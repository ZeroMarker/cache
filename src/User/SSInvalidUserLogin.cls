/// SS Invalid User Login
Class User.SSInvalidUserLogin Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_InvalidUserLogin, StorageStrategy = SQLStorage ]
{

/// Computer Name
Property INVLOGComputerName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INVLOG_ComputerName ];

/// Date
Property INVLOGDate As %Date [ SqlColumnNumber = 2, SqlFieldName = INVLOG_Date ];

/// Time
Property INVLOGTime As %Time [ SqlColumnNumber = 3, SqlFieldName = INVLOG_Time ];

/// Des Ref User
Property INVLOGUserDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = INVLOG_User_DR ];

Parameter EXTENTSIZE = 4050;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSInvalidUserLogin).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSInvalidUserLogin","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSInvalidUserLogin).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSInvalidUserLogin","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSInvalidUserLogin).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSInvalidUserLogin","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSInvalidUserLogin).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSInvalidUserLogin","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSInvalidUserLogin).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSInvalidUserLogin","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4050</ExtentSize>
<Property name="INVLOGComputerName">
<Selectivity>1</Selectivity>
</Property>
<Property name="INVLOGDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="INVLOGTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="INVLOGUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SST("INVLOG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INVLOG_ComputerName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INVLOG_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INVLOG_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INVLOG_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INVLOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INVLOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INVLOG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateUser">
<Condition>1</Condition>
<Global>^SST</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INVLOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INVLOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INVLOG_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INVLOG_User_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INVLOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INVLOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INVLOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INVLOG_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INVLOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdate">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INVLOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INVLOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INVLOG_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INVLOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INVLOG_RowId</SqlRowIdName>
<StreamLocation>^User.SSInvalidUserLoginS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
