Class DtPortal.Doctor.D02ClinicPrompt.D0208UndoInfectionService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     bmz---封装"DtPortal.Doctor.UndoInfection.MsgService","QryUnreadMsgList2"
/// CreatDate：   2018-11-23
/// Description:  查询当前医生未读医院感染提示列表
/// Table：       DHCMed.NINF.BC.Cases,DHCMed.NINF.Rep.InfReport
/// Input：        aUserCode     ：医生工号(SS_User.SSUSR_Initials)
/// Return：      未读消息列表
/// do ##class(%Library.ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0208UndoInfectionService","D020801QryList","P","ys01")
Query D020801QryList(QueryType As %String, aUserCode As %String) As DtPortal.Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,AdmBed:%String,MsgType:%String,RecordID:%String,PromptMsg:%String,MedicareNo:%String,AdmReason:%String,Age:%String,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID")
{
}

ClassMethod D020801QryListExecute(ByRef qHandle As %Binary, QueryType As %String, aUserCode As %String) As %Status
{
    n (qHandle,QueryType,aUserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	
	
	set obj=##class(%ResultSet).%New("DHCHAI.IO.ToDtPortal04:QryUnreadMsgList2")
	d obj.Execute(QueryType,aUserCode)
    f  Quit:'obj.Next()  d
	.set (UserID,EpisodeID,PapmiNo,PatName,PatSex,AdmBed,MsgType,RecordID,PromptMsg,MedicareNo,AdmReason,Age,PatientID)=""
	.s UserID=obj.Data("UserID")
	.s EpisodeID=obj.Data("EpisodeID")
	.s MsgType=obj.Data("MsgType")
	.s RecordID=obj.Data("RecordID")
	.s PromptMsg=obj.Data("PromptMsg")
	.s PatientID=obj.Data("PatientID")
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	.s AdmBed=$p(patInfoStr,"^",1)
	.s PatName=$p(patInfoStr,"^",2)
	.s PatSex=$p(patInfoStr,"^",3)
	.s Age=$p(patInfoStr,"^",4)
	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
	.s PapmiNo=$p(patInfoStr,"^",7)    //费用类型
	
	.//获取打开电子病历所需要的参数
	.set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
	.set EMRDocID=$p(EMRinfo,"^",1)
	.set EMRInstanceID=$p(EMRinfo,"^",2)
	.set locID=$p(EMRinfo,"^",3)
	.set PatientID=$p(EMRinfo,"^",4)
	.set EMREpisodeID=$p(EMRinfo,"^",5)
	
	.Do OutInfoRow
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutInfoRow
	set Data=$lb(EpisodeID,PapmiNo,PatName,PatSex,AdmBed,MsgType,RecordID,PromptMsg,MedicareNo,AdmReason,Age,EMRDocID,EMRInstanceID,locID,EMREpisodeID,UserID,PatientID)
 	Set ^||CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator：     zhufei  --bmz20181123封装  w ##class(DHCHAI.IO.ToDtPortal04).UnreadMsgHandle("79^3^确诊呼吸机相关性肺炎^中西医结合一科^601")
/// CreatDate：   2014-07-01
/// Description:  处置疑似病例筛查记录
/// Table：       DHCMed.EPD.CasesX
/// Input：       aMsgInput     : 1就诊号，2处置状态(1排除/3确诊)，3科室ID，4用户ID，5处置意见
/// Return：      return>0:成功  return<1:失败
/// w ##class(DtPortal.Doctor.D02ClinicPrompt.D0208UndoInfectionService).D020802MsgHandle("79^3^确诊呼吸机相关性肺炎^中西医结合一科^601")
ClassMethod D020802MsgHandle(aMsgInput As %String) As DtPortal.OutPut
{
	n (aMsgInput)
	q ##class(DHCHAI.IO.ToDtPortal04).UnreadMsgHandle(aMsgInput)
}

}
