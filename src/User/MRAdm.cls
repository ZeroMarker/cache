/// MR Admission            (MRADM,310)
Class User.MRAdm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Adm, StorageStrategy = SQLStorage ]
{

Relationship ChildMRAllergy As MRAllergy [ Cardinality = children, Inverse = MRALLMRADMParRef ];

Relationship ChildMRSubFind As MRSubFind [ Cardinality = children, Inverse = MRSUBMRADMParRef ];

Relationship ChildMRObjFind As MRObjFind [ Cardinality = children, Inverse = MROBJMRADMParRef ];

Relationship ChildMRClncData As MRClncData [ Cardinality = children, Inverse = MRCLNMRADMParRef ];

Relationship ChildMRDiagnos As MRDiagnos [ Cardinality = children, Inverse = MRDIAMRADMParRef ];

Relationship ChildMRInputOutput As MRInputOutput [ Cardinality = children, Inverse = INPOUTParRef ];

Relationship ChildMRPresentIllness As MRPresentIllness [ Cardinality = children, Inverse = PRESIParRef ];

Relationship ChildMRSystemReview As MRSystemReview [ Cardinality = children, Inverse = SYSRParRef ];

Relationship ChildMRPhysExamination As MRPhysExamination [ Cardinality = children, Inverse = PHYSParRef ];

Relationship ChildMRNursingNotes As MRNursingNotes [ Cardinality = children, Inverse = NOTParRef ];

Relationship ChildMRPictures As MRPictures [ Cardinality = children, Inverse = PICParRef ];

Relationship ChildMRWindowLayout As MRWindowLayout [ Cardinality = children, Inverse = WINParRef ];

Relationship ChildMREmergencyCondition As MREmergencyCondition [ Cardinality = children, Inverse = EMCParRef ];

Relationship ChildMRTransferNotes As MRTransferNotes [ Cardinality = children, Inverse = TRANParRef ];

Relationship ChildMRSubjectFindings As MRSubjectFindings [ Cardinality = children, Inverse = SUBFParRef ];

Relationship ChildMRICUValues As MRICUValues [ Cardinality = children, Inverse = ICUVParRef ];

Relationship ChildMRVoice As MRVoice [ Cardinality = children, Inverse = VOIParRef ];

Relationship ChildMREvolution As MREvolution [ Cardinality = children, Inverse = EVOParRef ];

Relationship ChildMRRiskEvaluation As MRRiskEvaluation [ Cardinality = children, Inverse = RISKParRef ];

Relationship ChildMRProcedures As MRProcedures [ Cardinality = children, Inverse = PROCParRef ];

Relationship ChildMRObservations As MRObservations [ Cardinality = children, Inverse = OBSParRef ];

Relationship ChildMRExtraObservations As MRExtraObservations [ Cardinality = children, Inverse = XOBParRef ];

Relationship ChildMRClinicalPathWays As MRClinicalPathWays [ Cardinality = children, Inverse = CPWParREf ];

Relationship ChildMRFloorPlanNotes As MRFloorPlanNotes [ Cardinality = children, Inverse = FLOORParRef ];

Relationship ChildMRFollowUpReason As MRFollowUpReason [ Cardinality = children, Inverse = FURParRef ];

Relationship ChildMRPsychDetails As MRPsychDetails [ Cardinality = children, Inverse = PSYCHParRef ];

Relationship ChildMRLatestObservation As MRLatestObservation [ Cardinality = children, Inverse = LOBSParRef ];

Relationship ChildMRCopaymentAmount As MRCopaymentAmount [ Cardinality = children, Inverse = COPParRef ];

Relationship ChildMRObservationNotes As MRObservationNotes [ Cardinality = children, Inverse = OBSNParRef ];

Relationship ChildMRMedication As MRMedication [ Cardinality = children, Inverse = MEDParRef ];

Relationship ChildMRPRS2Status As MRPRS2Status [ Cardinality = children, Inverse = PRS2ParRef ];

Relationship ChildMRPrescriptions As MRPrescriptions [ Cardinality = children, Inverse = PRESCParRef ];

Relationship ChildMRSickNote As MRSickNote [ Cardinality = children, Inverse = NOTParRef ];

/// Blood Pressure Diastolic
Property MRADMBPDiastolic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MRADM_BPDiastolic ];

/// Blood Pressure Systolic
Property MRADMBPSystolic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MRADM_BPSystolic ];

/// Date
Property MRADMDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MRADM_Date ];

/// Ectopic Beats Per Min
Property MRADMEctopic As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MRADM_Ectopic ];

/// Objective Findings
Property MRADMObjective As list Of %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = MRADM_Objective, SqlListType = SUBNODE ];

/// Pulse Rate
Property MRADMPulseRate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = MRADM_PulseRate ];

/// Resp
Property MRADMResp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = MRADM_Resp ];

/// Subjective Findings
Property MRADMSubjective As list Of %String(COLLATION = "AlphaUp", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = MRADM_Subjective, SqlListType = SUBNODE ];

/// Temperature
Property MRADMTemp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = MRADM_Temp ];

/// Time
Property MRADMTime As %Time [ SqlColumnNumber = 12, SqlFieldName = MRADM_Time ];

/// Des Ref to PAADM
Property MRADMADMDR As PAAdm [ SqlColumnNumber = 13, SqlFieldName = MRADM_ADM_DR ];

/// Condition At Time of Dicsharge
Property MRADMConditAtDischDR As PACDischCondit [ SqlColumnNumber = 14, SqlFieldName = MRADM_ConditAtDisch_DR ];

/// Des REf to DischType
Property MRADMDischTypeDR As CTDisposit [ SqlColumnNumber = 15, SqlFieldName = MRADM_DischType_DR ];

/// Other Disch Type
Property MRADMOtherDischType As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MRADM_OtherDischType ];

/// Des Ref InfectType
Property MRADMInfectTypeDR As PACInfectionType [ SqlColumnNumber = 17, SqlFieldName = MRADM_InfectType_DR ];

