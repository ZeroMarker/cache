Include webimport

IncludeGenerator webimport

Class web.ARCDisretOutstType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 100;

Parameter SQLDATEFROM = "DOUTS_DateFrom";

Parameter SQLDATETO = "DOUTS_DateTo";

Parameter SQLCODE = "DOUTS_Code";

Parameter SQLDESCRIPTION = "DOUTS_Desc";

Parameter SQLROWID = "DOUTS_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpOutstTypeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", paymentDate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpOutstTypeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpOutstTypeExecute ]
{
}

ClassMethod LookUpOutstTypeExecute(ByRef QHandle As %Binary, val As %String, paymentDate As %Date) As %Status
{
}

ClassMethod LookUpOutstTypeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOutstTypeExecute ]
{
}

/// Aji 3/9/03 - log 37539 - changed query to take start/end date into account and filter by payment date
Query LookUpOutstType(desc As %String, paymentDate As %Date) As %Query(ROWSPEC = "Description:%String,Code:%String")
{
}

}
