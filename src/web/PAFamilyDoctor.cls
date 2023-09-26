Class web.PAFamilyDoctor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 357;

Parameter SQLCODE = "FAMD_RowId";

Parameter SQLDATEFROM = "FAMD_DateFrom";

Parameter SQLDESCRIPTION = "FAMD_RowId";

Parameter SQLDATETO = "FAMD_DateTo";

Parameter SQLROWID = "FAMD_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckGPOverlap(compref As %Library.String, ToPID As %Library.String, FromPID As %Library.String) As %Library.String
{
}

/// ab 21.05.02
/// called from websysBeforeSave, and UpdateLatest
ClassMethod CheckValidDates(compref As %Library.String, newdfrom As %Library.String = "", newdto As %Library.String = "", PatientID As %Library.String = "", id As %Library.String = "") As %Library.Boolean
{
}

ClassMethod DeleteAndUpdateCurrent(id As %Library.String)
{
}

ClassMethod GetCurrent(PatientID As %Library.String = "", date As %Library.String = "", ByRef docid As %Library.String = "", ByRef doccode As %Library.String = "", ByRef clinicid As %Library.String = "", ByRef clncode As %Library.String = "", ByRef clnaddr As %Library.String = "", ByRef clnprovno As %Library.String = "", ByRef clncity As %Library.String = "", ByRef clnphone As %Library.String = "", ByRef clndesc As %Library.String = "", ByRef clnzip As %Library.String = "") As %Library.String
{
}

ClassMethod GetCurrentWebDetails(PatientID As %Library.String = "", date As %Library.String = "")
{
}

ClassMethod SetCurrent(PatientID As %Library.String = "", ByRef doccode As %Library.String = "", ByRef clncode As %Library.String = "") As %Library.String
{
}

ClassMethod UpdateLatest(PatientID As %Library.String = "", DoctorID As %Library.String = "", DocClinicID As %Library.String = "", compref As %Library.String = "", DocSaveOld As %Library.String = 1, checkActiveDR As %String = "")
{
}

ClassMethod FamilyDoctorInactive(PatientID As %String = "", famdoc As %String = "", famdocclin As %String = "")
{
}

/// ab 16.04.02 - 23759
/// before save, validates date from and date to fields, cancels save if overlap with existing dates, 
/// or invalid date range
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

/// Used to find the date range for all but the current GP in the GP History
/// cjb 03/08/2004 44284 - removed - AND	FAMD_DateTo is not NULL
Query FindFamilyGPDates(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "fromdate:%Library.Date,todate:%Library.Date, rowid:%String")
{
SELECT FAMD_DateFrom,FAMD_DateTo,FAMD_RowId
FROM SQLUser.PA_FamilyDoctor
WHERE FAMD_ParRef=:PatientID
}

}
