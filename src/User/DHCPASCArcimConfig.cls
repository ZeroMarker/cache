Class User.DHCPASCArcimConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPACS_ROWID, SqlTableName = DHC_PASCArcimConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCPACS_BodySystems_DR
Property DHCPACSBodySystemsDR As User.MRCBodySystems [ SqlColumnNumber = 3, SqlFieldName = DHCPACS_BodySystems_DR ];

/// DHCPACS_ARCIM_DR
Property DHCPACSARCIMDR As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = DHCPACS_ARCIM_DR ];

/// DHCPACS_Parent_DR
Property DHCPACSParentDR As User.DHCPASCArcimConfig [ SqlColumnNumber = 5, SqlFieldName = DHCPACS_Parent_DR ];

/// DHCPACS_Type
Property DHCPACSType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHCPACS_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACSARCIM)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCPACS_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPACS_BodySystems_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPACS_Parent_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPACS_ROWID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPACS_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPACSARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPACS_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCPACS_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDHCPACSParentDR">
<Global>^DHCPACSARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCPACS_ROWID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Parent"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCPACS_Parent_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCPACS_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPASCArcimConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
