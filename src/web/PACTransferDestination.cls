Include webimport

IncludeGenerator webimport

Class web.PACTransferDestination Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 91;

Parameter SQLDATEFROM = "TRD_DateFrom";

Parameter SQLDATETO = "TRD_DateTo";

Parameter SQLCODE = "TRD_Code";

Parameter SQLDESCRIPTION = "TRD_Desc";

Parameter SQLFILTER = "((TRD_DateFrom <= CURRENT_DATE OR TRD_DateFrom IS NULL) AND (TRD_DateTo >= CURRENT_DATE OR TRD_DateTo IS NULL))";

Parameter SQLROWID = "TRD_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT TRD_Desc,TRD_RowId,TRD_Code
FROM SQLUser.PAC_TransferDestination
WHERE ((%ALPHAUP TRD_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP TRD_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((TRD_DateFrom <= :date OR TRD_DateFrom IS NULL) AND  (TRD_DateTo IS NULL OR TRD_DateTo >= :date)))
ORDER   BY TRD_Desc
}

ClassMethod LookUpBrokerWithDateNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDateNC(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT TRD_Desc,TRD_RowId,TRD_Code,TRD_NationalCode
FROM SQLUser.PAC_TransferDestination
WHERE ((%ALPHAUP TRD_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP TRD_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((TRD_DateFrom <= :date OR TRD_DateFrom IS NULL) AND  (TRD_DateTo IS NULL OR TRD_DateTo >= :date)))
ORDER   BY TRD_Desc
}

}
