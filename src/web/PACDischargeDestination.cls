Class web.PACDischargeDestination Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 85;

Parameter SQLDATEFROM = "DDEST_DateFrom";

Parameter SQLDATETO = "DDEST_DateTo";

Parameter SQLCODE = "DDEST_Code";

Parameter SQLDESCRIPTION = "DDEST_Desc";

Parameter SQLFILTER = "((DDEST_DateFrom <= CURRENT_DATE OR DDEST_DateFrom IS NULL) AND (DDEST_DateTo >= CURRENT_DATE OR DDEST_DateTo IS NULL))";

Parameter SQLROWID = "DDEST_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetImage(ID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerWithNatCode(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %String = "") As %Library.Boolean
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpWithNatCode(desc As %String, date As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,hidden:%String")
{
SELECT DDEST_Desc, DDEST_RowID, DDEST_Code, DDEST_NationalCode
FROM SQLUser.PAC_DischargeDestination
WHERE ((%ALPHAUP DDEST_Desc %STARTSWITH %ALPHAUP :desc) OR
 (%ALPHAUP DDEST_Code %STARTSWITH %ALPHAUP :desc))
 	AND ((:date IS NULL) OR (((DDEST_DateFrom <= :date OR DDEST_DateFrom IS NULL) 
 	AND (DDEST_DateTo >= :date OR DDEST_DateTo IS NULL))))
 	ORDER BY DDEST_Desc
}

}
