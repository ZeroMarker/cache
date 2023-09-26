Class dhc.pa.data.CalUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CalUnit_rowid, SqlTableName = CalUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CalUnit_code
Property CalUnitcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CalUnit_code ];

/// CalUnit_name
Property CalUnitname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CalUnit_name ];

/// CalUnit_shortcut
Property CalUnitshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CalUnit_shortcut ];

/// CalUnit_desc
Property CalUnitdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CalUnit_desc ];

/// CalUnit_active
Property CalUnitactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CalUnit_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPACALUNIT(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="CalUnit_active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CalUnit_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CalUnit_desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CalUnit_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CalUnit_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPACALUNIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CalUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CalUnit_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPACALUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CalUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CalUnit_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CalUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPACALUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CalUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CalUnit_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CalUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPACALUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CalUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CalUnit_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CalUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPACALUNIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CalUnit_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CalUnit_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CalUnit_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.CalUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
