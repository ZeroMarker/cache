/// SS Users                (SSUSR,321)
Class User.SSUser Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = SS_User, StorageStrategy = SQLStorage ]
{

Relationship ChildSSUserOrderCategory As SSUserOrderCategory [ Cardinality = children, Inverse = ORCATParRef ];

Relationship ChildSSUserOrderStatus As SSUserOrderStatus [ Cardinality = children, Inverse = OSTATParRef ];

Relationship ChildSSUserReports As SSUserReports [ Cardinality = children, Inverse = USREPParRef ];

Relationship ChildSSUserWindow As SSUserWindow [ Cardinality = children, Inverse = WINParRef ];

Relationship ChildSSUserWindowDefault As SSUserWindowDefault [ Cardinality = children, Inverse = WINDParRef ];

Relationship ChildSSUserDepartFunction As SSUserDepartFunction [ Cardinality = children, Inverse = DFParRef ];

Relationship ChildSSUserCrystalReports As SSUserCrystalReports [ Cardinality = children, Inverse = CRYSTParRef ];

Relationship ChildSSUserSettings As SSUserSettings [ Cardinality = children, Inverse = SETParRef ];

Relationship ChildSSUserAvailDoctors As SSUserAvailDoctors [ Cardinality = children, Inverse = DOCParRef ];

Relationship ChildSSUserInsurance As SSUserInsurance [ Cardinality = children, Inverse = INSParRef ];

Relationship ChildSSUserPassword As SSUserPassword [ Cardinality = children, Inverse = PASSParRef ];

Relationship ChildSSUserGroups As SSUserGroups [ Cardinality = children, Inverse = GRPParRef ];

Relationship ChildSSUserAppointment As SSUserAppointment [ Cardinality = children, Inverse = APPTParRef ];

Relationship ChildSSUserOtherLogonLoc As SSUserOtherLogonLoc [ Cardinality = children, Inverse = OTHLLParRef ];

Relationship ChildSSUserRound As SSUserRound [ Cardinality = children, Inverse = RNDParRef ];

Relationship ChildSSUserExtSysCodes As SSUserExtSysCodes [ Cardinality = children, Inverse = EXTParRef ];

Relationship ChildSSUserPACLogons As SSUserPACLogons [ Cardinality = children, Inverse = PACParRef ];

Relationship ChildHOSUserAccountPost As HOSUserAccountPost [ Cardinality = children, Inverse = USERPOSTParRef ];

/// 账户代码
Property SSUSRInitials As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = SSUSR_Initials ];

/// 账户名称
Property SSUSRName As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SSUSR_Name ];

/// SSUSR_Password
Property SSUSRPassword As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SSUSR_Password ];

/// DEs Ref to CTLOC
Property SSUSRDefaultDeptDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = SSUSR_DefaultDept_DR ];

/// Is this a Doctor?
Property SSUSRIsThisDoctor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SSUSR_IsThisDoctor ];

/// Use Department As Default
Property SSUSRUseDeptAsDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = SSUSR_UseDeptAsDefault ];

/// Des Ref to CTPCP
Property SSUSRCTPCPDR As CTCareProv [ SqlColumnNumber = 11, SqlFieldName = SSUSR_CTPCP_DR ];

/// Security Group for the User 20221014去掉必填
Property SSUSRGroup As SSGroup [ SqlColumnNumber = 13, SqlFieldName = SSUSR_Group ];

/// User allowed to change location flag
Property SSUSRChangeLocation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = SSUSR_ChangeLocation ];

/// Name on E Mail system
Property SSUSREMailName As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = SSUSR_EMailName ];

/// Department / Location for EMR lists
Property SSUSRDeptforEMRLists As CTLoc [ SqlColumnNumber = 16, SqlFieldName = SSUSR_DeptforEMRLists ];

