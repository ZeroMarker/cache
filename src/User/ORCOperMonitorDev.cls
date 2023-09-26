/// Oper Monitor Device(1007)
Class User.ORCOperMonitorDev Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_OperMonitorDev, StorageStrategy = SQLStorage ]
{

/// Monitor Device Code
Property OPMONCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = OPMON_Code ];

/// Mon. Device Description
Property OPMONDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = OPMON_Desc ];

Index OPMONCodeUnqIdx1 On OPMONCode [ Unique ];

Parameter EXTENTSIZE = 20;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCOperMonitorDev).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperMonitorDev","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCOperMonitorDev).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperMonitorDev","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCOperMonitorDev).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperMonitorDev","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCOperMonitorDev).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperMonitorDev","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCOperMonitorDev).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperMonitorDev","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>20</ExtentSize>
<Property name="OPMONCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="OPMONDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^ORC("OPMON",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OPMON_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPMON_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OPMON_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPMON"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPMON_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPMON_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPMON"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OPMON_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPMON_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPMON_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPMON"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OPMON_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPMON_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OPMON_RowId</SqlRowIdName>
<StreamLocation>^User.ORCOperMonitorDevS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
