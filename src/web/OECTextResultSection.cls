Include webimport

IncludeGenerator webimport

Class web.OECTextResultSection Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 81;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SEC_RowId";

Parameter SQLDESCRIPTION = "SEC_Desc";

Parameter SQLROWID = "SEC_RowId";

}