/// Other Infection Type
Property MRADMOtherInfectType As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = MRADM_OtherInfectType ];

/// Des Ref CTCP
Property MRADMDocDischDR As CTCareProv [ SqlColumnNumber = 19, SqlFieldName = MRADM_DocDisch_DR ];

/// Des Ref to CTCP
Property MRADMNurseDischDR As CTCareProv [ SqlColumnNumber = 20, SqlFieldName = MRADM_NurseDisch_DR ];

/// Blood Sugar Test Result
Property MRADMBloodSugarTestResult As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = MRADM_BloodSugarTestResult ];

/// Des Ref BloodType
Property MRADMBloodTypeDR As PACBloodType [ SqlColumnNumber = 22, SqlFieldName = MRADM_BloodType_DR ];

/// Head Circumference
Property MRADMHeadCircumference As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = MRADM_HeadCircumference ];

/// Height
Property MRADMHeight As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = MRADM_Height ];

/// Kidney Transplant
Property MRADMKidneyTransplant As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = MRADM_KidneyTransplant ];

/// KidneyTransplant Desired
Property MRADMKidneyTranspDes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = MRADM_KidneyTranspDes ];

/// Urine Sugar Test Result
Property MRADMUrineSugarTestResult As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = MRADM_UrineSugarTestResult ];

/// Vision Score Left
Property MRADMVisionScoreLeft As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = MRADM_VisionScoreLeft ];

/// Vision Score Right
Property MRADMVisionScoreRight As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = MRADM_VisionScoreRight ];

/// Waist Circumference
Property MRADMWaistCircumference As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = MRADM_WaistCircumference ];

/// Weight
Property MRADMWeight As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = MRADM_Weight ];

/// Des Ref Tumor
Property MRADMTumorDR As PATumor [ SqlColumnNumber = 32, SqlFieldName = MRADM_Tumor_DR ];

/// Des Ref MaterType
Property MRADMMaterTypeDR As PACMaternityType [ SqlColumnNumber = 33, SqlFieldName = MRADM_MaterType_DR ];

/// Ceasarian Section
Property MRADMCeasarianSection As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = MRADM_CeasarianSection ];

/// Tubal Ligation
Property MRADMTubalLigation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = MRADM_TubalLigation ];

/// No of Still Birth
Property MRADMNoStillBirth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = MRADM_NoStillBirth ];

/// Des Ref WoundType
Property MRADMWoundTypeDR As MRCWoundType [ SqlColumnNumber = 37, SqlFieldName = MRADM_WoundType_DR ];

/// Des Ref AdmRoute
Property MRADMAdmRouteDR As MRCAdmissionRoute [ SqlColumnNumber = 38, SqlFieldName = MRADM_AdmRoute_DR ];

/// Des Ref CauseOfDeath
Property MRADMCauseOfDeathDR As MRCCauseOfDeath [ SqlColumnNumber = 39, SqlFieldName = MRADM_CauseOfDeath_DR ];

/// DateProofPrinted
Property MRADMDateProofPrinted As %Date [ SqlColumnNumber = 40, SqlFieldName = MRADM_DateProofPrinted ];

/// SeqNo
Property MRADMSeqNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = MRADM_SeqNo ];

/// DateRangeFrom
Property MRADMDateRangeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = MRADM_DateRangeFrom ];

/// Date Range To
Property MRADMDateRangeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = MRADM_DateRangeTo ];

/// Des Ref PatCond
Property MRADMPatCondDR As MRCPatientCondition [ SqlColumnNumber = 44, SqlFieldName = MRADM_PatCond_DR ];

/// Des Ref Visitor Status
Property MRADMVisitorStatusDR As PACVisitorStatus [ SqlColumnNumber = 45, SqlFieldName = MRADM_VisitorStatus_DR ];

/// Des Ref DRG
Property MRADMDRGDR As MRCDRGCodes [ SqlColumnNumber = 46, SqlFieldName = MRADM_DRG_DR ];

/// DRG First Date Processing
Property MRADMDRGFirstDateProcessing As %Date [ SqlColumnNumber = 47, SqlFieldName = MRADM_DRGFirstDateProcessing ];

/// DRG Last Date Processing
Property MRADMDRGLastDateProcessing As %Date [ SqlColumnNumber = 48, SqlFieldName = MRADM_DRGLastDateProcessing ];

/// DRG Process Times
Property MRADMDRGProcessTimes As %Float [ SqlColumnNumber = 49, SqlFieldName = MRADM_DRGProcessTimes ];

/// DRG Tariff
Property MRADMDRGTariff As %Float [ SqlColumnNumber = 50, SqlFieldName = MRADM_DRGTariff ];

/// Des Ref Autopsy Type
Property MRADMAutopsyTypeDR As PACAutopsyType [ SqlColumnNumber = 51, SqlFieldName = MRADM_AutopsyType_DR ];

/// Des Ref RefClin
Property MRADMRefClinDR As CTRefClin [ SqlColumnNumber = 52, SqlFieldName = MRADM_RefClin_DR ];

/// Des Ref Transfer Means
Property MRADMTransferMeansDR As PACTransferMeans [ SqlColumnNumber = 53, SqlFieldName = MRADM_TransferMeans_DR ];

/// Des Ref  PA Traffic
Property MRADMTrafficDR As PATrafficAccident [ SqlColumnNumber = 54, SqlFieldName = MRADM_Traffic_DR ];

/// Des Ref DischDestin
Property MRADMDischDestinDR As PACDischargeDestination [ SqlColumnNumber = 55, SqlFieldName = MRADM_DischDestin_DR ];

/// Des Ref DischTransport
Property MRADMDischTransportDR As PACDischargeTransport [ SqlColumnNumber = 56, SqlFieldName = MRADM_DischTransport_DR ];

/// Des RefReasonForRevFinDisch
Property MRADMReasonForRevFinDischDR As PACReasonForReverseFinDisch [ SqlColumnNumber = 57, SqlFieldName = MRADM_ReasonForRevFinDisch_DR ];

