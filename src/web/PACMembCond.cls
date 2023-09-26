Class web.PACMembCond Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "MEMBCOND_Code";

Parameter SQLDATEFROM = "MEMBCOND_DateFrom";

Parameter SQLDATETO = "MEMBCOND_DateTo";

Parameter SQLDESCRIPTION = "MEMBCOND_Desc";

Parameter SQLROWID = "MEMBCOND_RowId";

}
