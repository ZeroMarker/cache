Class web.PACAdmLabourStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ADMLS_Code";

Parameter SQLDESCRIPTION = "ADMLS_Desc";

Parameter SQLROWID = "ADMLS_RowId";

}
