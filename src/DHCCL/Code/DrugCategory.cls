/// 药学项分类
Class DHCCL.Code.DrugCategory Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DrugCategory ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ExternalID As %String [ SqlColumnNumber = 4 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="DrugCategoryDefaultData">
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
<DataLocation>^DHCCL.Code.DrugCategoryD</DataLocation>
<DefaultData>DrugCategoryDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.DrugCategoryD</IdLocation>
<IndexLocation>^DHCCL.Code.DrugCategoryI</IndexLocation>
<StreamLocation>^DHCCL.Code.DrugCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
