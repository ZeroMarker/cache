/// Order Entry Config      (OECF,5003)
Class User.CFOEConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_OEConfig, StorageStrategy = SQLStorage ]
{

Relationship ChildCFOEConfigRecieveLocPrint As CFOEConfigRecieveLocPrint [ Cardinality = children, Inverse = LOCParRef ];

/// Configuration Description
Property OECFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OECF_Description ];

/// Check Location Quantity with Receiving Dept.
Property OECFChkLocQty As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = OECF_ChkLocQty ];

/// Remove Queue
Property OECFRMQueue As %String(DISPLAYLIST = ",End Consult,Prompt", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",E,P") [ SqlColumnNumber = 5, SqlFieldName = OECF_RMQueue ];

/// Reject
Property OECFReject As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = OECF_Reject ];

/// Last Update Date
Property OECFUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OECF_UpdateDate ];

/// Last Update Time
Property OECFUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = OECF_UpdateTime ];

/// Last Update User
Property OECFUpdateUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 9, SqlFieldName = OECF_UpdateUser_DR ];

/// Default Disp Location
Property OECFDefaultDispLocDR As CTLoc [ SqlColumnNumber = 10, SqlFieldName = OECF_DefaultDispLoc_DR ];

/// Des Ref Priority
Property OECFPriorityDR As OECPriority [ SqlColumnNumber = 11, SqlFieldName = OECF_Priority_DR ];

/// Automatic Print Prescription on Acceptance
Property OECFPrintPresc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = OECF_PrintPresc ];

/// Des Ref to Frequency
Property OECFFrequencyDR As PHCFreq [ SqlColumnNumber = 13, SqlFieldName = OECF_Frequency_DR ];

/// Des Ref Duration
Property OECFDurationDR As PHCDuration [ SqlColumnNumber = 14, SqlFieldName = OECF_Duration_DR ];

/// Save Order Category
Property OECFSaveOrderCategory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = OECF_SaveOrderCategory ];

/// Change Linked On Update
Property OECFChangeLinkedOnUpdate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = OECF_ChangeLinkedOnUpdate ];

/// InPatient Billing Configuration
Property OECFInpatientBilling As %String(DISPLAYLIST = ",Bill Upon Ordering,Bill Upon Execution", MAXLEN = 19, TRUNCATE = 1, VALUELIST = ",BUO,BUE") [ SqlColumnNumber = 17, SqlFieldName = OECF_InpatientBilling ];

/// Send orders to Receiving Location
Property OECFOrdersToRecLoc As %String(DISPLAYLIST = ",On patient payment,On order entry", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",P,O") [ SqlColumnNumber = 18, SqlFieldName = OECF_OrdersToRecLoc ];

/// Send details to Auto. Tablet Counter
Property OECFATCInterface As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = OECF_ATCInterface ];

/// Default Order Group
Property OECFDefaultOrderGroup As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = OECF_DefaultOrderGroup ];

/// Send Hospital Code To LabTrak
Property OECFSendHospitalCodeToLab As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = OECF_SendHospitalCodeToLab ];

/// Diagnosis Warning Message Logic
Property OECFDiagWarning As %String(DISPLAYLIST = ",No Warning,Warning for Out Patients,Warning for In Patients,Warning for all Patients,Auto Add Diagnosis", MAXLEN = 24, TRUNCATE = 1, VALUELIST = ",N,O,I,A,K") [ SqlColumnNumber = 22, SqlFieldName = OECF_DiagWarning ];

/// Logic for when no Price defined
Property OECFCheckPrice As %String(DISPLAYLIST = ",No Warning,Warning Only,Warning and Disable Updates", MAXLEN = 27, TRUNCATE = 1, VALUELIST = ",N,W,D") [ SqlColumnNumber = 23, SqlFieldName = OECF_CheckPrice ];

/// OECF_AcceptIP
Property OECFAcceptIP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = OECF_AcceptIP ];

/// Accept OP
Property OECFAcceptOP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = OECF_AcceptOP ];

/// Auto Packing
Property OECFAutoPacking As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = OECF_AutoPacking ];

/// Execute Confirmation
Property OECFExecuteConfirmation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = OECF_ExecuteConfirmation ];

