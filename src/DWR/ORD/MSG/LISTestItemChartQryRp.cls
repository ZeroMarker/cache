Class DWR.ORD.MSG.LISTestItemChartQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Property LISTestItemList As list Of DWR.ORD.MSG.LISTestItem(XMLNAME = "LISTestItemList");

Storage Default
{
<Data name="LISTestItemChartQryRpDefaultData">
<Subscript>"LISTestItemChartQryRp"</Subscript>
<Value name="1">
<Value>LISTestItemList</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
</Data>
<DefaultData>LISTestItemChartQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
