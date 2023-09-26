/// 名称:系统参数
/// 编写者:基础平台组-陈莹
Class web.Entity.CT.SystemParameter Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SystemParameter";

//1print,18

Property PATCFPrintAdmissionNotif As %String;

Property PATCFPrintAdmSheetOnPaym As %String;

Property PATCFPrintAppointmentSlip As %String;

Property PATCFPrintReceipt As %String;

Property RTCFPrintMRBarCode As %String;

Property RTCFAutoPrintRequest As %String;

Property RTCFPrintMRRequestSlip As %String;

Property PATCFPrintBillOnPayment As %String;

Property PATCFPrLabNewPat As %String;

Property OECFPrintPresc As %String;

Property OECFPrintDelLabelOnUpdate As %String;

Property PATCFPrintRegisCard As %String;

Property PATCFPrintRBINQ01 As %String;

Property PATCFPrintRBINQ02 As %String;

Property PATCFPrintRBINQ03 As %String;

Property PATCFPrintAutom1 As %String;

Property PATCFPrintAutom2 As %String;

Property PATCFPrintWaitList As %String;

//2billing,24

Property CTCFPayMode As %String;

Property CTCFCTCURDR As %String;

Property OECFInpatientBilling As %String;

Property PATCFPriceToDisplayOnRB As %String;

Property PATCFStampDutyChargeDR As %String;

Property PATCFDefaultTariffDR As %String;

Property PATCFAllowPartialPaymentPayorBi As %String;

Property PATCFApplyMaxPatDiscount As %String;

Property PATCFApplyNewRoomRates As %String;

Property PATCFCompleteOnZeroBills As %String;

Property PATCFConvertCurrencyInBilling As %String;

Property PATCFDisableMultiselectBills As %String;

Property PATCFCashRecptDiscntReadOnly As %String;

Property PATCFEligMechVentCopayment As %String;

Property PATCFEligMechVentCopaymentNICU As %String;

Property PATCFAllowDirectCashPayment As %String;

Property CTCFChequeDate As %String;

//Property PATCFEnableMultipleDiscountsOut As %String;

Property CTCFMultipleCurr As %String;

Property PATCFOTCPayor As %String;

Property PATCFReasonCancelBill As %String;

Property PATCFRefreshCashiierAfterOE As %String;

Property PATCFRestrictNegOutsAmt As %String;

Property PATCFSameBillPatientPayor As %String;

/// 3billingw 23
Property PATCFTitleOfDeceasedPat As %String;

Property PATCFParentGuardianTitle As %String;

Property PATCFAgeCutOffMinors As %String;

Property PATCFInvoiceRounding As %String;

Property PATCFRoundingAmount As %String;

Property PATCFRoundingPaymentAdjustmentD As %String;

Property PATCFTimeRoomChargeApply As %String;

/// Time!
Property PATCFDepositAllocAlert As %String;

Property PATCFAddLinkedPlansOnAdm As %String;

Property PATCFAllowPartialPaymentSystemB As %String;

Property PATCFMotherBabyEpisAutoLink As %String;

Property OECFBillAdminDrugs As %String;

Property PATCFCancelPaymUponCancelBill As %String;

Property PATCFCopyPayorPlanFromPrevAdm As %String;

Property PATCFCopyPayorPlanDetFromPrevAd As %String;

Property PATCFShowZeroBillsUnpaid As %String;

Property PATCFLinkEDOUTEpisToIP As %String;

Property PATCFLastCPPaidForED As %String;

Property PATCFShowNegativeInvUnpaid As %String;

Property PATCFStoreAppPayPlanOverAdm As %String;

Property PATCFTenderPayment As %String;

Property PATCFUseCRAFTFunctionality As %String;

Property PATCFUseWIESVICDRGFunction As %String;

//4booking

Property PATCFBedRequestHours As %String;

Property RBCFConditionAutoEpAppt As %String;

Property RBCFNoDayGenSchedule As %String;

Property RBCFMultipleServicesSearch As %String;

Property RBCFMaxWeeksIrregSchedule As %String;

Property RBCFPercentIncrServDuration As %String;

