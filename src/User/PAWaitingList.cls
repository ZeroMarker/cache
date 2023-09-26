/// PA Waiting List(1475)
Class User.PAWaitingList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_WaitingList, StorageStrategy = SQLStorage ]
{

Relationship ChildPAWaitingListTransaction As PAWaitingListTransaction [ Cardinality = children, Inverse = TRANSParRef ];

Relationship ChildPAWaitingListNotAvailable As PAWaitingListNotAvailable [ Cardinality = children, Inverse = NAParRef ];

Relationship ChildPAWaitingListRB As PAWaitingListRB [ Cardinality = children, Inverse = RBParRef ];

Relationship ChildPAWaitingListAdm As PAWaitingListAdm [ Cardinality = children, Inverse = ADMParRef ];

Relationship ChildPAWaitingListReview As PAWaitingListReview [ Cardinality = children, Inverse = REVParRef ];

Relationship ChildPAWaitingListLoc As PAWaitingListLoc [ Cardinality = children, Inverse = LOCParRef ];

Relationship ChildPAWaitingListRefDoc As PAWaitingListRefDoc [ Cardinality = children, Inverse = REFDParRef ];

Relationship ChildPAWaitingListApptOffers As PAWaitingListApptOffers [ Cardinality = children, Inverse = APTOFParRef ];

Relationship ChildPAWaitingListGuarDate As PAWaitingListGuarDate [ Cardinality = children, Inverse = GDParRef ];

Relationship ChildPAWaitingListScore As PAWaitingListScore [ Cardinality = children, Inverse = SCParRef ];

/// Des Ref PAPMI
Property WLPAPMIDR As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = WL_PAPMI_DR ];

/// Des Ref Wait ListType
Property WLWaitListTypeDR As PACWaitingListType [ SqlColumnNumber = 3, SqlFieldName = WL_WaitListType_DR ];

/// Des Ref Wait List Prior
Property WLWaitListPriorDR As PACWaitingListPriority [ SqlColumnNumber = 4, SqlFieldName = WL_WaitListPrior_DR ];

/// Des Ref Wait List Status
Property WLWaitListStatusDR As PACWaitingListStatus [ SqlColumnNumber = 5, SqlFieldName = WL_WaitListStatus_DR ];

/// Des Ref Reason For Change
Property WLReasonForChangeDR As PACWaitListReasonForChange [ SqlColumnNumber = 6, SqlFieldName = WL_ReasonForChange_DR ];

/// Des Ref CTLOC
Property WLCTLOCDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = WL_CTLOC_DR ];

/// Des Ref Doctor
Property WLDoctorDR As CTCareProv [ SqlColumnNumber = 8, SqlFieldName = WL_Doctor_DR ];

/// diagnosis
Property WLICDDR As MRCICDDx [ SqlColumnNumber = 9, SqlFieldName = WL_ICD_DR ];

/// Des Ref Operation
Property WLOperationDR As ORCOperation [ SqlColumnNumber = 10, SqlFieldName = WL_Operation_DR ];

/// Max Waiting Period
Property WLMaxWaitingPeriod As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = WL_MaxWaitingPeriod ];

/// Des Ref Surgeon
Property WLSurgeonDR As CTCareProv [ SqlColumnNumber = 12, SqlFieldName = WL_Surgeon_DR ];

/// Des Ref AnaestMethod
Property WLAnaestMethodDR As ORCAnaestMethod [ SqlColumnNumber = 13, SqlFieldName = WL_AnaestMethod_DR ];

/// Date
Property WLDate As %Date [ SqlColumnNumber = 14, SqlFieldName = WL_Date ];

/// Time
Property WLTime As %Time [ SqlColumnNumber = 15, SqlFieldName = WL_Time ];

/// Des Ref User
Property WLUserDR As SSUser [ SqlColumnNumber = 16, SqlFieldName = WL_User_DR ];

/// Effective Date
Property WLEffectiveDate As %Date [ SqlColumnNumber = 17, SqlFieldName = WL_EffectiveDate ];

/// Days Exclude
Property WLDaysExclude As %Float [ SqlColumnNumber = 18, SqlFieldName = WL_DaysExclude ];

/// Des Ref ReasonForList
Property WLReasonForListDR As PACWLReasonForList [ SqlColumnNumber = 19, SqlFieldName = WL_ReasonForList_DR ];

/// Des Ref RefDoc
Property WLRefDocDR As PACRefDoctor [ SqlColumnNumber = 20, SqlFieldName = WL_RefDoc_DR ];

