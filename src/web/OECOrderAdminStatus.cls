Class web.OECOrderAdminStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 112;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "STAT_Code";

Parameter SQLDESCRIPTION = "STAT_Desc";

Parameter SQLROWID = "STAT_RowId";

ClassMethod GetStatusColours(ByRef dataLIST As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// 
/// 
/// TN:28/2/02: added %ALPHAUP to queries to ignore casing
ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", includeBlank As %Boolean = 0) As %Library.Boolean
{
}

/// Default implementation of LookUp Query. 
/// log61355 TedT 
ClassMethod LookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFetch ]
{
}

/// Default implementation of LookUp Query.
/// 
/// TN:28/2/02: added %ALPHAUP to queries to ignore casing
ClassMethod LookUpExecute(ByRef QHandle As %Library.Binary, desc As %String, includeBlank As %Boolean) As %Status
{
}

/// Default implementation of LookUp Query.
/// log61355 TedT
ClassMethod LookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpExecute ]
{
}

Query LookUpCaseInsensitive(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String")
{
SELECT STAT_Desc
FROM SQLUser.OEC_Order_AdminStatus
WHERE (%ALPHAUP STAT_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP STAT_Code = %ALPHAUP :desc)
ORDER BY STAT_Desc
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String, includeBlank As %Boolean = 0) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
}

}
