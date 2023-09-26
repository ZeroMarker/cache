/// SS Device(1270)
Class User.SSDevice Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Device, StorageStrategy = SQLStorage ]
{

/// General Name
Property DEVName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DEV_Name ];

/// System Name
Property DEVSystemName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlComputeCode = { s {DEV_SystemName}={SS_Device}
}, SqlComputed, SqlFieldName = DEV_SystemName, Transient ];

/// Des Ref TermType
Property DEVTermTypeDR As SSDeviceType [ SqlColumnNumber = 3, SqlFieldName = DEV_TermType_DR ];

/// Type
Property DEVType As %String(MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",TRM,SPL") [ SqlColumnNumber = 4, SqlFieldName = DEV_Type ];

/// Device Name
Property SSDevice As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlFieldName = SS_Device ];

Index RowIDBasedIDKeyIndex On SSDevice [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 13;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSDevice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDevice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSDevice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDevice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSDevice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDevice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSDevice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDevice","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSDevice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSDevice","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>13</ExtentSize>
<Property name="DEVName">
<Selectivity>1</Selectivity>
</Property>
<Property name="DEVSystemName">
<Selectivity>1</Selectivity>
</Property>
<Property name="DEVTermTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="DEVType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSDevice">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="DEV_Name">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="DEV_TermType_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="DEV_Type">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Global>^%IS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_Device</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_Device}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SS_Device</SqlRowIdName>
<StreamLocation>^User.SSDeviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
