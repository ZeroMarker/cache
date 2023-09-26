Include webimport

Class web.PACPregnancyType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 82;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PREGN_Code";

Parameter SQLDESCRIPTION = "PREGN_Desc";

Parameter SQLROWID = "PREGN_RowId";

Query LookUpDesc(desc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String")
{
SELECT PREGN_Desc
FROM PAC_PregnancyType
WHERE (PREGN_Desc %STARTSWITH :desc)
ORDER BY PREGN_Desc
}

}
