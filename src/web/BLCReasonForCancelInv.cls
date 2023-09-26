Include webimport

IncludeGenerator webimport

Class web.BLCReasonForCancelInv Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 39;

Parameter SQLDATEFROM = "RFC_DateFrom";

Parameter SQLDATETO = "RFC_DateTo";

Parameter SQLCODE = "RFC_Code";

Parameter SQLDESCRIPTION = "RFC_Desc";

Parameter SQLROWID = "RFC_RowId";

ClassMethod LookUpRFCBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpRFC(val As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,code:%String")
{
	SELECT RFC_Desc,RFC_Code
	FROM SQLUser.BLC_ReasonForCancelInv
	WHERE (((%ALPHAUP RFC_Desc %STARTSWITH %ALPHAUP :val) OR ( %ALPHAUP RFC_Code = %ALPHAUP :val) OR (:val IS NULL))
	AND (RFC_DateFrom <= CURRENT_DATE OR RFC_DateFrom IS NULL)
	AND (RFC_DateTo >= CURRENT_DATE OR RFC_DateTo IS NULL))
}

}
