Include webimport

IncludeGenerator webimport

Class web.RBAppointment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6273;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// This function puts appointments that have been cancelled due to episode
/// discharge or cancellation back to a status of "Booked"
ClassMethod ReinstateAppointments(compref As %String = "", EpisodeID As %String = "") As %Library.Boolean
{
}

/// Returns how many reports there are for this appointment
ClassMethod AnyReports(AppointmentID As %String) As %Library.Integer
{
}

ClassMethod ChangeService(compref As %Library.String)
{
}

/// This takes an appointment ID and then checks that the resource is available
/// The function returns 1 if the resource is unavailable
ClassMethod CheckResourceForNA(AppointmentID As %String = "") As %Library.Boolean
{
}

/// to be used when appointments are automatically bulk transfered developed for QH Log  37179
ClassMethod UpdateTransferReason(ApptList As %String = "", Reason As %String = "")
{
}

ClassMethod ReinstateOBSlot(RowID As %String = "")
{
}

/// This function returns the first booked appointment for an admission (and last
/// arrived Appointment). A blank it returned if there are no booked (or Arrived 
/// appointments) .
ClassMethod GetFirstBookedAppt(EpisodeID As %String = "") As %String
{
}

ClassMethod GetService(ServID As %String = "") As %String
{
}

ClassMethod IsFirstAppointment(EpisodeID As %String = "", NewApptDate As %String = "", NewApptTime As %String = "", TransAppt As %String = "") As %Boolean
{
}

Parameter SQLCODE = "APPT_RowId";

Parameter SQLDESCRIPTION = "APPT_RowId";

Parameter SQLROWID = "APPT_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod AddActionedOutcome(ApptID As %Library.String = "", Action As %Library.String = "")
{
}

/// Produces a waring message for all conflicting admissions/preadmissions and appointments.
/// Appointments 30days in the future from the new appointment/PreAmission date
/// and Preadmissions/Admissions 10 days in the past up to 30 days in the future
ClassMethod AdmissionWarning(PatientID As %Library.String = "", EpisodeID As %Library.String = "", Date As %Library.Date = "") As %Library.String
{
}

ClassMethod AppointmentServiceSelect(ByRef dataLIST As %Library.String)
{
}

/// A method to cancel all booked,inserted or on hold appointments for a give episode. 
///  An appointment ID can be supplied if one doesn't want a particular appointment cancelled, used for
/// changing appointment status for "discharge" outcome of an appointment.
ClassMethod CancelAllApptForEpisode(compref As %Library.String, EpisodeID As %Library.String, ApptID As %Library.String = "")
{
}

ClassMethod CancelFutureApptForEpisode(compref As %Library.String, EpisodeID As %Library.String, ApptID As %Library.String = "", date As %Library.String = "")
{
}

/// LOG 22061 BC 26-MARCH-2002
ClassMethod ChangeApptOrdItmStatus(apptid As %Library.String, status As %Library.String)
{
}

ClassMethod ChangeApptStatus(id As %Library.String = "") As %Library.Boolean
{
}

ClassMethod CheckApptPartofServiceSet(ApptId As %Library.String) As %Library.Boolean
{
}

ClassMethod CheckBookedLinkAppts(appt As %Library.String) As %Library.String
{
}

/// LOG 23612 BC Warning to indicate that a patient already has this type of service on a day
/// (independent of Resource)
ClassMethod CheckDayForService(PatientID As %Library.String = "", Date As %Library.String = "", Service As %Library.String = "") As %Library.String
{
}

/// This function checks to see if the appointment already has an 
/// outcome of "Rebook" against it and returns the ID of the outcome
/// if it is found.
ClassMethod CheckForAlreadyRebook(ApptId As %String = "") As %String
{
}

ClassMethod CheckForArrivedAppts(EpisodeID As %Library.String = "", AppointmentID As %Library.String = "") As %Library.Boolean
{
}

/// A routine to compare the services of a transfered appointment to the newly booked appointment 
/// and give the old appointment the "Rebooked" outcome if the service, resource and location match for both
/// appointments.
ClassMethod CheckForRebook(NewAppt As %Library.String = "")
{
}

ClassMethod CheckForServiceSet(bulktrans As %Library.String, appt As %Library.String = "", mappt As %Library.String = "", ssetid As %Library.String = "") As %Library.String
{
}

/// LOG 23612 BC Warning to indicate that a patient already has this type of service on a day
/// (independent of Resource)
ClassMethod CheckFutureEpisAppt(EpisodeID As %Library.String = "", ApptId As %Library.String = "") As %Library.String
{
}

ClassMethod CheckForFutureAppts(ApptID As %Library.String) As %Library.String
{
}

ClassMethod CheckLinkAppts(appt As %Library.String) As %Library.String
{
}

ClassMethod CheckOEOrdItems(AppointmentID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod CheckServiceAgainstHospital(serID As %Library.String, locID As %Library.String, patID As %Library.String, date As %Library.String) As %Library.String
{
}

/// KM 14-Aug-2001
ClassMethod CountAptsAttdForSess(RescID As %Library.String, SessID As %Library.String, date As %Library.Date) As %Library.Numeric
{
}

/// KM 14-Aug-2001 Created for component item BookedAppt in component RBResEffDateSession.List
ClassMethod CountAptsBkdForSess(RescID As %Library.String, SessID As %Library.String, date As %Library.Date) As %Library.Numeric
{
}

/// KM 14-Aug-2001 Created for component item BookedAppt in component RBResEffDateSession.List
ClassMethod CountAptsBkdForSessType(RescID As %Library.String, SessTypeID As %Library.String, date As %Library.Date) As %Library.Numeric
{
}

/// KM 14-Aug-2001 created for component item VacantAppt in component RBResEffDateSession.List
ClassMethod CountAptsVacantForSess(RescID As %Library.String, SessID As %Library.String, date As %Library.Date) As %Library.Numeric
{
}

ClassMethod DefaultInterpreter(AppointmentIDs As %Library.String = "")
{
}

ClassMethod DeleteOBSlots(RowID As %Library.String = "") As %Library.String
{
}

ClassMethod DisplayBookingButton() As %String
{
}

ClassMethod FindApptClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindApptFetch ]
{
}

