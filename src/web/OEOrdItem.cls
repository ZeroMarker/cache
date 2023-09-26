Include webimport

IncludeGenerator webimport

Class web.OEOrdItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6664;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod GetFilesOEOrdItemIDs(SavedFileName As %String = "") As %String
{
}

/// 	DL: Log 49666: 18/3/05
Query FindAllClinicalPathway(mrcpw As %String, CheckNurseWB As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORIItmMastDR,ARCIMDesc:%String,OEORIARCOSDR,ARCOSDesc:%String,OEORIDepProcNotes:%List,OECPRCode,OEORISttDat,OEORISttTim,ARCIMObservationGroupDR,ARCIMAdminQuestionnDR,OEORIDuratFactor,OEORIRMDuratFactor,OSTATCode,OEORIDateExecuted:%Date,OEORITimeExecuted:%Time,OEORIXDate:%Date,OEORIXTime:%Time,VRDesc,VCColour,OEORISeqNo,OEORIClinPathwaysDR,PHCFRDesc1,OSTATDesc")
{
SELECT OEORI_RowID, OEORI_ItmMast_DR, OEORI_ItmMast_DR->ARCIM_Desc, OEORI_ARCOS_DR, OEORI_ARCOS_DR->ARCOS_Desc, OEORI_DepProcNotes, OEORI_Priority_DR->OECPR_Code, OEORI_SttDat, OEORI_SttTim, OEORI_ItmMast_DR->ARCIM_ObservationGroup_DR, OEORI_ItmMast_DR->ARCIM_AdminQuestionn_DR, OEORI_Durat_DR->PHCDU_Factor, OEORI_RMDurat_DR->PHCDU_Factor, OEORI_ItemStat_DR->OSTAT_Code, OEORI_DateExecuted, OEORI_TimeExecuted, OEORI_XDate, OEORI_XTime, OEORI_VarianceReason_DR->VR_Desc, OEORI_VarianceReason_DR->VR_VarCateg_DR->VC_Colour, OEORI_SeqNo, OEORI_ClinPathways_DR, OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Desc1, OEORI_ItemStat_DR->OSTAT_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_ItemStat_DR->OSTAT_Code NOT='I') AND (OEORI_Priority_DR->OECPR_Code NOT='EP') AND (OEORI_ClinPathways_DR = :mrcpw) AND (OEORI_ClinPathways_DR = :mrcpw) AND ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_NurseWorkBench='Y' AND %UPPER :CheckNurseWB='YES') OR  :CheckNurseWB IS NULL)
}

Query FindAllNonClinicalPathway(EpisodeID As %String, CheckNurseWB As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORIItmMastDR,ARCIMDesc,OEORIARCOSDR,ARCOSDesc,OEORIDepProcNotes:%List,OECPRCode,OEORISttDat,OEORISttTim,ARCIMObservationGroupDR,ARCIMAdminQuestionnDR,OEORIDuratFactor,OEORIRMDuratFactor,OSTATCode,OEORIDateExecuted:%Date,OEORITimeExecuted:%Time,OEORIXDate:%Date,OEORIXTime:%Time,VRDesc,VCColour,OEORISeqNo,OEORIClinPathwaysDR,PHCFRDesc1,OSTATDesc")
{
SELECT OEORI_RowID, OEORI_ItmMast_DR, OEORI_ItmMast_DR->ARCIM_Desc, OEORI_ARCOS_DR, OEORI_ARCOS_DR->ARCOS_Desc, OEORI_DepProcNotes, OEORI_Priority_DR->OECPR_Code, OEORI_SttDat, OEORI_SttTim, OEORI_ItmMast_DR->ARCIM_ObservationGroup_DR, OEORI_ItmMast_DR->ARCIM_AdminQuestionn_DR, OEORI_Durat_DR->PHCDU_Factor, OEORI_RMDurat_DR->PHCDU_Factor, OEORI_ItemStat_DR->OSTAT_Code, OEORI_DateExecuted, OEORI_TimeExecuted, OEORI_XDate, OEORI_XTime, OEORI_VarianceReason_DR->VR_Desc, OEORI_VarianceReason_DR->VR_VarCateg_DR->VC_Colour, OEORI_SeqNo, OEORI_ClinPathways_DR, OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Desc1, OEORI_ItemStat_DR->OSTAT_Desc
FROM SQLUser.OE_OrdItem
WHERE NOT (OEORI_ItemStat_DR->OSTAT_Code='I') AND (OEORI_Priority_DR->OECPR_Code NOT='EP') AND (NOT (OEORI_Priority_DR->OECPR_Code='DIS') OR (OEORI_Priority_DR IS NULL)) AND (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) AND (OEORI_ClinPathways_DR IS NULL) AND (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_NurseWorkBench='Y') 
AND ((OEORI_ItemStat_DR->OSTAT_Code NOT= 'D') OR (
	SELECT	COUNT(OEORE_RowId) 
	FROM 	SQLUser.OE_OrdExec
	WHERE 	OEORE_OEORI_ParRef=OEORI_RowID
	AND 	OEORE_DateExecuted NOT='')>=1)
}

ClassMethod CheckAgeSexAndDosageRange(NewOrders As %String, UOM As %String, qty As %String, EpisodeID As %String, PatientID As %String) As %Library.String
{
}

/// Log 58325 BoC
ClassMethod CheckPregnBrFd(NewOrders As %String, EpisodeID As %String, PatientID As %String) As %Library.String
{
}

ClassMethod CheckOSItemsForSG(OrdSetID As %String) As %Library.String
{
}

ClassMethod GetQtyRange(ARCIMRowId As %String) As %Library.String
{
}

ClassMethod CheckQty(orderList As %Library.String = "") As %Library.String
{
}

/// Inputs:
/// array(columnnumber)=value as a reference to a table
/// 
/// Output:
/// 
/// array(columnnumber)=description from refrenced table
ClassMethod GetAuditDisplayInfo(ByRef aryColInfo As %Library.String) [ CodeMode = generator ]
{
}

ClassMethod GroupSecForOrdItem(GroupID As %String, CatID As %String, SubCatID As %String, ItemID As %String, IsOrdItmInOS As %String = "") As %Library.Boolean
{
}

ClassMethod GroupSecForOrdItemInOS(GroupID As %String, CatID As %String, SubCatID As %String, ItemID As %String) As %Library.Boolean
{
}

Parameter SQLCODE = "OEORI_RowId";

Parameter SQLDESCRIPTION = "OEORI_RowId";

Parameter SQLROWID = "OEORI_RowId";

Property dummy As %String(TRUNCATE = 1);

/// This method is now called from the Radiology Workbench from the following :
///  - OEOrdItemID item on component Voice.Link (Report)
///  - OEOrdItemID item on component WordDocRadiology.Link (Transcribe)
///  - OEOrdItemID item on component WordDocVerify.Link (Verify)
///  - epr.transcribetext.csp (Transcribe Text)
///  - epr.verifytextmulti.csp (Verify Text)
/// Logic now gets Associated "Word" Orders (Report, Transcribe, Verify), then,
///  and IF no associated "Word" Orders were found,
///  then gets Associated "Text" Orders (Transcribe Text, Verify Text).
ClassMethod AddAssocOrders(OERids As %Library.String = "") As %Library.String
{
}

ClassMethod ApptOrderStatus(ApptID As %Library.String = "") As %Library.String
{
}

ClassMethod RequestedRecievedProsthetics(OEOrdID As %Library.String = "", ApptID As %Library.String = "") As %Library.String
{
}

ClassMethod ArriveOrder(compref As %Library.String = "", ID As %Library.String = "")
{
}

/// Get Langauge Description from ID
ClassMethod CheckAbnormalResult(EpisodeID As %Library.String, Desc As %Library.String = "") As %Library.String
{
}

ClassMethod CheckMultipleLabNo(LabNo As %Library.String, EpisodeID As %Library.String) As %Library.Boolean
{
}

ClassMethod GetOrdItemDocs(rowid As %Library.String, mradmdr As %Library.String) As %Library.String
{
}

ClassMethod CheckMultipleOrders(EpisodeID As %String, Date As %String, ItemID As %String, SetID As %String) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod CheckEpisodeDates(OEOrdItemIDs As %String = "", AdmDate As %String = "", DischDate As %String = "", SttDateCust As %String = "")
{
}

ClassMethod CheckUserGroup(OEOrdItemIDs As %String = "", User As %String = "", PathwayDR As %Library.String = "", compref As %Library.String = "")
{
}

ClassMethod CheckNullOrInvalidStatus(OEOrdItemID As %String = "")
{
}

/// KK 07-Feb-2002 Log No:22637
/// To Change the WaitingList Status in PAwaitingList depending on OEORItemStatusDR in table OEOrdItem 
/// 
/// RQG Log30995
/// Previous code:
/// 	;KK 07-Feb-2002 Log No:22637
/// 	;RQG Log22637/12.03.02: Update the order status in the PAWaitingListRB
/// 	n WLid,obj,OEStatus,rowid,discont
/// 	s (WLid,obj,OEStatus,rowid,discont)=""
/// 	;
/// 	s discont=##Class(web.OECOrderStatus).GetIdFromCodeOrDescription("D")
/// 	q:OEOrdItemID=""
/// 	s obj=##Class(User.OEOrdItem).%OpenId(OEOrdItemID,0)
/// 	;RQG Log 22637,12.03.02: To check if WaitinglistID exists
/// 	;i obj s WLid=obj.OEORIWaitListDR.%Id()
/// 	i obj,obj.OEORIWaitListDR'="" s WLid=obj.OEORIWaitListDR.%Id()
/// 	d obj.%Close()
/// 	i WLid {
/// 		&sql(	SELECT	OEORI_RowId,OEORI_ItemStat_DR->OSTAT_Code
/// 			INTO 	:rowid,:OEStatus
/// 			FROM	SQLUser.OE_OrdItem
/// 			WHERE	(OEORI_WaitList_DR = :WLid)
/// 		)
/// 		i 'SQLCODE {
/// 			;RQG Log 22637,12.03.02: Change PAWaitingListRB depending on OEOrditem status
/// 			i OEStatus'="" d ##Class(web.PAWaitingListRB).WaitListRBChangeStatus(WLid,rowid,OEStatus)
/// 			;i ##Class(web.OECOrderStatus).GetIdFromCodeOrDescription("OEStatus")=discont d ##Class(web.PAWaitingListRB).SetWLStatusToDone(OEOrdItemID)
/// 		}
/// 	}
/// 	;
/// 	q
/// 
ClassMethod CheckandChangeWLStatus(OEOrdItemID As %Library.String)
{
}

ClassMethod ConvertDayBook(DBList As %Library.String = "") As %Library.String
{
}

ClassMethod DeleteOrder(OEORIROWIDs As %Library.String = "")
{
}

ClassMethod DisplaySensitivitiesButton() As %Library.String
{
}

ClassMethod FPGetOEDetails(EpisodeID As %Library.String, ByRef ARY As %Library.String)
{
}

ClassMethod FindLabEpisodeNoClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLabEpisodeNoFetch ]
{
}

