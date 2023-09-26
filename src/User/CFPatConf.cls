/// Patient Config         (PATCF,5004)
Class User.CFPatConf Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_PatConf, StorageStrategy = SQLStorage ]
{

/// Configuration Desc
Property PATCFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PATCF_Description ];

/// In Patient Number
Property PATCFIPNo As %String(DISPLAYLIST = ",Counter Generated,User Assigned,Either", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",C,U,E") [ SqlColumnNumber = 3, SqlFieldName = PATCF_IPNo ];

/// Out Patient Number
Property PATCFOPNo As %String(DISPLAYLIST = ",Counter Generated,User Assigned,Either", MAXLEN = 18, TRUNCATE = 1, VALUELIST = ",C,U,E") [ SqlColumnNumber = 4, SqlFieldName = PATCF_OPNo ];

/// Same Numbers For In/Out Patient
Property PATCFIPOPSame As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = PATCF_IPOPSame ];

/// Print Label for New Patient
Property PATCFPrLabNewPat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 6, SqlFieldName = PATCF_PrLabNewPat ];

/// In Patient Number Prefix
Property PATCFIPNoPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PATCF_IPNoPrefix ];

/// Out Patient Number Prefix
Property PATCFOPNoPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PATCF_OPNoPrefix ];

/// In Patient Number Suffix
Property PATCFIPNoSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PATCF_IPNoSuffix ];

/// Out Patient Number Suffix
Property PATCFOPNoSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PATCF_OPNoSuffix ];

/// In Pat / Out Pat Admission Number Same
Property PATCFIPOPAdmNoSame As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PATCF_IPOPAdmNoSame ];

/// In Patient Admission Number
Property PATCFIPAdmNo As %String(DISPLAYLIST = ",System Counter,Patient Number and Counter,Patient Number and System Counter", MAXLEN = 33, TRUNCATE = 1, VALUELIST = ",SC,PNPC,PNSC") [ SqlColumnNumber = 12, SqlFieldName = PATCF_IPAdmNo ];

/// Out Patient Admission Number
Property PATCFOPAdmNo As %String(DISPLAYLIST = ",System Counter,Patient Number And Counter,Patient Number And System Counter", MAXLEN = 33, TRUNCATE = 1, VALUELIST = ",SC,PNPC,PNSC") [ SqlColumnNumber = 13, SqlFieldName = PATCF_OPAdmNo ];

/// In Patient Admission Number Prefix
Property PATCFIPAdmNoPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PATCF_IPAdmNoPrefix ];

/// In Patient Admission Number Suffix
Property PATCFIPAdmNoSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PATCF_IPAdmNoSuffix ];

/// Out Patient Admission Number Prefix
Property PATCFOPAdmNoPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PATCF_OPAdmNoPrefix ];

/// Out Patient Admission Number Suffix
Property PATCFOPAdmNoSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PATCF_OPAdmNoSuffix ];

/// Emergency Admission Number Prefix
Property PATCFEMAdmNoPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PATCF_EMAdmNoPrefix ];

/// Emergency Admission Number Suffix
Property PATCFEMAdmNoSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PATCF_EMAdmNoSuffix ];

/// Default Number Of Labels
Property PATCFDefaultNoLabels As %Float [ SqlColumnNumber = 21, SqlFieldName = PATCF_DefaultNoLabels ];

/// Default Out Patient Visit Type
Property PATCFDefaultOPVisTypDR As CTVisType [ SqlColumnNumber = 23, SqlFieldName = PATCF_DefaultOPVisTypDR ];

/// Computers in Ward
Property PATCFComputersInWard As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = PATCF_ComputersInWard ];

/// Next Of Kin
Property PATCFNextOfKin As %String(DISPLAYLIST = ",This Patient Record,Separate Person Record", MAXLEN = 22, TRUNCATE = 1, VALUELIST = ",T,S") [ SqlColumnNumber = 25, SqlFieldName = PATCF_NextOfKin ];

/// Allow In Pat Discharge W/O Fin Discharge
Property PATCFAllowInpatDischWOFin As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = PATCF_AllowInpatDischWOFin ];

/// Des Ref CTLOC
Property PATCFOperRoomDR As CTLoc [ SqlColumnNumber = 28, SqlFieldName = PATCF_OperRoom_DR ];

/// Des Ref OUTS type
Property PATCFDefaultDiscretOutType As ARCDisretOutstType [ SqlColumnNumber = 29, SqlFieldName = PATCF_DefaultDiscretOutType ];

/// In Patient Admission Number Delimiter
Property PATCFIPAdmNoDelim As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = PATCF_IPAdmNoDelim ];

/// Out Patient Admission Number Delimiter
Property PATCFOPAdmNoDelim As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = PATCF_OPAdmNoDelim ];

/// Emergency Admission Number Delimiter
Property PATCFEMAdmNoDelim As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = PATCF_EMAdmNoDelim ];

/// Pre Admission No Prefix
Property PATCFPAAdmNoPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = PATCF_PAAdmNoPrefix ];

/// Pre Admission Number Delimiter
Property PATCFPAAdmNoDelim As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 37, SqlFieldName = PATCF_PAAdmNoDelim ];

/// Pre Admission No Suffix
Property PATCFPAAdmNoSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = PATCF_PAAdmNoSuffix ];

/// Out Patient Number Only
Property PATCFOPNoOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 39, SqlFieldName = PATCF_OPNoOnly ];

/// In Patient Number Only
Property PATCFIPNoOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 40, SqlFieldName = PATCF_IPNoOnly ];

/// Default Nursery Ward (On Assignment)
Property PATCFDefaultNurseryWard As PACWard [ SqlColumnNumber = 41, SqlFieldName = PATCF_DefaultNurseryWard ];

/// Default Out Patient Que Priority
Property PATCFDefaultOPQuePriorityDR As CTAcuity [ SqlColumnNumber = 42, SqlFieldName = PATCF_DefaultOPQuePriorityDR ];

/// Default Emergency Que Priority
Property PATCFDefaultEMQuePriorityDR As CTAcuity [ SqlColumnNumber = 43, SqlFieldName = PATCF_DefaultEMQuePriorityDR ];

/// Not Used Default Print Language
Property PATCFDefaultPrintLanguageDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = PATCF_DefaultPrintLanguageDR ];

/// Queue Counter Method
Property PATCFQue1CounterMethod As %String(DISPLAYLIST = ",System Counter,Care Provider", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",S,C") [ SqlColumnNumber = 45, SqlFieldName = PATCF_Que1CounterMethod ];

/// Default Admitting Service
Property PATCFDefaultIPVisitTypeDR As CTVisType [ SqlColumnNumber = 46, SqlFieldName = PATCF_DefaultIPVisitTypeDR ];

/// Des Ref RB_Resource
Property PATCFDefOperResourceDR As RBResource [ SqlColumnNumber = 47, SqlFieldName = PATCF_DefOperResource_DR ];

/// Automatic Print 1 On Registration
Property PATCFPrintAutom1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 48, SqlFieldName = PATCF_PrintAutom1 ];

/// Automatic Print 2
Property PATCFPrintAutom2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 49, SqlFieldName = PATCF_PrintAutom2 ];

/// Skip Patient Type
Property PATCFSkipPatientType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 50, SqlFieldName = PATCF_SkipPatientType ];

/// Des Ref Epis SubType
Property PATCFDaySurgeryTypeDR As PACEpisodeSubType [ InitialExpression = 0, SqlColumnNumber = 51, SqlFieldName = PATCF_DaySurgeryType_DR ];

/// Nursery Bed Cleanup Hours
Property PATCFNurseryBedCleanupHours As %Float [ SqlColumnNumber = 52, SqlFieldName = PATCF_NurseryBedCleanupHours ];

/// Discharge Policy
Property PATCFDischargePolicy As %String(DISPLAYLIST = ",Release First,Do Not Release First", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 53, SqlFieldName = PATCF_DischargePolicy ];

/// Verify New Admissions
Property PATCFVerifyNewAdmissions As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 54, SqlFieldName = PATCF_VerifyNewAdmissions ];

/// Default Use Logon Dept As Default
Property PATCFDefaultUseDeptAsDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 55, SqlFieldName = PATCF_DefaultUseDeptAsDefault ];

/// Emergency Admission Number Length
Property PATCFEMAdmNoLength As %Float(MAXVAL = 10, MINVAL = 1) [ SqlColumnNumber = 56, SqlFieldName = PATCF_EMAdmNoLength ];

/// In Patient Admission Number Length
Property PATCFIPAdmNoLength As %Float(MAXVAL = 30, MINVAL = 1) [ SqlColumnNumber = 57, SqlFieldName = PATCF_IPAdmNoLength ];

/// Pre Admission Number Length
Property PATCFPAAdmNoLength As %Float(MAXVAL = 30, MINVAL = 1) [ SqlColumnNumber = 58, SqlFieldName = PATCF_PAAdmNoLength ];

/// In Patient Number Length
Property PATCFIPNoLength As %Float(MAXVAL = 12, MINVAL = 1) [ SqlColumnNumber = 59, SqlFieldName = PATCF_IPNoLength ];

/// Out Patient Number Length
Property PATCFOPNoLength As %Float(MAXVAL = 12, MINVAL = 1) [ SqlColumnNumber = 60, SqlFieldName = PATCF_OPNoLength ];

/// Out Patient Number Length
Property PATCFOPAdmNoLength As %Float(MAXVAL = 30, MINVAL = 1) [ SqlColumnNumber = 61, SqlFieldName = PATCF_OPAdmNoLength ];

/// Disch Grace Priod
Property PATCFDischGracePeriod As %Float [ SqlColumnNumber = 62, SqlFieldName = PATCF_DischGracePeriod ];

/// Admission Cancellation Grace Period
Property PATCFAdmCancelGracePeriod As %Float(MAXVAL = 24, MINVAL = 0) [ SqlColumnNumber = 63, SqlFieldName = PATCF_AdmCancelGracePeriod ];

