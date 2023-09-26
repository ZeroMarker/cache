/// CIS.AN.SRV.WebService.SyncSurgenOperation
Class CIS.AN.SRV.WebService.SyncSurgenOperation Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "SyncSurgenOperation";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// 同步手术权限
ClassMethod SaveSurgenOperation(Input As %Stream.GlobalCharacter) As %String [ WebMethod ]
{
	Quit ##class(CIS.AN.SRV.SurgenOperService).SaveSurgenOper(Input)
}

/// 查询手术记录
ClassMethod OperationInquiry(Input As %Stream.GlobalCharacter) As %Stream.GlobalCharacter [ WebMethod ]
{
	Quit ##class(CIS.AN.SRV.SurgenOperService).SendOperSchedule(Input)
}

}