ClassMethod FindLabEpisodeNoExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String, LabEpisNo As %Library.String) As %Library.Status
{
}

ClassMethod FindLabEpisodeNoFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLabEpisodeNoExecute ]
{
}

ClassMethod FindLabEpisodeNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %Library.String = "", LabEpisNo As %Library.String = "") As %Library.Boolean
{
}

ClassMethod FindMessage(ApptId As %Library.String, PatientID As %Library.String) As %Library.String
{
}

ClassMethod FindReceivingClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindReceivingFetch ]
{
}

/// Finds ordered items according to following search criteria:
/// 
/// CTLOCDesc: description of receiving location of order
/// DateFrom: cache date format for start date range of start date of order
/// DateTo: cache date format for end date range of start date of orders
/// RegNo: registration number of patient
/// CTPCPDesc: description of the ordering doctor of orders
/// OSTATDesc: status of order item: if status is AUTHORISED, locate verifed and authorised items
/// TestEpisodeNo: LabEpisodeNo of orders (lab or radiology orders)
/// ConsCTPCPDesc: Consulting doctor for order (for radiology orders, this is the radiologist)
/// 
/// Displays items by most recent start date grouped by patients episode orders.
ClassMethod FindReceivingExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", CTLOCDesc As %Library.String = "", DateFrom As %Library.Date = "", DateTo As %Library.Date = "", RegistrationNo As %Library.String = "", TestEpisodeNo As %Library.String = "", OSTATDesc As %Library.String = "", ConsCTPCPDesc As %Library.String = "", RESCDesc As %Library.String = "", OEORIAccessionNumber As %Library.String = "") As %Library.Status
{
}

ClassMethod FindReceivingFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindReceivingExecute ]
{
}

