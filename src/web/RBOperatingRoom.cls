Class web.RBOperatingRoom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2083;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Chandana Log 41689
/// Returns a 0 or 1 depending on if there is data in the child tables
ClassMethod FindLinksStatus(id As %Library.String)
{
}

/// Default implementation of LookUp Query.
ClassMethod RBOPAnaestPrefListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = RBOPAnaestPrefListFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod RBOPAnaestPrefListExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod RBOPAnaestPrefListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = RBOPAnaestPrefListExecute ]
{
}

ClassMethod RBOPAnaestItems() As %Library.String
{
}

ClassMethod RBOPAnaestPrefSave()
{
}

/// Log 43894 10/8/04
/// This method sets the defaults for ORAnaesthesia.Edit as per Preference setup
ClassMethod GetRBOPAnaestPrefDefaults(RBOPId As %Library.String = "")
{
}

/// Log 43894 10/8/04
/// This method sets the defaults for ORAnaOperation.Edit as per Preference setup
ClassMethod GetRBOPOperPrefDefaults(RBOPId As %Library.String = "", AnaOpID As %Library.String = "")
{
}

ClassMethod GetRBOPOperSecPrefDefaults(RBOPId As %Library.String = "", SecProcId As %Library.String = "")
{
}

/// A function to transfer "booked" theatre bookings i.e. change the
/// associated appointments.
ClassMethod BulkTransfer(compref As %String) As %Boolean
{
}

ClassMethod CheckResLocPerBulk(ApptList As %String = "", OperList As %String = "", LocationID As %String = "", RescID As %String = "") As %Library.Boolean
{
}

ClassMethod GetOTCTDef(userid As %String = "", groupid As %String = "") As %Library.String
{
}

ClassMethod RetainValues()
{
}

ClassMethod EpisodeHasABookedTheatre(adm As %String = "") As %Library.Boolean
{
}

ClassMethod zwebsysSaveArrived(compref As %String, id As %String)
{
}

ClassMethod websysSaveStatus(compref As %String, ids As %String = "", newstatus As %String = "", dateA As %String = "", timeA As %String = "")
{
}

Parameter SQLCODE = "RBOP_RowId";

Parameter SQLDESCRIPTION = "RBOP_Rowid";

Parameter SQLROWID = "RBOP_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod DoesOtherOpBookExist(patientid As %Library.String = "") As %Boolean
{
}

ClassMethod DoesOtherOpBookExist2(episodeid As %Library.String = "", ByRef sdate As %Library.String, ByRef stime As %Library.String, ByRef surg As %Library.String, ByRef op As %Library.String) As %Boolean
{
}

