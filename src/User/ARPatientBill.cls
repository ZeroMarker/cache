/// AR Patient Bill(1256)
Class User.ARPatientBill Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatientBill, StorageStrategy = SQLStorage ]
{

Relationship ChildARPatBillGroup As ARPatBillGroup [ Cardinality = children, Inverse = BGRPParRef ];

Relationship ChildARPatBillDate As ARPatBillDate [ Cardinality = children, Inverse = DATEParRef ];

Relationship ChildARPatBillServTax As ARPatBillServTax [ Cardinality = children, Inverse = STParRef ];

Relationship ChildARPatBillOutstand As ARPatBillOutstand [ Cardinality = children, Inverse = OUTSParRef ];

Relationship ChildARPatBillDiscount As ARPatBillDiscount [ Cardinality = children, Inverse = DISCParRef ];

Relationship ChildARPatBillDiscAlloc As ARPatBillDiscAlloc [ Cardinality = children, Inverse = DSALParRef ];

Relationship ChildARPatBillPaymAlloc As ARPatBillPaymAlloc [ Cardinality = children, Inverse = PAYMParREf ];

Relationship ChildARPatBillWriteOff As ARPatBillWriteOff [ Cardinality = children, Inverse = WOParRef ];

Relationship ChildARPatBillClaim As ARPatBillClaim [ Cardinality = children, Inverse = CLParRef ];

/// Des Ref Version
Property ARPBLVersionDR As RVIInsCompanyBill [ SqlColumnNumber = 2, SqlFieldName = ARPBL_Version_DR ];

/// Date From
Property ARPBLDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = ARPBL_DateFrom ];

/// Date To
Property ARPBLDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = ARPBL_DateTo ];

/// Discret Amt
Property ARPBLDiscretAmt As %Float [ SqlColumnNumber = 5, SqlFieldName = ARPBL_DiscretAmt ];

/// Des Ref Discret DiscType
Property ARPBLDiscTypeDR As ARCDiscretDiscType [ SqlColumnNumber = 6, SqlFieldName = ARPBL_DiscType_DR ];

/// Outstanding Amt
Property ARPBLOutstandAmt As %Float [ SqlColumnNumber = 7, SqlFieldName = ARPBL_OutstandAmt ];

/// Des Ref DiscretOutstType
Property ARPBLDiscretOutstTypeDR As ARCDisretOutstType [ SqlColumnNumber = 8, SqlFieldName = ARPBL_DiscretOutstType_DR ];

/// Des Ref PAADM
Property ARPBLPAADMDR As PAAdm [ SqlColumnNumber = 9, SqlFieldName = ARPBL_PAADM_DR ];

/// Bill No
Property ARPBLBillNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ARPBL_BillNo ];

/// Total Specialist
Property ARPBLTotalSpecialist As %Float [ SqlColumnNumber = 11, SqlFieldName = ARPBL_TotalSpecialist ];

/// Total Patient
Property ARPBLTotalPatient As %Float [ SqlColumnNumber = 12, SqlFieldName = ARPBL_TotalPatient ];

/// Total InsCo
Property ARPBLTotalInsCo As %Float [ SqlColumnNumber = 13, SqlFieldName = ARPBL_TotalInsCo ];

/// Total Material Allowed
Property ARPBLTotalMaterialAllowed As %Float [ SqlColumnNumber = 14, SqlFieldName = ARPBL_TotalMaterialAllowed ];

/// Total Material Disallow
Property ARPBLTotalMaterialDisallow As %Float [ SqlColumnNumber = 15, SqlFieldName = ARPBL_TotalMaterialDisallow ];

/// Payed Flag
Property ARPBLPayedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = ARPBL_PayedFlag ];

/// Total Disallowed
Property ARPBLTotalDisallowed As %Float [ SqlColumnNumber = 17, SqlFieldName = ARPBL_TotalDisallowed ];

/// Total Allowed
Property ARPBLTotalAllowed As %Float [ SqlColumnNumber = 18, SqlFieldName = ARPBL_TotalAllowed ];

/// Total Employee Discount
Property ARPBLTotalEmployeeDisc As %Float [ SqlColumnNumber = 19, SqlFieldName = ARPBL_TotalEmployeeDisc ];