/// Des Ref to CTLAN
Property SSUSRCTLANDR As SSLanguage [ SqlColumnNumber = 17, SqlFieldName = SSUSR_CTLAN_DR ];

/// Des Ref to Care Provider
Property SSUSRCareProvDR As CTCareProv [ SqlColumnNumber = 18, SqlFieldName = SSUSR_CareProv_DR ];

/// Pin Number
Property SSUSRPin As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = SSUSR_Pin ];

/// Privilege for Stock
Property SSUSRPrivilegeStock As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = SSUSR_PrivilegeStock ];

/// Retain Order Category
Property SSUSRRetainOrderCategory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = SSUSR_RetainOrderCategory ];

/// Des Ref PAADM
Property SSUSRLastPAADMDR As PAAdm [ SqlColumnNumber = 22, SqlFieldName = SSUSR_LastPAADM_DR ];

/// 是否有效(Y/N)
Property SSUSRActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 23, SqlFieldName = SSUSR_Active ];

/// DRG Tariff Visible
Property SSUSRDRGTariffVisible As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = SSUSR_DRGTariffVisible ];

/// Des Ref BillSequence
Property SSUSRBillSequenceDR As BLCBillSequence [ SqlColumnNumber = 25, SqlFieldName = SSUSR_BillSequence_DR ];

/// Search All Admisions for Orders
Property SSUSRSearchAllAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = SSUSR_SearchAllAdm ];

/// Inpatient
Property SSUSRInpatient As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = SSUSR_Inpatient ];

/// Outpatient
Property SSUSROutpatient As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = SSUSR_Outpatient ];

/// Emergency
Property SSUSREmergency As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = SSUSR_Emergency ];

/// Own Patients Only
Property SSUSROwnPatientsOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = SSUSR_OwnPatientsOnly ];

/// Des Ref LocList
Property SSUSRLocListDR As CTLocationList [ SqlColumnNumber = 31, SqlFieldName = SSUSR_LocList_DR ];

/// Auto Authorise
Property SSUSRAutoAuthorise As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 32, SqlFieldName = SSUSR_AutoAuthorise ];

/// Des Ref ARCIM_DR
Property SSUSRDefaultARCIMDR As ARCItmMast [ SqlColumnNumber = 33, SqlFieldName = SSUSR_DefaultARCIM_DR ];

/// Des REf Department
Property SSUSRDefRBDepartmentDR As CTLoc [ SqlColumnNumber = 34, SqlFieldName = SSUSR_DefRBDepartment_DR ];

/// Des RBResource
Property SSUSRDefRBResourceDR As RBResource [ SqlColumnNumber = 35, SqlFieldName = SSUSR_DefRBResource_DR ];

/// DEs REf DefRBService
Property SSUSRDefRBServiceDR As RBCServices [ SqlColumnNumber = 36, SqlFieldName = SSUSR_DefRBService_DR ];

/// Use default EpisodeDep for RB
Property SSUSRDefEpisode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = SSUSR_DefEpisode ];

/// Link To Bed Management
Property SSUSRLinkToBedManagement As %String(DISPLAYLIST = ",Default Episode Department,Use Current Value", MAXLEN = 26, TRUNCATE = 1, VALUELIST = ",E,C") [ SqlColumnNumber = 38, SqlFieldName = SSUSR_LinkToBedManagement ];

/// Use Default Epis Dep (for pat registration)
Property SSUSRUseDefaultEpisDep As %String(DISPLAYLIST = ",Login Location,Location List", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",LOG,LIST") [ SqlColumnNumber = 39, SqlFieldName = SSUSR_UseDefaultEpisDep ];

/// Warn if user moves ORBooking to another Res
Property SSUSRWarnORBookingMoveRes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = SSUSR_WarnORBookingMoveRes ];

/// Do Not Allow OR Bookings in Past
Property SSUSRNAllORBookPast As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = SSUSR_NAllORBookPast ];

