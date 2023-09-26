/// 名称: DHCMed.NINFService.BC.OmissionSrv
/// 描述: 疑似未处理、消息未阅读、确诊未上报查询
/// 编写者：zhufei
/// 编写日期: 2013-12-06
Class DHCMed.NINFService.BC.OmissionSrv Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-03-13
/// Description:  就诊号取监控列表数据
/// Return:       $lb() 或 ""
ClassMethod BuildData(argPaadm As %String) As %List
{
	New (argPaadm)
	Set return=""
	Quit:argPaadm="" return
	
	Set $ZT="BuildDataErr"
	Set (PatientID,PapmiNo,PatName,Sex,Birthday,Age,PersonalID,EncryptLevel,PatLevel)=""
	Set (AdmitDate,AdmitTime,DisDate,DisTime,AdmLoc,AdmWard,AdmRoom,AdmBed,AdmDoc,AdmDays)=""
	Set objPaadm=##Class(User.PAAdm).%OpenId(argPaadm)
	Quit:'$IsObject(objPaadm) return
	Do objPaadm.%Close()
    If $IsObject(objPaadm.PAADMPAPMIDR)
    {
	    Set objPatient=objPaadm.PAADMPAPMIDR
	    Set PatientID=objPatient.%Id()
	    //Set PapmiNo=objPatient.PAPMINo
	    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	    Set PatName=objPatient.PAPMIName
	    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
	    Set Birthday=objPatient.PAPMIDOB
	    //update by zf 20150228 统一调用年龄计算方法
	    Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,argPaadm,"","")	//返回“*岁*月*天”
	    ;Set:Birthday'="" Birthday=$zd(Birthday,3)
	    Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	    Set PersonalID=objPatient.PAPMIID
	}
	
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
     //upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(argPaadm)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set AdmitTime=$p(AdmDateTime,"^",2)
    //Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(argPaadm)
	Set DisDate=$p(DischDateTime,"^",1)
	Set DisTime=$p(DischDateTime,"^",2)
	
    If DisDate'="" {
	    Set AdmDays=DisDate-AdmitDate
    } Else {
		Set AdmDays=+$h-AdmitDate
	}
    ;Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
    Set:AdmitDate'="" AdmitDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
    ;Set:DisDate'="" DisDate=$zd(DisDate,3)
    Set:DisDate'="" DisDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DisDate)
    Set:DisTime'="" DisTime=$zt(DisTime,1)
    If $IsObject(objPaadm.PAADMDepCodeDR)
    {
	    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
	    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	}
    If $IsObject(objPaadm.PAADMCurrentWardDR)
    {
	    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
	    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	}
	If $IsObject(objPaadm.PAADMCurrentRoomDR)
	{
		Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
	}
	If $IsObject(objPaadm.PAADMCurrentBedDR)
	{
		Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
	}
	If $IsObject(objPaadm.PAADMAdmDocCodeDR)
	{
		Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
	}
	
	Set AdmInfo=$g(^PAADM(argPaadm))
	Set AdmType=$p(AdmInfo,"^",2)
	Set AdmType=$s(AdmType="I":"住院",AdmType="O":"门诊",AdmType="E":"急诊",1:"其他")
	
	//就诊信息
	Set Data=$lb(argPaadm)
    Set Data=Data_$lb(PatientID)
    Set Data=Data_$lb(PapmiNo)
    Set Data=Data_$lb(PatName)
    Set Data=Data_$lb(Sex)
    Set Data=Data_$lb(Birthday)
    Set Data=Data_$lb(Age)
    Set Data=Data_$lb(PersonalID)
	Set Data=Data_$lb(AdmitDate)
	Set Data=Data_$lb(AdmitTime)
	Set Data=Data_$lb(DisDate)
	Set Data=Data_$lb(DisTime)
	Set Data=Data_$lb(AdmLoc)
	Set Data=Data_$lb(AdmWard)
	Set Data=Data_$lb(AdmRoom)
	Set Data=Data_$lb(AdmBed)
	Set Data=Data_$lb(AdmDoc)
	Set Data=Data_$lb(AdmDays)
	Set Data=Data_$lb(AdmType)
    Set Data=Data_$lb(EncryptLevel)
	Set Data=Data_$lb(PatLevel)
    
    Set return=Data
	Quit return
	
BuildDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2014-03-21
/// Description:  感染漏报查询
/// Table：       DHCMed.NINF.BC.Cases、DHCMed.NINF.BC.CasesHandleA、DHCMed.NINF.BC.CasesHandleB
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.BC.OmissionSrv","QryInfQmission","INTCCS","2014-01-01","2014-03-21","","","")
Query QryInfQmission(aConfigCode As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aWardID As %String, aQryType As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmDays:%String,AdmType:%String,EncryptLevel:%String,PatLevel:%String,HandleID:%String,CurrStatus:%String,Operation:%String,ActDate:%String,ActTime:%String,ActUser:%String,TargetDept:%String,TargetWard:%String,Opinion:%String")
{
}

ClassMethod QryInfQmissionExecute(ByRef qHandle As %Binary, aConfigCode As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aWardID As %String, aQryType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=aConfigCode_","_aFromDate_","_aToDate_","_aLocID_","_aWardID_","_aQryType
	
	Set aQryType=+$g(aQryType)
	;Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	;Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set aFromDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aFromDate)
	Set aToDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aToDate)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Quit:aConfigCode="" $$$OK
	
	If aQryType>0 {
		//临床处置情况：消息未阅读
		For xDate=aFromDate:1:aToDate {
			Set xCasesID=""
			For {
				Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("HB","IndexActDate",xDate,xCasesID))
				Quit:xCasesID=""
				
				Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
				Continue:'$IsObject(objCases)
				Set IsActive=objCases.CSIsActive
				Continue:IsActive'=1
				Set SubjectCode=objCases.CSSubjectCode
				Continue:aConfigCode'=SubjectCode
				Set EpisodeID=objCases.CSEpisodeID
				
				Set HandleAOper=objCases.CSHandleAOper
				Set HandleADate=objCases.CSHandleADate
				Set HandleATime=objCases.CSHandleATime
				Set HandleBOper=objCases.CSHandleBOper
				Set HandleBDate=objCases.CSHandleBDate
				Set HandleBTime=objCases.CSHandleBTime
				Set HandleType="A"
				If (HandleADate="")&&(HandleBDate'="") {
					Set HandleType="B"
				} ElseIf (HandleADate'="")&&(HandleBDate'="") {
					If (HandleADate<HandleBDate){
						Set HandleType="B"
					} ElseIf (HandleADate=HandleBDate)&&(HandleATime<HandleBTime){
						Set HandleType="B"
					} Else {}
				} Else {}
				Set:HandleType="A" CurrStatus=HandleAOper
				Set:HandleType="B" CurrStatus=HandleBOper
				
				Set xHandleID=""
				For {
					Set xHandleID=$o(^DHCMed.NINF.BC.CasesI("HB","IndexActDate",xDate,xCasesID,xHandleID))
					Quit:xHandleID=""
					
					Set HandleID=xCasesID_"||"_xHandleID
					Set objHandle=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(HandleID)
					Continue:'$IsObject(objHandle)
					Set IsActive=objHandle.CHBIsActive
					Continue:IsActive'=1
					
					Set TargetDept=objHandle.CHBTargetDept
					Continue:(aLocID'="")&&(TargetDept'=aLocID)
					Set TargetWard=objHandle.CHBTargetWard
					Continue:(aWardID'="")&&(TargetWard'=aWardID)
					
					Set Operation=objHandle.CHBOperation
					Continue:(Operation'=4)
					Set CancelDate=objHandle.CHBCancelDate
					Continue:(CancelDate'="")
					Set ActDate=objHandle.CHBActDate
					Set ActTime=objHandle.CHBActTime
					Set ActUser=objHandle.CHBActUser
					Set Opinion=objHandle.CHBOpinion
					
					Set CurrStatus=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(CurrStatus)
					Set Operation=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(Operation)
					Set ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
					Set ActTime=$zt(ActTime,2)
					Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",ActUser)),"^",2)
					Set:TargetDept'="" TargetDept=$p($g(^CTLOC(TargetDept)),"^",2)
					Set:$p(TargetDept,"-",2)'="" TargetDept=$p(TargetDept,"-",2)
					Set:TargetWard'="" TargetWard=$p($g(^CTLOC(TargetWard)),"^",2)
					Set:$p(TargetWard,"-",2)'="" TargetWard=$p(TargetWard,"-",2)
					
					Set Data=..BuildData(EpisodeID)
					Continue:Data=""
					Set Data=Data_$lb("HB"_HandleID,CurrStatus,Operation,ActDate,ActTime,ActUser,TargetDept,TargetWard,Opinion)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} Else {
		//院感处置情况：疑似未处理、消息未阅读、确诊未上报
		For xDate=aFromDate:1:aToDate {
			Set xCasesID=""
			For {
				Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("HA","IndexActDate",xDate,xCasesID))
				Quit:xCasesID=""
				
				Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
				Continue:'$IsObject(objCases)
				Set IsActive=objCases.CSIsActive
				Continue:IsActive'=1
				Set SubjectCode=objCases.CSSubjectCode
				Continue:aConfigCode'=SubjectCode
				Set EpisodeID=objCases.CSEpisodeID
				
				Set HandleAOper=objCases.CSHandleAOper
				Set HandleADate=objCases.CSHandleADate
				Set HandleATime=objCases.CSHandleATime
				Set HandleBOper=objCases.CSHandleBOper
				Set HandleBDate=objCases.CSHandleBDate
				Set HandleBTime=objCases.CSHandleBTime
				Set HandleType="A"
				If (HandleADate="")&&(HandleBDate'="") {
					Set HandleType="B"
				} ElseIf (HandleADate'="")&&(HandleBDate'="") {
					If (HandleADate<HandleBDate){
						Set HandleType="B"
					} ElseIf (HandleADate=HandleBDate)&&(HandleATime<HandleBTime){
						Set HandleType="B"
					} Else {}
				} Else {}
				Set:HandleType="A" CurrStatus=HandleAOper
				Set:HandleType="B" CurrStatus=HandleBOper
				
				//是否报卡
				Set IsReport=0
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xRepID))
					Quit:xRepID=""
				
					Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
					Continue:'$IsObject(objReport)
					Continue:'$IsObject(objReport.ReportType)
					Continue:'$IsObject(objReport.ReportStatus)
					Continue:objReport.ReportType.Code'="COMP"
					Set RepStatus=objReport.ReportStatus.Code
					Continue:(RepStatus=0)||(RepStatus=1)
				
					Set IsReport=1
				}
				
				Set xHandleID=""
				For {
					Set xHandleID=$o(^DHCMed.NINF.BC.CasesI("HA","IndexActDate",xDate,xCasesID,xHandleID))
					Quit:xHandleID=""
					
					Set HandleID=xCasesID_"||"_xHandleID
					Set objHandle=##class(DHCMed.NINF.BC.CasesHandleA).GetObjById(HandleID)
					Continue:'$IsObject(objHandle)
					Set IsActive=objHandle.CHAIsActive
					Continue:IsActive'=1
					
					Set TargetDept=objHandle.CHATargetDept
					Continue:(aLocID'="")&&(TargetDept'=aLocID)
					Set TargetWard=objHandle.CHATargetWard
					Continue:(aWardID'="")&&(TargetWard'=aWardID)
					
					Set Operation=objHandle.CHAOperation
					Continue:(Operation=1)||(Operation=5)
					If Operation=4 {
						Set CancelDate=objHandle.CHACancelDate
						Continue:(CancelDate'="")
					} Else {
						Set ActDate=objHandle.CHAActDate
						Set ActTime=objHandle.CHAActTime
						Continue:(ActDate<HandleADate)
						Continue:(ActDate=HandleADate)&&(ActTime<HandleATime)
						Continue:(ActDate<HandleBDate)
						Continue:(ActDate=HandleBDate)&&(ActTime<HandleBTime)
						Continue:(Operation=3)&&(IsReport=1)
					}
					Set ActDate=objHandle.CHAActDate
					Set ActTime=objHandle.CHAActTime
					Set ActUser=objHandle.CHAActUser
					Set Opinion=objHandle.CHAOpinion
					
					Set CurrStatus=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(CurrStatus)
					Set Operation=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(Operation)
					Set ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
					Set ActTime=$zt(ActTime,2)
					Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",ActUser)),"^",2)
					Set:TargetDept'="" TargetDept=$p($g(^CTLOC(TargetDept)),"^",2)
					Set:$p(TargetDept,"-",2)'="" TargetDept=$p(TargetDept,"-",2)
					Set:TargetWard'="" TargetWard=$p($g(^CTLOC(TargetWard)),"^",2)
					Set:$p(TargetWard,"-",2)'="" TargetWard=$p(TargetWard,"-",2)
					
					Set Data=..BuildData(EpisodeID)
					Continue:Data=""
					Set Data=Data_$lb("HA"_HandleID,CurrStatus,Operation,ActDate,ActTime,ActUser,TargetDept,TargetWard,Opinion)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
		
		//临床处置情况：确诊未报卡
		For xDate=aFromDate:1:aToDate {
			Set xCasesID=""
			For {
				Set xCasesID=$o(^DHCMed.NINF.BC.CasesI("HB","IndexActDate",xDate,xCasesID))
				Quit:xCasesID=""
				
				Set objCases=##class(DHCMed.NINF.BC.Cases).GetObjById(xCasesID)
				Continue:'$IsObject(objCases)
				Set IsActive=objCases.CSIsActive
				Continue:IsActive'=1
				Set SubjectCode=objCases.CSSubjectCode
				Continue:aConfigCode'=SubjectCode
				Set EpisodeID=objCases.CSEpisodeID
				
				Set HandleAOper=objCases.CSHandleAOper
				Set HandleADate=objCases.CSHandleADate
				Set HandleATime=objCases.CSHandleATime
				Set HandleBOper=objCases.CSHandleBOper
				Set HandleBDate=objCases.CSHandleBDate
				Set HandleBTime=objCases.CSHandleBTime
				Set HandleType="A"
				If (HandleADate="")&&(HandleBDate'="") {
					Set HandleType="B"
				} ElseIf (HandleADate'="")&&(HandleBDate'="") {
					If (HandleADate<HandleBDate){
						Set HandleType="B"
					} ElseIf (HandleADate=HandleBDate)&&(HandleATime<HandleBTime){
						Set HandleType="B"
					} Else {}
				} Else {}
				Set:HandleType="A" CurrStatus=HandleAOper
				Set:HandleType="B" CurrStatus=HandleBOper
				
				//是否报卡
				Set IsReport=0
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xRepID))
					Quit:xRepID=""
				
					Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
					Continue:'$IsObject(objReport)
					Continue:'$IsObject(objReport.ReportType)
					Continue:'$IsObject(objReport.ReportStatus)
					Continue:objReport.ReportType.Code'="COMP"
					Set RepStatus=objReport.ReportStatus.Code
					Continue:(RepStatus=0)||(RepStatus=1)
				
					Set IsReport=1
				}
				
				Set xHandleID=""
				For {
					Set xHandleID=$o(^DHCMed.NINF.BC.CasesI("HB","IndexActDate",xDate,xCasesID,xHandleID))
					Quit:xHandleID=""
					
					Set HandleID=xCasesID_"||"_xHandleID
					Set objHandle=##class(DHCMed.NINF.BC.CasesHandleB).GetObjById(HandleID)
					Continue:'$IsObject(objHandle)
					Set IsActive=objHandle.CHBIsActive
					Continue:IsActive'=1
					
					Set TargetDept=objHandle.CHBTargetDept
					Continue:(aLocID'="")&&(TargetDept'=aLocID)
					Set TargetWard=objHandle.CHBTargetWard
					Continue:(aWardID'="")&&(TargetWard'=aWardID)
					
					Set Operation=objHandle.CHBOperation
					Continue:(Operation'=3)
					Set ActDate=objHandle.CHBActDate
					Set ActTime=objHandle.CHBActTime
					Continue:(ActDate<HandleADate)
					Continue:(ActDate=HandleADate)&&(ActTime<HandleATime)
					Continue:(ActDate<HandleBDate)
					Continue:(ActDate=HandleBDate)&&(ActTime<HandleBTime)
					Continue:(Operation=3)&&(IsReport=1)
					
					Set ActDate=objHandle.CHBActDate
					Set ActTime=objHandle.CHBActTime
					Set ActUser=objHandle.CHBActUser
					Set Opinion=objHandle.CHBOpinion
					
					Set CurrStatus=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(CurrStatus)
					Set Operation=##class(DHCMed.NINFService.BC.CommonSrv).GetHandleGradeByCode(Operation)
					Set ActDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ActDate)
					Set ActTime=$zt(ActTime,2)
					Set:ActUser'="" ActUser=$p($g(^SSU("SSUSR",ActUser)),"^",2)
					Set:TargetDept'="" TargetDept=$p($g(^CTLOC(TargetDept)),"^",2)
					Set:$p(TargetDept,"-",2)'="" TargetDept=$p(TargetDept,"-",2)
					Set:TargetWard'="" TargetWard=$p($g(^CTLOC(TargetWard)),"^",2)
					Set:$p(TargetWard,"-",2)'="" TargetWard=$p(TargetWard,"-",2)
					
					Set Data=..BuildData(EpisodeID)
					Continue:Data=""
					Set Data=Data_$lb("HB"_HandleID,CurrStatus,Operation,ActDate,ActTime,ActUser,TargetDept,TargetWard,Opinion)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
		
	Quit $$$OK
}

ClassMethod QryInfQmissionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfQmissionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfQmissionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfQmissionExecute ]
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

}
