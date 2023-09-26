Class web.CTAddrType Extends (%Library.Persistent, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 107;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "CTADR_Code";

Parameter SQLDATEFROM = "CTADR_DateFrom";

Parameter SQLDESCRIPTION = "CTADR_Desc";

Parameter SQLDATETO = "CTADR_DateTo";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTADR_DateFrom <= CURRENT_DATE OR CTADR_DateFrom IS NULL) AND (CTADR_DateTo >= CURRENT_DATE OR CTADR_DateTo IS NULL))";

Parameter SQLROWID = "CTADR_RowId";

ClassMethod LookUpBrokerRestricted(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", viewflag As %String = "0", cdate As %String = "") As %Boolean
{
}

Query LookUpRestricted(desc As %String, viewflag As %String, cdate As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CTADR_Desc,CTADR_RowId,CTADR_Code
FROM SQLUser.CT_AddrType
WHERE ((%ALPHAUP CTADR_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP CTADR_Code = %ALPHAUP :desc))
AND ((%ALPHAUP CTADR_Code = %ALPHAUP :viewflag) OR (CTADR_RestrictFromLookUp<>'Y' OR CTADR_RestrictFromLookUp IS NULL))
AND ((CTADR_DateFrom <= CURRENT_DATE OR CTADR_DateFrom IS NULL) AND (CTADR_DateTo >= CURRENT_DATE OR CTADR_DateTo IS NULL))
ORDER   BY CTADR_Desc
}

}
