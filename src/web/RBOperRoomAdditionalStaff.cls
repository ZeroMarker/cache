Class web.RBOperRoomAdditionalStaff Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RBOPAS_RowId";

Parameter SQLDESCRIPTION = "RBOPAS_RowId";

Parameter SQLROWID = "RBOPAS_RowId";

Property dummy As %String(TRUNCATE = 1);

Query GetDetails(PARREF) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,RBOPASParRef,RBOPASCareProvType,CTPCPDesc,OPERDesc,SPPPDesc,RBOPASStartDate,RBOPASStartTime,RBOPASEndDate,RBOPASEndTime,CTLOCDesc")
{
SELECT RBOPAS_RowId,RBOPAS_ParRef,RBOPAS_CareProvType,RBOPAS_CareProv_DR->CTPCP_Desc,RBOPAS_Operation_DR->OPER_Desc,RBOPAS_StatePPP_DR->SPPP_Desc,RBOPAS_StartDate,RBOPAS_StartTime,RBOPAS_EndDate,RBOPAS_EndTime, RBOPAS_CPLocation_DR->CTLOC_Desc
FROM SQLUser.RB_OperRoomAdditionalStaff
WHERE ((RBOPAS_ParRef=:PARREF) AND (:PARREF IS NOT NULL))
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

ClassMethod websysSaveAddStfSessLvl(id As %String)
{
}

ClassMethod IsLinkedStaff(PARREF) As %String
{
}

}
