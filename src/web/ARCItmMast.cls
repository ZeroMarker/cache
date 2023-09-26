Include webimport

IncludeGenerator webimport

Class web.ARCItmMast Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1936;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "ARCIM_EffDateTo";

Parameter SQLCODE = "ARCIM_Code";

Parameter SQLDESCRIPTION = "ARCIM_Desc";

Parameter SQLROWID = "ARCIM_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod CheckDepartOverride(ItmMastID As %Library.String, EpisodeID As %Library.String, PreOrdDate As %Library.String = "", PreOrdTime As %Library.String = "", CurrOeorid As %Library.String = "") As %Library.Boolean
{
}

ClassMethod CheckFavRestriction(ItmMast As %Library.String, GroupID As %Library.String, ItmType As %Library.String = "", VisitStatus As %Library.String = "", OrdItemID As %Library.String = "", PatientID As %Library.String = "", FinDischFlag As %Library.String = "", formulary As %Library.String = "", EpisodeID As %Library.String = "", HospID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod DrugFormGetIDFromDesc(Form As %String = "") As %String
{
}

ClassMethod StrengthGetIDFromDesc(Strength As %String = "") As %String
{
}

ClassMethod TestAndSetValidDrugForm(itmMastDR As %String = "") As %String
{
}

ClassMethod TestValidDrugForm(PHCDFRowId As %String = "") As %String
{
}

ClassMethod FindMessByID(id As %Library.String, age As %Library.String, sex As %Library.String)
{
}

ClassMethod FindMessagesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMessagesFetch ]
{
}

ClassMethod FindMessagesExecute(ByRef QHandle As %Library.Binary, ORIRowIDs As %Library.String) As %Library.Status
{
}

ClassMethod FindMessagesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMessagesExecute ]
{
}

ClassMethod FindAllDrugFormClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllDrugFormFetch ]
{
}

ClassMethod FindAllDrugFormExecute(ByRef QHandle As %Library.Binary, ARCItmMastID As %Library.String) As %Library.Status
{
}

ClassMethod FindAllDrugFormFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllDrugFormExecute ]
{
}

ClassMethod GetDefaultDuration(ROW As %Library.String) As %Library.String
{
}

ClassMethod GetOrderType(ARCIM As %Library.String) As %Library.String
{
}

/// Log 54749 - 13.07.2006 - Returns Service Tax Type Code when given OrderItem Id.
ClassMethod GetDefaultServiceTax(OrderItem As %Library.String) As %Library.String
{
}

ClassMethod GetDefaultRMDuration(ARCIMRowId As %Library.String) As %Library.String
{
}

ClassMethod GetDefaultRMFrequency(ARCIMRowId As %Library.String) As %Library.String
{
}

ClassMethod GetIVExpiry(ARCIMRowId As %Library.String) As %Library.String
{
}

ClassMethod CheckDrgSubstitution(ARCIMRowId As %Library.String) As %Library.String
{
}

ClassMethod GetItemNameByGenePresc(ordid As %Library.String) As %Library.String
{
}

ClassMethod GetItemDoseQty(ItemID As %String, GroupID As %String) As %String
{
}

ClassMethod GetItemQty(ItemID As %String, GroupID As %String) As %String
{
}

ClassMethod GetOEMessage(ROW As %Library.String) As %Library.String
{
}

ClassMethod LookUpGetItemClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpGetItemFetch ]
{
}

ClassMethod LookUpGetItemExecute(ByRef QHandle As %Library.Binary, Order As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpGetItemFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpGetItemExecute ]
{
}

Query LookUpGetItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, LUCategoryDesc As %Library.String, LUSubCategoryDesc As %Library.String, EpisodeID As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod LookUpGetItemBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetOrderItemPrice(OrdItemID As %Library.String) As %Library.String
{
}

ClassMethod LookUpByTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByTypeFetch ]
{
}

/// KM: 21May2001: I have used this query in Component OEOrder.Edit.LabCummProfile
/// [NB: Query was already in existence, so it may be used somewhere else]
ClassMethod LookUpByTypeExecute(ByRef QHandle As %Library.Binary, OrderItem As %Library.String, OrderType As %Library.String) As %Library.Status
{
}

