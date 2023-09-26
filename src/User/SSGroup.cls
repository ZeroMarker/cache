/// SS Groups for the Users (SSGRP,770)
/// 安全组 =角色
Class User.SSGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Group, StorageStrategy = SQLStorage ]
{

Relationship ChildSSGroupMFunctions As SSGroupMFunctions [ Cardinality = children, Inverse = SSGMFSSGRPParRef ];

Relationship ChildSSGroupVBExecFunction As SSGroupVBExecFunction [ Cardinality = children, Inverse = VBEXParRef ];

Relationship ChildSSGroupOrderCategory As SSGroupOrderCategory [ Cardinality = children, Inverse = SSORDParRef ];

Relationship ChildSSGroupWindowLayout As SSGroupWindowLayout [ Cardinality = children, Inverse = WINParRef ];

Relationship ChildSSGroupForms As SSGroupForms [ Cardinality = children, Inverse = FORMParRef ];

Relationship ChildSSGroupOrderStatus As SSGroupOrderStatus [ Cardinality = children, Inverse = OSTATParRef ];

Relationship ChildSSGroupNWSWindowLayout As SSGroupNWSWindowLayout [ Cardinality = children, Inverse = NWSWINParRef ];

Relationship ChildSSGroupNWSForm As SSGroupNWSForm [ Cardinality = children, Inverse = NWSFORMParRef ];

Relationship ChildSSGroupRBRestrictions As SSGroupRBRestrictions [ Cardinality = children, Inverse = RBParRef ];

Relationship ChildSSGroupStockLocations As SSGroupStockLocations [ Cardinality = children, Inverse = STParRef ];

Relationship ChildSSGroupStockTakeGroup As SSGroupStockTakeGroup [ Cardinality = children, Inverse = STGParRef ];

Relationship ChildSSGroupPurchaseOrderType As SSGroupPurchaseOrderType [ Cardinality = children, Inverse = POParRef ];

Relationship ChildSSGroupDiagnosisType As SSGroupDiagnosisType [ Cardinality = children, Inverse = DTYPEParRef ];

Relationship ChildSSGroupPayors As SSGroupPayors [ Cardinality = children, Inverse = PAYParRef ];

Relationship ChildSSGroupHospitals As SSGroupHospitals [ Cardinality = children, Inverse = HOSPParRef ];

Relationship ChildSSGroupDocResRestrictions As SSGroupDocResRestrictions [ Cardinality = children, Inverse = DRESParRef ];

Relationship ChildSSGroupDischCond As SSGroupDischCond [ Cardinality = children, Inverse = DCParREf ];

Relationship ChildSSGroupConsumReason As SSGroupConsumReason [ Cardinality = children, Inverse = CONRParRef ];

Relationship ChildSSGroupStockItems As SSGroupStockItems [ Cardinality = children, Inverse = INCIParRef ];

Relationship ChildSSGroupWaitListType As SSGroupWaitListType [ Cardinality = children, Inverse = WLTParRef ];

Relationship ChildSSGroupWaitListPriority As SSGroupWaitListPriority [ Cardinality = children, Inverse = WLPParRef ];

Relationship ChildSSGroupAlertCategory As SSGroupAlertCategory [ Cardinality = children, Inverse = ALCParRef ];

Relationship ChildSSGroupClnPathwayType As SSGroupClnPathwayType [ Cardinality = children, Inverse = CPWParRef ];

Relationship ChildSSGroupUDWGroup As SSGroupUDWGroup [ Cardinality = children, Inverse = RESRRParRef ];

Relationship ChildSSGroupSourceOfAttend As SSGroupSourceOfAttend [ Cardinality = children, Inverse = SATTParRef ];

Relationship ChildSSGroupRROrdCateg As SSGroupRROrdCateg [ Cardinality = children, Inverse = RRCATParRef ];

Relationship ChildSSGroupCodingStatus As SSGroupCodingStatus [ Cardinality = children, Inverse = CODSTParRef ];

Relationship ChildSSGroupSpecialProject As SSGroupSpecialProject [ Cardinality = children, Inverse = SPECPROParRef ];

Relationship ChildSSGroupAdmPoint As SSGroupAdmPoint [ Cardinality = children, Inverse = ADMPParRef ];

Relationship ChildSSGroupReqReason As SSGroupReqReason [ Cardinality = children, Inverse = REQRParRef ];

Relationship ChildSSGroupSessionType As SSGroupSessionType [ Cardinality = children, Inverse = SESSParRef ];

/// 安全组名称=角色名称
Property SSGRPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SSGRP_Desc ];

/// First Menu
Property SSGRPFirstMenu As SSMenu [ SqlColumnNumber = 4, SqlFieldName = SSGRP_FirstMenu ];

/// First Menu Type
Property SSGRPFirstMenuType As %String(DISPLAYLIST = ",Bar,Pop Up", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",B,P") [ SqlColumnNumber = 5, SqlFieldName = SSGRP_FirstMenuType ];

/// Allowed To Add Orders after Review flag
Property SSGRPAllowedAddOrdersReview As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SSGRP_AllowedAddOrdersReview ];

/// Retain Order Category
Property SSGRPRetainOrderCategory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SSGRP_RetainOrderCategory ];

/// Minimize Order Entry on Update
Property SSGRPMinimizeOEUpdate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SSGRP_MinimizeOEUpdate ];

/// Show Order Price
Property SSGRPPrice As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SSGRP_Price ];

/// Display Diagnosis
Property SSGRPDisplayDiagnosis As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = SSGRP_DisplayDiagnosis ];

/// Allowed to Delete Episode/Process
Property SSGRPAllowDeleteEpisode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = SSGRP_AllowDeleteEpisode ];

/// Auto Show Patient Search in Registration
Property SSGRPShowPatientSearch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = SSGRP_ShowPatientSearch ];

/// Allow to Book Outside Range
Property SSGRPAllowBookOutsideRange As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SSGRP_AllowBookOutsideRange ];

/// Allowed to Book Operation Times
Property SSGRPAllowedtoBookOR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SSGRP_AllowedtoBookOR ];

/// Allow To Change Family Doctor
Property SSGRPAllowToChangeFamilyDoctor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = SSGRP_AllowToChangeFamilyDoctor ];

