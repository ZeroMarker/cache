Include webimport

IncludeGenerator webimport

Class web.PAOperation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 229;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OPER_RowId";

Parameter SQLDESCRIPTION = "OPER_Desc";

Parameter SQLROWID = "OPER_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod HistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = HistoryFetch ]
{
}

ClassMethod HistoryExecute(ByRef QHandle As %Library.Binary, PatientID As %String) As %Library.Status
{
}

ClassMethod HistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = HistoryExecute ]
{
}

/// Query to retrieve data from multiple tables:
/// PADesease (!),PAPastHistCondition,PAOperation,PAAllergy,PASocHist,PAFamily
/// ;
/// This query requires that the 'Find' queries are consistent.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code.
/// Log 58610 - GC - 24-04-2006 : Add OPERDSReportFlag to ROWSPEC
Query History(PatientID As %String) As %Query(CONTAINID = 1, ROWSPEC = "ID,Type:%String,Desc:%String,OnsetDate:%Date,Years,Months,Days,Comments:%List,CareProvider:%String,UpdateUser:%String,HistoryType:%String,HistoryDesc:%String,CommentsDisplay:%String,chkInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,Laterality:%String,HiddenFields:%String,Quantity:%String,OPERDSReportFlag:%String")
{
}

/// Author - John Hart
/// Purpose - Saves Patient Family Details
/// Used By - EPR page 
/// 
ClassMethod HistoryInsert(compref As %Library.String, PatientID As %String, operDesc As %String, onsetDate As %String, durYr As %String, durMo As %String, durDy As %String, comments As %String, HistoryID As %String, chkInActive As %Library.String, Laterality As %Library.String, DSReportFlag As %Library.String)
{
}

Query Find(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,ORCOPERDesc:%String,OPEROnsetDate:%Date,OPERDuratYear:%String,OPERDuratMonth:%String,OPERDuratDays:%String,OPERDesc:%List,OPERCareProv:%String,UpdateUser:%String")
{
SELECT OPER_RowID, OPER_ORCOper_DR->OPER_Desc, 
OPER_OnsetDate, OPER_DuratYear, OPER_DuratMonth, 
OPER_DuratDays, OPER_Desc, OPER_Doctor_DR->CTPCP_Desc,
OPER_UpdateUser_DR->SSUSR_Name
FROM PA_Operation
WHERE (OPER_ParRef = :PatientID)
}

/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
/// LOG 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code (Initials).
/// Log 58610 - GC - 26-04-2006 : Add DSReportFlag to ROWSPEC.
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,ORCOPERDesc:%String,OPEROnsetDate:%Date,OPERDuratYear:%String,OPERDuratMonth:%String,OPERDuratDays:%String,OPERDesc:%List,OPERCareProv:%String,UpdateUser:%String,OPERInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String,Laterality:%String,DSReportFlag:%String")
{
SELECT OPER_RowID,
 OPER_ORCOper_DR->OPER_Desc,
 OPER_OnsetDate,
 OPER_DuratYear,
 OPER_DuratMonth,
 OPER_DuratDays,
 OPER_Desc,
 OPER_Doctor_DR->CTPCP_Desc,
 OPER_UpdateUser_DR->SSUSR_Name,
 OPER_InActive,
 OPER_UpdateDate,
 OPER_UpdateTime,
 OPER_UpdateHospital_DR->HOSP_Desc,
 OPER_UpdateUser_DR->SSUSR_Initials,
 OPER_Laterality_DR->LATER_Desc,
 OPER_DSReportFlag
 
FROM PA_Operation
WHERE ((OPER_ParRef = :PatientID) AND ((OPER_InActive = :InActive) OR (:InActive = 'Y' AND OPER_InActive IS NULL)))
}

/// Log 58610 - GC 24/04/2006 : Save the DS Report Flag.
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

}
