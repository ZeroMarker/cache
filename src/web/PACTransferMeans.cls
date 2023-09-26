Include webimport

IncludeGenerator webimport

Class web.PACTransferMeans Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "TRANSM_Code";

Parameter SQLDATEFROM = "TRANSM_DateFrom";

Parameter SQLDATETO = "TRANSM_DateTo";

Parameter SQLDESCRIPTION = "TRANSM_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((TRANSM_DateFrom <= CURRENT_DATE OR TRANSM_DateFrom IS NULL) AND (TRANSM_DateTo >= CURRENT_DATE OR TRANSM_DateTo IS NULL))";

Parameter SQLROWID = "TRANSM_RowId";

ClassMethod LookUpDateBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %Library.String = "") As %Library.Boolean [ PlaceAfter = GetIdFromDateCodeOrDesc ]
{
}

Query LookUpNC(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN")
{
SELECT	TRANSM_Desc,TRANSM_RowId,TRANSM_Code,TRANSM_NationalCode
FROM	SQLUser.PAC_TransferMeans
WHERE	(TRANSM_Desc %STARTSWITH :desc
OR      TRANSM_Code=:desc)
AND ((TRANSM_DateFrom <= CURRENT_DATE OR TRANSM_DateFrom IS NULL) AND (TRANSM_DateTo >= CURRENT_DATE OR TRANSM_DateTo IS NULL))
}

}
