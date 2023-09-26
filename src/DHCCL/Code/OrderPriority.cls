/// 医嘱优先级
Class DHCCL.Code.OrderPriority Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OrderPriority ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property Priority As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property Color As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property ExternalID As %String [ SqlColumnNumber = 6 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="OrderPriorityDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Priority</Value>
</Value>
<Value name="4">
<Value>Color</Value>
</Value>
<Value name="5">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.OrderPriorityD</DataLocation>
<DefaultData>OrderPriorityDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.OrderPriorityD</IdLocation>
<IndexLocation>^DHCCL.Code.OrderPriorityI</IndexLocation>
<StreamLocation>^DHCCL.Code.OrderPriorityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
