Class dhc.ca.cache.data.OutCostDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutCostDepts_rowid, SqlTableName = OutCostDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On OutCostDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistMethods Parent Reference
Relationship OutCostDeptsparRef As dhc.ca.cache.data.CostDistMethods [ Cardinality = parent, Inverse = ChildOutCostDepts, Required, SqlFieldName = OutCostDepts_parRef ];

/// OutCostDepts_childSub
Property OutCostDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),"||"),"CDM",$p(%d(0),"||",2),"OutCostDept",0))}, SqlColumnNumber = 2, SqlFieldName = OutCostDepts_childSub ];

/// OutCostDepts_deptDr
Property OutCostDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = OutCostDepts_deptDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="OutCostDepts_deptDr">
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
<Field>OutCostDepts_childSub</Field>
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
<Expression>"OutCostDept"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutCostDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.OutCostDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