/// Des Ref EmployeeDisc
Property ARPBLEmployeeDiscDR As ARCDiscType [ SqlColumnNumber = 20, SqlFieldName = ARPBL_EmployeeDisc_DR ];

/// Total Patient Of Allowed
Property ARPBLTotalPatientOfAllowed As %Float [ SqlColumnNumber = 21, SqlFieldName = ARPBL_TotalPatientOfAllowed ];

/// Total Blood Discount
Property ARPBLTotalBloodDisc As %Float [ SqlColumnNumber = 22, SqlFieldName = ARPBL_TotalBloodDisc ];

/// Blood Coupons 320
Property ARPBLBloodCoupons320 As %Float [ SqlColumnNumber = 23, SqlFieldName = ARPBL_BloodCoupons320 ];

/// Blood Coupons 400
Property ARPBLBloodCoupons400 As %Float [ SqlColumnNumber = 24, SqlFieldName = ARPBL_BloodCoupons400 ];

/// Insurance Type DR
Property ARPBLInsuranceTypeDR As ARCInsuranceType [ SqlColumnNumber = 25, SqlFieldName = ARPBL_InsuranceType_DR ];

/// Bill Type
Property ARPBLBillType As %String(DISPLAYLIST = ",Interim In Patient Bill,Final In Patient Bill,Out Patient Bill", MAXLEN = 23, TRUNCATE = 1, VALUELIST = ",I,F,O") [ SqlColumnNumber = 26, SqlFieldName = ARPBL_BillType ];

/// Des Ref Hospital
Property ARPBLHospitalDR As CTHospital [ SqlColumnNumber = 27, SqlFieldName = ARPBL_Hospital_DR ];

/// Total Service Allowed
Property ARPBLTotalServiceAllowed As %Float [ SqlColumnNumber = 28, SqlFieldName = ARPBL_TotalServiceAllowed ];

/// Total Pat Service Allowed
Property ARPBLTotalPatServiceAllowed As %Float [ SqlColumnNumber = 29, SqlFieldName = ARPBL_TotalPatServiceAllowed ];

/// Total Material AD
Property ARPBLTotalMaterialAD As %Float [ SqlColumnNumber = 30, SqlFieldName = ARPBL_TotalMaterialAD ];

/// Total Material Unauthorised
Property ARPBLTotalMaterialUnauthor As %Float [ SqlColumnNumber = 31, SqlFieldName = ARPBL_TotalMaterialUnauthor ];

/// Total Service AD
Property ARPBLTotalServiceAD As %Float [ SqlColumnNumber = 32, SqlFieldName = ARPBL_TotalServiceAD ];

/// Total Service Unauthorised
Property ARPBLTotalServiceUnauthor As %Float [ SqlColumnNumber = 33, SqlFieldName = ARPBL_TotalServiceUnauthor ];

/// Insurance Uplift
Property ARPBLInsuranceUplift As %Float [ SqlColumnNumber = 34, SqlFieldName = ARPBL_InsuranceUplift ];

/// Patient Uplift
Property ARPBLPatientUplift As %Float [ SqlColumnNumber = 35, SqlFieldName = ARPBL_PatientUplift ];

/// Des Ref AuxInsType
Property ARPBLAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 36, SqlFieldName = ARPBL_AuxInsType_DR ];

/// Des REf ARPBL Original_Bill_DR
Property ARPBLOriginalBillDR As ARPatientBill [ SqlColumnNumber = 37, SqlFieldName = ARPBL_Original_Bill_DR ];

/// Des Ref ARPBL_RefundBill_DR
Property ARPBLRefundBillDR As ARPatientBill [ SqlColumnNumber = 38, SqlFieldName = ARPBL_RefundBill_DR ];

/// Empl Name Outstanding
Property ARPBLEmplNameOuts As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = ARPBL_EmplNameOuts ];

/// Department Outstanding
Property ARPBLDepartOuts As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = ARPBL_DepartOuts ];

/// Comments Outstand
Property ARPBLCommentOuts As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = ARPBL_CommentOuts ];

