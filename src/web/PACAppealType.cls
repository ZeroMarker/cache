Class web.PACAppealType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "APPTYPE_Code";

Parameter SQLDATEFROM = "APPTYPE_DateFrom";

Parameter SQLDATETO = "APPTYPE_DateTo";

Parameter SQLDESCRIPTION = "APPTYPE_Desc";

Parameter SQLROWID = "APPTYPE_RowId";

Query LookUpWithAppeal(desc As %String, date As %String, appeal As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Appeal:%String")
{
SELECT APPTYPE_Desc,APPTYPE_RowID,APPTYPE_Code,APPTYPE_ParRef->APPEAL_Desc
FROM SQLUser.PAC_AppealType
WHERE ((%ALPHAUP APPTYPE_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP APPTYPE_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((APPTYPE_DateFrom <= :date OR APPTYPE_DateFrom IS NULL) AND  (APPTYPE_DateTo IS NULL OR APPTYPE_DateTo >= :date)))
AND ((:appeal IS NULL) OR (%ALPHAUP :appeal = %ALPHAUP APPTYPE_ParRef->APPEAL_Desc))
ORDER   BY APPTYPE_Desc
}

ClassMethod LookUpBrokerWithAppeal(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "", appeal As %String = "") As %Boolean
{
}

}
