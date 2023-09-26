Class web.PACFdiuDiagnosis Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "FDIUDIAG_Code";

Parameter SQLDATEFROM = "FDIUDIAG_DateFrom";

Parameter SQLDATETO = "FDIUDIAG_DateTo";

Parameter SQLDESCRIPTION = "FDIUDIAG_Desc";

Parameter SQLROWID = "FDIUDIAG_RowId";

}
