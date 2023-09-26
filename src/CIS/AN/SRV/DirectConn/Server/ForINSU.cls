/// 医保首页接口
Class CIS.AN.SRV.DirectConn.Server.ForINSU Extends %RegisteredObject
{

/// Version of My Service For INSU.
Parameter Version = "0.1.0";

/// Name of the WebService.
Parameter SERVICENAME = "AISAPIForINSU";

/// 4401 住院病案首页信息
ClassMethod Get4401OperInfo(request As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set adaptor=##class(CIS.AN.SRV.DirectConn.Adaptor).Create()
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Assembler.INSU.OperInfo"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName="CIS.AN.DTO.INSU.OperScheduleInfo"
	do adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	set response=adaptor.Receive(deserilizedRequest)
	
	Quit response.ToXML()
}

/// 4701  电子病历上传  手术记录
ClassMethod Get4701OperRecord(request As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set adaptor=##class(CIS.AN.SRV.DirectConn.Adaptor).Create()
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Assembler.INSU.OperRecord"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName="CIS.AN.DTO.INSU.OperRecord"
	do adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	set response=adaptor.Receive(deserilizedRequest)
	
	Quit response.ToXML()
}

/// 4701  电子病历上传  手术记录
ClassMethod Get4302EmergencyOperInfo(request As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set adaptor=##class(CIS.AN.SRV.DirectConn.Adaptor).Create()
	set options={}
	set options.TargetAddress="CIS.AN.SRV.Assembler.INSU.EmergencyOperInfo"
	set options.TargetMethod="Query"
	set options.Purpose="Query"
	set options.ContentNode="Arguments"
	set options.ModelName="CIS.AN.DTO.INSU.EmergencyOperInfo"
	do adaptor.SetOptions(options)
	
	set deserilizedRequest=##class(CIS.AN.DTO.ENS.Request).CloneFromXML(request,"Arguments")
	set response=adaptor.Receive(deserilizedRequest)
	
	Quit response.ToXML()
}

}
