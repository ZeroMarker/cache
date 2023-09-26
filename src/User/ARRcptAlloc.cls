/// AR Receipt Allocation   (ARRAL,404)
Class User.ARRcptAlloc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_RcptAlloc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ARRALChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref to ARRCP
Relationship ARRALARRCPParRef As ARReceipts [ Cardinality = parent, Inverse = ChildARRcptAlloc, Required, SqlFieldName = ARRAL_ARRCP_ParRef ];

/// ARRAL Child Subscript
Property ARRALChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^ARRCP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"RAL",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ARRAL_ChildSub ];

/// Des Ref to ARBIL (Not in Use)
Property ARRALBillDR As ARBill [ SqlColumnNumber = 3, SqlFieldName = ARRAL_Bill_DR ];

/// Payment Amount
Property ARRALPayAmt As %Float [ SqlColumnNumber = 4, SqlFieldName = ARRAL_PayAmt ];

/// Discount Amount
Property ARRALDiscAmt As %Float(MAXVAL = 9999999999, MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = ARRAL_DiscAmt ];

/// Discount Rate
Property ARRALDiscRate As %Float(MAXVAL = 100, MINVAL = 0) [ InitialExpression = 0.00, SqlColumnNumber = 6, SqlFieldName = ARRAL_DiscRate ];

/// Previous Balance
Property ARRALPrevBal As %Float [ SqlColumnNumber = 7, SqlFieldName = ARRAL_PrevBal ];

/// Des Ref to PAADM
Property ARRALAdmissionDR As PAAdm [ SqlColumnNumber = 9, SqlFieldName = ARRAL_Admission_DR ];

/// Archive Flag
Property ARRALRcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ARRAL_RcFlag ];

/// Transaction Code (Des Ref to ARCTC)(not in us
Property ARRALTransactDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ARRAL_Transact_DR ];

/// Doctor Fee Flag (Should Be a Yes/No)
Property ARRALDocFeeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = ARRAL_DocFeeFlag ];

/// GL Batch Number
Property ARRALGlBatchNo As %String(COLLATION = "AlphaUp", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = ARRAL_GlBatchNo ];

/// Allocation Code - Des Ref to ARCAC(not in use
Property ARRALAllocCodeDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ARRAL_AllocCode_DR ];

/// Deposit Type - des ref to ARCDT
Property ARRALDepositDR As ARCDepType [ SqlColumnNumber = 17, SqlFieldName = ARRAL_Deposit_DR ];

/// First Payment Flag
Property ARRAL1stPayFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = ARRAL_1stPayFlag ];

/// Des Ref PayMode
Property ARRALPayModeDR As CTPayMode [ SqlColumnNumber = 21, SqlFieldName = ARRAL_PayMode_DR ];

/// Des Ref to CMCBank
Property ARRALCMCBankDR As CMCBankMas [ SqlColumnNumber = 22, SqlFieldName = ARRAL_CMCBank_DR ];

/// Des Ref ARPBIL - Patient Bill
Property ARRALARPBILDR As User.DHCPatientBill [ SqlColumnNumber = 23, SqlFieldName = ARRAL_ARPBIL_DR ];

/// Round Amount
Property ARRALRoundAmt As %Float [ SqlColumnNumber = 24, SqlFieldName = ARRAL_RoundAmt ];

/// Des Ref to Refund ARRCA
Property ARRALARRCADR As ARRcptAlloc [ SqlColumnNumber = 25, SqlFieldName = ARRAL_ARRCA_DR ];

/// Update Date
Property ARRALUpdateDate As %Date [ SqlColumnNumber = 26, SqlFieldName = ARRAL_UpdateDate ];

/// Update Time
Property ARRALUpdateTime As %Time [ SqlColumnNumber = 27, SqlFieldName = ARRAL_UpdateTime ];

/// Des Ref Update User
Property ARRALUpdateUserDR As SSUser [ SqlColumnNumber = 28, SqlFieldName = ARRAL_UpdateUser_DR ];

/// Des Ref RefundReason
Property ARRALRefundReasonDR As BLCReasonForRefund [ SqlColumnNumber = 29, SqlFieldName = ARRAL_RefundReason_DR ];

