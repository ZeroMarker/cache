Class web.PACDelDecisionMaker Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "DSMKR_Code";

Parameter SQLDESCRIPTION = "DSMKR_Desc";

Parameter SQLROWID = "DSMKR_RowId";

}
