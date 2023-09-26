Class dhc.ca.cache.data.DeptCostItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DeptCostItem_rowid, SqlTableName = DeptCostItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DeptCostItemchildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistSets Parent Reference
Relationship DeptCostItemparRef As dhc.ca.cache.data.CostDistSets [ Cardinality = parent, Inverse = ChildDeptCostItem, Required, SqlFieldName = DeptCostItem_parRef ];

/// DeptCostItem_childSub
Property DeptCostItemchildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),$c(1),1),"DeptCostItem",0))}, SqlColumnNumber = 2, SqlFieldName = DeptCostItem_childSub ];

/// DeptCostItem_intervalDr
Property DeptCostItemintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 3, SqlFieldName = DeptCostItem_intervalDr ];

/// DeptCostItem_deptDr
Property DeptCostItemdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = DeptCostItem_deptDr ];

/// DeptCostItem_item
Property DeptCostItemitem As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 5, SqlFieldName = DeptCostItem_item ];

/// DeptCostItem_bubgCost
Property DeptCostItembubgCost As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DeptCostItem_bubgCost ];

/// DeptCostItem_primeCost
Property DeptCostItemprimeCost As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DeptCostItem_primeCost ];

/// DeptCostItem_allocCost1
Property DeptCostItemallocCost1 As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DeptCostItem_allocCost1 ];

/// DeptCostItem_allocCost2
Property DeptCostItemallocCost2 As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DeptCostItem_allocCost2 ];

/// DeptCostItem_allocCost3
Property DeptCostItemallocCost3 As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DeptCostItem_allocCost3 ];

/// DeptCostItem_allocCost4
Property DeptCostItemallocCost4 As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = DeptCostItem_allocCost4 ];

/// DeptCostItem_allocCost5
Property DeptCostItemallocCost5 As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DeptCostItem_allocCost5 ];

/// DeptCostItem_allocCost6
Property DeptCostItemallocCost6 As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = DeptCostItem_allocCost6 ];

/// DeptCostItem_allocCost7
Property DeptCostItemallocCost7 As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DeptCostItem_allocCost7 ];

/// DeptCostItem_allocCost8
Property DeptCostItemallocCost8 As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DeptCostItem_allocCost8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="DeptCostItem_allocCost1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DeptCostItem_allocCost2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DeptCostItem_allocCost3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DeptCostItem_allocCost4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DeptCostItem_allocCost5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DeptCostItem_allocCost6">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DeptCostItem_allocCost7">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DeptCostItem_allocCost8">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DeptCostItem_bubgCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DeptCostItem_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DeptCostItem_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DeptCostItem_item">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DeptCostItem_primeCost">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DeptCostItem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptCostItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptCostItem_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInterval">
<Global>^DHCCACOSTDISTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DeptCostItem_childSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIntervalItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DeptCostItem_intervalDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DeptCostItem_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.cache.d60B.DeptCostItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
