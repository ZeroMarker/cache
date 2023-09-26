/// OE Order Item           (OEORI,122)
Class User.OEOrdItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = OE_OrdItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OEORIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildOEOrdExec As OEOrdExec [ Cardinality = children, Inverse = OEOREOEORIParRef ];

Relationship ChildOEOrdResult As OEOrdResult [ Cardinality = children, Inverse = RESParRef ];

Relationship ChildOEOrdSpecimen As OEOrdSpecimen [ Cardinality = children, Inverse = SPECParRef ];

Relationship ChildOEOrdTeeth As OEOrdTeeth [ Cardinality = children, Inverse = TEETHParRef ];

Relationship ChildOEOrdBills As OEOrdBills [ Cardinality = children, Inverse = BILLParRef ];

Relationship ChildOEOrdTextResult As OEOrdTextResult [ Cardinality = children, Inverse = TRESParRef ];

Relationship ChildOEOrdStatus As OEOrdStatus [ Cardinality = children, Inverse = STParRef ];

Relationship ChildOEOrdSnomedCodes As OEOrdSnomedCodes [ Cardinality = children, Inverse = SNOParRef ];

Relationship ChildOEOrdCollectionResult As OEOrdCollectionResult [ Cardinality = children, Inverse = DELParRef ];

Relationship ChildOEOrdQuestion As OEOrdQuestion [ Cardinality = children, Inverse = QAParRef ];

Relationship ChildOEOrdDoctor As OEOrdDoctor [ Cardinality = children, Inverse = DOCParRef ];

Relationship ChildOEOrdDietModifiers As OEOrdDietModifiers [ Cardinality = children, Inverse = DMParRef ];

Relationship ChildOEOrdDBSpecimType As OEOrdDBSpecimType [ Cardinality = children, Inverse = DBSPECParRef ];

Relationship ChildOEOrdFinPer As OEOrdFinPer [ Cardinality = children, Inverse = FPParRef ];

Relationship ChildOEOrdRefDoctor As OEOrdRefDoctor [ Cardinality = children, Inverse = REFDParRef ];

Relationship ChildOEOrdAlertMessage As OEOrdAlertMessage [ Cardinality = children, Inverse = ALMParRef ];

Relationship ChildOEOrdAction As OEOrdAction [ Cardinality = children, Inverse = ACTParRef ];

Relationship ChildOEOrdDiagnos As OEOrdDiagnos [ Cardinality = children, Inverse = DIAParRef ];

Relationship ChildOEOrdItemDoseQty As OEOrdItemDoseQty [ Cardinality = children, Inverse = OIDQOEORIParRef ];

/// Des Ref to OEORD
Relationship OEORIOEORDParRef As OEOrder [ Cardinality = parent, Inverse = ChildOEOrdItem, Required, SqlFieldName = OEORI_OEORD_ParRef ];

/// OEORI Child Sub (New Key)
Property OEORIChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = OEORI_Childsub ];

/// Des Ref to OEORN
Property OEORIOrdEntDR As OEOrdEnt [ SqlColumnNumber = 3, SqlFieldName = OEORI_OrdEnt_DR ];

/// Des Ref to ARCIM
Property OEORIItmMastDR As ARCItmMast [ Required, SqlColumnNumber = 4, SqlFieldName = OEORI_ItmMast_DR ];

/// Des Ref to CTLOC
Property OEORIOrdDeptDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = OEORI_OrdDept_DR ];

/// Prescription Type
Property OEORIPrescType As %String(DISPLAYLIST = ",Inventory Formulary,Sample Formulary,Own Formulary,Inventory Non-Formulary,Sample Non-Formulary,Own Non-Formulary", MAXLEN = 23, TRUNCATE = 1, VALUELIST = ",IF,SF,OF,IN,SN,ON") [ SqlColumnNumber = 9, SqlFieldName = OEORI_PrescType ];

/// Item Status
Property OEORIItemStatDR As OECOrderStatus [ SqlColumnNumber = 10, SqlFieldName = OEORI_ItemStat_DR ];

/// Des Ref to CTPCP
Property OEORIDoctorDR As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = OEORI_Doctor_DR ];

/// Order Start Date
Property OEORISttDat As %Date [ SqlColumnNumber = 17, SqlFieldName = OEORI_SttDat ];

/// Order Start Time
Property OEORISttTim As %Time [ SqlColumnNumber = 18, SqlFieldName = OEORI_SttTim ];

/// Des Ref to OECPR
Property OEORIPriorityDR As OECPriority [ SqlColumnNumber = 23, SqlFieldName = OEORI_Priority_DR ];

/// des ref to PHCFR
Property OEORIPHFreqDR As PHCFreq [ SqlColumnNumber = 25, SqlFieldName = OEORI_PHFreq_DR ];

/// Des Ref to PHCDO
Property OEORIDosageDR As PHCDosage [ SqlColumnNumber = 26, SqlFieldName = OEORI_Dosage_DR ];

/// Des Ref to PHCIN
Property OEORIInstrDR As PHCInstruc [ SqlColumnNumber = 27, SqlFieldName = OEORI_Instr_DR ];

/// Des Ref to CTUOM
Property OEORIUnitDR As CTUOM [ SqlColumnNumber = 28, SqlFieldName = OEORI_Unit_DR ];

/// Quantity Ordered
Property OEORIPhQtyOrd As %Float [ SqlColumnNumber = 29, SqlComputeCode = { s {OEORI_PhQtyOrd}=$$CO29^at122({OEORI_DoseQty},{OEORI_PHFreq_DR},{OEORI_Durat_DR},{OEORI_Priority_DR})
}, SqlComputed, SqlComputeOnChange = (OEORIDoseQty, OEORIPHFreqDR, OEORIDuratDR), SqlFieldName = OEORI_PhQtyOrd ];

/// Cross Out Date
Property OEORIXDate As %Date [ SqlColumnNumber = 34, SqlFieldName = OEORI_XDate ];

/// Des Ref to PHCDU
Property OEORIDuratDR As PHCDuration [ SqlColumnNumber = 35, SqlFieldName = OEORI_Durat_DR ];

/// Notes for Care Provider
Property OEORIRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = OEORI_Remarks, SqlListType = SUBNODE ];

/// Specialist Instruction
Property OEORIPhSpecInstr As %String(COLLATION = "Exact", MAXLEN = 70, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = OEORI_PhSpecInstr ];

/// Bill Description
Property OEORIBillDesc As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = OEORI_BillDesc ];

/// OEORI_UnitCost
Property OEORIUnitCost As %Float [ SqlColumnNumber = 46, SqlFieldName = OEORI_UnitCost ];

/// Des Ref to CTPCP (Cross Out Name)
Property OEORIDRCrossDR As CTCareProv [ SqlColumnNumber = 47, SqlFieldName = OEORI_DRCross_DR ];

/// Cross Out Time
Property OEORIXTime As %Time [ SqlColumnNumber = 48, SqlFieldName = OEORI_XTime ];

/// Qty
Property OEORIQty As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = OEORI_Qty ];

/// Department Type
Property OEORIDepType As %String(DISPLAYLIST = ",OutPatient,InPatient,Emergency,Discharge,PreOper", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",O,I,E,D,P") [ SqlColumnNumber = 51, SqlFieldName = OEORI_DepType ];

/// Link To Order
Property OEORILinkToOrder As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 52, SqlFieldName = OEORI_LinkToOrder ];

/// Notes for Processing Department
Property OEORIDepProcNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 53, SqlFieldName = OEORI_DepProcNotes, SqlListType = SUBNODE ];

/// Insurance Billing Condition
Property OEORIInsBillConditDR As ARCInsurCoverStatus [ SqlColumnNumber = 54, SqlFieldName = OEORI_InsBillCondit_DR ];

/// Covered by Main Insurance
Property OEORICoverMainIns As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 55, SqlFieldName = OEORI_CoverMainIns ];

/// Portable Equipment Required
Property OEORIPortEquipReq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 56, SqlFieldName = OEORI_PortEquipReq ];

/// Administer after Skin Test
Property OEORIAdministerSkinTest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 57, SqlFieldName = OEORI_AdministerSkinTest ];

/// Des Ref NeedleGauge
Property OEORINeedleGaugeDR As OECNeedleGauge [ SqlColumnNumber = 58, SqlFieldName = OEORI_NeedleGauge_DR ];

/// Des Ref Interval
Property OEORIIntervalDR As %Float [ SqlColumnNumber = 59, SqlFieldName = OEORI_Interval_DR ];

/// Speed Flow Rate Calc Value
Property OEORISpeedFlowValue As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 60, SqlFieldName = OEORI_SpeedFlowValue ];

/// Des Ref NeedleType
Property OEORINeedleTypeDR As OECNeedleType [ SqlColumnNumber = 61, SqlFieldName = OEORI_NeedleType_DR ];

/// Des Ref BodySite
Property OEORIBodySiteDR As OECBodySite [ SqlColumnNumber = 62, SqlFieldName = OEORI_BodySite_DR ];

/// Who Goes Where
Property OEORIWhoGoWhere As %String(DISPLAYLIST = ",Doctor To Patient,Patient To Doctor", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",D,P") [ SqlColumnNumber = 63, SqlFieldName = OEORI_WhoGoWhere ];

/// Des Ref OperCategory
Property OEORIOperCategoryDR As ORCOperationCategory [ SqlColumnNumber = 64, SqlFieldName = OEORI_OperCategory_DR ];