/// Bed Transfer Reversal Grace Period
Property PATCFTrfCancelGracePeriod As %Float(MAXVAL = 24, MINVAL = 0) [ SqlColumnNumber = 64, SqlFieldName = PATCF_TrfCancelGracePeriod ];

/// Automatically Print Registration Card
Property PATCFPrintRegisCard As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 65, SqlFieldName = PATCF_PrintRegisCard ];

/// Anaest. Prefix
Property PATCFAnaestPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 66, SqlFieldName = PATCF_AnaestPrefix ];

/// Anaest. Suffix
Property PATCFAnaestSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 67, SqlFieldName = PATCF_AnaestSuffix ];

/// Anaest. Length
Property PATCFAnaestLength As %Float [ SqlColumnNumber = 68, SqlFieldName = PATCF_AnaestLength ];

/// Oper. Prefix
Property PATCFOperPrefix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 69, SqlFieldName = PATCF_OperPrefix ];

/// Oper. Suffix
Property PATCFOperSuffix As %String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 70, SqlFieldName = PATCF_OperSuffix ];

/// Oper. Length
Property PATCFOperLength As %Float [ SqlColumnNumber = 71, SqlFieldName = PATCF_OperLength ];

/// Des PAC TransReqStatus
Property PATCFDefaultReqStatusDR As PACTransfRequestStatus [ SqlColumnNumber = 72, SqlFieldName = PATCF_DefaultReqStatus_DR ];

/// Print the discharge confirmation sheet
Property PATCFPrintDischargeConf As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 73, SqlFieldName = PATCF_PrintDischargeConf ];

/// Print the admission notification slip
Property PATCFPrintAdmissionNotif As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 74, SqlFieldName = PATCF_PrintAdmissionNotif ];

/// Emergency Surcharge Charge Code
Property PATCFEmergencySurChargeCode As ARCItmMast [ SqlColumnNumber = 75, SqlFieldName = PATCF_EmergencySurChargeCode ];

/// Insurance Card Holder Code
Property PATCFInsuranceCardHolder As CTRelation [ SqlColumnNumber = 76, SqlFieldName = PATCF_InsuranceCardHolder ];

/// Proof Prefix 1
Property PATCFProofPrefix1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 77, SqlFieldName = PATCF_ProofPrefix1 ];

/// Proof Prefix 2
Property PATCFProofPrefix2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 78, SqlFieldName = PATCF_ProofPrefix2 ];

/// Emergency Discharge Details
Property PATCFEmergDischDetails As %String(DISPLAYLIST = ",Full Details,Brief Details", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",F,B") [ SqlColumnNumber = 79, SqlFieldName = PATCF_EmergDischDetails ];

/// Collect Registration Fee
Property PATCFCollectRegistrFee As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 80, SqlFieldName = PATCF_CollectRegistrFee ];

/// Choose Referal Doctor From List
Property PATCFChooseReferalDoctorFromLis As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 81, SqlFieldName = PATCF_ChooseReferalDoctorFromList ];

/// Print Bill On Payment
Property PATCFPrintBillOnPayment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 82, SqlFieldName = PATCF_PrintBillOnPayment ];

/// Print Admission Sheet On Payment
Property PATCFPrintAdmSheetOnPaym As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 83, SqlFieldName = PATCF_PrintAdmSheetOnPaym ];

/// Print Appointment Slip
Property PATCFPrintAppointmentSlip As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = PATCF_PrintAppointmentSlip ];

/// Is Referal Doctor Mandatory Field ?
Property PATCFIsRefDoctorMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 85, SqlFieldName = PATCF_IsRefDoctorMandatory ];

/// Show Order Entry  Message On Admission Update
Property PATCFShowOEMessageOnAdmUpdate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 86, SqlFieldName = PATCF_ShowOEMessageOnAdmUpdate ];

/// Des Ref CTLOC
Property PATCFDefNewBornDepDR As CTLoc [ SqlColumnNumber = 87, SqlFieldName = PATCF_DefNewBornDep_DR ];

/// No of Fields for Patient Name
Property PATCFNoFieldsPatName As %Float [ SqlColumnNumber = 88, SqlFieldName = PATCF_NoFieldsPatName ];

/// Allow Self Admission
Property PATCFAllowSelfAdmission As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = PATCF_AllowSelfAdmission ];

/// Is Doctor Mandatory ?
Property PATCFIsDoctorMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 90, SqlFieldName = PATCF_IsDoctorMandatory ];

/// Combine Episodes and Processes
Property PATCFProcess As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 91, SqlFieldName = PATCF_Process ];

/// Generate Registation Number on
Property PATCFGenerateRego As %String(DISPLAYLIST = ",Admission,PreAdmission,Patient Entry", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",A,P,E") [ SqlColumnNumber = 92, SqlFieldName = PATCF_GenerateRego ];

/// Process Prefix
Property PATCFProcessPrefix As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 93, SqlFieldName = PATCF_ProcessPrefix ];

/// Process Suffix
Property PATCFProcessSuffix As %String(COLLATION = "AlphaUp", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 94, SqlFieldName = PATCF_ProcessSuffix ];

/// Process Length
Property PATCFProcessLength As %Float [ SqlColumnNumber = 95, SqlFieldName = PATCF_ProcessLength ];

/// Des Ref ARCIM
Property PATCFEmergencyOrderDR As ARCItmMast [ SqlColumnNumber = 96, SqlFieldName = PATCF_EmergencyOrder_DR ];

/// Assign Department To Bed
Property PATCFAssignDepartmentToBed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 97, SqlFieldName = PATCF_AssignDepartmentToBed ];

/// Allow to Enter Diagnosis on Discharge
Property PATCFAllowEnterDiagnosisDischar As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 98, SqlFieldName = PATCF_AllowEnterDiagnosisDischarge ];

/// Show Previous EMR
Property PATCFShowPreviousEMR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 99, SqlFieldName = PATCF_ShowPreviousEMR ];

/// Zip Codes Setup
Property PATCFZipCodesSetup As %String(DISPLAYLIST = ",Description of City,Reference to City,Reference to City w/o Zip Code", MAXLEN = 30, TRUNCATE = 1, VALUELIST = ",D,R,W") [ SqlColumnNumber = 100, SqlFieldName = PATCF_ZipCodesSetup ];

/// Default Tab In Registration
Property PATCFDefaultTabInRegistration As %Numeric(MAXVAL = 100, MINVAL = 0, SCALE = 0) [ SqlColumnNumber = 101, SqlFieldName = PATCF_DefaultTabInRegistration ];

/// Put Emergency Patient in Non-Emergency Bed
Property PATCFEmergencyPatBedOption As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 102, SqlFieldName = PATCF_EmergencyPatBedOption ];

/// Use DRG Grouper
Property PATCFUseDRGGrouper As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 103, SqlFieldName = PATCF_UseDRGGrouper ];

/// Allow Direct Cash Payment
Property PATCFAllowDirectCashPayment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 104, SqlFieldName = PATCF_AllowDirectCashPayment ];

/// Extend Diagnosis ListBox to Full Screen
Property PATCFExtendDiagnosis As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 105, SqlFieldName = PATCF_ExtendDiagnosis ];

/// Des Ref InsType
Property PATCFDefaultInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 106, SqlFieldName = PATCF_DefaultInsType_DR ];

/// Des REf Tariff
Property PATCFDefaultTariffDR As ARCTariff [ SqlColumnNumber = 107, SqlFieldName = PATCF_DefaultTariff_DR ];

/// Disable Insurance Office Combo
Property PATCFDisableInsuranceOfficeComb As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 108, SqlFieldName = PATCF_DisableInsuranceOfficeCombo ];

/// Des Ref Resource
Property PATCFRBResourceDR As RBResource [ SqlColumnNumber = 109, SqlFieldName = PATCF_RBResource_DR ];

/// maximum Text Field Length
Property PATCFFieldLength As %Numeric(SCALE = 0) [ SqlColumnNumber = 110, SqlFieldName = PATCF_FieldLength ];

/// Restrict to Single Diagnosis Type
Property PATCFRestrictSingleDiagType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 111, SqlFieldName = PATCF_RestrictSingleDiagType ];

/// Des Ref Sex
Property PATCFFemaleSexDR As CTSex [ SqlColumnNumber = 112, SqlFieldName = PATCF_FemaleSex_DR ];

/// Show Reason for Change Pat Data
Property PATCFShowreasonChangePatData As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 113, SqlFieldName = PATCF_ShowreasonChangePatData ];

/// Des Ref CounterType
Property PATCFExemptionCounterTypeDR As PACCounterType [ SqlColumnNumber = 114, SqlFieldName = PATCF_ExemptionCounterType_DR ];

/// Display Reg Details After Bed Assignment
Property PATCFDisplayRegDetAfterBedAssig As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 115, SqlFieldName = PATCF_DisplayRegDetAfterBedAssign ];

/// Des Ref CTSEX
Property PATCFMaleSexDR As CTSex [ SqlColumnNumber = 116, SqlFieldName = PATCF_MaleSex_DR ];

/// Use Bed Management Screen
Property PATCFUseBedManagementScreen As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 117, SqlFieldName = PATCF_UseBedManagementScreen ];

/// Complete On Zero Bills
Property PATCFCompleteOnZeroBills As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 118, SqlFieldName = PATCF_CompleteOnZeroBills ];

/// Lab Episode Number Method
Property PATCFLabEpisodeNumberMethod As %String(DISPLAYLIST = ",System Counter,Daily Counter,User Defined Counter", MAXLEN = 20, TRUNCATE = 1, VALUELIST = ",S,D,U") [ SqlColumnNumber = 119, SqlFieldName = PATCF_LabEpisodeNumberMethod ];

/// Daily Counter Length
Property PATCFDailyCounterLength As %Float [ SqlColumnNumber = 120, SqlFieldName = PATCF_DailyCounterLength ];

