/// RB Resource Scheduling    (RS,8042)
Class User.RBResSchedule Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResSchedule, StorageStrategy = SQLStorage ]
{

Relationship ChildRBResScheduleServices As RBResScheduleServices [ Cardinality = children, Inverse = SERParRef ];

/// Child Sub (New Key)
Property RSChildSub As %Float [ InitialExpression = {$i(^RB("RES",+$s($d(initvalue):initvalue,1:%d(0)),"RS",0))}, Required, SqlColumnNumber = 2, SqlFieldName = RS_ChildSub ];

/// Des Ref to CT DayOfWeek
Property RSDOWDR As CTDayOfWeek [ Required, SqlColumnNumber = 3, SqlFieldName = RS_DOW_DR ];

/// Load Level
Property RSLoad As %Float(MAXVAL = 99, MINVAL = 1) [ InitialExpression = {$$Policy^aRB11(2)}, Required, SqlColumnNumber = 8, SqlFieldName = RS_Load ];

/// Number of Appointment for this session
Property RSNoApptSession As %Float(MAXVAL = 99, MINVAL = 1) [ Required, SqlColumnNumber = 7, SqlFieldName = RS_NoApptSession ];

/// RB_Resource Parent Reference
Relationship RSRESParRef As RBResource [ Cardinality = parent, Inverse = ChildRBResSchedule, Required, SqlFieldName = RS_RES_ParRef ];

/// Session End Time
Property RSSessEndTime As %Time [ Required, SqlColumnNumber = 6, SqlFieldName = RS_SessEndTime ];

/// Session Start Time
Property RSSessStartTime As %Time [ Required, SqlColumnNumber = 5, SqlFieldName = RS_SessStartTime ];

/// Session
Property RSSession As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = RS_Session ];

/// Des Ref Session Type
Property RSSessionTypeDR As RBCSessionType [ SqlColumnNumber = 10, SqlFieldName = RS_SessionType_DR ];

/// Slot Number
Property RSSlot As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = RS_Slot ];

Index RowIDBasedIDKeyIndex On RSChildSub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedule","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedule","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedule","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResSchedule).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedule","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResSchedule).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResSchedule","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterRS">
<Data name="RS_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RS_Load">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RS_NoApptSession">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RS_SessEndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RS_SessStartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RS_Session">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RS_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RS_Slot">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"RS"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSessStartTime">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"RS"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>"STime"</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{RS_SessStartTime}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{RS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RS_RowId</SqlRowIdName>
<StreamLocation>^User.RBResScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
