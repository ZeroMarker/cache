Class web.BLCDRGTariff Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

Parameter SQLDATEFROM = "TAR_DateFrom";

Parameter SQLDATETO;

Parameter SQLCODE = "TAR_RowId";

Parameter SQLDESCRIPTION = "TAR_RowId";

Parameter SQLROWID = "TAR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// SA 10.07.02 - log 24621: Method created for implementation of DRG Inquiry.
/// When DRG Code is returned from DRG grouper, the code is required to display
/// the tariff codes against the returned DRG code.
ClassMethod GetDetailsForDRG(DRGCode As %Library.String = "", Date As %Library.Date = {+$h})
{
}

ClassMethod LookUpDRGTarByVersionBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", version As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpDRGTarByVersionClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpDRGTarByVersionExecute ]
{
}

ClassMethod LookUpDRGTarByVersionExecute(ByRef QHandle As %Binary, val As %String = "", version As %String = "") As %Status
{
}

ClassMethod LookUpDRGTarByVersionFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDRGTarByVersionExecute ]
{
}

Query LookUpDRGTarByVersion(val As %String = "", version As %String = "") As %Query(ROWSPEC = "Desc:%String,hidden:%String,Code:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String,hidden:%String")
{
}

}
