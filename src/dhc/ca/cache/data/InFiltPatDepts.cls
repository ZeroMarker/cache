Class dhc.ca.cache.data.InFiltPatDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InFiltPatDepts_rowid, SqlTableName = InFiltPatDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InFiltPatDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// InFiltRules Parent Reference
Relationship InFiltPatDeptsparRef As dhc.ca.cache.data.InFiltRules [ Cardinality = parent, Inverse = ChildInFiltPatDepts, Required, SqlFieldName = InFiltPatDepts_parRef ];

/// InFiltPatDepts_childSub
Property InFiltPatDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINFILTRULE($p(%d(0),$c(1),1),"PatDepts",0))}, SqlColumnNumber = 2, SqlFieldName = InFiltPatDepts_childSub ];

/// InFiltPatDepts_Dr
Property InFiltPatDeptsDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 3, SqlFieldName = InFiltPatDepts_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InFiltPatDepts_Dr">
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
<Field>InFiltPatDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatDepts"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltPatDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatDept">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InFiltRules.InFiltRules_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InFiltPatDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatDept"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFiltPatDepts_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InFiltPatDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InFiltPatDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
