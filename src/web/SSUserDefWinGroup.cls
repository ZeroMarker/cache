Class web.SSUserDefWinGroup Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WINGRP_Code";

Parameter SQLDESCRIPTION = "WINGRP_Desc";

Parameter SQLROWID = "WINGRP_RowId";

/// ab 3.05.06 - find by security group restriction, else return all
ClassMethod LookUpByGroupBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %String = "", GroupID As %String = "")
{
}

/// ab 3.05.06 - find by security group restriction, else return all
Query LookUpByGroup(val As %String, GroupID As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT WINGRP_Desc, WINGRP_RowId, WINGRP_Code
FROM SQLUser.SS_UserDefWinGroup
WHERE (
((%ALPHAUP WINGRP_Code = %ALPHAUP :val) OR (:val IS NULL))
OR ((%ALPHAUP WINGRP_Desc %STARTSWITH %ALPHAUP :val) OR (:val IS NULL)) )
AND (
	(:GroupID IS NULL)
	OR (WINGRP_RowId IN (SELECT RESRR_UDWGroup_DR->WINGRP_RowId FROM SQLUser.SS_GroupUDWGroup WHERE RESRR_ParRef->SSGRP_RowId = :GroupID))
	OR ((SELECT RESRR_UDWGroup_DR->WINGRP_RowId FROM SQLUser.SS_GroupUDWGroup WHERE RESRR_ParRef->SSGRP_RowId = :GroupID) IS NULL)
)
ORDER BY WINGRP_Desc
}

}
