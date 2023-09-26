Class dhc.ca.cache.data.OutItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutItems_rowid, SqlTableName = OutItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On OutItemschildSub [ IdKey, PrimaryKey, Unique ];

/// InItems Parent Reference
Relationship OutItemsparRef As dhc.ca.cache.data.InItems [ Cardinality = parent, Inverse = ChildOutItems, Required, SqlFieldName = OutItems_parRef ];

/// OutItems_childSub
Property OutItemschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINITEMSETS($p(%d(0),"||"),"In",$p(%d(0),"||",2),"Out",0))}, SqlColumnNumber = 2, SqlFieldName = OutItems_childSub ];

/// OutItems_order
Property OutItemsorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = OutItems_order ];

/// OutItems_itemDr
Property OutItemsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = OutItems_itemDr ];

/// OutItems_remark
Property OutItemsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OutItems_remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="OutItems_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OutItems_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OutItems_remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCAINITEMSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InItemSets.InItemSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>InItems.InItems_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OutItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InItemSets.InItemSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"In"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItems.InItems_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Out"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutItems_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOutItemDr">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InItemSets.InItemSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>InItems.InItems_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OutItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutItemDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets.InItemSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItems.InItems_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutItems_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutOrder">
<Global>^DHCCAINITEMSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InItemSets.InItemSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>InItems.InItems_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OutItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InItemSets.InItemSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InItems.InItems_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutItems_order}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.OutItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
