Class web.PAAdmInsuranceBGLimits Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 299;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "LIM_RowId";

Parameter SQLDESCRIPTION = "LIM_RowId";

Parameter SQLROWID = "LIM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod GetAuthorisationLimit(EpisodeID As %Library.String = "", StartDate As %Library.String = "", OrderItemID As %Library.String = "") As %Integer
{
}

ClassMethod GetMaxCoverageAllowed(EpisodeID As %Library.String = "", StartDate As %Library.String = "", OrderItemID As %Library.String = "") As %Float
{
}

ClassMethod GetQuantityUsed(id As %Library.String = "") As %Integer
{
}

/// Log 66004 - 08.01.2008 - we need to count all items except discontinued ones or ones will OEORI_Billed flag is Ignore
ClassMethod GetAllQtyUsed(EpisodeID As %String, ARCItmMastID As %String = "", StartDate As %String = "", EndDate As %String = "", BillingGroupID As %String = "", OrderStatus As %String = "") As %Integer
{
}

ClassMethod GetMaxCoverageUsed(id As %Library.String = "") As %Float
{
}

}
