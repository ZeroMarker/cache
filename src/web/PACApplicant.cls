Class web.PACApplicant Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 14;

Parameter SQLCODE = "APPL_Code";

Parameter SQLDATEFROM = "APPL_DateFrom";

Parameter SQLDATETO = "APPL_DateTo";

Parameter SQLDESCRIPTION = "APPL_Desc";

Parameter SQLROWID = "APPL_RowId";

Property dummy As %String(TRUNCATE = 1);

}
