/// MR Risk Evaluation(1611)
Class User.MRRiskEvaluation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_RiskEvaluation, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RISKChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship RISKParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRRiskEvaluation, Required, SqlFieldName = RISK_ParRef ];

/// Childsub
Property RISKChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RISK",0))}, SqlColumnNumber = 2, SqlFieldName = RISK_Childsub ];

/// Des Ref Risk Param
Property RISKRiskParamDR As MRCRiskEvalParam [ SqlColumnNumber = 3, SqlFieldName = RISK_RiskParam_DR ];

/// Des Ref Risk Criteria
Property RISKRiskCriteriaDR As MRCRiskEvalParamCriteria [ SqlColumnNumber = 4, SqlFieldName = RISK_RiskCriteria_DR ];

/// Des Ref BodySysProbStat
Property RISKBodySysProbStatDR As MRCBodySystemProbStatus [ SqlColumnNumber = 5, SqlFieldName = RISK_BodySysProbStat_DR ];

/// Date
Property RISKDate As %Date [ SqlColumnNumber = 6, SqlFieldName = RISK_Date ];

/// Time
Property RISKTime As %Time [ SqlColumnNumber = 7, SqlFieldName = RISK_Time ];

/// Des Ref CTCP
Property RISKCTCPDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = RISK_CTCP_DR ];

/// Description
Property RISKDesc As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = RISK_Desc, SqlListType = SUBNODE ];

/// Des Ref RiskEval
Property RISKRiskEvalDR As MRCRiskParamCritEval [ SqlColumnNumber = 10, SqlFieldName = RISK_RiskEval_DR ];

/// Des Ref UpdateUser
Property RISKUpdateUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = RISK_UpdateUser_DR ];

/// Update Date
Property RISKUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = RISK_UpdateDate ];

/// Update Time
Property RISKUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = RISK_UpdateTime ];

/// Des Ref UpdateHospital
Property RISKUpdateHospitalDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = RISK_UpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRRiskEvaluation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRRiskEvaluation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRRiskEvaluation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRRiskEvaluation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRRiskEvaluation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRRiskEvaluation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRRiskEvaluation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRRiskEvaluation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRRiskEvaluation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRRiskEvaluation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RISK_BodySysProbStat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RISK_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RISK_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RISK_Desc">
<Node>"REM"</Node>
</Data>
<Data name="RISK_RiskCriteria_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RISK_RiskEval_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RISK_RiskParam_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RISK_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RISK_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RISK_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RISK_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RISK_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RISK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RISK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RISK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RISK_RowId</SqlRowIdName>
<StreamLocation>^User.MRRiskEvaluationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
