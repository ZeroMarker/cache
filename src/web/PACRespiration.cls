Include webimport

Class web.PACRespiration Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM = "RESP_DateFrom";

Parameter SQLDATETO = "RESP_DateTo";

Parameter SQLCODE = "RESP_Code";

Parameter SQLDESCRIPTION = "RESP_Desc";

Parameter SQLROWID = "RESP_RowId";

Property dummy As %String(TRUNCATE = 1);

//this method returns values that are in a valid date range

ClassMethod LookUpBrokerRespiration(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", epDate As %String = "") As %Library.Boolean
{
}

Query LookUpRespiration(val As %String = "", epDate As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
	SELECT RESP_Desc,  RESP_Code
	FROM SQLUser.PAC_Respiration
	WHERE ((%ALPHAUP RESP_Code %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP RESP_Desc %STARTSWITH %ALPHAUP :val))
	AND ((RESP_DateFrom IS NULL) OR (:epDate >= RESP_DateFrom)) AND 
 	((RESP_DateTo IS NULL) OR (:epDate <= RESP_DateTo))
 	Order by RESP_Desc
}

}
