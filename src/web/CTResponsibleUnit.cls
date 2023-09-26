Class web.CTResponsibleUnit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

Parameter SQLDATEFROM = "RU_DateFrom";

Parameter SQLDATETO = "RU_DateTo";

Parameter SQLCODE = "RU_Code";

Parameter SQLDESCRIPTION = "RU_Desc";

Parameter SQLROWID = "RU_RowId";

ClassMethod LookUpPartBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerHosp(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", hosp As %String = "") As %Library.Boolean
{
}

Query LookUpHosp(desc As %String, hosp As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT DISTINCT BY (CTLOC_RespUnit_DR->RU_RowId) CTLOC_RespUnit_DR->RU_Desc,CTLOC_RespUnit_DR->RU_RowId,CTLOC_RespUnit_DR->RU_Code
FROM SQLUser.CT_Loc
WHERE ((%ALPHAUP CTLOC_RespUnit_DR->RU_Desc %STARTSWITH %ALPHAUP :desc)
OR (%ALPHAUP CTLOC_RespUnit_DR->RU_Code = %ALPHAUP :desc))
AND (({fn CONCAT( '|', {fn CONCAT((:hosp),'|')})} [ {fn CONCAT( '|', {fn CONCAT((CTLOC_Hospital_DR),'|')})}) OR (:hosp IS NULL))
ORDER BY CTLOC_RespUnit_DR->RU_Desc
}

Query LookUpPart(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT RU_Desc,RU_RowId,RU_Code
FROM SQLUser.CT_ResponsibleUnit
WHERE ((%ALPHAUP RU_Desc [ %ALPHAUP :desc) or (%ALPHAUP RU_Code [ %ALPHAUP :desc))
AND ((RU_DateFrom IS NULL OR RU_DateFrom <= CURRENT_DATE) AND (RU_DateTo IS NULL OR RU_DateTo >= CURRENT_DATE))
ORDER BY RU_Desc
}

}
