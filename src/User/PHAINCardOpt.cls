/// Huxt 2020-04-17
/// 卡片属性附加表
/// d ##class(User.PHAINCardOpt).%BuildIndices()
Class User.PHAINCardOpt Extends %Persistent [ SqlRowIdName = PICO_RowId, SqlTableName = PHAIN_CardOpt, StorageStrategy = SQLStorage ]
{

/// 定义子表
Relationship ChildPHAINCardOptItm As User.PHAINCardOptItm [ Cardinality = children, Inverse = PICOIParref ];

/// 指向卡片主表
Property PICOPICDR As User.PHAINCard [ SqlColumnNumber = 2, SqlFieldName = PICO_PIC_DR ];

/// 内容是否可用
Property PICOActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PICO_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.CardOpt)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PICO_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PICO_PIC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CF.PHA.IN.CardOpt</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PICO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PICO_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPIC">
<Global>^CF.PHA.IN.CardOpti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PICO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICO_PIC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICO_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINCardOptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.CardOpt)
	s oldI = +$g(^mdata("CF.PHA.IN.CardOpt"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.CardOpt = maxI
	s ^mdata("CF.PHA.IN.CardOpt") = maxI
}

}
