/// PHC Drug Form           (PHCDF,520)
Class User.PHCDrgForm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_DrgForm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHCDFChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildPHCFormDoseEquiv As PHCFormDoseEquiv [ Cardinality = children, Inverse = EQParRef ];

Relationship ChildPHCDrgFormForms As PHCDrgFormForms [ Cardinality = children, Inverse = FRMParRef ];

/// PHCD Parent Reference (Drug master)
Relationship PHCDFPHCDParRef As PHCDrgMast [ Cardinality = parent, Inverse = ChildPHCDrgForm, Required, SqlFieldName = PHCDF_PHCD_ParRef ];

Relationship ChildPHCDrgFormProp As PHCDrgFormProp [ Cardinality = children, Inverse = PHCDFPParRef ];

/// Des Ref to PHCF (Form Code)
Property PHCDFPHCFDR As PHCForm [ SqlColumnNumber = 2, SqlFieldName = PHCDF_PHCF_DR ];

/// Des Ref to PHCP (Per)
Property PHCDFPHCPDR As PHCPer [ SqlColumnNumber = 4, SqlFieldName = PHCDF_PHCP_DR ];

/// Des Ref to PHCS (Strength)
Property PHCDFPHCSDR As PHCStrength [ SqlColumnNumber = 5, SqlFieldName = PHCDF_PHCS_DR ];

/// Des Ref to PHCPA (Packing)
Property PHCDFPHCPADR As PHCPack [ SqlColumnNumber = 6, SqlFieldName = PHCDF_PHCPA_DR ];

/// Price 1 - MIMS (info)
Property PHCDFPrice1 As %Float(MAXVAL = 9999999.99, MINVAL = 0) [ SqlColumnNumber = 7, SqlFieldName = PHCDF_Price1 ];

/// Price 2 - MIMS (info)
Property PHCDFPrice2 As %Float(MAXVAL = 9999999.99, MINVAL = 0) [ SqlColumnNumber = 8, SqlFieldName = PHCDF_Price2 ];

/// PHCDF ChildSub (New Key)
Property PHCDFChildSub As %Float(MAXVAL = 999999999, MINVAL = 1) [ InitialExpression = {$i(^PHCD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"DF",0))}, Required, SqlColumnNumber = 9, SqlFieldName = PHCDF_ChildSub ];

/// Des Ref to PHCFR (Frequency)
Property PHCDFPHCFRDR As PHCFreq [ SqlColumnNumber = 10, SqlFieldName = PHCDF_PHCFR_DR ];

/// Des Ref to PHCIN (Instruction)
Property PHCDFPHCINDR As PHCInstruc [ SqlColumnNumber = 11, SqlFieldName = PHCDF_PHCIN_DR ];

/// Des Ref to PHCDO (Dosage)
Property PHCDFPHCDODR As PHCDosage [ SqlColumnNumber = 12, SqlFieldName = PHCDF_PHCDO_DR ];

/// Indication (info)
Property PHCDFIndication As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PHCDF_Indication, SqlListType = SUBNODE ];

/// Contra Indication (info)
Property PHCDFContraInd As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PHCDF_ContraInd, SqlListType = SUBNODE ];

/// Special Precautions (info)
Property PHCDFPrecaution As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PHCDF_Precaution, SqlListType = SUBNODE ];

/// Adverse Reaction (info)
Property PHCDFAdvReaction As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PHCDF_AdvReaction, SqlListType = SUBNODE ];

/// MIMS number
Property PHCDFMIMSno As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PHCDF_MIMSno ];

/// Des Ref to PHCDU  (Duartion)
Property PHCDFPHCDUDR As PHCDuration [ SqlColumnNumber = 19, SqlFieldName = PHCDF_PHCDU_DR ];

/// ATC Bin
Property PHCDFATCBin As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PHCDF_ATCBin ];

