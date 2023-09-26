Class dhc.ca.cache.data.LevelItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LevelItems_rowid, SqlTableName = LevelItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LevelItemschildSub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship LevelItemsparRef As dhc.ca.cache.data.DataLevelSets [ Cardinality = parent, Inverse = ChildLevelItems, Required, SqlFieldName = LevelItems_parRef ];

/// LevelItems_childSub
Property LevelItemschildSub As %Library.Float [ InitialExpression = {$i(^DHCCADATALEVELSETS($p(%d(0),$c(1),1),"Items",0))}, SqlColumnNumber = 2, SqlFieldName = LevelItems_childSub ];

/// LevelItems_ItemTypeDr
Property LevelItemsitemTypeDr As dhc.ca.cache.data.DataItemTypes [ SqlColumnNumber = 3, SqlFieldName = LevelItems_itemTypeDr ];

/// LevelItems_itemDr
Property LevelItemsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = LevelItems_itemDr ];

/// LevelItems_order
Property LevelItemsorder As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = LevelItems_order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="LevelItems_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LevelItems_itemTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LevelItems_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCADATALEVELSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DataLevelSets.DataLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LevelItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DataLevelSets.DataLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Items"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LevelItems_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DataLevelSets.DataLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LevelItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets.DataLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LevelItems_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LevelItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemSet">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DataLevelSets.DataLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LevelItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemSet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LevelItems_itemDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DataLevelSets.DataLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LevelItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DataLevelSets.DataLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LevelItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets.DataLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LevelItems_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LevelItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeItem">
<Global>^DHCCADATALEVELSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DataLevelSets.DataLevelSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LevelItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DataLevelSets.DataLevelSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LevelItems_itemTypeDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LevelItems_itemDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LevelItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.LevelItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
