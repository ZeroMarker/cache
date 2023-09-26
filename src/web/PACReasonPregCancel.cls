Class web.PACReasonPregCancel Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PREGCNCL_Code";

Parameter SQLDATEFROM = "PREGCNCL_DateFrom";

Parameter SQLDATETO = "PREGCNCL_DateTo";

Parameter SQLDESCRIPTION = "PREGCNCL_Desc";

Parameter SQLROWID = "PREGCNCL_RowId";

}
