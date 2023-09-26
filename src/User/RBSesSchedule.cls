/// RB Session Schedule      (RBSS,751)
Class User.RBSesSchedule Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_SesSchedule, StorageStrategy = SQLStorage ]
{

Relationship ChildRBSesScheduleServices As RBSesScheduleServices [ Cardinality = children, Inverse = SERParRef ];

/// Child Sub
Property RBSSChildSub As %Float [ InitialExpression = {$i(^RBSS($j,0))}, SqlColumnNumber = 11, SqlFieldName = RBSS_ChildSub ];

/// Des Ref to CTDOW
Property RBSSDOWDR As CTDayOfWeek [ SqlColumnNumber = 10, SqlFieldName = RBSS_DOW_DR ];

/// Schedule Date
Property RBSSDate As %Date [ SqlColumnNumber = 12, SqlFieldName = RBSS_Date ];

/// Job Id
Property RBSSJobId As %Float [ InitialExpression = {$j}, SqlColumnNumber = 2, SqlFieldName = RBSS_JobId ];

/// Load Level
Property RBSSLoad As %Float(MAXVAL = 99, MINVAL = 1) [ Required, SqlColumnNumber = 8, SqlFieldName = RBSS_Load ];

/// Number of Appointments/Slot
Property RBSSNoApptSlot As %Float(MAXVAL = 99, MINVAL = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = RBSS_NoApptSlot ];

/// Number of Slots/Session
Property RBSSNoSlots As %Float(MAXVAL = 99, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = RBSS_NoSlots ];

/// Session Number
Property RBSSSessionNo As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = RBSS_SessionNo ];

/// Des Ref SessionType
Property RBSSSessionTypeDR As RBCSessionType [ SqlColumnNumber = 13, SqlFieldName = RBSS_SessionType_DR ];

/// Length of Each Slot in Minutes
Property RBSSSlotLength As %Float(MAXVAL = 99999, MINVAL = 1) [ Required, SqlColumnNumber = 7, SqlFieldName = RBSS_SlotLength ];

/// Session End Time
Property RBSSTimeEnd As %Time [ Required, SqlColumnNumber = 5, SqlFieldName = RBSS_TimeEnd ];

/// Session Start Time
Property RBSSTimeStart As %Time [ Required, SqlColumnNumber = 4, SqlFieldName = RBSS_TimeStart ];

Index RowIDBasedIDKeyIndex On (RBSSJobId, RBSSChildSub) [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBSesSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedule","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBSesSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedule","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBSesSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedule","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBSesSchedule).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedule","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBSesSchedule).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBSesSchedule","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMapRBSS">
<Data name="RBSS_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RBSS_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RBSS_Load">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RBSS_NoApptSlot">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBSS_NoSlots">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RBSS_SessionNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RBSS_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RBSS_SlotLength">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RBSS_TimeEnd">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RBSS_TimeStart">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^RBSS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RBSS_JobId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RBSS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RBSS_JobId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RBSS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RBSS_RowId</SqlRowIdName>
<StreamLocation>^User.RBSesScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
