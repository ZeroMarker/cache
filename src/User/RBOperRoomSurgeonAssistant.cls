/// RB OP Room Surg Assist(1548)
Class User.RBOperRoomSurgeonAssistant Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperRoomSurgeonAssistant, StorageStrategy = SQLStorage ]
{

/// Des Ref CTCP
Property SURGCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = SURG_CTCP_DR ];

/// Childsub
Property SURGChildsub As %Float [ InitialExpression = {$i(^RBOP($p(%d(0),$c(1)),"SURG",0))}, SqlColumnNumber = 2, SqlFieldName = SURG_Childsub ];

/// RB_OperatingRoom Parent Reference
Relationship SURGParREf As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperRoomSurgeonAssistant, Required, SqlFieldName = SURG_ParREf ];

Index RowIDBasedIDKeyIndex On SURGChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBOperRoomSurgeonAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomSurgeonAssistant","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBOperRoomSurgeonAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomSurgeonAssistant","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBOperRoomSurgeonAssistant).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomSurgeonAssistant","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBOperRoomSurgeonAssistant).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomSurgeonAssistant","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBOperRoomSurgeonAssistant).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomSurgeonAssistant","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SURG_CTCP_DR">
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
<Field>SURG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SURG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SURG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SURG_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperRoomSurgeonAssistanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
