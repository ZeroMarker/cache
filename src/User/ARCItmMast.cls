/// ARC Item Master         (ARCIM,115)
Class User.ARCItmMast Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ARC_ItmMast, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (ARCIMSubscript, ARCIMVersion) [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCItemSupportDoc As ARCItemSupportDoc [ Cardinality = children, Inverse = SUPDParRef ];

Relationship ChildARCItemInsurTypeCost As ARCItemInsurTypeCost [ Cardinality = children, Inverse = COSTParRef ];

Relationship ChildARCItemQtyAllowed As ARCItemQtyAllowed [ Cardinality = children, Inverse = QTYALParRef ];

Relationship ChildARCItemCost As ARCItemCost [ Cardinality = children, Inverse = ITCOSTParRef ];

Relationship ChildARCItemPriceItaly As ARCItemPriceItaly [ Cardinality = children, Inverse = ITPParRef ];

Relationship ChildARCItemExternalCodes As ARCItemExternalCodes [ Cardinality = children, Inverse = EXTParRef ];

Relationship ChildARCItemDelivTimeRes As ARCItemDelivTimeRes [ Cardinality = children, Inverse = DTRParRef ];

Relationship ChildARCItemMessage As ARCItemMessage [ Cardinality = children, Inverse = MESSParRef ];

Relationship ChildARCItemGeneric As ARCItemGeneric [ Cardinality = children, Inverse = GENParRef ];

Relationship ChildARCItemEpisodicBilling As ARCItemEpisodicBilling [ Cardinality = children, Inverse = EPParRef ];

Relationship ChildARCItemSpecimen As ARCItemSpecimen [ Cardinality = children, Inverse = SPECParRef ];

Relationship ChildARCItemQuestion As ARCItemQuestion [ Cardinality = children, Inverse = QUESParRef ];

Relationship ChildARCItemAgeSexRestriction As ARCItemAgeSexRestriction [ Cardinality = children, Inverse = AGEParRef ];

Relationship ChildARCItemDietModifier As ARCItemDietModifier [ Cardinality = children, Inverse = DMParRef ];

Relationship ChildARCItemResults As ARCItemResults [ Cardinality = children, Inverse = RESParRef ];

Relationship ChildARCItemDepartOverride As ARCItemDepartOverride [ Cardinality = children, Inverse = DOVParRef ];

Relationship ChildARCItemAllergy As ARCItemAllergy [ Cardinality = children, Inverse = ALGParRef ];

Relationship ChildARCItemDependent As ARCItemDependent [ Cardinality = children, Inverse = DEPParRef ];

Relationship ChildARCItemNationalCode As ARCItemNationalCode [ Cardinality = children, Inverse = NCParRef ];

Relationship ChildARCItemHosp As ARCItemHosp [ Cardinality = children, Inverse = HOSPParRef ];

Relationship ChildARCItemPregnBrfeedAlert As ARCItemPregnBrfeedAlert [ Cardinality = children, Inverse = PBAParRef ];

/// Charge Code
Property ARCIMCode As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = ARCIM_Code ];

/// Description
Property ARCIMDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = ARCIM_Desc ];

/// Description
Property ARCIMAbbrev As %String(COLLATION = "AlphaUp", MAXLEN = 80, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlComputeCode = { s {ARCIM_Abbrev}=$S($g({ARCIM_Abbrev})="":$e({ARCIM_Desc},1,20),1:$g({ARCIM_Abbrev}))
}, SqlComputed, SqlComputeOnChange = ARCIMDesc, SqlFieldName = ARCIM_Abbrev ];

/// Des Ref to CTUOM
Property ARCIMUOMDR As CTUOM [ SqlColumnNumber = 5, SqlFieldName = ARCIM_UOM_DR ];

/// Minimum Amount
Property ARCIMMinAmt As %Float(MAXVAL = 999999, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = ARCIM_MinAmt ];

/// Maximum Amount
Property ARCIMMaxAmt As %Float(MAXVAL = 999999, MINVAL = 0) [ SqlColumnNumber = 7, SqlFieldName = ARCIM_MaxAmt ];

/// Charge Unit Factor
Property ARCIMChgUnitFact As %Float(MAXVAL = 999999, MINVAL = .01) [ InitialExpression = 1, SqlColumnNumber = 8, SqlFieldName = ARCIM_ChgUnitFact ];

/// Des Ref to ARCIC
Property ARCIMItemCatDR As ARCItemCat [ SqlColumnNumber = 9, SqlFieldName = ARCIM_ItemCat_DR ];

/// Unit Cost
Property ARCIMChgCost As %Float(MAXVAL = 999999, MINVAL = 0) [ SqlColumnNumber = 10, SqlFieldName = ARCIM_ChgCost ];

/// Minimum Amount
Property ARCIMChgMinAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 11, SqlFieldName = ARCIM_ChgMinAmt ];

/// Maximum Amount
Property ARCIMChgMaxAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 12, SqlFieldName = ARCIM_ChgMaxAmt ];

/// Standard Amount
Property ARCIMStdAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 13, SqlFieldName = ARCIM_StdAmt ];

/// Type A Amount
Property ARCIMTypeAAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 17, SqlFieldName = ARCIM_TypeAAmt ];

/// Type B Amount
Property ARCIMTypeBAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 18, SqlFieldName = ARCIM_TypeBAmt ];

