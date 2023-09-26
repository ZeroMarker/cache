/// 医嘱项分类
Class DHCCL.Config.OrderCategory Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OrderCategory ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ExternalID As %String [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="OrderCategoryDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.OrderCategoryD</DataLocation>
<DefaultData>OrderCategoryDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.OrderCategoryD</IdLocation>
<IndexLocation>^DHCCL.Config.OrderCategoryI</IndexLocation>
<StreamLocation>^DHCCL.Config.OrderCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
