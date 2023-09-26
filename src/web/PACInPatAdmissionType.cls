Include webimport

IncludeGenerator webimport

Class web.PACInPatAdmissionType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 226;

Parameter SQLDATEFROM = "IPAT_DateFrom";

Parameter SQLDATETO = "IPAT_DateTo";

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "IPAT_Code";

Parameter SQLDESCRIPTION = "IPAT_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((IPAT_DateFrom <= CURRENT_DATE OR IPAT_DateFrom IS NULL) AND (IPAT_DateTo >= CURRENT_DATE OR IPAT_DateTo IS NULL))";

Parameter SQLROWID = "IPAT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetCodeFromId(id As %Library.String) As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerIPAT(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", OrganProcurement As %String = "", date As %String = "") As %Library.Boolean
{
}

Query LookUpWithDate(desc As %String, OrganProcurement As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT IPAT_Desc,IPAT_RowId,IPAT_Code
FROM SQLUser.PAC_InPatAdmissionType
WHERE ((%ALPHAUP IPAT_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP IPAT_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((IPAT_DateFrom <= :date OR IPAT_DateFrom IS NULL) AND  (IPAT_DateTo IS NULL OR IPAT_DateTo >= :date)))
ORDER   BY IPAT_Desc
}

}
