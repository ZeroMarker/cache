Class dhc.ca.cache.data.Roles Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Roles_rowid, SqlTableName = Roles, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildRRights As dhc.ca.cache.data.RRights [ Cardinality = children, Inverse = RRightsparRef ];

Relationship ChildRDepts As dhc.ca.cache.data.RDepts [ Cardinality = children, Inverse = RDeptsparRef ];

Relationship ChildRItems As dhc.ca.cache.data.RItems [ Cardinality = children, Inverse = RItemsparRef ];

/// Roles_order
Property Rolesorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = Roles_order ];

/// Roles_code
Property Rolescode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Roles_code ];

/// Roles_name
Property Rolesname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Roles_name ];

/// Roles_shortcut
Property Rolesshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Roles_shortcut ];

/// Roles_deptDr
Property RolesdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 6, SqlFieldName = Roles_deptDr ];

/// Roles_page
Property Rolespage As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Roles_page ];

/// Roles_remark
Property Rolesremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Roles_remark ];

/// Roles_active
Property Rolesactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = Roles_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAROLES(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="Roles_active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Roles_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Roles_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Roles_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Roles_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Roles_page">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Roles_remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Roles_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCAROLES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Roles_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Roles_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Roles_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Roles_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Roles_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Roles_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Roles_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Roles_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Roles_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Roles_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortcut">
<Global>^DHCCAROLES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Roles_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shortcut"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Roles_shortcut}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Roles_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.RolesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
