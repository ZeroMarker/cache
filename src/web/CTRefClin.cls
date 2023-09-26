Include webimport

IncludeGenerator webimport

Class web.CTRefClin Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 101;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CTRFC_Code";

Parameter SQLDATEFROM = "CTRFC_DateFrom";

Parameter SQLDATETO = "CTRFC_DateTo";

Parameter SQLDESCRIPTION = "CTRFC_Desc";

Parameter SQLFILTER = "CTRFC_ActiveFlag ='Y'";

Parameter SQLROWID = "CTRFC_RowId";

ClassMethod LookUpDateBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	CTRFC_Desc,CTRFC_RowId,CTRFC_Code,CTRFC_VEMD
FROM	SQLUser.CT_RefClin
WHERE	(CTRFC_Desc %STARTSWITH :desc
OR      CTRFC_Code=:desc)
AND ((CTRFC_DateFrom <= CURRENT_DATE OR CTRFC_DateFrom IS NULL) AND (CTRFC_DateTo >= CURRENT_DATE OR CTRFC_DateTo IS NULL))
}

}
