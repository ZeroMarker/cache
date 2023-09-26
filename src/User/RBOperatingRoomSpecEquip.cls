/// RB Oper Room Spec Equip(1332)
Class User.RBOperatingRoomSpecEquip Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperatingRoomSpecEquip, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EQChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_OperatingRoom Parent Reference
Relationship EQParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperatingRoomSpecEquip, Required, SqlFieldName = EQ_ParRef ];

/// Childsub
Property EQChildsub As %Float [ InitialExpression = {$i(^RBOP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"EQ",0))}, SqlColumnNumber = 2, SqlFieldName = EQ_Childsub ];

/// Des Ref to Equip
Property EQEquipDR As ORCEquipment [ SqlColumnNumber = 3, SqlFieldName = EQ_Equip_DR ];

/// Des Ref APPT
Property EQAPPTDR As RBAppointment [ SqlColumnNumber = 4, SqlFieldName = EQ_APPT_DR ];

/// DateBooked
Property EQDateBooked As %Date [ SqlColumnNumber = 5, SqlFieldName = EQ_DateBooked ];

/// TimeBooked
Property EQTimeBooked As %Time [ SqlColumnNumber = 6, SqlFieldName = EQ_TimeBooked ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBOperatingRoomSpecEquip).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoomSpecEquip","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBOperatingRoomSpecEquip).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoomSpecEquip","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBOperatingRoomSpecEquip).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoomSpecEquip","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBOperatingRoomSpecEquip).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoomSpecEquip","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBOperatingRoomSpecEquip).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoomSpecEquip","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBOperatingRoomSpecEquip","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>38</ExtentSize>
<Property name="EQAPPTDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EQChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="EQDateBooked">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EQEquipDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="EQParRef">
<Selectivity>3.4483%</Selectivity>
</Property>
<Property name="EQTimeBooked">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="EQ_APPT_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EQ_DateBooked">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EQ_Equip_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EQ_TimeBooked">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^RBOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EQ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EQ_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EQ_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperatingRoomSpecEquipS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