/// Des Ref LabCounterType
Property PATCFLabCounterTypeDR As PACCounterType [ SqlColumnNumber = 121, SqlFieldName = PATCF_LabCounterType_DR ];

/// Default Zip Desc Into Address field
Property PATCFDefaultZipDescIntoAddress As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 122, SqlFieldName = PATCF_DefaultZipDescIntoAddress ];

/// Search By Keywords
Property PATCFSearchByKeywords As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 123, SqlFieldName = PATCF_SearchByKeywords ];

/// Price To Display On RB
Property PATCFPriceToDisplayOnRB As %String(DISPLAYLIST = ",Italian Price,Default Tariff", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",I,T") [ SqlColumnNumber = 124, SqlFieldName = PATCF_PriceToDisplayOnRB ];

/// Cut Off Time for Automatice Discharge
Property PATCFCutOffTimeDischarge As %Time [ SqlColumnNumber = 125, SqlFieldName = PATCF_CutOffTimeDischarge ];

/// Des Ref ARCIM
Property PATCFStampDutyChargeDR As ARCItmMast [ SqlColumnNumber = 126, SqlFieldName = PATCF_StampDutyCharge_DR ];

/// Ignore words shorter or equal to
Property PATCFKeywordLength As %Float [ SqlColumnNumber = 127, SqlFieldName = PATCF_KeywordLength ];

/// Same Bill for Patient and Payor
Property PATCFSameBillPatientPayor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 128, SqlFieldName = PATCF_SameBillPatientPayor ];

/// Show Preadm After Appoint
Property PATCFShowPreadmAfterAppoint As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 129, SqlFieldName = PATCF_ShowPreadmAfterAppoint ];

/// Des Ref HICClaimCounter
Property PATCFHICClaimCounterDR As PACCounterType [ SqlColumnNumber = 130, SqlFieldName = PATCF_HICClaimCounter_DR ];

/// Convert Currency In Billing
Property PATCFConvertCurrencyInBilling As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 131, SqlFieldName = PATCF_ConvertCurrencyInBilling ];

/// use Default Department as User login location
Property PATCFDefaultDepartUser As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 132, SqlFieldName = PATCF_DefaultDepartUser ];

/// Warn if user moves ORBooking to another Res
Property PATCFWarnORBookingMoveRes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 133, SqlFieldName = PATCF_WarnORBookingMoveRes ];

/// Do Not Allow ORBookings in the past
Property PATCFNAllORBookPast As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 134, SqlFieldName = PATCF_NAllORBookPast ];

/// Do Not Allow ORBooking in Non Session area
Property PATCFNAllORBookNoSess As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 135, SqlFieldName = PATCF_NAllORBookNoSess ];

/// Do Not Allow ORBookings in Not Avail area
Property PATCFNAllORBookNA As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 136, SqlFieldName = PATCF_NAllORBookNA ];

/// Show Referral Doctor Specialty
Property PATCFShowRefDoctorSpec As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 137, SqlFieldName = PATCF_ShowRefDoctorSpec ];

/// Generate Admission Number on
Property PATCFGenerateAdmNo As %String(DISPLAYLIST = ",Admission,PreAdmission", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",A,P") [ SqlColumnNumber = 138, SqlFieldName = PATCF_GenerateAdmNo ];

/// Use User Default Payor
Property PATCFUseUserDefPayor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 139, SqlFieldName = PATCF_UseUserDefPayor ];

/// Des Ref Language
Property PATCFLanguageDR As SSLanguage [ SqlColumnNumber = 140, SqlFieldName = PATCF_Language_DR ];

/// Arrive Patient On Registration
Property PATCFArrivePatientOnReg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 141, SqlFieldName = PATCF_ArrivePatientOnReg ];

/// Print RBINQ01
Property PATCFPrintRBINQ01 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 142, SqlFieldName = PATCF_PrintRBINQ01 ];

/// Print RBINQ02
Property PATCFPrintRBINQ02 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 143, SqlFieldName = PATCF_PrintRBINQ02 ];

/// Print RBINQ03
Property PATCFPrintRBINQ03 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 144, SqlFieldName = PATCF_PrintRBINQ03 ];

/// PrintWaitList
Property PATCFPrintWaitList As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 145, SqlFieldName = PATCF_PrintWaitList ];

/// Discontinue Orders On Discharge
Property PATCFDisconOrdersOnDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 146, SqlFieldName = PATCF_DisconOrdersOnDischarge ];

/// Des Ref UnavailBedStatus
Property PATCFUnavailBedStatus As PACBedReasonNotAvail [ SqlColumnNumber = 147, SqlFieldName = PATCF_UnavailBedStatus ];

/// Print Receipt
Property PATCFPrintReceipt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 148, SqlFieldName = PATCF_PrintReceipt ];

/// des ref Deceased WaitList
Property PATCFDeceasedWaitListDR As PACWaitingListStatus [ SqlColumnNumber = 149, SqlFieldName = PATCF_DeceasedWaitList_DR ];

/// Transfer Reason Mandatory
Property PATCFTransferReasonMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 150, SqlFieldName = PATCF_TransferReasonMandatory ];

/// Restrict Loc List
Property PATCFRestrictLocList As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 151, SqlFieldName = PATCF_RestrictLocList ];

/// PATMAN ReadOnly
Property PATCFPATMANReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 152, SqlFieldName = PATCF_PATMANReadOnly ];

/// HPPrefix
Property PATCFHPPrefix As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 153, SqlFieldName = PATCF_HPPrefix ];

/// HPSuffix
Property PATCFHPSuffix As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 154, SqlFieldName = PATCF_HPSuffix ];

/// HPLength
Property PATCFHPLength As %Float [ SqlColumnNumber = 155, SqlFieldName = PATCF_HPLength ];

/// Refresh PATMAN after OE
Property PATCFRefreshPATMANOE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 156, SqlFieldName = PATCF_RefreshPATMANOE ];

/// DisableMultiselectBills
Property PATCFDisableMultiselectBills As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 157, SqlFieldName = PATCF_DisableMultiselectBills ];

/// Enable Multiple Discounts Outs
Property PATCFEnableMultipleDiscountsOut As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 158, SqlFieldName = PATCF_EnableMultipleDiscountsOuts ];

/// Des Ref NewBornEpisSubType
Property PATCFNewBornEpisSubTypeDR As PACEpisodeSubType [ SqlColumnNumber = 159, SqlFieldName = PATCF_NewBornEpisSubType_DR ];

/// WLSortByDays
Property PATCFWLSortByDays As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 160, SqlFieldName = PATCF_WLSortByDays ];

/// UsePayorFromPrevEpisode
Property PATCFUsePayorFromPrevEpisode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 161, SqlFieldName = PATCF_UsePayorFromPrevEpisode ];

/// Default Adm Depart in BDMAN
Property PATCFDefAdmDepartBDMAN As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 162, SqlFieldName = PATCF_DefAdmDepartBDMAN ];

/// Des REf BedType
Property PATCFBedTypeDR As PACBedType [ SqlColumnNumber = 163, SqlFieldName = PATCF_BedType_DR ];

/// Default 2nd Tab in Episode Details
Property PATCFDef2ndTabEpisDetails As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 164, SqlFieldName = PATCF_Def2ndTabEpisDetails ];

/// Save Reg Num from Ext DB
Property PATCFSaveRegNumExtDB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 165, SqlFieldName = PATCF_SaveRegNumExtDB ];

/// Sort By Queue
Property PATCFSortByQueue As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 166, SqlFieldName = PATCF_SortByQueue ];

/// Des Ref MRCType1
Property PATCFMRCType1DR As MRCDiagnosType [ SqlColumnNumber = 167, SqlFieldName = PATCF_MRCType1_DR ];

/// Des Ref Diag Type2
Property PATCFMRCType2DR As MRCDiagnosType [ SqlColumnNumber = 168, SqlFieldName = PATCF_MRCType2_DR ];

/// Display OTC Payor
Property PATCFOTCPayor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 169, SqlFieldName = PATCF_OTCPayor ];

/// Des Ref CancelWListStatus
Property PATCFCancelWListStatusDR As PACWaitingListStatus [ SqlColumnNumber = 170, SqlFieldName = PATCF_CancelWListStatus_DR ];

/// RefreshCashiierAfterOE
Property PATCFRefreshCashiierAfterOE As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 171, SqlFieldName = PATCF_RefreshCashiierAfterOE ];

/// Des Ref PatTypeOutPat
Property PATCFPatTypeOutPat As PACPatientType [ SqlColumnNumber = 172, SqlFieldName = PATCF_PatTypeOutPat ];

/// Des Ref PatTypeInPat
Property PATCFPatTypeInPat As PACPatientType [ SqlColumnNumber = 173, SqlFieldName = PATCF_PatTypeInPat ];

/// Des Ref PatTypeEmerg
Property PATCFPatTypeEmerg As PACPatientType [ SqlColumnNumber = 174, SqlFieldName = PATCF_PatTypeEmerg ];

/// Des Ref PatTypeHealthProm
Property PATCFPatTypeHealthProm As PACPatientType [ SqlColumnNumber = 175, SqlFieldName = PATCF_PatTypeHealthProm ];

/// Set WL Status to Initial OnCancel
Property PATCFWLStatInitOnCancel As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 176, SqlFieldName = PATCF_WLStatInitOnCancel ];

/// Reason for Cancel Bill
Property PATCFReasonCancelBill As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 177, SqlFieldName = PATCF_ReasonCancelBill ];

/// Restrict Neg Outs Amt
Property PATCFRestrictNegOutsAmt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 178, SqlFieldName = PATCF_RestrictNegOutsAmt ];

/// No Of Years Age Search
Property PATCFNoOfYearsAgeSearch As %Float [ SqlColumnNumber = 179, SqlFieldName = PATCF_NoOfYearsAgeSearch ];

/// Des Ref ContactType
Property PATCFContactTypeDR As PACContactType [ SqlColumnNumber = 180, SqlFieldName = PATCF_ContactType_DR ];

