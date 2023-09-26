Class web.PACLetterType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "LET_Code";

Parameter SQLDESCRIPTION = "LET_Desc";

Parameter SQLROWID = "LET_RowId";

Query LetterLookUp(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT LET_Desc,LET_Code,LET_RowId
FROM SQLUser.PAC_LetterType
WHERE %UPPER LET_Desc %STARTSWITH %UPPER :desc
}

}
