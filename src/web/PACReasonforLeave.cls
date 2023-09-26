Class web.PACReasonforLeave Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RFL_Code";

Parameter SQLDESCRIPTION = "RFL_Desc";

Parameter SQLROWID = "RFL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT RFL_Desc,RFL_RowId,RFL_Code
FROM SQLUser.PAC_Reason_For_Leave
WHERE ((%ALPHAUP RFL_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP RFL_Code = %ALPHAUP :desc))
ORDER   BY RFL_Desc
}

///  AND ((:date IS NULL) OR ((RFL_DateFrom <= :date OR RFL_DateFrom IS NULL) AND  (RFL_DateTo IS NULL OR RFL_DateTo >= :date)))

}
