/// 医嘱项子类
Class DHCCL.Code.DrugMinorCat Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DrugMinorCat ]
{

Property DrugSubCat As DHCCL.Code.DrugSubCat [ Required, SqlColumnNumber = 2 ];

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4 ];

Property ExternalID As %String [ SqlColumnNumber = 5 ];

Index DrgSubCat On DrugSubCat;

Index Code On Code [ Unique ];

Index Ext On ExternalID;

ForeignKey FKDrugSubCat(DrugSubCat) References DHCCL.Code.DrugSubCat() [ OnDelete = cascade ];

Storage Default
{
<Data name="DrugMinorCatDefaultData">
<Value name="1">
<Value>DrugSubCat</Value>
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
<DataLocation>^DHCCL.Code.DrugMinorCatD</DataLocation>
<DefaultData>DrugMinorCatDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.DrugMinorCatD</IdLocation>
<IndexLocation>^DHCCL.Code.DrugMinorCatI</IndexLocation>
<StreamLocation>^DHCCL.Code.DrugMinorCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
