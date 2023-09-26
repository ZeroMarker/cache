Include webimport

IncludeGenerator webimport

Class web.PACCardType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 100;

Parameter SQLDATEFROM = "CARD_DateFrom";

Parameter SQLDATETO = "CARD_DateTo";

Parameter SQLCODE = "CARD_Code";

Parameter SQLDESCRIPTION = "CARD_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CARD_DateFrom <= CURRENT_DATE OR CARD_DateFrom IS NULL) AND (CARD_DateTo >= CURRENT_DATE OR CARD_DateTo IS NULL))";

Parameter SQLROWID = "CARD_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CARDDesc,CARDCode,HIDDEN")
{
	SELECT	CARD_Desc,CARD_Code,CARD_RowID
	FROM	SQLUser.PAC_CardType
	WHERE	((CARD_Desc %STARTSWITH :desc) OR (CARD_Code = :desc))
	AND	((CARD_DateFrom IS NULL) OR (CARD_DateFrom<= :date))
	AND	((CARD_DateTo IS NULL) OR (CARD_DateTo>= :date))
	ORDER	BY CARD_Desc
}

}
