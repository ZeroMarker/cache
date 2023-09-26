/// ClassName:    DtPortal.Doctor.D02ClinicPrompt.D0207UndoEpidemicService
/// Description:  传染病提示服务
/// Creator：     zhufei
/// CreatDate:    2014-07-01
Class DtPortal.Doctor.D02ClinicPrompt.D0207UndoEpidemicService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     程鹏
/// CreatDate：   2014-07-01
/// Description:  查询当前患者传染病报卡情况列表
/// Table：       DHCMed.EPD.Epidemic
/// Input：       QueryType     查询类型 P 本人 PG本主诊组
/// 			  UserCode 		医生工号
/// Return：      报卡详情
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0207UndoEpidemicService","D020701EPIReportList","P","4829")
Query D020701EPIReportList(QueryType As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "EpisodeID,EpiID,MEPDICDDR,StatusDesc,MEPDRepUsrName,reportDateTime,BedNo,MedicareNo,Name,Sex,Age,AdmReason,ManagerDoc,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserId,PatientID")
{
}

ClassMethod D020701EPIReportListExecute(ByRef qHandle As %Binary, QueryType As %String, UserCode As %String) As %Status
{
	n (qHandle,QueryType,UserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:((QueryType="")||(UserCode="")) $$$OK
	
	Set UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	Quit:UserId="" $$$OK
	
	set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserId,"")
	quit:admPatList="" $$$OK

	for admIndex=1:1:$L(admPatList,"^")
	{
		set EpisodeID=$p(admPatList,"^",admIndex)
		
		set EPIID=$o(^DHCMed.EPDi("EPD",0,"EpisodeID",EpisodeID,""))
		continue:EPIID=""
		
		s EPIInfo=##class(DtPortal.Doctor.D02ClinicPrompt.D0207UndoEpidemicService).GetEPIInfo(EPIID)
		
		s flag=$p(EPIInfo,"^",1)
		continue:flag'=1
		set MEPDICDDR=$p(EPIInfo,"^",2)		//传染病诊断
		set StatusDesc=$p(EPIInfo,"^",3)	//状态描述
		
		s MEPDRepUsrDR=$p(EPIInfo,"^",4)
		s MEPDRepDate=$p(EPIInfo,"^",5)
		s MEPDRepTime=$p(EPIInfo,"^",6)
		
		set reportName="",reportDate="",reportTime="",reportDateTime=""
		set:MEPDRepUsrDR'="" MEPDRepUsrName=$p($g(^SSU("SSUSR",MEPDRepUsrDR)),"^",2)	//上报人
		set:MEPDRepDate'="" reportDate=$zd(MEPDRepDate,3)							//上报日期
		set:MEPDRepTime'="" reportTime=$zt(MEPDRepTime,2)							//上报时间
		set reportDateTime=reportDate_"&nbsp;"_reportTime
		set WardID=$p(^PAADM(EpisodeID),"^",4)
		
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
		s BedNo=$p(patInfoStr,"^",1)
		s MedicareNo=$p(patInfoStr,"^",5)
		s Name=$p(patInfoStr,"^",2)
		s Sex=$p(patInfoStr,"^",3)
		s Age=$p(patInfoStr,"^",4)
		s AdmReason=$p(patInfoStr,"^",6)
		
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EMREpisodeID=$p(EMRinfo,"^",5)
		
		Set Data=$lb(EpisodeID,EPIID,MEPDICDDR,StatusDesc,MEPDRepUsrName,reportDateTime,BedNo,MedicareNo,Name,Sex,Age,AdmReason,ManagerDoc,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserId,PatientID)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
		
	}
	Quit $$$OK
}

/// Creator： 白明哲
/// CreatDate： 2019-2-20
/// Description: 获取传染病相关的数据
/// Input：  AdmId         
/// Return： 1-flag(1-存在  '=1-不存在)   2-MEPDICDDR(传染病诊断) 3-StatusDesc（状态描述） 4-MEPDRepUsrDR  5-MEPDRepDate  6-MEPDRepTime
/// w ##class(DtPortal.Doctor.D02ClinicPrompt.D0207UndoEpidemicService).GetEPIInfo("9")
ClassMethod GetEPIInfo(EPIID) As %String
{
	n (EPIID)
	set EPDObj=##class(DHCMed.EPD.Epidemic).GetObjById(EPIID)
	q:'$IsObject(EPDObj) ""
	s MEPDRepPlace=EPDObj.MEPDRepPlace
	//只取住院
	q:MEPDRepPlace'="I" "" 
	
	set MEPDICDDR=EPDObj.MEPDICDDR.MIFDisease		//传染病诊断
	set MEPDStatus=EPDObj.MEPDStatus
	set Statusobj=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTSTATUS",MEPDStatus,"1")
	q:'$IsObject(Statusobj) ""
	set StatusDesc=Statusobj.Description		//传染病状态
	//过滤删除状态
	q:StatusDesc="删除" ""					
	
	s MEPDRepUsrDR=EPDObj.MEPDRepUsrDR
	s MEPDRepDate=EPDObj.MEPDRepDate
	s MEPDRepTime=EPDObj.MEPDRepTime
	q "1^"_MEPDICDDR_"^"_StatusDesc_"^"_MEPDRepUsrDR_"^"_MEPDRepDate_"^"_MEPDRepTime
}

}