/// Prescription No
Property OEORIPrescNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 65, SqlFieldName = OEORI_PrescNo ];

/// Presc Seq No
Property OEORIPrescSeqNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 66, SqlFieldName = OEORI_PrescSeqNo ];

/// Des Ref CTLOC
Property OEORIConsultDepDR As CTLoc [ SqlColumnNumber = 67, SqlFieldName = OEORI_ConsultDep_DR ];

/// Des Ref to CTCP
Property OEORIConsultDrDR As CTCareProv [ SqlColumnNumber = 68, SqlFieldName = OEORI_ConsultDr_DR ];

/// Unit
Property OEORIUnit As %String(MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",ML,L") [ SqlColumnNumber = 69, SqlFieldName = OEORI_Unit ];

/// Time(No of Times)
Property OEORITime As %Float [ SqlColumnNumber = 70, SqlFieldName = OEORI_Time ];

/// Unit(Hrs)
Property OEORIUnitHrs As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 71, SqlFieldName = OEORI_Unit_Hrs ];

/// SpeedFlowRate
Property OEORISpeedFlowRate As %String [ SqlColumnNumber = 72, SqlFieldName = OEORI_SpeedFlowRate ];

/// Flow Qty
Property OEORIFlowQty As %Float [ SqlColumnNumber = 74, SqlFieldName = OEORI_FlowQty ];

/// Des REf to CTLOC
Property OEORIRecDepDR As CTLoc [ SqlColumnNumber = 75, SqlFieldName = OEORI_RecDep_DR ];

/// OEORI_Billed
Property OEORIBilled As %String(DISPLAYLIST = ",Billed,Refunded,Paid,To Bill,To Refund,Ignore", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",B,R,P,TB,TR,I") [ SqlColumnNumber = 76, SqlFieldName = OEORI_Billed ];

/// Sequence No
Property OEORISeqNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 77, SqlFieldName = OEORI_SeqNo ];

/// Des Ref AdmInsurance
Property OEORIAdmInsuranceDR As PAAdmInsurance [ SqlColumnNumber = 78, SqlFieldName = OEORI_AdmInsurance_DR ];

/// Price
Property OEORIPrice As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 79, SqlFieldName = OEORI_Price ];

/// CollectedBy
Property OEORICollectedBy As CTCareProv [ SqlColumnNumber = 80, SqlFieldName = OEORI_CollectedBy ];

/// Date
Property OEORIDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 81, SqlFieldName = OEORI_Date ];

/// No Orders Link
Property OEORINoOrdersLink As %Float [ SqlColumnNumber = 82, SqlFieldName = OEORI_NoOrdersLink ];

/// Des Ref OrderType
Property OEORIOrderTypeDR As OECOrderType [ SqlColumnNumber = 83, SqlFieldName = OEORI_OrderType_DR ];

/// Patient Reg No
Property OEORIPRN As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 84, SqlComputeCode = { s {OEORI_PRN}=$$CO84^at122({OEORI_OEORD_ParRef})
}, SqlComputed, SqlFieldName = OEORI_PRN, Transient ];

/// Dose Qty
Property OEORIDoseQty As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 85, SqlFieldName = OEORI_DoseQty ];

/// Des Ref ARCOS
Property OEORIARCOSDR As ARCOrdSets [ SqlColumnNumber = 86, SqlFieldName = OEORI_ARCOS_DR ];

/// LinkNo
Property OEORILinkNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 87, SqlFieldName = OEORI_LinkNo ];

/// Lab Episode No
Property OEORILabEpisodeNo As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 88, SqlFieldName = OEORI_LabEpisodeNo ];

/// Lab Episode Setup flag
Property OEORILabEpisodeSetup As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 89, SqlFieldName = OEORI_LabEpisodeSetup ];

/// Time of Order
Property OEORITimeOrd As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 90, SqlFieldName = OEORI_TimeOrd ];

/// Refund Qty
Property OEORIRefundQty As %Float [ SqlColumnNumber = 91, SqlFieldName = OEORI_RefundQty ];

/// Refund Type
Property OEORIRefundType As %String(DISPLAYLIST = ",Drug Return,Discontinue", MAXLEN = 11, TRUNCATE = 1, VALUELIST = ",R,D") [ SqlColumnNumber = 92, SqlFieldName = OEORI_RefundType ];

/// Des Ref ARPBL Item,treakcare is User.ARPatBillGroupCharges
Property OEORIARPBLItemDR As User.DHCPatBillOrder [ SqlColumnNumber = 93, SqlFieldName = OEORI_ARPBLItem_DR ];

/// X out Doctor
Property OEORIXCTCPDR As CTCareProv [ SqlColumnNumber = 94, SqlFieldName = OEORI_XCTCP_DR ];

/// Des Ref ReasonForRefund
Property OEORIReasonRefundDR As BLCReasonForRefund [ SqlColumnNumber = 95, SqlFieldName = OEORI_ReasonRefund_DR ];

/// Return To Stock Flag
Property OEORIReturnToStock As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 96, SqlFieldName = OEORI_ReturnToStock ];

/// Des Ref MealType
Property OEORIMealTypeDR As DTCMealType [ SqlColumnNumber = 97, SqlFieldName = OEORI_MealType_DR ];

/// Des Ref RiceType
Property OEORIRiceTypeDR As DTCRiceType [ SqlColumnNumber = 98, SqlFieldName = OEORI_RiceType_DR ];

/// Des Ref Volume
Property OEORIVolumeDR As DTCVolume [ SqlColumnNumber = 99, SqlFieldName = OEORI_Volume_DR ];

/// Des Ref Energy
Property OEORIEnergyDR As DTCEnergy [ SqlColumnNumber = 100, SqlFieldName = OEORI_Energy_DR ];

/// Protein
Property OEORIProtein As %Float [ SqlColumnNumber = 101, SqlFieldName = OEORI_Protein ];

/// Fat
Property OEORIFat As %Float [ SqlColumnNumber = 102, SqlFieldName = OEORI_Fat ];

/// Carbohydrate
Property OEORICarbohydrate As %Float [ SqlColumnNumber = 103, SqlFieldName = OEORI_Carbohydrate ];

/// Delay Meal
Property OEORIDelayMeal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 104, SqlFieldName = OEORI_DelayMeal ];

/// Date/Time Computed
Property OEORIDateTime As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 105, SqlComputeCode = { s {OEORI_DateTime}= +{OEORI_Date}_","_(+{OEORI_TimeOrd})
}, SqlComputed, SqlFieldName = OEORI_DateTime, Transient ];

/// Des Ref Anaest
Property OEORIAnaestDR As ORAnaesthesia [ SqlColumnNumber = 106, SqlFieldName = OEORI_Anaest_DR ];

/// Des Ref Anaest Oper
Property OEORIAnaOperDR As ORAnaestOperation [ SqlColumnNumber = 107, SqlFieldName = OEORI_AnaOper_DR ];

/// Pasterize Food
Property OEORIPasterizeFood As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 108, SqlFieldName = OEORI_PasterizeFood ];

/// Sterilize Utelsis
Property OEORISterilizeUtelsis As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 109, SqlFieldName = OEORI_SterilizeUtelsis ];

/// Des Ref RVICharges
Property OEORIRVIChargeDR As RVIInsCoBillCharges [ SqlColumnNumber = 110, SqlFieldName = OEORI_RVICharge_DR ];

/// Result Status flag
Property OEORIResultFlag As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ InitialExpression = "A", SqlColumnNumber = 111, SqlFieldName = OEORI_ResultFlag ];

/// Des Ref to Freq
Property OEORIRMFreqDR As PHCFreq [ SqlColumnNumber = 112, SqlFieldName = OEORI_RMFreq_DR ];

/// Des Ref Durat
Property OEORIRMDuratDR As PHCDuration [ SqlColumnNumber = 113, SqlFieldName = OEORI_RMDurat_DR ];

/// Item Group
Property OEORIItemGroup As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 114, SqlFieldName = OEORI_ItemGroup ];

/// Date Executed
Property OEORIDateExecuted As %Date [ SqlColumnNumber = 115, SqlFieldName = OEORI_DateExecuted ];

/// Time Executed
Property OEORITimeExecuted As %Time [ SqlColumnNumber = 116, SqlFieldName = OEORI_TimeExecuted ];

/// Des Ref SSUSR
Property OEORIUserExecuted As SSUser [ SqlColumnNumber = 117, SqlFieldName = OEORI_UserExecuted ];

/// Des REf APPT
Property OEORIAPPTDR As RBAppointment [ SqlColumnNumber = 118, SqlFieldName = OEORI_APPT_DR ];

/// DRG Order
Property OEORIDRGOrder As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 119, SqlFieldName = OEORI_DRGOrder ];

/// Des Ref SS_User
Property OEORIUserAdd As SSUser [ SqlColumnNumber = 120, SqlFieldName = OEORI_UserAdd ];

/// Des Ref Department
Property OEORIUserDepartmentDR As CTLoc [ SqlColumnNumber = 121, SqlFieldName = OEORI_UserDepartment_DR ];

/// User Authorise
Property OEORIUserAuthorise As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 122, SqlFieldName = OEORI_UserAuthorise ];

/// AuthComments
Property OEORIAuthComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 123, SqlFieldName = OEORI_AuthComments, SqlListType = SUBNODE ];

/// Dispensing Times
Property OEORIDispensingTimes As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 124, SqlFieldName = OEORI_DispensingTimes ];

