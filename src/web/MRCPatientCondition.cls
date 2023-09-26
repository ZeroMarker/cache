Class web.MRCPatientCondition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM = "COND_DateFrom";

Parameter SQLDATETO = "COND_DateTo";

Parameter SQLCODE = "COND_Code";

Parameter SQLDESCRIPTION = "COND_Desc";

Parameter SQLROWID = "COND_RowId";

/// Log 41965 - AI - 07-07-2004 : get the name of the image from the id (stored on ARY("MRADMPatCondID"))
ClassMethod GetImage(ID As %Library.String, PARAMS As %Library.String, ByRef imgLIST As %Library.String)
{
}

}
