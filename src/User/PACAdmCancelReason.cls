/// AdmCancelReason(2061)
Class User.PACAdmCancelReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AdmCancelReason, StorageStrategy = SQLStorage ]
{

/// Code
Property ADMCRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ADMCR_Code ];

/// Description
Property ADMCRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADMCR_Desc ];

/// Date From
Property ADMCRDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ADMCR_DateFrom ];

/// Date To
Property ADMCRDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ADMCR_DateTo ];

/// Allow to Show Results in EPR
Property ADMCRAllowShowResultsEPR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ADMCR_AllowShowResultsEPR ];

/// DefaultForAutoCancel
Property ADMCRDefaultForAutoCancel As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ADMCR_DefaultForAutoCancel ];

/// Allow Display of Questionnaire on EPR
Property ADMCRDisplayQuestionEPR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ADMCR_DisplayQuestionEPR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACAdmCancelReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmCancelReason","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACAdmCancelReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmCancelReason","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACAdmCancelReason).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmCancelReason","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACAdmCancelReason).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmCancelReason","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmCancelReason","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACAdmCancelReason).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmCancelReason","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("ADMCR",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ADMCR_AllowShowResultsEPR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADMCR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADMCR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADMCR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADMCR_DefaultForAutoCancel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADMCR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADMCR_DisplayQuestionEPR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADMCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ADMCR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADMCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADMCR_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADMCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADMCR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADMCR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ADMCR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADMCR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADMCR_RowId</SqlRowIdName>
<StreamLocation>^User.PACAdmCancelReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
