Class web.RBEventCPFacilitator Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 57;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CPF_RowId";

Parameter SQLDESCRIPTION = "CPF_RowId";

Parameter SQLROWID = "CPF_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String, parref As %Library.String)
{
}

ClassMethod websysSave(compref As %String, id As %Library.String = "", parref As %String = "", rsvp As %Library.String = "", arrived As %Library.String = "", restrict As %Library.String = "")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpCPF(desc As %String, parref) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CPF_CareProv_DR->CTPCP_Desc,CPF_RowId,CPF_CareProv_DR->CTPCP_Code
FROM SQLUser.RB_EventCPFacilitator
WHERE CPF_CareProv_DR->CTPCP_Desc %STARTSWITH :desc
AND CPF_ParRef=:parref
}

}
