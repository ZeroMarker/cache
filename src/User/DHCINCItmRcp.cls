Class User.DHCINCItmRcp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INREC_RowId, SqlTableName = DHC_INCItmRcp, StorageStrategy = SQLStorage ]
{

/// INCItmRcp 表id
Property INRECINRECDR As User.INCItmRcp [ SqlColumnNumber = 2, SqlFieldName = INREC_INREC_Dr ];

Property INRECDifferential As %Library.String [ SqlColumnNumber = 3, SqlFieldName = INREC_Differential ];

/// Des Ref to CTCUR
Property INRECCProfitRatio As %Library.String [ SqlColumnNumber = 4, SqlFieldName = INREC_CProfitRatio ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINREC)</SqlIdExpression>
<SQLMap name="IndexINREC">
<Global>^DHCINREC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INREC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INREC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INREC_INREC_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="INREC_CProfitRatio">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INREC_Differential">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INREC_INREC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCINREC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INREC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INREC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINCItmRcpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINREC)
	s oldI = +$g(^mdata("DHCINCItmRcp"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINREC = maxI
	s ^mdata("DHCINCItmRcp") = maxI
}

}
