Include webimport

IncludeGenerator webimport

Class web.OEOrder Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 3007;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod SetRepeatOrderGlb(RepOrdStr1 As %String = "") As %String
{
}

ClassMethod CheckAuthDoc(orderList As %String = "") As %Library.String
{
}

ClassMethod FindUserNameBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", UserCode As %Library.String = "") As %Library.Boolean
{
}

ClassMethod IsContainDSSMessage(NewOrders As %String = "") As %Library.Boolean
{
}

ClassMethod checkDecisionSupportForNonError() As %Library.Boolean
{
}

ClassMethod CheckStartDateOLD(val As %String = "", arcim As %String = "", adm As %String = "", apptID As %String = "", priority As %String = "", ordloc As %String = "") As %Library.String
{
}

ClassMethod CheckStartDate(val As %String = "", arcim As %String = "", adm As %String = "", priority As %String = "") As %Library.String
{
}

Parameter SQLCODE = "OEORD_RowId";

Parameter SQLDESCRIPTION = "OEORD_RowId";

Parameter SQLROWID = "OEORD_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod BarcodeFindBroker(Barcode As %String) As %String
{
}

ClassMethod FindUnreadResAcrossAdm(EpisodeID As %String = "") As %Library.Integer
{
}

ClassMethod BilledFlagGetAll(OrderString As %String = "") As %Library.String
{
}

ClassMethod ChangeOrderQuantityInOS(OSOrdRowIDs As %String = "", OSOrderQuantitys As %String = "") As %Library.Boolean
{
}

ClassMethod GetBilledFlag(OEORIROWID As %String = "") As %Library.String
{
}

/// called from order summary screen
ClassMethod UpdateOrderStatus(OEOrdItemIDs As %String, EpisodeID As %String = "")
{
}

ClassMethod GetOrderItemIDs(oerids As %String = "") As %String
{
}

ClassMethod FindAgeSexItemsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindAgeSexItemsExecute ]
{
}

ClassMethod FindAgeSexItemsExecute(ByRef QHandle As %Binary, AgeSexItems As %String, AgeSexAlert As %String) As %Status
{
}

ClassMethod FindAgeSexItemsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAgeSexItemsExecute ]
{
}

Query FindAgeSexItems(AgeSexItems As %String, AgeSexAlert As %String) As %Query(ROWSPEC = "ORIRowID:%Library.String,ARCIMDesc:%Library.String,ARCIMRowId:%Library.String,AgeSexMsg:%Library.String")
{
}

ClassMethod CheckStatusSecurityGroup(User As %String = "", Status As %String = "", ItemMast As %String = "", OrdRowID As %String = "") As %Boolean
{
}

ClassMethod CheckAgeSexRestriction(ItmMastID As %Library.String, EpisodeID As %Library.String, ByRef Gparam3 As %Library.String, ByRef Gparam4 As %Library.String) As %Library.Boolean
{
}

ClassMethod ColRecSetGlobal(EpisodeID As %Library.String = "", OEORIRowId As %Library.String = "", ARCIMRowId As %Library.String = "", RecievedDate As %Library.String = "", RecievedTime As %Library.String = "", CollectDate As %Library.String = "", CollectTime As %Library.String = "")
{
}

ClassMethod ColRecSpecimens()
{
}

ClassMethod DisplayActionValues()
{
}

/// TN:03-Sep-2003:  don't use this method anymore, use web.ARCItemQuestions.DisplayQuestions instead
ClassMethod DisplayQuestions(QCSPFlag As %Library.String = 0)
{
}

ClassMethod FindAllergyItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllergyItemsFetch ]
{
}

ClassMethod FindAllergyItemsExecute(ByRef QHandle As %Library.Binary, AllergyItems As %Library.String, NewOrders As %Library.String) As %Library.Status
{
}

ClassMethod FindAllergyItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllergyItemsExecute ]
{
}

ClassMethod FindChkBoxItemClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindChkBoxItemFetch ]
{
}

ClassMethod FindChkBoxItemExecute(ByRef QHandle As %Library.Binary, listoption As %Library.String = "", IDnVal As %Library.String = "") As %Library.Status
{
}

ClassMethod FindChkBoxItemFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindChkBoxItemExecute ]
{
}

