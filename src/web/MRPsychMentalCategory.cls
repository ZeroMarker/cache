Class web.MRPsychMentalCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 109;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "MC_RowId";

Parameter SQLDATEFROM = "MC_DateFrom";

Parameter SQLDATETO = "MC_DateTo";

Parameter SQLDESCRIPTION = "MC_RowId";

Parameter SQLROWID = "MC_RowId";

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// ab 15.03.05 -update the psych details with the latest mental category
ClassMethod UpdatePsychMC(PARREF As %String = "")
{
}

ClassMethod RecordHistory(compref As %String, PARREF As %String, MentalCategory As %String = "", DateFrom As %String = "", TimeFrom As %String = "")
{
}

Query FindMentalCategory(PARREF As %String = "", mradm As %String = "") As %Query(CONTAINID = 1, ROWSPEC = "ID,PARREF,MCDateFrom,MCDateTo,MENTCDesc,MCTimeFrom")
{
}

ClassMethod FindMentalCategoryExecute(ByRef QHandle As %Library.Binary, PARREF As %String = "", mradm As %String = "") As %Library.Status
{
}

ClassMethod FindMentalCategoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMentalCategoryExecute ]
{
}

ClassMethod FindMentalCategoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMentalCategoryFetch ]
{
}

/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
}

}