/// Do Not Allow ORBooking in Non Session area
Property SSUSRNAllORBookNoSess As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 43, SqlFieldName = SSUSR_NAllORBookNoSess ];

/// Do Not Allow ORBookings in Not Avail area
Property SSUSRNAllORBookNA As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 44, SqlFieldName = SSUSR_NAllORBookNA ];

/// Always Use Soundex
Property SSUSRAlwaysUseSoundex As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = SSUSR_AlwaysUseSoundex ];

/// RB Number Of Rows
Property SSUSRRBNumberOfRows As %Float [ SqlColumnNumber = 46, SqlFieldName = SSUSR_RBNumberOfRows ];

/// Multi Select Rows
Property SSUSRMultiSelectRows As %Float [ SqlColumnNumber = 47, SqlFieldName = SSUSR_MultiSelectRows ];

/// Password Date
Property SSUSRPasswordDate As %Date [ SqlColumnNumber = 48, SqlFieldName = SSUSR_PasswordDate ];

/// Date Last Login
Property SSUSRDateLastLogin As %Date [ SqlColumnNumber = 49, SqlFieldName = SSUSR_DateLastLogin ];

/// Time Last Login
Property SSUSRTimeLastLogin As %Time [ SqlColumnNumber = 50, SqlFieldName = SSUSR_TimeLastLogin ];

/// Default Date From to Today
Property SSUSRDateFromToday As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 51, SqlFieldName = SSUSR_DateFromToday ];

/// Default Date To to Today
Property SSUSRDateToToday As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 52, SqlFieldName = SSUSR_DateToToday ];

/// Des Ref RefHosp
Property SSUSRDefRefHospDR As CTRefClin [ SqlColumnNumber = 53, SqlFieldName = SSUSR_DefRefHosp_DR ];

/// Res Entry Buttons
Property SSUSRResEntryButtons As %String(DISPLAYLIST = ",OK,OK & Verify,Both", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",O,V,B") [ SqlColumnNumber = 54, SqlFieldName = SSUSR_ResEntryButtons ];

/// Default Res Entry Buttons
Property SSUSRDefaultResEntryButtons As %String(DISPLAYLIST = ",OK,OK & Verify", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",O,V") [ SqlColumnNumber = 55, SqlFieldName = SSUSR_DefaultResEntryButtons ];

/// Default Date in OE
Property SSUSRDefDateinOE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = SSUSR_DefDateinOE ];

/// Def Date In Discharge form
Property SSUSRDefDateInDisch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = SSUSR_DefDateInDisch ];

/// Disable EMR for Preadmission
Property SSUSRDisableEMRPreadm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = SSUSR_DisableEMRPreadm ];

/// Search Prev Adm for Order Entry
Property SSUSRSearchPrevAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 59, SqlFieldName = SSUSR_SearchPrevAdm ];

/// NoOrders
Property SSUSRNoOrders As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 60, SqlFieldName = SSUSR_NoOrders ];

/// No EMR flag
Property SSUSRNoEMR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 61, SqlFieldName = SSUSR_NoEMR ];

/// NoDiagnosis
Property SSUSRNoDiagnosis As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 62, SqlFieldName = SSUSR_NoDiagnosis ];

/// Web Security Access
Property SSUSRWebSecurityAccess As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 63, SqlFieldName = SSUSR_WebSecurityAccess ];

/// Des Ref EpisSubType
Property SSUSREpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 64, SqlFieldName = SSUSR_EpisSubType_DR ];

/// Not Read Results
Property SSUSRNotReadResults As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = SSUSR_NotReadResults ];

/// Restrict Modification after Discharge
Property SSUSRRestrictModifDischarge As %String(DISPLAYLIST = ",No Changes Permitted,Care provider only,Linked Care Providers", MAXLEN = 21, TRUNCATE = 1, VALUELIST = ",N,CP,LC") [ SqlColumnNumber = 66, SqlFieldName = SSUSR_RestrictModifDischarge ];