/// Show Order Price
Property OECFPrice As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = OECF_Price ];

/// Allow Pharmacy Item Not Linked to Stock Item
Property OECFPharmacyItemNoStock As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = OECF_PharmacyItemNoStock ];

/// Clear Orders On Update
Property OECFClearOrdersOnUpdate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = OECF_ClearOrdersOnUpdate ];

/// Allow Discontinue Executed Order
Property OECFDiscontExecutedOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = OECF_DiscontExecutedOrder ];

/// Send Ordering Doctor To Labtrak
Property OECFSendOrderingDoctorToLab As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = OECF_SendOrderingDoctorToLab ];

/// Execute Lab Order before sending to Labtrak
Property OECFExecuteLabOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = OECF_ExecuteLabOrder ];

/// Check if Orders are Covered
Property OECFCheckOrdersCovered As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = OECF_CheckOrdersCovered ];

/// Show Instruction As
Property OECFShowInstructionAs As %String(DISPLAYLIST = ",Code,Description", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",C,D") [ SqlColumnNumber = 35, SqlFieldName = OECF_ShowInstructionAs ];

/// Use Preprinted Labels for Lab
Property OECFUsePreprintedLabelsLab As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 36, SqlFieldName = OECF_UsePreprintedLabelsLab ];

/// Prescription Generated
Property OECFPrescriptionGenerated As %String(DISPLAYLIST = ",On Order Entry,Based on Receiving Location,Per Receiving Location Per Day", MAXLEN = 30, TRUNCATE = 1, VALUELIST = ",OE,RL,RD") [ SqlColumnNumber = 37, SqlFieldName = OECF_PrescriptionGenerated ];

/// Number Of Orders Allowed for the Same Group
Property OECFNumberOfOrdersAllowedSameGr As %Float [ SqlColumnNumber = 38, SqlFieldName = OECF_NumberOfOrdersAllowedSameGroup ];

/// Show Snomed Codes
Property OECFShowSnomedCodes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = OECF_ShowSnomedCodes ];

/// Print Result Delivery Label On Update
Property OECFPrintDelLabelOnUpdate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = OECF_PrintDelLabelOnUpdate ];

/// Show Delivery Info On Pin
Property OECFShowDeliveryInfoOnPin As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = OECF_ShowDeliveryInfoOnPin ];

/// Generate Execution Schedule for Outpatients
Property OECFGenerateExecSchedOutpat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = OECF_GenerateExecSchedOutpat ];

/// Same Start Date Warning
Property OECFSameStartDateWarning As %String(DISPLAYLIST = ",All Orders,Exclude Orders in This session", MAXLEN = 30, TRUNCATE = 1, VALUELIST = ",A,E") [ SqlColumnNumber = 43, SqlFieldName = OECF_SameStartDateWarning ];

/// Discontinue Overlapping Execution Time
Property OECFDiscontinueOverlapExTime As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = OECF_DiscontinueOverlapExTime ];

/// Warn Qty Range to include Duration
Property OECFWarnQtyRangeDuration As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = OECF_WarnQtyRangeDuration ];

/// Disable Execution Not Arrived Appt
Property OECFDisableExecuteNotArrAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = OECF_DisableExecuteNotArrAppt ];

/// Ignore Payor/Plan Restrictions arrive appt
Property OECFIgnorePayorPlanRest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = OECF_IgnorePayorPlanRest ];

/// Des Ref DefRefundReason
Property OECFDefRefundReasonDR As BLCReasonForRefund [ SqlColumnNumber = 48, SqlFieldName = OECF_DefRefundReason_DR ];

/// Show Discontinued Orders with Results
Property OECFShowDisOrdersResults As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = OECF_ShowDisOrdersResults ];

/// Round Dose Qty
Property OECFRoundDoseQty As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = OECF_RoundDoseQty ];

/// Edit Notes
Property OECFEditNotes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = OECF_EditNotes ];

/// Use Repeats Or EndDate
Property OECFUseRepeatsOrEndDate As %String(DISPLAYLIST = ",Repeats,End Date", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",R,E") [ SqlColumnNumber = 52, SqlFieldName = OECF_UseRepeatsOrEndDate ];

