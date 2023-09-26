Class web.PACRoom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM = "ROOM_DateFrom";

Parameter SQLDATETO = "ROOM_DateTo";

Parameter SQLCODE = "ROOM_Code";

Parameter SQLDESCRIPTION = "ROOM_Desc";

Parameter SQLROWID = "ROOM_RowID";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT ROOM_Desc,ROOM_RowID,ROOM_Code
FROM SQLUser.PAC_Room
WHERE ((%ALPHAUP ROOM_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP ROOM_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((ROOM_DateFrom <= :date OR ROOM_DateFrom IS NULL) AND  (ROOM_DateTo IS NULL OR ROOM_DateTo >= :date)))
ORDER   BY ROOM_Desc
}

}
