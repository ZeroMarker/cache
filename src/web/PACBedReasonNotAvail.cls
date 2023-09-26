Class web.PACBedReasonNotAvail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 58;

Parameter SQLDATEFROM = "RNAV_DateFrom";

Parameter SQLDATETO = "RNAV_DateTo";

Parameter SQLCODE = "RNAV_Code";

Parameter SQLDESCRIPTION = "RNAV_Desc";

Parameter SQLROWID = "RNAV_RowId";

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT RNAV_Desc,RNAV_RowID,RNAV_Code
FROM SQLUser.PAC_BedReasonNotAvail
WHERE ((%ALPHAUP RNAV_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP RNAV_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((RNAV_DateFrom <= :date OR RNAV_DateFrom IS NULL) AND  (RNAV_DateTo IS NULL OR RNAV_DateTo >= :date)))
ORDER   BY RNAV_Desc
}

}
