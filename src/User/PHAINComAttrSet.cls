/// Huxt 2020-05-20
/// 与User.PHAINComAttr结合用作公共授权使用
Class User.PHAINComAttrSet Extends %Persistent [ SqlRowIdName = PICAS_RowId, SqlTableName = PHAIN_ComAttrSet, StorageStrategy = SQLStorage ]
{

/// 医院(院区)
Property PICASHOSPDR As User.CTHospital [ Required, SqlColumnNumber = 2, SqlFieldName = PICAS_HOSP_DR ];

/// 属性授权类型
Property PICASType As %String(DISPLAYLIST = ",User,Group,Loc,All", MAXLEN = 10, SELECTIVITY = "25%", VALUELIST = ",U,G,L,A") [ Required, SqlColumnNumber = 3, SqlFieldName = PICAS_Type ];

/// 授权类型指向
Property PICASPointer As %String [ InitialExpression = 0, Required, SqlColumnNumber = 4, SqlFieldName = PICAS_Pointer ];

/// 属性关联表名
Property PICASTable As %String [ Required, SqlColumnNumber = 5, SqlFieldName = PICAS_Table ];

/// 属性关联表ID
Property PICASTableId As %String [ Required, SqlColumnNumber = 6, SqlFieldName = PICAS_TableId ];

/// 指向公共属性
Property PICASPICADR As User.PHAINComAttr [ SqlColumnNumber = 7, SqlFieldName = PICAS_PICA_DR ];

/// 属性值
Property PICASValue As %String [ SqlColumnNumber = 8, SqlFieldName = PICAS_Value ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.ComAttrSet)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PICAS_HOSP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICAS_PICA_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PICAS_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PICAS_Table">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PICAS_TableId">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PICAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PICAS_Value">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF.PHA.IN.ComAttrSet</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PICAS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PICAS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHTPTTP">
<Global>^CF.PHA.IN.ComAttrSeti</Global>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>PICAS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HTPTTP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICAS_HOSP_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICAS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICAS_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PICAS_Table}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PICAS_TableId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PICAS_PICA_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PICAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICAS_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINComAttrSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.ComAttrSet)
	s oldI = +$g(^mdata("CF.PHA.IN.ComAttrSet"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.ComAttrSet = maxI
	s ^mdata("CF.PHA.IN.ComAttrSet") = maxI
}

}
