/// Psych Tribunal(2637)
Class User.MRPsychTribunal Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PsychTribunal, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On TRIBChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_PsychDetails Parent Reference
Relationship TRIBParRef As MRPsychDetails [ Cardinality = parent, Inverse = ChildMRPsychTribunal, Required, SqlFieldName = TRIB_ParRef ];

/// Childsub
Property TRIBChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PSYCH",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"TRIB",0))}, SqlColumnNumber = 2, SqlFieldName = TRIB_Childsub ];

/// Des Ref Applicant
Property TRIBApplicantDR As PACApplicant [ SqlColumnNumber = 3, SqlFieldName = TRIB_Applicant_DR ];

/// Des Ref Appeal
Property TRIBAppealDR As PACAppeal [ SqlColumnNumber = 4, SqlFieldName = TRIB_Appeal_DR ];

/// Des Ref AppealType
Property TRIBAppealTypeDR As PACAppealType [ SqlColumnNumber = 5, SqlFieldName = TRIB_AppealType_DR ];

/// DateReferral
Property TRIBDateReferral As %Date [ SqlColumnNumber = 6, SqlFieldName = TRIB_DateReferral ];

/// DateHearing
Property TRIBDateHearing As %Date [ SqlColumnNumber = 7, SqlFieldName = TRIB_DateHearing ];

/// DateReport
Property TRIBDateReport As %Date [ SqlColumnNumber = 8, SqlFieldName = TRIB_DateReport ];

/// DateSubReport
Property TRIBDateSubReport As %Date [ SqlColumnNumber = 9, SqlFieldName = TRIB_DateSubReport ];

/// DateStatement
Property TRIBDateStatement As %Date [ SqlColumnNumber = 10, SqlFieldName = TRIB_DateStatement ];

/// DateMedical
Property TRIBDateMedical As %Date [ SqlColumnNumber = 11, SqlFieldName = TRIB_DateMedical ];

/// DateSocial
Property TRIBDateSocial As %Date [ SqlColumnNumber = 12, SqlFieldName = TRIB_DateSocial ];

/// ReportSent
Property TRIBReportSent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = TRIB_ReportSent ];

/// PatAttend
Property TRIBPatAttend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = TRIB_PatAttend ];

/// Des Ref Decision
Property TRIBDecisionDR As PACDecision [ SqlColumnNumber = 15, SqlFieldName = TRIB_Decision_DR ];

/// CoOrdinator
Property TRIBCoOrdinator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = TRIB_CoOrdinator ];

/// Solicitor
Property TRIBSolicitor As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = TRIB_Solicitor, SqlListType = SUBNODE ];

/// Comments
Property TRIBComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = TRIB_Comments, SqlListType = SUBNODE ];

/// DateNrsReport
Property TRIBDateNrsReport As %Date [ SqlColumnNumber = 19, SqlFieldName = TRIB_DateNrsReport ];

/// AppealStatus
Property TRIBAppealStatus As %String(DISPLAYLIST = ",Pending,Adjorned,Complete", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",P,A,C") [ SqlColumnNumber = 20, SqlFieldName = TRIB_AppealStatus ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPsychTribunal).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTribunal","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPsychTribunal).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTribunal","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPsychTribunal).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTribunal","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPsychTribunal).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTribunal","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPsychTribunal).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPsychTribunal","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexAppeal">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TRIB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRAppeal"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRIB_Appeal_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRIB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppealStatus">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TRIB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRAppealSt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRIB_AppealStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRIB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppealType">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TRIB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRAppealType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRIB_AppealType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRIB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDecision">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TRIB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRDecis"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRIB_Decision_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRIB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHearDate">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>TRIB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TRHearDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TRIB_DateHearing}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TRIB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="datamaster">
<Data name="TRIB_AppealStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TRIB_AppealType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TRIB_Appeal_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRIB_Applicant_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRIB_CoOrdinator">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TRIB_Comments">
<Node>"RMK"</Node>
</Data>
<Data name="TRIB_DateHearing">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TRIB_DateMedical">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TRIB_DateNrsReport">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TRIB_DateReferral">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRIB_DateReport">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TRIB_DateSocial">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TRIB_DateStatement">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TRIB_DateSubReport">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TRIB_Decision_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TRIB_PatAttend">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TRIB_ReportSent">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TRIB_Solicitor">
<Node>"SOL"</Node>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_PsychDetails.PSYCH_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>TRIB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PSYCH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_PsychDetails.PSYCH_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TRIB"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRIB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TRIB_RowId</SqlRowIdName>
<StreamLocation>^User.MRPsychTribunalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