ClassMethod FindReceivingSortCheck(oeord As %Library.String = 0, oeori As %Library.String = 0, TSRTITM As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", ConsultDr As %Library.String = "", CTLOC As %Library.String = "", OSTATCode As %Library.String = "", OSTAT As %Library.String = "", VSTAT As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetAccessionDesc(OEORIROWIDs As %Library.String = "") As %Library.String
{
}

ClassMethod GetActiveDRByID(value As %Library.String) As %Library.String
{
}

/// For fetching data for multiple ordered items to web components.
/// By default, if only one ordered item(OEOrdItem) is passed retrieves all data,
/// but if more than one ordered item id is passed than only retrieve multiple item desc and ids (ARCItmMast) and blank for all else.
/// 
/// Passed in a string of OEOrdItem ids separated by "^".
ClassMethod GetAuthorisedDetails(OEOrdItemIDs As %Library.String = "")
{
}

/// This returns description,id,code (this is to be consitent with lookups)
/// 
/// TN:1-May-2002
/// overwrite generic code as it was not meaningful for this class
/// replace description with: patient registration number plus description of the code table order item (" : " separated)
/// replace the code with: the  rowid of the patient plus rowid of the code table order item ('^' separated)
ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

ClassMethod GetConsultDoctor(OEOrdItemID As %Library.String = "") As %Library.String
{
}

ClassMethod GetDayBook(LabCode As %Library.String = "") As %Library.String
{
}

ClassMethod GetEpisodeIdFromLabNo(labepisodeno As %Library.String) As %Library.String
{
}

ClassMethod GetExternalSystem(orderitem As %Library.String) As %Library.String
{
}

/// Log 63844 - 26.06.2007 - Returns Exam Abandon Reason Description
ClassMethod GetExamAbandonReason(OEOrdItemID As %Library.String = "") As %Library.String
{
}

Query GetItems(EpisodeID As %String, dfrom As %String, dto As %String, OrderedRowIDs As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "StartDate:%String,SeqNo:%String,OrderName:%String,HIDDEN:%String,num:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod GetItemsClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod GetItemsExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String, dfrom As %Library.String, dto As %Library.String, OrderedRowIDs As %Library.String) As %Library.Status
{
}

ClassMethod GetItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

ClassMethod GetLabEpisodeNo(oeorditemid As %Library.String) As %Library.String
{
}

ClassMethod GetLatestEpisodeID(PatientId As %Library.String = "") As %Library.String
{
}

ClassMethod GetLocations(UID As %Library.String) As %Library.String
{
}

ClassMethod GetOrderDefPriority(arcimid As %Library.String = "")
{
}

ClassMethod GetOrderLoc(OEORID As %Library.String = "") As %Library.String
{
}

/// oeorder.oplistcustom.csp中用到了
/// w ##Class(web.OEOrdItem).GetOrderSetDefaultID(74362)
ClassMethod GetOrderSetDefaultID(EpisodeID As %Library.String) As %Library.String
{
	Q ""
	s defaultSetID=""
	s mradmid=##class(web.PAAdm).GetMRAdm(EpisodeID)
	Set rs=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d rs.Execute(mradmid)
	For  Quit:'rs.Next()  Do
	.s defaultSetID=obj.Data("DSYMARCOSDR")
	.i defaultSetID'="" Quit
	d obj.Close()
	Q defaultSetID
	;d ##class(%ResultSet).RunQuery("web.MRDiagnos","FindDefaultOrderSet",74362)
}

ClassMethod GetPatientID(OEOrdItemID As %Library.String) As %Library.String
{
}

ClassMethod GetPatientIdFromLabNo(LabEpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetPatientOrderItems(PatientID As %Library.String, EpsiodeID As %Library.String) As %Library.String
{
	Q "^"
}

ClassMethod GetPatientsOrders(PatientID As %Library.String, EpsiodeID As %Library.String) As %Library.String
{
}

ClassMethod GetProcessingNotes(OrderID As %Library.String) As %Library.String
{
}

ClassMethod GetReferralDr(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetSpecCode(SpecDesc As %Library.String = "") As %Library.String
{
}

Method GetStartDateTime(ID As %Library.String = "", EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetUpdatedSpecCodes(OEORIROWID As %Library.String = "") As %Library.String
{
}

ClassMethod GetUserLastAddHosp(OEORIRowId As %Library.String = "") As %Library.String
{
}

/// rqg,Log25929:To return the waitlist status via orderitem passing OEOrdItemID
ClassMethod GetWaitListStatus(OEOrdItemID As %Library.String) As %Library.String
{
}

ClassMethod HasPatPaidForConsult(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod Insert(episID As %String, OECPRDesc As %String, OSTATDesc As %String, CTLOCDesc As %String, OEORISttDat As %String, OEORISttTim As %String, OEORIItemGroup As %String, OEORIQty As %String, OEORIRemarks As %String, OEORIDepProcNotes As %String, ORDERSETID As %String, OEORILabEpisodeNo As %String, OEORILab1 As %String, OEORILab2 As %String, OEORIDoseQty As %String, CTUOMDesc As %String, PHCFRDesc1 As %String, PHCINDesc1 As %String, PHCDUDesc1 As %String, OEORIMaxNumberOfRepeats As %String, OEORIItmMastDR As %String, specimens As %String, Appt As %String, mDate As %String, mTime As %String, DeptDesc As %String, CTPCPDesc As %String, CONSDesc As %String, OEORIWhoGoWhere As %String, OEORIPrice As %String, DOCTOR As %Library.String, OEORIRMFreqDR As %Library.String, OEORIRMDuratDR As %Library.String, OEORIBillDesc As %Library.String, BillPrice As %Library.String, OEORIMealTypeDR As %Library.String, OEORIRiceTypeDR As %Library.String, OEORIVolumeDR As %Library.String, OEORIEnergyDR As %Library.String, OEORIProtein As %Library.String, OEORIFat As %Library.String, OEORICarbohydrate As %Library.String, OEORIDelayMeal As %Library.String, OEORISterilizeUtelsis As %Library.String, OEORIPasterizeFood As %Library.String, OEORICoverMainIns As %Library.String, OEORIPortEquipReq As %Library.String, OEORIAdministerSkinTest As %Library.String, ItemText As %Library.String, RadNo As %Library.String, ContactCarProv As %Library.String, AlertReason As %Library.String, UserID As %Library.String, CareProvList As %Library.String, zOEORIRowId As %Library.String, NeedleGauge As %Library.String, NeedleType As %Library.String, BodySite As %Library.String, QuantityUnit As %Library.String, FlowQuantity As %Library.String, FlowTimeUnit As %Library.String, FlowTime As %Library.String, FlowRateUnit As %Library.String, Interval As %Library.String, Teeth As %Library.String, PATHWAYDR As %Library.String, Linked As %Library.String, VarReason As %Library.String, Modifiers As %Library.String, HotReport As %Library.String, ColDate As %Library.String, ColTime As %Library.String, FeedString As %Library.String, OEORIReasOrdCMVNegBlood As %Library.String = "", OEORICompXMatchReq As %Library.String = "", OEORIAutologousBloodReq As %Library.String = "", OEORIPatConsentObtained As %Library.String = "", OEORINoConsentOverrideReas As %Library.String = "", OEORIBBTAG1 As %Library.String = "", OEORIBBTAG2 As %Library.String = "", OEORIBBTAG3 As %Library.String = "", OEORIBBTAG4 As %Library.String = "", OEORIBBTAG5 As %Library.String = "", SpecSites As %Library.String = "", EndDate As %Library.String = "", OEORIRefDocDR As %Library.String = "", OEORIAccessionNumber As %Library.String = "", DBSpecType As %Library.String = "", LabVol As %Library.String = "", ReceivedDate As %Library.String = "", ReceivedTime As %Library.String = "", PatLoc As %Library.String = "", TempStat As %Library.String = "", TheatDate As %Library.String = "", ReqTheat As %Library.String = "", HL7Flag As %Library.String = "", UnitsColl As %Library.String = "", IncompReas As %Library.String = "", IndicateTransfusion As %Library.String = "", OEORIEndDate As %Library.String = "", OEORIEndTime As %Library.String = "", LinkedItmID As %Library.String = "", OEORIContOrderAfterDischarge As %Library.String = "", OEORIRoute As %Library.String = "", AuthDoctor As %Library.String = "", CopyOrderRowId As %Library.String = "", PrefConMethod As %Library.String = "", RefDoctorList As %Library.String = "", NotifyClinician As %Library.String = "", GroupID As %Library.String = "", refclincode As %Library.String = "", StartEndMealType As %Library.String = "", EligibilityStatus As %Library.String = "", OEORIFreqDelay As %Library.String = "", zPRNIndication As %Library.String = "", zPRNTotNumDoseAllow As %Library.String = "", zPRNMaxDose24hr As %Library.String = "", zRouteAdmin As %Library.String = "", zDayCycle As %Library.String = "", zOEORIQtyPackUOM As %Library.String = "", zLTClinCond As %Library.String = "", zProsthetic As %Library.String = "", zSpecialty As %Library.String = "", zLabelText As %Library.String = "", OEORIView As %Library.String = "", OEORIActivity As %Library.String = "", OEORIPrescRepExpiryDate As %Library.String = "", OEORIPrescRepNumberDays As %Library.String = "", OEORIMaxRepeats As %Library.String = "", OEORICurrRepeatNumber As %Library.String = "", OEORIAnnotateDR As %Library.String = "", OEORIConsultID As %Library.String = "", Urgent As %String = "", OEORIPreparationTime As %String = "")
{
}

ClassMethod InsertDiaryAppt(compref As %Library.String, PatientID As %Library.String, EpisodeID As %Library.String, rescID As %Library.String) As %Library.String
{
}

/// SA: This method created to add an order item to the selected episode
/// which has the description "Discharge Letter".
ClassMethod InsertDischargeLetterItem(compref As %Library.String, id As %Library.String, EpisodeID As %Library.String, FileName As %Library.String)
{
}

ClassMethod InsertItem(compref As %Library.String, id As %Library.String, hiddenCount As %Library.String = "")
{
}

ClassMethod InsertNewOrder()
{
}

ClassMethod InsertWordDoc(id As %Library.String, objID As %Library.String, DoctorID As %Library.String, Desc As %Library.String, UserCode As %Library.String, path As %Library.String, UserID As %Library.String, abnormal As %Library.String)
{
}

ClassMethod LookUpItmBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", DateRestriction As %Library.String = "", OrdCatGrp As %Library.String = "", Pharm As %Library.String = "", Param As %Library.String = "", Hospital As %Library.String = "") As %Library.Boolean
{
}

ClassMethod DBAccessionNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", AccessionNumber As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpItmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpItmFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// TN: 5-Nov-2002: new mod:
/// Accepts category and subcategory as descriptions, which will only be used if corresponding ids are blank.
/// Descriptions must be a match (not a startswith).
/// by wuqk 2011-06-14
/// d ##class(%ResultSet).RunQuery("web.OEOrdItem","LookUpItm","as",100)
ClassMethod LookUpItmExecute(ByRef QHandle As %Library.Binary, Order As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", LUCategoryDesc As %Library.String = "", LUSubCategoryDesc As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", DateRestriction As %Library.String = "", OrdCatGrp As %Library.String = "", Pharm As %Library.String = "", Param As %Library.String = "", Hospital As %Library.String = "") As %Library.Status
{
	/*
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s (ARCIMDesc,arcimRowid,HIDDEN,ARCIMTypeCalc,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN)=""
	s version=1,len=$l(Order)
	s Order1=Order
	s:Order1'="" Order1=$O(^ARCIM("0","Desc",Order),-1)
	f  s Order1=$O(^ARCIM("0","Desc",Order1)) q:(Order1="")||(($e(Order1,1,len)'=Order)&&(Order'=""))  d
	.s ID="" 
	.f  s ID=$O(^ARCIM("0","Desc",Order1,ID)) q:ID=""  d
	..s obj=##class(User.ARCItmMast).%OpenId(ID_"||"_version)
	..q:'$IsObject(obj)
	..s arcimRowid=ID_"||"_version
	..s ARCIMDesc=obj.ARCIMDesc 	;暂时这样写
	..s ARCIMTypeCalc=obj.ARCIMTypeCalc
	..s ^CacheTemp(repid,ind)=$lb(ARCIMDesc,arcimRowid,HIDDEN,ARCIMTypeCalc)
	..s ind=ind+1
	*/
	;Order, GroupID, Category, SubCategory, TYPE, LUCategoryDesc, LUSubCategoryDesc, 
	;EpisodeID, BillingGrp, BillingSubGrp, DateRestriction, OrdCatGrp, Pharm, Param, Hospital
	
	if LUCategoryDesc'="" {
		s CategoryID=$O(^OEC("ORCAT",0,"Desc",LUCategoryDesc,0))
		i CategoryID'="" s Category=CategoryID
	}
	i LUSubCategoryDesc'="" {
		s SubCategoryID=$O(^ARC("IC",0,"Desc",LUSubCategoryDesc,0))
		i SubCategoryID'="" s SubCategory=SubCategoryID
	}
	
	New repid, index
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	Set QHandle=$lb(0,repid,0)
	Set index=1
	
	if (Category'="")&(SubCategory="") d
	.i $$valordcat(GroupID,Category) d
	..s SubCategory=0 f  s SubCategory=$o(^ARC("IC",0,"OrdCat",Category,SubCategory)) q:SubCategory=""  d
	...set retval=$$open(SubCategory,Order,GroupID)
	...for  s retval=$$fetch(SubCategory,Order,GroupID) q:retval="100"  d
 	.... Do OutputRow
	...set retval=$$close()
	e  d
	.set retval=$$open(SubCategory,Order,GroupID)
	.for  s retval=$$fetch(SubCategory,Order,GroupID) q:retval="100"  d
 	.. Do OutputRow
	.set retval=$$close()

 	Quit $$$OK
 	
open(CATEG,TEXT,user) 
	k ^TMP($zn,$j)
	;;s ^zleon($zn,"o")=CATEG_"^"_TEXT_"^"_user
	s TEXT=$g(TEXT),CATEG=$g(CATEG)
	s TEXT1=$ZCVT(TEXT,"U")
	s TEXT=$ZCVT(TEXT,"U")
	;
	s DESC=0,ROW=0,TEXT0=TEXT 
	i TEXT,TEXT=+TEXT s TEXT0=TEXT_$c(1)
	s:TEXT0="" TEXT0=0
	;build list of categories for user
	k UserCat
	s ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  d
	.s s=^(ord)
	.s sssubcat=$p(s,"^",5)
	.if '$d(UserCat(+s)) d
	..s UserCat(+s)=$p(s,"^",3,4)_"^"_sssubcat
	.e  d
	..s UserCat(+s)=UserCat(+s)_"!"_sssubcat
	;decide which index to use
	s SubScr=$$subscr(CATEG)
	q 0
fetch(CATEG,TEXT,user) 
	 s TEXT=$g(TEXT),CATEG=$g(CATEG)
	 s TEXT1=$ZCVT(TEXT,"U")
	 s TEXT=$ZCVT(TEXT,"U")
	 s SubScr=$g(SubScr),DESC=$g(DESC),ROW=$g(ROW),TEXT0=$g(TEXT0)
	 k PLIST 
	 i CATEG="" g it3
	 i CATEG'="" g it31
it1 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,TEXT0)),DESC=""
it2 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it1 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 ;i $ZCVT(TEXT0,"U")'[TEXT q 100
	 ;i TEXT'=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC)),ROW=""
	 g:DESC="" it1
it3 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it1
	 s ROW=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW))
	 g:ROW="" it2
	 s ind=$o(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,""))
	 g:ind="" it3
	 s str=$g(^ARC("ALIAS",0,SubScr,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2),genflag=$p(str,"^",3)
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it3
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it3
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 s OrderType=""
	 if subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	 i (TYPE'="")&&(OrderType'=TYPE) g it3
	 i '$$valord(user,subCATEG,type,ROW1) g it3
	 i type="ARCIM",$$valrow(ROW1) g it3
	 i type="ARCOS",$$valarcos(ROW1) g it3
	 i $d(^TMP($zn,$j,type_"^"_ROW1)) g it3
	 s ^TMP($zn,$j,type_"^"_ROW1)=""
	 s flag=$s(TEXT0=DESC:"",ROW=ROW1:"",$g(^ARC("ALIAS",ROW))'="":$P($G(^ARC("ALIAS",ROW)),"^",6)_"-",type["ARCIM":$p($g(^ARCIM(+ROW1,1,8)),"^",21)_"-",1:"")
	 ;i type="ARCIM",flag="" d
	 i type="ARCIM" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 i type="ARCIM",genflag d
	 .s flag=$p($g(^ARCIM(+ROW1,1,"GEN",genflag)),"^",2)_"-"
	 i type["ARCIM" s err=$$selectarcim(ROW1) g:err it3 s desc=flag_desc q "ARCIM"
	 i type["ARCOS" s err=$$selectarcos(ROW1) g:err it3 s desc=flag_desc q "ARCOS"
	 q 0
 ;
it11 ;
	 s TEXT0=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0)),DESC=""
it21 q:TEXT0="" 100
	 ;i TEXT=+TEXT,$l(TEXT),$e($$ALPHAUP^SSUTIL4(TEXT0),1,$l(TEXT))'[TEXT g it11 ;q 100
	 i $l(TEXT),$e($ZCVT(TEXT0,"U"),1,$l(TEXT))'[TEXT q 100
	 s DESC=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC)),ROW=""
	 g:DESC="" it11
it31 q:$g(TEXT0)="" 100
	 g:$g(DESC)="" it11
	 s ROW=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW))
	 g:ROW="" it21
	 s ind=$o(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,""))
	 g:ind="" it21
	 s str=$g(^ARC("ALIAS",0,SubScr,+CATEG,TEXT0,DESC,ROW,ind))
	 s ROW1=$p(str,"^"),type=$p(str,"^",2)
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" g it31
	 i type="ARCOS" s subCATEG=$p($g(^ARCOS(+ROW1)),"^",9)
	 e  s subCATEG=$p($g(^ARCIM(+ROW1,1,1)),"^",10)
	 s OrderType=""
	 i subCATEG'="" s OrderType=$P(^ARC("IC",subCATEG),"^",7)
	 i (TYPE'="")&&(OrderType'=TYPE) g it31
	 i '$$valord(user,subCATEG,type,ROW1) g it31
	 i type="ARCIM",$$valrow(ROW1) g it31
	 i type="ARCOS",$$valarcos(ROW1) g it31
	 i $e($ZCVT(TEXT0,"U"),1,$l(TEXT1))'[TEXT1 g it31
	 s flag=$s(TEXT0=DESC:"",1:$P($G(^ARC("ALIAS",ROW)),"^",6)_"-")
	 i type="ARCIM",flag="" d
	 .s generdesc=$p($g(^ARCIM(+ROW,1,8)),"^",21)
	 .i $ZCVT(generdesc,"U")=TEXT0 s flag=generdesc_"-"
	 s err=0
	 i type["ARCIM" s err=$$selectarcim(ROW1) 
	 i type["ARCOS" s err=$$selectarcos(ROW1)
	 g:err it31 
	 ;s $p(PLIST(1),$c(2),2)=flag_$p(PLIST(1),$c(2),2) 
	 i $l(type),ROW1,$d(^TMP($zn,$j,type,ROW1_"^"_desc)) g it31
	 i $l(type),ROW1 s ^TMP($zn,$j,type,ROW1_"^"_desc)=""
	 i type="ARCIM" q "ARCIM"
	 i type="ARCOS" q "ARCOS"
	 q 0
close() k UserCat,TEXT,TEXT0
	 k ^TMP($zn,$j)
	 q 0
selectarcim(RowID)	k PLIST
	&SQL(SELECT ARCIM_RowId,ARCIM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCD_ParRef,ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,ARCIM_PHCDF_DR,
			ARCIM_RiceType_DR,ARCIM_RiceType_DR->RIC_Desc,ARCIM_ConsultDept,ARCIM_ConsultDept->CTLOC_Desc,
			ARCIM_ItemCat_DR,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,ARCIM_MealType_DR,ARCIM_MealType_DR->MEALT_Desc,
			ARCIM_PriceCostOnOrdering,ARCIM_InsSubCat_DR,ARCIM_DefPriority_DR,ARCIM_DefPriority_DR->OECPR_Desc,ARCIM_Code,
			ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Code,ARCIM_ItemCat_DR->ARCIC_OrderType,ARCIM_ItemCat_DR->ARCIC_OrdCat_DR,
			$LIST(ARCIM_OEMessage),ARCIM_RangeFrom,ARCIM_RangeTo,ARCIM_PHCDF_DR->PHCDF_CTUOM_DR->CTUOM_Desc,ARCIM_PHCDF_DR->PHCDF_PHCDU_DR,
			ARCIM_PHCDF_DR->PHCDF_GenRtForm_DR,ARCIM_ItemCat_DR->ARCIC_Desc,ARCIM_BillingUOM_DR->CTUOM_Desc,ARCIM_DerFeeRules_DR->DFR_Desc 
	   INTO :rowid,:desc,:code,:code1,:drgform,:rice,:ricedes,:cons,:consdes,
	        :subcat,:categ,:mealt,:mealtdes,:cost,:inssubcat,:prior,:priordesc,
	        :arcimcode,:phfreqcode,:subcatcode,:ordcatid,:oemessage,:rangefrom,:rangeto,:phuomdesc,:phdurrowid,:generic,:subcatdesc,:billuom,
	        :DerFeeRules
	   FROM Sqluser.ARC_ItmMast  WHERE ARCIM_RowId=:RowID)
	i 'SQLCODE d adjust1
	q SQLCODE
	;
adjust1	;
	s rowid=$p(rowid,$c(1))
	s generic=""
	;s desc=flag_desc
	s desc=desc_"-"_$p(flag,"-",1)			
	s Data=$lb(desc,rowid,"","ARCIM")
	q
selectarcos(RowID)	k PLIST
	&SQL(SELECT ARCOS_RowId,ARCOS_Desc,ARCOS_Code,ARCOS_LabTrakTestSet,ARCOS_DefPriority_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR->ARCIC_Desc
	       INTO :rowid,:desc,:code,:labsetrowid,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc
	       FROM SQLUser.ARC_OrdSets WHERE ARCOS_RowId=:RowID)
	;&SQL(SELECT ARCOS_Desc FROM SQLUser.ARC_OrdSets)
	i 'SQLCODE d adjust2
	q SQLCODE
adjust2	;
	s desc=$TR(desc,$C(13),"")
	s desc=flag_desc
	s subcatcode=""
	s Recloc=""
	s Data=$lb(desc,rowid,"","ARCOS")
	q
	;
valord(user,subCATEG,type,ROW1) ;validate usergroup and CATEGory
	 ;1-valid,0-invalid
	 n (UserCat,user,subCATEG,type,ROW1,EpisodeType,EpLoc,UserRowId)
	 s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	 Q:'user 1
	 i '$d(UserCat(+CATEG)) q 0
	 s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2),subcat=$p(s,"^",3)
	 Q:(subcat'="")&&(("!"_subcat_"!")'[("!"_subCATEG_"!")) 0
	 i type="ARCOS",os'="Y" Q 0
	 ;i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y",vis'="Y" q 0
	 i type="ARCIM",$p($g(^ARCIM(+ROW1,1,7)),"^",13)'["Y" Q 0
	 Q 1
	 ;
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
valordcat(user,CATEG)
	 ;1-valid,0-invalid
	 s found=0
	 s found=0,ord=0 f  s ord=$o(^SSU("SSGRP",+user,"SSORD",ord)) q:ord=""  q:found  s s=^(ord) d
	 .i '(s-CATEG) s found=1
	 q found
 ;        
ALPHAUP(val,remove)
 s %trans(1)="abcdefghijklmnopqrstuvwxyz !,""#$%&'()*+-./:;<=>@[\]^_`{|},~",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
UP(val,remove) 
 s %trans(1)="abcdefghijklmnopqrstuvwxyz",%trans(2)="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 q:'$d(remove) $tr(val,%trans(1),%trans(2)) q $tr(val,$tr(%trans(1),remove),%trans(2))
valrow(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>$h q 1
	 i dateto,dateto<$h q 1
	 q 0
valarcos(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
subscr(subCATEG) ;decide which index to use
	n (subCATEG,UserCat)
	;if order subcategory is blank, index can be :
	; Desc - all order items, order sets
	; DescI - all order items,no order sets
	; DescVI - visible order items, no order sets
	; DescVIOS - visible order items, order sets
	;if order subcategory is not blank, index can be :
	; OrderCat-Desc - all order items, order sets
	; OrderCat-DescI - all order items,no order sets
	; OrderCat-DescVI - visible order items, no order sets
	; OrderCat-DescVIOS - visible order items, order sets
	;
	;
	s CATEG=$p($g(^ARC("IC",+subCATEG)),"^",8)
	s subscr="NoItems"
	i CATEG,'$d(UserCat(+CATEG)) q subscr
	i CATEG d  q subscr
	.s s=UserCat(+CATEG),vis=$p(s,"^"),os=$p(s,"^",2)
	.i vis="Y",os="Y" s subscr="OrderCat-Desc"
	.i vis'="Y",os="Y" s subscr="OrderCat-DescVIOS"
	.i vis="Y",os'="Y" s subscr="OrderCat-DescI"
	.i vis'="Y",os'="Y" s subscr="OrderCat-DescVI"
	;
	;check what are settings of all order categories
	s vis="N",os="N"
	s cat="" f  s cat=$o(UserCat(cat)) q:cat=""  s s=UserCat(cat) d
	.i $p(s,"^")="Y" s vis="Y"
	.i $p(s,"^",2)="Y" s os="Y"
	i vis="Y",os="Y" s subscr="Desc"
	i vis'="Y",os="Y" s subscr="DescVIOS"
	i vis="Y",os'="Y" s subscr="DescI"
	i vis'="Y",os'="Y" s subscr="DescVI"
	q subscr
OutputRow
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariables
	///set (repid)=0
	quit
}

ClassMethod LookUpItmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpItmExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpLabNoByAdmRecDeptClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpLabNoByAdmRecDeptFetch ]
{
}

/// Similar to FindLabEpisodeNo with more restrictions by Type and Receiving Department
ClassMethod LookUpLabNoByAdmRecDeptExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String, LabEpisNo As %Library.String, type As %Library.String = "", RecDept As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpLabNoByAdmRecDeptFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpLabNoByAdmRecDeptExecute ]
{
}

ClassMethod LookUpLabNoByAdmRecDeptBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %Library.String = "", LabEpisNo As %Library.String = "", type As %Library.String = "", RecDept As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpLabTestItemClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpLabTestItemFetch ]
{
}

