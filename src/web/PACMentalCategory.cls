Class web.PACMentalCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

Parameter SQLDATEFROM = "MENTC_DateFrom";

Parameter SQLDATETO = "MENTC_DateTo";

Parameter SQLCODE = "MENTC_Code";

Parameter SQLDESCRIPTION = "MENTC_Desc";

Parameter SQLROWID = "MENTC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetDescFromId(rowid As %Library.String) As %Library.String
{
}

Query LookUpByName(MentalCat As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MCDesd,MCCode")
{
SELECT MENTC_Desc, MENTC_Code
FROM SQLUser.PAC_MentalCategory
ORDER BY	MENTC_Desc
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "MENTCDesc,MENTCCode,HIDDEN")
{
	SELECT	MENTC_Desc,MENTC_Code,MENTC_RowID
	FROM	SQLUser.PAC_MentalCategory
	WHERE	((MENTC_Desc %STARTSWITH :desc) OR (MENTC_Code = :desc))
	AND	((MENTC_DateFrom IS NULL) OR (MENTC_DateFrom<= :date))
	AND	((MENTC_DateTo IS NULL) OR (MENTC_DateTo>= :date))
	ORDER	BY MENTC_Desc
}

}
