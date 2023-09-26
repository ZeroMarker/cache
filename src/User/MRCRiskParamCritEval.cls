/// MRC Risk Param Criteria Eval(1610)
Class User.MRCRiskParamCritEval Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_RiskParamCritEval, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EVALChildsub As %Float [ InitialExpression = {$i(^MRC("REP",$p(%d(0),"||"),"CRIT",$p(%d(0),"||",2),"EVAL",0))}, SqlColumnNumber = 2, SqlFieldName = EVAL_Childsub ];

/// Code
Property EVALCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = EVAL_Code ];

/// Description
Property EVALDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = EVAL_Desc ];

/// MRC_RiskEvalParamCriteria Parent Reference
Relationship EVALParRef As MRCRiskEvalParamCriteria [ Cardinality = parent, Inverse = ChildMRCRiskParamCritEval, Required, SqlFieldName = EVAL_ParRef ];

Index RowIDBasedIDKeyIndex On EVALChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCRiskParamCritEval).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskParamCritEval","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCRiskParamCritEval).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskParamCritEval","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCRiskParamCritEval).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskParamCritEval","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCRiskParamCritEval).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskParamCritEval","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCRiskParamCritEval).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskParamCritEval","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="EVALChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EVALCode">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="EVALDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="EVALParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="EVAL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EVAL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_RiskEvalParam.REP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRC_RiskEvalParamCriteria.CRIT_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>EVAL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_RiskEvalParam.REP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CRIT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRC_RiskEvalParamCriteria.CRIT_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"EVAL"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EVAL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EVAL_RowId</SqlRowIdName>
<StreamLocation>^User.MRCRiskParamCritEvalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
