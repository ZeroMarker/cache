Class web.PACLacerationLoc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "LOCLAC_Code";

Parameter SQLDESCRIPTION = "LOCLAC_Desc";

Parameter SQLROWID = "LOCLAC_RowId";

}