Property RBCFOverBookReasonDR As %String;

Property RBCFMaxPeriodCheckEpisNum As %String;

Property RBCFMaxPeriodCheckEpis1 As %String;

/// 5booking2
Property RBCFAllowOverBookWalkins As %String;

Property RBCFAllowOverBookingAvailSlots As %String;

Property RBCFAllowBookOverlapAppoint As %String;

Property RBCFAllowTransferEarlyAdmDate As %String;

Property RBCFCancelAdmOnCancelAppt As %String;

Property RBCFNoWarningOnApptCancel As %String;

Property RBCFDischEpCancelFutureAppts As %String;

Property RBCFAdmDateEarliestApptDate As %String;

Property PATCFMakeCurrOPAdmForOPDAttend As %String;

Property RBCFDefaultPatientDetPayorPlan As %String;

Property RBCFDefResourceLastAppt As %String;

Property RBCFDisableRTCreationAppt As %String;

Property RBCFDisplayOrderNotes As %String;

Property RBCFExtendReferralPeriod As %String;

Property RBCFGenerate1stWeekOfCycle As %String;

Property RBCFGroupNoEpisodeCreation As %String;

Property RBCFKeepLocAnResource As %String;

Property RBCFWebNotMoveOnHoldOnSchGen As %String;

Property RBCFRestrictServices As %String;

Property RBCFSetAdmDateTimeToAppt As %String;

Property RBCFShowBookedAppt As %String;

Property RBCFShowBookingNotesMessage As %String;

Property RBCFShowReferralAfterChangeStat As %String;

Property RBCFRestrictPayorPlan As %String;

Property RBCFUseUserDefPayor As %String;

/// 6 clinical,20
Property PATCFMRCType2DR As %String;

Property PATCFMRCType1DR As %String;

Property PATCFDefNewBornDepDR As %String;

Property PATCFNewBornEpisSubTypeDR As %String;

Property PATCFFemaleSexDR As %String;

Property PATCFAllergyDR As %String;

Property OECFTextForDeletedTestItem As %String;

Property PATCFActivateAdvancdEPRSecu As %String;

Property PATCFActivateAdvancdSOAPCon As %String;

Property PATCFAutomaticReadLinkedProvide As %String;

Property PATCFExtendDiagnosis As %String;

Property PATCFRestrictSingleDiagType As %String;

Property PATCFShowPreviousEMR As %String;

Property PATCFSortByQueue As %String;

Property PATCFGestationMaxWeeks As %String;

Property PATCFGestationMinWeeks As %String;

Property PATCFGestationMaxDays As %String;

Property PATCFGestationMinDays As %String;

Property PATCFBirthWeightMax As %String;

Property PATCFBirthWeightMin As %String;

/// 7department,4
Property OECFExecuteConfirmation As %String;

Property OECFDisableExecuteNotArrAppt As %String;

Property OECFIgnorePayorPlanRest As %String;

Property RBCFOrderBySlotOrQueue As %String;

/// 8discharge,10
Property PATCFEmergDischDetails As %String;

Property PATCFUnavailBedStatus As %String;

Property PATCFCutOffTimeDischarge As %String;

/// time!
Property PATCFAllowEnterDiagnosisDischar As %String;

Property PATCFAllowInpatDischWOFin As %String;

Property PATCFDisconOrdersOnDischarge As %String;

Property PATCFCopyDiagToInPatAdm As %String;

Property PATCFNotPopDischDateTimeOnLeave As %String;

Property PATCFUseDischargeDateTimeAdm As %String;

Property PATCFUseMaxDaysOnLeaveDisch As %String;

/// /9geographic,7
Property SMCFProvinceDR As %String;

Property SMCFCityDR As %String;

Property SMCFHCADR As %String;

Property PATCFZipCodesSetup As %String;

Property PATCFHospLinkedThrBedDepAlloc As %String;

Property PATCFDefaultZipDescIntoAddress As %String;

//10HTML,1

Property SMCFExplorePath As %String;

//11labtrak

Property PATCFLabEpisodeNumberMethod As %String;

