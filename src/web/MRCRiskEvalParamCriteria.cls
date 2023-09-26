Class web.MRCRiskEvalParamCriteria Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 88;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CRIT_Code";

Parameter SQLDESCRIPTION = "CRIT_Desc";

Parameter SQLROWID = "CRIT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpByParam(desc As %String, param As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "CRITDesc:%String,HIDDEN:%String,REPDesc:%String")
{
SELECT CRIT_Desc, CRIT_RowID, CRIT_ParRef->REP_Desc
FROM SQLUser.MRC_RiskEvalParamCriteria
WHERE (CRIT_Desc %STARTSWITH :desc) AND (CRIT_ParRef->REP_Desc %STARTSWITH :param)
ORDER BY CRIT_ParRef->REP_Desc,CRIT_Desc
}

ClassMethod LookUpByParamBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val2 As %Library.String = "") As %Library.Boolean
{
}

}
