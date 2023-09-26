Include webimport

IncludeGenerator webimport

Class web.CTOccupation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 132;

Parameter SQLDATEFROM = "CTOCC_DateFrom";

Parameter SQLDATETO = "CTOCC_DateTo";

Parameter SQLCODE = "CTOCC_Code";

Parameter SQLDESCRIPTION = "CTOCC_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTOCC_DateFrom <= CURRENT_DATE OR CTOCC_DateFrom IS NULL) AND (CTOCC_DateTo >= CURRENT_DATE OR CTOCC_DateTo IS NULL))";

Parameter SQLROWID = "CTOCC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpKeyWordClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpKeyWordFetch ]
{
}

ClassMethod LookUpKeyWordExecute(ByRef QHandle As %Library.Binary, desc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpKeyWordFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpKeyWordExecute ]
{
}

Query LookUpKeyWord(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

}
