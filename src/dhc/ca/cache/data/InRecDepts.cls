Class dhc.ca.cache.data.InRecDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InRecDepts_rowid, SqlTableName = InRecDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InRecDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistMethods Parent Reference
Relationship InRecDeptsparRef As dhc.ca.cache.data.CostDistMethods [ Cardinality = parent, Inverse = ChildInRecDepts, Required, SqlFieldName = InRecDepts_parRef ];

/// InRecDepts_childSub
Property InRecDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),"||"),"CDM",$p(%d(0),"||",2),"InRecDept",0))}, SqlColumnNumber = 2, SqlFieldName = InRecDepts_childSub ];

/// InRecDepts_deptDr
Property InRecDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = InRecDepts_deptDr ];

/// InRecDepts_rate
Property InRecDeptsrate As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = InRecDepts_rate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InRecDepts_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="InRecDepts_rate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Field>InRecDepts_childSub</Field>
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
<Expression>"InRecDept"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InRecDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InRecDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
