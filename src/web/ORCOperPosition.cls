Class web.ORCOperPosition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OPPOS_Code";

Parameter SQLDESCRIPTION = "OPPOS_Desc";

Parameter SQLROWID = "OPPOS_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerPosition(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "") As %Library.Boolean
{
}

Query LookUpPosition(desc) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OPPOSDesc,OPPOSCode")
{
SELECT OPPOS_Desc,OPPOS_Code 
FROM SQLUser.ORC_OperPosition
WHERE (%ALPHAUP OPPOS_Desc = %ALPHAUP :desc OR %ALPHAUP OPPOS_Desc %STARTSWITH %ALPHAUP :desc) 
OR (%ALPHAUP OPPOS_Code = %ALPHAUP :desc)
ORDER BY OPPOS_Desc
}

}
