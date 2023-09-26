Class DWR.ORD.MSG.RISReportQryRp Extends (%RegisteredObject, XT.Common.Msg.Response, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 检查报告分组列表
Property RISReportGroupList As list Of DWR.ORD.MSG.RISReportGroup(XMLNAME = "RISReportGroupList");

Storage Default
{
<Data name="RISReportQryRpDefaultData">
<Subscript>"RISReportQryRp"</Subscript>
<Value name="1">
<Value>ResultCode</Value>
</Value>
<Value name="2">
<Value>ResultContent</Value>
</Value>
<Value name="3">
<Value>RISReportList</Value>
</Value>
</Data>
<DefaultData>RISReportQryRpDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