/// Des Ref RefHosp
Property WLRefHospDR As CTRefClin [ SqlColumnNumber = 21, SqlFieldName = WL_RefHosp_DR ];

/// Remarks
Property WLRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = WL_Remarks, SqlListType = subnode ];

/// Preop Date
Property WLPreopDate As %Date [ SqlColumnNumber = 23, SqlFieldName = WL_PreopDate ];

/// Donation Date
Property WLDonationDate As %Date [ SqlColumnNumber = 24, SqlFieldName = WL_DonationDate ];

/// Special Categ Flag
Property WLSpecialCatFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = WL_SpecialCatFlag ];

/// Des Ref RB OperTheatre
Property WLRBOPDR As RBOperatingRoom [ SqlColumnNumber = 26, SqlFieldName = WL_RBOP_DR ];

/// Pre Admission DR
Property WLPreAdmissionDR As PAAdm [ SqlColumnNumber = 27, SqlFieldName = WL_PreAdmission_DR ];

/// Date Off List
Property WLDateOfList As %Date [ SqlColumnNumber = 29, SqlFieldName = WL_DateOfList ];

/// Delete Flag
Property WLDeleteFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 30, SqlFieldName = WL_DeleteFlag ];

/// Des Ref RefDocTo
Property WLRefDocToDR As PACRefDoctor [ SqlColumnNumber = 31, SqlFieldName = WL_RefDocTo_DR ];

/// Des Ref Ref HospTo
Property WLRefHospToDR As CTRefClin [ SqlColumnNumber = 32, SqlFieldName = WL_RefHospTo_DR ];

/// Day Surgery
Property WLDaySurgery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = WL_DaySurgery ];

/// Des Ref CTLOC
Property WLRefDepDR As CTLoc [ SqlColumnNumber = 34, SqlFieldName = WL_RefDep_DR ];

/// Des Ref RefDocInt
Property WLRefDocIntDR As CTCareProv [ SqlColumnNumber = 35, SqlFieldName = WL_RefDocInt_DR ];

/// Des Ref CreatingAdmission
Property WLCreatingAdmissionDR As PAAdm [ SqlColumnNumber = 36, SqlFieldName = WL_CreatingAdmission_DR ];

/// Date entry is reported to have been removed
Property WLEffectiveRemovalDate As %Date [ SqlColumnNumber = 37, SqlFieldName = WL_EffectiveRemovalDate ];

/// Des Ref AdmissionCategory
Property WLAdmissionCategoryDR As PACAdmCategory [ SqlColumnNumber = 39, SqlFieldName = WL_AdmissionCategory_DR ];

/// Des Ref ServiceGroup
Property WLServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 40, SqlFieldName = WL_ServiceGroup_DR ];

/// Date Minus Excl Days
Property WLDateMinusExcludeDays As %Date [ SqlColumnNumber = 41, SqlFieldName = WL_DateMinusExcludeDays ];

/// ContractRemarks
Property WLContractRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = WL_ContractRemarks, SqlListType = subnode ];

/// DaysOnList
Property WLDaysOnList As %Float [ SqlColumnNumber = 43, SqlFieldName = WL_DaysOnList ];

/// Days Of Week
Property WLDaysOfWeek As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = WL_DaysOfWeek ];

/// StartTime
Property WLStartTime As %Time [ SqlColumnNumber = 45, SqlFieldName = WL_StartTime ];

/// Des REf Resource_DR
Property WLResourceDR As RBResource [ SqlColumnNumber = 46, SqlFieldName = WL_Resource_DR ];

/// Des Ref AppointMethod
Property WLAppointMethodDR As RBCAppointMethod [ SqlColumnNumber = 47, SqlFieldName = WL_AppointMethod_DR ];

/// SessionType
Property WLSessionType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 48, SqlFieldName = WL_SessionType ];

/// Advised
Property WLAdvised As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = WL_Advised ];

/// Appt Date
Property WLApptDate As %Date [ SqlColumnNumber = 50, SqlFieldName = WL_ApptDate ];

/// Des Ref Guarantee Exception Code
Property WLGuaranteeExcCodeDR As PACWLGuarantExcCode [ SqlColumnNumber = 51, SqlFieldName = WL_GuaranteeExcCode_DR ];

/// Not used
Property WLOwnMinisterIndicator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = WL_OwnMinisterIndicator ];

/// Not used
Property WLHospChaplainVisitReq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 53, SqlFieldName = WL_HospChaplainVisitReq ];

/// Des Ref RefDocClinc
Property WLRefDocClincDR As PACRefDoctorClinic [ SqlColumnNumber = 54, SqlFieldName = WL_RefDocClinc_DR ];

