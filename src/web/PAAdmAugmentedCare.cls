Class web.PAAdmAugmentedCare Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 126;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// HP: Validate ACP dates within Episode dates
/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String, EpisodeID As %Library.String, ACPStartDate As %Library.String, ACPEndDate As %Library.String) As %Boolean
{
}

/// HP 6/5/02 Log# 23926
ClassMethod websysSave(compref As %Library.String, id As %Library.String)
{
}

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "AUG_RowId";

Parameter SQLDESCRIPTION = "AUG_RowId";

Parameter SQLROWID = "AUG_RowId";

}