Property SMCFLabtrakUserID As %String;

Property SMCFLabtrakUserPassword As %String;

Property PATCFDailyCounterLength As %String;

Property PATCFLabCounterTypeDR As %String;

Property OECFSendWebNRtoLabTrak As %String;

Property SMCFLinkExtLab As %String;

Property OECFExecuteLabOrder As %String;

Property OECFSendHospitalCodeToLab As %String;

Property OECFSendOrderingDoctorToLab As %String;

Property OECFSendRecLocToLab As %String;

Property PATCFUseAntibioticSeqInLab As %String;

Property SMCFNewLabTrak As %String;

/// 12maternity,6
Property PATCFAutoCreatePregnanForBookMA As %String;

Property PATCFPlacentaDetailsRequired As %String;

Property PATCFDaysToClosePregnEvent As %String;

Property PATCFBookingTypeForMaternityEqu As %String;

Property PATCFBreastfeedAlertCategoryDR As %String;

Property PATCFPregnancyAlertCategoryDR As %String;

/// 13operating,15
Property PATCFCanclAdmOnCanclOTAppt As %String;

Property PATCFDisplayTheatreTimeExcWarn As %String;

Property PATCFNAllORBookNA As %String;

Property PATCFNAllORBookNoSess As %String;

Property PATCFNAllORBookPast As %String;

Property RBCFGenerateAdmOnOTRequest As %String;

Property PATCFLinkOTBookToExistPreAdm As %String;

Property PATCFWarnORBookingMoveRes As %String;

/// Property PATCFAlloweChangeOvertimeBtwOps As %String;  ///glob
Property PATCFMaxOperatingTimeMins As %String;

Property PATCFExtrInterFixDevice As %String;

Property PATCFNonProperIncisionPerc As %String;

Property PATCFProperIncisionPerc As %String;

Property PATCFOTDelayMargin As %String;

Property PATCFOTStartMargin As %String;

Property PATCFAutoCreateOTBookEpConditio As %String;

/// 14orders
Property OECFPriorityDR As %String;

Property OECFDefaultOrderGroup As %String;

Property OECFDiagWarning As %String;

Property OECFCheckPrice As %String;

Property OECFPatLeaveOrderAdmStatusDR As %String;

Property OECFOrdersToRecLoc As %String;

Property OECFShowInstructionAs As %String;

Property OECFUseRepeatsOrEndDate As %String;

Property OECFCMVTestDR As %String;

Property OECFNumberOfOrdersAllowedSameGr As %String;

Property OECFAgeFrom As %String;

Property OECFAgeTo As %String;

/// 15orders2
Property OECFAllowConcurrentOrders As %String;

Property OECFAllowActiveOrdersAdmDates As %String;

Property OECFDiscontExecutedOrder As %String;

Property OECFAllowPlaceOrderOutsideEpisD As %String;

Property OECFDefaultOSItemBillingPriceBl As %String;

Property OECFChangeLinkedOnUpdate As %String;

Property OECFCheckOrdersCovered As %String;

Property OECFClearOrdersOnUpdate As %String;

Property OECFCreate1OrderPerToothFace As %String;

Property OECFCreate1OrderPerSpecimen As %String;

Property OECFCreateReturnQueueDisch As %String;

Property OECFDefaultCheckBsUnselect As %String;

Property OECFDisableAddForQtyBlank As %String;

Property OECFDiscontinueOverlapExTime As %String;

Property OECFDisplayDuplDosageTextBox As %String;

Property OECFNoDefaultPatLocOnOE As %String;

Property OECFNoShowLabEpForAllOrdersIPES As %String;

Property OECFNoShowReorderNurseWB As %String;

Property OECFAllowPackUOM As %String;

Property OECFEditNotes As %String;

Property OECFExecuteFutureOrders As %String;

Property OECFGenerateExecSchedOutpat As %String;

Property OECFIgnorePriorityDEf As %String;

Property OECFKeepPriorDateSession As %String;

Property OECFManualVerifLabOrders As %String;

Property OECFShowSnomedCodes As %String;

Property OECFWarnQtyRangeDuration As %String;

