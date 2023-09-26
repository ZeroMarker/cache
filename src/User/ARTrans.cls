/// AR Transaction(1709)
Class User.ARTrans Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_Trans, StorageStrategy = SQLStorage ]
{

/// Transaction Type
Property TRType As %String(DISPLAYLIST = ",Bill Created,Refund Created,Receipt Created,Bill Written Off,Bill Outstanding Updated,Patient Outstanding Updated,Bill Discount Update,Allocation,Reverse Allocation,Not Allocated,Cancel Payment,Refund", MAXLEN = 27, TRUNCATE = 1, VALUELIST = ",BC,RFC,RC,BW,BO,PO,BDU,ALLOC,REVAL,NALL,CANCP,REF") [ SqlColumnNumber = 2, SqlFieldName = TR_Type ];

/// Date
Property TRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = TR_Date ];

/// Time
Property TRTime As %Time [ SqlColumnNumber = 4, SqlFieldName = TR_Time ];

/// Des Ref User
Property TRUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = TR_User_DR ];

/// Des Ref PAPER
Property TRPAPERDR As PAPerson [ SqlColumnNumber = 6, SqlFieldName = TR_PAPER_DR ];

/// Des Ref PAADM
Property TRPAADMDR As PAAdm [ SqlColumnNumber = 7, SqlFieldName = TR_PAADM_DR ];

/// Des Ref ARPBL
Property TRARPBLDR As ARPatientBill [ SqlColumnNumber = 8, SqlFieldName = TR_ARPBL_DR ];

/// Des Ref ARRCA
Property TRARRCADR As ARRcptAlloc [ SqlColumnNumber = 9, SqlFieldName = TR_ARRCA_DR ];

/// Amount
Property TRAmount As %Float [ SqlColumnNumber = 10, SqlFieldName = TR_Amount ];

/// Des Ref InsType
Property TRInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 11, SqlFieldName = TR_InsType_DR ];

/// Des Ref DiscType
Property TRDiscTypeDR As ARCDiscretDiscType [ SqlColumnNumber = 12, SqlFieldName = TR_DiscType_DR ];

/// Des Ref DiscretOutsType
Property TRDiscretOutsTypeDR As ARCDisretOutstType [ SqlColumnNumber = 13, SqlFieldName = TR_DiscretOutsType_DR ];

/// Des Ref Bill Discount
Property TRBillDiscountDR As ARPatBillDiscount [ SqlColumnNumber = 14, SqlFieldName = TR_BillDiscount_DR ];

/// Des Ref BillOutstand
Property TRBillOutstandDR As ARPatBillOutstand [ SqlColumnNumber = 15, SqlFieldName = TR_BillOutstand_DR ];

/// Des Ref BillWriteOff
Property TRBillWriteOffDR As ARPatBillWriteOff [ SqlColumnNumber = 16, SqlFieldName = TR_BillWriteOff_DR ];

/// Des Ref ReceiptID
Property TRReceiptIDDR As ARReceipts [ SqlColumnNumber = 17, SqlFieldName = TR_ReceiptID_DR ];

/// Des Ref UserLocation
Property TRUserLocationDR As CTLoc [ SqlColumnNumber = 18, SqlFieldName = TR_UserLocation_DR ];

/// Des Ref AccountPeriod
Property TRAccountPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 19, SqlFieldName = TR_AccountPeriod_DR ];

/// Des Ref AR_Trans
Property TROrgARTransDR As ARTrans [ SqlColumnNumber = 20, SqlFieldName = TR_OrgAR_Trans_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARTrans).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARTrans","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARTrans).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARTrans","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARTrans).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARTrans","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARTrans).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARTrans","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARTrans","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARTrans).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARTrans","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARTR(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TR_ARPBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TR_ARRCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TR_AccountPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="TR_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TR_BillDiscount_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TR_BillOutstand_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TR_BillWriteOff_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TR_DiscType_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TR_DiscretOutsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TR_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TR_OrgAR_Trans_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="TR_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TR_PAPER_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TR_ReceiptID_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TR_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TR_UserLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="TR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^ARTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARRCA">
<Global>^ARTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARRCA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_ARRCA_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_InsType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^ARTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPER">
<Global>^ARTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_PAPER_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRec">
<Global>^ARTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Rec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_ReceiptID_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^ARTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TR_RowId</SqlRowIdName>
<StreamLocation>^User.ARTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
