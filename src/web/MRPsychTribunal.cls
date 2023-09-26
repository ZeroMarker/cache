Class web.MRPsychTribunal Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 65;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRIB_RowId";

Parameter SQLDESCRIPTION = "TRIB_RowId";

Parameter SQLROWID = "TRIB_RowId";

Property dummy As %String(TRUNCATE = 1);

Query FindTribunal(PARREF As %String = "", mradm As %String = "") As %Query(CONTAINID = 1, ROWSPEC = "ID,PARREF,APPLDesc,APPEALDesc,APPTYPEDesc,DECDesc,TRIBAppealStatus,TRIBCoOrdinator,TRIBComments,TRIBSolicitor,TRIBDateHearing,TRIBDateMedical,TRIBDateReferral,TRIBDateReport,TRIBDateSocial,TRIBDateStatement,TRIBDateSubReport,TRIBReportSent,TRIBPatAttend,TRIBDateNrsReport")
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod FindTribunalExecute(ByRef QHandle As %Library.Binary, PARREF As %String = "", mradm As %String = "") As %Library.Status
{
}

ClassMethod FindTribunalFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindTribunalExecute ]
{
}

ClassMethod FindTribunalClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindTribunalFetch ]
{
}

Query FindTribunal2(PARREF As %String = "", mradm As %String = "", PatUR As %String = "", PatSurname As %String = "", PatGiven As %String = "", PatSex As %String = "", PatDOB As %String = "", Appeal As %String = "", AppealType As %String = "", HearingDateFrom As %String = "", HearingDateTo As %String = "", AppealStatus As %String = "", Decision As %String = "", LegalStatus As %String = "", AdmHospital As %String = "", AdmWard As %String = "") As %Query(CONTAINID = 1, ROWSPEC = "ID,PARREF,APPLDesc,APPEALDesc,APPTYPEDesc,DECDesc,TRIBAppealStatus,TRIBCoOrdinator,TRIBComments,TRIBSolicitor,TRIBDateHearing,TRIBDateMedical,TRIBDateReferral,TRIBDateReport,TRIBDateSocial,TRIBDateStatement,TRIBDateSubReport,TRIBReportSent,TRIBPatAttend,TRIBDateNrsReport,PatientID,EpisodeID,mradm,Surname,GivenName,Sex,DOB,LegalStatus,CareProv")
{
}

ClassMethod FindTribunal2Execute(ByRef QHandle As %Library.Binary, PARREF As %String = "", mradm As %String = "", PatUR As %String = "", PatSurname As %String = "", PatGiven As %String = "", PatSex As %String = "", PatDOB As %String = "", Appeal As %String = "", AppealType As %String = "", HearingDateFrom As %String = "", HearingDateTo As %String = "", AppealStatus As %String = "", Decision As %String = "", LegalStatus As %String = "", AdmHospital As %String = "", AdmWard As %String = "") As %Library.Status
{
}

ClassMethod FindTribunal2Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindTribunal2Execute ]
{
}

ClassMethod FindTribunal2Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindTribunal2Fetch ]
{
}

ClassMethod websysDelete(id As %Library.String)
{
}

}
