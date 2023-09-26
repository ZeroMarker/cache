Class web.PAWaitingList Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2150;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WL_RowId";

Parameter SQLDESCRIPTION = "WL_RowId";

Parameter SQLROWID = "WL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod AddLinkWLPread(id As %Library.String, widstr As %Library.String)
{
}

ClassMethod UnLinkWLFromADm(id As %Library.String, widstr As %Library.String)
{
}

ClassMethod AustinRemoveReinstate(id)
{
}

ClassMethod AfterDeferredDischarge(id As %Library.String) As %Library.String
{
}

ClassMethod ChangeWLOrdItmStatus(WLid As %Library.String, status As %Library.String)
{
}

/// RQG,Log23839,26.03.02: This method will check for deceased patient using the selected waitinglist. 
///                                            The aim is to not allow editing of waiting list details for deceased patient.
ClassMethod CheckDeceased(WIDStr As %Library.String) As %Library.String
{
}

ClassMethod CheckForAlreadyOnList(compref As %Library.String, PatientID As %Library.String, Speciality As %Library.String, WaitingListID As %Library.String, DoctorID As %Library.String, SPPPDesc As %Library.String) As %Library.Boolean
{
}

/// KK 20/May/2002 Log 24478 chek if the patient is currently an inpatient
ClassMethod CheckForInpatient(PatientID As %Library.String) As %Library.String
{
}

/// log 33074
ClassMethod CheckPreadOnRemove(WaitingListID As %Library.String = "") As %Library.String
{
}

ClassMethod CheckSuspension(compref As %Library.String, id As %Library.String, PARREF As %Library.String, date As %Library.String) As %Library.Boolean
{
}

ClassMethod CopyWLDetailsToReferral(WaitingListID As %Library.String, EpisodeID As %Library.String, ApptCareProv As %Library.String = "")
{
}

/// This routine is to delete multiple removals (or re-instatments) and return the waiting lists
/// to their original state (and removing the transaction history)
ClassMethod DeleteRemoveOrReinstate(ids As %Library.String)
{
}

ClassMethod DisableWL(WLId As %Library.String = "")
{
}

ClassMethod CheckExceedGD(wlID As %String, bookDate As %Date, user As %String, transfer As %String) As %String
{
}

/// log 63075 TedT input parameter changed, original: CTLOC As %Library.String, EpST As %Library.String, HCR As %Library.String, Oper As %Library.String
ClassMethod FindGuaranteedDays(id As %Library.String) As %Library.String
{
}

ClassMethod FindActiveWLAppt(WaitID As %Library.String) As %Library.String
{
}

/// GR 4/2/02
/// This will return the next Operative Episode for a Patient on a waiting list
/// Ref log 22659
ClassMethod FindOperativeEpisode(id As %Library.String, PatientId As %Library.String, Mode As %Library.String) As %Library.String
{
}

ClassMethod FindSpecOperativeEpisode(PatientId As %Library.String) As %Library.String
{
}

ClassMethod GetActiveWLs(ID As %Library.String) As %Library.String
{
}

ClassMethod GetAllWLForPatient(WLIds As %Library.String) As %Library.String
{
}

/// RQG,Log23771,04.04.02: This function strips the order item id and description from the delimited string.
/// The 'retcode' defines the string to return, ie. "I" for order item id's and "D" for order item descriptions.
ClassMethod GetArcIMDetails(arcimstr As %Library.String, retcode As %Library.String) As %Library.String
{
}

ClassMethod GetActiveAdmissionWard(PatientID As %Library.String, WaitingListID As %Library.String) As %Library.String
{
}

ClassMethod GetDaysOnList(WaitingListID As %Library.String) As %Library.String
{
}

/// SA - log 24114: Method used by component PAWaitingListPriority.Edit
ClassMethod GetLastPriorityUpdateDetails(WaitingListID As %Library.String, TRANSRowId As %String = "")
{
}

/// this is for the component PAWaitingListTransfer.New to get the details for last update user, time and date
ClassMethod GetLastTransferUpdateDetails(WaitingListID As %String)
{
}

ClassMethod GetListReason(ID As %Library.String) As %Library.String
{
}

ClassMethod GetListType(ID As %Library.String) As %Library.String
{
}

