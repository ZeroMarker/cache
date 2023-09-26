/// SS Application Settings(1659)
Class User.SSAppSettings Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_AppSettings, StorageStrategy = SQLStorage ]
{

/// Application Code
Property SETAppCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SET_AppCode ];

/// Id
Property SETId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SET_Id ];

/// Key
Property SETKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SET_Key ];

/// Parameter
Property SETParameter As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = SET_Parameter ];

/// Type
Property SETType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SET_Type ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSAppSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAppSettings","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSAppSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAppSettings","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSAppSettings).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAppSettings","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSAppSettings).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAppSettings","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSAppSettings).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSAppSettings","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="SETAppCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETId">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETKey">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETParameter">
<Selectivity>1</Selectivity>
</Property>
<Property name="SETType">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SST("SET",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SET_AppCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SET_Id">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SET_Key">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SET_Parameter">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SET_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SET_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SET_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApp">
<Global>^SST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>SET_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SET"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"App"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SET_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SET_Id}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SET_AppCode}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SET_Key}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SET_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SET_RowId</SqlRowIdName>
<StreamLocation>^User.SSAppSettingsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