ClassMethod FindApptExecute(ByRef QHandle As %Library.Binary, ServId As %String, LocId As %Library.String, ResId As %Library.String, PayId As %Library.String, PlanId As %Library.String, DOW As %Library.String, Date As %Library.String, STime As %Library.String, ETime As %Library.String, Rows As %Library.String, LinkFlag As %Library.String, HCA As %Library.String = "", MultiSelect As %Library.String = 1, HospIDs As %Library.String = "", transint As %Library.String, SessDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod FindApptFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindApptExecute ]
{
}

ClassMethod FindApptListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindApptListFetch ]
{
}

/// SB 04/09/02 (27419): Needed to change the basic query of RBAppointment.List to a
/// Execute/Fetch/Close to add security to the table.
ClassMethod FindApptListExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", TSRTITM As %Library.String, TSRTORD As %Library.String) As %Library.Status
{
}

ClassMethod FindApptListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindApptListExecute ]
{
}

ClassMethod FindByEpisodeAClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByEpisodeAFetch ]
{
}

ClassMethod FindByEpisodeAExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String, PatientID As %Library.String, status As %Library.String = "") As %Library.Status
{
}

ClassMethod FindByEpisodeAFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByEpisodeAExecute ]
{
}

ClassMethod FindByEpisodeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindByEpisodeFetch ]
{
}

ClassMethod FindByEpisodeExecute(ByRef QHandle As %Library.Binary, EpisodeID As %Library.String, PatientID As %Library.String, status As %Library.String = "") As %Library.Status
{
}

ClassMethod FindByEpisodeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindByEpisodeExecute ]
{
}

/// Purpose - To return a string of 0 and 1 respresenting if there is information behind the four links.
ClassMethod FindIfBoldLink(EpisodeID As %Library.String)
{
}

ClassMethod FindIncompApptClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindIncompApptFetch ]
{
}

ClassMethod FindIncompApptExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", DocIDs As %String, Status As %Library.String = "", fromdate As %Library.Date = "", todate As %Library.Date = "") As %Library.Status
{
}

ClassMethod FindIncompApptFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindIncompApptExecute ]
{
}

/// This method returns the Appointment ID for that last (non cancelled or transferred) 
/// appointment for a given episode
ClassMethod FindLastApptForEpis(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod FindPatApptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatApptsFetch ]
{
}

ClassMethod FindPatApptsExecute(ByRef QHandle As %Library.Binary, LocId As %Library.String, ResId As %Library.String, sdate As %Library.String, edate As %Library.String, status As %Library.String, stime As %Library.String, etime As %Library.String, ServId As %Library.String, SSServId As %Library.String, PatientID As %Library.String = "", HospID As %Library.String = "", SessionId As %Library.String = "", TSRTITM As %Library.String = "", TSRTORD As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatApptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatApptsExecute ]
{
}

ClassMethod FindRescDaySchedClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRescDaySchedFetch ]
{
}

ClassMethod FindRescDaySchedExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, RescID As %String, date As %Date, RegistrationNo As %Library.String, PatientID As %Library.String, timefrom As %Library.Time, timeto As %Library.Time, sessId As %Library.String, ServID As %Library.String, SessTypeId As %Library.String = "", WorkID As %Library.String, sessall As %Library.String, MedRecSearch As %Library.String) As %Library.Status
{
}

ClassMethod getSort(rbcount) As %Library.String
{
}

ClassMethod zeroPad(str, length) As %Library.String
{
}

ClassMethod GetBlockedSess(sdate, time, sess) As %Library.String
{
}

ClassMethod ShowAdhoc(stime, etime, sSessID, SchedID, date) As %Library.String
{
}

ClassMethod GetSlotAppt(sRescID As %Library.String, sdate As %Library.String, edate As %Library.String, stimefrom As %Library.String, stimeto As %Library.String, squeezed As %Library.String, sessID As %Library.String, RegoNo As %Library.String = "", RegistrationNo As %Library.String = "") As %Library.String
{
}

ClassMethod GetSqueezedInSlots(ftime As %Library.String, ttime As %Library.String, sessID As %Library.String) As %Library.String
{
}

ClassMethod CheckSqueezedInSlots(sRescID As %Library.String, sdate As %Library.String, stimefrom As %Library.String) As %Library.String
{
}

ClassMethod FindRescDaySchedFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRescDaySchedExecute ]
{
}

/// This routine finds, if available, the ID of the transferred
/// appointment associated with this appointment.
ClassMethod FindTransAppt(ApptID As %String = "") As %String
{
}

/// A function to return information about the appointment in the following firm:
/// 
/// Patient, Resource, Location, Service : date, time
ClassMethod GetApptDetails(AppointmentID As %Library.String = "") As %Library.String
{
}

/// A function to bring back a delimated string of AppointmentIDs for use in bulk transfer 
/// and automatic bulk transfer.  This is to be used when selecting all appropriate appointments
/// rather than hand selecting them.
/// 
/// LOG 28034
ClassMethod GetApptIDList(LocId As %Library.String = "", ResId As %Library.String = "", sdate As %Library.String = "", edate As %Library.String = "", status As %Library.String = "", stime As %Library.String = "", etime As %Library.String = "", ServId As %Library.String = "", SSServId As %Library.String = "", PatientID As %Library.String = "", HospID As %Library.String = "", SessionID As %Library.String = "") As %Library.String
{
}

