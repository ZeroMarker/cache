Class web.OEOrdCollectionResult Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 15;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DEL_RowId";

Parameter SQLDESCRIPTION = "DEL_RowId";

Parameter SQLROWID = "DEL_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod IsDeliveredResult(OrdItemId As %String) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

}
