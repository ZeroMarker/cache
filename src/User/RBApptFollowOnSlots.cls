/// RB Appt Follow On Slots(RBFOS,1302)
Class User.RBApptFollowOnSlots Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptFollowOnSlots, StorageStrategy = SQLStorage ]
{

/// Des Ref to ApptSch
Property RBFOSApptSchDR As RBApptSchedule [ SqlColumnNumber = 4, SqlFieldName = RBFOS_ApptSch_DR ];

/// Childsub
Property RBFOSChildsub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"APPT",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"SLOT",0))}, SqlColumnNumber = 2, SqlFieldName = RBFOS_Childsub ];

/// No Of Slots taken up in RBAS by this APPT
Property RBFOSNoOfSlots As %Float [ SqlColumnNumber = 3, SqlFieldName = RBFOS_NoOfSlots ];

/// RB_Appointment Parent Reference
Relationship RBFOSParRef As RBAppointment [ Cardinality = parent, Inverse = ChildRBApptFollowOnSlots, Required, SqlFieldName = RBFOS_ParRef ];

Index RowIDBasedIDKeyIndex On RBFOSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 14551;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBApptFollowOnSlots).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptFollowOnSlots","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBApptFollowOnSlots).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptFollowOnSlots","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBApptFollowOnSlots).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptFollowOnSlots","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBApptFollowOnSlots).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptFollowOnSlots","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBApptFollowOnSlots).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptFollowOnSlots","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>14551</ExtentSize>
<Property name="RBFOSApptSchDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBFOSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBFOSNoOfSlots">
<Selectivity>1</Selectivity>
</Property>
<Property name="RBFOSParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RBFOS_ApptSch_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RBFOS_NoOfSlots">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>RB_Appointment.APPT_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>RBFOS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"APPT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_Appointment.APPT_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SLOT"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RBFOS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RBFOS_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptFollowOnSlotsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
