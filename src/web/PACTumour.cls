Class web.PACTumour Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 63;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "TUM_Code";

Parameter SQLDESCRIPTION = "TUM_Desc";

Parameter SQLROWID = "TUM_RowId";

}
