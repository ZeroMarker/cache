Class User.DHCMatOrdCat Extends (%Persistent, User.Abstract) [ SqlRowIdName = MatOrdCat_RowId, SqlTableName = DHC_MatOrdCat, StorageStrategy = SQLStorage ]
{

Property MatOrdCatDR As User.OECOrderCategory [ SqlColumnNumber = 2, SqlFieldName = Mat_OrdCat_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMATORDCAT)</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="Mat_OrdCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCMATORDCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MatOrdCat_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MatOrdCat_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdCat">
<Global>^DHCMATORDCAT</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MatOrdCat_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Mat_OrdCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MatOrdCat_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MatOrdCat_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatOrdCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMATORDCAT)
	s oldI = +$g(^mdata("DHCMATORDCAT"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMATORDCAT = maxI
	s ^mdata("DHCMATORDCAT") = maxI
}

}
