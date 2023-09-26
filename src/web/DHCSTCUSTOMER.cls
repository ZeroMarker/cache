Import SQLUser

Class web.DHCSTCUSTOMER Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetCustomer() As %String
{
	n HosCode
	s HosCode=$O(^STCUS(0,"FLAG","Y",""))
	i HosCode'="" s HosCode=$$ALPHAUP^SSUTIL4(HosCode)
	q HosCode
}

ClassMethod GetCustomerDesc() As %String
{
	n HosCode,HosDesc
	s HosDesc=""
	s HosCode=$O(^STCUS(0,"FLAG","Y",""))
	i HosCode'="" s HosDesc=$O(^STCUS(0,"FLAG","Y",HosCode,""))
	q HosDesc
}

/// Descript：	取医院相关信息
/// Creater：	zhouyg
/// CreateDate:	2011-03-08
ClassMethod GetCustomerStr() As %String
{
 n HosCode,HosDesc,HosID
 s HosDesc="",HosID="",RetCust=""
 s HosCode=$O(^STCUS(0,"FLAG","Y",""))
 i HosCode'="" D
 .s HosDesc=$O(^STCUS(0,"FLAG","Y",HosCode,""))
 .S HosID=$O(^STCUS(0,"FLAG","Y",HosCode,HosDesc,""))
 .S RetCust=HosID_"^"_$G(^STCUS(HosID))
 q RetCust
}

}