/// Price Control Flag
Property ARCIMChgDispFlg As %String(DISPLAYLIST = ",Input,Display", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",I,D") [ InitialExpression = "I", SqlColumnNumber = 23, SqlFieldName = ARCIM_ChgDispFlg ];

/// Charge Posting Flag
Property ARCIMChgPostFlg As %String(DISPLAYLIST = ",Upon Order Entry,Upon execution", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",O,E") [ InitialExpression = "O", SqlColumnNumber = 24, SqlFieldName = ARCIM_ChgPostFlg ];

/// Time Dependent Flag
Property ARCIMTimeDepFlg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = ARCIM_TimeDepFlg ];

/// Period 1 Charge Factor
Property ARCIMP1ChgFact As %Float(MAXVAL = 999999999, MINVAL = .01) [ SqlColumnNumber = 26, SqlFieldName = ARCIM_P1ChgFact ];

/// Period 1 Standard Additional Amount
Property ARCIMP1StdAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 27, SqlFieldName = ARCIM_P1StdAddAmt ];

/// Period 1 Type A Additional Amount
Property ARCIMP1TypAAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 28, SqlFieldName = ARCIM_P1TypAAddAmt ];

/// Period 1 Type B Additional Amount
Property ARCIMP1TypBAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 29, SqlFieldName = ARCIM_P1TypBAddAmt ];

/// Period 2 Charge Factor
Property ARCIMP2ChgFact As %Float(MAXVAL = 999999999, MINVAL = .01) [ SqlColumnNumber = 30, SqlFieldName = ARCIM_P2ChgFact ];

/// Period 2 Standard Additional Amount
Property ARCIMP2StdAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 31, SqlFieldName = ARCIM_P2StdAddAmt ];

/// Period 2 Type A Additional Amount
Property ARCIMP2TypAAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 32, SqlFieldName = ARCIM_P2TypAAddAmt ];

/// Period 2 Type B Additional Amount
Property ARCIMP2TypBAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 33, SqlFieldName = ARCIM_P2TypBAddAmt ];

/// Period 3 Charge Factor
Property ARCIMP3ChgFact As %Float(MAXVAL = 999999999, MINVAL = .01) [ SqlColumnNumber = 34, SqlFieldName = ARCIM_P3ChgFact ];

/// Period 3 Standard Additional Amount
Property ARCIMP3StdAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 35, SqlFieldName = ARCIM_P3StdAddAmt ];

/// Period 3 Type A Additional Amount
Property ARCIMP3TypAAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 36, SqlFieldName = ARCIM_P3TypAAddAmt ];

/// Period 3 Type B Additional Amount
Property ARCIMP3TypBAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 37, SqlFieldName = ARCIM_P3TypBAddAmt ];

/// Period 4 Charge Factor
Property ARCIMP4ChgFact As %Float(MAXVAL = 999999999, MINVAL = .01) [ SqlColumnNumber = 38, SqlFieldName = ARCIM_P4ChgFact ];

/// Period 4 Standard Additional Amount
Property ARCIMP4StdAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 39, SqlFieldName = ARCIM_P4StdAddAmt ];

/// Period 4 Type A Additional Amount
Property ARCIMP4TypAAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 40, SqlFieldName = ARCIM_P4TypAAddAmt ];

/// Period 4 Type B Additional Amount
Property ARCIMP4TypBAddAmt As %Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 41, SqlFieldName = ARCIM_P4TypBAddAmt ];

/// Des Ref to ARCSC
Property ARCIMServCatDR As ARCServCat [ SqlColumnNumber = 42, SqlFieldName = ARCIM_ServCat_DR ];

/// Profile Flag
Property ARCIMProfileFlg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 43, SqlFieldName = ARCIM_ProfileFlg ];

/// Ancillary Master Flag
Property ARCIMSubMasFlg As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 44, SqlFieldName = ARCIM_SubMasFlg ];

/// Des Ref to ARCSG
Property ARCIMBillSubDR As ARCBillSub [ Required, SqlColumnNumber = 47, SqlFieldName = ARCIM_BillSub_DR ];

/// Des Ref to ARCST
Property ARCIMServTaxDR As ARCServTax [ SqlColumnNumber = 48, SqlFieldName = ARCIM_ServTax_DR ];

/// Dose Type
Property ARCIMDoseType As %String(DISPLAYLIST = ",One Dose,Daily Dose,Unit Dose", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",O,D,U") [ SqlColumnNumber = 50, SqlFieldName = ARCIM_DoseType ];

/// Des Ref to PHCDF
Property ARCIMPHCDFDR As PHCDrgForm [ SqlColumnNumber = 51, SqlFieldName = ARCIM_PHCDF_DR ];

/// Version
Property ARCIMVersion As %Float [ InitialExpression = 1, SqlColumnNumber = 54, SqlFieldName = ARCIM_Version ];

/// Current Version
Property ARCIMCurVersDR As ARCItmMast [ SqlColumnNumber = 55, SqlComputeCode = { s {ARCIM_CurVers_DR}=$$CO55^at115({ARCIM_Subscript})
}, SqlComputed, SqlFieldName = ARCIM_CurVers_DR, Transient ];

/// Current Version Flag
Property ARCIMCurVerFlg As %String(COLLATION = "Exact", MAXLEN = 7, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlComputeCode = { S {ARCIM_CurVerFlg}=$$CURVER^at115({ARCIM_CurVers_DR},{ARCIM_RowId})
}, SqlComputed, SqlFieldName = ARCIM_CurVerFlg, Transient ];

