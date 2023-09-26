Class web.PAWaitingListAdm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1353;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ADM_RowId";

Parameter SQLDESCRIPTION = "ADM_RowId";

Parameter SQLROWID = "ADM_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod AustinValidate(canceldate As %Library.String, bookdate As %Library.String, compid As %Library.String, admdate As %Library.String)
{
}

ClassMethod CancelAll(WaitingListID As %Library.String)
{
}

/// SA 6.3.02 - log 23277: 
/// - Method created to cancel all appointments associated with a PAWaitingListAdm
/// when the PAWLAdm is cancelled, or set to DNA.
/// - This method is called from PAWaitingListAdm.websysSaveAddAdm
ClassMethod CancelApptsForWLAdm(EpisodeID As %Library.String)
{
}

ClassMethod CancelMRRequest(wlid As %Library.String = "")
{
}

ClassMethod CheckForAuditReviewReponse(PARREF)
{
}

/// RQG 27.12.02 Log31334: Returns 1 (True) or 0 (False) for InPatient
ClassMethod CheckForInPatient(compref As %Library.String = "", PatientID As %Library.String = "")
{
}

ClassMethod CheckValidStatus(WLId As %Library.String) As %Library.String
{
}

ClassMethod FindActivePread(PARREF As %Library.String) As %Library.Boolean
{
}

ClassMethod FindAllClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindAllExecute(ByRef QHandle As %Library.Binary, WaitingListID As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
/// KK 7.3.2002 Log 23186 Execute and Fetch modifed to retrieve tow newly added fields ADMOperDate and ADMOperTime.
/// If there is no value in RBOPDateoper and RBOPTimeOper then the values in ADMOperDate and ADMTimeOper are listed.
ClassMethod FindAllFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllExecute ]
{
}

/// BC 14-Dec-2001
/// This will return the next child ID of the WaitinglistAdm object or the child ID of the present WaitinglistAdm Object
ClassMethod FindBookingNumber(id As %Library.String, ParRef As %Library.String) As %Library.String
{
}

/// rqg,Log25259: Introduced field "NoOfDays" in PAWaitingListAdm.Edit. The field is used to check whether the
/// day difference of new tci from last tci is greater than  "NoOfDays".
ClassMethod FindConflictingAdm(compref As %Library.String, id As %Library.String, PARREF As %Library.String, date As %Library.String) As %Library.Boolean
{
}

/// rqg,Log25259: To check if the TCI date is on the same day as an OP Appointment.
ClassMethod FindConflictingAppt(compref As %Library.String, id As %Library.String, PARREF As %Library.String, date As %Library.String)
{
}

/// rqg:Log24863: The method is called from PAWaitingListAdm.Edit and seeks to find TCI's which were
/// cancelled by the Hospital. If found returns true.
ClassMethod FindHospitalCancellation(parref As %Library.String) As %Library.String
{
}

ClassMethod FindOverlapWithSuspension(compref As %Library.String, id As %Library.String, PARREF As %Library.String, date As %Library.String, oprdate As %Library.String = "", preopdate As %Library.String = "", reverseflag As %Library.String = "") As %Library.Boolean
{
}

/// SA 6.3.02 - log 23277: 
/// - Written to get current or last cancelled Appt details, because previous code to 
/// populate fields did not take into account cancelled appointments against a WL TCI. 
/// - This code should also prevent multiple calls to populate single fields (APPTStatus,APPTDate,APPTTime)
/// - It will be called to populate the above  fields on PAWaitingListInquiry.List, PAWaitingListAdm.List and 
/// PAWaitingListAdfm.Edit 
ClassMethod GetApptDetailsForWLAdm(EpisodeID As %Library.String) As %Library.String
{
}

/// rqg,Log25031: This will get the PAADMDaySurgeryType from PAADM using the waitinglistadm id.
/// Also this will return the equivalent description.
ClassMethod GetDaySurgeryType(id As %Library.String)
{
}

ClassMethod GetHospital(ID As %Library.String) As %Library.String
{
}

/// rqg,Log24863:
/// Will return the last discharged date on the previous tci.
/// 
ClassMethod GetLastDischargedDate(WaitingListID As %Library.String) As %Library.Date
{
}

ClassMethod GetLatestAdm(PARREF As %Library.String, epid As %Library.String = "")
{
}