/// Des Ref Discharge Classif
Property MRADMDischClassifDR As PACDischClassification [ SqlColumnNumber = 58, SqlFieldName = MRADM_DischClassif_DR ];

/// Des Ref MedicSuffix
Property MRADMMedicSuffixDR As PACMedicareSuffix [ SqlColumnNumber = 59, SqlFieldName = MRADM_MedicSuffix_DR ];

/// Des Ref AccountClass
Property MRADMAccountClassDR As PACAccountClass [ SqlColumnNumber = 60, SqlFieldName = MRADM_AccountClass_DR ];

/// Text Des Ref SeparationReferral
Property MRADMSeparationReferralDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 61, SqlFieldName = MRADM_SeparationReferral_DR ];

/// Des Ref CarerAvail
Property MRADMCarerAvailDR As PACCarerAvailability [ SqlColumnNumber = 62, SqlFieldName = MRADM_CarerAvail_DR ];

/// Des Ref CareType
Property MRADMCareTypeDR As PACCareType [ SqlColumnNumber = 63, SqlFieldName = MRADM_CareType_DR ];

/// Des Ref MentHealthStat
Property MRADMMentHealthStatDR As PACMentalHealthLegalStat [ SqlColumnNumber = 64, SqlFieldName = MRADM_MentHealthStat_DR ];

/// Des Ref Program FundSource
Property MRADMProgrFundSourceDR As PACProgramFundingSource [ SqlColumnNumber = 65, SqlFieldName = MRADM_ProgrFundSource_DR ];

/// Des Ref FundingArrang
Property MRADMFundingArrangDR As PACFundingArrangement [ SqlColumnNumber = 66, SqlFieldName = MRADM_FundingArrang_DR ];

/// Des Ref ContractType
Property MRADMContractTypeDR As PACContractType [ SqlColumnNumber = 67, SqlFieldName = MRADM_ContractType_DR ];

/// Des Ref ContractRole
Property MRADMContractRoleDR As PACContractRole [ SqlColumnNumber = 68, SqlFieldName = MRADM_ContractRole_DR ];

/// Des Ref ContrSpokeIdentif
Property MRADMContrSpokeIdentifDR As PACContractSpokIdentifier [ SqlColumnNumber = 69, SqlFieldName = MRADM_ContrSpokeIdentif_DR ];

/// Des Ref IntentReadmit
Property MRADMIntentReadmitDR As PACIntentionReadmit [ SqlColumnNumber = 70, SqlFieldName = MRADM_IntentReadmit_DR ];

/// Des Ref ReasonCritCareTransfer
Property MRADMReasonCritCareTransDR As PACReasonCritCareTransfer [ SqlColumnNumber = 71, SqlFieldName = MRADM_ReasonCritCareTrans_DR ];

/// Onset Date
Property MRADMOnsetDate As %Date [ SqlColumnNumber = 72, SqlFieldName = MRADM_OnsetDate ];

/// Des Ref AdmReadmRehab
Property MRADMAdmReadmRehabDR As PACAdmReadmRehab [ SqlColumnNumber = 73, SqlFieldName = MRADM_AdmReadmRehab_DR ];

/// Des Ref SourceReferralPalCare
Property MRADMSourceReferralPalCareDR As PACSourceRefPalliatCare [ SqlColumnNumber = 74, SqlFieldName = MRADM_SourceReferralPalCare_DR ];

/// Deletion
Property MRADMDeletion As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 75, SqlFieldName = MRADM_Deletion ];

/// Resend
Property MRADMResend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 76, SqlFieldName = MRADM_Resend ];

/// Sent to PRS2
Property MRADMSentPRS2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = MRADM_SentPRS2 ];

/// Duration of Mechanical Ventilation
Property MRADMDurationMechVent As %Float [ SqlColumnNumber = 78, SqlFieldName = MRADM_DurationMechVent ];

/// Transfer Date from RefCln
Property MRADMTransferDateRefCln As %Date [ SqlColumnNumber = 79, SqlFieldName = MRADM_TransferDateRefCln ];

/// Number Of Days
Property MRADMNumberOfDays As %Float [ SqlColumnNumber = 80, SqlFieldName = MRADM_NumberOfDays ];

/// Date Height
Property MRADMDateHeight As %Date [ SqlColumnNumber = 81, SqlFieldName = MRADM_DateHeight ];

/// Date Weight
Property MRADMDateWeight As %Date [ SqlColumnNumber = 82, SqlFieldName = MRADM_DateWeight ];

/// DRG Weighting
Property MRADMDRGWeighting As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 83, SqlFieldName = MRADM_DRG_Weighting ];

/// Discharge Date
Property MRADMDischargeDate As %Date [ SqlColumnNumber = 84, SqlFieldName = MRADM_DischargeDate ];

/// Present Complaint
Property MRADMPresentComplaint As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 85, SqlFieldName = MRADM_PresentComplaint ];

/// PreHosp Treatment
Property MRADMPreHospTreatment As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 86, SqlFieldName = MRADM_PreHospTreatment, SqlListType = SUBNODE ];

/// GP Consent
Property MRADMGPConsent As %String(DISPLAYLIST = ",Yes,No,Maybe", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",Y,N,M") [ SqlColumnNumber = 87, SqlFieldName = MRADM_GPConsent ];

/// Ambulance Case
Property MRADMAmbulanceCase As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 88, SqlFieldName = MRADM_AmbulanceCase ];

/// Oxygen Saturation
Property MRADMOxygenSaturation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 89, SqlFieldName = MRADM_OxygenSaturation ];

/// Des Ref TransfDest
Property MRADMTransfDestDR As PACTransferDestination [ SqlColumnNumber = 90, SqlFieldName = MRADM_TransfDest_DR ];

/// Des Ref ReasonTransfer
Property MRADMReasonTransferDR As PACReasonForTransfer [ SqlColumnNumber = 91, SqlFieldName = MRADM_ReasonTransfer_DR ];

/// Des Ref EscortSource
Property MRADMEscortSourceDR As PACEscortSource [ SqlColumnNumber = 92, SqlFieldName = MRADM_EscortSource_DR ];

