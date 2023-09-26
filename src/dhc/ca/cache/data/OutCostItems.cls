Class dhc.ca.cache.data.OutCostItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutCostItems_rowid, SqlTableName = OutCostItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On OutCostItemschildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistMethods Parent Reference
Relationship OutCostItemsparRef As dhc.ca.cache.data.CostDistMethods [ Cardinality = parent, Inverse = ChildOutCostItems, Required, SqlFieldName = OutCostItems_parRef ];

/// OutCostItems_childSub
Property OutCostItemschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),"||"),"CDM",$p(%d(0),"||",2),"OutCostItem",0))}, SqlColumnNumber = 2, SqlFieldName = OutCostItems_childSub ];

/// OutCostItems_itemDr
Property OutCostItemsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 3, SqlFieldName = OutCostItems_itemDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="OutCostItems_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CostDistMethods.CostDistMethods_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OutCostItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistMethods.CostDistMethods_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OutCostItem"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutCostItems_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.OutCostItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
