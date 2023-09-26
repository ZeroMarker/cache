Include webimport

IncludeGenerator webimport

Class web.PAPastHistCondition Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 153;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PHIST_RowId";

Parameter SQLDESCRIPTION = "PHIST_Desc";

Parameter SQLROWID = "PHIST_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Author - John Hart
/// Purpose - Saves Patient Family Details
/// Used By - EPR page
ClassMethod HistoryInsert(compref As %Library.String, pid As %String, condition As %String, onsetDate As %String, durYr As %String, durMo As %String, durDy As %String, comments As %String, hid As %String, chkInActive As %Library.String)
{
}

ClassMethod GetFirstRecord(PatientID As %Library.String)
{
}

ClassMethod GetLastRecord(PatientID As %Library.String)
{
}

/// update comment field of first record or new record
/// used from Order Entry update
ClassMethod websysSaveComment(PatientID As %Library.String = "", txt As %Library.String = "")
{
}

Query Find(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PASTDesc:%String,PHISTOnsetDate:%Date,PHISTDuratDays:%String,PHISTDuratMonth:%String,PHISTDuratYear:%String,PHISTDesc:%List,PHISTCareProv:%String,UpdateUser:%String")
{
SELECT PHIST_RowID,  PHIST_PastHist_DR->PAST_Desc, 
PHIST_OnsetDate,  PHIST_DuratYear,PHIST_DuratMonth,
PHIST_DuratDays,PHIST_Desc, PHIST_CTCP_DR->CTPCP_Desc,
PHIST_UpdateUser_DR->SSUSR_Name
FROM SQLUser.PA_PastHistCondition
WHERE PHIST_ParRef = :PatientID
}

/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
/// LOG 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code (Initials).
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,PASTDesc:%String,PHISTOnsetDate:%Date,PHISTDuratDays:%String,PHISTDuratMonth:%String,PHISTDuratYear:%String,PHISTDesc:%List,PHISTCareProv:%String,UpdateUser:%String,PHISTInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String")
{
SELECT PHIST_RowID,
 PHIST_PastHist_DR->PAST_Desc,
 PHIST_OnsetDate,
 PHIST_DuratYear,
 PHIST_DuratMonth,
 PHIST_DuratDays,
 PHIST_Desc,
 PHIST_CTCP_DR->CTPCP_Desc,
 PHIST_UpdateUser_DR->SSUSR_Name,
 PHIST_InActive,
 PHIST_UpdateDate,
 PHIST_UpdateTime,
 PHIST_UpdateHospital_DR->HOSP_Desc,
 PHIST_UpdateUser_DR->SSUSR_Initials
FROM SQLUser.PA_PastHistCondition
WHERE ((PHIST_ParRef = :PatientID) AND ((PHIST_InActive = :InActive) OR (:InActive = 'Y' AND PHIST_InActive IS NULL)))
}

}
