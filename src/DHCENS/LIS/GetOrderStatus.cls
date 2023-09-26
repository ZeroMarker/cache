Class DHCENS.LIS.GetOrderStatus Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "GetOrderStatusReturn";

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

/// 医嘱状态
Property Status As %String;

/// 收费状态
Property BillStatus As %String;

/// 查询医嘱的状态
/// 查询医嘱状态XML
ClassMethod GetOrderStatusXml(OrdID As %String) As %GlobalCharacterStream
{
	s obj=##class(DHCENS.LIS.GetOrderStatus).%New()
	s obj.Status=##class(DHCENS.Method.BaseMethod).GetOrderStatus(OrdID)
	s obj.BillStatus=##class(DHCENS.Method.BaseMethod).GetOrderBillStatus(OrdID)
	s obj.ResultCode="0"
	s obj.ResultContent="成功!!"
	s Status=obj.XMLExportToStream(.Xml)
    s objStream=##class(%GlobalCharacterStream).%New()
    d objStream.Write("<Response>")
    d objStream.CopyFrom(Xml)
    d objStream.Write("</Response>")
	q objStream
}

}
