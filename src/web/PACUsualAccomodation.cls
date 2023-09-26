Class web.PACUsualAccomodation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLDATEFROM = "USACC_DateFrom";

Parameter SQLDATETO = "USACC_DateTo";

Parameter SQLCODE = "USACC_Code";

Parameter SQLDESCRIPTION = "USACC_Desc";

Parameter SQLROWID = "USACC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpBroker1(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query LookUpNC(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT USACC_Desc,USACC_RowID,USACC_Code,USACC_NationalCode
FROM SQLUser.PAC_UsualAccomodation 
WHERE (USACC_Desc %STARTSWITH :desc)
OR (USACC_Code = :desc)
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "USACCDesc,USACCCode,HIDDEN")
{
	SELECT	USACC_Desc,USACC_Code,USACC_RowID
	FROM	SQLUser.PAC_UsualAccomodation
	WHERE	((USACC_Desc %STARTSWITH :desc) OR (USACC_Code = :desc))
	AND	((USACC_DateFrom IS NULL) OR (USACC_DateFrom<= :date))
	AND	((USACC_DateTo IS NULL) OR (USACC_DateTo>= :date))
	ORDER	BY USACC_Desc
}

ClassMethod LookUpDateBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

}