/// Empl Name Discount
Property ARPBLEmplNameDisc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = ARPBL_EmplNameDisc ];

/// Department Discount
Property ARPBLDepartDisc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = ARPBL_DepartDisc ];

/// Comment Discount
Property ARPBLCommentDiscount As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = ARPBL_CommentDiscount ];

/// Des Ref ReasonForRefund
Property ARPBLReasonForRefundDR As BLCReasonForRefund [ SqlColumnNumber = 45, SqlFieldName = ARPBL_ReasonForRefund_DR ];

/// Billing Type
Property ARPBLBillingType As %String(DISPLAYLIST = ",InPatient,OutPatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 46, SqlFieldName = ARPBL_BillingType ];

/// UpdateDate
Property ARPBLUpdateDate As %Date [ SqlColumnNumber = 47, SqlFieldName = ARPBL_UpdateDate ];

/// Update Time
Property ARPBLUpdateTime As %Time [ SqlColumnNumber = 48, SqlFieldName = ARPBL_UpdateTime ];

/// Payor Type
Property ARPBLPayorType As %String(DISPLAYLIST = ",Patient,Insurance,OTC,Manual", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",P,I,O,M") [ SqlColumnNumber = 49, SqlFieldName = ARPBL_PayorType ];

/// Des Ref InsAssociation
Property ARPBLInsAssociationDR As ARCInsurAssociation [ SqlColumnNumber = 50, SqlFieldName = ARPBL_InsAssociation_DR ];

/// Date Bill Printed
Property ARPBLDatePrinted As %Date [ SqlColumnNumber = 51, SqlFieldName = ARPBL_DatePrinted ];

/// Bill/Refund
Property ARPBLBillRefund As %String(DISPLAYLIST = ",Bill,Refund", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",B,R") [ SqlColumnNumber = 52, SqlFieldName = ARPBL_BillRefund ];

/// Des Ref Batch
Property ARPBLBatchDR As ARBatch [ SqlColumnNumber = 53, SqlFieldName = ARPBL_Batch_DR ];

/// UnSettled
Property ARPBLUnSettled As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = ARPBL_UnSettled ];

/// Flag 1
Property ARPBLFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = ARPBL_Flag1 ];

/// Des Ref Currency
Property ARPBLCurrencyDR As CTCurrency [ SqlColumnNumber = 56, SqlFieldName = ARPBL_Currency_DR ];

/// Invoiced Flag
Property ARPBLInvoicedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = ARPBL_InvoicedFlag ];

/// Batch Process
Property ARPBLBatchProcess As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 58, SqlFieldName = ARPBL_BatchProcess ];

/// Amount Payor Paid
Property ARPBLAmountPayorPaid As %Float [ SqlColumnNumber = 59, SqlFieldName = ARPBL_AmountPayorPaid ];

/// Write Off Amount
Property ARPBLWriteOffAmount As %Float [ SqlColumnNumber = 60, SqlFieldName = ARPBL_WriteOffAmount ];

/// Des Ref User
Property ARPBLUpdateUserDR As SSUser [ SqlColumnNumber = 61, SqlFieldName = ARPBL_UpdateUser_DR ];

/// Des Ref ARPBL
Property ARPBLFullCancelBillDR As ARPatientBill [ SqlColumnNumber = 62, SqlFieldName = ARPBL_FullCancelBill_DR ];

/// AmountToPay
Property ARPBLAmountToPay As %Float [ SqlColumnNumber = 63, SqlComputeCode = { s {ARPBL_AmountToPay}=$$CO63^CCalculateBill({ARPBL_RowId})
}, SqlComputed, SqlFieldName = ARPBL_AmountToPay, Transient ];

/// Des Ref GLBatch
Property ARPBLGLBatchDR As GLBatch [ SqlColumnNumber = 64, SqlFieldName = ARPBL_GLBatch_DR ];

/// Notes
Property ARPBLNotes As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 65, SqlFieldName = ARPBL_Notes, SqlListType = SUBNODE ];

/// Adm Date
Property ARPBLAdmDate As %Date [ SqlColumnNumber = 66, SqlFieldName = ARPBL_AdmDate ];