/// Des Ref Allergy
Property PATCFAllergyDR As PACAllergy [ SqlColumnNumber = 181, SqlFieldName = PATCF_Allergy_DR ];

/// Male Pension Age
Property PATCFMalePensionAge As %Float [ SqlColumnNumber = 182, SqlFieldName = PATCF_MalePensionAge ];

/// Female Pension Age
Property PATCFFemalePensionAge As %Float [ SqlColumnNumber = 183, SqlFieldName = PATCF_FemalePensionAge ];

/// Allow Partial Payment of Payor Bill
Property PATCFAllowPartialPaymentPayorBi As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 184, SqlFieldName = PATCF_AllowPartialPaymentPayorBill ];

/// Max Days On Leave w/o discharge
Property PATCFMaxDaysOnLeave As %Float [ SqlColumnNumber = 185, SqlFieldName = PATCF_MaxDaysOnLeave ];

/// Use Emergency As StandAlone 
Property PATCFEmergStandAlone As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 186, SqlFieldName = PATCF_EmergStandAlone ];

/// Des Ref WLStatOnAdm
Property PATCFWLStatOnAdmDR As PACWaitingListStatus [ SqlColumnNumber = 187, SqlFieldName = PATCF_WLStatOnAdm_DR ];

/// Allow Overlapping Suspensions
Property PATCFAllOverlapSuspens As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 188, SqlFieldName = PATCF_AllOverlapSuspens ];

/// Apply Max Patient Discount
Property PATCFApplyMaxPatDiscount As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 189, SqlFieldName = PATCF_ApplyMaxPatDiscount ];

/// Suppress MR same as Rego
Property PATCFSuppressMRRego As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 190, SqlFieldName = PATCF_SuppressMRRego ];

/// AutomaticReadLinkedProviders
Property PATCFAutomaticReadLinkedProvide As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 191, SqlFieldName = PATCF_AutomaticReadLinkedProviders ];

/// Show Months When Inactive
Property PATCFShowMonthsWhenInactive As %Float [ SqlColumnNumber = 192, SqlFieldName = PATCF_ShowMonthsWhenInactive ];

/// Place Patients In Holding Area
Property PATCFPlacePatInHoldArea As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 193, SqlFieldName = PATCF_PlacePatInHoldArea ];

/// SetAppToBook
Property PATCFSetAppToBook As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 194, SqlFieldName = PATCF_SetAppToBook ];

/// SearchOnExactMRN
Property PATCFSearchOnExactMRN As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 195, SqlFieldName = PATCF_SearchOnExactMRN ];

/// Use WIES and VIC-DRG functionality
Property PATCFUseWIESVICDRGFunction As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 196, SqlFieldName = PATCF_UseWIESVICDRGFunction ];

/// Eligible For Mechanical Vent Copayment
Property PATCFEligMechVentCopayment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 197, SqlFieldName = PATCF_EligMechVentCopayment ];

/// Do Not Generate PRN for Emergency Patients
Property PATCFNoGenPRNforEMergPats As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 198, SqlFieldName = PATCF_NoGenPRNforEMergPats ];

/// Use Client Based DRG Grouper
Property PATCFUseClientBasedDRGGrouper As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 199, SqlFieldName = PATCF_UseClientBasedDRGGrouper ];

/// Use CRAFT Functionality
Property PATCFUseCRAFTFunctionality As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 200, SqlFieldName = PATCF_UseCRAFTFunctionality ];

/// NotPopDischDateTimeOnLeave
Property PATCFNotPopDischDateTimeOnLeave As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 201, SqlFieldName = PATCF_NotPopDischDateTimeOnLeave ];

/// EligMechVentCopaymentNICU
Property PATCFEligMechVentCopaymentNICU As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 202, SqlFieldName = PATCF_EligMechVentCopaymentNICU ];

/// Use Bed Req Date Time f PreAdm from Emergency
Property PATCFUseBedReqDateTimeEm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 203, SqlFieldName = PATCF_UseBedReqDateTimeEm ];

/// Allow Overlap GP
Property PATCFAllowOverlapGP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 204, SqlFieldName = PATCF_AllowOverlapGP ];

/// Allow WL Changes After Admission
Property PATCFAllowWLChangesAfterAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 205, SqlFieldName = PATCF_AllowWLChangesAfterAdm ];

/// Pregnancy Check Age From
Property PATCFPregnancyCheckAgeFrom As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 206, SqlFieldName = PATCF_PregnancyCheckAgeFrom ];

/// Pregnancy Check Age To
Property PATCFPregnancyCheckAgeTo As %Float(MAXVAL = 100, MINVAL = 0) [ SqlColumnNumber = 207, SqlFieldName = PATCF_PregnancyCheckAgeTo ];

/// Clear WLApptDate on Cancel From OutPat
Property PATCFClearWLApptDateOutPCancel As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 208, SqlFieldName = PATCF_ClearWLApptDateOutPCancel ];

/// Use Discharge Date/Time on Admission
Property PATCFUseDischargeDateTimeAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 209, SqlFieldName = PATCF_UseDischargeDateTimeAdm ];

/// Upper Limit Display Days
Property PATCFUpperLimitDisplayDays As %Float [ SqlColumnNumber = 210, SqlFieldName = PATCF_UpperLimitDisplayDays ];

/// Upper Limit Display Weeks
Property PATCFUpperLimitDisplayWeeks As %Float [ SqlColumnNumber = 211, SqlFieldName = PATCF_UpperLimitDisplayWeeks ];

/// Upper Limit Display Months
Property PATCFUpperLimitDisplayMonths As %Float [ SqlColumnNumber = 212, SqlFieldName = PATCF_UpperLimitDisplayMonths ];

/// Bed Request Hours
Property PATCFBedRequestHours As %Float [ SqlColumnNumber = 213, SqlFieldName = PATCF_BedRequestHours ];

/// No Ed Transaction
Property PATCFNoEdTransaction As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 214, SqlFieldName = PATCF_NoEdTransaction ];

/// Do Not Create Trans on Adm From DE
Property PATCFDoNotCreateTransAdmFromED As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 215, SqlFieldName = PATCF_DoNotCreateTransAdmFromED ];

/// Title Of Deceased Patient
Property PATCFTitleOfDeceasedPat As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 216, SqlFieldName = PATCF_TitleOfDeceasedPat ];

/// Parent Guardian Title
Property PATCFParentGuardianTitle As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 217, SqlFieldName = PATCF_ParentGuardianTitle ];

/// Age Cut Off for Minors
Property PATCFAgeCutOffMinors As %Float [ SqlColumnNumber = 218, SqlFieldName = PATCF_AgeCutOffMinors ];

/// SMR Reporting
Property PATCFSMRReporting As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 219, SqlFieldName = PATCF_SMRReporting ];

/// Number of Days To Include Discharged Patients
Property PATCFDaysToIncludeDischPat As %Float [ SqlColumnNumber = 220, SqlFieldName = PATCF_DaysToIncludeDischPat ];

/// UseMaxDaysOnLeaveDisch
Property PATCFUseMaxDaysOnLeaveDisch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 221, SqlFieldName = PATCF_UseMaxDaysOnLeaveDisch ];

/// Allow MultipleActiveGP
Property PATCFAllowMultipleActiveGP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 222, SqlFieldName = PATCF_AllowMultipleActiveGP ];

/// Include Disch Pats for IP search
Property PATCFIPInclDischPat As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 223, SqlFieldName = PATCF_IPInclDischPat ];

/// Search On Month
Property PATCFSearchOnMonth As %String(COLLATION = "Exact", MAXLEN = 630, TRUNCATE = 1) [ SqlColumnNumber = 224, SqlFieldName = PATCF_SearchOnMonth ];

/// No of Rows to display for Diag and Proc
Property PATCFNoRowsDiagProc As %Float [ SqlColumnNumber = 225, SqlFieldName = PATCF_NoRowsDiagProc ];

/// No of Days For Adms Search to Copy from
Property PATCFNoDaysForAdmSearchToCopyFr As %Float [ SqlColumnNumber = 226, SqlFieldName = PATCF_NoDaysForAdmSearchToCopyFrom ];

/// Save Outpatient Episode Upon InPat Conversion
Property PATCFSaveOutPatEpUponInConv As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 227, SqlFieldName = PATCF_SaveOutPatEpUponInConv ];

/// Limit Number of Days for Search
Property PATCFLimitNoDaysForSearch As %Float [ SqlColumnNumber = 228, SqlFieldName = PATCF_LimitNoDaysForSearch ];

/// Apply New Room Rates for existing patients
Property PATCFApplyNewRoomRates As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 229, SqlFieldName = PATCF_ApplyNewRoomRates ];

/// Confirm to Create Alias Sex/DOB
Property PATCFConfirmCreateAliasSexDOB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 230, SqlFieldName = PATCF_ConfirmCreateAliasSexDOB ];

/// Sort by Surname First Other name
Property PATCFSortBySurnameFirstOther As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 231, SqlFieldName = PATCF_SortBySurnameFirstOther ];

/// Do not discharge outpatient epis on decease
Property PATCFDontDischOutPatOnDecease As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 232, SqlFieldName = PATCF_DontDischOutPatOnDecease ];

/// Reset WL Days on Priority Increase
Property PATCFResetWLDaysPriorIncrease As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 233, SqlFieldName = PATCF_ResetWLDaysPriorIncrease ];

/// Error on Extract if Coding Incomplete
Property PATCFErrorOnExtractCodingIncomp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 234, SqlFieldName = PATCF_ErrorOnExtractCodingIncomplete ];

/// Include Records after Extract EndDate
Property PATCFInclRecsAfterExtrctEndDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 235, SqlFieldName = PATCF_InclRecsAfterExtrctEndDate ];

/// Allow Partial Payment System Bill
Property PATCFAllowPartialPaymentSystemB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 236, SqlFieldName = PATCF_AllowPartialPaymentSystemBill ];

