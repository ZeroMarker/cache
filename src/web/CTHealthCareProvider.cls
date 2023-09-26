Include webimport

IncludeGenerator webimport

Class web.CTHealthCareProvider Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 84;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "HCP_Code";

Parameter SQLDESCRIPTION = "HCP_Desc";

Parameter SQLROWID = "HCP_RowId";

}
