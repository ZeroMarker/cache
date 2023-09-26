Class web.MRCBodySystemProblem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PRO_Code";

Parameter SQLDESCRIPTION = "PRO_Desc";

Parameter SQLROWID = "PRO_RowId";

Query LookUpByBodSys(desc As %Library.String, bodsys As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%Library.String,Code:%Library.String")
{
SELECT PRO_Desc,PRO_Code
FROM SQLUSER.MRC_BodySystemProblem
WHERE (PRO_Desc %STARTSWITH :desc) AND (PRO_ParRef->BODS_Desc = :bodsys)
}

}
