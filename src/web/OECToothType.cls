Class web.OECToothType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TOOTHT_Code";

Parameter SQLDESCRIPTION = "TOOTHT_Desc";

Parameter SQLROWID = "TOOTHT_RowId";

Property dummy As %String(TRUNCATE = 1);

}
