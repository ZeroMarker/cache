Class dhc.ca.cache.data.RItems Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RItems_rowid, SqlTableName = RItems, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RItemschildSub [ IdKey, PrimaryKey, Unique ];

/// Roles Parent Reference
Relationship RItemsparRef As dhc.ca.cache.data.Roles [ Cardinality = parent, Inverse = ChildRItems, Required, SqlFieldName = RItems_parRef ];

/// RItems_childSub
Property RItemschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAROLES($p(%d(0),$c(1),1),"RItems",0))}, SqlColumnNumber = 2, SqlFieldName = RItems_childSub ];

/// RItems_order
Property RItemsorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = RItems_order ];

/// RItems_itemDr
Property RItemsitemDr As dhc.ca.cache.data.AllDataItems [ SqlColumnNumber = 4, SqlFieldName = RItems_itemDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="RItems_itemDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RItems_order">
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
<Field>RItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RItems"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RItems_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRIItemdr">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RIItemdr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RItems_itemDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRIOrder">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RItems_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RIOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RItems_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RItems_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.RItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
