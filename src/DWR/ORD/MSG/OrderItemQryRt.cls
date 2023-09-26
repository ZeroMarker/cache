/// 医嘱记录查询
Class DWR.ORD.MSG.OrderItemQryRt Extends (%RegisteredObject, XT.Common.Msg.Request, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 开始日期    (YYYY-MM-DD)
Property StartDate As %String(TRUNCATE = 1);

/// 结束日期    (YYYY-MM-DD)
Property EndDate As %String(TRUNCATE = 1);

/// 分组方式
Property GroupBy As %String(TRUNCATE = 1);

Storage Default
{
<Data name="OrderItemQryRtDefaultData">
<Subscript>"OrderItemQryRt"</Subscript>
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
</Data>
<DefaultData>OrderItemQryRtDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
