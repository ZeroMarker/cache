Class web.ORAnaestAdditionalStaff Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ANAAS_RowId";

Parameter SQLDESCRIPTION = "ANAAS_RowId";

Parameter SQLROWID = "ANAAS_RowId";

Property dummy As %String(TRUNCATE = 1);

Query GetDetails(PARREF) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ANAASParRef,ANAASCareProvType,CTPCPDesc,OPERDesc,SPPPDesc,ANAASStartDate,ANAASStartTime,ANAASEndDate,ANAASEndTime,CTLOCDesc")
{
SELECT ANAAS_RowId,ANAAS_ParRef,ANAAS_CareProvType,ANAAS_CareProv_DR->CTPCP_Desc,ANAAS_Operation_DR->OPER_Desc,ANAAS_StatePPP_DR->SPPP_Desc,ANAAS_StartDate,ANAAS_StartTime,ANAAS_EndDate,ANAAS_EndTime,ANAAS_CPLocation_DR->CTLOC_Desc
FROM SQLUser.OR_AnaestAdditionalStaff
WHERE ((ANAAS_ParRef=:PARREF) AND (:PARREF IS NOT NULL))
}

}
