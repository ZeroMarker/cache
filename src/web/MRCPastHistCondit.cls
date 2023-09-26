Include webimport

IncludeGenerator webimport

Class web.MRCPastHistCondit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "PAST_Code";

Parameter SQLDESCRIPTION = "PAST_Desc";

Parameter SQLROWID = "PAST_RowId";

}