/// Effective Date
Property ARCIMEffDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 58, SqlFieldName = ARCIM_EffDate ];

/// Effective Time
Property ARCIMEffTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 59, SqlFieldName = ARCIM_EffTime ];

/// Effective Date / Time
Property ARCIMEffDateTime As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 60, SqlComputeCode = { s {ARCIM_EffDateTime}=$p({ARCIM_EffDate},$c(1))_"Z"_$p({ARCIM_EffTime},$c(1))
}, SqlComputed, SqlComputeOnChange = (ARCIMEffDate, ARCIMEffTime), SqlFieldName = ARCIM_EffDateTime ];

/// ARCIM Subscript
Property ARCIMSubscript As %Numeric(SCALE = 0) [ InitialExpression = {$i(^ARCIM(0))}, Required, SqlColumnNumber = 62, SqlFieldName = ARCIM_Subscript ];

/// Revenue Posting To Ordering Department
Property ARCIMGLPostToOrderDept As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 65, SqlFieldName = ARCIM_GLPostToOrderDept ];

/// RVP Follow-up Days
Property ARCIMRvpFud As %Float(MINVAL = 0) [ SqlColumnNumber = 66, SqlFieldName = ARCIM_RvpFud ];

/// RVP Anesthesia Unit Value
Property ARCIMRvpAnes As %Float(MINVAL = 0) [ SqlColumnNumber = 67, SqlFieldName = ARCIM_RvpAnes ];

/// RVP Unit Status
Property ARCIMRvpUnitStat As %String(DISPLAYLIST = ",Interim,By Report,Relativity Not Established", MAXLEN = 26, TRUNCATE = 1, VALUELIST = ",I,BR,RNE") [ SqlColumnNumber = 68, SqlFieldName = ARCIM_RvpUnitStat ];

/// RVP Update
Property ARCIMRvpUpd As %String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 1) [ SqlColumnNumber = 69, SqlFieldName = ARCIM_RvpUpd ];

/// RVP Date Stamped Value
Property ARCIMRvpInterimYear As %Float(MAXVAL = 9999, MINVAL = 0) [ SqlColumnNumber = 70, SqlFieldName = ARCIM_RvpInterimYear ];

/// Insurance Company Description
Property ARCIMInsCoDesc As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 71, SqlFieldName = ARCIM_InsCoDesc ];

/// Des Ref to ARC_InsSubCat
Property ARCIMInsSubCatDR As ARCInsuranceSubcategory [ SqlColumnNumber = 72, SqlFieldName = ARCIM_InsSubCat_DR ];

/// Effective Date To
Property ARCIMEffDateTo As %Date [ SqlColumnNumber = 73, SqlFieldName = ARCIM_EffDateTo ];

/// Des Ref to ARC_Surcharge
Property ARCIMSurchargeDR As ARCSurchargeCode [ SqlColumnNumber = 74, SqlFieldName = ARCIM_Surcharge_DR ];

/// Ointment
Property ARCIMOintment As %Float [ SqlColumnNumber = 75, SqlFieldName = ARCIM_Ointment ];

/// Service/Material
Property ARCIMServMaterial As %String(DISPLAYLIST = ",Service,Material", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",S,M") [ SqlColumnNumber = 76, SqlFieldName = ARCIM_ServMaterial ];

/// Haemodalisys Flag
Property ARCIMHaemodal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 77, SqlFieldName = ARCIM_Haemodal ];

/// CAPD Flag
Property ARCIMCAPD As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 78, SqlFieldName = ARCIM_CAPD ];

/// Kidney Transplant Flag
Property ARCIMKidneyTransp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 79, SqlFieldName = ARCIM_KidneyTransp ];

/// Des Ref Billing Body Parts
Property ARCIMBillBodyPDR As ARCBillBodyParts [ SqlColumnNumber = 80, SqlFieldName = ARCIM_BillBodyP_DR ];

/// Order Entry Message
Property ARCIMOEMessage As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 81, SqlFieldName = ARCIM_OEMessage, SqlListType = SUBNODE ];

/// Des REf to IncSource
Property ARCIMIncSourceDR As ARCIncomeSource [ SqlColumnNumber = 82, SqlFieldName = ARCIM_IncSource_DR ];

/// Order On Its Own
Property ARCIMOrderOnItsOwn As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 83, SqlFieldName = ARCIM_OrderOnItsOwn ];

/// Visible In Order List
Property ARCIMVisibleInOrderList As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 84, SqlFieldName = ARCIM_VisibleInOrderList ];

/// Manufactured
Property ARCIMManufactured As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 85, SqlComputeCode = { s {ARCIM_Manufactured}=$$CO85^at115({ARCIM_RowId})
}, SqlComputed, SqlFieldName = ARCIM_Manufactured, Transient ];

/// Charge Partial
Property ARCIMChargePartial As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 86, SqlFieldName = ARCIM_ChargePartial ];

/// Snack Flag
Property ARCIMSnackFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 87, SqlFieldName = ARCIM_SnackFlag ];

/// Des Ref RiceTyp
Property ARCIMRiceTypeDR As DTCRiceType [ SqlColumnNumber = 88, SqlFieldName = ARCIM_RiceType_DR ];

/// Update Date
Property ARCIMUpdateDate As %Date [ SqlColumnNumber = 89, SqlFieldName = ARCIM_UpdateDate ];

