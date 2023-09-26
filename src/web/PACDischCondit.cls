Include webimport

IncludeGenerator webimport

/// Discharge Condition
Class web.PACDischCondit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 124;

Parameter SQLDATEFROM = "DISCON_DateFrom";

Parameter SQLDATETO = "DISCON_DateTo";

Parameter SQLCODE = "DISCON_Code";

Parameter SQLDESCRIPTION = "DISCON_Desc";

Parameter SQLROWID = "DISCON_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the LookUp for Discharge Condition and returns desc, rowid, code and deadflag
/// 
/// admtype - defaults to logged in type (emergency/inpatient)
/// admtype2 - if they pick an admission type, change restriction
ClassMethod LookUpByLocationBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", admType As %Library.String = "") As %Library.Boolean
{
}

/// KM 22-Jan-2002: Modified to include DISCON_EpisodeType field and WHERE clause
/// 
/// KK & RG
/// Log:20992
/// Date:9-jan-2002
/// Basic query returning description, rowid, code and deadflag from a partial description.
/// 
Query LookUpByLocationType(desc As %String, admType As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT DISCON_Desc, DISCON_RowId, DISCON_Code,DISCON_DeadFlag
FROM SQLUser.PAC_DischCondit
WHERE (%ALPHAUP DISCON_Desc %STARTSWITH %ALPHAUP :desc)
AND (((DISCON_EpisodeType=:admType) OR (DISCON_EpisodeType IS NULL)) OR (:admType IS NULL))
AND (((DISCON_DateFrom <= CURRENT_DATE) OR (DISCON_DateFrom IS NULL)) AND ((DISCON_DateTo >= CURRENT_DATE) OR (DISCON_DateTo IS NULL)))
ORDER BY DISCON_Desc
}

ClassMethod LookUpByLocationBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", admType As %Library.String = "") As %Library.Boolean
{
}

Query LookUpByLocationTypeNC(desc As %String, admType As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT DISCON_Desc, DISCON_RowId, DISCON_Code,DISCON_DeadFlag,DISCON_NationalCode
FROM SQLUser.PAC_DischCondit
WHERE (%ALPHAUP DISCON_Desc %STARTSWITH %ALPHAUP :desc)
AND (((DISCON_EpisodeType=:admType) OR (DISCON_EpisodeType IS NULL)) OR (:admType IS NULL))
AND (((DISCON_DateFrom <= CURRENT_DATE) OR (DISCON_DateFrom IS NULL)) AND ((DISCON_DateTo >= CURRENT_DATE) OR (DISCON_DateTo IS NULL)))
ORDER BY DISCON_Desc
}

}
