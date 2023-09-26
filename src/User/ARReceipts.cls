/// AR Receipts             (ARRCP,389)
Class User.ARReceipts Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_Receipts, StorageStrategy = SQLStorage ]
{

Relationship ChildARRcptAlloc As ARRcptAlloc [ Cardinality = children, Inverse = ARRALARRCPParRef ];

Relationship ChildARRcptPayMode As ARRcptPayMode [ Cardinality = children, Inverse = PAYMParRef ];

/// Des Ref to CTLOC (Rcp Department)
Property ARRCPLocationDR As CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = ARRCP_Location_DR ];

/// Receipt Number
Property ARRCPNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ARRCP_Number ];

/// Receipt Date
Property ARRCPDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 7, SqlFieldName = ARRCP_Date ];

/// Payment Amount
Property ARRCPPayAmount As %Float [ SqlColumnNumber = 8, SqlComputeCode = { s {ARRCP_PayAmount}=$$CO08^at389({ARRCP_RowId})
}, SqlComputed, SqlFieldName = ARRCP_PayAmount, Transient ];

/// Received Amount
Property ARRCPRecvAmt As %Float(MAXVAL = 9999999999, MINVAL = 00000000) [ SqlColumnNumber = 11, SqlFieldName = ARRCP_RecvAmt ];

/// Des Ref to CTPM
Property ARRCPPayModeDR As CTPayMode [ SqlColumnNumber = 12, SqlFieldName = ARRCP_PayMode_DR ];

/// Payer Name
Property ARRCPPayerName As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ARRCP_PayerName ];

/// Des Ref to ARCDR
Property ARRCPDebtorDR As ARCDebtor [ SqlColumnNumber = 14, SqlFieldName = ARRCP_Debtor_DR ];

/// Cheque Number
Property ARRCPChequeRef As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ARRCP_ChequeRef ];

/// Date of Cheque
Property ARRCPChequeDate As %Date [ SqlColumnNumber = 17, SqlFieldName = ARRCP_ChequeDate ];

/// Des Ref to ARCDR
Property ARRCPCardDrDR As ARCDebtor [ SqlColumnNumber = 18, SqlFieldName = ARRCP_CardDr_DR ];

/// Credit Card Number
Property ARRCPCrCardNo As %String(COLLATION = "AlphaUp", MAXLEN = 16, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = ARRCP_CrCardNo ];

/// Credit Card Expiry Date
Property ARRCPCrExpDate As %Date [ SqlColumnNumber = 20, SqlFieldName = ARRCP_CrExpDate ];

/// Des Ref to CMCBM
Property ARRCPDeposBankDR As CMCBankMas [ SqlColumnNumber = 21, SqlFieldName = ARRCP_DeposBank_DR ];

/// Commission Amount
Property ARRCPCommAmt As %Float(MAXVAL = 9999999999, MINVAL = 0) [ InitialExpression = 0.00, SqlColumnNumber = 23, SqlFieldName = ARRCP_CommAmt ];

/// Credit Card Authorisation Number
Property ARRCPCardAuth As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = ARRCP_CardAuth ];

/// Receipt Status (O - Cancelled Receipt)
Property ARRCPStatus As %String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = ARRCP_Status ];

/// Remarks
Property ARRCPRemarks As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = ARRCP_Remarks, SqlListType = SUBNODE ];

/// Financial Period - des ref to CTFP
Property ARRCPFinPerDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = ARRCP_FinPer_DR ];

/// Print Count
Property ARRCPPrintCount As %Float(MAXVAL = 9999, MINVAL = 0) [ InitialExpression = +0, SqlColumnNumber = 40, SqlFieldName = ARRCP_PrintCount ];

/// Archive Flag
Property ARRCPRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = ARRCP_RcFlag ];

/// Discount Amount
Property ARRCPDiscAmt As %Float [ InitialExpression = 0.00, SqlColumnNumber = 44, SqlFieldName = ARRCP_DiscAmt ];

/// Discount Rate
Property ARRCPDiscRate As %Float(MAXVAL = 100, MINVAL = 0) [ InitialExpression = 0.00, SqlColumnNumber = 45, SqlFieldName = ARRCP_DiscRate ];

/// Des Ref to ARCDI
Property ARRCPDiscountDR As ARCDiscType [ SqlColumnNumber = 46, SqlFieldName = ARRCP_Discount_DR ];

/// Unallocated Amount
Property ARRCPUnallocAmt As %Float [ InitialExpression = 0, SqlColumnNumber = 47, SqlFieldName = ARRCP_UnallocAmt ];

/// Location Receipt Number
Property ARRCPLocRcptNo As %String(COLLATION = "Exact", MAXLEN = 29, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = ARRCP_LocRcptNo ];

/// Add User ID
Property ARRCPAddUserID As SSUser [ InitialExpression = {$g(XCNF("USER",0))}, SqlColumnNumber = 49, SqlFieldName = ARRCP_AddUserID ];

/// Add Date
Property ARRCPAddDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 50, SqlFieldName = ARRCP_AddDate ];