/// Des Ref FlowRate
Property OEORIFlowRateUnitDR As OECSpeedFlowRate [ SqlColumnNumber = 125, SqlFieldName = OEORI_FlowRateUnit_DR ];

/// Des REfConsCateg
Property OEORIConsCategDR As OECConsultCateg [ SqlColumnNumber = 126, SqlFieldName = OEORI_ConsCateg_DR ];

/// Des REf Doctor Executed
Property OEORIDoctorExecutedDR As CTCareProv [ SqlColumnNumber = 127, SqlFieldName = OEORI_DoctorExecuted_DR ];

/// Discount Amt
Property OEORIDiscountAmt As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 128, SqlFieldName = OEORI_DiscountAmt ];

/// Discount Perc
Property OEORIDiscountPerc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 129, SqlFieldName = OEORI_DiscountPerc ];

/// Discount Date
Property OEORIDiscountDate As %Date [ SqlColumnNumber = 130, SqlFieldName = OEORI_DiscountDate ];

/// Discount Time
Property OEORIDiscountTime As %Time [ SqlColumnNumber = 131, SqlFieldName = OEORI_DiscountTime ];

/// Discount Doctor
Property OEORIDiscountDoctorDR As CTCareProv [ SqlColumnNumber = 132, SqlFieldName = OEORI_DiscountDoctor_DR ];

/// Discount Reason
Property OEORIDiscountReason As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 133, SqlFieldName = OEORI_DiscountReason ];

/// Cost (to calculate price)
Property OEORICost As %Float [ SqlColumnNumber = 134, SqlFieldName = OEORI_Cost ];

/// Finish Date of the order
Property OEORIFinDate As %Date [ SqlColumnNumber = 135, SqlComputeCode = { s {OEORI_FinDate}=$$CO135^at122({OEORI_RowId},{OEORI_SttDat},{OEORI_Durat_DR},{OEORI_RMDurat_DR})
}, SqlComputed, SqlFieldName = OEORI_FinDate, Transient ];

/// LabTestSet RowId
Property OEORILabTestSetRow As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 136, SqlFieldName = OEORI_LabTestSetRow ];

/// Des Ref RefCln
Property OEORIRefClnDR As CTRefClin [ SqlColumnNumber = 137, SqlFieldName = OEORI_RefCln_DR ];

/// HIC Claim No
Property OEORIHICClaimNo As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 138, SqlFieldName = OEORI_HICClaimNo ];

/// Des REf MainOeEnt_DR
Property OEORIMainOeEntDR As OEOrdEnt [ SqlColumnNumber = 139, SqlFieldName = OEORI_MainOeEnt_DR ];

/// Pharmacy Status
Property OEORIPharmacyStatus As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 140, SqlFieldName = OEORI_PharmacyStatus ];

/// Des Ref UserUpdate
Property OEORIUserUpdate As SSUser [ SqlColumnNumber = 141, SqlFieldName = OEORI_UserUpdate ];

/// Des Ref CTLOC
Property OEORICollectionDepDR As CTLoc [ SqlColumnNumber = 142, SqlFieldName = OEORI_CollectionDep_DR ];

/// Expected Coll Date
Property OEORIExpectedCollDate As %Date [ SqlColumnNumber = 143, SqlFieldName = OEORI_ExpectedCollDate ];

/// Expected Collection Time
Property OEORIExpectedCollTime As %Time [ SqlColumnNumber = 144, SqlFieldName = OEORI_ExpectedCollTime ];

/// Lab1
Property OEORILab1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 145, SqlFieldName = OEORI_Lab1 ];

/// Lab2
Property OEORILab2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 146, SqlFieldName = OEORI_Lab2 ];

/// Max Number Of Repeats
Property OEORIMaxNumberOfRepeats As %Float [ SqlColumnNumber = 147, SqlFieldName = OEORI_MaxNumberOfRepeats ];

/// Accession Number
Property OEORIAccessionNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 148, SqlFieldName = OEORI_AccessionNumber ];

/// Result Reference
Property OEORIResultRef As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 149, SqlFieldName = OEORI_ResultRef ];

/// Des Ref ClinPathways
Property OEORIClinPathwaysDR As MRClinicalPathWays [ SqlColumnNumber = 150, SqlFieldName = OEORI_ClinPathways_DR ];

/// Result Group
Property OEORIResultGroup As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 151, SqlFieldName = OEORI_ResultGroup ];

/// StockBatches
Property OEORIStockBatches As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 152, SqlFieldName = OEORI_StockBatches ];

/// Des REf Assistant
Property OEORIAssistantDR As CTCareProv [ SqlColumnNumber = 153, SqlFieldName = OEORI_Assistant_DR ];

/// Qty for Packing UOM
Property OEORIQtyPackUOM As %Float [ SqlColumnNumber = 154, SqlFieldName = OEORI_QtyPackUOM ];

/// Date Read
Property OEORIDateRead As %Date [ SqlColumnNumber = 155, SqlFieldName = OEORI_DateRead ];

/// Time Read
Property OEORITimeRead As %Time [ SqlColumnNumber = 156, SqlFieldName = OEORI_TimeRead ];

/// Des Ref UserRead
Property OEORIUserReadDR As SSUser [ SqlColumnNumber = 157, SqlFieldName = OEORI_UserRead_DR ];

/// Des Ref AlertReason
Property OEORIAlertReasonDR As OECAlertReason [ SqlColumnNumber = 158, SqlFieldName = OEORI_AlertReason_DR ];

/// End Date
Property OEORIEndDate As %Date [ SqlColumnNumber = 159, SqlFieldName = OEORI_EndDate ];

/// EndT ime
Property OEORIEndTime As %Time [ SqlColumnNumber = 160, SqlFieldName = OEORI_EndTime ];

/// Des Ref AdmLoc
Property OEORIAdmLocDR As CTLoc [ SqlColumnNumber = 161, SqlFieldName = OEORI_AdmLoc_DR ];

/// Contact Care Prov
Property OEORIContactCareProv As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 162, SqlFieldName = OEORI_ContactCareProv ];

/// Filler No
Property OEORIFillerNo As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 163, SqlFieldName = OEORI_FillerNo ];

/// Des Ref VarianceReason
Property OEORIVarianceReasonDR As MRCVarianceReason [ SqlColumnNumber = 164, SqlFieldName = OEORI_VarianceReason_DR ];

/// Authorised Date
Property OEORIAuthorisedDate As %Date [ SqlColumnNumber = 165, SqlFieldName = OEORI_AuthorisedDate ];

/// ExamStartTime
Property OEORIExamStartTime As %Time [ SqlColumnNumber = 166, SqlFieldName = OEORI_ExamStartTime ];

/// Patient ID Checked
Property OEORIPatientIDChecked As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 167, SqlFieldName = OEORI_PatientIDChecked ];

/// Pre Exam User
Property OEORIPreExamUser As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 168, SqlFieldName = OEORI_PreExamUser ];

/// Exposure KV
Property OEORIExposureKV As %Float [ SqlColumnNumber = 169, SqlFieldName = OEORI_ExposureKV ];

/// Exposure_mAs
Property OEORIExposuremAs As %Float [ SqlColumnNumber = 170, SqlFieldName = OEORI_Exposure_mAs ];

/// Screening Time
Property OEORIScreeningTime As %Float [ SqlColumnNumber = 171, SqlFieldName = OEORI_ScreeningTime ];

/// Des Ref Type_SizeOfFilmsUsed
Property OEORITypeSizeOfFilmsUsedDR As OECFilmTypeSize [ SqlColumnNumber = 172, SqlFieldName = OEORI_Type_SizeOfFilmsUsed_DR ];

/// LMP Date
Property OEORILMPDate As %Date [ SqlColumnNumber = 173, SqlFieldName = OEORI_LMPDate ];

/// Des Ref TypeSizeOfFilmsRejected
Property OEORITypeSizeOfFilmsRejectedDR As OECFilmTypeSize [ SqlColumnNumber = 174, SqlFieldName = OEORI_TypeSizeOfFilmsRejected_DR ];

/// Des Ref RBResource
Property OEORIRBResourceDR As RBResource [ SqlColumnNumber = 175, SqlFieldName = OEORI_RBResource_DR ];

/// Des Ref Film Reason For Rejection
Property OEORIFilmReasonForRejectionDR As OECFilmReasonForReject [ SqlColumnNumber = 176, SqlFieldName = OEORI_FilmReasonForRejection_DR ];

/// Des Ref Contrast Type
Property OEORIContrastTypeDR As OECFilmContrastType [ SqlColumnNumber = 177, SqlFieldName = OEORI_ContrastType_DR ];

/// Contrast Volume
Property OEORIContrastVolume As %Float [ SqlColumnNumber = 178, SqlFieldName = OEORI_ContrastVolume ];

/// Contrast Expiry Date
Property OEORIContrastExpiryDate As %Date [ SqlColumnNumber = 179, SqlFieldName = OEORI_ContrastExpiryDate ];

/// Contrast Batch Number
Property OEORIContrastBatchNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 180, SqlFieldName = OEORI_ContrastBatchNumber ];

/// Injection Time
Property OEORIInjectionTime As %Time [ SqlColumnNumber = 181, SqlFieldName = OEORI_InjectionTime ];

/// Des Ref CTPCP
Property OEORIPersonInjectDR As CTCareProv [ SqlColumnNumber = 182, SqlFieldName = OEORI_PersonInject_DR ];

/// PregnancyCheck
Property OEORIPregnancyCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 183, SqlFieldName = OEORI_PregnancyCheck ];