Query FindChkBoxItem(listoption As %Library.String, IDnVal As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Item:%Library.String,HIDDEN:%Library.String")
{
}

ClassMethod FindDSSMsgClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDSSMsgFetch ]
{
}

ClassMethod FindDSSMsgExecute(ByRef QHandle As %Library.Binary, NewOrders As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDSSMsgFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDSSMsgExecute ]
{
}

ClassMethod FindDrugIntItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDrugIntItemsFetch ]
{
}

ClassMethod FindDrugIntItemsExecute(ByRef QHandle As %Library.Binary, DrugIntString As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDrugIntItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDrugIntItemsExecute ]
{
}

ClassMethod FindAllergyItemsNewClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllergyItemsNewFetch ]
{
}

ClassMethod FindAllergyItemsNewExecute(ByRef QHandle As %Library.Binary, AllergyString As %Library.String = "", ARCIMRowId As %Library.String = "", ORIRowID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindAllergyItemsNewFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllergyItemsNewExecute ]
{
}

ClassMethod FindLabEpisodeNoClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLabEpisodeNoFetch ]
{
}

ClassMethod FindLabEpisodeNoExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindLabEpisodeNoFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLabEpisodeNoExecute ]
{
}

/// TN:03-Sep-2003: don't use this query anymore, use ARCItemQuestion.FindAllQuestions instead
Query FindQuestions(OrderItemID As %String, PatientID As %String, distinct As %String, NewOrders As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,QuestionCode,QuestionDesc,ControlType,Values,Mandatory,maxLength,QuesARCIMDesc,Patients,DefaultAnswer,FldType,DecAllow,PosOnly,Other,DefaultMLAnswer")
{
}

ClassMethod FindQuestionsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindQuestionsFetch ]
{
}

ClassMethod FindQuestionsExecute(ByRef QHandle As %Library.Binary, OrderItemsID As %Library.String, PatientID As %Library.String, distinct As %Library.String, NewOrders As %Library.String = "") As %Library.Status
{
}

ClassMethod FindQuestionsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindQuestionsExecute ]
{
}

ClassMethod FindUnverifiedOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindUnverifiedOrdersFetch ]
{
}

ClassMethod FindUnverifiedOrdersExecute(ByRef QHandle As %Library.Binary, CareProvDesc As %Library.String, WardDesc As %Library.String, EpisodeDept As %Library.String, RecLocDesc As %Library.String) As %Library.Status
{
}

ClassMethod FindUnverifiedOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindUnverifiedOrdersExecute ]
{
}

ClassMethod GetAdmDateViaRegNum(PAPMINo As %Library.String = "") As %Library.String
{
}

ClassMethod GetAllergyForItem(EpisodeID As %Library.String, ARCIMRowId As %Library.String, txt As %Library.String = "") As %Library.String
{
}

ClassMethod GetAntibodyStatus(PatientId As %Library.String = "") As %Library.String
{
}

ClassMethod GetBloodGroup(PatientID As %Library.String = "") As %Library.String
{
}

/// Get Current Sample Expiry Date from Labtrak.
/// This date is calculated by the collection date + the date against labtrak configuration.
ClassMethod GetCurrExpBagAvail(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetDBSPEC() As %Library.String
{
}

ClassMethod GetDSSDesc(Code As %Library.String = "")
{
}

/// TN:03-Sep-2003: don't use this method anymore, use ARCItemQuestion.GetDefaultAnswer instead
ClassMethod GetDefaultAnswer(ORIRowId As %Library.String, QID As %Library.String) As %Library.String
{
}

/// TN:03-Sep-2003: don't use this method anymore, use ARCItemQuestion.GetDefaultMLAnswer instead
ClassMethod GetDefaultMLAnswer(ORIRowId As %Library.String, QID As %Library.String) As %Library.String
{
}

ClassMethod GetDefaultLaboratory(MRUserCode As %Library.String = "") As %Library.String
{
}

/// 	f j=1:1:$l(PLIST(5),",") {
/// 		s ApptIconsList(j)=$p(PLIST(5),",",j)
/// 		i $p(ApptIconsList(j),$c(1),1)'="" {
/// 			s count=count+1
/// 			s imgLIST("OE"_count,"image")= $p(ApptIconsList(j),$c(1),1)
/// 			s imgLIST("OE"_count,"title")="Appointment Booked:"_$c(13,10)_$p(ApptIconsList(j),$c(1),2)
/// 			s imgLIST("OE"_count,"priority")=""
/// 		}
/// 	}
/// 
ClassMethod GetImage(EpisodeID As %Library.String, PARAMS As %Library.String, ByRef imgLIST As %Library.String, ByRef EXCLUDE As %String)
{
}

/// changes to add orders and  Modifiers
ClassMethod GetModifiersbyEpID(EpisodeID As %Library.String, ByRef OrderName As %Library.String = "", ByRef Modifiers As %Library.String = "", ByRef MainMeal1 As %Library.String = "", ByRef MainMeal2 As %Library.String = "", ByRef MainMeal3 As %Library.String = "")
{
}

ClassMethod ConstructWardStr(Wards As %Library.String = "", Hosp As %Library.String = "") As %Library.String
{
}

ClassMethod FindDocCurrentAdmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDocCurrentAdmFetch ]
{
}

