Include webimport

IncludeGenerator webimport

Class web.CMCBankMas Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 114;

Parameter SQLDATEFROM = "CMCBM_DateFrom";

Parameter SQLDATETO = "CMCBM_DateTo";

Parameter SQLCODE = "CMCBM_Code";

Parameter SQLDESCRIPTION = "CMCBM_Desc";

Parameter SQLROWID = "CMCBM_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetDescFromRowId(rowid As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBankBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", paymentDate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpBankClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpBankExecute ]
{
}

ClassMethod LookUpBankExecute(ByRef QHandle As %Binary, val As %String, paymentDate As %Date) As %Status
{
}

ClassMethod LookUpBankFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpBankExecute ]
{
}

/// Aji 3/9/03 - log 37539 - changed query to take start/end date into account and filter by payment date
Query LookUpBank(desc As %String, paymentDate As %Date) As %Query(ROWSPEC = "Description:%String,Code:%String")
{
}

}