Property OECFSaveOrderCategory As %String;

Property OECFShowDisOrdersResults As %String;

Property OECFShowAllergyDSSQA As %String;

Property OECFShowDeliveryInfoOnPin As %String;

Property OECFUsePreprintedLabelsLab As %String;

/// /16paper
Property RTCFRequestReasonAdmDR As %String;

Property RTCFDefaultReasEDRequest As %String;

Property RTCFRequestReasonAPPTDR As %String;

Property RTCFDefaultReasonWLRequest As %String;

Property RTCFMainMRTypeDR As %String;

Property RTCFMainMRVolumeDR As %String;

Property RTCFDaysToGetMR As %String;

//17paper2

Property RTCFAskReqDetails As %String;

Property RTCFBypassDepartMR As %String;

Property RTCFApptHoldCancelsMRReq As %String;

Property RTCFDisableVBAutoRequest As %String;

Property RTCFMarkMRNInactivePatMerge As %String;

Property RTCFNoShowUVMsgOnMoveMRToHomeLo As %String;

Property RTCFInactivateRTVolumeMerg As %String;

Property RTCFAutoMRRequestToNewVolume As %String;

Property RTCFReturnMRTHomeFirst As %String;

Property RTCFOnlyInactMRNLogHospMerg As %String;

Property RTCFShowMessageForResearchReq As %String;

Property RTCFViewAllVolumes As %String;

Property RTCFViewRequestDefaultLoc As %String;

/// 18patient
Property PATCFWLStatOnAdmDR As %String;

Property PATCFCancelWListStatusDR As %String;

Property PATCFContactTypeDR As %String;

Property PATCFDaySurgeryTypeDR As %String;

Property PATCFDeceasedWaitListDR As %String;

Property PATCFBedTypeDR As %String;

Property PATCFLanguageDR As %String;

Property PATCFExemptionCounterTypeDR As %String;

Property PATCFGenerateAdmNo As %String;

Property PATCFGenerateRego As %String;

Property PATCFHICClaimCounterDR As %String;

Property PATCFNextOfKin As %String;

Property PATCFUpperLimitDisplayDays As %String;

Property PATCFUpperLimitDisplayWeeks As %String;

Property PATCFUpperLimitDisplayMonths As %String;

Property PATCFSearchOnDays As %String;

Property PATCFSearchOnMonth As %String;

Property PATCFDefaultTabInRegistration As %String;

Property PATCFNoRowsDiagProc As %String;

Property PATCFFemalePensionAge As %String;

Property PATCFLimitNoDaysForSearch As %String;

Property PATCFMalePensionAge As %String;

Property PATCFMaxDaysOnLeave As %String;

Property PATCFFieldLength As %String;

Property PATCFNoFieldsPatName As %String;

Property PATCFNoDaysForAdmSearchToCopyFr As %String;

Property PATCFDaysToIncludeDischPat As %String;

Property PATCFNoOfYearsAgeSearch As %String;

Property PATCFShowMonthsWhenInactive As %String;

/// 19patient2
Property PATCFEmergencyPatBedOption As %String;

Property PATCFAllowSelfAdmission As %String;

Property PATCFUsePayorFromPrevEpisode As %String;

Property PATCFArrivePatientOnReg As %String;

Property PATCFAssignDepartmentToBed As %String;

Property PATCFShowreasonChangePatData As %String;

Property PATCFUseDRGGrouper As %String;

Property PATCFChooseReferalDoctorFromLis As %String;

Property PATCFCollectRegistrFee As %String;

Property PATCFProcess As %String;

Property PATCFDefAdmDepartBDMAN As %String;

Property PATCFDef2ndTabEpisDetails As %String;

Property PATCFDisableInsuranceOfficeComb As %String;

Property PATCFDisplayRegDetAfterBedAssig As %String;

Property PATCFShowPreadmAfterAppoint As %String;

Property PATCFIsRefDoctorMandatory As %String;

Property PATCFDisplayZipDescription As %String;

Property PATCFRefreshPATMANOE As %String;

Property PATCFSaveOutPatEpUponInConv As %String;

