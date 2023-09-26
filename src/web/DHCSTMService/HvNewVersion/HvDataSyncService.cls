/// web.DHCSTMHUI.HvInScrapNew
Class web.DHCSTMService.HvNewVersion.HvDataSyncService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "HvDataSyncService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	s rtn="Test Success!"
	Quit rtn
}

/// Description：在新库生成单据,目前只有调整单
/// Table：
/// Input：Lable,ListData,Type
/// Return：状态
/// Others
ClassMethod CreateInfoHvForNew(Lable As %String, ListData As %String, Type As %String = "") As %String [ WebMethod ]
{
	set Ret=##class(web.DHCSTMService.HvNewVersion.HvDataSync).CreateInfoHvForNew(Lable,ListData,Type)
	q Ret
}

}
