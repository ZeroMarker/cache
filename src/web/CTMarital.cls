Include webimport

IncludeGenerator webimport

Class web.CTMarital Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 99;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CTMAR_Code";

Parameter SQLDATEFROM = "CTMAR_DateFrom";

Parameter SQLDATETO = "CTMAR_DateTo";

Parameter SQLDESCRIPTION = "CTMAR_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTMAR_DateFrom <= CURRENT_DATE OR CTMAR_DateFrom IS NULL) AND (CTMAR_DateTo >= CURRENT_DATE OR CTMAR_DateTo IS NULL))";

Parameter SQLROWID = "CTMAR_RowId";

ClassMethod LookUpBrokerNC(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	CTMAR_Desc,CTMAR_RowID,CTMAR_Code,CTMAR_PRS2
FROM	 SQLUser.CT_Marital
WHERE	(CTMAR_Desc %STARTSWITH :desc
OR      CTMAR_Code=:desc)
AND ((CTMAR_DateFrom <= CURRENT_DATE OR CTMAR_DateFrom IS NULL) AND (CTMAR_DateTo >= CURRENT_DATE OR CTMAR_DateTo IS NULL))
}

}