/// Add Time
Property ARRCPAddTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 51, SqlFieldName = ARRCP_AddTime ];

/// Des Ref to PAPMI
Property ARRCPPAPMIDR As PAPatMas [ SqlColumnNumber = 52, SqlFieldName = ARRCP_PAPMI_DR ];

/// Des Ref InsType
Property ARRCPInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 53, SqlFieldName = ARRCP_InsType_DR ];

/// Des Ref GL Batch
Property ARRCPGLBatchDR As GLBatch [ SqlColumnNumber = 54, SqlFieldName = ARRCP_GLBatch_DR ];

/// Invalid Flag
Property ARRCPInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = ARRCP_InvalidFlag ];

/// Invalid Amt
Property ARRCPInvalidAmt As %Float [ SqlColumnNumber = 56, SqlFieldName = ARRCP_InvalidAmt ];

/// Invalid Date
Property ARRCPInvalidDate As %Date [ SqlColumnNumber = 57, SqlFieldName = ARRCP_InvalidDate ];

/// Invalid Time
Property ARRCPInvalidTime As %Time [ SqlColumnNumber = 58, SqlFieldName = ARRCP_InvalidTime ];

/// Des Ref User
Property ARRCPInvalidUserDR As SSUser [ SqlColumnNumber = 59, SqlFieldName = ARRCP_InvalidUser_DR ];

/// Des Ref CancelUser
Property ARRCPCancelUserDR As SSUser [ SqlColumnNumber = 60, SqlFieldName = ARRCP_CancelUser_DR ];

/// Des Ref CancelReceipt
Property ARRCPCancelReceiptDR As ARReceipts [ SqlColumnNumber = 61, SqlFieldName = ARRCP_CancelReceipt_DR ];

/// Des Ref WO Reason
Property ARRCPCancelReasonDR As ARCReasonWriteOff [ SqlColumnNumber = 62, SqlFieldName = ARRCP_CancelReason_DR ];

/// Des Ref AcctClsAuxInsType
Property ARRCPAcctClsAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 63, SqlFieldName = ARRCP_AcctClsAuxInsType_DR ];

/// Expected Payment Date
Property ARRCPExpPayDate As %Date [ SqlColumnNumber = 64, SqlFieldName = ARRCP_ExpPayDate ];

/// Des Ref CTLOC
Property ARRCPAddLocationDR As CTLoc [ SqlColumnNumber = 65, SqlFieldName = ARRCP_AddLocation_DR ];

/// Des Ref CTLOC
Property ARRCPInvLocationDR As CTLoc [ SqlColumnNumber = 66, SqlFieldName = ARRCP_InvLocation_DR ];

/// Included In Bank Run
Property ARRCPIncludedInBankRun As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 67, SqlFieldName = ARRCP_IncludedInBankRun ];

/// Refund Date
Property ARRCPRefundDate As %Date [ SqlColumnNumber = 68, SqlFieldName = ARRCP_RefundDate ];

/// Refund Time
Property ARRCPRefundTime As %Time [ SqlColumnNumber = 69, SqlFieldName = ARRCP_RefundTime ];

/// Des Ref RefundUser
Property ARRCPRefundUserDR As SSUser [ SqlColumnNumber = 70, SqlFieldName = ARRCP_RefundUser_DR ];

/// Des Ref RefundLocation
Property ARRCPRefundLocationDR As CTLoc [ SqlColumnNumber = 71, SqlFieldName = ARRCP_RefundLocation_DR ];

/// Refund Comments
Property ARRCPRefundComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 72, SqlFieldName = ARRCP_RefundComments, SqlListType = SUBNODE ];

/// Cancel Comments
Property ARRCPCancelComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 73, SqlFieldName = ARRCP_CancelComments, SqlListType = SUBNODE ];

/// Des Ref InsAssoc
Property ARRCPInsAssocDR As ARCInsurAssociation [ SqlColumnNumber = 74, SqlFieldName = ARRCP_InsAssoc_DR ];

/// Over Payment Flag
Property ARRCPOverPaymentFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = ARRCP_OverPaymentFlag ];

/// Des Ref Receipt Refunded
Property ARRCPRefundReceiptDR As ARReceipts [ SqlColumnNumber = 76, SqlFieldName = ARRCP_RefundReceipt_DR ];

/// Des Ref AccountingPeriod
Property ARRCPAccountingPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 77, SqlFieldName = ARRCP_AccountingPeriod_DR ];

/// Batch No
Property ARRCPBatchNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 78, SqlFieldName = ARRCP_BatchNo ];

/// Des Ref SundryDebtor
Property ARRCPSundryDebtorDR As ARCSundryDebtor [ SqlColumnNumber = 79, SqlFieldName = ARRCP_SundryDebtor_DR ];

/// Des Ref CloseShift
Property ARRCPCloseShiftDR As ARCloseShift [ SqlColumnNumber = 80, SqlFieldName = ARRCP_CloseShift_DR ];

/// Des Ref CancelAccountingPeriod
Property ARRCPCancelAccountingPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 81, SqlFieldName = ARRCP_CancelAccountingPeriod_DR ];