/// Isotope Dose
Property OEORIIsotopeDose As %Float [ SqlColumnNumber = 184, SqlFieldName = OEORI_IsotopeDose ];

/// Post Exam User
Property OEORIPostExamUser As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 185, SqlFieldName = OEORI_PostExamUser ];

/// Authorised Time
Property OEORIAuthorisedTime As %Time [ SqlColumnNumber = 186, SqlFieldName = OEORI_AuthorisedTime ];

/// HotReportRequired
Property OEORIHotReportRequired As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 187, SqlFieldName = OEORI_HotReportRequired ];

/// Des Ref WaitList
Property OEORIWaitListDR As PAWaitingList [ SqlColumnNumber = 188, SqlFieldName = OEORI_WaitList_DR ];

/// Epis Arrive Date
Property OEORIEpisArriveDate As %Date [ SqlColumnNumber = 189, SqlFieldName = OEORI_EpisArriveDate ];

/// Epis Arrive Time
Property OEORIEpisArriveTime As %Time [ SqlColumnNumber = 190, SqlFieldName = OEORI_EpisArriveTime ];

/// Abnormal flag
Property OEORIAbnormal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 191, SqlFieldName = OEORI_Abnormal ];

/// UpdateDate
Property OEORIUpdateDate As %Date [ SqlColumnNumber = 192, SqlFieldName = OEORI_UpdateDate ];

/// Update Time
Property OEORIUpdateTime As %Time [ SqlColumnNumber = 193, SqlFieldName = OEORI_UpdateTime ];

/// Des Ref NoConsentOverrideReas
Property OEORINoConsentOverrideReasDR As OECOverReasonNonConsent [ SqlColumnNumber = 194, SqlFieldName = OEORI_NoConsentOverrideReas_DR ];

/// No Ordered Bags
Property OEORINoOrderedBags As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 195, SqlFieldName = OEORI_NoOrderedBags ];

/// CurrSampleExpiry
Property OEORICurrSampleExpiry As %Date [ SqlColumnNumber = 196, SqlFieldName = OEORI_CurrSampleExpiry ];

/// ReasOrdCMVNegBlood
Property OEORIReasOrdCMVNegBlood As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 197, SqlFieldName = OEORI_ReasOrdCMVNegBlood ];

/// CompXMatchReq
Property OEORICompXMatchReq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 198, SqlFieldName = OEORI_CompXMatchReq ];

/// AutologousBloodReq
Property OEORIAutologousBloodReq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 199, SqlFieldName = OEORI_AutologousBloodReq ];

/// PatConsentObtained
Property OEORIPatConsentObtained As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 200, SqlFieldName = OEORI_PatConsentObtained ];

/// BBTAG1
Property OEORIBBTAG1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 201, SqlFieldName = OEORI_BBTAG1 ];

/// BBTAG2
Property OEORIBBTAG2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 202, SqlFieldName = OEORI_BBTAG2 ];

/// BBTAG3
Property OEORIBBTAG3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 203, SqlFieldName = OEORI_BBTAG3 ];

/// BBTAG4
Property OEORIBBTAG4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 204, SqlFieldName = OEORI_BBTAG4 ];

/// BBTAG5
Property OEORIBBTAG5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 205, SqlFieldName = OEORI_BBTAG5 ];

/// BBExtCode
Property OEORIBBExtCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 206, SqlFieldName = OEORI_BBExtCode ];

/// Des Ref RefDoc
Property OEORIRefDocDR As PACRefDoctor [ SqlColumnNumber = 207, SqlFieldName = OEORI_RefDoc_DR ];

/// BBStatus
Property OEORIBBStatus As %String(DISPLAYLIST = ",Ready,BBPick", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",R,B") [ SqlColumnNumber = 208, SqlFieldName = OEORI_BBStatus ];

/// Des Ref Action
Property OEORIActionDR As OECAction [ SqlColumnNumber = 209, SqlFieldName = OEORI_Action_DR ];

/// Result Comments
Property OEORIResultComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 210, SqlFieldName = OEORI_ResultComments, SqlListType = SUBNODE ];

/// Des Ref AllergyReason
Property OEORIAllergyReasonDR As PACAllergyReason [ SqlColumnNumber = 211, SqlFieldName = OEORI_AllergyReason_DR ];

/// Lab Action
Property OEORILabAction As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 212, SqlFieldName = OEORI_LabAction ];

/// LabVolume
Property OEORILabVolume As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 213, SqlFieldName = OEORI_LabVolume ];

/// LabSeqNo
Property OEORILabSeqNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 214, SqlFieldName = OEORI_LabSeqNo ];

/// Placer No
Property OEORIPlacerNo As %String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 1) [ SqlColumnNumber = 215, SqlFieldName = OEORI_PlacerNo ];

/// SentInExtract
Property OEORISentInExtract As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 216, SqlFieldName = OEORI_SentInExtract ];

/// Radiology SeriesNo
Property OEORISeriesNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 217, SqlFieldName = OEORI_SeriesNo ];

/// LabReceiveDate
Property OEORILabReceiveDate As %Date [ SqlColumnNumber = 218, SqlFieldName = OEORI_LabReceiveDate ];

/// LabReceiveTime
Property OEORILabReceiveTime As %Time [ SqlColumnNumber = 219, SqlFieldName = OEORI_LabReceiveTime ];

/// Des Ref PostExamUserHospDR
Property OEORIPostExamUserHospDR As CTHospital [ SqlColumnNumber = 220, SqlFieldName = OEORI_PostExamUserHospDR ];

/// Des Ref PreExamUserHospDR
Property OEORIPreExamUserHospDR As CTHospital [ SqlColumnNumber = 221, SqlFieldName = OEORI_PreExamUserHospDR ];

/// Des Ref UserAuthoriseHospDR
Property OEORIUserAuthoriseHospDR As CTHospital [ SqlColumnNumber = 222, SqlFieldName = OEORI_UserAuthoriseHospDR ];

/// Des Ref UserAddHospDR
Property OEORIUserAddHospDR As CTHospital [ SqlColumnNumber = 223, SqlFieldName = OEORI_UserAddHospDR ];

/// Theatre Required
Property OEORITheatreRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 224, SqlFieldName = OEORI_TheatreRequired ];

/// Theatre Date
Property OEORITheatreDate As %Date [ SqlColumnNumber = 225, SqlFieldName = OEORI_TheatreDate ];

/// TestSetComments
Property OEORITestSetComments As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 226, SqlFieldName = OEORI_TestSetComments, SqlListType = SUBNODE ];

/// Return Date
Property OEORIReturnDate As %Date [ SqlColumnNumber = 227, SqlFieldName = OEORI_ReturnDate ];

/// Return Time
Property OEORIReturnTime As %Time [ SqlColumnNumber = 228, SqlFieldName = OEORI_ReturnTime ];

/// Des Ref ReturnUser
Property OEORIReturnUserDR As SSUser [ SqlColumnNumber = 229, SqlFieldName = OEORI_ReturnUser_DR ];

/// Des Ref OEORI
Property OEORIOEORIDR As OEOrdItem [ SqlColumnNumber = 230, SqlFieldName = OEORI_OEORI_DR ];

/// Day Book Accession No
Property OEORIDayBookAccessionNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 231, SqlFieldName = OEORI_DayBookAccessionNo ];

/// DayBookSpecimen
Property OEORIDayBookSpecimen As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 232, SqlFieldName = OEORI_DayBookSpecimen ];

/// Units Collected
Property OEORIUnitsCollected As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 233, SqlFieldName = OEORI_UnitsCollected ];

/// Incomplete Collection
Property OEORIIncompleteCollection As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 234, SqlFieldName = OEORI_IncompleteCollection, SqlListType = SUBNODE ];

/// Des Ref UserUnRead
Property OEORIUserUnReadDR As SSUser [ SqlColumnNumber = 235, SqlFieldName = OEORI_UserUnRead_DR ];

/// Date UnRead
Property OEORIDateUnRead As %Date [ SqlColumnNumber = 236, SqlFieldName = OEORI_DateUnRead ];

/// Time Unread
Property OEORITimeUnread As %Time [ SqlColumnNumber = 237, SqlFieldName = OEORI_TimeUnread ];

/// Reason Not Collected
Property OEORIReasonNotCollected As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 238, SqlFieldName = OEORI_ReasonNotCollected, SqlListType = SUBNODE ];

/// Post Exam Start Time
Property OEORIPostExamStartTime As %Time [ SqlColumnNumber = 239, SqlFieldName = OEORI_PostExamStartTime ];

/// Des Ref IndicTransfusion
Property OEORIIndicTransfusionDR As OECIndicationTransfusion [ SqlColumnNumber = 240, SqlFieldName = OEORI_IndicTransfusion_DR ];

/// Clinically Significant
Property OEORIClinicallySignificant As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 241, SqlFieldName = OEORI_ClinicallySignificant ];

/// SensitivitiesSignoff
Property OEORISensitivitiesSignoff As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 242, SqlFieldName = OEORI_SensitivitiesSignoff ];

/// ContOrderAfterDischarge
Property OEORIContOrderAfterDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 243, SqlFieldName = OEORI_ContOrderAfterDischarge ];

/// Des Ref Route
Property OEORIRouteDR As OECRoute [ SqlColumnNumber = 244, SqlFieldName = OEORI_Route_DR ];

