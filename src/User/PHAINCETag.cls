Class User.PHAINCETag Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIET_Rowid, SqlTableName = PHAINC_ETag, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 标签ID
Property PIETID As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = PIET_ID ];

/// 条码号
Property PIETBarCode As %String(TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PIET_BarCode ];

/// 标签颜色
Property PIETColor As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PIET_Color ];

/// 标签状态
Property PIETState As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PIET_State ];

/// 应用 1-处方，2-设备
Property PIETAppType As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PIET_AppType ];

/// 当前处方
Property PIETPrescNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PIET_PrescNo ];

/// 标签位置
Property PIETPlace As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PIET_Place ];

/// 标签类型 1-声光标签，2-普通电子标签
Property PIETType As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PIET_Type ];

/// 当前电量
Property PIETBattery As %Float [ SqlColumnNumber = 10, SqlFieldName = PIET_Battery ];

/// 激活时间
Property PIETActiveTime As %DateTime [ SqlColumnNumber = 11, SqlFieldName = PIET_ActiveTime ];

/// 停用时间
Property PIETDeactiveTime As %DateTime [ SqlColumnNumber = 12, SqlFieldName = PIET_DeactiveTime ];

/// 创建时间
Property PIETCreateTime As %DateTime [ SqlColumnNumber = 13, SqlFieldName = PIET_CreateTime ];

Index PIETIDIndex On PIETID [ Unique ];

Index PIETBarCodeIndex On PIETBarCode;

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^CD.PHA.INC.ETAG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PIET_ActiveTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIET_AppType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIET_BarCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIET_Battery">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIET_Color">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIET_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PIET_DeactiveTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PIET_ID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIET_Place">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIET_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIET_State">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIET_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CD.PHA.INC.ETAG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIET_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIET_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarcode">
<Global>^CD.PHA.INC.ETAGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIET_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"BarCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIET_BarCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIET_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexID">
<Global>^CD.PHA.INC.ETAGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>{PIET_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIET_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIET_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^CD.PHA.INC.ETAGi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIET_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIET_PrescNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIET_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAINCETagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^CD.PHA.INC.ETAG)
	s oldI = +$g(^mdata("PHAINCETAG"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^CD.PHA.INC.ETAG = maxI
	s ^mdata("PHAINCETAG") = maxI
}

}
