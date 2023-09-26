Class DHCEPRFS.BL.BLMREpisodeView Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 通过身份证号查询归档就诊记录
Query GetMREpisodeListByIDCard(AIDCard As %String) As %SQLQuery
{
	SELECT A.ID as MREpisodeID,A.EpisodeID,A.MedRecordNo, 
	H.RegNo,H.Name As PatName,to_char(A.AdmDate,'yyyy-MM-dd') AS AdmDate,to_char(A.DisDate,'yyyy-MM-dd') As DischDate,
	A.AdmTypeID As AdmType,A.AdmType As AdmTypeDesc,A.DisLocID As DischLocID,
	A.DisLoc As DischLoc,A.MainDoctor
	 FROM dhceprfs_inst.mrepisode a 
	inner join dhceprfs_inst.MRPatient H ON A.MRPatientID=H.ID
	WHERE MRPatientID IN 
	(SELECT ID FROM dhceprfs_inst.mrpatient b WHERE b.IDCard =:AIDCard)
}

/// Desc: 归档就诊信息查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisodeView","GetMREpisodeInfoList","612")
Query GetMREpisodeInfoList(AEpisodeID As %String) As %Query(ROWSPEC = "MREpisodeID:%String,EpisodeID:%String,MedRecordNo:%String,RegNo:%String,PatName:%String,AdmDate:%String,DischDate:%String,AdmType:%String,AdmTypeDesc:%String,DischLocID:%String,DischLoc:%String,MainDoctor:%String")
{
}

ClassMethod GetMREpisodeInfoListExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID = "") $$$OK
	s patientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(AEpisodeID)
	q:(patientID = "") $$$OK
	s mrPatientID = ##class(DHCEPRFS.BL.BLMRPatient).GetMRPatientID(patientID)
	q:(mrPatientID = "") $$$OK
	
	s mrEpisodeID = ""
	f {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_mrPatientID,mrEpisodeID))
		q:(mrEpisodeID = "")
		s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
		s regNo = objMRPatient.RegNo
		s medRecordNo = objMRPatient.MedRecordNo
		s patName = objMRPatient.Name
		d objMRPatient.%Close()
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s episodeID = objMREpisode.EpisodeID
		s admDate = objMREpisode.AdmDate
		s:(admDate '= "") admDate = $zd(admDate,3)
		s disDate = objMREpisode.DisDate
		s:(disDate '= "") disDate = $zd(disDate,3)
		s admTypeID = objMREpisode.AdmTypeID
		s admType = objMREpisode.AdmType
		if ((admTypeID = "")||(admType = ""))
		{
			s admTypeID = $p($g(^PAADM(episodeID)),"^",2)
			s admType = $s(admTypeID="I":"住院",admTypeID="O":"门诊",admTypeID="E":"急诊",1:"")
		}
		s disLocID = objMREpisode.DisLocID
		s disLoc = objMREpisode.DisLoc
		s mainDoctor = objMREpisode.MainDoctor
		d objMREpisode.%Close()
		s ^CacheTemp(repid,ind) = $lb(mrEpisodeID,episodeID,medRecordNo,regNo,patName,admDate,disDate,admTypeID,admType,disLocID,disLoc,mainDoctor)
		s ind = ind + 1
	}
	q $$$OK
}