/// Des Ref InsType
Property WLInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 55, SqlFieldName = WL_InsType_DR ];

/// Date Decided To Admit
Property WLDateDecidedToAdmit As %Date [ SqlColumnNumber = 56, SqlFieldName = WL_DateDecidedToAdmit ];

/// Intended Procedure Status(Verified)
Property WLVerified As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = WL_Verified ];

/// Des Ref Procedure2
Property WLProcedure2DR As ORCOperation [ SqlColumnNumber = 58, SqlFieldName = WL_Procedure2_DR ];

/// Des Ref Procedure3
Property WLProcedure3DR As ORCOperation [ SqlColumnNumber = 59, SqlFieldName = WL_Procedure3_DR ];

/// Des Ref EpisSubType
Property WLEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 60, SqlFieldName = WL_EpisSubType_DR ];

/// Last Reviewed Date
Property WLLastReviewedDate As %Date [ SqlColumnNumber = 61, SqlFieldName = WL_LastReviewedDate ];

/// Des Ref Source of addition
Property WLSourceOfAdditDR As PACSourceOfAddition [ SqlColumnNumber = 62, SqlFieldName = WL_SourceOfAddit_DR ];

/// Des Ref AdmBookingSystem
Property WLAdmBookingSystemDR As PACAdmBookingSystem [ SqlColumnNumber = 63, SqlFieldName = WL_AdmBookingSystem_DR ];

/// Des Ref IntendedWard
Property WLIntendedWardDR As PACWard [ SqlColumnNumber = 64, SqlFieldName = WL_IntendedWard_DR ];

/// Provisional Diagnosis
Property WLProvisionalDiagnosis As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 65, SqlFieldName = WL_ProvisionalDiagnosis ];

/// Short Notice
Property WLShortNotice As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 66, SqlFieldName = WL_ShortNotice ];

/// Des Ref RBC Transport
Property WLRBCTransportDR As RBCAppointTransport [ SqlColumnNumber = 67, SqlFieldName = WL_RBCTransport_DR ];

/// Blood Donation
Property WLBloodDonation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 68, SqlFieldName = WL_BloodDonation ];

/// Date Guaranteed
Property WLDateGuaranteed As %Date [ SqlColumnNumber = 69, SqlFieldName = WL_DateGuaranteed ];

/// Preop Time
Property WLPreopTime As %Time [ SqlColumnNumber = 70, SqlFieldName = WL_PreopTime ];

/// Update Date
Property WLUpdateDate As %Date [ SqlColumnNumber = 71, SqlFieldName = WL_UpdateDate ];

/// Update Time
Property WLUpdateTime As %Time [ SqlColumnNumber = 72, SqlFieldName = WL_UpdateTime ];

/// Update User
Property WLUpdateUserDR As SSUser [ SqlColumnNumber = 73, SqlFieldName = WL_UpdateUser_DR ];

/// DesiredTheatreTime
Property WLDesiredTheatreTime As %Time [ SqlColumnNumber = 74, SqlFieldName = WL_DesiredTheatreTime ];

/// Doctor
Property WLDoctor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 75, SqlFieldName = WL_Doctor ];

/// Des Ref Hospital
Property WLHospitalDR As CTHospital [ SqlColumnNumber = 76, SqlFieldName = WL_Hospital_DR ];

/// Operative Episode
Property WLOperativeEpisode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 77, SqlFieldName = WL_OperativeEpisode ];

/// Desref TransDest
Property WLTransDestDR As PACTransferDestination [ SqlColumnNumber = 78, SqlFieldName = WL_TransDest_DR ];

/// Procedure Free Text
Property WLProcedureFreeText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 79, SqlFieldName = WL_ProcedureFreeText, SqlListType = subnode ];

/// Desref Nurse
Property WLNurseDR As CTCareProv [ SqlColumnNumber = 80, SqlFieldName = WL_Nurse_DR ];

/// Estimated operation date
Property WLEstOperDate As %Date [ SqlColumnNumber = 81, SqlFieldName = WL_EstOperDate ];

/// Estimated operation time
Property WLEstOperTime As %Time [ SqlColumnNumber = 82, SqlFieldName = WL_EstOperTime ];

/// Des Ref StateProc
Property WLStateProcDR As PACStatePPP [ SqlColumnNumber = 83, SqlFieldName = WL_StateProc_DR ];

/// Private
Property WLPrivate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = WL_Private ];

/// Number
Property WLNO As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 85, SqlFieldName = WL_NO ];

/// Hosp Initiated Postponements
Property WLHIPs As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 86, SqlFieldName = WL_HIPs ];

