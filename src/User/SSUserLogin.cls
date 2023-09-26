/// SS User Login(1724)
Class User.SSUserLogin Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserLogin, StorageStrategy = SQLStorage ]
{

/// Logoff Date
Property LOGLogoffDate As %Date [ SqlColumnNumber = 6, SqlFieldName = LOG_LogoffDate ];

/// Logoff Time
Property LOGLogoffTime As %Time [ SqlColumnNumber = 7, SqlFieldName = LOG_LogoffTime ];

/// Logon Date
Property LOGLogonDate As %Date [ SqlColumnNumber = 4, SqlFieldName = LOG_LogonDate ];

/// Logon Time
Property LOGLogonTime As %Time [ SqlColumnNumber = 5, SqlFieldName = LOG_LogonTime ];

/// Des Ref User
Property LOGUserDR As SSUser [ SqlColumnNumber = 2, SqlFieldName = LOG_User_DR ];

/// Des Ref VBEX
Property LOGVBEXDR As SSVBExecutables [ SqlColumnNumber = 3, SqlFieldName = LOG_VBEX_DR ];

Property LOGLocDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = LOG_Loc_DR ];

Property LOGLastUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = LOG_LastUpdateDate ];

Property LOGLastUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = LOG_LastUpdateTime ];

Property LOGGroupDR As SSGroup [ SqlColumnNumber = 11, SqlFieldName = LOG_Group_DR ];

Property LOGPostDR As %String [ SqlColumnNumber = 12, SqlFieldName = LOG_Post_DR ];

Parameter EXTENTSIZE = 1000000;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserLogin).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserLogin","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserLogin).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserLogin","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserLogin).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserLogin","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserLogin).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserLogin","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserLogin).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserLogin","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<Property name="LOGLogoffDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOGLogoffTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOGLogonDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOGLogonTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOGUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="LOGVBEXDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SST("LOG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LOG_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="LOG_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LOG_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LOG_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="LOG_LogoffDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LOG_LogoffTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LOG_LogonDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LOG_LogonTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LOG_Post_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="LOG_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOG_VBEX_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LOG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOG_LogonDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOG_User_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateGroup">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>LOG_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateGroup"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOG_LogonDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOG_Group_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>LOG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOG_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LOG_LogonDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOG_LogonTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LOG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOG_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserLoginS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
