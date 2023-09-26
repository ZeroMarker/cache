Class web.OECSpeedFlowRate Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLCODE = "SFR_Code";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "SFR_Desc";

Parameter SQLROWID = "SFR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpSpeedFlowRateBroker(itmjs As %String = "", itmjsex As %String = "", desc As %String = "") As %Boolean
{
}

ClassMethod GetIDFromDesc(desc As %Library.String) As %Library.String
{
}

Query LookUpSpeedFlowRate(desc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "SFRDesc:%String,SFRCode:%String")
{
SELECT SFR_Desc,SFR_Code
FROM SQLUser.OEC_SpeedFlowRate
WHERE ((%ALPHAUP SFR_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP SFR_Code= %ALPHAUP :desc) OR (:desc IS NULL))
ORDER BY SFR_Desc
}

}
