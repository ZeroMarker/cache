Class User.DHCPHMonSubClassItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHMSCI_RowID, SqlTableName = DHC_PHMonSubClassItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHMSCIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHMonSubClass Parent Reference PHMSCI_PHMSC_Parref
Relationship PHMSCIPHMSCParref As User.DHCPHMonSubClass [ Cardinality = parent, Inverse = ChildDHCPHMONSUBCLASSITM, Required, SqlFieldName = PHMSCI_PHMSC_Parref ];

/// PHMSCI_ChildSub
Property PHMSCIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHMSCI_ChildSub ];

/// PHMSCI_Loc_Dr
Property PHMSCILocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHMSCI_Loc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DateMaster">
<Data name="PHMSCI_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHMSC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHMonSubClass.PHMSC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHMSCI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHMonSubClass.PHMSC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMSCI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocDr">
<Global>^DHCPHMSC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHMonSubClass.PHMSC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHMSCI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHMSCI_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHMonSubClass.PHMSC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHMSCI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMonSubClassItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
