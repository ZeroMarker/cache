/// 名称:DHCMed.NINFService.BC.CasesXSrv
/// 描述: 疑似病例筛查日志
/// 编写者：zhufei
/// 编写日期: 2013-12-06
Class DHCMed.NINFService.BC.CasesXSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2013-12-06
/// Description:  查询疑似病例列表
/// Table：       DHCMed.NINF.BC.CasesX
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CasesXSrv","QryCasesXPatList","INTCCS","2014-03-08","2014-03-10","1","3,2,1,0","","","602554")
Query QryCasesXPatList(aConfigCode As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aScreenGrade As %String, aHandleGrade As %String, aHospID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,CasesXIDs:%String,CasesXDates:%String,RegNo:%String,PatName:%String,MrNo:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,LocID:%String,LocDesc:%String,LocGrp:%String,WardID:%String,WardDesc:%String,WardGrp:%String,BedID:%String,Bed:%String,DocID:%String,DocName:%String,DisDate:%String,DisTime:%String,AdmStatus:%String")
{
}

ClassMethod QryCasesXPatListExecute(ByRef qHandle As %Binary, aConfigCode As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aScreenGrade As %String, aHandleGrade As %String, aHospID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aConfigCode="" $$$OK
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	
 	Set JIndex=$j,ZIndex=$zn
 	Kill ^TMP(JIndex,ZIndex,"QryCasesXPatList")
 	
 	Set xDate=aDateFrom-1
 	For {
	 	Set xDate=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm",aConfigCode,xDate))
	 	Quit:xDate=""
	 	Quit:xDate>aDateTo
	 	
	 	Set xEpisodeID=""
	 	For {
		 	Set xEpisodeID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm",aConfigCode,xDate,xEpisodeID))
		 	Quit:xEpisodeID=""
		 	Continue:(aEpisodeID'="")&&(aEpisodeID'=xEpisodeID)
		 	
		 	Set xID=""
		 	For {
				Set xID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm",aConfigCode,xDate,xEpisodeID,xID))
				Quit:xID=""
				
				Set CasesXID=xID
				Set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(CasesXID)
				Continue:'$IsObject(objCasesX)
				Set IsActive=objCasesX.CXIsActive
				Continue:IsActive'=1
				Set EpisodeID=objCasesX.CXEpisodeID
				Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
				Set HandleGrade=##Class(DHCMed.NINFService.BC.CasesSrv).GetHandleGrade(CasesXID)
				Continue:(HandleGrade'="")&&(aHandleGrade'[HandleGrade)
				Set ScreenGrade=objCasesX.CXScreenGrade  //筛查等级(1易感人群\2疑似患者\3高度疑似)
				Continue:(aScreenGrade'[ScreenGrade)
				Set (HandleStatus,HandleDate,HandleTime,SttDate,EndDate)=""
				Set tmpCasesHandle=##Class(DHCMed.NINFService.BC.CasesSrv).GetCasesHandleStatus(aConfigCode,EpisodeID)
				If tmpCasesHandle'="" {
					Set HandleStatus=$p(tmpCasesHandle,",",1)
					Set HandleStatusDesc=$p(tmpCasesHandle,",",2)
					Set HandleDate=$p(tmpCasesHandle,",",3)
					Set HandleTime=$p(tmpCasesHandle,",",4)
					Set SttDate=$p(tmpCasesHandle,",",5)
					Set EndDate=$p(tmpCasesHandle,",",6)
					Continue:(HandleStatus=3)&&(aScreenGrade'["0") //确诊病例,归入筛选条件“其它”
				}
				Set ActDate=objCasesX.CXActDate
				
				Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Continue:'$IsObject(objPaadm)
				Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Continue:'$IsObject(objPatient)
				
				Set LocID=objPaadm.DepartmentID
				Set LocDesc=objPaadm.Department
				//判断医院(集团化医院)
				If aHospID'="" {
					Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospID)
					Continue:flg<1
				}
				Set AdmStatus=objPaadm.Status    //状态(1在院\2出院)
				Continue:AdmStatus="C"
				Set tmpAdmStatus=$s(AdmStatus="A":"1",AdmStatus="D":"2",1:"1")
				Continue:(aAdmStatus'="")&&(aAdmStatus'[tmpAdmStatus)	//在院出院过滤
				Set AdmStatus=$s(AdmStatus="A":"在院",AdmStatus="D":"出院",1:"在院")
				
				If '$d(^TMP(JIndex,ZIndex,"QryCasesXPatList",EpisodeID)){
					Set RegNo=objPatient.PapmiNo
					Set PatName=objPatient.PatientName
					Set MrNo=objPatient.InPatientMrNo
					Set:MrNo="" MrNo=objPaadm.MrNo
					Set Sex=objPatient.Sex
					Set Age=objPatient.Age
					Set tmpWardID=objPaadm.WardID
					Set WardID=$p($g(^PAWARD(+tmpWardID)),"^",5)
					Set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
					Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
					Set BedID=objPaadm.BedID
					Set BedDesc=objPaadm.Bed
					Set DocID=objPaadm.DoctorID
					Set DocName=objPaadm.DoctorName
					//Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(EpisodeID)
					//Set AdmDate=$p(tmpDateTime,",",1)
					//upadte by pylian 2016-02-18 修改入院时间取值方式
    				Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
					Set AdmDate=$p(AdmDateTime,"^",1)
					;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
					Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
					//Set AdmTime=$p(tmpDateTime,",",2)
					Set AdmTime=$p(AdmDateTime,"^",2)
					Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
					Set DisDate=objPaadm.DisDate
					Set DisTime=objPaadm.DisTime
					
					Set LocGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("E",LocID)
					Set WardGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("W",WardID)
					
					Set CasesXIDs=CasesXID
					Set CasesXDates=ActDate
					
					Set Data=$lb(EpisodeID,PatientID,CasesXIDs,CasesXDates,RegNo,PatName,MrNo,Sex,Age)
					Set Data=Data_$lb(AdmDate,AdmTime,LocID,LocDesc,LocGrp,WardID,WardDesc,WardGrp)
					Set Data=Data_$lb(BedID,Bed,DocID,DocName,DisDate,DisTime,AdmStatus)
				} Else {
					Set Data=$g(^TMP(JIndex,ZIndex,"QryCasesXPatList",EpisodeID))
					Set CasesXIDs=$list(Data,3)
					Set CasesXIDs=CasesXIDs_","_CasesXID
					Set $list(Data,3)=CasesXIDs
					Set CasesXDates=$list(Data,4)
					Set CasesXDates=CasesXDates_","_ActDate
					Set $list(Data,4)=CasesXDates
				}
				
				Set ^TMP(JIndex,ZIndex,"QryCasesXPatList",EpisodeID)=Data
			}
		}
	}
	
	Set xEpisodeID=0
	For {
		Set xEpisodeID=$o(^TMP(JIndex,ZIndex,"QryCasesXPatList",xEpisodeID))
		Quit:xEpisodeID=""
		Set Data=$g(^TMP(JIndex,ZIndex,"QryCasesXPatList",xEpisodeID))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	Kill ^TMP(JIndex,ZIndex,"QryCasesXPatList")
 	
	Quit $$$OK
}

ClassMethod QryCasesXPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCasesXPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCasesXPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCasesXPatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2014-01-24
/// Description:  查询处置病例列表
/// Table：       DHCMed.NINF.BC.CasesX,DHCMed.NINF.BC.Cases
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CasesXSrv","QryCasesPatList","INTCCS","2014-03-01","2014-03-30","1,2","1,2,3,4","2","3","")
Query QryCasesPatList(aConfigCode As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aHandleGrade As %String, aScreenGrade As %String, aHospID As %String, aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,CasesXIDs:%String,CasesXDates:%String,RegNo:%String,PatName:%String,MrNo:%String,Sex:%String,Age:%String,AdmDate:%String,AdmTime:%String,LocID:%String,LocDesc:%String,LocGrp:%String,WardID:%String,WardDesc:%String,WardGrp:%String,BedID:%String,Bed:%String,DocID:%String,DocName:%String,DisDate:%String,DisTime:%String,AdmStatus:%String")
{
}

ClassMethod QryCasesPatListExecute(ByRef qHandle As %Binary, aConfigCode As %String, aDateFrom As %String, aDateTo As %String, aAdmStatus As %String, aHandleGrade As %String, aScreenGrade As %String, aHospID As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aConfigCode="" $$$OK
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
 	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
 	Set JIndex=$j,ZIndex=$zn
 	Kill ^TMP(JIndex,ZIndex,"QryCasesPatList")
 	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINF.BC.CasesI("HA","IndexActDate",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Quit:aScreenGrade'["1"  //感染管理科处置记录
 	
		Set xCasesID=""
		For {
			Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("HA","IndexActDate",xDate,xCasesID))
			Quit:xCasesID=""
		
			Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
			Continue:'$IsObject(objCases)
			Set IsActive=objCases.CSIsActive
			Continue:IsActive'=1
			Set SubjectCode=objCases.CSSubjectCode
			Continue:SubjectCode'=aConfigCode
			Set EpisodeID=objCases.CSEpisodeID
			Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
		 	Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
		 	
			Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient)
			
			Set LocID=objPaadm.DepartmentID
			Set LocDesc=objPaadm.Department
			//判断医院(集团化医院)
			If aHospID'="" {
				Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospID)
				Continue:flg<1
			}
			Set AdmStatus=objPaadm.Status    //状态(1在院\2出院)
			Continue:AdmStatus="C"
			Set tmpAdmStatus=$s(AdmStatus="A":"1",AdmStatus="D":"2",1:"1")
			Continue:(aAdmStatus'="")&&(aAdmStatus'[tmpAdmStatus)	//在院出院过滤
			Set AdmStatus=$s(AdmStatus="A":"在院",AdmStatus="D":"出院",1:"在院")
			
	 		Set (HandleStatus,HandleDate,HandleTime,SttDate,EndDate)=""
			Set tmpCasesHandle=##Class(DHCMed.NINFService.BC.CasesSrv).GetCasesHandleStatus(aConfigCode,EpisodeID)
			If tmpCasesHandle'="" {
				Set HandleStatus=$p(tmpCasesHandle,",",1)
				Set HandleStatusDesc=$p(tmpCasesHandle,",",2)
				Set HandleDate=$p(tmpCasesHandle,",",3)
				Set HandleTime=$p(tmpCasesHandle,",",4)
				Set SttDate=$p(tmpCasesHandle,",",5)
				Set EndDate=$p(tmpCasesHandle,",",6)
			}
			
			Set xSub=0
			For {
				Set xSub=$o(^DHCMed.NINF.BC.CasesI("HA","IndexActDate",xDate,xCasesID,xSub))
				Quit:xSub=""
				
				Set objCasesHandleA=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(xCasesID_"||"_xSub)
				Continue:'$IsObject(objCasesHandleA)
				Set IsActive=objCasesHandleA.CHAIsActive
				Continue:IsActive'=1
				Set HandleGrade=objCasesHandleA.CHAOperation
				Continue:(aHandleGrade'[HandleGrade)	//处置等级过滤
				
				Set CasesXID=objCasesHandleA.CHALnkCasesX,ActDate=""
				If CasesXID="" {
					Set xCasesXID=""
					For {
						Set xCasesXID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectPaadm",aConfigCode,EpisodeID,xCasesXID),-1)
						Quit:xCasesXID=""
					
						Set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(xCasesXID)
						Continue:'$IsObject(objCasesX)
						Set IsActive=objCasesX.CXIsActive
						Continue:IsActive'=1
						Set CasesXID=xCasesXID
						Set ActDate=objCasesX.CXActDate
					}
				} ElseIf CasesXID'="" {
					Set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(CasesXID)
					If $IsObject(objCasesX) {
						Set IsActive=objCasesX.CXIsActive
						If IsActive=1 {
							Set ActDate=objCasesX.CXActDate
						}
					}
					Set:ActDate="" CasesXID=""
				}
				
				If '$d(^TMP(JIndex,ZIndex,"QryCasesPatList",EpisodeID)){
					Set RegNo=objPatient.PapmiNo
					Set PatName=objPatient.PatientName
					Set MrNo=objPatient.InPatientMrNo
					Set:MrNo="" MrNo=objPaadm.MrNo
					Set Sex=objPatient.Sex
					Set Age=objPatient.Age
					Set tmpWardID=objPaadm.WardID
					Set WardID=$p($g(^PAWARD(+tmpWardID)),"^",5)
					Set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
					Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
					Set BedID=objPaadm.BedID
					Set BedDesc=objPaadm.Bed
					Set DocID=objPaadm.DoctorID
					Set DocName=objPaadm.DoctorName
					//Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(EpisodeID)
					//Set AdmDate=$p(tmpDateTime,",",1)
					//upadte by pylian 2016-02-18 修改入院时间取值方式
    				Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
					Set AdmDate=$p(AdmDateTime,"^",1)
					;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
					Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
					//Set AdmTime=$p(tmpDateTime,",",2)
					Set AdmTime=$p(AdmDateTime,"^",2)
					Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
					Set DisDate=objPaadm.DisDate
					Set DisTime=objPaadm.DisTime
					
					Set LocGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("E",LocID)
					Set WardGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("W",WardID)
					
					Set CasesXIDs=CasesXID
					Set CasesXDates=ActDate
					
					Set Data=$lb(EpisodeID,PatientID,CasesXIDs,CasesXDates,RegNo,PatName,MrNo,Sex,Age)
					Set Data=Data_$lb(AdmDate,AdmTime,LocID,LocDesc,LocGrp,WardID,WardDesc,WardGrp)
					Set Data=Data_$lb(BedID,Bed,DocID,DocName,DisDate,DisTime,AdmStatus)
				} Else {
					Set Data=$g(^TMP(JIndex,ZIndex,"QryCasesPatList",EpisodeID))
					Set CasesXIDs=$list(Data,3)
					Set CasesXIDs=CasesXIDs_","_CasesXID
					Set $list(Data,3)=CasesXIDs
					Set CasesXDates=$list(Data,4)
					Set CasesXDates=CasesXDates_","_ActDate
					Set $list(Data,4)=CasesXDates
				}
				
				Set ^TMP(JIndex,ZIndex,"QryCasesPatList",EpisodeID)=Data
			}
		}
	}
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.NINF.BC.CasesI("HB","IndexActDate",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		Quit:aScreenGrade'["2"  //临床科室处置记录
 		
		Set xCasesID=""
		For {
			Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("HB","IndexActDate",xDate,xCasesID))
			Quit:xCasesID=""
			
			Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
			Continue:'$IsObject(objCases)
			Set IsActive=objCases.CSIsActive
			Continue:IsActive'=1
			Set SubjectCode=objCases.CSSubjectCode
			Continue:SubjectCode'=aConfigCode
			Set EpisodeID=objCases.CSEpisodeID
			Continue:(aEpisodeID'="")&&(aEpisodeID'=EpisodeID)
		 	Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	 		
			Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objPaadm)
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient)
			
			Set LocID=objPaadm.DepartmentID
			Set LocDesc=objPaadm.Department
			//判断医院(集团化医院)
			If aHospID'="" {
				Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospID)
				Continue:flg<1
			}
			Set AdmStatus=objPaadm.Status    //状态(1在院\2出院)
			Continue:AdmStatus="C"
			Set tmpAdmStatus=$s(AdmStatus="A":"1",AdmStatus="D":"2",1:"1")
			Continue:(aAdmStatus'="")&&(aAdmStatus'[tmpAdmStatus)	//在院出院过滤
			Set AdmStatus=$s(AdmStatus="A":"在院",AdmStatus="D":"出院",1:"在院")
			
	 		Set (HandleStatus,HandleDate,HandleTime,SttDate,EndDate)=""
			Set tmpCasesHandle=##Class(DHCMed.NINFService.BC.CasesSrv).GetCasesHandleStatus(aConfigCode,EpisodeID)
			If tmpCasesHandle'="" {
				Set HandleStatus=$p(tmpCasesHandle,",",1)
				Set HandleStatusDesc=$p(tmpCasesHandle,",",2)
				Set HandleDate=$p(tmpCasesHandle,",",3)
				Set HandleTime=$p(tmpCasesHandle,",",4)
				Set SttDate=$p(tmpCasesHandle,",",5)
				Set EndDate=$p(tmpCasesHandle,",",6)
			}
			
			Set xSub=0
			For {
				Set xSub=$o(^DHCMed.NINF.BC.CasesI("HB","IndexActDate",xDate,xCasesID,xSub))
				Quit:xSub=""
				
				Set objCasesHandleB=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(xCasesID_"||"_xSub)
				Continue:'$IsObject(objCasesHandleB)
				Set IsActive=objCasesHandleB.CHBIsActive
				Continue:IsActive'=1
				Set HandleGrade=objCasesHandleB.CHBOperation
				Continue:(aHandleGrade'[HandleGrade)	//处置等级过滤
				
				Set CasesXID="",ActDate=""
				Set xCasesXID=""
				For {
					Set xCasesXID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectPaadm",aConfigCode,EpisodeID,xCasesXID),-1)
					Quit:xCasesXID=""
				
					Set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(xCasesXID)
					Continue:'$IsObject(objCasesX)
					Set IsActive=objCasesX.CXIsActive
					Continue:IsActive'=1
					Set CasesXID=xCasesXID
					Set ActDate=objCasesX.CXActDate
				}
				
				If '$d(^TMP(JIndex,ZIndex,"QryCasesPatList",EpisodeID)){
					Set RegNo=objPatient.PapmiNo
					Set PatName=objPatient.PatientName
					Set MrNo=objPatient.InPatientMrNo
					Set:MrNo="" MrNo=objPaadm.MrNo
					Set Sex=objPatient.Sex
					Set Age=objPatient.Age
					Set tmpWardID=objPaadm.WardID
					Set WardID=$p($g(^PAWARD(+tmpWardID)),"^",5)
					Set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
					Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
					Set BedID=objPaadm.BedID
					Set BedDesc=objPaadm.Bed
					Set DocID=objPaadm.DoctorID
					Set DocName=objPaadm.DoctorName
					//Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(EpisodeID)
					//Set AdmDate=$p(tmpDateTime,",",1)
					//upadte by pylian 2016-02-18 修改入院时间取值方式
    				Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
					Set AdmDate=$p(AdmDateTime,"^",1)
					;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
					Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
					//Set AdmTime=$p(tmpDateTime,",",2)
					Set AdmTime=$p(AdmDateTime,"^",2)
					Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
					Set DisDate=objPaadm.DisDate
					Set DisTime=objPaadm.DisTime
					
					Set LocGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("E",LocID)
					Set WardGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("W",WardID)
					
					Set CasesXIDs=CasesXID
					Set CasesXDates=ActDate
					
					Set Data=$lb(EpisodeID,PatientID,CasesXIDs,CasesXDates,RegNo,PatName,MrNo,Sex,Age)
					Set Data=Data_$lb(AdmDate,AdmTime,LocID,LocDesc,LocGrp,WardID,WardDesc,WardGrp)
					Set Data=Data_$lb(BedID,Bed,DocID,DocName,DisDate,DisTime,AdmStatus)
				} Else {
					Set Data=$g(^TMP(JIndex,ZIndex,"QryCasesPatList",EpisodeID))
					Set CasesXIDs=$list(Data,3)
					Set CasesXIDs=CasesXIDs_","_CasesXID
					Set $list(Data,3)=CasesXIDs
					Set CasesXDates=$list(Data,4)
					Set CasesXDates=CasesXDates_","_ActDate
					Set $list(Data,4)=CasesXDates
				}
				
				Set ^TMP(JIndex,ZIndex,"QryCasesPatList",EpisodeID)=Data
			}
		}
	}
	
	Set xEpisodeID=0
	For {
		Set xEpisodeID=$o(^TMP(JIndex,ZIndex,"QryCasesPatList",xEpisodeID))
		Quit:xEpisodeID=""
		
		Set Data=$g(^TMP(JIndex,ZIndex,"QryCasesPatList",xEpisodeID))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
 	Kill ^TMP(JIndex,ZIndex,"QryCasesPatList")
 	
	Quit $$$OK
}