/// Des Ref BookSystem
Property WLBookSystemDR As PACApptBookingSystem [ SqlColumnNumber = 87, SqlFieldName = WL_BookSystem_DR ];

/// Des Ref TransSource
Property WLTransSourceDR As PACTransferDestination [ SqlColumnNumber = 88, SqlFieldName = WL_TransSource_DR ];

/// Deferred Date
Property WLDeferredDate As %Date [ SqlColumnNumber = 89, SqlFieldName = WL_DeferredDate ];

/// Expected Adm Date
Property WLExpectedAdmDate As %Date [ SqlColumnNumber = 90, SqlFieldName = WL_ExpectedAdmDate ];

/// Des Ref WaitList
Property WLWaitListDR As PAWaitingList [ SqlColumnNumber = 91, SqlFieldName = WL_WaitList_DR ];

/// RadiologyFlag
Property WLRadiologyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 92, SqlFieldName = WL_RadiologyFlag ];

/// Deferred Days Waiting
Property WLDeferredDaysWaiting As %Float [ SqlColumnNumber = 93, SqlFieldName = WL_DeferredDaysWaiting ];

/// Des Ref UpdateUserHospital
Property WLUpdateUserHospitalDR As CTHospital [ SqlColumnNumber = 94, SqlFieldName = WL_UpdateUserHospital_DR ];

/// Remove Comments
Property WLRemoveComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 95, SqlFieldName = WL_RemoveComments, SqlListType = subnode ];

/// Last Audit Review Date
Property WLLastAuditReviewDate As %Date [ SqlColumnNumber = 96, SqlFieldName = WL_LastAuditReviewDate ];

/// Des Ref SpecialProject
Property WLSpecialProjectDR As PACSpecialProject [ SqlColumnNumber = 97, SqlFieldName = WL_SpecialProject_DR ];

/// Des Ref StandbyStatus
Property WLStandbyStatusDR As PACStandbyStatus [ SqlColumnNumber = 98, SqlFieldName = WL_StandbyStatus_DR ];

/// Des Ref AccomodationType
Property WLAccomodationTypeDR As PACAccomodationType [ SqlColumnNumber = 99, SqlFieldName = WL_AccomodationType_DR ];

/// Estimated LengthOfStay
Property WLEstLengthOfStay As %Float [ SqlColumnNumber = 100, SqlFieldName = WL_EstLengthOfStay ];

/// Blood Donation Text
Property WLBloodDonationText As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 101, SqlFieldName = WL_BloodDonationText ];

/// Special Requirements
Property WLSpecialRequirements As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 102, SqlFieldName = WL_SpecialRequirements, SqlListType = subnode ];

/// Days Waiting
Property WLDaysWaiting As %Float [ SqlColumnNumber = 103, SqlFieldName = WL_DaysWaiting ];

/// Total  Days On List
Property WLTotDaysOnList As %Float [ SqlColumnNumber = 104, SqlFieldName = WL_TotDaysOnList ];

/// PlannedSameDay
Property WLPlannedSameDay As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 105, SqlFieldName = WL_PlannedSameDay ];

/// Doctor Notes
Property WLDoctorNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 106, SqlFieldName = WL_DoctorNotes, SqlListType = subnode ];

/// Des Ref Service
Property WLServiceDR As RBCServices [ SqlColumnNumber = 107, SqlFieldName = WL_Service_DR ];

/// ServiceKey
Property WLServiceKey As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 108, SqlFieldName = WL_ServiceKey ];

/// PositionNumber
Property WLPositionNumber As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 109, SqlFieldName = WL_PositionNumber ];

/// Adm Date in Other Hosp
Property WLAdmDateOtherHosp As %Date [ SqlColumnNumber = 110, SqlFieldName = WL_AdmDateOtherHosp ];

/// Referral Unique ID
Property WLReferralUniqueID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 111, SqlFieldName = WL_ReferralUniqueID ];

/// Des Ref CaseManager
Property WLCaseManagerDR As CTCareProv [ SqlColumnNumber = 112, SqlFieldName = WL_CaseManager_DR ];

/// ESIS Resubmission Date
Property WLESISResubmissionDate As %Date [ SqlColumnNumber = 113, SqlFieldName = WL_ESISResubmissionDate ];

/// ClinicalRegistrationDate
Property WLClinicalRegistrationDate As %Date [ SqlColumnNumber = 114, SqlFieldName = WL_ClinicalRegistrationDate ];

/// Des Ref OSVisitorStatus
Property WLOSVisitorStatusDR As PACOSVisitorStatus [ SqlColumnNumber = 115, SqlFieldName = WL_OSVisitorStatus_DR ];

