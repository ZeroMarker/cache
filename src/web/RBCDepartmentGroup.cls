Include webimport

IncludeGenerator webimport

Class web.RBCDepartmentGroup Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "DEP_Code";

Parameter SQLDATEFROM = "DEP_DateFrom";

Parameter SQLDATETO = "DEP_DateTo";

Parameter SQLDESCRIPTION = "DEP_Desc";

Parameter SQLROWID = "DEP_RowId";

}
