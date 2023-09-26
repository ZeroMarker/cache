/// Admission Department Room(1436)
Class User.PAAdmDepartmentRoom Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_AdmDepartmentRoom, StorageStrategy = SQLStorage ]
{

/// PA_AdmDepartment Parent Reference
Relationship ROOMParRef As PAAdmDepartment [ Cardinality = parent, Inverse = ChildPAAdmDepartmentRoom, Required, SqlFieldName = ROOM_ParRef ];

/// Des Ref Room
Property ROOMRoomDR As PACRoom [ SqlColumnNumber = 2, SqlFieldName = ROOM_Room_DR ];

Index RowIDBasedIDKeyIndex On ROOMRoomDR [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAdmDepartmentRoom).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartmentRoom","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAdmDepartmentRoom).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartmentRoom","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAdmDepartmentRoom).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartmentRoom","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAdmDepartmentRoom).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartmentRoom","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAdmDepartmentRoom).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAAdmDepartmentRoom","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmDepartment.DEP_Date</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ROOM_Room_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmDepartment.DEP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ROOM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ROOM_Room_DR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ROOM_RowId</SqlRowIdName>
<StreamLocation>^User.PAAdmDepartmentRoomS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
