Class dhc.ca.cache.data.OutRecDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutRecDepts_rowid, SqlTableName = OutRecDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On OutRecDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistMethods Parent Reference
Relationship OutRecDeptsparRef As dhc.ca.cache.data.CostDistMethods [ Cardinality = parent, Inverse = ChildOutRecDepts, Required, SqlFieldName = OutRecDepts_parRef ];

/// OutRecDepts_childSub
Property OutRecDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),"||"),"CDM",$p(%d(0),"||",2),"OutRecDept",0))}, SqlColumnNumber = 2, SqlFieldName = OutRecDepts_childSub ];

/// OutRecDepts_deptDr
Property OutRecDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = OutRecDepts_deptDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="OutRecDepts_deptDr">
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
<Field>OutRecDepts_childSub</Field>
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
<Expression>"OutRecDept"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutRecDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.OutRecDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
