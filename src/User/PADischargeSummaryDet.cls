/// DischargeSummaryDet(2824)
Class User.PADischargeSummaryDet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_DischargeSummaryDet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_DischargeSummary Parent Reference
Relationship DETParRef As PADischargeSummary [ Cardinality = parent, Inverse = ChildPADischargeSummaryDet, Required, SqlFieldName = DET_ParRef ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^PA("DISSUM",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Des Ref OEOrdItem
Property DETLabResultDR As OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DET_LabResult_DR ];

/// Des Ref MRDiagnos
Property DETMRDiagnosDR As MRDiagnos [ SqlColumnNumber = 4, SqlFieldName = DET_MRDiagnos_DR ];

/// Des Ref MRMedication
Property DETMRMedicationDR As MRMedication [ SqlColumnNumber = 5, SqlFieldName = DET_MRMedication_DR ];

/// Des Ref MRNursingNotes
Property DETMRNursingNotesDR As MRNursingNotes [ SqlColumnNumber = 6, SqlFieldName = DET_MRNursingNotes_DR ];

/// Des Ref MRPresentIllness
Property DETMRPresentIllnessDR As MRPresentIllness [ SqlColumnNumber = 7, SqlFieldName = DET_MRPresentIllness_DR ];

/// Des Ref MRProcedures
Property DETMRProceduresDR As MRProcedures [ SqlColumnNumber = 8, SqlFieldName = DET_MRProcedures_DR ];

/// Des Ref MRSubFind
Property DETMRSubFindDR As MRSubFind [ SqlColumnNumber = 9, SqlFieldName = DET_MRSubFind_DR ];

/// Des Ref OEOrdItem
Property DETOEOrdItemDR As OEOrdItem [ SqlColumnNumber = 10, SqlFieldName = DET_OEOrdItem_DR ];

/// Des Ref ORAnaesthesia
Property DETORAnaesthesiaDR As ORAnaesthesia [ SqlColumnNumber = 11, SqlFieldName = DET_ORAnaesthesia_DR ];

/// Des Ref PAAlertMsg
Property DETPAAlertMsgDR As PAAlertMsg [ SqlColumnNumber = 12, SqlFieldName = DET_PAAlertMsg_DR ];

/// Des Ref PAAllergy
Property DETPAAllergyDR As PAAllergy [ SqlColumnNumber = 13, SqlFieldName = DET_PAAllergy_DR ];

/// Des Ref OETextResult
Property DETTextResultDR As OETextResult [ SqlColumnNumber = 14, SqlFieldName = DET_TextResult_DR ];

/// Des Ref OEOrdResult
Property DETWordResultDR As OEOrdResult [ SqlColumnNumber = 15, SqlFieldName = DET_WordResult_DR ];

/// Des Ref PAFamily
Property DETPAFamilyDR As PAFamily [ SqlColumnNumber = 16, SqlFieldName = DET_PAFamily_DR ];

/// Des Ref PAOperation
Property DETPAOperationDR As PAOperation [ SqlColumnNumber = 17, SqlFieldName = DET_PAOperation_DR ];

/// Des Ref PASocHist
Property DETPASocHistDR As PASocHist [ SqlColumnNumber = 18, SqlFieldName = DET_PASocHist_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PADischargeSummaryDet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryDet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PADischargeSummaryDet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryDet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PADischargeSummaryDet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryDet","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PADischargeSummaryDet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryDet","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryDet","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PADischargeSummaryDet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PADischargeSummaryDet","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_LabResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_MRDiagnos_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_MRMedication_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DET_MRNursingNotes_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_MRPresentIllness_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DET_MRProcedures_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DET_MRSubFind_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DET_OEOrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DET_ORAnaesthesia_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DET_PAAlertMsg_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DET_PAAllergy_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DET_PAFamily_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DET_PAOperation_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DET_PASocHist_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DET_TextResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DET_WordResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLabResultDR">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"LabResultDR"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_LabResult_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRDiagnos">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MRDiagnos"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_MRDiagnos_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRMedication">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MRMedication"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_MRMedication_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRNursingNotes">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MRNursingNotes"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_MRNursingNotes_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRPresentIllness">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MRPresentIllness"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_MRPresentIllness_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRProcedures">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MRProcedures"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_MRProcedures_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMRSubFind">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MRSubFind"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_MRSubFind_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEOrdItem">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"OEOrdItem"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_OEOrdItem_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexORAnaesthesia">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ORAnaesthesia"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_ORAnaesthesia_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAAlertMsg">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PAAlertMsg"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_PAAlertMsg_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAAllergy">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PAAllergy"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_PAAllergy_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAFamily">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PAFamily"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_PAFamily_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAOperation">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PAOperation"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_PAOperation_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPASocHist">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"PASocHist"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_PASocHist_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTextResult">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"TextResult"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_TextResult_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWordResult">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PA_DischargeSummary.DIS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DISSUM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PA_DischargeSummary.DIS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"WordResult"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DET_WordResult_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.PADischargeSummaryDetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
