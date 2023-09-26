Class User.DHCSTMAdjErrorLog Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = DHCSTM_RowId, SqlTableName = DHCSTM_AdjErrorLog, StorageStrategy = SQLStorage ]
{

Property DHCSTMADJNo As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCSTM_AdjErrorNo ];

Property DHCSTMAdjType As %Library.String(COLLATION = "Exact", MAXLEN = 920, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCSTM_AdjType ];

Property DHCSTMAdjTitle As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DHCSTM_AdjTitle ];

Property DHCSTMAdjDesc As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DHCSTM_AdjDesc ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCSTMAdjErrorLog)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCSTM_AdjDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCSTM_AdjErrorNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCSTM_AdjTitle">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCSTM_AdjType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTMAdjErrorLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCSTM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCSTM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCSTM_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSTMAdjErrorLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTMAdjErrorLog)
	s oldI = +$g(^mdata("DHCSTMAdjErrorLog"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTMAdjErrorLog = maxI
	s ^mdata("DHCSTMAdjErrorLog") = maxI
}

}
