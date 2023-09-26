Class dhc.ca.cache.data.InItemSets Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InItemSets_rowid, SqlTableName = InItemSets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildInItems As dhc.ca.cache.data.InItems [ Cardinality = children, Inverse = InItemsparRef ];

/// InItemSets_order
Property InItemSetsorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = InItemSets_order ];

/// InItemSets_code
Property InItemSetscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = InItemSets_code ];

/// InItemSets_name
Property InItemSetsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = InItemSets_name ];

/// InItemSets_shortcut
Property InItemSetsshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = InItemSets_shortcut ];

/// InItemSets_remark
Property InItemSetsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = InItemSets_remark ];

/// InItemSets_active
Property InItemSetsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = InItemSets_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINITEMSETS(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InItemSets_active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="InItemSets_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InItemSets_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InItemSets_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InItemSets_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InItemSets_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCAINITEMSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InItemSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InItemSets_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InItemSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItemSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InItemSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItemSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InItemSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItemSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSetOrder">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InItemSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SetOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItemSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InItemSets_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItemSets_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InItemSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
