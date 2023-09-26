Class web.PACWLReviewOutcome Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 83;

Property Dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpOutcomeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

Parameter SQLCODE = "WLROU_Code";

Parameter SQLDATEFROM = "WLROU_DateFrom";

Parameter SQLDATETO = "WLROU_DateTo";

Parameter SQLDESCRIPTION = "WLROU_Desc";

Parameter SQLROWID = "WLROU_RowId";

Query LookUpByOutcome(val As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,hidden:%String,code:%String,hidden:%String")
{
SELECT WLROU_Desc,WLROU_RowId,WLROU_Code,WLROU_ResetReviewDate
FROM SQLUser.PAC_WLReviewOutcome
WHERE ((%UPPER WLROU_Desc %STARTSWITH %UPPER :val) OR (%UPPER WLROU_Code %STARTSWITH %UPPER :val))
AND ((WLROU_DateFrom <= :activedate) OR (WLROU_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((WLROU_DateTo >= :activedate) OR (WLROU_DateTo IS NULL) OR (:activedate IS NULL))
}

ClassMethod LookUpOutcomeBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod ReviewResetDefined() As %Library.String
{
}

}
