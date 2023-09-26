/// 库存项关联计费项
Class User.DHCInciLinkTar Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = ILT_RowId, SqlTableName = DHC_InciLinkTar, StorageStrategy = SQLStorage ]
{

Property ILTINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = ILT_INCI_DR ];

Property ILTTariffDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = ILT_Tariff_DR ];

Property ILTQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = ILT_Qty ];

Property ILTUom As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = ILT_Uom ];

Property ILTPercent As %Float(MAXVAL = 1, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = ILT_Percent ];

Property ILTActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ILT_ActiveFlag ];

Property ILTGroup As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 8, SqlFieldName = ILT_Group ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCILT)</SqlIdExpression>
<SQLMap name="IndexInci">
<Global>^DHCILT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{ILT_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ILT_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ILT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTariff">
<Global>^DHCILT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ILT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Tariff"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ILT_Tariff_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ILT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="ILT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ILT_Group">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ILT_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ILT_Percent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ILT_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ILT_Tariff_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ILT_Uom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCILT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ILT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ILT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ILT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCInciLinkTarS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCILT)
	s oldI = +$g(^mdata("DHCINCILINKTAR"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCILT = maxI
	s ^mdata("DHCINCILINKTAR") = maxI
}

}
