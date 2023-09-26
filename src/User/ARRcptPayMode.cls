/// AR Receipt Payment Mode(1305)
Class User.ARRcptPayMode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_RcptPayMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PAYMChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_Receipts Parent Reference
Relationship PAYMParRef As User.ARReceipts [ Cardinality = parent, Inverse = ChildARRcptPayMode, Required, SqlFieldName = PAYM_ParRef ];

/// Childsub
Property PAYMChildsub As %Float [ InitialExpression = {$i(^ARRCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PAYM",0))}, SqlColumnNumber = 2, SqlFieldName = PAYM_Childsub ];

/// Des Ref to PayMode
Property PAYMPayModeDR As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = PAYM_PayMode_DR ];

/// Des Ref to CMBank
Property PAYMCMBankDR As User.CMCBankMas [ SqlColumnNumber = 4, SqlFieldName = PAYM_CMBank_DR ];

/// Amount
Property PAYMAmt As %Float [ SqlColumnNumber = 5, SqlFieldName = PAYM_Amt ];

/// Card/Cheque No
Property PAYMCardChequeNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PAYM_CardChequeNo ];

/// Author Code
Property PAYMAuthorCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PAYM_AuthorCode ];

/// Des Ref Currency
Property PAYMCurrencyDR As User.CTCurrency [ SqlColumnNumber = 8, SqlFieldName = PAYM_Currency_DR ];

/// Currency Amt
Property PAYMCurrencyAmt As %Float [ SqlColumnNumber = 9, SqlFieldName = PAYM_CurrencyAmt ];

/// Des Ref Card
Property PAYMCardDR As User.ARCBankCardType [ SqlColumnNumber = 10, SqlFieldName = PAYM_Card_DR ];

/// Change Amount
Property PAYMChangeAmount As %Float [ SqlColumnNumber = 11, SqlFieldName = PAYM_ChangeAmount ];

/// Cheque Date
Property PAYMChequeDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PAYM_ChequeDate ];

/// BankSlipNo
Property PAYMBankSlipNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PAYM_BankSlipNo ];

/// Invalid Flag
Property PAYMInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PAYM_InvalidFlag ];

/// Des Ref CredCardPaym
Property PAYMCredCardPaymDR As User.ARCreditCardPayments [ SqlColumnNumber = 15, SqlFieldName = PAYM_CredCardPaym_DR ];

/// Reconcile
Property PAYMReconcile As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = PAYM_Reconcile ];

/// Des Ref User
Property PAYMInvUser As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = PAYM_InvUser ];

/// PAYM_InvDate
Property PAYMInvDate As %Date [ SqlColumnNumber = 18, SqlFieldName = PAYM_InvDate ];

/// PAYM_InvTime
Property PAYMInvTime As %Time [ SqlColumnNumber = 19, SqlFieldName = PAYM_InvTime ];

/// PAYM_TransFlag
Property PAYMTransFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = PAYM_TransFlag ];

/// PAYM_Unit_DR 公费单位
Property PAYMUnitDR As User.CTHealthCareProvider [ SqlColumnNumber = 21, SqlFieldName = PAYM_Unit_DR ];

/// PAYM_InsuFlag 住院结算是否医保支付方式标识
Property PAYMInsuFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = PAYM_InsuFlag ];

/// PAYM_Branch
Property PAYMBranch As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PAYM_Branch ];

/// Drawer
Property PAYMDrawer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = PAYM_Drawer ];

/// Card Expiry Date
Property PAYMCardExpiryDate As %Date [ SqlColumnNumber = 25, SqlFieldName = PAYM_CardExpiryDate ];

/// Des Ref InvLoc
Property PAYMInvLocDR As User.CTLoc [ SqlColumnNumber = 26, SqlFieldName = PAYM_InvLoc_DR ];

/// AddDate
Property PAYMAddDate As %Date [ SqlColumnNumber = 27, SqlFieldName = PAYM_AddDate ];

/// Add Time
Property PAYMAddTime As %Time [ SqlColumnNumber = 28, SqlFieldName = PAYM_AddTime ];

/// Remarks
Property PAYMRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = PAYM_Remarks, SqlListType = SUBNODE ];

/// RefundComments
Property PAYMRefundComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PAYM_RefundComments, SqlListType = SUBNODE ];

/// Date
Property PAYMDate As %Date [ SqlColumnNumber = 31, SqlFieldName = PAYM_Date ];

/// Des Ref CancelReason
Property PAYMCancelReasonDR As User.ARCReasonWriteOff [ SqlColumnNumber = 32, SqlFieldName = PAYM_CancelReason_DR ];

/// CancelComments
Property PAYMCancelComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = PAYM_CancelComments, SqlListType = SUBNODE ];

/// RefundNo
Property PAYMRefundNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = PAYM_RefundNo ];

