/// 医保数据上传接口数据明细表
/// wty 20210305
Class User.INSUDataPortListSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDPLS_Rowid, SqlTableName = INSU_DataPortListSub, StorageStrategy = SQLStorage ]
{

/// User.INSUDataPortList指针
Property PARID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PARID ];

/// 表名，节点名
Property TableCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TableCode ];

/// 唯一序号
Property SerialNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SerialNo ];

/// 上传用户
Property INDPLSOpter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INDPLS_Opter ];

/// 上传日期
Property INDPLSOptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INDPLS_OptDate ];

/// 上传日期
Property INDPLSOptTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = INDPLS_OptTime ];

/// 上传标志
Property INDPLSOptFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDPLS_OptFlag ];

/// 交易编号
Property TradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TradeNo ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINDPLS)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="INDPLS_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDPLS_OptFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDPLS_OptTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDPLS_Opter">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PARID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SerialNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TableCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TradeNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCINDPLS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDPLS_Rowi</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INDPLS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfPARID">
<Global>^DHCINDPLSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDPLS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PARID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PARID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDPLS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfTableCode">
<Global>^DHCINDPLSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDPLS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TableCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PARID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TableCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SerialNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDPLS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexOfTradeNoSerino">
<Global>^DHCINDPLSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>[L4}</Expression>
<Field>INDPLS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TradeNoSerino"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TradeNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SerialNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDPLS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDataPortListSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