ClassMethod LookUpLabTestItemExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpLabTestItemFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpLabTestItemExecute ]
{
}

ClassMethod LookUpPatItmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPatItmFetch ]
{
}

ClassMethod LookUpPatItmExecute(ByRef QHandle As %Library.Binary, orderitem As %Library.String = "", OrdCategory As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpPatItmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPatItmExecute ]
{
}

ClassMethod OSItemListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = OSItemListFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// HiddenDelete is only there to pass on for paging
/// 计费组调用了--zhouzq 2012.06.26
/// d ##class(%ResultSet).RunQuery("web.OEOrdItem","OSItemList","",384)
ClassMethod OSItemListExecute(ByRef QHandle As %Library.Binary, itemtext As %Library.String = "", ORDERSETID As %Library.String = "", HiddenDelete As %Library.String = "", PatientID As %Library.String = "", EpisodeID As %Library.String = "", GroupID As %Library.String = "", formulary As %Library.String = "") As %Library.Status
{
	//ROWSPEC = "ItemRowid: ,OrderTypeCode: ,itmCatid: ,OEMessage: ,RangeFrom: 
	//RangeTo: ,UOM: ,defdur: ,desc: ,allergy: ,itmSubCatid:
	//DISABLED: ,Quantity: ,StockAvailable")	
	n repid	

	Set repid=$I(^CacheTemp)
	Set ind=1
	S ARCOSDateRowid=$$GetOrderSetDate(ORDERSETID) 
	if ARCOSDateRowid="" {
		set QHandle = $lb(0,repid,0)
		Q $$$OK
	}
	
	
 	S item=0 f  {
	 	s item=$o(^ARCOS(+ARCOSDateRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item)) 
	 	q:item=""  
	 	s s=^(item)
  		s (ItemRowid,OrderTypeCode,itmCatid,OEMessage,RangeFrom,RangeTo,UOM,defdur,desc,allergy,itmSubCatid,DISABLED,Quantity,StockAvailable)=""
		S ARCIMRowid=$p(s,"^",1)

 		continue:$$ValARCItem(ARCIMRowid)
		s ItemRowid=ARCIMRowid
 		s desc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
 		s Quantity=$p(s,"^",2)

 		;医嘱大类,子类,类型
 		s itmSubCatid="",itmCatid="",OrderTypeCode=""
 		s itmSubCatid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
 		i itmSubCatid'="" {
 			s itmCatid=$p($g(^ARC("IC",itmSubCatid)),"^",8)
 			s OrderTypeCode=$p($g(^ARC("IC",itmSubCatid)),"^",7)
 		}
 		s OEMessage=""
 		if $d(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),"OEM")){
	 		s msgchild=0 f {
		 		s msgchild=$O(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),"OEM",msgchild))
		 		Q:msgchild=""
		 		s msgText=$G(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),"OEM",msgchild))_"|"
		 		s OEMessage=OEMessage_msgText
	 		}
 		}
		if OEMessage="|" s OEMessage=""
		s RangeFrom=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),9)),"^",1)	    
		s RangeTo=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),9)),"^",2)

		s defdur=$p(s,"^",7)
		s UOMDR=$p(s,"^",10)
		s UOM=$S(UOMDR'="":$p($g(^CT("UOM",UOMDR)),"^",2),1:"")

	    s allergy=""
	    s DISABLED="T"
	    s StockAvailable=1
	    s data=$lb(ItemRowid,OrderTypeCode,itmCatid,OEMessage,RangeFrom,RangeTo,UOM,defdur,desc,allergy,itmSubCatid,DISABLED,Quantity,StockAvailable)
		d OutPutRow
 	}

	set QHandle = $lb(0,repid,0)
	Q $$$OK
