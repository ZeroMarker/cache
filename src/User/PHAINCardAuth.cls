/// Huxt 2020-04-17
/// 卡片使用授权
/// d ##class(User.PHAINCardAuth).%BuildIndices()
Class User.PHAINCardAuth Extends %Persistent [ SqlRowIdName = PICA_RowId, SqlTableName = PHAIN_CardAuth, StorageStrategy = SQLStorage ]
{

/// 医院(院区)
Property PICAHOSPDR As User.CTHospital [ Required, SqlColumnNumber = 2, SqlFieldName = PICA_HOSP_DR ];

/// 属性授权类型
Property PICAType As %String(DISPLAYLIST = ",User,Group,Loc,All", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",U,G,L,A") [ Required, SqlColumnNumber = 3, SqlFieldName = PICA_Type ];

/// 授权类型指向
Property PICAPointer As %String [ InitialExpression = 0, Required, SqlColumnNumber = 4, SqlFieldName = PICA_Pointer ];

/// 指向卡片子表
Property PICAPICIDR As User.PHAINCardItm [ SqlColumnNumber = 5, SqlFieldName = PICA_PICI_DR ];

/// 是否授权(取消授权时置N,新增为Y)
Property PICAAuthFlag As %String [ SqlColumnNumber = 6, SqlFieldName = PICA_AuthFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.CardAuth)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PICA_AuthFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PICA_HOSP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICA_PICI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PICA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PICA_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.PHA.IN.CardAuth</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PICA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PICA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHTPP">
<Global>^CF.PHA.IN.CardAuthi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PICA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HTPP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICA_HOSP_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICA_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICA_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PICA_PICI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PICA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICA_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardAuthS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.CardAuth)
	s oldI = +$g(^mdata("CF.PHA.IN.CardAuth"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.CardAuth = maxI
	s ^mdata("CF.PHA.IN.CardAuth") = maxI
}

}
