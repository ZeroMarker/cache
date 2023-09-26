Class dhc.pa.data.DNRRoom Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DNRRoom_rowid, SqlTableName = DNRRoom, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DNRRoom_code
Property DNRRoomcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DNRRoom_code ];

/// DNRRoom_name
Property DNRRoomname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DNRRoom_name ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPADNRROOM)</SqlIdExpression>
<SQLMap name="Master">
<Data name="DNRRoom_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DNRRoom_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPADNRROOM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DNRRoom_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DNRRoom_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.DNRRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
