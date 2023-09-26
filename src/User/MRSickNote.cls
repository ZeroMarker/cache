/// SickNote(2739)
Class User.MRSickNote Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_SickNote, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On NOTChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship NOTParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRSickNote, Required, SqlFieldName = NOT_ParRef ];

/// Childsub
Property NOTChildsub As %Float [ InitialExpression = {$i(^MR($p(initvalue,$c(1)),"SN",0))}, SqlColumnNumber = 2, SqlFieldName = NOT_Childsub ];

/// CreateDate
Property NOTCreateDate As %Date [ SqlColumnNumber = 3, SqlFieldName = NOT_CreateDate ];

/// CreateTime
Property NOTCreateTime As %Time [ SqlColumnNumber = 4, SqlFieldName = NOT_CreateTime ];

/// Des Ref LastUpdateUser
Property NOTLastUpdateUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = NOT_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property NOTLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 6, SqlFieldName = NOT_LastUpdateHospital_DR ];

/// LastUpdateDate
Property NOTLastUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = NOT_LastUpdateDate ];

/// LastUpdateTime
Property NOTLastUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = NOT_LastUpdateTime ];

/// StartDate
Property NOTStartDate As %Date [ SqlColumnNumber = 9, SqlFieldName = NOT_StartDate ];

/// EndDate
Property NOTEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = NOT_EndDate ];

/// Remarks
Property NOTRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 11, SqlFieldName = NOT_Remarks, SqlListType = subnode ];

/// Des Ref Diagnosis
Property NOTDiagnosisDR As MRCICDDx [ SqlColumnNumber = 12, SqlFieldName = NOT_Diagnosis_DR ];

/// Des Ref ChiefComplaints
Property NOTChiefComplaintsDR As MRCDiagnosSignSymptom [ SqlColumnNumber = 13, SqlFieldName = NOT_ChiefComplaints_DR ];

/// Status
Property NOTStatus As %String(DISPLAYLIST = ",Entered,Authorised", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",E,A") [ SqlColumnNumber = 14, SqlFieldName = NOT_Status ];

/// Des Ref CareProv
Property NOTCareProvDR As CTCareProv [ SqlColumnNumber = 15, SqlFieldName = NOT_CareProv_DR ];

/// Des Consult
Property NOTConsultDR As PAPersonConsultSetCons [ SqlColumnNumber = 16, SqlFieldName = NOT_Consult_DR ];

/// Des Ref MedCertType
Property NOTMedCertTypeDR As MRCMedicalCertifType [ SqlColumnNumber = 17, SqlFieldName = NOT_MedCertType_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRSickNote).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSickNote","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRSickNote).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSickNote","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRSickNote).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSickNote","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRSickNote).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSickNote","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRSickNote).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSickNote","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="NOT_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NOT_ChiefComplaints_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NOT_Consult_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NOT_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NOT_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NOT_Diagnosis_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NOT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NOT_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NOT_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NOT_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NOT_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NOT_MedCertType_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="NOT_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="NOT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NOT_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
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
<Expression>"SN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NOT_RowId</SqlRowIdName>
<StreamLocation>^User.MRSickNoteS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
