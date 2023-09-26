Class web.PACEpisiotomyType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 97;

Parameter SQLDATEFROM = "EPIT_DateFrom";

Parameter SQLDATETO = "EPIT_DateTo";

Parameter SQLCODE = "EPIT_Code";

Parameter SQLDESCRIPTION = "EPIT_Desc";

Parameter SQLROWID = "EPIT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

//This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.

//This is typically used for filtering records to allow only active records to be used.

Parameter SQLFILTER = "((EPIT_DateFrom <= CURRENT_DATE OR EPIT_DateFrom IS NULL) AND (EPIT_DateTo >= CURRENT_DATE OR EPIT_DateTo IS NULL))";

//this method returns values that are in a valid date range

ClassMethod LookUpBrokerEpEpisiotomyType(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", epDate As %String = "") As %Library.Boolean
{
}

Query LookUpEpEpisiotomyType(val As %String = "", epDate As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
	SELECT EPIT_Desc,  EPIT_Code
	FROM SQLUser.PAC_EpisiotomyType
	WHERE ((%ALPHAUP EPIT_Code %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP EPIT_Desc %STARTSWITH %ALPHAUP :val))
	AND ((EPIT_DateFrom IS NULL) OR (:epDate >= EPIT_DateFrom)) AND 
 	((EPIT_DateTo IS NULL) OR (:epDate <= EPIT_DateTo))
 	Order by EPIT_Desc
}

}
