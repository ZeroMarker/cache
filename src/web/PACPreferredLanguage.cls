Include webimport

IncludeGenerator webimport

Class web.PACPreferredLanguage Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 99;

Parameter SQLDATEFROM = "PREFL_DateFrom";

Parameter SQLDATETO = "PREFL_DateTo";

Parameter SQLCODE = "PREFL_Code";

Parameter SQLDESCRIPTION = "PREFL_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((PREFL_DateFrom <= CURRENT_DATE OR PREFL_DateFrom IS NULL) AND (PREFL_DateTo >= CURRENT_DATE OR PREFL_DateTo IS NULL))";

Parameter SQLROWID = "PREFL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerNC(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	PREFL_Desc,PREFL_RowID,PREFL_Code,PREFL_VEMDCode
FROM	 SQLUser.PAC_PreferredLanguage
WHERE	(PREFL_Desc %STARTSWITH :desc
OR      PREFL_Code=:desc)
AND ((PREFL_DateFrom <= CURRENT_DATE OR PREFL_DateFrom IS NULL) AND (PREFL_DateTo >= CURRENT_DATE OR PREFL_DateTo IS NULL))
}

}
