/// SS User Settings(1515)
Class User.SSUserSettings Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserSettings, StorageStrategy = SQLStorage ]
{

/// Application Code
Property SETAppCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SET_AppCode ];

/// Childsub
Property SETChildsub As %Float [ InitialExpression = {$i(^SST("SSUSR",$p(%d(0),$c(1)),"SET",0))}, SqlColumnNumber = 2, SqlFieldName = SET_Childsub ];

/// Key
Property SETKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SET_Key ];

/// SS_User Parent Reference
Relationship SETParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserSettings, Required, SqlFieldName = SET_ParRef ];

/// Parameter
Property SETParameter As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SET_Parameter ];

Index RowIDBasedIDKeyIndex On SETChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 8;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserSettings","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserSettings","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserSettings","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserSettings).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserSettings","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserSettings).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserSettings","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>8</ExtentSize>
<Property name="SETAppCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETKey">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETParameter">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SET_AppCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SET_Key">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SET_Parameter">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppKey">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>SET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"App"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SET_AppCode}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SET_Key}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SET_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SET_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserSettingsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
