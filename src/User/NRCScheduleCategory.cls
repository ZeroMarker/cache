/// Schedule Category(1049)
Class User.NRCScheduleCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = NRC_ScheduleCategory, StorageStrategy = SQLStorage ]
{

/// Active
Property SCHEDActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SCHED_Active ];

/// Code
Property SCHEDCode As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SCHED_Code ];

/// Description
Property SCHEDDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SCHED_Desc ];

/// Work Shift
Property SCHEDWorkShift As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SCHED_WorkShift ];

/// Des Ref WorkShift
Property SCHEDWorkShiftDR As CTWorkShif [ SqlColumnNumber = 5, SqlFieldName = SCHED_WorkShift_DR ];

Index SCHEDCodeUnqIdx1 On SCHEDCode [ Unique ];

Parameter EXTENTSIZE = 7;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.NRCScheduleCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRCScheduleCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.NRCScheduleCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRCScheduleCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.NRCScheduleCategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRCScheduleCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.NRCScheduleCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRCScheduleCategory","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.NRCScheduleCategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.NRCScheduleCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>7</ExtentSize>
<Property name="SCHEDActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHEDCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="SCHEDDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="SCHEDWorkShift">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SCHEDWorkShiftDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^NRC("SCHED",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SCHED_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SCHED_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCHED_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCHED_WorkShift">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCHED_WorkShift_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^NRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SCHED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCHED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SCHED_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^NRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SCHED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCHED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SCHED_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCHED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^NRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SCHED_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCHED"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SCHED_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SCHED_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SCHED_RowId</SqlRowIdName>
<StreamLocation>^User.NRCScheduleCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
