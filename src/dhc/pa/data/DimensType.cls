Class dhc.pa.data.DimensType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DimensType_rowid, SqlTableName = DimensType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DimensType_code
Property DimensTypecode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DimensType_code ];

/// DimensType_name
Property DimensTypename As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DimensType_name ];

/// DimensType_shortcut
Property DimensTypeshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DimensType_shortcut ];

/// DimensType_order
Property DimensTypeorder As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DimensType_order ];

/// DimensType_appSysDr
Property DimensTypeappSysDr As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DimensType_appSysDr ];

/// DimensType_desc
Property DimensTypedesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DimensType_desc ];

/// DimensType_isInner
Property DimensTypeisInner As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DimensType_isInner ];

/// DimensType_active
Property DimensTypeactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = DimensType_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPADIMENSTYPE(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="DimensType_active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DimensType_appSysDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DimensType_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DimensType_desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DimensType_isInner">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DimensType_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DimensType_order">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DimensType_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPADIMENSTYPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPADIMENSTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DimensType_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppSys">
<Global>^DHCCJXPADIMENSTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppSys"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DimensType_appSysDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCJXPADIMENSTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DimensType_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInner">
<Global>^DHCCJXPADIMENSTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inner"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DimensType_isInner}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCJXPADIMENSTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DimensType_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCJXPADIMENSTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DimensType_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortCut">
<Global>^DHCCJXPADIMENSTYPE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DimensType_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DimensType_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DimensType_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.DimensTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
