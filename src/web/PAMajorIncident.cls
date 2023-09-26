Class web.PAMajorIncident Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 194;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MI_RowId";

Parameter SQLDESCRIPTION = "MI_RowId";

Parameter SQLROWID = "MI_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CancelMajorIncidentAdm(desc As %Library.String, exp As %Library.String, id As %Library.String, oldEst As %Library.String, compref As %Library.String)
{
}

ClassMethod CreateMajorIncidentAdm(loc As %Library.String, desc As %Library.String, exp As %Library.String, sDate As %Library.String, sTime As %Library.String, id As %Library.String, oldEst As %Library.String, compref As %Library.String)
{
}

ClassMethod UpdateMajorIncidentAdm(id As %Library.String, exp As %Library.String, compref As %Library.String)
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String, compref As %Library.String = "")
{
}

ClassMethod websysSave(compref As %String, id As %String)
{
}

}
