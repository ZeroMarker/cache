/// ORC Ana Method Agent Alloc(1554)
Class User.ORCANAMethodAgentAlloc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_ANA_Method_Agent_Alloc, StorageStrategy = SQLStorage ]
{

/// Des Ref Agent
Property METAGAgentDR As ORCAnaestAgent [ SqlColumnNumber = 3, SqlFieldName = METAG_Agent_DR ];

/// Des Ref Ana Method
Property METAGMethodDR As ORCAnaestMethod [ SqlColumnNumber = 2, SqlFieldName = METAG_Method_DR ];

Parameter EXTENTSIZE = 33;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCANAMethodAgentAlloc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCANAMethodAgentAlloc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCANAMethodAgentAlloc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCANAMethodAgentAlloc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCANAMethodAgentAlloc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCANAMethodAgentAlloc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCANAMethodAgentAlloc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCANAMethodAgentAlloc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCANAMethodAgentAlloc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCANAMethodAgentAlloc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>33</ExtentSize>
<Property name="METAGAgentDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="METAGMethodDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^ORC("METAG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="METAG_Agent_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="METAG_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>METAG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"METAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{METAG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMethod">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>METAG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"METAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"METH"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{METAG_Method_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{METAG_Agent_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{METAG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>METAG_RowId</SqlRowIdName>
<StreamLocation>^User.ORCANAMethodAgentAllocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
