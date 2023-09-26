Class User.DHCDocExceedReason Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlRowIdName = DHCExceed_RowID, SqlTableName = DHCDoc_ExceedReason, StorageStrategy = SqlStorage ]
{

/// 超限代码
Property DHCExceedCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCExceed_Code ];

/// 超限描述
Property DHCExceedDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCExceed_Desc ];

/// 超限类型
Property DHCExceedType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCExceed_Type ];

/// 有效开始日期
Property DHCExceedFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCExceed_FromDate ];

/// 有效结束日期
Property DHCExceedEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCExceed_EndDate ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocExceedReason(0))</SqlIdExpression>
<SQLMap name="Index">
<Global>^DHCDocExceedReasonI</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCExceed_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCExceed_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCExceed_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MainData">
<Data name="DHCExceed_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCExceed_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCExceed_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCExceed_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCExceed_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocExceedReason</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCExceed_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCExceed_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCExceed_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocExceedReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
