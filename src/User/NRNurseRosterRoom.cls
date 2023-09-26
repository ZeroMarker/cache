/// NR Nurse Roster Room(1051)
Class User.NRNurseRosterRoom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = NR_NurseRosterRoom, StorageStrategy = SQLStorage ]
{

/// Childsub
Property NURRChildsub As %Float [ InitialExpression = {$i(^NURSE($p(%d(0),$c(1)),"ROOM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = NURR_Childsub ];

/// PA_Nurse_Rostering Parent Reference
Relationship NURRParRef As NRNurseRostering [ Cardinality = parent, Inverse = ChildNRNurseRosterRoom, Required, SqlFieldName = NURR_ParRef ];

/// Room Des Ref to PACRoom
Property NURRRoomDR As PACRoom [ SqlColumnNumber = 3, SqlFieldName = NURR_Room_DR ];

Index RowIDBasedIDKeyIndex On NURRChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.NRNurseRosterRoom).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRosterRoom","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.NRNurseRosterRoom).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRosterRoom","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.NRNurseRosterRoom).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRosterRoom","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.NRNurseRosterRoom).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRosterRoom","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.NRNurseRosterRoom).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRNurseRosterRoom","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NURR_Room_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^NURSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NR_Nurse_Rostering.NUR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>NURR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{NR_Nurse_Rostering.NUR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ROOM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NURR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>NURR_RowId</SqlRowIdName>
<StreamLocation>^User.NRNurseRosterRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