/// RQG Log23652,18.03.02: This method is called whenever there is an order associated with the waitinglist.
/// The aim is to restricts the list type lookup selection to the value set in the location field.
/// 
ClassMethod GetOrderItemDetails(OEOrdItemID As %Library.String) As %Library.String
{
}

/// SA - log 24114: Method used by component PAWaitingListPriority.Edit
/// From the log description:
/// The "Priority Reassignment Date" must not be less than the date of the last Priority increase entered. 
/// For example, if a patient is reassigned to a Priority of "2" from a priority of "3" on the 01/04/02 and 
/// then reassigned to "1" on the 05/04/02 the "Priority Reassignment Date" must have a check whereby 
/// the date entered on the 05/04/02 into the "Priority Reassignment Date" field is not less than the 01/04/02." 
/// 
/// This method retrieves the last and next reassignment dates, to allow the edit checks to be made by the 
/// standard javascript PAWaitingListPriority.Edit.js
ClassMethod GetPriorityReassignDetails(WaitingListID As %Library.String, TRANSRowId As %String = "")
{
}

/// rqg,Log24863: Will return the appointment date of the passed parameter WLID
ClassMethod GetWLApptDate(WaitingListID As %Library.String) As %Library.String
{
}

ClassMethod GetWLDetails(ID As %Library.String) As %Library.String
{
}

ClassMethod GetWLStatus(WaitingListID As %Library.String, EpisodeID As %Library.String) As %Library.String
{
}

/// log63014 TedT used in RBAppointment.find layout
ClassMethod GetWLCTLOC(WaitingListID As %String = "") As %String
{
}

/// log63014 TedT used in RBAppointment.find layout
ClassMethod GetWLDoctor(WaitingListID As %String = "") As %String
{
}

/// log63014 TedT used in RBAppointment menu transition expression 
ClassMethod GetWLCreatingAdmission(WaitingListID As %String = "") As %String
{
}

ClassMethod LookUpRestrictedWLTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRestrictedWLTypeFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpRestrictedWLTypeExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpRestrictedWLTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRestrictedWLTypeExecute ]
{
}

ClassMethod LookUpWLLinktoAdmClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWLLinktoAdmFetch ]
{
}

ClassMethod LookUpWLLinktoAdmExecute(ByRef QHandle As %Library.Binary, PatId As %String, AdmDate As %String) As %Library.Status
{
}

ClassMethod LookUpWLLinktoAdmFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWLLinktoAdmExecute ]
{
}

ClassMethod ORMISComplete(WLId As %Library.String)
{
}

ClassMethod ReverseORMISComplete(WLId As %Library.String)
{
}

ClassMethod ORMISCancel(compref As %Library.String, WLId As %Library.String, CancelDate As %Library.String = "", CancelTime As %Library.String = "", CancelReason As %Library.String = "", CancelComment As %Library.String = "", UserID As %Library.String = "", WLRGDesc As %Library.String = "")
{
}

ClassMethod RemoveReinstate(compref As %Library.String, ids As %Library.String, remove As %Library.String)
{
}

ClassMethod ReverseDeferredDischarge(id As %Library.String, compid As %Library.String) As %Library.String
{
}

ClassMethod WaitListHistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = WaitListHistoryFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod WaitListHistoryExecute(ByRef QHandle As %Library.Binary, WaitingListID As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod WaitListHistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = WaitListHistoryExecute ]
{
}

ClassMethod WaitListPriorityClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = WaitListPriorityFetch ]
{
}

ClassMethod WaitListPriorityExecute(ByRef QHandle As %Library.Binary, WaitingListID As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod WaitListPriorityFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = WaitListPriorityExecute ]
{
}

ClassMethod WaitingListInquiryGetTotal(TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PatientID As %Library.String = "", LocDesc As %Library.String = "", HospDesc As %Library.String = "", CareProvDesc As %Library.String = "", ListTypeCode As %Library.String = "", StatusDesc As %Library.String = "", PriorityDesc As %Library.String = "", ReasonDesc As %Library.String = "", Activity As %Library.String = "", OperDesc As %Library.String = "", ShortNotice As %Library.String = "", HiddenFindParam As %Library.String) As %Library.String
{
}

