Class web.PAAdmViewableBy Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 71;

Parameter SQLDATEFROM = "VIEW_DateFrom";

Parameter SQLDATETO = "VIEW_DateTo";

Parameter SQLCODE = "VIEW_RowId";

Parameter SQLDESCRIPTION = "VIEW_RowId";

Parameter SQLROWID = "VIEW_RowId";

/// gets logon details for filtering of PAAdm queries
ClassMethod GetLogonDetails(ByRef logonloc As %Library.String = "", ByRef logoncp As %Library.String = "", ByRef secgrpid As %Library.String = "", ByRef cpset As %Library.String = "")
{
}

/// returns whether episode has any viewing restrictions
/// ie. by episode care prov
ClassMethod IsRestricted(EpisodeID As %Library.String = "") As %Library.Boolean
{
}

/// ab 3.09.02
/// returns whether an episode is viewable for a care prov OR loc OR care prov type
/// (episode settings)
ClassMethod IsViewable(EpisodeID As %Library.String = "", CareProv As %Library.String = "", Loc As %Library.String = "") As %Library.Boolean
{
}

/// checks if care provider is viewable by the security group
/// used with getlogondetails
/// (security group settings)
ClassMethod IsViewableGroupCPT(cpid As %Library.String = "", cpset As %Library.String = "") As %Library.Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

}
