Class web.MRFloorPlanNotes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 114;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetLatest(mradm As %Library.String) As %Library.String
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Parameter SQLCODE = "FLOOR_RowId";

Parameter SQLDESCRIPTION = "FLOOR_Text";

Parameter SQLROWID = "FLOOR_RowId";

}