/// This function returns a "^" delimited string of all the appointment IDs associated with the admission
ClassMethod GetApptIDsForAdm(EpisodeID As %Library.String = "", PatientID As %Library.String = "") As %Library.String
{
}

/// This function returns a "^" delimited string of all the appointment IDs associated with the admission
ClassMethod GetAllApptIDsForAdm(EpisodeID As %Library.String = "", PatientID As %Library.String = "") As %Library.String
{
}

ClassMethod GetDateFromID(ID As %Library.String) As %Library.Date
{
}

/// KM 23-Oct-2001: Called from PAAdm.websysSaveDischarge
ClassMethod GetEpisodeFutureAppts(EpisodeID As %Library.String, PatientID As %Library.String, IgnoreOpTheatre As %Library.String = "") As %Library.String
{
}

ClassMethod GetEpisodeId(ID As %Library.String) As %Library.Date
{
}

ClassMethod GetLinkApptMessage(ApptID As %Library.String)
{
}

ClassMethod GetResourceDetails(apptID As %String = "", EpisodeID As %String = "")
{
}

ClassMethod GetServiceIdFromCodeOrDesc(LocId As %Library.String, ResId As %Library.String, ServiceDesc As %Library.String) As %Library.String
{
}

ClassMethod GetTimeFromID(ID As %Library.String) As %Library.Time
{
}

/// need this to get the waiting list id, so that a custom script can run for log 24883
ClassMethod GetWLID(ID As %Library.String) As %Library.Date
{
}

ClassMethod InsertOverbook(compref As %Library.String)
{
}

ClassMethod InsertOffer(compref As %Library.String, details As %Library.String = "", WaitingListID As %Library.String = "")
{
}

ClassMethod InsertAppt(compref As %Library.String, overbook As %Library.String = "")
{
}

ClassMethod ServOrdSecGroup(Services)
{
}

ClassMethod InsertRBMulti(compref As %Library.String, PatientID As %String, ServiceIDs As %String, ScheduleIDs As %String, EpisodeID As %Library.String, ApptLetter As %Library.String, RevPeriod As %Library.String, Transport As %Library.String, Comments As %Library.String, Overbook As %Library.String, OldAppt As %Library.String, AdmDocId As %Library.String, Main As %Library.String, WaitingListID As %Library.String, ReasonForTransfer As %Library.String = "", Interpreter As %Library.String, LocationIDs As %Library.String, date As %Library.String, ASSI As %Library.String = "")
{
}

ClassMethod SaveApptToMRClinPathWay(ApptID As %Library.String = "", CPWRowId As %Library.String = "")
{
}

ClassMethod IsUrgent(ApptID As %Library.String)
{
}

ClassMethod ListApptByStatusClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListApptByStatusFetch ]
{
}

ClassMethod ListApptByStatusExecute(ByRef QHandle As %Library.Binary, RescID As %String, dfrom As %Date, dto As %Library.Date, status As %Library.String, SessID As %Library.String) As %Library.Status
{
}

ClassMethod ListApptByStatusFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListApptByStatusExecute ]
{
}

ClassMethod ListApptsByResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListApptsByResFetch ]
{
}

ClassMethod ListApptsByResExecute(ByRef QHandle As %Library.Binary, ResourceID As %Library.String, DateFr As %Library.String, DateTo As %Library.String, Type As %Library.String, Status As %Library.String, Session As %Library.String, TimeFrom As %Library.String, TimeTo As %Library.String, Doctor As %Library.String) As %Library.Status
{
}

ClassMethod ListApptsByResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListApptsByResExecute ]
{
}

ClassMethod ListOfServicesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListOfServicesFetch ]
{
}

ClassMethod ListOfServicesExecute(ByRef QHandle As %Library.Binary, tblStr As %Library.String) As %Library.Status
{
}

ClassMethod ListOfServicesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListOfServicesExecute ]
{
}

ClassMethod ListOfAdditionalServicesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListOfAdditionalServicesFetch ]
{
}

ClassMethod ListOfAdditionalServicesExecute(ByRef QHandle As %Library.Binary, addStr As %Library.String) As %Library.Status
{
}

ClassMethod ListOfAdditionalServicesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListOfAdditionalServicesExecute ]
{
}

ClassMethod LookUpBrokerHRG(itmjs As %Library.String = "", itmjsex As %Library.String = "", HRG As %Library.String, LocDesc As %Library.String, epID As %Library.String)
{
}

ClassMethod LookUpBrokerServ(itmjs As %Library.String = "", itmjsex As %Library.String = "", locDesc As %Library.String = "", resDesc As %Library.String = "", serDesc As %Library.String = "", ServType As %Library.String = "", BookType As %Library.String = "", LocId As %Library.String = "", ResDesc2 As %Library.String = "", HCARowID As %Library.String = "", HospIDs As %Library.String = "", RESRowId As %Library.String = "", RESCode As %Library.String = "", Broker As %Library.String = "", NoRestrict As %String = "", PFBFlag As %String = "", SchedID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpHRGClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpHRGFetch ]
{
}

ClassMethod LookUpHRGExecute(ByRef QHandle As %Library.Binary, HRG As %String, LocDesc As %Library.String, epID As %Library.String) As %Library.Status
{
}

ClassMethod LookUpHRGFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpHRGExecute ]
{
}

ClassMethod LookUpServiceClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpServiceFetch ]
{
}

ClassMethod LookUpServiceExecute(ByRef QHandle As %Library.Binary, LocDesc As %Library.String = "", ResDesc As %Library.String = "", SerDesc As %Library.String = "", ServType As %Library.String = "", BookType As %Library.String = "", LocId As %Library.String = "", ResDesc2 As %Library.String = "", HCARowID As %Library.String = "", HospIDs As %Library.String = "", RESRowId As %Library.String = "", RESCode As %Library.String = "", Broker As %Library.String = "", NoRestrict As %String = "", PFBFlag As %String = "", SchedID As %Library.String = "") As %Library.Status
{
}