OutPutRow
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q $$$OK
GetOrderSetDate(ARCOSRowid)
	n drow
	s DATE=$g(DATE) s:'DATE DATE=+$h
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q ARCOSRowid_"||"_drow
	
ValARCItem(ARCIMRowid)
	;validate if arcim is active 0-active,1-not active
	s datefrom=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",13)
	s dateto=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),7)),"^",1)
	i datefrom>+$h q 1
	i dateto,dateto<+$h q 1
	q 0
}

ClassMethod OSItemListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = OSItemListExecute ]
{
   n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OrdItemPriceClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = OrdItemPriceFetch ]
{
}

ClassMethod OrdItemPriceExecute(ByRef QHandle As %Library.Binary, EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %Library.String = "", uomstr As %Library.String = "", drugformstr As %Library.String = "", ordidstr As %String) As %Library.Status
{
}

ClassMethod OrdItemPriceFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = OrdItemPriceExecute ]
{
}

ClassMethod OrdItemCostClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = OrdItemCostFetch ]
{
}

ClassMethod OrdItemCostExecute(ByRef QHandle As %Library.Binary, EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %Library.String = "", uomstr As %Library.String = "", drugformstr As %Library.String = "", ordidstr As %String) As %Library.Status
{
}

ClassMethod OrdItemCostFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = OrdItemCostExecute ]
{
}

/// log 63874
ClassMethod RadCountTotal(TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", CTLOCDesc As %Library.String = "", DateFrom As %Library.Date = "", DateTo As %Library.Date = "", RegistrationNo As %Library.String = "", TestEpisodeNo As %Library.String = "", OSTATDesc As %Library.String = "", ConsCTPCPDesc As %Library.String = "", RESCDesc As %Library.String = "", OEORIAccessionNumber As %Library.String = "", ApptOnly As %Library.String = "", EpisodeType As %Library.String = "", resultstatusapex As %Library.String = "", resultstatuskestral As %Library.String = "", resultstatus As %Library.String = "") As %String
{
}

ClassMethod RadWorkBenchClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = RadWorkBenchFetch ]
{
}

/// Finds ordered items according to following search criteria:
/// 
/// CTLOCDesc: description of receiving location of order
/// DateFrom: cache date format for start date range of start date of order
/// DateTo: cache date format for end date range of start date of orders
/// RegNo: registration number of patient
/// CTPCPDesc: description of the ordering doctor of orders
/// OSTATDesc: status of order item: if status is AUTHORISED, locate verifed and authorised items
/// TestEpisodeNo: LabEpisodeNo of orders (lab or radiology orders)
/// ConsCTPCPDesc: Consulting doctor for order (for radiology orders, this is the radiologist)
/// 
/// Displays items by most recent start date grouped by patients episode orders.
ClassMethod RadWorkBenchExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", CTLOCDesc As %Library.String = "", DateFrom As %Library.Date = "", DateTo As %Library.Date = "", RegistrationNo As %Library.String = "", TestEpisodeNo As %Library.String = "", OSTATDesc As %Library.String = "", ConsCTPCPDesc As %Library.String = "", RESCDesc As %Library.String = "", OEORIAccessionNumber As %Library.String = "", ApptOnly As %Library.String = "", EpisodeType As %Library.String = "", resultstatusapex As %Library.String = "", resultstatuskestral As %Library.String = "", resultstatus As %Library.String = "") As %Library.Status
{
}

ClassMethod RadWorkBenchFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = RadWorkBenchExecute ]
{
}

ClassMethod RemoveDBSeq(specstr As %Library.String = "") As %Library.String
{
}

ClassMethod RetainValues()
{
}

ClassMethod IsPatientActive(PatientID As %String = "", compid As %String = "") As %Library.Boolean
{
}

ClassMethod SetInsertVars(compref As %Library.String, id As %Library.String, OrderedRowIDs As %Library.String = "", SaveDefaults As %Library.String = "")
{
}

ClassMethod LockClear(ID As %Library.String = "")
{
}

ClassMethod SetOrderDetailsFields()
{
}

ClassMethod getUnReadLabResultsAll(EpisodeIDs As %Library.String) As %Library.String
{
}

ClassMethod getUnReadResultCat(EpisodeID As %Library.String, ByRef descr As %Library.String = "") As %Library.String
{
}

ClassMethod websysSaveAuthorise(compref As %Library.String = "", OEOrdItemIDs As %Library.String = "", doAuthCheck As %Library.String = "")
{
}

ClassMethod websysSaveProcessingNotes()
{
}

ClassMethod websysSaveTranscribe(compref As %Library.String = "")
{
}

ClassMethod websysSaveVerified(compref As %Library.String = "", OEOrdItemIDs As %Library.String, FileName As %Library.String = "")
{
}

ClassMethod websysSaveWaitListDR(WaitingListID As %Library.String, OEOrdItemIDs As %Library.String)
{
}

/// grabs the comment from first MREvolution record, if no records then populate with Presenting Complaint
/// used in OEOrder.Custom component for field MREvolution (Current Condition)
ClassMethod GetCurrentCondition(mradm As %Library.String)
{
}

ClassMethod GetPatOrderItemTotalQty(PatientID As %String, ARCItmMastID As %String = "", OrderedDose As %Float = 0, NewDose As %Float = 0) As %Library.String
{
}

