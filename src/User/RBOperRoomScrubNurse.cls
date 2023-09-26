/// RB Oper Room Scrub Nurse(1561)
Class User.RBOperRoomScrubNurse Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperRoomScrubNurse, StorageStrategy = SQLStorage ]
{

/// Des Ref CTCP
Property SCRUBCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = SCRUB_CTCP_DR ];

/// Childsub
Property SCRUBChildsub As %Float [ InitialExpression = {$i(^RBOP($p(%d(0),$c(1)),"SCRUB",0))}, SqlColumnNumber = 2, SqlFieldName = SCRUB_Childsub ];

/// RB_OperatingRoom Parent Reference
Relationship SCRUBParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperRoomScrubNurse, Required, SqlFieldName = SCRUB_ParRef ];

Index RowIDBasedIDKeyIndex On SCRUBChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBOperRoomScrubNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomScrubNurse","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBOperRoomScrubNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomScrubNurse","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBOperRoomScrubNurse).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomScrubNurse","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBOperRoomScrubNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomScrubNurse","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBOperRoomScrubNurse).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBOperRoomScrubNurse","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SCRUB_CTCP_DR">
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
<Field>SCRUB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCRUB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCRUB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SCRUB_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperRoomScrubNurseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
