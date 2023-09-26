Class web.OECToothNumber Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 79;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TOOTHN_Code";

Parameter SQLDESCRIPTION = "TOOTHN_Desc";

Parameter SQLROWID = "TOOTHN_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query ToothNumberFind(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "TOOTHNDesc:%String")
{
SELECT TOOTHN_Desc
FROM SQLUser.OEC_ToothNumber
WHERE   TOOTHN_Desc %STARTSWITH :desc
ORDER BY TOOTHN_Desc
}

Query FindToothIdFromCode(code As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String")
{
SELECT TOOTHN_RowId
FROM SQLUser.OEC_ToothNumber
WHERE   TOOTHN_Code = :code
}

ClassMethod GetIdFromCode(code As %String) As %Library.String
{
}

}
