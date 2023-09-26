/// EventTimes(2309)
Class User.RBEventTimes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_EventTimes, StorageStrategy = SQLStorage ]
{

Relationship ChildRBEventTimesFacilitators As RBEventTimesFacilitators [ Cardinality = children, Inverse = TFParRef ];

/// Des Ref CancelReason
Property TIMECancelReasonDR As RBCReasonForCancel [ SqlColumnNumber = 6, SqlFieldName = TIME_CancelReason_DR ];

/// Childsub
Property TIMEChildsub As %Float [ InitialExpression = {$i(^RBEV($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"TIME",0))}, SqlColumnNumber = 2, SqlFieldName = TIME_Childsub ];

/// Date
Property TIMEDate As %Date [ SqlColumnNumber = 3, SqlFieldName = TIME_Date ];

/// RB_Event Parent Reference
Relationship TIMEParRef As RBEvent [ Cardinality = parent, Inverse = ChildRBEventTimes, Required, SqlFieldName = TIME_ParRef ];

/// Start Time
Property TIMEStartTime As %Time [ SqlColumnNumber = 4, SqlFieldName = TIME_StartTime ];

/// Status
Property TIMEStatus As %String(DISPLAYLIST = ",Initial,Booked,Transfer,Cancel,Done", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",I,B,T,X,D") [ SqlColumnNumber = 5, SqlFieldName = TIME_Status ];

/// Des Ref TransferReason
Property TIMETransferReasonDR As RBCTransferApptReason [ SqlColumnNumber = 7, SqlFieldName = TIME_TransferReason_DR ];

Index RowIDBasedIDKeyIndex On TIMEChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 227;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBEventTimes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBEventTimes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBEventTimes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBEventTimes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimes","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBEventTimes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBEventTimes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>227</ExtentSize>
<Property name="TIMECancelReasonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="TIMEChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="TIMEDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="TIMEParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="TIMEStartTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="TIMEStatus">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="TIMETransferReasonDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="TIME_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TIME_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TIME_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TIME_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TIME_TransferReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^RBEV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Event.EV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TIME_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TIME_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RBEV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Event.EV_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>TIME_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_Event.EV_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TIME_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{TIME_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TIME_RowId</SqlRowIdName>
<StreamLocation>^User.RBEventTimesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
