Class web.PAAdmUnavailable Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 285;

Parameter SQLDATEFROM = "UNAV_DateFrom";

Parameter SQLDATETO = "UNAV_DateTo";

Parameter SQLCODE = "UNAV_RowId";

Parameter SQLDESCRIPTION = "UNAV_RowId";

Parameter SQLROWID = "UNAV_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod CheckValidDates(compref As %Library.String, id As %Library.String = "") As %Library.Boolean
{
}

/// ab 10.07.02
/// returns if a patient is available or not
ClassMethod IsAvailable(EpisodeID As %Library.String = "", day As %Library.String = "") As %Library.Boolean
{
}

ClassMethod IsAvailableFrom(EpisodeID As %Library.String, RefDate As %Library.Date = "") As %Library.String
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// ab 11.12.03 40017 - used to run brokers on update, for checking start/end dates on existing data
ClassMethod ValidateCodeTableDates(compid As %String, id As %String = "") As %String
{
}

ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

Query Find(EpisodeID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "UNAV_RowID,UNAV_DateFrom,UNAV_DateTo,UNAV_ReasonText,REA_Desc")
{
SELECT UNAV_RowID, UNAV_DateFrom, UNAV_DateTo, UNAV_ReasonText,
UNAV_Reason_DR->REA_Desc
FROM SQLUser.PA_AdmUnavailable
WHERE UNAV_ParRef=:EpisodeID
ORDER BY	UNAV_DateFrom DESC, UNAV_DateTo DESC
}

}