/// KK 7.3.2002 Log 23186 Get Date from PAWaitingListAdm if RBOPDateOper=""
/// KK 19/Apr/2002 Log 24443 get date from PAWaitingList if date from PAWaitingListAdm=""
ClassMethod GetOperationDate(id As %Library.String, wid As %Library.String) As %Library.Date
{
}

/// KK 7.3.2002 Log 23186 Get Time from PAWaitingListAdm if RBOPTimeOper=""
ClassMethod GetOperationTime(id As %Library.String, wid As %Library.String) As %Library.Time
{
}

ClassMethod GetPriorityDisable(PARREF As %Library.String) As %Library.Boolean
{
}

ClassMethod GetTCIDate(WaitingListID As %Library.String) As %Library.String
{
}

/// KK 3/jun/2002 Log 24443 to get tci date and time
ClassMethod GetTCIDateandTime(WaitingListID As %Library.String) As %Library.String
{
}

ClassMethod GetTCIFomWLID(WaitingListID As %Library.String)
{
}

ClassMethod GetTCIStatus(PARREF As %Library.String) As %Library.Boolean
{
}

/// 20/09/02 Log#28116 HP: Get booking comment. Called from PAAdm:FindPatPreAdFetch.
/// 08/10/02 Log#28116 HP: Changed to also get intended ward. Called from PAAdm:FindPatPreAdFetch.
ClassMethod GetWLAdmCommentIntWard(WLRowID As %Library.String, EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod GetWLAdmFromEpisodeID(EpisodeID As %Library.String) As %Library.String
{
}

/// gr for new pre-admissions we need to get the details from the existing waiting list
ClassMethod GetWLDetailsForAdm(ParRef As %Library.String, id As %Library.String)
{
}

/// rqg,Log24189: The Value of Day of Surgery field is calculated using the hardcoded value of Episode Subtype 
/// "SUBTDesc" field as follows:
///    1 - Intended same day
///    2 - Intended overnight
///  
ClassMethod SaveDayOfSurgeryPatient(id As %Library.String = "") As %Library.String
{
}

/// rqg,Log23771:This method will create wl admission record when new order item is made.
/// This is called from PAWaitingList Websysaftersave.
ClassMethod SaveOEOrderAdm(WaitingListID As %Library.String, OEOrdItemID As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSaveAddAdm(compref As %Library.String, id As %Library.String, PARREF As %Library.String)
{
}

/// Log 61975 - 19.04.2007 - to be called from the web (PAWaitingListAdm.Edit).
ClassMethod IsWLOTDone(PARREF As %Library.String) As %Library.String
{
}

ClassMethod XDaysExceeded(admdate As %Library.String, wladmId As %Library.String, wlId As %Library.String, compid As %Library.String)
{
}

ClassMethod PutWLAdmIntoPAAdm(id As %Library.String)
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

Query FindAll(WaitingListID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,ADMAdmDate,ADMTime,ADMCancelDate,ADMCancelTime,READesc,ADMComment,ADMConfirmation,OperCTLOCDesc,RBOPDateOper,RBOPTimeOper,RFLDesc,ANMETDesc,WLBloodDonation,WARDDesc,OPERDesc,WLPreopDate,WLPreopTime,APTRDesc,WLRemarks,WLRGDesc,WLTDesc,APPTDate,APPTTime,APPTOutcome,BookingNumber,ADMOperDate,ADMOperTime,ADMBookingDate,SPPPDesc,ProcFreeText,CommentsCancelLetter,Department,Consultant,WLStatus,APPTId,TCIStatus,ADMTheatreType,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHosp,RBOpStatus,RBOpid,ADMPAADMDR")
{
}

/// SA 27.11.01: Used to retrieve ID and Date for subsequent sorting and full 
/// record retrieval by PAWaitingList.WaitListHistory
/// RQG 20.02.02: Changed to retrieve admission date 'Date', time 'Time' and cancellation 
/// date 'CancelDate' as admission date is needed in the history list
Query GetIDDateByParent(WaitingListID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Date,Time,CancelDate")
{
SELECT ADM_RowId, ADM_AdmDate, ADM_Time, ADM_CancelDate
FROM SQLUser.PA_WaitingListAdm
WHERE (ADM_ParRef = :WaitingListID)
AND (ADM_CancelDate IS NOT NULL)
}

ClassMethod GetWLFromOT(OpRoomID As %Library.String) As %Library.String
{
}

}