/// Hospital linked thr Bed Dept Allocation
Property PATCFHospLinkedThrBedDepAlloc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 237, SqlFieldName = PATCF_HospLinkedThrBedDepAlloc ];

/// Add Linked Plans OnAdm
Property PATCFAddLinkedPlansOnAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 238, SqlFieldName = PATCF_AddLinkedPlansOnAdm ];

/// Allow Overlap IP Episodes
Property PATCFAllowOverlapIPEpisodes As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 239, SqlFieldName = PATCF_AllowOverlapIPEpisodes ];

/// Allow Edit CP for Linked WL Admissions
Property PATCFAllowEditCPforLinkedWLAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 240, SqlFieldName = PATCF_AllowEditCPforLinkedWLAdm ];

/// Show Reg Waiting Timeon FloorPlan
Property PATCFShowRegWaitTimeFloorPlan As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 241, SqlFieldName = PATCF_ShowRegWaitTimeFloorPlan ];

/// Do Not Execute Orders UponDischarge
Property PATCFNoExecuteOrdUponDisc As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 242, SqlFieldName = PATCF_NoExecuteOrdUponDisc ];

/// CareProvType
Property PATCFCareProvType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 243, SqlFieldName = PATCF_CareProvType ];

/// Allow to Change Preadm Date in WL
Property PATCFAllowChangePreadmDateWL As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 244, SqlFieldName = PATCF_AllowChangePreadmDateWL ];

/// Show MR Number on FloorPlan
Property PATCFShowMRNumberFloorPlan As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 245, SqlFieldName = PATCF_ShowMRNumberFloorPlan ];

/// Show Zero Bills when Unpaid
Property PATCFShowZeroBillsUnpaid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 246, SqlFieldName = PATCF_ShowZeroBillsUnpaid ];

/// Show Negative Invoices when Unpaid is ticked
Property PATCFShowNegativeInvUnpaid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 247, SqlFieldName = PATCF_ShowNegativeInvUnpaid ];

/// SearchOnDays
Property PATCFSearchOnDays As %Float [ SqlColumnNumber = 248, SqlFieldName = PATCF_SearchOnDays ];

/// Change WL Stat to Done upon Arrival Appt
Property PATCFChangeWLStDoneArrAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 249, SqlFieldName = PATCF_ChangeWLStDoneArrAppt ];

/// LastCPPaidForED
Property PATCFLastCPPaidForED As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 250, SqlFieldName = PATCF_LastCPPaidForED ];

/// Gestation MinDays
Property PATCFGestationMinDays As %Float [ SqlColumnNumber = 251, SqlFieldName = PATCF_GestationMinDays ];

/// GestationMaxDays
Property PATCFGestationMaxDays As %Float [ SqlColumnNumber = 252, SqlFieldName = PATCF_GestationMaxDays ];

/// BirthWeightMin
Property PATCFBirthWeightMin As %Float [ SqlColumnNumber = 253, SqlFieldName = PATCF_BirthWeightMin ];

/// BirthWeightMax
Property PATCFBirthWeightMax As %Float [ SqlColumnNumber = 254, SqlFieldName = PATCF_BirthWeightMax ];

/// GestationMinWeeks
Property PATCFGestationMinWeeks As %Float [ SqlColumnNumber = 255, SqlFieldName = PATCF_GestationMinWeeks ];

/// GestationMaxWeeks
Property PATCFGestationMaxWeeks As %Float [ SqlColumnNumber = 256, SqlFieldName = PATCF_GestationMaxWeeks ];

/// Clear Ref Hosp On Remove
Property PATCFClearRefHospOnRemove As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 257, SqlFieldName = PATCF_ClearRefHospOnRemove ];

/// Default Procedure Date if SameDay
Property PATCFDefProcDateSameDay As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 258, SqlFieldName = PATCF_DefProcDateSameDay ];

/// Display Theatre Time Exc Warning
Property PATCFDisplayTheatreTimeExcWarn As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 259, SqlFieldName = PATCF_DisplayTheatreTimeExcWarn ];

/// ConfirmToSaveAsPreviousAddress
Property PATCFConfirmToSaveAsPreviousAdd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 260, SqlFieldName = PATCF_ConfirmToSaveAsPreviousAddress ];

/// Copy Alrg/Alrt To Both Pat on Unmerge
Property PATCFCopyAlrgAlrtToBothPatU As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 261, SqlFieldName = PATCF_CopyAlrgAlrtToBothPatU ];

/// Des Ref AddressType
Property PATCFAddressTypeDR As CTAddrType [ SqlColumnNumber = 262, SqlFieldName = PATCF_AddressType_DR ];

/// TBCAlrgAlertEpisMove
Property PATCFTBCAlrgAlertEpisMove As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 263, SqlFieldName = PATCF_TBCAlrgAlertEpisMove ];

/// Dont Display Inactive Alias
Property PATCFDontDisplayInactiveAlias As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 264, SqlFieldName = PATCF_DontDisplayInactiveAlias ];

/// Des Ref UnknownSex
Property PATCFUnknownSexDR As CTSex [ SqlColumnNumber = 265, SqlFieldName = PATCF_UnknownSex_DR ];

/// Current Ep/OutpatAPPT in DWB
Property PATCFCurrentEpOutpatAPPTDWB As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 266, SqlFieldName = PATCF_CurrentEpOutpatAPPT_DWB ];

/// Show Warning when Proc Date Out of Epis
Property PATCFShowWarnProcDateOutEpis As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 267, SqlFieldName = PATCF_ShowWarnProcDateOutEpis ];

/// PopulateAdmDocForNewWL
Property PATCFPopulateAdmDocForNewWL As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 268, SqlFieldName = PATCF_PopulateAdmDocForNewWL ];

/// CancelPaymUponCancelBill
Property PATCFCancelPaymUponCancelBill As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 269, SqlFieldName = PATCF_CancelPaymUponCancelBill ];

/// NoOrdersCopyFromOrigAdm
Property PATCFNoOrdersCopyFromOrigAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 270, SqlFieldName = PATCF_NoOrdersCopyFromOrigAdm ];

/// FromThisArea flag ReadOnly
Property PATCFFromThisAreaReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 271, SqlFieldName = PATCF_FromThisAreaReadOnly ];

/// RestrictCancerRegLogonHosp
Property PATCFRestCancerRegLogonHosp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 272, SqlFieldName = PATCF_RestCancerRegLogonHosp ];

/// UseAntibioticSeqInLab
Property PATCFUseAntibioticSeqInLab As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 273, SqlFieldName = PATCF_UseAntibioticSeqInLab ];

/// PatNamesOrder
Property PATCFPatNamesOrder As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 274, SqlFieldName = PATCF_PatNamesOrder ];

/// CopyDiagToInPatAdm
Property PATCFCopyDiagToInPatAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 275, SqlFieldName = PATCF_CopyDiagToInPatAdm ];

/// AllAdmsForNewDischarge
Property PATCFAllAdmsForNewDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 276, SqlFieldName = PATCF_AllAdmsForNewDischarge ];

/// AlloweChangeOvertimeBtwOps
Property PATCFAlloweChangeOvertimeBtwOps As %Float [ SqlColumnNumber = 277, SqlFieldName = PATCF_AlloweChangeOvertimeBtwOps ];

/// UseSoundexSearchAllNames
Property PATCFUseSoundexSearchAllNames As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 278, SqlFieldName = PATCF_UseSoundexSearchAllNames ];

/// CanclAdmOnCanclOTAppt
Property PATCFCanclAdmOnCanclOTAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 279, SqlFieldName = PATCF_CanclAdmOnCanclOTAppt ];

/// OTDelayMargin
Property PATCFOTDelayMargin As %Float [ SqlColumnNumber = 280, SqlFieldName = PATCF_OTDelayMargin ];

/// OTStartMargin
Property PATCFOTStartMargin As %Float [ SqlColumnNumber = 281, SqlFieldName = PATCF_OTStartMargin ];

/// ChangeOPWLStDoneArrAppt
Property PATCFChangeOPWLStDoneArrAppt As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 282, SqlFieldName = PATCF_ChangeOPWLStDoneArrAppt ];

/// TimeRoomChargeApply
Property PATCFTimeRoomChargeApply As %Time [ SqlColumnNumber = 283, SqlFieldName = PATCF_TimeRoomChargeApply ];

/// RestWardDeptBook
Property PATCFRestWardDeptBook As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 284, SqlFieldName = PATCF_RestWardDeptBook ];

/// GovExtract
Property PATCFGovExtract As %String(DISPLAYLIST = ",SMR,QHME,NMDS", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",SMR,QHME,NMDS") [ SqlColumnNumber = 285, SqlFieldName = PATCF_GovExtract ];

/// Keep AppCreatePayPlanForAdm
Property PATCFAppCreatePayPlanAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 286, SqlFieldName = PATCF_AppCreatePayPlanAdm ];

/// TriageWaitTime1st
Property PATCFTriageWaitTime1st As %Float [ SqlColumnNumber = 287, SqlFieldName = PATCF_TriageWaitTime1st ];

/// TriageWaitTime2nd
Property PATCFTriageWaitTime2nd As %Float [ SqlColumnNumber = 288, SqlFieldName = PATCF_TriageWaitTime2nd ];

/// CashRecptDiscntReadOnly
Property PATCFCashRecptDiscntReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 289, SqlFieldName = PATCF_CashRecptDiscntReadOnly ];

/// AnonymousName
Property PATCFAnonymousName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 290, SqlFieldName = PATCF_AnonymousName ];

/// MaxOperatingTimeMins
Property PATCFMaxOperatingTimeMins As %Float [ SqlColumnNumber = 291, SqlFieldName = PATCF_MaxOperatingTimeMins ];

/// ExternalPatValid
Property PATCFExternalPatValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 292, SqlFieldName = PATCF_ExternalPatValid ];

