Include webimport

IncludeGenerator webimport

Class web.PACAdmReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 99;

Parameter SQLCODE = "REA_Code";

Parameter SQLDATEFROM = "REA_DateFrom";

Parameter SQLDATETO = "REA_DateTo";

Parameter SQLDESCRIPTION = "REA_Desc";

Parameter SQLROWID = "REA_RowId";

Property dummy As %String(TRUNCATE = 1);

/// ab 1.09.04 - 46035 - overriden for validation check
ClassMethod LookUpDateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

ClassMethod LookUpDateBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	REA_Desc,REA_RowId,REA_Code,REA_NationalCode 
FROM	SQLUser.PAC_AdmReason
WHERE	(REA_Desc %STARTSWITH :desc
OR      REA_Code=:desc)
AND ((REA_DateFrom <= CURRENT_DATE OR REA_DateFrom IS NULL) AND (REA_DateTo >= CURRENT_DATE OR REA_DateTo IS NULL))
}

}