ClassMethod GetMREpisodeInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMREpisodeInfoListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMREpisodeInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMREpisodeInfoListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 就诊信息查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisodeView","GetEpisodeInfoList","^^500316^^")
Query GetEpisodeInfoList(AParam As %String) As %Query(ROWSPEC = "IsCreated:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetEpisodeInfoListExecute(ByRef qHandle As %Binary, AParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s APatientID = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s AMedRecordNo = $p(AParam,"^",3)
	s AAdmNo = $p(AParam,"^",4)
	s ARegNo = $p(AParam,"^",5)
	if ($l(AParam,"^") > 5)
	{
		s AStartDate = $p(AParam,"^",6)
		s:(AStartDate '= "") AStartDate = $zdh(AStartDate,3)
		s AEndDate = $p(AParam,"^",7)
		s:(AEndDate '= "") AEndDate = $zdh(AEndDate,3)
		s ALocID = $p(AParam,"^",8)
	}
	else
	{
		s AStartDate = ""
		s AEndDate = ""
		s ALocID = ""
	}
	
	d DealParamter   //处理参数
	
	if (AAdmNo '= "")
	{
		s PAAdm = AAdmNo
		d OutPutRow
	}
	elseif (APatientID '= "")
	{
		s PAPMI = APatientID
		d OutPutPAMI
	}
	elseif (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PAPMI = "") $$$OK
		d OutPutPAMI
	}
	elseif (AMedRecordNo '= "")
	{
		s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
		if (hospitalFlag = "FCYY")
		{
			//b "s"
			s RegNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNoByMedRecordNo(AMedRecordNo)
			s PAPMI = $o(^PAPERi("PAPMI_PatNo",RegNo,""))
			q:(PAPMI = "") $$$OK
			d OutPutPAMI
		}
		else
		{
			s PAPMI = $o(^PAPERi("Medicare1",AMedRecordNo,0))
			q:(PAPMI = "") $$$OK
			d OutPutPAMI
		}
	}
	elseif (APatientName '= "")
	{
		s APatientName = $zcvt(APatientName,"U")
		s PAPMI = ""
		for {
			s PAPMI = $O(^PAPERi("PAPER_PatName",APatientName,PAPMI))
			q:(PAPMI = "")
			d OutPutPAMI
		}
	}
	elseif ((AStartDate '= "")&&(AEndDate '=""))
	{
		if (ALocID '= "")
		{
			s date = AStartDate - 1
			f {
				s date = $o(^PAADMi("DisDateDep",ALocID,date))
				q:(date = "")||(date > AEndDate)
				s PAAdm = ""
				f {
					s PAAdm = $o(^PAADMi("DisDateDep",ALocID,date,PAAdm))
					q:(PAAdm = "")
					d OutPutRow
				}
			}
		}
		else
		{
			s date = AStartDate - 1
			f {
				s date = $o(^PAADMi("DischDate",date))
				q:(date = "")||(date > AEndDate)
				s PAAdm = ""
				f {
					s PAAdm = $o(^PAADMi("DischDate",date,PAAdm))
					q:(PAAdm = "")
					d OutPutRow
				}
			}
		}
	}
	
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
		s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
		q:(AdmType = "")
		s PAAdm = ""
		for {
			s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
			q:(PAAdm = "")
			d OutPutRow
		}
	}
	q
	
OutPutRow
	//检查就诊是否已取消，取消的就诊不显示
	s IsCancel = ..CheckEpisodeCancel(PAAdm)
	q:(IsCancel = "1")
	
	s IsCreated = "N"
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(PAAdm,"DHC")
	if (mrEpisodeID '= "")
	{
		s IsCreated = "Y"
	}
	
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)
	//就诊类型
	if (PAAdmType = "I")
	{
		s PAAdmType = "住院"
	}
	elseif PAAdmType = "O"
	{
		s PAAdmType = "门诊"
	}
	elseif PAAdmType = "E"
	{
		s PAAdmType = "急诊"
	}
	//病人姓名
	if (PatientID '= "")
	{
		s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)
		//身份证号
		s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9)
		//登记号
		s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		
		//出生日期,年龄
		s PAPMIDOB = "" ,PAPMIAge = ""
		s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
		if (DobDate '= "")
		{
			s PAPMIDOB = $ZD(DobDate,3)
			s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
		}
		//性别
		s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)
		s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
	}
	//婚姻
	s tmpMarriage=##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
	if (tmpMarriage '= "")
	{
		s Marriage= $p($g(tmpMarriage),"^",3)
	}
	//出生地
	s tmpNative=##Class(EPRservice.HISInterface.PatientInfoAssist).Native(PatientID,Hospital)
	if (tmpNative '= "")
	{
		//出生地城市
		s CityBirth = $p($g(tmpNative),"!",2)
		s CityBirth = $p($g(CityBirth),"^",2)
		
		//出生地省份
		s ProvinceBirth = $p($g(tmpNative),"!",1)
		s ProvinceBirth = $p($g(ProvinceBirth),"^",2)
	}
	//职业
	s tmpOccupation = ##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
	if (tmpOccupation '= "")
	{
		s Occupation = $p($g(tmpOccupation),"^",2)
	}
	//民族
	s tmpNation=##Class(EPRservice.HISInterface.PatientInfoAssist).Nation(PatientID,Hospital)
	if (tmpNation '= "")
	{
		s Nation = $p($g(tmpNation),"^",2)
	}
	//手机
	s MobilePhone=##Class(EPRservice.HISInterface.PatientInfoAssist).MobilePhone(PatientID,Hospital)
	
	s PAAdmDate = $p($g(^PAADM(PAAdm)),"^",6)
	s PAAdmDate = $ZD(PAAdmDate,3) //入院日期
	s PAAdmTime = $P($g(^PAADM(PAAdm)),"^",7)
	s:(PAAdmTime'="") PAAdmTime = $ZT(PAAdmTime,3)  //入院时间
	
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	s:(PAAdmDateTime = ",") PAAdmDateTime = ""
	//病区
	s PAAdmWard = ""
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	s:(WardDr '= "") PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
	s:($l(PAAdmWard,"-") > 1) PAAdmWard = $p(PAAdmWard,"-",2)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	s:(RoomDr '= "") PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)
	s:(BedId '= "") PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)
	q:((ALocID '= "")&&(Loc '= ALocID))
	s:(Loc '="") PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
	s:($l(PAAdmLoc,"-") > 1) PAAdmLoc = $p(PAAdmLoc,"-",2)
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17)
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	//若存在开始和结束日期，则需判断出院日期是否在范围内
	if (AStartDate '= "")
	{
		q:(PADischgeDate < AStartDate)
	}
	if (AEndDate '= "")
	{
		q:(PADischgeDate > AEndDate)
	}
	s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime,3)
	//在院状态
	s PAStatusType = "A"
	s:(PADischgeDate = "") PADischgeDateTime = ""
	s:(PADischgeDateTime '= "") PAStatusType = "D"
	
	if (PAStatusType = "A")
	{
		s PAStatusType = "在院"
	}
	elseif (PAStatusType = "D")
	{
		s PAStatusType = "出院"
	}
	//医生 
	s PAAdmDoc = ""
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9)
	s:(Doctor '= "") PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	//付费方式
	s PayMode = ""
	s prtRowID = ""
	for {
		s prtRowID = $o(^DHCSFPRINTDETAIL(0,"adm",PAAdm,prtRowID))
		q:(prtRowID = "")
		s pmRowID = $p($g(^DHCSFPRINTDETAIL(prtRowID)),"^",9)
		s pmDesc = $p($g(^CT("CTPM",pmRowID)),"^",2)
		s:($f(PayMode,pmDesc) = 0) PayMode = PayMode_pmDesc_" "
	}
	s data = $lb(IsCreated,PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter
	s:(APatientID = $c(0)) APatientID = ""
	s:(ARegNo = $c(0)) ARegNo = ""
	s:(APatientName = $c(0)) APatientName = ""
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	s:(AAdmNo = $c(0)) AAdmNo = ""
	q
}

ClassMethod GetEpisodeInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeInfoListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If (ind = "") 
	{				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      
	{				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeInfoListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 扫描就诊列表
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisodeView","GetScanEpisodeList","A","2019-11-01","2019-11-01","301")
Query GetScanEpisodeList(AAdmStatus As %String, AStartDate As %String, AEndDate As %String, ALocID As %String = "", ARegNo As %String = "", AMedRecordNo As %String = "", APatName As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PatName:%String,PatDOB:%String,PatSex:%String,AdmDate:%String,AdmTime:%String,DisDate:%String,DisTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,PAAdmDocCodeDR:%String,PAADMReason:%String")
{
}

ClassMethod GetScanEpisodeListExecute(ByRef qHandle As %Binary, AAdmStatus As %String, AStartDate As %String, AEndDate As %String, ALocID As %String = "", ARegNo As %String = "", AMedRecordNo As %String = "", APatName As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	Set langid=20  //登录语言
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set EnableTranslation=0  //翻译功能启用标识
	If (##class(%Dictionary.CompiledMethod).%ExistsId("User.Abstract||GetTranByDesc"))
	{
		Set EnableTranslation=1
	}
	
	s:(AStartDate=$c(0)) AStartDate=""
	s:(AEndDate=$c(0)) AEndDate=""
	q:(AAdmStatus="")||(ALocID="") $$$OK
	q:(AAdmStatus="D")&&((AStartDate="")||(AEndDate="")) $$$OK
	s startDate="",endDate=""
	s:(AStartDate'="") startDate=##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AStartDate)
	s:(AEndDate'="") endDate=##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AEndDate)
	
	s locIDS=ALocID
	s locDepDR=##class(DHCEPRFS.BL.HISInfo.BLHISInfo).CheckCTLocType(ALocID)
	if (locDepDR="0")
	{
		s linkLocIDS=##class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetLinkLocID(ALocID)
		s locIDS=locIDS_"^"_linkLocIDS
	}
	
	if (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		s papmiDR = ""
		s papmiDR = $o(^PAPERi("PAPMI_PatNo",ARegNo,papmiDR))
		q:(papmiDR = "") $$$OK
		s episodeID = ""
		f {
			s episodeID = $o(^PAPERdr(papmiDR,"ADM","I",episodeID))
			q:(episodeID = "")
			d GetScanEpisodeInfo
		}
	}
	elseif (AMedRecordNo '= "")
	{
		s papmiDR = ""
		s papmiDR = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(AMedRecordNo)
		q:(papmiDR = "") $$$OK
		s episodeID = ""
		f {
			s episodeID = $o(^PAPERdr(papmiDR,"ADM","I",episodeID))
			q:(episodeID = "")
			d GetScanEpisodeInfo
		}
	}
	elseif (APatName '= "")
	{
		s APatName = $zcvt(APatName,"U")
		s papmiDR = ""
		f {
			s papmiDR = $o(^PAPERi("PAPER_PatName",APatName,papmiDR))
			q:(papmiDR = "")
			s episodeID = ""
			f {
				s episodeID = $o(^PAPERdr(papmiDR,"ADM","I",episodeID))
				q:(episodeID = "")
				d GetScanEpisodeInfo
			}
		}
	}
	else
	{
		f i=1:1:$l(locIDS,"^")
		{
			s xLocID=$p(locIDS,"^",i)
			if (AAdmStatus="A")
			{
				s date=""
				f {
					s date=$o(^PAADMi("CurrLoc",xLocID,date))
					q:(date="")
					s time=""
					f {
						s time=$o(^PAADMi("CurrLoc",xLocID,date,time))
						q:(time="")
						s episodeID=""
						f {
							s episodeID=$o(^PAADMi("CurrLoc",xLocID,date,time,episodeID))
							q:(episodeID="")
							d GetScanEpisodeInfo
						}
					}
				}
			}
			else
			{
				//s:(AStartDate'="") startDate=$zdh(AStartDate,3)
				//s:(AEndDate'="") endDate=$zdh(AEndDate,3)
				//最终结算日期
				s date=startDate-1
				f {
					s date=$o(^PAADMi("DisDateDep",xLocID,date))
					q:(date="")||(date>endDate)
					s episodeID=""
					f {
						s episodeID=$o(^PAADMi("DisDateDep",xLocID,date,episodeID))
						q:(episodeID="")
						d GetScanEpisodeInfo
					}
				}
				//医疗结算日期
				/*s date=startDate-1
				f {
					s date=$o(^PAADMi("EstDischNew",date))
					q:(date="")||(date>endDate)
					s episodeID=""
					f {
						s episodeID=$o(^PAADMi("EstDischNew",date,episodeID))
						q:(episodeID="")
						d GetScanEpisodeInfo
					}
				}*/
			}
		}
	}

	Quit $$$OK

GetScanEpisodeInfo
	s admType=$p($g(^PAADM(episodeID)),"^",2)
	q:(admType'="I")
	s admStatus=$p($g(^PAADM(episodeID)),"^",20)
	q:(admStatus="C")
	q:(admStatus'=AAdmStatus)
	
	s admLocID=$p($g(^PAADM(episodeID)),"^",4)
	s disWardDR = $p($g(^PAADM(episodeID)),"^",70)
	s wardLocDR = $p($g(^PAWARD(disWardDR)),"^",5)
	q:((admLocID '= ALocID)&&(wardLocDR '= ALocID))
	s admLocDesc="",admWardDesc=""
	if (admLocID '= "")
	{
		s admLocDesc = $p($g(^CTLOC(admLocID)),"^",2)
		s:(admLocDesc["-") admLocDesc =$p(admLocDesc,"-",2)
	}
	if (disWardDR '= "")
	{
		s admWardDesc =$p($g(^PAWARD(disWardDR)),"^",2)
		s:(admWardDesc["-") admWardDesc =$p(admWardDesc,"-",2)
	}
	
	s patientID = $p($g(^PAADM(episodeID)),"^",1)
	s medRecordNo=##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",episodeID)
	s patName=$p($g(^PAPER(patientID,"ALL")),"^",1)
	s regNo=$p($g(^PAPER(patientID,"PAT",1)),"^",1)
	s patDob = $p($g(^PAPER(patientID,"ALL")),"^",6)
	s:(patDob '= "") patDob = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(patDob)
	s patSex=""
	s patSexDR = $p($g(^PAPER(patientID,"ALL")),"^",7)
	s:(patSexDR'="") patSex = $p($g(^CT("SEX",patSexDR)),"^",2)
	
	s admDate="",admTime=""
	s paAdmDate = $p($g(^PAADM(episodeID)),"^",6)
	s paAdmTime = $p($g(^PAADM(episodeID)),"^",7)
	s:(paAdmDate'="") admDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(paAdmDate)
	s:(paAdmTime'="") admTime = $zt(paAdmTime,1)
	s disDate="",disTime=""
	s paDisDate = $p($g(^PAADM(episodeID)),"^",59)
	s paDisTime = $p($g(^PAADM(episodeID)),"^",60)
	if (AAdmStatus="D")&&(paDisDate'="")
	{
		q:(paDisDate<startDate)||(paDisDate>endDate)
	}
	s:(paDisDate'="") disDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(paDisDate)
	s:(paDisTime'="") disTime = $zt(paDisTime,1)
	
	s paAdmDocCodeDR=""
	s paAdmDocCode=$p($g(^PAADM(episodeID)),"^",9)
	if (paAdmDocCode '= "")
	{
		s paAdmDocCodeDR = $p($g(^CTPCP(paAdmDocCode,1)),"^",2)
	}
	s paAdmReason=""
	s paAdmReasonDR = $p($g(^PAADM(episodeID,1)),"^",7)
	if (paAdmReasonDR '= "")
	{
		s paAdmReason = $p($g(^PAC("ADMREA",paAdmReasonDR)),"^",2)
	}
	
	if (EnableTranslation = 1)
	{
		s:(patSex'="") patSex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",patSex,langid)
		s:(admLocDesc'="") admLocDesc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",admLocDesc,langid)
		s:(admWardDesc'="") admWardDesc = ##class(User.PACWard).GetTranByDesc("WARDDesc",admWardDesc,langid)
		s:(paAdmDocCodeDR'="") paAdmDocCodeDR = ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",paAdmDocCodeDR,langid)
		s:(paAdmReason'="") paAdmReason = ##class(User.PACAdmReason).GetTranByDesc("READesc",paAdmReason,langid)
	}
	
	s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,patName,patDob,patSex,admDate,admTime,disDate,disTime,admLocDesc,admWardDesc,paAdmDocCodeDR,paAdmReason)
	s ind = ind + 1
	q
}

ClassMethod GetScanEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanEpisodeListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetScanEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanEpisodeListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AddZero(ARegNo As %String) As %String
{
	s regNo = ""
	s regNo = $o(^PAPERi("PAPMI_PatNo",regNo))
	s regNo = $tr(regNo, " ")
	s regNo = $tr(regNo,$c(10),"")
	s regNo = $tr(regNo,$c(13),"")
	s length = $l(regNo)
	q:(length = $l(ARegNo)) ARegNo
	
	for index=1:1:(length - $l(ARegNo)) 
	{
		s ARegNo = "0"_ARegNo
	}
	q ARegNo
}

ClassMethod CheckEpisodeCancel(AEpisodeID As %String) As %String
{
	s ret = "0"
	s flag = $p($g(^PAADM(AEpisodeID)),"^",20)
	s:(flag = "c") ret = "1"
	s:(flag = "C") ret = "1"
	q ret
}

/// Desc: 护士提交信息查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisodeView","GetNurSubEpisodeInfoList","^^^^^2022-01-01^2022-01-30^6")
Query GetNurSubEpisodeInfoList(AParam As %String) As %Query(ROWSPEC = "PatientID:%String,PAPMINO:%String,PAPMIName:%String,PAPMIAge:%String,PAPMISex:%String,PAAdm:%String,PAAdmType:%String,PAAdmLoc:%String,PAAdmDateTime:%String,PADischgeDateTime:%String,PAAdmWard:%String,PAAdmBed:%String,PAAdmDoc:%String,DeathFlag:%String,NurSubmit:%String,DocSubmit:%String,ScanFlag:%String,SubmitTime:%String")
{
}

ClassMethod GetNurSubEpisodeInfoListExecute(ByRef qHandle As %Binary, AParam As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s APatientID = $p(AParam,"^",1)
	s APatientName = $p(AParam,"^",2)
	s AMedRecordNo = $p(AParam,"^",3)
	s AAdmNo = $p(AParam,"^",4)
	s ARegNo = $p(AParam,"^",5)
	if ($l(AParam,"^") > 5)
	{
		s AStartDate = $p(AParam,"^",6)
		s:(AStartDate '= "") AStartDate = $zdh(AStartDate,3)
		s AEndDate = $p(AParam,"^",7)
		s:(AEndDate '= "") AEndDate = $zdh(AEndDate,3)
		s ALocID = $p(AParam,"^",8)
		s AWardID = $P(AParam,"^",9)
	}
	else
	{
		s AStartDate = ""
		s AEndDate = ""
		s ALocID = ""
	}
	
	d DealParamter   //处理参数
	
	if (AAdmNo '= "")
	{
		s PAAdm = AAdmNo
		d OutPutRow
	}
	elseif (APatientID '= "")
	{
		s PAPMI = APatientID
		d OutPutPAMI
	}
	elseif (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
		q:(PAPMI = "") $$$OK
		d OutPutPAMI
	}
	elseif (AMedRecordNo '= "")
	{
		s PAPMIS = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(AMedRecordNo)
		for index=1:1:$l(PAPMIS,"^")
		{
			s PAPMI = $p(PAPMIS,"^",index)
			continue:(PAPMI = "")
			d OutPutPAMI
		}
	}
	elseif (APatientName '= "")
	{
		s APatientName = $zcvt(APatientName,"U")
		s PAPMI = ""
		for {
			s PAPMI = $o(^PAPERi("PAPER_PatName",APatientName,PAPMI))
			q:(PAPMI = "")
			d OutPutPAMI
		}
	}
	elseif ((AStartDate '= "")&&(AEndDate '= ""))
	{
		s date = AStartDate - 1
		f {
			s date = $o(^PAADMi("DischDate",date))
			q:(date = "")||(date > AEndDate)
			s PAAdm = ""
			f {
				s PAAdm = $o(^PAADMi("DischDate",date,PAAdm))
				q:(PAAdm = "")
				d OutPutRow
			}
		}
	}
	
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
		s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
		q:(AdmType = "")
		
		continue:(AdmType'="I")
		s PAAdm = ""
		for {
			s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
			
			q:(PAAdm = "")
			d OutPutRow
		}
		q
	}
	q
	
OutPutRow
	//检查就诊是否已取消，取消的就诊不显示
	s IsCancel = ..CheckEpisodeCancel(PAAdm)
	q:(IsCancel = "1")
	
	s PAAdmType = $p($g(^PAADM(PAAdm)),"^",2)
	q:(PAAdmType'="I")
	s PAAdmType = "住院"
	
	//当前科室
	s PAAdmLoc = ""
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)
	//q:((ALocID'="")&&(Loc'=ALocID))
	s:(Loc '="") PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
	s:($l(PAAdmLoc,"-") > 1) PAAdmLoc = $p(PAAdmLoc,"-",2)
	
	//病区
	s disWardDR = $p($g(^PAADM(PAAdm)),"^",70)
	q:((AWardID'="")&&(disWardDR'=AWardID))
	s:(disWardDR '= "") PAAdmWard = $P($g(^PAWARD(disWardDR)),"^",2)
	s:($l(PAAdmWard,"-") > 1) PAAdmWard = $p(PAAdmWard,"-",2)
	
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17)
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
	s tmpDate = PADischgeDate
	
	//若存在开始和结束日期，则需判断出院日期是否在范围内
	if (AStartDate '= "")
	{
		q:(PADischgeDate < AStartDate)
	}
	if (AEndDate '= "")
	{
		q:(PADischgeDate > AEndDate)
	}
	//q:(PADischgeDate="")
	s PADischgeDateTime = $zd(PADischgeDate,3)_","_$zt(PADischgeTime)
	
	//护士提交。医生提交。
	s NurSubmit = "N"
	s DocSubmit = "N"
	s admMrStatusID = $O(^DHCEPRFS.INST.AdmMRStatusI("IdxEpisodeID"," DHC"," "_PAAdm,""))
	if (admMrStatusID'="")
	{
		s admMRStatusObj = ##class(DHCEPRFS.INST.AdmMRStatus).%OpenId(admMrStatusID)
		if (admMRStatusObj'="")
		{
			if (admMRStatusObj.FlagFinalAccount="1")
			{
				s NurSubmit = "Y"
			}
			elseif (admMRStatusObj.FlagFinalAccountDate'="")
			{
				s NurSubmit = "B"
			}
			if (admMRStatusObj.FlagMRCompletion="1")
			{
				s DocSubmit = "Y"
			}
			elseif (admMRStatusObj.FlagMRCompletionDate'="")
			{
				s DocSubmit = "B"
			}
		}
	}
	
	//是否扫描
	s ScanFlag = "否"
	s ScanCount = $P(##Class(DHCEPRFS.BI.BIToEMR).GetScanPageCount(PAAdm),"|",1)
	s:(ScanCount'="0") ScanCount = "是"
	
	//是否死亡
	s DeathFlag = "0"
	
	s PatientID = $p($g(^PAADM(PAAdm)),"^",1)
	if (PatientID '= "")
	{
		//病人姓名
		s PAPMIName = $p($g(^PAPER(PatientID,"ALL")),"^",1)
		//身份证号
		s IdCardNo = $P($G(^PAPER(PatientID,"ALL")),"^",9)
		//登记号
		s PAPMINO = $p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		
		//出生日期,年龄
		s PAPMIDOB = "" ,PAPMIAge = ""
		s DobDate = $p($g(^PAPER(PatientID,"ALL")),"^",6)
		if (DobDate '= "")
		{
			s PAPMIDOB = $ZD(DobDate,3)
			s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
		}
		//性别
		s Sex = $P($g(^PAPER(PatientID,"ALL")),"^",7)
		s PAPMISex = $P($g(^CT("SEX",Sex)),"^",2)
		
		//是否死亡
		s DeathDate = ""
		s DeathDate = $p($g(^PAPER(PatientID,"ALL")),"^",13)
		s:(DeathDate '= "") DeathFlag = "1"
	}
	
	s PAAdmDate = $p($g(^PAADM(PAAdm)),"^",6)
	s PAAdmDate = $ZD(PAAdmDate,3)  //入院日期
	s PAAdmTime = $P($g(^PAADM(PAAdm)),"^",7)
	s:(PAAdmTime'="") PAAdmTime = $ZT(PAAdmTime,3)  //入院时间
	
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	s:(PAAdmDateTime = ",") PAAdmDateTime = ""
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)
	s:(BedId '= "") PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	
	//时效性
	s SubmitTime = ""
	s toDate = ($P($H,",",1)-tmpDate)-##class(web.DHCBL.CT.BDPHoliday).GetHolidayDateNum($zd(tmpDate,3),$zd($P($H,",",1),3),"")
	if (DeathFlag="0")
	{
		if (toDate>3)
		{
			s SubmitTime = "超期"_toDate_"天"
		}
		else
		{
			s SubmitTime = "出院"_toDate_"天"
		}
	}
	else
	{
		if (toDate>5)
		{
			s SubmitTime = "超期"_toDate_"天"
		}
		else
		{
			s SubmitTime = "出院"_toDate_"天"
		}
	}
	
	//医生 
	s PAAdmDoc = ""
	s Doctor = $P($g(^PAADM(PAAdm)),"^",9)
	s:(Doctor '= "") PAAdmDoc = $P($g(^CTPCP(Doctor,1)),"^",2)
	
	s data = $lb(PatientID,PAPMINO,PAPMIName,PAPMIAge,PAPMISex,PAAdm,PAAdmType,PAAdmLoc,PAAdmDateTime,PADischgeDateTime,PAAdmWard,PAAdmBed,PAAdmDoc,DeathFlag,NurSubmit,DocSubmit,ScanFlag,SubmitTime)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter
	s:(APatientID = $c(0)) APatientID = ""
	s:(ARegNo = $c(0)) ARegNo = ""
	s:(APatientName = $c(0)) APatientName = ""
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	s:(AAdmNo = $c(0)) AAdmNo = ""
	if (ALocID'="")
	{
		s ALocID = $P($P(^CTLOC(ALocID),"^",1),".",1)_"."
		//w ALocID,!
	}
	q
}

ClassMethod GetNurSubEpisodeInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurSubEpisodeInfoListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If (ind = "") 
	{				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      
	{				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetNurSubEpisodeInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurSubEpisodeInfoListExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Create: 2022-10-31 yangshun
/// Desc: 门诊扫描就诊列表
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMREpisodeView","GetScanEpisodeList4Out","2019-11-01","2019-11-01","301")
Query GetScanEpisodeList4Out(AStartDate As %String, AEndDate As %String, ALocID As %String = "", ARegNo As %String = "", AMedRecordNo As %String = "", APatName As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PatName:%String,PatDOB:%String,PatSex:%String,AdmDate:%String,AdmTime:%String,AdmLocDesc:%String,PAAdmDocCodeDR:%String,PAADMReason:%String")
{
}

ClassMethod GetScanEpisodeList4OutExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ALocID As %String = "", ARegNo As %String = "", AMedRecordNo As %String = "", APatName As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	Set langid=20  //登录语言
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set EnableTranslation=0  //翻译功能启用标识
	If (##class(%Dictionary.CompiledMethod).%ExistsId("User.Abstract||GetTranByDesc"))
	{
		Set EnableTranslation=1
	}
	
	s:(AStartDate=$c(0)) AStartDate=""
	s:(AEndDate=$c(0)) AEndDate=""
	q:(ALocID="") $$$OK
	q:((AStartDate="")||(AEndDate="")) $$$OK
	s startDate="",endDate=""
	s:(AStartDate'="") startDate=##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AStartDate)
	s:(AEndDate'="") endDate=##class(DHCEPRFS.Util.StringHelper).FormatLogicalDate(AEndDate)
	
	if (ARegNo '= "")
	{
		s ARegNo = ..AddZero(ARegNo)
		s papmiDR = ""
		s papmiDR = $o(^PAPERi("PAPMI_PatNo",ARegNo,papmiDR))
		q:(papmiDR = "") $$$OK
		s episodeID = ""
		f {
			s episodeID = $o(^PAPERdr(papmiDR,"ADM","O",episodeID))
			q:(episodeID = "")
			d GetScanEpisodeInfo
		}
	}
	elseif (AMedRecordNo '= "")
	{
		s papmiDR = ""
		s papmiDR = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(AMedRecordNo)
		q:(papmiDR = "") $$$OK
		s episodeID = ""
		f {
			s episodeID = $o(^PAPERdr(papmiDR,"ADM","O",episodeID))
			q:(episodeID = "")
			d GetScanEpisodeInfo
		}
	}
	elseif (APatName '= "")
	{
		s APatName = $zcvt(APatName,"U")
		s papmiDR = ""
		f {
			s papmiDR = $o(^PAPERi("PAPER_PatName",APatName,papmiDR))
			q:(papmiDR = "")
			s episodeID = ""
			f {
				s episodeID = $o(^PAPERdr(papmiDR,"ADM","O",episodeID))
				q:(episodeID = "")
				d GetScanEpisodeInfo
			}
		}
	}
	else
	{
		s date=startDate-1
		f {
			s date=$o(^PAADMi("DepDateTime",ALocID,date))
			q:(date="")||(date>endDate)
			s time=""
			f {
				s time=$o(^PAADMi("DepDateTime",ALocID,date,time))
				q:(time="")
				s episodeID=""
				f {
					s episodeID=$o(^PAADMi("DepDateTime",ALocID,date,time,episodeID))
					q:(episodeID="")
					d GetScanEpisodeInfo
				}
			}
		}
	}

	Quit $$$OK

GetScanEpisodeInfo
	s admType=$p($g(^PAADM(episodeID)),"^",2)
	q:(admType'="O")
	s admStatus=$p($g(^PAADM(episodeID)),"^",20)
	q:(admStatus="C")
	
	s admLocID=$p($g(^PAADM(episodeID)),"^",4)
	q:(admLocID '= ALocID)
	s admLocDesc=""
	if (admLocID '= "")
	{
		s admLocDesc = $p($g(^CTLOC(admLocID)),"^",2)
		s:(admLocDesc["-") admLocDesc = $p(admLocDesc,"-",2)
	}
	
	s patientID = $p($g(^PAADM(episodeID)),"^",1)
	s medRecordNo=##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",episodeID)
	s patName=$p($g(^PAPER(patientID,"ALL")),"^",1)
	s regNo=$p($g(^PAPER(patientID,"PAT",1)),"^",1)
	s patDob = $p($g(^PAPER(patientID,"ALL")),"^",6)
	s:(patDob '= "") patDob = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(patDob)
	s patSex=""
	s patSexDR = $p($g(^PAPER(patientID,"ALL")),"^",7)
	s:(patSexDR'="") patSex = $p($g(^CT("SEX",patSexDR)),"^",2)
	
	s admDate="",admTime=""
	s paAdmDate = $p($g(^PAADM(episodeID)),"^",6)
	s:(paAdmDate'="") admDate = ##class(DHCEPRFS.Util.StringHelper).FormatDisplayDate(paAdmDate)
	s paAdmTime = $p($g(^PAADM(episodeID)),"^",7)
	s:(paAdmTime'="") admTime = $zt(paAdmTime,1)
	
	s paAdmDocCodeDR=""
	s paAdmDocCode=$p($g(^PAADM(episodeID)),"^",9)
	if (paAdmDocCode '= "")
	{
		s paAdmDocCodeDR = $p($g(^CTPCP(paAdmDocCode,1)),"^",2)
	}
	s paAdmReason=""
	s paAdmReasonDR = $p($g(^PAADM(episodeID,1)),"^",7)
	if (paAdmReasonDR '= "")
	{
		s paAdmReason = $p($g(^PAC("ADMREA",paAdmReasonDR)),"^",2)
	}
	
	if (EnableTranslation = 1)
	{
		s:(patSex'="") patSex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",patSex,langid)
		s:(admLocDesc'="") admLocDesc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",admLocDesc,langid)
		s:(paAdmDocCodeDR'="") paAdmDocCodeDR = ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",paAdmDocCodeDR,langid)
		s:(paAdmReason'="") paAdmReason = ##class(User.PACAdmReason).GetTranByDesc("READesc",paAdmReason,langid)
	}
	
	s ^CacheTemp(repid,ind) = $lb(episodeID,patientID,medRecordNo,regNo,patName,patDob,patSex,admDate,admTime,admLocDesc,paAdmDocCodeDR,paAdmReason)
	s ind = ind + 1
	q
}

ClassMethod GetScanEpisodeList4OutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScanEpisodeList4OutExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetScanEpisodeList4OutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScanEpisodeList4OutExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
