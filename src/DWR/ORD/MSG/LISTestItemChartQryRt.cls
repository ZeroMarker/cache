/// 检验项图表分析数据查询
Class DWR.ORD.MSG.LISTestItemChartQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 检验项目代码
Property TestItemCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="LISTestItemChartQryRtDefaultData">
<Subscript>"LISTestItemChartQryRt"</Subscript>
<Value name="1">
<Value>EpisodeID</Value>
</Value>
<Value name="2">
<Value>TestItemCode</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
</Data>
<DefaultData>LISTestItemChartQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
