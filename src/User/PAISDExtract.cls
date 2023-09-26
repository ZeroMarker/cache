/// PA ISD Extract(2023)
Class User.PAISDExtract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ISDExtract, StorageStrategy = SQLStorage ]
{

/// End Date
Property ISDEndDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ISD_EndDate ];

/// Run Date
Property ISDRunDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ISD_RunDate ];

/// Run Time
Property ISDRunTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ISD_RunTime ];

/// Start Date
Property ISDStartDate As %Date [ SqlColumnNumber = 2, SqlFieldName = ISD_StartDate ];

/// Type
Property ISDType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ISD_Type ];

/// Des Ref User
Property ISDUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = ISD_User_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAISDExtract).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISDExtract","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAISDExtract).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISDExtract","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAISDExtract).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISDExtract","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAISDExtract).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISDExtract","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAISDExtract).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAISDExtract","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="ISDEndDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISDRunDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISDRunTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISDStartDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISDType">
<Selectivity>1</Selectivity>
</Property>
<Property name="ISDUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAISD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ISD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISD_RunDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ISD_RunTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISD_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISD_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAISD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ISD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ISD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ISD_RowId</SqlRowIdName>
<StreamLocation>^User.PAISDExtractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
