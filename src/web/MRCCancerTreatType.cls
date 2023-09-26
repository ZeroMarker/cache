Class web.MRCCancerTreatType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Parameter SQLDATEFROM = "CANTT_DateFrom";

Parameter SQLDATETO = "CANTT_DateTo";

Parameter SQLCODE = "CANTT_Code";

Parameter SQLDESCRIPTION = "CANTT_Desc";

Parameter SQLROWID = "CANTT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CANTTDesc,CANTTCode,HIDDEN")
{
	SELECT	CANTT_Desc,CANTT_Code,CANTT_RowID
	FROM	SQLUser.MRC_CancerTreatType
	WHERE	((CANTT_Desc %STARTSWITH :desc) OR (CANTT_Code = :desc))
	AND	((CANTT_DateFrom IS NULL) OR (CANTT_DateFrom<= :date))
	AND	((CANTT_DateTo IS NULL) OR (CANTT_DateTo>= :date))
	ORDER	BY CANTT_Desc
}

}
