Include webimport

IncludeGenerator webimport

Class web.CTPayMode Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 131;

Parameter SQLDATEFROM = "CTPM_DateFrom";

Parameter SQLDATETO = "CTPM_DateTo";

Parameter SQLCODE = "CTPM_Code";

Parameter SQLDESCRIPTION = "CTPM_Desc";

Parameter SQLROWID = "CTPM_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetDescFromRowId(rowid As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpGrpCodeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", paymentDate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpGrpCodeClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpGrpCodeExecute ]
{
}

ClassMethod LookUpGrpCodeExecute(ByRef QHandle As %Binary, desc As %String, paymentDate As %Date) As %Status
{
}

ClassMethod LookUpGrpCodeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpGrpCodeExecute ]
{
}

/// Aji 3/9/03 - log 37539 - changed query to take start/end date into account and filter by payment date
Query LookUpGrpCode(desc As %String, paymentDate As %Date) As %Query(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
}

}