Property PATCFSaveRegNumExtDB As %String;

Property PATCFSearchByKeywords As %String;

Property PATCFSearchOnExactMRN As %String;

Property PATCFShowOEMessageOnAdmUpdate As %String;

Property PATCFTransferReasonMandatory As %String;

Property PATCFUseBedManagementScreen As %String;

Property PATCFUseUserDefPayor As %String;

/// 20patientwl
Property PATCFAllowWLChangesAfterAdm As %String;

Property PATCFAllowEditCPforLinkedWLAdm As %String;

Property PATCFAllowChangePreadmDateWL As %String;

Property PATCFChangeWLStDoneArrAppt As %String;

Property PATCFChangeOPWLStDoneArrAppt As %String;

Property PATCFClearRefHospOnRemove As %String;

Property PATCFWLStatInitOnCancel As %String;

Property PATCFClearWLApptDateOutPCancel As %String;

Property PATCFPopulateAdmDocForNewWL As %String;

Property PATCFRestrictLocList As %String;

Property PATCFResetWLDaysPriorIncrease As %String;

Property PATCFWLSortByDays As %String;

Property PATCFDaysAllowChangeTCI As %String;

Property PATCFOTBookCancelReasonDR As %String;

/// /21patientw
Property PATCFAnonymousName As %String;

Property PATCFTriageWaitTime1st As %String;

Property PATCFTriageWaitTime2nd As %String;

Property PATCFAddressTypeDR As %String;

Property PATCFGovExtract As %String;

Property PATCFUnknownSexDR As %String;

Property PATCFYearsSinceLastEpisode As %String;

/// /22patientw2
Property PATCFAllowCarePlanIntApptDCONOu As %String;

Property PATCFAllowMultipleActiveGP As %String;

Property PATCFAllowOverlapGP As %String;

Property PATCFAllowOverlapIPEpisodes As %String;

Property PATCFConfirmCreateAliasSexDOB As %String;

Property PATCFConfirmToSaveAsPreviousAdd As %String;

Property PATCFCopyAlrgAlrtToBothPatU As %String;

Property PATCFDefProcDateSameDay As %String;

Property PATCFShowPreAdmInfoOnEDBedReque As %String;

Property PATCFNoOrdersCopyFromOrigAdm As %String;

Property PATCFDontDischOutPatOnDecease As %String;

Property PATCFDontDisplayInactiveAlias As %String;

Property PATCFNoExecuteOrdUponDisc As %String;

Property PATCFNoGenPRNforEMergPats As %String;

Property PATCFNoTempLocUpdateOnPatArriva As %String;

Property PATCFErrorOnExtractCodingIncomp As %String;

Property PATCFExternalPatValid As %String;

Property PATCFInclRecsAfterExtrctEndDate As %String;

Property PATCFIPInclDischPat As %String;

Property PATCFConfirmCreateAliasName As %String;

Property PATCFRestCancerRegLogonHosp As %String;

Property PATCFRestrictAdmListForLogonHos As %String;

Property PATCFRestWardDeptBook As %String;

Property PATCFSameDayPreAdm As %String;

Property PATCFSearchStartswithRego As %String;

Property PATCFTBCAlrgAlertEpisMove As %String;

Property PATCFShowMRNumberFloorPlan As %String;

Property PATCFShowRegWaitTimeFloorPlan As %String;

Property PATCFSMRReporting As %String;

Property PATCFShowWarnProcDateOutEpis As %String;

Property PATCFSortBySurnameFirstOther As %String;

Property PATCFSuppressMRRego As %String;

Property PATCFUseBedReqDateTimeEm As %String;

Property PATCFEmergStandAlone As %String;

Property PATCFUseSoundexSearchAllNames As %String;

//23petientwae

Property PATCFFreqAttendAge As %String;

Property PATCFNumberOfVisits As %String;

Property PATCFTimeFrame As %String;

Property PATCFTimeFrameType As %String;

Property PATCFNoSimultanCurrentIPEDAdms As %String;

/// 24pharmacy
Property OECFPharmacyItemNoStock As %String;

Property OECFAcceptIP As %String;

