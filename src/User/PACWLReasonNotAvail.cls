/// PAC Wait List Reason Not Avail(1506
Class User.PACWLReasonNotAvail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLReasonNotAvail, StorageStrategy = SQLStorage ]
{

/// Code
Property REACode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = REA_Code ];

/// Description
Property READesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = REA_Desc ];

/// Exclude from wating period
Property REAExclude As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = REA_Exclude ];

/// Unavailable Reason
Property REAUnavailableReason As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = REA_UnavailableReason ];

/// Take Off list
Property REATakeOfflist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = REA_TakeOfflist ];

/// Reinstate On list
Property REAReinstateOnlist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = REA_ReinstateOnlist ];

/// Cancel On PreAdmission
Property REACancelOnPreAdmission As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = REA_CancelOnPreAdmission ];

/// Des Ref ReasonGroup
Property REAReasonGroupDR As PACWLReasonGroup [ SqlColumnNumber = 9, SqlFieldName = REA_ReasonGroup_DR ];

/// DNAReason
Property READNAReason As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = REA_DNAReason ];

/// Date From
Property READateFrom As %Date [ SqlColumnNumber = 11, SqlFieldName = REA_DateFrom ];

/// Date To
Property READateTo As %Date [ SqlColumnNumber = 12, SqlFieldName = REA_DateTo ];

/// National Code
Property REANationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = REA_NationalCode ];

/// Restriction
Property REARestriction As %String(DISPLAYLIST = ",Waiting List Only,OutPatient Only", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",WLO,OO") [ SqlColumnNumber = 14, SqlFieldName = REA_Restriction ];

/// Priority Change
Property REAPriorityChange As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = REA_PriorityChange ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACWLReasonNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonNotAvail","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACWLReasonNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonNotAvail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACWLReasonNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonNotAvail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACWLReasonNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonNotAvail","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACWLReasonNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLReasonNotAvail","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("WLREA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="REA_CancelOnPreAdmission">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REA_DNAReason">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="REA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="REA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REA_Exclude">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REA_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="REA_PriorityChange">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="REA_ReasonGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REA_ReinstateOnlist">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REA_Restriction">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REA_TakeOfflist">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REA_UnavailableReason">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REA_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>REA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLREA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({REA_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REA_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLReasonNotAvailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
