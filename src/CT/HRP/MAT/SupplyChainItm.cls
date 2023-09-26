Class CT.HRP.MAT.SupplyChainItm Extends (%Persistent, User.Abstract) [ SqlTableName = SupplyChainItm ]
{

Relationship SCIParRef As CT.HRP.MAT.SupplyChain [ Cardinality = parent, Inverse = Itm, Required, SqlFieldName = SCI_ParRef ];

Property SCIINCIDR As User.INCItm [ Required, SqlColumnNumber = 2, SqlFieldName = SCI_INCI_DR ];

Index INCI On (SCIINCIDR As Exact, SCIParRef As Exact);

Storage Default
{
<Data name="SupplyChainItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCIINCIDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Itm")</DataLocation>
<DefaultData>SupplyChainItmDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Itm")</IdLocation>
<IndexLocation>^CT.HRP.MAT.SupplyChainItmI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.SupplyChainItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
