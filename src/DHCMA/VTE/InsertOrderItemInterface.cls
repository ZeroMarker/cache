/// DHCMA.VTE.InsertOrderItemInterface
Class DHCMA.VTE.InsertOrderItemInterface Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "InsertOrderItem";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// InsertOrderItem
Method InsertOrderItem(admId As %String, UserID As %String, userDeptId As %String, ArcimID As %String, OrderPrice As %String) As %String [ WebMethod ]
{
	s reg = ##class(DHCMA.VTE.VteToClinicInterface).insertOrderItem(admId,UserID,userDeptId,ArcimID,OrderPrice)
	Q:(reg=0)!(reg=100) "插入医嘱失败"
	
	Quit "插入医嘱成功"
}

}
