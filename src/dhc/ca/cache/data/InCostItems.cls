Class dhc.ca.cache.data.InCostItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InCostItems_rowid, SqlTableName = InCostItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InCostItemschildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistMethods Parent Reference
Relationship InCostItemsparRef As dhc.ca.cache.data.CostDistMethods [ Cardinality = parent, Inverse = ChildInCostItems, Required, SqlFieldName = InCostItems_parRef ];

/// InCostItems_childSub
Property InCostItemschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),"||"),"CDM",$p(%d(0),"||",2),"InCostItem",0))}, SqlColumnNumber = 2, SqlFieldName = InCostItems_childSub ];

/// InCostItems_itemDr
Property InCostItemsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 3, SqlFieldName = InCostItems_itemDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InCostItems_itemDr">
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
<Field>InCostItems_childSub</Field>
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
<Expression>"InCostItem"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InCostItems_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InCostItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
