Include webimport

IncludeGenerator webimport

Class web.PACCareType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 95;

Parameter SQLDATEFROM = "CARETYP_DateFrom";

Parameter SQLDATETO = "CARETYP_DateTo";

Parameter SQLCODE = "CARETYP_Code";

Parameter SQLDESCRIPTION = "CARETYP_Desc";

Parameter SQLROWID = "CARETYP_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CARETYP_Desc,CARETYP_RowId,CARETYP_Code
FROM SQLUser.PAC_CareType
WHERE ((%ALPHAUP CARETYP_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP CARETYP_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR
(((CARETYP_DateFrom <= :date) OR (CARETYP_DateFrom IS NULL)) AND  ((CARETYP_DateTo IS NULL) OR (CARETYP_DateTo >= :date))))
ORDER   BY CARETYP_Desc
}

}
