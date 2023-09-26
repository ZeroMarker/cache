Class web.PACQualificationStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

Parameter SQLDATEFROM = "QUAL_DateFrom";

Parameter SQLDATETO = "QUAL_DateTo";

Parameter SQLCODE = "QUAL_Code";

Parameter SQLDESCRIPTION = "QUAL_Desc";

Parameter SQLROWID = "QUAL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT QUAL_Desc,QUAL_RowId,QUAL_Code
FROM SQLUser.PAC_QualificationStatus
WHERE ((%ALPHAUP QUAL_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP QUAL_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((QUAL_DateFrom <= :date OR QUAL_DateFrom IS NULL) AND  (QUAL_DateTo IS NULL OR QUAL_DateTo >= :date)))
ORDER   BY QUAL_Desc
}

}