/// Allow To Change Data AfterPatient Discharge
Property SSGRPChangeDataAfterDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = SSGRP_ChangeDataAfterDischarge ];

/// Allow to Add Stock Item to Location
Property SSGRPAllowAddStockItem As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = SSGRP_AllowAddStockItem ];

/// Allow To Add Item To Location Portfolio
Property SSGRPAllowToAddItemToLocPortfol As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = SSGRP_AllowToAddItemToLocPortfolio ];

/// Allow To Add Item To Vend Portfolio
Property SSGRPAllowToAddItemToVendPortfo As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = SSGRP_AllowToAddItemToVendPortfolio ];

/// Allow To Execute Order Outside Shift
Property SSGRPAllowToExecuteOrderOutside As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = SSGRP_AllowToExecuteOrderOutsideShift ];

/// Show All Locations in Patient Registration
Property SSGRPShowAllLocations As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = SSGRP_ShowAllLocations ];

/// Des Ref OutPatLocList
Property SSGRPOutPatLocListDR As CTLocationList [ SqlColumnNumber = 22, SqlFieldName = SSGRP_OutPatLocList_DR ];

/// Des Ref InPatLocList
Property SSGRPInPatLocListDR As CTLocationList [ SqlColumnNumber = 23, SqlFieldName = SSGRP_InPatLocList_DR ];

/// Des Ref EmergencyLocList
Property SSGRPEmergencyLocListDR As CTLocationList [ SqlColumnNumber = 24, SqlFieldName = SSGRP_EmergencyLocList_DR ];

/// Des Ref HealthPromLocList
Property SSGRPHealthPromLocListDR As CTLocationList [ SqlColumnNumber = 25, SqlFieldName = SSGRP_HealthPromLocList_DR ];

/// Display Orders from Previous Episode
Property SSGRPOrdersPrevEpisode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = SSGRP_OrdersPrevEpisode ];

/// Allow to Issue Archived MR
Property SSGRPAllowIssueArchiveMR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = SSGRP_AllowIssueArchiveMR ];

/// Show Preadm After Appoint
Property SSGRPShowPreadmafterAppoint As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = SSGRP_ShowPreadmafterAppoint ];

/// Show All patients in assigned ward in NWB
Property SSGRPShowAllPatientsInNWB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = SSGRP_ShowAllPatientsInNWB ];

/// Warn if user moves ORBooking to another Res
Property SSGRPWarnORBookingMoveRes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = SSGRP_WarnORBookingMoveRes ];

/// Do Not Allow OR Bookings in Past
Property SSGRPNAllORBookPast As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 31, SqlFieldName = SSGRP_NAllORBookPast ];

/// Do Not Allow ORBooking in Non Session area
Property SSGRPNAllORBookNoSess As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = SSGRP_NAllORBookNoSess ];

/// Do Not Allow ORBookings in Not Avail area
Property SSGRPNAllORBookNA As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = SSGRP_NAllORBookNA ];

/// Allow Over BookRB
Property SSGRPAllowOverBookRB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = SSGRP_AllowOverBookRB ];

/// Enable System CT
Property SSGRPEnableSystemCT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = SSGRP_EnableSystemCT ];

/// Des Ref WaitListStatus
Property SSGRPWaitListStatusDR As PACWaitingListStatus [ SqlColumnNumber = 36, SqlFieldName = SSGRP_WaitListStatus_DR ];

/// Allow to Change Dep in OT
Property SSGRPAllowChangeDepOT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = SSGRP_AllowChangeDepOT ];

/// Use Default Dose Equivalent
Property SSGRPDefaultDoseEquiv As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = SSGRP_DefaultDoseEquiv ];

/// Check if Orders are Covered
Property SSGRPCheckOrdersCovered As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = SSGRP_CheckOrdersCovered ];

/// AllowToChangeAgrPrice
Property SSGRPAllowToChangeAgrPrice As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 40, SqlFieldName = SSGRP_AllowToChangeAgrPrice ];

/// Display Diagn Proc DRG
Property SSGRPDisplayDiagnProcDRG As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = SSGRP_DisplayDiagnProcDRG ];

/// Des Ref WardViewLocList
Property SSGRPWardViewLocListDR As CTLocationList [ SqlColumnNumber = 42, SqlFieldName = SSGRP_WardViewLocList_DR ];

/// WardPlaceLocList
Property SSGRPWardPlaceLocListDR As CTLocationList [ SqlColumnNumber = 43, SqlFieldName = SSGRP_WardPlaceLocList_DR ];

/// SuppressPin
Property SSGRPSuppressPin As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = SSGRP_SuppressPin ];

/// MoveToDefaultBed
Property SSGRPMoveToDefaultBed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = SSGRP_MoveToDefaultBed ];

/// Allow to Override Payor Restrictions
Property SSGRPAllowOverPayorRestrict As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 46, SqlFieldName = SSGRP_AllowOverPayorRestrict ];

/// Allow Undo Appointment
Property SSGRPAllowUndoAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = SSGRP_AllowUndoAppt ];

/// Allow to Delete Diagnosis entered byOtherUser
Property SSGRPAllowDeleteDiagOtherUs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = SSGRP_AllowDeleteDiagOtherUs ];

/// Allow Delete Bed Transactions
Property SSGRPAllowDeleteBedTransactions As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = SSGRP_AllowDeleteBedTransactions ];

/// Allow to Edit Price in  GR
Property SSGRPAllowEditPriceGR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = SSGRP_AllowEditPriceGR ];

/// Consumption Reason Mandatory
Property SSGRPConsReasonMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = SSGRP_ConsReasonMandatory ];

/// Allow Web Layout Manager
Property SSGRPAllowWebLayoutManager As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = SSGRP_AllowWebLayoutManager ];

/// Allow Web Column Manager
Property SSGRPAllowWebColumnManager As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = SSGRP_AllowWebColumnManager ];

/// Restrict Modification after Discharge
Property SSGRPRestrictModifDischarge As %String(DISPLAYLIST = ",No Changes Permitted,Care provider only,Linked Care Providers", MAXLEN = 21, TRUNCATE = 1, VALUELIST = ",N,CP,LC") [ SqlColumnNumber = 55, SqlFieldName = SSGRP_RestrictModifDischarge ];

