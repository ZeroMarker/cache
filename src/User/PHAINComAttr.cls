/// Huxt 2020-04-16
/// 公共属性字典表
/// d ##class(User.PHAINComAttr).%BuildIndices()
Class User.PHAINComAttr Extends %Persistent [ SqlRowIdName = PICA_RowId, SqlTableName = PHAIN_ComAttr, StorageStrategy = SQLStorage ]
{

/// 属性代码
Property PICACode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PICA_Code ];

/// 属性名称
Property PICADesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PICA_Desc ];

/// 上一级属性
Property PICAParDR As User.PHAINComAttr [ InitialExpression = 0, SqlColumnNumber = 4, SqlFieldName = PICA_Par_DR ];

/// 公共属性
Property PICAComFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PICA_ComFlag ];

/// HISUI属性
Property PICAHUIFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PICA_HUIFlag ];

/// 必填属性
Property PICARequiredFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PICA_RequiredFlag ];

/// 属性是否可用
Property PICAActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PICA_ActiveFlag ];

/// 属性值类型 (string/number/boolean/pointer/object/function)
Property PICAValType As %String(MAXLEN = 10) [ SqlColumnNumber = 9, SqlFieldName = PICA_ValType ];

/// 属性值范围
Property PICAValRange As %String(MAXLEN = 200) [ SqlColumnNumber = 10, SqlFieldName = PICA_ValRange ];

/// 表单类型(文本,下拉, 复选, 连接弹窗(pointer赋值))
Property PICAFormType As %String(MAXLEN = 20) [ SqlColumnNumber = 11, SqlFieldName = PICA_FormType ];

/// 表单显示顺序
Property PICAFormSort As %String(MAXLEN = 10) [ SqlColumnNumber = 12, SqlFieldName = PICA_FormSort ];

/// 表单默认值
Property PICAFormVal As %String(MAXLEN = 50) [ SqlColumnNumber = 13, SqlFieldName = PICA_FormVal ];

/// 属性使用备注 (内容可能很多,单独存)
Property PICAMemo As list Of %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PICA_Memo, SqlListType = SUBNODE ];

Storage SQLStorage
{
<SqlIdExpression>$i(^CD.PHA.IN.ComAttr)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="PICA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PICA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PICA_ComFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PICA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PICA_FormSort">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PICA_FormType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PICA_FormVal">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PICA_HUIFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PICA_Memo">
<Delimiter>"^"</Delimiter>
<Node>"Memo"</Node>
</Data>
<Data name="PICA_Par_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PICA_RequiredFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PICA_ValRange">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PICA_ValType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CD.PHA.IN.ComAttr</Global>
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
<SQLMap name="IndexCode">
<Global>^CD.PHA.IN.ComAttri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PICA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICA_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPar">
<Global>^CD.PHA.IN.ComAttri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PICA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Par"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICA_Par_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParCode">
<Global>^CD.PHA.IN.ComAttri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PICA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ParCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PICA_Par_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PICA_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PICA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PICA_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINComAttrS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.IN.ComAttr)
	s oldI = +$g(^mdata("CD.PHA.IN.ComAttr"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.IN.ComAttr = maxI
	s ^mdata("CD.PHA.IN.ComAttr") = maxI
}

}
