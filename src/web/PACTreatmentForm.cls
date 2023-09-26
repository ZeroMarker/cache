Class web.PACTreatmentForm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 14;

Parameter SQLCODE = "TF_Code";

Parameter SQLDATEFROM = "TF_DateFrom";

Parameter SQLDATETO = "TF_DateTo";

Parameter SQLDESCRIPTION = "TF_Desc";

Parameter SQLROWID = "TF_RowId";

Property dummy As %String(TRUNCATE = 1);

}
