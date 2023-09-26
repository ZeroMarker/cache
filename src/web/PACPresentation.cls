Include webimport

Class web.PACPresentation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM = "PRES_DateFrom";

Parameter SQLDATETO = "PRES_DateTo";

Parameter SQLCODE = "PRES_Code";

Parameter SQLDESCRIPTION = "PRES_Desc";

Parameter SQLROWID = "PRES_RowId";

Property dummy As %String(TRUNCATE = 1);

//This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.

//This is typically used for filtering records to allow only active records to be used.

Parameter SQLFILTER = "((PRES_DateFrom <= CURRENT_DATE OR PRES_DateFrom IS NULL) AND (PRES_DateTo >= CURRENT_DATE OR PRES_DateTo IS NULL))";

//this method returns values that are in a valid date range

ClassMethod LookUpBrokerEpPresentation(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", epDate As %String = "") As %Library.Boolean
{
}

Query LookUpEpPresentation(val As %String = "", epDate As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
	SELECT PRES_Desc,  PRES_Code
	FROM SQLUser.PAC_Presentation
	WHERE ((%ALPHAUP PRES_Code %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP PRES_Desc %STARTSWITH %ALPHAUP :val))
	AND ((PRES_DateFrom IS NULL) OR (:epDate >= PRES_DateFrom)) AND 
 	((PRES_DateTo IS NULL) OR (:epDate <= PRES_DateTo))
 	Order by PRES_Desc
}

}
