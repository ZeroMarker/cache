Class User.DHCPHSendLoc Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHSL_RowID, SqlTableName = DHC_PHSendLoc, StorageStrategy = SQLStorage ]
{

/// 药房科室
Property PHSLPHLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PHSL_PHLoc_Dr ];

/// 病房科室
Property PHSLWardLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHSL_WardLoc_Dr ];

/// 送药标志
Property PHSLSendFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 4, SqlFieldName = PHSL_SendFlag ];

/// 送药频率
Property PHSLSendFreqDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHSL_SendFreqDesc ];

/// 频率系数
Property PHSLSendFreqFactor As %Float [ SqlColumnNumber = 6, SqlFieldName = PHSL_SendFreqFactor ];

/// 付数系数
Property PHSLSendFactor As %Float [ SqlColumnNumber = 7, SqlFieldName = PHSL_SendFactor ];

/// 显示序号
Property PHSLWardQue As %Integer [ SqlColumnNumber = 8, SqlFieldName = PHSL_WardQue ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPHSL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHSL_PHLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHSL_SendFactor">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHSL_SendFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHSL_SendFreqDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHSL_SendFreqFactor">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHSL_WardLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHSL_WardQue">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHSL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHSL_PHLoc_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHSL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPHLoc">
<Global>^DHCPHSLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHSL_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSL_WardLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToLoc">
<Global>^DHCPHSLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHSL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ToLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHSL_WardLoc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHSL_PHLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHSendLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHSL)
	s oldI = +$g(^mdata("DHCPHSENDLOC"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHSL = maxI
	s ^mdata("DHCPHSENDLOC") = maxI
}

}
