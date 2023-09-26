Class User.DHCINITBarCode Extends (%Persistent, User.Abstract) [ SqlRowIdName = INITB_RowId, SqlTableName = DHC_INITBarCode, StorageStrategy = SqlStorage ]
{

/// 出库明细DR
Property INITBINITIDR As User.DHCInIsTrfItm [ SqlColumnNumber = 2, SqlFieldName = INITB_INITI_DR ];

/// 条码
Property INITBBarCode As %String [ SqlColumnNumber = 3, SqlFieldName = INITB_BarCode ];

Property INITBStatus As %String [ SqlColumnNumber = 4, SqlFieldName = INITB_Status ];

Storage SqlStorage
{
<SqlIdExpression>$i(^DHCINITB)</SqlIdExpression>
<SQLMap name="IndexBarCode">
<Global>^DHCINITB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INITB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INITB_BarCode}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INITB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINITI">
<Global>^DHCINITB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INITB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INITI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INITB_INITI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INITB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="INITB_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INITB_INITI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INITB_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINITB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INITB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INITB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INITB_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINITBarCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINITB)
	s oldI = +$g(^mdata("DHCINITB"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINITB = maxI
	s ^mdata("DHCINITB") = maxI
}

}
