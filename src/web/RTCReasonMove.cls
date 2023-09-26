Class web.RTCReasonMove Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpMoveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "MOVE_Code";

Parameter SQLDESCRIPTION = "MOVE_Desc";

Parameter SQLROWID = "MOVE_RowId";

Query LookUpMove(desc As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MOVEDesc:%String,MOVECode:%String")
{
SELECT MOVE_Desc, MOVE_Code
FROM SQLUser.RTC_Reason_Move
WHERE (MOVE_Desc  %STARTSWITH:desc) AND (MOVE_Active='Y')
ORDER BY MOVE_Desc
}

}
