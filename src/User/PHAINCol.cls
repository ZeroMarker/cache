Class User.PHAINCol Extends %Persistent [ SqlRowIdName = Col_RowId, SqlTableName = PHAIN_Col, StorageStrategy = CacheSQLStorage ]
{

/// 表名
Property ColTableName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ Required, SqlColumnNumber = 2, SqlFieldName = Col_TableName ];

/// 指向ColTableName表ID
Property ColPointer As %Library.String [ Required, SqlColumnNumber = 3, SqlFieldName = Col_Pointer ];

/// 列名: field,name,index
Property ColField As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ Required, SqlColumnNumber = 4, SqlFieldName = Col_Field ];

/// 列名: title,header
Property ColTitle As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ Required, SqlColumnNumber = 5, SqlFieldName = Col_Title ];

/// 列宽 (数字)
Property ColWidth As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Col_Width ];

/// 列对齐方式 (left/center/right)
Property ColAlign As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Col_Align ];

/// 列隐藏 (Y/N)
Property ColHidden As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Col_Hidden ];

/// 是否列排序 (Y/N)
Property ColSortable As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Col_Sortable ];

/// 列冻结 (Y/N)
Property ColFrozen As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Col_Frozen ];

/// 回车跳转 (数字)
Property ColEnterSort As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = Col_EnterSort ];

/// 列显示顺序 (数字)
Property ColSort As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = Col_Sort ];

/// 列格式化表达式 (js函数名称)
Property ColFormatter As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Col_Formatter ];

/// 列样式表达式 (js函数名称)
Property ColStyler As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = Col_Styler ];

/// 列打印时是否打印 (Y/N)
Property ColIfPrint As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = Col_IfPrint ];

/// 列导出时是否导出 (Y/N)
Property ColIfExport As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = Col_IfExport ];

/// 列导提示宽度 (数字)
Property ColTipWidth As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = Col_TipWidth ];

/// 列是否求和 (求和/合计)
Property ColIsTotal As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = Col_IsTotal ];

/// 列宽固定 (Y/N)
Property ColFixed As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = Col_Fixed ];

/// 是否checkbox
Property ColIsCheckbox As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = Col_IsCheckbox ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IN.Col)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="Col_Align">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Col_EnterSort">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Col_Field">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Col_Fixed">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="Col_Formatter">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Col_Frozen">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Col_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Col_IfExport">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="Col_IfPrint">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Col_IsCheckbox">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="Col_IsTotal">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="Col_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Col_Sort">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Col_Sortable">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Col_Styler">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Col_TableName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Col_TipWidth">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Col_Title">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Col_Width">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CF.PHA.IN.Col</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Col_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Col_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTPF">
<Global>^CF.PHA.IN.Coli</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Col_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TPF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Col_TableName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Col_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Col_Field}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Col_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>Col_RowId</SqlRowIdName>
<StreamLocation>^User.PHAINColS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CF.PHA.IN.Col)
	s oldI = +$g(^mdata("CF.PHA.IN.Col"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CF.PHA.IN.Col = maxI
	s ^mdata("CF.PHA.IN.Col") = maxI
}

}