/// Reason for Overpay
Property ARRALReasonOverpay As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = ARRAL_ReasonOverpay ];

/// Overpay Flag
Property ARRALOverpayFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = ARRAL_OverpayFlag ];

/// Recoup Flag
Property ARRALRecoupFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = ARRAL_RecoupFlag ];

/// RefundNo
Property ARRALRefundNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = ARRAL_RefundNo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARRcptAlloc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptAlloc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARRcptAlloc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptAlloc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARRcptAlloc).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptAlloc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARRcptAlloc).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptAlloc","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARRcptAlloc).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptAlloc","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARRcptAlloc","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>3232</ExtentSize>
<Property name="ARRAL1stPayFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARRALARPBILDR">
<Selectivity>0.6100%</Selectivity>
</Property>
<Property name="ARRALARRCADR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALARRCPParRef">
<Selectivity>0.0385%</Selectivity>
</Property>
<Property name="ARRALAdmissionDR">
<Selectivity>0.7386%</Selectivity>
</Property>
<Property name="ARRALAllocCodeDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALBillDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALCMCBankDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALChildSub">
<Selectivity>24.9999%</Selectivity>
</Property>
<Property name="ARRALDepositDR">
<Selectivity>24.9999%</Selectivity>
</Property>
<Property name="ARRALDiscAmt">
<Selectivity>5.8822%</Selectivity>
</Property>
<Property name="ARRALDiscRate">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARRALDocFeeFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARRALGlBatchNo">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALOverpayFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARRALPayAmt">
<Selectivity>1.4865%</Selectivity>
</Property>
<Property name="ARRALPayModeDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALPrevBal">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALRcFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARRALReasonOverpay">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALRecoupFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARRALRefundNo">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALRefundReasonDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALRoundAmt">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALTransactDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARRALUpdateDate">
<Selectivity>0.5205%</Selectivity>
</Property>
<Property name="ARRALUpdateTime">
<Selectivity>0.0932%</Selectivity>
</Property>
<Property name="ARRALUpdateUserDR">
<Selectivity>24.9999%</Selectivity>
</Property>
<SQLMap name="DataMasterARRAL">
<Data name="ARRAL_1stPayFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARRAL_ARPBIL_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ARRAL_ARRCA_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ARRAL_Admission_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARRAL_AllocCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARRAL_Bill_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARRAL_CMCBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARRAL_Deposit_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARRAL_DiscAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARRAL_DiscRate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARRAL_DocFeeFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARRAL_GlBatchNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARRAL_OverpayFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ARRAL_PayAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARRAL_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARRAL_PrevBal">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARRAL_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARRAL_ReasonOverpay">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ARRAL_RecoupFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ARRAL_RefundNo">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ARRAL_RefundReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ARRAL_RoundAmt">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ARRAL_Transact_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARRAL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ARRAL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ARRAL_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^ARRCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RAL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARRAL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARPBLDR">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ARPBL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARRAL_ARPBIL_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRAL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARRALAdmDR">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Adm_DR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARRAL_Admission_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARRAL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARRALBillDR">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Bill_DR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARRAL_Bill_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARRAL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARRCA">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARRCA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARRAL_ARRCA_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARRAL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayor">
<Condition>{ARRAL_ARPBIL_DR}=""</Condition>
<ConditionFields>ARRAL_ARPBIL_DR</ConditionFields>
<Global>^ARRCP</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Payor"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$instype^at404({AR_Receipts.ARRCP_RowId})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRAL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayorOffice">
<Condition>{ARRAL_ARPBIL_DR}=""</Condition>
<ConditionFields>ARRAL_ARPBIL_DR</ConditionFields>
<Global>^ARRCP</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PayorOffice"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$insassoc^at404({AR_Receipts.ARRCP_RowId})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRAL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdDate">
<Global>^ARRCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>AR_Receipts.ARRCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARRAL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RALUpdDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARRAL_UpdateDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Receipts.ARRCP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARRAL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARRAL_RowId</SqlRowIdName>
<StreamLocation>^User.ARRcptAllocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
