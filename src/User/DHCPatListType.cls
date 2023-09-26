Class User.DHCPatListType Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DHC_PatTypeRowID, SqlTableName = DHC_PatListType, StorageStrategy = SQLStorage ]
{

/// 患者类型代码
Property DHCPatTypeCode As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHC_PatTypeCode ];

/// 患者类型描述
Property DHCPatTypeDesc As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DHC_PatTypeDesc ];

/// 控制点执行代码
Property DHCPatTypeExecCode As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DHC_PatTypeExecCode ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCPatType(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHC_PatTypeCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHC_PatTypeDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHC_PatTypeExecCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPatType</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PatTypeRowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PatTypeRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DHC_PayTypeRowID</SqlRowIdName>
<StreamLocation>User.DHCPatListTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