/// Des Ref ReferredTo_DR
Property MRADMReferredToDR As PACReferredDeparture [ SqlColumnNumber = 93, SqlFieldName = MRADM_ReferredTo_DR ];

/// OtherTransferReason
Property MRADMOtherTransferReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 94, SqlFieldName = MRADM_OtherTransferReason ];

/// InjuryDesc
Property MRADMInjuryDesc As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 95, SqlFieldName = MRADM_InjuryDesc ];

/// PACS Discharge Date
Property MRADMPACSDischargeDate As %Date [ SqlColumnNumber = 96, SqlFieldName = MRADM_PACSDischargeDate ];

/// RefBookDate
Property MRADMRefBookDate As %Date [ SqlColumnNumber = 97, SqlFieldName = MRADM_RefBookDate ];

/// Remarks
Property MRADMRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 98, SqlFieldName = MRADM_Remarks, SqlListType = SUBNODE ];

/// Des Ref Visit Type
Property MRADMVisitTypeDR As PACVisitType [ SqlColumnNumber = 99, SqlFieldName = MRADM_VisitType_DR ];

/// Des Ref TransDest2(used as transfer source)
Property MRADMTransDest2DR As PACTransferDestination [ SqlColumnNumber = 100, SqlFieldName = MRADM_TransDest2_DR ];

/// MedicallyFit
Property MRADMMedicallyFit As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 101, SqlFieldName = MRADM_MedicallyFit ];

/// RingWard
Property MRADMRingWard As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 102, SqlFieldName = MRADM_RingWard ];

/// PatientRequirements
Property MRADMPatientRequirements As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 103, SqlFieldName = MRADM_PatientRequirements, SqlListType = SUBNODE ];

/// Special Instructions
Property MRADMSpecialInstr As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 104, SqlFieldName = MRADM_SpecialInstr, SqlListType = SUBNODE ];

/// Taking Calls
Property MRADMTakingCalls As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 105, SqlFieldName = MRADM_TakingCalls ];

/// PatInqUpdateDate
Property MRADMPatInqUpdateDate As %Date [ SqlColumnNumber = 106, SqlFieldName = MRADM_PatInqUpdateDate ];

/// Des Ref User
Property MRADMPatInqUpdUserDR As SSUser [ SqlColumnNumber = 107, SqlFieldName = MRADM_PatInqUpdUser_DR ];

/// Des Ref ConscState
Property MRADMConscStateDR As MRCConsciousState [ SqlColumnNumber = 108, SqlFieldName = MRADM_ConscState_DR ];

/// Des Ref Progress
Property MRADMProgressDR As MRCProgress [ SqlColumnNumber = 109, SqlFieldName = MRADM_Progress_DR ];

/// Des Ref Activity
Property MRADMActivityDR As MRCActivity [ SqlColumnNumber = 110, SqlFieldName = MRADM_Activity_DR ];

/// Des Ref Overnight
Property MRADMOvernightDR As MRCOvernight [ SqlColumnNumber = 111, SqlFieldName = MRADM_Overnight_DR ];

/// Diet Comments
Property MRADMDietComments As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 112, SqlFieldName = MRADM_DietComments, SqlListType = SUBNODE ];

/// Des Ref DischPallCare
Property MRADMDischPallCareDR As PACPalliativeCareState [ SqlColumnNumber = 113, SqlFieldName = MRADM_DischPallCare_DR ];

/// Des Ref DischBedMobility
Property MRADMDischBedMobilityDR As PACBedMobility [ SqlColumnNumber = 114, SqlFieldName = MRADM_DischBedMobility_DR ];

/// Des Ref DischToileting
Property MRADMDischToiletingDR As PACToileting [ SqlColumnNumber = 115, SqlFieldName = MRADM_DischToileting_DR ];

/// Des Ref DischTransfer
Property MRADMDischTransferDR As PACTransferring [ SqlColumnNumber = 116, SqlFieldName = MRADM_DischTransfer_DR ];

/// Des Ref DischEating
Property MRADMDischEatingDR As PACEating [ SqlColumnNumber = 117, SqlFieldName = MRADM_DischEating_DR ];

/// Disch RUG Total
Property MRADMDischRUGTotal As %Float [ SqlColumnNumber = 118, SqlFieldName = MRADM_DischRUGTotal ];

/// ICU Hours
Property MRADMICUHours As %Float [ SqlColumnNumber = 119, SqlFieldName = MRADM_ICUHours ];

/// CCU Hours
Property MRADMCCUHours As %Float [ SqlColumnNumber = 120, SqlFieldName = MRADM_CCUHours ];

/// CPAP Hours
Property MRADMCPAPHours As %Float [ SqlColumnNumber = 121, SqlFieldName = MRADM_CPAPHours ];

/// Des Ref DischReasonBedUnAvail
Property MRADMDischReasonBedUnAvailDR As PACBedReasonNotAvail [ SqlColumnNumber = 122, SqlFieldName = MRADM_DischReasonBedUnAvail_DR ];

/// PatInqUpdateTime
Property MRADMPatInqUpdateTime As %Time [ SqlColumnNumber = 123, SqlFieldName = MRADM_PatInqUpdateTime ];

/// Coding Update Date
Property MRADMCodingUpdateDate As %Date [ SqlColumnNumber = 124, SqlFieldName = MRADM_CodingUpdateDate ];

/// Coding Update Time
Property MRADMCodingUpdateTime As %Time [ SqlColumnNumber = 125, SqlFieldName = MRADM_CodingUpdateTime ];

/// Des Ref User
Property MRADMCodingUpdateUserDR As SSUser [ SqlColumnNumber = 126, SqlFieldName = MRADM_CodingUpdateUser_DR ];

