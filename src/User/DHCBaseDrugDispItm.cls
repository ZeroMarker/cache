Class User.DHCBaseDrugDispItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BDDI_RowId, SqlTableName = DHC_BaseDrugDispItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On BDDIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCBaseDrugDispItmOrd As User.DHCBaseDrugDispItmOrd [ Cardinality = children, Inverse = BDDIOBDIParref ];

/// DHC_BaseDrugDisp Parent Reference
Relationship BDDIBDDParRef As User.DHCBaseDrugDisp [ Cardinality = parent, Inverse = ChildDHCBaseDrugDispItm, Required, SqlFieldName = BDDI_BDD_ParRef ];

/// BDDI_ChildSub
Property BDDIChildSub As %Library.Float [ InitialExpression = {$i(^DHCBDD($p(%d(0),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = BDDI_ChildSub ];

/// BDDI_INCI_DR
Property BDDIINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = BDDI_INCI_DR ];

/// BDDI_DispQty
Property BDDIDispQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = BDDI_DispQty ];

/// BDDI_ReqQty
Property BDDIReqQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = BDDI_ReqQty ];

/// BDDI_ReqItm
Property BDDIReqItm As User.INReqItm [ SqlColumnNumber = 6, SqlFieldName = BDDI_ReqItm ];

/// BDDI_RestQty
Property BDDIRestQty As %Library.Float [ SqlColumnNumber = 7, SqlComputeCode = { s {BDDI_RestQty}={BDDI_DispQty}+{BDDI_LastRestQty}-{BDDI_ReqQty}-{BDDI_ClearQty}
}, SqlComputed, SqlFieldName = BDDI_RestQty, Transient ];

/// BDDI_CTLOC_DR
Property BDDICTLOCDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = BDDI_CTLOC_DR ];

/// BDDI_LastRestQty
Property BDDILastRestQty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BDDI_LastRestQty ];

/// BDDI_ClearQty
Property BDDIClearQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = BDDI_ClearQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="BDDI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDDI_ClearQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BDDI_DispQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDDI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDDI_LastRestQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BDDI_ReqItm">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDDI_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCBDD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BaseDrugDisp.BDD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>BDDI_ChildSub</Field>
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
<Expression>{BDDI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCILoc">
<Global>^DHCBDD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_BaseDrugDisp.BDD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>BDDI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCI_LOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BDDI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDDI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_BaseDrugDisp.BDD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{BDDI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexreqitm">
<Global>^DHCBDD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_BaseDrugDisp.BDD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>BDDI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BDDI_ReqItm}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_BaseDrugDisp.BDD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BDDI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBaseDrugDispItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
