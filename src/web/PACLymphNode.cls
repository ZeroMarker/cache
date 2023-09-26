Class web.PACLymphNode Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "LYMN_Code";

Parameter SQLDESCRIPTION = "LYMN_Desc";

Parameter SQLROWID = "LYMN_RowId";

}
