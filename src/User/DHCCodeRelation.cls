Class User.DHCCodeRelation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CODEREL_RowId, SqlTableName = DHC_CodeRelation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property CODERELINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = CODEREL_INCI_DR ];

Property CODERELTRCODE As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CODEREL_TRCode ];

//Property CODERELPbNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CODEREL_Pbno ];

//Property CODERELChangeRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CODEREL_ChangeRate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTRCODEREL)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="CODEREL_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CODEREL_TRCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCTRCODEREL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CODEREL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CODEREL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCTRCODEREL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CODEREL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CODEREL_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODEREL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTRCODE">
<Global>^DHCTRCODEREL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CODEREL_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRCODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CODEREL_TRCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODEREL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCodeRelationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCTRCODEREL)
	s oldI = +$g(^mdata("DHCTRCODEREL"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCTRCODEREL = maxI
	s ^mdata("DHCTRCODEREL") = maxI
}

}