/// ; Retrieve the current status
/// n user,work,cnt,delimsys
/// n Location, Resource, Service, ServType
/// ;
/// s delimsys = $c(2)
/// s AtEnd=$li(QHandle,1)
/// s user=$li(QHandle,2)
/// s work=$li(QHandle,3)
/// ;
/// s Location=$li(work,1)
/// s Resource=$li(work,2)
/// s Service=$li(work,3)
/// s ServType=$li(work,4)
/// ;
/// s ^zsb($zn,"BeforeFetch")=""
/// s code=$$fetch^CWEBRBRS1(Location, Resource, Service, ServType)
/// s ^zsb($zn,"AfterFetch")=""
/// i code s AtEnd=1,Row=""
/// ;
/// i code=0 d
/// . ; Build up the columns for one row of the result set
/// . n ID, Desc, Code, Other
/// . s (ID, Desc, Code, Other)=""
/// . s ID = $p(PLIST(1), delimsys,1)
/// . s Desc = $p(PLIST(1), delimsys, 2)
/// . s Code = $p(PLIST(1), delimsys, 3)
/// . s Other = $p(PLIST(1), delimsys, 4)
/// . s code2=$$getmessrb1^CWEBARCOS(ID)
/// . s Message=""
/// . i PLIST  d
/// . . f i=1:1:PLIST  d
/// . . . s Message=Message_PLIST(i)_" "
/// . s Row=$lb(Desc,Message,ID)
/// ;
/// s QHandle=$lb(AtEnd,user,work)
/// q $$$OK
ClassMethod LookUpServiceFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpServiceExecute ]
{
}

ClassMethod RecreateMedicalRecordRequests(ResID As %Library.String = "")
{
}

/// Trigger used for cancel^MVBAPPT4 to release slots
ClassMethod ReleaseSlots(parentID As %Library.String, flag As %Library.String)
{
}

ClassMethod CheckSlotsAvail(ParentID As %Library.String) As %Library.String
{
}

ClassMethod ReturnBookedLinkAppts(appt As %Library.String) As %Library.String
{
}

/// This function returns 1 for the "future" button and 2 for the "Past" button
/// 
/// LOG 25724 BC  18-6-2002 Allow retrospective booking showing a different button for past appointments
ClassMethod SelectBookingButton() As %Library.String
{
}

/// This routine will give the last appointment for episode an outcome of "Discharged" as defined by the 
/// Discharge flag on the outcome.   It is to be used when an episode is discharge.
/// 
/// This routine ignores transferred and cancelled appointments. 
/// 
/// Log 29620 BC 26-11-2002
ClassMethod SetDischargeOutcome(EpisodeID As %Library.String)
{
}

/// GR log 28902.  message if there is an appointment present.  called from wl, paadm and appt.
ClassMethod ShowConflictMessageForAppt(ConflictMsg As %Library.String = "", compid As %Library.String, StDate As %Library.String = {+$h}) As %Library.String
{
}

ClassMethod ShowOtherAttdCPIcon(ApptID As %Library.String = "") As %Library.String
{
}

/// SB: This was copied from M621DEVDATA
/// This function increments/decrements the number of services booked agains the global. It needs to be called 
/// whenever an appointment is booked, cancelled, transferred etc.
ClassMethod UpdService(rbas As %Library.String, ser As %Library.String, flag As %Library.String)
{
}

///  ;*********************************************************************
///  ;* Routine: UpdateOEOrdExecs                                                                                       *
///  ;* Variables: AppointmentID,Status                                                                                 *
///  ;* Returned:                                                                                                                     *
///  ;* Calls:                                                                                                                             *
///  ;*                                                                                                                                      *
///  ;* This routine will update the order adminstration status of all                                      *
///  ;* OEOrdExecs that do not have their staus set and will also update                              * 
///  ;* the Order exectuted by, the executed date and time.                                                *
///  ;*                                                                                                                                      *
///  ;* History                                                                                                                          *
///  ;* - Log 30874 BC 17-12-2002 Original coding                                                                 *
///  ;*********************************************************************
///  ;
ClassMethod UpdateOEOrdExecs(AppointmentID As %Library.String = "", Status As %Library.String = "")
{
}

ClassMethod ValTime(res As %Library.String, datefrom As %Library.String, timefrom As %Library.String, dateto As %Library.String, timeto As %Library.String, row As %Library.String)
{
}

ClassMethod correctCrossModCheck(conflictmess As %Library.String, messagelength As %Library.String = 12) As %Library.String
{
}

ClassMethod getAdmDoc(AdmId As %Library.String) As %Library.String
{
}

ClassMethod otherApptsSameDay(PatientID As %Library.String, ApptID As %Library.String) As %Library.String
{
}

/// A routine to compare the services of a transfered appointment to the newly booked appointment 
/// and give the old appointment the "Rebooked" outcome if the service, resource and location match for both
/// appointments.
ClassMethod setRebookOutcome(OldAppt As %Library.String = "", userID As %Library.String = "")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod CheckOrdExeWithApptDepTime(ApptID As %String, DepTime As %String) As %String
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysOTApptSave(compref As %String, ResID As %String)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod GetOrderItem(ApptId) As %String
{
}

ClassMethod websysSaveAppt(compref As %Library.String, PatientId As %Library.String, EpisodeId As %Library.String, ApptParams As %Library.String, AdmParams As %Library.String, InsParams As %Library.String, AdmsnType As %Library.String)
{
}

ClassMethod websysSaveApptOutcome()
{
}

