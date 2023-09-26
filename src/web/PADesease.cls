Include webimport

IncludeGenerator webimport

Class web.PADesease Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 175;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DES_RowId";

Parameter SQLDESCRIPTION = "DES_CTCP_DR";

Parameter SQLROWID = "DES_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Author - John Hart
/// Purpose - Saves Patient Disease Details
/// Used By - EPR page
ClassMethod HistoryInsert(compref As %Library.String, pid As %String, disease As %String, onsetDate As %String, durYr As %String, durMo As %String, durDy As %String, comments As %String, hid As %String, chkInActive As %Library.String)
{
}

Query Find(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCIDDesc:%String,DESOnsetDate:%Date,DESDuratYear:%String,DESDuratMonth:%String,DESDuratDays:%String,DESDesc:%List,DESCareProv:%String,UpdateUser:%String")
{
SELECT DES_RowID, DES_MRCICDDx_DR->MRCID_Desc, 
DES_OnsetDate, DES_DuratYear, DES_DuratMonth, 
DES_DuratDays, DES_Desc, DES_CTCP_DR->CTPCP_Desc,
DES_UpdateUser_DR->SSUSR_Name
FROM PA_Desease
WHERE DES_ParRef = :PatientID
}

/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
/// Log 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, User, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code (Initials).
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCIDDesc:%String,DESOnsetDate:%Date,DESDuratYear:%String,DESDuratMonth:%String,DESDuratDays:%String,DESDesc:%List,DESCareProv:%String,UpdateUser:%String,DESInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String")
{
SELECT DES_RowID,
 DES_MRCICDDx_DR->MRCID_Desc,
 DES_OnsetDate,
 DES_DuratYear,
 DES_DuratMonth,
 DES_DuratDays,
 DES_Desc,
 DES_CTCP_DR->CTPCP_Desc,
 DES_UpdateUser_DR->SSUSR_Name,
 DES_InActive,
 DES_UpdateDate,
 DES_UpdateTime,
 DES_UpdateHospital_DR->HOSP_Desc,
 DES_UpdateUser_DR->SSUSR_Initials
FROM PA_Desease
WHERE ((DES_ParRef = :PatientID) AND ((DES_InActive = :InActive) OR (:InActive = 'Y' AND DES_InActive IS NULL)))
}

}
