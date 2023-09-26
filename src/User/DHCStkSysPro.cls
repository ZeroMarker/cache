Class User.DHCStkSysPro Extends %Persistent [ SqlTableName = DHC_StkSysPro, StorageStrategy = CacheSQLStorage ]
{

/// 代码
Property ProCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Pro_Code ];

/// 名称
Property ProDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Pro_Desc ];

/// 激活
Property ProActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Pro_ActiveFlag ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^DHCSSPRO)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="Pro_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Pro_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Pro_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSSPRO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Pro_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Pro_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSSPROi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Pro_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Pro_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Pro_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Pro_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStkSysProS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSSPRO)
	s oldI = +$g(^mdata("DHCSSPRO"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSSPRO = maxI
	s ^mdata("DHCSSPRO") = maxI
}

}