ClassMethod GetApptPayor(EpisodeId As %String, ApptId As %String)
{
}

ClassMethod GetApptPlan(EpisodeId As %String, ApptId As %String)
{
}

ClassMethod GetPlanForEpisode(EpisodeID As %Library.String)
{
}

/// Log 56831 - 11.12.2006 - Update C/P arrival and departure times
ClassMethod websysSaveCareProvTimes(compref As %String, id As %String, CareProvId As %String, TimeType As %String, ResID As %String)
{
}

/// Log 62342 - 25.01.2007 - Validations before updating CP times
ClassMethod CPTimesCheck(ID As %Library.String = "", CP As %Library.String, ResID As %Library.String, TimeType As %Library.String) As %Library.String
{
}

/// Log 56831 - 22.01.2007 - Get QMATIC Number for given Appointment
ClassMethod getQMNo(ApptID As %Library.String)
{
}

/// Log 56831 - 22.01.2007 - Get Appointments 
ClassMethod getNextAppts(CP1or2 As %String, Resource As %String, CareProvider As %String, ClinicType As %String)
{
}

/// Log 56831 - 12.12.2006 - Get Next Patient
ClassMethod getNextPatient(compref As %String, CP1or2 As %String, Location As %String, Resource As %String, CareProvider As %String, ClinicType As %String, RoomNo As %String, ApptID As %String = "")
{
}

/// KM 12-Sept-2001: Updates Appointment Status
ClassMethod websysSaveApptStatus(compref As %String, id As %String)
{
}

ClassMethod updateRefExpDate(compid, id)
{
}

ClassMethod checkRefDate(id, EpisodeID)
{
}

ClassMethod isfirstarrived(id, EpisodeID)
{
}

/// by wuqk 2011-06-21 未实现
ClassMethod GetFirstArrivedDate(EpisodeID)
{
	quit ""
}

ClassMethod websysSaveBulkTransAuto(compref As %Library.String, apptRows As %Library.String, DateFrom As %Library.String, DateTo As %Library.String, Res As %Library.String = "", Loc As %Library.String = "", sessId As %Library.String = "", Overbook As %Library.String = "", OverbookBy As %Library.String = "", NextAvail As %Library.String = "", ApplyServiceSetList As %Library.String = "")
{
}