ClassMethod WaitingListInquiryInitParams(TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PatientID As %Library.String = "", LocDesc As %Library.String = "", HospDesc As %Library.String = "", CareProvDesc As %Library.String = "", ListTypeDesc As %Library.String = "", StatusDesc As %Library.String = "", PriorityDesc As %Library.String = "", ReasonDesc As %Library.String = "", Activity As %Library.String = "", OperDesc As %Library.String = "", ShortNotice As %Library.String = "", HiddenFindParam As %Library.String) As %Library.List
{
}

ClassMethod WaitingListInquiryListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = WaitingListInquiryListFetch ]
{
}

ClassMethod WaitingListInquiryListExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", PatientID As %Library.String = "", LocDesc As %Library.String = "", HospDesc As %Library.String = "", CareProvDesc As %Library.String = "", ListTypeDesc As %Library.String = "", StatusDesc As %Library.String = "", PriorityDesc As %Library.String = "", ReasonDesc As %Library.String = "", Activity As %Library.String = "", OperDesc As %Library.String = "", ShortNotice As %Library.String = "", HiddenFindParam As %Library.String) As %Library.Status
{
}

ClassMethod WaitingListInquiryListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = WaitingListInquiryListExecute ]
{
}

/// KM 8-Aug-2001: Called from web.PAAdm.websysSave() and from web.RBAppointment.InsertAppt()
/// BC 12-Dec-2001: Audit trail added
ClassMethod changeWLStatus(id As %Library.String, newstatus As %Library.String, PAWLAdmRowID As %Library.String = "", EffectiveDate As %Library.String = "", ReasonCode As %Library.String = "", TransactionCode As %Library.String = "", BookingNumber As %Library.String = "", TCIStatus As %Library.String = "", ApptDate As %Library.String = "")
{
}

/// KM 8-Aug-2001: Called From "Waiting List Inquiry" workflow on conditional
/// expression on workflow item "Waiting List List".  so that workflow goes straight to
/// Edit component if there is only one entry on the waiting list for this patient.
ClassMethod checkForActiveEntriesOnWLsOLD(PatientID As %Library.String) As %Library.String
{
}

ClassMethod checkForActiveEntriesOnWLs(PatientID As %Library.String) As %Library.String
{
}

/// KM 8-Aug-2001: Called From "Waiting List Inquiry" workflow on conditional
/// expression on workflow item "Waiting List List".  so that workflow goes straight to
/// Edit component if there is only one entry on the waiting list for this patient.
ClassMethod checkForEntriesOnWLs(PatientID As %Library.String) As %Library.String
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %Library.String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeRemoveReinstate(compref As %String, id As %String) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, id As %String) As %Boolean
{
}

/// To delete the waiting list entry and ALL transactions that are associated with it.
/// 
ClassMethod websysDelete(compref As %Library.String, WaitingListID As %Library.String)
{
}

/// SA 13.6.02 - log 24114: Method to be called from Update in component PAWaitingListPriority.Edit
ClassMethod websysSavePriority(compref As %Library.String, TRANSRowId As %Library.String = "", WaitingListID As %Library.String = "", Priority As %Library.String = "", NextReassignDate As %Library.String = "", LastReassignDate As %Library.String = "")
{
}

/// rqg,Log24512: Will save multiple referral doctors and consent to paadmrefdoc table everytime new tci
/// is made. Passed parameters: waitinglist id and episodeid.
ClassMethod websysSaveRefDocDetails(wlid As %Library.String, episodeid As %Library.String)
{
}

/// GR 28/2/02 code to save the transfer to transaction as well as change the details in waitinglist
ClassMethod websysSaveTransfer(compref As %Library.String, id As %Library.String, waitListType As %Library.String, careprov As %Library.String, location As %Library.String, waitListStr As %Library.String, reason As %Library.String, hospital As %Library.String)
{
}

/// SA 4.7.02 - Made copy. Should be okay to delete after a month
ClassMethod WLMergeUniqueCnt(Patient As %Library.String = "")
{
}

ClassMethod GetConsultDetails(ConsultID As %Library.String = "")
{
}

