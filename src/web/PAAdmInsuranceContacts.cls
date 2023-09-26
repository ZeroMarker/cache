Class web.PAAdmInsuranceContacts Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 104;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CONTACT_RowId";

Parameter SQLDESCRIPTION = "CONTACT_RowId";

Parameter SQLROWID = "CONTACT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// 1/10/02 Log#28049 HP: Called from web.PAAdmInsurance: GetByEpisodeIDFetch
ClassMethod GetContactType(InsurRowID As %Library.String) As %Library.String
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

}