/// Des Ref PendingStatus
Property OEORIPendingStatusDR As OECOrderStatus [ SqlColumnNumber = 245, SqlFieldName = OEORI_PendingStatus_DR ];

/// Des Ref AuthoriseClinician
Property OEORIAuthoriseClinicianDR As CTCareProv [ SqlColumnNumber = 246, SqlFieldName = OEORI_AuthoriseClinician_DR ];

/// Notify
Property OEORINotify As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 247, SqlFieldName = OEORI_Notify ];

/// NotifyClinician
Property OEORINotifyClinician As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 248, SqlFieldName = OEORI_NotifyClinician ];

/// Des Ref PACClinic
Property OEORIPACClinicDR As PACClinic [ SqlColumnNumber = 249, SqlFieldName = OEORI_PACClinic_DR ];

/// ResultUpdateDate
Property OEORIResultUpdateDate As %Date [ SqlColumnNumber = 250, SqlFieldName = OEORI_ResultUpdateDate ];

/// ResultUpdateTime
Property OEORIResultUpdateTime As %Time [ SqlColumnNumber = 251, SqlFieldName = OEORI_ResultUpdateTime ];

/// Des Ref ResultUpdateUser
Property OEORIResultUpdateUserDR As SSUser [ SqlColumnNumber = 252, SqlFieldName = OEORI_ResultUpdateUser_DR ];

/// Des Ref ResultUpdateHospital
Property OEORIResultUpdateHospitalDR As CTHospital [ SqlColumnNumber = 253, SqlFieldName = OEORI_ResultUpdateHospital_DR ];

/// EligibilityStatus
Property OEORIEligibilityStatus As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 254, SqlFieldName = OEORI_EligibilityStatus ];

/// RecLocVerified
Property OEORIRecLocVerified As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 255, SqlFieldName = OEORI_RecLocVerified ];

/// ResultAvailable
Property OEORIResultAvailable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 256, SqlFieldName = OEORI_ResultAvailable ];

/// ExternalPrimarySpecSite
Property OEORIExternalPrimarySpecSite As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 257, SqlFieldName = OEORI_ExternalPrimarySpecSite ];

/// ExternalSecondarySpecSite
Property OEORIExternalSecondarySpecSite As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 258, SqlFieldName = OEORI_ExternalSecondarySpecSite ];

/// Des Ref ExternalRefDoctor
Property OEORIExternalRefDoctorDR As PACRefDoctor [ SqlColumnNumber = 259, SqlFieldName = OEORI_ExternalRefDoctor_DR ];

/// ResultAvailableDate
Property OEORIResultAvailableDate As %Date [ SqlColumnNumber = 260, SqlFieldName = OEORI_ResultAvailableDate ];

/// Des Ref Manufacturer Order
Property OEORIManufacturerOrderDR As INManufactureOrder [ SqlColumnNumber = 261, SqlFieldName = OEORI_ManufacturerOrder_DR ];

/// HL7ResultStatus
Property OEORIHL7ResultStatus As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 262, SqlFieldName = OEORI_HL7ResultStatus ];

/// HL7ResultDate
Property OEORIHL7ResultDate As %Date [ SqlColumnNumber = 263, SqlFieldName = OEORI_HL7ResultDate ];

/// HL7ResultTime
Property OEORIHL7ResultTime As %Time [ SqlColumnNumber = 264, SqlFieldName = OEORI_HL7ResultTime ];

/// FreqDelay
Property OEORIFreqDelay As %Float [ SqlColumnNumber = 265, SqlFieldName = OEORI_FreqDelay ];

/// Des ref CancelReason
Property OEORICancelReasonDR As OECCancelReason [ SqlColumnNumber = 266, SqlFieldName = OEORI_CancelReason_DR ];

/// LabelText
Property OEORILabelText As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 267, SqlFieldName = OEORI_LabelText, SqlListType = SUBNODE ];

/// Des Ref Specialty
Property OEORISpecialtyDR As CTSpec [ SqlColumnNumber = 268, SqlFieldName = OEORI_Specialty_DR ];

/// Des Ref AdminRoute
Property OEORIAdminRouteDR As PHCAdministrationRoute [ SqlColumnNumber = 269, SqlFieldName = OEORI_AdminRoute_DR ];

/// PRNMaxDose24hrs
Property OEORIPRNMaxDose24hrs As %Float [ SqlColumnNumber = 270, SqlFieldName = OEORI_PRNMaxDose24hrs ];

/// PRNTotal NumberDosesAllowed
Property OEORIPRNTotNumberDosesAll As %Float [ SqlColumnNumber = 271, SqlFieldName = OEORI_PRNTotNumberDosesAll ];

/// PRNIndication
Property OEORIPRNIndication As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 272, SqlFieldName = OEORI_PRNIndication, SqlListType = SUBNODE ];

/// Pregnant
Property OEORIPregnant As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 273, SqlFieldName = OEORI_Pregnant ];

/// LDMP
Property OEORILDMP As %Date [ SqlColumnNumber = 274, SqlFieldName = OEORI_LDMP ];

/// WeeksPregnant
Property OEORIWeeksPregnant As %Float [ SqlColumnNumber = 275, SqlFieldName = OEORI_WeeksPregnant ];

/// DayOfCycle
Property OEORIDayOfCycle As %Float [ SqlColumnNumber = 276, SqlFieldName = OEORI_DayOfCycle ];

/// ClinicalCondition
Property OEORILtClinicalCondition As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 277, SqlFieldName = OEORI_LtClinicalCondition ];

/// Questionnaire
Property OEORIQuestionnaire As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 278, SqlFieldName = OEORI_Questionnaire ];

/// SupplierContactedDate
Property OEORISupplierContactedDate As %Date [ SqlColumnNumber = 279, SqlFieldName = OEORI_SupplierContactedDate ];

/// SupplierContactedTime
Property OEORISupplierContactedTime As %Time [ SqlColumnNumber = 280, SqlFieldName = OEORI_SupplierContactedTime ];

/// ProsReceivedDate
Property OEORIProsReceivedDate As %Date [ SqlColumnNumber = 281, SqlFieldName = OEORI_ProsReceivedDate ];

/// ProsReceivedTime
Property OEORIProsReceivedTime As %Time [ SqlColumnNumber = 282, SqlFieldName = OEORI_ProsReceivedTime ];

/// ProsBatchNo
Property OEORIProsBatchNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 283, SqlFieldName = OEORI_ProsBatchNo ];

/// ProsSerialNo
Property OEORIProsSerialNo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 284, SqlFieldName = OEORI_ProsSerialNo ];

/// ProsSupplier
Property OEORIProsSupplier As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 285, SqlFieldName = OEORI_ProsSupplier ];

/// ExpiryDate
Property OEORIExpiryDate As %Date [ SqlColumnNumber = 286, SqlFieldName = OEORI_ExpiryDate ];

/// Size
Property OEORISize As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 287, SqlFieldName = OEORI_Size ];

/// Des Ref ImplantType
Property OEORIImplantTypeDR As OECImplantType [ SqlColumnNumber = 288, SqlFieldName = OEORI_ImplantType_DR ];

/// ReadyToBill
Property OEORIReadyToBill As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 289, SqlFieldName = OEORI_ReadyToBill ];

/// DietFlag
Property OEORIDietFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 290, SqlFieldName = OEORI_DietFlag ];

/// Activity
Property OEORIActivity As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 291, SqlFieldName = OEORI_Activity ];

/// View
Property OEORIView As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 292, SqlFieldName = OEORI_View ];

/// DSReportFlag
Property OEORIDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 293, SqlFieldName = OEORI_DSReportFlag ];

/// ResultDSReportFlag
Property OEORIResultDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 294, SqlFieldName = OEORI_ResultDSReportFlag ];

/// PrescRepExpiryDate
Property OEORIPrescRepExpiryDate As %Date [ SqlColumnNumber = 295, SqlFieldName = OEORI_PrescRepExpiryDate ];

/// PrescRep Number of Days
Property OEORIPrescRepNumberDays As %Float [ SqlColumnNumber = 296, SqlFieldName = OEORI_PrescRepNumberDays ];

/// MaxRepeats
Property OEORIMaxRepeats As %Float [ SqlColumnNumber = 297, SqlFieldName = OEORI_MaxRepeats ];

/// CurrRepeatNumber
Property OEORICurrRepeatNumber As %Float [ SqlColumnNumber = 298, SqlFieldName = OEORI_CurrRepeatNumber ];

/// Des Ref Categ
Property OEORICategDR As OECOrderCategory [ SqlColumnNumber = 299, SqlComputeCode = { n itemcat s itemcat=$p($g(^ARCIM(+{OEORI_ItmMast_DR},1,1)),"^",10)
 s {OEORI_Categ_DR}=$p($g(^ARC("IC",+itemcat)),"^",8)
}, SqlComputed, SqlFieldName = OEORI_Categ_DR, Transient ];

/// Des Ref Consult
Property OEORIConsultDR As PAPersonConsultSetCons [ SqlColumnNumber = 300, SqlFieldName = OEORI_Consult_DR ];

/// Des Ref Annotation
Property OEORIAnnotationDR As OEAnnotation [ SqlColumnNumber = 301, SqlFieldName = OEORI_Annotation_DR ];

/// Des Ref SkinTestOutcome
Property OEORISkinTestOutcomeDR As PHCSkinTestOutcome [ SqlColumnNumber = 302, SqlFieldName = OEORI_SkinTestOutcome_DR ];

