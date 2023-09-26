Class web.ARChargesOverride Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 312;

Parameter SQLCODE = "COV_RowId";

Parameter SQLDATEFROM = "COV_DateFrom";

Parameter SQLDESCRIPTION = "COV_RowId";

Parameter SQLDATETO = "COV_DateTo";

Parameter SQLROWID = "COV_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod isBillFrozen(OEOrderItemID As %Library.String) As %String
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysSave(compref As %Library.String, id As %Library.String)
{
}

ClassMethod CreateOverride(IsAccomOrder As %String, OEOrderItemID As %String, OverrideRowID As %String)
{
}

ClassMethod SaveARChargesOverride(OverrideRowID As %String, OEOrderItemID As %String, DateFrom As %String, DateTo As %String)
{
}

ClassMethod RecalculateBill(PatientID As %String, EpisodeID As %String, SundryID As %String, OEOrderItemID As %String)
{
}

ClassMethod BeforeDeleteVerify(compref As %String, ByRef id As %String) As %Boolean
{
}

}
