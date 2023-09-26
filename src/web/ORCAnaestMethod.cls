Class web.ORCAnaestMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 114;

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

Parameter SQLCODE = "ANMET_Code";

Parameter SQLDATEFROM = "ANMET_DateFrom";

Parameter SQLDATETO = "ANMET_DateTo";

Parameter SQLDESCRIPTION = "ANMET_Desc";

Parameter SQLROWID = "ANMET_RowId";

/// rqg,Log26488:The query is standardized to accomodate start and end dates.
Query LookUpActive(val As %Library.String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "desc:%String,hidden:%String,code:%String")
{
SELECT ANMET_Desc, ANMET_RowId, ANMET_Code
FROM SQLUser.ORC_AnaestMethod
WHERE ((%UPPER ANMET_Desc %STARTSWITH %UPPER :val) OR (%UPPER ANMET_Code %STARTSWITH %UPPER :val))
AND ((ANMET_DateFrom <= :activedate) OR (ANMET_DateFrom IS NULL) OR (:activedate IS NULL))
AND ((ANMET_DateTo >= :activedate) OR (ANMET_DateTo IS NULL) OR (:activedate IS NULL))
}

Query LookUpByDate(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT ANMET_Desc, ANMET_RowId, ANMET_Code
FROM SQLUser.ORC_AnaestMethod
WHERE (ANMET_DateFrom <= CURRENT_DATE)
AND ((ANMET_DateTo >= CURRENT_DATE) OR (ANMET_DateTo IS NULL))
AND ((%UPPER ANMET_Desc %STARTSWITH %UPPER :desc) OR (%UPPER ANMET_Code %STARTSWITH %UPPER :desc))
}

ClassMethod LookUpActiveBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", activedate As %Library.Date = "") As %Library.Boolean
{
}

}
