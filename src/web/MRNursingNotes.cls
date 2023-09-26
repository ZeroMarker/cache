Class web.MRNursingNotes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 743;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "NOT_RowId";

Parameter SQLDESCRIPTION = "NOT_RowId";

Parameter SQLROWID = "NOT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindNotesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindNotesFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindNotesExecute(ByRef QHandle As %Library.Binary, NOTStatusDR As %String, NOTTypeDR As %Library.String, Location As %Library.String, CareProv As %Library.String, DateFrom As %Library.String, DateTo As %Library.String, ClinsessID As %Library.String, RegNo As %Library.String, EpisodeType As %Library.String, EpisodeNo As %Library.String, PatientID As %Library.String, LocType As %Library.String = "", CareProvType As %Library.String, EnteredByCP As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindNotesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindNotesExecute ]
{
}

/// This returns description,id,code (this is to be consitent with lookups)
ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

/// BC 30-Jan-2002: This routine sets the flags in PAAdm or RBAppointment to indicate that there are clinical notes recorded against them
ClassMethod SetNotesFlag(EpisodeID As %Library.String, AppointmentID As %Library.String)
{
}

ClassMethod MatchEpisPatID(EpisodeID As %Library.String, PatientID As %Library.String, MRAdm As %Library.String) As %Library.String
{
}

ClassMethod websysDelete(compref As %Library.String, id As %String = "") As %Boolean
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Location:%Library.String,CareProv:%Library.String,dfrom:%Library.Date,dto:%Library.Date,NNType:%Library.String,NOTStatus:%Library.String
/// 
/// 
/// AND	(%EXTERNAL (NOT_ParRef->MRADM_ADM_DR->PAADM_AdmDate) >= :dfrom OR :dfrom IS NULL)
/// SELECT	PAADM_RowID, PAADM_ADMNo, 
/// PAADM_DepCode_DR->CTLOC_Desc, 
/// PAADM_AdmDate, PAADM_AdmTime, 
/// PAADM_MainMRADM_DR, 
/// 
/// PAADM_AdmDocCodeDR->CTPCP_Desc, 
/// PAADM_Appoint_DR->APPT_RBCServ_DR->SER_Desc,
/// PAADM_PAPMI_DR,PAADM_PAPMI_DR->PAPMI_EPRDescription,
/// PAADM_VisitStatus,PAADM_Type,PAADM_DepCode_DR->CTLOC_Dep_DR->DEP_Desc
/// PAADM_RefExpiryDate
/// FROM	SQLUser.PA_Adm
/// WHERE	(PAADM_DepCode_DR->CTLOC_Desc,  = :PatientID) 
Query Find(NOTStatusDR, NOTTypeDR, Location, CareProv, DateFrom, DateTo, RegNo) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,NOTStatusDR,NOTTypeDR,EpisodeID,EpisodeNo,PatientID,Name,Name2,Name3,Location,CareProv,EpisodeStartDate:%Library.Date,Notes,Speciality,DischargeDate:%Library.Date,ApptDate:%Library.Date,NOTIncludedForDischSum,NOTEnteredCareProv")
{
SELECT NOT_RowID, NOT_ParRef, 
NOT_Status_DR->NNS_Desc,
NOT_ClinNotesType_DR->CNT_Desc,
NOT_ParRef->MRADM_ADM_DR,
NOT_ParRef->MRADM_ADM_DR->PAADM_ADMNo,
NOT_ParRef->MRADM_ADM_DR->PAADM_PAPMI_DR,
NOT_ParRef->MRADM_ADM_DR->PAADM_PAPMI_DR->PAPMI_Name,
NOT_ParRef->MRADM_ADM_DR->PAADM_PAPMI_DR->PAPMI_Name2,
NOT_ParRef->MRADM_ADM_DR->PAADM_PAPMI_DR->PAPMI_Name3,
NOT_ParRef->MRADM_ADM_DR->PAADM_DepCode_DR->CTLOC_Desc,
NOT_ParRef->MRADM_ADM_DR->PAADM_AdmDocCodeDR->CTPCP_Desc,
NOT_ParRef->MRADM_ADM_DR->PAADM_AdmDate,
NOT_Notes,
NOT_ParRef->MRADM_ADM_DR->PAADM_AdmDocCodeDR->CTPCP_CTLOC_DR->CTLOC_Desc,
NOT_ParRef->MRADM_ADM_DR->PAADM_DischgDate,
NOT_ParRef->MRADM_ADM_DR->PAADM_Appoint_DR->APPT_AS_ParRef->AS_Date,
NOT_IncludedForDischSum,
NOT_EnteredCareProv_DR->CTPCP_Desc
FROM SQLUser.MR_NursingNotes
WHERE (NOT_Status_DR->NNS_Desc = :NOTStatusDR OR :NOTStatusDR IS NULL)
AND (NOT_ClinNotesType_DR->CNT_Desc = :NOTTypeDR OR :NOTTypeDR IS NULL)
AND (NOT_ParRef->MRADM_ADM_DR->PAADM_DepCode_DR->CTLOC_Desc = :Location OR :Location IS NULL)
AND (NOT_ParRef->MRADM_ADM_DR->PAADM_AdmDocCodeDR->CTPCP_Desc = :CareProv OR :CareProv IS NULL)
AND (NOT_ParRef->MRADM_ADM_DR->PAADM_AdmDate >= :DateFrom OR :DateFrom IS NULL)
AND (NOT_ParRef->MRADM_ADM_DR->PAADM_AdmDate <= :DateTo OR :DateTo IS NULL)
AND (NOT_ParRef->MRADM_ADM_DR->PAADM_PAPMI_DR->PAPMI_No = :RegNo OR :RegNo IS NULL)
}

