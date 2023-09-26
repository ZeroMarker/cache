Class web.PACFreqAttendActions Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "FAA_Code";

Parameter SQLDATEFROM = "FAA_DateFrom";

Parameter SQLDATETO = "FAA_DateTo";

Parameter SQLDESCRIPTION = "FAA_Desc";

Parameter SQLROWID = "FAA_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckIfMandatory(PCode As %String = "") As %String
{
}

ClassMethod LookUpBrokerByFlag(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpFlag(desc As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "FAA_Desc,Hidden,FAA_Code,Hidden")
{
	SELECT	FAA_Desc,FAA_RowId,FAA_Code,FAA_CommentsMandatory
FROM	SQLUser.PAC_FreqAttendActions
WHERE	((%ALPHAUP FAA_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP FAA_Code = %ALPHAUP :desc) OR (:desc IS NULL))
AND	((FAA_DateFrom <= CURRENT_DATE OR FAA_DateFrom IS NULL) AND (FAA_DateTo >= CURRENT_DATE OR FAA_DateTo IS NULL))
}

}
