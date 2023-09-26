/// RB Oper Room Nurse(1550)
Class User.RBOperRoomNurse Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperRoomNurse, StorageStrategy = SQLStorage ]
{

/// Des Ref CTCP
Property NURCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = NUR_CTCP_DR ];

/// Childsub
Property NURChildsub As %Float [ InitialExpression = {$i(^RBOP($p(%d(0),$c(1)),"NUR",0))}, SqlColumnNumber = 2, SqlFieldName = NUR_Childsub ];

/// RB_OperatingRoom Parent Reference
Relationship NURParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperRoomNurse, Required, SqlFieldName = NUR_ParRef ];

Index RowIDBasedIDKeyIndex On NURChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBOperRoomNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomNurse","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBOperRoomNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomNurse","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBOperRoomNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomNurse","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBOperRoomNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomNurse","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBOperRoomNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomNurse","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NUR_CTCP_DR">
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
<Field>NUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NUR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NUR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NUR_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperRoomNurseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
