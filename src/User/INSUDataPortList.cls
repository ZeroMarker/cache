/// 医保数据上传接口表
/// wty 20210305
Class User.INSUDataPortList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDPL_Rowid, SqlTableName = INSU_DataPortList, StorageStrategy = SQLStorage ]
{

/// User.INSUDataUL指针
Property PARID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PARID ];

/// 交易编号
Property TradeNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TradeNo ];

/// 上传用户
Property INDPLOpter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INDPL_Opter ];

/// 上传日期
Property INDPLOptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = INDPL_OptDate ];

/// 上传日期
Property INDPLOptTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INDPL_OptTime ];

/// 上传标志
Property INDPLOptFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INDPL_OptFlag ];

/// 入参
Property INDPLInPutData As %Stream.GlobalCharacter [ SqlColumnNumber = 8, SqlFieldName = INPUL_InPutData ];

/// 出参
Property INDPLOutPutData As %Stream.GlobalCharacter [ SqlColumnNumber = 9, SqlFieldName = INPUL_OutPutData ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINDPL)</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="INDPL_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDPL_OptFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDPL_OptTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDPL_Opter">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPUL_InPutData">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPUL_OutPutData">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PARID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TradeNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINDPL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDPL_Rowi</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INDPL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfPARID">
<Global>^DHCINDPLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INDPL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PARID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PARID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDPL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfTradeNo">
<Global>^DHCINDPLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDPL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TradeNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PARID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TradeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDPL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDataPortListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
