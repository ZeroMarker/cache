Class web.PACDischClassification Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM = "DSCL_DateFrom";

Parameter SQLDATETO = "DSCL_DateTo";

Parameter SQLCODE = "DSCL_Code";

Parameter SQLDESCRIPTION = "DSCL_Desc";

Parameter SQLFILTER = "((DSCL_DateFrom <= CURRENT_DATE OR DSCL_DateFrom IS NULL) AND (DSCL_DateTo >= CURRENT_DATE OR DSCL_DateTo IS NULL))";

Parameter SQLROWID = "DSCL_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetImage(ID As %Library.String, PARAMS As %Library.String, ByRef imgLIST As %Library.String)
{
}

ClassMethod LookUpDateBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

Query LookUpNC(desc As %String, tdate As %Library.String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	DSCL_Desc,DSCL_RowId,DSCL_Code,DSCL_NationalCode
FROM	SQLUser.PAC_DischClassification
WHERE	(DSCL_Desc %STARTSWITH :desc
OR      DSCL_Code=:desc)
AND ((:tdate IS NULL) OR ((DSCL_DateFrom IS NULL OR DSCL_DateFrom <= :tdate) AND (DSCL_DateTo IS NULL OR DSCL_DateTo >= :tdate)))
}

}
