Include webimport

Class web.PACContraceptiveMethods Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5;

Parameter SQLCODE = "CONMET_Code";

Parameter SQLDATEFROM = "CONMET_DateFrom";

Parameter SQLDATETO = "CONMET_DateTo";

Parameter SQLDESCRIPTION = "CONMET_Desc";

Parameter SQLROWID = "CONMET_RowId";

Property dummy As %String(TRUNCATE = 1);

}
