Include webimport

IncludeGenerator webimport

Class web.PHCDrgForm Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 148;

Parameter SQLDATEFROM = "PHCDF_DateFrom";

Parameter SQLDATETO = "PHCDF_DateTo";

Parameter SQLCODE = "PHCDF_OfficialCode";

Parameter SQLDESCRIPTION = "PHCDF_RowId";

Parameter SQLROWID = "PHCDF_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetDrugDetails(OrderItemID As %Library.String)
{
}

ClassMethod GetMIMSInfo(OrderItemID As %Library.String)
{
}

Query LookUpByItemMaster(arcimId, desc) As %SQLQuery(CONTAINID = 0, ROWSPEC = "PHCDName:%String")
{
SELECT PHCDF_PHCD_ParRef->PHCD_Name
FROM PHC_DrgForm
WHERE (PHCDF_PHCD_ParRef->PHCD_Name %STARTSWITH :desc)
AND ((PHCDF_DateFrom <= CURRENT_DATE) OR (PHCDF_DateFrom IS NULL))
AND ((PHCDF_DateTo >= CURRENT_DATE) OR (PHCDF_DateTo IS NULL))
ORDER BY PHCDF_PHCD_ParRef->PHCD_Name
}

}