ClassMethod QryCasesPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCasesPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCasesPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCasesPatListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2013-12-06
/// Description:  查询疑似病例列表
/// Table：       DHCMed.NINF.BC.CasesX
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CasesXSrv","QryCasesXDtl","INTCCS","641432","63254,63256")
Query QryCasesXDtl(aConfigCode As %String, aEpisodeID As %String, aCasesXDates As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,CasesXID:%String,CXScreenGrade:%String,CXHandleGrade:%String,CXActDate:%String,ResultID:%String,ItemID:%String,ItemDesc:%String,Score:%String,ScreenGrade:%String,SubCatID:%String,SubCatDesc:%String,ItemCatID:%String,ItemCatDesc:%String,ActDate:%String,ActTime:%String,OccurDate:%String,OccurTime:%String,Summary:%String,DataValue:%String,ObjectID:%String,UserID:%String,UserDesc:%String")
{
}

ClassMethod QryCasesXDtlExecute(ByRef qHandle As %Binary, aConfigCode As %String, aEpisodeID As %String, aCasesXDates As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aConfigCode="")||(aEpisodeID="")||(aCasesXDates="") $$$OK
 	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aConfigCode)
	Quit:'$IsObject(objConfig) $$$OK
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	
 	For indDate=1:1:$l(aCasesXDates,",") {
	 	Set xActDate=$p(aCasesXDates,",",indDate)
	 	Continue:xActDate=""
	 	;Set:xActDate["-" xActDate=$zdh(xActDate,3)
	 	Set:xActDate'="" xActDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(xActDate)
	 	
	 	Set JIndex=$j,ZIndex=$zn
		Kill ^TMP(JIndex,ZIndex,"QryCasesXDtl")
		
	 	Set xID=0
	 	For {
		 	Set xID=$o(^DHCMed.NINF.BC.CasesXI("IndexSubjectDateAdm",aConfigCode,xActDate,aEpisodeID,xID))
	 		Quit:xID=""
	 		
			Set CasesXID=xID
			Set objCasesX=##class(DHCMed.NINF.BC.CasesX).GetObjById(CasesXID)
			Continue:'$IsObject(objCasesX)
			Set IsActive=objCasesX.CXIsActive
			Continue:IsActive'=1
			Set EpisodeID=objCasesX.CXEpisodeID
			Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
			Set CXHandleGrade=##Class(DHCMed.NINFService.BC.CasesSrv).GetHandleGrade(CasesXID)
			Set CXScreenGrade=objCasesX.CXScreenGrade  //筛查等级(1易感人群\2疑似患者\3高度疑似)
			Set CXActDate=objCasesX.CXActDate
			;Set CXActDate=$zd(CXActDate,3)
			Set CXActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CXActDate)
			Set CXScreenGrade=##class(DHCMed.NINFService.BC.CommonSrv).GetScreenGradeByCode(CXScreenGrade)
			Set CXHandleGrade=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(CXHandleGrade)
			
			Set xResultID=0
			For {
				Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",objCasesX.CXActDate,EpisodeID,SubjectID,xResultID))
				Quit:xResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
				Continue:'$IsObject(objResult)
				
				Set ItemID=objResult.ItemId
				Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
				Continue:'$IsObject(objItem)
				Set ItemDicDr=objItem.ItemDic
				Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDr)
				Continue:'$IsObject(objItemDic)
				Set ItemDesc=objItemDic.IDDesc
				Set SubCatDr=objItemDic.IDSubCatDr
				Continue:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,SubCatDr))
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
				Continue:'$IsObject(objSubCat)
				Set SubCatDesc=objSubCat.ISCDesc
				Set ItemCatID=objSubCat.ISCCatDr
				Set objItemCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatID)
				Continue:'$IsObject(objItemCat)
				Set ItemCatDesc=objItemCat.ICDesc
				
				Set Score=objItem.Score  //借用Score字段作为项目等级字段
				Continue:Score<1
				Set ScreenGrade=0
				Set:(Score>0)&&(Score<=50) ScreenGrade=1
				Set:(Score>50)&&(Score<=100) ScreenGrade=2
				Set:Score>100 ScreenGrade=3
				Continue:ScreenGrade<1
				
				Set EpisodeID=objResult.EpisodeID
				Set ObjectID=objResult.ObjectID
				
				If $d(^TMP(JIndex,ZIndex,"QryCasesXDtl",EpisodeID,ObjectID)) {
					Set tmpData=$g(^TMP(JIndex,ZIndex,"QryCasesXDtl",EpisodeID,ObjectID))
					Set tmpScore=$list(tmpData,10)
					Continue:Score<tmpScore
				}
				
				Set ActDate=objResult.ActDate
				;Set:ActDate'="" ActDate=$zd(ActDate,3)
				Set:ActDate'="" ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
				Set ActTime=objResult.ActTime
				Set:ActTime'="" ActTime=$zt(ActTime,2)
				Set Summary=objResult.Summary
				Set DataValue=objResult.DataValue
				Set UserDesc=""
				Set UserID=objResult.UserID
				Set:UserID'="" UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
				Set OccurDate=objResult.OccurDate
				;Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
				Set:OccurDate'="" OccurDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OccurDate)
				Set OccurTime=objResult.OccurTime
				Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
				
				Set Data=$lb(EpisodeID,PatientID,CasesXID,CXScreenGrade,CXHandleGrade,CXActDate)
				Set Data=Data_$lb(xResultID,ItemID,ItemDesc,Score,ScreenGrade,SubCatDr,SubCatDesc,ItemCatID,ItemCatDesc,ActDate,ActTime,OccurDate,OccurTime,Summary,DataValue,ObjectID,UserID,UserDesc)
				Set ^TMP(JIndex,ZIndex,"QryCasesXDtl",EpisodeID,ObjectID)=Data
			}
	 	}
	 	
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^TMP(JIndex,ZIndex,"QryCasesXDtl",xEpisodeID))
			Quit:xEpisodeID=""
			Set xObjectID=""
			For {
				Set xObjectID=$o(^TMP(JIndex,ZIndex,"QryCasesXDtl",xEpisodeID,xObjectID))
				Quit:xObjectID=""
			
				Set Data=$g(^TMP(JIndex,ZIndex,"QryCasesXDtl",xEpisodeID,xObjectID))
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		Kill ^TMP(JIndex,ZIndex,"QryCasesXDtl")
	}
	
	Quit $$$OK
}

