Include webimport

Class web.PACDeliveryMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 84;

Parameter SQLDATEFROM = "DLMTH_DateFrom";

Parameter SQLDATETO = "DLMTH_DateTo";

Parameter SQLCODE = "DLMTH_Code";

Parameter SQLDESCRIPTION = "DLMTH_Desc";

Parameter SQLROWID = "DLMTH_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

//this method returns values that are in a valid date range

ClassMethod LookUpBrokerDeliveryMethod(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", epDate As %String = "") As %Library.Boolean
{
}

//Query LookUpDeliveryMethod(val As %String = "", epDate As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")

Query LookUpDeliveryMethod(val As %String = "", epDate As %String = "") As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
	SELECT DLMTH_Desc, DLMTH_RowId, DLMTH_Code
	FROM SQLUser.PAC_DeliveryMethod
	WHERE ((%ALPHAUP DLMTH_Code %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP DLMTH_Desc %STARTSWITH %ALPHAUP :val))
	AND ((DLMTH_DateFrom IS NULL) OR (:epDate >= DLMTH_DateFrom)) AND 
 	((DLMTH_DateTo IS NULL) OR (:epDate <= DLMTH_DateTo))
 	Order by DLMTH_Desc
}

}
