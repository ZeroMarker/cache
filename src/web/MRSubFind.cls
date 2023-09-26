Include webimport

IncludeGenerator webimport

Class web.MRSubFind Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 166;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MRSUB_DocCode_DR";

Parameter SQLDESCRIPTION = "MRSUB_Desc";

Parameter SQLROWID = "MRSUB_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/*
/// KM 27-Jun-2001: Called from component MRSubFind.ListEMR
/// Log 34901 - AI - 17-06-2003 : Add "Last Update" details.
/// Log 55973 - PJC - 21-12-2005 : If the "Only show entries marked for DS Report" checkbox 
///        is checked only show those records with DSReportFlag = Y.
Query ListEPR(mradmlist As %Library.String, GrpSetCarPrv As %Library.String, OnlyMarkedForDSReport As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,BODP_Desc,SYM_Desc,MRSUB_BodyPartSymSubs,MRSUB_DateStarted:%Library.Date,MRSUB_DurationYear,MRSUB_DurationMonth,MRSUB_DurationDays,MRSUB_Desc,MRSUB_MRADM_ParRef,SSUSR_Name,MRSUB_Date,MRSUB_Time,UpdateDate:%Date,UpdateTime:%Time,UpdateHospital:%String,MRSUBDSReportFlag:%String")
{
SELECT		MRSUB_RowID,
			MRSUB_BodyParts_DR->BODP_Desc,
			MRSUB_BodyPartsSymp_DR->SYM_Desc,
			MRSUB_BodyPartSymSubs->SUBS_Desc,
			MRSUB_DateStarted,
			MRSUB_DurationYear,
			MRSUB_DurationMonth,
			MRSUB_DurationDays,
			MRSUB_Desc,
			MRSUB_MRADM_ParRef,
			MRSUB_UserUpdate->SSUSR_Name,
			MRSUB_Date,
			MRSUB_Time,
			MRSUB_UpdateDate,
			MRSUB_UpdateTime,
			MRSUB_UpdateHospital_DR->HOSP_Desc,
			MRSUB_DSReportFlag
FROM SQLUser.MR_SubFind
WHERE (("^"_:mradmlist_"^") [ ("^"_%INTERNAL(MRSUB_MRADM_ParRef)_"^"))
 AND ((:GrpSetCarPrv [ (","_%INTERNAL(MRSUB_UserUpdate->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR)_",")) 
   OR :GrpSetCarPrv is NULL)
 AND ((:OnlyMarkedForDSReport="N")
   OR ((:OnlyMarkedForDSReport="Y") AND (MRSUB_DSReportFlag="Y")))
}
*/
/// Log 58108 YC - Rewrote query to use globals instead of sql for speed
/// Called from component MRSubFind.ListEMR
ClassMethod ListEPRClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListEPRFetch ]
{
}

ClassMethod ListEPRExecute(ByRef QHandle As %Library.Binary, mradmlist As %Library.String, GrpSetCarPrv As %Library.String, OnlyMarkedForDSReport As %Library.String = "") As %Library.Status
{
}

ClassMethod ListEPRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListEPRExecute ]
{
}

Query ListEPR(mradmlist As %Library.String, GrpSetCarPrv As %Library.String, OnlyMarkedForDSReport As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,BODP_Desc,SYM_Desc,MRSUB_BodyPartSymSubs,MRSUB_DateStarted:%Library.Date,MRSUB_DurationYear,MRSUB_DurationMonth,MRSUB_DurationDays,MRSUB_Desc,MRSUB_MRADM_ParRef,SSUSR_Name,MRSUB_Date,MRSUB_Time,UpdateDate:%Date,UpdateTime:%Time,UpdateHospital:%String,MRSUBDSReportFlag:%String,EditCP")
{
}

/// Log 55973 - PC - 05-12-2005 : Save the selected rows as either "Include in DS Report" or "Exclude From DS Report".
ClassMethod IncludeExcludeDSReport(action As %Library.String = "E", RowIDs As %Library.String = "")
{
}

ClassMethod websysSaveNew(compref As %String, ByRef id As %String) As %Boolean
{
}

}
