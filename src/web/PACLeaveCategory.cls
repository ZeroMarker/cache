Class web.PACLeaveCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 45;

Parameter SQLDATEFROM = "LEACAT_DateFrom";

Parameter SQLDATETO = "LEACAT_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "LEACAT_Code";

Parameter SQLDESCRIPTION = "LEACAT_Desc";

Parameter SQLROWID = "LEACAT_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT LEACAT_Desc,LEACAT_RowID,LEACAT_Code
FROM SQLUser.PAC_LeaveCategory
WHERE ((%ALPHAUP LEACAT_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP LEACAT_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((LEACAT_DateFrom <= :date OR LEACAT_DateFrom IS NULL) AND  (LEACAT_DateTo IS NULL OR LEACAT_DateTo >= :date)))
ORDER   BY LEACAT_Desc
}

}