/// DiscontinueExecOrders
Property SSGRPDiscontinueExecOrders As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = SSGRP_DiscontinueExecOrders ];

/// Job aOET11 in OE
Property SSGRPJobOE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = SSGRP_JobOE ];

/// AllowToChangeStatus
Property SSGRPAllowToChangeOEStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = SSGRP_AllowToChangeOEStatus ];

/// InactivityTimeOut
Property SSGRPInactivityTimeOut As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 59, SqlFieldName = SSGRP_InactivityTimeOut ];

/// Allow Obj Subj Findings Edit Within 24hrs
Property SSGRPAllowOSFEdit24hrs As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = SSGRP_AllowOSFEdit24hrs ];

/// Auto Med Discharge
Property SSGRPAutoMedDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = SSGRP_AutoMedDischarge ];

/// Check for Future Appointments
Property SSGRPChkFutureAppts As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = SSGRP_ChkFutureAppts ];

/// Do Not Allow Booking Outside of Session Time
Property SSGRPNotBookOutSess As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 63, SqlFieldName = SSGRP_NotBookOutSess ];

/// PasswordDaysToExpire
Property SSGRPPasswordDaysToExpire As %Float [ SqlColumnNumber = 64, SqlFieldName = SSGRP_PasswordDaysToExpire ];

/// Radiology Location List
Property SSGRPRadLocList As CTLocationList [ SqlColumnNumber = 65, SqlFieldName = SSGRP_RadLocList ];

/// Des Ref TempPatLocList
Property SSGRPTempPatLocList As CTLocationList [ SqlColumnNumber = 66, SqlFieldName = SSGRP_TempPatLocList ];

/// Security Level
Property SSGRPSecurityLevel As %Numeric(MAXVAL = 1000, MINVAL = 0, SCALE = 0) [ SqlColumnNumber = 67, SqlFieldName = SSGRP_SecurityLevel ];

/// Update Order Details
Property SSGRPUpdateOrderDetails As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 68, SqlFieldName = SSGRP_UpdateOrderDetails ];

/// Wait List Location List DR
Property SSGRPWaitListLocListDR As CTLocationList [ SqlColumnNumber = 69, SqlFieldName = SSGRP_WaitListLocList_DR ];

/// do Not Exceed LoadLevel for slot Overrides
Property SSGRPNotExcLoadLevelOverrides As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = SSGRP_NotExcLoadLevelOverrides ];

/// Allow to View VIP Patients
Property SSGRPAllowViewVIPPatients As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 71, SqlFieldName = SSGRP_AllowViewVIPPatients ];

/// Des Ref DFLocList
Property SSGRPDFLocListDR As CTLocationList [ SqlColumnNumber = 72, SqlFieldName = SSGRP_DFLocList_DR ];

/// Allow Send Msg to All users
Property SSGRPAllowSendMsgAll As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 73, SqlFieldName = SSGRP_AllowSendMsgAll ];

/// Display Service Details in Calendar
Property SSGRPDisplayServiceDetails As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 74, SqlFieldName = SSGRP_DisplayServiceDetails ];

/// RingWardFlag
Property SSGRPRingWardFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = SSGRP_RingWardFlag ];

/// Warning if Future Appt exist
Property SSGRPWarnFutureAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 76, SqlFieldName = SSGRP_WarnFutureAppt ];

/// Allow only edit adms in login Location
Property SSGRPAllowEditEpLogLoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = SSGRP_AllowEditEpLogLoc ];

/// Diary Start Time
Property SSGRPDiaryStartTime As %Time [ SqlColumnNumber = 78, SqlFieldName = SSGRP_DiaryStartTime ];

/// Diary End Time
Property SSGRPDiaryEndTime As %Time [ SqlColumnNumber = 79, SqlFieldName = SSGRP_DiaryEndTime ];

/// Diary Slot Length
Property SSGRPDiarySlotLength As %Float [ SqlColumnNumber = 80, SqlFieldName = SSGRP_DiarySlotLength ];

/// Appt Autofind
Property SSGRPApptAutofind As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 81, SqlFieldName = SSGRP_ApptAutofind ];

/// Allow discontinue order of packed prescrips
Property SSGRPAllowDiscOrdPackedPres As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 82, SqlFieldName = SSGRP_AllowDiscOrdPackedPres ];

/// Allocate Order ToBatch
Property SSGRPAllocateOrderToBatch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 83, SqlFieldName = SSGRP_AllocateOrderToBatch ];

/// Allow See Sensitive Results
Property SSGRPAllowedSeeSEnsitRes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = SSGRP_AllowedSeeSEnsitRes ];

/// Disable Add All on OE
Property SSGRPDisableAddAll As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 85, SqlFieldName = SSGRP_DisableAddAll ];

/// Des Ref WLStatusList_DR
Property SSGRPWLStatusListDR As PACWLStatusList [ SqlColumnNumber = 86, SqlFieldName = SSGRP_WLStatusList_DR ];

/// Appt Past
Property SSGRPApptPast As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 87, SqlFieldName = SSGRP_ApptPast ];

/// Restrict Search EMR
Property SSGRPRestrictSearchEMR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 88, SqlFieldName = SSGRP_RestrictSearchEMR ];

/// Select All Episodes in EMR
Property SSGRPSelectAllEpisodesEMR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = SSGRP_SelectAllEpisodesEMR ];

/// Des Ref WardAttendLocList
Property SSGRPWardAttendLocListDR As CTLocationList [ SqlColumnNumber = 90, SqlFieldName = SSGRP_WardAttendLocList_DR ];

/// Restrict Appt for Radiology Orders
Property SSGRPRestrictApptRadOrders As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 91, SqlFieldName = SSGRP_RestrictApptRadOrders ];

/// Clinical Loc List DR
Property SSGRPClinicalLocListDr As CTLocationList [ SqlColumnNumber = 92, SqlFieldName = SSGRP_ClinicalLocListDr ];

/// RestrictMRType to Current Hospital
Property SSGRPRestrictMRTypeCurrHosp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 93, SqlFieldName = SSGRP_RestrictMRTypeCurrHosp ];

