Include webimport

Class web.PACDelivPlanManag Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "DELPM_Code";

Parameter SQLDESCRIPTION = "DELPM_Desc";

Parameter SQLROWID = "DELPM_RowId";

}
