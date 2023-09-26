Include webimport

IncludeGenerator webimport

Class web.CTNation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CTNAT_Code";

Parameter SQLDESCRIPTION = "CTNAT_Desc";

Parameter SQLROWID = "CTNAT_RowId";

}
