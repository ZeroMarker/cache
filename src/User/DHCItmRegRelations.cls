Class User.DHCItmRegRelations Extends (%Persistent, User.Abstract) [ SqlRowIdName = IRR_RowId, SqlTableName = DHC_ItmRegRelations ]
{

/// 注册证DR
Property IRRREGCERTDR As User.DHCMatRegCert [ SqlColumnNumber = 2, SqlFieldName = IRR_RegCert_DR ];

/// 库存项DR
Property IRRINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = IRR_INCI_DR ];

Property IRRMCDR As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = IRR_MC_DR ];

Property IRRSADR As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = IRR_SA_DR ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IRRREGCERTDR</Value>
</Value>
<Value name="3">
<Value>IRRINCIDR</Value>
</Value>
<Value name="4">
<Value>IRRMCDR</Value>
</Value>
<Value name="5">
<Value>IRRSADR</Value>
</Value>
</Data>
<DataLocation>^User.DHCItmRegRelationsD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^User.DHCItmRegRelationsD</IdLocation>
<IndexLocation>^User.DHCItmRegRelationsI</IndexLocation>
<SqlRowIdName>IRR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCItmRegRelationsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index Inci On IRRINCIDR As Exact;

Index Reg On IRRREGCERTDR As Exact;

Index InciReg On (IRRINCIDR As Exact, IRRREGCERTDR As Exact);

}
