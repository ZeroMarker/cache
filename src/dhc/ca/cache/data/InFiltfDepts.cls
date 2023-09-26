Class dhc.ca.cache.data.InFiltfDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InFiltfDepts_rowid, SqlTableName = InFiltfDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InFiltfDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// InFiltRules Parent Reference
Relationship InFiltfDeptsparRef As dhc.ca.cache.data.InFiltRules [ Cardinality = parent, Inverse = ChildInFiltfDepts, Required, SqlFieldName = InFiltfDepts_parRef ];

/// InFiltfDepts_childSub
Property InFiltfDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINFILTRULE($p(%d(0),$c(1),1),"FDepts",0))}, SqlColumnNumber = 2, SqlFieldName = InFiltfDepts_childSub ];

/// InFiltfDepts_Dr
Property InFiltfDeptsDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = InFiltfDepts_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InFiltfDepts_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAINFILTRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InFiltRules.InFiltRules_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>InFiltfDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FDepts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltfDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFDept">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InFiltRules.InFiltRules_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InFiltfDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFiltfDepts_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InFiltfDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InFiltfDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