/// LTSpecCode
Property OEORILTSpecCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 303, SqlFieldName = OEORI_LTSpecCode ];

/// LTSiteCode
Property OEORILTSiteCode As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 304, SqlFieldName = OEORI_LTSiteCode ];

/// Retention Days
Property OEORIRetentionDays As %Float [ SqlColumnNumber = 305, SqlFieldName = OEORI_RetentionDays ];

/// Des Ref PackOverReason
Property OEORIPackOverReasonDR As PHCPackingOverrideReason [ SqlColumnNumber = 306, SqlFieldName = OEORI_PackOverReason_DR ];

/// UrgentReport
Property OEORIUrgentReport As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 307, SqlFieldName = OEORI_UrgentReport ];

/// PhoneOrder
Property OEORIPhoneOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 308, SqlFieldName = OEORI_PhoneOrder ];

/// Des Ref SecondOrderingUser
Property OEORISecondOrderingUserDR As SSUser [ SqlColumnNumber = 309, SqlFieldName = OEORI_SecondOrderingUser_DR ];

/// DatePOAuthorised
Property OEORIDatePOAuthorised As %Date [ SqlColumnNumber = 310, SqlFieldName = OEORI_DatePOAuthorised ];

/// TimePOAuthorised
Property OEORITimePOAuthorised As %Time [ SqlColumnNumber = 311, SqlFieldName = OEORI_TimePOAuthorised ];

/// DateAuthReq
Property OEORIDateAuthReq As %Date [ SqlColumnNumber = 312, SqlFieldName = OEORI_DateAuthReq ];

/// TimeAuthReq
Property OEORITimeAuthReq As %Time [ SqlColumnNumber = 313, SqlFieldName = OEORI_TimeAuthReq ];

/// Des Ref AnaestAgent
Property OEORIAnaestAgentDR As ORAnaestAgent [ SqlColumnNumber = 314, SqlFieldName = OEORI_AnaestAgent_DR ];

/// Des Ref OriginalOrder
Property OEORIOriginalOrderDR As OEOrdItem [ SqlColumnNumber = 315, SqlFieldName = OEORI_OriginalOrder_DR ];

/// Des Ref Exam AbandonReason
Property OEORIExamAbandonReasonDR As OECExamAbandonReason [ SqlColumnNumber = 316, SqlFieldName = OEORI_ExamAbandonReason_DR ];

/// ResultExist
Property OEORIResultExist As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 317, SqlFieldName = OEORI_ResultExist ];

/// Preparation Time
Property OEORIPreparationTime As %Float [ SqlColumnNumber = 318, SqlFieldName = OEORI_PreparationTime ];

/// Personnel
Property OEORIPersonnel As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 319, SqlFieldName = OEORI_Personnel ];

/// Comment1
Property OEORIComment1 As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 320, SqlFieldName = OEORI_Comment1 ];

/// Comment2
Property OEORIComment2 As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 321, SqlFieldName = OEORI_Comment2 ];

/// Comment3
Property OEORIComment3 As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 322, SqlFieldName = OEORI_Comment3 ];

/// Des Ref RadiationDoesUnit
Property OEORIRadiationDoesUnitDR As OECRadiologyDoseUnits [ SqlColumnNumber = 323, SqlFieldName = OEORI_RadiationDoesUnit_DR ];

/// Des Ref ReasonRejectPresc
Property OEORIReasonRejectPrescDR As OECReasonRejectPresc [ SqlColumnNumber = 324, SqlFieldName = OEORI_ReasonRejectPresc_DR ];

/// Demand Number
Property OEORIDemandNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 325, SqlFieldName = OEORI_DemandNumber ];

/// RadiologyStatus
Property OEORIRadiologyStatus As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 326, SqlFieldName = OEORI_RadiologyStatus ];

/// 保存系统日期 add by zhouzq 2012.03.20 
Property OEORIInsertDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 327, SqlFieldName = OEORI_InsertDate ];

/// 保存系统时间 add by zhouzq 2012.03.20
Property OEORIInsertTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 328, SqlFieldName = OEORI_InsertTime ];

/// 计费日期 add by 郭荣勇 2019.01.20 
Property OEORIBillPriceDate As %Date [ SqlColumnNumber = 329, SqlFieldName = OEORI_BillPriceDate ];

