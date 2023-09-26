Class web.MRCClinPathOutcome Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "CLPO_Code";

Parameter SQLDESCRIPTION = "CLPO_Desc";

Parameter SQLROWID = "CLPO_RowId";

}
