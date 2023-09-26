/// 系统参数
/// 基础数据平台组-陈莹
/// 2014-4-2
Class web.DHCBL.CT.SystemParameter Extends %RegisteredObject
{

ClassMethod SaveEntityprinting(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		//1printing
		s $p(^CF("PATCF",1,4),"^",10)=eobj.PATCFPrintAdmissionNotif
		s $p(^CF("PATCF",1,4),"^",19)=eobj.PATCFPrintAdmSheetOnPaym
		s $p(^CF("PATCF",1,4),"^",20)=eobj.PATCFPrintAppointmentSlip
		s $p(^CF("PATCF",1,8),"^",7)=eobj.PATCFPrintReceipt
		s $p(^CF("RT",2),"^",18)=eobj.RTCFPrintMRBarCode
		s $p(^CF("RT",2),"^",26)=eobj.RTCFAutoPrintRequest
		s $p(^CF("RT",2),"^",19)=eobj.RTCFPrintMRRequestSlip
		s $p(^CF("PATCF",1,4),"^",18)=eobj.PATCFPrintBillOnPayment
		s $p(^CF("PATCF",1,1),"^",5)=eobj.PATCFPrLabNewPat
		s $p(^CF("OE",1),"^",10)=eobj.OECFPrintPresc
		s $p(^CF("OE",1),"^",38)=eobj.OECFPrintDelLabelOnUpdate
		s $p(^CF("PATCF",1,4),"^",1)=eobj.PATCFPrintRegisCard
		s $p(^CF("PATCF",1,8),"^",1)=eobj.PATCFPrintRBINQ01
		s $p(^CF("PATCF",1,8),"^",2)=eobj.PATCFPrintRBINQ02
		s $p(^CF("PATCF",1,8),"^",3)=eobj.PATCFPrintRBINQ03
		s $p(^CF("PATCF",1,2),"^",42)=eobj.PATCFPrintAutom1
		s $p(^CF("PATCF",1,2),"^",12)=eobj.PATCFPrintAutom2
		s $p(^CF("PATCF",1,8),"^",4)=eobj.PATCFPrintWaitList
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitybilling(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{	

		//2billing,
	s $p(^CF("CT",1),"^",7)=eobj.CTCFPayMode
	s $p(^CF("CT",1),"^",2)=eobj.CTCFCTCURDR
	s $p(^CF("OE",1),"^",15)=eobj.OECFInpatientBilling
	s $p(^CF("PATCF",1,7),"^",6)=eobj.PATCFPriceToDisplayOnRB
	s $p(^CF("PATCF",1,7),"^",8)=eobj.PATCFStampDutyChargeDR
	s $p(^CF("PATCF",1,6),"^",7)=eobj.PATCFDefaultTariffDR
	s $p(^CF("PATCF",1,10),"^",13)=eobj.PATCFAllowPartialPaymentPayorBi
	s $p(^CF("PATCF",1,10),"^",18)=eobj.PATCFApplyMaxPatDiscount
	s $p(^CF("PATCF",1,11),"^",58)=eobj.PATCFApplyNewRoomRates
	s $p(^CF("PATCF",1,6),"^",18)=eobj.PATCFCompleteOnZeroBills
	s $p(^CF("PATCF",1,7),"^",13)=eobj.PATCFConvertCurrencyInBilling
	s $p(^CF("PATCF",1,9),"^",1)=eobj.PATCFDisableMultiselectBills
	s $p(^CF("PATCF",1,12),"^",46)=eobj.PATCFCashRecptDiscntReadOnly
	s $p(^CF("PATCF",1,11),"^",26)=eobj.PATCFEligMechVentCopayment
	s $p(^CF("PATCF",1,11),"^",31)=eobj.PATCFEligMechVentCopaymentNICU
	s $p(^CF("PATCF",1,6),"^",4)=eobj.PATCFAllowDirectCashPayment
	s $p(^CF("CT",1),"^",9)=eobj.CTCFChequeDate
	;s $p(^CF("PATCF",1,?),"^",?)=eobj.PATCFEnableMultipleDiscountsOut=
	s $p(^CF("CT",1),"^",8)=eobj.CTCFMultipleCurr
	s $p(^CF("PATCF",1,9),"^",13)=eobj.PATCFOTCPayor
	s $p(^CF("PATCF",1,10),"^",6)=eobj.PATCFReasonCancelBill
	s $p(^CF("PATCF",1,9),"^",15)=eobj.PATCFRefreshCashiierAfterOE
	s $p(^CF("PATCF",1,10),"^",7)=eobj.PATCFRestrictNegOutsAmt
	s $p(^CF("PATCF",1,7),"^",10)=eobj.PATCFSameBillPatientPayor
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitybillingw(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		/// 3billingw
	s $p(^CF("PATCF",1,11),"^",45)=eobj.PATCFTitleOfDeceasedPat
	s $p(^CF("PATCF",1,11),"^",46)=eobj.PATCFParentGuardianTitle
	s $p(^CF("PATCF",1,11),"^",47)=eobj.PATCFAgeCutOffMinors
	s $p(^CF("PATCF",1,13),"^",7)=eobj.PATCFInvoiceRounding
	s $p(^CF("PATCF",1,12),"^",66)=eobj.PATCFRoundingAmount
	s $p(^CF("PATCF",1,12),"^",65)=eobj.PATCFRoundingPaymentAdjustmentD
	///时间格式
	s:eobj.PATCFTimeRoomChargeApply'="" eobj.PATCFTimeRoomChargeApply=$zth(eobj.PATCFTimeRoomChargeApply,1)
	s $p(^CF("PATCF",1,12),"^",40)=eobj.PATCFTimeRoomChargeApply
	s $p(^CF("PATCF",1,13),"^",20)=eobj.PATCFDepositAllocAlert
	s $p(^CF("PATCF",1,11),"^",67)=eobj.PATCFAddLinkedPlansOnAdm
	s $p(^CF("PATCF",1,11),"^",65)=eobj.PATCFAllowPartialPaymentSystemB
	s $p(^CF("PATCF",1,12),"^",60)=eobj.PATCFMotherBabyEpisAutoLink
	s $p(^CF("OE",1),"^",76)=eobj.OECFBillAdminDrugs
	s $p(^CF("PATCF",1,12),"^",26)=eobj.PATCFCancelPaymUponCancelBill
	s $p(^CF("PATCF",1,13),"^",1)=eobj.PATCFCopyPayorPlanFromPrevAdm
	s $p(^CF("PATCF",1,13),"^",2)=eobj.PATCFCopyPayorPlanDetFromPrevAd
	s $p(^CF("PATCF",1,12),"^",3)=eobj.PATCFShowZeroBillsUnpaid
	s $p(^CF("PATCF",1,12),"^",63)=eobj.PATCFLinkEDOUTEpisToIP
	s $p(^CF("PATCF",1,12),"^",7)=eobj.PATCFLastCPPaidForED
	s $p(^CF("PATCF",1,12),"^",4)=eobj.PATCFShowNegativeInvUnpaid
	s $p(^CF("PATCF",1,12),"^",54)=eobj.PATCFStoreAppPayPlanOverAdm
	s $p(^CF("PATCF",1,12),"^",61)=eobj.PATCFTenderPayment
	s $p(^CF("PATCF",1,11),"^",29)=eobj.PATCFUseCRAFTFunctionality
	s $p(^CF("PATCF",1,11),"^",25)=eobj.PATCFUseWIESVICDRGFunction
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitybooking(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//4booking
	s $p(^CF("PATCF",1,11),"^",42)=eobj.PATCFBedRequestHours
	s $p(^CF("RB",1),"^",51)=eobj.RBCFConditionAutoEpAppt
	s $p(^CF("RB",1),"^",3)=eobj.RBCFNoDayGenSchedule
	s $p(^CF("RB",1),"^",17)=eobj.RBCFMultipleServicesSearch
	s $p(^CF("RB",1),"^",40) =eobj.RBCFMaxWeeksIrregSchedule
	s $p(^CF("RB",1),"^",41)=eobj.RBCFPercentIncrServDuration
	s $p(^CF("RB",1),"^",44)=eobj.RBCFOverBookReasonDR
	s $p(^CF("RB",1),"^",42)=eobj.RBCFMaxPeriodCheckEpisNum
	s $p(^CF("RB",1),"^",43)=eobj.RBCFMaxPeriodCheckEpis1
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitybooking2(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		// 5booking2
	s $p(^CF("RB",1),"^",16)=eobj.RBCFAllowOverBookWalkins
	s $p(^CF("RB",1),"^",24)=eobj.RBCFAllowOverBookingAvailSlots
	s $p(^CF("RB",1),"^",23)=eobj.RBCFAllowBookOverlapAppoint
	s $p(^CF("RB",1),"^",50)=eobj.RBCFAllowTransferEarlyAdmDate
	s $p(^CF("RB",1),"^",31)=eobj.RBCFCancelAdmOnCancelAppt
	s $p(^CF("RB",1),"^",59)=eobj.RBCFNoWarningOnApptCancel
	s $p(^CF("RB",1),"^",52)=eobj.RBCFDischEpCancelFutureAppts
	s $p(^CF("RB",1),"^",32)=eobj.RBCFAdmDateEarliestApptDate
	s $p(^CF("PATCF",1,13),"^",13)=eobj.PATCFMakeCurrOPAdmForOPDAttend
	s $p(^CF("RB",1),"^",58)=eobj.RBCFDefaultPatientDetPayorPlan
	s $p(^CF("RB",1),"^",46)=eobj.RBCFDefResourceLastAppt
	s $p(^CF("RB",1),"^",34)=eobj.RBCFDisableRTCreationAppt
	s $p(^CF("RB",1),"^",29)=eobj.RBCFDisplayOrderNotes
	s $p(^CF("RB",1),"^",39)=eobj.RBCFExtendReferralPeriod
	s $p(^CF("RB",1),"^",53)=eobj.RBCFGenerate1stWeekOfCycle
	s $p(^CF("RB",1),"^",57)=eobj.RBCFGroupNoEpisodeCreation
	s $p(^CF("RB",1),"^",47)=eobj.RBCFKeepLocAnResource
	s $p(^CF("RB",1),"^",56)=eobj.RBCFWebNotMoveOnHoldOnSchGen
	s $p(^CF("RB",1),"^",14)=eobj.RBCFRestrictServices
	s $p(^CF("RB",1),"^",33)=eobj.RBCFSetAdmDateTimeToAppt
	s $p(^CF("RB",1),"^",28)=eobj.RBCFShowBookedAppt
	s $p(^CF("RB",1),"^",35)=eobj.RBCFShowBookingNotesMessage
	s $p(^CF("RB",1),"^",38)=eobj.RBCFShowReferralAfterChangeStat
	s $p(^CF("RB",1),"^",26)=eobj.RBCFRestrictPayorPlan
	s $p(^CF("RB",1),"^",22)=eobj.RBCFUseUserDefPayor
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityclinical(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		// 6 clinical,
	s $p(^CF("PATCF",1,9),"^",12)=eobj.PATCFMRCType2DR
	s $p(^CF("PATCF",1,9),"^",11)=eobj.PATCFMRCType1DR
	s $p(^CF("PATCF",1,5),"^",2)=eobj.PATCFDefNewBornDepDR
	s $p(^CF("PATCF",1,8),"^",12)=eobj.PATCFNewBornEpisSubTypeDR
	s $p(^CF("PATCF",1,6),"^",11)=eobj.PATCFFemaleSexDR
	s $p(^CF("PATCF",1,10),"^",10)=eobj.PATCFAllergyDR
	s $p(^CF("OE",1),"^",75)=eobj.OECFTextForDeletedTestItem
	s $p(^CF("PATCF",1,13),"^",18)=eobj.PATCFActivateAdvancdEPRSecu
	s $p(^CF("PATCF",1,13),"^",19)=eobj.PATCFActivateAdvancdSOAPCon
	s $p(^CF("PATCF",1,11),"^",20)=eobj.PATCFAutomaticReadLinkedProvide
	s $p(^CF("PATCF",1,6),"^",5)=eobj.PATCFExtendDiagnosis
	s $p(^CF("PATCF",1,6),"^",12)=eobj.PATCFRestrictSingleDiagType
	s $p(^CF("PATCF",1,5),"^",14)=eobj.PATCFShowPreviousEMR
	s $p(^CF("PATCF",1,9),"^",10)=eobj.PATCFSortByQueue
	s $p(^CF("PATCF",1,12),"^",13)=eobj.PATCFGestationMaxWeeks
	s $p(^CF("PATCF",1,12),"^",12)=eobj.PATCFGestationMinWeeks
	s $p(^CF("PATCF",1,12),"^",9) =eobj.PATCFGestationMaxDays
	s $p(^CF("PATCF",1,12),"^",8)=eobj.PATCFGestationMinDays
	s $p(^CF("PATCF",1,12),"^",11)=eobj.PATCFBirthWeightMax
	s $p(^CF("PATCF",1,12),"^",10)=eobj.PATCFBirthWeightMin
	

		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitydepartment(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
			// 7department,
	s $p(^CF("OE",1),"^",25)=eobj.OECFExecuteConfirmation
	s $p(^CF("OE",1),"^",44)=eobj.OECFDisableExecuteNotArrAppt
	s $p(^CF("OE",1,4),"^",45)=eobj.OECFIgnorePayorPlanRest
	s $p(^CF("RB",1),"^",27)=eobj.RBCFOrderBySlotOrQueue
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitydischarge(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		// 8discharge
	s $p(^CF("PATCF",1,4),"^",15)=eobj.PATCFEmergDischDetails
	s $p(^CF("PATCF",1,8),"^",6)=eobj.PATCFUnavailBedStatus
	s:eobj.PATCFCutOffTimeDischarge'="" eobj.PATCFCutOffTimeDischarge=$zth(eobj.PATCFCutOffTimeDischarge,1)   //11:00:00-->39600
	s $p(^CF("PATCF",1,7),"^",7)=eobj.PATCFCutOffTimeDischarge
	s $p(^CF("PATCF",1,5),"^",13)=eobj.PATCFAllowEnterDiagnosisDischar
	s $p(^CF("PATCF",1,1),"^",15)=eobj.PATCFAllowInpatDischWOFin
	s $p(^CF("PATCF",1,8),"^",15)=eobj.PATCFDisconOrdersOnDischarge
	s $p(^CF("PATCF",1,12),"^",32)=eobj.PATCFCopyDiagToInPatAdm
	s $p(^CF("PATCF",1,11),"^",30)=eobj.PATCFNotPopDischDateTimeOnLeave
	s $p(^CF("PATCF",1,11),"^",38)=eobj.PATCFUseDischargeDateTimeAdm
	s $p(^CF("PATCF",1,11),"^",50)=eobj.PATCFUseMaxDaysOnLeaveDisch
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitygeographic(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		///9geographic
	s $p(^CF("SM",1),"^",33)=eobj.SMCFProvinceDR
	s $p(^CF("SM",1),"^",32)=eobj.SMCFCityDR
	s $p(^CF("SM",1),"^",31)=eobj.SMCFHCADR
	s $p(^CF("PATCF",1,5),"^",15)=eobj.PATCFZipCodesSetup
	s $p(^CF("PATCF",1,11),"^",66)=eobj.PATCFHospLinkedThrBedDepAlloc
	s $p(^CF("PATCF",1,7),"^",4)=eobj.PATCFDefaultZipDescIntoAddress
	
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityhtml(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//10html
	s $p(^CF("SM",1),"^",51)=eobj.SMCFExplorePath
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitylabtrak(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
	//11labtrak
	s $p(^CF("PATCF",1,7),"^",1)=eobj.PATCFLabEpisodeNumberMethod
	s $p(^CF("SM",1),"^",41)=eobj.SMCFLabtrakUserID
	s:eobj.SMCFLabtrakUserPassword'="****" $p(^CF("SM",1),"^",42)=eobj.SMCFLabtrakUserPassword
	///$p(^CF("SM",1),"^",42)= ##Class(web.SSUser).Encrypt(eobj.SMCFLabtrakUserPassword)		
	///s $p(^CF("SM",1),"^",42)=eobj.SMCFLabtrakUserPassword
	s $p(^CF("PATCF",1,7),"^",3) =eobj.PATCFDailyCounterLength
	s $p(^CF("PATCF",1,7),"^",2)=eobj.PATCFLabCounterTypeDR
	s $p(^CF("OE",1),"^",89)=eobj.OECFSendWebNRtoLabTrak
	s $p(^CF("SM",1),"^",52)=eobj.SMCFLinkExtLab
	s $p(^CF("OE",1),"^",31)=eobj.OECFExecuteLabOrder
	s $p(^CF("PATCF",1,4),"^",19)=eobj.OECFSendHospitalCodeToLab
	s $p(^CF("OE",1),"^",30)=eobj.OECFSendOrderingDoctorToLab
	s $p(^CF("OE",1),"^",81)=eobj.OECFSendRecLocToLab
	s $p(^CF("PATCF",1,12),"^",30)=eobj.PATCFUseAntibioticSeqInLab
	s $p(^CF("SM",1),"^",30)=eobj.SMCFNewLabTrak
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitymaternity(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
	/// 12maternity,6
	s $p(^CF("PATCF",1,12),"^",69)=eobj.PATCFAutoCreatePregnanForBookMA
	s $p(^CF("PATCF",1,13),"^",10)=eobj.PATCFPlacentaDetailsRequired
	s $p(^CF("PATCF",1,13),"^",14)=eobj.PATCFDaysToClosePregnEvent
	s $p(^CF("PATCF",1,12),"^",70)=eobj.PATCFBookingTypeForMaternityEqu
	s $p(^CF("PATCF",1,12),"^",72)=eobj.PATCFBreastfeedAlertCategoryDR
	s $p(^CF("PATCF",1,12),"^",71)=eobj.PATCFPregnancyAlertCategoryDR
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityoperating(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		/// 13operating,15
	s $p(^CF("PATCF",1,12),"^",36)=eobj.PATCFCanclAdmOnCanclOTAppt
	s $p(^CF("PATCF",1,12),"^",16)=eobj.PATCFDisplayTheatreTimeExcWarn
	s $p(^CF("PATCF",1,7),"^",18)=eobj.PATCFNAllORBookNA
	s $p(^CF("PATCF",1,7),"^",17)=eobj.PATCFNAllORBookNoSess
	s $p(^CF("PATCF",1,7),"^",16)=eobj.PATCFNAllORBookPast
	s $p(^CF("RB",1),"^",55)=eobj.RBCFGenerateAdmOnOTRequest
	s $p(^CF("PATCF",1,12),"^",53)=eobj.PATCFLinkOTBookToExistPreAdm
	s $p(^CF("PATCF",1,7),"^",15)=eobj.PATCFWarnORBookingMoveRes
	s $p(^CF("PATCF",1,12),"^",48)=eobj.PATCFMaxOperatingTimeMins
	s $p(^CF("PATCF",1,12),"^",57)=eobj.PATCFExtrInterFixDevice
	s $p(^CF("PATCF",1,12),"^",56)=eobj.PATCFNonProperIncisionPerc
	s $p(^CF("PATCF",1,12),"^",55)=eobj.PATCFProperIncisionPerc
	s $p(^CF("PATCF",1,12),"^",37)=eobj.PATCFOTDelayMargin
	s $p(^CF("PATCF",1,12),"^",38)=eobj.PATCFOTStartMargin
	s $p(^CF("PATCF",1,12),"^",52)=eobj.PATCFAutoCreateOTBookEpConditio
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityorders(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		/// 14orders
	s $p(^CF("OE",1),"^",9)=eobj.OECFPriorityDR
	s $p(^CF("OE",1),"^",18)=eobj.OECFDefaultOrderGroup
	s $p(^CF("OE",1),"^",21)=eobj.OECFDiagWarning
	s $p(^CF("OE",1),"^",20)=eobj.OECFCheckPrice
	s $p(^CF("OE",1),"^",86)=eobj.OECFPatLeaveOrderAdmStatusDR
	s $p(^CF("OE",1),"^",17)=eobj.OECFOrdersToRecLoc
	s $p(^CF("OE",1),"^",33)=eobj.OECFShowInstructionAs
	s $p(^CF("OE",1),"^",50)=eobj.OECFUseRepeatsOrEndDate
	s $p(^CF("OE",1),"^",63)=eobj.OECFCMVTestDR
	s $p(^CF("OE",1),"^",36)=eobj.OECFNumberOfOrdersAllowedSameGr
	s $p(^CF("OE",1),"^",60)=eobj.OECFAgeFrom
	s $p(^CF("OE",1),"^",61)=eobj.OECFAgeTo
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityorders2(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		/// 15orders2
	s $p(^CF("OE",1),"^",83)=eobj.OECFAllowConcurrentOrders
	s $p(^CF("OE",1),"^",82)=eobj.OECFAllowActiveOrdersAdmDates
	s $p(^CF("OE",1),"^",29)=eobj.OECFDiscontExecutedOrder
	s $p(^CF("OE",1),"^",71)=eobj.OECFAllowPlaceOrderOutsideEpisD
	s $p(^CF("OE",1),"^",85)=eobj.OECFDefaultOSItemBillingPriceBl
	s $p(^CF("OE",1),"^",14)=eobj.OECFChangeLinkedOnUpdate
	s $p(^CF("OE",1),"^",32)=eobj.OECFCheckOrdersCovered
	s $p(^CF("OE",1),"^",28)=eobj.OECFClearOrdersOnUpdate
	s $p(^CF("OE",1),"^",73)=eobj.OECFCreate1OrderPerToothFace
	s $p(^CF("OE",1),"^",62)=eobj.OECFCreate1OrderPerSpecimen
	s $p(^CF("OE",1),"^",69)=eobj.OECFCreateReturnQueueDisch
	s $p(^CF("OE",1),"^",68)=eobj.OECFDefaultCheckBsUnselect
	s $p(^CF("OE",1),"^",80)=eobj.OECFDisableAddForQtyBlank
	s $p(^CF("OE",1),"^",42)=eobj.OECFDiscontinueOverlapExTime
	s $p(^CF("OE",1),"^",67)=eobj.OECFDisplayDuplDosageTextBox
	s $p(^CF("OE",1),"^",64)=eobj.OECFNoDefaultPatLocOnOE
	s $p(^CF("OE",1),"^",84)=eobj.OECFNoShowLabEpForAllOrdersIPES
	s $p(^CF("OE",1),"^",65)=eobj.OECFNoShowReorderNurseWB
	
	s $p(^CF("OE",1),"^",51)=eobj.OECFAllowPackUOM
	s $p(^CF("OE",1),"^",49)=eobj.OECFEditNotes
	s $p(^CF("OE",1),"^",52)=eobj.OECFExecuteFutureOrders
	s $p(^CF("OE",1),"^",40)=eobj.OECFGenerateExecSchedOutpat
	s $p(^CF("OE",1),"^",53)=eobj.OECFIgnorePriorityDEf
	s $p(^CF("OE",1),"^",54)=eobj.OECFKeepPriorDateSession
	s $p(^CF("OE",1),"^",72)=eobj.OECFManualVerifLabOrders
	s $p(^CF("OE",1),"^",37)=eobj.OECFShowSnomedCodes
	s $p(^CF("OE",1),"^",43)=eobj.OECFWarnQtyRangeDuration
	s $p(^CF("OE",1),"^",13)=eobj.OECFSaveOrderCategory
	s $p(^CF("OE",1),"^",47)=eobj.OECFShowDisOrdersResults
	s $p(^CF("OE",1),"^",56)=eobj.OECFShowAllergyDSSQA
	s $p(^CF("OE",1),"^",39)=eobj.OECFShowDeliveryInfoOnPin
	s $p(^CF("OE",1),"^",34)=eobj.OECFUsePreprintedLabelsLab
	
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypaper(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		////16paper
	s $p(^CF("RT",2),"^",29)=eobj.RTCFRequestReasonAdmDR
	s $p(^CF("RT",2),"^",31)=eobj.RTCFDefaultReasEDRequest
	s $p(^CF("RT",2),"^",17)=eobj.RTCFRequestReasonAPPTDR
	s $p(^CF("RT",2),"^",27)=eobj.RTCFDefaultReasonWLRequest
	s $p(^CF("RT",2),"^",20)=eobj.RTCFMainMRTypeDR
	s $p(^CF("RT",2),"^",21)=eobj.RTCFMainMRVolumeDR
	s $p(^CF("RT",2),"^",22)=eobj.RTCFDaysToGetMR
	
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypaper2(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		//17paper2
	s $p(^CF("RT",2),"^",28)=eobj.RTCFAskReqDetails
	s $p(^CF("RT",2),"^",23)=eobj.RTCFBypassDepartMR
	s $p(^CF("RT",2),"^",33)=eobj.RTCFApptHoldCancelsMRReq
	s $p(^CF("RT",2),"^",41)=eobj.RTCFDisableVBAutoRequest
	s $p(^CF("RT",2),"^",38)=eobj.RTCFMarkMRNInactivePatMerge
	s $p(^CF("RT",2),"^",39)=eobj.RTCFNoShowUVMsgOnMoveMRToHomeLo
	s $p(^CF("RT",2),"^",32)=eobj.RTCFInactivateRTVolumeMerg
	s $p(^CF("RT",2),"^",40)=eobj.RTCFAutoMRRequestToNewVolume
	s $p(^CF("RT",2),"^",42)=eobj.RTCFReturnMRTHomeFirst
	s $p(^CF("RT",2),"^",37)=eobj.RTCFOnlyInactMRNLogHospMerg
	s $p(^CF("RT",2),"^",30)=eobj.RTCFShowMessageForResearchReq
	s $p(^CF("RT",2),"^",36)=eobj.RTCFViewAllVolumes
	s $p(^CF("RT",2),"^",34)=eobj.RTCFViewRequestDefaultLoc
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypatient(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		/// 18patient
	s $p(^CF("PATCF",1,10),"^",16)=eobj.PATCFWLStatOnAdmDR
	s $p(^CF("PATCF",1,9),"^",14)=eobj.PATCFCancelWListStatusDR
	s $p(^CF("PATCF",1,10),"^",9)=eobj.PATCFContactTypeDR
	s $p(^CF("PATCF",1,2),"^",44)=eobj.PATCFDaySurgeryTypeDR
	s $p(^CF("PATCF",1,8),"^",8)=eobj.PATCFDeceasedWaitListDR
	s $p(^CF("PATCF",1,9),"^",7)=eobj.PATCFBedTypeDR
	s $p(^CF("PATCF",1,7),"^",22)=eobj.PATCFLanguageDR
	s $p(^CF("PATCF",1,6),"^",14)=eobj.PATCFExemptionCounterTypeDR
	s $p(^CF("PATCF",1,7),"^",20)=eobj.PATCFGenerateAdmNo
	s $p(^CF("PATCF",1,5),"^",7)=eobj.PATCFGenerateRego
	s $p(^CF("PATCF",1,7),"^",12)=eobj.PATCFHICClaimCounterDR
	s $p(^CF("PATCF",1,1),"^",6)=eobj.PATCFNextOfKin
	s $p(^CF("PATCF",1,11),"^",39)=eobj.PATCFUpperLimitDisplayDays
	s $p(^CF("PATCF",1,11),"^",40)=eobj.PATCFUpperLimitDisplayWeeks
	s $p(^CF("PATCF",1,11),"^",41)=eobj.PATCFUpperLimitDisplayMonths
	s $p(^CF("PATCF",1,12),"^",5)=eobj.PATCFSearchOnDays
	s $p(^CF("PATCF",1,11),"^",53)=eobj.PATCFSearchOnMonth
	s $p(^CF("PATCF",1,6),"^",1)=eobj.PATCFDefaultTabInRegistration
	s $p(^CF("PATCF",1,11),"^",54)=eobj.PATCFNoRowsDiagProc
	s $p(^CF("PATCF",1,10),"^",12)=eobj.PATCFFemalePensionAge
	s $p(^CF("PATCF",1,11),"^",57)=eobj.PATCFLimitNoDaysForSearch
	s $p(^CF("PATCF",1,10),"^",11)=eobj.PATCFMalePensionAge
	s $p(^CF("PATCF",1,10),"^",14)=eobj.PATCFMaxDaysOnLeave
	s $p(^CF("PATCF",1,6),"^",10)=eobj.PATCFFieldLength
	s $p(^CF("PATCF",1,5),"^",3)=eobj.PATCFNoFieldsPatName
	s $p(^CF("PATCF",1,11),"^",55)=eobj.PATCFNoDaysForAdmSearchToCopyFr
	s $p(^CF("PATCF",1,11),"^",49)=eobj.PATCFDaysToIncludeDischPat
	s $p(^CF("PATCF",1,10),"^",8)=eobj.PATCFNoOfYearsAgeSearch
	s $p(^CF("PATCF",1,11),"^",21)=eobj.PATCFShowMonthsWhenInactive
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypatient2(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		/// 19patient2	
	s $p(^CF("PATCF",1,6),"^",2)=eobj.PATCFEmergencyPatBedOption
	s $p(^CF("PATCF",1,5),"^",4)=eobj.PATCFAllowSelfAdmission
	s $p(^CF("PATCF",1,8),"^",14)=eobj.PATCFUsePayorFromPrevEpisode
	s $p(^CF("PATCF",1,7),"^",23)=eobj.PATCFArrivePatientOnReg
	s $p(^CF("PATCF",1,5),"^",12)=eobj.PATCFAssignDepartmentToBed
	s $p(^CF("PATCF",1,6),"^",13)=eobj.PATCFShowreasonChangePatData
	s $p(^CF("PATCF",1,6),"^",3)=eobj.PATCFUseDRGGrouper
	s $p(^CF("PATCF",1,4),"^",17)=eobj.PATCFChooseReferalDoctorFromLis
	s $p(^CF("PATCF",1,4),"^",16)=eobj.PATCFCollectRegistrFee
	s $p(^CF("PATCF",1,5),"^",6)=eobj.PATCFProcess
	s $p(^CF("PATCF",1,9),"^",6)=eobj.PATCFDefAdmDepartBDMAN
	s $p(^CF("PATCF",1,9),"^",8)=eobj.PATCFDef2ndTabEpisDetails
	s $p(^CF("PATCF",1,6),"^",8)=eobj.PATCFDisableInsuranceOfficeComb
	s $p(^CF("PATCF",1,6),"^",15)=eobj.PATCFDisplayRegDetAfterBedAssig
	s $p(^CF("PATCF",1,7),"^",11)=eobj.PATCFShowPreadmAfterAppoint
	s $p(^CF("PATCF",1,4),"^",21)=eobj.PATCFIsRefDoctorMandatory
	s $p(^CF("PATCF",1,2),"^",68)=eobj.PATCFDisplayZipDescription
	s $p(^CF("PATCF",1,8),"^",15)=eobj.PATCFRefreshPATMANOE
	s $p(^CF("PATCF",1,11),"^",56)=eobj.PATCFSaveOutPatEpUponInConv
	s $p(^CF("PATCF",1,9),"^",9)=eobj.PATCFSaveRegNumExtDB
	s $p(^CF("PATCF",1,7),"^",5)=eobj.PATCFSearchByKeywords
	s $p(^CF("PATCF",1,11),"^",24)=eobj.PATCFSearchOnExactMRN
	s $p(^CF("PATCF",1,5),"^",1)=eobj.PATCFShowOEMessageOnAdmUpdate
	s $p(^CF("PATCF",1,8),"^",9)=eobj.PATCFTransferReasonMandatory
	s $p(^CF("PATCF",1,6),"^",17)=eobj.PATCFUseBedManagementScreen
	s $p(^CF("PATCF",1,7),"^",21)=eobj.PATCFUseUserDefPayor
	
		
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypatientwl(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
	/// 20patientwl
	s $p(^CF("PATCF",1,11),"^",34)=eobj.PATCFAllowWLChangesAfterAdm
	s $p(^CF("PATCF",1,11),"^",69)=eobj.PATCFAllowEditCPforLinkedWLAdm
	s $p(^CF("PATCF",1,12),"^",1)=eobj.PATCFAllowChangePreadmDateWL
	s $p(^CF("PATCF",1,12),"^",6)=eobj.PATCFChangeWLStDoneArrAppt
	s $p(^CF("PATCF",1,12),"^",39)=eobj.PATCFChangeOPWLStDoneArrAppt
	s $p(^CF("PATCF",1,12),"^",14)=eobj.PATCFClearRefHospOnRemove
	s $p(^CF("PATCF",1,10),"^",5)=eobj.PATCFWLStatInitOnCancel
	s $p(^CF("PATCF",1,11),"^",37)=eobj.PATCFClearWLApptDateOutPCancel
	s $p(^CF("PATCF",1,12),"^",25)=eobj.PATCFPopulateAdmDocForNewWL
	s $p(^CF("PATCF",1,8),"^",10)=eobj.PATCFRestrictLocList
	s $p(^CF("PATCF",1,11),"^",62)=eobj.PATCFResetWLDaysPriorIncrease
	s $p(^CF("PATCF",1,8),"^",13)=eobj.PATCFWLSortByDays
	s $p(^CF("PATCF",1,12),"^",58)=eobj.PATCFDaysAllowChangeTCI
	s $p(^CF("PATCF",1,13),"^",9)=eobj.PATCFOTBookCancelReasonDR
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypatientw(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		////21patientw
	s $p(^CF("PATCF",1,12),"^",47)=eobj.PATCFAnonymousName
	s $p(^CF("PATCF",1,12),"^",44)=eobj.PATCFTriageWaitTime1st
	s $p(^CF("PATCF",1,12),"^",45)=eobj.PATCFTriageWaitTime2nd
	s $p(^CF("PATCF",1,12),"^",19)=eobj.PATCFAddressTypeDR
	s $p(^CF("PATCF",1,12),"^",42)=eobj.PATCFGovExtract
	s $p(^CF("PATCF",1,12),"^",22)=eobj.PATCFUnknownSexDR
	s $p(^CF("PATCF",1,12),"^",67)=eobj.PATCFYearsSinceLastEpisode
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypatientw2(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		
	////22patientw2
	s $p(^CF("PATCF",1,12),"^",51)=eobj.PATCFAllowCarePlanIntApptDCONOu
	s $p(^CF("PATCF",1,11),"^",51)=eobj.PATCFAllowMultipleActiveGP
	s $p(^CF("PATCF",1,11),"^",33)=eobj.PATCFAllowOverlapGP
	s $p(^CF("PATCF",1,11),"^",68)=eobj.PATCFAllowOverlapIPEpisodes
	s $p(^CF("PATCF",1,11),"^",59)=eobj.PATCFConfirmCreateAliasSexDOB
	s $p(^CF("PATCF",1,12),"^",17)=eobj.PATCFConfirmToSaveAsPreviousAdd
	s $p(^CF("PATCF",1,12),"^",18)=eobj.PATCFCopyAlrgAlrtToBothPatU
	s $p(^CF("PATCF",1,12),"^",15)=eobj.PATCFDefProcDateSameDay
	s $p(^CF("PATCF",1,12),"^",64)=eobj.PATCFShowPreAdmInfoOnEDBedReque
	s $p(^CF("PATCF",1,12),"^",27)=eobj.PATCFNoOrdersCopyFromOrigAdm
	s $p(^CF("PATCF",1,11),"^",61)=eobj.PATCFDontDischOutPatOnDecease
	s $p(^CF("PATCF",1,12),"^",21)=eobj.PATCFDontDisplayInactiveAlias
	s $p(^CF("PATCF",1,11),"^",71)=eobj.PATCFNoExecuteOrdUponDisc
	s $p(^CF("PATCF",1,11),"^",27)=eobj.PATCFNoGenPRNforEMergPats
	s $p(^CF("PATCF",1,13),"^",15)=eobj.PATCFNoTempLocUpdateOnPatArriva
	s $p(^CF("PATCF",1,11),"^",63)=eobj.PATCFErrorOnExtractCodingIncomp
	s $p(^CF("PATCF",1,12),"^",49)=eobj.PATCFExternalPatValid
	s $p(^CF("PATCF",1,11),"^",64)=eobj.PATCFInclRecsAfterExtrctEndDate
	s $p(^CF("PATCF",1,11),"^",52)=eobj.PATCFIPInclDischPat
	s $p(^CF("PATCF",1,12),"^",62)=eobj.PATCFConfirmCreateAliasName
	s $p(^CF("PATCF",1,12),"^",29)=eobj.PATCFRestCancerRegLogonHosp
	s $p(^CF("PATCF",1,13),"^",8)=eobj.PATCFRestrictAdmListForLogonHos
	s $p(^CF("PATCF",1,12),"^",41)=eobj.PATCFRestWardDeptBook
	s $p(^CF("PATCF",1,12),"^",50)=eobj.PATCFSameDayPreAdm
	s $p(^CF("PATCF",1,12),"^",59)=eobj.PATCFSearchStartswithRego
	s $p(^CF("PATCF",1,12),"^",20)=eobj.PATCFTBCAlrgAlertEpisMove
	s $p(^CF("PATCF",1,12),"^",2)=eobj.PATCFShowMRNumberFloorPlan
	s $p(^CF("PATCF",1,11),"^",70)=eobj.PATCFShowRegWaitTimeFloorPlan
	s $p(^CF("PATCF",1,11),"^",48)=eobj.PATCFSMRReporting
	s $p(^CF("PATCF",1,12),"^",24)=eobj.PATCFShowWarnProcDateOutEpis
	s $p(^CF("PATCF",1,11),"^",60)=eobj.PATCFSortBySurnameFirstOther
	s $p(^CF("PATCF",1,11),"^",19)=eobj.PATCFSuppressMRRego
	s $p(^CF("PATCF",1,11),"^",32)=eobj.PATCFUseBedReqDateTimeEm
	s $p(^CF("PATCF",1,10),"^",15)=eobj.PATCFEmergStandAlone
	s $p(^CF("PATCF",1,12),"^",35)=eobj.PATCFUseSoundexSearchAllNames
	
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypetientwae(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		//23petientwae
	s $p(^CF("PATCF",1,13),"^",3)=eobj.PATCFFreqAttendAge
	s $p(^CF("PATCF",1,13),"^",4)=eobj.PATCFNumberOfVisits
	s $p(^CF("PATCF",1,13),"^",5)=eobj.PATCFTimeFrame
	s $p(^CF("PATCF",1,13),"^",6)=eobj.PATCFTimeFrameType
	s $p(^CF("PATCF",1,13),"^",12)=eobj.PATCFNoSimultanCurrentIPEDAdms
	
	
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitypharmacy(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		/// 24pharmacy
	s $p(^CF("OE",1),"^",27)=eobj.OECFPharmacyItemNoStock
	s $p(^CF("OE",1),"^",22)=eobj.OECFAcceptIP
	s $p(^CF("OE",1),"^",23)=eobj.OECFAcceptOP
	s $p(^CF("OE",1),"^",24)=eobj.OECFAutoPacking
	s $p(^CF("OE",1),"^",70)=eobj.OECFDisplayOIDescOnPharmWB
	s $p(^CF("OE",1),"^",55)=eobj.OECFDisplayRefundReason
	s $p(^CF("OE",1),"^",78)=eobj.OECFExecuteUponCollection
	s $p(^CF("OE",1),"^",79)=eobj.OECFExePhDischOrdersOnDisch
	s $p(^CF("OE",1),"^",74)=eobj.OECFGenericPrescribing
	s $p(^CF("OE",1),"^",94)=eobj.OECFPickBlankExpBatchLast
	s $p(^CF("OE",1),"^",16)=eobj.OECFATCInterface
	s $p(^CF("OE",1),"^",93)=eobj.OECFWarnOutstanAmtExist
	s $p(^CF("OE",1),"^",96)=eobj.OECFSignOffDisclaimerDays
	s $p(^CF("OE",1),"^",91)=eobj.OECFDaysToRemainAtPacked
	s $p(^CF("OE",1),"^",92)=eobj.OECFDaysToRemainAtUncollected
	s $p(^CF("OE",1),"^",95)=eobj.OECFExternalMonographURL
	s $p(^CF("OE",1),"^",35)=eobj.OECFPrescriptionGenerated
	s $p(^CF("OE",1),"^",87)=eobj.OECFKinetics
	s $p(^CF("OE",1),"^",88)=eobj.OECFTPN
	
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntityscanning(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		/// 25scanning
	s $p(^CF("RT",2),"^",25)=eobj.RTCFScannedImageType
	s $p(^CF("RT",2),"^",24)=eobj.RTCFResolution
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitystock(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
	/// 26stock
	s $p(^CF("IN",1),"^",5)=eobj.INCFDefRecTypeDR
	s $p(^CF("IN",1),"^",28)=eobj.INCFDaysPastTransaction
	s $p(^CF("IN",1),"^",48)=eobj.INCFUseExternalStockSytem
	s $p(^CF("IN",1),"^",11)=eobj.INCFBatchReq
	s $p(^CF("IN",1),"^",12)=eobj.INCFExpReq
	s $p(^CF("IN",1),"^",7)=eobj.INCFWardStk
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitystock2(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		
		///27stock2
	s $p(^CF("IN",1),"^",31)=eobj.INCFAllowMixedTax
	s $p(^CF("IN",1),"^",4)=eobj.INCFNegStk
	s $p(^CF("IN",1),"^",21)=eobj.INCFRecvMoreRequest
	s $p(^CF("IN",1),"^",40)=eobj.INCFDefaultAvePriceOnStRec
	s $p(^CF("IN",1),"^",27)=eobj.INCFAlwaysDefaultToTransfer
	s $p(^CF("IN",1),"^",35)=eobj.INCFDocketDateMandStockRec
	s $p(^CF("IN",1),"^",42)=eobj.INCFDontUpdateStItemCode
	s $p(^CF("IN",1),"^",43)=eobj.INCFRestrictDrugMOrdersByLoc
	s $p(^CF("IN",1),"^",30)=eobj.INCFIgnoreOETax
	s $p(^CF("IN",1),"^",52)=eobj.INCFNoSearchByAnyPart
	s $p(^CF("IN",1),"^",38)=eobj.INCFPromptCommercialNameOnPO
	s $p(^CF("IN",1),"^",24)=eobj.INCFRecalculateReorderLevel
	s $p(^CF("IN",1),"^",25)=eobj.INCFRecalculateReplenishLevel
	s $p(^CF("IN",1),"^",23)=eobj.INCFRestrictPObyPOType
	s $p(^CF("IN",1),"^",22)=eobj.INCFRestrictTransferSTKGroup
	s $p(^CF("IN",1),"^",32)=eobj.INCFReturnNonPharmacyDiscon
	s $p(^CF("IN",1),"^",33)=eobj.INCFReturnPharmStockDiscon
	s $p(^CF("IN",1),"^",37)=eobj.INCFShowZeroBatchesSTK
	s $p(^CF("IN",1),"^",26)=eobj.INCFSkipNoStockItemsonAddAll
	s $p(^CF("IN",1),"^",46)=eobj.INCFStReqDoNotAllowMultItems
	s $p(^CF("IN",1),"^",50)=eobj.INCFStTakeGDFNewWay
	s $p(^CF("IN",1),"^",49)=eobj.INCFStTakeNoCountQtyDefault
	s $p(^CF("IN",1),"^",51)=eobj.INCFStTkSecondCountRequired
	s $p(^CF("IN",1),"^",44)=eobj.INCFStTransFormatNumber
	s $p(^CF("IN",1),"^",45)=eobj.INCFTransDecimalRestrict
	s $p(^CF("IN",1),"^",41)=eobj.INCFTransAckReasonMandatory
	s $p(^CF("IN",1),"^",1)=eobj.INCFAckFlag
	s $p(^CF("IN",1),"^",34)=eobj.INCFUnifyTakeNAdjustment
	s $p(^CF("IN",1),"^",20)=eobj.INCFUpdateARCost
	s $p(^CF("IN",1),"^",36)=eobj.INCFUseStkLocRestrInquiry
	
	
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

ClassMethod SaveEntitysystem(eobj As web.Entity.CT.SystemParameter) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		/// 28system
	s $p(^CF("SM",1),"^",22)=eobj.SMCFMainDatabaseServer
	s $p(^CF("SM",1),"^",57)=eobj.SMCFCTNamespace
	s $p(^CF("SM",1),"^",5)=eobj.SMCFName1
	s $p(^CF("SM",1),"^",12)=eobj.SMCFBillingVersion
	s $p(^CF("SM",1),"^",9)=eobj.SMCFMedTrakVersion
	s $p(^CF("SM",1),"^",13)=eobj.SMCFWordVersion
	s $p(^CF("SM",1),"^",34)=eobj.SMCFCrystalRepDSN
	s $p(^CF("SM",1),"^",35)=eobj.SMCFCrystalRepUserID
	s:eobj.SMCFCrystRepPassword'="****" $p(^CF("SM",1),"^",36)=eobj.SMCFCrystRepPassword
	s $p(^CF("SM",1),"^",62)=eobj.SMCFHL7QueryTimeoutInSecs
	s $p(^CF("SM",1),"^",39)=eobj.SMCFInactivityTimeout
	s $p(^CF("SM",1),"^",49)=eobj.SMCFPasswordMinLength
	s $p(^CF("SM",1),"^",17)=eobj.SMCFNowNominator
	s $p(^CF("SM",1),"^",48)=eobj.SMCFPasswordDaysToExpire
	s $p(^CF("SM",1),"^",46)=eobj.SMCFInvalidLoginAttempts
	s $p(^CF("SM",1),"^",16)=eobj.SMCFTodayNominator
	s $p(^CF("SM",1),"^",40)=eobj.SMCFCloseAllFormsOnExit
	s $p(^CF("SM",1),"^",58)=eobj.SMCFCreateWebIndexes
	s $p(^CF("SM",1),"^",63)=eobj.SMCFDoNotDeleteGrouperFile
	s $p(^CF("SM",1),"^",60)=eobj.SMCFNoRestrictUserSameGroupOE
	s $p(^CF("SM",1),"^",27)=eobj.SMCFAllowDeletionFromCodeTables
	s $p(^CF("SM",1),"^",54)=eobj.SMCFEnableAccessNTLogon
	s $p(^CF("SM",1),"^",56)=eobj.SMCFPasswContainULSNChars
	s $p(^CF("SM",1),"^",59)=eobj.SMCFRestrictUserSameGroup
	
	
		
		
		s result = "{success:'true'}"
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// 获取系统参数数据
ClassMethod GetSysPara(id As %String) As %String
{
    s str = ""
	s eobj = ##class(web.Entity.CT.SystemParameter).%New()
	
	//1print
	s eobj.PATCFPrintAdmissionNotif=$p($g(^CF("PATCF",1,4)),"^",10)
	s:eobj.PATCFPrintAdmissionNotif="Y" eobj.PATCFPrintAdmissionNotif="true"
	s eobj.PATCFPrintAdmSheetOnPaym=$p($g(^CF("PATCF",1,4)),"^",19)
	s:eobj.PATCFPrintAdmSheetOnPaym="Y" eobj.PATCFPrintAdmSheetOnPaym="true" 
	s eobj.PATCFPrintAppointmentSlip=$p($g(^CF("PATCF",1,4)),"^",20)
	s:eobj.PATCFPrintAppointmentSlip="Y" eobj.PATCFPrintAppointmentSlip="true"
	s eobj.PATCFPrintReceipt=$p($g(^CF("PATCF",1,8)),"^",7)
	s:eobj.PATCFPrintReceipt="Y" eobj.PATCFPrintReceipt="true"
	s eobj.RTCFPrintMRBarCode=$p($g(^CF("RT",2)),"^",18)
	s:eobj.RTCFPrintMRBarCode="Y" eobj.RTCFPrintMRBarCode="true"
	s eobj.RTCFAutoPrintRequest=$p($g(^CF("RT",2)),"^",26)
	s:eobj.RTCFAutoPrintRequest="Y" eobj.RTCFAutoPrintRequest="true"
	s eobj.RTCFPrintMRRequestSlip=$p($g(^CF("RT",2)),"^",19)
	s:eobj.RTCFPrintMRRequestSlip="Y" eobj.RTCFPrintMRRequestSlip="true"
	s eobj.PATCFPrintBillOnPayment=$p($g(^CF("PATCF",1,4)),"^",18)
	s:eobj.PATCFPrintBillOnPayment="Y" eobj.PATCFPrintBillOnPayment="true"
	s eobj.PATCFPrLabNewPat=$p($g(^CF("PATCF",1,1)),"^",5)
	s:eobj.PATCFPrLabNewPat="Y" eobj.PATCFPrLabNewPat="true"
	s eobj.OECFPrintPresc=$p($g(^CF("OE",1)),"^",10)
	s:eobj.OECFPrintPresc="Y" eobj.OECFPrintPresc="true"
	s eobj.OECFPrintDelLabelOnUpdate=$p($g(^CF("OE",1)),"^",38)
	s:eobj.OECFPrintDelLabelOnUpdate="Y" eobj.OECFPrintDelLabelOnUpdate="true"
	s eobj.PATCFPrintRegisCard=$p($g(^CF("PATCF",1,4)),"^",1)
	s:eobj.PATCFPrintRegisCard="Y" eobj.PATCFPrintRegisCard="true"
	s eobj.PATCFPrintRBINQ01=$p($g(^CF("PATCF",1,8)),"^",1)
	s:eobj.PATCFPrintRBINQ01="Y" eobj.PATCFPrintRBINQ01="true"
	s eobj.PATCFPrintRBINQ02=$p($g(^CF("PATCF",1,8)),"^",2)
	s:eobj.PATCFPrintRBINQ02="Y" eobj.PATCFPrintRBINQ02="true"
	s eobj.PATCFPrintRBINQ03=$p($g(^CF("PATCF",1,8)),"^",3)
	s:eobj.PATCFPrintRBINQ03="Y" eobj.PATCFPrintRBINQ03="true"
	s eobj.PATCFPrintAutom1=$p($g(^CF("PATCF",1,2)),"^",42)
	s:eobj.PATCFPrintAutom1="Y" eobj.PATCFPrintAutom1="true"
	s eobj.PATCFPrintAutom2=$p($g(^CF("PATCF",1,2)),"^",12)
	s:eobj.PATCFPrintAutom2="Y" eobj.PATCFPrintAutom2="true"
	s eobj.PATCFPrintWaitList=$p($g(^CF("PATCF",1,8)),"^",4)
	s:eobj.PATCFPrintWaitList="Y" eobj.PATCFPrintWaitList="true"
	
	//2billing,
	s eobj.CTCFPayMode=$p($g(^CF("CT",1)),"^",7)
	s eobj.CTCFCTCURDR=$p($g(^CF("CT",1)),"^",2)
	s eobj.OECFInpatientBilling=$p($g(^CF("OE",1)),"^",15)
	s eobj.PATCFPriceToDisplayOnRB=$p($g(^CF("PATCF",1,7)),"^",6)
	s eobj.PATCFStampDutyChargeDR=$p($g(^CF("PATCF",1,7)),"^",8)
	s eobj.PATCFDefaultTariffDR=$p($g(^CF("PATCF",1,6)),"^",7)
	s eobj.PATCFAllowPartialPaymentPayorBi=$p($g(^CF("PATCF",1,10)),"^",13)
	s:eobj.PATCFAllowPartialPaymentPayorBi="Y" eobj.PATCFAllowPartialPaymentPayorBi="true"
	s eobj.PATCFApplyMaxPatDiscount=$p($g(^CF("PATCF",1,10)),"^",18)
	s:eobj.PATCFApplyMaxPatDiscount="Y" eobj.PATCFApplyMaxPatDiscount="true"
	s eobj.PATCFApplyNewRoomRates=$p($g(^CF("PATCF",1,11)),"^",58)
	s:eobj.PATCFApplyNewRoomRates="Y" eobj.PATCFApplyNewRoomRates="true"
	s eobj.PATCFCompleteOnZeroBills=$p($g(^CF("PATCF",1,6)),"^",18)
	s:eobj.PATCFCompleteOnZeroBills="Y" eobj.PATCFCompleteOnZeroBills="true"
	s eobj.PATCFConvertCurrencyInBilling=$p($g(^CF("PATCF",1,7)),"^",13)
	s:eobj.PATCFConvertCurrencyInBilling="Y" eobj.PATCFConvertCurrencyInBilling="true"
	s eobj.PATCFDisableMultiselectBills=$p($g(^CF("PATCF",1,9)),"^",1)
	s:eobj.PATCFDisableMultiselectBills="Y" eobj.PATCFDisableMultiselectBills="true"
	s eobj.PATCFCashRecptDiscntReadOnly=$p($g(^CF("PATCF",1,12)),"^",46)
	s:eobj.PATCFCashRecptDiscntReadOnly="Y" eobj.PATCFCashRecptDiscntReadOnly="true"
	s eobj.PATCFEligMechVentCopayment=$p($g(^CF("PATCF",1,11)),"^",26)
	s:eobj.PATCFEligMechVentCopayment="Y" eobj.PATCFEligMechVentCopayment="true"
	s eobj.PATCFEligMechVentCopaymentNICU=$p($g(^CF("PATCF",1,11)),"^",31)
	s:eobj.PATCFEligMechVentCopaymentNICU="Y" eobj.PATCFEligMechVentCopaymentNICU="true"
	s eobj.PATCFAllowDirectCashPayment=$p($g(^CF("PATCF",1,6)),"^",4)
	s:eobj.PATCFAllowDirectCashPayment="Y" eobj.PATCFAllowDirectCashPayment="true"
	s eobj.CTCFChequeDate=$p($g(^CF("CT",1)),"^",9)
	s:eobj.CTCFChequeDate="Y" eobj.CTCFChequeDate="true"
	;s eobj.PATCFEnableMultipleDiscountsOut=$p($g(^CF("PATCF",1,?)),"^",?)
	;s:eobj.PATCFEnableMultipleDiscountsOut="Y" eobj.PATCFEnableMultipleDiscountsOut="true"
	s eobj.CTCFMultipleCurr=$p($g(^CF("CT",1)),"^",8)
	s:eobj.CTCFMultipleCurr="Y" eobj.CTCFMultipleCurr="true"
	s eobj.PATCFOTCPayor=$p($g(^CF("PATCF",1,9)),"^",13)
	s:eobj.PATCFOTCPayor="Y" eobj.PATCFOTCPayor="true"
	s eobj.PATCFReasonCancelBill=$p($g(^CF("PATCF",1,10)),"^",6)
	s:eobj.PATCFReasonCancelBill="Y" eobj.PATCFReasonCancelBill="true"
	s eobj.PATCFRefreshCashiierAfterOE=$p($g(^CF("PATCF",1,9)),"^",15)
	s:eobj.PATCFRefreshCashiierAfterOE="Y" eobj.PATCFRefreshCashiierAfterOE="true"
	s eobj.PATCFRestrictNegOutsAmt=$p($g(^CF("PATCF",1,10)),"^",7)
	s:eobj.PATCFRestrictNegOutsAmt="Y" eobj.PATCFRestrictNegOutsAmt="true"
	s eobj.PATCFSameBillPatientPayor=$p($g(^CF("PATCF",1,7)),"^",10)
	s:eobj.PATCFSameBillPatientPayor="Y" eobj.PATCFSameBillPatientPayor="true"
	
	/// 3billingw
	s eobj.PATCFTitleOfDeceasedPat=$p($g(^CF("PATCF",1,11)),"^",45)
	s eobj.PATCFParentGuardianTitle=$p($g(^CF("PATCF",1,11)),"^",46)
	s eobj.PATCFAgeCutOffMinors=$p($g(^CF("PATCF",1,11)),"^",47)
	s eobj.PATCFInvoiceRounding=$p($g(^CF("PATCF",1,13)),"^",7)
	s eobj.PATCFRoundingAmount=$p($g(^CF("PATCF",1,12)),"^",66)
	s eobj.PATCFRoundingPaymentAdjustmentD=$p($g(^CF("PATCF",1,12)),"^",65)
	
	s eobj.PATCFTimeRoomChargeApply=$zt($p($g(^CF("PATCF",1,12)),"^",40),1)
	s eobj.PATCFDepositAllocAlert=$p($g(^CF("PATCF",1,13)),"^",20)
	s eobj.PATCFAddLinkedPlansOnAdm=$p($g(^CF("PATCF",1,11)),"^",67)
	s:eobj.PATCFAddLinkedPlansOnAdm="Y" eobj.PATCFAddLinkedPlansOnAdm="true"
	s eobj.PATCFAllowPartialPaymentSystemB=$p($g(^CF("PATCF",1,11)),"^",65)
	s:eobj.PATCFAllowPartialPaymentSystemB="Y" eobj.PATCFAllowPartialPaymentSystemB="true"
	s eobj.PATCFMotherBabyEpisAutoLink=$p($g(^CF("PATCF",1,12)),"^",60)
	s:eobj.PATCFMotherBabyEpisAutoLink="Y" eobj.PATCFMotherBabyEpisAutoLink="true"
	s eobj.OECFBillAdminDrugs=$p($g(^CF("OE",1)),"^",76)
	s:eobj.OECFBillAdminDrugs="Y" eobj.OECFBillAdminDrugs="true"
	s eobj.PATCFCancelPaymUponCancelBill=$p($g(^CF("PATCF",1,12)),"^",26)
	s:eobj.PATCFCancelPaymUponCancelBill="Y" eobj.PATCFCancelPaymUponCancelBill="true"
	s eobj.PATCFCopyPayorPlanFromPrevAdm=$p($g(^CF("PATCF",1,13)),"^",1)
	s:eobj.PATCFCopyPayorPlanFromPrevAdm="Y" eobj.PATCFCopyPayorPlanFromPrevAdm="true"
	s eobj.PATCFCopyPayorPlanDetFromPrevAd=$p($g(^CF("PATCF",1,13)),"^",2)
	s:eobj.PATCFCopyPayorPlanDetFromPrevAd="Y" eobj.PATCFCopyPayorPlanDetFromPrevAd="true"
	s eobj.PATCFShowZeroBillsUnpaid=$p($g(^CF("PATCF",1,12)),"^",3)
	s:eobj.PATCFShowZeroBillsUnpaid="Y" eobj.PATCFShowZeroBillsUnpaid="true"
	s eobj.PATCFLinkEDOUTEpisToIP=$p($g(^CF("PATCF",1,12)),"^",63)
	s:eobj.PATCFLinkEDOUTEpisToIP="Y" eobj.PATCFLinkEDOUTEpisToIP="true"
	s eobj.PATCFLastCPPaidForED=$p($g(^CF("PATCF",1,12)),"^",7)
	s:eobj.PATCFLastCPPaidForED="Y" eobj.PATCFLastCPPaidForED="true"
	s eobj.PATCFShowNegativeInvUnpaid=$p($g(^CF("PATCF",1,12)),"^",4)
	s:eobj.PATCFShowNegativeInvUnpaid="Y" eobj.PATCFShowNegativeInvUnpaid="true"
	s eobj.PATCFStoreAppPayPlanOverAdm=$p($g(^CF("PATCF",1,12)),"^",54)
	s:eobj.PATCFStoreAppPayPlanOverAdm="Y" eobj.PATCFStoreAppPayPlanOverAdm="true"
	s eobj.PATCFTenderPayment=$p($g(^CF("PATCF",1,12)),"^",61)
	s:eobj.PATCFTenderPayment="Y" eobj.PATCFTenderPayment="true"
	s eobj.PATCFUseCRAFTFunctionality=$p($g(^CF("PATCF",1,11)),"^",29)
	s:eobj.PATCFUseCRAFTFunctionality="Y" eobj.PATCFUseCRAFTFunctionality="true"
	s eobj.PATCFUseWIESVICDRGFunction=$p($g(^CF("PATCF",1,11)),"^",25)
	s:eobj.PATCFUseWIESVICDRGFunction="Y" eobj.PATCFUseWIESVICDRGFunction="true"
	
	//4booking
	s eobj.PATCFBedRequestHours=$p($g(^CF("PATCF",1,11)),"^",42)
	s eobj.RBCFConditionAutoEpAppt=$p($g(^CF("RB",1)),"^",51)
	s eobj.RBCFNoDayGenSchedule=$p($g(^CF("RB",1)),"^",3)
	s eobj.RBCFMultipleServicesSearch=$p($g(^CF("RB",1)),"^",17)
	s eobj.RBCFMaxWeeksIrregSchedule=$p($g(^CF("RB",1)),"^",40)
	s eobj.RBCFPercentIncrServDuration=$p($g(^CF("RB",1)),"^",41)
	s eobj.RBCFOverBookReasonDR=$p($g(^CF("RB",1)),"^",44)
	s eobj.RBCFMaxPeriodCheckEpisNum=$p($g(^CF("RB",1)),"^",42)
	s eobj.RBCFMaxPeriodCheckEpis1=$p($g(^CF("RB",1)),"^",43)
	
	// 5booking2
	s eobj.RBCFAllowOverBookWalkins=$p($g(^CF("RB",1)),"^",16)
	s:eobj.RBCFAllowOverBookWalkins="Y" eobj.RBCFAllowOverBookWalkins="true"
	s eobj.RBCFAllowOverBookingAvailSlots=$p($g(^CF("RB",1)),"^",24)
	s:eobj.RBCFAllowOverBookingAvailSlots="Y" eobj.RBCFAllowOverBookingAvailSlots="true"
	s eobj.RBCFAllowBookOverlapAppoint=$p($g(^CF("RB",1)),"^",23)
	s:eobj.RBCFAllowBookOverlapAppoint="Y" eobj.RBCFAllowBookOverlapAppoint="true"
	s eobj.RBCFAllowTransferEarlyAdmDate=$p($g(^CF("RB",1)),"^",50)
	s:eobj.RBCFAllowTransferEarlyAdmDate="Y" eobj.RBCFAllowTransferEarlyAdmDate="true"
	s eobj.RBCFCancelAdmOnCancelAppt=$p($g(^CF("RB",1)),"^",31)
	s:eobj.RBCFCancelAdmOnCancelAppt="Y" eobj.RBCFCancelAdmOnCancelAppt="true"
	s eobj.RBCFNoWarningOnApptCancel=$p($g(^CF("RB",1)),"^",59)
	s:eobj.RBCFNoWarningOnApptCancel="Y" eobj.RBCFNoWarningOnApptCancel="true"
	s eobj.RBCFDischEpCancelFutureAppts=$p($g(^CF("RB",1)),"^",52)
	s:eobj.RBCFDischEpCancelFutureAppts="Y" eobj.RBCFDischEpCancelFutureAppts="true"
	s eobj.RBCFAdmDateEarliestApptDate=$p($g(^CF("RB",1)),"^",32)
	s:eobj.RBCFAdmDateEarliestApptDate="Y" eobj.RBCFAdmDateEarliestApptDate="true"
	s eobj.PATCFMakeCurrOPAdmForOPDAttend=$p($g(^CF("PATCF",1,13)),"^",13)
	s:eobj.PATCFMakeCurrOPAdmForOPDAttend="Y" eobj.PATCFMakeCurrOPAdmForOPDAttend="true"
	s eobj.RBCFDefaultPatientDetPayorPlan=$p($g(^CF("RB",1)),"^",58)
	s:eobj.RBCFDefaultPatientDetPayorPlan="Y" eobj.RBCFDefaultPatientDetPayorPlan="true"
	s eobj.RBCFDefResourceLastAppt=$p($g(^CF("RB",1)),"^",46)
	s:eobj.RBCFDefResourceLastAppt="Y" eobj.RBCFDefResourceLastAppt="true"
	s eobj.RBCFDisableRTCreationAppt=$p($g(^CF("RB",1)),"^",34)
	s:eobj.RBCFDisableRTCreationAppt="Y" eobj.RBCFDisableRTCreationAppt="true"
	s eobj.RBCFDisplayOrderNotes=$p($g(^CF("RB",1)),"^",29)
	s:eobj.RBCFDisplayOrderNotes="Y" eobj.RBCFDisplayOrderNotes="true"
	s eobj.RBCFExtendReferralPeriod=$p($g(^CF("RB",1)),"^",39)
	s:eobj.RBCFExtendReferralPeriod="Y" eobj.RBCFExtendReferralPeriod="true"
	s eobj.RBCFGenerate1stWeekOfCycle=$p($g(^CF("RB",1)),"^",53)
	s:eobj.RBCFGenerate1stWeekOfCycle="Y" eobj.RBCFGenerate1stWeekOfCycle="true"
	s eobj.RBCFGroupNoEpisodeCreation=$p($g(^CF("RB",1)),"^",57)
	s:eobj.RBCFGroupNoEpisodeCreation="Y" eobj.RBCFGroupNoEpisodeCreation="true"
	s eobj.RBCFKeepLocAnResource=$p($g(^CF("RB",1)),"^",47)
	s:eobj.RBCFKeepLocAnResource="Y" eobj.RBCFKeepLocAnResource="true"
	s eobj.RBCFWebNotMoveOnHoldOnSchGen=$p($g(^CF("RB",1)),"^",56)
	s:eobj.RBCFWebNotMoveOnHoldOnSchGen="Y" eobj.RBCFWebNotMoveOnHoldOnSchGen="true"
	s eobj.RBCFRestrictServices=$p($g(^CF("RB",1)),"^",14)
	s:eobj.RBCFRestrictServices="Y" eobj.RBCFRestrictServices="true"
	s eobj.RBCFSetAdmDateTimeToAppt=$p($g(^CF("RB",1)),"^",33)
	s:eobj.RBCFSetAdmDateTimeToAppt="Y" eobj.RBCFSetAdmDateTimeToAppt="true"
	s eobj.RBCFShowBookedAppt=$p($g(^CF("RB",1)),"^",28)
	s:eobj.RBCFShowBookedAppt="Y" eobj.RBCFShowBookedAppt="true"
	s eobj.RBCFShowBookingNotesMessage=$p($g(^CF("RB",1)),"^",35)
	s:eobj.RBCFShowBookingNotesMessage="Y" eobj.RBCFShowBookingNotesMessage="true"
	s eobj.RBCFShowReferralAfterChangeStat=$p($g(^CF("RB",1)),"^",38)
	s:eobj.RBCFShowReferralAfterChangeStat="Y" eobj.RBCFShowReferralAfterChangeStat="true"
	s eobj.RBCFRestrictPayorPlan=$p($g(^CF("RB",1)),"^",26)
	s:eobj.RBCFRestrictPayorPlan="Y" eobj.RBCFRestrictPayorPlan="true"
	s eobj.RBCFUseUserDefPayor=$p($g(^CF("RB",1)),"^",22)
	s:eobj.RBCFUseUserDefPayor="Y" eobj.RBCFUseUserDefPayor="true"
	
	// 6 clinical,
	s eobj.PATCFMRCType2DR=$p($g(^CF("PATCF",1,9)),"^",12)
	s eobj.PATCFMRCType1DR=$p($g(^CF("PATCF",1,9)),"^",11)
	s eobj.PATCFDefNewBornDepDR=$p($g(^CF("PATCF",1,5)),"^",2)
	s eobj.PATCFNewBornEpisSubTypeDR=$p($g(^CF("PATCF",1,8)),"^",12)
	s eobj.PATCFFemaleSexDR=$p($g(^CF("PATCF",1,6)),"^",11)
	s eobj.PATCFAllergyDR=$p($g(^CF("PATCF",1,10)),"^",10)
	s eobj.OECFTextForDeletedTestItem=$p($g(^CF("OE",1)),"^",75)
	s eobj.PATCFActivateAdvancdEPRSecu=$p($g(^CF("PATCF",1,13)),"^",18)
	s:eobj.PATCFActivateAdvancdEPRSecu="Y" eobj.PATCFActivateAdvancdEPRSecu="true"
	s eobj.PATCFActivateAdvancdSOAPCon=$p($g(^CF("PATCF",1,13)),"^",19)
	s:eobj.PATCFActivateAdvancdSOAPCon="Y" eobj.PATCFActivateAdvancdSOAPCon="true"
	s eobj.PATCFAutomaticReadLinkedProvide=$p($g(^CF("PATCF",1,11)),"^",20)
	s:eobj.PATCFAutomaticReadLinkedProvide="Y" eobj.PATCFAutomaticReadLinkedProvide="true"
	s eobj.PATCFExtendDiagnosis=$p($g(^CF("PATCF",1,6)),"^",5)
	s:eobj.PATCFExtendDiagnosis="Y" eobj.PATCFExtendDiagnosis="true"
	s eobj.PATCFRestrictSingleDiagType=$p($g(^CF("PATCF",1,6)),"^",12)
	s:eobj.PATCFRestrictSingleDiagType="Y" eobj.PATCFRestrictSingleDiagType="true"
	s eobj.PATCFShowPreviousEMR=$p($g(^CF("PATCF",1,5)),"^",14)
	s:eobj.PATCFShowPreviousEMR="Y" eobj.PATCFShowPreviousEMR="true"
	s eobj.PATCFSortByQueue=$p($g(^CF("PATCF",1,9)),"^",10)
	s:eobj.PATCFSortByQueue="Y" eobj.PATCFSortByQueue="true"
	s eobj.PATCFGestationMaxWeeks=$p($g(^CF("PATCF",1,12)),"^",13)
	s eobj.PATCFGestationMinWeeks=$p($g(^CF("PATCF",1,12)),"^",12)
	s eobj.PATCFGestationMaxDays=$p($g(^CF("PATCF",1,12)),"^",9)
	s eobj.PATCFGestationMinDays=$p($g(^CF("PATCF",1,12)),"^",8)
	s eobj.PATCFBirthWeightMax=$p($g(^CF("PATCF",1,12)),"^",11)
	s eobj.PATCFBirthWeightMin=$p($g(^CF("PATCF",1,12)),"^",10)
	
	// 7department,
	s eobj.OECFExecuteConfirmation=$p($g(^CF("OE",1)),"^",25)
	s:eobj.OECFExecuteConfirmation="Y" eobj.OECFExecuteConfirmation="true"
	s eobj.OECFDisableExecuteNotArrAppt=$p($g(^CF("OE",1)),"^",44)
	s:eobj.OECFDisableExecuteNotArrAppt="Y" eobj.OECFDisableExecuteNotArrAppt="true"
	s eobj.OECFIgnorePayorPlanRest=$p($g(^CF("OE",1,4)),"^",45)
	s:eobj.OECFIgnorePayorPlanRest="Y" eobj.OECFIgnorePayorPlanRest="true"
	s eobj.RBCFOrderBySlotOrQueue=$p($g(^CF("RB",1)),"^",27)
	
	// 8discharge
	s eobj.PATCFEmergDischDetails=$p($g(^CF("PATCF",1,4)),"^",15)
	s eobj.PATCFUnavailBedStatus=$p($g(^CF("PATCF",1,8)),"^",6)
	
	s eobj.PATCFCutOffTimeDischarge=$zt($p($g(^CF("PATCF",1,7)),"^",7),1)
	s eobj.PATCFAllowEnterDiagnosisDischar=$p($g(^CF("PATCF",1,5)),"^",13)
	s:eobj.PATCFAllowEnterDiagnosisDischar="Y" eobj.PATCFAllowEnterDiagnosisDischar="true"
	s eobj.PATCFAllowInpatDischWOFin=$p($g(^CF("PATCF",1,1)),"^",15)
	s:eobj.PATCFAllowInpatDischWOFin="Y" eobj.PATCFAllowInpatDischWOFin="true"
	s eobj.PATCFDisconOrdersOnDischarge=$p($g(^CF("PATCF",1,8)),"^",15)
	s:eobj.PATCFDisconOrdersOnDischarge="Y" eobj.PATCFDisconOrdersOnDischarge="true"
	s eobj.PATCFCopyDiagToInPatAdm=$p($g(^CF("PATCF",1,12)),"^",32)
	s:eobj.PATCFCopyDiagToInPatAdm="Y" eobj.PATCFCopyDiagToInPatAdm="true"
	s eobj.PATCFNotPopDischDateTimeOnLeave=$p($g(^CF("PATCF",1,11)),"^",30)
	s:eobj.PATCFNotPopDischDateTimeOnLeave="Y" eobj.PATCFNotPopDischDateTimeOnLeave="true"
	s eobj.PATCFUseDischargeDateTimeAdm=$p($g(^CF("PATCF",1,11)),"^",38)
	s:eobj.PATCFUseDischargeDateTimeAdm="Y" eobj.PATCFUseDischargeDateTimeAdm="true"
	s eobj.PATCFUseMaxDaysOnLeaveDisch=$p($g(^CF("PATCF",1,11)),"^",50)
	s:eobj.PATCFUseMaxDaysOnLeaveDisch="Y" eobj.PATCFUseMaxDaysOnLeaveDisch="true"
	
	///9geographic
	s eobj.SMCFProvinceDR=$p($g(^CF("SM",1)),"^",33)
	s eobj.SMCFCityDR=$p($g(^CF("SM",1)),"^",32)
	s eobj.SMCFHCADR=$p($g(^CF("SM",1)),"^",31)
	s eobj.PATCFZipCodesSetup=$p($g(^CF("PATCF",1,5)),"^",15)
	s eobj.PATCFHospLinkedThrBedDepAlloc=$p($g(^CF("PATCF",1,11)),"^",66)
	s:eobj.PATCFHospLinkedThrBedDepAlloc="Y" eobj.PATCFHospLinkedThrBedDepAlloc="true"
	s eobj.PATCFDefaultZipDescIntoAddress=$p($g(^CF("PATCF",1,7)),"^",4)
	s:eobj.PATCFDefaultZipDescIntoAddress="Y" eobj.PATCFDefaultZipDescIntoAddress="true"
	
	//10HTML,1
	s eobj.SMCFExplorePath=$p($g(^CF("SM",1)),"^",51)
	
	//11labtrak
	s eobj.PATCFLabEpisodeNumberMethod=$p($g(^CF("PATCF",1,7)),"^",1)
	s eobj.SMCFLabtrakUserID=$p($g(^CF("SM",1)),"^",41)
	s eobj.SMCFLabtrakUserPassword="****"
	////s eobj.SMCFLabtrakUserPassword=$p($g(^CF("SM",1)),"^",42)
	s eobj.PATCFDailyCounterLength=$p($g(^CF("PATCF",1,7)),"^",3)
	s eobj.PATCFLabCounterTypeDR=$p($g(^CF("PATCF",1,7)),"^",2)
	s eobj.OECFSendWebNRtoLabTrak=$p($g(^CF("OE",1)),"^",89)
	s:eobj.OECFSendWebNRtoLabTrak="Y" eobj.OECFSendWebNRtoLabTrak="true"
	s eobj.SMCFLinkExtLab=$p($g(^CF("SM",1)),"^",52)
	s:eobj.SMCFLinkExtLab="Y" eobj.SMCFLinkExtLab="true"
	s eobj.OECFExecuteLabOrder=$p($g(^CF("OE",1)),"^",31)
	s:eobj.OECFExecuteLabOrder="Y" eobj.OECFExecuteLabOrder="true"
	s eobj.OECFSendHospitalCodeToLab=$p($g(^CF("PATCF",1,4)),"^",19)
	s:eobj.OECFSendHospitalCodeToLab="Y" eobj.OECFSendHospitalCodeToLab="true"
	s eobj.OECFSendOrderingDoctorToLab=$p($g(^CF("OE",1)),"^",30)
	s:eobj.OECFSendOrderingDoctorToLab="Y" eobj.OECFSendOrderingDoctorToLab="true"
	s eobj.OECFSendRecLocToLab=$p($g(^CF("OE",1)),"^",81)
	s:eobj.OECFSendRecLocToLab="Y" eobj.OECFSendRecLocToLab="true"
	s eobj.PATCFUseAntibioticSeqInLab=$p($g(^CF("PATCF",1,12)),"^",30)
	s:eobj.PATCFUseAntibioticSeqInLab="Y" eobj.PATCFUseAntibioticSeqInLab="true"
	s eobj.SMCFNewLabTrak=$p($g(^CF("SM",1)),"^",30)
	s:eobj.SMCFNewLabTrak="Y" eobj.SMCFNewLabTrak="true"
	
	/// 12maternity,6
	s eobj.PATCFAutoCreatePregnanForBookMA=$p($g(^CF("PATCF",1,12)),"^",69)
	s:eobj.PATCFAutoCreatePregnanForBookMA="Y" eobj.PATCFAutoCreatePregnanForBookMA="true"
	s eobj.PATCFPlacentaDetailsRequired=$p($g(^CF("PATCF",1,13)),"^",10)
	s:eobj.PATCFPlacentaDetailsRequired="Y" eobj.PATCFPlacentaDetailsRequired="true"
	s eobj.PATCFDaysToClosePregnEvent=$p($g(^CF("PATCF",1,13)),"^",14)
	s eobj.PATCFBookingTypeForMaternityEqu=$p($g(^CF("PATCF",1,12)),"^",70)
	s eobj.PATCFBreastfeedAlertCategoryDR=$p($g(^CF("PATCF",1,12)),"^",72)
	s eobj.PATCFPregnancyAlertCategoryDR=$p($g(^CF("PATCF",1,12)),"^",71)
	
	/// 13operating,15
	s eobj.PATCFCanclAdmOnCanclOTAppt=$p($g(^CF("PATCF",1,12)),"^",36)
	s:eobj.PATCFCanclAdmOnCanclOTAppt="Y" eobj.PATCFCanclAdmOnCanclOTAppt="true"
	s eobj.PATCFDisplayTheatreTimeExcWarn=$p($g(^CF("PATCF",1,12)),"^",16)
	s:eobj.PATCFDisplayTheatreTimeExcWarn="Y" eobj.PATCFDisplayTheatreTimeExcWarn="true"
	s eobj.PATCFNAllORBookNA=$p($g(^CF("PATCF",1,7)),"^",18)
	s:eobj.PATCFNAllORBookNA="Y" eobj.PATCFNAllORBookNA="true"
	s eobj.PATCFNAllORBookNoSess=$p($g(^CF("PATCF",1,7)),"^",17)
	s:eobj.PATCFNAllORBookNoSess="Y" eobj.PATCFNAllORBookNoSess="true"
	s eobj.PATCFNAllORBookPast=$p($g(^CF("PATCF",1,7)),"^",16)
	s:eobj.PATCFNAllORBookPast="Y" eobj.PATCFNAllORBookPast="true"
	s eobj.RBCFGenerateAdmOnOTRequest=$p($g(^CF("RB",1)),"^",55)
	s:eobj.RBCFGenerateAdmOnOTRequest="Y" eobj.RBCFGenerateAdmOnOTRequest="true"
	s eobj.PATCFLinkOTBookToExistPreAdm=$p($g(^CF("PATCF",1,12)),"^",53)
	s:eobj.PATCFLinkOTBookToExistPreAdm="Y" eobj.PATCFLinkOTBookToExistPreAdm="true"
	s eobj.PATCFWarnORBookingMoveRes=$p($g(^CF("PATCF",1,7)),"^",15)
	s:eobj.PATCFWarnORBookingMoveRes="Y" eobj.PATCFWarnORBookingMoveRes="true"
	s eobj.PATCFMaxOperatingTimeMins=$p($g(^CF("PATCF",1,12)),"^",48)
	s eobj.PATCFExtrInterFixDevice=$p($g(^CF("PATCF",1,12)),"^",57)
	s eobj.PATCFNonProperIncisionPerc=$p($g(^CF("PATCF",1,12)),"^",56)
	s eobj.PATCFProperIncisionPerc=$p($g(^CF("PATCF",1,12)),"^",55)
	s eobj.PATCFOTDelayMargin=$p($g(^CF("PATCF",1,12)),"^",37)
	s eobj.PATCFOTStartMargin=$p($g(^CF("PATCF",1,12)),"^",38)
	s eobj.PATCFAutoCreateOTBookEpConditio=$p($g(^CF("PATCF",1,12)),"^",52)
	/// 14orders
	s eobj.OECFPriorityDR=$p($g(^CF("OE",1)),"^",9)
	s eobj.OECFDefaultOrderGroup=$p($g(^CF("OE",1)),"^",18)
	s eobj.OECFDiagWarning=$p($g(^CF("OE",1)),"^",21)
	s eobj.OECFCheckPrice=$p($g(^CF("OE",1)),"^",20)
	s eobj.OECFPatLeaveOrderAdmStatusDR=$p($g(^CF("OE",1)),"^",86)
	s eobj.OECFOrdersToRecLoc=$p($g(^CF("OE",1)),"^",17)
	s eobj.OECFShowInstructionAs=$p($g(^CF("OE",1)),"^",33)
	s eobj.OECFUseRepeatsOrEndDate=$p($g(^CF("OE",1)),"^",50)
	s eobj.OECFCMVTestDR=$p($g(^CF("OE",1)),"^",63)
	s eobj.OECFNumberOfOrdersAllowedSameGr=$p($g(^CF("OE",1)),"^",36)
	s eobj.OECFAgeFrom=$p($g(^CF("OE",1)),"^",60)
	s eobj.OECFAgeTo=$p($g(^CF("OE",1)),"^",61)
	
	/// 15orders2
	s eobj.OECFAllowConcurrentOrders=$p($g(^CF("OE",1)),"^",83)
	s:eobj.OECFAllowConcurrentOrders="Y" eobj.OECFAllowConcurrentOrders="true"
	s eobj.OECFAllowActiveOrdersAdmDates=$p($g(^CF("OE",1)),"^",82)
	s:eobj.OECFAllowActiveOrdersAdmDates="Y" eobj.OECFAllowActiveOrdersAdmDates="true"
	s eobj.OECFDiscontExecutedOrder=$p($g(^CF("OE",1)),"^",29)
	s:eobj.OECFDiscontExecutedOrder="Y" eobj.OECFDiscontExecutedOrder="true"
	s eobj.OECFAllowPlaceOrderOutsideEpisD=$p($g(^CF("OE",1)),"^",71)
	s:eobj.OECFAllowPlaceOrderOutsideEpisD="Y" eobj.OECFAllowPlaceOrderOutsideEpisD="true"
	s eobj.OECFDefaultOSItemBillingPriceBl=$p($g(^CF("OE",1)),"^",85)
	s:eobj.OECFDefaultOSItemBillingPriceBl="Y" eobj.OECFDefaultOSItemBillingPriceBl="true"
	s eobj.OECFChangeLinkedOnUpdate=$p($g(^CF("OE",1)),"^",14)
	s:eobj.OECFChangeLinkedOnUpdate="Y" eobj.OECFChangeLinkedOnUpdate="true"
	s eobj.OECFCheckOrdersCovered=$p($g(^CF("OE",1)),"^",32)
	s:eobj.OECFCheckOrdersCovered="Y" eobj.OECFCheckOrdersCovered="true"
	s eobj.OECFClearOrdersOnUpdate=$p($g(^CF("OE",1)),"^",28)
	s:eobj.OECFClearOrdersOnUpdate="Y" eobj.OECFClearOrdersOnUpdate="true"
	s eobj.OECFCreate1OrderPerToothFace=$p($g(^CF("OE",1)),"^",73)
	s:eobj.OECFCreate1OrderPerToothFace="Y" eobj.OECFCreate1OrderPerToothFace="true"
	s eobj.OECFCreate1OrderPerSpecimen=$p($g(^CF("OE",1)),"^",62)
	s:eobj.OECFCreate1OrderPerSpecimen="Y" eobj.OECFCreate1OrderPerSpecimen="true"
	s eobj.OECFCreateReturnQueueDisch=$p($g(^CF("OE",1)),"^",69)
	s:eobj.OECFCreateReturnQueueDisch="Y" eobj.OECFCreateReturnQueueDisch="true"
	s eobj.OECFDefaultCheckBsUnselect=$p($g(^CF("OE",1)),"^",68)
	s:eobj.OECFDefaultCheckBsUnselect="Y" eobj.OECFDefaultCheckBsUnselect="true"
	s eobj.OECFDisableAddForQtyBlank=$p($g(^CF("OE",1)),"^",80)
	s:eobj.OECFDisableAddForQtyBlank="Y" eobj.OECFDisableAddForQtyBlank="true"
	s eobj.OECFDiscontinueOverlapExTime=$p($g(^CF("OE",1)),"^",42)
	s:eobj.OECFDiscontinueOverlapExTime="Y" eobj.OECFDiscontinueOverlapExTime="true"
	s eobj.OECFDisplayDuplDosageTextBox=$p($g(^CF("OE",1)),"^",67)
	s:eobj.OECFDisplayDuplDosageTextBox="Y" eobj.OECFDisplayDuplDosageTextBox="true"
	s eobj.OECFNoDefaultPatLocOnOE=$p($g(^CF("OE",1)),"^",64)
	s:eobj.OECFNoDefaultPatLocOnOE="Y" eobj.OECFNoDefaultPatLocOnOE="true"
	s eobj.OECFNoShowLabEpForAllOrdersIPES=$p($g(^CF("OE",1)),"^",84)
	s:eobj.OECFNoShowLabEpForAllOrdersIPES="Y" eobj.OECFNoShowLabEpForAllOrdersIPES="true"
	s eobj.OECFNoShowReorderNurseWB=$p($g(^CF("OE",1)),"^",65)
	s:eobj.OECFNoShowReorderNurseWB="Y" eobj.OECFNoShowReorderNurseWB="true"
	
	s eobj.OECFAllowPackUOM=$p($g(^CF("OE",1)),"^",51)
	s:eobj.OECFAllowPackUOM="Y" eobj.OECFAllowPackUOM="true"
	s eobj.OECFEditNotes=$p($g(^CF("OE",1)),"^",49)
	s:eobj.OECFEditNotes="Y" eobj.OECFEditNotes="true"
	s eobj.OECFExecuteFutureOrders=$p($g(^CF("OE",1)),"^",52)
	s:eobj.OECFExecuteFutureOrders="Y" eobj.OECFExecuteFutureOrders="true"
	s eobj.OECFGenerateExecSchedOutpat=$p($g(^CF("OE",1)),"^",40)
	s:eobj.OECFGenerateExecSchedOutpat="Y" eobj.OECFGenerateExecSchedOutpat="true"
	s eobj.OECFIgnorePriorityDEf=$p($g(^CF("OE",1)),"^",53)
	s:eobj.OECFIgnorePriorityDEf="Y" eobj.OECFIgnorePriorityDEf="true"
	s eobj.OECFKeepPriorDateSession=$p($g(^CF("OE",1)),"^",54)
	s:eobj.OECFKeepPriorDateSession="Y" eobj.OECFKeepPriorDateSession="true"
	s eobj.OECFManualVerifLabOrders=$p($g(^CF("OE",1)),"^",72)
	s:eobj.OECFManualVerifLabOrders="Y" eobj.OECFManualVerifLabOrders="true"
	s eobj.OECFShowSnomedCodes=$p($g(^CF("OE",1)),"^",37)
	s:eobj.OECFShowSnomedCodes="Y" eobj.OECFShowSnomedCodes="true"
	s eobj.OECFWarnQtyRangeDuration=$p($g(^CF("OE",1)),"^",43)
	s:eobj.OECFWarnQtyRangeDuration="Y" eobj.OECFWarnQtyRangeDuration="true"
	s eobj.OECFSaveOrderCategory=$p($g(^CF("OE",1)),"^",13)
	s:eobj.OECFSaveOrderCategory="Y" eobj.OECFSaveOrderCategory="true"
	s eobj.OECFShowDisOrdersResults=$p($g(^CF("OE",1)),"^",47)
	s:eobj.OECFShowDisOrdersResults="Y" eobj.OECFShowDisOrdersResults="true"
	s eobj.OECFShowAllergyDSSQA=$p($g(^CF("OE",1)),"^",56)
	s:eobj.OECFShowAllergyDSSQA="Y" eobj.OECFShowAllergyDSSQA="true"
	s eobj.OECFShowDeliveryInfoOnPin=$p($g(^CF("OE",1)),"^",39)
	s:eobj.OECFShowDeliveryInfoOnPin="Y" eobj.OECFShowDeliveryInfoOnPin="true"
	s eobj.OECFUsePreprintedLabelsLab=$p($g(^CF("OE",1)),"^",34)
	s:eobj.OECFUsePreprintedLabelsLab="Y" eobj.OECFUsePreprintedLabelsLab="true"
	
	////16paper
	s eobj.RTCFRequestReasonAdmDR=$p($g(^CF("RT",2)),"^",29)
	s eobj.RTCFDefaultReasEDRequest=$p($g(^CF("RT",2)),"^",31)
	s eobj.RTCFRequestReasonAPPTDR=$p($g(^CF("RT",2)),"^",17)
	s eobj.RTCFDefaultReasonWLRequest=$p($g(^CF("RT",2)),"^",27)
	s eobj.RTCFMainMRTypeDR=$p($g(^CF("RT",2)),"^",20)
	s eobj.RTCFMainMRVolumeDR=$p($g(^CF("RT",2)),"^",21)
	s eobj.RTCFDaysToGetMR=$p($g(^CF("RT",2)),"^",22)
	
	//17paper2
	s eobj.RTCFAskReqDetails=$p($g(^CF("RT",2)),"^",28)
	s:eobj.RTCFAskReqDetails="Y" eobj.RTCFAskReqDetails="true"
	s eobj.RTCFBypassDepartMR=$p($g(^CF("RT",2)),"^",23)
	s:eobj.RTCFBypassDepartMR="Y" eobj.RTCFBypassDepartMR="true"
	s eobj.RTCFApptHoldCancelsMRReq=$p($g(^CF("RT",2)),"^",33)
	s:eobj.RTCFApptHoldCancelsMRReq="Y" eobj.RTCFApptHoldCancelsMRReq="true"
	s eobj.RTCFDisableVBAutoRequest=$p($g(^CF("RT",2)),"^",41)
	s:eobj.RTCFDisableVBAutoRequest="Y" eobj.RTCFDisableVBAutoRequest="true"
	s eobj.RTCFMarkMRNInactivePatMerge=$p($g(^CF("RT",2)),"^",38)
	s:eobj.RTCFMarkMRNInactivePatMerge="Y" eobj.RTCFMarkMRNInactivePatMerge="true"
	s eobj.RTCFNoShowUVMsgOnMoveMRToHomeLo=$p($g(^CF("RT",2)),"^",39)
	s:eobj.RTCFNoShowUVMsgOnMoveMRToHomeLo="Y" eobj.RTCFNoShowUVMsgOnMoveMRToHomeLo="true"
	s eobj.RTCFInactivateRTVolumeMerg=$p($g(^CF("RT",2)),"^",32)
	s:eobj.RTCFInactivateRTVolumeMerg="Y" eobj.RTCFInactivateRTVolumeMerg="true"
	s eobj.RTCFAutoMRRequestToNewVolume=$p($g(^CF("RT",2)),"^",40)
	s:eobj.RTCFAutoMRRequestToNewVolume="Y" eobj.RTCFAutoMRRequestToNewVolume="true"
	s eobj.RTCFReturnMRTHomeFirst=$p($g(^CF("RT",2)),"^",42)
	s:eobj.RTCFReturnMRTHomeFirst="Y" eobj.RTCFReturnMRTHomeFirst="true"
	s eobj.RTCFOnlyInactMRNLogHospMerg=$p($g(^CF("RT",2)),"^",37)
	s:eobj.RTCFOnlyInactMRNLogHospMerg="Y" eobj.RTCFOnlyInactMRNLogHospMerg="true"
	s eobj.RTCFShowMessageForResearchReq=$p($g(^CF("RT",2)),"^",30)
	s:eobj.RTCFShowMessageForResearchReq="Y" eobj.RTCFShowMessageForResearchReq="true"
	s eobj.RTCFViewAllVolumes=$p($g(^CF("RT",2)),"^",36)
	s:eobj.RTCFViewAllVolumes="Y" eobj.RTCFViewAllVolumes="true"
	s eobj.RTCFViewRequestDefaultLoc=$p($g(^CF("RT",2)),"^",34)
	s:eobj.RTCFViewRequestDefaultLoc="Y" eobj.RTCFViewRequestDefaultLoc="true"
	
	/// 18patient
	s eobj.PATCFWLStatOnAdmDR=$p($g(^CF("PATCF",1,10)),"^",16)
	s eobj.PATCFCancelWListStatusDR=$p($g(^CF("PATCF",1,9)),"^",14)
	s eobj.PATCFContactTypeDR=$p($g(^CF("PATCF",1,10)),"^",9)
	s eobj.PATCFDaySurgeryTypeDR=$p($g(^CF("PATCF",1,2)),"^",44)
	s eobj.PATCFDeceasedWaitListDR=$p($g(^CF("PATCF",1,8)),"^",8)
	s eobj.PATCFBedTypeDR=$p($g(^CF("PATCF",1,9)),"^",7)
	s eobj.PATCFLanguageDR=$p($g(^CF("PATCF",1,7)),"^",22)
	s eobj.PATCFExemptionCounterTypeDR=$p($g(^CF("PATCF",1,6)),"^",14)
	s eobj.PATCFGenerateAdmNo=$p($g(^CF("PATCF",1,7)),"^",20)
	s eobj.PATCFGenerateRego=$p($g(^CF("PATCF",1,5)),"^",7)
	s eobj.PATCFHICClaimCounterDR=$p($g(^CF("PATCF",1,7)),"^",12)
	s eobj.PATCFNextOfKin=$p($g(^CF("PATCF",1,1)),"^",6)
	s eobj.PATCFUpperLimitDisplayDays=$p($g(^CF("PATCF",1,11)),"^",39)
	s eobj.PATCFUpperLimitDisplayWeeks=$p($g(^CF("PATCF",1,11)),"^",40)
	s eobj.PATCFUpperLimitDisplayMonths=$p($g(^CF("PATCF",1,11)),"^",41)
	s eobj.PATCFSearchOnDays=$p($g(^CF("PATCF",1,12)),"^",5)
	s eobj.PATCFSearchOnMonth=$p($g(^CF("PATCF",1,11)),"^",53)
	s eobj.PATCFDefaultTabInRegistration=$p($g(^CF("PATCF",1,6)),"^",1)
	s eobj.PATCFNoRowsDiagProc=$p($g(^CF("PATCF",1,11)),"^",54)
	s eobj.PATCFFemalePensionAge=$p($g(^CF("PATCF",1,10)),"^",12)
	s eobj.PATCFLimitNoDaysForSearch=$p($g(^CF("PATCF",1,11)),"^",57)
	s eobj.PATCFMalePensionAge=$p($g(^CF("PATCF",1,10)),"^",11)
	s eobj.PATCFMaxDaysOnLeave=$p($g(^CF("PATCF",1,10)),"^",14)
	s eobj.PATCFFieldLength=$p($g(^CF("PATCF",1,6)),"^",10)
	s eobj.PATCFNoFieldsPatName=$p($g(^CF("PATCF",1,5)),"^",3)
	s eobj.PATCFNoDaysForAdmSearchToCopyFr=$p($g(^CF("PATCF",1,11)),"^",55)
	s eobj.PATCFDaysToIncludeDischPat=$p($g(^CF("PATCF",1,11)),"^",49)
	s eobj.PATCFNoOfYearsAgeSearch=$p($g(^CF("PATCF",1,10)),"^",8)
	s eobj.PATCFShowMonthsWhenInactive=$p($g(^CF("PATCF",1,11)),"^",21)
	
	/// 19patient2	
	s eobj.PATCFEmergencyPatBedOption=$p($g(^CF("PATCF",1,6)),"^",2)
	s:eobj.PATCFEmergencyPatBedOption="Y" eobj.PATCFEmergencyPatBedOption="true"
	s eobj.PATCFAllowSelfAdmission=$p($g(^CF("PATCF",1,5)),"^",4)
	s:eobj.PATCFAllowSelfAdmission="Y" eobj.PATCFAllowSelfAdmission="true"
	s eobj.PATCFUsePayorFromPrevEpisode=$p($g(^CF("PATCF",1,8)),"^",14)
	s:eobj.PATCFUsePayorFromPrevEpisode="Y" eobj.PATCFUsePayorFromPrevEpisode="true"
	s eobj.PATCFArrivePatientOnReg=$p($g(^CF("PATCF",1,7)),"^",23)
	s:eobj.PATCFArrivePatientOnReg="Y" eobj.PATCFArrivePatientOnReg="true"
	s eobj.PATCFAssignDepartmentToBed=$p($g(^CF("PATCF",1,5)),"^",12)
	s:eobj.PATCFAssignDepartmentToBed="Y" eobj.PATCFAssignDepartmentToBed="true"
	s eobj.PATCFShowreasonChangePatData=$p($g(^CF("PATCF",1,6)),"^",13)
	s:eobj.PATCFShowreasonChangePatData="Y" eobj.PATCFShowreasonChangePatData="true"
	s eobj.PATCFUseDRGGrouper=$p($g(^CF("PATCF",1,6)),"^",3)
	s:eobj.PATCFUseDRGGrouper="Y" eobj.PATCFUseDRGGrouper="true"
	s eobj.PATCFChooseReferalDoctorFromLis=$p($g(^CF("PATCF",1,4)),"^",17)
	s:eobj.PATCFChooseReferalDoctorFromLis="Y" eobj.PATCFChooseReferalDoctorFromLis="true"
	s eobj.PATCFCollectRegistrFee=$p($g(^CF("PATCF",1,4)),"^",16)
	s:eobj.PATCFCollectRegistrFee="Y" eobj.PATCFCollectRegistrFee="true"
	s eobj.PATCFProcess=$p($g(^CF("PATCF",1,5)),"^",6)
	s:eobj.PATCFProcess="Y" eobj.PATCFProcess="true"
	s eobj.PATCFDefAdmDepartBDMAN=$p($g(^CF("PATCF",1,9)),"^",6)
	s:eobj.PATCFDefAdmDepartBDMAN="Y" eobj.PATCFDefAdmDepartBDMAN="true"
	s eobj.PATCFDef2ndTabEpisDetails=$p($g(^CF("PATCF",1,9)),"^",8)
	s:eobj.PATCFDef2ndTabEpisDetails="Y" eobj.PATCFDef2ndTabEpisDetails="true"
	s eobj.PATCFDisableInsuranceOfficeComb=$p($g(^CF("PATCF",1,6)),"^",8)
	s:eobj.PATCFDisableInsuranceOfficeComb="Y" eobj.PATCFDisableInsuranceOfficeComb="true"
	s eobj.PATCFDisplayRegDetAfterBedAssig=$p($g(^CF("PATCF",1,6)),"^",15)
	s:eobj.PATCFDisplayRegDetAfterBedAssig="Y" eobj.PATCFDisplayRegDetAfterBedAssig="true"
	s eobj.PATCFShowPreadmAfterAppoint=$p($g(^CF("PATCF",1,7)),"^",11)
	s:eobj.PATCFShowPreadmAfterAppoint="Y" eobj.PATCFShowPreadmAfterAppoint="true"
	s eobj.PATCFIsRefDoctorMandatory=$p($g(^CF("PATCF",1,4)),"^",21)
	s:eobj.PATCFIsRefDoctorMandatory="Y" eobj.PATCFIsRefDoctorMandatory="true"
	s eobj.PATCFDisplayZipDescription=$p($g(^CF("PATCF",1,2)),"^",68)
	s:eobj.PATCFDisplayZipDescription="Y" eobj.PATCFDisplayZipDescription="true"
	s eobj.PATCFRefreshPATMANOE=$p($g(^CF("PATCF",1,8)),"^",15)
	s:eobj.PATCFRefreshPATMANOE="Y" eobj.PATCFRefreshPATMANOE="true"
	s eobj.PATCFSaveOutPatEpUponInConv=$p($g(^CF("PATCF",1,11)),"^",56)
	s:eobj.PATCFSaveOutPatEpUponInConv="Y" eobj.PATCFSaveOutPatEpUponInConv="true"
	s eobj.PATCFSaveRegNumExtDB=$p($g(^CF("PATCF",1,9)),"^",9)
	s:eobj.PATCFSaveRegNumExtDB="Y" eobj.PATCFSaveRegNumExtDB="true"
	s eobj.PATCFSearchByKeywords=$p($g(^CF("PATCF",1,7)),"^",5)
	s:eobj.PATCFSearchByKeywords="Y" eobj.PATCFSearchByKeywords="true"
	s eobj.PATCFSearchOnExactMRN=$p($g(^CF("PATCF",1,11)),"^",24)
	s:eobj.PATCFSearchOnExactMRN="Y" eobj.PATCFSearchOnExactMRN="true"
	s eobj.PATCFShowOEMessageOnAdmUpdate=$p($g(^CF("PATCF",1,5)),"^",1)
	s:eobj.PATCFShowOEMessageOnAdmUpdate="Y" eobj.PATCFShowOEMessageOnAdmUpdate="true"
	s eobj.PATCFTransferReasonMandatory=$p($g(^CF("PATCF",1,8)),"^",9)
	s:eobj.PATCFTransferReasonMandatory="Y" eobj.PATCFTransferReasonMandatory="true"
	s eobj.PATCFUseBedManagementScreen=$p($g(^CF("PATCF",1,6)),"^",17)
	s:eobj.PATCFUseBedManagementScreen="Y" eobj.PATCFUseBedManagementScreen="true"
	s eobj.PATCFUseUserDefPayor=$p($g(^CF("PATCF",1,7)),"^",21)
	s:eobj.PATCFUseUserDefPayor="Y" eobj.PATCFUseUserDefPayor="true"
	
	
	/// 20patientwl
	s eobj.PATCFAllowWLChangesAfterAdm=$p($g(^CF("PATCF",1,11)),"^",34)
	s:eobj.PATCFAllowWLChangesAfterAdm="Y" eobj.PATCFAllowWLChangesAfterAdm="true"
	s eobj.PATCFAllowEditCPforLinkedWLAdm=$p($g(^CF("PATCF",1,11)),"^",69)
	s:eobj.PATCFAllowEditCPforLinkedWLAdm="Y" eobj.PATCFAllowEditCPforLinkedWLAdm="true"
	s eobj.PATCFAllowChangePreadmDateWL=$p($g(^CF("PATCF",1,12)),"^",1)
	s:eobj.PATCFAllowChangePreadmDateWL="Y" eobj.PATCFAllowChangePreadmDateWL="true"
	s eobj.PATCFChangeWLStDoneArrAppt=$p($g(^CF("PATCF",1,12)),"^",6)
	s:eobj.PATCFChangeWLStDoneArrAppt="Y" eobj.PATCFChangeWLStDoneArrAppt="true"
	s eobj.PATCFChangeOPWLStDoneArrAppt=$p($g(^CF("PATCF",1,12)),"^",39)
	s:eobj.PATCFChangeOPWLStDoneArrAppt="Y" eobj.PATCFChangeOPWLStDoneArrAppt="true"
	s eobj.PATCFClearRefHospOnRemove=$p($g(^CF("PATCF",1,12)),"^",14)
	s:eobj.PATCFClearRefHospOnRemove="Y" eobj.PATCFClearRefHospOnRemove="true"
	s eobj.PATCFWLStatInitOnCancel=$p($g(^CF("PATCF",1,10)),"^",5)
	s:eobj.PATCFWLStatInitOnCancel="Y" eobj.PATCFWLStatInitOnCancel="true"
	s eobj.PATCFClearWLApptDateOutPCancel=$p($g(^CF("PATCF",1,11)),"^",37)
	s:eobj.PATCFClearWLApptDateOutPCancel="Y" eobj.PATCFClearWLApptDateOutPCancel="true"
	s eobj.PATCFPopulateAdmDocForNewWL=$p($g(^CF("PATCF",1,12)),"^",25)
	s:eobj.PATCFPopulateAdmDocForNewWL="Y" eobj.PATCFPopulateAdmDocForNewWL="true"
	s eobj.PATCFRestrictLocList=$p($g(^CF("PATCF",1,8)),"^",10)
	s:eobj.PATCFRestrictLocList="Y" eobj.PATCFRestrictLocList="true"
	s eobj.PATCFResetWLDaysPriorIncrease=$p($g(^CF("PATCF",1,11)),"^",62)
	s:eobj.PATCFResetWLDaysPriorIncrease="Y" eobj.PATCFResetWLDaysPriorIncrease="true"
	s eobj.PATCFWLSortByDays=$p($g(^CF("PATCF",1,8)),"^",13)
	s:eobj.PATCFWLSortByDays="Y" eobj.PATCFWLSortByDays="true"
	s eobj.PATCFDaysAllowChangeTCI=$p($g(^CF("PATCF",1,12)),"^",58)
	s eobj.PATCFOTBookCancelReasonDR=$p($g(^CF("PATCF",1,13)),"^",9)
	
	////21patientw
	s eobj.PATCFAnonymousName=$p($g(^CF("PATCF",1,12)),"^",47)
	s eobj.PATCFTriageWaitTime1st=$p($g(^CF("PATCF",1,12)),"^",44)
	s eobj.PATCFTriageWaitTime2nd=$p($g(^CF("PATCF",1,12)),"^",45)
	s eobj.PATCFAddressTypeDR=$p($g(^CF("PATCF",1,12)),"^",19)
	s eobj.PATCFGovExtract=$p($g(^CF("PATCF",1,12)),"^",42)
	s eobj.PATCFUnknownSexDR=$p($g(^CF("PATCF",1,12)),"^",22)
	s eobj.PATCFYearsSinceLastEpisode=$p($g(^CF("PATCF",1,12)),"^",67)
	
	////22patientw2
	s eobj.PATCFAllowCarePlanIntApptDCONOu=$p($g(^CF("PATCF",1,12)),"^",51)
	s:eobj.PATCFAllowCarePlanIntApptDCONOu="Y" eobj.PATCFAllowCarePlanIntApptDCONOu="true"
	s eobj.PATCFAllowMultipleActiveGP=$p($g(^CF("PATCF",1,11)),"^",51)
	s:eobj.PATCFAllowMultipleActiveGP="Y" eobj.PATCFAllowMultipleActiveGP="true"
	s eobj.PATCFAllowOverlapGP=$p($g(^CF("PATCF",1,11)),"^",33)
	s:eobj.PATCFAllowOverlapGP="Y" eobj.PATCFAllowOverlapGP="true"
	s eobj.PATCFAllowOverlapIPEpisodes=$p($g(^CF("PATCF",1,11)),"^",68)
	s:eobj.PATCFAllowOverlapIPEpisodes="Y" eobj.PATCFAllowOverlapIPEpisodes="true"
	s eobj.PATCFConfirmCreateAliasSexDOB=$p($g(^CF("PATCF",1,11)),"^",59)
	s:eobj.PATCFConfirmCreateAliasSexDOB="Y" eobj.PATCFConfirmCreateAliasSexDOB="true"
	s eobj.PATCFConfirmToSaveAsPreviousAdd=$p($g(^CF("PATCF",1,12)),"^",17)
	s:eobj.PATCFConfirmToSaveAsPreviousAdd="Y" eobj.PATCFConfirmToSaveAsPreviousAdd="true"
	s eobj.PATCFCopyAlrgAlrtToBothPatU=$p($g(^CF("PATCF",1,12)),"^",18)
	s:eobj.PATCFCopyAlrgAlrtToBothPatU="Y" eobj.PATCFCopyAlrgAlrtToBothPatU="true"
	s eobj.PATCFDefProcDateSameDay=$p($g(^CF("PATCF",1,12)),"^",15)
	s:eobj.PATCFDefProcDateSameDay="Y" eobj.PATCFDefProcDateSameDay="true"
	s eobj.PATCFShowPreAdmInfoOnEDBedReque=$p($g(^CF("PATCF",1,12)),"^",64)
	s:eobj.PATCFShowPreAdmInfoOnEDBedReque="Y" eobj.PATCFShowPreAdmInfoOnEDBedReque="true"
	s eobj.PATCFNoOrdersCopyFromOrigAdm=$p($g(^CF("PATCF",1,12)),"^",27)
	s:eobj.PATCFNoOrdersCopyFromOrigAdm="Y" eobj.PATCFNoOrdersCopyFromOrigAdm="true"
	
	s eobj.PATCFDontDischOutPatOnDecease=$p($g(^CF("PATCF",1,11)),"^",61)
	s:eobj.PATCFDontDischOutPatOnDecease="Y" eobj.PATCFDontDischOutPatOnDecease="true"
	s eobj.PATCFDontDisplayInactiveAlias=$p($g(^CF("PATCF",1,12)),"^",21)
	s:eobj.PATCFDontDisplayInactiveAlias="Y" eobj.PATCFDontDisplayInactiveAlias="true"
	s eobj.PATCFNoExecuteOrdUponDisc=$p($g(^CF("PATCF",1,11)),"^",71)
	s:eobj.PATCFNoExecuteOrdUponDisc="Y" eobj.PATCFNoExecuteOrdUponDisc="true"
	s eobj.PATCFNoGenPRNforEMergPats=$p($g(^CF("PATCF",1,11)),"^",27)
	s:eobj.PATCFNoGenPRNforEMergPats="Y" eobj.PATCFNoGenPRNforEMergPats="true"
	s eobj.PATCFNoTempLocUpdateOnPatArriva=$p($g(^CF("PATCF",1,13)),"^",15)
	s:eobj.PATCFNoTempLocUpdateOnPatArriva="Y" eobj.PATCFNoTempLocUpdateOnPatArriva="true"
	s eobj.PATCFErrorOnExtractCodingIncomp=$p($g(^CF("PATCF",1,11)),"^",63)
	s:eobj.PATCFErrorOnExtractCodingIncomp="Y" eobj.PATCFErrorOnExtractCodingIncomp="true"
	s eobj.PATCFExternalPatValid=$p($g(^CF("PATCF",1,12)),"^",49)
	s:eobj.PATCFExternalPatValid="Y" eobj.PATCFExternalPatValid="true"
	s eobj.PATCFInclRecsAfterExtrctEndDate=$p($g(^CF("PATCF",1,11)),"^",64)
	s:eobj.PATCFInclRecsAfterExtrctEndDate="Y" eobj.PATCFInclRecsAfterExtrctEndDate="true"
	s eobj.PATCFIPInclDischPat=$p($g(^CF("PATCF",1,11)),"^",52)
	s:eobj.PATCFIPInclDischPat="Y" eobj.PATCFIPInclDischPat="true"
	
	s eobj.PATCFConfirmCreateAliasName=$p($g(^CF("PATCF",1,12)),"^",62)
	s:eobj.PATCFConfirmCreateAliasName="Y" eobj.PATCFConfirmCreateAliasName="true"
	s eobj.PATCFRestCancerRegLogonHosp=$p($g(^CF("PATCF",1,12)),"^",29)
	s:eobj.PATCFRestCancerRegLogonHosp="Y" eobj.PATCFRestCancerRegLogonHosp="true"
	s eobj.PATCFRestrictAdmListForLogonHos=$p($g(^CF("PATCF",1,13)),"^",8)
	s:eobj.PATCFRestrictAdmListForLogonHos="Y" eobj.PATCFRestrictAdmListForLogonHos="true"
	s eobj.PATCFRestWardDeptBook=$p($g(^CF("PATCF",1,12)),"^",41)
	s:eobj.PATCFRestWardDeptBook="Y" eobj.PATCFRestWardDeptBook="true"
	s eobj.PATCFSameDayPreAdm=$p($g(^CF("PATCF",1,12)),"^",50)
	s:eobj.PATCFSameDayPreAdm="Y" eobj.PATCFSameDayPreAdm="true"
	s eobj.PATCFSearchStartswithRego=$p($g(^CF("PATCF",1,12)),"^",59)
	s:eobj.PATCFSearchStartswithRego="Y" eobj.PATCFSearchStartswithRego="true"
	s eobj.PATCFTBCAlrgAlertEpisMove=$p($g(^CF("PATCF",1,12)),"^",20)
	s:eobj.PATCFTBCAlrgAlertEpisMove="Y" eobj.PATCFTBCAlrgAlertEpisMove="true"
	s eobj.PATCFShowMRNumberFloorPlan=$p($g(^CF("PATCF",1,12)),"^",2)
	s:eobj.PATCFShowMRNumberFloorPlan="Y" eobj.PATCFShowMRNumberFloorPlan="true"
	s eobj.PATCFShowRegWaitTimeFloorPlan=$p($g(^CF("PATCF",1,11)),"^",70)
	s:eobj.PATCFShowRegWaitTimeFloorPlan="Y" eobj.PATCFShowRegWaitTimeFloorPlan="true"
	s eobj.PATCFSMRReporting=$p($g(^CF("PATCF",1,11)),"^",48)
	s:eobj.PATCFSMRReporting="Y" eobj.PATCFSMRReporting="true"
	s eobj.PATCFShowWarnProcDateOutEpis=$p($g(^CF("PATCF",1,12)),"^",24)
	s:eobj.PATCFShowWarnProcDateOutEpis="Y" eobj.PATCFShowWarnProcDateOutEpis="true"
	s eobj.PATCFSortBySurnameFirstOther=$p($g(^CF("PATCF",1,11)),"^",60)
	s:eobj.PATCFSortBySurnameFirstOther="Y" eobj.PATCFSortBySurnameFirstOther="true"
	s eobj.PATCFSuppressMRRego=$p($g(^CF("PATCF",1,11)),"^",19)
	s:eobj.PATCFSuppressMRRego="Y" eobj.PATCFSuppressMRRego="true"
	s eobj.PATCFUseBedReqDateTimeEm=$p($g(^CF("PATCF",1,11)),"^",32)
	s:eobj.PATCFUseBedReqDateTimeEm="Y" eobj.PATCFUseBedReqDateTimeEm="true"
	s eobj.PATCFEmergStandAlone=$p($g(^CF("PATCF",1,10)),"^",15)
	s:eobj.PATCFEmergStandAlone="Y" eobj.PATCFEmergStandAlone="true"
	s eobj.PATCFUseSoundexSearchAllNames=$p($g(^CF("PATCF",1,12)),"^",35)
	s:eobj.PATCFUseSoundexSearchAllNames="Y" eobj.PATCFUseSoundexSearchAllNames="true"
	
	//23petientwae
	s eobj.PATCFFreqAttendAge=$p($g(^CF("PATCF",1,13)),"^",3)
	s eobj.PATCFNumberOfVisits=$p($g(^CF("PATCF",1,13)),"^",4)
	s eobj.PATCFTimeFrame=$p($g(^CF("PATCF",1,13)),"^",5)
	s eobj.PATCFTimeFrameType=$p($g(^CF("PATCF",1,13)),"^",6)
	s eobj.PATCFNoSimultanCurrentIPEDAdms=$p($g(^CF("PATCF",1,13)),"^",12)
	s:eobj.PATCFNoSimultanCurrentIPEDAdms="Y" eobj.PATCFNoSimultanCurrentIPEDAdms="true"
	
	/// 24pharmacy
	s eobj.OECFPharmacyItemNoStock=$p($g(^CF("OE",1)),"^",27)
	s:eobj.OECFPharmacyItemNoStock="Y" eobj.OECFPharmacyItemNoStock="true"
	s eobj.OECFAcceptIP=$p($g(^CF("OE",1)),"^",22)
	s:eobj.OECFAcceptIP="Y" eobj.OECFAcceptIP="true"
	s eobj.OECFAcceptOP=$p($g(^CF("OE",1)),"^",23)
	s:eobj.OECFAcceptOP="Y" eobj.OECFAcceptOP="true"
	s eobj.OECFAutoPacking=$p($g(^CF("OE",1)),"^",24)
	s:eobj.OECFAutoPacking="Y" eobj.OECFAutoPacking="true"
	s eobj.OECFDisplayOIDescOnPharmWB=$p($g(^CF("OE",1)),"^",70)
	s:eobj.OECFDisplayOIDescOnPharmWB="Y" eobj.OECFDisplayOIDescOnPharmWB="true"
	s eobj.OECFDisplayRefundReason=$p($g(^CF("OE",1)),"^",55)
	s:eobj.OECFDisplayRefundReason="Y" eobj.OECFDisplayRefundReason="true"
	s eobj.OECFExecuteUponCollection=$p($g(^CF("OE",1)),"^",78)
	s:eobj.OECFExecuteUponCollection="Y" eobj.OECFExecuteUponCollection="true"
	s eobj.OECFExePhDischOrdersOnDisch=$p($g(^CF("OE",1)),"^",79)
	s:eobj.OECFExePhDischOrdersOnDisch="Y" eobj.OECFExePhDischOrdersOnDisch="true"
	s eobj.OECFGenericPrescribing=$p($g(^CF("OE",1)),"^",74)
	s:eobj.OECFGenericPrescribing="Y" eobj.OECFGenericPrescribing="true"
	s eobj.OECFPickBlankExpBatchLast=$p($g(^CF("OE",1)),"^",94)
	s:eobj.OECFPickBlankExpBatchLast="Y" eobj.OECFPickBlankExpBatchLast="true"
	s eobj.OECFATCInterface=$p($g(^CF("OE",1)),"^",16)
	s:eobj.OECFATCInterface="Y" eobj.OECFATCInterface="true"
	s eobj.OECFWarnOutstanAmtExist=$p($g(^CF("OE",1)),"^",93)
	s:eobj.OECFWarnOutstanAmtExist="Y" eobj.OECFWarnOutstanAmtExist="true"
	
	s eobj.OECFSignOffDisclaimerDays=$p($g(^CF("OE",1)),"^",96)
	s eobj.OECFDaysToRemainAtPacked=$p($g(^CF("OE",1)),"^",91)
	s eobj.OECFDaysToRemainAtUncollected=$p($g(^CF("OE",1)),"^",92)
	s eobj.OECFExternalMonographURL=$p($g(^CF("OE",1)),"^",95)
	s eobj.OECFPrescriptionGenerated=$p($g(^CF("OE",1)),"^",35)
	s eobj.OECFKinetics=$p($g(^CF("OE",1)),"^",87)
	s eobj.OECFTPN=$p($g(^CF("OE",1)),"^",88)
	
	/// 25scanning
	s eobj.RTCFScannedImageType=$p($g(^CF("RT",2)),"^",25)
	s eobj.RTCFResolution=$p($g(^CF("RT",2)),"^",24)
	
	/// 26stock
	s eobj.INCFDefRecTypeDR=$p($g(^CF("IN",1)),"^",5)
	s eobj.INCFDaysPastTransaction=$p($g(^CF("IN",1)),"^",28)
	s eobj.INCFUseExternalStockSytem=$p($g(^CF("IN",1)),"^",48)
	s eobj.INCFBatchReq=$p($g(^CF("IN",1)),"^",11)
	s eobj.INCFExpReq=$p($g(^CF("IN",1)),"^",12)
	s eobj.INCFWardStk=$p($g(^CF("IN",1)),"^",7)
	
	///27stock2
	s eobj.INCFAllowMixedTax=$p($g(^CF("IN",1)),"^",31)
	s:eobj.INCFAllowMixedTax="Y" eobj.INCFAllowMixedTax="true"
	s eobj.INCFNegStk=$p($g(^CF("IN",1)),"^",4)
	s:eobj.INCFNegStk="Y" eobj.INCFNegStk="true"
	s eobj.INCFRecvMoreRequest=$p($g(^CF("IN",1)),"^",21)
	s:eobj.INCFRecvMoreRequest="Y" eobj.INCFRecvMoreRequest="true"
	s eobj.INCFDefaultAvePriceOnStRec=$p($g(^CF("IN",1)),"^",40)
	s:eobj.INCFDefaultAvePriceOnStRec="Y" eobj.INCFDefaultAvePriceOnStRec="true"
	s eobj.INCFAlwaysDefaultToTransfer=$p($g(^CF("IN",1)),"^",27)
	s:eobj.INCFAlwaysDefaultToTransfer="Y" eobj.INCFAlwaysDefaultToTransfer="true"
	s eobj.INCFDocketDateMandStockRec=$p($g(^CF("IN",1)),"^",35)
	s:eobj.INCFDocketDateMandStockRec="Y" eobj.INCFDocketDateMandStockRec="true"
	s eobj.INCFDontUpdateStItemCode=$p($g(^CF("IN",1)),"^",42)
	s:eobj.INCFDontUpdateStItemCode="Y" eobj.INCFDontUpdateStItemCode="true"
	s eobj.INCFRestrictDrugMOrdersByLoc=$p($g(^CF("IN",1)),"^",43)
	s:eobj.INCFRestrictDrugMOrdersByLoc="Y" eobj.INCFRestrictDrugMOrdersByLoc="true"
	s eobj.INCFIgnoreOETax=$p($g(^CF("IN",1)),"^",30)
	s:eobj.INCFIgnoreOETax="Y" eobj.INCFIgnoreOETax="true"
	s eobj.INCFNoSearchByAnyPart=$p($g(^CF("IN",1)),"^",52)
	s:eobj.INCFNoSearchByAnyPart="Y" eobj.INCFNoSearchByAnyPart="true"
	s eobj.INCFPromptCommercialNameOnPO=$p($g(^CF("IN",1)),"^",38)
	s:eobj.INCFPromptCommercialNameOnPO="Y" eobj.INCFPromptCommercialNameOnPO="true"
	s eobj.INCFRecalculateReorderLevel=$p($g(^CF("IN",1)),"^",24)
	s:eobj.INCFRecalculateReorderLevel="Y" eobj.INCFRecalculateReorderLevel="true"
	s eobj.INCFRecalculateReplenishLevel=$p($g(^CF("IN",1)),"^",25)
	s:eobj.INCFRecalculateReplenishLevel="Y" eobj.INCFRecalculateReplenishLevel="true"
	s eobj.INCFRestrictPObyPOType=$p($g(^CF("IN",1)),"^",23)
	s:eobj.INCFRestrictPObyPOType="Y" eobj.INCFRestrictPObyPOType="true"
	s eobj.INCFRestrictTransferSTKGroup=$p($g(^CF("IN",1)),"^",22)
	s:eobj.INCFRestrictTransferSTKGroup="Y" eobj.INCFRestrictTransferSTKGroup="true"
	s eobj.INCFReturnNonPharmacyDiscon=$p($g(^CF("IN",1)),"^",32)
	s:eobj.INCFReturnNonPharmacyDiscon="Y" eobj.INCFReturnNonPharmacyDiscon="true"
	
	s eobj.INCFReturnPharmStockDiscon=$p($g(^CF("IN",1)),"^",33)
	s:eobj.INCFReturnPharmStockDiscon="Y" eobj.INCFReturnPharmStockDiscon="true"
	s eobj.INCFShowZeroBatchesSTK=$p($g(^CF("IN",1)),"^",37)
	s:eobj.INCFShowZeroBatchesSTK="Y" eobj.INCFShowZeroBatchesSTK="true"
	s eobj.INCFSkipNoStockItemsonAddAll=$p($g(^CF("IN",1)),"^",26)
	s:eobj.INCFSkipNoStockItemsonAddAll="Y" eobj.INCFSkipNoStockItemsonAddAll="true"
	s eobj.INCFStReqDoNotAllowMultItems=$p($g(^CF("IN",1)),"^",46)
	s:eobj.INCFStReqDoNotAllowMultItems="Y" eobj.INCFStReqDoNotAllowMultItems="true"
	s eobj.INCFStTakeGDFNewWay=$p($g(^CF("IN",1)),"^",50)
	s:eobj.INCFStTakeGDFNewWay="Y" eobj.INCFStTakeGDFNewWay="true"
	s eobj.INCFStTakeNoCountQtyDefault=$p($g(^CF("IN",1)),"^",49)
	s:eobj.INCFStTakeNoCountQtyDefault="Y" eobj.INCFStTakeNoCountQtyDefault="true"
	s eobj.INCFStTkSecondCountRequired=$p($g(^CF("IN",1)),"^",51)
	s:eobj.INCFStTkSecondCountRequired="Y" eobj.INCFStTkSecondCountRequired="true"
	s eobj.INCFStTransFormatNumber=$p($g(^CF("IN",1)),"^",44)
	s:eobj.INCFStTransFormatNumber="Y" eobj.INCFStTransFormatNumber="true"
	s eobj.INCFTransDecimalRestrict=$p($g(^CF("IN",1)),"^",45)
	s:eobj.INCFTransDecimalRestrict="Y" eobj.INCFTransDecimalRestrict="true"
	s eobj.INCFTransAckReasonMandatory=$p($g(^CF("IN",1)),"^",41)
	s:eobj.INCFTransAckReasonMandatory="Y" eobj.INCFTransAckReasonMandatory="true"
	s eobj.INCFAckFlag=$p($g(^CF("IN",1)),"^",1)
	s:eobj.INCFAckFlag="Y" eobj.INCFAckFlag="true"
	s eobj.INCFUnifyTakeNAdjustment=$p($g(^CF("IN",1)),"^",34)
	s:eobj.INCFUnifyTakeNAdjustment="Y" eobj.INCFUnifyTakeNAdjustment="true"
	s eobj.INCFUpdateARCost=$p($g(^CF("IN",1)),"^",20)
	s:eobj.INCFUpdateARCost="Y" eobj.INCFUpdateARCost="true"
	s eobj.INCFUseStkLocRestrInquiry=$p($g(^CF("IN",1)),"^",36)
	s:eobj.INCFUseStkLocRestrInquiry="Y" eobj.INCFUseStkLocRestrInquiry="true"
	
	/// 28system
	s eobj.SMCFMainDatabaseServer=$p($g(^CF("SM",1)),"^",22)
	s eobj.SMCFCTNamespace=$p($g(^CF("SM",1)),"^",57)
	s eobj.SMCFName1=$p($g(^CF("SM",1)),"^",5)
	s eobj.SMCFBillingVersion=$p($g(^CF("SM",1)),"^",12)
	s eobj.SMCFMedTrakVersion=$p($g(^CF("SM",1)),"^",9)
	s eobj.SMCFWordVersion=$p($g(^CF("SM",1)),"^",13)
	s eobj.SMCFCrystalRepDSN=$p($g(^CF("SM",1)),"^",34)
	s eobj.SMCFCrystalRepUserID=$p($g(^CF("SM",1)),"^",35)
	s eobj.SMCFCrystRepPassword="****"
	///s eobj.SMCFCrystRepPassword=$p($g(^CF("SM",1)),"^",36)
	s eobj.SMCFHL7QueryTimeoutInSecs=$p($g(^CF("SM",1)),"^",62)
	s eobj.SMCFInactivityTimeout=$p($g(^CF("SM",1)),"^",39)
	s eobj.SMCFPasswordMinLength=$p($g(^CF("SM",1)),"^",49)
	s eobj.SMCFNowNominator=$p($g(^CF("SM",1)),"^",17)
	s eobj.SMCFPasswordDaysToExpire=$p($g(^CF("SM",1)),"^",48)
	s eobj.SMCFInvalidLoginAttempts=$p($g(^CF("SM",1)),"^",46)
	s eobj.SMCFTodayNominator=$p($g(^CF("SM",1)),"^",16)
	s eobj.SMCFCloseAllFormsOnExit=$p($g(^CF("SM",1)),"^",40)
	s:eobj.SMCFCloseAllFormsOnExit="Y" eobj.SMCFCloseAllFormsOnExit="true"
	s eobj.SMCFCreateWebIndexes=$p($g(^CF("SM",1)),"^",58)
	s:eobj.SMCFCreateWebIndexes="Y" eobj.SMCFCreateWebIndexes="true"
	s eobj.SMCFDoNotDeleteGrouperFile=$p($g(^CF("SM",1)),"^",63)
	s:eobj.SMCFDoNotDeleteGrouperFile="Y" eobj.SMCFDoNotDeleteGrouperFile="true"
	s eobj.SMCFNoRestrictUserSameGroupOE=$p($g(^CF("SM",1)),"^",60)
	s:eobj.SMCFNoRestrictUserSameGroupOE="Y" eobj.SMCFNoRestrictUserSameGroupOE="true"
	s eobj.SMCFAllowDeletionFromCodeTables=$p($g(^CF("SM",1)),"^",27)
	s:eobj.SMCFAllowDeletionFromCodeTables="Y" eobj.SMCFAllowDeletionFromCodeTables="true"
	s eobj.SMCFEnableAccessNTLogon=$p($g(^CF("SM",1)),"^",54)
	s:eobj.SMCFEnableAccessNTLogon="Y" eobj.SMCFEnableAccessNTLogon="true"
	s eobj.SMCFPasswContainULSNChars=$p($g(^CF("SM",1)),"^",56)
	s:eobj.SMCFPasswContainULSNChars="Y" eobj.SMCFPasswContainULSNChars="true"
	s eobj.SMCFRestrictUserSameGroup=$p($g(^CF("SM",1)),"^",59)
	s:eobj.SMCFRestrictUserSameGroup="Y" eobj.SMCFRestrictUserSameGroup="true"
	
	
	s str = eobj.JsonS()
	s str = "{list:["_str_"]}"
	q str
}

/// 参数配置获取左边的树
/// [{"id":"6","text":"码表日志维护","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDP_DataChangeLog","leaf":true},{"id":"127","text":"Ext功能大表维护","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPExecutables","leaf":true},{"id":"8","text":"菜单维护","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDP_Menu","leaf":true},{"id":"139","text":"菜单授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPAuthorize_Menu","leaf":true},{"id":"140","text":"功能元素授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPAuthorize_Item","leaf":true},{"id":"141","text":"基础数据授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPAuthorize_BaseData","leaf":true},{"id":"294","text":"医院级授权","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/DataAutHospPre","leaf":true},{"id":"278","text":"授权浏览","iconCls":"","myhref":"dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/Aut/BDPSystem/BDPPreferences","leaf":true}]
/// w ##class(web.DHCBL.CT.CFPatConf).GetTreeJson("","","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000
	//输出菜单JSON串
	s myJsonStr=""
	
	//1
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"1"_""",""text"":"""_"自动打印"_""","
	s myUrl1="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/printing"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl1_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	
	//2
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"2"_""",""text"":"""_"计费和出纳"_""","
	s myUrl2="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/billing"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl2_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//3
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"3"_""",""text"":"""_"计费和出纳(WEB)"_""","
	s myUrl3="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/billingw"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl3_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//4
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"4"_""",""text"":"""_"预约"_""","
	s myUrl4="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/booking"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl4_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//5
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"5"_""",""text"":"""_"预约2"_""","
	s myUrl5="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/booking2"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl5_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//6
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"6"_""",""text"":"""_"临床和电子病历"_""","
	s myUrl6="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/clinical"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl6_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//7
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"7"_""",""text"":"""_"部门职能"_""","
	s myUrl7="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/departmental"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl7_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//8
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"8"_""",""text"":"""_"卸货"_""","
	s myUrl8="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/discharge"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl8_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//9
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"9"_""",""text"":"""_"地理信息"_""","
	s myUrl9="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/geographic"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl9_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//10
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"10"_""",""text"":"""_"HTML参数"_""","
	s myUrl10="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/html"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl10_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//11
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"11"_""",""text"":"""_"Labtrak关联"_""","
	s myUrl11="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/labtrak"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl11_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//12
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"12"_""",""text"":"""_"妇产科(WEB)"_""","
	s myUrl12="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/maternity"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl12_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	
	//13
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"13"_""",""text"":"""_"手术室工作台"_""","
	s myUrl13="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/operating"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl13_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//14
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"14"_""",""text"":"""_"医嘱与结果"_""","
	s myUrl14="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/orders"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl14_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	//15
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"15"_""",""text"":"""_"医嘱与结果2"_""","
	s myUrl15="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/orders2"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl15_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//16
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"16"_""",""text"":"""_"纸质记录追踪"_""","
	s myUrl16="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/paper"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl16_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//17
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"17"_""",""text"":"""_"纸质记录追踪2"_""","
	s myUrl17="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/paper2"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl17_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//18
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"18"_""",""text"":"""_"病人管理"_""","
	s myUrl18="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/patient"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl18_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//19
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"19"_""",""text"":"""_"病人管理2"_""","
	s myUrl19="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/patient2"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl19_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//20
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"20"_""",""text"":"""_"病人管理(WL)"_""","
	s myUrl20="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/patientwl"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl20_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//21
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"21"_""",""text"":"""_"病人管理(WEB)"_""","
	s myUrl21="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/patientw"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl21_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//22
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"22"_""",""text"":"""_"病人管理(WEB)2"_""","
	s myUrl22="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/patientw2"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl22_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//23
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"23"_""",""text"":"""_"病人管理(WEB A&E)"_""","
	s myUrl23="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/patientwae"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl23_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//24
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"24"_""",""text"":"""_"药学"_""","
	s myUrl24="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/pharmacy"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl24_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//25
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"25"_""",""text"":"""_"扫描默认值"_""","
	s myUrl25="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/scanning"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl25_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//26
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"26"_""",""text"":"""_"库存"_""","
	s myUrl26="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/stock"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl26_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//27
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"27"_""",""text"":"""_"库存2"_""","
	s myUrl27="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/stock2"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl27_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	//28
	s myJsonStr=myJsonStr_","
	s myJsonStr=myJsonStr_"{"
	s myJsonStr=myJsonStr_"""id"":"""_""_"28"_""",""text"":"""_"系统"_""","
	s myUrl28="dhc.bdp.ext.default.csp?extfilename=App/System/SystemParameter/system"
	s myJsonStr=myJsonStr_"""myhref"":"""_""_myUrl28_""","
	s myJsonStr=myJsonStr_"""leaf"":true"	
	s myJsonStr=myJsonStr_"}"
	
	
	s myJsonStr="["_myJsonStr_"]"
	
	q myJsonStr
}

/// /CFCTCTCURDR,CTCurrency
Query GetCTCurrency(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTCURRowId:%String,CTCURCode:%String,CTCURDesc:%String")
{
}

ClassMethod GetCTCurrencyExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s CTCURRowId=rowid
		s CTCURCode=$p($g(^CT("CUR",CTCURRowId)),"^",1)
		s CTCURDesc=$p($g(^CT("CUR",CTCURRowId)),"^",2)
		d OutputRowCTCUR
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s CTCURRowId=0
		for
		{
			s CTCURRowId=$o(^CT("CUR",CTCURRowId)) q:CTCURRowId=""	
			s CTCURCode=$p($g(^CT("CUR",CTCURRowId)),"^",1)
			s CTCURDesc=$p($g(^CT("CUR",CTCURRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCURDesc)
			i ($ZCONVERT(CTCURCode,"U")[code)&(($ZCONVERT(CTCURDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowCTCUR
			}

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCTCUR
    set Data=$lb(CTCURRowId,CTCURCode,CTCURDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetCTCurrencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTCurrencyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCTCurrencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTCurrencyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// /PATCFDefaultTariffDR  ARCTariff
Query GetARCTariff(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TARRowId:%String,TARCode:%String,TARDesc:%String")
{
}

ClassMethod GetARCTariffExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s TARRowId=rowid
		s TARCode=$p($g(^ARC("TAR",TARRowId)),"^",1)
		s TARDesc=$p($g(^ARC("TAR",TARRowId)),"^",2)
		d OutputRowTAR
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s TARRowId=0
		for
		{
			s TARRowId=$o(^ARC("TAR",TARRowId)) q:TARRowId=""	
			s TARCode=$p($g(^ARC("TAR",TARRowId)),"^",1)
			s TARDesc=$p($g(^ARC("TAR",TARRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TARDesc)
			i ($ZCONVERT(TARCode,"U")[code)&(($ZCONVERT(TARDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowTAR
			}

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowTAR
    set Data=$lb(TARRowId,TARCode,TARDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetARCTariffFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetARCTariffExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetARCTariffClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetARCTariffExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// /PATCFRoundingPaymentAdjustmentDR  As ARCReasonWriteOff
Query GetARCReasonWriteOff(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "RWRowId:%String,RWCode:%String,RWDesc:%String")
{
}

ClassMethod GetARCReasonWriteOffExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s RWRowId=rowid
		s RWCode=$p($g(^ARC("RW",RWRowId)),"^",1)
		s RWDesc=$p($g(^ARC("RW",RWRowId)),"^",2)
		d OutputRowRW
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RWRowId=0
		for
		{
			s RWRowId=$o(^ARC("RW",RWRowId)) q:RWRowId=""	
			s RWCode=$p($g(^ARC("RW",RWRowId)),"^",1)
			s RWDesc=$p($g(^ARC("RW",RWRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(RWDesc)
			i ($ZCONVERT(RWCode,"U")[code)&(($ZCONVERT(RWDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowRW
			}

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowRW
    set Data=$lb(RWRowId,RWCode,RWDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetARCReasonWriteOffFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetARCReasonWriteOffExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetARCReasonWriteOffClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetARCReasonWriteOffExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// /RBCFOverBookReasonDR As RBCReasonOverBook
Query GetRBCReasonOverBook(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ROBRowId:%String,ROBCode:%String,ROBDesc:%String")
{
}

ClassMethod GetRBCReasonOverBookExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s ROBRowId=rowid
		s ROBCode=$p($g(^RBC("ROB",ROBRowId)),"^",1)
		s ROBDesc=$p($g(^RBC("ROB",ROBRowId)),"^",2)
		d OutputRowROB
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ROBRowId=0
		for
		{
			s ROBRowId=$o(^RBC("ROB",ROBRowId)) q:ROBRowId=""	
			s ROBCode=$p($g(^RBC("ROB",ROBRowId)),"^",1)
			s ROBDesc=$p($g(^RBC("ROB",ROBRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(ROBDesc)
			i ($ZCONVERT(ROBCode,"U")[code)&(($ZCONVERT(ROBDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowROB
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowROB
    set Data=$lb(ROBRowId,ROBCode,ROBDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRBCReasonOverBookFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRBCReasonOverBookExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRBCReasonOverBookClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRBCReasonOverBookExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SystemParameter", "GetMRCDiagnosType","","")
/// /PATCFMRCType2DR As MRCDiagnosType
/// /PATCFMRCType1DR As MRCDiagnosType
Query GetMRCDiagnosType(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DTYPRowId:%String,DTYPCode:%String,DTYPDesc:%String")
{
}

ClassMethod GetMRCDiagnosTypeExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s DTYPRowId=rowid
		s DTYPCode=$p($g(^MRC("DTYP",DTYPRowId)),"^",1)
		s DTYPDesc=$p($g(^MRC("DTYP",DTYPRowId)),"^",2)
		d OutputRowDTYP
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s DTYPRowId=0
		for
		{
			s DTYPRowId=$o(^MRC("DTYP",DTYPRowId)) q:DTYPRowId=""	
			s DTYPCode=$p($g(^MRC("DTYP",DTYPRowId)),"^",1)
			s DTYPDesc=$p($g(^MRC("DTYP",DTYPRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(DTYPDesc)
			i ($ZCONVERT(DTYPCode,"U")[code)&(($ZCONVERT(DTYPDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowDTYP
			}

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDTYP
    set Data=$lb(DTYPRowId,DTYPCode,DTYPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetMRCDiagnosTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRCDiagnosTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRCDiagnosTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRCDiagnosTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// PATCFLabCounterTypeDR As PACCounterType
Query GetPACCounterType(rowid As %String, desc As %String) As %Query(ROWSPEC = "CNTRowId:%String,CNTDesc:%String")
{
}

ClassMethod GetPACCounterTypeExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s CNTRowId=rowid
		s CNTDesc=$p($g(^COUNT("CNTTYPE",CNTRowId)),"^",1)
		d OutputRowCNT
	}
	else
	{
		
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s CNTRowId=0
		for
		{
			s CNTRowId=$o(^COUNT("CNTTYPE",CNTRowId)) q:CNTRowId=""
			s CNTDesc=$p($g(^COUNT("CNTTYPE",CNTRowId)),"^",1)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CNTDesc)
			i ($ZCONVERT(CNTDesc,"U")[desc)||(PINYIN[desc)
			{
				d OutputRowCNT
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCNT
    set Data=$lb(CNTRowId,CNTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPACCounterTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPACCounterTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPACCounterTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPACCounterTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// PATCFBookingTypeForMaternityEqu As PACApptBookingSystem 
Query GetPACApptBookingSystem(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "APPTBSRowId:%String,APPTBSCode:%String,APPTBSDesc:%String")
{
}

ClassMethod GetPACApptBookingSystemExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s APPTBSRowId=rowid
		s APPTBSCode=$p($g(^PAC("APPTBS",APPTBSRowId)),"^",1)
		s APPTBSDesc=$p($g(^PAC("APPTBS",APPTBSRowId)),"^",2)
		d OutputRowAPPTBS
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s APPTBSRowId=0
		for
		{
			s APPTBSRowId=$o(^PAC("APPTBS",APPTBSRowId)) q:APPTBSRowId=""	
			s APPTBSCode=$p($g(^PAC("APPTBS",APPTBSRowId)),"^",1)
			s APPTBSDesc=$p($g(^PAC("APPTBS",APPTBSRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(APPTBSDesc)
			i ($ZCONVERT(APPTBSCode,"U")[code)&(($ZCONVERT(APPTBSDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowAPPTBS
			}

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAPPTBS
    set Data=$lb(APPTBSRowId,APPTBSCode,APPTBSDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPACApptBookingSystemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPACApptBookingSystemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPACApptBookingSystemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPACApptBookingSystemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// PATCFBreastfeedAlertCategoryDR As PACAlertCategory 
/// PATCFPregnancyAlertCategoryDR   As PACAlertCategory 
Query GetPACAlertCategory(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ALERTCATRowId:%String,ALERTCATCode:%String,ALERTCATDesc:%String")
{
}

ClassMethod GetPACAlertCategoryExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s ALERTCATRowId=rowid
		s ALERTCATCode=$p($g(^PAC("ALERTCAT",ALERTCATRowId)),"^",1)
		s ALERTCATDesc=$p($g(^PAC("ALERTCAT",ALERTCATRowId)),"^",2)
		d OutputRowALERTCAT
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s ALERTCATRowId=0
		for
		{
			s ALERTCATRowId=$o(^PAC("ALERTCAT",ALERTCATRowId)) q:ALERTCATRowId=""	
			s ALERTCATCode=$p($g(^PAC("ALERTCAT",ALERTCATRowId)),"^",1)
			s ALERTCATDesc=$p($g(^PAC("ALERTCAT",ALERTCATRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(ALERTCATDesc)
			i ($ZCONVERT(ALERTCATCode,"U")[code)&(($ZCONVERT(ALERTCATDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowALERTCAT
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowALERTCAT
    set Data=$lb(ALERTCATRowId,ALERTCATCode,ALERTCATDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPACAlertCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPACAlertCategoryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPACAlertCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPACAlertCategoryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// RTCFRequestReasonAdmDR As RTCReasonRequest
/// RTCFDefaultReasEDRequest As RTCReasonRequest 
/// RTCFRequestReasonAPPTDR As RTCReasonRequest 
/// RTCFDefaultReasonWLRequest As RTCReasonRequest
Query GetRTCReasonRequest(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "REARowId:%String,REACode:%String,READesc:%String")
{
}

ClassMethod GetRTCReasonRequestExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s REARowId=rowid
		s REACode=$p($g(^RTC("REA",REARowId)),"^",6)
		s READesc=$p($g(^RTC("REA",REARowId)),"^",1)
		d OutputRowREA
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s REARowId=0
		for
		{
			s REARowId=$o(^RTC("REA",REARowId)) q:REARowId=""	
			s REACode=$p($g(^RTC("REA",REARowId)),"^",6)
			s READesc=$p($g(^RTC("REA",REARowId)),"^",1)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(READesc)
			i ($ZCONVERT(REACode,"U")[code)&(($ZCONVERT(READesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowREA
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowREA
    set Data=$lb(REARowId,REACode,READesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRTCReasonRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRTCReasonRequestExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRTCReasonRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRTCReasonRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// RTCFMainMRTypeDR As RTCMRecordType
Query GetRTCMRecordType(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "TYPRowId:%String,TYPCode:%String,TYPDesc:%String")
{
}

ClassMethod GetRTCMRecordTypeExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s TYPRowId=rowid
		s TYPCode=$p($g(^RTC("TYPE",TYPRowId)),"^",1)
		s TYPDesc=$p($g(^RTC("TYPE",TYPRowId)),"^",2)
		d OutputRowTYP
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s TYPRowId=0
		for
		{
			s TYPRowId=$o(^RTC("TYPE",TYPRowId)) q:TYPRowId=""	
			s TYPCode=$p($g(^RTC("TYPE",TYPRowId)),"^",1)
			s TYPDesc=$p($g(^RTC("TYPE",TYPRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(TYPDesc)
			i ($ZCONVERT(TYPCode,"U")[code)&(($ZCONVERT(TYPDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowTYP
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowTYP
    set Data=$lb(TYPRowId,TYPCode,TYPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRTCMRecordTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRTCMRecordTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRTCMRecordTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRTCMRecordTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// RTCFMainMRVolumeDR As RTCMRecordTypeVolumes
Query GetRTCMRecordTypeVolumes(tpyrowid, rowid As %String, desc As %String) As %Query(ROWSPEC = "VOLRowId:%String,VOLCode:%String,VOLDesc:%String")
{
}

ClassMethod GetRTCMRecordTypeVolumesExecute(ByRef qHandle As %Binary, tpyrowid, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s VOLRowId=rowid
		s TYPRowId=$p(rowid,"||",1)
		s ChildSub=$p(rowid,"||",2)
		s VOLCode=$p($g(^RTC("TYPE",TYPRowId,"VOL",ChildSub)),"^",1)
		s VOLDesc=$p($g(^RTC("TYPE",TYPRowId,"VOL",ChildSub)),"^",2)
		d OutputRowVOL
	}
	else
	{
		s:desc'="" desc=$zcvt(desc,"U")
		s ChildSub=0 
		for
		{
			s ChildSub=$o(^RTC("TYPE",tpyrowid,"VOL",ChildSub)) q:ChildSub=""
			s VOLRowId=tpyrowid_"||"_ChildSub
			s VOLCode=$p($g(^RTC("TYPE",tpyrowid,"VOL",ChildSub)),"^",1)
			s VOLDesc=$p($g(^RTC("TYPE",tpyrowid,"VOL",ChildSub)),"^",2)
			s VOLDesc1=$zcvt(VOLDesc,"U")
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(VOLDesc)
			i (ChildSub>0)&&((VOLDesc1[desc)||(PINYIN[desc))
			{
				d OutputRowVOL
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowVOL
    set Data=$lb(VOLRowId,VOLCode,VOLDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRTCMRecordTypeVolumesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRTCMRecordTypeVolumesExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRTCMRecordTypeVolumesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRTCMRecordTypeVolumesExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.SystemParameter", "GetRTCReasonRequest","","")
/// PATCFContactTypeDR As PACContactType
Query GetPACContactType(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CONTTPRowId:%String,CONTTPCode:%String,CONTTPDesc:%String")
{
}

ClassMethod GetPACContactTypeExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s CONTTPRowId=rowid
		s CONTTPCode=$p($g(^PAC("CONTTP",CONTTPRowId)),"^",1)
		s CONTTPDesc=$p($g(^PAC("CONTTP",CONTTPRowId)),"^",2)
		d OutputRowCONTTP
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s CONTTPRowId=0
		for
		{
			s CONTTPRowId=$o(^PAC("CONTTP",CONTTPRowId)) q:CONTTPRowId=""	
			s CONTTPCode=$p($g(^PAC("CONTTP",CONTTPRowId)),"^",1)
			s CONTTPDesc=$p($g(^PAC("CONTTP",CONTTPRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CONTTPDesc)
			i ($ZCONVERT(CONTTPCode,"U")[code)&(($ZCONVERT(CONTTPDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowCONTTP
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCONTTP
    set Data=$lb(CONTTPRowId,CONTTPCode,CONTTPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPACContactTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPACContactTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPACContactTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPACContactTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// PATCFAddressTypeDR As CTAddrType
Query GetCTAddrType(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "CTADRRowId:%String,CTADRCode:%String,CTADRDesc:%String")
{
}

ClassMethod GetCTAddrTypeExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s CTADRRowId=rowid
		s CTADRCode=$p($g(^CT("ADR",CTADRRowId)),"^",1)
		s CTADRDesc=$p($g(^CT("ADR",CTADRRowId)),"^",2)
		d OutputRowCTADR
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s CTADRRowId=0
		for
		{
			s CTADRRowId=$o(^CT("ADR",CTADRRowId)) q:CTADRRowId=""	
			s CTADRCode=$p($g(^CT("ADR",CTADRRowId)),"^",1)
			s CTADRDesc=$p($g(^CT("ADR",CTADRRowId)),"^",2)
			i ($ZCONVERT(CTADRCode,"U")[code)&($ZCONVERT(CTADRDesc,"U")[desc)
			{
				d OutputRowCTADR
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCTADR
    set Data=$lb(CTADRRowId,CTADRCode,CTADRDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetCTAddrTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTAddrTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCTAddrTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTAddrTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// INCFDefRecTypeDR As INCGdRecType
Query GetINCGdRecType(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "INCGRRowId:%String,INCGRCode:%String,INCGRDesc:%String")
{
}

ClassMethod GetINCGdRecTypeExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (rowid'="")
	{
		s INCGRRowId=rowid
		s INCGRCode=$p($g(^INC("GR",INCGRRowId)),"^",1)
		s INCGRDesc=$p($g(^INC("GR",INCGRRowId)),"^",2)
		d OutputRowINCGR
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s INCGRRowId=0
		for
		{
			s INCGRRowId=$o(^INC("GR",INCGRRowId)) q:INCGRRowId=""	
			s INCGRCode=$p($g(^INC("GR",INCGRRowId)),"^",1)
			s INCGRDesc=$p($g(^INC("GR",INCGRRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(INCGRDesc)
			i ($ZCONVERT(INCGRCode,"U")[code)&(($ZCONVERT(INCGRDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowINCGR
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowINCGR
    set Data=$lb(INCGRRowId,INCGRCode,INCGRDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetINCGdRecTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetINCGdRecTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetINCGdRecTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetINCGdRecTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
