/// 医嘱记录分组
Class DWR.ORD.MSG.OrderItemGroup Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "OrderItemGroup";

/// 分组名称
Property GroupName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 医嘱记录列表
Property OrderItemList As list Of DWR.ORD.MSG.OrderItem(XMLNAME = "OrderItemList");

}