ClassMethod QryCasesXDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCasesXDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCasesXDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCasesXDtlExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##Class(DHCMed.NINFService.BC.CasesXSrv).GetCasesXPatInfo("INTCCS","333409")
ClassMethod GetCasesXPatInfo(aConfigCode As %String, aEpisodeID As %String) As %String
{
	New (aConfigCode,aEpisodeID)
	Set return=""
	Quit:(aConfigCode="")||(aEpisodeID="") return
	
	Set EpisodeID=aEpisodeID
	Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	
	Set objPaadm=##Class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm) return
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return
	
	Set LocID=objPaadm.DepartmentID
	Set LocDesc=objPaadm.Department
	Set HospID=$p($g(^CTLOC(+LocID)),"^",22)
	Set AdmStatus=objPaadm.Status    //状态(1在院\2出院)
	Quit:AdmStatus="C" return
	Set AdmStatus=$s(AdmStatus="A":"在院",AdmStatus="D":"出院",1:"在院")
	
	Set RegNo=objPatient.PapmiNo
	Set PatName=objPatient.PatientName
	Set MrNo=objPatient.InPatientMrNo
	Set:MrNo="" MrNo=objPaadm.MrNo
	Set Sex=objPatient.Sex
	//Set Age=objPatient.Age
	Set:objPatient.Age>0 Age=objPatient.Age_"岁"
	Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
	Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
	Set tmpWardID=objPaadm.WardID
	Set WardID=$p($g(^PAWARD(+tmpWardID)),"^",5)
	Set WardDesc=$p($g(^CTLOC(+WardID)),"^",2)
	Set:$p(WardDesc,"-",2)'="" WardDesc=$p(WardDesc,"-",2)
	Set BedID=objPaadm.BedID
	Set BedDesc=objPaadm.Bed
	Set DocID=objPaadm.DoctorID
	Set DocName=objPaadm.DoctorName
	//Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospDateTime(EpisodeID)
	//Set AdmDate=$p(tmpDateTime,",",1)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	//Set AdmTime=$p(tmpDateTime,",",2)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	Set DisDate=objPaadm.DisDate
	Set DisTime=objPaadm.DisTime
	Set tmpLocWard=##class(DHCMed.NINFService.BC.CommonSrv).GetInHospLocWard(EpisodeID)
	Set InHospLocID=$p(tmpLocWard,",",1)
	Set InHospLocDesc=$p(tmpLocWard,",",2)
	Set InHospWardID=$p(tmpLocWard,",",3)
	Set InHospWardDesc=$p(tmpLocWard,",",4)
	;Set tmpSttDate=$zdh(AdmDate,3)
	Set tmpSttDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(AdmDate)
	;Set tmpEndDate=$s(DisDate'="":$zdh(DisDate,3),1:+$h)
	Set tmpEndDate=$s(DisDate'="":##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(DisDate),1:+$h)
	Set InHospDays=(tmpEndDate-tmpSttDate)+1
	
	Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInLocDateTime(EpisodeID,"E")
	Set InLocDate=$p(tmpDateTime,",",1)
	;Set:InLocDate'="" InLocDate=$zd(InLocDate,3)
	Set:InLocDate'="" InLocDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InLocDate)
	Set InLocTime=$p(tmpDateTime,",",2)
	Set:InLocTime'="" InLocTime=$zt(InLocTime,2)
	Set tmpDateTime=##class(DHCMed.NINFService.BC.CommonSrv).GetInLocDateTime(EpisodeID,"W")
	Set InWardDate=$p(tmpDateTime,",",1)
	;Set:InWardDate'="" InWardDate=$zd(InWardDate,3)
	Set:InWardDate'="" InWardDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InWardDate)
	Set InWardTime=$p(tmpDateTime,",",2)
	Set:InWardTime'="" InWardTime=$zt(InWardTime,2)
	
	Set LocGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("E",LocID)
	Set WardGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("W",WardID)
	
	Set (HandleStatus,HandleDate,HandleTime,SttDate,EndDate)=""
	Set tmpCasesHandle=##Class(DHCMed.NINFService.BC.CasesSrv).GetCasesHandleStatus(aConfigCode,EpisodeID)
	If tmpCasesHandle'="" {
		Set HandleStatus=$p(tmpCasesHandle,",",2)
		Set HandleDate=$p(tmpCasesHandle,",",3)
		Set HandleTime=$p(tmpCasesHandle,",",4)
		Set SttDate=$p(tmpCasesHandle,",",5)
		Set EndDate=$p(tmpCasesHandle,",",6)
	} Else {
		Set HandleStatus="未处理"
	}
	
	Set return=EpisodeID_"^"_PatientID
	Set return=return_"^"_HandleStatus_"^"_HandleDate_"^"_HandleTime_"^"_SttDate_"^"_EndDate
	Set return=return_"^"_RegNo_"^"_PatName_"^"_MrNo_"^"_Sex_"^"_Age
	Set return=return_"^"_AdmDate_"^"_AdmTime_"^"_LocID_"^"_LocDesc_"^"_LocGrp
	Set return=return_"^"_WardID_"^"_WardDesc_"^"_WardGrp_"^"_BedID_"^"_BedDesc
	Set return=return_"^"_DocID_"^"_DocName_"^"_DisDate_"^"_DisTime_"^"_AdmStatus
	Set return=return_"^"_InHospLocDesc_"^"_InHospWardDesc_"^"_InHospDays_"^"_InLocDate_"^"_InLocTime
	Set return=return_"^"_InWardDate_"^"_InWardTime
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-15
/// Description:  获取监控日期列表
/// Table：       DHCMed.CC.CtlResult
/// Input：       主题配置代码\就诊号
/// Return：      返回Object
/// w ##class(DHCMed.NINFService.BC.CasesXSrv).GetCtlDateList("INTCCS",204)
ClassMethod GetCtlDateList(aSubjectCode As %String, aEpisodeID As %String)
{
	New (aSubjectCode,aEpisodeID)
	Set return=""
	Quit:(aSubjectCode="")||(aEpisodeID="") return
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) return
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	//主题配置下的监控之类
	Kill arrSubCat
	Kill arrCtlDate
	Set xSubCatID=""
	For {
		Set xSubCatID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,xSubCatID))
		Quit:xSubCatID=""
		Set num=$i(arrSubCat(xSubCatID))
	}
	
	Set xResultID=0
	For {
		Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",aEpisodeID,SubjectID,xResultID))
		Quit:xResultID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
		Continue:'$IsObject(objResult)
		
		Set ItemID=objResult.ItemId
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set ItemDicDr=objItem.ItemDic
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDr)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set SubCatDr=objItemDic.IDSubCatDr
		Continue:'$d(arrSubCat(SubCatDr))
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
		Continue:'$IsObject(objSubCat)
		Set SubCatDesc=objSubCat.ISCDesc
		Set ItemCatID=objSubCat.ISCCatDr
		Set objItemCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objItemCat)
		Set Score=objItem.Score  //借用Score字段作为项目等级字段
		Continue:Score<1
		Set ItemGroup=0
		Set:(Score>0)&&(Score<=50) ItemGroup=1
		Set:(Score>50)&&(Score<=100) ItemGroup=2
		Set:Score>100 ItemGroup=3
		Continue:ItemGroup<1
		
		Set ActDate=objResult.ActDate      //结果时间
		Continue:ActDate=""
		Set num=$i(arrCtlDate(ActDate))
		Set OccurDate=objResult.OccurDate  //发生时间
		Continue:OccurDate=""
		Set num=$i(arrCtlDate(OccurDate))
	}
	
	Set SttDate=$o(arrCtlDate(""))
	Set EndDate=$o(arrCtlDate(""),-1)
	Set:(EndDate-SttDate)>60 SttDate=EndDate-60
	For xDate=SttDate:1:EndDate {
		Set return=return_","_$zd(xDate,3)
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-12-14
/// Description:  查询监控明细
/// Table：       DHCMed.CC.CtlResult
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.CasesXSrv","QryCtlResult","INTCCS","644586")
Query QryCtlResult(aSubjectCode As %String, aEpisodeID As %String) As %Query(ROWSPEC = "ResultID:%String,EpisodeID:%String,ItemID:%String,ItemDesc:%String,Score:%String,ItemGroup:%String,SubCatID:%String,SubCatDesc:%String,ItemCatID:%String,ItemCatDesc:%String,ActDate:%String,ActTime:%String,OccurDate:%String,OccurTime:%String,Summary:%String,DataValue:%String,ObjectID:%String,UserID:%String,UserDesc:%String")
{
}

ClassMethod QryCtlResultExecute(ByRef qHandle As %Binary, aSubjectCode As %String, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Quit:(aSubjectCode="")||(aEpisodeID="") $$$OK
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(aSubjectCode)
	Quit:'$IsObject(objConfig) $$$OK
	Set ConfigID=objConfig.%Id()
	Set SubjectCode=objConfig.SubjectCode
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	
	//主题配置下的监控之类
	kill arrSubCat
	set xSubCatID=""
	for {
		set xSubCatID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,xSubCatID))
		quit:xSubCatID=""
		set num=$i(arrSubCat(xSubCatID))
	}
	
	Set xResultID=0
	For {
		Set xResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexEpisodeSubject",aEpisodeID,SubjectID,xResultID))
		Quit:xResultID=""
		
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(xResultID)
		Continue:'$IsObject(objResult)
		
		Set ItemID=objResult.ItemId
		Set objItem=##class(DHCMed.CC.SubjectItm).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		Set ItemDicDr=objItem.ItemDic
		Set objItemDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicDr)
		Continue:'$IsObject(objItemDic)
		Set ItemDesc=objItemDic.IDDesc
		Set SubCatDr=objItemDic.IDSubCatDr
		Continue:'$d(arrSubCat(SubCatDr))
		Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
		Continue:'$IsObject(objSubCat)
		Set SubCatDesc=objSubCat.ISCDesc
		Set ItemCatID=objSubCat.ISCCatDr
		Set objItemCat=##class(DHCMed.CC.ItemCat).GetObjById(ItemCatID)
		Continue:'$IsObject(objItemCat)
		Set ItemCatDesc=objItemCat.ICDesc
		
		Set Score=objItem.Score  //借用Score字段作为项目等级字段
		Continue:Score<1
		Set ItemGroup=0
		Set:(Score>0)&&(Score<=50) ItemGroup=1
		Set:(Score>50)&&(Score<=100) ItemGroup=2
		Set:Score>100 ItemGroup=3
		Continue:ItemGroup<1
		
		Set EpisodeID=objResult.EpisodeID
		Set ObjectID=objResult.ObjectID
		
		Set ActDate=objResult.ActDate
		Set:ActDate'="" ActDate=$zd(ActDate,3)
		Set ActTime=objResult.ActTime
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set Summary=objResult.Summary
		Set DataValue=objResult.DataValue
		Set UserDesc=""
		Set UserID=objResult.UserID
		Set:UserID'="" UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
		Set OccurDate=objResult.OccurDate
		Set:OccurDate'="" OccurDate=$zd(OccurDate,3)
		Set OccurTime=objResult.OccurTime
		Set:OccurTime'="" OccurTime=$zt(OccurTime,2)
		
		Set Data=$lb(xResultID,EpisodeID,ItemID,ItemDesc,Score,ItemGroup,SubCatDr,SubCatDesc,ItemCatID,ItemCatDesc,ActDate,ActTime,OccurDate,OccurTime,Summary,DataValue,ObjectID,UserID,UserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrSubCat
	
	Quit $$$OK
}

