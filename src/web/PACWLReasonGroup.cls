Class web.PACWLReasonGroup Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 84;

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpCIBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "WLRG_Code";

Parameter SQLDATEFROM = "WLRG_DateFrom";

Parameter SQLDATETO = "WLRG_DateTo";

Parameter SQLDESCRIPTION = "WLRG_Desc";

Parameter SQLROWID = "WLRG_RowId";

Query LookUpByCI(val As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,hidden:%String,code:%String")
{
SELECT WLRG_Desc,WLRG_RowId,WLRG_Code
FROM SQLUser.PAC_WLReasonGroup
WHERE ((%UPPER WLRG_Desc %STARTSWITH %UPPER :val) OR (%UPPER WLRG_Code %STARTSWITH %UPPER :val))
AND ((WLRG_DateFrom <= :activedate) OR (WLRG_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((WLRG_DateTo >= :activedate) OR (WLRG_DateTo IS NULL) OR (:activedate IS NULL))
}

ClassMethod LookUpCIBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

}
