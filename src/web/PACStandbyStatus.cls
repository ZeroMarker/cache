Class web.PACStandbyStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod LookUpLocByHospBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String) As %Library.Boolean
{
}

Parameter SQLCODE = "STANDST_Code";

Parameter SQLDATEFROM = "STANDST_DateFrom";

Parameter SQLDATETO = "STANDST_DateTo";

Parameter SQLDESCRIPTION = "STANDST_Desc";

Parameter SQLROWID = "STANDST_RowId";

Query LookUpStandBy(desc) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc,Code,Hidden")
{
SELECT STANDST_Desc,STANDST_Code,STANDST_RowID
FROM SQLUser.PAC_StandbyStatus
WHERE ((STANDST_Desc %STARTSWITH :desc) OR (STANDST_Code %STARTSWITH :desc) OR (:desc IS NULL))
AND (STANDST_DateFrom <= CURRENT_DATE) 
AND ((STANDST_DateTo IS NULL) OR (STANDST_DateTo >= CURRENT_DATE))
ORDER BY STANDST_Desc
}

ClassMethod LookUpLocByHospBrokerOLD(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String) As %Library.Boolean
{
}

}
