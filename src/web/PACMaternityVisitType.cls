Class web.PACMaternityVisitType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MATVT_Code";

Parameter SQLDESCRIPTION = "MATVT_Desc";

Parameter SQLROWID = "MATVT_RowId";

}
