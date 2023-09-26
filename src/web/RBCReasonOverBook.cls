Include webimport

IncludeGenerator webimport

Class web.RBCReasonOverBook Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 91;

Parameter SQLCODE = "ROB_Code";

Parameter SQLDATEFROM = "ROB_DateFrom";

Parameter SQLDESCRIPTION = "ROB_Desc";

Parameter SQLDATETO = "ROB_DateTo";

Parameter SQLROWID = "ROB_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpReason(reason As %Library.String, date As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc,Code,HIDDEN")
{
	SELECT ROB_Desc,ROB_Code,ROB_RowId
	FROM SQLUser.RBC_ReasonOverBook
	WHERE ((%ALPHAUP ROB_Desc %STARTSWITH %ALPHAUP :reason) OR (%ALPHAUP ROB_Code = %ALPHAUP :reason) OR (:reason IS NULL))
	AND ((ROB_DateFrom < :date) OR (:date IS NULL) OR (ROB_DateFrom IS NULL))
	AND ((ROB_DateTo > :date) OR (:date IS NULL) OR (ROB_DateTo IS NULL))
}

ClassMethod LookUpReasonBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", reason As %Library.String, date As %Library.String) As %Library.Boolean
{
}

}