/// Booked
Property SSUSRBooked As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 67, SqlFieldName = SSUSR_Booked ];

/// Admitted
Property SSUSRAdmitted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 68, SqlFieldName = SSUSR_Admitted ];

/// Discharged
Property SSUSRDischarged As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 69, SqlFieldName = SSUSR_Discharged ];

/// Default Care Prov
Property SSUSRDefaultCareProv As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 70, SqlFieldName = SSUSR_DefaultCareProv ];

/// Default Location
Property SSUSRDefaultLocation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 71, SqlFieldName = SSUSR_DefaultLocation ];

/// Password Changed
Property SSUSRPasswordChanged As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 72, SqlFieldName = SSUSR_PasswordChanged ];

/// Title
Property SSUSRTitle As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 73, SqlFieldName = SSUSR_Title ];

/// Surname
Property SSUSRSurname As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 74, SqlFieldName = SSUSR_Surname ];

/// GivenName
Property SSUSRGivenName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 75, SqlFieldName = SSUSR_GivenName ];

/// OtherName
Property SSUSROtherName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 76, SqlFieldName = SSUSR_OtherName ];

/// DepartmentHead
Property SSUSRDepartmentHead As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = SSUSR_DepartmentHead ];

/// PayrollNumber
Property SSUSRPayrollNumber As %Float [ SqlColumnNumber = 78, SqlFieldName = SSUSR_PayrollNumber ];

/// Des Ref StaffType
Property SSUSRStaffTypeDR As CTStaffType [ SqlColumnNumber = 79, SqlFieldName = SSUSR_StaffType_DR ];

/// Comments
Property SSUSRComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 80, SqlFieldName = SSUSR_Comments, SqlListType = SUBNODE ];

/// 系统最新更新人
Property SSUSRLastUpdateUserDR As SSUser [ SqlColumnNumber = 81, SqlFieldName = SSUSR_LastUpdateUser_DR ];

/// 系统最新更新日期
Property SSUSRLastUpdateDate As %Date [ SqlColumnNumber = 82, SqlFieldName = SSUSR_LastUpdateDate ];

/// 系统最新更新时间
Property SSUSRLastUpdateTime As %Time [ SqlColumnNumber = 83, SqlFieldName = SSUSR_LastUpdateTime ];

/// DoctorFlag
Property SSUSRDoctorFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = SSUSR_DoctorFlag ];

/// NurseFlag
Property SSUSRNurseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 85, SqlFieldName = SSUSR_NurseFlag ];

/// SecurityMsgRead
Property SSUSRSecurityMsgRead As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 86, SqlFieldName = SSUSR_SecurityMsgRead ];

/// SecurityMessage
Property SSUSRSecurityMessage As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 87, SqlFieldName = SSUSR_SecurityMessage, SqlListType = SUBNODE ];

/// LoginID
Property SSUSRLoginID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 88, SqlFieldName = SSUSR_LoginID ];

/// LoginRound
Property SSUSRLoginRound As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = SSUSR_LoginRound ];

/// Default All Resources
Property SSUSRDefAllResources As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 90, SqlFieldName = SSUSR_DefAllResources ];

/// Def Appt Slots
Property SSUSRDefApptSlots As %String(DISPLAYLIST = ",Same Time,Consecutive Times,All Times", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",ST,CT,AT") [ SqlColumnNumber = 91, SqlFieldName = SSUSR_DefApptSlots ];

/// SDefUseStartTimeEachday
Property SSUSRDefUseStartTimeEachday As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 92, SqlFieldName = SSUSR_DefUseStartTimeEachday ];

/// Des Ref AppointMeth
Property SSUSRDefAppointMethDR As RBCAppointMethod [ SqlColumnNumber = 93, SqlFieldName = SSUSR_DefAppointMeth_DR ];

