Class User.DHCPHConsultType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCONT_RowID, SqlTableName = DHC_PHConsultType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHCONT_Code
Property PHCONTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHCONT_Code ];

/// PHCONT_Desc
Property PHCONTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHCONT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHCONT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHCONT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCONT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHCONT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCONT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHCONT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHCONT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCONT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PHCONT_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCONT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHConsultTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCONT)
	s oldI = +$g(^mdata("DHCPHCONSULTTYPE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCONT = maxI
	s ^mdata("DHCPHCONSULTTYPE") = maxI
}

}
