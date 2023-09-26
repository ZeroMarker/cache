Class web.PACComplaintPriority Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "COMPRI_Code";

Parameter SQLDESCRIPTION = "COMPRI_Desc";

Parameter SQLROWID = "COMPRI_RowId";

}
