/// RB Added Slots(1750)
Class User.RBAddedSlots Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_AddedSlots, StorageStrategy = SQLStorage ]
{

/// Des Ref Resource
Property ADDResourceDR As RBResource [ SqlColumnNumber = 2, SqlFieldName = ADD_Resource_DR ];

/// Date
Property ADDDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ADD_Date ];

/// Start Time
Property ADDStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ADD_StartTime ];

/// End Time
Property ADDEndTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ADD_EndTime ];

/// Number Of Slots
Property ADDNumberOfSlots As %Float [ SqlColumnNumber = 6, SqlFieldName = ADD_NumberOfSlots ];

/// Des Ref Appt Sched
Property ADDApptSchedDR As RBApptSchedule [ SqlColumnNumber = 7, SqlFieldName = ADD_ApptSched_DR ];

/// Des Ref ResourceFrom
Property ADDResourceFromDR As RBResource [ SqlColumnNumber = 8, SqlFieldName = ADD_ResourceFrom_DR ];

/// DateFrom
Property ADDDateFrom As %Date [ SqlColumnNumber = 9, SqlFieldName = ADD_DateFrom ];

/// Des Ref ApptSchedFrom
Property ADDApptSchedFromDR As RBApptSchedule [ SqlColumnNumber = 10, SqlFieldName = ADD_ApptSchedFrom_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBAddedSlots).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAddedSlots","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBAddedSlots).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAddedSlots","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBAddedSlots).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAddedSlots","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBAddedSlots).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAddedSlots","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBAddedSlots).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBAddedSlots","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RB("ADD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADD_ApptSchedFrom_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADD_ApptSched_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADD_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADD_NumberOfSlots">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADD_ResourceFrom_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADD_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADD_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResFrom">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ResFrom"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADD_ResourceFrom_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADD_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ADD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADD_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADD_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADD_StartTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADD_RowId</SqlRowIdName>
<StreamLocation>^User.RBAddedSlotsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
