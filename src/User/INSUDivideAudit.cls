Class User.INSUDivideAudit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSUDIVAUD_Rowid, SqlTableName = INSU_DivideAudit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INSUDIVAUD_DIVDR
Property INSUDIVAUDDIVDR As User.INSUDivide [ SqlColumnNumber = 2, SqlFieldName = INSUDIVAUD_DIVDR ];

/// INSUDIVAUD_INVDR
Property INSUDIVAUDINVDR As User.DHCINVPRT [ SqlColumnNumber = 3, SqlFieldName = INSUDIVAUD_INVDR ];

/// INSUDIVAUD_Flag
Property INSUDIVAUDFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "16.6667%", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INSUDIVAUD_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^mdata("INSUDIVIDEAUDIT"))</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INSUDIVAUD_DIVDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSUDIVAUD_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSUDIVAUD_INVDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^INSUDIVAUD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INSUDIVAUD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INSUDIVAUD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofINDiv">
<Global>^INSUDIVAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSUDIVAUD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INDIV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUDIVAUD_DIVDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSUDIVAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofInv">
<Global>^INSUDIVAUD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INSUDIVAUD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INSUDIVAUD_INVDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSUDIVAUD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>User.INSUDivideAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
