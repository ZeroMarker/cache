Class web.ORAnOperAdditionalStaff Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OPAS_RowId";

Parameter SQLDESCRIPTION = "OPAS_RowId";

Parameter SQLROWID = "OPAS_RowId";

Property dummy As %String(TRUNCATE = 1);

Query GetDetails(PARREF) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,OPASParRef,OPASCareProvType,CTPCPDesc,OPERDesc,SPPPDesc,OPASStartDate,OPASStartTime,OPASEndDate,OPASEndTime,CTLOCDesc")
{
SELECT OPAS_RowId,OPAS_ParRef,OPAS_CareProvType,OPAS_CareProv_DR->CTPCP_Desc,OPAS_Operation_DR->OPER_Desc,OPAS_StatePPP_DR->SPPP_Desc,OPAS_StartDate,OPAS_StartTime,OPAS_EndDate,OPAS_EndTime,OPAS_CPLocation_DR->CTLOC_Desc
FROM SQLUser.OR_An_Oper_Additional_Staff
WHERE ((OPAS_ParRef=:PARREF) AND (:PARREF IS NOT NULL))
}

}
