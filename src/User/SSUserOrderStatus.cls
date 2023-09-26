/// SS User Order Status(1260)
Class User.SSUserOrderStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserOrderStatus, StorageStrategy = SQLStorage ]
{

/// Childsub
Property OSTATChildsub As %Float [ InitialExpression = {$i(^SST("SSUSR",$p(%d(0),$c(1)),"OSTAT",0))}, SqlColumnNumber = 2, SqlFieldName = OSTAT_Childsub ];

/// Des Ref OrderStatus
Property OSTATOrderStatusDR As OECOrderStatus [ SqlColumnNumber = 3, SqlFieldName = OSTAT_OrderStatus_DR ];

/// SS_User Parent Reference
Relationship OSTATParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserOrderStatus, Required, SqlFieldName = OSTAT_ParRef ];

Index RowIDBasedIDKeyIndex On OSTATChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserOrderStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserOrderStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserOrderStatus).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserOrderStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderStatus","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserOrderStatus).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserOrderStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OSTAT_OrderStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OSTAT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OSTAT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OSTAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OSTAT_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserOrderStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