/// Allow to change Pack UOM
Property OECFAllowPackUOM As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = OECF_AllowPackUOM ];

/// Execute Future Orders
Property OECFExecuteFutureOrders As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = OECF_ExecuteFutureOrders ];

/// IgnorePriorityDEf
Property OECFIgnorePriorityDEf As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = OECF_IgnorePriorityDEf ];

/// Keep Priorty,StartDate/Time dur Order Session
Property OECFKeepPriorDateSession As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = OECF_KeepPriorDateSession ];

/// Display Refund Reason in stock return
Property OECFDisplayRefundReason As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = OECF_DisplayRefundReason ];

/// Limit
Property OECFLimit As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 58, SqlFieldName = OECF_Limit, SqlListType = SUBNODE ];

/// Copyright
Property OECFCopyright As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = OECF_Copyright, SqlListType = SUBNODE ];

/// Issue
Property OECFIssue As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 60, SqlFieldName = OECF_Issue, SqlListType = SUBNODE ];

/// Disclaim
Property OECFDisclaim As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 61, SqlFieldName = OECF_Disclaim, SqlListType = SUBNODE ];

/// Show Allergy_DSS_QA
Property OECFShowAllergyDSSQA As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = OECF_ShowAllergy_DSS_QA ];

/// Auto Backspace
Property OECFAutoBackspace As %Float [ SqlColumnNumber = 63, SqlFieldName = OECF_AutoBackspace ];

/// Allow Neg Stock for AutoPacking
Property OECFAllowNegStockAutoPacking As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 64, SqlFieldName = OECF_AllowNegStockAutoPacking ];

/// Allocate Order To Batch
Property OECFAllocateOrderToBatch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = OECF_AllocateOrderToBatch ];

/// Age From
Property OECFAgeFrom As %Float [ SqlColumnNumber = 66, SqlFieldName = OECF_AgeFrom ];

/// Age To
Property OECFAgeTo As %Float [ SqlColumnNumber = 67, SqlFieldName = OECF_AgeTo ];

/// Create 1 Order Per Specimen
Property OECFCreate1OrderPerSpecimen As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 68, SqlFieldName = OECF_Create1OrderPerSpecimen ];

/// Des Ref ARCIM
Property OECFCMVTestDR As ARCItmMast [ SqlColumnNumber = 69, SqlFieldName = OECF_CMVTest_DR ];

/// Do Not Default Patient Location on OE
Property OECFNoDefaultPatLocOnOE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = OECF_NoDefaultPatLocOnOE ];

/// do Not Show Reorder warning on Nurse WB
Property OECFNoShowReorderNurseWB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 71, SqlFieldName = OECF_NoShowReorderNurseWB ];

/// Show Warning as on OI Deptmt Override ct
Property OECFShowWarnOIDepOverCT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 72, SqlFieldName = OECF_ShowWarnOIDepOverCT ];

/// Display Duplicate Dosage TextBox
Property OECFDisplayDuplDosageTextBox As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 73, SqlFieldName = OECF_DisplayDuplDosageTextBox ];

/// Default Checkboxes on OS list unselect
Property OECFDefaultCheckBsUnselect As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 74, SqlFieldName = OECF_DefaultCheckBsUnselect ];

/// Create Return Queue upon Discharge
Property OECFCreateReturnQueueDisch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = OECF_CreateReturnQueueDisch ];

/// Display OI description on Pharmacy WB
Property OECFDisplayOIDescOnPharmWB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 76, SqlFieldName = OECF_DisplayOIDescOnPharmWB ];

/// AllowPlaceOrderOutsideEpisDates
Property OECFAllowPlaceOrderOutsideEpisD As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = OECF_AllowPlaceOrderOutsideEpisDates ];

/// Manual Verif LabOrders
Property OECFManualVerifLabOrders As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 78, SqlFieldName = OECF_ManualVerifLabOrders ];

/// Create 1 Order Per Tooth Face
Property OECFCreate1OrderPerToothFace As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 79, SqlFieldName = OECF_Create1OrderPerToothFace ];

/// GenericPrescribing
Property OECFGenericPrescribing As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 80, SqlFieldName = OECF_GenericPrescribing ];

