Class web.OECNeedleType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter SQLCODE = "NEDT_Code";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "NEDT_Desc";

Parameter SQLROWID = "NEDT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpNeedleType(desc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "NEDTDesc:%String")
{
SELECT NEDT_Desc
FROM SQLUser.OEC_NeedleType
WHERE NEDT_Desc %STARTSWITH  :desc
ORDER BY NEDT_Desc
}

}
