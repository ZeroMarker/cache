Include webimport

IncludeGenerator webimport

Class web.PACReportingType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 19;

Parameter SQLDATEFROM = "REPTYPE_DateFrom";

Parameter SQLDATETO = "REPTYPE_DateTo";

Parameter SQLCODE = "REPTYPE_Code";

Parameter SQLDESCRIPTION = "REPTYPE_Desc";

Parameter SQLROWID = "REPTYPE_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}
