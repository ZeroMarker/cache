/// WLOutcomeOfOffers(2738)
Class User.PACWLOutcomeOfOffers Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLOutcomeOfOffers, StorageStrategy = SQLStorage ]
{

/// Code
Property WLOOFCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WLOOF_Code ];

/// Description
Property WLOOFDesc As %String(COLLATION = "AlphaUp", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WLOOF_Desc ];

/// DateFrom
Property WLOOFDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = WLOOF_DateFrom ];

/// DateTo
Property WLOOFDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = WLOOF_DateTo ];

/// FieldToDenote
Property WLOOFFieldToDenote As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = WLOOF_FieldToDenote ];

/// StopWaitTime
Property WLOOFStopWaitTime As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = WLOOF_StopWaitTime ];

/// DisplayOnAdmission
Property WLOOFDisplayOnAdmission As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = WLOOF_DisplayOnAdmission ];

/// ResetOutComeFrom
Property WLOOFResetOutComeFrom As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = WLOOF_ResetOutComeFrom ];

/// ResetOutComeTo
Property WLOOFResetOutComeTo As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = WLOOF_ResetOutComeTo ];

/// OutcomeOfferReasonable
Property WLOOFOutcomeOfferReasonable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = WLOOF_OutcomeOfferReasonable ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACWLOutcomeOfOffers).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLOutcomeOfOffers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACWLOutcomeOfOffers).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLOutcomeOfOffers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACWLOutcomeOfOffers).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLOutcomeOfOffers","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACWLOutcomeOfOffers).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLOutcomeOfOffers","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLOutcomeOfOffers","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACWLOutcomeOfOffers).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLOutcomeOfOffers","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("WLOOF",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="WLOOF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLOOF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLOOF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLOOF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLOOF_DisplayOnAdmission">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLOOF_FieldToDenote">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLOOF_OutcomeOfferReasonable">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WLOOF_ResetOutComeFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WLOOF_ResetOutComeTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WLOOF_StopWaitTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WLOOF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLOOF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WLOOF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLOOF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLOOF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLOOF_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOOF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLOOF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLOOF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WLOOF_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLOOF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLOOF_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLOutcomeOfOffersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
