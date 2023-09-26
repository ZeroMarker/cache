Class web.PACReasonDelayDischarge Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 57;

Parameter SQLCODE = "READEL_Code";

Parameter SQLDATEFROM = "READEL_DateFrom";

Parameter SQLDATETO = "READEL_DateTo";

Parameter SQLDESCRIPTION = "READEL_Desc";

Parameter SQLROWID = "READEL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpWithType(desc As %String, date As %String, type As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT READEL_Desc,READEL_RowId,READEL_Code
FROM SQLUser.PAC_ReasonDelayDischarge
WHERE ((%ALPHAUP READEL_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP READEL_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((READEL_DateFrom <= :date OR READEL_DateFrom IS NULL) AND  (READEL_DateTo IS NULL OR READEL_DateTo >= :date)))
AND ((READEL_EpisodeType IS NULL) OR (:type IS NULL) OR (READEL_EpisodeType = :type))
ORDER   BY READEL_Desc
}

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "", type As %String = "") As %Boolean
{
}

Query LookUpWithTypeNC(desc As %String, date As %String, type As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT READEL_Desc,READEL_RowId,READEL_Code,READEL_NationalCode
FROM SQLUser.PAC_ReasonDelayDischarge
WHERE ((%ALPHAUP READEL_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP READEL_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((READEL_DateFrom <= :date OR READEL_DateFrom IS NULL) AND  (READEL_DateTo IS NULL OR READEL_DateTo >= :date)))
AND ((READEL_EpisodeType IS NULL) OR (:type IS NULL) OR (READEL_EpisodeType = :type))
ORDER   BY READEL_Desc
}

ClassMethod LookUpBrokerWithDateNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "", type As %String = "") As %Boolean
{
}

}
