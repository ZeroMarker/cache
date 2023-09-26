Class web.PACWardAdm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 64;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WADM_RowId";

Parameter SQLDESCRIPTION = "WADM_RowId";

Parameter SQLROWID = "WADM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetStatistics(WardID As %Library.String, PARAMS As %Library.String, ByRef STATS As %Library.String, ByRef DISDATE As %Library.String, ByRef DISDATECON As %Library.String, ByRef DISDATEUNC As %Library.String, ByRef BOOK As %Library.String)
{
}

}