ClassMethod LookUpByTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByTypeExecute ]
{
}

Query Edit(Code As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCIMCode:%String")
{
SELECT ARCIM_ROWID, ARCIM_Code
FROM ARC_ItmMast
WHERE (ARCIM_Code %STARTSWITH :Code)
ORDER BY ARCIM_Code
}

Query Find(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCIMCode:%String,ARCIMDesc:%String,ARCICOrderType:%String")
{
SELECT ARCIM_RowID, ARCIM_Code, ARCIM_Desc, ARCIM_ItemCat_DR->ARCIC_OrderType
FROM ARC_ItmMast
WHERE (ARCIM_RowID = :ID)
}

Query FindAllAlerts(PatientID As %String = "", DosageRange As %String = "", DupMsg As %String = "", AgeSexItem As %String = "", AgeSexString As %String = "", AgeSexFlag As %String = "", AllergyItems As %String = "", AllergyFlag As %String = "", NewOrders As %String = "", DrugIntString As %String = "", TherpDupStr As %String = "", InteractFlag As %String = "", ORIRowIDs As %String = "", OrdRowIDExternalCodeNotExist As %String = "", DelStockInOtherLoc As %String = "", MaxCumDoseFlag As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "ORIRowID:%String,ARCIMRowId:%String,ARCIMDesc:%String,ErrorType:%String,Message:%String,AlertType:%String,AlertTypeDR:%String,SeverityDR:%String,Severity:%String,SeverityColor:%String,Priority:%String,Mendatory:%String,AllergyType:%String,AllergyCategory:%String,DrugIntCategory:%String,MonoGraphID:%String,xsensDesc:%String,SeqNo:%String,PregnBrFdAlertType:%String")
{
}

Query FindAllDrugForm(ARCItmMastID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIDDEN,DrugFormDesc:%String,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
}

ClassMethod FindAllAlertsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllAlertsFetch ]
{
}

ClassMethod FindAllAlertsExecute(ByRef QHandle As %Library.Binary, PatientID As %String = "", DosageRange As %String = "", DupMsg As %String = "", AgeSexItem As %String = "", AgeSexString As %String = "", AgeSexFlag As %String = "", AllergyItems As %String = "", AllergyFlag As %String = "", NewOrders As %String = "", DrugIntString As %String = "", TherpDupStr As %String = "", InteractFlag As %String = "", ORIRowIDs As %String = "", OrdRowIDExternalCodeNotExist As %String = "", DelStockInOtherLoc As %String = "", MaxCumDoseFlag As %String = "") As %Library.Status
{
}

ClassMethod FindAllAlertsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllAlertsExecute ]
{
}

//SB 01/01/05 (50265 & 49172): display generic route & form

ClassMethod GetOEDesc(ARCIMRowId As %String = "", ARCIMDesc As %String = "", IsRouted As %String = "N") As %Library.String
{
}

ClassMethod OverrideMsgOE(PatientID As %String = "", ARCIMRowId As %String = "") As %Library.String
{
}

ClassMethod OverrideMsgProceed(pat As %String = "", sex As %String = "", agefrom As %String = "", ageto As %String = "") As %Library.String
{
}

ClassMethod GetTemplateName(ARCIMDesc As %String = "") As %Library.String
{
}

ClassMethod LookUpDrugFormClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod LookUpDrugFormExecute(ByRef QHandle As %Library.Binary, frm As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpDrugFormFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

ClassMethod LookUpDrugFormBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpStrengthClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod LookUpStrengthExecute(ByRef QHandle As %Library.Binary, Strength As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpStrengthFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

ClassMethod ItemListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemListFetch ]
{
}

/// HiddenDelete is only there to pass on for paging
ClassMethod ItemListExecute(ByRef QHandle As %Library.Binary, Pref As %Library.String = "", ReadOnly As %Library.String = "") As %Library.Status
{
}

ClassMethod ItemListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemListExecute ]
{
}

ClassMethod ItemOSListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ItemListFetch ]
{
}

/// HiddenDelete is only there to pass on for paging
ClassMethod ItemOSListExecute(ByRef QHandle As %Library.Binary, OrderSetID As %Library.String = "", OSQty As %Library.String = "", Pref As %Library.String = "") As %Library.Status
{
}

