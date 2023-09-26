Class dhc.pa.data.Users Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UserRowid, SqlTableName = Users, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UserName
Property UserName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// Passwd
Property Passwd As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAUSER(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Passwd">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UserName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCJXPAUSER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UserRowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UserRowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUserName">
<Global>^DHCCJXPAUSER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UserRowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UserName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UserRowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.UsersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
