/// 三测单数据查询
Class DWR.NUR.MSG.ThreeSTDataQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 开始日期    (YYYY-MM-DD)
Property StartDate As %String(TRUNCATE = 1);

/// 结束日期    (YYYY-MM-DD)
Property EndDate As %String(TRUNCATE = 1);

/// 第几周
Property Week As %String(TRUNCATE = 1);

Storage Default
{
<Data name="ThreeSTDataQryRtDefaultData">
<Subscript>"ThreeSTDataQryRt"</Subscript>
<Value name="1">
<Value>EndDate</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>UserID</Value>
</Value>
<Value name="5">
<Value>Week</Value>
</Value>
</Data>
<DefaultData>ThreeSTDataQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
