Class DWR.ORD.MSG.OrderItemQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 医嘱记录分组列表
Property OrderItemGroupList As list Of DWR.ORD.MSG.OrderItemGroup(XMLNAME = "OrderItemGroupList");

Storage Default
{
<Data name="OrderItemQryRpDefaultData">
<Subscript>"OrderItemQryRp"</Subscript>
<Value name="1">
<Value>OrderItems</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
<Value name="4">
<Value>OrderItemList</Value>
</Value>
</Data>
<DefaultData>OrderItemQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
