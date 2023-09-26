Class dhc.ca.cache.data.InCostDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InCostDepts_rowid, SqlTableName = InCostDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InCostDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistMethods Parent Reference
Relationship InCostDeptsparRef As dhc.ca.cache.data.CostDistMethods [ Cardinality = parent, Inverse = ChildInCostDepts, Required, SqlFieldName = InCostDepts_parRef ];

/// InCostDepts_childSub
Property InCostDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),"||"),"CDM",$p(%d(0),"||",2),"InCostDept",0))}, SqlColumnNumber = 2, SqlFieldName = InCostDepts_childSub ];

/// InCostDepts_deptDr
Property InCostDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = InCostDepts_deptDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InCostDepts_deptDr">
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
<Field>InCostDepts_childSub</Field>
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
<Expression>"InCostDept"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InCostDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InCostDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
