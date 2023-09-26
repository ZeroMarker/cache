Class User.DHCPHDrgMisRepDrgItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMRDI_RowID, SqlTableName = DHC_PHDrgMisRepDrgItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DMRDIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHDrgMisReport Parent Reference DMRDI_DMR_Parref
Relationship DMRDIDMRParref As User.DHCPHDrgMisReport [ Cardinality = parent, Inverse = ChildDHCPHDRGMISREPDRGITM, Required, SqlFieldName = DMRDI_DMR_Parref ];

/// DMRDI_ChildSub
Property DMRDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DMRDI_ChildSub ];

/// DMRDI_OEORI_DR
Property DMRDIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DMRDI_OEORI_DR ];

/// DMRDI_PHCD_DR
Property DMRDIPHCDDR As User.PHCDrgMast [ SqlColumnNumber = 4, SqlFieldName = DMRDI_PHCD_DR ];

/// DMRDI_GoodsName
Property DMRDIGoodsName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DMRDI_GoodsName ];

/// DMRDI_Generic_DR
Property DMRDIGenericDR As User.PHCGeneric [ SqlColumnNumber = 6, SqlFieldName = DMRDI_Generic_DR ];

/// DMRDI_PhForm_DR
Property DMRDIPhFormDR As User.PHCForm [ SqlColumnNumber = 7, SqlFieldName = DMRDI_PhForm_DR ];

/// DMRDI_Dosage
Property DMRDIDosage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DMRDI_Dosage ];

/// DMRDI_DosUom_DR
Property DMRDIDosUomDR As User.CTUOM [ SqlColumnNumber = 9, SqlFieldName = DMRDI_DosUom_DR ];

/// DMRDI_Instruc_DR
Property DMRDIInstrucDR As User.PHCInstruc [ SqlColumnNumber = 10, SqlFieldName = DMRDI_Instruc_DR ];

/// DMRDI_Freq_DR
Property DMRDIFreqDR As User.PHCFreq [ SqlColumnNumber = 11, SqlFieldName = DMRDI_Freq_DR ];

/// DMRDI_Manf_DR
Property DMRDIManfDR As User.PHManufacturer [ SqlColumnNumber = 12, SqlFieldName = DMRDI_Manf_DR ];

/// DMRDI_Classify
Property DMRDIClassify As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DMRDI_Classify ];

/// DMRDI_Spec
Property DMRDISpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DMRDI_Spec ];

/// DMRDI_PackType
Property DMRDIPackType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DMRDI_PackType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DMRDI_Classify">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DMRDI_DosUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DMRDI_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DMRDI_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DMRDI_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DMRDI_GoodsName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DMRDI_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DMRDI_Manf_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DMRDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMRDI_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMRDI_PackType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DMRDI_PhForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DMRDI_Spec">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCPHDMR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHDrgMisReport.DMR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DMRDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHDrgMisReport.DMR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DMRDI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMRDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHDrgMisRepDrgItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