ClassMethod FindDocCurrentAdmExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", Doctor As %Library.String = "", Location As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", AbnormalResults As %Library.String = "", ResultStatus As %Library.String = "", OrderResults As %Library.String = "", NotRead As %Library.String = "", AllPatients As %Library.String = "", Resource As %Library.String = "", CURRLoc As %Library.String = "", TemporaryLocation As %Library.String = "", OPConsultRm As %Library.String = "", InpatAdmType As %String = "") As %Library.Status
{
}

ClassMethod FindDocCurrentAdmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDocCurrentAdmExecute ]
{
}

/// Log 58206 YC - TPN Assist & Kinetics
/// Used in oeorder.iv.csp and oeorder.med.csp
ClassMethod GetClinicalAssistParams() As %Library.String
{
}

ClassMethod GetOrdersAcrossAdms(PatientID As %Library.String = "") As %Library.String
{
}

/// Copy all orders from previous episode to current episode.
ClassMethod GetOrdersFrPrvEp(CurrEpisode As %Library.String, PatientID As %Library.String)
{
}

ClassMethod GetPatientLoc(OERowID As %Library.String = "", EpisodeID As %Library.String = "", ApptID As %Library.String = "") As %Library.String
{
}

ClassMethod GetPayorbyEpisodeID(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetPlanbyEpisodeID(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetPayorPlanbyEpisodeID(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetPrevEpisOrdStatus(adm As %Library.String = "", rea As %String = "")
{
}

ClassMethod GetPrevEpisode(pat As %Library.String = "", CurrEp As %Library.String = "")
{
}

ClassMethod GetPrevInpEpisode(pat As %Library.String = "", CurrEp As %Library.String = "")
{
}

ClassMethod GetSSGrpItem(SSGrpUnverified As %Library.String = "", ItemID As %Library.String = "") As %Library.String
{
}

ClassMethod GetUnverified(grpID As %Library.String = "", orderList As %Library.String = "") As %Library.String
{
}

ClassMethod CheckDBAccNum(orderList As %Library.String = "") As %Library.String
{
}

ClassMethod CheckRecLocation(orderList As %Library.String = "") As %Library.String
{
}

ClassMethod CreateNewDentalOrder(OrderRowID As %String = "", NewTeeth As %String = "", EpisodeID As %String = "") As %String
{
}

ClassMethod GetCareProvDetail(CProvID As %String = "", ContactMethod As %String = "") As %Library.String
{
}

ClassMethod UpdateCareProvDetail(CareProv As %String = "", ContactMethod As %String = "", ContactDetail As %String = "")
{
}

ClassMethod GetSSGrpItemCat(SSGroup As %Library.String = "", OERowID As %Library.String = "") As %Library.String
{
}

ClassMethod GetSampleExpiryDate(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetDateGroupHoldTest(PatientID As %Library.String) As %Library.String
{
}

ClassMethod GetTransfuseIDfromDesc(INDTRANSFDesc As %Library.String = "") As %Library.String
{
}

ClassMethod LookUpBrokerTransfusion(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpDBLabClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDBLabFetch ]
{
}

ClassMethod LookUpDBLabExecute(ByRef QHandle As %Library.Binary, CodeDesc As %String = "") As %Library.Status
{
}

ClassMethod LookUpDBLabFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDBLabExecute ]
{
}

ClassMethod OverridePayorPlan(OEORID As %Library.String = "", Payor As %Library.String = "", Plan As %Library.String = "")
{
}

ClassMethod RevertDietOrderStatus(EpisodeID As %Library.String = "", LeaveDate As %Library.String = "", LeaveTime As %Library.String = "", ActualReturnDate As %Library.String = "", ActualReturnTime As %Library.String = "")
{
}

ClassMethod SaveAllergyReason(ALGParams As %Library.String = "", DRGFlag As %Library.String = 0)
{
}

ClassMethod SetActionValues(NewOrder As %Library.String = "", EpisodeID As %Library.String = "", ActionTiming As %Library.String = "B", ByRef ActionItemString As %Library.String = "", Verify As %Library.String = "Y", ReceiptDate As %Library.String = "", ReceiptTime As %Library.String = "", CollectDate As %Library.String = "", CollectTime As %Library.String = "")
{
}

/// by wuqk 2011-06-01 未实现,不知逻辑
/// w ##class(web.OEOrder).EligibilityStatus(77273)
/// 基础数据可参考websys.StandardTypeItem
ClassMethod EligibilityStatus(EpisodeID As %String) As %Library.String
{
	quit ""
}

ClassMethod UpdateAction(NewOrderString As %Library.String = "", EpisodeIDString As %Library.String = "", extCodeString As %Library.String = "", TestSetString As %Library.String = "", RecurseString As %Library.String = "")
{
}

ClassMethod UpdateEpisodePayor(EpisodeID As %Library.String = "", Payor As %Library.String = "", Plan As %Library.String = "")
{
}

ClassMethod UpdateSummary()
{
}

ClassMethod ValidateLTAccNo(AccNo As %Library.String) As %Library.Boolean
{
}

ClassMethod checkDecisionSupport() As %Library.Boolean
{
}

ClassMethod websysChangeOrderStatus(compref As %Library.String = "", OrderString As %Library.String = "", NewStatus As %Library.String = "") As %Library.String
{
}

/// called from order alert screen
ClassMethod websysSaveAnswers()
{
}

Query Date(PAPMINo As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "datemax:%Date")
{
SELECT PAADM_AdmDate
FROM PA_Adm
WHERE (PAADM_PAPMI_DR->PAPMI_No = :PAPMINo)
}

Query FindAllergyItems(AllergyItemsList As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ORIRowID:%Library.String,ARCIMDesc:%Library.String,ARCIMRowId:%Library.String")
{
}

Query FindByPAAdm(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORDAdmDR:%String,OEORDDate:%Date,OEORDDoctorDR:%String")
{
SELECT OEORD_RowID, OEORD_Adm_DR, OEORD_Date, OEORD_Doctor_DR
FROM SQLUser.OE_Order
WHERE (OEORD_Adm_DR = :EpisodeID)
}

Query FindDBSpecimen() As %SQLQuery(CONTAINID = 1, ROWSPEC = "DBSPECDesc")
{
SELECT DBSPEC_Desc FROM SQLUser.CT_DBSpecimen
}

Query FindDSSMsg(NewOrders As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "ARCIMRowId,ARCIMDesc,ORIRowId,ErrorType,Message")
{
}

Query FindDrugIntItems(DrugIntString As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "mradm:%Library.String,RegNo:%Library.String,PatientID:%Library.String,EpisodeID:%Library.String,PatientTitle:%Library.String,ORIRowID:%Library.String,ARCIMDesc:%Library.String,IntWith:%Library.String,ARCIMRowId:%Library.String,Severity:%Library.String,DrugIntCategory:%Library.String,MonoGraphID:%Library.String,DrgIntType:%Library.String,intOEORIRowID:%Library.String,intpatid:%Library.String,intepid:%Library.String,intmradm:%Library.String")
{
}

Query FindAllergyItemsNew(AllergyString As %Library.String, ARCIMRowId As %Library.String, ORIRowID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ItemMast:%Library.String,orderrow:%Library.String,SeverityDR:%Library.String,SeverityPriority:%Library.String,SeverityMendatory:%Library.String,AllergyCategory:%Library.String,ARCIMDesc:%Library.String,AllergyType:%Library.String,xsensDesc:%Library.String")
{
}

Query FindLabEpisodeNo() As %Library.Query(CONTAINID = 0, ROWSPEC = "RegNo:%Library.String,mradm:%Library.String,PatientID:%Library.String,EpisodeID:%Library.String,PatientTitle:%Library.String,OEORIRowId:%Library.String,ItemMastID:%Library.String,ARCIMDesc:%Library.String,LabEpisodeNo:%Library.String")
{
}

Query FindLocWA(EpisodeID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "WATCTLOCDR")
{
SELECT WAT_Ward_DR->WARD_Desc
FROM SQLUser.PA_AdmWardAttend
WHERE WAT_ParRef=:EpisodeID
ORDER BY WAT_Date desc, WAT_Time desc
}

Query FindSSGrpUnverified(SSGroup, ItemID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Unverified")
{
SELECT ITM_UnverifOrder 
FROM SQLUser.SS_GroupOrderCategoryItems, SQLUser.SS_GroupOrderCategory, SQLUser.SS_Group
WHERE SSGRP_RowId=:SSGroup
AND SSORD_ParRef=SSGRP_RowId
AND SSORD_RowId=ITM_ParRef
AND ITM_ARCIM_DR=:ItemID
}

Query FindSSGrpUnverifiedCat(SSGroup, ItemID) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Unverified")
{
	SELECT	SSORD_RequireAuthorisation
	FROM	SQLUser.SS_GroupOrderCategory, SQLUser.OE_OrdItem
	WHERE	OEORI_RowId=:ItemID
	AND	SSORD_ParRef=:SSGroup
	AND	OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR=SSORD_OrdCat_DR
	AND ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR=SSORD_OrdSubCategory) OR (SSORD_OrdSubCategory IS NULL))
}

Query FindUnverifiedOrders(CareProvDesc As %String, WardDesc As %String, EpisodeDept As %String, RecLocDesc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Name:%String,Name2:%String,Name3:%String,RegNum:%String,WardDesc:%String,EpisodeDept:%String,AdmRowID:%String,ItemDesc:%String,CareProvDesc:%String,RecLocDesc:%String,StartDate:%Date,StartTime:%Time")
{
}

Query LookUpDBLab(Code As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "LabDesc:%Library.String,LabCode:%Library.String,HIDDEN:%Library.String")
{
}

Query LookUpIndicationTransfusion(desc As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT  INDTRANSF_Desc,INDTRANSF_Code,INDTRANSF_RowId
FROM SQLUser.OEC_IndicationTransfusion
WHERE ((%ALPHAUP INDTRANSF_Desc  [%ALPHAUP :desc) OR ( %ALPHAUP INDTRANSF_Code  [%ALPHAUP :desc))
ORDER BY INDTRANSF_Desc
}

Query FindDocCurrentAdm(TSRTITM As %String, TSRTORD As %String, Doctor As %Library.String, Specialty As %Library.String, dFrom As %Library.String, dTo As %Library.String, AbnormalResults As %Library.String, ResultStatus As %Library.String, OrderResults As %Library.String, NotRead As %Library.String, AllPatients As %Library.String, Resource As %Library.String, CURRLoc As %Library.String, TemporaryLocation As %String, OPConsultRm As %String, InpatAdmType As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PatientID,mradm,PAPMIEPRDescription:%String,PAPMIName:%String,PAPMIName2:%String,PAPMIName3:%String,PAPMINo:%String,PAADMAdmDate:%Date,PAADMAdmTime:%Time,CTLOCDesc:%String,Arrived:%String,PresComplt,MRDIADesc,PAADMAdmDocCodeDR,PAADMType,Ward:%String,Bed:%String,BookedWard:%String,BookedBed:%String,Hospital:%String,visstat:%String,refstatus:%String,medRecNo:%String,CurrWardDesc,HasResult:%String,InpatAdmType:%String,RespUnit:%String,Sex,DOB,Unit,DischargeDate:%String,RoomDesc:%String,TempLoc:%String,PAPMIName4:%String,PAPMIName5:%String,PAPMIName6:%String,PAPMIName7:%String,PAPMIName8:%String,VIPStatus,MedDischargeDate:%String,FinDischargeDate,BillFlag:%String")
{
}

ClassMethod FindPrefTabItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPrefTabItemsFetch ]
{
}

ClassMethod FindPrefTabItemsExecute(ByRef QHandle As %Library.Binary, TABITEMS As %Library.String = "", groupno As %Library.Integer = 0, getDetails As %Library.Boolean = 0, SSGroupID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPrefTabItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPrefTabItemsExecute ]
{
}

ClassMethod FindPrefTabListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPrefTabListFetch ]
{
}

ClassMethod FindPrefTabListExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindPrefTabListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPrefTabListExecute ]
{
}

/// Make sure you change the components and respective javascripts to reflect any changes, check notes on components for fields that use these delims.
/// OEOrder.PrefTabs.EditList
/// OEOrder.PrefTabs.Edit
ClassMethod GetPrefOEDelims(ByRef itemdataDelim As %Library.String = "", ByRef groupitemDelim As %Library.Integer = "", ByRef tabgroupDelim As %Library.Boolean = "", ByRef preflistDelim As %Library.Binary = "")
{
}

/// retrieves extra details for a particular order item or order set 
/// used for order entry preference groups.
/// intended to be used in order entry item lookup as well so data returned can be the same for both lookup and preferences
ClassMethod GetOEItemSelectedDetails(type As %Library.String = "", ordid As %Library.String = "", itemdataDelim As %Library.String = "") As %Library.String
{
}

/// retrieves name set for a particular group 'groupno' (group 1 to 5) for a particular tabitem (passed as a sting 'TABITEMS') from the order favaourites/preferences list
ClassMethod GetPrefTabGroupName(TABITEMS As %Library.String = "", groupno As %Library.Integer = 0) As %Library.String
{
}

/// retrieves details used for order entry preferences and preferences setup.
ClassMethod GetPrefTabs()
{
}

ClassMethod PharmItemSubstitution(OEOrdItemDR As %String, ItemMastDR As %String)
{
}

ClassMethod UpdateGroupNumber(OrderGroupNumber As %String, OrderRowIDs As %String) As %Library.String
{
}

ClassMethod VerifyScanOrders(NewOrders As %String = "")
{
}

ClassMethod websysDeletePrefTabs(compref As %Library.String = "")
{
}

/// Saves favourite orders into websys.Preferences
/// data=$lb(chart,chartframesize,tablist)
/// where chart=%String,chartframesize=%String, tablist=$lb(tab1,tab2,...,tabX)
/// where tabX=tabname_tabgroupDelim_grp1_tabgroupDelim_grp2_tabgroupDelim_..._tabgroupDelim_grp5_category_tabgroupDelim_subcategory
/// where tabname=%String,category=%String(id of OECOrderCategory),subcategory=%String(id of ARCItemCat)
/// and grpX=grpname_groupitemDelim_item1_groupitemDelim_item2_groupitemDelim_..._groupitemDelim_itemX
/// where grpname=%String and itemX=type_itemdataDelim_itemid
/// where type="ARCIM" or "ARCOS" and itemid=rowid of ARCItmMast or rowid of ARCOrdSet
/// tabgroupDelim,groupitemDelim,itemdataDelim defined in GetOrderEntryDelims
ClassMethod websysSavePrefTabs(compref As %Library.String = "", id As %Library.String = "")
{
}

/// used in order entry from 'AddToFav' link to update selected items to the first group of the user's preferences
ClassMethod websysSavePrefTabsUserAdd()
{
}

/// brings back each item for a particular group 'groupno' (group 1 to 5) for a particular tabitem (passed as a sting 'TABITEMS') from the order favaourites/preferences list
/// accepts a boolean 'getDetails' to determine whether to fetch extra details against ecah item.
/// getDetails = 0 (default) for preferences setup.
/// getDetails = 1 in order entry screen (oeorder.entry.redrawprefs.csp)
Query FindPrefTabItems(TABITEMS As %Library.String, groupno As %Library.Integer, getDetails As %Library.Boolean, SSGroupID As %Library.String, EpisodeID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

/// used in order entry preferences list
/// brings back each tab in the order favourites/preferences list
Query FindPrefTabList() As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

/// OLD ORDER FAVOURITES... shouldn't be used anymore
/// Saves favourite orders
/// data is a list of 5 grouplists
/// each grouplist is a list containing a name and a itemslist
/// each itemslist is a list containing a value and an id
/// the value contains the type (either "ARCIM" for order item or "ARCOS" for order set)
/// and an alias desc if the item is an alias, separated by an "*"
/// 
/// checks to see whether the save comes from the order entry page in which it only append the newly 
/// added item to the first group;
/// else saves all 5 groups
ClassMethod zwebsysSaveFavourites()
{
}

Query zFindFavouriteGroupItems(OEPARAMS, favgrp, GroupID, EpisodeID) As %Library.Query(CONTAINID = 0, ROWSPEC = "values,desc")
{
}

ClassMethod zFindFavouriteGroupItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = zFindFavouriteGroupItemsFetch ]
{
}

ClassMethod zFindFavouriteGroupItemsExecute(ByRef QHandle As %Library.Binary, OEPARAMS As %Library.String, favgrp As %Library.String, GroupID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod zFindFavouriteGroupItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = zFindFavouriteGroupItemsExecute ]
{
}

ClassMethod zSaveFavouritesAcrossGroup(usercode As %Library.String)
{
}

ClassMethod zwebGetFavouriteGroupNames(LocID As %Library.String = "")
{
}

ClassMethod CheckNonNegStock(OEOrdItemID As %Library.String = "", LocID As %Library.String = "")
{
}

/// Row change broker - 54852
ClassMethod UpdateListRowHandler(OEOrdItemID As %Library.String = "", DoseQty As %Library.String = "", Duration As %Library.String = "", Frequency As %Library.String = "", Priority As %Library.String = "", Instruc As %Library.String = "", RouteAdm As %Library.String = "", Qty As %Library.String = "", IVVol As %Library.String = "", IVVolUnit As %Library.String = "", IVTime As %Library.String = "", IVTimeUnit As %Library.String = "", FreqDelay As %Library.String = "", IVExpDur As %Library.String = "", MaxRpts As %Library.String = "", IVTypeCode As %Library.String = "")
{
}

/// Delete Row - 54852
/// log 61314 TedT allow to delete multiple orders
ClassMethod DeleteSessionItemHandler(OrdIDs As %String = "")
{
}

ClassMethod RetainValues()
{
}

// Query - JD New OE List Screen 54852

ClassMethod FindSessionOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSessionOrdersFetch ]
{
}

ClassMethod FindSessionOrdersExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod FindSessionOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSessionOrdersExecute ]
{
}

ClassMethod UpdateItemTempQty(deleteString As %String = "") As %Integer
{
}

ClassMethod CalcDoseUpd(compref As %Library.String = "", mradm As %String = "")
{
}

//Eliotc log 63900 start

ClassMethod SetDispbuomQty(OEORIItmMastDR As %String = "", UOMDesc As %String = "", FreqDesc As %String = "", Priority As %String = "", DurDesc As %String = "", DoseQty As %String = "", StartDate As %String = "") As %String
{
}

ClassMethod SetDispbuomQtyNoQtyCal(OEORIItmMastDR As %String = "", UOMDesc As %String = "") As %String
{
}

//Eliotc log 63900 end

/// log 63789 BoC
ClassMethod GetItemLink(OEORIROWIDs As %String = "") As %String
{
}

/// log 63789 BoC
ClassMethod GetExecutionDateAndTime(OEOrdItemID As %String = "") As %String
{
}

Query FindSessionOrders(EpisodeID As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,OEITMDesc,SttDate,SttTime,Dosage,Unit,Duration,Frequency,RecLoc,arcim,Priority,type,Instruc,Route,AdminRt,Qty,ARCIMPHCDFDR,IVType,IVVolume,IVVolUnit,IVTime,IVTimeUnit,OEITMName,TotVolume,PBSQuan,PBSCat,PBSRepeats,MaxRpts,OverrideID,FreqMins,MRAdm,OEORIPrescRepExpiryDate,OEORIPrescRepNumberDays,IVDoseFactor")
{
}

/// / 65489
ClassMethod CheckDeletes(delstring As %String = "")
{
}

}
