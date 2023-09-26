Class web.OECRoute Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

Parameter SQLDATEFROM = "ROUTE_DateFrom";

Parameter SQLDATETO = "ROUTE_DateTo";

Parameter SQLCODE = "ROUTE_RowId";

Parameter SQLDESCRIPTION = "ROUTE_RowId";

Parameter SQLROWID = "ROUTE_RowId";

Query LookUpRoute(Route As %Library.String = "", Date As %Library.String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "ROUTEDesc,ROUTECode")
{
SELECT	ROUTE_Desc,ROUTE_Code
FROM	SQLUser.OEC_Route
WHERE	((%ALPHAUP ROUTE_Code %STARTSWITH %ALPHAUP :Route) OR (%ALPHAUP ROUTE_Desc %STARTSWITH %ALPHAUP :Route) OR (:Route IS NULL))
AND	((:Date >= ROUTE_DateFrom) OR (ROUTE_DateFrom IS NULL))
AND	((:Date <= ROUTE_DateTo) OR (ROUTE_DateTo IS NULL))
}

ClassMethod LookUpBrokerRoute(itmjs As %Library.String = "", itmjsex As %Library.String = "", Route As %String = "", Date As %String = "") As %Library.Boolean
{
}

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

}
