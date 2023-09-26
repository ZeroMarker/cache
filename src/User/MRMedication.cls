/// Medication(2545)
Class User.MRMedication Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Medication, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On MEDChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship MEDParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRMedication, Required, SqlFieldName = MED_ParRef ];

/// Childsub
Property MEDChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"MED",0))}, SqlColumnNumber = 2, SqlFieldName = MED_Childsub ];

/// HL7Number
Property MEDHL7Number As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MED_HL7Number ];

/// Details
Property MEDDetails As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MED_Details, SqlListType = SUBNODE ];

/// Type
Property MEDType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MED_Type ];

/// Comments
Property MEDComments As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MED_Comments, SqlListType = SUBNODE ];

/// ExcludeFromDS
Property MEDExcludeFromDS As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = MED_ExcludeFromDS ];

/// LastUpdateDate
Property MEDLastUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = MED_LastUpdateDate ];

/// LastUpdateTime
Property MEDLastUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = MED_LastUpdateTime ];

/// Des Ref LastUpdateUser
Property MEDLastUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = MED_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property MEDLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = MED_LastUpdateHospital_DR ];

/// DSReportFlag
Property MEDDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MED_DSReportFlag ];

/// Des Ref DrgMast
Property MEDDrgMastDR As PHCDrgMast [ SqlColumnNumber = 13, SqlFieldName = MED_DrgMast_DR ];

/// Des Ref DrgForm
Property MEDDrgFormDR As PHCDrgForm [ SqlColumnNumber = 14, SqlFieldName = MED_DrgForm_DR ];

/// Des Ref GenRtFrm
Property MEDGenRtFrmDR As PHCGenericRtForms [ SqlColumnNumber = 15, SqlFieldName = MED_GenRtFrm_DR ];

/// Dose
Property MEDDose As %Float [ SqlColumnNumber = 16, SqlFieldName = MED_Dose ];

/// Des Ref UOM
Property MEDDoseUOMDR As CTUOM [ SqlColumnNumber = 17, SqlFieldName = MED_DoseUOM_DR ];

/// Des Ref Freq
Property MEDFreqDR As PHCFreq [ SqlColumnNumber = 18, SqlFieldName = MED_Freq_DR ];

/// Des Ref Duration
Property MEDDurationDR As PHCDuration [ SqlColumnNumber = 19, SqlFieldName = MED_Duration_DR ];

/// DurationFree
Property MEDDurationFree As %String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = MED_DurationFree ];

/// Des Ref ICDDx
Property MEDConditionDR As MRCICDDx [ SqlColumnNumber = 21, SqlFieldName = MED_Condition_DR ];

/// Ceased
Property MEDCeased As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = MED_Ceased ];

/// UpdateDate
Property MEDUpdateDate As %Date [ SqlColumnNumber = 23, SqlFieldName = MED_UpdateDate ];

/// UpdateTime
Property MEDUpdateTime As %Time [ SqlColumnNumber = 24, SqlFieldName = MED_UpdateTime ];

/// Des Ref UpdateUser
Property MEDUpdateUserDR As SSUser [ SqlColumnNumber = 25, SqlFieldName = MED_UpdateUser_DR ];

/// ShowInDS
Property MEDShowInDS As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = MED_ShowInDS ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRMedication).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRMedication","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRMedication).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRMedication","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRMedication).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRMedication","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRMedication).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRMedication","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRMedication).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRMedication","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="MED_Ceased">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MED_Comments">
<Node>"COM"</Node>
</Data>
<Data name="MED_Condition_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MED_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MED_Details">
<Node>"DET"</Node>
</Data>
<Data name="MED_Dose">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MED_DoseUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MED_DrgForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MED_DrgMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MED_DurationFree">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MED_Duration_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MED_ExcludeFromDS">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MED_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MED_GenRtFrm_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MED_HL7Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MED_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MED_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MED_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MED_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MED_ShowInDS">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MED_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MED_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MED_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MED_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMedicationNumber">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MedicationNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MED_HL7Number}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MED_RowId</SqlRowIdName>
<StreamLocation>^User.MRMedicationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
