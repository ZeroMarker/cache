Include webimport

IncludeGenerator webimport

Class web.RBCAppointMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "APTM_Code";

Parameter SQLDESCRIPTION = "APTM_Desc";

Parameter SQLROWID = "APTM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookupMethod(RBCAppointMethod As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "APTMDesc,APTMCode ")
{
SELECT APTM_Desc,APTM_Code 
FROM RBC_AppointMethod
WHERE (%ALPHAUP APTM_Desc = %ALPHAUP :RBCAppointMethod OR %ALPHAUP APTM_Desc %STARTSWITH %ALPHAUP :RBCAppointMethod) 
OR (%ALPHAUP APTM_Code = %ALPHAUP :RBCAppointMethod OR %ALPHAUP APTM_Code %STARTSWITH %ALPHAUP :RBCAppointMethod)
}

ClassMethod LookupMethod(itmjs As %Library.String = "", itmjsex As %Library.String = "", RBCAppointMethod As %Library.String = "") As %Library.Boolean
{
}

}
