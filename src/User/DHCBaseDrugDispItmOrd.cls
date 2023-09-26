Class User.DHCBaseDrugDispItmOrd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BDDIO_RowId, SqlTableName = DHC_BaseDrugDispItmOrd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On BDDIOChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_BaseDrugDispItm Parent Reference
Relationship BDDIOBDIParref As User.DHCBaseDrugDispItm [ Cardinality = parent, Inverse = ChildDHCBaseDrugDispItmOrd, Required, SqlFieldName = BDDIO_BDI_Parref ];

/// BDIO_ChildSub
Property BDDIOChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = BDDIO_ChildSub ];

/// BDIO_OEORI_DR
Property BDDIOOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = BDDIO_OEORI_DR ];

/// BDIO_Qty
Property BDDIOQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BDDIO_Qty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BDDIO_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDDIO_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCBDD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BaseDrugDisp.BDD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_BaseDrugDispItm.BDDI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>BDDIO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_BaseDrugDisp.BDD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_BaseDrugDispItm.BDDI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BDDIO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCBaseDrugDispItmOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
