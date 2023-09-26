/// InterLocSet
Class dhc.pa.inter.InterLocSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterLocSet_rowid, SqlTableName = InterLocSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InterLocSet_order
Property InterLocSetorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = InterLocSet_order ];

/// InterLocSet_code
Property InterLocSetcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterLocSet_code ];

/// InterLocSet_name
Property InterLocSetname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterLocSet_name ];

/// InterLocSet_shortcut
Property InterLocSetshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterLocSet_shortcut ];

/// InterLocSet_desc
Property InterLocSetdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InterLocSet_desc ];

/// InterLocSet_active
Property InterLocSetactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = InterLocSet_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINTERLOCSET(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InterLocSet_active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InterLocSet_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InterLocSet_desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InterLocSet_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InterLocSet_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InterLocSet_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCJXPAINTERLOCSET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InterLocSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InterLocSet_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAINTERLOCSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterLocSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLocSet_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLocSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAINTERLOCSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterLocSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLocSet_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLocSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAINTERLOCSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterLocSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLocSet_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLocSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPAINTERLOCSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterLocSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ShortCut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterLocSet_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterLocSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.InterLocSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
