Include webimport

IncludeGenerator webimport

Class web.CTEducation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 21;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EDU_Code";

Parameter SQLDESCRIPTION = "EDU_Desc";

Parameter SQLROWID = "EDU_RowId";

Property dummy As %String(TRUNCATE = 1);

}
