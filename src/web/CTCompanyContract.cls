Class web.CTCompanyContract Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Property dummy;

Parameter SQLCODE = "CONT_Code";

Parameter SQLDATEFROM = "CONT_StartDate";

Parameter SQLDATETO = "CONT_EndDate";

Parameter SQLDESCRIPTION = "CONT_RowId";

Parameter SQLROWID = "CONT_RowId";

ClassMethod GetIdFromCodeAndCompany(code As %String = "", comp As %String = "") As %String
{
}

Query LookUpCompany(desc As %String, comp As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Code:%String,HIDDEN:%String")
{
SELECT CONT_Code,CONT_RowId
FROM SQLUser.CT_CompanyContract
WHERE ((%ALPHAUP CONT_Code %STARTSWITH %ALPHAUP :desc))
AND ((%ALPHAUP CONT_ParRef->CTCO_Desc = %ALPHAUP :comp) OR (:comp IS NULL))
ORDER   BY CONT_Code
}

ClassMethod LookUpCompanyBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", comp As %String = "") As %Boolean
{
}

}
