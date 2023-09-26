Include webimport

IncludeGenerator webimport

Class web.PACVisitType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "VST_Code";

Parameter SQLDATEFROM = "VST_DateFrom";

Parameter SQLDATETO = "VST_DateTo";

Parameter SQLDESCRIPTION = "VST_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((VST_DateFrom <= CURRENT_DATE OR VST_DateFrom IS NULL) AND (VST_DateTo >= CURRENT_DATE OR VST_DateTo IS NULL))";

Parameter SQLROWID = "VST_RowId";

ClassMethod GetCodeFromId(id As %Library.String)
{
}

ClassMethod LookUpDateBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	VST_Desc,VST_RowId,VST_Code,VST_NationalCode
FROM	SQLUser.PAC_VisitType
WHERE	(VST_Desc %STARTSWITH :desc
OR      VST_Code=:desc)
AND ((VST_DateFrom <= CURRENT_DATE OR VST_DateFrom IS NULL) AND (VST_DateTo >= CURRENT_DATE OR VST_DateTo IS NULL))
}

}
