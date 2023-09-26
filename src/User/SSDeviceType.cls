/// SS Device Type(1268)
Class User.SSDeviceType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_DeviceType, StorageStrategy = SQLStorage ]
{

/// SS_DeviceType Row ID
Property SSDeviceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlFieldName = SS_DeviceType ];

Index RowIDBasedIDKeyIndex On SSDeviceType [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 14;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSDeviceType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDeviceType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSDeviceType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDeviceType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSDeviceType).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDeviceType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSDeviceType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDeviceType","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSDeviceType).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDeviceType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>14</ExtentSize>
<Property name="SSDeviceType">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Global>^%IS</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>SS_DeviceType</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SS_DeviceType}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SS_DeviceType</SqlRowIdName>
<StreamLocation>^User.SSDeviceTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
