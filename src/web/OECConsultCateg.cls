Class web.OECConsultCateg Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM = "CONS_DateFrom";

Parameter SQLDATETO = "CONS_DateTo";

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "CONS_Code";

Parameter SQLDESCRIPTION = "CONS_Desc";

Parameter SQLROWID = "CONS_RowId";

}
