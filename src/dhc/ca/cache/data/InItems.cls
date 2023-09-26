Class dhc.ca.cache.data.InItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InItems_rowid, SqlTableName = InItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InItemschildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOutItems As dhc.ca.cache.data.OutItems [ Cardinality = children, Inverse = OutItemsparRef ];

/// InItemSets Parent Reference
Relationship InItemsparRef As dhc.ca.cache.data.InItemSets [ Cardinality = parent, Inverse = ChildInItems, Required, SqlFieldName = InItems_parRef ];

/// InItems_childSub
Property InItemschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINITEMSETS($p(%d(0),$c(1),1),"InItems",0))}, SqlColumnNumber = 2, SqlFieldName = InItems_childSub ];

/// InItems_order
Property InItemsorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = InItems_order ];

/// InItems_itemDr
Property InItemsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = InItems_itemDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InItems_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InItems_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAINITEMSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InItemSets.InItemSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>InItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InItemSets.InItemSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InItems"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItems_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInItem">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InItemSets.InItemSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets.InItemSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItems_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInOrder">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InItemSets.InItemSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets.InItemSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItems_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
