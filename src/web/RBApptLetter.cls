Class web.RBApptLetter Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 108;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "LET_RowId";

Parameter SQLDESCRIPTION = "LET_Desc";

Parameter SQLROWID = "LET_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

Query FindToBeCancelled(ResourceID As %String, LocationID As %String, times As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "EpisodeID:%String,PatientID:%String,name:%String,name2:%String,name3:%String,sex:%String,DOB:%Date,date:%Date,time:%Time,location:%String,Careprovider:%String,admType:%String,AdmNo:%String")
{
SELECT PAADM_RowID, PAADM_ADMNo, PAADM_AdmDate, PAADM_AdmTime, PAADM_DepCode_DR->CTLOC_Desc,PAADM_AdmDocCodeDR->CTPCP_Desc, PAADM_DischgDate,PAADM_MainMRADM_DR->MRADM_GPConsent,
 PAADM_CurrentWard_DR->WARD_Desc, PAADM_CurrentResource_DR->RES_Desc, PAAdm_PatAcuity_DR->ACU_Desc, PAAdm_AdmCateg_DR->ADMCAT_Desc
FROM SQLUser.PA_Adm
WHERE (PAADM_PAPMI_DR = :PatientID) AND (PAADM_VisitStatus IN ('A','P','D'))
ORDER BY PAADM_AdmDate desc, PAADM_AdmTime desc
}

ClassMethod FindToBeCancelledClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindToBeCancelledFetch ]
{
}

/// Log 30973 - AI - 23-12-2002 : Add Patient Acuity and Admission Category to the Select statement.
ClassMethod FindToBeCancelledExecute(ByRef QHandle As %Library.Binary, ResourceID As %Library.String = "", LocationID As %Library.String, times As %Library.String = 2) As %Library.Status
{
}

ClassMethod FindToBeCancelledFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindToBeCancelledExecute ]
{
}

ClassMethod AnyApptLetters(ID As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod FindLettersForApptIDsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLettersForApptIDsFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindLettersForApptIDsExecute(ByRef QHandle As %Library.Binary, ApptIDs As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindLettersForApptIDsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLettersForApptIDsExecute ]
{
}

/// Find the letter associated with an appointment
Query FindLetterByID(ApptID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "LetterID,LetterDesc,LetterDate:%Date,LetterTime:%Time,CareProv,ApptDate:%Date,ApptSTime:%Time,ApptETime:%Time,Service")
{
SELECT LET_RowId,
 LET_Desc,
 LET_Date,
 LET_Time,
 LET_ParRef->APPT_AS_ParRef->AS_RES_ParRef->RES_CTPCP_DR->CTPCP_Desc,
 LET_ParRef->APPT_AS_ParRef->AS_Date,
 LET_ParRef->APPT_AS_ParRef->AS_SessStartTime,
 LET_ParRef->APPT_AS_ParRef->AS_SessEndTime,
 LET_ParRef->APPT_RBCServ_DR->SER_Desc
FROM SQLUser.RB_ApptLetter
WHERE LET_ParRef=:ApptID
ORDER BY LET_ParRef->APPT_AS_ParRef->AS_RES_ParRef->RES_CTPCP_DR->CTPCP_Desc,
 LET_ParRef->APPT_RBCServ_DR->SER_Desc,
 LET_ParRef->APPT_AS_ParRef->AS_Date,
 LET_ParRef->APPT_AS_ParRef->AS_SessStartTime,
 LET_Date,
 LET_Time
}

/// Find all letters for appointment associated with an admission
Query FindLettersForApptIDs(ApptIDs As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "LetterID,LetterDesc,LetterDate,LetterTime,Appt,ApptDate,ApptTime,CareProv")
{
}

}