/// In UK last 12 Months
Property WLInUK12Months As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 116, SqlFieldName = WL_InUK12Months ];

/// Staying Permanently
Property WLStayingPermanently As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 117, SqlFieldName = WL_StayingPermanently ];

/// Des Ref SourceAttend
Property WLSourceAttendDR As PACSourceOfAttendance [ SqlColumnNumber = 118, SqlFieldName = WL_SourceAttend_DR ];

/// DateConsultRequestSent
Property WLDateConsultRequestSent As %Date [ SqlColumnNumber = 119, SqlFieldName = WL_DateConsultRequestSent ];

/// DateReceivedBack
Property WLDateReceivedBack As %Date [ SqlColumnNumber = 120, SqlFieldName = WL_DateReceivedBack ];

/// DateRefLetter
Property WLDateRefLetter As %Date [ SqlColumnNumber = 121, SqlFieldName = WL_DateRefLetter ];

/// Des Ref ReferralPriority
Property WLReferralPriorityDR As PACReferralPriority [ SqlColumnNumber = 122, SqlFieldName = WL_ReferralPriority_DR ];

/// Responded
Property WLResponded As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 123, SqlFieldName = WL_Responded ];

/// Des Ref FamilyDoc
Property WLFamilyDocDR As PACRefDoctor [ SqlColumnNumber = 124, SqlFieldName = WL_FamilyDoc_DR ];

/// Date Contact Letter Sent
Property WLDateContactLetterSent As %Date [ SqlColumnNumber = 125, SqlFieldName = WL_DateContactLetterSent ];

/// Date Acknowledgement Letter Sent
Property WLDateAcknowLetterSent As %Date [ SqlColumnNumber = 126, SqlFieldName = WL_DateAcknowLetterSent ];

/// Date Reminder Letter Sent
Property WLDateReminderLetterSent As %Date [ SqlColumnNumber = 127, SqlFieldName = WL_DateReminderLetterSent ];

/// Des Ref LeafLetType
Property WLLeafLetTypeDR As RBCLeafletType [ SqlColumnNumber = 128, SqlFieldName = WL_LeafLetType_DR ];

/// Des Ref ConsultCateg
Property WLConsultCategDR As OECConsultCateg [ SqlColumnNumber = 129, SqlFieldName = WL_ConsultCateg_DR ];

/// Des Ref Consult
Property WLConsultDR As PAPersonConsultSetCons [ SqlColumnNumber = 130, SqlFieldName = WL_Consult_DR ];

/// RecallDate
Property WLRecallDate As %Date [ SqlColumnNumber = 131, SqlFieldName = WL_RecallDate ];

/// Des Ref WaitingTimeStandard
Property WLWaitingTimeStandardDR As PACWaitingTimeStandard [ SqlColumnNumber = 132, SqlFieldName = WL_WaitingTimeStandard_DR ];

/// SuitabilityOfPatient
Property WLSuitabilityOfPatient As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 133, SqlFieldName = WL_SuitabilityOfPatient ];

/// PatWillChangeClinician
Property WLPatWillChangeClinician As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 134, SqlFieldName = WL_PatWillChangeClinician ];

/// PatWillChangeNHSBoard
Property WLPatWillChangeNHSBoard As %String(DISPLAYLIST = ",Yes,No,Unknown", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",Y,N,U") [ SqlColumnNumber = 135, SqlFieldName = WL_PatWillChangeNHSBoard ];

/// RemovedRemainOnList
Property WLRemovedRemainOnList As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 136, SqlFieldName = WL_RemovedRemainOnList ];

/// Des Ref PatientCategory
Property WLPatientCategoryDR As PACPatientCategory [ SqlColumnNumber = 137, SqlFieldName = WL_PatientCategory_DR ];

/// PatientType
Property WLPatientTypeDR As PACPatientType [ SqlColumnNumber = 138, SqlFieldName = WL_PatientType_DR ];

/// Des Ref PersonScheduleItem
Property WLPersonScheduleItemDR As PAPersonScheduleItem [ SqlColumnNumber = 139, SqlFieldName = WL_PersonScheduleItem_DR ];

/// Des Ref DeftTreatInit
Property WLDeftTreatInitDR As PACDefTreatmentInitiator [ SqlColumnNumber = 140, SqlFieldName = WL_DeftTreatInit_DR ];

