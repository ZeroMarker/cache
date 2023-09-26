Class web.PACAccomodationType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

Parameter SQLDATEFROM = "ACCOMT_DateFrom";

Parameter SQLDATETO = "ACCOMT_DateTo";

Parameter SQLCODE = "ACCOMT_Code";

Parameter SQLDESCRIPTION = "ACCOMT_Desc";

Parameter SQLROWID = "ACCOMT_RowId";

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerWL(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpWaitingList(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT 	ACCOMT_Desc,ACCOMT_RowId,ACCOMT_Code
FROM 	SQLUser.PAC_AccomodationType
WHERE (((%UPPER ACCOMT_Desc %STARTSWITH %UPPER :desc)
 OR (%UPPER ACCOMT_Code %STARTSWITH %UPPER :desc)) 
 AND %UPPER ACCOMT_WL='Y')
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT ACCOMT_Desc,ACCOMT_RowId,ACCOMT_Code
FROM SQLUser.PAC_AccomodationType
WHERE ((%ALPHAUP ACCOMT_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP ACCOMT_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((ACCOMT_DateFrom <= :date OR ACCOMT_DateFrom IS NULL) AND  (ACCOMT_DateTo IS NULL OR ACCOMT_DateTo >= :date)))
ORDER   BY ACCOMT_Desc
}

}
