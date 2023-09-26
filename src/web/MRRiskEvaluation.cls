Class web.MRRiskEvaluation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 91;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RISK_RowId";

Parameter SQLDESCRIPTION = "RISK_RowId";

Parameter SQLROWID = "RISK_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

Query ListEPR(mradm As %Library.String, GrpSetCarPrv As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RISK_Date:%Library.Date,RISK_Desc,PARREF,RISK_Time:%Library.Time,STAT_Desc,CTPCP_Desc,CRIT_Desc,EVAL_Desc,REP_Desc,SSUSR_Name,UpdateDate:%Date,UpdateTime:%Time,UpdateHospital:%String")
{
SELECT RISK_RowId,RISK_Date, RISK_Desc, RISK_ParRef, RISK_Time,
 RISK_BodySysProbStat_DR->STAT_Desc, 
 RISK_CTCP_DR->CTPCP_Desc, 
 RISK_RiskCriteria_DR->CRIT_Desc, 
 RISK_RiskEval_DR->EVAL_Desc, 
 RISK_RiskParam_DR->REP_Desc, 
 RISK_UpdateUser_DR->SSUSR_Name,
 RISK_UpdateDate,
 RISK_UpdateTime,
 RISK_UpdateHospital_DR->HOSP_Desc
FROM SQLUser.MR_RiskEvaluation
WHERE RISK_ParRef = :mradm
AND ((:GrpSetCarPrv [ (','_%INTERNAL(RISK_UpdateUser_DR->SSUSR_CareProv_DR->CTPCP_CarPrvTp_DR)_',')) 
OR :GrpSetCarPrv is NULL)
}

}
