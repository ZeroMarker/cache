/// Descript:Grid列设置
/// Creater:    ZhangHaiLong
/// CreateDate: 2012-11-17
Class User.DHCEmSysGridSet Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SGS_RowId, SqlTableName = DHC_EmSysGridSet, StorageStrategy = NewStorage1 ]
{

/// 表格ID  SGS_GridID
Property SGSGridID As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = SGS_GridID ];

/// CSP名称  SGS_CspName
Property SGSCspName As %Text(MAXLEN = 120) [ SqlColumnNumber = 3, SqlFieldName = SGS_CspName ];

/// 保存模式标识  SGS_SaveFor
Property SGSSaveFor As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = SGS_SaveFor ];

/// 保存模式对应值  SGS_Reference
Property SGSReference As %Text(MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = SGS_Reference ];

/// 列Key  SGS_Key
Property SGSKey As %Text(MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = SGS_Key ];

/// 列名称  SGS_Name
Property SGSName As %Text(MAXLEN = 30) [ SqlColumnNumber = 7, SqlFieldName = SGS_Name ];

/// 标题  SGS_Header
Property SGSHeader As %Text(MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = SGS_Header ];

/// 列宽  SGS_Width
Property SGSWidth As %Text(MAXLEN = 30) [ SqlColumnNumber = 9, SqlFieldName = SGS_Width ];

/// 列对齐格式  SGS_Alignment
Property SGSAlignment As %Text(MAXLEN = 30) [ SqlColumnNumber = 10, SqlFieldName = SGS_Alignment ];

/// 是否隐藏  SGS_Hidden
Property SGSHidden As %Text(MAXLEN = 30) [ SqlColumnNumber = 11, SqlFieldName = SGS_Hidden ];

/// 顺序号  SGS_OrderNum
Property SGSOrderNum As %Text(MAXLEN = 30) [ SqlColumnNumber = 12, SqlFieldName = SGS_OrderNum ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMSGS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SGS_Alignment">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SGS_CspName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SGS_GridID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SGS_Header">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SGS_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SGS_Key">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SGS_Name">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SGS_OrderNum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SGS_Reference">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SGS_SaveFor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SGS_Width">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEMSGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SGS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SGS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexGrid">
<Global>^DHCEMSGS</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>SGS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Grid"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP^SSUTIL4({SGS_CspName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SGS_GridID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SGS_SaveFor}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SGS_Reference}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SGS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmSysGridSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
