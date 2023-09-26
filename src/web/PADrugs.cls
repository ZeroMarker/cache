Include webimport

IncludeGenerator webimport

/// %RegisteredObject,websys.Abstract
Class web.PADrugs Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DRG_RowId";

Parameter SQLDESCRIPTION = "DRG_Desc";

Parameter SQLROWID = "DRG_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Author - John Hart
/// Purpose - Saves Patient Drug Details
/// Used By - EPR page
ClassMethod HistoryInsert(compref As %Library.String, pid As %String, drug As %String, onsetDate As %String, durYr As %String, durMo As %String, durDy As %String, comments As %String, hid As %String, chkInActive As %Library.String)
{
}

Query Find(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PHCDDesc:%String,DRGOnsetDate:%Date,DRGDuratYear:%Float,DRGDuratMonth:%Float,DRGDuratDays:%Float,DRGDesc:%List,DRGCareProv:%String,UpdateUser:%String")
{
SELECT DRG_RowID, DRG_DrugMast_DR->PHCD_Name, 
 DRG_OnsetDate, DRG_DuratYear, 
 DRG_DuratMonth, DRG_DuratDays, DRG_Desc, 
 DRG_CTCP_DR->CTPCP_Desc,
 DRG_UpdateUser_DR->SSUSR_Name
FROM PA_Drugs
WHERE (DRG_ParRef = :PatientID)
}

/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
/// LOG 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code (Initials).
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PHCDDesc:%String,DRGOnsetDate:%Date,DRGDuratYear:%Float,DRGDuratMonth:%Float,DRGDuratDays:%Float,DRGDesc:%List,DRGCareProv:%String,UpdateUser:%String,DRGInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String")
{
SELECT DRG_RowID,
 DRG_DrugMast_DR->PHCD_Name,
 DRG_OnsetDate,
 DRG_DuratYear,
 DRG_DuratMonth,
 DRG_DuratDays,
 DRG_Desc,
 DRG_CTCP_DR->CTPCP_Desc,
 DRG_UpdateUser_DR->SSUSR_Name,
 DRG_InActive,
 DRG_UpdateDate,
 DRG_UpdateTime,
 DRG_UpdateHospital_DR->HOSP_Desc,
 DRG_UpdateUser_DR->SSUSR_Initials
FROM PA_Drugs
WHERE ((DRG_ParRef = :PatientID) AND ((DRG_InActive = :InActive) OR (:InActive = 'Y' AND DRG_InActive IS NULL)))
}

}