/// DischDate
Property ARPBLDischDate As %Date [ SqlColumnNumber = 67, SqlFieldName = ARPBL_DischDate ];

/// Des Ref ReasonWriteOff
Property ARPBLReasonWriteOffDR As ARCReasonWriteOff [ SqlColumnNumber = 68, SqlFieldName = ARPBL_ReasonWriteOff_DR ];

/// Discount Percentage
Property ARPBLDiscPerc As %Float [ SqlColumnNumber = 69, SqlFieldName = ARPBL_DiscPerc ];

/// Des Ref GL Write off Batch
Property ARPBLGLWOBatchDR As GLBatch [ SqlColumnNumber = 70, SqlFieldName = ARPBL_GLWOBatch_DR ];

/// Amount To Pay1
Property ARPBLAmountToPay1 As %Float [ SqlColumnNumber = 71, SqlFieldName = ARPBL_AmountToPay1 ];

/// Des Ref UserPrinted
Property ARPBLUserPrintedDR As SSUser [ SqlColumnNumber = 72, SqlFieldName = ARPBL_UserPrinted_DR ];

/// Des Ref CTLOC
Property ARPBLCTLOCPrintedDR As CTLoc [ SqlColumnNumber = 73, SqlFieldName = ARPBL_CTLOCPrinted_DR ];

/// Des Ref User
Property ARPBLUserCancelBillDR As SSUser [ SqlColumnNumber = 74, SqlFieldName = ARPBL_UserCancelBill_DR ];

/// Bill DateFrom
Property ARPBLBillDateFrom As %Date [ SqlColumnNumber = 75, SqlFieldName = ARPBL_BillDateFrom ];

/// Bill Date To
Property ARPBLBillDateTo As %Date [ SqlColumnNumber = 76, SqlFieldName = ARPBL_BillDateTo ];

/// DateCancelled
Property ARPBLDateCancelled As %Date [ SqlColumnNumber = 77, SqlFieldName = ARPBL_DateCancelled ];

/// Time Cancelled
Property ARPBLTimeCancelled As %Time [ SqlColumnNumber = 78, SqlFieldName = ARPBL_TimeCancelled ];

/// Des Ref AccountingPeriod
Property ARPBLAccountingPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 79, SqlFieldName = ARPBL_AccountingPeriod_DR ];

/// Des Ref InsType1
Property ARPBLInsType1DR As ARCInsuranceType [ SqlColumnNumber = 80, SqlFieldName = ARPBL_InsType1_DR ];

/// Des Ref AuxInstype1
Property ARPBLAuxInstype1DR As ARCAuxilInsurType [ SqlColumnNumber = 81, SqlFieldName = ARPBL_AuxInstype1_DR ];

/// FollowUpIdentifier
Property ARPBLFollowUpIdentifier As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 82, SqlFieldName = ARPBL_FollowUpIdentifier ];

/// Des Ref SundryDebtor
Property ARPBLSundryDebtorDR As ARCSundryDebtor [ SqlColumnNumber = 83, SqlFieldName = ARPBL_SundryDebtor_DR ];

/// Des Ref OEORD
Property ARPBLOEORDDR As OEOrder [ SqlColumnNumber = 84, SqlFieldName = ARPBL_OEORD_DR ];

/// Des Ref AccrualAccountPeriod
Property ARPBLAccrualAccountPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 85, SqlFieldName = ARPBL_AccrualAccountPeriod_DR ];

/// Des Ref CancelHospital
Property ARPBLCancelHospitalDR As CTHospital [ SqlColumnNumber = 86, SqlFieldName = ARPBL_CancelHospital_DR ];

/// CancelComments
Property ARPBLCancelComments As list Of %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 87, SqlFieldName = ARPBL_CancelComments, SqlListType = SUBNODE ];

/// Des Ref ReasonCancel
Property ARPBLReasonCancelDR As BLCReasonForCancelInv [ SqlColumnNumber = 88, SqlFieldName = ARPBL_ReasonCancel_DR ];

/// EDISentDate
Property ARPBLEDISentDate As %Date [ SqlColumnNumber = 89, SqlFieldName = ARPBL_EDISentDate ];