/// Des REf Title
Property SSUSRTitleDR As CTTitle [ SqlColumnNumber = 94, SqlFieldName = SSUSR_Title_DR ];

/// Registration Number
Property SSUSRRegistrationNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 95, SqlFieldName = SSUSR_RegistrationNumber ];

/// Print Security Level
Property SSUSRPrintSecurityLevel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 96, SqlFieldName = SSUSR_PrintSecurityLevel ];

/// Des Ref LastUpdateUserHosp
Property SSUSRLastUpdateUserHospDR As CTHospital [ SqlColumnNumber = 97, SqlFieldName = SSUSR_LastUpdateUserHosp_DR ];

/// Only Change Loc Within Logon Hospital
Property SSUSRChangeLocWithinLogHosp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 98, SqlFieldName = SSUSR_ChangeLocWithinLogHosp ];

/// Not Allow To Overbook
Property SSUSRNotAllowToOverbook As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 99, SqlFieldName = SSUSR_NotAllowToOverbook ];

/// Mark Inactive Date
Property SSUSRMarkInactiveDate As %Date [ SqlColumnNumber = 100, SqlFieldName = SSUSR_MarkInactiveDate ];

/// Mark Inactive Time
Property SSUSRMarkInactiveTime As %Time [ SqlColumnNumber = 101, SqlFieldName = SSUSR_MarkInactiveTime ];

/// Des Ref MarkInactiveUser
Property SSUSRMarkInactiveUserDR As SSUser [ SqlColumnNumber = 102, SqlFieldName = SSUSR_MarkInactiveUser_DR ];

/// Date From
Property SSUSRDateFrom As %Date [ SqlColumnNumber = 103, SqlFieldName = SSUSR_DateFrom ];

/// Date To
Property SSUSRDateTo As %Date [ SqlColumnNumber = 104, SqlFieldName = SSUSR_DateTo ];

/// Des Ref Hospital
Property SSUSRHospitalDR As CTHospital [ SqlColumnNumber = 105, SqlFieldName = SSUSR_Hospital_DR ];

/// Mobile
Property SSUSRMobile As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 106, SqlFieldName = SSUSR_Mobile ];

/// Pager
Property SSUSRPager As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 107, SqlFieldName = SSUSR_Pager ];

/// Email
Property SSUSREmail As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 108, SqlFieldName = SSUSR_Email ];

/// LocationNotMandatoryOnResEntry
Property SSUSRLocationNotMandatoryOnResE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 109, SqlFieldName = SSUSR_LocationNotMandatoryOnResEntry ];

/// Time Since Last Appt
Property SSUSRTimeSinceLastAppt As %Float [ SqlColumnNumber = 110, SqlFieldName = SSUSR_TimeSinceLastAppt ];

/// Time Since Period
Property SSUSRTimeSincePeriod As %String(DISPLAYLIST = ",Days,Months,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 111, SqlFieldName = SSUSR_TimeSincePeriod ];

/// Name1
Property SSUSRName1 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 112, SqlFieldName = SSUSR_Name1 ];

/// Name2
Property SSUSRName2 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 113, SqlFieldName = SSUSR_Name2 ];

/// Name3
Property SSUSRName3 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 114, SqlFieldName = SSUSR_Name3 ];

/// IEPath
Property SSUSRIEPath As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 115, SqlFieldName = SSUSR_IEPath ];

/// ExternalUserIdentifier
Property SSUSRExternalUserIdentifier As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 116, SqlFieldName = SSUSR_ExternalUserIdentifier ];

/// CashierShift
Property SSUSRCashierShift As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 117, SqlFieldName = SSUSR_CashierShift ];

/// BioKey
Property SSUSRBioKey As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 118, SqlFieldName = SSUSR_BioKey ];

/// BioMode
Property SSUSRBioMode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 119, SqlFieldName = SSUSR_BioMode ];

