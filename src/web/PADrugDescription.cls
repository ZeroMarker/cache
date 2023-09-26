Include webimport

IncludeGenerator webimport

Class web.PADrugDescription Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 125;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DRD_RowId";

Parameter SQLDESCRIPTION = "DRD_Desc";

Parameter SQLROWID = "DRD_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Author - John Hart
/// Purpose - Saves Patient Drug Details
/// Used By - EPR page
ClassMethod HistoryInsert(pid As %String, drgDesc As %String, onsetDate As %String, durYr As %String, durMo As %String, durDy As %String, comments As %String, hid As %String, chkInActive As %Library.String)
{
}

Query Find(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DRDNotes:%List,DRDOnsetDate:%Date,DRDDuratYear:%Float,DRDDuratMonth:%Float,DRDDuratDays:%Float,DRDDesc:%List,DRDCareProv:%String,UpdateUser:%String")
{
SELECT DRD_RowID, DRD_Notes, DRD_OnsetDate, 
 DRD_DuratYear, DRD_DuratMonth, 
 DRD_DuratDays, DRD_Desc, 
 DRD_CTCP_DR->CTPCP_Desc,
 DRD_UpdateUser_DR->SSUSR_Name
FROM PA_DrugDescription
WHERE (DRD_ParRef = :PatientID)
}

/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
/// LOG 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code (Initials).
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DRDNotes:%List,DRDOnsetDate:%Date,DRDDuratYear:%Float,DRDDuratMonth:%Float,DRDDuratDays:%Float,DRDDesc:%List,DRDCareProv:%String,UpdateUser:%String,DRDInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String")
{
SELECT DRD_RowID,
 DRD_Notes,
 DRD_OnsetDate,
 DRD_DuratYear,
 DRD_DuratMonth,
 DRD_DuratDays,
 DRD_Desc,
 DRD_CTCP_DR->CTPCP_Desc,
 DRD_UpdateUser_DR->SSUSR_Name,
 DRD_InActive,
 DRD_UpdateDate,
 DRD_UpdateTime,
 DRD_UpdateHospital_DR->HOSP_Desc,
 DRD_UpdateUser_DR->SSUSR_Initials
FROM PA_DrugDescription
WHERE ((DRD_ParRef = :PatientID) AND ((DRD_InActive = :InActive) OR (:InActive = 'Y' AND DRD_InActive IS NULL)))
}

}