/// Update Time
Property ARCIMUpdateTime As %Time [ SqlColumnNumber = 90, SqlFieldName = ARCIM_UpdateTime ];

/// Update User
Property ARCIMUpdateUser As SSUser [ SqlColumnNumber = 91, SqlFieldName = ARCIM_UpdateUser ];

/// Default Consultation Department
Property ARCIMConsultDept As CTLoc [ SqlColumnNumber = 92, SqlFieldName = ARCIM_ConsultDept ];

/// Single Fee
Property ARCIMSingleFee As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 93, SqlFieldName = ARCIM_SingleFee ];

/// Row_Calc
Property ARCIMRowCalc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 94, SqlComputeCode = { s {ARCIM_Row_Calc}={ARCIM_Subscript}_"||"_{ARCIM_Version}
}, SqlComputed, SqlFieldName = ARCIM_Row_Calc, Transient ];

/// ARCIM_Type_Calc
Property ARCIMTypeCalc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 95, SqlComputeCode = { s {ARCIM_Type_Calc}="ARCIM"
}, SqlComputed, SqlFieldName = ARCIM_Type_Calc, Transient ];

/// Des Ref MealType
Property ARCIMMealTypeDR As DTCMealType [ SqlColumnNumber = 96, SqlFieldName = ARCIM_MealType_DR ];

/// Des Ref Service Group
Property ARCIMServiceGroupDR As RBCServiceGroup [ SqlColumnNumber = 97, SqlFieldName = ARCIM_ServiceGroup_DR ];

/// Minutes
Property ARCIMMinutes As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 98, SqlFieldName = ARCIM_Minutes ];

/// Days
Property ARCIMDays As %Float [ SqlColumnNumber = 99, SqlFieldName = ARCIM_Days ];

/// Allow to Order Without Stock Check
Property ARCIMAllowOrderWOStockCheck As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 102, SqlFieldName = ARCIM_AllowOrderWOStockCheck ];

/// Bill Description
Property ARCIMBillDescription As %String(DISPLAYLIST = ",Description Only,Processing Notes Only,Description and Processing Notes", MAXLEN = 32, TRUNCATE = 1, VALUELIST = ",D,P,B") [ SqlColumnNumber = 103, SqlFieldName = ARCIM_BillDescription ];

/// Price and Cost On Ordering
Property ARCIMPriceCostOnOrdering As %String(DISPLAYLIST = ",Inform Cost on Ordering,Inform Price and Cost on Ordering,No Value", MAXLEN = 33, TRUNCATE = 1, VALUELIST = ",C,P,N") [ SqlColumnNumber = 104, SqlFieldName = ARCIM_PriceCostOnOrdering ];

/// Des Ref UOM
Property ARCIMBillingUOMDR As CTUOM [ SqlColumnNumber = 105, SqlFieldName = ARCIM_BillingUOM_DR ];

/// Word Template
Property ARCIMWordTemplate As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 106, SqlFieldName = ARCIM_WordTemplate ];

/// Des Ref RMDuration
Property ARCIMRMDurationDR As PHCDuration [ SqlColumnNumber = 107, SqlFieldName = ARCIM_RMDuration_DR ];

/// Des Ref RMFrequency
Property ARCIMRMFrequencyDR As PHCFreq [ SqlColumnNumber = 108, SqlFieldName = ARCIM_RMFrequency_DR ];

/// Derived Fee Item
Property ARCIMDerivedFeeItem As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 109, SqlFieldName = ARCIM_DerivedFeeItem ];

/// DerFeeRules
Property ARCIMDerFeeRulesDR As ARCDerivedFeeRules [ SqlColumnNumber = 110, SqlFieldName = ARCIM_DerFeeRules_DR ];

/// Des Ref Generic
Property ARCIMGenericDR As PHCGeneric [ SqlColumnNumber = 111, SqlFieldName = ARCIM_Generic_DR ];

/// Generic Description
Property ARCIMGenericDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 112, SqlFieldName = ARCIM_GenericDesc ];

/// Des Ref DefPriority
Property ARCIMDefPriorityDR As OECPriority [ SqlColumnNumber = 113, SqlFieldName = ARCIM_DefPriority_DR ];

/// ShortDesc
Property ARCIMShortDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 114, SqlComputeCode = { s {ARCIM_ShortDesc}=$$CO114^at115({ARCIM_Desc})
}, SqlComputed, SqlFieldName = ARCIM_ShortDesc, Transient ];

/// Range From
Property ARCIMRangeFrom As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 115, SqlFieldName = ARCIM_RangeFrom ];

/// Range To
Property ARCIMRangeTo As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 116, SqlFieldName = ARCIM_RangeTo ];

/// Result Group
Property ARCIMResultGroup As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 117, SqlFieldName = ARCIM_ResultGroup ];

/// Des Ref PayorICDGroup
Property ARCIMPayorICDGroupDR As MRCPayorICDGroup [ SqlColumnNumber = 118, SqlFieldName = ARCIM_PayorICDGroup_DR ];

/// File Name for patient Notes
Property ARCIMFileNotes As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 119, SqlFieldName = ARCIM_FileNotes ];

/// RB Notes
Property ARCIMRBNotes As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 120, SqlFieldName = ARCIM_RBNotes, SqlListType = SUBNODE ];

/// Use ODBC for Word
Property ARCIMUseODBCforWord As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 121, SqlFieldName = ARCIM_UseODBCforWord ];