/// PRS2 Status
Property MRADMPRS2Status As %String(DISPLAYLIST = ",Verified,Sent,Flagged to resubmit,Accepted,Episode Deletion,Diagnosis Deletion,Extra Diagnosis Deletion,Sub Acute Deletion,Rollback,Resent with changes", MAXLEN = 24, TRUNCATE = 1, VALUELIST = ",V,S,F,A,E,D,ED,SA,R,D1") [ SqlColumnNumber = 127, SqlFieldName = MRADM_PRS2Status ];

/// InlierEquivalence
Property MRADMInlierEquivalence As %String(DISPLAYLIST = ",High Outlier,Low Outlier,Inlier", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",H,L,I") [ SqlColumnNumber = 128, SqlFieldName = MRADM_InlierEquivalence ];

/// Base WIES
Property MRADMBaseWIES As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 129, SqlFieldName = MRADM_BaseWIES ];

/// ATIS WIES
Property MRADMATISWIES As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 130, SqlFieldName = MRADM_ATISWIES ];

/// Total WIES Score
Property MRADMTotalWIESScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 131, SqlFieldName = MRADM_TotalWIESScore ];

/// Total WIES Price
Property MRADMTotalWIESPrice As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 132, SqlFieldName = MRADM_TotalWIESPrice ];

/// High Outlier Days
Property MRADMHighOutlierDays As %Float [ SqlColumnNumber = 133, SqlFieldName = MRADM_HighOutlierDays ];

/// Des Ref CodingUpdateHospital
Property MRADMCodingUpdateHospitalDR As CTHospital [ SqlColumnNumber = 134, SqlFieldName = MRADM_CodingUpdateHospital_DR ];

/// Des Ref PatInqUpdUserHosp
Property MRADMPatInqUpdUserHospDR As CTHospital [ SqlColumnNumber = 135, SqlFieldName = MRADM_PatInqUpdUserHosp_DR ];

/// Des Ref WorkingDiagnosis
Property MRADMWorkingDiagnosisDR As PACWorkingDiagnosis [ SqlColumnNumber = 136, SqlFieldName = MRADM_WorkingDiagnosis_DR ];

/// Des Ref OtherConditions
Property MRADMOtherConditionsDR As PACOtherConditions [ SqlColumnNumber = 137, SqlFieldName = MRADM_OtherConditions_DR ];

/// Des Ref IVTherapy
Property MRADMIVTherapyDR As PACIVTherapy [ SqlColumnNumber = 138, SqlFieldName = MRADM_IVTherapy_DR ];

/// Des Ref Ventilation
Property MRADMVentilationDR As PACVentilation [ SqlColumnNumber = 139, SqlFieldName = MRADM_Ventilation_DR ];

/// Des Ref Isolation
Property MRADMIsolationDR As PACIsolation [ SqlColumnNumber = 140, SqlFieldName = MRADM_Isolation_DR ];

/// Des Ref DrainTubes_
Property MRADMDrainTubesDR As PACDrainTubes [ SqlColumnNumber = 141, SqlFieldName = MRADM_DrainTubes_DR ];

/// PatCondDate
Property MRADMPatCondDate As %Date [ SqlColumnNumber = 142, SqlFieldName = MRADM_PatCondDate ];

/// PatCondTime
Property MRADMPatCondTime As %Time [ SqlColumnNumber = 143, SqlFieldName = MRADM_PatCondTime ];

/// Progress Date
Property MRADMProgressDate As %Date [ SqlColumnNumber = 144, SqlFieldName = MRADM_ProgressDate ];

/// Progress Time
Property MRADMProgressTime As %Time [ SqlColumnNumber = 145, SqlFieldName = MRADM_ProgressTime ];

/// VisitHrFrom
Property MRADMVisitHrFrom As %Time [ SqlColumnNumber = 146, SqlFieldName = MRADM_VisitHrFrom ];

/// VisitHrTo
Property MRADMVisitHrTo As %Time [ SqlColumnNumber = 147, SqlFieldName = MRADM_VisitHrTo ];

/// RestPeriodFrom
Property MRADMRestPeriodFrom As %Time [ SqlColumnNumber = 148, SqlFieldName = MRADM_RestPeriodFrom ];

/// RestPeriodTo
Property MRADMRestPeriodTo As %Time [ SqlColumnNumber = 149, SqlFieldName = MRADM_RestPeriodTo ];

/// Des Ref UnplanReadmission
Property MRADMUnplanReadmissionDR As PACUnplannedReadmission [ SqlColumnNumber = 150, SqlFieldName = MRADM_UnplanReadmission_DR ];

/// Patient Clinical Complexity Level
Property MRADMPCCL As %Float [ SqlColumnNumber = 151, SqlFieldName = MRADM_PCCL ];

/// PM UpdateDate
Property MRADMPMUpdateDate As %Date [ SqlColumnNumber = 152, SqlFieldName = MRADM_PMUpdateDate ];

/// PM UpdateTime
Property MRADMPMUpdateTime As %Time [ SqlColumnNumber = 153, SqlFieldName = MRADM_PMUpdateTime ];

/// Des Ref PMUpdateUser
Property MRADMPMUpdateUserDR As SSUser [ SqlColumnNumber = 154, SqlFieldName = MRADM_PMUpdateUser_DR ];

/// Des Ref PMUpdateHospital
Property MRADMPMUpdateHospitalDR As CTHospital [ SqlColumnNumber = 155, SqlFieldName = MRADM_PMUpdateHospital_DR ];

/// ACAS DR
Property MRADMACASDR As PACAgedCareAssessServ [ SqlColumnNumber = 156, SqlFieldName = MRADM_ACAS_DR ];

/// Des Ref GrouperStatus
Property MRADMGrouperStatusDR As MRCDRGGrouperErrors [ SqlColumnNumber = 157, SqlFieldName = MRADM_GrouperStatus_DR ];

/// MultiVisitingHoursRanges
Property MRADMMultiVisitingHoursRanges As %String(COLLATION = "Exact", MAXLEN = 230, TRUNCATE = 1) [ SqlColumnNumber = 158, SqlFieldName = MRADM_MultiVisitingHoursRanges ];

