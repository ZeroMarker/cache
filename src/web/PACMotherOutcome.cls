Class web.PACMotherOutcome Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MTHROC_Code";

Parameter SQLDESCRIPTION = "MTHROC_Desc";

Parameter SQLROWID = "MTHROC_RowId";

}