/// Allow Activate Volume
Property SSGRPAllowActivateVolume As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 94, SqlFieldName = SSGRP_AllowActivateVolume ];

/// Discharge Location List
Property SSGRPDischargeLocList As CTLocationList [ SqlColumnNumber = 95, SqlFieldName = SSGRP_DischargeLocList ];

/// Allowed See Sensitive Orders
Property SSGRPAllowedSeeSensitOrd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 96, SqlFieldName = SSGRP_AllowedSeeSensitOrd ];

/// Allow to create new MR Types for Patient
Property SSGRPAllowNewMRTypesPat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 97, SqlFieldName = SSGRP_AllowNewMRTypesPat ];

/// Main Surgeon Is Not Mandatory in OT booking
Property SSGRPMainSurgeonIsNotMandOT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 98, SqlFieldName = SSGRP_MainSurgeonIsNotMandOT ];

/// Anaest Method Isnt Mandatory in OT booking
Property SSGRPAnMethodIsntMandOT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 99, SqlFieldName = SSGRP_AnMethodIsntMandOT ];

/// Main Anaestethist Isnt Mandator in OT booking
Property SSGRPMainAnaestIsntMandOT As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 100, SqlFieldName = SSGRP_MainAnaestIsntMandOT ];

/// Restrict Locations for Group Hospitals
Property SSGRPRestrictLocForGrHospitals As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 101, SqlFieldName = SSGRP_RestrictLocForGrHospitals ];

/// not used
Property SSGRPCumAcrossAllEpisodes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 102, SqlFieldName = SSGRP_CumAcrossAllEpisodes ];

/// not used
Property SSGRPCumIncludeRPrefix As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 103, SqlFieldName = SSGRP_CumIncludeRPrefix ];

/// not used
Property SSGRPCumRefRangePosition As %String(DISPLAYLIST = ",Before Test Item,After Test Item,After Test Data,Do Not Display", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",BT,AT,AD,DN") [ SqlColumnNumber = 104, SqlFieldName = SSGRP_CumRefRangePosition ];

/// not used
Property SSGRPCumAllowedSeeGraphLink As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 105, SqlFieldName = SSGRP_CumAllowedSeeGraphLink ];

/// not used
Property SSGRPCumNoColumns As %Float [ SqlColumnNumber = 106, SqlFieldName = SSGRP_CumNoColumns ];

/// Allow Overbook when Slots Override r Zero
Property SSGRPAllowOverBookOnSlotZero As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 107, SqlFieldName = SSGRP_AllowOverBookOnSlotZero ];

/// ShowAllergy_DSS_QA
Property SSGRPShowAllergyDSSQA As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 108, SqlFieldName = SSGRP_ShowAllergy_DSS_QA ];

/// DisplayQnsOnAlertScreen
Property SSGRPDisplayQnsOnAlertScreen As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 109, SqlFieldName = SSGRP_DisplayQnsOnAlertScreen ];

/// DisplayQnsOnSumScreen
Property SSGRPDisplayQnsOnSumScreen As %String(DISPLAYLIST = ",Before,After", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",B,A") [ SqlColumnNumber = 110, SqlFieldName = SSGRP_DisplayQnsOnSumScreen ];

/// Ignore Order Restrictions
Property SSGRPIgnoreOrderRestrictions As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 111, SqlFieldName = SSGRP_IgnoreOrderRestrictions ];

/// Only OutPat Units For My Hospital
Property SSGRPOnlyOutpatUnitsForMyHospit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 112, SqlFieldName = SSGRP_OnlyOutpatUnitsForMyHospital ];

/// Only InPat Units For My Hospital
Property SSGRPOnlyInpatUnitsForMyHospita As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 113, SqlFieldName = SSGRP_OnlyInpatUnitsForMyHospital ];

/// DisplayOEfromRBAfterApptCreated
Property SSGRPDisplayOEfromRBAfterAp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 114, SqlFieldName = SSGRP_DisplayOEfromRBAfterAp ];

/// WL Audit Letter Days
Property SSGRPWLAuditLetterDays As %Float [ SqlColumnNumber = 115, SqlFieldName = SSGRP_WLAuditLetterDays ];

/// DisplayPatmanActiveCWB
Property SSGRPDisplayPatmanActiveCWB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 116, SqlFieldName = SSGRP_DisplayPatmanActiveCWB ];

/// ShowOnlyIPUnitsForWL
Property SSGRPShowOnlyIPUnitsForWL As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 117, SqlFieldName = SSGRP_ShowOnlyIPUnitsForWL ];

/// AllowedSeeSensitAntib
Property SSGRPAllowedSeeSensitAntib As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 118, SqlFieldName = SSGRP_AllowedSeeSensitAntib ];

/// MaxPOAmount
Property SSGRPMaxPOAmount As %Float [ SqlColumnNumber = 119, SqlFieldName = SSGRP_MaxPOAmount ];

/// Not Allow to Add Past Appt
Property SSGRPNAllAddPastAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 120, SqlFieldName = SSGRP_NAllAddPastAppt ];

/// Des Ref OPLocList
Property SSGRPOPLocListDR As CTLocationList [ SqlColumnNumber = 121, SqlFieldName = SSGRP_OPLocList_DR ];

/// AllowDiscPaidOrder
Property SSGRPAllowDiscPaidOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 122, SqlFieldName = SSGRP_AllowDiscPaidOrder ];

/// RestrictWardsToDepartment
Property SSGRPRestrictWardsToDepartment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 123, SqlFieldName = SSGRP_RestrictWardsToDepartment ];

/// NoRestrictUserSameGroupOE
Property SSGRPNoRestrictUserSameGroupOE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 124, SqlFieldName = SSGRP_NoRestrictUserSameGroupOE ];

/// AllowMultipleServAdhoc
Property SSGRPAllowMultipleServAdhoc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 125, SqlFieldName = SSGRP_AllowMultipleServAdhoc ];

/// NoDisplayReasonStAdj
Property SSGRPNoDisplayReasonStAdj As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 126, SqlFieldName = SSGRP_NoDisplayReasonStAdj ];

/// NoDisplayReasonStCons
Property SSGRPNoDisplayReasonStCons As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 127, SqlFieldName = SSGRP_NoDisplayReasonStCons ];

