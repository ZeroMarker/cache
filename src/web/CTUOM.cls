Include webimport

IncludeGenerator webimport

Class web.CTUOM Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 95;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CTUOM_Code";

Parameter SQLDESCRIPTION = "CTUOM_Desc";

Parameter SQLROWID = "CTUOM_RowId";

}
