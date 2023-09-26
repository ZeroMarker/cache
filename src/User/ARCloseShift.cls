/// AR CloseShift(2543)
Class User.ARCloseShift Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_CloseShift, StorageStrategy = SQLStorage ]
{

Relationship ChildARCloseShiftReceipt As ARCloseShiftReceipt [ Cardinality = children, Inverse = RECParRef ];

Relationship ChildARCloseShiftAdjust As ARCloseShiftAdjust [ Cardinality = children, Inverse = ADJParRef ];

/// Number
Property CLSNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLS_Number ];

/// Create Date
Property CLSCreateDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CLS_CreateDate ];

/// Create Time
Property CLSCreateTime As %Time [ SqlColumnNumber = 4, SqlFieldName = CLS_CreateTime ];

/// Des Ref CreateUser
Property CLSCreateUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = CLS_CreateUser_DR ];

/// Cancel Date
Property CLSCancelDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CLS_CancelDate ];

/// Cancel Time
Property CLSCancelTime As %Time [ SqlColumnNumber = 7, SqlFieldName = CLS_CancelTime ];

/// Des Ref CancelUser
Property CLSCancelUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = CLS_CancelUser_DR ];

/// Status
Property CLSStatus As %String(DISPLAYLIST = ",Completed,Cancel,Open", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",C,X,O") [ SqlColumnNumber = 9, SqlFieldName = CLS_Status ];

/// Des Ref Location
Property CLSRecLocationDR As CTLoc [ SqlColumnNumber = 10, SqlFieldName = CLS_RecLocation_DR ];

/// RecDate
Property CLSRecDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CLS_RecDate ];

/// Rec Time From
Property CLSRecTimeFrom As %Time [ SqlColumnNumber = 12, SqlFieldName = CLS_RecTimeFrom ];

/// Rec Time To
Property CLSRecTimeTo As %Time [ SqlColumnNumber = 13, SqlFieldName = CLS_RecTimeTo ];

/// Des Ref RecCashier
Property CLSRecCashierDR As SSUser [ SqlColumnNumber = 14, SqlFieldName = CLS_RecCashier_DR ];

/// Opening Balance
Property CLSOpeningBalance As %Float [ SqlColumnNumber = 15, SqlFieldName = CLS_OpeningBalance ];

/// Closing Balance
Property CLSClosingBalance As %Float [ SqlColumnNumber = 16, SqlFieldName = CLS_ClosingBalance ];

/// Des Ref CashierClosing
Property CLSCashierClosingDR As SSUser [ SqlColumnNumber = 17, SqlFieldName = CLS_CashierClosing_DR ];

/// Des Ref CashierCheck
Property CLSCashierCheckDR As SSUser [ SqlColumnNumber = 18, SqlFieldName = CLS_CashierCheck_DR ];

/// Notes
Property CLSNotes As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CLS_Notes, SqlListType = SUBNODE ];

/// Des Ref ReasonCancel
Property CLSReasonCancelDR As ARCCashShiftCancReason [ SqlColumnNumber = 20, SqlFieldName = CLS_ReasonCancel_DR ];

/// CancelText
Property CLSCancelText As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = CLS_CancelText, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCloseShift).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShift","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCloseShift).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShift","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCloseShift).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShift","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCloseShift).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShift","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCloseShift).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShift","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>46</ExtentSize>
<Property name="CLSCancelDate">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="CLSCancelText">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="CLSCancelTime">
<Selectivity>3.1250%</Selectivity>
</Property>
<Property name="CLSCancelUserDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CLSCashierCheckDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="CLSCashierClosingDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CLSClosingBalance">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="CLSCreateDate">
<Selectivity>7.1429%</Selectivity>
</Property>
<Property name="CLSCreateTime">
<Selectivity>2.1739%</Selectivity>
</Property>
<Property name="CLSCreateUserDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="CLSNotes">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="CLSNumber">
<Selectivity>2.1739%</Selectivity>
</Property>
<Property name="CLSOpeningBalance">
<Selectivity>3.7037%</Selectivity>
</Property>
<Property name="CLSReasonCancelDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CLSRecCashierDR">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="CLSRecDate">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="CLSRecLocationDR">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="CLSRecTimeFrom">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CLSRecTimeTo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="CLSStatus">
<Selectivity>25.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^AR("CLSH",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CLS_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CLS_CancelText">
<Node>"CAN"</Node>
</Data>
<Data name="CLS_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CLS_CancelUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CLS_CashierCheck_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CLS_CashierClosing_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CLS_ClosingBalance">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CLS_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CLS_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CLS_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CLS_Notes">
<Node>"REM"</Node>
</Data>
<Data name="CLS_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CLS_OpeningBalance">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CLS_ReasonCancel_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CLS_RecCashier_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CLS_RecDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CLS_RecLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CLS_RecTimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CLS_RecTimeTo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CLS_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLSH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CLS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLSH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLS_CreateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^AR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CLS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLSH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Number"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CLS_Number})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CLS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCloseShiftS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
