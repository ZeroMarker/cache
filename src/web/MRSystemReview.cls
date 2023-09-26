Include webimport

IncludeGenerator webimport

Class web.MRSystemReview Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 114;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod GetFirstRecord(mradm As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Parameter SQLCODE = "SYSR_RowId";

Parameter SQLDESCRIPTION = "SYSR_RowId";

Parameter SQLROWID = "SYSR_RowId";

/// Log 32090 - AI - 16-04-2003 : Add "Last Update" information - Date, Time, Hospital.
Query ListEPR(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%Library.String,UpdateUser:%Library.String,CareProv:%Library.String,Date:%Library.String,Description:%Library.String,BodSysProbSub:%Library.String,BodySysProb:%Library.String,BodySysPrStat:%Library.String,BodySys:%Library.String,Time:%Library.String,UpdateDate:%String,UpdateTime:%String,UpdateHospital:%String")
{
SELECT SYSR_RowId,
 SYSR_UpdateUser_DR->SSUSR_Name,
 SYSR_CTCP_DR->CTPCP_Desc,
 SYSR_Date,
 SYSR_Desc,
 SYSR_MRCBodSysProbSub->SUBP_Desc,
 SYSR_MRCBodySysProb_DR->PRO_Desc,
 SYSR_MRCBodySysPrStat_DR->STAT_Desc,
 SYSR_MRCBodySys_DR->BODS_Desc,
 SYSR_Time,
 SYSR_UpdateDate,
 SYSR_UpdateTime,
 SYSR_UpdateHospital_DR->HOSP_Desc
FROM SQLUser.MR_SystemReview
WHERE (SYSR_ParRef = :mradm)
}

}
