Class web.PAAdmContractedCare Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

Parameter SQLDATEFROM = "CONTCARE_DateFrom";

Parameter SQLDATETO = "CONTCARE_DateTo";

Parameter SQLCODE = "CONTCARE_RowId";

Parameter SQLDESCRIPTION = "CONTCARE_RowId";

Parameter SQLROWID = "CONTCARE_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckMandatory(EpisodeID As %Library.String) As %Library.String
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod ValidateFields(compid As %String, id As %String) As %String
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String = "") As %String
{
}

}
