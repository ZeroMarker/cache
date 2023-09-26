Class web.PACAdmMaternityReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ADMMR_Code";

Parameter SQLDESCRIPTION = "ADMMR_Desc";

Parameter SQLROWID = "ADMMR_RowId";

}
