/// Huxt 2020-04-17
/// 卡片定义表
/// d ##class(User.PHAINCard).%BuildIndices()
Class User.PHAINCard Extends %Persistent [ SqlRowIdName = PIC_RowId, SqlTableName = PHAIN_Card, StorageStrategy = SQLStorage ]
{

/// 定义子表
Relationship ChildPHAINCardItm As User.PHAINCardItm [ Cardinality = children, Inverse = PICIParref ];

/// 内容代码
Property PICCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PIC_Code ];

/// 内容名称
Property PICDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PIC_Desc ];

/// 内容是否可用
Property PICActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PIC_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.Card)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PIC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CF.PHA.IN.Card</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CF.PHA.IN.Cardi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIC_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PIC_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.Card)
	s oldI = +$g(^mdata("CF.PHA.IN.Card"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.Card = maxI
	s ^mdata("CF.PHA.IN.Card") = maxI
}

}
