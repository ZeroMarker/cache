/// MRC Risk Eval Param Crit(1609)
Class User.MRCRiskEvalParamCriteria Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_RiskEvalParamCriteria, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CRITChildsub As %Float [ InitialExpression = {$i(^MRC("REP",$p(%d(0),$c(1)),"CRIT",0))}, SqlColumnNumber = 2, SqlFieldName = CRIT_Childsub ];

/// Code
Property CRITCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CRIT_Code ];

/// Description
Property CRITDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = CRIT_Desc ];

/// MRC_RiskEvalParam Parent Reference
Relationship CRITParRef As MRCRiskEvalParam [ Cardinality = parent, Inverse = ChildMRCRiskEvalParamCriteria, Required, SqlFieldName = CRIT_ParRef ];

Relationship ChildMRCRiskParamCritEval As MRCRiskParamCritEval [ Cardinality = children, Inverse = EVALParRef ];

Index RowIDBasedIDKeyIndex On CRITChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCRiskEvalParamCriteria).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskEvalParamCriteria","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCRiskEvalParamCriteria).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskEvalParamCriteria","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCRiskEvalParamCriteria).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskEvalParamCriteria","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCRiskEvalParamCriteria).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskEvalParamCriteria","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCRiskEvalParamCriteria).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCRiskEvalParamCriteria","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="CRITChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CRITCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CRITDesc">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CRITParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="CRIT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CRIT_Desc">
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
<Field>CRIT_Childsub</Field>
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
<Expression>{CRIT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CRIT_RowId</SqlRowIdName>
<StreamLocation>^User.MRCRiskEvalParamCriteriaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