/// Des Ref ApptOutcome
Property WLApptOutcomeDR As RBCOutcomeOfAppoint [ SqlColumnNumber = 141, SqlFieldName = WL_ApptOutcome_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PAWaitingList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingList","OnAfterInsert")
 d Table^HL7Outbound("PAWaitingList",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PAWaitingList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingList","OnAfterUpdate")
 d Table^HL7Outbound("PAWaitingList",%d(1),"Update")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PAWaitingList).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingList","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PAWaitingList).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingList","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingList","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PAWaitingList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAWaitingList","OnAfterDelete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SqlIdExpression>$i(^PAWL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WL_AccomodationType_DR">
<Delimiter>"^"</Delimiter>
<Piece>93</Piece>
</Data>
<Data name="WL_AdmBookingSystem_DR">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="WL_AdmDateOtherHosp">
<Delimiter>"^"</Delimiter>
<Piece>101</Piece>
</Data>
<Data name="WL_AdmissionCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="WL_Advised">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="WL_AnaestMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="WL_AppointMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="WL_ApptDate">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="WL_ApptOutcome_DR">
<Delimiter>"^"</Delimiter>
<Piece>132</Piece>
</Data>
<Data name="WL_BloodDonation">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="WL_BloodDonationText">
<Delimiter>"^"</Delimiter>
<Piece>95</Piece>
</Data>
<Data name="WL_BookSystem_DR">
<Delimiter>"^"</Delimiter>
<Piece>82</Piece>
</Data>
<Data name="WL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WL_CaseManager_DR">
<Delimiter>"^"</Delimiter>
<Piece>103</Piece>
</Data>
<Data name="WL_ClinicalRegistrationDate">
<Delimiter>"^"</Delimiter>
<Piece>105</Piece>
</Data>
<Data name="WL_ConsultCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>120</Piece>
</Data>
<Data name="WL_Consult_DR">
<Delimiter>"^"</Delimiter>
<Piece>121</Piece>
</Data>
<Data name="WL_ContractRemarks">
<Node>"CONTR"</Node>
</Data>
<Data name="WL_CreatingAdmission_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="WL_Date">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="WL_DateAcknowLetterSent">
<Delimiter>"^"</Delimiter>
<Piece>117</Piece>
</Data>
<Data name="WL_DateConsultRequestSent">
<Delimiter>"^"</Delimiter>
<Piece>110</Piece>
</Data>
<Data name="WL_DateContactLetterSent">
<Delimiter>"^"</Delimiter>
<Piece>116</Piece>
</Data>
<Data name="WL_DateDecidedToAdmit">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="WL_DateGuaranteed">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="WL_DateMinusExcludeDays">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="WL_DateOfList">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="WL_DateReceivedBack">
<Delimiter>"^"</Delimiter>
<Piece>111</Piece>
</Data>
<Data name="WL_DateRefLetter">
<Delimiter>"^"</Delimiter>
<Piece>112</Piece>
</Data>
<Data name="WL_DateReminderLetterSent">
<Delimiter>"^"</Delimiter>
<Piece>118</Piece>
</Data>
<Data name="WL_DaySurgery">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="WL_DaysExclude">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="WL_DaysOfWeek">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="WL_DaysOnList">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="WL_DaysWaiting">
<Delimiter>"^"</Delimiter>
<Piece>96</Piece>
</Data>
<Data name="WL_DeferredDate">
<Delimiter>"^"</Delimiter>
<Piece>84</Piece>
</Data>
<Data name="WL_DeferredDaysWaiting">
<Delimiter>"^"</Delimiter>
<Piece>88</Piece>
</Data>
<Data name="WL_DeftTreatInit_DR">
<Delimiter>"^"</Delimiter>
<Piece>131</Piece>
</Data>
<Data name="WL_DeleteFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="WL_DesiredTheatreTime">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="WL_Doctor">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="WL_DoctorNotes">
<Node>"DOC"</Node>
</Data>
<Data name="WL_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="WL_DonationDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="WL_ESISResubmissionDate">
<Delimiter>"^"</Delimiter>
<Piece>104</Piece>
</Data>
<Data name="WL_EffectiveDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="WL_EffectiveRemovalDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="WL_EpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="WL_EstLengthOfStay">
<Delimiter>"^"</Delimiter>
<Piece>94</Piece>
</Data>
<Data name="WL_EstOperDate">
<Delimiter>"^"</Delimiter>
<Piece>76</Piece>
</Data>
<Data name="WL_EstOperTime">
<Delimiter>"^"</Delimiter>
<Piece>77</Piece>
</Data>
<Data name="WL_ExpectedAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>85</Piece>
</Data>
<Data name="WL_FamilyDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>115</Piece>
</Data>
<Data name="WL_GuaranteeExcCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="WL_HIPs">
<Delimiter>"^"</Delimiter>
<Piece>81</Piece>
</Data>
<Data name="WL_HospChaplainVisitReq">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="WL_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="WL_ICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WL_InUK12Months">
<Delimiter>"^"</Delimiter>
<Piece>107</Piece>
</Data>
<Data name="WL_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="WL_IntendedWard_DR">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="WL_LastAuditReviewDate">
<Delimiter>"^"</Delimiter>
<Piece>90</Piece>
</Data>
<Data name="WL_LastReviewedDate">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="WL_LeafLetType_DR">
<Delimiter>"^"</Delimiter>
<Piece>119</Piece>
</Data>
<Data name="WL_MaxWaitingPeriod">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WL_NO">
<Delimiter>"^"</Delimiter>
<Piece>80</Piece>
</Data>
<Data name="WL_Nurse_DR">
<Delimiter>"^"</Delimiter>
<Piece>75</Piece>
</Data>
<Data name="WL_OSVisitorStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>106</Piece>
</Data>
<Data name="WL_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WL_OperativeEpisode">
<Delimiter>"^"</Delimiter>
<Piece>72</Piece>
</Data>
<Data name="WL_OwnMinisterIndicator">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="WL_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="WL_PatWillChangeClinician">
<Delimiter>"^"</Delimiter>
<Piece>125</Piece>
</Data>
<Data name="WL_PatWillChangeNHSBoard">
<Delimiter>"^"</Delimiter>
<Piece>126</Piece>
</Data>
<Data name="WL_PatientCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>128</Piece>
</Data>
<Data name="WL_PatientType_DR">
<Delimiter>"^"</Delimiter>
<Piece>129</Piece>
</Data>
<Data name="WL_PersonScheduleItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>130</Piece>
</Data>
<Data name="WL_PlannedSameDay">
<Delimiter>"^"</Delimiter>
<Piece>98</Piece>
</Data>
<Data name="WL_PositionNumber">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="WL_PreAdmission_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="WL_PreopDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="WL_PreopTime">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="WL_Private">
<Delimiter>"^"</Delimiter>
<Piece>79</Piece>
</Data>
<Data name="WL_Procedure2_DR">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="WL_Procedure3_DR">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="WL_ProcedureFreeText">
<Node>"PROC"</Node>
</Data>
<Data name="WL_ProvisionalDiagnosis">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="WL_RBCTransport_DR">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="WL_RBOP_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="WL_RadiologyFlag">
<Delimiter>"^"</Delimiter>
<Piece>87</Piece>
</Data>
<Data name="WL_ReasonForChange_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WL_ReasonForList_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="WL_RecallDate">
<Delimiter>"^"</Delimiter>
<Piece>122</Piece>
</Data>
<Data name="WL_RefDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="WL_RefDocClinc_DR">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="WL_RefDocInt_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="WL_RefDocTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="WL_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="WL_RefHospTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="WL_RefHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="WL_ReferralPriority_DR">
<Delimiter>"^"</Delimiter>
<Piece>113</Piece>
</Data>
<Data name="WL_ReferralUniqueID">
<Delimiter>"^"</Delimiter>
<Piece>102</Piece>
</Data>
<Data name="WL_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="WL_RemoveComments">
<Node>"RMC"</Node>
</Data>
<Data name="WL_RemovedRemainOnList">
<Delimiter>"^"</Delimiter>
<Piece>127</Piece>
</Data>
<Data name="WL_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="WL_Responded">
<Delimiter>"^"</Delimiter>
<Piece>114</Piece>
</Data>
<Data name="WL_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="WL_ServiceKey">
<Delimiter>"^"</Delimiter>
<Piece>100</Piece>
</Data>
<Data name="WL_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>99</Piece>
</Data>
<Data name="WL_SessionType">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="WL_ShortNotice">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="WL_SourceAttend_DR">
<Delimiter>"^"</Delimiter>
<Piece>109</Piece>
</Data>
<Data name="WL_SourceOfAddit_DR">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="WL_SpecialCatFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="WL_SpecialProject_DR">
<Delimiter>"^"</Delimiter>
<Piece>91</Piece>
</Data>
<Data name="WL_SpecialRequirements">
<Node>"SPREQ"</Node>
</Data>
<Data name="WL_StandbyStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>92</Piece>
</Data>
<Data name="WL_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="WL_StateProc_DR">
<Delimiter>"^"</Delimiter>
<Piece>78</Piece>
</Data>
<Data name="WL_StayingPermanently">
<Delimiter>"^"</Delimiter>
<Piece>108</Piece>
</Data>
<Data name="WL_SuitabilityOfPatient">
<Delimiter>"^"</Delimiter>
<Piece>124</Piece>
</Data>
<Data name="WL_Surgeon_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WL_Time">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="WL_TotDaysOnList">
<Delimiter>"^"</Delimiter>
<Piece>97</Piece>
</Data>
<Data name="WL_TransDest_DR">
<Delimiter>"^"</Delimiter>
<Piece>73</Piece>
</Data>
<Data name="WL_TransSource_DR">
<Delimiter>"^"</Delimiter>
<Piece>83</Piece>
</Data>
<Data name="WL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="WL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="WL_UpdateUserHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>89</Piece>
</Data>
<Data name="WL_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="WL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="WL_Verified">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="WL_WaitListPrior_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WL_WaitListStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="WL_WaitListType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WL_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Piece>86</Piece>
</Data>
<Data name="WL_WaitingTimeStandard_DR">
<Delimiter>"^"</Delimiter>
<Piece>123</Piece>
</Data>
<Global>^PAWL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{WL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDCDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DCDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DateDecidedToAdmit}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDCDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DCDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DateDecidedToAdmit}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDCDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DCDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DateDecidedToAdmit}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDFDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DFDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DeferredDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDFDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DFDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DeferredDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDWLocSerDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DWLocSerDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_ServiceKey}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{WL_DaysWaiting}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateOffList">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DateOffList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_DateOfList}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Days"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysListType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DLType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysOnList">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysOnListTypeStatus">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DLTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysWaitType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DWDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DaysWaiting}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysWaitTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DWDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DaysWaiting}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDaysWaiting">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DWDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DaysWaiting}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDefDateDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DFDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DeferredDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDeleted">
<Condition>$p({WL_DeleteFlag},$c(1))="Y"</Condition>
<ConditionFields>WL_DeleteFlag</ConditionFields>
<Global>^PAWLi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DEL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDL">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DocDL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Doctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDLType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DocDLType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Doctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDLTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DocDLTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Doctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DocDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Doctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DocDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Doctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DocDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Doctor_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexESISDate">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ESISDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_ESISResubmissionDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEffDateDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EDDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_EffectiveDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEffDateType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EDDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_EffectiveDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEffDateTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EDDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_EffectiveDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFDDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FDDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_FamilyDoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFDDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FDDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_FamilyDoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFamDoc">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FDDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_FamilyDoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGECDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GECDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_GuaranteeExcCode_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGECDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GECDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_GuaranteeExcCode_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGECDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GECDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_GuaranteeExcCode_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGuarDate">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GuarDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_DateGuaranteed}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDL">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocDL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDLType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocDLType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDLTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocDLTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DaysOnList}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDocPriorDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LDPDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{WL_Doctor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{WL_WaitListPrior_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({WL_NO})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOPDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_Operation_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOPDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_Operation_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOpDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_Operation_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMI">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListPrior_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPODateDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PODaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_PreopDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPODateTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PODaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_PreopDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPersSched">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PerSched"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_PersonScheduleItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPos">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Pos"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({WL_PositionNumber})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPreopDateDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PODays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_PreopDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRHDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RHDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_RefHosp_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRHDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RHDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_RefHosp_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRHDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RHDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_RefHosp_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecallDate">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RecallDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_RecallDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResStatus">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Resource_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Resource_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResourceType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RESType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Resource_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSPPPDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPPPDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_StateProc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSPPPDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPPPDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_StateProc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSPPPDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SPPPDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_StateProc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSer">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SERDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_ServiceKey}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSerDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SERDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_ServiceKey}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSerDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SERDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_ServiceKey}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShNoticeDaysTypeSt">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SHNDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_ShortNotice}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortNoticeDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SHNDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_ShortNotice}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexShortNoticedays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SHNDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_ShortNotice}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecCateg">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SpecCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_SpecialCatFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStbyStatDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STBDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_StandbyStatus_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStbyStatType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STBDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_StandbyStatus_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStbyStatTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STBDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_StandbyStatus_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTotDays">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TOTDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{WL_TotDaysOnList}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTotDaysType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TOTDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{WL_TotDaysOnList}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTotDaysTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TOTDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{WL_TotDaysOnList}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeStatus">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Type-Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListPrior_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWLDate">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLDDays"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWLDateType">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLDDaysType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWLDateTypeStat">
<Global>^PAWLi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>WL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLDDaysTypeStat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WL_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WL_WaitListType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WL_WaitListStatus_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WL_DateMinusExcludeDays}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WL_RowId</SqlRowIdName>
<StreamLocation>^User.PAWaitingListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
