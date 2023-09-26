Class dhc.ca.cache.data.InFiltItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InFiltItems_rowid, SqlTableName = InFiltItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On InFiltItemschildSub [ IdKey, PrimaryKey, Unique ];

/// InFiltRules Parent Reference
Relationship InFiltItemsparRef As dhc.ca.cache.data.InFiltRules [ Cardinality = parent, Inverse = ChildInFiltItems, Required, SqlFieldName = InFiltItems_parRef ];

/// InFiltItems_childSub
Property InFiltItemschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINFILTRULE($p(%d(0),$c(1),1),"Items",0))}, SqlColumnNumber = 2, SqlFieldName = InFiltItems_childSub ];

/// InFiltItems_Dr
Property InFiltItemsDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 3, SqlFieldName = InFiltItems_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="InFiltItems_Dr">
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
<Field>InFiltItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Items"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltItems_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItem">
<Global>^DHCCAINFILTRULE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InFiltRules.InFiltRules_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InFiltItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InFiltRules.InFiltRules_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InFiltItems_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InFiltItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InFiltItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
