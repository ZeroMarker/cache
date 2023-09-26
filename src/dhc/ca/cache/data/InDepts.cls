Class dhc.ca.cache.data.InDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InDepts_rowid, SqlTableName = InDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InDeptschildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOutDepts As dhc.ca.cache.data.OutDepts [ Cardinality = children, Inverse = OutDeptsparRef ];

/// InDeptSets Parent Reference
Relationship InDeptsparRef As dhc.ca.cache.data.InDeptSets [ Cardinality = parent, Inverse = ChildInDepts, Required, SqlFieldName = InDepts_parRef ];

/// InDepts_childSub
Property InDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINDEPTSETS($p(%d(0),$c(1),1),"InDepts",0))}, SqlColumnNumber = 2, SqlFieldName = InDepts_childSub ];

/// InDepts_order
Property InDeptsorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = InDepts_order ];

/// InDepts_deptDr
Property InDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = InDepts_deptDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InDepts_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InDepts_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAINDEPTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>InDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InDepts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInDept">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDepts_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInOrder">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDepts_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