ClassMethod GetEpisodeOrderItemPrice(EpisodeID As %String, ARCItmMastID As %String = "", StartDate As %String = "", EndDate As %String = "", BillingGroupID As %String = "", OrderStatus As %String = "V") As %Float
{
}

ClassMethod GetEpisodeRoyalOrderPrice(EpisodeID As %String, RODR As %String = "", OrderStatus As %String = "V") As %Float
{
}

ClassMethod GetRadiologyStatusNew(OEOrdItemID As %Library.String) As %Library.String
{
}

ClassMethod GetEpisodeOrderItemQuantity(EpisodeID As %String, ARCItmMastID As %String = "", StartDate As %String = "", EndDate As %String = "", BillingGroupID As %String = "", OrderStatus As %String = "V", BillFlag As %String = "") As %Integer
{
}

Query Find(Desc) As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID,OEORNROWID,ARCICOrderType")
{
SELECT OEORI_ROWID, OEORI_OrdEnt_DR->OEORN_ROWID, OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType
FROM SQLUser.OE_OrdItem
WHERE OEORI_ROWID = :ID
}

Query FindAccessionDesc(OEORDItemID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc,id")
{
select ARCIM_Desc, OEORI_AccessionNumber from SQLUser.OE_OrdItem, SQLUser.ARC_ItmMast 
where OEORI_RowId=:OEORDItemID
AND OEORI_ItmMast_DR=ARCIM_RowId
}

Query FindByAppt(AppointmentID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OrdItemID")
{
SELECT OEORI_RowId
FROM SQLUser.OE_OrdItem
WHERE OEORI_APPT_DR=:AppointmentID
}

Query FindByPAAdm(EpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORISttDat:%Date,ARCIMDesc:%String,DoseQty:%String,CTUOMDesc:%String,PHCFRDesc1:%String,PHCDUDesc1:%String,PHCINDesc1:%String,OEORIDepProcNotes:%String,OEORIItmMastDR:%String,ARCIMFileNotes:%String,OEORIARCOSDR:%String,OEORIDoctorDR:%String,OEORIDate:%String,OEORITimeOrd:%String,OEORILabEpisodeNo:%String,ARCICOrderType:%String,ARCIMRowId:%String")
{
SELECT OEORI_RowID, OEORI_SttDat, 
OEORI_ItmMast_DR->ARCIM_Desc, 
OEORI_DoseQty, OEORI_Unit_DR->CTUOM_Desc, 
OEORI_PHFreq_DR->PHCFR_Desc1, 
OEORI_Durat_DR->PHCDU_Desc1, 
OEORI_Instr_DR->PHCIN_Desc1, 
OEORI_DepProcNotes,
OEORI_ItmMast_DR, 
OEORI_ItmMast_DR->ARCIM_FileNotes, 
OEORI_ARCOS_DR, 
OEORI_Doctor_DR->CTPCP_Desc,
OEORI_Date, 
OEORI_TimeOrd,
OEORI_LabEpisodeNo,
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
OEORI_ItmMast_DR->ARCIM_RowId
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
ORDER BY OEORI_Date DESC, OEORI_TimeOrd DESC
}

Query FindByParRef(param As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
SELECT Code, Description
FROM websys.StandardTypeItem
WHERE (ParRef = :param)
ORDER BY Description
}

Query FindCategByPAAdm(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORIItmMastDR:%String,ORCATIconName:%String,ORCATIconPriority:%String,ORCATDesc:%String,DefConsultDeptCode,DefConsultDeptDesc,ConsultDeptCode:%String,ConsultDeptDesc:%String")
{
SELECT OEORI_RowID, OEORI_ItmMast_DR, 
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_IconName, 
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_IconPriority, 
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc, 
OEORI_ItmMast_DR->ARCIM_ConsultDept->CTLOC_Code, 
OEORI_ItmMast_DR->ARCIM_ConsultDept->CTLOC_Desc, 
OEORI_ConsultDep_DR->CTLOC_Code, 
OEORI_ConsultDep_DR->CTLOC_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) AND (OEORI_ItemStat_DR->OSTAT_Code <> 'D')
}

Query FindClinicalPathway(mrcpw As %String, CheckNurseWB As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORIItmMastDR,ARCIMDesc:%String,OEORIARCOSDR,ARCOSDesc:%String,OEORIDepProcNotes:%List,OECPRCode,OEORISttDat,OEORISttTim,ARCIMObservationGroupDR,ARCIMAdminQuestionnDR,OEORIDuratFactor,OEORIRMDuratFactor,OSTATCode,OEORIDateExecuted:%Date,OEORITimeExecuted:%Time,OEORIXDate:%Date,OEORIXTime:%Time,VRDesc,VCColour,OEORISeqNo,OEORIClinPathwaysDR,PHCFRDesc1,OSTATDesc")
{
SELECT OEORI_RowID, OEORI_ItmMast_DR, OEORI_ItmMast_DR->ARCIM_Desc, OEORI_ARCOS_DR, OEORI_ARCOS_DR->ARCOS_Desc, OEORI_DepProcNotes, OEORI_Priority_DR->OECPR_Code, OEORI_SttDat, OEORI_SttTim, OEORI_ItmMast_DR->ARCIM_ObservationGroup_DR, OEORI_ItmMast_DR->ARCIM_AdminQuestionn_DR, OEORI_Durat_DR->PHCDU_Factor, OEORI_RMDurat_DR->PHCDU_Factor, OEORI_ItemStat_DR->OSTAT_Code, OEORI_DateExecuted, OEORI_TimeExecuted, OEORI_XDate, OEORI_XTime, OEORI_VarianceReason_DR->VR_Desc, OEORI_VarianceReason_DR->VR_VarCateg_DR->VC_Colour, OEORI_SeqNo, OEORI_ClinPathways_DR, OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Desc1, OEORI_ItemStat_DR->OSTAT_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_ClinPathways_DR = :mrcpw) AND ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_NurseWorkBench='Y' AND %UPPER :CheckNurseWB='YES') OR  %UPPER :CheckNurseWB!='YES')
AND OEORI_ItemStat_DR->OSTAT_Code NOT='D'
}

Query FindConsultationDept(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DefDeptCode,DefDeptDesc,ConsultDeptCode:%String,ConsultDeptDesc:%String")
{
SELECT OEORI_ItmMast_DR->ARCIM_ConsultDept->CTLOC_Code, OEORI_ItmMast_DR->ARCIM_ConsultDept->CTLOC_Desc, OEORI_ConsultDep_DR->CTLOC_Code,OEORI_ConsultDep_DR->CTLOC_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
}

Query FindDietOrders(EpisodeID As %Library.String, Date As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OEORIRowID:%String,ARCIMDesc:%String,ARCICOrderType:%String,ARCIMRowId:%String,ORCATIconName:%String")
{
SELECT OEORI_RowID,
OEORI_ItmMast_DR->ARCIM_Desc, 
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
OEORI_ItmMast_DR->ARCIM_RowId,
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_IconName
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
AND ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='D') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='S') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='DTF') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='E') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='H'))
AND (OEORI_ItemStat_DR->OSTAT_Code<>'D')
AND (OEORI_ItemStat_DR->OSTAT_Code<>'I')
AND (OEORI_SttDat=:Date)
}

Query FindDietOrdersNew(OrderID As %Library.String, Date As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OEORIRowID:%String,ARCIMDesc:%String,ARCICOrderType:%String,ARCIMRowId:%String,ORCATIconName:%String")
{
SELECT OEORI_RowID,
OEORI_ItmMast_DR->ARCIM_Desc, 
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
OEORI_ItmMast_DR->ARCIM_RowId,
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_IconName
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef = :OrderID)
AND ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='D') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='S') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='DTF') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='E') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='H'))
AND (OEORI_ItemStat_DR->OSTAT_Code<>'D')
AND (OEORI_ItemStat_DR->OSTAT_Code<>'I')
AND (OEORI_SttDat=:Date)
}

