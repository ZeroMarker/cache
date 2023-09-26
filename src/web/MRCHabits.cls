Include webimport

IncludeGenerator webimport

Class web.MRCHabits Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "HAB_Code";

Parameter SQLDESCRIPTION = "HAB_Desc";

Parameter SQLROWID = "HAB_RowId";

}
