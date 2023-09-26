Class web.PACStageClassification Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "STCL_Code";

Parameter SQLDESCRIPTION = "STCL_Desc";

Parameter SQLROWID = "STCL_RowId";

}
