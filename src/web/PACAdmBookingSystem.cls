Class web.PACAdmBookingSystem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 63;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ADMBS_Code";

Parameter SQLDESCRIPTION = "ADMBS_Desc";

Parameter SQLROWID = "ADMBS_RowId";

}
