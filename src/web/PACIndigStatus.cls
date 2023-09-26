Include webimport

IncludeGenerator webimport

Class web.PACIndigStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 95;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "INDST_Code";

Parameter SQLDATEFROM = "INDST_DateFrom";

Parameter SQLDATETO = "INDST_DateTo";

Parameter SQLDESCRIPTION = "INDST_Desc";

Parameter SQLROWID = "INDST_RowId";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((INDST_DateFrom <= CURRENT_DATE OR INDST_DateFrom IS NULL) AND (INDST_DateTo >= CURRENT_DATE OR INDST_DateTo IS NULL))";

ClassMethod LookUpBrokerNC(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	 INDST_Desc,INDST_RowID,INDST_Code,INDST_NationalCode
FROM	 SQLUser.PAC_IndigStatus
WHERE	(INDST_Desc %STARTSWITH :desc
OR      INDST_Code=:desc)
AND ((INDST_DateFrom <= CURRENT_DATE OR INDST_DateFrom IS NULL) AND (INDST_DateTo >= CURRENT_DATE OR INDST_DateTo IS NULL))
}

}
