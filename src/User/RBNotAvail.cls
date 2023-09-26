/// RB Leave / Not Available  (NA,8043)
Class User.RBNotAvail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_NotAvail, StorageStrategy = SQLStorage ]
{

/// Des Ref to RB_Resource
Property NARESDR As RBResource [ Required, SqlColumnNumber = 2, SqlFieldName = NA_RES_DR ];

/// Off Start date
Property NAFrDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = NA_FrDate ];

/// Off Until - Date
Property NAToDate As %Date [ Required, SqlColumnNumber = 4, SqlFieldName = NA_ToDate ];

/// Remarks
Property NARemarks As list Of %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = NA_Remarks, SqlListType = SUBNODE ];

/// Off Start Time
Property NAFrTime As %Time [ Required, SqlColumnNumber = 6, SqlFieldName = NA_FrTime ];

/// Off Until - Time
Property NAToTime As %Time [ Required, SqlColumnNumber = 7, SqlFieldName = NA_ToTime ];

/// From date & Time
Property NAFrDateTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlComputeCode = { s:'$d(%d(8)) %d(8)=""
 s:'$d(%e(8)) %e(8)=""
 i {NA_FrDate}="" s {NA_FrDateTime}="" q
 i {NA_FrTime}="" s {NA_FrDateTime}="" q
 s {NA_FrDateTime}=$p({NA_FrDate},$c(1))_"Z"_$p({NA_FrTime},$c(1))
}, SqlComputed, SqlFieldName = NA_FrDateTime, Transient ];

/// Until Date Time
Property NAToDateTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlComputeCode = { s:'$d(%d(9)) %d(9)=""
 s:'$d(%e(9)) %e(9)=""
 i {NA_ToDate}="" s {NA_ToDateTime}="" q
 i {NA_ToTime}="" s {NA_ToDateTime}="" q
 s {NA_ToDateTime}=$p({NA_ToDate},$c(1))_"Z"_$p({NA_ToTime},$c(1))
}, SqlComputed, SqlFieldName = NA_ToDateTime, Transient ];

/// Reason Des Ref to RBCReasNA
Property NAReasonDR As RBCReasonNotAvail [ SqlColumnNumber = 10, SqlFieldName = NA_Reason_DR ];

/// Block
Property NABlock As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = NA_Block ];

/// RSVP
Property NARSVP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = NA_RSVP ];

/// Arrived
Property NAArrived As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = NA_Arrived ];

/// Des Ref RBEvent
Property NARBEventDR As RBEvent [ SqlColumnNumber = 14, SqlFieldName = NA_RBEvent_DR ];

/// Update Date
Property NAUpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = NA_UpdateDate ];

/// Update Time
Property NAUpdateTime As %Time [ SqlColumnNumber = 16, SqlFieldName = NA_UpdateTime ];

/// Des Ref UpdateUser
Property NAUpdateUserDR As SSUser [ SqlColumnNumber = 17, SqlFieldName = NA_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property NAUpdateHospitalDR As CTHospital [ SqlColumnNumber = 18, SqlFieldName = NA_UpdateHospital_DR ];

/// Des Ref Service
Property NAServiceDR As RBCServices [ SqlColumnNumber = 19, SqlFieldName = NA_Service_DR ];

/// Vacant
Property NAVacant As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = NA_Vacant ];

/// Reason Des Ref to RBCReasNA
Property NADayOfWeekDR As CTDayOfWeek [ SqlColumnNumber = 21, SqlFieldName = NA_DayOfWeek_DR ];

/// NA_TimeRange_DR
Property NATimeRangeDR As User.DHCTimeRange [ SqlColumnNumber = 22, SqlFieldName = NA_TimeRange_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBNotAvail","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBNotAvail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBNotAvail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBNotAvail","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBNotAvail","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RB("NA",0))</SqlIdExpression>
<SQLMap name="DataMasterNA">
<Data name="NA_Arrived">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NA_Block">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NA_DayOfWeek_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="NA_FrDate">
<Delimiter>"^","Z"</Delimiter>
<Piece>2,1</Piece>
</Data>
<Data name="NA_FrDateTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NA_FrTime">
<Delimiter>"^","Z"</Delimiter>
<Piece>2,2</Piece>
</Data>
<Data name="NA_RBEvent_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NA_RES_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NA_RSVP">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NA_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NA_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="NA_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NA_TimeRange_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="NA_ToDate">
<Delimiter>"^","Z"</Delimiter>
<Piece>3,1</Piece>
</Data>
<Data name="NA_ToDateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NA_ToTime">
<Delimiter>"^","Z"</Delimiter>
<Piece>3,2</Piece>
</Data>
<Data name="NA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NA_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NA_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NA_Vacant">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{NA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBlock">
<Condition>$p({NA_Block},$c(1))="Y"</Condition>
<ConditionFields>NA_Block</ConditionFields>
<Global>^RB</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BLOCK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NA_RES_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NA_FrDateTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{NA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRESDR">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>NA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{NA_RES_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{NA_FrDateTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{NA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NA_RowId</SqlRowIdName>
<StreamLocation>^User.RBNotAvailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
