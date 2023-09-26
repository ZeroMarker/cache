Class web.SSUserPassword Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 71;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod ChangedPassword(userid As %Library.String, password As %Library.String)
{
}

ClassMethod CheckSpecialFormat(password As %String = "") As %Boolean
{
}

/// Checks if the user has changed the password since first setting up the user.
/// When user is first created, one userpassword record is created.
/// Need to check if it has changed since then.
/// returns 1 if password has changed since creating
/// returns 0 if password has not changed since creating
ClassMethod HasChangedPassword(userid As %Library.String) As %Library.Boolean
{
}

/// Checks if the password is a current or previous password belonging to the particular user.
/// 
/// Returns 1 if password has been used for user
/// Returns 0 if no user, or no password, or no matching password for user
ClassMethod IsPreviousPassword(userid As %Library.String, password As %Library.String) As %Library.Boolean
{
}

Parameter SQLCODE = "PASS_RowId";

Parameter SQLDESCRIPTION = "PASS_RowId";

Parameter SQLROWID = "PASS_RowId";

}
