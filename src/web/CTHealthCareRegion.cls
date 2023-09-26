Class web.CTHealthCareRegion Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 67;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "HCR_Code";

Parameter SQLDATEFROM = "HCR_DateFrom";

Parameter SQLDATETO = "HCR_DateTo";

Parameter SQLDESCRIPTION = "HCR_Desc";

Parameter SQLROWID = "HCR_RowId";

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT HCR_Desc, HCR_RowId, HCR_Code
FROM SQLUser.CT_HealthCareRegion
WHERE (%ALPHAUP HCR_Desc [%ALPHAUP :desc)
AND (HCR_DateFrom <= CURRENT_DATE OR HCR_DateFrom IS NULL) 
AND (HCR_DateTo >= CURRENT_DATE OR HCR_DateTo IS NULL)
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpHCR(desc As %Library.String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT HCR_Desc, HCR_RowId, HCR_Code
FROM SQLUser.CT_HealthCareRegion
WHERE ((%ALPHAUP(HCR_Desc) [ %ALPHAUP(:desc))OR (%ALPHAUP(HCR_Code) [ %ALPHAUP(:desc)))
AND (HCR_DateFrom <= CURRENT_DATE OR HCR_DateFrom IS NULL) 
AND (HCR_DateTo >= CURRENT_DATE OR HCR_DateTo IS NULL)
ORDER BY HCR_Desc
}

}