/// SA 19-Apr-2001: Implemented for ChartFX Graph
/// 
/// 15.5.01 - Execute/Fetch/Close written instead of query below to use Leon's uery
/// 
/// Old query:
/// 
/// SELECT	OEORI_DateExecuted, OEORI_TimeExecuted, OEORI_DoseQty
/// FROM	SQLUser.OE_OrdItem
/// WHERE	OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR = :PatientID
/// AND OEORI_ItmMast_DR = :OEItemID
/// AND (OEORI_DateExecuted > :StartDate OR :StartDate IS NULL OR ((OEORI_TimeExecuted > :StartTime OR :StartTime IS NULL) AND OEORI_DateExecuted = :StartDate))
/// AND (OEORI_DateExecuted < :EndDate OR :EndDate IS NULL OR (OEORI_TimeExecuted < :EndTime AND OEORI_DateExecuted = :EndDate))
/// AND OEORI_DateExecuted IS NOT NULL
/// AND OEORI_TimeExecuted IS NOT NULL
/// ORDER	BY OEORI_DateExecuted, OEORI_TimeExecuted
/// 
/// ;AND OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType = :OEItemType
/// KM 23-Mar-2001: For epr.timeline.csp
/// ;AND OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType = :OEItemType
Query FindForTimeline(EpisodeID As %Library.String, OEItemType As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,StartDate,FinishDate,OEItemID,OEItemDesc,OEItemType,StartTime")
{
SELECT  OEORI_RowID, OEORI_SttDat, OEORI_FinDate,
 OEORI_ItmMast_DR, OEORI_ItmMast_DR->ARCIM_Desc, 
 OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
 OEORI_TimeExecuted
FROM SQLUser.OE_OrdItem
WHERE OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID
ORDER BY OEORI_ItmMast_DR,OEORI_SttDat
}

Query FindLabEpisodeNo(EpisodeID As %String, LabEpisNo As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "EpisodeNo:%String,Descr:%String")
{
}

/// KM: 27-Feb-2001: Modified to be used by the PAADM Results Query which is 
/// called by the MRAdm.ListEMRResults Component.
/// 
/// KM: 25-Jul-2001: SQL Query Changed From:
/// SELECT	OEORI_RowId, OEORI_LabTestSetRow, OEORI_SttDat, OEORI_SttTim,
/// OEORI_ItmMast_DR->ARCIM_Desc,OEORI_ItemStat_DR->OSTAT_Code,
/// OEORI_ItemStat_DR->OSTAT_Desc,OEORI_DateRead,
/// OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_AdmNo
/// FROM	SQLUser.OE_OrdItem
/// WHERE	OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_PAPMI_DR=:PatientID
/// AND (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID OR :EpisodeID IS NULL) 
/// AND (OEORI_LabTestSetRow IS NOT NULL)
/// AND ((:catgsID [ (","_%INTERNAL(OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_",") 
/// AND OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR is NOT NULL) 
/// OR :catgsID is NULL)
/// AND ((OEORI_SttDat >= :dfrom) OR :dfrom is NULL)
/// AND ((OEORI_SttDat <= :dto) OR :dto is NULL)
/// 
/// Log 30564 - AI - 07-02-2003 : Add single line to get the Order Category:
/// OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc
/// and add this to the Row Specification.
Query FindLabForResultsProfile(EpisodeID As %String, catgsID As %String, dfrom As %Library.Date, dto As %Library.Date) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORILabTestSetRow,OEORISttDat,OEORISttTim,ARCIMDesc,StatusCode,StatusDesc,DateRead,EpisodeNo,OEORIDateExecuted,OEORILabEpisodeNo,OEORIPriorityDR,ARCICHL7ResultType,OEORITimeExecuted,OEORIEpisArriveDate,OEORIEpisArriveTime,OEORIFillerNo,OEORILabAction,ResultSensitive,Abnormal,RESAction,RESComment,OrderCategory:%String,OEORIItemDR,OEORISeriesNo,REFDDesc")
{
SELECT OEORI_RowId, OEORI_LabTestSetRow, OEORI_SttDat, OEORI_SttTim,
 OEORI_ItmMast_DR->ARCIM_Desc,OEORI_ItemStat_DR->OSTAT_Code,
 OEORI_ItemStat_DR->OSTAT_Desc,OEORI_DateRead,
 OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_AdmNo,
 OEORI_DateExecuted,
 OEORI_LabEpisodeNo,
 OEORI_Priority_DR,
 OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_HL7ResultType,
 OEORI_TimeExecuted,OEORI_EpisArriveDate,OEORI_EpisArriveTime,OEORI_FillerNo,
 OEORI_LabAction,
 OEORI_ItmMast_DR->ARCIM_Sensitive,
 OEORI_Abnormal,
 OEORI_Action_DR->Act_Desc,
 OEORI_ResultComments,
 OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc,
 OEORI_ItmMast_DR->ARCIM_RowID,
 OEORI_SeriesNo,
 OEORI_RefDoc_DR->REFD_Desc
FROM SQLUser.OE_OrdItem
WHERE OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID
 AND (OEORI_LabTestSetRow IS NOT NULL)
 AND ((:catgsID [ (','_%INTERNAL(OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR)_',') 
OR :catgsID is NULL))
 AND ((OEORI_SttDat <= :dto) OR (:dto = NULL))
 AND ((OEORI_SttDat >= :dfrom) OR (:dfrom = NULL))
}

Query FindMainMeals(OrderID As %Library.String, ARCIMRowId As %Library.String, Date As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MEALTDesc:%String")
{
SELECT Distinct OEORI_MealType_DR->MEALT_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef= :OrderID)
AND ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='D') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='E') OR (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='H'))
AND (OEORI_MealType_DR->MEALT_MainMeal='Y')
AND (OEORI_ItmMast_DR->ARCIM_RowId=:ARCIMRowId)
AND (OEORI_ItemStat_DR->OSTAT_Code<>'D')
AND (OEORI_SttDat=:Date)
AND (OEORI_MealType_DR->MEALT_Time>CURRENT_TIME)
}

Query FindNonClinicalPathway(EpisodeID As %String, CheckNurseWB As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OEORIItmMastDR,ARCIMDesc,OEORIARCOSDR,ARCOSDesc,OEORIDepProcNotes:%List,OECPRCode,OEORISttDat,OEORISttTim,ARCIMObservationGroupDR,ARCIMAdminQuestionnDR,OEORIDuratFactor,OEORIRMDuratFactor,OSTATCode,OEORIDateExecuted:%Date,OEORITimeExecuted:%Time,OEORIXDate:%Date,OEORIXTime:%Time,VRDesc,VCColour,OEORISeqNo,OEORIClinPathwaysDR,PHCFRDesc1,OSTATDesc")
{
SELECT OEORI_RowID, OEORI_ItmMast_DR, OEORI_ItmMast_DR->ARCIM_Desc, OEORI_ARCOS_DR, OEORI_ARCOS_DR->ARCOS_Desc, OEORI_DepProcNotes, OEORI_Priority_DR->OECPR_Code, OEORI_SttDat, OEORI_SttTim, OEORI_ItmMast_DR->ARCIM_ObservationGroup_DR, OEORI_ItmMast_DR->ARCIM_AdminQuestionn_DR, OEORI_Durat_DR->PHCDU_Factor, OEORI_RMDurat_DR->PHCDU_Factor, OEORI_ItemStat_DR->OSTAT_Code, OEORI_DateExecuted, OEORI_TimeExecuted, OEORI_XDate, OEORI_XTime, OEORI_VarianceReason_DR->VR_Desc, OEORI_VarianceReason_DR->VR_VarCateg_DR->VC_Colour, OEORI_SeqNo, OEORI_ClinPathways_DR, OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_PHCFR_DR->PHCFR_Desc1, OEORI_ItemStat_DR->OSTAT_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) AND (OEORI_ClinPathways_DR IS NULL) AND ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_NurseWorkBench='Y' AND %UPPER :CheckNurseWB='YES') OR  %UPPER :CheckNurseWB!='YES')
AND OEORI_ItemStat_DR->OSTAT_Code NOT='D'
}