/// Des Ref RoyalOrder
Property ARPBLRoyalOrderDR As PAPersonRoyalOrder [ SqlColumnNumber = 90, SqlFieldName = ARPBL_RoyalOrder_DR ];

/// TimePrinted
Property ARPBLTimePrinted As %Time [ SqlColumnNumber = 91, SqlFieldName = ARPBL_TimePrinted ];

/// Des Ref PatientBill
Property ARPBLPatientBillDR As ARPatientBill [ SqlColumnNumber = 92, SqlFieldName = ARPBL_PatientBill_DR ];

/// Remaining Discount
Property ARPBLRemainingDiscount As %Float [ SqlColumnNumber = 93, SqlFieldName = ARPBL_RemainingDiscount ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatientBill).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatientBill","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatientBill).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatientBill","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatientBill).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatientBill","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatientBill).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatientBill","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatientBill).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatientBill","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatientBill","OnBeforeInsert")
 d VALINS^at1256
}

Storage SQLStorage
{
<ExtentSize>3465</ExtentSize>
<Property name="ARPBLAccountingPeriodDR">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="ARPBLAccrualAccountPeriodDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="ARPBLAdmDate">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="ARPBLAmountPayorPaid">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLAmountToPay">
<Selectivity>1.0576%</Selectivity>
</Property>
<Property name="ARPBLAmountToPay1">
<Selectivity>8.3333%</Selectivity>
</Property>
<Property name="ARPBLAuxInsTypeDR">
<Selectivity>5.2628%</Selectivity>
</Property>
<Property name="ARPBLAuxInstype1DR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLBatchDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLBatchProcess">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLBillDateFrom">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLBillDateTo">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLBillNo">
<Selectivity>1.7346%</Selectivity>
</Property>
<Property name="ARPBLBillRefund">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLBillType">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ARPBLBillingType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLBloodCoupons320">
<Selectivity>1.0986%</Selectivity>
</Property>
<Property name="ARPBLBloodCoupons400">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLCTLOCPrintedDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLCancelComments">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLCancelHospitalDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLCommentDiscount">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLCommentOuts">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLCurrencyDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLDateCancelled">
<Selectivity>7.1428%</Selectivity>
</Property>
<Property name="ARPBLDateFrom">
<Selectivity>0.3082%</Selectivity>
</Property>
<Property name="ARPBLDatePrinted">
<Selectivity>1.8929%</Selectivity>
</Property>
<Property name="ARPBLDateTo">
<Selectivity>0.2810%</Selectivity>
</Property>
<Property name="ARPBLDepartDisc">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLDepartOuts">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLDiscPerc">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLDiscTypeDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLDischDate">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ARPBLDiscretAmt">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLDiscretOutstTypeDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLEDISentDate">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLEmplNameDisc">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLEmplNameOuts">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLEmployeeDiscDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLFlag1">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLFollowUpIdentifier">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLFullCancelBillDR">
<Selectivity>4.9994%</Selectivity>
</Property>
<Property name="ARPBLGLBatchDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLGLWOBatchDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLHospitalDR">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="ARPBLInsAssociationDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLInsType1DR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLInsuranceTypeDR">
<Selectivity>6.2499%</Selectivity>
</Property>
<Property name="ARPBLInsuranceUplift">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLInvoicedFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLNotes">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLOEORDDR">
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="ARPBLOriginalBillDR">
<Selectivity>4.3461%</Selectivity>
</Property>
<Property name="ARPBLOutstandAmt">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLPAADMDR">
<Selectivity>0.1568%</Selectivity>
</Property>
<Property name="ARPBLPatientBillDR">
<Selectivity>6.2499%</Selectivity>
</Property>
<Property name="ARPBLPatientUplift">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLPayedFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLPayorType">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ARPBLReasonCancelDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLReasonForRefundDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLReasonWriteOffDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLRefundBillDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLRemainingDiscount">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLRoyalOrderDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLSundryDebtorDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ARPBLTimeCancelled">
<Selectivity>7.1428%</Selectivity>
</Property>
<Property name="ARPBLTimePrinted">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalAllowed">
<Selectivity>0.7633%</Selectivity>
</Property>
<Property name="ARPBLTotalBloodDisc">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalDisallowed">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalEmployeeDisc">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalInsCo">
<Selectivity>1.6283%</Selectivity>
</Property>
<Property name="ARPBLTotalMaterialAD">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalMaterialAllowed">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalMaterialDisallow">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalMaterialUnauthor">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalPatServiceAllowed">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalPatient">
<Selectivity>2.0266%</Selectivity>
</Property>
<Property name="ARPBLTotalPatientOfAllowed">
<Selectivity>2.0266%</Selectivity>
</Property>
<Property name="ARPBLTotalServiceAD">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalServiceAllowed">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalServiceUnauthor">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLTotalSpecialist">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLUnSettled">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLUpdateDate">
<Selectivity>0.3175%</Selectivity>
</Property>
<Property name="ARPBLUpdateTime">
<Selectivity>0.0289%</Selectivity>
</Property>
<Property name="ARPBLUpdateUserDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ARPBLUserCancelBillDR">
<Selectivity>49.9999%</Selectivity>
</Property>
<Property name="ARPBLUserPrintedDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLVersionDR">
<Selectivity>99.9995%</Selectivity>
</Property>
<Property name="ARPBLWriteOffAmount">
<Selectivity>20.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARPBL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ARPBL_AccountingPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="ARPBL_AccrualAccountPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="ARPBL_AdmDate">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="ARPBL_AmountPayorPaid">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="ARPBL_AmountToPay1">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="ARPBL_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ARPBL_AuxInstype1_DR">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="ARPBL_BatchProcess">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="ARPBL_Batch_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="ARPBL_BillDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="ARPBL_BillDateTo">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="ARPBL_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ARPBL_BillRefund">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="ARPBL_BillType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ARPBL_BillingType">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="ARPBL_BloodCoupons320">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ARPBL_BloodCoupons400">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ARPBL_CTLOCPrinted_DR">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="ARPBL_CancelComments">
<Node>"CANCREM"</Node>
</Data>
<Data name="ARPBL_CancelHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="ARPBL_CommentDiscount">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="ARPBL_CommentOuts">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="ARPBL_Currency_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="ARPBL_DateCancelled">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="ARPBL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARPBL_DatePrinted">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="ARPBL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARPBL_DepartDisc">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="ARPBL_DepartOuts">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="ARPBL_DiscPerc">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="ARPBL_DiscType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARPBL_DischDate">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="ARPBL_DiscretAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARPBL_DiscretOutstType_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ARPBL_EDISentDate">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="ARPBL_EmplNameDisc">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="ARPBL_EmplNameOuts">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="ARPBL_EmployeeDisc_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ARPBL_Flag1">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="ARPBL_FollowUpIdentifier">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="ARPBL_FullCancelBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="ARPBL_GLBatch_DR">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="ARPBL_GLWOBatch_DR">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="ARPBL_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ARPBL_InsAssociation_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="ARPBL_InsType1_DR">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="ARPBL_InsuranceType_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ARPBL_InsuranceUplift">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ARPBL_InvoicedFlag">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="ARPBL_Notes">
<Node>"REM"</Node>
</Data>
<Data name="ARPBL_OEORD_DR">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="ARPBL_Original_Bill_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ARPBL_OutstandAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ARPBL_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ARPBL_PatientBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="ARPBL_PatientUplift">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ARPBL_PayedFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ARPBL_PayorType">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="ARPBL_ReasonCancel_DR">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="ARPBL_ReasonForRefund_DR">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="ARPBL_ReasonWriteOff_DR">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="ARPBL_RefundBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ARPBL_RemainingDiscount">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="ARPBL_RoyalOrder_DR">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="ARPBL_SundryDebtor_DR">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="ARPBL_TimeCancelled">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="ARPBL_TimePrinted">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="ARPBL_TotalAllowed">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ARPBL_TotalBloodDisc">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ARPBL_TotalDisallowed">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ARPBL_TotalEmployeeDisc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ARPBL_TotalInsCo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ARPBL_TotalMaterialAD">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ARPBL_TotalMaterialAllowed">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ARPBL_TotalMaterialDisallow">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ARPBL_TotalMaterialUnauthor">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ARPBL_TotalPatServiceAllowed">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ARPBL_TotalPatient">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ARPBL_TotalPatientOfAllowed">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ARPBL_TotalServiceAD">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ARPBL_TotalServiceAllowed">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ARPBL_TotalServiceUnauthor">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ARPBL_TotalSpecialist">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ARPBL_UnSettled">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="ARPBL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="ARPBL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="ARPBL_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="ARPBL_UserCancelBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="ARPBL_UserPrinted_DR">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="ARPBL_Version_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARPBL_WriteOffAmount">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARPBL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAssoc">
<Condition>{ARPBL_BillNo}'="",{ARPBL_UnSettled}'["N"</Condition>
<ConditionFields>ARPBL_DischDate,ARPBL_InsAssociation_DR,ARPBL_UnSettled,ARPBL_BillNo</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SOA_PAYOR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_InsAssociation_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_DischDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBatch">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Batch"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_Batch_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCancelBill">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CancBill"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_FullCancelBill_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateFrom">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateFrom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_DateFrom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDatePrinted">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DatePrint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_DatePrinted}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTo">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_DateTo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDischDate">
<Condition>{ARPBL_BillNo}'="",{ARPBL_UnSettled}'["N"</Condition>
<ConditionFields>ARPBL_BillNo,ARPBL_DischDate,ARPBL_BillRefund,ARPBL_UnSettled</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SOA_CASH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_DischDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGLBatch">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GLBatch"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_GLBatch_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGLWONotPosted">
<Condition>'{ARPBL_GLWOBatch_DR},{ARPBL_WriteOffAmount}</Condition>
<ConditionFields>ARPBL_UpdateDate,ARPBL_GLWOBatch_DR,ARPBL_WriteOffAmount</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GLWOPost"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIns1TypeDate">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsType1Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_InsType1_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsAdmDate">
<Condition>1</Condition>
<Global>^ARPBL</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsAdmDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_AdmDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotGLPosted">
<Condition>$$post^at1256({ARPBL_GLBatch_DR},{ARPBL_UpdateDate},{ARPBL_InvoicedFlag},{ARPBL_PayedFlag})=1</Condition>
<ConditionFields>ARPBL_GLBatch_DR,ARPBL_UpdateDate,ARPBL_InvoicedFlag,ARPBL_PayedFlag</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GLPost"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotPrinted">
<Condition>'{ARPBL_DatePrinted},{ARPBL_BillRefund}["B"</Condition>
<ConditionFields>ARPBL_DatePrinted,ARPBL_BillRefund,ARPBL_DateFrom</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotPrinted"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_DateFrom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ARPBL_BillNo})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORD">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_OEORD_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutstand">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OUTS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_DiscretOutstType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadm">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatbill">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatBill"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_PatientBill_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayorDate">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsTypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayorUnsettle">
<Condition>{ARPBL_BillRefund}["B",{ARPBL_UnSettled}'["N",{ARPBL_PayorType}["I"</Condition>
<ConditionFields>ARPBL_BillRefund,ARPBL_UnSettled,ARPBL_InsuranceType_DR,ARPBL_PayorType</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Unset"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_InsuranceType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRefNotPrinted">
<Condition>{ARPBL_BillRefund}["R",'{ARPBL_DatePrinted}</Condition>
<ConditionFields>ARPBL_BillRefund,ARPBL_DateFrom,ARPBL_DatePrinted</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RefundNotPrinted"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_DateFrom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRoyalOrder">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RoyalOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_RoyalOrder_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSunDeb">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SunDeb"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_SundryDebtor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSunDeb1">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SunDebDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_SundryDebtor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_UpdateDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToPay">
<Condition>
<![CDATA[{ARPBL_AmountToPay1}>0]]></Condition>
<ConditionFields>ARPBL_AmountToPay1</ConditionFields>
<Global>^ARPBL</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToPay"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^ARPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARPBL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARPBL_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARPBL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARPBL_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatientBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