/// TextForDeletedTestItem
Property OECFTextForDeletedTestItem As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 81, SqlFieldName = OECF_TextForDeletedTestItem ];

/// BillAdminDrugs
Property OECFBillAdminDrugs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 82, SqlFieldName = OECF_BillAdminDrugs ];

/// NoDCOrdersOnNurseWB
Property OECFNoDCOrdersOnNurseWB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 83, SqlFieldName = OECF_NoDCOrdersOnNurseWB ];

/// ExecuteUponCollection
Property OECFExecuteUponCollection As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = OECF_ExecuteUponCollection ];

/// ExePhDischOrdersOnDisch
Property OECFExePhDischOrdersOnDisch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 85, SqlFieldName = OECF_ExePhDischOrdersOnDisch ];

/// DisableAddForQtyBlank
Property OECFDisableAddForQtyBlank As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 86, SqlFieldName = OECF_DisableAddForQtyBlank ];

/// SendRecLocToLab
Property OECFSendRecLocToLab As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 87, SqlFieldName = OECF_SendRecLocToLab ];

/// Allow definition ActiveOrders as of AdmDates
Property OECFAllowActiveOrdersAdmDates As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 88, SqlFieldName = OECF_AllowActiveOrdersAdmDates ];

/// AllowConcurrentOrders
Property OECFAllowConcurrentOrders As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = OECF_AllowConcurrentOrders ];

/// Do Not ShowLabEpForAllOrdersIP_EStat
Property OECFNoShowLabEpForAllOrdersIPES As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 90, SqlFieldName = OECF_NoShowLabEpForAllOrdersIP_EStat ];

/// DefaultOSItemBillingPriceBlank
Property OECFDefaultOSItemBillingPriceBl As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 91, SqlFieldName = OECF_DefaultOSItemBillingPriceBlank ];

/// Des Ref PatLeaveOrderAdmStatus
Property OECFPatLeaveOrderAdmStatusDR As OECOrderAdminStatus [ SqlColumnNumber = 92, SqlFieldName = OECF_PatLeaveOrderAdmStatus_DR ];

/// Kinetics
Property OECFKinetics As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 93, SqlFieldName = OECF_Kinetics ];

/// TPN
Property OECFTPN As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 94, SqlFieldName = OECF_TPN ];

/// Send Web NR to LabTrak
Property OECFSendWebNRtoLabTrak As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 95, SqlFieldName = OECF_SendWebNRtoLabTrak ];

/// NoDisplayEpisNoForNormal
Property OECFNoDisplayEpisNoForNormal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 96, SqlFieldName = OECF_NoDisplayEpisNoForNormal ];

/// DaysToRemainAtPacked
Property OECFDaysToRemainAtPacked As %Float [ SqlColumnNumber = 97, SqlFieldName = OECF_DaysToRemainAtPacked ];

/// DaysToRemainAtUncollected
Property OECFDaysToRemainAtUncollected As %Float [ SqlColumnNumber = 98, SqlFieldName = OECF_DaysToRemainAtUncollected ];

/// WarnOutstanAmtExist
Property OECFWarnOutstanAmtExist As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 99, SqlFieldName = OECF_WarnOutstanAmtExist ];

/// PickBlankExpBatchLast
Property OECFPickBlankExpBatchLast As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 100, SqlFieldName = OECF_PickBlankExpBatchLast ];

/// ExternalMonographURL
Property OECFExternalMonographURL As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 101, SqlFieldName = OECF_ExternalMonographURL ];

