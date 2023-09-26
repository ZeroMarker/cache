/// AR_CloseShiftReceipt(2544)
Class User.ARCloseShiftReceipt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_CloseShiftReceipt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RECChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_CloseShift Parent Reference
Relationship RECParRef As ARCloseShift [ Cardinality = parent, Inverse = ChildARCloseShiftReceipt, Required, SqlFieldName = REC_ParRef ];

/// Childsub
Property RECChildsub As %Float [ InitialExpression = {$i(^AR("CLSH",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REC",0))}, SqlColumnNumber = 2, SqlFieldName = REC_Childsub ];

/// Des Ref ARREC
Property RECARRECDR As ARReceipts [ SqlColumnNumber = 3, SqlFieldName = REC_ARREC_DR ];

/// Cash Amt
Property RECCashAmt As %Float [ SqlColumnNumber = 4, SqlFieldName = REC_CashAmt ];

/// ChequeAmt
Property RECChequeAmt As %Float [ SqlColumnNumber = 5, SqlFieldName = REC_ChequeAmt ];

/// CardAmt
Property RECCardAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = REC_CardAmt ];

/// Direct Payment Amt
Property RECDirectPaymentAmt As %Float [ SqlColumnNumber = 7, SqlFieldName = REC_DirectPaymentAmt ];

/// TransType
Property RECTransType As %String(DISPLAYLIST = ",Open Balance,Payment,Refund,Cancelled", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",O,P,R,C") [ SqlColumnNumber = 8, SqlFieldName = REC_TransType ];

/// Des Ref ARRPM
Property RECARRPMDR As ARRcptPayMode [ SqlColumnNumber = 9, SqlFieldName = REC_ARRPM_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCloseShiftReceipt).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftReceipt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCloseShiftReceipt).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftReceipt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCloseShiftReceipt).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftReceipt","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCloseShiftReceipt).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftReceipt","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftReceipt","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCloseShiftReceipt).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftReceipt","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>2484</ExtentSize>
<Property name="RECARRECDR">
<Selectivity>0.0678%</Selectivity>
</Property>
<Property name="RECARRPMDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="RECCardAmt">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="RECCashAmt">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="RECChequeAmt">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="RECChildsub">
<Selectivity>0.1311%</Selectivity>
</Property>
<Property name="RECDirectPaymentAmt">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="RECParRef">
<Selectivity>5.8816%</Selectivity>
</Property>
<Property name="RECTransType">
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="REC_ARREC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REC_ARRPM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REC_CardAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REC_CashAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REC_ChequeAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REC_DirectPaymentAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REC_TransType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AR_CloseShift.CLS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>REC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLSH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AR_CloseShift.CLS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REC_RowId</SqlRowIdName>
<StreamLocation>^User.ARCloseShiftReceiptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
