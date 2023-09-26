/// Wait List Priority Sess Typ(1720)
Class User.PACWaitLisPrioritySessType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WaitLisPrioritySessType, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SESSChildsub As %Float [ InitialExpression = {$i(^PAC("WLP",$p(%d(0),$c(1)),"SESS",0))}, SqlColumnNumber = 2, SqlFieldName = SESS_Childsub ];

/// PAC_WaitingListPriority Parent Reference
Relationship SESSParRef As PACWaitingListPriority [ Cardinality = parent, Inverse = ChildPACWaitLisPrioritySessType, Required, SqlFieldName = SESS_ParRef ];

/// Des Ref SessionType
Property SESSSessionTypeDR As RBCSessionType [ SqlColumnNumber = 3, SqlFieldName = SESS_SessionType_DR ];

Index RowIDBasedIDKeyIndex On SESSChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWaitLisPrioritySessType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWaitLisPrioritySessType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWaitLisPrioritySessType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWaitLisPrioritySessType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWaitLisPrioritySessType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWaitLisPrioritySessType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWaitLisPrioritySessType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWaitLisPrioritySessType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWaitLisPrioritySessType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACWaitLisPrioritySessType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SESS_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_WaitingListPriority.WLP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_WaitingListPriority.WLP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SESS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSessType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_WaitingListPriority.WLP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>SESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_WaitingListPriority.WLP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SessType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SESS_SessionType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SESS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SESS_RowId</SqlRowIdName>
<StreamLocation>^User.PACWaitLisPrioritySessTypS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
