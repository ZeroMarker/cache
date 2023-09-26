Class web.ORCOperMonitorDev Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 22;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OPMON_Code";

Parameter SQLDESCRIPTION = "OPMON_Desc";

Parameter SQLROWID = "OPMON_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerMonDev(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "") As %Library.Boolean
{
}

Query LookUpMonDev(desc) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OPMONDesc,HIDDEN,OPMONCode")
{
SELECT OPMON_Desc,OPMON_RowId,OPMON_Code 
FROM SQLUser.ORC_OperMonitorDev
WHERE (%ALPHAUP OPMON_Desc = %ALPHAUP :desc OR %ALPHAUP OPMON_Desc %STARTSWITH %ALPHAUP :desc) 
OR (%ALPHAUP OPMON_Code = %ALPHAUP :desc)
ORDER BY OPMON_Desc
}

}
