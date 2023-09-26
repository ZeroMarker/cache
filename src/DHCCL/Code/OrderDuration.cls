Class DHCCL.Code.OrderDuration Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OrderDuration ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property LocalDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ForeignDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property Factor As %Float [ Required, SqlColumnNumber = 5 ];

Property ActiveDate As %Date [ SqlColumnNumber = 6 ];

Property ExpireDate As %Date [ SqlColumnNumber = 7 ];

Property ExternalID As %String [ SqlColumnNumber = 8 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="OrderDurationDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>LocalDesc</Value>
</Value>
<Value name="3">
<Value>ForeignDesc</Value>
</Value>
<Value name="4">
<Value>Factor</Value>
</Value>
<Value name="5">
<Value>ActiveDate</Value>
</Value>
<Value name="6">
<Value>ExpireDate</Value>
</Value>
<Value name="7">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.OrderDurationD</DataLocation>
<DefaultData>OrderDurationDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.OrderDurationD</IdLocation>
<IndexLocation>^DHCCL.Code.OrderDurationI</IndexLocation>
<StreamLocation>^DHCCL.Code.OrderDurationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
