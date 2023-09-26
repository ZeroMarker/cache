Class User.DHCAdvDrugRepItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADVDRI_RowID, SqlTableName = DHC_AdvDrugRepItm, StorageStrategy = NewStorage1 ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADVDRIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrReport Parent Reference ADVDRI_ADRR_Parref
Relationship ADRRDIADRRParref As User.DHCAdvDrugReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPDRUGITM, Required, SqlFieldName = ADVDRI_ADRR_Parref ];

/// ADVDRI_ChildSub
Property ADVDRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADVDRI_ChildSub ];

/// ADVDRI_Type 
Property ADVDRIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADVDRI_Type ];

/// ADVDRI_OEORI_DR
Property ADVDRIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = ADVDRI_OEORI_DR ];

/// ADVDRI_ApprDocu
Property ADVDRIApprDocu As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ADVDRI_ApprDocu ];

/// ADVDRI_PHCD_DR
Property ADVDRIPHCDDR As User.PHCDrgMast [ SqlColumnNumber = 6, SqlFieldName = ADVDRI_PHCD_DR ];

/// ADVDRI_GoodsName
Property ADVDRIGoodsName As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ADVDRI_GoodsName ];

/// ADVDRI_Generic_DR
Property ADVDRIGenericDR As User.PHCGeneric [ SqlColumnNumber = 8, SqlFieldName = ADVDRI_Generic_DR ];

/// ADVDRI_PhForm_DR
Property ADVDRIPhFormDR As User.PHCForm [ SqlColumnNumber = 9, SqlFieldName = ADVDRI_PhForm_DR ];

/// ADVDRI_Manf_DR
Property ADVDRIManfDR As User.PHManufacturer [ SqlColumnNumber = 10, SqlFieldName = ADVDRI_Manf_DR ];

/// ADVDRI_ProductNo
Property ADVDRIProductNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ADVDRI_ProductNo ];

/// ADVDRI_Dosage
Property ADVDRIDosage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ADVDRI_Dosage ];

/// ADVDRI_DosUom_DR
Property ADVDRIDosUomDR As User.CTUOM [ SqlColumnNumber = 13, SqlFieldName = ADVDRI_DosUom_DR ];

/// ADVDRI_Instruc_DR
Property ADVDRIInstrucDR As User.PHCInstruc [ SqlColumnNumber = 14, SqlFieldName = ADVDRI_Instruc_DR ];

/// ADVDRI_Freq_DR
Property ADVDRIFreqDR As User.PHCFreq [ SqlColumnNumber = 15, SqlFieldName = ADVDRI_Freq_DR ];

/// ADVDRI_StartDate
Property ADVDRIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = ADVDRI_StartDate ];

/// ADVDRI_StartTime
Property ADVDRIStartTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = ADVDRI_StartTime ];

/// ADVDRI_EndDate
Property ADVDRIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = ADVDRI_EndDate ];

/// ADVDRI_EndTime
Property ADVDRIEndTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = ADVDRI_EndTime ];

/// ADVDRI_Reason_DR
Property ADVDRIReasonDR As %Library.String [ SqlColumnNumber = 20, SqlFieldName = ADVDRI_Reason_DR ];

/// ADVDRI_Reason
Property ADVDRIReason As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ADVDRI_Reason ];

Storage NewStorage1
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADVDRI_ApprDocu">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADVDRI_DosUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADVDRI_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ADVDRI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADVDRI_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADVDRI_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADVDRI_Generic_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADVDRI_GoodsName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADVDRI_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADVDRI_Manf_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADVDRI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADVDRI_PHCD_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADVDRI_PhForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADVDRI_ProductNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADVDRI_Reason">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ADVDRI_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ADVDRI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADVDRI_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADVDRI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVDRUGREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AdvDrugReport.ADVDR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADVDRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AdvDrugReport.ADVDR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Drug"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVDRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvDrugRepItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
