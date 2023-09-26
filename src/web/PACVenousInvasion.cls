Class web.PACVenousInvasion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "VENI_Code";

Parameter SQLDESCRIPTION = "VENI_Desc";

Parameter SQLROWID = "VENI_RowId";

}
