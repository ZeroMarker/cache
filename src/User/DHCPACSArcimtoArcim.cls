Class User.DHCPACSArcimtoArcim Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCARC_Rowid, SqlTableName = DHC_PACSArcimtoArcim, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCARC_Nor_Arcim_DR
Property DHCARCNorArcimDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DHCARC_Nor_Arcim_DR ];

/// DHCARC_Add_Arcim_DR
Property DHCARCAddArcimDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DHCARC_Add_Arcim_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACSARCTOARC)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DHCARC_Add_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCARC_Nor_Arcim_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCARC_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPACSARCTOARC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCARC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCARC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNorArcim">
<Global>^DHCPACSARCTOARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCARC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NorArcim"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCARC_Nor_Arcim_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCARC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPACSArcimtoArcimS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
