Class User.DHCPHAdrRepDrugItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRRDI_RowID, SqlTableName = DHC_PHAdrRepDrugItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADRRDIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrReport Parent Reference ADRRDI_ADRR_Parref
Relationship ADRRDIADRRParref As User.DHCPHAdrReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPDRUGITM, Required, SqlFieldName = ADRRDI_ADRR_Parref ];

/// ADRRDI_ChildSub
Property ADRRDIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADRRDI_ChildSub ];

/// ADRRDI_Type 
Property ADRRDIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRRDI_Type ];

/// ADRRDI_OEORI_DR
Property ADRRDIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = ADRRDI_OEORI_DR ];

/// ADRRDI_ApprDocu
Property ADRRDIApprDocu As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ADRRDI_ApprDocu ];

/// ADRRDI_PHCD_DR
Property ADRRDIPHCDDR As User.PHCDrgMast [ SqlColumnNumber = 6, SqlFieldName = ADRRDI_PHCD_DR ];

/// ADRRDI_GoodsName
Property ADRRDIGoodsName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ADRRDI_GoodsName ];

/// ADRRDI_Generic_DR
Property ADRRDIGenericDR As User.PHCGeneric [ SqlColumnNumber = 8, SqlFieldName = ADRRDI_Generic_DR ];

/// ADRRDI_PhForm_DR
Property ADRRDIPhFormDR As User.PHCForm [ SqlColumnNumber = 9, SqlFieldName = ADRRDI_PhForm_DR ];

/// ADRRDI_Manf_DR
Property ADRRDIManfDR As User.PHManufacturer [ SqlColumnNumber = 10, SqlFieldName = ADRRDI_Manf_DR ];

/// ADRRDI_ProductNo
Property ADRRDIProductNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ADRRDI_ProductNo ];

/// ADRRDI_Dosage
Property ADRRDIDosage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ADRRDI_Dosage ];

/// ADRRDI_DosUom_DR
Property ADRRDIDosUomDR As User.CTUOM [ SqlColumnNumber = 13, SqlFieldName = ADRRDI_DosUom_DR ];

/// ADRRDI_Instruc_DR
Property ADRRDIInstrucDR As User.PHCInstruc [ SqlColumnNumber = 14, SqlFieldName = ADRRDI_Instruc_DR ];

/// ADRRDI_Freq_DR
Property ADRRDIFreqDR As User.PHCFreq [ SqlColumnNumber = 15, SqlFieldName = ADRRDI_Freq_DR ];

/// ADRRDI_StartDate
Property ADRRDIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = ADRRDI_StartDate ];

/// ADRRDI_StartTime
Property ADRRDIStartTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = ADRRDI_StartTime ];

/// ADRRDI_EndDate
Property ADRRDIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = ADRRDI_EndDate ];

/// ADRRDI_EndTime
Property ADRRDIEndTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = ADRRDI_EndTime ];

/// ADRRDI_Reason_DR
Property ADRRDIReasonDR As User.DHCPHAdrReasonForMed [ SqlColumnNumber = 20, SqlFieldName = ADRRDI_Reason_DR ];

/// ADRRDI_Reason
Property ADRRDIReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ADRRDI_Reason ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADRRDI_ApprDocu">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADRRDI_DosUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADRRDI_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADRRDI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADRRDI_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADRRDI_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADRRDI_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADRRDI_GoodsName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADRRDI_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADRRDI_Manf_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADRRDI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRRDI_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADRRDI_PhForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADRRDI_ProductNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADRRDI_Reason">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADRRDI_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADRRDI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADRRDI_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADRRDI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHADRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAdrReport.ADRR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADRRDI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdrReport.ADRR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADRRDI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRRDI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrRepDrugItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
