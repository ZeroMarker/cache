/// 检验报告查询
Class DWR.ORD.MSG.LISReportQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 分组方式
Property GroupBy As %String(TRUNCATE = 1);

Storage Default
{
<Data name="LISReportQryRtDefaultData">
<Subscript>"LISReportQryRt"</Subscript>
<Value name="1">
<Value>EpisodeID</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
</Data>
<DefaultData>LISReportQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
