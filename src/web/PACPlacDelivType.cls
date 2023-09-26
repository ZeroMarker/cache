Class web.PACPlacDelivType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM = "PLDT_DateFrom";

Parameter SQLDATETO = "PLDT_DateTo";

Parameter SQLCODE = "PLDT_Code";

Parameter SQLDESCRIPTION = "PLDT_Desc";

Parameter SQLROWID = "PLDT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

//this method returns values that are in a valid date range

ClassMethod LookUpBrokerPlacDelivType(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", epDate As %String = "") As %Library.Boolean
{
}

Query LookUpPlacDelivType(val As %String = "", epDate As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
	SELECT PLDT_Desc,  PLDT_Code
	FROM SQLUser.PAC_PlacDelivType
	WHERE ((%ALPHAUP PLDT_Code %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP PLDT_Desc %STARTSWITH %ALPHAUP :val))
	AND ((PLDT_DateFrom IS NULL) OR (:epDate >= PLDT_DateFrom)) AND 
 	((PLDT_DateTo IS NULL) OR (:epDate <= PLDT_DateTo))
 	Order by PLDT_Desc
}

}