/// SignOffDisclaimerDays
Property OECFSignOffDisclaimerDays As %Float [ SqlColumnNumber = 102, SqlFieldName = OECF_SignOffDisclaimerDays ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFOEConfig).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFOEConfig","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFOEConfig).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFOEConfig","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFOEConfig).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFOEConfig","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFOEConfig).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFOEConfig","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFOEConfig","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFOEConfig).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFOEConfig","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CF("OE",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="OECF_ATCInterface">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OECF_AcceptIP">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OECF_AcceptOP">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OECF_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="OECF_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="OECF_AllocateOrderToBatch">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="OECF_AllowActiveOrdersAdmDates">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="OECF_AllowConcurrentOrders">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="OECF_AllowNegStockAutoPacking">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="OECF_AllowPackUOM">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="OECF_AllowPlaceOrderOutsideEpisDates">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="OECF_AutoBackspace">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="OECF_AutoPacking">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OECF_BillAdminDrugs">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="OECF_CMVTest_DR">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="OECF_ChangeLinkedOnUpdate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OECF_CheckOrdersCovered">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OECF_CheckPrice">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OECF_ChkLocQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OECF_ClearOrdersOnUpdate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OECF_Copyright">
<Node>"COPY"</Node>
</Data>
<Data name="OECF_Create1OrderPerSpecimen">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="OECF_Create1OrderPerToothFace">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="OECF_CreateReturnQueueDisch">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="OECF_DaysToRemainAtPacked">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="OECF_DaysToRemainAtUncollected">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="OECF_DefRefundReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="OECF_DefaultCheckBsUnselect">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="OECF_DefaultDispLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OECF_DefaultOSItemBillingPriceBlank">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="OECF_DefaultOrderGroup">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OECF_Description">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OECF_DiagWarning">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OECF_DisableAddForQtyBlank">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="OECF_DisableExecuteNotArrAppt">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OECF_Disclaim">
<Node>"DSCL"</Node>
</Data>
<Data name="OECF_DiscontExecutedOrder">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OECF_DiscontinueOverlapExTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OECF_DisplayDuplDosageTextBox">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="OECF_DisplayOIDescOnPharmWB">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="OECF_DisplayRefundReason">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="OECF_Duration_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OECF_EditNotes">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="OECF_ExePhDischOrdersOnDisch">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="OECF_ExecuteConfirmation">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OECF_ExecuteFutureOrders">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="OECF_ExecuteLabOrder">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OECF_ExecuteUponCollection">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="OECF_ExternalMonographURL">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="OECF_Frequency_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OECF_GenerateExecSchedOutpat">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OECF_GenericPrescribing">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="OECF_IgnorePayorPlanRest">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OECF_IgnorePriorityDEf">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="OECF_InpatientBilling">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OECF_Issue">
<Node>"ISS"</Node>
</Data>
<Data name="OECF_KeepPriorDateSession">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="OECF_Kinetics">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="OECF_Limit">
<Node>"LIM"</Node>
</Data>
<Data name="OECF_ManualVerifLabOrders">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="OECF_NoDCOrdersOnNurseWB">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="OECF_NoDefaultPatLocOnOE">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="OECF_NoDisplayEpisNoForNormal">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="OECF_NoShowLabEpForAllOrdersIP_EStat">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="OECF_NoShowReorderNurseWB">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="OECF_NumberOfOrdersAllowedSameGroup">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OECF_OrdersToRecLoc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OECF_PatLeaveOrderAdmStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="OECF_PharmacyItemNoStock">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OECF_PickBlankExpBatchLast">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="OECF_PrescriptionGenerated">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OECF_Price">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OECF_PrintDelLabelOnUpdate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OECF_PrintPresc">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OECF_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OECF_RMQueue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OECF_Reject">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OECF_RoundDoseQty">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="OECF_SameStartDateWarning">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OECF_SaveOrderCategory">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OECF_SendHospitalCodeToLab">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OECF_SendOrderingDoctorToLab">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OECF_SendRecLocToLab">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="OECF_SendWebNRtoLabTrak">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="OECF_ShowAllergy_DSS_QA">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="OECF_ShowDeliveryInfoOnPin">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OECF_ShowDisOrdersResults">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="OECF_ShowInstructionAs">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OECF_ShowSnomedCodes">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OECF_ShowWarnOIDepOverCT">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="OECF_SignOffDisclaimerDays">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="OECF_TPN">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="OECF_TextForDeletedTestItem">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="OECF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OECF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OECF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OECF_UsePreprintedLabelsLab">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OECF_UseRepeatsOrEndDate">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="OECF_WarnOutstanAmtExist">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="OECF_WarnQtyRangeDuration">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OECF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"OE"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{OECF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OECF_RowID</SqlRowIdName>
<StreamLocation>^User.CFOEConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
