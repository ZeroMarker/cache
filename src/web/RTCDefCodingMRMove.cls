Include webimport

IncludeGenerator webimport

Class web.RTCDefCodingMRMove Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 16;

Parameter SQLDATEFROM = "DCMM_DateFrom";

Parameter SQLCODE = "DCMM_RowId";

Parameter SQLDATETO = "DCMM_DateTo";

Parameter SQLDESCRIPTION = "DCMM_RowId";

Parameter SQLROWID = "DCMM_RowId";

Property dummy As %String(TRUNCATE = 1);

/// cjb 11/04/2005 51584 - moved here from web.PAAdmCoding
/// / KK 23/Jul/2003 Log 32778 - to move medical records on PAAdm.DRGCoding screen update. Called from web.PAAdmCoding.websysSaveDRGGrouping
ClassMethod MoveMedicalRecords(PatientID As %String = "", MRLoc As %String = "")
{
}

}
