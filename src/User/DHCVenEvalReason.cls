Class User.DHCVenEvalReason Extends (%Persistent, User.Abstract) [ Not Abstract, SqlRowIdName = VEIR_RowId, SqlTableName = DHC_VenEvalReason, StorageStrategy = SQLStorage ]
{

Property VEIRCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VEIR_Code ];

Property VEIRDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = VEIR_Desc ];

Property VEIRWeight As %Float [ SqlColumnNumber = 4, SqlFieldName = VEIR_Weight ];

Property VEIRVEI As User.DHCVendorEvaluationIndex [ Required, SqlColumnNumber = 5, SqlFieldName = VEIR_VEI ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVEIR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VEIR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VEIR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VEIR_VEI">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VEIR_Weight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCVEIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VEIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{VEIR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVenindex">
<Global>^DHCVEIR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>VEIR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VENINDEX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VEIR_VEI}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VEIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VEIR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVenEvalReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCVEIR)
	s oldI = +$g(^mdata("DHCVENEVALREASON"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCVEIR = maxI
	s ^mdata("DHCVENEVALREASON") = maxI
}

Parameter EXTENTSIZE = 250;

}