ClassMethod DoesSeqNoExist(ResID As %Library.String, Date As %Library.Date = {+$h}, SeqNo As %Library.String, OpID As %Library.String = "", SessID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod DoesSeqNoExistFromSched(ResID As %Library.String, Date As %Library.Date = {+$h}, SeqNo As %Library.String, OpID As %Library.String = "", SchedID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod IsOpBookPreAdm(adm As %Library.String = "") As %Boolean
{
}

/// Log 45324 CS 6/1/05
ClassMethod IsAdmSameDay(EpisodeID As %Library.String = "") As %Boolean
{
}

ClassMethod PatientTheatreProgress(EpisodeID As %Library.String = "") As %Integer
{
}

ClassMethod TheatreBooking(EpisodeID As %Library.String = "") As %Integer
{
}

ClassMethod ExtraOperationStaff(OperRoomID As %Library.String = "") As %Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod FindOperationClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOperationFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindOperationExecute(ByRef QHandle As %Library.Binary, TSRTITM As %String = "", TSRTORD As %Library.String = "", RBOPDateOper As %Library.String = "", CTLocID As %Library.String = "", ResID As %Library.String = "", Anesthetiest As %Library.String = "", RBOPOperDepartmentID As %Library.String = "", OPStatus As %Library.String = "", dateto As %Library.Date = "", surgeonid As %Library.String = "", NoAppt As %Library.String = "", RBOPOperation As %Library.String = "", RBOPStatePPP As %Library.String = "", RegistrationNo As %Library.String = "", Surgeon As %Library.String = "", Params As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindOperationFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOperationExecute ]
{
}

ClassMethod GetEstTime(StTime As %Library.String = "", Date As %Library.String = "", SeqNo As %Library.String = "", ResId As %String = "") As %Library.String
{
}

ClassMethod GetExtraToEstTime(Operation As %Library.String = "", Surgeon As %Library.String = "", SPPOperation As %Library.String = "") As %Library.String
{
}

ClassMethod IsInProcTime(ResID, Date, atime) As %Library.String
{
}

ClassMethod NACheckSTime(ResId, Date, STime) As %Library.String
{
}

ClassMethod NACheckETime(ResId, Date, ETime) As %Library.String
{
}

ClassMethod NACheckVacantSTime(ResId, Date, STime) As %Library.String
{
}

ClassMethod NACheckVacantETime(ResId, Date, STime, ETime, VNAID) As %Library.String
{
}

ClassMethod GetSequenceNo(ResID As %Library.String, Date As %Library.Date = {+$h}, SessID As %Library.String = "") As %Library.Integer
{
}

ClassMethod GetSequenceNoFromSched(ResID As %Library.String, Date As %Library.Date = {+$h}, SchedID As %Library.String = "") As %Library.Integer
{
}

/// Log 43894 - CS 04/8/04 Get count of OT bookings with status 'B' or 'A' for the given episode id
ClassMethod GetOTByEpId(EpId As %String) As %Library.Integer
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpTBCClose(QHandle As %Library.Binary) As %Library.Status [ CodeMode = generator, PlaceAfter = LookUpTBCFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpTBCExecute(ByRef QHandle As %Library.Binary, ResourceID As %String = "", LocationID As %Library.String = "", times As %Library.String = 2) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpTBCFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpTBCExecute ]
{
}

ClassMethod ShuffleSeqNo(ResID As %Library.String = "", Date As %Library.Date = {+$h}, NewSqNo As %Library.Integer = "", OpID As %Library.String = "", SchedID As %Library.String = "")
{
}

/// Returns the number of slots left in an resource session
ClassMethod SlotsLeft(sess As %String = "", dt As %String = {+$h}, res As %String = "") As %Integer
{
}

/// Truncates Name and procedure for the operating diary
ClassMethod TruncateNameProc(ByRef Name As %String = "", ByRef Operation As %String = "")
{
}

ClassMethod webSetDetails()
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod ResetVacant(upvacant As %Library.String = "", VNAID As %Library.String = "", RescID As %Library.String = "")
{
}

ClassMethod ReEstablishVacant(vacdate As %Library.String, sttime As %Library.String = "", uptime As %Library.String = "", RescID As %Library.String = "")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod CheckIsNAperiods(ResId As %Library.String = "", Date As %Library.String = "", esTime As %Library.String = "", duration As %Library.String = "")
{
}

ClassMethod CheckInExProcTime(res As %Library.String = "")
{
}

Query FindOperation(TSRTITM As %Library.String, TSRTORD As %Library.String, RBOPDateOper As %Library.String, CTLocID As %Library.String, ResID As %Library.String, Anesthetiest As %Library.String, RBOPOperDepartmentID As %Library.String, OPStatus As %Library.String, dateto As %Library.Date, surgeonid As %Library.String, NoAppt As %Library.String, RBOPOperation As %Library.String, RBOPStatePPP As %Library.String, RegistrationNo As %Library.String, Surgeon As %Library.String, Params As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "OperRoomID:%String,PatientID:%String,EpisodeID:%String,Resource:%String,Date:%Date,Time:%Time,Status:%String,Name:%String,Name2:%String,Name3:%String,Name4:%String,Name5:%String,Name6:%String,Name7:%String,Name8:%String,RegNo:%String,Operation:%String,MainSurgeon:%String,Anesthetic:%String,MainAnesthiest:%String,Priority:%String,ApptID:%String,SeqNo:%String,LocationID:%String,OperationID:%String,EpisodeNo:%String,EpisodeLoc:%String,VisitStat:%String,AdmDate:%String,AdmTime:%String,SuspendReason:%String,CancelReason:%String,Procedure:%String,Hospital:%String,arrvDate:%Date,arrvTime:%Time,EstTime:%Time,CurSeqNo:%String,age:%String,dob:%String,sex:%String,remarks:%String,FreeProc:%String,nationalID:%String,ExpAdmTime:%String,PatContacted:%String,Bed:%String,Ward:%String,VIPStatus,EstFinishDate:%Date,EstFinishTime:%Time,OperCatQID,ApproxTime:%Time,eqstr:%String")
{
}

Query FindAllStatus() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc")
{
	SELECT Description 
 	FROM websys.StandardTypeItem 
 	WHERE ParRef='RBOperatingRoomStatus'
 	ORDER BY Description
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpTBC(ResourceID As %String, LocationID As %String, times As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "EpisodeID:%String,PatientID:%String,name:%String,name2:%String,name3:%String,sex:%String,DOB:%Date,date:%Date,time:%Time,location:%String,Careprovider:%String,admType:%String,AdmNo:%String")
{
}

/// Log 43894 - CS 04/8/04 Get prefrences for what needs to be copied from RBOperatingRoom to ORAnaesthesia
Query RBOPAnaestPrefList() As %Library.Query(CONTAINID = 0, ROWSPEC = "code:%String,caption:%String,selected:%Boolean")
{
}

ClassMethod websysApptScheduleSave(SchedID As %String)
{
}

}