/// 计费时间 add by 郭荣勇 2019.01.20
Property OEORIBillPriceTime As %Time [ SqlColumnNumber = 330, SqlFieldName = OEORI_BillPriceTime ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdItem).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdItem","OnAfterInsert")
 d Table^HL7Outbound("OEOrdItem",%d(1),"Insert")
 d ##Class(web.OEOrdItem).CheckNullOrInvalidStatus($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdItem).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdItem","OnAfterUpdate")
 d Table^HL7Outbound("OEOrdItem",%d(1),"Update")
 d ##Class(web.OEOrdItem).CheckNullOrInvalidStatus($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdItem).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdItem","OnBeforeDelete")
 s %ok=$$onbeforedelete^COEOrdItem16()
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdItem).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdItem","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdItem","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdItem).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdItem","OnAfterDelete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="IndexARCIM">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAbnormal">
<Condition>{OEORI_Abnormal}["Y"</Condition>
<ConditionFields>OEORI_Abnormal</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Abnorm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAnAgent">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ANAAgent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_AnaestAgent_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAnaest">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ana"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_Anaest_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAnaestOper">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AnaOp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_AnaOper_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppointment">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Appt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_APPT_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuth">
<Condition>{OEORI_AuthorisedDate}</Condition>
<ConditionFields>OEORI_AuthorisedDate,OEORI_SttDat</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Auth"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ItemStat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAuthReq">
<Condition>'{OEORI_DatePOAuthorised},{OEORI_TimePOAuthorised}=""</Condition>
<ConditionFields>OEORI_DatePOAuthorised,OEORI_DateAuthReq,OEORI_TimeAuthReq,OEORI_TimePOAuthorised</ConditionFields>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuthReq"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_DateAuthReq}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_TimeAuthReq}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBBExtCode">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BBExtCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_BBStatus}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_BBExtCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillPriceDat">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillPDat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_BillPriceDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDrStDtArr">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDrStDtArr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ConsultDr_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{OEORI_EpisArriveDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDrStDtPort">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDrStDtPort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ConsultDr_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$s({OEORI_PortEquipReq}["Y":1,1:0)</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCDrStDtPrior">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDrStDtPri"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ConsultDr_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Priority_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCdrStDtCover">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDrStDtCov"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ConsultDr_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$s({OEORI_CoverMainIns}["Y":1,1:0)</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCons">
<Condition>$$index^at122m({OEORI_ItmMast_DR},{OEORI_APPT_DR},{OEORI_RowId})=1</Condition>
<ConditionFields>OEORI_ItmMast_DR,OEORI_APPT_DR,OEORI_SttDat,OEORI_SttTim</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>(+{OEORI_SttDat})_","_(+{OEORI_SttTim})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsDoc">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ConsDocStDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ConsultDr_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexConsult">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Consult"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_Consult_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateExec">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateExecuted"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_DateExecuted}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateExecTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateExecTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_DateExecuted}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{OEORI_TimeExecuted}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDelDate">
<Condition>$$deliv^at122({OEORI_RowId})=1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DelDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_CollectionDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_ExpectedCollDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Priority_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepOrders">
<Condition>$$index^at122k({OEORI_ItmMast_DR},{OEORI_ItemStat_DR},{OEORI_Billed},{OEORI_RecDep_DR},{OEORI_SeqNo})=1</Condition>
<ConditionFields>OEORI_RecDep_DR,OEORI_SttDat</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>30</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_DateTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDiet">
<Condition>{OEORI_DietFlag}["Y"</Condition>
<ConditionFields>OEORI_SttDat,OEORI_SttTim,OEORI_DietFlag</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Diet"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_OrdEnt_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocStDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DocStDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_Doctor_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDocStDtTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CDrStDtTm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ConsultDr_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisode">
<Global>^OEORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EpisNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_LabEpisodeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisodeNotSent">
<Condition>$$epis^at122l({OEORI_LabEpisodeSetup},{OEORI_SeqNo})=1</Condition>
<ConditionFields>OEORI_LabEpisodeNo,OEORI_LabEpisodeSetup</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EpisPend"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_LabEpisodeNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFiller">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Filler"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_FillerNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_LabEpisodeNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFinRetDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FinRetDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_FinDate}+{OEORI_RetentionDays}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SeqNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFinishDateSeqNo">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FnDtSeqNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_FinDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SeqNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFullLabResult">
<Condition>$$index^at122g({OEORI_ItmMast_DR},{OEORI_SeqNo})=1</Condition>
<ConditionFields>OEORI_ItmMast_DR,OEORI_SeqNo</ConditionFields>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FLabResult"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ItemGroup}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHICClaim">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_HICClaimNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemGroup">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ItemGroup}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLabNotRead">
<Condition>{OEORI_LabTestSetRow}'="",'{OEORI_DateRead}</Condition>
<ConditionFields>OEORI_LabTestSetRow,OEORI_DateRead</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LabNotRead"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLabReadWeb">
<Condition>{OEORI_LabAction}'="",{OEORI_DateRead}</Condition>
<ConditionFields>OEORI_DateRead,OEORI_LabAction</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LabReadWeb"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLabTS">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LabTS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_LabTestSetRow}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDateExec">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDateExecTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_DateExecuted}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORI_TimeExecuted}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDateTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocStDtTm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocStDtArr">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocStDtArr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{OEORI_EpisArriveDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocStDtCov">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocStDtCov"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$s({OEORI_CoverMainIns}["Y":1,1:0)</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocStDtPort">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocStDtPort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$s({OEORI_PortEquipReq}["Y":1,1:0)</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocStDtPrior">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocStDtPr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Priority_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManuf">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Manuf"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ManufacturerOrder_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNotExec">
<Condition>$$index1^at122f({OEORI_ItmMast_DR},{OEORI_ItemStat_DR})=1</Condition>
<ConditionFields>OEORI_ItmMast_DR,OEORI_ItemStat_DR,OEORI_SttDat,OEORI_SttTim</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NotExec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOPER">
<Condition>$$index^at122l({OEORI_ItmMast_DR})=1</Condition>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOriginalOrder">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrigOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_OriginalOrder_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPathway">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ClinPathways_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPlacer">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PlacerNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_PlacerNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_LabEpisodeNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPortable">
<Condition>$$index^at122i({OEORI_RowId},{OEORI_ItmMast_DR},{OEORI_ItemStat_DR},{OEORI_Billed},{OEORI_RecDep_DR},{OEORI_SeqNo},{OEORI_PortEquipReq})=1</Condition>
<ConditionFields>OEORI_Billed,OEORI_RecDep_DR,OEORI_RowId</ConditionFields>
<Global>^OEORD</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Port"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_DateTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^OEORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrescNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrior">
<Condition>1</Condition>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Priority"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Priority_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRadStBlank">
<Condition>{OEORI_RadiologyStatus}=""</Condition>
<ConditionFields>OEORI_RecDep_DR,OEORI_SttDat,OEORI_RadiologyStatus</ConditionFields>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RadSt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_ItemStat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRadStatus">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RadSt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_RadiologyStatus}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDep">
<Condition>$$index^at122d({OEORI_RowId},{OEORI_ItmMast_DR},{OEORI_ItemStat_DR},{OEORI_Billed},{OEORI_RecDep_DR},{OEORI_SeqNo})=1</Condition>
<ConditionFields>OEORI_Billed,OEORI_RecDep_DR,OEORI_RowId,OEORI_ItemStat_DR</ConditionFields>
<Global>^OEORD</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_PRN}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDep1">
<Condition>$$index1^at122d({OEORI_RowId},{OEORI_ItmMast_DR},{OEORI_ItemStat_DR},{OEORI_Billed},{OEORI_RecDep_DR},{OEORI_SeqNo})</Condition>
<ConditionFields>OEORI_Billed,OEORI_RecDep_DR,OEORI_ItemStat_DR,OEORI_OrdDept_DR</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDep1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_OrdDept_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_DateTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDep2">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDep2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_PRN}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDep3">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDep3"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDepDateTime">
<Condition>$$index1^at122d({OEORI_RowId},{OEORI_ItmMast_DR},{OEORI_ItemStat_DR},{OEORI_Billed},{OEORI_RecDep_DR},{OEORI_SeqNo})</Condition>
<ConditionFields>OEORI_Billed,OEORI_RecDep_DR,OEORI_RowId,OEORI_ItemStat_DR</ConditionFields>
<Global>^OEORD</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDepDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_DateTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDepOrd">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDepOrd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDepOrdDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDepOrdDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDepRes">
<Condition>$$index^at122f({OEORI_RowId},{OEORI_ItmMast_DR},{OEORI_ItemStat_DR},{OEORI_Billed},{OEORI_RecDep_DR},{OEORI_SeqNo})=1</Condition>
<ConditionFields>OEORI_Billed,OEORI_RecDep_DR,OEORI_RowId,OEORI_ItemStat_DR</ConditionFields>
<Global>^OEORD</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecDepRes"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OEORI_ResultFlag}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OEORI_PRN}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDepResDateTime">
<Condition>$$index^at122f({OEORI_RowId},{OEORI_ItmMast_DR},{OEORI_ItemStat_DR},{OEORI_Billed},{OEORI_RecDep_DR},{OEORI_SeqNo})=1</Condition>
<ConditionFields>OEORI_Billed,OEORI_RecDep_DR,OEORI_RowId,OEORI_ItemStat_DR</ConditionFields>
<Global>^OEORD</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecDepResDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OEORI_ResultFlag}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>(+{OEORI_SttDat})_","_(+{OEORI_SttTim})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDepStartDateTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDepStartDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResRef">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResRef"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({OEORI_ResultRef})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResStDateTime">
<Condition>" A  "'[(" "_{OEORI_ResultFlag}_" ")+({OEORI_ResultExist}'="")</Condition>
<ConditionFields>OEORI_ResultExist,OEORI_ResultFlag,OEORI_SttDat,OEORI_SttTim</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResStDtTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StDt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStDateStTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StDtTm1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStDateStatus">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StDtStat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_ItemStat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStDtTm1Loc">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StDtTm1Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_RecDep_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="6">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDateSeqNo">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StDtSeqNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SeqNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartdateTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StDtTm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatStDtTm1">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatStDtTm1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Categ_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_ItemStat_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_SttDat}</Expression>
</Subscript>
<Subscript name="7">
<Expression>+{OEORI_SttTim}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexToBill">
<Condition>" TB TR "[(" "_$p({OEORI_Billed},$c(1))_" ")</Condition>
<ConditionFields>OEORI_Billed</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ToBill"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWL">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_WaitList_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexXDate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"XDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_XDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexXDateTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"XDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_XDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_XTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="LabNotReadWeb">
<Condition>{OEORI_LabAction}'="",'{OEORI_DateRead}</Condition>
<ConditionFields>OEORI_DateRead,OEORI_LabAction</ConditionFields>
<Global>^OEORDi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LabNotReadWeb"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="OEORIDataMasterMap">
<Data name="OEORI_APPT_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_ARPBLItem_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_Abnormal">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_AccessionNumber">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORI_Action_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORI_Activity">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>28</Piece>
</Data>
<Data name="OEORI_AdmInsurance_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>24</Piece>
</Data>
<Data name="OEORI_AdmLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_AdminRoute_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_AdministerSkinTest">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_AlertReason_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_AllergyReason_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORI_AnaOper_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_AnaestAgent_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>50</Piece>
</Data>
<Data name="OEORI_Anaest_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_Annotation_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>37</Piece>
</Data>
<Data name="OEORI_Assistant_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_AuthComments">
<Node>"AUTH"</Node>
</Data>
<Data name="OEORI_AuthoriseClinician_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>53</Piece>
</Data>
<Data name="OEORI_AuthorisedDate">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_AuthorisedTime">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORI_AutologousBloodReq">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_BBExtCode">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_BBStatus">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORI_BBTAG1">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_BBTAG2">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_BBTAG3">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_BBTAG4">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_BBTAG5">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_BillDesc">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_BillPriceDate">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_BillPriceTime">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_Billed">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_BodySite_DR">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_CancelReason_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_Carbohydrate">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_ClinPathways_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORI_ClinicallySignificant">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>48</Piece>
</Data>
<Data name="OEORI_CollectedBy">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>26</Piece>
</Data>
<Data name="OEORI_CollectionDep_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_Comment1">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>56</Piece>
</Data>
<Data name="OEORI_Comment2">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>57</Piece>
</Data>
<Data name="OEORI_Comment3">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>58</Piece>
</Data>
<Data name="OEORI_CompXMatchReq">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_ConsCateg_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_ConsultDep_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_ConsultDr_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORI_Consult_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>36</Piece>
</Data>
<Data name="OEORI_ContOrderAfterDischarge">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>50</Piece>
</Data>
<Data name="OEORI_ContactCareProv">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_ContrastBatchNumber">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_ContrastExpiryDate">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_ContrastType_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_ContrastVolume">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_Cost">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_CoverMainIns">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_CurrRepeatNumber">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>35</Piece>
</Data>
<Data name="OEORI_CurrSampleExpiry">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_DRCross_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_DRGOrder">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>30</Piece>
</Data>
<Data name="OEORI_Date">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_DateAuthReq">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>48</Piece>
</Data>
<Data name="OEORI_DateExecuted">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_DatePOAuthorised">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>46</Piece>
</Data>
<Data name="OEORI_DateRead">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_DateUnRead">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>44</Piece>
</Data>
<Data name="OEORI_DayBookAccessionNo">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>40</Piece>
</Data>
<Data name="OEORI_DayBookSpecimen">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>41</Piece>
</Data>
<Data name="OEORI_DayOfCycle">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_DelayMeal">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_DemandNumber">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>61</Piece>
</Data>
<Data name="OEORI_DepProcNotes">
<Node>"DEP"</Node>
</Data>
<Data name="OEORI_DepType">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_DietFlag">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>27</Piece>
</Data>
<Data name="OEORI_DiscountAmt">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_DiscountDate">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_DiscountDoctor_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_DiscountPerc">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_DiscountReason">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_DiscountTime">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_DispensingTimes">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_DoctorExecuted_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_Dosage_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_DoseQty">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_Durat_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_EligibilityStatus">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>61</Piece>
</Data>
<Data name="OEORI_EndDate">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_EndTime">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_Energy_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_EpisArriveDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_EpisArriveTime">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_ExamAbandonReason_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>52</Piece>
</Data>
<Data name="OEORI_ExamStartTime">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_ExpectedCollDate">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_ExpectedCollTime">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>23</Piece>
</Data>
<Data name="OEORI_ExposureKV">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_Exposure_mAs">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_ExternalPrimarySpecSite">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>64</Piece>
</Data>
<Data name="OEORI_ExternalRefDoctor_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>66</Piece>
</Data>
<Data name="OEORI_ExternalSecondarySpecSite">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>65</Piece>
</Data>
<Data name="OEORI_Fat">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_FillerNo">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_FilmReasonForRejection_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_FlowQty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORI_FlowRateUnit_DR">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_FreqDelay">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_HICClaimNo">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_HL7ResultDate">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_HL7ResultStatus">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_HL7ResultTime">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_HotReportRequired">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORI_ImplantType_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>25</Piece>
</Data>
<Data name="OEORI_IncompleteCollection">
<Node>"INC"</Node>
</Data>
<Data name="OEORI_IndicTransfusion_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>47</Piece>
</Data>
<Data name="OEORI_InjectionTime">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_InsBillCondit_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_InsertDate">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORI_InsertTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORI_Instr_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_Interval_DR">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_IsotopeDose">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORI_ItemGroup">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_ItemStat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_LDMP">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_LMPDate">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_LTSiteCode">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>40</Piece>
</Data>
<Data name="OEORI_LTSpecCode">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>39</Piece>
</Data>
<Data name="OEORI_Lab1">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_Lab2">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_LabAction">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>23</Piece>
</Data>
<Data name="OEORI_LabEpisodeNo">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORI_LabEpisodeSetup">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORI_LabReceiveDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>28</Piece>
</Data>
<Data name="OEORI_LabReceiveTime">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>29</Piece>
</Data>
<Data name="OEORI_LabSeqNo">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>25</Piece>
</Data>
<Data name="OEORI_LabTestSetRow">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>35</Piece>
</Data>
<Data name="OEORI_LabVolume">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>24</Piece>
</Data>
<Data name="OEORI_LabelText">
<Node>"LABT"</Node>
</Data>
<Data name="OEORI_LinkNo">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_LinkToOrder">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_LtClinicalCondition">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_MainOeEnt_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_ManufacturerOrder_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>68</Piece>
</Data>
<Data name="OEORI_MaxNumberOfRepeats">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_MaxRepeats">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>34</Piece>
</Data>
<Data name="OEORI_MealType_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_NeedleGauge_DR">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_NeedleType_DR">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_NoConsentOverrideReas_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_NoOrderedBags">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_NoOrdersLink">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>28</Piece>
</Data>
<Data name="OEORI_Notify">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>54</Piece>
</Data>
<Data name="OEORI_NotifyClinician">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>55</Piece>
</Data>
<Data name="OEORI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>39</Piece>
</Data>
<Data name="OEORI_OperCategory_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_OrdDept_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_OrdEnt_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_OrderType_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_OriginalOrder_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>51</Piece>
</Data>
<Data name="OEORI_PACClinic_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>56</Piece>
</Data>
<Data name="OEORI_PHFreq_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_PRN">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_PRNIndication">
<Node>"PRNIND"</Node>
</Data>
<Data name="OEORI_PRNMaxDose24hrs">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_PRNTotNumberDosesAll">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_PackOverReason_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>42</Piece>
</Data>
<Data name="OEORI_PasterizeFood">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_PatConsentObtained">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_PatientIDChecked">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_PendingStatus_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>52</Piece>
</Data>
<Data name="OEORI_PersonInject_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_Personnel">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>55</Piece>
</Data>
<Data name="OEORI_PhQtyOrd">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_PhSpecInstr">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_PharmacyStatus">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_PhoneOrder">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>44</Piece>
</Data>
<Data name="OEORI_PlacerNo">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>36</Piece>
</Data>
<Data name="OEORI_PortEquipReq">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_PostExamStartTime">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>46</Piece>
</Data>
<Data name="OEORI_PostExamUser">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORI_PostExamUserHospDR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>30</Piece>
</Data>
<Data name="OEORI_PreExamUser">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_PreExamUserHospDR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>31</Piece>
</Data>
<Data name="OEORI_PregnancyCheck">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_Pregnant">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_PreparationTime">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>54</Piece>
</Data>
<Data name="OEORI_PrescNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_PrescRepExpiryDate">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>32</Piece>
</Data>
<Data name="OEORI_PrescRepNumberDays">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>33</Piece>
</Data>
<Data name="OEORI_PrescSeqNo">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_PrescType">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_Price">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>25</Piece>
</Data>
<Data name="OEORI_Priority_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_ProsBatchNo">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORI_ProsReceivedDate">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_ProsReceivedTime">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORI_ProsSerialNo">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORI_ProsSupplier">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORI_Protein">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_Qty">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_QtyPackUOM">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_Questionnaire">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_RBResource_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_RMDurat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_RMFreq_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_RVICharge_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_RadiationDoesUnit_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>59</Piece>
</Data>
<Data name="OEORI_RadiologyStatus">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>62</Piece>
</Data>
<Data name="OEORI_ReadyToBill">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>26</Piece>
</Data>
<Data name="OEORI_ReasOrdCMVNegBlood">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_ReasonNotCollected">
<Node>"RNCOLL"</Node>
</Data>
<Data name="OEORI_ReasonRefund_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>30</Piece>
</Data>
<Data name="OEORI_ReasonRejectPresc_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>60</Piece>
</Data>
<Data name="OEORI_RecDep_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_RecLocVerified">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>62</Piece>
</Data>
<Data name="OEORI_RefCln_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_RefDoc_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORI_RefundQty">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>23</Piece>
</Data>
<Data name="OEORI_RefundType">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>27</Piece>
</Data>
<Data name="OEORI_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="OEORI_ResultAvailable">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>63</Piece>
</Data>
<Data name="OEORI_ResultAvailableDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>67</Piece>
</Data>
<Data name="OEORI_ResultComments">
<Node>"RC"</Node>
</Data>
<Data name="OEORI_ResultDSReportFlag">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>31</Piece>
</Data>
<Data name="OEORI_ResultExist">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>53</Piece>
</Data>
<Data name="OEORI_ResultFlag">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_ResultGroup">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORI_ResultRef">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORI_ResultUpdateDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>57</Piece>
</Data>
<Data name="OEORI_ResultUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>60</Piece>
</Data>
<Data name="OEORI_ResultUpdateTime">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>58</Piece>
</Data>
<Data name="OEORI_ResultUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>59</Piece>
</Data>
<Data name="OEORI_RetentionDays">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>41</Piece>
</Data>
<Data name="OEORI_ReturnDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>36</Piece>
</Data>
<Data name="OEORI_ReturnTime">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>37</Piece>
</Data>
<Data name="OEORI_ReturnToStock">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>32</Piece>
</Data>
<Data name="OEORI_ReturnUser_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>38</Piece>
</Data>
<Data name="OEORI_RiceType_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_Route_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>51</Piece>
</Data>
<Data name="OEORI_ScreeningTime">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_SecondOrderingUser_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>45</Piece>
</Data>
<Data name="OEORI_SensitivitiesSignoff">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>49</Piece>
</Data>
<Data name="OEORI_SentInExtract">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>26</Piece>
</Data>
<Data name="OEORI_SeqNo">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_SeriesNo">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>27</Piece>
</Data>
<Data name="OEORI_Size">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>24</Piece>
</Data>
<Data name="OEORI_SkinTestOutcome_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>38</Piece>
</Data>
<Data name="OEORI_Specialty_DR">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_SpeedFlowRate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_SpeedFlowValue">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_SterilizeUtelsis">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_StockBatches">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_SttDat">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_SttTim">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_SupplierContactedDate">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_SupplierContactedTime">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_TestSetComments">
<Node>"TS"</Node>
</Data>
<Data name="OEORI_TheatreDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>35</Piece>
</Data>
<Data name="OEORI_TheatreRequired">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>34</Piece>
</Data>
<Data name="OEORI_Time">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_TimeAuthReq">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>49</Piece>
</Data>
<Data name="OEORI_TimeExecuted">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_TimeOrd">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_TimePOAuthorised">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>47</Piece>
</Data>
<Data name="OEORI_TimeRead">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_TimeUnread">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>45</Piece>
</Data>
<Data name="OEORI_TypeSizeOfFilmsRejected_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_Type_SizeOfFilmsUsed_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_Unit">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_UnitCost">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_Unit_DR">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_Unit_Hrs">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_UnitsCollected">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>42</Piece>
</Data>
<Data name="OEORI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_UrgentReport">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>43</Piece>
</Data>
<Data name="OEORI_UserAdd">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_UserAddHospDR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>33</Piece>
</Data>
<Data name="OEORI_UserAuthorise">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_UserAuthoriseHospDR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>32</Piece>
</Data>
<Data name="OEORI_UserDepartment_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_UserExecuted">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_UserRead_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_UserUnRead_DR">
<Delimiter>"^"</Delimiter>
<Node>11</Node>
<Piece>43</Piece>
</Data>
<Data name="OEORI_UserUpdate">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_VarianceReason_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_View">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>29</Piece>
</Data>
<Data name="OEORI_Volume_DR">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_WaitList_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>23</Piece>
</Data>
<Data name="OEORI_WeeksPregnant">
<Delimiter>"^"</Delimiter>
<Node>12</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_WhoGoWhere">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_XCTCP_DR">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>29</Piece>
</Data>
<Data name="OEORI_XDate">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>34</Piece>
</Data>
<Data name="OEORI_XTime">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>15</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OEORI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEORI_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
