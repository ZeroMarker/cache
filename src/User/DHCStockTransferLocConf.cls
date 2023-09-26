Class User.DHCStockTransferLocConf Extends (%Persistent, User.Abstract) [ SqlRowIdName = STLOC_RowId, SqlTableName = DHC_StockTransferLocConf, StorageStrategy = SqlStorage1 ]
{

Property STLOCCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = STLOC_CTLOC_DR ];

Property STLOCFrLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = STLOC_FrLoc_DR ];

Property STLOCDateFrom As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = STLOC_DateFrom ];

Property STLOCDateTo As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = STLOC_DateTo ];

Property STLOCDefault As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = STLOC_Default ];

/// 安全组
Property STLOCGroupDR As User.SSGroup [ SqlColumnNumber = 7, SqlFieldName = STLOC_Group_DR ];

/// 类型（供货科室F，接收科室T）
Property STLOCType As %Library.String [ SqlColumnNumber = 8, SqlFieldName = STLOC_Type ];

Storage SqlStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCSTLOCCONF)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="STLOC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STLOC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STLOC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STLOC_Default">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="STLOC_FrLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STLOC_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STLOC_Type">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCSTLOCCONF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>STLOC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{STLOC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFrLoc">
<Global>^DHCSTLOCCONF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STLOC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FrLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STLOC_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STLOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTGroup">
<Global>^DHCSTLOCCONF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STLOC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STLOC_Group_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STLOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSTLOC">
<Global>^DHCSTLOCCONF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>STLOC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STLOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STLOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeFrLoc">
<Global>^DHCSTLOCCONF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STLOC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeFrLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STLOC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STLOC_FrLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STLOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeLoc">
<Global>^DHCSTLOCCONF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STLOC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{STLOC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{STLOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STLOC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STLOC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStockTransferLocConfS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTLOCCONF)
	s oldI = +$g(^mdata("DHCSTOCKTRANSFERLOCCONF"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTLOCCONF = maxI
	s ^mdata("DHCSTOCKTRANSFERLOCCONF") = maxI
}

}