ClassMethod QryCtlResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCtlResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCMed.NINFService.BC.CasesXSrv).GetLocIPCount("2013-07-05","2013-07-05","")
ClassMethod GetLocIPCount(aFromDate As %String, aToDate As %String, aLocID As %String = "") As %String
{
	New (aFromDate,aToDate,aLocID)
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	
 	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
 	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
 	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
 	Set aFromDate=aFromDate-1
 	Set aToDate=aToDate-1
 	
 	Kill ^TMP($zn,$j,"GetLocIPCount")
	
	//计算科室在院人数
	Set num=0
	Set xDate=aFromDate
	For {
		Set xDate=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate))
		Quit:xDate=""
		Quit:xDate>(aToDate+10)
		
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID))
			Quit:xLocID=""
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				
				Set AdmLoc=$p($g(^PAADM(xPaadm)),"^",4)
				Continue:AdmLoc=""
				Set AdmWard=$p($g(^PAADM(xPaadm)),"^",70)
				Continue:AdmWard=""
				Set AdmWard=$p($g(^PAWARD(AdmWard)),"^",5)
				Continue:(aLocID'="")&&(aLocID'=AdmLoc)&&(aLocID'=AdmWard)
				
				Set xAimTransID=0
				For {
					Set xAimTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm,xAimTransID))
					Quit:xAimTransID=""
					
					Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAimTransID)
					Continue:'$IsObject(objAimTrans)
					If objAimTrans.LinkID'="" {
						Set tmpAimTransID=objAimTrans.LinkID
						Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(tmpAimTransID)
						Continue:'$IsObject(objAimTrans)
					} Else {
						Set tmpAimTransID=objAimTrans.%Id()
					}
					Continue:$d(^TMP($zn,$j,"GetLocIPCount","AdmTrans",tmpAimTransID))
					Set ^TMP($zn,$j,"GetLocIPCount","AdmTrans",tmpAimTransID)=""
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>aToDate
					Continue:TransOutDate<aFromDate
					Continue:(TransInDate=aToDate)&&(TransOutDate'=aToDate)
					
					If '$d(^TMP($zn,$j,"GetLocIPCount","Data",AdmLoc,"InHosp",xPaadm)) {
						Set ^TMP($zn,$j,"GetLocIPCount","Data",AdmLoc,"InHosp",xPaadm)=""
						Set num=$i(^TMP($zn,$j,"GetLocIPCount","Data",AdmLoc,"InHosp"))
					}
					If '$d(^TMP($zn,$j,"GetLocIPCount","Data",AdmWard,"InHosp",xPaadm)) {
						Set ^TMP($zn,$j,"GetLocIPCount","Data",AdmWard,"InHosp",xPaadm)=""
						Set num=$i(^TMP($zn,$j,"GetLocIPCount","Data",AdmWard,"InHosp"))
					}
				}
			}
		}
	}
	
	Set xLocID=""
	For {
		Set xLocID=$o(^TMP($zn,$j,"GetLocIPCount","Data",xLocID))
		Quit:xLocID=""
		
		Set LocDesc=$p($g(^CTLOC(xLocID)),"^",2)
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
		Continue:LocDesc["已停用"
		
		Set LocType=$p($g(^CTLOC(xLocID)),"^",13)
		If LocType="E" {
			Set LocGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("E",xLocID)
		} Else {
			Set LocGrp=##class(DHCMed.NINF.BC.LocGroup).GetLocGrpByLocID("W",xLocID)
		}
		
		Set IPCount=+$g(^TMP($zn,$j,"GetLocIPCount","Data",xLocID,"InHosp"))
		Set tmpLoc=xLocID_$c(2)_LocType_$c(2)_IPCount_$c(2)_LocDesc_$c(2)_LocGrp
		Set return=return_$c(1)_tmpLoc
	}
	Kill ^TMP($zn,$j,"GetLocIPCount")
	
	Set return=return
	Quit return
}

}