/// Des Ref to CTUOM
Property PHCDFCTUOMDR As CTUOM [ SqlColumnNumber = 21, SqlFieldName = PHCDF_CTUOM_DR ];

/// Base Qty
Property PHCDFBaseQty As %Float [ SqlColumnNumber = 22, SqlFieldName = PHCDF_BaseQty ];

/// Deduct Partially
Property PHCDFDeductPartially As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 23, SqlFieldName = PHCDF_DeductPartially ];

/// Update Date
Property PHCDFUpdateDate As %Date [ SqlColumnNumber = 24, SqlFieldName = PHCDF_UpdateDate ];

/// Update Time
Property PHCDFUpdateTime As %Time [ SqlColumnNumber = 25, SqlFieldName = PHCDF_UpdateTime ];

/// Update User
Property PHCDFUpdateUser As SSUser [ SqlColumnNumber = 26, SqlFieldName = PHCDF_UpdateUser ];

/// Des Ref PHCDU
Property PHCDFInPatDurationDR As PHCDuration [ SqlColumnNumber = 27, SqlFieldName = PHCDF_InPatDuration_DR ];

/// Official Code
Property PHCDFOfficialCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = PHCDF_OfficialCode ];

/// Max Number of Repeats
Property PHCDFMaxNumberRepeats As %Float [ SqlColumnNumber = 29, SqlFieldName = PHCDF_MaxNumberRepeats ];

/// Interaction
Property PHCDFInteraction As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PHCDF_Interaction, SqlListType = SUBNODE ];

/// Warning
Property PHCDFWarning As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = PHCDF_Warning, SqlListType = SUBNODE ];

/// Date From
Property PHCDFDateFrom As %Date [ SqlColumnNumber = 32, SqlFieldName = PHCDF_DateFrom ];

/// Date To
Property PHCDFDateTo As %Date [ SqlColumnNumber = 33, SqlFieldName = PHCDF_DateTo ];

/// Des Ref GenRtForm
Property PHCDFGenRtFormDR As PHCGenericRtForms [ SqlColumnNumber = 34, SqlFieldName = PHCDF_GenRtForm_DR ];

/// Des Ref Route
Property PHCDFRouteDR As OECRoute [ SqlColumnNumber = 35, SqlFieldName = PHCDF_Route_DR ];

/// Formulary
Property PHCDFFormulary As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = PHCDF_Formulary ];

/// Preferred
Property PHCDFPreferred As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = PHCDF_Preferred ];

/// Des Ref AdminRoute
Property PHCDFAdminRouteDR As PHCAdministrationRoute [ SqlColumnNumber = 38, SqlFieldName = PHCDF_AdminRoute_DR ];

/// RoundIndivAdmin
Property PHCDFRoundIndivAdmin As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = PHCDF_RoundIndivAdmin ];

/// IV Expiry
Property PHCDFIVExpiry As %Float [ SqlColumnNumber = 40, SqlFieldName = PHCDF_IVExpiry ];

/// Volume
Property PHCDFVolume As %Float [ SqlColumnNumber = 41, SqlFieldName = PHCDF_Volume ];

/// Monograph
Property PHCDFMonograph As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = PHCDF_Monograph, SqlListType = SUBNODE ];

/// PBS Quan
Property PHCDFPBSQuan As %Float [ SqlColumnNumber = 43, SqlFieldName = PHCDF_PBSQuan ];

/// Des Ref Poison
Property PHCDFPoisonDR As PHCPoison [ SqlColumnNumber = 44, SqlFieldName = PHCDF_Poison_DR ];

/// RegionCodeFDB
Property PHCDFRegionCodeFDB As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = PHCDF_RegionCodeFDB ];

/// NeverCalculateQty
Property PHCDFNeverCalculateQty As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = PHCDF_NeverCalculateQty ];

/// ExternalData
Property PHCDFExternalData As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = PHCDF_ExternalData ];

/// Modified
Property PHCDFModified As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = PHCDF_Modified ];

