/// 药学项子类
Class DHCCL.Code.DrugSubCat Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DrugSubCat ]
{

Property DrugCategory As DHCCL.Code.DrugCategory [ Required, SqlColumnNumber = 2 ];

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

Property ExternalID As %String [ SqlColumnNumber = 5 ];

Index DrgCat On DrugCategory;

Index Code On Code [ Unique ];

Index Ext On ExternalID;

ForeignKey FKDrugCategory(DrugCategory) References DHCCL.Code.DrugCategory() [ OnDelete = cascade ];

Storage Default
{
<Data name="DrugSubCatDefaultData">
<Value name="1">
<Value>DrugCategory</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.DrugSubCatD</DataLocation>
<DefaultData>DrugSubCatDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.DrugSubCatD</IdLocation>
<IndexLocation>^DHCCL.Code.DrugSubCatI</IndexLocation>
<StreamLocation>^DHCCL.Code.DrugSubCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
