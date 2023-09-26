Class web.PAComplaintClinician Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

Parameter SQLCODE = "DOC_RowId";

Parameter SQLDESCRIPTION = "DOC_RowId";

Parameter SQLROWID = "DOC_RowId";

Query ListClinician(PARREF As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%Library.String,Clinician:%Library.String")
{
SELECT DOC_RowId,DOC_CareProv_DR->CTPCP_Desc
FROM SQLUSER.PA_ComplaintClinician
WHERE DOC_PARREF=:PARREF
}

}
