Class web.GLCCC Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "GLCCC_Code";

Parameter SQLDESCRIPTION = "GLCCC_Desc";

Parameter SQLROWID = "GLCCC_RowId";

Query LookUpCC(val) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "CCDesc,HIDDEN,CCCode")
{
SELECT GLCCC_Desc, GLCCC_RowId, GLCCC_Code
FROM SQLUSER.GLC_CC
WHERE (%ALPHAUP GLCCC_Desc %STARTSWITH %ALPHAUP :val) 
ORDER BY GLCCC_Desc
}

}
