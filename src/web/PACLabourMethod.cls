Class web.PACLabourMethod Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

Parameter SQLCODE = "LBMTH_Code";

Parameter SQLDATEFROM = "LBMTH_DateFrom";

Parameter SQLDESCRIPTION = "LBMTH_Desc";

Parameter SQLDATETO = "LBMTH_DateTo";

Parameter SQLROWID = "LBMTH_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpGetType(val As %Library.String = "", epDate As %String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "LBMTHDesc:%String,Hidden:%String,LBMTHCode:%String,LBMTHType:%String")
{
SELECT LBMTH_Desc,LBMTH_RowId,LBMTH_Code,LBMTH_Type
FROM SQLUser.PAC_LabourMethod
WHERE ((%ALPHAUP LBMTH_Code %STARTSWITH %ALPHAUP :val) OR (%ALPHAUP LBMTH_Desc %STARTSWITH %ALPHAUP :val))
AND ((LBMTH_DateFrom IS NULL) OR (:epDate >= LBMTH_DateFrom)) AND 
((LBMTH_DateTo IS NULL) OR (:epDate <= LBMTH_DateTo))
Order by LBMTH_Desc
}

ClassMethod LookUpGetTypeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", epDate As %String = "") As %Library.Boolean
{
}

}
