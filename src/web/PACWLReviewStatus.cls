Class web.PACWLReviewStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 76;

Parameter SQLDATEFROM = "WLRST_DateFrom";

Parameter SQLDATETO = "WLRST_DateTo";

Parameter SQLCODE = "WLRST_Code";

Parameter SQLDESCRIPTION = "WLRST_Desc";

Parameter SQLROWID = "WLRST_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

/// KK 19/Mar/2003 Log 32884
ClassMethod GetResponseRequired() As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpStatusBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

Query LookUpByStatus(val As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,hidden:%String,code:%String,hidden:%String")
{
SELECT WLRST_Desc,WLRST_RowId,WLRST_Code,WLRST_ResetReviewDate
FROM SQLUser.PAC_WLReviewStatus
WHERE ((%UPPER WLRST_Desc %STARTSWITH %UPPER :val) OR (%UPPER WLRST_Code %STARTSWITH %UPPER :val))
AND ((WLRST_DateFrom <= :activedate) OR (WLRST_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((WLRST_DateTo >= :activedate) OR (WLRST_DateTo IS NULL) OR (:activedate IS NULL))
}

/// GR11/7/02 25253  to populate multiple review statuses listbox
Query LookUpStatusDesc() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Code,Description")
{
SELECT WLRST_Code,WLRST_Desc
FROM SQLUser.PAC_WLReviewStatus
}

ClassMethod LookUpStatusBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

}
