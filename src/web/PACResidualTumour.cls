Class web.PACResidualTumour Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "RESTUM_Code";

Parameter SQLDESCRIPTION = "RESTUM_Desc";

Parameter SQLROWID = "RESTUM_RowId";

}
