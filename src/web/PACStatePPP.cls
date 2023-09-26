Class web.PACStatePPP Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 154;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SPPP_Code";

Parameter SQLDESCRIPTION = "SPPP_Desc";

Parameter SQLROWID = "SPPP_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// CS Log 41685 14/1/04 : added SPPP_NPPP_DR,SPPP_NPPP_DR->NPPP_Desc,SPPP_EstTime to sql select statement and retval
ClassMethod LookUpBrokerByLocation(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", location As %Library.String = "", wltype As %Library.String = "", activedate As %Library.Date = "", admType As %Library.String = "", surg As %Library.String = "", recov As %Library.String = "", bookdate As %Library.Date, reqdate As %Library.Date) As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookupBrokerByLoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", location As %Library.String = "", wltype As %Library.String = "", activedate As %Library.Date = "", admType As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookupByLocClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupByLocFetch ]
{
}

/// Default implementation of LookUp Query.
/// CS log 41685 13/1/04 : Included column SPPP_EstTime to the sql statement
/// CS log 47062 18/1/04 : Included admType in the where clause
ClassMethod LookupByLocExecute(ByRef QHandle As %Library.Binary, desc As %String, location As %Library.String = "", wltype As %Library.String = "", activedate As %Library.Date = "", admType As %Library.String = "", surg As %Library.String = "", recov As %Library.String = "", bookdate As %Library.Date, reqdate As %Library.Date) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
/// CS log 41685 13/1/04 : Included column SPPP_EstTime
ClassMethod LookupByLocFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupByLocExecute ]
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query CodeDescLookup(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,ESIS:%String")
{
SELECT SPPP_Desc,SPPP_RowId,SPPP_Code,SPPP_ESIS_Reportable
FROM SQLUser.PAC_StatePPP
WHERE %ALPHAUP SPPP_Desc [ %ALPHAUP :desc
}

/// have to do :location as null and LOC_DR as null so that it works for both austin and rie.  
/// 
/// spoke to wendy ellis, and she advised that RIE will have the location field filled in 
/// for EVERY stateppp.  if it isnt, then that particular item will display EVERY time.
/// 
/// KK 5/6/02 Log 25256 for B&R, added waitinglist type also as a filter criteria
/// KK 12/Mar/2003 Log 32885 Added NPPP Rowid and NPPPDesc
/// CS log 41685 13/1/04 : Added SPPP_EstTime
Query LookupByLoc(desc As %String, location As %String, wltype As %String, activedate As %Library.Date, admType As %Library.String, surg As %Library.String, recov As %Library.String, bookdate As %Library.Date, reqdate As %Library.Date) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,ESIS:%String,HIDDEN:%String,HIDDEN:%String,EstTime:%Integer,HIDDEN:%String")
{
}

}
