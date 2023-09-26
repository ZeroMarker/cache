/// InterSysSet
Class dhc.pa.inter.InterSysSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InterSysSet_rowid, SqlTableName = InterSysSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InterSysSet_order
Property InterSysSetorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = InterSysSet_order ];

/// InterSysSet_code
Property InterSysSetcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InterSysSet_code ];

/// InterSysSet_name
Property InterSysSetname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InterSysSet_name ];

/// InterSysSet_shortcut
Property InterSysSetshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InterSysSet_shortcut ];

/// InterSysSet_desc
Property InterSysSetdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InterSysSet_desc ];

/// InterSysSet_active
Property InterSysSetactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = InterSysSet_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAINTERSYSSET(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InterSysSet_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InterSysSet_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InterSysSet_desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InterSysSet_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InterSysSet_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InterSysSet_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCJXPAINTERSYSSET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InterSysSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InterSysSet_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAINTERSYSSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterSysSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterSysSet_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterSysSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAINTERSYSSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterSysSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterSysSet_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterSysSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAINTERSYSSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterSysSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterSysSet_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterSysSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPAINTERSYSSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InterSysSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ShortCut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InterSysSet_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InterSysSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.InterSysSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
