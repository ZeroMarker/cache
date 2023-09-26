Class web.OECAlertReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 122;

ClassMethod LookUpBrokerReasonForOverride(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "ALR_Code";

Parameter SQLDATEFROM = "ALR_DateFrom";

Parameter SQLDATETO = "ALR_DateTo";

Parameter SQLDESCRIPTION = "ALR_Desc";

Parameter SQLROWID = "ALR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query FindAlertReason() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ALRDesc:%String")
{
SELECT ALR_Desc
FROM SQLUser.OEC_AlertReason
ORDER BY ALR_Desc
}

Query LookUpReasonForOverride(Desc As %String = "") As %SQLQuery(CONTAINID = 2, ROWSPEC = "ALRDesc:%String,HIDDEN:%String,ALRCode:%String")
{
SELECT ALR_Desc,ALR_RowId,ALR_Code
FROM SQLUser.OEC_AlertReason
WHERE ((ALR_Desc %STARTSWITH :Desc) OR (ALR_Code %STARTSWITH :Desc)) 
	AND ((ALR_DateTo IS NULL)OR(ALR_DateTo >= CURRENT_DATE))
	AND ((ALR_DateFrom IS NULL)OR(ALR_DateFrom <= CURRENT_DATE))
ORDER BY ALR_Desc
}

}
