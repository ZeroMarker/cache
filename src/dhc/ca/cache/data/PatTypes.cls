Class dhc.ca.cache.data.PatTypes Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PatTypes_rowid, SqlTableName = PatTypes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property PatTypesCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PatTypes_code ];

Property PatTypesName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PatTypes_name ];

Property PatTypeslorder As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PatTypes_order ];

Property PatTypesactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PatTypes_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAPATTYPES(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCCAPATTYPES</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PatTypes_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"patCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PatTypes_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PatTypes_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapMast">
<Data name="PatTypes_active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PatTypes_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PatTypes_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PatTypes_order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCAPATTYPES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PatTypes_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PatTypes_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.PatTypes</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
