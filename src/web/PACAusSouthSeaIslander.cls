Class web.PACAusSouthSeaIslander Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Parameter SQLDATEFROM = "ASSIS_DateFrom";

Parameter SQLDATETO = "ASSIS_DateTo";

Parameter SQLCODE = "ASSIS_Code";

Parameter SQLDESCRIPTION = "ASSIS_Desc";

Parameter SQLROWID = "ASSIS_RowId";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// / This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((ASSIS_DateFrom <= CURRENT_DATE OR ASSIS_DateFrom IS NULL) AND (ASSIS_DateTo >= CURRENT_DATE OR ASSIS_DateTo IS NULL))";

ClassMethod LookUpBrokerNC(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	ASSIS_Desc,ASSIS_RowID,ASSIS_Code,ASSIS_NationalCode
FROM	 SQLUser.PAC_AusSouthSeaIslander
WHERE	(ASSIS_Desc %STARTSWITH :desc
OR      ASSIS_Code=:desc)
AND ((ASSIS_DateFrom <= CURRENT_DATE OR ASSIS_DateFrom IS NULL) AND (ASSIS_DateTo >= CURRENT_DATE OR ASSIS_DateTo IS NULL))
}

}