/// Des REf Questionnaire
Property ARCIMQuestionnaireDR As SSUserDefWindow [ SqlColumnNumber = 122, SqlFieldName = ARCIM_Questionnaire_DR ];

/// Number of Days to CheckDuplicate
Property ARCIMDaysCheckDuplicate As %Float [ SqlColumnNumber = 123, SqlFieldName = ARCIM_DaysCheckDuplicate ];

/// Dose Calc Formula
Property ARCIMDoseCalcFormula As %String(DISPLAYLIST = ",Boyd,Gehan and George,Mosteller,Haycock,Du Bois and Du Bois,Calvert", MAXLEN = 19, TRUNCATE = 1, VALUELIST = ",B,G,M,H,D,C") [ SqlColumnNumber = 124, SqlFieldName = ARCIM_DoseCalcFormula ];

/// Question Mandatory
Property ARCIMQuesMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 125, SqlFieldName = ARCIM_QuesMandatory ];

/// Observation Group DR
Property ARCIMObservationGroupDR As MRCObservationGroup [ SqlColumnNumber = 126, SqlFieldName = ARCIM_ObservationGroup_DR ];

/// ARCIM Administration Questionnarie Des Ref
Property ARCIMAdminQuestionnDR As SSUserDefWindow [ SqlColumnNumber = 127, SqlFieldName = ARCIM_AdminQuestionn_DR ];

/// Test Item Sequence
Property ARCIMTestItemSequnce As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 128, SqlFieldName = ARCIM_TestItemSequnce ];

/// Processing Notes
Property ARCIMProcessingNotes As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 129, SqlFieldName = ARCIM_ProcessingNotes ];

/// Maximum Price
Property ARCIMMaxPrice As %Float [ SqlColumnNumber = 130, SqlFieldName = ARCIM_MaxPrice ];

/// Minimum Price
Property ARCIMMinPrice As %Float [ SqlColumnNumber = 131, SqlFieldName = ARCIM_MinPrice ];

/// Modifiers Required Flag
Property ARCIMModifiersRequired As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 132, SqlFieldName = ARCIM_ModifiersRequired ];

/// Sensitive
Property ARCIMSensitive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 133, SqlFieldName = ARCIM_Sensitive ];

/// Patient OrderFile1
Property ARCIMPatientOrderFile1 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 134, SqlFieldName = ARCIM_PatientOrderFile1 ];

/// Patient Order File 2
Property ARCIMPatientOrderFile2 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 135, SqlFieldName = ARCIM_PatientOrderFile2 ];

/// Patient Order File 3
Property ARCIMPatientOrderFile3 As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 136, SqlFieldName = ARCIM_PatientOrderFile3 ];

/// Sensitive Order
Property ARCIMSensitiveOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 137, SqlFieldName = ARCIM_SensitiveOrder ];

/// Display Cumulative
Property ARCIMDisplayCumulative As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 138, SqlFieldName = ARCIM_DisplayCumulative ];

/// Result Display Group DR
Property ARCIMResultDisplayGroupDR As OECResultDisplayGroup [ SqlColumnNumber = 139, SqlFieldName = ARCIM_ResultDisplayGroupDR ];

/// Charge Order per hour
Property ARCIMChgOrderPerHour As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 140, SqlFieldName = ARCIM_ChgOrderPerHour ];

/// Authorising Clinician
Property ARCIMAuthorisingClinician As CTCareProv [ SqlColumnNumber = 141, SqlFieldName = ARCIM_AuthorisingClinician ];

/// HL7ResultType
Property ARCIMHL7ResultType As %String(DISPLAYLIST = ",Atomic,Image,Atomic and Image", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",AT,IM,AI") [ SqlColumnNumber = 142, SqlFieldName = ARCIM_HL7ResultType ];

/// Des Ref DentalState
Property ARCIMDentalStateDR As OECDentalState [ SqlColumnNumber = 143, SqlFieldName = ARCIM_DentalState_DR ];

/// Deceased Patients Only
Property ARCIMDeceasedPatientsOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 144, SqlFieldName = ARCIM_DeceasedPatientsOnly ];

/// MaxCumDose
Property ARCIMMaxCumDose As %Float [ SqlColumnNumber = 145, SqlFieldName = ARCIM_MaxCumDose ];

/// NoOfCumDays
Property ARCIMNoOfCumDays As %Float [ SqlColumnNumber = 146, SqlFieldName = ARCIM_NoOfCumDays ];

/// Text1
Property ARCIMText1 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 147, SqlFieldName = ARCIM_Text1 ];

/// Text2
Property ARCIMText2 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 148, SqlFieldName = ARCIM_Text2 ];

/// Text3
Property ARCIMText3 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 149, SqlFieldName = ARCIM_Text3 ];

/// Text4
Property ARCIMText4 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 150, SqlFieldName = ARCIM_Text4 ];

/// Text5
Property ARCIMText5 As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 151, SqlFieldName = ARCIM_Text5 ];

/// MaxQtyPerDay
Property ARCIMMaxQtyPerDay As %Float [ SqlColumnNumber = 152, SqlFieldName = ARCIM_MaxQtyPerDay ];

/// MaxQty
Property ARCIMMaxQty As %Float [ SqlColumnNumber = 153, SqlFieldName = ARCIM_MaxQty ];

/// MinTime
Property ARCIMMinTime As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 154, SqlFieldName = ARCIM_MinTime ];

