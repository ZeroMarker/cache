/// PAC Trace Outcome(1721)
Class User.PACTraceOutcome Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_TraceOutcome, StorageStrategy = SQLStorage ]
{

Relationship ChildPACTraceOutcomeStatus As PACTraceOutcomeStatus [ Cardinality = children, Inverse = STParRef ];

/// Attendance Class
Property TRACEAttendanceClass As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TRACE_AttendanceClass ];

/// Code
Property TRACECode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TRACE_Code ];

/// Description
Property TRACEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TRACE_Desc ];

/// Number Status
Property TRACENumberStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = TRACE_NumberStatus ];

Parameter EXTENTSIZE = 12;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACTraceOutcome).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcome","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACTraceOutcome).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcome","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACTraceOutcome).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcome","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACTraceOutcome).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcome","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACTraceOutcome).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACTraceOutcome","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>12</ExtentSize>
<Property name="TRACEAttendanceClass">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRACECode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRACEDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRACENumberStatus">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("TRACE",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRACE_AttendanceClass">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TRACE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRACE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TRACE_NumberStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TRACE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRACE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRACE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRACE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRACE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRACE_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRACE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TRACE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRACE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({TRACE_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TRACE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TRACE_RowId</SqlRowIdName>
<StreamLocation>^User.PACTraceOutcomeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
