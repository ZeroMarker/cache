Class web.PACContractRole Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 46;

Parameter SQLDATEFROM = "CONTROL_DateFrom";

Parameter SQLDATETO = "CONTROL_DateTo";

Parameter SQLCODE = "CONTROL_Code";

Parameter SQLDESCRIPTION = "CONTROL_Desc";

Parameter SQLROWID = "CONTROL_RowId";

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", rdate As %Date) As %Boolean
{
}

Query LookUpWithDate(desc As %String, rdate As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CONTROLDesc,HIDDEN,CONTROLCode")
{
SELECT	CONTROL_Desc,CONTROL_RowID,CONTROL_Code
FROM	SQLUser.PAC_ContractRole
WHERE	((CONTROL_Desc %STARTSWITH :desc) OR (CONTROL_Code = :desc))
AND	((CONTROL_DateFrom IS NULL) OR (CONTROL_DateFrom<= :rdate))
AND	((CONTROL_DateTo IS NULL) OR (CONTROL_DateTo>= :rdate))
ORDER	BY CONTROL_Desc
}

}
