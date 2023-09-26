/// PA Wait List Not Available(1507)
Class User.PAWaitingListNotAvailable Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListNotAvailable, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On NAChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_WaitingList Parent Reference
Relationship NAParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListNotAvailable, Required, SqlFieldName = NA_ParRef ];

/// Childsub
Property NAChildsub As %Float [ InitialExpression = {$i(^PAWL($p(initvalue,$c(1)),"NA",0))}, SqlColumnNumber = 2, SqlFieldName = NA_Childsub ];

/// Date From
Property NADateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = NA_DateFrom ];

/// Date To
Property NADateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = NA_DateTo ];

/// Des Ref Reason Not Avail
Property NAReasonDR As PACWLReasonNotAvail [ SqlColumnNumber = 5, SqlFieldName = NA_Reason_DR ];

/// Exclude From Waiting
Property NAExcludeFromWaiting As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = NA_ExcludeFromWaiting ];

/// Des Ref User
Property NAUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = NA_User_DR ];

/// Date
Property NADate As %Date [ SqlColumnNumber = 8, SqlFieldName = NA_Date ];

/// Time
Property NATime As %Time [ SqlColumnNumber = 9, SqlFieldName = NA_Time ];

/// ProcessedFlag
Property NAProcessedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = NA_ProcessedFlag ];

/// Des Ref Suspension Indicator
Property NASuspensionIndicatorDR As PACSuspensionIndicator [ SqlColumnNumber = 11, SqlFieldName = NA_SuspensionIndicator_DR ];

/// Comments
Property NAComments As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = NA_Comments, SqlListType = subnode ];

/// Date From Processed Flag
Property NADateFromProcessedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = NA_DateFromProcessedFlag ];

/// Des Ref ReasonForList
Property NAReasonForListDR As PACWLReasonForList [ SqlColumnNumber = 14, SqlFieldName = NA_ReasonForList_DR ];

/// Des Ref WLType
Property NAWLTypeDR As PACWaitingListType [ SqlColumnNumber = 15, SqlFieldName = NA_WLType_DR ];

/// Des Ref UpdateUserHospital
Property NAUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 16, SqlFieldName = NA_UpdateUserHospital_DR ];

/// DateDelete
Property NADateDelete As %Date [ SqlColumnNumber = 17, SqlFieldName = NA_DateDelete ];

/// ReviewDate
Property NAReviewDate As %Date [ SqlColumnNumber = 18, SqlFieldName = NA_ReviewDate ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAWaitingListNotAvailable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListNotAvailable","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAWaitingListNotAvailable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListNotAvailable","OnAfterInsert")

 d Table^HL7Outbound("PAWaitingListNotAvailable",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAWaitingListNotAvailable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListNotAvailable","OnAfterUpdate")

 d Table^HL7Outbound("PAWaitingListNotAvailable",%d(1),"Update")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAWaitingListNotAvailable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListNotAvailable","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListNotAvailable","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAWaitingListNotAvailable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListNotAvailable","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NA_Comments">
<Node>"REM"</Node>
</Data>
<Data name="NA_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NA_DateDelete">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="NA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NA_DateFromProcessedFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="NA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NA_ExcludeFromWaiting">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NA_ProcessedFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NA_ReasonForList_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NA_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NA_ReviewDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="NA_SuspensionIndicator_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NA_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NA_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NA_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NA_WLType_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>NA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNADateFrom">
<Condition>{NA_DateFromProcessedFlag}'["Y"</Condition>
<ConditionFields>NA_DateFrom,NA_DateFromProcessedFlag</ConditionFields>
<Global>^PAWLi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>NA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NADateFrom"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NA_DateFrom}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNADateTo">
<Condition>{NA_ProcessedFlag}'["Y"</Condition>
<ConditionFields>NA_DateTo,NA_ProcessedFlag</ConditionFields>
<Global>^PAWLi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>NA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NADateTo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NA_DateTo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NA_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingLis9B2S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
