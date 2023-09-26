Class web.PACContractType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 53;

Parameter SQLDATEFROM = "CONTRTYPE_DateFrom";

Parameter SQLDATETO = "CONTRTYPE_DateTo";

Parameter SQLCODE = "CONTRTYPE_Code";

Parameter SQLDESCRIPTION = "CONTRTYPE_Desc";

Parameter SQLROWID = "CONTRTYPE_RowId";

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", rdate As %Date) As %Boolean
{
}

Query LookUpWithDate(desc As %String, rdate As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CONTRTYPEDesc,HIDDEN,CONTRTYPECode")
{
SELECT	CONTRTYPE_Desc,CONTRTYPE_RowID,CONTRTYPE_Code
FROM	SQLUser.PAC_ContractType
WHERE	((CONTRTYPE_Desc %STARTSWITH :desc) OR (CONTRTYPE_Code = :desc))
AND	((CONTRTYPE_DateFrom IS NULL) OR (CONTRTYPE_DateFrom<= :rdate))
AND	((CONTRTYPE_DateTo IS NULL) OR (CONTRTYPE_DateTo>= :rdate))
ORDER	BY CONTRTYPE_Desc
}

}