/// Des Ref ServiceCharge
Property ARCIMServiceChargeDR As ARCServiceCharge [ SqlColumnNumber = 155, SqlFieldName = ARCIM_ServiceCharge_DR ];

/// EnergyKj
Property ARCIMEnergyKj As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 156, SqlFieldName = ARCIM_EnergyKj ];

/// EnergyCal
Property ARCIMEnergyCal As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 157, SqlFieldName = ARCIM_EnergyCal ];

/// ProteinG
Property ARCIMProteinG As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 158, SqlFieldName = ARCIM_ProteinG ];

/// TotalFatG
Property ARCIMTotalFatG As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 159, SqlFieldName = ARCIM_TotalFatG ];

/// SaturatedFatsG
Property ARCIMSaturatedFatsG As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 160, SqlFieldName = ARCIM_SaturatedFatsG ];

/// CarbohydratesG
Property ARCIMCarbohydratesG As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 161, SqlFieldName = ARCIM_CarbohydratesG ];

/// SugarsG
Property ARCIMSugarsG As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 162, SqlFieldName = ARCIM_SugarsG ];

/// SodiumMg
Property ARCIMSodiumMg As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 163, SqlFieldName = ARCIM_SodiumMg ];

/// DietryFibreG
Property ARCIMDietryFibreG As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 164, SqlFieldName = ARCIM_DietryFibreG ];

/// OtherG
Property ARCIMOtherG As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 165, SqlFieldName = ARCIM_OtherG ];

/// Des Ref UserDefWindow
Property ARCIMUserDefWindowDR As SSUserDefWindow [ SqlColumnNumber = 166, SqlFieldName = ARCIM_UserDefWindow_DR ];

/// Restrict to EM episode
Property ARCIMRestrictEM As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 167, SqlFieldName = ARCIM_RestrictEM ];

/// Restrict IP episode
Property ARCIMRestrictIP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 168, SqlFieldName = ARCIM_RestrictIP ];

/// Restrict OP episode
Property ARCIMRestrictOP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 169, SqlFieldName = ARCIM_RestrictOP ];

/// Restrict HP episode
Property ARCIMRestrictHP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 170, SqlFieldName = ARCIM_RestrictHP ];

/// Des Ref ServicePriority
Property ARCIMServicePriorityDR As RBCServicePriority [ SqlColumnNumber = 171, SqlFieldName = ARCIM_ServicePriority_DR ];

/// PhoneOrderReviewTime
Property ARCIMPhoneOrderReviewTime As %Float [ SqlColumnNumber = 172, SqlFieldName = ARCIM_PhoneOrderReviewTime ];

/// Exclude From Grp Warn
Property ARCIMExcludeFromGrpWarn As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 173, SqlFieldName = ARCIM_ExcludeFromGrpWarn ];

/// PreRecoveryTimeMin
Property ARCIMPreRecoveryTimeMin As %Float [ SqlColumnNumber = 174, SqlFieldName = ARCIM_PreRecoveryTimeMin ];

/// PreRecoveryTimeType
Property ARCIMPreRecoveryTimeType As %String(DISPLAYLIST = ",Blank,Pre,Post", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",B,PR,PO") [ SqlColumnNumber = 175, SqlFieldName = ARCIM_PreRecoveryTimeType ];

/// SequenceOrder
Property ARCIMSequenceOrder As %String(DISPLAYLIST = ",Always First,Always Second,Always Last,Blank", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",F,S,L,B") [ SqlColumnNumber = 176, SqlFieldName = ARCIM_SequenceOrder ];

/// 默认加急 add by chenying 2019-05-29
Property ARCIMDefSensitive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 177, SqlFieldName = ARCIM_DefSensitive ];

/// 允许录入频次 add by chenying 2020-11-24
Property ARCIMAllowInputFreq As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 178, SqlFieldName = ARCIM_AllowInputFreq ];

/// 自费标志 add by chenying 2022-04-24  ,8  ^23
Property ARCIMOwnPayFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 179, SqlFieldName = ARCIM_OwnPayFlag ];

/// 是否扫码计费  10 ^ 22
Property ARCIMScanCodeBilling As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 180, SqlFieldName = ARCIM_ScanCodeBilling ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItmMast).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmMast","OnAfterInsert")
 d POFILINS^at115
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItmMast).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmMast","OnAfterUpdate")
 d POFILUPD^at115
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItmMast).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmMast","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItmMast).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmMast","OnBeforeUpdate")
 d VALUPD^at115
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmMast","OnBeforeInsert")
 d VALINS^at115
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItmMast).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItmMast","OnAfterDelete")
}

