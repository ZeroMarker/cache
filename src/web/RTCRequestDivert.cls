Class web.RTCRequestDivert Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 53;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "REQDIV_RowId";

Parameter SQLDESCRIPTION = "REQDIV_RowId";

Parameter SQLROWID = "REQDIV_RowId";

Property dunmmy As %Library.String(TRUNCATE = 1);

ClassMethod CheckDivert(RequestType As %Library.String = "", MRType As %Library.String = "", Hospital As %Library.String = "") As %Library.String
{
}

Query List(CurrentHospital As %Library.String = "", DivertLocation As %Library.String = "", MRType As %Library.String = "", RequestType As %Library.String = "", ShowHome As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ReqType,MRType,Hospital,MRLocation,ShowHome")
{
SELECT REQDIV_RowId,REQDIV_Reqreason_DR->REA_Desc,REQDIV_RecordType_DR->TYP_Desc,REQDIV_Hospital_DR->HOSP_Desc,REQDIV_MRLocation_DR->CTLOC_Desc,REQDIV_ShowHome
FROM SQLUser.RTC_RequestDivert
WHERE ((REQDIV_Hospital_DR->HOSP_Desc=:CurrentHospital) OR (:CurrentHospital is NULL))
AND ((REQDIV_MRLocation_DR->CTLOC_Desc=:DivertLocation) OR (:DivertLocation is NULL))
AND ((REQDIV_RecordType_DR->TYP_Desc=:MRType) OR (:MRType is NULL))
AND ((REQDIV_Reqreason_DR->REA_Desc=:RequestType) OR (:RequestType is NULL))
AND (((REQDIV_ShowHome='Y') AND (:ShowHome='on')) OR ((REQDIV_ShowHome='N') AND (:ShowHome IS NULL)))
}

}