/// NoDisplayReasonStDisp
Property SSGRPNoDisplayReasonStDisp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 128, SqlFieldName = SSGRP_NoDisplayReasonStDisp ];

/// DisableFindStAdj
Property SSGRPDisableFindStAdj As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 129, SqlFieldName = SSGRP_DisableFindStAdj ];

/// DisableFindStCons
Property SSGRPDisableFindStCons As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 130, SqlFieldName = SSGRP_DisableFindStCons ];

/// DisableFindStDisp
Property SSGRPDisableFindStDisp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 131, SqlFieldName = SSGRP_DisableFindStDisp ];

/// AllowEditWLStatusTreated
Property SSGRPAllowEditWLStatusTreated As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 132, SqlFieldName = SSGRP_AllowEditWLStatusTreated ];

/// LocMandatoryPOInquiry
Property SSGRPLocMandatoryPOInquiry As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 133, SqlFieldName = SSGRP_LocMandatoryPOInquiry ];

/// LocMandatoryPOSearch
Property SSGRPLocMandatoryPOSearch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 134, SqlFieldName = SSGRP_LocMandatoryPOSearch ];

/// Des Ref InPatTransferList
Property SSGRPInPatTransferListDR As CTLocationList [ SqlColumnNumber = 135, SqlFieldName = SSGRP_InPatTransferList_DR ];

/// CheckApproved
Property SSGRPCheckApproved As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 136, SqlFieldName = SSGRP_CheckApproved ];

/// OnePOforEveryVendor
Property SSGRPOnePOforEveryVendor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 137, SqlFieldName = SSGRP_OnePOforEveryVendor ];

/// UserPOReferenceNotMandatory
Property SSGRPUserPOReferenceNotMandator As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 138, SqlFieldName = SSGRP_UserPOReferenceNotMandatory ];

/// Des Ref DefaultPOReference
Property SSGRPDefaultPOReferenceDR As INCPOReference [ SqlColumnNumber = 139, SqlFieldName = SSGRP_DefaultPOReference_DR ];

/// ClosePatList1PatReturned
Property SSGRPClosePatList1PatReturned As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 140, SqlFieldName = SSGRP_ClosePatList1PatReturned ];

/// DoNotUpdateDOCTORWithLinkedCP
Property SSGRPDoNotUpdateDOCTORWithLinke As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 141, SqlFieldName = SSGRP_DoNotUpdateDOCTORWithLinkedCP ];

/// DoNotClearPatManUponUpdate
Property SSGRPDoNotClearPatManUponUpdate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 142, SqlFieldName = SSGRP_DoNotClearPatManUponUpdate ];

/// OEDontSkipUponUDFReject
Property SSGRPOEDontSkipUponUDFReject As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 143, SqlFieldName = SSGRP_OEDontSkipUponUDFReject ];

/// AllowAdmitAllInPatPreAdm
Property SSGRPAllowAdmitAllInPatPreAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 144, SqlFieldName = SSGRP_AllowAdmitAllInPatPreAdm ];

/// DontBookOutsideOTSchedule
Property SSGRPDontBookOutsideOTSchedule As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 145, SqlFieldName = SSGRP_DontBookOutsideOTSchedule ];

/// RoundingOnPayment
Property SSGRPRoundingOnPayment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 146, SqlFieldName = SSGRP_RoundingOnPayment ];

/// RoundingAutomatic
Property SSGRPRoundingAutomatic As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 147, SqlFieldName = SSGRP_RoundingAutomatic ];

/// CashierCustomPrintRcpt
Property SSGRPCashierCustomPrintRcpt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 148, SqlFieldName = SSGRP_CashierCustomPrintRcpt ];

/// ShowMIC
Property SSGRPShowMIC As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 149, SqlFieldName = SSGRP_ShowMIC ];

/// ED Floor Plan Display Only
Property SSGRPFloorPlanDisplayOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 150, SqlFieldName = SSGRP_FloorPlanDisplayOnly ];

/// AllowBookPastGuarDateOP
Property SSGRPAllowBookPastGuarDateOP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 151, SqlFieldName = SSGRP_AllowBookPastGuarDateOP ];

/// AllowBookPastGuarDateWL
Property SSGRPAllowBookPastGuarDateWL As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 152, SqlFieldName = SSGRP_AllowBookPastGuarDateWL ];

/// Allow Edit Help
Property SSGRPAllowEditHelp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 153, SqlFieldName = SSGRP_AllowEditHelp ];

/// 有效标志 （空和Y为有效）
Property SSGRPActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 154, SqlFieldName = SSGRP_ActiveFlag ];

/// 安全组代码=角色代码
Property SSGRPCode As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 155, SqlFieldName = SSGRP_Code ];

/// 开始日期
Property SSGRPStartDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 156, SqlFieldName = SSGRP_StartDate ];

/// 结束日期
Property SSGRPEndDate As %Date [ SqlColumnNumber = 157, SqlFieldName = SSGRP_EndDate ];

/// 系统创建日期
Property SSGRPCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 158, SqlFieldName = SSGRP_CreateDate ];

/// 系统创建时间
Property SSGRPCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 159, SqlFieldName = SSGRP_CreateTime ];

/// 系统创建人
Property SSGRPCreateUser As User.SSUser [ SqlColumnNumber = 160, SqlFieldName = SSGRP_CreateUser ];

/// 系统排序号
Property SSGRPSeqNo As %Float [ SqlColumnNumber = 161, SqlFieldName = SSGRP_SeqNo ];

/// 系统最后更新日期
Property SSGRPLastUpdateDate As %Date [ SqlColumnNumber = 162, SqlFieldName = SSGRP_LastUpdateDate ];

/// 系统最后更新时间
Property SSGRPLastUpdateTime As %Time [ SqlColumnNumber = 163, SqlFieldName = SSGRP_LastUpdateTime ];

/// 系统最新更新人
Property SSGRPLastUpdateUser As User.SSUser [ SqlColumnNumber = 164, SqlFieldName = SSGRP_LastUpdateUser ];

/// 拼音码
Property SSGRPPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 165, SqlFieldName = SSGRP_PYCode ];

