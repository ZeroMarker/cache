Class web.PACLymphInvasion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "LYMI_Code";

Parameter SQLDESCRIPTION = "LYMI_Desc";

Parameter SQLROWID = "LYMI_RowId";

}