/// OriginalPayAmount
Property ARRCPOriginalPayAmount As %Float [ SqlColumnNumber = 82, SqlFieldName = ARRCP_OriginalPayAmount ];

/// Des Ref RefundReason
Property ARRCPRefundReasonDR As BLCReasonForRefund [ SqlColumnNumber = 83, SqlFieldName = ARRCP_RefundReason_DR ];

/// Des Ref Hospital
Property ARRCPHospitalDR As CTHospital [ SqlColumnNumber = 84, SqlFieldName = ARRCP_Hospital_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARReceipts).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARReceipts","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARReceipts).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARReceipts","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARReceipts).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARReceipts","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARReceipts).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARReceipts","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARReceipts","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARReceipts).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARReceipts","OnAfterDelete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SqlIdExpression>$i(^ARRCP(0))</SqlIdExpression>
<SQLMap name="DataMasterARRCP">
<Data name="ARRCP_AccountingPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="ARRCP_AcctClsAuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ARRCP_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ARRCP_AddLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ARRCP_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ARRCP_AddUserID">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ARRCP_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="ARRCP_CancelAccountingPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="ARRCP_CancelComments">
<Node>"CANC"</Node>
</Data>
<Data name="ARRCP_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ARRCP_CancelReceipt_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ARRCP_CancelUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ARRCP_CardAuth">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ARRCP_CardDr_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARRCP_ChequeDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARRCP_ChequeRef">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARRCP_CloseShift_DR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="ARRCP_CommAmt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARRCP_CrCardNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARRCP_CrExpDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARRCP_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARRCP_Debtor_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARRCP_DeposBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARRCP_DiscAmt">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARRCP_DiscRate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARRCP_Discount_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ARRCP_ExpPayDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ARRCP_FinPer_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ARRCP_GLBatch_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ARRCP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="ARRCP_IncludedInBankRun">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ARRCP_InsAssoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ARRCP_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ARRCP_InvLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ARRCP_InvalidAmt">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ARRCP_InvalidDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ARRCP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ARRCP_InvalidTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ARRCP_InvalidUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ARRCP_LocRcptNo">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ARRCP_Location_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARRCP_Number">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARRCP_OriginalPayAmount">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="ARRCP_OverPaymentFlag">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ARRCP_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ARRCP_PayAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARRCP_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ARRCP_PayerName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARRCP_PrintCount">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ARRCP_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ARRCP_RecvAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARRCP_RefundComments">
<Node>"RFC"</Node>
</Data>
<Data name="ARRCP_RefundDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ARRCP_RefundLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ARRCP_RefundReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="ARRCP_RefundReceipt_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ARRCP_RefundTime">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ARRCP_RefundUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ARRCP_Remarks">
<Node>"RMK"</Node>
</Data>
<Data name="ARRCP_Status">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ARRCP_SundryDebtor_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="ARRCP_UnallocAmt">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^ARRCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARRCP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAcctPeriod">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AcctPeriod"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_AccountingPeriod_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBatch">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Batch"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_BatchNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBatchPost">
<Condition>{ARRCP_BatchNo}=""</Condition>
<ConditionFields>ARRCP_BatchNo,ARRCP_Date</ConditionFields>
<Global>^ARRCP</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BatchPost"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCancRec">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CancRec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_CancelReceipt_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCancelAcctPeriod">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CancAcctPer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_CancelAccountingPeriod_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCloseShift">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CloseShift"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_CloseShift_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDebtor">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARRCP_Debtor_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARRCP_Debtor_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGLBatch">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GLBatch"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_GLBatch_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvDate">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_InvalidDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocRcptNo">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LocRcptNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARRCP_LocRcptNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocationDR">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARRCP_Location_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotGLPosted">
<Condition>{ARRCP_GLBatch_DR}=""</Condition>
<ConditionFields>ARRCP_Date,ARRCP_GLBatch_DR</ConditionFields>
<Global>^ARRCP</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GLPost"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Number"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ARRCP_Number})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOverpay">
<Condition>{ARRCP_OverPaymentFlag}["Y"</Condition>
<ConditionFields>ARRCP_Date,ARRCP_InsAssoc_DR,ARRCP_OverPaymentFlag</ConditionFields>
<Global>^ARRCP</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OverpayRcp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{ARRCP_InsAssoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOverpayPayor">
<Condition>{ARRCP_OverPaymentFlag}["Y"</Condition>
<ConditionFields>ARRCP_Date,ARRCP_InsType_DR,ARRCP_OverPaymentFlag</ConditionFields>
<Global>^ARRCP</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OverpayPayor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_InsType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayorDate">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_InsType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRefReceipt">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RefRec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_RefundReceipt_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSunDeb">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SunDeb"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_SundryDebtor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnallocAmt">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UnallocAmt"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARRCP_UnallocAmt}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexrefundRcp">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARRCP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RefundRcp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRCP_RefundDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRCP_InsAssoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARRCP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARRCP_RowId</SqlRowIdName>
<StreamLocation>^User.ARReceiptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
