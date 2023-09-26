/// MR SubjectFindings(1298)
Class User.MRSubjectFindings Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_SubjectFindings, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SUBFChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship SUBFParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRSubjectFindings, Required, SqlFieldName = SUBF_ParRef ];

/// Childsub
Property SUBFChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SUBF",0))}, SqlColumnNumber = 2, SqlFieldName = SUBF_Childsub ];

/// Text
Property SUBFText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SUBF_Text, SqlListType = subnode ];

/// Des Ref CTCP
Property SUBFCTCPDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = SUBF_CTCP_DR ];

/// Date
Property SUBFDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = SUBF_Date ];

/// Time
Property SUBFTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = SUBF_Time ];

/// Des Ref User
Property SUBFUpdateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = SUBF_UpdateUser_DR ];

/// RTFNotes
Property SUBFRTFNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SUBF_RTFNotes, SqlListType = subnode ];

/// Update Date
Property SUBFUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = SUBF_UpdateDate ];

/// Update Time
Property SUBFUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = SUBF_UpdateTime ];

/// Des Ref UpdateHospital
Property SUBFUpdateHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = SUBF_UpdateHospital_DR ];

/// Des Ref Consult
Property SUBFConsultDR As PAPersonConsultSetCons [ SqlColumnNumber = 12, SqlFieldName = SUBF_Consult_DR ];

/// Des Ref DiagnosSignSymptom
Property SUBFDiagnosSignSymptomDR As MRCDiagnosSignSymptom [ SqlColumnNumber = 13, SqlFieldName = SUBF_DiagnosSignSymptom_DR ];

/// Des Ref BodySite
Property SUBFBodySiteDR As OECBodySite [ SqlColumnNumber = 14, SqlFieldName = SUBF_BodySite_DR ];

/// Des Ref Laterality
Property SUBFLateralityDR As PACLaterality [ SqlColumnNumber = 15, SqlFieldName = SUBF_Laterality_DR ];

/// Des Ref Severity
Property SUBFSeverityDR As MRCSeverity [ SqlColumnNumber = 16, SqlFieldName = SUBF_Severity_DR ];

/// DurationNum
Property SUBFDurationNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = SUBF_DurationNum ];

/// DurationUnit
Property SUBFDurationUnit As %String(DISPLAYLIST = ",Days,Weeks,Months,Years,Hours,Minutes", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",D,W,M,Y,H,Min") [ SqlColumnNumber = 18, SqlFieldName = SUBF_DurationUnit ];

/// ApproxOnsetDate
Property SUBFApproxOnsetDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = SUBF_ApproxOnsetDate ];

/// OnsetDate
Property SUBFOnsetDate As %Date [ SqlColumnNumber = 20, SqlFieldName = SUBF_OnsetDate ];

/// OnsetTime
Property SUBFOnsetTime As %Time [ SqlColumnNumber = 21, SqlFieldName = SUBF_OnsetTime ];

/// EndDate
Property SUBFEndDate As %Date [ SqlColumnNumber = 22, SqlFieldName = SUBF_EndDate ];

/// EndTime
Property SUBFEndTime As %Time [ SqlColumnNumber = 23, SqlFieldName = SUBF_EndTime ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRSubjectFindings).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubjectFindings","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRSubjectFindings).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubjectFindings","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRSubjectFindings).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubjectFindings","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRSubjectFindings).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubjectFindings","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubjectFindings","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRSubjectFindings).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRSubjectFindings","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SUBF_ApproxOnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SUBF_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SUBF_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUBF_Consult_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SUBF_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUBF_DiagnosSignSymptom_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUBF_DurationNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SUBF_DurationUnit">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SUBF_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SUBF_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SUBF_Laterality_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SUBF_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SUBF_OnsetTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SUBF_RTFNotes">
<Node>"RTF"</Node>
</Data>
<Data name="SUBF_Severity_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SUBF_Text">
<Node>"REM"</Node>
</Data>
<Data name="SUBF_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUBF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUBF_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUBF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SUBF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SUBF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUBF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SUBF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConsult">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SUBF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUBFCons"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SUBF_Consult_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SUBF_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUBF_RowId</SqlRowIdName>
<StreamLocation>^User.MRSubjectFindingsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
