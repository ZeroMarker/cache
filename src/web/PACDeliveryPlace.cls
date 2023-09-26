Include webimport

Class web.PACDeliveryPlace Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 64;

Parameter SQLCODE = "DELPL_Code";

Parameter SQLDATEFROM = "DELPL_DateFrom";

Parameter SQLDATETO = "DELPL_DateTo";

Parameter SQLDESCRIPTION = "DELPL_Desc";

Parameter SQLROWID = "DELPL_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

Query LookUpActive(val As %Library.String = "", aDate As %String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "DELPLDesc:%String,Hidden:%String,DELPLCode:%String")
{
SELECT DELPL_Desc,DELPL_RowId,DELPL_Code
FROM SQLUser.PAC_DeliveryPlace
WHERE ((%ALPHAUP DELPL_Code %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP DELPL_Desc %STARTSWITH %ALPHAUP :val))
AND ((DELPL_DateFrom IS NULL) OR (:aDate >= DELPL_DateFrom)) AND 
((DELPL_DateTo IS NULL) OR (:aDate <= DELPL_DateTo))
Order by DELPL_Desc
}

ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", aDate As %String = "") As %Library.Boolean
{
}

}
