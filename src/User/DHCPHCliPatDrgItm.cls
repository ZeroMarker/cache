Class User.DHCPHCliPatDrgItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCPDI_RowID, SqlTableName = DHC_PHCliPatDrgItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHCPDIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHCliPathography Parent Reference PHCPDI_PHCP_Parref
Relationship PHCPDIPHCPParref As User.DHCPHCliPathography [ Cardinality = parent, Inverse = ChildDHCPHCLIPATDRGITM, Required, SqlFieldName = PHCPDI_PHCP_Parref ];

/// PHCPDI_ChildSub
Property PHCPDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHCPDI_ChildSub ];

/// PHCPDI_OEORI_DR  医嘱ID
Property PHCPDIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PHCPDI_OEORI_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHCPDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHCliPathography.PHCP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCPDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHCliPathography.PHCP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCPDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCliPatDrgItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
