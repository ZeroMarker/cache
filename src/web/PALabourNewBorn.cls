Class web.PALabourNewBorn Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 90;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod GetPALabNB(EpisodeID As %Library.String) As %Library.String
{
}

Parameter SQLCODE = "LNB_RowID";

Parameter SQLDESCRIPTION = "LNB_RowID";

Parameter SQLROWID = "LNB_RowID";

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

}
