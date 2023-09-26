/// MR Clinical Pathways(1773)
Class User.MRClinicalPathWays Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ClinicalPathWays, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CPWChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRClinicalPathWaysICD As MRClinicalPathWaysICD [ Cardinality = children, Inverse = ICDParRef ];

/// MR_Adm Parent Reference
Relationship CPWParREf As MRAdm [ Cardinality = parent, Inverse = ChildMRClinicalPathWays, Required, SqlFieldName = CPW_ParREf ];

/// Childsub
Property CPWChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CPW",0))}, SqlColumnNumber = 2, SqlFieldName = CPW_Childsub ];

/// Des Ref Pathways
Property CPWPathwaysDR As MRCClinPathwEpDays [ SqlColumnNumber = 3, SqlFieldName = CPW_Pathways_DR ];

/// Used Flag
Property CPWUsedFlag As %Date [ SqlColumnNumber = 4, SqlFieldName = CPW_UsedFlag ];

/// ID Date
Property CPWIDDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CPW_IDDate ];

/// ID Time
Property CPWIDTime As %Time [ SqlColumnNumber = 6, SqlFieldName = CPW_IDTime ];

/// Des Ref Pathway
Property CPWPathwayDR As MRCClinicalPathways [ SqlColumnNumber = 7, SqlFieldName = CPW_Pathway_DR ];

/// Des Ref Status
Property CPWStatusDR As MRCClinPathwayStatus [ SqlColumnNumber = 8, SqlFieldName = CPW_Status_DR ];

/// Comments
Property CPWComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPW_Comments, SqlListType = subnode ];

/// Goal text
Property CPWGoalText As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPW_GoalText, SqlListType = subnode ];

/// Des Ref Outcome
Property CPWOutcomeDR As MRCClinPathOutcome [ SqlColumnNumber = 11, SqlFieldName = CPW_Outcome_DR ];

/// Number
Property CPWNumber As %Float [ SqlColumnNumber = 12, SqlFieldName = CPW_Number ];

/// Date Added
Property CPWDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CPW_Date ];

/// NurseAction
Property CPWNurseAction As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CPW_NurseAction, SqlListType = subnode ];

/// ProblemReviewDate
Property CPWProblemReviewDate As %Date [ SqlColumnNumber = 15, SqlFieldName = CPW_ProblemReviewDate ];

/// ProblemEndDate
Property CPWProblemEndDate As %Date [ SqlColumnNumber = 16, SqlFieldName = CPW_ProblemEndDate ];

/// Des Ref CareProvider
Property CPWCareProviderDR As CTCareProv [ SqlColumnNumber = 17, SqlFieldName = CPW_CareProvider_DR ];

/// GoalTargetDate
Property CPWGoalTargetDate As %Date [ SqlColumnNumber = 18, SqlFieldName = CPW_GoalTargetDate ];

/// ProblemStartDate
Property CPWProblemStartDate As %Date [ SqlColumnNumber = 19, SqlFieldName = CPW_ProblemStartDate ];

/// Des Ref VarianceReason
Property CPWVarianceReasonDR As MRCVarianceReason [ SqlColumnNumber = 20, SqlFieldName = CPW_VarianceReason_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRClinicalPathWays).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRClinicalPathWays","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRClinicalPathWays).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRClinicalPathWays","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRClinicalPathWays).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRClinicalPathWays","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRClinicalPathWays).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRClinicalPathWays","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRClinicalPathWays).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRClinicalPathWays","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRClinicalPathWays","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CPW_CareProvider_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CPW_Comments">
<Node>"REM"</Node>
</Data>
<Data name="CPW_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CPW_GoalTargetDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CPW_GoalText">
<Node>"TXT"</Node>
</Data>
<Data name="CPW_IDDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CPW_IDTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CPW_Number">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CPW_NurseAction">
<Node>"NA"</Node>
</Data>
<Data name="CPW_Outcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CPW_Pathway_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CPW_Pathways_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CPW_ProblemEndDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CPW_ProblemReviewDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CPW_ProblemStartDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CPW_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CPW_UsedFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CPW_VarianceReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CPW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CPW_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Condition>1</Condition>
<Global>^MR</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CPW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Number"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CPW_Number}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CPW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CPW_RowId</SqlRowIdName>
<StreamLocation>^User.MRClinicalPathWaysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
