Class dhc.ca.cache.data.DeptCostSrc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DeptCostSrc_rowid, SqlTableName = DeptCostSrc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DeptCostSrcchildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistSets Parent Reference
Relationship DeptCostSrcparRef As dhc.ca.cache.data.CostDistSets [ Cardinality = parent, Inverse = ChildDeptCostSrc, Required, SqlFieldName = DeptCostSrc_parRef ];

/// DeptCostSrc_childSub
Property DeptCostSrcchildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),$c(1),1),"DeptCostSrc",0))}, SqlColumnNumber = 2, SqlFieldName = DeptCostSrc_childSub ];

/// DeptCostSrc_intervalDr
Property DeptCostSrcintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 3, SqlFieldName = DeptCostSrc_intervalDr ];

/// DeptCostSrc_deptDr
Property DeptCostSrcdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = DeptCostSrc_deptDr ];

/// DeptCostSrc_cost
Property DeptCostSrccost As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DeptCostSrc_cost ];

/// DeptCostSrc_distDeptDr
Property DeptCostSrcdistDeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 6, SqlFieldName = DeptCostSrc_distDeptDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="DeptCostSrc_cost">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DeptCostSrc_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DeptCostSrc_distDeptDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DeptCostSrc_intervalDr">
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
<Field>DeptCostSrc_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptCostSrc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptCostSrc_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.cache.data.DeptCostSrcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