/// UpdateDate
Property PAYMUpdateDate As %Date [ SqlColumnNumber = 35, SqlFieldName = PAYM_UpdateDate ];

/// UpdateTime
Property PAYMUpdateTime As %Time [ SqlColumnNumber = 36, SqlFieldName = PAYM_UpdateTime ];

/// Des Ref UpdateUser
Property PAYMUpdateUserDR As User.SSUser [ SqlColumnNumber = 37, SqlFieldName = PAYM_UpdateUser_DR ];

/// Des Ref CTLOC
Property PAYMCTLOCDR As User.CTLoc [ SqlColumnNumber = 38, SqlFieldName = PAYM_CTLOC_DR ];

/// PAYMETPDR 第三方支付交易表指针
Property PAYMETPDR As User.DHCBillExtTradePay [ SqlColumnNumber = 39, SqlFieldName = PAYM_ETP_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARRcptPayMode).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptPayMode","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARRcptPayMode).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptPayMode","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARRcptPayMode).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptPayMode","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARRcptPayMode).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptPayMode","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptPayMode","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARRcptPayMode).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptPayMode","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>2712</ExtentSize>
<Property name="PAYMAddDate">
<Selectivity>6.6665%</Selectivity>
</Property>
<Property name="PAYMAddTime">
<Selectivity>4.7595%</Selectivity>
</Property>
<Property name="PAYMAmt">
<Selectivity>1.0474%</Selectivity>
</Property>
<Property name="PAYMAuthorCode">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="PAYMBankSlipNo">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMBranch">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="PAYMCMBankDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="PAYMCTLOCDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMCancelComments">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="PAYMCancelReasonDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="PAYMCardChequeNo">
<Selectivity>24.9999%</Selectivity>
</Property>
<Property name="PAYMCardDR">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="PAYMCardExpiryDate">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="PAYMChangeAmount">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="PAYMChequeDate">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="PAYMChildsub">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="PAYMCloseShiftDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMCredCardPaymDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMCurrencyAmt">
<Selectivity>4.9983%</Selectivity>
</Property>
<Property name="PAYMCurrencyDR">
<Selectivity>33.3332%</Selectivity>
</Property>
<Property name="PAYMDate">
<Selectivity>2.6626%</Selectivity>
</Property>
<Property name="PAYMDrawer">
<Selectivity>1.9456%</Selectivity>
</Property>
<Property name="PAYMETPDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMGLBatchDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMGovernNo">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMInvDate">
<Selectivity>3.5589%</Selectivity>
</Property>
<Property name="PAYMInvLocDR">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="PAYMInvNotes">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMInvTime">
<Selectivity>2.2023%</Selectivity>
</Property>
<Property name="PAYMInvUser">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="PAYMInvalidFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PAYMParRef">
<Selectivity>0.0369%</Selectivity>
</Property>
<Property name="PAYMPayModeDR">
<Selectivity>16.6666%</Selectivity>
</Property>
<Property name="PAYMReconcile">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PAYMRefundComments">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="PAYMRefundNo">
<Selectivity>24.9999%</Selectivity>
</Property>
<Property name="PAYMRemarks">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="PAYMUnitDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<Property name="PAYMUpdateDate">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="PAYMUpdateTime">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="PAYMUpdateUserDR">
<Selectivity>99.9991%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PAYM_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PAYM_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PAYM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAYM_AuthorCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAYM_BankSlipNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAYM_Branch">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PAYM_CMBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAYM_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PAYM_CancelComments">
<Node>"CANC"</Node>
</Data>
<Data name="PAYM_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PAYM_CardChequeNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAYM_CardExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PAYM_Card_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAYM_ChangeAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAYM_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAYM_CredCardPaym_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PAYM_CurrencyAmt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAYM_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAYM_Date">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PAYM_Drawer">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PAYM_ETP_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PAYM_InsuFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PAYM_InvDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PAYM_InvLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PAYM_InvTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PAYM_InvUser">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PAYM_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAYM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAYM_Reconcile">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PAYM_RefundComments">
<Node>"RFC"</Node>
</Data>
<Data name="PAYM_RefundNo">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PAYM_Remarks">
<Node>"RMK"</Node>
</Data>
<Data name="PAYM_TransFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PAYM_Unit_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PAYM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PAYM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PAYM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Global>^ARRCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAYM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAYM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAYM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInvFlag">
<Condition>{PAYM_InvalidFlag}["Y"</Condition>
<ConditionFields>PAYM_InvDate,PAYM_InvalidFlag</ConditionFields>
<Global>^ARRCP</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PAYM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CANCEL_REC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAYM_InvDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAYM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdDate">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PAYM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAYMUpdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAYM_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAYM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAYM_RowId</SqlRowIdName>
<StreamLocation>^User.ARRcptPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