/// KM 15-Nov-2001: Called From class query PAAdm.FindByLocType
Query FindOrdersByEpisodeAndCategory(EpisodeID As %Library.String, OrdCategID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OrderName,CategCode,CategDesc")
{
SELECT  OEORI_Rowid,
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_Desc,
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Code,
OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
AND (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Rowid = :OrdCategID)
}

/// SELECT OEORI_ItmMast_DR->ARCIM_Desc,OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc
/// FROM SQLUser.OE_OrdItem
/// WHERE OEORI_OEORD_ParRef->OEORD_Adm_DR = "32673"
/// 
/// 
/// AND (OEORI_ItmMast_DR->ARCIM_PHCDF_DR IS NOT NULL))
Query FindOrdersForAdm(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,PHCFDesc:%String,HIDDEN:%String")
{
SELECT DISTINCT BY (OEORI_ItmMast_DR) OEORI_ItmMast_DR->ARCIM_Desc,OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_PHCF_DR->PHCF_Desc,OEORI_ItmMast_DR->ARCIM_PHCDF_DR
FROM OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR= :EpisodeID)
AND (OEORI_ItmMast_DR->ARCIM_PHCDF_DR IS NOT NULL)
}

Query FindOtherBookedAppts(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ApptRowid")
{
SELECT APPT_RowId
FROM SQLUser.RB_Appointment
WHERE APPT_PAPMI_DR =:PatientID
}

/// Log 27725 - AI -  04-09-2002 :  Gets read result for a pateint episode.
/// 		Query called from method web.MRAdm.GotAnyResults.
/// 
Query FindReadLabResult(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CatDesc,OrderID:%String:""""")
{
SELECT distinct(OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc),OEORI_RowId
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
AND (OEORI_DateRead IS NOT NULL)
AND (OEORI_LabAction IS NOT NULL) 
AND (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code='LAB')
AND	(OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_HL7ResultType<>'IM')
}

/// Finds ordered items according to following search criteria:
/// 
/// CTLOCDesc: description of receiving location of order
/// DateFrom: cache date format for start date range of start date of order
/// DateTo: cache date format for end date range of start date of orders
/// RegNo: registration number of patient
/// CTPCPDesc: description of the ordering doctor of orders
/// OSTATDesc: status of order item: if status is AUTHORISED, locate verifed and authorised items
/// TestEpisodeNo: LabEpisodeNo of orders (lab or radiology orders)
/// ConsCTPCPDesc: Consulting doctor for order (for radiology orders, this is the radiologist)
/// 
/// Displays items by most recent start date grouped by patients episode orders.
Query FindReceiving(TSRTITM, TSRTORD, CTLOCDesc, DateFrom As %Date, DateTo As %Date, RegistrationNo, TestEpisodeNo, OSTATDesc, ConsCTPCPDesc, RESCDesc, OEORIAccessionNumber) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PatientID,EpisodeID,mradm,PAPMINo,PAPMIName,PAPMIName2,PAPMISex,PAPMIDOB:%Date,PAADMAdmNo,PAADMLocation,PAADMAdmDoc,ARCIMID,ARCIMDesc,OEORISttDat:%Date,OEORILabEpisodeNo,OEORIPriority,OEORIAPPTDR,APPTStatus,APPTDate:%Date,OEORIItemStatus,OEORIAuthorisedDate:%Date,OEORIDepProcNotes,OEORIDoctor,OEORIRecDep,OEOrdSubCat,OEORICoverMainInsur,OEORIPortableEquip,OEORIConsultDr,APPTTime:%Time,OEORIEpisArriveTime:%Time,OEORIEpisArriveDate:%Date,RESULTStatus,OrderCategory,ResType,EstDOB,OEORIWaitListDR,TempLoc,TempLocCode,OEORIAccessionNumberShow,OtherBookedAppts")
{
}

/// KM 14May2001:  Gets all unread results for ALL pateint episodes. 
/// Query called from method web.OEOrdItem.FindUnreadResultsAll
Query FindUnReadLabResult(EpisodeID As %String, CanViewSensitive) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CatDesc,OrderID:%String:""""")
{
SELECT distinct(OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR->ORCAT_Desc),OEORI_RowId
FROM SQLUser.OE_OrdItem
WHERE OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID
AND (OEORI_DateRead IS NULL)
AND (OEORI_LabAction IS NOT NULL) 
AND (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code='LAB')
AND	(OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_HL7ResultType<>'IM')
AND (((OEORI_ItmMast_DR->ARCIM_Sensitive='Y') AND (:CanViewSensitive='Y'))
OR ((OEORI_ItmMast_DR->ARCIM_Sensitive='N')OR(OEORI_ItmMast_DR->ARCIM_Sensitive IS NULL)))
}

/// Author - John Hart
/// Purpose - To get unexecuted lab orders
/// Used by - web.OEOrdItem2:FindIfAnyUnreadOrders
Query FindUnreadLabOrders(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCIMDesc")
{
SELECT OEORI_RowId, OEORI_ItmMast_DR->ARCIM_Desc
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID) AND (OEORI_DateRead IS NULL) AND (OEORI_LabTestSetRow IS NOT NULL) AND (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code='LAB')
}

/// KM 14May2001:  Gets all unread results for ALL pateint episodes. 
/// Query called from method web.OEOrdItem.FindUnreadResultsAll
Query FindUnreadLabResultsAll(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCIMDesc,DateRead")
{
SELECT OEORI_RowId, OEORI_ItmMast_DR->ARCIM_Desc, OEORI_DateRead 
FROM SQLUser.OE_OrdItem
WHERE OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID
AND (OEORI_DateRead IS NULL)
AND (OEORI_LabAction IS NOT NULL) 
AND (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_ExecCateg_DR->EXEC_Code='LAB')
}

Query LookUpByGroup(Order As %String, GroupID As %String) As %Query(CONTAINID = 1, ROWSPEC = "ARCIMDesc:%String,HIDDEN:%String")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpItm(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, LUCategoryDesc As %Library.String, LUSubCategoryDesc As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, DateRestriction As %Library.String, OrdCatGrp As %Library.String, Pharm As %Library.String, Param As %Library.String, Hospital As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpLabEpisodeOrders(labepisodeno As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ItemDesc")
{
	SELECT OEORI_RowID, OEORI_ItmMast_DR->ARCIM_Desc
	FROM SQLUser.OE_OrdItem
	WHERE (OEORI_LabEpisodeNo = :labepisodeno) and (NOT (OEORI_LabEpisodeSetup = 'Y') OR (OEORI_LabEpisodeSetup Is NULL))
}

/// Similar to FindLabEpisodeNo with more restrictions by Type and Receiving Department
Query LookUpLabNoByAdmRecDept(EpisodeID As %String, LabEpisNo As %String, type As %String, RecDept) As %Library.Query(CONTAINID = "", ROWSPEC = "EpisodeNo:%String,Descr:%String")
{
}

/// KM 21May2001: Called From Component OEOrdItem.ListEMR.Search.byResults
Query LookUpLabTestItem(desc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "descrip:%String,HIDDEN:%String")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpPatItm(orderitem As %String, OrdCategory As %String, EpisodeID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%Library.String,HIDDEN:%Library.String")
{
}

/// This query returns the "Billed" status of each consultation for an episode.  
/// This is used by MAX India  to determine is a consultation service 
/// has been paid for.
Query LookupConstBilledByAdm(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Billed,rowid")
{
SELECT OEORI_Billed,OEORI_RowId
FROM SQLUser.OE_OrdItem
WHERE (OEORI_OEORD_ParRef->OEORD_Adm_DR = :EpisodeID)
AND (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='C')
}

/// HiddenDelete
Query OSItemList(itemtext As %Library.String, ORDERSETID, HiddenDelete, PatientID As %Library.String, EpisodeID As %Library.String, GroupID As %Library.String, formulary As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ItemRowid:%String,OrderTypeCode:%String,itmCatid:%String,OEMessage:%String,RangeFrom:%String,RangeTo:%String,UOM:%String,defdur:%String,desc:%String,allergy:%String,itmSubCatid:%String,DISABLED:%String,Quantity:%String,StockAvailable:%String")
{
}

Query OrdItemPrice(EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %String, uomstr As %String, drugformstr As %String, ordidstr As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Item:%String,Qty:%String,Price:%Library.Currency,Total:%Library.Currency")
{
}

Query OrdItemCost(EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %String, uomstr As %String, drugformstr As %String, ordidstr As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Item:%String,Qty:%String,Price:%Library.Currency,Total:%Library.Currency")
{
}

/// Finds ordered items according to following search criteria:
/// 
/// CTLOCDesc: description of receiving location of order
/// DateFrom: cache date format for start date range of start date of order
/// DateTo: cache date format for end date range of start date of orders
/// RegNo: registration number of patient
/// CTPCPDesc: description of the ordering doctor of orders
/// OSTATDesc: status of order item: if status is AUTHORISED, locate verifed and authorised items
/// TestEpisodeNo: LabEpisodeNo of orders (lab or radiology orders)
/// ConsCTPCPDesc: Consulting doctor for order (for radiology orders, this is the radiologist)
/// 
/// Displays items by most recent start date grouped by patients episode orders.
Query RadWorkBench(TSRTITM, TSRTORD, CTLOCDesc, DateFrom As %Date, DateTo As %Date, RegistrationNo, TestEpisodeNo, OSTATDesc, ConsCTPCPDesc, RESCDesc, OEORIAccessionNumber, ApptOnly, EpisodeType, resultstatusapexCode, resultstatuskestralCode, resultstatusCode) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,PatientID,EpisodeID,mradm,PAPMINo,PAPMIName,PAPMIName2,PAPMIName3,PAPMIName4,PAPMIName5,PAPMIName6,PAPMIName7,PAPMIName8,PAPMISex,PAPMIDOB:%Date,PAPMIAGE,PAADMAdmNo,PAADMLocation,PAADMAdmDoc,ARCIMID,ARCIMDesc,OEORISttDat:%Date,OEORILabEpisodeNo,OEORIPriority,OEORIAPPTDR,APPTStatus,APPTDate:%Date,OEORIItemStatus,OEORIAuthorisedDate:%Date,OEORIDepProcNotes,OEORIDoctor,OEORIRecDep,OEOrdSubCat,OEORICoverMainInsur,OEORIPortableEquip,OEORIConsultDr,APPTTime:%Time,OEORIEpisArriveTime:%Time,OEORIEpisArriveDate:%Date,RESULTStatus,OrderCategory,ResType,EstDOB,OEORIWaitListDR,TempLoc,TempLocCode,OEORIAccessionNumberShow,OtherBookedAppts,APPTRoomDesc,EQPDesc,SupResFlag,OEORIOrdDept,Decease,PatientLocation,bed,ward,DocumentList,ResultAvailableDate,TextResultID,room,transcriptionist,DeliveryID,VIPStatus,Color,ItemStatusCode,ResDesc,Urgent,time,TextCode,CurrTextIdx,CurWordRes,voiceFile,QMNo,ExamAbandonReason,apptPrepArrivalTime,ExecuteDate,ExecuteTime,PersonID")
{
}

Query zzItemSensitivityList(LabEpisodeID As %String, TestSetCode As %String, TestItemCode As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,AntiB:%String,Sensitivity:%String")
{
}

ClassMethod DeleteUserDefaults(ItmMastIDs As %String, User As %String) As %Integer
{
}

ClassMethod UpdateLabCondition(LabEpID As %String, ClinCondID As %String) As %Integer
{
}

// JPD 11/7/05 (52132)

// returns Clinical Condition values from LabTrak code tables.

Query FindLabTrakClinCond(val As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String")
{
}

ClassMethod FindLabTrakClinCondClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLabTrakClinCondFetch ]
{
}

ClassMethod FindLabTrakClinCondExecute(ByRef QHandle As %Library.Binary, val As %String = "") As %Library.Status
{
}

ClassMethod FindLabTrakClinCondFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLabTrakClinCondExecute ]
{
}

// JPD 8/8/05 (54454)

// returns DayBook Site values from LabTrak code tables.

Query FindDBSiteCode(lab As %String, site As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String")
{
}

ClassMethod FindDBSiteCodeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDBSiteCodeFetch ]
{
}

ClassMethod FindDBSiteCodeExecute(ByRef QHandle As %Library.Binary, lab As %String = "", site As %String = "") As %Library.Status
{
}

ClassMethod FindDBSiteCodeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDBSiteCodeExecute ]
{
}

ClassMethod AddIngredients(compref As %Library.String)
{
}

ClassMethod DeleteIngredients()
{
}

/// Log 58325 BoC, created for tkMakeServerCall as tkMakeServerCall can't call routine
ClassMethod PregnBrFd(PatID, arcim, ORIRowID, SttEndDate, EpisodeID, duration)
{
}

/// Log 60866 save labeltext
ClassMethod SaveLabelText(compref As %Library.String, ORIRowID As %Library.String)
{
}

//log61703 TedT

ClassMethod TMPPriceOrderIDs(ordids As %String, ordset As %String) As %String
{
}

/// log 63684
ClassMethod GetStandardTypeLookupResult(type As %Library.String = "", desc As %Library.String = "") As %Library.String
{
}

}