/// RecordsToResubmit
Property MRADMRecordsToResubmit As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 159, SqlFieldName = MRADM_RecordsToResubmit ];

/// GlasgowComaScore
Property MRADMGlasgowComaScore As %Float [ SqlColumnNumber = 160, SqlFieldName = MRADM_GlasgowComaScore ];

/// PainScore
Property MRADMPainScore As %Float [ SqlColumnNumber = 161, SqlFieldName = MRADM_PainScore ];

/// PainRange
Property MRADMPainRange As %String(DISPLAYLIST = ",PainFree,Mild,Moderate,Severe", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",F,M,O,S") [ SqlColumnNumber = 162, SqlFieldName = MRADM_PainRange ];

/// NursingHours
Property MRADMNursingHours As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 163, SqlFieldName = MRADM_NursingHours ];

/// CarePlanStartDate
Property MRADMCarePlanStartDate As %Date [ SqlColumnNumber = 164, SqlFieldName = MRADM_CarePlanStartDate ];

/// CarePlanReviewDate
Property MRADMCarePlanReviewDate As %Date [ SqlColumnNumber = 165, SqlFieldName = MRADM_CarePlanReviewDate ];

/// CarePlanEndDate
Property MRADMCarePlanEndDate As %Date [ SqlColumnNumber = 166, SqlFieldName = MRADM_CarePlanEndDate ];

/// SerumCreatinine
Property MRADMSerumCreatinine As %Float [ SqlColumnNumber = 167, SqlFieldName = MRADM_SerumCreatinine ];

/// DateSerumCreatinine
Property MRADMDateSerumCreatinine As %Date [ SqlColumnNumber = 168, SqlFieldName = MRADM_DateSerumCreatinine ];

/// 末次月经时间
Property MRADMPregnancyLMP As %Date [ SqlColumnNumber = 169, SqlFieldName = MRADM_Pregnancy_LMP ];

/// 主责护士
Property MRADMPrimaryNurseDischDR As CTCareProv [ SqlColumnNumber = 170, SqlFieldName = MRADM_PrimaryNurseDisch_DR ];

/// 病房护士长
Property MRADMWardNurseDischDR As CTCareProv [ SqlColumnNumber = 171, SqlFieldName = MRADM_WardNurseDisch_DR ];

/// N4责任护士
Property MRADMN4PrimaryNurseDischDR As CTCareProv [ SqlColumnNumber = 172, SqlFieldName = MRADM_N4PrimaryNurseDisch_DR ];

/// N3责任护士
Property MRADMN3PrimaryNurseDischDR As CTCareProv [ SqlColumnNumber = 173, SqlFieldName = MRADM_N3PrimaryNurseDisch_DR ];

/// N2责任护士
Property MRADMN2PrimaryNurseDischDR As CTCareProv [ SqlColumnNumber = 174, SqlFieldName = MRADM_N2PrimaryNurseDisch_DR ];

/// N1责任护士
Property MRADMN1PrimaryNurseDischDR As CTCareProv [ SqlColumnNumber = 175, SqlFieldName = MRADM_N1PrimaryNurseDisch_DR ];

/// 质控护士1
Property MRADMN1QualityNurseDischDR As CTCareProv [ SqlColumnNumber = 176, SqlFieldName = MRADM_N1QualityNurseDisch_DR ];

