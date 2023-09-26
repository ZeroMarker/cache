Class web.ARCBankCardType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM = "CARD_DateFrom";

Parameter SQLDATETO = "CARD_DateTo";

Parameter SQLCODE = "CARD_Code";

Parameter SQLDESCRIPTION = "CARD_Desc";

Parameter SQLROWID = "CARD_RowId";

ClassMethod GetDescFromRowId(rowid As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBankCardBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", paymentDate As %Library.Date = "") As %Library.Boolean
{
}

ClassMethod LookUpBankCardClose(ByRef QqHandle As %Binary) As %Status [ PlaceAfter = LookUpBankCardExecute ]
{
}

ClassMethod LookUpBankCardExecute(ByRef QHandle As %Binary, val As %String, paymentDate As %Date) As %Status
{
}

ClassMethod LookUpBankCardFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpBankCardExecute ]
{
}

/// Aji 3/9/03 - log 37539 - changed query to take start/end date into account and filter by payment date
Query LookUpBankCard(desc As %String, paymentDate As %Date) As %Query(ROWSPEC = "Description:%String,Code:%String")
{
}

}
