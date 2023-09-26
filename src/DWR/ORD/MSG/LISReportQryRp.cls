Class DWR.ORD.MSG.LISReportQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 检验报告分组列表
Property LISReportGroupList As list Of DWR.ORD.MSG.LISReportGroup(XMLNAME = "LISReportGroupList");

Storage Default
{
<Data name="LISReportQryRpDefaultData">
<Subscript>"LISReportQryRp"</Subscript>
<Value name="1">
<Value>LISReportList</Value>
</Value>
<Value name="2">
<Value>ResultCode</Value>
</Value>
<Value name="3">
<Value>ResultContent</Value>
</Value>
</Data>
<DefaultData>LISReportQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