/// DisclaimerSigned
Property SSUSRDisclaimerSigned As %Date [ SqlColumnNumber = 120, SqlFieldName = SSUSR_DisclaimerSigned ];

/// 系统创建人
Property SSUSRCreatedByDR As SSUser [ SqlColumnNumber = 121, SqlFieldName = SSUSR_CreatedBy_DR ];

/// 系统创建日期
Property SSUSRCreatedDate As %Date [ SqlColumnNumber = 122, SqlFieldName = SSUSR_CreatedDate ];

/// 系统创建时间
Property SSUSRCreatedTime As %Time [ SqlColumnNumber = 123, SqlFieldName = SSUSR_CreatedTime ];

/// YesNo1
Property SSUSRYesNo1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 124, SqlFieldName = SSUSR_YesNo1 ];

/// YesNo2
Property SSUSRYesNo2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 125, SqlFieldName = SSUSR_YesNo2 ];

/// YesNo3
Property SSUSRYesNo3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 126, SqlFieldName = SSUSR_YesNo3 ];

/// YesNo4
Property SSUSRYesNo4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 127, SqlFieldName = SSUSR_YesNo4 ];

/// YesNo5
Property SSUSRYesNo5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 128, SqlFieldName = SSUSR_YesNo5 ];

/// FreeText1
Property SSUSRFreeText1 As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 129, SqlFieldName = SSUSR_FreeText1 ];

/// FreeText2
Property SSUSRFreeText2 As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 130, SqlFieldName = SSUSR_FreeText2 ];

/// FreeText3
Property SSUSRFreeText3 As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 131, SqlFieldName = SSUSR_FreeText3 ];

/// AllowWebLayoutManager
Property SSUSRAllowWebLayoutManager As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 132, SqlFieldName = SSUSR_AllowWebLayoutManager ];

/// AllowWebColumnManager
Property SSUSRAllowWebColumnManager As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 133, SqlFieldName = SSUSR_AllowWebColumnManager ];

/// SSUSR IgnoreCALogon
Property SSUSRIgnoreCALogon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 134, SqlFieldName = SSUSR_IgnoreCALogon ];

/// 人员唯一标识码 外键 add@20220923
Property SSUSRHOSPersonDR As CT.BDP.CT.HOSPerson [ SqlColumnNumber = 135, SqlFieldName = SSUSR_HOSPerson_DR ];

/// 系统排序号
Property SSUSRSeqNo As %Float [ SqlColumnNumber = 136, SqlFieldName = SSUSR_SeqNo ];

/// 拼音码
Property SSUSRPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 137, SqlFieldName = SSUSR_PYCode ];

/// 五笔码
Property SSUSRWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 138, SqlFieldName = SSUSR_WBCode ];

/// 备注
Property SSUSRMark As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 139, SqlFieldName = SSUSR_Mark ];

