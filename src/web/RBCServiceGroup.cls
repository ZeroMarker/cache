Class web.RBCServiceGroup Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 124;

Parameter SQLDATEFROM = "SG_DateFrom";

Parameter SQLDATETO = "SG_DateTo";

/// wanghc add
Query LookUp(SGDesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT SG_Desc,SG_RowId,SG_Code
FROM SQLUser.RBC_ServiceGroup
WHERE (:SGDesc is null) OR (SG_Desc  %STARTSWITH %ALPHAUP :SGDesc)
}

Query LookUpServiceGroup(sessionId As %String, SGDesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "SGDesc:%String,SGCode:%String,HIDDEN:%String")
{
SELECT DISTINCT BY (SER_RBC_Service_DR->SER_ServGroup_DR) SER_RBC_Service_DR->SER_ServGroup_DR->SG_Desc,SER_RBC_Service_DR->SER_ServGroup_DR->SG_Code,SER_RBC_Service_DR->SER_ServGroup_DR
FROM SQLUser.RB_ResEffDateSessServices 
WHERE ((SER_ParRef=:sessionId) OR (:sessionId IS NULL))
AND (%ALPHAUP SER_RBC_Service_DR->SER_ServGroup_DR->SG_Desc %STARTSWITH %ALPHAUP :SGDesc OR :SGDesc IS NULL)
Order by SER_RBC_Service_DR->SER_ServGroup_DR
}

Query LookUpService(sessionId As %String, SGDesc As %String, SERDesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "SGDesc:%String,HIDDEN:%String")
{
SELECT DISTINCT BY (SER_RBC_Service_DR) SER_RBC_Service_DR->SER_Desc,SER_RBC_Service_DR
FROM SQLUser.RB_ResEffDateSessServices 
WHERE (SER_ParRef=:sessionId)
AND (%ALPHAUP SER_RBC_Service_DR->SER_ServGroup_DR->SG_Desc %STARTSWITH %ALPHAUP :SGDesc OR :SGDesc IS NULL)
AND (%ALPHAUP SER_RBC_Service_DR->SER_Desc %STARTSWITH %ALPHAUP :SERDesc OR :SERDesc IS NULL)
Order by SER_RBC_Service_DR
}

Parameter SQLCODE = "SG_Code";

Parameter SQLDESCRIPTION = "SG_Desc";

Parameter SQLROWID = "SG_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod DoesAllowBookAfterDisch(Services As %Library.String = "", EpisodeID As %String = "", InvalidServices As %String = "") As %Boolean
{
}

ClassMethod DoesAnyAllowBookAfterDisch() As %Boolean
{
}

ClassMethod LookUpServiceGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", sessionId As %Library.String, val As %Library.String = "") As %Library.Boolean
{
}

}
