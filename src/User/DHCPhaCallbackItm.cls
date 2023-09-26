Class User.DHCPhaCallbackItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPCI_RowID, SqlTableName = DHC_PhaCallbackItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCPCIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PhaCallback Parent Reference
Relationship DHCPCIDHCPCParRef As User.DHCPhaCallback [ Cardinality = parent, Inverse = ChildDHCPhaCallbackItm, Required, SqlFieldName = DHCPCI_DHCPC_ParRef ];

/// DHCPCI_INCI_DR  User.INCItm
Property DHCPCIINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = DHCPCI_INCI_DR ];

/// DHCPCI_CTUOM_DR User.CTUOM
Property DHCPCICTUOMDR As User.CTUOM [ SqlColumnNumber = 4, SqlFieldName = DHCPCI_CTUOM_DR ];

/// DHCPCI_Qty
Property DHCPCIQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DHCPCI_Qty ];

/// DHCPCI_Price
Property DHCPCIPrice As %Library.Numeric(SCALE = 4) [ SqlColumnNumber = 6, SqlFieldName = DHCPCI_Price ];

Property DHCPCIAvailableQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DHCPCI_AvailableQty ];

/// DHCPCI_ChildSub
Property DHCPCIChildSub As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCPCI_ChildSub ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DHCPhaCallbackItmmaster">
<Data name="DHCPCI_AvailableQty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCPCI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPCI_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPCI_DHCPC_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPCI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPCI_Price">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPCI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPCB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaCallback.DHCPC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCPCI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PhaCallback.DHCPC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCPCI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaCallbackItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
