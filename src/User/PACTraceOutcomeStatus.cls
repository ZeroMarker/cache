/// TraceOutcomeStatus(2124)
Class User.PACTraceOutcomeStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_TraceOutcomeStatus, StorageStrategy = SQLStorage ]
{

/// Childsub
Property STChildsub As %Float [ InitialExpression = {$i(^PAC("TRACE",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ST",0))}, SqlColumnNumber = 2, SqlFieldName = ST_Childsub ];

/// PAC_TraceOutcome Parent Reference
Relationship STParRef As PACTraceOutcome [ Cardinality = parent, Inverse = ChildPACTraceOutcomeStatus, Required, SqlFieldName = ST_ParRef ];

/// Des Ref TraceOutcome
Property STTraceOutcomeDR As PACTraceOutcome [ SqlColumnNumber = 3, SqlFieldName = ST_TraceOutcome_DR ];

Index RowIDBasedIDKeyIndex On STChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 19;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACTraceOutcomeStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcomeStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACTraceOutcomeStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcomeStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACTraceOutcomeStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcomeStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACTraceOutcomeStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcomeStatus","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACTraceOutcomeStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcomeStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="STChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="STParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="STTraceOutcomeDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ST_TraceOutcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_TraceOutcome.TRACE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRACE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_TraceOutcome.TRACE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ST_RowId</SqlRowIdName>
<StreamLocation>^User.PACTraceOutcomeStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
