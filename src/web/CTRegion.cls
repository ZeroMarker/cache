Include webimport

IncludeGenerator webimport

Class web.CTRegion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CTRG_Code";

Parameter SQLDESCRIPTION = "CTRG_Desc";

Parameter SQLROWID = "CTRG_RowId";

}