Query FindNotes(NOTStatusDR As %Library.String, NOTTypeDR As %Library.String, Location As %Library.String, CareProv As %Library.String, DateFrom As %Library.String, DateTo As %Library.String, ClinsessID As %Library.String, RegNo, EpisodeType, EpisodeNo, PatientID, LocType, CareProvType, EnteredByCP) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,mradm,NOTStatusDR,NOTTypeDR,EpisodeID,EpisodeNo,PatientID,Name,Name2,Name3,Location,CareProv,EpisodeStartDate:%Library.Date,Notes,DischargeDate:%Library.Date,ApptDate:%Library.Date,ClinSess,EpType,ApptID,NOTUserDR,NOTDate,NOTTime,NotesFull,ApptDoc,ApptDept,RegNo,NOTEnteredLocDR,NOTIncludedForDischSum,NOTNurseIdDR")
{
}

ClassMethod ListEPRClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = ListEPRExecute ]
{
}

ClassMethod ListEPRExecute(ByRef QHandle As %Binary, mradm As %Library.String = "", GrpSetCarPrv As %Library.String = "", CNTDesc As %String = "", EnteredByCP As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", NOTStatus As %Library.String = "", ApptDate As %Library.String = "", HIDCNTList As %Library.String = "") As %Status
{
}

ClassMethod ListEPRFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListEPRExecute ]
{
}

/// Log 55973 - PC - 02-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

/// KM 27-Jun-2001: Called from component MRNursingNotes.List
/// KM 18-Dec-2001: Log21975: Updated so that it orders in Date,Time Descending
Query ListEPR(mradm As %Library.String, GrpSetCarPrv As %Library.String, CNTDesc As %String, EnteredByCP As %Library.String, DateFrom As %Library.String, DateTo As %Library.String, NOTStatus As %Library.String, ApptDate As %Library.String, HIDCNTList As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,NOTDate:%Library.Date,CTPCPDesc:%Library.String,NOTNotes:%List,NOTParRef,NOTTime:%Library.Time,NOTStatusCode,NOTStatus,NOTType,CTPCPRowId,NOTCreateTime:%Library.Time,NOTCreateDate:%Library.Date,NOTDSReportFlag:%Library.String,NOTEnteredLocDR:%Library.String,NOTIncludedForDischSum,NOTEnteredLocDR,LastUpdHosp,EditCP")
{
}

/// Log 58610 - GC - 27/04/2006 : Save the DS Report Flag. 
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

ClassMethod websysSaveNew(compref As %String, ByRef id As %String) As %Boolean
{
}

}
