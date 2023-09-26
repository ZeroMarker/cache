Class web.PACAgedCareAssessServ Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 29;

Parameter SQLCODE = "ACAS_Code";

Parameter SQLDATEFROM = "ACAS_DateFrom";

Parameter SQLDESCRIPTION = "ACAS_Desc";

Parameter SQLDATETO = "ACAS_DateTo";

Parameter SQLROWID = "ACAS_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerNC(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpNC(desc As %String, date As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,NatCode:%String")
{
SELECT	ACAS_Desc,ACAS_RowID,ACAS_Code,ACAS_NationalCode
FROM	 SQLUser.PAC_AgedCareAssessServ
WHERE	((ACAS_Desc %STARTSWITH :desc) OR 	(ACAS_Code=:desc))
AND	((ACAS_DateFrom IS NULL) OR (ACAS_DateFrom<= :date))
AND	((ACAS_DateTo IS NULL) OR (ACAS_DateTo>= :date))
ORDER BY ACAS_Desc
}

}
