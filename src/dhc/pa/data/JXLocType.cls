/// JXLocType
Class dhc.pa.data.JXLocType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXLocType_rowid, SqlTableName = JXLocType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// JXLocType_code
Property JXLocTypecode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JXLocType_code ];

/// JXLocType_name
Property JXLocTypename As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JXLocType_name ];

/// JXLocType_shortcut
Property JXLocTypeshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JXLocType_shortcut ];

/// JXLocType_desc
Property JXLocTypedesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = JXLocType_desc ];

/// JXLocType_active
Property JXLocTypeactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = JXLocType_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAJXLOCTYPE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="JXLocType_active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JXLocType_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JXLocType_desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JXLocType_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JXLocType_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPAJXLOCTYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JXLocType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXLocType_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAJXLOCTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXLocType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXLocType_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXLocType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAJXLOCTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXLocType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXLocType_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXLocType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAJXLOCTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXLocType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXLocType_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXLocType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPAJXLOCTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXLocType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXLocType_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXLocType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.JXLocTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
