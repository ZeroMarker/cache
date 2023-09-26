Class web.PAPersonRoyalOrderHist Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HIS_RowId";

Parameter SQLDESCRIPTION = "HIS_RowId";

Parameter SQLROWID = "HIS_RowId";

Property dummy As %String(TRUNCATE = 1);

Query ROHist(PARREF As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT *
FROM SQLUser.PA_PersonRoyalOrderHist
WHERE HIS_ParRef->ROYAL_RowId = :PARREF
}

ClassMethod LookUpHistoryExecute(ByRef QHandle As %Library.Binary, PARREF As %Library.String) As %Library.Status
{
}

ClassMethod LookUpHistoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpHistoryExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpHistoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpHistoryFetch ]
{
}

Query LookUpHistory(PARREF As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIS_Date,HIS_Time,HIS_User_DR,HIS_ReasonForChange,HIS_AmtUsed,HIS_Status,HIS_IPDateValidFrom,HIS_IPDateValidTo,HIS_IPValidPeriod,HIS_IPValidPeriodUnits,HIS_OPDateValidFrom,HIS_OPDateValidTo,HIS_OPValidPeriod,HIS_OPValidPeriodUnits,HIS_PaysUntil,HIS_LetterStartDate,HIS_LetterExpiredDate,HIS_LetterPeriod,HIS_LetterPeriodUnit")
{
}

}
