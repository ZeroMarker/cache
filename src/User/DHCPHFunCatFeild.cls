Class User.DHCPHFunCatFeild Extends %Persistent [ SqlRowIdName = FLC_RowId, SqlTableName = DHC_PHFunCatFeild, StorageStrategy = NewStorage1 ]
{

Property FLCCode As %String [ SqlColumnNumber = 2, SqlFieldName = FLC_Code ];

Property FLCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = FLC_Desc ];

Property FLCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = FLC_ActiveFlag ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHFUNCAT)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCPHFUNCAT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>FLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FLC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FLC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="FLC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FLC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FLC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHFUNCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FLC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FLC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHFunCatFeildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHFUNCAT)
	s oldI = +$g(^mdata("DHCPHFunCatFeild"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHFUNCAT = maxI
	s ^mdata("DHCPHFunCatFeild") = maxI
}

}
