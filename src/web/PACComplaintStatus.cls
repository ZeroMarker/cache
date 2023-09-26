Class web.PACComplaintStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 31;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "CMS_Code";

Parameter SQLDESCRIPTION = "CMS_Desc";

Parameter SQLROWID = "CMS_RowId";

}
