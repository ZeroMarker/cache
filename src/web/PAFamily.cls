Include webimport

IncludeGenerator webimport

Class web.PAFamily Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 167;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "FAM_RowId";

Parameter SQLDESCRIPTION = "FAM_Desc";

Parameter SQLROWID = "FAM_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Author - John Hart
/// Purpose - Saves Patient Family Details
/// Used By - EPR page
/// Log 58610 - GC - 26-04-2006 : Add new argument DSReportFlag
ClassMethod HistoryInsert(pid As %String, disease As %String, relation As %String, onsetDate As %String, comments As %String, hid As %String, chkInActive As %Library.String, BodySys As %Library.String, BodySysProb As %Library.String, BodySysProbSub As %Library.String, DSReportFlag As %Library.String, Duration As %Library.String, DurationDesc As %Library.String, ApproxOnset As %Library.String)
{
}

Query Find(PatientID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCIDDesc:%String,FAMOnsetDate:%Date,FAMDuratYear:%String,FAMDuratMonth:%String,FAMDuratDays:%String,FAMDesc:%String,FAMCareProv:%String,UpdateUser:%String,CTRLTDesc:%String")
{
SELECT FAM_RowID, FAM_MRCICD_DR->MRCID_Desc, 
 FAM_OnsetDate, FAM_DuratYear, 
 FAM_DuratMonth, FAM_DuratDays, FAM_Desc, 
 FAM_CTCP_DR->CTPCP_Desc,
 FAM_UpdateUser_DR->SSUSR_Name,
 FAM_Relation_DR->CTRLT_Desc
FROM PA_Family
WHERE (FAM_PAPMI_ParRef = :PatientID)
}

/// Called by web.PAPatMas.HistoryExecute
/// Used in EPR Chart, Patient History, History.
/// LOG 26677 - AI - 25-07-2002 : Find With InActive checkbox value.
/// Log 32090 - AI - 17-04-2003 : Add Last Update fields - Date, Time, Hospital.
/// Log 42561 - AI - 27-02-2004 : Now add Last Update User Code (Initials).
/// Log 58610 - GC - 26-04-2006 : Add DSReportFlag to ROWSPEC and SELECT list
Query FindWithInActive(PatientID As %String, InActive As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCIDDesc:%String,FAMOnsetDate:%Date,FAMDuratYear:%String,FAMDuratMonth:%String,FAMDuratDays:%String,FAMDesc:%String,FAMCareProv:%String,UpdateUser:%String,FAMInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,CTRLTDesc:%String,UpdateUserCode:%String,BodySys:%String,BodySysProb:%String,BodySysProbSub:%String,DSReportFlag:%String,Duration:%String,DurationDesc:%String,CTRLTCode:%String,ApproxOnsetDate:%String")
{
SELECT FAM_RowID,
 FAM_MRCICD_DR->MRCID_Desc,
 FAM_OnsetDate,
 FAM_DuratYear,
 FAM_DuratMonth,
 FAM_DuratDays,
 FAM_Desc,
 FAM_CTCP_DR->CTPCP_Desc,
 FAM_UpdateUser_DR->SSUSR_Name,
 FAM_InActive,
 FAM_UpdateDate,
 FAM_UpdateTime,
 FAM_UpdateHospital_DR->HOSP_Desc,
 FAM_Relation_DR->CTRLT_Desc,
 FAM_UpdateUser_DR->SSUSR_Initials,
 FAM_MRCBodySys_DR->BODP_Desc,
 FAM_MRCBodySysProb_DR->SYM_Desc,
 FAM_MRCBodSysProbSub_DR->SUBS_Desc,
 FAM_DSReportFlag,
 FAM_Duration,
 FAM_DurationDesc,
 FAM_Relation_DR->CTRLT_Code,
 FAM_ApproxOnsetDate
FROM PA_Family
WHERE ((FAM_PAPMI_ParRef = :PatientID) AND ((FAM_InActive = :InActive) OR (:InActive = 'Y' AND FAM_InActive IS NULL)))
}

ClassMethod HistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = HistoryFetch ]
{
}

ClassMethod HistoryExecute(ByRef QHandle As %Library.Binary, PatientID As %String, PAHistoryType As %String = "") As %Library.Status
{
}

ClassMethod HistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = HistoryExecute ]
{
}

/// Log 58610 - GC - 26-04-2006 : Add DSReportFlag to ROWSPEC
Query History(PatientID As %String, PAHistoryType As %String) As %Query(CONTAINID = 1, ROWSPEC = "ID,Type:%String,Desc:%String,OnsetDate:%Date,Years,Months,Days,Comments:%List,CareProvider:%String,UpdateUser:%String,HistoryType:%String,HistoryDesc:%String,CommentsDisplay:%String,chkInActive:%String,UpdateDate:%Date,UpdateTime:%Time,UpdateHospitalDesc:%String,UpdateUserCode:%String,HiddenFields:%String,Relation:%String,BodySys:%String,BodySysProb:%String,BodySysProbSub:%String,DSReportFlag:%String,Duration:%String,DurationDesc:%String,ApproxOnsetDate:%String")
{
}

/// Log 58610 - GC 26/04/2006 : Save the DS Report Flag.
ClassMethod websysUpdateDSReportFlag(id As %Library.String = "") As %Boolean
{
}

}
