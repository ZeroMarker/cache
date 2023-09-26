Include webimport

Class web.PACOutcomeOfPregnancy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "OPREG_Code";

Parameter SQLDESCRIPTION = "OPREG_Desc";

Parameter SQLROWID = "OPREG_RowId";

}
