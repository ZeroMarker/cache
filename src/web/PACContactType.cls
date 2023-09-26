Include webimport

IncludeGenerator webimport

Class web.PACContactType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 154;

Parameter SQLDATEFROM = "CONTTP_Date_From";

Parameter SQLDATETO = "CONTTP_Date_To";

Parameter SQLCODE = "CONTTP_Code";

Parameter SQLDESCRIPTION = "CONTTP_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CONTTP_Date_From <= CURRENT_DATE OR CONTTP_Date_From IS NULL) AND (CONTTP_Date_To >= CURRENT_DATE OR CONTTP_Date_To IS NULL))";

Parameter SQLROWID = "CONTTP_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod IsValidContact(val As %Library.String) As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerNOK(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", vdate As %Library.Date = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerRelation(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", vdate As %Library.Date = "") As %Library.Boolean
{
}

/// Look up contact type des and default relationship field.
/// The ongoing type are filtered out.
Query LookUpNOK(desc As %Library.String, vdate As %Library.Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,hidden:%String,hidden:%String,hidden:%String")
{
SELECT CONTTP_Desc, CONTTP_Code, CONTTP_RowId, CONTTP_FamilyRelship->CTRLT_Desc, {fn CONVERT(CONTTP_Priority, SQL_VARCHAR)} AS Priority
FROM SQLUser.PAC_ContactType
WHERE ((CONTTP_Code = :desc) OR (CONTTP_Desc %STARTSWITH :desc)) 
  AND ((CONTTP_Date_From IS NULL) OR (:vdate IS NULL) OR (CONTTP_Date_From <= :vdate))
  AND ((CONTTP_Date_To IS NULL) OR (:vdate IS NULL)  OR (CONTTP_Date_To >= :vdate ))
  AND ((CONTTP_NotOngoing IS NULL) OR  (CONTTP_NotOngoing = 'N'))
}

/// Look up contact type des and default relationship field
Query LookUpRelation(desc As %Library.String, vdate As %Library.Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String,hidden:%String,hidden:%String,hidden:%String")
{
SELECT CONTTP_Desc, CONTTP_Code, CONTTP_RowId, CONTTP_FamilyRelship->CTRLT_Desc, {fn CONVERT(CONTTP_Priority, SQL_VARCHAR)} AS Priority
FROM SQLUser.PAC_ContactType
WHERE ((CONTTP_Code %STARTSWITH :desc) OR (CONTTP_Desc %STARTSWITH :desc)) 
  AND ((CONTTP_Date_From IS NULL) OR (:vdate IS NULL) OR (CONTTP_Date_From <= :vdate))
  AND ((CONTTP_Date_To IS NULL) OR (:vdate IS NULL)  OR (CONTTP_Date_To >= :vdate ))
ORDER BY	Priority
}

}
