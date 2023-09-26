Class web.PACSNAPPhases Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM = "SNAPPH_DateFrom";

Parameter SQLDATETO = "SNAPPH_DateTo";

Parameter SQLCODE = "SNAPPH_Code";

Parameter SQLDESCRIPTION = "SNAPPH_Desc";

Parameter SQLROWID = "SNAPPH_RowId";

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", rdate As %Date) As %Boolean
{
}

Query LookUpWithDate(desc As %String, rdate As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SNAPPHDesc,HIDDEN,SNAPPHCode")
{
SELECT	SNAPPH_Desc,SNAPPH_RowID,SNAPPH_Code
FROM	SQLUser.PAC_SNAPPhases
WHERE	((SNAPPH_Desc %STARTSWITH :desc) OR (SNAPPH_Code = :desc))
AND	((SNAPPH_DateFrom IS NULL) OR (SNAPPH_DateFrom<= :rdate))
AND	((SNAPPH_DateTo IS NULL) OR (SNAPPH_DateTo>= :rdate))
ORDER	BY SNAPPH_Desc
}

}
