Class web.RBEventDocuments Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindIfLinksDataRBEventEdit(EventID As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "SD_RowId";

Parameter SQLDESCRIPTION = "SD_RowId";

Parameter SQLROWID = "SD_RowId";

Query ListDocuments(PARREF As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId:%Library.String,File:%Library.String")
{
SELECT SD_RowId,SD_File
FROM SQLUser.RB_EventDocuments
WHERE SD_ParRef=:PARREF
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
