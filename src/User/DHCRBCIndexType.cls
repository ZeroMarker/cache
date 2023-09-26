Class User.DHCRBCIndexType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIT_Rowid, SqlTableName = DHCRBC_IndexType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DIT_Code
Property DITCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DIT_Code ];

/// DIT_Desc
Property DITDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DIT_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCIndexType)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCRBCIndexTypei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIT_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMapData">
<Data name="DIT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCIndexType</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DIT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DIT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCIndexTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
