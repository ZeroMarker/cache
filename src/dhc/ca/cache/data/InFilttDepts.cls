Class dhc.ca.cache.data.InFilttDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InFilttDepts_rowid, SqlTableName = InFilttDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InFilttDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// InFiltRules Parent Reference
Relationship InFilttDeptsparRef As dhc.ca.cache.data.InFiltRules [ Cardinality = parent, Inverse = ChildInFilttDepts, Required, SqlFieldName = InFilttDepts_parRef ];

/// InFilttDepts_childSub
Property InFilttDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINFILTRULE($p(%d(0),$c(1),1),"TDepts",0))}, SqlColumnNumber = 2, SqlFieldName = InFilttDepts_childSub ];

/// InFilttDepts_Dr
Property InFilttDeptsDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = InFilttDepts_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InFilttDepts_Dr">
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
<Field>InFilttDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TDepts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFilttDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTDept">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InFiltRules.InFiltRules_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InFilttDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFilttDepts_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InFilttDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InFilttDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