Parameter EXTENTSIZE = 1000000;

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMasterARCIM">
<Data name="ARCIM_Abbrev">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_AdminQuestionn_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>12</Piece>
</Data>
<Data name="ARCIM_AllowInputFreq">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>42</Piece>
</Data>
<Data name="ARCIM_AllowOrderWOStockCheck">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>11</Piece>
</Data>
<Data name="ARCIM_AuthorisingClinician">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>26</Piece>
</Data>
<Data name="ARCIM_BillBodyP_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>10</Piece>
</Data>
<Data name="ARCIM_BillDescription">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>12</Piece>
</Data>
<Data name="ARCIM_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>9</Piece>
</Data>
<Data name="ARCIM_BillingUOM_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>14</Piece>
</Data>
<Data name="ARCIM_CAPD">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_CarbohydratesG">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_ChargePartial">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>15</Piece>
</Data>
<Data name="ARCIM_ChgCost">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_ChgDispFlg">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCIM_ChgMaxAmt">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_ChgMinAmt">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_ChgOrderPerHour">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>25</Piece>
</Data>
<Data name="ARCIM_ChgPostFlg">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>9</Piece>
</Data>
<Data name="ARCIM_ChgUnitFact">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Code">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_ConsultDept">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_Days">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>9</Piece>
</Data>
<Data name="ARCIM_DaysCheckDuplicate">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCIM_DeceasedPatientsOnly">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>29</Piece>
</Data>
<Data name="ARCIM_DefPriority_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>22</Piece>
</Data>
<Data name="ARCIM_DefSensitive">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>41</Piece>
</Data>
<Data name="ARCIM_DentalState_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>28</Piece>
</Data>
<Data name="ARCIM_DerFeeRules_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>19</Piece>
</Data>
<Data name="ARCIM_DerivedFeeItem">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>18</Piece>
</Data>
<Data name="ARCIM_Desc">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_DietryFibreG">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>9</Piece>
</Data>
<Data name="ARCIM_DisplayCumulative">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>23</Piece>
</Data>
<Data name="ARCIM_DoseCalcFormula">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>9</Piece>
</Data>
<Data name="ARCIM_DoseType">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_EffDate">
<Delimiter>"^","Z"</Delimiter>
<Node>1</Node>
<Piece>13,1</Piece>
</Data>
<Data name="ARCIM_EffDateTime">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>13</Piece>
</Data>
<Data name="ARCIM_EffDateTo">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_EffTime">
<Delimiter>"^","Z"</Delimiter>
<Node>1</Node>
<Piece>13,2</Piece>
</Data>
<Data name="ARCIM_EnergyCal">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_EnergyKj">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_ExcludeFromGrpWarn">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>18</Piece>
</Data>
<Data name="ARCIM_FileNotes">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_GLPostToOrderDept">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_GenericDesc">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>21</Piece>
</Data>
<Data name="ARCIM_Generic_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>20</Piece>
</Data>
<Data name="ARCIM_HL7ResultType">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>27</Piece>
</Data>
<Data name="ARCIM_Haemodal">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCIM_IncSource_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>12</Piece>
</Data>
<Data name="ARCIM_InsCoDesc">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_InsSubCat_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>10</Piece>
</Data>
<Data name="ARCIM_KidneyTransp">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>9</Piece>
</Data>
<Data name="ARCIM_MaxAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_MaxCumDose">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>30</Piece>
</Data>
<Data name="ARCIM_MaxPrice">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>15</Piece>
</Data>
<Data name="ARCIM_MaxQty">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>38</Piece>
</Data>
<Data name="ARCIM_MaxQtyPerDay">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>37</Piece>
</Data>
<Data name="ARCIM_MealType_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_MinAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_MinPrice">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>16</Piece>
</Data>
<Data name="ARCIM_MinTime">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>39</Piece>
</Data>
<Data name="ARCIM_Minutes">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>10</Piece>
</Data>
<Data name="ARCIM_ModifiersRequired">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>17</Piece>
</Data>
<Data name="ARCIM_NoOfCumDays">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>31</Piece>
</Data>
<Data name="ARCIM_OEMessage">
<Node>"OEM"</Node>
</Data>
<Data name="ARCIM_ObservationGroup_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>11</Piece>
</Data>
<Data name="ARCIM_Ointment">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_OrderOnItsOwn">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>13</Piece>
</Data>
<Data name="ARCIM_OtherG">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>10</Piece>
</Data>
<Data name="ARCIM_OwnPayFlag">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>23</Piece>
</Data>
<Data name="ARCIM_P1ChgFact">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_P1StdAddAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_P1TypAAddAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_P1TypBAddAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_P2ChgFact">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_P2StdAddAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_P2TypAAddAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_P2TypBAddAmt">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCIM_P3ChgFact">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_P3StdAddAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_P3TypAAddAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_P3TypBAddAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_P4ChgFact">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_P4StdAddAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_P4TypAAddAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_P4TypBAddAmt">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCIM_PHCDF_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>12</Piece>
</Data>
<Data name="ARCIM_PatientOrderFile1">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>19</Piece>
</Data>
<Data name="ARCIM_PatientOrderFile2">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>20</Piece>
</Data>
<Data name="ARCIM_PatientOrderFile3">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>21</Piece>
</Data>
<Data name="ARCIM_PayorICDGroup_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_PhoneOrderReviewTime">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>17</Piece>
</Data>
<Data name="ARCIM_PreRecoveryTimeMin">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>19</Piece>
</Data>
<Data name="ARCIM_PreRecoveryTimeType">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>20</Piece>
</Data>
<Data name="ARCIM_PriceCostOnOrdering">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>13</Piece>
</Data>
<Data name="ARCIM_ProcessingNotes">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>14</Piece>
</Data>
<Data name="ARCIM_ProfileFlg">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_ProteinG">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_QuesMandatory">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>10</Piece>
</Data>
<Data name="ARCIM_Questionnaire_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_RBNotes">
<Node>"RB"</Node>
</Data>
<Data name="ARCIM_RMDuration_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>16</Piece>
</Data>
<Data name="ARCIM_RMFrequency_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>17</Piece>
</Data>
<Data name="ARCIM_RangeFrom">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_RangeTo">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_RestrictEM">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>12</Piece>
</Data>
<Data name="ARCIM_RestrictHP">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>15</Piece>
</Data>
<Data name="ARCIM_RestrictIP">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>13</Piece>
</Data>
<Data name="ARCIM_RestrictOP">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>14</Piece>
</Data>
<Data name="ARCIM_ResultDisplayGroupDR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>24</Piece>
</Data>
<Data name="ARCIM_ResultGroup">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_RiceType_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>17</Piece>
</Data>
<Data name="ARCIM_RvpAnes">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_RvpFud">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_RvpInterimYear">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_RvpUnitStat">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_RvpUpd">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_SaturatedFatsG">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_ScanCodeBilling">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>22</Piece>
</Data>
<Data name="ARCIM_Sensitive">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>18</Piece>
</Data>
<Data name="ARCIM_SensitiveOrder">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>22</Piece>
</Data>
<Data name="ARCIM_SequenceOrder">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>21</Piece>
</Data>
<Data name="ARCIM_ServCat_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_ServMaterial">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_ServTax_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCIM_ServiceCharge_DR">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>40</Piece>
</Data>
<Data name="ARCIM_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_ServicePriority_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>16</Piece>
</Data>
<Data name="ARCIM_SingleFee">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_SnackFlag">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>16</Piece>
</Data>
<Data name="ARCIM_SodiumMg">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>8</Piece>
</Data>
<Data name="ARCIM_StdAmt">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_SubMasFlg">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_SugarsG">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>7</Piece>
</Data>
<Data name="ARCIM_Surcharge_DR">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_TestItemSequnce">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>13</Piece>
</Data>
<Data name="ARCIM_Text1">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>32</Piece>
</Data>
<Data name="ARCIM_Text2">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>33</Piece>
</Data>
<Data name="ARCIM_Text3">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>34</Piece>
</Data>
<Data name="ARCIM_Text4">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>35</Piece>
</Data>
<Data name="ARCIM_Text5">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>36</Piece>
</Data>
<Data name="ARCIM_TimeDepFlg">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>10</Piece>
</Data>
<Data name="ARCIM_TotalFatG">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_TypeAAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>5</Piece>
</Data>
<Data name="ARCIM_TypeBAmt">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_UOM_DR">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="ARCIM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>2</Piece>
</Data>
<Data name="ARCIM_UpdateUser">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>3</Piece>
</Data>
<Data name="ARCIM_UseODBCforWord">
<Delimiter>"^"</Delimiter>
<Node>9</Node>
<Piece>6</Piece>
</Data>
<Data name="ARCIM_UserDefWindow_DR">
<Delimiter>"^"</Delimiter>
<Node>10</Node>
<Piece>11</Piece>
</Data>
<Data name="ARCIM_VisibleInOrderList">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>14</Piece>
</Data>
<Data name="ARCIM_WordTemplate">
<Delimiter>"^"</Delimiter>
<Node>8</Node>
<Piece>15</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCICDR">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIC_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCIM_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCSCDR">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCSC_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCIM_ServCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCSGDR">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCSG_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCIM_BillSub_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCSTDR">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ARCIM_ServTax_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasAll">
<Condition>1</Condition>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>100</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasAllItems">
<Condition>1</Condition>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOSVisItems">
<Condition>$$visible^at115({ARCIM_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ARCIM_OrderOnItsOwn,ARCIM_Desc</ConditionFields>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOrCatOSVisIte">
<Condition>$$visible^at115({ARCIM_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ARCIM_ItemCat_DR,ARCIM_Desc,ARCIM_OrderOnItsOwn</ConditionFields>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIM_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOrdCatAll">
<Condition>1</Condition>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>100</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIM_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOrdCatAllIte">
<Condition>1</Condition>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-DescI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIM_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasOrdCatVisItem">
<Condition>$$visible^at115({ARCIM_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ARCIM_ItemCat_DR,ARCIM_Desc,ARCIM_OrderOnItsOwn</ConditionFields>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrderCat-DescVI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIM_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAliasVisItems">
<Condition>$$visible^at115({ARCIM_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ARCIM_Desc,ARCIM_OrderOnItsOwn</ConditionFields>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_ShortDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCIM_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCodeStr">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CodeStr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ARCIM_Code})_"Z"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGeneric">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Gener"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARCIM_Generic_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenericAll">
<Condition>1</Condition>
<ConditionFields>ARCIM_Desc,ARCIM_GenericDesc</ConditionFields>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenericAllItems">
<Condition>1</Condition>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenericOSVisItems">
<Condition>$$visible^at115({ARCIM_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ARCIM_Desc,ARCIM_GenericDesc,ARCIM_OrderOnItsOwn</ConditionFields>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVIOS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGenericVisItm">
<Condition>$$visible^at115({ARCIM_OrderOnItsOwn})="Y"</Condition>
<ConditionFields>ARCIM_Desc,ARCIM_GenericDesc,ARCIM_OrderOnItsOwn</ConditionFields>
<Data name="ARCIM_Row_Calc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARCIM_Type_Calc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DescVI"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_GenericDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsSubCat">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsSubCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARCIM_InsSubCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ARCIM_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPHCDFDR">
<Condition>{ARCIM_PHCDF_DR}'=""</Condition>
<Global>^ARCIM</Global>
<PopulationPct>80</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHCDF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ARCIM_PHCDF_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceGroup">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARCIM_Version</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SERGRP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARCIM_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARCIM_Version}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ARCIM_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItmMastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
