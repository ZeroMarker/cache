Class web.PACWLReasonForList Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 94;

Parameter SQLDATEFROM = "RFL_DateFrom";

Parameter SQLDATETO = "RFL_DateTo";

Parameter SQLCODE = "RFL_Code";

Parameter SQLDESCRIPTION = "RFL_Desc";

Parameter SQLROWID = "RFL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// RQG Log23079:
/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpReasonBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpReasonOnDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", wldate As %Library.String = "") As %Library.Boolean
{
}

/// /KK 28/jul/2003 Log 35081
ClassMethod LookUpReasonOnDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpReasonOnDateExecute ]
{
}

/// /KK 28/jul/2003 Log 35081
ClassMethod LookUpReasonOnDateExecute(ByRef qHandle As %Binary, desc As %String = "", wldate As %String = "") As %Status
{
}

ClassMethod LookUpReasonOnDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpReasonOnDateExecute ]
{
}

Query LookUpReasonOnDate(desc As %String = "", wldate As %String = "") As %Query(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod LookUpReasonBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// /KK 28/jul/2003 Log 35081
ClassMethod LookUpReasonOnDateBrokerOLD(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", wldate As %Library.String = "") As %Library.Boolean
{
}

}
