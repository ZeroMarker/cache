/// Cycle
Class dhc.pa.data.Cycle Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Cycle_rowid, SqlTableName = Cycle, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Cycle_code
Property Cyclecode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Cycle_code ];

/// Cycle_name
Property Cyclename As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Cycle_name ];

/// Cycle_shortcut
Property Cycleshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Cycle_shortcut ];

/// Cycle_desc
Property Cycledesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Cycle_desc ];

/// Cycle_active
Property Cycleactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = Cycle_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPACYCLE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Cycle_active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Cycle_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Cycle_desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Cycle_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Cycle_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPACYCLE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Cycle_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Cycle_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPACYCLE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Cycle_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Cycle_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Cycle_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPACYCLE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Cycle_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Cycle_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Cycle_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPACYCLE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Cycle_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Cycle_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Cycle_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.CycleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