ClassMethod ItemOSListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ItemListExecute ]
{
}

ClassMethod LookUpStrengthBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query FindByDesc(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCIMCode:%String,ARCIMDesc:%String,ARCICOrderType:%String")
{
SELECT ARCIM_RowID, ARCIM_Code, ARCIM_Desc, ARCIM_ItemCat_DR->ARCIC_OrderType
FROM ARC_ItmMast
WHERE (ARCIM_Desc = :desc)
}

/// KK 08/Oct/2002 Log 28459
Query FindByDietaryGroup(desc As %Library.String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "HIDDEN,ARCIMCode:%String,ARCIMDesc:%String")
{
SELECT ARCIM_RowID, ARCIM_Code, ARCIM_Desc
FROM ARC_ItmMast
WHERE (ARCIM_BillSub_DR->ARCSG_ARCBG_ParRef->ARCBG_Desc = 'DIETARY')
AND ((%UPPER ARCIM_Desc [ %UPPER :desc) OR (:desc IS NULL))
}

/// Find the Days and Hours of the Department Override table for an ordermast id and location
Query FindDepartOverrideDayHour(OrdMastID, CTLocID) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "DOVDays,DOVHours")
{
SELECT DOV_Days, DOV_Hours
FROM SQLUser.ARC_ItemDepartOverride
WHERE (DOV_CTLOC_DR = :CTLocID)
AND 	(DOV_ParRef = :OrdMastID)
}

Query FindDrugForm(itmMast As %Library.String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "PHCFDesc:%String")
{
SELECT ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc
FROM ARC_ItmMast
WHERE ARCIM_RowId =  :itmMast
}

Query FindAllDrugFormForARCIM(drgMast As %Library.String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "PHCDFRowId:%String")
{
SELECT PHCDF_RowId
FROM PHC_DrgForm
WHERE PHCDF_PHCD_ParRef = :drgMast
}

Query FindMessages(ORIRowIDs As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ORIRowID:%String,ARCIMRowId:%String,ARCIMDesc:%String")
{
}

Query FindDFFromGeneic(GenRtFormDR As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PHCDFRowId,PHCDFPreferred")
{
SELECT PHCDF_RowId,PHCDF_Preferred
FROM SQLUser.PHC_DrgForm
WHERE PHCDF_GenRtForm_DR = :GenRtFormDR
AND PHCDF_Formulary='Y'
}

Query FindQuestions(OrderItemID As %String, Age As %String, SexID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "QuestionCode,QuestionDesc,ControlType,Values")
{
SELECT QUES_Question_DR->QUES_Code,QUES_Question_DR->QUES_Desc,QUES_Question_DR->QUES_ControlType,QUES_Question_DR->QUES_Values
FROM SQLUser.ARC_ItemQuestion
WHERE (QUES_ParRef = :OrderItemID) AND ((QUES_Question_DR->QUES_AgeFrom >= :Age) OR (QUES_Question_DR->QUES_AgeFrom = NULL)) AND ((QUES_Question_DR->QUES_AgeTo <= :Age) OR (QUES_Question_DR->QUES_AgeTo = NULL)) AND (QUES_Question_DR->QUES_Sex_DR = :SexID)
}

/// KM 17May2001: Called from epr.CTProfileParams.Edit.csp
/// NB: This query was already in existence but I changed the Row Specification from;
/// ARCIM_Desc,ARCIM_Code   to   ARCIM_Desc:%String,HIDDEN:%String
Query LookUpByType(OrderItem As %String, OrderType As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "itemdesc:%String,itemcode:%String")
{
}

Query LookUpDrugForm(frm As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "itemdesc:%String,itemcode:%String")
{
}

Query LookUpStrength(Strength As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "itemdesc:%String,itemcode:%String")
{
}

Query LookUpByBillSubGrp(BillSubGrp As %String = "", OrderItem As %String = "", DischDate As %String = "", AuthDate As %String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
SELECT ARCIM_Desc, ARCIM_Code
FROM ARC_ItmMast
WHERE ((ARCIM_BillSub_DR->ARCSG_Desc = :BillSubGrp OR :BillSubGrp IS NULL) AND (ARCIM_Desc %STARTSWITH :OrderItem OR :OrderItem IS NULL))
AND (((ARCIM_EffDateTo >= :DischDate AND NOT :DischDate IS NULL) OR (ARCIM_EffDateTo >= :AuthDate AND NOT :AuthDate IS NULL))
OR (ARCIM_EffDateTo >= CURRENT_DATE OR ARCIM_EffDateTo IS NULL))
}

ClassMethod LookUpByBillSubGrpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", BillSubGrp As %Library.String = "", OrderItem As %Library.String = "", DischDate As %String = "", AuthDate As %String = "") As %Library.Boolean
{
}

// FindFormula and FormulaBroker: JPD LOG 49134

Query FindFormula(formula As %String, EpisodeID As %String, Height As %String = "", Weight As %String = "") As %Library.Query(CONTAINID = "", ROWSPEC = "FormulaDescription:%String,Code:%String,hidden:%String")
{
}

ClassMethod FindFormulaClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindFormulaFetch ]
{
}

ClassMethod FindFormulaExecute(ByRef QHandle As %Library.Binary, formula As %Library.String, EpisodeID As %String, Height As %String = "", Weight As %String = "") As %Library.Status
{
}

ClassMethod FindFormulaFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindFormulaExecute ]
{
}

ClassMethod FormulaBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", formula As %String, EpisodeID As %String, Height As %String = "", Weight As %String = "") As %Library.String
{
}

ClassMethod KillOnUnloadBroker(sess As %String = "") As %Library.Boolean
{
}

Query ItemList(Pref As %String, ReadOnly As %String) As %Query(ROWSPEC = "itmId:%String,itmDesc:%String,itmType:%String,AnaestDR:%String,itmQty:%String,ANAOPNo:%String,arcosNo:%String,AnaOperDR:%String,itmChecked:%String,PartialSelection:%String,OrderId:%String,altDesc:%String")
{
}

Query ItemOSList(OrderSetID As %String, OSQty As %String, Pref As %String) As %Query(ROWSPEC = "itmId:%String,itmDesc:%String,itmQty:%String,AnaestOSDR:%String,AnaOperOSDR:%String,itmOSChecked:%String,OSOrdID:%String")
{
}

ClassMethod OnBeforeUpdate() As %String
{
}

/// log57509 TedT
ClassMethod UpdateOneOrder(OrderId As %String, Qty As %String, RecDep As %String)
{
}

ClassMethod UpdateOrders(compref As %String)
{
}

/// 	log58216 TedT May2006 get default rec loc if user left it blank
ClassMethod CheckRecLoc() As %Boolean
{
}

ClassMethod CreateOrder(Adm As %Library.String = "", SttDat1 As %Library.String = "", SttTim1 As %Library.String = "", Qty As %Library.String = "", ItemMast As %Library.String = "", AnaestDR As %Library.String = "", AnaOperDR As %Library.String = "", RecDep As %Library.String = "", ReadyToBill As %Library.String = "", OrderSet As %Library.String = "", ItemStat As %Library.String = "", Unit As %Library.String = "", Freq As %Library.String = "", Durat As %Library.String = "")
{
}

ClassMethod ConvertOrder(compref As %String)
{
}

ClassMethod AddItem()
{
}

ClassMethod GetLastUpdateInfo(Pref As %Library.String = "") As %Library.String
{
}

ClassMethod RecLocAdd(ARCIM As %Library.String = "", RecDep As %Library.String = "", adm As %Library.String = "") As %Library.String
{
}

ClassMethod AnaMethOrd(OrderId As %Library.String = "", AnaId As %Library.String = "")
{
}

ClassMethod GetAnaDR(Pref As %Library.String = "") As %Library.String
{
}

ClassMethod Spacer(ARCIMRowId As %Library.String = "", OSid As %Library.String = "", space As %Library.String = "   ") As %Library.String
{
}

/// log 58512, Ted, May 2006: check if drug frequency is greater than PRN min time period
ClassMethod PRNFreqCheck(arcimid As %String) As %Boolean
{
}

/// log58512 Ted May 2006 if default priority is PRN, check if the frequency is greater than PRN period and return alert message
ClassMethod PRNAlertMsg(PRNAlert As %String, arcim As %String, itemdesc As %String) As %String
{
}

}
