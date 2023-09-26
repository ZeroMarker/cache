Class web.PACDischargeTransport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 76;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "TRANSP_Code";

Parameter SQLDATEFROM = "TRANSP_DateFrom";

Parameter SQLDATETO = "TRANSP_DateTo";

Parameter SQLDESCRIPTION = "TRANSP_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((TRANSP_DateFrom <= CURRENT_DATE OR TRANSP_DateFrom IS NULL) AND (TRANSP_DateTo >= CURRENT_DATE OR TRANSP_DateTo IS NULL))";

Parameter SQLROWID = "TRANSP_RowId";

ClassMethod GetImage(ID As %Library.String, PARAMS As %Library.String, ByRef imgLIST As %Library.String)
{
}

ClassMethod LookUpDateBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	TRANSP_Desc,TRANSP_RowId,TRANSP_Code,TRANSP_NationalCode
FROM	SQLUser.PAC_DischargeTransport
WHERE	(TRANSP_Desc %STARTSWITH :desc
OR      TRANSP_Code=:desc)
AND ((TRANSP_DateFrom <= CURRENT_DATE OR TRANSP_DateFrom IS NULL) AND (TRANSP_DateTo >= CURRENT_DATE OR TRANSP_DateTo IS NULL))
}

}
