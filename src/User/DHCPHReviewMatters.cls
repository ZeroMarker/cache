Class User.DHCPHReviewMatters Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHRM_RowID, SqlTableName = DHC_PHReviewMatters, StorageStrategy = NewStorage1 ]
{

Parameter EXTENTSIZE = 250;

/// DSD_Code
Property PHRMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHRM_Code ];

/// DSD_Desc
Property PHRMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHRM_Desc ];

Storage NewStorage1
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHRM)</SqlIdExpression>
<SQLMap name="Data">
<Data name="PHRM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHRM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHRM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHRM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHRM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHRM_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHReviewMattersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHRM)
	s oldI = +$g(^mdata("^DHCPHRM"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHRM = maxI
	s ^mdata("^DHCPHRM") = maxI
}

}
