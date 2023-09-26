Include webimport

IncludeGenerator webimport

Class web.PHCForm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "PHCF_Code";

Parameter SQLDESCRIPTION = "PHCF_Desc";

Parameter SQLROWID = "PHCF_RowId";

Query LookUpByDrgFrm(desc, drgFrm) As %SQLQuery(CONTAINID = 0, ROWSPEC = "PHCFDesc:%String,HIDDEN:%String,PHCFCode:%String")
{
SELECT DISTINCT PHCDF_PHCF_DR->PHCF_Desc,PHCDF_PHCF_DR->PHCF_RowId,PHCDF_PHCF_DR->PHCF_Code
FROM PHC_DrgForm
WHERE ((PHCDF_PHCF_DR->PHCF_Desc %STARTSWITH :desc) OR (PHCDF_PHCF_DR->PHCF_Code %STARTSWITH :desc))
AND ((PHCDF_PHCD_ParRef->PHCD_Name=:drgFrm) OR (:drgFrm IS NULL))
ORDER BY PHCDF_PHCF_DR->PHCF_Desc
}

Query LookUpByDrgFrmDetails(desc, drgFrm, active) As %SQLQuery(CONTAINID = 0, ROWSPEC = "PHCFDesc:%String,HIDDEN:%String,PHCFCode:%String,Route:%String,Strength:%String,PackSize:%String")
{
SELECT DISTINCT PHCDF_PHCF_DR->PHCF_Desc,PHCDF_RowId,PHCDF_PHCF_DR->PHCF_Code, PHCDF_Route_DR->ROUTE_Desc,PHCDF_PHCS_DR->PHCS_Desc,PHCDF_PHCPA_DR->PHCPA_Desc
FROM PHC_DrgForm
WHERE ((PHCDF_PHCF_DR->PHCF_Desc %STARTSWITH :desc) OR (PHCDF_PHCF_DR->PHCF_Code %STARTSWITH :desc))
AND ((PHCDF_PHCD_ParRef->PHCD_Name=:drgFrm) OR (:drgFrm IS NULL))
AND ((:active IS NULL) OR ((:active IS NOT NULL) AND ((PHCDF_DateFrom IS NULL) OR (PHCDF_DateFrom <= CURRENT_DATE)) AND ((PHCDF_DateTo IS NULL) OR (PHCDF_DateTo >= CURRENT_DATE))))
ORDER BY PHCDF_PHCF_DR->PHCF_Desc
}

ClassMethod LookUpBrokerByDrgFrmDetails(itmjs As %String = "", itmjsex As %String = "", val As %String = "", val2 As %String = "", active As %String = "") As %Boolean
{
}

ClassMethod LookUpBrokerByDrgFrm(itmjs As %String = "", itmjsex As %String = "", val As %String = "", val2 As %String) As %Boolean
{
}

}
