Class DWR.ORD.MSG.RISReportQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 分组方式
Property GroupBy As %String(TRUNCATE = 1);

Storage Default
{
<Data name="RISReportQryRtDefaultData">
<Subscript>"RISReportQryRt"</Subscript>
<Value name="1">
<Value>EpisodeID</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
</Data>
<DefaultData>RISReportQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
