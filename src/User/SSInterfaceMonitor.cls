/// Interface Monitor
Class User.SSInterfaceMonitor Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_InterfaceMonitor, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INTMONInterfaceDR [ IdKey, PrimaryKey, Unique ];

/// Des Ref SS_Interface
Property INTMONInterfaceDR As SSInterface [ SqlColumnNumber = 2, SqlFieldName = INTMON_Interface_DR ];

/// Connection Status
Property INTMONStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INTMON_Status ];

/// Date Interface Started
Property INTMONDateStarted As %Date [ SqlColumnNumber = 4, SqlFieldName = INTMON_DateStarted ];

/// Time Interface Started
Property INTMONTimeStarted As %Time [ SqlColumnNumber = 5, SqlFieldName = INTMON_TimeStarted ];

/// Active
Property INTMONActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = INTMON_Active ];

/// Date of Last Message
Property INTMONDateLastMessage As %Date [ SqlColumnNumber = 7, SqlFieldName = INTMON_DateLastMessage ];

/// Time of Last Message
Property INTMONTimeLastMessage As %Time [ SqlColumnNumber = 8, SqlFieldName = INTMON_TimeLastMessage ];

/// No Of Messages Received Since Started
Property INTMONCountMessages As %Float [ SqlColumnNumber = 9, SqlFieldName = INTMON_CountMessages ];

/// No of Message in Outbound Queue
Property INTMONCountQueue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INTMON_CountQueue ];

/// Date of Last Rejected Message
Property INTMONDateLastRejection As %Date [ SqlColumnNumber = 11, SqlFieldName = INTMON_DateLastRejection ];

/// Time of Last Rejected Message
Property INTMONTimeLastRejection As %Time [ SqlColumnNumber = 12, SqlFieldName = INTMON_TimeLastRejection ];

/// No of Un-Acked Rejections
Property INTMONNoUnAckRejections As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = INTMON_NoUnAckRejections ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSInterfaceMonitor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterfaceMonitor","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSInterfaceMonitor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterfaceMonitor","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSInterfaceMonitor).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterfaceMonitor","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSInterfaceMonitor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterfaceMonitor","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSInterfaceMonitor).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSInterfaceMonitor","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INTMON_Active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTMON_CountMessages">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTMON_CountQueue">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INTMON_DateLastMessage">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INTMON_DateLastRejection">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INTMON_DateStarted">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTMON_NoUnAckRejections">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INTMON_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTMON_TimeLastMessage">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTMON_TimeLastRejection">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INTMON_TimeStarted">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SST</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INTMON_Interface_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INTMON_Interface_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MON"</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INTMON_RowId</SqlRowIdName>
<StreamLocation>^User.SSInterfaceMonitorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
