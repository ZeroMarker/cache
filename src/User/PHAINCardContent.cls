/// Huxt 2020-04-17
/// 卡片内容字典表
/// d ##class(User.PHAINCardContent).%BuildIndices()
Class User.PHAINCardContent Extends %Persistent [ SqlRowIdName = PICC_RowId, SqlTableName = PHAIN_CardContent, StorageStrategy = SQLStorage ]
{

/// 定义子表
Relationship ChildPHAINCardContentItm As User.PHAINCardContentItm [ Cardinality = children, Inverse = PICCIParref ];

/// 内容代码
Property PICCCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PICC_Code ];

/// 内容名称
Property PICCDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PICC_Desc ];

/// 内容是否可用
Property PICCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PICC_ActiveFlag ];

/// 内容是否为表单
Property PICCFormFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PICC_FormFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CD.PHA.IN.CardContent)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PICC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PICC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PICC_FormFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CD.PHA.IN.CardContent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PICC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PICC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CD.PHA.IN.CardContenti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PICC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICC_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICC_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardContentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.IN.CardContent)
	s oldI = +$g(^mdata("CD.PHA.IN.CardContent"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.IN.CardContent = maxI
	s ^mdata("CD.PHA.IN.CardContent") = maxI
}

}