Index SSUSRInitialsUnqIdx1 On SSUSRInitials [ Unique ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUser).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUser","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUser).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUser","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUser).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUser","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUser).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUser","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUser","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUser).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSUser","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^SSU("SSUSR",0))</SqlIdExpression>
<SQLMap name="DataMasterSSUSR">
<Data name="SSUSR_Active">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="SSUSR_Admitted">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="SSUSR_AllowWebColumnManager">
<Delimiter>"^"</Delimiter>
<Piece>126</Piece>
</Data>
<Data name="SSUSR_AllowWebLayoutManager">
<Delimiter>"^"</Delimiter>
<Piece>125</Piece>
</Data>
<Data name="SSUSR_AlwaysUseSoundex">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="SSUSR_AutoAuthorise">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="SSUSR_BillSequence_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="SSUSR_BioKey">
<Delimiter>"^"</Delimiter>
<Piece>111</Piece>
</Data>
<Data name="SSUSR_BioMode">
<Delimiter>"^"</Delimiter>
<Piece>112</Piece>
</Data>
<Data name="SSUSR_Booked">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="SSUSR_CTLAN_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SSUSR_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SSUSR_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SSUSR_CashierShift">
<Delimiter>"^"</Delimiter>
<Piece>110</Piece>
</Data>
<Data name="SSUSR_ChangeLocWithinLogHosp">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="SSUSR_ChangeLocation">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SSUSR_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="SSUSR_CreatedBy_DR">
<Delimiter>"^"</Delimiter>
<Piece>114</Piece>
</Data>
<Data name="SSUSR_CreatedDate">
<Delimiter>"^"</Delimiter>
<Piece>115</Piece>
</Data>
<Data name="SSUSR_CreatedTime">
<Delimiter>"^"</Delimiter>
<Piece>116</Piece>
</Data>
<Data name="SSUSR_DRGTariffVisible">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="SSUSR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="SSUSR_DateFromToday">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="SSUSR_DateLastLogin">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="SSUSR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="SSUSR_DateToToday">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="SSUSR_DefAllResources">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="SSUSR_DefAppointMeth_DR">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="SSUSR_DefApptSlots">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="SSUSR_DefDateInDisch">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="SSUSR_DefDateinOE">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="SSUSR_DefEpisode">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="SSUSR_DefRBDepartment_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="SSUSR_DefRBResource_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="SSUSR_DefRBService_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="SSUSR_DefRefHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="SSUSR_DefUseStartTimeEachday">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="SSUSR_DefaultARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="SSUSR_DefaultCareProv">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="SSUSR_DefaultDept_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSUSR_DefaultLocation">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="SSUSR_DefaultResEntryButtons">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="SSUSR_DepartmentHead">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="SSUSR_DeptforEMRLists">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SSUSR_DisableEMRPreadm">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="SSUSR_Discharged">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="SSUSR_DisclaimerSigned">
<Delimiter>"^"</Delimiter>
<Piece>113</Piece>
</Data>
<Data name="SSUSR_DoctorFlag">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="SSUSR_EMailName">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SSUSR_Email">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="SSUSR_Emergency">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="SSUSR_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="SSUSR_ExternalUserIdentifier">
<Delimiter>"^"</Delimiter>
<Piece>109</Piece>
</Data>
<Data name="SSUSR_FreeText1">
<Delimiter>"^"</Delimiter>
<Piece>122</Piece>
</Data>
<Data name="SSUSR_FreeText2">
<Delimiter>"^"</Delimiter>
<Piece>123</Piece>
</Data>
<Data name="SSUSR_FreeText3">
<Delimiter>"^"</Delimiter>
<Piece>124</Piece>
</Data>
<Data name="SSUSR_GivenName">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="SSUSR_Group">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSUSR_HOSPerson_DR">
<Delimiter>"^"</Delimiter>
<Piece>128</Piece>
</Data>
<Data name="SSUSR_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="SSUSR_IEPath">
<Delimiter>"^"</Delimiter>
<Piece>108</Piece>
</Data>
<Data name="SSUSR_IgnoreCALogon">
<Delimiter>"^"</Delimiter>
<Piece>127</Piece>
</Data>
<Data name="SSUSR_Initials">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSUSR_Inpatient">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="SSUSR_IsThisDoctor">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SSUSR_LastPAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="SSUSR_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="SSUSR_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="SSUSR_LastUpdateUserHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="SSUSR_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="SSUSR_LinkToBedManagement">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="SSUSR_LocList_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="SSUSR_LocationNotMandatoryOnResEntry">
<Delimiter>"^"</Delimiter>
<Piece>102</Piece>
</Data>
<Data name="SSUSR_LoginID">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="SSUSR_LoginRound">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="SSUSR_Mark">
<Delimiter>"^"</Delimiter>
<Piece>132</Piece>
</Data>
<Data name="SSUSR_MarkInactiveDate">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="SSUSR_MarkInactiveTime">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="SSUSR_MarkInactiveUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="SSUSR_Mobile">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="SSUSR_MultiSelectRows">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="SSUSR_NAllORBookNA">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="SSUSR_NAllORBookNoSess">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="SSUSR_NAllORBookPast">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="SSUSR_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSUSR_Name1">
<Delimiter>"^"</Delimiter>
<Piece>105</Piece>
</Data>
<Data name="SSUSR_Name2">
<Delimiter>"^"</Delimiter>
<Piece>106</Piece>
</Data>
<Data name="SSUSR_Name3">
<Delimiter>"^"</Delimiter>
<Piece>107</Piece>
</Data>
<Data name="SSUSR_NoDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="SSUSR_NoEMR">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="SSUSR_NoOrders">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="SSUSR_NotAllowToOverbook">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="SSUSR_NotReadResults">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="SSUSR_NurseFlag">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="SSUSR_OtherName">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="SSUSR_Outpatient">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="SSUSR_OwnPatientsOnly">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="SSUSR_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>130</Piece>
</Data>
<Data name="SSUSR_Pager">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="SSUSR_Password">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSUSR_PasswordChanged">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="SSUSR_PasswordDate">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="SSUSR_PayrollNumber">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="SSUSR_Pin">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SSUSR_PrintSecurityLevel">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="SSUSR_PrivilegeStock">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SSUSR_RBNumberOfRows">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="SSUSR_RegistrationNumber">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="SSUSR_ResEntryButtons">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="SSUSR_RestrictModifDischarge">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="SSUSR_RetainOrderCategory">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SSUSR_SearchAllAdm">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="SSUSR_SearchPrevAdm">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="SSUSR_SecurityMessage">
<Node>"SM"</Node>
</Data>
<Data name="SSUSR_SecurityMsgRead">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="SSUSR_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>129</Piece>
</Data>
<Data name="SSUSR_StaffType_DR">
<Delimiter>"^"</Delimiter>
<Piece>74</Piece>
</Data>
<Data name="SSUSR_Surname">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="SSUSR_TimeLastLogin">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="SSUSR_TimeSinceLastAppt">
<Delimiter>"^"</Delimiter>
<Piece>103</Piece>
</Data>
<Data name="SSUSR_TimeSincePeriod">
<Delimiter>"^"</Delimiter>
<Piece>104</Piece>
</Data>
<Data name="SSUSR_Title">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="SSUSR_Title_DR">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="SSUSR_UseDefaultEpisDep">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="SSUSR_UseDeptAsDefault">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SSUSR_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>131</Piece>
</Data>
<Data name="SSUSR_WarnORBookingMoveRes">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="SSUSR_WebSecurityAccess">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="SSUSR_YesNo1">
<Delimiter>"^"</Delimiter>
<Piece>117</Piece>
</Data>
<Data name="SSUSR_YesNo2">
<Delimiter>"^"</Delimiter>
<Piece>118</Piece>
</Data>
<Data name="SSUSR_YesNo3">
<Delimiter>"^"</Delimiter>
<Piece>119</Piece>
</Data>
<Data name="SSUSR_YesNo4">
<Delimiter>"^"</Delimiter>
<Piece>120</Piece>
</Data>
<Data name="SSUSR_YesNo5">
<Delimiter>"^"</Delimiter>
<Piece>121</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSUSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SSUSR_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBioKey">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSUSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BioKey"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SSUSR_BioKey})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSUSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSUSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSUSR_Group}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSUSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSSUSRCTPCPDR">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSUSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTPCP"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SSUSR_CareProv_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSUSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSSUSRHOSPersonDR">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOSPerson"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSUSR_HOSPerson_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SSUSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSSUSRInitials">
<Data name="SSUSR_Initials">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSUSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SSUSR_Initials"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SSUSR_Initials})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SSUSR_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSSUSRName">
<Data name="SSUSR_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SSUSR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"SSUSR_Name"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({SSUSR_Name})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SSUSR_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SSUSR_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
