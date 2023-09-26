Class web.OEOrdAlertMessage Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 14;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ALM_RowId";

Parameter SQLDESCRIPTION = "ALM_RowId";

Parameter SQLROWID = "ALM_RowId";

ClassMethod AlertMessageUpdate(OrdItem As %String = "", Message As %String = "", AlertType As %String = "", Reason As %String = "") As %Library.String
{
}

}