Query Find(resc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ASRowID,ASSessStartTime")
{
SELECT APPT_RowID, APPT_AS_ParRef->AS_RowID, APPT_AS_ParRef->AS_SessStartTime
INTO :ID,:ASRowID,:ASSessStartTime
FROM RB_Appointment
WHERE (APPT_AS_ParRef->AS_RES_ParRef->RES_RowID = :resc)
}

Query FindAppointDatesByEpisode(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "apptID, adate,atime, location, resource, service")
{
SELECT  APPT_RowId, APPT_AS_ParRef->AS_Date, APPT_AS_ParRef->AS_SessStartTime,
 APPT_AS_ParRef->AS_RES_ParRef->RES_CTLOC_DR->CTLOC_Desc, 
 APPT_AS_ParRef->AS_RES_ParRef->RES_CTPCP_DR->CTPCP_Desc, 
 APPT_RBCServ_DR->SER_Desc
FROM SQLUser.RB_Appointment
WHERE (APPT_Adm_DR = :EpisodeID)
}

Query FindAppt(ServId As %String, LocId As %String, ResId As %String, PayId As %String, PlanId As %String, DOW As %String, Date As %String, STime As %String, ETime As %String, Rows As %String, LinkFlag As %String, HCA As %String, MultiSelect As %String, HospIDs As %String, TransInt As %String, SessDesc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,ChildSub:%String,Date:%Date,Session:%String,SessStartTime:%Time,SessEndTime:%Time,NoApptSession:%String,Load:%String,Availability:%String,NumPatIn:%String,NumPatOut:%String,Remarks:%String,Slot:%String,QueueNoCount:%String,BookedSlots:%String,Location:%String,Resource:%String,Price:%String,Service:%String,DurationOfService:%String,SessionType:%String,ServiceGroup:%String,sDay:%String,HIDDEN:%String,shospital:%String,sroom:%String,sessmess:%String,LocId:%String,ResId:%String,transport:%String,interpreter:%String,intreq:%String,transreq:%String,disint:%String,distrans:%String,ssString:%String,SerId:%String,lhospital:%String,OrigDate:%String,pos:%String,NewWayOffer:%String")
{
}

/// SB 04/09/02 (27419): Needed to change the basic query of RBAppointment.List to a
/// Execute/Fetch/Close to add security to the table.
Query FindApptList(PatientID As %String, TSRTITM As %String, TSRTORD As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "apptId,apptLetter,apptArrTime,apptConfirm,apptInterpReq,apptTransReq,apptRemarks,apptRevPeriod,apptSeenDate,apptSeenTime,apptStatus,apptTransportDesc,apptDate,apptSTime,apptLocDesc,apptCPDesc,paadmADMNo,paadmRefApprovNo,paadmRefDate,paperPrefLangDesc,paadmRefDateActiveTo,paadmRefDoc,apptReasonForCancel,apptReasonOverBook,apptAdmId,apptServDesc,apptASParRef,paadmRefDocListId,apptSessDesc,paadmCarPrvTpId,RescId,EventID,EventName,Initiator,AdmType,MRAdmid,RefPriority,Interpreter,ServiceSetID,Hospital,apptStatusCode,Room,method,SessType,apptConfirmDate,ReasonNotShow")
{
}

Query FindByEpisode(EpisodeID, PatientID, status) As %Library.Query(CONTAINID = 1, ROWSPEC = "apptid,remarks:%String,status:%String,adate:%String,atime:%String,location:%String,resource:%String,service:%String,EpisodeNo:%String,roomdesc:%String,tdate:%Date,ttime:%Time,tuser:%String,initiator:%String,statuschangeuser:%String,statuschangehospital:%String,statuschangedate:%Date,statuschangetime:%Time,statuschangeusercode:%String,hospital:%String")
{
}

Query FindByEpisodeA(EpisodeID, PatientID, status) As %Library.Query(CONTAINID = 1, ROWSPEC = "Hidden,adate:%String,atime:%String,location:%String,resource:%String,service:%String")
{
}

Query FindByPat(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,APPTASParRef,ASDate:%Date,ASSessStartTime:%Time,CTLOCDesc:%String,RESDesc:%String,SERDesc:%String,APPTDuration:%Float,APPTStatus:%String")
{
SELECT APPT_RowID, APPT_AS_ParRef, 
APPT_AS_ParRef->AS_Date, APPT_AS_ParRef->AS_SessStartTime, 
APPT_AS_ParRef->AS_RES_ParRef->RES_CTLOC_DR->CTLOC_Desc, 
APPT_AS_ParRef->AS_RES_ParRef->RES_Desc, 
APPT_RBCServ_DR->SER_Desc, APPT_Duration, APPT_Status
FROM RB_Appointment
WHERE (APPT_PAPMI_DR = :PatientID) 
AND (APPT_Status IN ('P','I','H','J')) 
AND (APPT_AS_ParRef->AS_Date >= CURRENT_DATE)
}

Query FindIncompAppt(TSRTITM As %String, TSRTORD As %String, DocIDs As %Library.String, Status As %Library.String, fromdate As %Library.Date, todate As %Library.Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "SchedID,Time,RegNo,Name,Name2,Name3,Name4,Name5,Name6,Name7,Name8,Age,Sex,Phone,StatusCode,Status,Service,PatientID,EpisodeID,mradm,ApptID,StatusColor,sessionID,sesstype,WaitListType,WaitListStatus,smessageid,DOB,ItmMess,payor,sdate,MedRecNo,ORIRowIDs,RescID,ResDesc,ResLocID,ResLoc")
{
}

Query FindPatAppts(LocId As %String, ResId As %String, sdate As %String, edate As %String, status As %String, stime As %String, etime As %String, ServId As %String, SSServId As %String, PatientID As %String = "", HospID As %String = "", SessionId As %String = "", TSRTITM As %String, TSRTORD As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "reg,name,res,date,stime,etime,service,status,apptId,statcode,surgdate,name2,name3,Remarks,RefPriority,transtodate,transtotime,EpiNumber,apptAdmId,AdmType,MRAdmid,PatId,MedRecNo,Location,Hospital,RSTVisitStatus,VIPStatus,name4,guarDate,SessTypeDesc")
{
}

/// Find all appointments for a patient.
Query FindPatientAppt(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "APPTRowId,APPTAppointLetter,APPTArrivalTime,APPTConfirmation,APPTInterpreterRequired,APPTRemarks,APPTReviewPeriod_DR,APPTSeenDate,APPTSeenTime,APPTStatus,APTRDesc,ASDate,ASSessStartTime,CTLOCDesc,CTPCPDesc,PAADMADMNo,PAADMRefApprovNo,PAADMRefDate,PREFLDesc,REFDDateActiveTo,REFDDesc,RFCDesc,ROBDesc,APPTAdmDR,SERDesc,APPTASParRef,PAADMRefDocListDR,SESSDesc,EventID,EVName")
{
SELECT APPT_RowId, APPT_AppointLetter, APPT_ArrivalTime, APPT_Confirmation, APPT_InterpreterRequired, APPT_Remarks, APPT_ReviewPeriod_DR, APPT_SeenDate, APPT_SeenTime, APPT_Status, APPT_Transport_DR->APTR_Desc, APPT_AS_ParRef->AS_Date, APPT_AS_ParRef->AS_SessStartTime, APPT_AS_ParRef->AS_RES_ParRef->RES_CTLOC_DR->CTLOC_Desc, APPT_AS_ParRef->AS_RES_ParRef->RES_CTPCP_DR->CTPCP_Desc, APPT_Adm_DR->PAADM_ADMNo, APPT_Adm_DR->PAADM_RefApprovNo, APPT_Adm_DR->PAADM_RefDate, APPT_PAPMI_DR->PAPMI_PAPER_DR->PAPER_PrefLanguage_DR->PREFL_Desc, APPT_Adm_DR->PAADM_RefDocList_DR->REFD_DateActiveTo, APPT_Adm_DR->PAADM_RefDocList_DR->REFD_Desc, APPT_ReasonForCancel_DR->RFC_Desc, APPT_ReasonOverBook_DR->ROB_Desc,APPT_Adm_DR,APPT_RBCServ_DR->SER_Desc,APPT_AS_ParRef,APPT_Adm_DR->PAADM_RefDocList_DR,APPT_AS_ParRef->AS_RBEffDateSession_DR->SESS_Desc,APPT_RBEvent_DR,APPT_RBEvent_DR->EV_Name
FROM SQLUser.RB_Appointment
WHERE APPT_PAPMI_DR =:PatientID
AND (APPT_Status IN ('P','I','H','J','S')) 
ORDER BY APPT_AS_ParRef->AS_Date DESC
}

/// Find all appointments for a patient.
Query FindPatientApptByDate(PatientID As %Library.String, apptdate As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "APPTRowId,APPTAppointLetter,APPTArrivalTime,APPTConfirmation,APPTInterpreterRequired,APPTRemarks,APPTReviewPeriod_DR,APPTSeenDate,APPTSeenTime,APPTStatus,APTRDesc,ASDate,ASSessStartTime,CTLOCDesc,CTPCPDesc,PAADMADMNo,PAADMRefApprovNo,PAADMRefDate,PREFLDesc,REFDDateActiveTo,REFDDesc,RFCDesc,ROBDesc,APPTAdmDR,SERDesc,APPTASParRef,PAADMRefDocListDR,SESSDesc,EventID,EVName")
{
SELECT APPT_RowId, APPT_AppointLetter, APPT_ArrivalTime, APPT_Confirmation, APPT_InterpreterRequired, APPT_Remarks, APPT_ReviewPeriod_DR, APPT_SeenDate, APPT_SeenTime, APPT_Status, APPT_Transport_DR->APTR_Desc, APPT_AS_ParRef->AS_Date, APPT_AS_ParRef->AS_SessStartTime, APPT_AS_ParRef->AS_RES_ParRef->RES_CTLOC_DR->CTLOC_Desc, APPT_AS_ParRef->AS_RES_ParRef->RES_CTPCP_DR->CTPCP_Desc, APPT_Adm_DR->PAADM_ADMNo, APPT_Adm_DR->PAADM_RefApprovNo, APPT_Adm_DR->PAADM_RefDate, APPT_PAPMI_DR->PAPMI_PAPER_DR->PAPER_PrefLanguage_DR->PREFL_Desc, APPT_Adm_DR->PAADM_RefDocList_DR->REFD_DateActiveTo, APPT_Adm_DR->PAADM_RefDocList_DR->REFD_Desc, APPT_ReasonForCancel_DR->RFC_Desc, APPT_ReasonOverBook_DR->ROB_Desc,APPT_Adm_DR,APPT_RBCServ_DR->SER_Desc,APPT_AS_ParRef,APPT_Adm_DR->PAADM_RefDocList_DR,APPT_AS_ParRef->AS_RBEffDateSession_DR->SESS_Desc,APPT_RBEvent_DR,APPT_RBEvent_DR->EV_Name
FROM SQLUser.RB_Appointment
WHERE APPT_PAPMI_DR =:PatientID
AND (APPT_Status IN ('P','I','H','J','S'))
AND APPT_AS_ParRef->AS_Date=:apptdate 
ORDER BY APPT_AS_ParRef->AS_Date DESC
}

/// NB!!!!  The Patient ID is passed into this query only so it is passed from one page
/// to the next with "next page" arrows at the bottom of the list
Query FindRescDaySched(TSRTITM As %String, TSRTORD As %String, RescID As %String, date As %Date, RegistrationNo As %String, PatientID As %String, timefrom, timeto, sessId, ServID, SessTypeId, WorkID, sessall, MedRecSearch) As %Query(CONTAINID = 1, ROWSPEC = "SchedID,Time:%Time,RegNo:%String,Name:%String,Name2:%String,Name3:%String,Name4:%String,Name5:%String,Name6:%String,Name7:%String,Name8:%String,Age:%Float,Sex:%String,Phone:%String,StatusCode,Status:%String,Service:%String,PatientID,EpisodeID,mradm,gotAppt:%Boolean,PAPMIEPRDescription:%String,ApptID:%String,StatusColor:%String,Remarks:%String,Interpreter,Transport,obreason,slotover:%String,Outcome:%String,load:%String,squeezed:%String,sessionID:%String,sesstype:%String,WLType:%String,WLStatus:%String,sessstime:%Time,sessetime:%Time,messId,DOB,itmmess,payor:%String,resrow:%String,currsess:%String,sdate:%String,MedRecNo:%String,ORIRowIDs:%String,TypeFlag:%String,InterpreterConfirmed:%String,WorkID,slotlength,ReferralPriority:%String,Plan:%String,ApptPayor:%String,ApptPlan:%String,typPatCalc:%String,VIPStatus,APPTArrivalTime:%String,ConsCateg:%String,PatStatus:%String,OPDRoom:%String,QMNo:%String")
{
}

Query ListApptByStatus(RescID As %String, dfrom As %Date, dto As %Date, status As %String, SessID As %String) As %Query(CONTAINID = 1, ROWSPEC = "SchedID,Time:%Time,RegNo:%String,Name:%String,Name2:%String,Name3:%String,Name4:%String,Name5:%String,Name6:%String,Name7:%String,Name8:%String,Age:%Float,Sex:%String,Phone:%String,StatusCode,Status:%String,Service:%String,PatientID,EpisodeID,mradm,PAPMIEPRDescription:%String,ApptID:%String,StatusColor:%String,ReasonForNotAttended:%String,MedRecNo:%String")
{
}

Query ListApptsByRes(ResourceID As %String, DateFr As %Date, DateTo As %Date, Type As %String, Status As %String, Session As %String, TimeFrom As %Time, TimeTo As %Time, Doctor As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "APPT_RowID")
{
}

/// OR :Type [ "^" _ %INTERNAL APPT_AT_DR _ "^")
Query ListApptsByResQuery(ResourceID As %String, DateFr As %Date, DateTo As %Date, Type As %String, Status As %String, Session As %String, TimeFrom As %Time, TimeTo As %Time, Doctor As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "APPT_RowID")
{
SELECT APPT_RowID
FROM RB_Appointment
WHERE APPT_AS_ParRef->AS_RES_ParRef = :ResourceID
AND (:Status IS NULL 
OR :Status [ %INTERNAL APPT_Status)
AND ((:Type [ {fn CONCAT( '^', {fn CONCAT((%INTERNAL APPT_AT_DR),'^')})}) OR (:Type IS NULL) OR (APPT_AT_DR IS NULL))
AND (APPT_AS_ParRef->AS_Date NOT< :DateFr OR :DateFr IS NULL)
AND (APPT_AS_ParRef->AS_Date NOT> :DateTo OR :DateTo IS NULL)
AND APPT_PAPMI_DR IS NOT NULL
}

Query ListOfServices(tblStr As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "serDesc,locDesc,resDesc,day,date,time,payDesc,planDesc,serId,locId,resId,payId,planId,obreason,comment,schedlist,main,nodays,duration,urgent,sesstype,transport,interpreter,stype,intreq,trareq,disInt,disTrans,ssessdesc,HCADesc,HCARowID,HospDesc,HospIDs,ApptMethod,APPTLanguage,chkIncapacity,RegistrationNo,QLDOutChk,Price,ORICred,OEOrdItemID,multiSelCnt,chkbox,ConsultCateg,Surname,Name,DoB,Sex,endtime,addStr,itemPrice")
{
}

Query ListOfAdditionalServices(addStr As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "schedID,day,date,time,duration,urgent,sesstype,ssessdesc,Price,OEOrdItemID,endtime")
{
}

Query LookUpHRG(HRG As %String, location As %String, epID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HRGCode,HRGDesc")
{
}

/// LookUpService(LRST):
/// Looks up Service by Location, Resource, Service, Service Type
/// Log 61263 - 20.11.2006 Look up by Schedule ID for Date/Time slot overrides as well if defined
Query LookUpService(LocDesc As %String, ResDesc As %String, Desc As %String, ServType As %String, BookType As %String, LocId As %String, ResDesc2 As %String, HCARowID As %String, HospIDs As %String, RESRowId As %String, RESCode As %String, Broker As %String, NoRestrict As %String, PFBFlag As %String, SchedID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Desc:%String,Message:%String,HIDDEN:%String,Frequency:%String,Duration:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod websysSavePayorPlan(compref As %String = "", id As %String = "", payor As %String, plan As %String)
{
}

ClassMethod GetApptLanguage(PatientID As %String = "", ApptTrans As %String = "") As %String
{
}

/// Returns the reason why the previous appointment
/// was transferred
ClassMethod GetPrevApptTransReason(ApptID As %String = "") As %String
{
}

ClassMethod FindToBeCancelledExecute(ByRef QHandle As %Library.Binary, ResourceID As %Library.String = "", LocationID As %Library.String, numberoftimes As %Library.String = 2) As %Library.Status
{
}

ClassMethod FindToBeCancelledFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindToBeCancelledExecute ]
{
}

ClassMethod FindToBeCancelledClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindToBeCancelledFetch ]
{
}

Query FindToBeCancelled(ResourceID As %String, LocationID As %String, numberoftimes As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "EpisodeID:%String,PatientID:%String,name:%String,name2:%String,name3:%String,name4:%String,name5:%String,name6:%String,name7:%String,name8:%String,sex:%String,DOB:%Date,date:%Date,time:%Time,location:%String,Careprovider:%String,admType:%String,AdmNo:%String,VIPStatus")
{
SELECT PAADM_RowID, PAADM_ADMNo, PAADM_AdmDate, PAADM_AdmTime, PAADM_DepCode_DR->CTLOC_Desc,PAADM_AdmDocCodeDR->CTPCP_Desc, PAADM_DischgDate,PAADM_MainMRADM_DR->MRADM_GPConsent,
 PAADM_CurrentWard_DR->WARD_Desc, PAADM_CurrentResource_DR->RES_Desc, PAAdm_PatAcuity_DR->ACU_Desc, PAAdm_AdmCateg_DR->ADMCAT_Desc
FROM SQLUser.PA_Adm
WHERE (PAADM_PAPMI_DR = :PatientID) AND (PAADM_VisitStatus IN ('A','P','D'))
ORDER BY PAADM_AdmDate desc, PAADM_AdmTime desc
}

// Log 30973 - AI - 23-12-2002 : Add Patient Acuity and Admission Category to the Select statement.

ClassMethod websysSaveAdhocSchedule(compref As %Library.String)
{
}

ClassMethod ReverseAdhoc(Resource As %Library.String = "")
{
}

ClassMethod SystemWideDeleteCorruptAppt()
{
}

ClassMethod DeleteCorruptAppt(SystemSession As %Library.String = "")
{
}

ClassMethod CheckPublicHoliday(Date As %Library.String = "", RescID As %Library.String = "")
{
}

ClassMethod GetLocResDesc(ApptId As %Library.String = "")
{
}

///  Log 56831 - 05.12.2006 - query for Patient Management View screen (RBApptPatientTraking.Find/List)
Query FindPatTracking(CP1or2 As %String, Location As %String, Resource As %String, CareProvider As %String, ClinicType As %String, Seen As %String, ToSee As %String, Current As %String, RoomNo As %String, RegistrationNo As %String, Date As %String, ShowArrived As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ApptID:%String,PatientReg:%String,Name:%String,Name2:%String,EmpNo:%String,ApptTime:%String,ArriveTime:%String,ArriveCP1:%String,ArriveCP2:%String,DepartCP1:%String,DepartCP2:%String,RoomNo:%String,PatStatus:%String,Service:%String,PatientID:%String,EpisodeID:%String,ApptStat:%String,Outcome:%String,ReqCP1:%String,ReqCP2:%String,CP1:%String,CP2:%String,QMNo:%String")
{
}

ClassMethod FindPatTrackingExecute(ByRef QHandle As %Library.Binary, CP1or2 As %Library.String = "", Location As %Library.String = "", Resource As %Library.String = "", CareProvider As %Library.String = "", ClinicType As %Library.String = "", Seen As %Library.String = "", ToSee As %Library.String = "", Current As %Library.String = "", RoomNo As %Library.String = "", RegistrationNo As %Library.String = "", Date As %Library.String = "", ShowArrived As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatTrackingClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPatTrackingFetch ]
{
}

ClassMethod FindPatTrackingFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatTrackingExecute ]
{
}

/// Log 62342 - 23.02.2007
ClassMethod RetainValues()
{
}

}