/// SameDayPreAdm
Property PATCFSameDayPreAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 293, SqlFieldName = PATCF_SameDayPreAdm ];

/// AllowCarePlanIntApptDCONOutcClose
Property PATCFAllowCarePlanIntApptDCONOu As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 294, SqlFieldName = PATCF_AllowCarePlanIntApptDCONOutcClose ];

/// AutoCreateOTBookEpConditions
Property PATCFAutoCreateOTBookEpConditio As %String(DISPLAYLIST = ",Location,Date/Location,Resource/Location,Responsible Unit", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",L,DL,RL,RU") [ SqlColumnNumber = 295, SqlFieldName = PATCF_AutoCreateOTBookEpConditions ];

/// LinkOTBookToExistPreAdm
Property PATCFLinkOTBookToExistPreAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 296, SqlFieldName = PATCF_LinkOTBookToExistPreAdm ];

/// StoreAppPayPlanOverAdm
Property PATCFStoreAppPayPlanOverAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 297, SqlFieldName = PATCF_StoreAppPayPlanOverAdm ];

/// ProperIncisionPerc
Property PATCFProperIncisionPerc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 298, SqlFieldName = PATCF_ProperIncisionPerc ];

/// NonProperIncisionPerc
Property PATCFNonProperIncisionPerc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 299, SqlFieldName = PATCF_NonProperIncisionPerc ];

/// ExtrInterFixDevice
Property PATCFExtrInterFixDevice As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 300, SqlFieldName = PATCF_ExtrInterFixDevice ];

/// DaysAllowChangeTCI
Property PATCFDaysAllowChangeTCI As %Float [ SqlColumnNumber = 301, SqlFieldName = PATCF_DaysAllowChangeTCI ];

/// Search on  Startswith Rego
Property PATCFSearchStartswithRego As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 302, SqlFieldName = PATCF_SearchStartswithRego ];

/// MotherBabyEpisAutoLink
Property PATCFMotherBabyEpisAutoLink As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 303, SqlFieldName = PATCF_MotherBabyEpisAutoLink ];

/// TenderPayment
Property PATCFTenderPayment As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 304, SqlFieldName = PATCF_TenderPayment ];

/// ConfirmCreateAliasName
Property PATCFConfirmCreateAliasName As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 305, SqlFieldName = PATCF_ConfirmCreateAliasName ];

/// Link ED OUT Epis To IP
Property PATCFLinkEDOUTEpisToIP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 306, SqlFieldName = PATCF_LinkEDOUTEpisToIP ];

/// ShowPreAdmInfoOnEDBedRequest
Property PATCFShowPreAdmInfoOnEDBedReque As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 307, SqlFieldName = PATCF_ShowPreAdmInfoOnEDBedRequest ];

/// Des Ref RoundingPaymentAdjustment
Property PATCFRoundingPaymentAdjustmentD As ARCReasonWriteOff [ SqlColumnNumber = 308, SqlFieldName = PATCF_RoundingPaymentAdjustment_DR ];

/// RoundingAmount
Property PATCFRoundingAmount As %Float [ SqlColumnNumber = 309, SqlFieldName = PATCF_RoundingAmount ];

/// YearsSinceLastEpisode
Property PATCFYearsSinceLastEpisode As %Float [ SqlColumnNumber = 310, SqlFieldName = PATCF_YearsSinceLastEpisode ];

/// DisplayZipDescription
Property PATCFDisplayZipDescription As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 311, SqlFieldName = PATCF_DisplayZipDescription ];

/// AutoCreatePregnanForBookMAT
Property PATCFAutoCreatePregnanForBookMA As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 312, SqlFieldName = PATCF_AutoCreatePregnanForBookMAT ];

/// Des Ref BookingTypeForMaternityEquals
Property PATCFBookingTypeForMaternityEqu As PACApptBookingSystem [ SqlColumnNumber = 313, SqlFieldName = PATCF_BookingTypeForMaternityEquals_DR ];

/// Des Ref PregnancyAlertCategory
Property PATCFPregnancyAlertCategoryDR As PACAlertCategory [ SqlColumnNumber = 314, SqlFieldName = PATCF_PregnancyAlertCategory_DR ];

/// Des Ref BreastfeedAlertCategory
Property PATCFBreastfeedAlertCategoryDR As PACAlertCategory [ SqlColumnNumber = 315, SqlFieldName = PATCF_BreastfeedAlertCategory_DR ];

/// CopyPayorPlanFromPrevAdm
Property PATCFCopyPayorPlanFromPrevAdm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 316, SqlFieldName = PATCF_CopyPayorPlanFromPrevAdm ];

/// CopyPayorPlanDetFromPrevAdm
Property PATCFCopyPayorPlanDetFromPrevAd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 317, SqlFieldName = PATCF_CopyPayorPlanDetFromPrevAdm ];

/// FreqAttendAge
Property PATCFFreqAttendAge As %Float [ SqlColumnNumber = 318, SqlFieldName = PATCF_FreqAttendAge ];

/// NumberOfVisits
Property PATCFNumberOfVisits As %Float [ SqlColumnNumber = 319, SqlFieldName = PATCF_NumberOfVisits ];

/// TimeFrame
Property PATCFTimeFrame As %Float [ SqlColumnNumber = 320, SqlFieldName = PATCF_TimeFrame ];

/// TimeFrameType
Property PATCFTimeFrameType As %String(DISPLAYLIST = ",Days,Months,Weeks,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,W,Y") [ SqlColumnNumber = 321, SqlFieldName = PATCF_TimeFrameType ];

/// InvoiceRounding
Property PATCFInvoiceRounding As %Float [ SqlColumnNumber = 322, SqlFieldName = PATCF_InvoiceRounding ];

/// RestrictAdmListForLogonHosp
Property PATCFRestrictAdmListForLogonHos As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 323, SqlFieldName = PATCF_RestrictAdmListForLogonHosp ];

/// Des Ref OTBookCancelReason
Property PATCFOTBookCancelReasonDR As ORCReasonForSuspend [ SqlColumnNumber = 324, SqlFieldName = PATCF_OTBookCancelReason_DR ];

/// PlacentaDetailsRequired
Property PATCFPlacentaDetailsRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 325, SqlFieldName = PATCF_PlacentaDetailsRequired ];

/// PAPersonFindMinSearch
Property PATCFPAPersonFindMinSearch As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 326, SqlFieldName = PATCF_PAPersonFindMinSearch ];

/// NoSimultanCurrentIPEDAdms
Property PATCFNoSimultanCurrentIPEDAdms As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 327, SqlFieldName = PATCF_NoSimultanCurrentIPEDAdms ];

/// MakeCurrOPAdmForOPDAttend
Property PATCFMakeCurrOPAdmForOPDAttend As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 328, SqlFieldName = PATCF_MakeCurrOPAdmForOPDAttend ];

/// DaysToClosePregnEvent
Property PATCFDaysToClosePregnEvent As %Float [ SqlColumnNumber = 329, SqlFieldName = PATCF_DaysToClosePregnEvent ];

/// NoTempLocUpdateOnPatArrival
Property PATCFNoTempLocUpdateOnPatArriva As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 330, SqlFieldName = PATCF_NoTempLocUpdateOnPatArrival ];

/// RestrictPatManSearchByDefPatType
Property PATCFRestrictPatManSearchByDefP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 331, SqlFieldName = PATCF_RestrictPatManSearchByDefPatType ];

/// DisplayEnhancedFP
Property PATCFDisplayEnhancedFP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 332, SqlFieldName = PATCF_DisplayEnhancedFP ];

/// ActivateAdvancdEPRSecurty
Property PATCFActivateAdvancdEPRSecu As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 333, SqlFieldName = PATCF_ActivateAdvancdEPRSecu ];

/// ActivateAdvancdSOAPConsSecurty
Property PATCFActivateAdvancdSOAPCon As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 334, SqlFieldName = PATCF_ActivateAdvancdSOAPCon ];

/// DepositAllocAlert
Property PATCFDepositAllocAlert As %String(DISPLAYLIST = ",No Message,Warning Message,Fatal Error", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",NM,WN,FE") [ SqlColumnNumber = 335, SqlFieldName = PATCF_DepositAllocAlert ];

