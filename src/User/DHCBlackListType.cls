Class User.DHCBlackListType Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_BlackListType, StorageStrategy = DHCBlackListType ]
{

/// 黑名单类型
Property DHCBlackCode As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCBlackCode ];

/// 黑名单描述
Property DHCBlackDesc As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCBlackDesc ];

/// 管控执行代码
Property DHCBlackExecuteCode As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCBlackExecuteCode ];

Storage DHCBlackListType
{
<SqlIdExpression>$i(^DHCBlackType(0))</SqlIdExpression>
<SQLMap name="DataMap">
<Data name="DHCBlackCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCBlackDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCBlackExecuteCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCBlackType</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHCBlackType_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCBlackType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCBlackType_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHCBlackType_RowId</SqlRowIdName>
<StreamLocation>^User.DHCBlackListTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
