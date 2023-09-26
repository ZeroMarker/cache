Include webimport

IncludeGenerator webimport

Class web.MRCBodyArea Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 116;

Parameter SQLDATEFROM = "BODAR_DateFrom";

Parameter SQLDATETO = "BODAR_DateTo";

Parameter SQLCODE = "BODAR_Code";

Parameter SQLDESCRIPTION = "BODAR_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((BODAR_DateFrom <= CURRENT_DATE OR BODAR_DateFrom IS NULL) AND (BODAR_DateTo >= CURRENT_DATE OR BODAR_DateTo IS NULL))";

Parameter SQLROWID = "BODAR_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// 
/// always calls the javascipt select handler even if no match
ClassMethod LookUpBrokerAlwaysJS(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

ClassMethod LookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFetch ]
{
}

ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpExecute ]
{
}

Query LookUp(Desc As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "BodyArea:%String,Code:%String,HIDDEN:%String")
{
}

ClassMethod LookUpWithDateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithDateFetch ]
{
}

ClassMethod LookUpWithDateExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "", Date As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpWithDateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithDateExecute ]
{
}

Query LookUpWithDate(Desc As %Library.String = "", Date As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "BodyArea:%String,Code:%String,HIDDEN:%String")
{
}

}
