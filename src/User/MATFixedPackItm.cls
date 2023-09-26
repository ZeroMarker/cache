Class User.MATFixedPackItm Extends (%Persistent, User.Abstract) [ SqlTableName = MAT_FixedPackItm ]
{

Relationship MATFPIParRef As User.MATFixedPack [ Cardinality = parent, Inverse = ChildMATFixedPackItm, Required, SqlFieldName = MATFPI_MATFP_ParRef ];

Property MATFPIINCIBDR As User.INCItmBat [ SqlColumnNumber = 2, SqlFieldName = MATFPI_INCIB_DR ];

/// 数量
Property MATFPIQty As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = MATFPI_Qty ];

Storage Default
{
<Data name="MATFixedPackItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MATFPIINCIBDR</Value>
</Value>
<Value name="3">
<Value>MATFPIQty</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildItm")</DataLocation>
<DefaultData>MATFixedPackItmDefaultData</DefaultData>
<IdLocation>^User.MATFixedPackC("ChildItm")</IdLocation>
<IndexLocation>^User.MATFixedPackItmI</IndexLocation>
<StreamLocation>^User.MATFixedPackItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