/// ReversalInpatAdmCutOffTime
Property PATCFReversalInpatAdmCutOffTime As %Float [ SqlColumnNumber = 336, SqlFieldName = PATCF_ReversalInpatAdmCutOffTime ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFPatConf).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFPatConf","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFPatConf).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFPatConf","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFPatConf).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFPatConf","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFPatConf).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFPatConf","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFPatConf","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFPatConf).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFPatConf","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CF("PATCF",0))</SqlIdExpression>
<SQLMap name="DataMasterMapPATCF">
<Data name="PATCF_ActivateAdvancdEPRSecu">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>18</Piece>
</Data>
<Data name="PATCF_ActivateAdvancdSOAPCon">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>19</Piece>
</Data>
<Data name="PATCF_AddLinkedPlansOnAdm">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>67</Piece>
</Data>
<Data name="PATCF_AddressType_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>19</Piece>
</Data>
<Data name="PATCF_AdmCancelGracePeriod">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_AgeCutOffMinors">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>47</Piece>
</Data>
<Data name="PATCF_AllAdmsForNewDischarge">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>33</Piece>
</Data>
<Data name="PATCF_AllOverlapSuspens">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>17</Piece>
</Data>
<Data name="PATCF_Allergy_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_AllowCarePlanIntApptDCONOutcClose">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>51</Piece>
</Data>
<Data name="PATCF_AllowChangePreadmDateWL">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_AllowDirectCashPayment">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_AllowEditCPforLinkedWLAdm">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>69</Piece>
</Data>
<Data name="PATCF_AllowEnterDiagnosisDischarge">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_AllowInpatDischWOFin">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_AllowMultipleActiveGP">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>51</Piece>
</Data>
<Data name="PATCF_AllowOverlapGP">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>33</Piece>
</Data>
<Data name="PATCF_AllowOverlapIPEpisodes">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>68</Piece>
</Data>
<Data name="PATCF_AllowPartialPaymentPayorBill">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_AllowPartialPaymentSystemBill">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>65</Piece>
</Data>
<Data name="PATCF_AllowSelfAdmission">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_AllowWLChangesAfterAdm">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>34</Piece>
</Data>
<Data name="PATCF_AlloweChangeOvertimeBtwOps">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>34</Piece>
</Data>
<Data name="PATCF_AnaestLength">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_AnaestPrefix">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_AnaestSuffix">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_AnonymousName">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>47</Piece>
</Data>
<Data name="PATCF_AppCreatePayPlanAdm">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>43</Piece>
</Data>
<Data name="PATCF_ApplyMaxPatDiscount">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>18</Piece>
</Data>
<Data name="PATCF_ApplyNewRoomRates">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>58</Piece>
</Data>
<Data name="PATCF_ArrivePatientOnReg">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>23</Piece>
</Data>
<Data name="PATCF_AssignDepartmentToBed">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_AutoCreateOTBookEpConditions">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>52</Piece>
</Data>
<Data name="PATCF_AutoCreatePregnanForBookMAT">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>69</Piece>
</Data>
<Data name="PATCF_AutomaticReadLinkedProviders">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>20</Piece>
</Data>
<Data name="PATCF_BedRequestHours">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>42</Piece>
</Data>
<Data name="PATCF_BedType_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_BirthWeightMax">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_BirthWeightMin">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_BookingTypeForMaternityEquals_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>70</Piece>
</Data>
<Data name="PATCF_BreastfeedAlertCategory_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>72</Piece>
</Data>
<Data name="PATCF_CancelPaymUponCancelBill">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>26</Piece>
</Data>
<Data name="PATCF_CancelWListStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_CanclAdmOnCanclOTAppt">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>36</Piece>
</Data>
<Data name="PATCF_CareProvType">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>72</Piece>
</Data>
<Data name="PATCF_CashRecptDiscntReadOnly">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>46</Piece>
</Data>
<Data name="PATCF_ChangeOPWLStDoneArrAppt">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>39</Piece>
</Data>
<Data name="PATCF_ChangeWLStDoneArrAppt">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_ChooseReferalDoctorFromList">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>17</Piece>
</Data>
<Data name="PATCF_ClearRefHospOnRemove">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_ClearWLApptDateOutPCancel">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>37</Piece>
</Data>
<Data name="PATCF_CollectRegistrFee">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>16</Piece>
</Data>
<Data name="PATCF_CompleteOnZeroBills">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>18</Piece>
</Data>
<Data name="PATCF_ComputersInWard">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_ConfirmCreateAliasName">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>62</Piece>
</Data>
<Data name="PATCF_ConfirmCreateAliasSexDOB">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>59</Piece>
</Data>
<Data name="PATCF_ConfirmToSaveAsPreviousAddress">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>17</Piece>
</Data>
<Data name="PATCF_ContactType_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_ConvertCurrencyInBilling">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_CopyAlrgAlrtToBothPatU">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>18</Piece>
</Data>
<Data name="PATCF_CopyDiagToInPatAdm">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>32</Piece>
</Data>
<Data name="PATCF_CopyPayorPlanDetFromPrevAdm">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_CopyPayorPlanFromPrevAdm">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_CurrentEpOutpatAPPT_DWB">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>23</Piece>
</Data>
<Data name="PATCF_CutOffTimeDischarge">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_DailyCounterLength">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_DaySurgeryType_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>44</Piece>
</Data>
<Data name="PATCF_DaysAllowChangeTCI">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>58</Piece>
</Data>
<Data name="PATCF_DaysToClosePregnEvent">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_DaysToIncludeDischPat">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>49</Piece>
</Data>
<Data name="PATCF_DeceasedWaitList_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_Def2ndTabEpisDetails">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_DefAdmDepartBDMAN">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_DefNewBornDep_DR">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_DefOperResource_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>43</Piece>
</Data>
<Data name="PATCF_DefProcDateSameDay">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_DefaultDepartUser">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_DefaultDiscretOutType">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>27</Piece>
</Data>
<Data name="PATCF_DefaultEMQuePriorityDR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>40</Piece>
</Data>
<Data name="PATCF_DefaultIPVisitTypeDR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_DefaultInsType_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_DefaultNoLabels">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_DefaultNurseryWard">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>37</Piece>
</Data>
<Data name="PATCF_DefaultOPQuePriorityDR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>39</Piece>
</Data>
<Data name="PATCF_DefaultOPVisTypDR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_DefaultPrintLanguageDR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>38</Piece>
</Data>
<Data name="PATCF_DefaultReqStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_DefaultTabInRegistration">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_DefaultTariff_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_DefaultUseDeptAsDefault">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>48</Piece>
</Data>
<Data name="PATCF_DefaultZipDescIntoAddress">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_DepositAllocAlert">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>20</Piece>
</Data>
<Data name="PATCF_Description">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_DisableInsuranceOfficeCombo">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_DisableMultiselectBills">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_DischGracePeriod">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_DischargePolicy">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>46</Piece>
</Data>
<Data name="PATCF_DisconOrdersOnDischarge">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_DisplayEnhancedFP">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>17</Piece>
</Data>
<Data name="PATCF_DisplayRegDetAfterBedAssign">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_DisplayTheatreTimeExcWarn">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>16</Piece>
</Data>
<Data name="PATCF_DisplayZipDescription">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>68</Piece>
</Data>
<Data name="PATCF_DoNotCreateTransAdmFromED">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>44</Piece>
</Data>
<Data name="PATCF_DontDischOutPatOnDecease">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>61</Piece>
</Data>
<Data name="PATCF_DontDisplayInactiveAlias">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>21</Piece>
</Data>
<Data name="PATCF_EMAdmNoDelim">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>31</Piece>
</Data>
<Data name="PATCF_EMAdmNoLength">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_EMAdmNoPrefix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_EMAdmNoSuffix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_EligMechVentCopayment">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>26</Piece>
</Data>
<Data name="PATCF_EligMechVentCopaymentNICU">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>31</Piece>
</Data>
<Data name="PATCF_EmergDischDetails">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_EmergStandAlone">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_EmergencyOrder_DR">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_EmergencyPatBedOption">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_EmergencySurChargeCode">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_EnableMultipleDiscountsOuts">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_ErrorOnExtractCodingIncomplete">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>63</Piece>
</Data>
<Data name="PATCF_ExemptionCounterType_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_ExtendDiagnosis">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_ExternalPatValid">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>49</Piece>
</Data>
<Data name="PATCF_ExtrInterFixDevice">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>57</Piece>
</Data>
<Data name="PATCF_FemalePensionAge">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_FemaleSex_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_FieldLength">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_FreqAttendAge">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_FromThisAreaReadOnly">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>28</Piece>
</Data>
<Data name="PATCF_GenerateAdmNo">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>20</Piece>
</Data>
<Data name="PATCF_GenerateRego">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_GestationMaxDays">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_GestationMaxWeeks">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_GestationMinDays">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_GestationMinWeeks">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_GovExtract">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>42</Piece>
</Data>
<Data name="PATCF_HICClaimCounter_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_HPLength">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_HPPrefix">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_HPSuffix">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_HospLinkedThrBedDepAlloc">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>66</Piece>
</Data>
<Data name="PATCF_IPAdmNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="PATCF_IPAdmNoDelim">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>29</Piece>
</Data>
<Data name="PATCF_IPAdmNoLength">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_IPAdmNoPrefix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="PATCF_IPAdmNoSuffix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="PATCF_IPInclDischPat">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>52</Piece>
</Data>
<Data name="PATCF_IPNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_IPNoLength">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_IPNoOnly">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>35</Piece>
</Data>
<Data name="PATCF_IPNoPrefix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="PATCF_IPNoSuffix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="PATCF_IPOPAdmNoSame">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>21</Piece>
</Data>
<Data name="PATCF_IPOPSame">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_InclRecsAfterExtrctEndDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>64</Piece>
</Data>
<Data name="PATCF_InsuranceCardHolder">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_InvoiceRounding">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_IsDoctorMandatory">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_IsRefDoctorMandatory">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>21</Piece>
</Data>
<Data name="PATCF_KeywordLength">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_LabCounterType_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_LabEpisodeNumberMethod">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_Language_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>22</Piece>
</Data>
<Data name="PATCF_LastCPPaidForED">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_LimitNoDaysForSearch">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>57</Piece>
</Data>
<Data name="PATCF_LinkEDOUTEpisToIP">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>63</Piece>
</Data>
<Data name="PATCF_LinkOTBookToExistPreAdm">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>53</Piece>
</Data>
<Data name="PATCF_MRCType1_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_MRCType2_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_MakeCurrOPAdmForOPDAttend">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_MalePensionAge">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_MaleSex_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>16</Piece>
</Data>
<Data name="PATCF_MaxDaysOnLeave">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_MaxOperatingTimeMins">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>48</Piece>
</Data>
<Data name="PATCF_MotherBabyEpisAutoLink">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>60</Piece>
</Data>
<Data name="PATCF_NAllORBookNA">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>18</Piece>
</Data>
<Data name="PATCF_NAllORBookNoSess">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>17</Piece>
</Data>
<Data name="PATCF_NAllORBookPast">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>16</Piece>
</Data>
<Data name="PATCF_NewBornEpisSubType_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_NextOfKin">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_NoDaysForAdmSearchToCopyFrom">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>55</Piece>
</Data>
<Data name="PATCF_NoEdTransaction">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>43</Piece>
</Data>
<Data name="PATCF_NoExecuteOrdUponDisc">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>71</Piece>
</Data>
<Data name="PATCF_NoFieldsPatName">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_NoGenPRNforEMergPats">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>27</Piece>
</Data>
<Data name="PATCF_NoOfYearsAgeSearch">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_NoOrdersCopyFromOrigAdm">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>27</Piece>
</Data>
<Data name="PATCF_NoRowsDiagProc">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>54</Piece>
</Data>
<Data name="PATCF_NoSimultanCurrentIPEDAdms">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_NoTempLocUpdateOnPatArrival">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_NonProperIncisionPerc">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>56</Piece>
</Data>
<Data name="PATCF_NotPopDischDateTimeOnLeave">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>30</Piece>
</Data>
<Data name="PATCF_NumberOfVisits">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_NurseryBedCleanupHours">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>45</Piece>
</Data>
<Data name="PATCF_OPAdmNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>22</Piece>
</Data>
<Data name="PATCF_OPAdmNoDelim">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>30</Piece>
</Data>
<Data name="PATCF_OPAdmNoLength">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_OPAdmNoPrefix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>23</Piece>
</Data>
<Data name="PATCF_OPAdmNoSuffix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>24</Piece>
</Data>
<Data name="PATCF_OPNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_OPNoLength">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_OPNoOnly">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>36</Piece>
</Data>
<Data name="PATCF_OPNoPrefix">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>25</Piece>
</Data>
<Data name="PATCF_OPNoSuffix">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>26</Piece>
</Data>
<Data name="PATCF_OTBookCancelReason_DR">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_OTCPayor">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_OTDelayMargin">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>37</Piece>
</Data>
<Data name="PATCF_OTStartMargin">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>38</Piece>
</Data>
<Data name="PATCF_OperLength">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_OperPrefix">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_OperRoom_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>28</Piece>
</Data>
<Data name="PATCF_OperSuffix">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_PAAdmNoDelim">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>32</Piece>
</Data>
<Data name="PATCF_PAAdmNoLength">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_PAAdmNoPrefix">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>34</Piece>
</Data>
<Data name="PATCF_PAAdmNoSuffix">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>33</Piece>
</Data>
<Data name="PATCF_PAPersonFindMinSearch">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_PATMANReadOnly">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_ParentGuardianTitle">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>46</Piece>
</Data>
<Data name="PATCF_PatNamesOrder">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>31</Piece>
</Data>
<Data name="PATCF_PatTypeEmerg">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_PatTypeHealthProm">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_PatTypeInPat">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_PatTypeOutPat">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_PlacePatInHoldArea">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>22</Piece>
</Data>
<Data name="PATCF_PlacentaDetailsRequired">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_PopulateAdmDocForNewWL">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>25</Piece>
</Data>
<Data name="PATCF_PrLabNewPat">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_PregnancyAlertCategory_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>71</Piece>
</Data>
<Data name="PATCF_PregnancyCheckAgeFrom">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>35</Piece>
</Data>
<Data name="PATCF_PregnancyCheckAgeTo">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>36</Piece>
</Data>
<Data name="PATCF_PriceToDisplayOnRB">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_PrintAdmSheetOnPaym">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>19</Piece>
</Data>
<Data name="PATCF_PrintAdmissionNotif">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_PrintAppointmentSlip">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>20</Piece>
</Data>
<Data name="PATCF_PrintAutom1">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>42</Piece>
</Data>
<Data name="PATCF_PrintAutom2">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_PrintBillOnPayment">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>18</Piece>
</Data>
<Data name="PATCF_PrintDischargeConf">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_PrintRBINQ01">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_PrintRBINQ02">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_PrintRBINQ03">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_PrintReceipt">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_PrintRegisCard">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_PrintWaitList">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_Process">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_ProcessLength">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_ProcessPrefix">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_ProcessSuffix">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_ProofPrefix1">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_ProofPrefix2">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_ProperIncisionPerc">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>55</Piece>
</Data>
<Data name="PATCF_Que1CounterMethod">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>41</Piece>
</Data>
<Data name="PATCF_RBResource_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_ReasonCancelBill">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_RefreshCashiierAfterOE">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_RefreshPATMANOE">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_ResetWLDaysPriorIncrease">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>62</Piece>
</Data>
<Data name="PATCF_RestCancerRegLogonHosp">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>29</Piece>
</Data>
<Data name="PATCF_RestWardDeptBook">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>41</Piece>
</Data>
<Data name="PATCF_RestrictAdmListForLogonHosp">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_RestrictLocList">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_RestrictNegOutsAmt">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>7</Piece>
</Data>
<Data name="PATCF_RestrictPatManSearchByDefPatType">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>16</Piece>
</Data>
<Data name="PATCF_RestrictSingleDiagType">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>12</Piece>
</Data>
<Data name="PATCF_ReversalInpatAdmCutOffTime">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>21</Piece>
</Data>
<Data name="PATCF_RoundingAmount">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>66</Piece>
</Data>
<Data name="PATCF_RoundingPaymentAdjustment_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>65</Piece>
</Data>
<Data name="PATCF_SMRReporting">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>48</Piece>
</Data>
<Data name="PATCF_SameBillPatientPayor">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_SameDayPreAdm">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>50</Piece>
</Data>
<Data name="PATCF_SaveOutPatEpUponInConv">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>56</Piece>
</Data>
<Data name="PATCF_SaveRegNumExtDB">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_SearchByKeywords">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_SearchOnDays">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_SearchOnExactMRN">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>24</Piece>
</Data>
<Data name="PATCF_SearchOnMonth">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>53</Piece>
</Data>
<Data name="PATCF_SearchStartswithRego">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>59</Piece>
</Data>
<Data name="PATCF_SetAppToBook">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>23</Piece>
</Data>
<Data name="PATCF_ShowMRNumberFloorPlan">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>2</Piece>
</Data>
<Data name="PATCF_ShowMonthsWhenInactive">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>21</Piece>
</Data>
<Data name="PATCF_ShowNegativeInvUnpaid">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>4</Piece>
</Data>
<Data name="PATCF_ShowOEMessageOnAdmUpdate">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>1</Piece>
</Data>
<Data name="PATCF_ShowPreAdmInfoOnEDBedRequest">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>64</Piece>
</Data>
<Data name="PATCF_ShowPreadmAfterAppoint">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>11</Piece>
</Data>
<Data name="PATCF_ShowPreviousEMR">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_ShowRefDoctorSpec">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>19</Piece>
</Data>
<Data name="PATCF_ShowRegWaitTimeFloorPlan">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>70</Piece>
</Data>
<Data name="PATCF_ShowWarnProcDateOutEpis">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>24</Piece>
</Data>
<Data name="PATCF_ShowZeroBillsUnpaid">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_ShowreasonChangePatData">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_SkipPatientType">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_SortByQueue">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>10</Piece>
</Data>
<Data name="PATCF_SortBySurnameFirstOther">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>60</Piece>
</Data>
<Data name="PATCF_StampDutyCharge_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>8</Piece>
</Data>
<Data name="PATCF_StoreAppPayPlanOverAdm">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>54</Piece>
</Data>
<Data name="PATCF_SuppressMRRego">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>19</Piece>
</Data>
<Data name="PATCF_TBCAlrgAlertEpisMove">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>20</Piece>
</Data>
<Data name="PATCF_TenderPayment">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>61</Piece>
</Data>
<Data name="PATCF_TimeFrame">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_TimeFrameType">
<Delimiter>"^"</Delimiter>
<Node>13</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_TimeRoomChargeApply">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>40</Piece>
</Data>
<Data name="PATCF_TitleOfDeceasedPat">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>45</Piece>
</Data>
<Data name="PATCF_TransferReasonMandatory">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_TrfCancelGracePeriod">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>9</Piece>
</Data>
<Data name="PATCF_TriageWaitTime1st">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>44</Piece>
</Data>
<Data name="PATCF_TriageWaitTime2nd">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>45</Piece>
</Data>
<Data name="PATCF_UnavailBedStatus">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>6</Piece>
</Data>
<Data name="PATCF_UnknownSex_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>22</Piece>
</Data>
<Data name="PATCF_UpperLimitDisplayDays">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>39</Piece>
</Data>
<Data name="PATCF_UpperLimitDisplayMonths">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>41</Piece>
</Data>
<Data name="PATCF_UpperLimitDisplayWeeks">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>40</Piece>
</Data>
<Data name="PATCF_UseAntibioticSeqInLab">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>30</Piece>
</Data>
<Data name="PATCF_UseBedManagementScreen">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>17</Piece>
</Data>
<Data name="PATCF_UseBedReqDateTimeEm">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>32</Piece>
</Data>
<Data name="PATCF_UseCRAFTFunctionality">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>29</Piece>
</Data>
<Data name="PATCF_UseClientBasedDRGGrouper">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>28</Piece>
</Data>
<Data name="PATCF_UseDRGGrouper">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>3</Piece>
</Data>
<Data name="PATCF_UseDischargeDateTimeAdm">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>38</Piece>
</Data>
<Data name="PATCF_UseMaxDaysOnLeaveDisch">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>50</Piece>
</Data>
<Data name="PATCF_UsePayorFromPrevEpisode">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>14</Piece>
</Data>
<Data name="PATCF_UseSoundexSearchAllNames">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>35</Piece>
</Data>
<Data name="PATCF_UseUserDefPayor">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>21</Piece>
</Data>
<Data name="PATCF_UseWIESVICDRGFunction">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>25</Piece>
</Data>
<Data name="PATCF_VerifyNewAdmissions">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>47</Piece>
</Data>
<Data name="PATCF_WLSortByDays">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>13</Piece>
</Data>
<Data name="PATCF_WLStatInitOnCancel">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>5</Piece>
</Data>
<Data name="PATCF_WLStatOnAdm_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>16</Piece>
</Data>
<Data name="PATCF_WarnORBookingMoveRes">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>15</Piece>
</Data>
<Data name="PATCF_YearsSinceLastEpisode">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>67</Piece>
</Data>
<Data name="PATCF_ZipCodesSetup">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>15</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PATCF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PATCF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PATCF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PATCF_RowID</SqlRowIdName>
<StreamLocation>^User.CFPatConfS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
