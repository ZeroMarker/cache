Class web.CTCountry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 156;

Parameter SQLCODE = "CTCOU_Code";

Parameter SQLDATEFROM = "CTCOU_DateActiveFrom";

Parameter SQLDESCRIPTION = "CTCOU_Desc";

Parameter SQLDATETO = "CTCOU_DateActiveTo";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTCOU_DateActiveFrom <= CURRENT_DATE OR CTCOU_DateActiveFrom IS NULL) AND (CTCOU_DateActiveTo >= CURRENT_DATE OR CTCOU_DateActiveTo IS NULL))";

Parameter SQLROWID = "CTCOU_RowId";

ClassMethod LookUpDOBClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDOBFetch ]
{
}

/// cjb 15/04/2005 51686 - new query.  written in cache, sets date variable and runs LookUpDate
/// called from PAPerson.Edit, Country of Birth [CTCOUDesc] field, where date is patient DOB
ClassMethod LookUpDOBExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, date As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpDOBFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDOBExecute ]
{
}

/// cjb 15/04/2005 51686 - new broker.
/// called from PAPerson.Edit, Country of Birth [CTCOUDesc] field, where date is patient DOB
ClassMethod LookUpDOBBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String, date As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod zzLookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// KM: 12Jun2001: Filters active countries only
Query zzLookUpActiveCountries(val As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String")
{
SELECT CTCOU_Desc,CTCOU_Code
FROM SQLUser.CT_Country
WHERE (CTCOU_Active='Y') AND ((CTCOU_Desc %STARTSWITH :val) OR (CTCOU_Code =:val))
ORDER BY CTCOU_Desc
}

/// cjb 15/04/2005 51411 - new query.  written in cache, sets date variable and runs LookUpExtDate
Query LookUpDOB(desc As %String, date As %Date = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Prov:%String,FiscalPrefix:%String")
{
}

}