/// ExtraDetails
Property PHCDFExtraDetails As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = PHCDF_ExtraDetails ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCDrgForm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgForm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCDrgForm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgForm","OnAfterUpdate")
#; d POFILUPD^at520
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCDrgForm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgForm","OnBeforeDelete")
#; d VALDEL^at520({PHCDF_RowId})
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCDrgForm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgForm","OnBeforeUpdate")
 //d VALUPD^at520
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgForm","OnBeforeInsert")
 d PRFILINS^at520({PHCDF_RowId},{PHCDF_PHCD_ParRef})
#; d VALINS^at520({PHCDF_RowId},{PHCDF_PHCD_ParRef},{PHCDF_PHCF_DR},{PHCDF_PHCPA_DR},{PHCDF_PHCP_DR},{PHCDF_PHCS_DR})
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCDrgForm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCDrgForm","OnAfterDelete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMasterPHCDF">
<Data name="PHCDF_ATCBin">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="PHCDF_AdminRoute_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>12</Piece>
</Data>
<Data name="PHCDF_AdvReaction">
<Node>"ADV"</Node>
</Data>
<Data name="PHCDF_BaseQty">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCDF_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCDF_ContraInd">
<Node>"CON"</Node>
</Data>
<Data name="PHCDF_DateFrom">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCDF_DateTo">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="PHCDF_DeductPartially">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCDF_ExternalData">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>20</Piece>
</Data>
<Data name="PHCDF_ExtraDetails">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>22</Piece>
</Data>
<Data name="PHCDF_Formulary">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>10</Piece>
</Data>
<Data name="PHCDF_GenRtForm_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Data name="PHCDF_IVExpiry">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>14</Piece>
</Data>
<Data name="PHCDF_InPatDuration_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="PHCDF_Indication">
<Node>"IND"</Node>
</Data>
<Data name="PHCDF_Interaction">
<Node>"INT"</Node>
</Data>
<Data name="PHCDF_MIMSno">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCDF_MaxNumberRepeats">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCDF_Modified">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>21</Piece>
</Data>
<Data name="PHCDF_Monograph">
<Node>"MON"</Node>
</Data>
<Data name="PHCDF_NeverCalculateQty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>19</Piece>
</Data>
<Data name="PHCDF_OfficialCode">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCDF_PBSQuan">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>16</Piece>
</Data>
<Data name="PHCDF_PHCDO_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCDF_PHCDU_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="PHCDF_PHCFR_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="PHCDF_PHCF_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCDF_PHCIN_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="PHCDF_PHCPA_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCDF_PHCP_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="PHCDF_PHCS_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="PHCDF_Poison_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>17</Piece>
</Data>
<Data name="PHCDF_Precaution">
<Node>"PRE"</Node>
</Data>
<Data name="PHCDF_Preferred">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>11</Piece>
</Data>
<Data name="PHCDF_Price1">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCDF_Price2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCDF_RegionCodeFDB">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>18</Piece>
</Data>
<Data name="PHCDF_RoundIndivAdmin">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>13</Piece>
</Data>
<Data name="PHCDF_Route_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>9</Piece>
</Data>
<Data name="PHCDF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="PHCDF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="PHCDF_UpdateUser">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="PHCDF_Volume">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>15</Piece>
</Data>
<Data name="PHCDF_Warning">
<Node>"WRN"</Node>
</Data>
<Global>^PHCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHCDF_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDurat">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Durat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCDF_PHCDU_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCDF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFreq">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Freq"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCDF_PHCFR_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCDF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenRtForm">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GenRtForm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCDF_GenRtForm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCDF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInstruc">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Instruc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCDF_PHCIN_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCDF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMIMSno">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DF_MIMS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({PHCDF_MIMSno})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCDF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOfficialCode">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OffCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({PHCDF_OfficialCode})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCDF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCFDR">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHCDF_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DF_Form"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHCDF_PHCF_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHCDF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCDF_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDrgFormS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
