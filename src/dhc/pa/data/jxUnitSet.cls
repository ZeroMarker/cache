/// jxUnitSet
Class dhc.pa.data.jxUnitSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = jxUnitSet_rowid, SqlTableName = jxUnitSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// jxUnitSet_order
Property jxUnitSetorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = jxUnitSet_order ];

/// jxUnitSet_code
Property jxUnitSetcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = jxUnitSet_code ];

/// jxUnitSet_name
Property jxUnitSetname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = jxUnitSet_name ];

/// jxUnitSet_shortcut
Property jxUnitSetshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = jxUnitSet_shortcut ];

/// jxUnitSet_py
Property jxUnitSetpy As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = jxUnitSet_py ];

/// jxUnitSet_desc
Property jxUnitSetdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = jxUnitSet_desc ];

/// jxUnitSet_parent
Property jxUnitSetparent As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = jxUnitSet_parent ];

/// jxUnitSet_active
Property jxUnitSetactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = jxUnitSet_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAJXUNITSET(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="jxUnitSet_active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="jxUnitSet_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="jxUnitSet_desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="jxUnitSet_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="jxUnitSet_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="jxUnitSet_parent">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="jxUnitSet_py">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="jxUnitSet_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCJXPAJXUNITSET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>jxUnitSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{jxUnitSet_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAJXUNITSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>jxUnitSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{jxUnitSet_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{jxUnitSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPAJXUNITSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>jxUnitSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{jxUnitSet_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{jxUnitSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPAJXUNITSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>jxUnitSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{jxUnitSet_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{jxUnitSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCJXPAJXUNITSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>jxUnitSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{jxUnitSet_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{jxUnitSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentOrder">
<Global>^DHCCJXPAJXUNITSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>jxUnitSet_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParentOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{jxUnitSet_parent}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{jxUnitSet_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{jxUnitSet_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.jxUnitSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