/// 质控护士2
Property MRADMN2QualityNurseDischDR As CTCareProv [ SqlColumnNumber = 177, SqlFieldName = MRADM_N2QualityNurseDisch_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRAdm","OnAfterDelete")

 d Table^HL7Outbound("MRAdm",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRAdm","OnAfterInsert")

 d Table^HL7Outbound("MRAdm",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRAdm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRAdm","OnAfterUpdate")

 d Table^HL7Outbound("MRAdm",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRAdm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRAdm","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRAdm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRAdm","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRAdm","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MR(0))</SqlIdExpression>
<SQLMap name="IndexCodingDate">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CODDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRADM_CodingUpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDRG">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRADM_DischargeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRADM_DRG_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPRS2Status">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRS2Stat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRADM_PRS2Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRADMDataMasterMap">
<Data name="MRADM_ACAS_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>147</Piece>
</Data>
<Data name="MRADM_ADM_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>9</Piece>
</Data>
<Data name="MRADM_ATISWIES">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>121</Piece>
</Data>
<Data name="MRADM_AccountClass_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>56</Piece>
</Data>
<Data name="MRADM_Activity_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>102</Piece>
</Data>
<Data name="MRADM_AdmReadmRehab_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>69</Piece>
</Data>
<Data name="MRADM_AdmRoute_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>34</Piece>
</Data>
<Data name="MRADM_AmbulanceCase">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>83</Piece>
</Data>
<Data name="MRADM_AutopsyType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>47</Piece>
</Data>
<Data name="MRADM_BPDiastolic">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>5</Piece>
</Data>
<Data name="MRADM_BPSystolic">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>4</Piece>
</Data>
<Data name="MRADM_BaseWIES">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>120</Piece>
</Data>
<Data name="MRADM_BloodSugarTestResult">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>17</Piece>
</Data>
<Data name="MRADM_BloodType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>18</Piece>
</Data>
<Data name="MRADM_CCUHours">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>111</Piece>
</Data>
<Data name="MRADM_CPAPHours">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>112</Piece>
</Data>
<Data name="MRADM_CarePlanEndDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>157</Piece>
</Data>
<Data name="MRADM_CarePlanReviewDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>156</Piece>
</Data>
<Data name="MRADM_CarePlanStartDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>155</Piece>
</Data>
<Data name="MRADM_CareType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>59</Piece>
</Data>
<Data name="MRADM_CarerAvail_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>58</Piece>
</Data>
<Data name="MRADM_CauseOfDeath_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>35</Piece>
</Data>
<Data name="MRADM_CeasarianSection">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>30</Piece>
</Data>
<Data name="MRADM_CodingUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>115</Piece>
</Data>
<Data name="MRADM_CodingUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>125</Piece>
</Data>
<Data name="MRADM_CodingUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>116</Piece>
</Data>
<Data name="MRADM_CodingUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>117</Piece>
</Data>
<Data name="MRADM_ConditAtDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>10</Piece>
</Data>
<Data name="MRADM_ConscState_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>100</Piece>
</Data>
<Data name="MRADM_ContrSpokeIdentif_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>65</Piece>
</Data>
<Data name="MRADM_ContractRole_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>64</Piece>
</Data>
<Data name="MRADM_ContractType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>63</Piece>
</Data>
<Data name="MRADM_DRGFirstDateProcessing">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>43</Piece>
</Data>
<Data name="MRADM_DRGLastDateProcessing">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>44</Piece>
</Data>
<Data name="MRADM_DRGProcessTimes">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>45</Piece>
</Data>
<Data name="MRADM_DRGTariff">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>46</Piece>
</Data>
<Data name="MRADM_DRG_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>42</Piece>
</Data>
<Data name="MRADM_DRG_Weighting">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>79</Piece>
</Data>
<Data name="MRADM_Date">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>1</Piece>
</Data>
<Data name="MRADM_DateHeight">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>77</Piece>
</Data>
<Data name="MRADM_DateProofPrinted">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>36</Piece>
</Data>
<Data name="MRADM_DateRangeFrom">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>38</Piece>
</Data>
<Data name="MRADM_DateRangeTo">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>39</Piece>
</Data>
<Data name="MRADM_DateSerumCreatinine">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>159</Piece>
</Data>
<Data name="MRADM_DateWeight">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>78</Piece>
</Data>
<Data name="MRADM_Deletion">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>71</Piece>
</Data>
<Data name="MRADM_DietComments">
<Node>"DIETCOM"</Node>
</Data>
<Data name="MRADM_DischBedMobility_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>105</Piece>
</Data>
<Data name="MRADM_DischClassif_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>54</Piece>
</Data>
<Data name="MRADM_DischDestin_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>51</Piece>
</Data>
<Data name="MRADM_DischEating_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>108</Piece>
</Data>
<Data name="MRADM_DischPallCare_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>104</Piece>
</Data>
<Data name="MRADM_DischRUGTotal">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>109</Piece>
</Data>
<Data name="MRADM_DischReasonBedUnAvail_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>113</Piece>
</Data>
<Data name="MRADM_DischToileting_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>106</Piece>
</Data>
<Data name="MRADM_DischTransfer_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>107</Piece>
</Data>
<Data name="MRADM_DischTransport_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>52</Piece>
</Data>
<Data name="MRADM_DischType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>11</Piece>
</Data>
<Data name="MRADM_DischargeDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>80</Piece>
</Data>
<Data name="MRADM_DocDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>15</Piece>
</Data>
<Data name="MRADM_DrainTubes_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>132</Piece>
</Data>
<Data name="MRADM_DurationMechVent">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>74</Piece>
</Data>
<Data name="MRADM_Ectopic">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>7</Piece>
</Data>
<Data name="MRADM_EscortSource_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>87</Piece>
</Data>
<Data name="MRADM_FundingArrang_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>62</Piece>
</Data>
<Data name="MRADM_GPConsent">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>82</Piece>
</Data>
<Data name="MRADM_GlasgowComaScore">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>151</Piece>
</Data>
<Data name="MRADM_GrouperStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>148</Piece>
</Data>
<Data name="MRADM_HeadCircumference">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>19</Piece>
</Data>
<Data name="MRADM_Height">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>20</Piece>
</Data>
<Data name="MRADM_HighOutlierDays">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>124</Piece>
</Data>
<Data name="MRADM_ICUHours">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>110</Piece>
</Data>
<Data name="MRADM_IVTherapy_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>129</Piece>
</Data>
<Data name="MRADM_InfectType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>13</Piece>
</Data>
<Data name="MRADM_InjuryDesc">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>90</Piece>
</Data>
<Data name="MRADM_InlierEquivalence">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>119</Piece>
</Data>
<Data name="MRADM_IntentReadmit_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>66</Piece>
</Data>
<Data name="MRADM_Isolation_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>131</Piece>
</Data>
<Data name="MRADM_KidneyTranspDes">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>21</Piece>
</Data>
<Data name="MRADM_KidneyTransplant">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>22</Piece>
</Data>
<Data name="MRADM_MaterType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>29</Piece>
</Data>
<Data name="MRADM_MedicSuffix_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>55</Piece>
</Data>
<Data name="MRADM_MedicallyFit">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>95</Piece>
</Data>
<Data name="MRADM_MentHealthStat_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>60</Piece>
</Data>
<Data name="MRADM_MultiVisitingHoursRanges">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>149</Piece>
</Data>
<Data name="MRADM_N1PrimaryNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>6</Piece>
</Data>
<Data name="MRADM_N1QualityNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>7</Piece>
</Data>
<Data name="MRADM_N2PrimaryNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>5</Piece>
</Data>
<Data name="MRADM_N2QualityNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>8</Piece>
</Data>
<Data name="MRADM_N3PrimaryNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>4</Piece>
</Data>
<Data name="MRADM_N4PrimaryNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>3</Piece>
</Data>
<Data name="MRADM_NoStillBirth">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>32</Piece>
</Data>
<Data name="MRADM_NumberOfDays">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>76</Piece>
</Data>
<Data name="MRADM_NurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>16</Piece>
</Data>
<Data name="MRADM_NursingHours">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>154</Piece>
</Data>
<Data name="MRADM_Objective">
<Node>"PRO",1,"OBJ"</Node>
</Data>
<Data name="MRADM_OnsetDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>68</Piece>
</Data>
<Data name="MRADM_OtherConditions_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>128</Piece>
</Data>
<Data name="MRADM_OtherDischType">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>12</Piece>
</Data>
<Data name="MRADM_OtherInfectType">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>14</Piece>
</Data>
<Data name="MRADM_OtherTransferReason">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>89</Piece>
</Data>
<Data name="MRADM_Overnight_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>103</Piece>
</Data>
<Data name="MRADM_OxygenSaturation">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>84</Piece>
</Data>
<Data name="MRADM_PACSDischargeDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>91</Piece>
</Data>
<Data name="MRADM_PCCL">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>142</Piece>
</Data>
<Data name="MRADM_PMUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>143</Piece>
</Data>
<Data name="MRADM_PMUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>146</Piece>
</Data>
<Data name="MRADM_PMUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>144</Piece>
</Data>
<Data name="MRADM_PMUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>145</Piece>
</Data>
<Data name="MRADM_PRS2Status">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>118</Piece>
</Data>
<Data name="MRADM_PainRange">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>153</Piece>
</Data>
<Data name="MRADM_PainScore">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>152</Piece>
</Data>
<Data name="MRADM_PatCondDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>133</Piece>
</Data>
<Data name="MRADM_PatCondTime">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>134</Piece>
</Data>
<Data name="MRADM_PatCond_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>40</Piece>
</Data>
<Data name="MRADM_PatInqUpdUserHosp_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>126</Piece>
</Data>
<Data name="MRADM_PatInqUpdUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>99</Piece>
</Data>
<Data name="MRADM_PatInqUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>98</Piece>
</Data>
<Data name="MRADM_PatInqUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>114</Piece>
</Data>
<Data name="MRADM_PatientRequirements">
<Node>"PRO",1,"REQ"</Node>
</Data>
<Data name="MRADM_PreHospTreatment">
<Node>"PRO","HOSP"</Node>
</Data>
<Data name="MRADM_Pregnancy_LMP">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>160</Piece>
</Data>
<Data name="MRADM_PresentComplaint">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>81</Piece>
</Data>
<Data name="MRADM_PrimaryNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>1</Piece>
</Data>
<Data name="MRADM_ProgrFundSource_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>61</Piece>
</Data>
<Data name="MRADM_ProgressDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>135</Piece>
</Data>
<Data name="MRADM_ProgressTime">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>136</Piece>
</Data>
<Data name="MRADM_Progress_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>101</Piece>
</Data>
<Data name="MRADM_PulseRate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>6</Piece>
</Data>
<Data name="MRADM_ReasonCritCareTrans_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>67</Piece>
</Data>
<Data name="MRADM_ReasonForRevFinDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>53</Piece>
</Data>
<Data name="MRADM_ReasonTransfer_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>86</Piece>
</Data>
<Data name="MRADM_RecordsToResubmit">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>150</Piece>
</Data>
<Data name="MRADM_RefBookDate">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>92</Piece>
</Data>
<Data name="MRADM_RefClin_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>48</Piece>
</Data>
<Data name="MRADM_ReferredTo_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>88</Piece>
</Data>
<Data name="MRADM_Remarks">
<Node>"PRO",1,"REM"</Node>
</Data>
<Data name="MRADM_Resend">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>72</Piece>
</Data>
<Data name="MRADM_Resp">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>8</Piece>
</Data>
<Data name="MRADM_RestPeriodFrom">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>139</Piece>
</Data>
<Data name="MRADM_RestPeriodTo">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>140</Piece>
</Data>
<Data name="MRADM_RingWard">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>96</Piece>
</Data>
<Data name="MRADM_SentPRS2">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>73</Piece>
</Data>
<Data name="MRADM_SeparationReferral_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>57</Piece>
</Data>
<Data name="MRADM_SeqNo">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>37</Piece>
</Data>
<Data name="MRADM_SerumCreatinine">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>158</Piece>
</Data>
<Data name="MRADM_SourceReferralPalCare_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>70</Piece>
</Data>
<Data name="MRADM_SpecialInstr">
<Node>"PRO",1,"SPC"</Node>
</Data>
<Data name="MRADM_Subjective">
<Node>"PRO",1,"SBJ"</Node>
</Data>
<Data name="MRADM_TakingCalls">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>97</Piece>
</Data>
<Data name="MRADM_Temp">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>3</Piece>
</Data>
<Data name="MRADM_Time">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>2</Piece>
</Data>
<Data name="MRADM_TotalWIESPrice">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>123</Piece>
</Data>
<Data name="MRADM_TotalWIESScore">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>122</Piece>
</Data>
<Data name="MRADM_Traffic_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>50</Piece>
</Data>
<Data name="MRADM_TransDest2_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>94</Piece>
</Data>
<Data name="MRADM_TransfDest_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>85</Piece>
</Data>
<Data name="MRADM_TransferDateRefCln">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>75</Piece>
</Data>
<Data name="MRADM_TransferMeans_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>49</Piece>
</Data>
<Data name="MRADM_TubalLigation">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>31</Piece>
</Data>
<Data name="MRADM_Tumor_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>28</Piece>
</Data>
<Data name="MRADM_UnplanReadmission_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>141</Piece>
</Data>
<Data name="MRADM_UrineSugarTestResult">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>23</Piece>
</Data>
<Data name="MRADM_Ventilation_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>130</Piece>
</Data>
<Data name="MRADM_VisionScoreLeft">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>24</Piece>
</Data>
<Data name="MRADM_VisionScoreRight">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>25</Piece>
</Data>
<Data name="MRADM_VisitHrFrom">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>137</Piece>
</Data>
<Data name="MRADM_VisitHrTo">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>138</Piece>
</Data>
<Data name="MRADM_VisitType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>93</Piece>
</Data>
<Data name="MRADM_VisitorStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>41</Piece>
</Data>
<Data name="MRADM_WaistCircumference">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>26</Piece>
</Data>
<Data name="MRADM_WardNurseDisch_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1,"NUR"</Node>
<Piece>2</Piece>
</Data>
<Data name="MRADM_Weight">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>27</Piece>
</Data>
<Data name="MRADM_WorkingDiagnosis_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>127</Piece>
</Data>
<Data name="MRADM_WoundType_DR">
<Delimiter>"^"</Delimiter>
<Node>"PRO",1</Node>
<Piece>33</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MRADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRADM_RowId</SqlRowIdName>
<StreamLocation>^User.MRAdmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