Property OECFAcceptOP As %String;

Property OECFAutoPacking As %String;

Property OECFDisplayOIDescOnPharmWB As %String;

Property OECFDisplayRefundReason As %String;

Property OECFExecuteUponCollection As %String;

Property OECFExePhDischOrdersOnDisch As %String;

Property OECFGenericPrescribing As %String;

Property OECFPickBlankExpBatchLast As %String;

Property OECFATCInterface As %String;

Property OECFWarnOutstanAmtExist As %String;

Property OECFSignOffDisclaimerDays As %String;

Property OECFDaysToRemainAtPacked As %String;

Property OECFDaysToRemainAtUncollected As %String;

Property OECFExternalMonographURL As %String;

Property OECFPrescriptionGenerated As %String;

Property OECFKinetics As %String;

Property OECFTPN As %String;

/// 25scanning
Property RTCFScannedImageType As %String;

Property RTCFResolution As %String;

/// 26stock
Property INCFDefRecTypeDR As %String;

Property INCFDaysPastTransaction As %String;

Property INCFUseExternalStockSytem As %String;

Property INCFBatchReq As %String;

Property INCFExpReq As %String;

Property INCFWardStk As %String;

/// 计算字段
/// 27stock2
Property INCFAllowMixedTax As %String;

Property INCFNegStk As %String;

Property INCFRecvMoreRequest As %String;

Property INCFDefaultAvePriceOnStRec As %String;

Property INCFAlwaysDefaultToTransfer As %String;

Property INCFDocketDateMandStockRec As %String;

Property INCFDontUpdateStItemCode As %String;

Property INCFRestrictDrugMOrdersByLoc As %String;

Property INCFIgnoreOETax As %String;

Property INCFNoSearchByAnyPart As %String;

Property INCFPromptCommercialNameOnPO As %String;

Property INCFRecalculateReorderLevel As %String;

Property INCFRecalculateReplenishLevel As %String;

Property INCFRestrictPObyPOType As %String;

Property INCFRestrictTransferSTKGroup As %String;

Property INCFReturnNonPharmacyDiscon As %String;

Property INCFReturnPharmStockDiscon As %String;

Property INCFShowZeroBatchesSTK As %String;

Property INCFSkipNoStockItemsonAddAll As %String;

Property INCFStReqDoNotAllowMultItems As %String;

Property INCFStTakeGDFNewWay As %String;

Property INCFStTakeNoCountQtyDefault As %String;

Property INCFStTkSecondCountRequired As %String;

Property INCFStTransFormatNumber As %String;

Property INCFTransDecimalRestrict As %String;

Property INCFTransAckReasonMandatory As %String;

Property INCFAckFlag As %String;

Property INCFUnifyTakeNAdjustment As %String;

Property INCFUpdateARCost As %String;

Property INCFUseStkLocRestrInquiry As %String;

/// 28system
Property SMCFMainDatabaseServer As %String;

Property SMCFCTNamespace As %String;

Property SMCFName1 As %String;

Property SMCFBillingVersion As %String;

Property SMCFMedTrakVersion As %String;

Property SMCFWordVersion As %String;

Property SMCFCrystalRepDSN As %String;

Property SMCFCrystalRepUserID As %String;

Property SMCFCrystRepPassword As %String;

Property SMCFHL7QueryTimeoutInSecs As %String;

Property SMCFInactivityTimeout As %String;

Property SMCFPasswordMinLength As %String;

Property SMCFNowNominator As %String;

Property SMCFPasswordDaysToExpire As %String;

Property SMCFInvalidLoginAttempts As %String;

Property SMCFTodayNominator As %String;

Property SMCFCloseAllFormsOnExit As %String;

Property SMCFCreateWebIndexes As %String;

Property SMCFDoNotDeleteGrouperFile As %String;

Property SMCFNoRestrictUserSameGroupOE As %String;

Property SMCFAllowDeletionFromCodeTables As %String;

Property SMCFEnableAccessNTLogon As %String;

Property SMCFPasswContainULSNChars As %String;

Property SMCFRestrictUserSameGroup As %String;

}
