Class web.PACRoomType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM = "ROOMT_DateFrom";

Parameter SQLDATETO = "ROOMT_DateTo";

Parameter SQLCODE = "ROOMT_Code";

Parameter SQLDESCRIPTION = "ROOMT_Desc";

Parameter SQLROWID = "ROOMT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT ROOMT_Desc,ROOMT_RowID,ROOMT_Code
FROM SQLUser.PAC_RoomType
WHERE ((%ALPHAUP ROOMT_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP ROOMT_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((ROOMT_DateFrom <= :date OR ROOMT_DateFrom IS NULL) AND  (ROOMT_DateTo IS NULL OR ROOMT_DateTo >= :date)))
ORDER   BY ROOMT_Desc
}

}
