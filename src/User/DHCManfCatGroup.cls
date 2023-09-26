Class User.DHCManfCatGroup Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = MCG_RowId, SqlTableName = DHC_ManfCatGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property MCGMANFDr As User.PHManufacturer [ SqlColumnNumber = 2, SqlFieldName = MCG_MANF_Dr ];

Property MCGSCGDr As User.DHCStkCatGroup [ SqlColumnNumber = 3, SqlFieldName = MCG_SCG_Dr ];

Property MCGUseFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MCG_UseFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMCG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MCG_MANF_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MCG_SCG_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MCG_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MCG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexManf">
<Global>^DHCMCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MANF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MCG_MANF_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSCG">
<Global>^DHCMCG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MCG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SCG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{MCG_SCG_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{MCG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MCG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCManfCatGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCMCG)
	s oldI = +$g(^mdata("DHCMANFCATGROUP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCMCG = maxI
	s ^mdata("DHCMANFCATGROUP") = maxI
}

}
