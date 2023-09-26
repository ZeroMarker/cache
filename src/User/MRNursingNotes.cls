/// MR Nursing Notes(1129)
Class User.MRNursingNotes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_NursingNotes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On NOTChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship NOTParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRNursingNotes, Required, SqlFieldName = NOT_ParRef ];

/// Childsub
Property NOTChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"NOT",0))}, SqlColumnNumber = 2, SqlFieldName = NOT_Childsub ];

/// Date
Property NOTDate As %Date [ SqlColumnNumber = 3, SqlFieldName = NOT_Date ];

/// Time
Property NOTTime As %Time [ SqlColumnNumber = 4, SqlFieldName = NOT_Time ];

/// Nurse Id Des Ref to CTCP
Property NOTNurseIdDR As CTCareProv [ SqlColumnNumber = 5, SqlFieldName = NOT_NurseId_DR ];

/// Notes
Property NOTNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = NOT_Notes, SqlListType = subnode ];

/// Add Work List
Property NOTAddWorkList As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = NOT_AddWorkList ];

/// Des Ref ClinNotesType
Property NOTClinNotesTypeDR As MRCClinNotesType [ SqlColumnNumber = 8, SqlFieldName = NOT_ClinNotesType_DR ];

/// Des Ref Status
Property NOTStatusDR As MRCNursingNotesStatus [ SqlColumnNumber = 9, SqlFieldName = NOT_Status_DR ];

/// Des Ref Appoint
Property NOTAppointDR As RBAppointment [ SqlColumnNumber = 10, SqlFieldName = NOT_Appoint_DR ];

/// Date Auth
Property NOTDateAuth As %Date [ SqlColumnNumber = 11, SqlFieldName = NOT_DateAuth ];

/// Time Auth
Property NOTTimeAuth As %Time [ SqlColumnNumber = 12, SqlFieldName = NOT_TimeAuth ];

/// Des Ref UserAuth
Property NOTUserAuthDR As SSUser [ SqlColumnNumber = 13, SqlFieldName = NOT_UserAuth_DR ];

/// AdmApptDate
Property NOTAdmApptDate As %Date [ SqlColumnNumber = 14, SqlFieldName = NOT_AdmApptDate ];

/// AdmApptTime
Property NOTAdmApptTime As %Time [ SqlColumnNumber = 15, SqlFieldName = NOT_AdmApptTime ];

/// Des Ref User
Property NOTUserDR As SSUser [ SqlColumnNumber = 16, SqlFieldName = NOT_User_DR ];

/// RTF Notes
Property NOTRTFNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = NOT_RTFNotes, SqlListType = subnode ];

/// Des Ref Hospital
Property NOTHospitalDR As CTHospital [ SqlColumnNumber = 18, SqlFieldName = NOT_Hospital_DR ];

/// CreateDate
Property NOTCreateDate As %Date [ SqlColumnNumber = 19, SqlFieldName = NOT_CreateDate ];

/// CreateTime
Property NOTCreateTime As %Time [ SqlColumnNumber = 20, SqlFieldName = NOT_CreateTime ];

/// CopyToGP
Property NOTCopyToGP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = NOT_CopyToGP ];

/// OtherRecipNameAddress
Property NOTOtherRecipNameAddress As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = NOT_OtherRecipNameAddress ];

/// DSReportFlag
Property NOTDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = NOT_DSReportFlag ];

/// Des Ref EnteredCareProv
Property NOTEnteredCareProvDR As CTCareProv [ SqlColumnNumber = 24, SqlFieldName = NOT_EnteredCareProv_DR ];

/// IncludedForDischSum
Property NOTIncludedForDischSum As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = NOT_IncludedForDischSum ];

/// Entered Location
Property NOTEnteredLocDR As CTLoc [ SqlColumnNumber = 26, SqlFieldName = NOT_EnteredLoc_DR ];

/// Consent
Property NOTConsent As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = NOT_Consent ];

/// Des Ref ClinNoteSens
Property NOTClinNoteSensDR As MRCClinNotesSensitivity [ SqlColumnNumber = 28, SqlFieldName = NOT_ClinNoteSens_DR ];

/// Notes1
Property NOTNotes1 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = NOT_Notes1, SqlListType = subnode ];

/// RTFNotes1
Property NOTRTFNotes1 As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = NOT_RTFNotes1, SqlListType = subnode ];

/// Des Ref EditCP
Property NOTEditCPDR As CTCareProv [ SqlColumnNumber = 31, SqlFieldName = NOT_EditCP_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRNursingNotes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRNursingNotes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRNursingNotes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRNursingNotes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRNursingNotes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRNursingNotes","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRNursingNotes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRNursingNotes","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRNursingNotes","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRNursingNotes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRNursingNotes","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NOT_AddWorkList">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NOT_AdmApptDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NOT_AdmApptTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NOT_Appoint_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NOT_ClinNoteSens_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="NOT_ClinNotesType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NOT_Consent">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="NOT_CopyToGP">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="NOT_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="NOT_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="NOT_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="NOT_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NOT_DateAuth">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NOT_EditCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="NOT_EnteredCareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="NOT_EnteredLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="NOT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="NOT_IncludedForDischSum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="NOT_Notes">
<Node>"REM"</Node>
</Data>
<Data name="NOT_Notes1">
<Node>"REM1"</Node>
</Data>
<Data name="NOT_NurseId_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NOT_OtherRecipNameAddress">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="NOT_RTFNotes">
<Node>"RTF"</Node>
</Data>
<Data name="NOT_RTFNotes1">
<Node>"RTF1"</Node>
</Data>
<Data name="NOT_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NOT_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NOT_TimeAuth">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NOT_UserAuth_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NOT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>NOT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NOT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>NOT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotesDoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOT_NurseId_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NOT_AdmApptDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NOT_AdmApptTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{NOT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotesStatus">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>NOT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotesStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOT_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NOT_AdmApptDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NOT_AdmApptTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{NOT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>NOT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NOTES"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOT_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NOT_ClinNotesType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NOT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDateTime">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>NOT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotesType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOT_ClinNotesType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NOT_AdmApptDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NOT_AdmApptTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{NOT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NOT_RowId</SqlRowIdName>
<StreamLocation>^User.MRNursingNotesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
