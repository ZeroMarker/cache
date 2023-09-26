Class web.RBEventCPAttender Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 64;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CPAT_RowId";

Parameter SQLDESCRIPTION = "CPAT_RowId";

Parameter SQLROWID = "CPAT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String = "", parref As %Library.String = "")
{
}

ClassMethod websysSave(compref As %String, id As %Library.String = "", parref As %String = "", rsvp As %Library.String = "", arrived As %Library.String = "", restrict As %Library.String = "")
{
}

}
