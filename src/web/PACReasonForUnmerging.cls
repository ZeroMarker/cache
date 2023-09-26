Class web.PACReasonForUnmerging Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "REAUNM_Code";

Parameter SQLDATEFROM = "REAUNM_DateFrom";

Parameter SQLDATETO = "REAUNM_DateTo";

Parameter SQLDESCRIPTION = "REAUNM_Desc";

Parameter SQLROWID = "REAUNM_RowId";

}
