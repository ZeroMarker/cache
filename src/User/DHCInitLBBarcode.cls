Class User.DHCInitLBBarcode Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = ILBB_Rowid, SqlTableName = DHC_InitLBBarcode, StorageStrategy = SQLStorage ]
{

Property ILBBInititmDr As User.DHCInIsTrfItm [ SqlColumnNumber = 2, SqlFieldName = ILBB_Inititm_Dr ];

Property ILBBBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ILBB_Barcode ];

Property ILBBInclbDR As User.INCItmLcBt [ SqlColumnNumber = 4, SqlFieldName = ILBB_Inclb_DR ];

Property ILBBToLocInclbDR As User.INCItmLcBt [ SqlColumnNumber = 5, SqlFieldName = ILBB_ToLocInclb_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCILBB)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ILBB_Barcode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILBB_Inclb_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ILBB_Inititm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ILBB_ToLocInclb_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCILBB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILBB_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ILBB_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ILBB_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCInitLBBarcodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCILBB)
	s oldI = +$g(^mdata("DHCINITLBBARCODE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCILBB = maxI
	s ^mdata("DHCINITLBBARCODE") = maxI
}

}
