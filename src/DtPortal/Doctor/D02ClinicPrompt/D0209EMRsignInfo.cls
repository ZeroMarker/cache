/// 待签病例列表
Class DtPortal.Doctor.D02ClinicPrompt.D0209EMRsignInfo Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// creator    :  bmz
/// date       :  20181104
/// description: 待签病例   调用病例组提供的query，DtPortal.Doctor.EMRInfoService GetEMRsignInfo
/// input      : UserCode
/// output     :  待签病例患者相关信息
///              
/// debug       :  d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D02ClinicPrompt.D0209EMRsignInfo","D020901EMRsignList","601")
Query D020901EMRsignList(UserCode As %String) As DtPortal.Query(ROWSPEC = "BedNum:%String,EpisodeID:%String,PapmiNO:%String,PapmiName:%String,DoucumnetDesc:%String,InstanceID:%String,SignUserName:%String,EMRStatus:%String,DocID:%String,MedicareNo:%String,AdmReason:%String,Sex:%String,Age:%String,PatientID,LocID,UserId")
{
}

ClassMethod D020901EMRsignListExecute(ByRef qHandle As %Binary, UserCode As %String) As %Status
{
	new (qHandle,UserCode)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	set obj=##class(%ResultSet).%New("EMRservice.InterfaceService.WaitSign:GetEMRWaitSign")
	d obj.Execute(UserId)
	f  Quit:'obj.Next()  d
	.s (BedNum,EpisodeID,PapmiNO,PapmiName,DoucumnetDesc,InstanceID,SignUserName,EMRStatus,DocID,MedicareNo,AdmReason,Sex,Age)=""
	
	.s EpisodeID=obj.Data("EpisodeID")
	.s DoucumnetDesc=obj.Data("DoucumnetDesc")
	.s InstanceID=obj.Data("InstanceID")
	.s SignUserName=obj.Data("SignUserName")
	.s EMRStatus=obj.Data("EMRStatus")
	.s DocID=obj.Data("DocID")
	.s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	.s BedNum=$p(patInfoStr,"^",1)
	.s PapmiName=$p(patInfoStr,"^",2)
	.s Sex=$p(patInfoStr,"^",3)
	.s Age=$p(patInfoStr,"^",4)
	.s MedicareNo=$p(patInfoStr,"^",5)   //病案号
	.s AdmReason=$p(patInfoStr,"^",6)    //费用类型
	.s PapmiNO=$p(patInfoStr,"^",7)    //登记号
	.s PatientID=$p(patInfoStr,"^",8)    //病人基本信息ID
	.s LocID=$p(patInfoStr,"^",9)    //病人科室
	.d output
	
	

	Set qHandle=$lb(0,repid,0)
	quit $$$OK
	
output	

	Set ^||CacheTemp(repid,ind)=$lb(BedNum,EpisodeID,PapmiNO,PapmiName,DoucumnetDesc,InstanceID,SignUserName,EMRStatus,DocID,MedicareNo,AdmReason,Sex,Age,PatientID,LocID,UserId)
	Set ind=ind+1
	Quit
}

}
