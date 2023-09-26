Class dhc.ca.cache.data.RRights Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RRights_rowid, SqlTableName = RRights, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RRightschildSub [ IdKey, PrimaryKey, Unique ];

/// Roles Parent Reference
Relationship RRightsparRef As dhc.ca.cache.data.Roles [ Cardinality = parent, Inverse = ChildRRights, Required, SqlFieldName = RRights_parRef ];

/// RRights_childSub
Property RRightschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAROLES($p(%d(0),$c(1),1),"RRights",0))}, SqlColumnNumber = 2, SqlFieldName = RRights_childSub ];

/// RRights_order
Property RRightsorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = RRights_order ];

/// RRights_name
Property RRightsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RRights_name ];

/// RRights_active
Property RRightsactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = RRights_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="RRights_active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RRights_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RRights_order">
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
<Field>RRights_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RRights"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RRights_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRRActive">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RRights_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RRActive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RRights_active}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RRights_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRRName">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RRights_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RRName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RRights_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RRights_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRROrder">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Roles.Roles_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RRights_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RROrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles.Roles_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RRights_order}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RRights_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.RRightsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
