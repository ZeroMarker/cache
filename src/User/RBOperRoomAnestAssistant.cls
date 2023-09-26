/// RB Oper Room Anest Assist(1549)
Class User.RBOperRoomAnestAssistant Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperRoomAnestAssistant, StorageStrategy = SQLStorage ]
{

/// Des Ref CTCP
Property ANCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = AN_CTCP_DR ];

/// Childsub
Property ANChildsub As %Float [ InitialExpression = {$i(^RBOP($p(%d(0),$c(1)),"AN",0))}, SqlColumnNumber = 2, SqlFieldName = AN_Childsub ];

/// RB_OperatingRoom Parent Reference
Relationship ANParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperRoomAnestAssistant, Required, SqlFieldName = AN_ParRef ];

Index RowIDBasedIDKeyIndex On ANChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBOperRoomAnestAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomAnestAssistant","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBOperRoomAnestAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomAnestAssistant","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBOperRoomAnestAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomAnestAssistant","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBOperRoomAnestAssistant).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomAnestAssistant","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBOperRoomAnestAssistant).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomAnestAssistant","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AN_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AN_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperRoomAnestAssistantS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
