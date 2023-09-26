/// PA Wait List Review(2038)
Class User.PAWaitingListReview Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingListReview, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On REVChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_WaitingList Parent Reference
Relationship REVParRef As PAWaitingList [ Cardinality = parent, Inverse = ChildPAWaitingListReview, Required, SqlFieldName = REV_ParRef ];

/// Childsub
Property REVChildsub As %Float [ InitialExpression = {$i(^PAWL($p(initvalue,$c(1)),"REV",0))}, SqlColumnNumber = 2, SqlFieldName = REV_Childsub ];

/// Date
Property REVDate As %Date [ SqlColumnNumber = 3, SqlFieldName = REV_Date ];

/// Time
Property REVTime As %Time [ SqlColumnNumber = 4, SqlFieldName = REV_Time ];

/// Des Ref User
Property REVUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = REV_User_DR ];

/// Des Ref RevStatus
Property REVRevStatusDR As PACWLReviewStatus [ SqlColumnNumber = 6, SqlFieldName = REV_RevStatus_DR ];

/// Des Ref RevOutcome
Property REVRevOutcomeDR As PACWLReviewOutcome [ SqlColumnNumber = 7, SqlFieldName = REV_RevOutcome_DR ];

/// Comment
Property REVComment As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = REV_Comment, SqlListType = subnode ];

/// Patient Respond
Property REVPatientRespond As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = REV_PatientRespond ];

/// Effective Date
Property REVEffDate As %Date [ SqlColumnNumber = 10, SqlFieldName = REV_EffDate ];

/// Des Ref UpdateUserHospital
Property REVUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = REV_UpdateUserHospital_DR ];

/// Des Ref LetterType
Property REVLetterTypeDR As PACLetterType [ SqlColumnNumber = 12, SqlFieldName = REV_LetterType_DR ];

/// Date Letter Printed
Property REVDateLetterPrinted As %Date [ SqlColumnNumber = 13, SqlFieldName = REV_DateLetterPrinted ];

/// Letter Sent To
Property REVLetterSentTo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = REV_LetterSentTo ];

/// ResponseDueDate
Property REVResponseDueDate As %Date [ SqlColumnNumber = 15, SqlFieldName = REV_ResponseDueDate ];

/// PatientResponseDate
Property REVPatientResponseDate As %Date [ SqlColumnNumber = 16, SqlFieldName = REV_PatientResponseDate ];

/// ReviewDate
Property REVReviewDate As %Date [ SqlColumnNumber = 17, SqlFieldName = REV_ReviewDate ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAWaitingListReview).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListReview","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAWaitingListReview).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListReview","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAWaitingListReview).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListReview","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAWaitingListReview).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListReview","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListReview","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAWaitingListReview).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingListReview","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="REV_Comment">
<Node>"REM"</Node>
</Data>
<Data name="REV_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REV_DateLetterPrinted">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="REV_EffDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REV_LetterSentTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REV_LetterType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REV_PatientRespond">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REV_PatientResponseDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REV_ResponseDueDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="REV_RevOutcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REV_RevStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REV_ReviewDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="REV_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REV_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REV_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_WaitingList.WL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_WaitingList.WL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REV_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REV_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListReviewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
