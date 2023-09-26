Class web.MRCRiskParamCritEval Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 83;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EVAL_Code";

Parameter SQLDESCRIPTION = "EVAL_Desc";

Parameter SQLROWID = "EVAL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpByParamCriteria(desc As %String, criteria As %String, param As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "EVALDesc:%String,HIDDEN:%String,CRITDesc:%String,REPDesc:%String")
{
SELECT EVAL_Desc, EVAL_RowID, EVAL_ParRef->CRIT_Desc, EVAL_ParRef->CRIT_ParRef->REP_Desc
FROM SQLUser.MRC_RiskParamCritEval
WHERE (EVAL_ParRef->CRIT_Desc %STARTSWITH :criteria) AND (EVAL_ParRef->CRIT_ParRef->REP_Desc %STARTSWITH :param) 
AND (EVAL_Desc %STARTSWITH :desc)
ORDER BY EVAL_Desc
}

ClassMethod LookUpByParamCriteriaBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val2 As %Library.String = "", val3 As %Library.String = "") As %Library.Boolean
{
}

}
