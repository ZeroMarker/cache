Class web.PACTrust Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 63;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "TRUST_Code";

Parameter SQLDATEFROM = "TRUST_DateFrom";

Parameter SQLDATETO = "TRUST_DateTo";

Parameter SQLDESCRIPTION = "TRUST_Desc";

Parameter SQLROWID = "TRUST_RowId";

Query LookUpCode(Code As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Code,Descrittion")
{
SELECT TRUST_Code, TRUST_Desc
FROM SQLUser.PAC_Trust
WHERE (%ALPHAUP TRUST_Code [%ALPHAUP :Code)
ORDER BY TRUST_Desc
}

Query LookUpPartialDescription(desc As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT TRUST_Desc, TRUST_RowId, TRUST_Code
FROM SQLUser.PAC_Trust
WHERE (%ALPHAUP TRUST_Desc [%ALPHAUP :desc)
ORDER BY TRUST_Desc
}

}
