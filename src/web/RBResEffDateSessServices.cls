Include webimport

IncludeGenerator webimport

Class web.RBResEffDateSessServices Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 199;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "SER_RowId";

Parameter SQLDESCRIPTION = "SER_Desc";

Parameter SQLROWID = "SER_RowId";

ClassMethod CheckAgeSexRestrictions(compref As %Library.String) As %Library.Boolean
{
}

Query Find(serv As %String, resc As %String, loc As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SERRBCServiceDR:%String,SERDesc:%String,SERResourceDR:%String,RESDesc:%String,RESCTLOCDR:%String,CTLOCDesc:%String,RESCTPCPDR:%String,RESEQDR:%String,ARCIMQuestionnaireDR:%String,SERMinutes:%Float")
{
SELECT SER_RowID, SER_RBC_Service_DR, SER_RBC_Service_DR->SER_Desc, SER_Resource_DR, SER_Resource_DR->RES_Desc, SER_Resource_DR->RES_CTLOC_DR, SER_Resource_DR->RES_CTLOC_DR->CTLOC_Desc, SER_Resource_DR->RES_CTPCP_DR, SER_Resource_DR->RES_EQ_DR, SER_RBC_Service_DR->SER_ARCIM_DR->ARCIM_Questionnaire_DR, SER_Minutes
FROM SQLUser.RB_ResEffDateSessServices
WHERE (SER_RBC_Service_DR->SER_Desc = :serv) AND (%ALPHAUP SER_Resource_DR->RES_Desc = %ALPHAUP :resc) AND (SER_Resource_DR->RES_CTLOC_DR->CTLOC_Desc = :loc)
}

Query FindServices(sessionID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "serviceID:%String")
{
SELECT DISTINCT BY (SER_RBC_Service_DR->SER_ServGroup_DR) SER_RBC_Service_DR->SER_ServGroup_DR 
FROM SQLUser.RB_ResEffDateSessServices 
WHERE SER_ParRef=:sessionID 
Order by SER_RBC_Service_DR->SER_ServGroup_DR
}

Query FindTypeRestrict(serv As %String, resc As %String, loc As %String, type As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SERRBCServiceDR:%String,SERDesc:%String,SERResourceDR:%String,RESDesc:%String,RESCTLOCDR:%String,CTLOCDesc:%String,RESCTPCPDR:%String,RESEQDR:%String,ARCIMQuestionnaireDR:%String,SERMinutes:%Float")
{
SELECT SER_RowID, SER_RBC_Service_DR, SER_RBC_Service_DR->SER_Desc, SER_Resource_DR, SER_Resource_DR->RES_Desc, SER_Resource_DR->RES_CTLOC_DR, SER_Resource_DR->RES_CTLOC_DR->CTLOC_Desc, SER_Resource_DR->RES_CTPCP_DR, SER_Resource_DR->RES_EQ_DR, SER_RBC_Service_DR->SER_ARCIM_DR->ARCIM_Questionnaire_DR, SER_Minutes
FROM SQLUser.RB_ResEffDateSessServices
WHERE (SER_RBC_Service_DR->SER_Desc = :serv) AND (%ALPHAUP SER_Resource_DR->RES_Desc = %ALPHAUP :resc) AND (SER_Resource_DR->RES_CTLOC_DR->CTLOC_Desc = :loc)
AND ((SER_ParRef->SESS_SessionType_DR->SESS_Desc %STARTSWITH :type) OR (:type IS NULL))
}

Query LookUpResourceLocation(serv As %String, resc As %String, loc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "SERDesc:%String,RESDesc:%String,CTLOCDesc:%String,HIDDEN:%String")
{
SELECT DISTINCT BY (SER_RBC_Service_DR,SER_Resource_DR) SER_RBC_Service_DR->SER_Desc, SER_Resource_DR->RES_Desc, SER_CTLOC_DR->CTLOC_Desc, SER_RowId
FROM RB_ResEffDateSessServices
WHERE (SER_RBC_Service_DR->SER_Desc %STARTSWITH :serv) AND (%ALPHAUP SER_Resource_DR->RES_Desc %STARTSWITH %ALPHAUP :resc) AND (SER_CTLOC_DR->CTLOC_Desc %STARTSWITH :loc)
}

}
