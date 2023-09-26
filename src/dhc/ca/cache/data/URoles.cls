Class dhc.ca.cache.data.URoles Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = URoles_rowid, SqlTableName = URoles, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On URoleschildSub [ IdKey, PrimaryKey, Unique ];

/// Users Parent Reference
Relationship URolesparRef As dhc.ca.cache.data.Users [ Cardinality = parent, Inverse = ChildURoles, Required, SqlFieldName = URoles_parRef ];

/// URoles_childSub
Property URoleschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAUSERS($p(%d(0),$c(1),1),"URoles",0))}, SqlColumnNumber = 2, SqlFieldName = URoles_childSub ];

/// URoles_order
Property URolesorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = URoles_order ];

/// URoles_roleDr
Property URolesroleDr As dhc.ca.cache.data.Roles [ SqlColumnNumber = 4, SqlFieldName = URoles_roleDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="URoles_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="URoles_roleDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCAUSERS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Users.Users_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>URoles_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Users.Users_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"URoles"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{URoles_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUROrder">
<Global>^DHCCAUSERS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Users.Users_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>URoles_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UROrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Users.Users_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{URoles_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{URoles_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexURole">
<Global>^DHCCAUSERS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Users.Users_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>URoles_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"URole"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Users.Users_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{URoles_roleDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{URoles_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.URolesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