/// 五笔码
Property SSGRPWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 166, SqlFieldName = SSGRP_WBCode ];

/// 备注
Property SSGRPMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 167, SqlFieldName = SSGRP_Mark ];

/// 上级安全组代码-外键
Property SSGRPGroupDr As User.SSGroup [ SqlColumnNumber = 168, SqlFieldName = SSGRP_Group_Dr ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSGroup).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSGroup).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSGroup).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroup","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSGroup).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroup","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroup","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSGroup).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSGroup","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>124</ExtentSize>
<Property name="SSGRPAllocateOrderToBatch">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowActivateVolume">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowAddStockItem">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowAdmitAllInPatPreAdm">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowBookOutsideRange">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowBookPastGuarDateOP">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowBookPastGuarDateWL">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowChangeDepOT">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowDeleteBedTransactions">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowDeleteDiagOtherUs">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowDeleteEpisode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowDiscOrdPackedPres">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowDiscPaidOrder">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowEditEpLogLoc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowEditPriceGR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowEditWLStatusTreated">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowIssueArchiveMR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowMultipleServAdhoc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowNewMRTypesPat">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowOSFEdit24hrs">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowOverBookOnSlotZero">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowOverBookRB">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowOverPayorRestrict">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowSendMsgAll">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowToAddItemToLocPortfol">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowToAddItemToVendPortfo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowToChangeAgrPrice">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowToChangeFamilyDoctor">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowToChangeOEStatus">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowToExecuteOrderOutside">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowUndoAppt">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowViewVIPPatients">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowWebColumnManager">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowWebLayoutManager">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowedAddOrdersReview">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowedSeeSEnsitRes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowedSeeSensitAntib">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowedSeeSensitOrd">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAllowedtoBookOR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAnMethodIsntMandOT">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPApptAutofind">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPApptPast">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPAutoMedDischarge">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPCashierCustomPrintRcpt">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPChangeDataAfterDischarge">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPCheckApproved">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPCheckOrdersCovered">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPChkFutureAppts">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPClinicalLocListDr">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SSGRPClosePatList1PatReturned">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPConsReasonMandatory">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPCumAcrossAllEpisodes">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPCumAllowedSeeGraphLink">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPCumIncludeRPrefix">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPCumNoColumns">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SSGRPCumRefRangePosition">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="SSGRPDFLocListDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPDefaultDoseEquiv">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDefaultPOReferenceDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SSGRPDesc">
<Selectivity>0.8130%</Selectivity>
</Property>
<Property name="SSGRPDiaryEndTime">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPDiarySlotLength">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPDiaryStartTime">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPDisableAddAll">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisableFindStAdj">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisableFindStCons">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisableFindStDisp">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDischargeLocList">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SSGRPDiscontinueExecOrders">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisplayDiagnProcDRG">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisplayDiagnosis">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisplayOEfromRBAfterAp">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisplayPatmanActiveCWB">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisplayQnsOnAlertScreen">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisplayQnsOnSumScreen">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDisplayServiceDetails">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDoNotClearPatManUponUpdate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDoNotUpdateDOCTORWithLinke">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPDontBookOutsideOTSchedule">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPEmergencyLocListDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="SSGRPEnableSystemCT">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPFirstMenu">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPFirstMenuType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPFloorPlanDisplayOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPHealthPromLocListDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPIgnoreOrderRestrictions">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPInPatLocListDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SSGRPInPatTransferListDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPInactivityTimeOut">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPJobOE">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPLocMandatoryPOInquiry">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPLocMandatoryPOSearch">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPMainAnaestIsntMandOT">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPMainSurgeonIsNotMandOT">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPMaxPOAmount">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SSGRPMinimizeOEUpdate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPMoveToDefaultBed">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNAllAddPastAppt">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNAllORBookNA">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNAllORBookNoSess">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNAllORBookPast">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNoDisplayReasonStAdj">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNoDisplayReasonStCons">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNoDisplayReasonStDisp">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNoRestrictUserSameGroupOE">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNotBookOutSess">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPNotExcLoadLevelOverrides">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPOEDontSkipUponUDFReject">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPOPLocListDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SSGRPOnePOforEveryVendor">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPOnlyInpatUnitsForMyHospita">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPOnlyOutpatUnitsForMyHospit">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPOrdersPrevEpisode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPOutPatLocListDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="SSGRPPasswordDaysToExpire">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPPrice">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRadLocList">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRestrictApptRadOrders">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRestrictLocForGrHospitals">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRestrictMRTypeCurrHosp">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRestrictModifDischarge">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SSGRPRestrictSearchEMR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRestrictWardsToDepartment">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRetainOrderCategory">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRingWardFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRoundingAutomatic">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPRoundingOnPayment">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPSecurityLevel">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPSelectAllEpisodesEMR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPShowAllLocations">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPShowAllPatientsInNWB">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPShowAllergyDSSQA">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPShowMIC">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPShowOnlyIPUnitsForWL">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPShowPatientSearch">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPShowPreadmafterAppoint">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPSuppressPin">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPTempPatLocList">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="SSGRPUpdateOrderDetails">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPUserPOReferenceNotMandator">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPWLAuditLetterDays">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPWLStatusListDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SSGRPWaitListLocListDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPWaitListStatusDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPWardAttendLocListDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SSGRPWardPlaceLocListDR">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="SSGRPWardViewLocListDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="SSGRPWarnFutureAppt">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SSGRPWarnORBookingMoveRes">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^SSU("SSGRP"))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSGRP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSGRP_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSGRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSGRP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSGRP_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSGRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroupDr">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSGRP_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GroupDr"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSGRP_Group_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSGRP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterGROUPS">
<Data name="SSGRP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>151</Piece>
</Data>
<Data name="SSGRP_AllocateOrderToBatch">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="SSGRP_AllowActivateVolume">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="SSGRP_AllowAddStockItem">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SSGRP_AllowAdmitAllInPatPreAdm">
<Delimiter>"^"</Delimiter>
<Piece>141</Piece>
</Data>
<Data name="SSGRP_AllowBookOutsideRange">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SSGRP_AllowBookPastGuarDateOP">
<Delimiter>"^"</Delimiter>
<Piece>148</Piece>
</Data>
<Data name="SSGRP_AllowBookPastGuarDateWL">
<Delimiter>"^"</Delimiter>
<Piece>149</Piece>
</Data>
<Data name="SSGRP_AllowChangeDepOT">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="SSGRP_AllowDeleteBedTransactions">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="SSGRP_AllowDeleteDiagOtherUs">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="SSGRP_AllowDeleteEpisode">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SSGRP_AllowDiscOrdPackedPres">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="SSGRP_AllowDiscPaidOrder">
<Delimiter>"^"</Delimiter>
<Piece>119</Piece>
</Data>
<Data name="SSGRP_AllowEditEpLogLoc">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="SSGRP_AllowEditHelp">
<Delimiter>"^"</Delimiter>
<Piece>150</Piece>
</Data>
<Data name="SSGRP_AllowEditPriceGR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="SSGRP_AllowEditWLStatusTreated">
<Delimiter>"^"</Delimiter>
<Piece>129</Piece>
</Data>
<Data name="SSGRP_AllowIssueArchiveMR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SSGRP_AllowMultipleServAdhoc">
<Delimiter>"^"</Delimiter>
<Piece>122</Piece>
</Data>
<Data name="SSGRP_AllowNewMRTypesPat">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="SSGRP_AllowOSFEdit24hrs">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="SSGRP_AllowOverBookOnSlotZero">
<Delimiter>"^"</Delimiter>
<Piece>104</Piece>
</Data>
<Data name="SSGRP_AllowOverBookRB">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SSGRP_AllowOverPayorRestrict">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SSGRP_AllowSendMsgAll">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="SSGRP_AllowToAddItemToLocPortfolio">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SSGRP_AllowToAddItemToVendPortfolio">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SSGRP_AllowToChangeAgrPrice">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SSGRP_AllowToChangeFamilyDoctor">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SSGRP_AllowToChangeOEStatus">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="SSGRP_AllowToExecuteOrderOutsideShift">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SSGRP_AllowUndoAppt">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="SSGRP_AllowViewVIPPatients">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="SSGRP_AllowWebColumnManager">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="SSGRP_AllowWebLayoutManager">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="SSGRP_AllowedAddOrdersReview">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSGRP_AllowedSeeSEnsitRes">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="SSGRP_AllowedSeeSensitAntib">
<Delimiter>"^"</Delimiter>
<Piece>115</Piece>
</Data>
<Data name="SSGRP_AllowedSeeSensitOrd">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="SSGRP_AllowedtoBookOR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SSGRP_AnMethodIsntMandOT">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="SSGRP_ApptAutofind">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="SSGRP_ApptPast">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="SSGRP_AutoMedDischarge">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="SSGRP_CashierCustomPrintRcpt">
<Delimiter>"^"</Delimiter>
<Piece>145</Piece>
</Data>
<Data name="SSGRP_ChangeDataAfterDischarge">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SSGRP_CheckApproved">
<Delimiter>"^"</Delimiter>
<Piece>133</Piece>
</Data>
<Data name="SSGRP_CheckOrdersCovered">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SSGRP_ChkFutureAppts">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="SSGRP_ClinicalLocListDr">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="SSGRP_ClosePatList1PatReturned">
<Delimiter>"^"</Delimiter>
<Piece>137</Piece>
</Data>
<Data name="SSGRP_Code">
<Delimiter>"^"</Delimiter>
<Piece>152</Piece>
</Data>
<Data name="SSGRP_ConsReasonMandatory">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="SSGRP_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>157</Piece>
</Data>
<Data name="SSGRP_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>158</Piece>
</Data>
<Data name="SSGRP_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>156</Piece>
</Data>
<Data name="SSGRP_CumAcrossAllEpisodes">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="SSGRP_CumAllowedSeeGraphLink">
<Delimiter>"^"</Delimiter>
<Piece>102</Piece>
</Data>
<Data name="SSGRP_CumIncludeRPrefix">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="SSGRP_CumNoColumns">
<Delimiter>"^"</Delimiter>
<Piece>103</Piece>
</Data>
<Data name="SSGRP_CumRefRangePosition">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="SSGRP_DFLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="SSGRP_DefaultDoseEquiv">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SSGRP_DefaultPOReference_DR">
<Delimiter>"^"</Delimiter>
<Piece>136</Piece>
</Data>
<Data name="SSGRP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSGRP_DiaryEndTime">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="SSGRP_DiarySlotLength">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="SSGRP_DiaryStartTime">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="SSGRP_DisableAddAll">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="SSGRP_DisableFindStAdj">
<Delimiter>"^"</Delimiter>
<Piece>126</Piece>
</Data>
<Data name="SSGRP_DisableFindStCons">
<Delimiter>"^"</Delimiter>
<Piece>127</Piece>
</Data>
<Data name="SSGRP_DisableFindStDisp">
<Delimiter>"^"</Delimiter>
<Piece>128</Piece>
</Data>
<Data name="SSGRP_DischargeLocList">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="SSGRP_DiscontinueExecOrders">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="SSGRP_DisplayDiagnProcDRG">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SSGRP_DisplayDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SSGRP_DisplayOEfromRBAfterAp">
<Delimiter>"^"</Delimiter>
<Piece>111</Piece>
</Data>
<Data name="SSGRP_DisplayPatmanActiveCWB">
<Delimiter>"^"</Delimiter>
<Piece>113</Piece>
</Data>
<Data name="SSGRP_DisplayQnsOnAlertScreen">
<Delimiter>"^"</Delimiter>
<Piece>106</Piece>
</Data>
<Data name="SSGRP_DisplayQnsOnSumScreen">
<Delimiter>"^"</Delimiter>
<Piece>107</Piece>
</Data>
<Data name="SSGRP_DisplayServiceDetails">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="SSGRP_DoNotClearPatManUponUpdate">
<Delimiter>"^"</Delimiter>
<Piece>139</Piece>
</Data>
<Data name="SSGRP_DoNotUpdateDOCTORWithLinkedCP">
<Delimiter>"^"</Delimiter>
<Piece>138</Piece>
</Data>
<Data name="SSGRP_DontBookOutsideOTSchedule">
<Delimiter>"^"</Delimiter>
<Piece>142</Piece>
</Data>
<Data name="SSGRP_EmergencyLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SSGRP_EnableSystemCT">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SSGRP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>154</Piece>
</Data>
<Data name="SSGRP_FirstMenu">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSGRP_FirstMenuType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSGRP_FloorPlanDisplayOnly">
<Delimiter>"^"</Delimiter>
<Piece>147</Piece>
</Data>
<Data name="SSGRP_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>166</Piece>
</Data>
<Data name="SSGRP_HealthPromLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SSGRP_IgnoreOrderRestrictions">
<Delimiter>"^"</Delimiter>
<Piece>108</Piece>
</Data>
<Data name="SSGRP_InPatLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SSGRP_InPatTransferList_DR">
<Delimiter>"^"</Delimiter>
<Piece>132</Piece>
</Data>
<Data name="SSGRP_InactivityTimeOut">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="SSGRP_JobOE">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="SSGRP_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>160</Piece>
</Data>
<Data name="SSGRP_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>161</Piece>
</Data>
<Data name="SSGRP_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>162</Piece>
</Data>
<Data name="SSGRP_LocMandatoryPOInquiry">
<Delimiter>"^"</Delimiter>
<Piece>130</Piece>
</Data>
<Data name="SSGRP_LocMandatoryPOSearch">
<Delimiter>"^"</Delimiter>
<Piece>131</Piece>
</Data>
<Data name="SSGRP_MainAnaestIsntMandOT">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="SSGRP_MainSurgeonIsNotMandOT">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="SSGRP_Mark">
<Delimiter>"^"</Delimiter>
<Piece>165</Piece>
</Data>
<Data name="SSGRP_MaxPOAmount">
<Delimiter>"^"</Delimiter>
<Piece>116</Piece>
</Data>
<Data name="SSGRP_MinimizeOEUpdate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSGRP_MoveToDefaultBed">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SSGRP_NAllAddPastAppt">
<Delimiter>"^"</Delimiter>
<Piece>117</Piece>
</Data>
<Data name="SSGRP_NAllORBookNA">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SSGRP_NAllORBookNoSess">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SSGRP_NAllORBookPast">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SSGRP_NoDisplayReasonStAdj">
<Delimiter>"^"</Delimiter>
<Piece>123</Piece>
</Data>
<Data name="SSGRP_NoDisplayReasonStCons">
<Delimiter>"^"</Delimiter>
<Piece>124</Piece>
</Data>
<Data name="SSGRP_NoDisplayReasonStDisp">
<Delimiter>"^"</Delimiter>
<Piece>125</Piece>
</Data>
<Data name="SSGRP_NoRestrictUserSameGroupOE">
<Delimiter>"^"</Delimiter>
<Piece>121</Piece>
</Data>
<Data name="SSGRP_NotBookOutSess">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="SSGRP_NotExcLoadLevelOverrides">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="SSGRP_OEDontSkipUponUDFReject">
<Delimiter>"^"</Delimiter>
<Piece>140</Piece>
</Data>
<Data name="SSGRP_OPLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>118</Piece>
</Data>
<Data name="SSGRP_OnePOforEveryVendor">
<Delimiter>"^"</Delimiter>
<Piece>134</Piece>
</Data>
<Data name="SSGRP_OnlyInpatUnitsForMyHospital">
<Delimiter>"^"</Delimiter>
<Piece>110</Piece>
</Data>
<Data name="SSGRP_OnlyOutpatUnitsForMyHospital">
<Delimiter>"^"</Delimiter>
<Piece>109</Piece>
</Data>
<Data name="SSGRP_OrdersPrevEpisode">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SSGRP_OutPatLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SSGRP_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>163</Piece>
</Data>
<Data name="SSGRP_PasswordDaysToExpire">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="SSGRP_Price">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SSGRP_RadLocList">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="SSGRP_RestrictApptRadOrders">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="SSGRP_RestrictLocForGrHospitals">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="SSGRP_RestrictMRTypeCurrHosp">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="SSGRP_RestrictModifDischarge">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="SSGRP_RestrictSearchEMR">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="SSGRP_RestrictWardsToDepartment">
<Delimiter>"^"</Delimiter>
<Piece>120</Piece>
</Data>
<Data name="SSGRP_RetainOrderCategory">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSGRP_RingWardFlag">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="SSGRP_RoundingAutomatic">
<Delimiter>"^"</Delimiter>
<Piece>144</Piece>
</Data>
<Data name="SSGRP_RoundingOnPayment">
<Delimiter>"^"</Delimiter>
<Piece>143</Piece>
</Data>
<Data name="SSGRP_SecurityLevel">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="SSGRP_SelectAllEpisodesEMR">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="SSGRP_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>159</Piece>
</Data>
<Data name="SSGRP_ShowAllLocations">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SSGRP_ShowAllPatientsInNWB">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SSGRP_ShowAllergy_DSS_QA">
<Delimiter>"^"</Delimiter>
<Piece>105</Piece>
</Data>
<Data name="SSGRP_ShowMIC">
<Delimiter>"^"</Delimiter>
<Piece>146</Piece>
</Data>
<Data name="SSGRP_ShowOnlyIPUnitsForWL">
<Delimiter>"^"</Delimiter>
<Piece>114</Piece>
</Data>
<Data name="SSGRP_ShowPatientSearch">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SSGRP_ShowPreadmafterAppoint">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SSGRP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>153</Piece>
</Data>
<Data name="SSGRP_SuppressPin">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SSGRP_TempPatLocList">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="SSGRP_UpdateOrderDetails">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="SSGRP_UserPOReferenceNotMandatory">
<Delimiter>"^"</Delimiter>
<Piece>135</Piece>
</Data>
<Data name="SSGRP_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>164</Piece>
</Data>
<Data name="SSGRP_WLAuditLetterDays">
<Delimiter>"^"</Delimiter>
<Piece>112</Piece>
</Data>
<Data name="SSGRP_WLStatusList_DR">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="SSGRP_WaitListLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="SSGRP_WaitListStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SSGRP_WardAttendLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="SSGRP_WardPlaceLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="SSGRP_WardViewLocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SSGRP_WarnFutureAppt">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="SSGRP_WarnORBookingMoveRes">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSGRP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{SSGRP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SSGRP_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
