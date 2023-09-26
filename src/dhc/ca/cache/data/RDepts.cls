Class dhc.ca.cache.data.RDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RDepts_rowid, SqlTableName = RDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// Roles Parent Reference
Relationship RDeptsparRef As dhc.ca.cache.data.Roles [ Cardinality = parent, Inverse = ChildRDepts, Required, SqlFieldName = RDepts_parRef ];

/// RDepts_childSub
Property RDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAROLES($p(%d(0),$c(1),1),"RDepts",0))}, SqlColumnNumber = 2, SqlFieldName = RDepts_childSub ];

/// RDepts_order
Property RDeptsorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = RDepts_order ];

/// RDepts_deptDr
Property RDeptsdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = RDepts_deptDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="RDepts_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RDepts_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAROLES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RDepts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRDDeptdr">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RDDeptdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RDepts_deptDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRDOrder">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RDOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RDepts_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.RDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