/// KM 8-Aug-2001: Called From web.PAWaitingList.checkForEntriesOnWLs()
/// 
Query ActiveList(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID")
{
SELECT WL_RowId FROM SQLUser.PA_WaitingList
WHERE WL_PAPMI_DR = :PatientID AND ((WL_WaitListStatus_DR->WLS_Code='S') OR (WL_WaitListStatus_DR->WLS_Code='I'))
}

/// KM 8-Aug-2001: Called From web.PAWaitingList.checkForEntriesOnWLs()
/// 
Query List(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID")
{
SELECT WL_RowId FROM SQLUser.PA_WaitingList
WHERE WL_PAPMI_DR = :PatientID
}

Query LookUpRestrictedWLType(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// GR 8/10/02 lookup to get details of waiting list to link to an admission.
Query LookUpWLLinktoAdm(PatientID As %Library.String, AdmDate As %Library.Date) As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN,WLNO,WaitListType,WLDate,StateProc")
{
}

Query WaitListHistory(WaitingListID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "id,sdate,stime,seffdate,suser,sstatus,sreason,scomment,srevstatus,srevoutcome,sinitiator,sbookingnumber,spriority,stcistatus,sstateppp,shospital,saccomodation,sestlengthofstay,svisitstatus,sdeletedate")
{
}

Query WaitListPriority(WaitingListID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "TRANSRowId,TRANSDate,TRANSTime,TRANSDateEffective,WLPDesc,SSUSRName,PriorityIncreased,TRANSReason,TRANSInitiator,SSUSRInitials")
{
}

/// KM: 27-Jul-2001: Called From Component PAWaitingListInquiry.List
Query WaitingListInquiryList(TSRTITM, TSRTORD, PatientID, LocDesc, HospDesc, CareProvDesc, ListTypeCode, StatusDesc, PriorityDesc, ReasonDesc, Activity, OperDesc, ShortNotice, HiddenFindParam) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,ListType,Status,Priority,Date,DaysOnList,Department,Doctor,Surgeon,Operation,RegNo,Sex,Name,Name2,Name3,PAPMIEPRDescription,PatientID,PreopDate,DonationDate,EffectiveDate,ApptDate,EpisodeID,AppointmentID,Activity,Hospital,ReasonForList,ShortNotice,EpisodeSubType,GuarExcCode,GuarDate,BloodDonation,ProvDiagnosis,IntendedWard,UnavailReasonDesc,UnavailReasGrpDesc,UnavailDateFrom,UnavailDateTo,TCICancelReason,PreAssessOC,ConfTCI,TCIDate,revstat,DOB,AnaesthMeth,TCIStat,TCICancReasGrp,PriorityExceeded,WLRemarks,ArcIMIds,ArcIMDesc,StatePPP,TransDest,WLNO,WLOperativeEpisode,OEOrdItemID,DeferredDate,DateDecidedToAdmit,HIPs,ProcFreeText,WLStatusCode,defdays,daysuk,CommentsCancelLetter,RBOperDate,ADMOperDate,ZipCode,AdmPoint,Age,Zone,District,AccomodationType,StandBy,TheatreType,TotDays,CancelDate,NPPPDesc,EstLOStay,refhosp,famdochca,VIPStatus,recbackdate,dnarea,cancrea,consreqdate,contletterdate,ackletterdate,remletterdate,service,consultcat,recalldate,Name4,rbopstat,rbopid,waittimestd,suitability,patchgcons,patchgnhs,removedremained,TestVisitNo,WLType")
{
}

/// KM: 27-Jul-2001: Called From Component PAWaitingListInquiry.List
Query xxWaitingListInquiryList(LocDesc As %String, CareProvDesc As %String, StatusDesc As %String, ListTypeDesc As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ListType,Status,Priority,Date,DaysOnList,Department,Doctor,Surgeon,Operation,RegNo,Sex,Name,Name2,Name3,PAPMIEPRDescription,PatientID,PreopDate,DonationDate,EffectiveDate,ApptDate,EpisodeID, AppointmentID")
{
SELECT WL_RowId, WL_WaitListType_DR->WLT_Desc, WL_WaitListStatus_DR->WLS_Desc, WL_WaitListPrior_DR->WLP_Desc, WL_Date, WL_DaysOnList, WL_CTLOC_DR->CTLOC_Desc, WL_Doctor_DR->CTPCP_Desc, WL_Surgeon_DR->CTPCP_Desc, WL_Operation_DR->OPER_Desc, 
 WL_PAPMI_DR->PAPMI_No, WL_PAPMI_DR->PAPMI_PAPER_DR->PAPER_Sex_DR->CTSEX_Desc, WL_PAPMI_DR->PAPMI_PAPER_DR->PAPER_Name, WL_PAPMI_DR->PAPMI_PAPER_DR->PAPER_Name2, WL_PAPMI_DR->PAPMI_PAPER_DR->PAPER_Name3, WL_PAPMI_DR->PAPMI_EPRDescription, WL_PAPMI_DR,
 WL_PreopDate, WL_DonationDate, WL_EffectiveDate, WL_ApptDate, WL_PreAdmission_DR->PAADM_RowID, WL_PreAdmission_DR->PAADM_Appoint_DR->APPT_RowID
FROM SQLUser.PA_WaitingList
WHERE ((WL_CTLOC_DR->CTLOC_Desc %StartsWith :LocDesc) OR (:LocDesc IS NULL))
AND ((WL_Doctor_DR->CTPCP_Desc %StartsWith :CareProvDesc) OR (:CareProvDesc IS NULL))
AND ((WL_WaitListStatus_DR->WLS_Desc %StartsWith :StatusDesc) OR (:StatusDesc IS NULL))
AND ((WL_WaitListType_DR->WLT_Desc %STARTSWITH :ListTypeDesc) OR (:ListTypeDesc IS NULL))
}

/// get wl position counter
ClassMethod poscnt(type, date, loc)
{
}

/// log 60689 TedT
ClassMethod PatientWaitingListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = PatientWaitingListFetch ]
{
}

ClassMethod PatientWaitingListExecute(ByRef QHandle As %Library.Binary, PatientID As %String, ConsultID As %String) As %Library.Status
{
}

ClassMethod PatientWaitingListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = PatientWaitingListExecute ]
{
}

Query PatientWaitingList(PatientID As %String, ConsultID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "WL_RowId,WLT_Desc,WLS_Desc,WLS_Code,WLP_Desc,WL_Date,CTLOC_Desc,CTPCP_Desc,PAPMI_No,WL_PAPMI_DR,SIGNF_Code,RU_Desc,HOSP_Code,WL_ProcedureFreeText")
{
}

/*Query PatientWaitingList(PatientID As %String, ConsultID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "WL_RowId,WLT_Desc,WLS_Desc,WLS_Code,WLP_Desc,WL_Date,CTLOC_Desc,CTPCP_Desc,PAPMI_No,WL_PAPMI_DR,SIGNF_Code,RU_Desc,HOSP_Code,WL_ProcedureFreeText")
{
	SELECT WL_RowId,WL_WaitListType_DR->WLT_Desc,
	WL_WaitListStatus_DR->WLS_Desc,WL_WaitListStatus_DR->WLS_Code,
	WL_WaitListPrior_DR->WLP_Desc,
	WL_Date,WL_CTLOC_DR->CTLOC_Desc,WL_Doctor_DR->CTPCP_Desc,
	WL_PAPMI_DR->PAPMI_No,WL_PAPMI_DR,WL_CTLOC_DR->CTLOC_SignifFacility_DR->SIGNF_Code,
	WL_CTLOC_DR->CTLOC_RespUnit_DR->RU_Desc,
	WL_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Code,
	WL_ProcedureFreeText
	FROM  SQLUser.PA_WaitingList
	WHERE WL_PAPMI_DR =:PatientID
	AND ((:ConsultID IS NULL) OR (WL_Consult_DR= :ConsultID))
	ORDER by WL_Date DESC
}*/
ClassMethod NewWays(wl As %String) As %Library.String
{
}

ClassMethod GetOPLetterResponseX(WaitingListId As %String) As %String
{
}

ClassMethod GetOffersResetX(WaitingListId As %String) As %String
{
}

ClassMethod GetDaysOPDOfferX(WaitingListId As %String) As %String
{
}

ClassMethod CheckExistingWLOT(wlid As %Library.String) As %Library.Boolean
{
}

ClassMethod GetRecallSchema(RecallSchedID As %Library.String) As %Library.String
{
}

}
