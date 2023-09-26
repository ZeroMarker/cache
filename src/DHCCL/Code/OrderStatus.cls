/// 医嘱状态
Class DHCCL.Code.OrderStatus Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OrderStatus ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property Active As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

Property ExternalID As %String [ SqlColumnNumber = 5 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="OrderStatusDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.OrderStatusD</DataLocation>
<DefaultData>OrderStatusDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.OrderStatusD</IdLocation>
<IndexLocation>^DHCCL.Code.OrderStatusI</IndexLocation>
<StreamLocation>^DHCCL.Code.OrderStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
