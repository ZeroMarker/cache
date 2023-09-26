Class web.PACAutopsyType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 56;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "AUTOP_Code";

Parameter SQLDESCRIPTION = "AUTOP_Desc";

Parameter SQLROWID = "AUTOP_RowID";

}
