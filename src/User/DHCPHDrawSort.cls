Class User.DHCPHDrawSort Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDWS_RowID, SqlTableName = DHC_PHDrawSort, StorageStrategy = SQLStorage ]
{

/// 规则描述
Property PHDWSDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHDWS_Desc ];

/// 规则代码
Property PHDWSCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHDWS_Code ];

/// 药房科室
Property PHDWSPHLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHDWS_PHLoc_Dr ];

Relationship ChildDHCPHDrawSortItm As User.DHCPHDrawSortItm [ Cardinality = children, Inverse = PHDWSIPHDWSParref ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHDWSORT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHDWS_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHDWS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHDWS_PHLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHDWSORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHDWS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHDWS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPHDWSORTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDWS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PHDWS_Code})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDWS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPHDWSORTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHDWS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PHDWS_Desc})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDWS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHLoc">
<Global>^DHCPHDWSORTi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{PHDWS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHDWS_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDWS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.DHCPHDrawSortS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHDWSORT)
	s oldI = +$g(^mdata("DHCPHDRAWSORT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHDWSORT = maxI
	s ^mdata("DHCPHDRAWSORT") = maxI
}

}
