/// RB Location Schedule      (LS,8051)
Class User.RBLocSchedule Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_LocSchedule, StorageStrategy = SQLStorage ]
{

/// CT_Loc Parent Reference
Relationship LSCTLOCParRef As CTLoc [ Cardinality = parent, Inverse = ChildRBLocSchedule, Required, SqlFieldName = LS_CTLOC_ParRef ];

/// Child Sub (New Key)
Property LSChildSub As %Float [ InitialExpression = {$i(^RB("LS",+%d(0),0))}, Required, SqlColumnNumber = 2, SqlFieldName = LS_ChildSub ];

/// des ref to CT DayOfWeek
Property LSDOWDR As CTDayOfWeek [ Required, SqlColumnNumber = 3, SqlFieldName = LS_DOW_DR ];

/// Doctor Load Default
Property LSLoad As %Float(MAXVAL = 99, MINVAL = 1) [ InitialExpression = {$$Policy^aRB11(2)}, Required, SqlColumnNumber = 8, SqlFieldName = LS_Load ];

/// No of Appt per Session
Property LSNoApptSession As %Float(MAXVAL = 99, MINVAL = 1) [ Required, SqlColumnNumber = 7, SqlFieldName = LS_NoApptSession ];

/// Session End Time
Property LSSessEndTime As %Time [ Required, SqlColumnNumber = 6, SqlFieldName = LS_SessEndTime ];

/// Session Start Time
Property LSSessStartTime As %Time [ Required, SqlColumnNumber = 5, SqlFieldName = LS_SessStartTime ];

/// Session
Property LSSession As %Float(MAXVAL = 99, MINVAL = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = LS_Session ];

/// Slot Number
Property LSSlot As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = LS_Slot ];

Index RowIDBasedIDKeyIndex On LSChildSub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBLocSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBLocSchedule","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBLocSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBLocSchedule","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBLocSchedule).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBLocSchedule","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBLocSchedule).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBLocSchedule","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBLocSchedule).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBLocSchedule","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterLS">
<Data name="LS_DOW_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LS_Load">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LS_NoApptSession">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LS_SessEndTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LS_SessStartTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LS_Session">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LS_Slot">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLSSessStartTime">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LS_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LS"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"STime"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{LS_SessStartTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{LS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LS_RowId</SqlRowIdName>
<StreamLocation>^User.RBLocScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
