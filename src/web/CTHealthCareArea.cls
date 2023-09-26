Include webimport

IncludeGenerator webimport

Class web.CTHealthCareArea Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 123;

Parameter SQLDATEFROM = "HCA_DateFrom";

Parameter SQLDATETO = "HCA_DateTo";

Parameter SQLCODE = "HCA_Code";

Parameter SQLDESCRIPTION = "HCA_Desc";

Parameter SQLROWID = "HCA_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod STRINGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpWithCityHCAExecute ]
{
}

ClassMethod STRINGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWithCityHCAExecute ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerUnique(itmjs As %String = "", itmjsex As %String = "", citydesc As %String = "", hcacodein As %String = "") As %Boolean
{
}

Query LookUpWithCityHCA(city As %String, hca As %String) As %Query(ROWSPEC = "description,hidden,code")
{
}

ClassMethod LookUpWithCityHCAClose(LookUpWithCityHCAClose As %Binary) As %Status
{
}

ClassMethod LookUpWithCityHCAExecute(ByRef QHandle As %Binary, city As %String, hca As %String) As %Status
{
}

ClassMethod LookUpWithCityHCAFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWithCityHCAExecute ]
{
}

/// /KK 16.09.03 L:32885 - "[" operator replaced with %STRARTSWITH in where condition
Query LookUpHCA(val As %Library.String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "HCADesc:%String,Hidden:%String,HCACode:%String")
{
SELECT HCA_Desc,HCA_RowId,HCA_Code
FROM SQLUser.CT_HealthCareArea
Where ((%ALPHAUP(HCA_Desc) %STARTSWITH %ALPHAUP(:val)) OR (%ALPHAUP(HCA_Code) %STARTSWITH %ALPHAUP(:val)))
AND (HCA_DateFrom <= CURRENT_DATE OR HCA_DateFrom IS NULL) 
AND (HCA_DateTo >= CURRENT_DATE OR HCA_DateTo IS NULL)
AND (HCA_HCR_DR->HCR_DateFrom <= CURRENT_DATE OR HCA_HCR_DR->HCR_DateFrom IS NULL) 
AND (HCA_HCR_DR->HCR_DateTo >= CURRENT_DATE OR HCA_HCR_DR->HCR_DateTo IS NULL)
Order by HCA_Desc
}

}
