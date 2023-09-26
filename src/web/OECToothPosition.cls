Class web.OECToothPosition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TOOTHP_Code";

Parameter SQLDESCRIPTION = "TOOTHP_Desc";

Parameter SQLROWID = "TOOTHP_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query ToothPositionFind(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "TOOTHPDesc:%String")
{
SELECT TOOTHP_Desc
FROM SQLUser.OEC_ToothPosition
WHERE   TOOTHP_Desc %STARTSWITH :desc
ORDER BY TOOTHP_Desc
}

Query FindToothIdFromCode(code As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String")
{
SELECT TOOTHP_RowId
FROM SQLUser.OEC_ToothPosition
WHERE   TOOTHP_Code = :code
}

ClassMethod GetIdFromCode(code As %String) As %Library.String
{
}

}
