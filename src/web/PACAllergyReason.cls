Class web.PACAllergyReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ALRGREA_Code";

Parameter SQLDESCRIPTION = "ALRGREA_Desc";

Parameter SQLROWID = "ALRGREA_RowId";

}
