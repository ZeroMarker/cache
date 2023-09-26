Class DHCEPRRBAC.BL.HISInfo.BLEpisodeInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##class(DHCEPRRBAC.BL.HISInfo.BLEpisodeInfo).GetPatientInfo("2041473")
ClassMethod GetPatientInfo(ARegNo As %String, AEpisodeID As %String = "")
{
	s ARegNo = ..AddZero(ARegNo)
	s patientID = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
	s name = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetName(patientID)
	s gender = $p(##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetGender(patientID),"^",3)
	s birthday = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetBirthday(patientID)
	s:(birthday '= "") birthday = $zd(birthday,3)
	
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	if (AEpisodeID '= "")
	{
		s medRecordNo = ##Class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID,"",AEpisodeID)
		s loc = $P($g(^PAADM(AEpisodeID)),"^",4)
		s locDesc = ""
		s:(loc '= "") locDesc = $P($g(^CTLOC(loc)),"^",2)
		s:($l(locDesc,"-") = 2) locDesc = $p(locDesc,"-",2)
	
		s admDate = $P($g(^PAADM(AEpisodeID)),"^",6)
		s:(admDate '= "") admDate = $zd(admDate,3)
		
		q ARegNo_"^"_name_"^"_gender_"^"_birthday_"^"_medRecordNo_"^"_locDesc_"^"_admDate
	}
	else
	{
		q ARegNo_"^"_name_"^"_gender_"^"_birthday
	}
}

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.HISInfo.BLEpisodeInfo","GetEpisodeList","00539881","","Y","Y","2776","1673","1")
Query GetEpisodeList(ARegNo As %String, AAdmNo As %String = "", ANeedCheckScan As %String = "N", ANeedCheckPrivilege As %String = "N", AUserID As %String = "", ACTLocID As %String = "", ASSGroupID As %String = "") As %Query(ROWSPEC = "IsCreated:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDateTime:%String,PAAdmWard:%String,PAAdmRoom:%String,PAAdmBed:%String,PAAdmLoc:%String,PADischgeDateTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String,IsApply:%String,IsApplyDesc:%String")
{
}

ClassMethod GetEpisodeListExecute(ByRef qHandle As %Binary, ARegNo As %String, AAdmNo As %String, ANeedCheckScan As %String = "N", ANeedCheckPrivilege As %String = "N", AUserID As %String = "", ACTLocID As %String = "", ASSGroupID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	
 	d DealParamter   //处理参数
 	
	if (AAdmNo '= "")
	{
		s count = 0
		for {
			s count = count + 1
			q:(count > 1)
			s PAAdm = AAdmNo
			d OutPutRow 		
		}
	}
 	elseif (ARegNo '= "")
 	{
	 	s ARegNo = ..AddZero(ARegNo)
		if (ANeedCheckPrivilege = "Y")
		{
			s retOut = ##Class(DHCEPRRBAC.BL.BLPrivilege).CheckPrivilegeOut(ARegNo,AUserID,ACTLocID,ASSGroupID)
			s retIn = ##Class(DHCEPRRBAC.BL.BLPrivilege).CheckPrivilegeIn(ARegNo,AUserID,ACTLocID,ASSGroupID)
			q:((retOut = "0") && (retIn = "0")) $$$OK
		}
	 	
	 	s PAPMI = $o(^PAPERi("PAPMI_PatNo",ARegNo,""))
	 	q:(PAPMI = "") $$$OK
	 	d OutPutPAMI 
	}
	
	Quit $$$OK
	
OutPutPAMI
	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(PAPMI,"ADM",AdmType))
	    q:(AdmType = "")
	    //急诊不显示
	    continue:(AdmType = "E")
	    
	    s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm))
		     q:(PAAdm = "")
		     d OutPutRow
		}
	}
	q
	
OutPutRow
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
	elseif (PAAdmType = "O")
	{
		s PAAdmType = "门诊"
	}
	elseif (PAAdmType = "E")
	{
		s PAAdmType = "急诊"
	}
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
	//婚姻
 	s tmpMarriage = ##Class(EPRservice.HISInterface.PatientInfoAssist).Marriage(PatientID)
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
 	s tmpOccupation=##Class(EPRservice.HISInterface.PatientInfoAssist).Occupation(PatientID,Hospital)
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
	
	s PAAdmDate = $ZD($P($g(^PAADM(PAAdm)),"^",6),3) //入院日期
	s PAAdmTime = $ZT($P($g(^PAADM(PAAdm)),"^",7),3)  //入院时间
	s PAAdmDateTime = PAAdmDate_","_PAAdmTime
	s:(PAAdmDateTime = ",") PAAdmDateTime = ""
	//病区
	s PAAdmWard = ""  
	s WardDr = $P($g(^PAADM(PAAdm)),"^",70)
	s:(WardDr '= "") PAAdmWard = $P($g(^PAWARD(WardDr)),"^",2)
	
	s PAAdmRoom = "" //病房
	s RoomDr = $P($g(^PAADM(PAAdm)),"^",69)
	s:(RoomDr '= "") PAAdmRoom = $p($g(^PAROOM(RoomDr)),"^",1)
	
	s PAAdmBed = ""  //病床
	s BedId = $P($g(^PAADM(PAAdm)),"^",73)   
	s:(BedId '= "") PAAdmBed = $P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	//当前科室
	s PAAdmLoc = ""    
	s Loc = $P($g(^PAADM(PAAdm)),"^",4)  
	s PAAdmLoc = $P($g(^CTLOC(Loc)),"^",2)
	//出院日期时间
	s PADischgeDate=$P($g(^PAADM(PAAdm)),"^",17) 
	s PADischgeTime=$P($g(^PAADM(PAAdm)),"^",18)
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
		if ($f(PayMode,pmDesc) = 0)
		{ 
			s PayMode = PayMode_" "_pmDesc
		}
	}
	
	if (ANeedCheckScan = "Y")
	{
		s ret = ##Class(DHCEPRFS.BI.BIToRBAC).HasScanned(PAAdm)
		q:(ret = "0")
	}
	
	//是否提交申请
	s IsApply = "0"
	s IsApplyDesc = "否"
	s fsAuthorizationGID = ""
	for {
		s fsAuthorizationGID = $o(^DHCEPRRBAC.INST.FSAuthI("IdxEpisode"," "_PAAdm,fsAuthorizationGID))
		q:(fsAuthorizationGID = "")
		s objFSAG = ##class(DHCEPRRBAC.INST.FSAuthorizationGroup).%OpenId(fsAuthorizationGID)
		s appointStatus = objFSAG.AppointStatus
		if (appointStatus = "O")
		{
			s IsApply = "1"
			s IsApplyDesc = "是"
			q	
		}
	}

 	s data = $lb(IsCreated,PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDateTime,PAAdmWard,PAAdmRoom,PAAdmBed,PAAdmLoc,PADischgeDateTime,PAAdmDoc,PayMode,PAAdm,PatientID,IsApply,IsApplyDesc)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
	
DealParamter    
    s:(ARegNo = $c(0)) ARegNo = ""
    s:(AAdmNo = $c(0)) AAdmNo = ""
    s:(ANeedCheckScan = $c(0)) ANeedCheckScan = ""
    s:(ANeedCheckPrivilege = $c(0)) ANeedCheckPrivilege = ""
	
    q
}

ClassMethod GetEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
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

}
