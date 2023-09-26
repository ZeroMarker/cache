Class web.PACWaitingListPriority Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 133;

Property dummy As %Library.String(TRUNCATE = 1);

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
ClassMethod LookUpByPriorityBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

Parameter SQLCODE = "WLP_Code";

Parameter SQLDATEFROM = "WLP_DateFrom";

Parameter SQLDATETO = "WLP_DateTo";

Parameter SQLDESCRIPTION = "WLP_Desc";

Parameter SQLROWID = "WLP_RowId";

Query LookUpByPriority(val As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,hidden:%String,code:%String")
{
SELECT WLP_Desc,WLP_RowId,WLP_Code
FROM SQLUser.PAC_WaitingListPriority
WHERE ((%UPPER WLP_Desc %STARTSWITH %UPPER :val) OR (%UPPER WLP_Code %STARTSWITH %UPPER :val))
AND ((WLP_DateFrom <= :activedate) OR (WLP_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((WLP_DateTo >= :activedate) OR (WLP_DateTo IS NULL) OR (:activedate IS NULL))
}

ClassMethod LookUpActiveBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpByPriorityBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

}
