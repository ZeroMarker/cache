Class web.PACStage Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "STG_Code";

Parameter SQLDESCRIPTION = "STG_Desc";

Parameter SQLROWID = "STG_RowId";

}
