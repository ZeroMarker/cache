Class User.DHCPHPCDrgItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHDI_RowID, SqlTableName = DHC_PHPCDrgItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHDIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHPharCare Parent Reference PHDI_PHPC_Parref
Relationship PHDIPHPCParref As User.DHCPHPharCare [ Cardinality = parent, Inverse = ChildDHCPHPCDRGITM, Required, SqlFieldName = PHDI_PHPC_Parref ];

/// PHDI_ChildSub
Property PHDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHDI_ChildSub ];

/// PHDI_OEORI_DR  医嘱ID
Property PHDIOEORIDR As User.DHCPHMonItem [ SqlColumnNumber = 3, SqlFieldName = PHDI_OEORI_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHPharCare.PHPC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHPharCare.PHPC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPCDrgItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
