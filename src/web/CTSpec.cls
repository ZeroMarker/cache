Class web.CTSpec Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 75;

Property Dummy As %Library.String(TRUNCATE = 1);

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "CTSPC_Code";

Parameter SQLDATEFROM = "CTSPC_DateFrom";

Parameter SQLDATETO = "CTSPC_DateTo";

Parameter SQLDESCRIPTION = "CTSPC_Desc";

Parameter SQLROWID = "CTSPC_RowId";

Query FindSpec(desc) As %SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String")
{
	SELECT CTSPC_Desc,CTSPC_Code
	FROM SQLUser.CT_Spec
    	WHERE (((%ALPHAUP CTSPC_Code %STARTSWITH %ALPHAUP  :desc) 
     		OR (%ALPHAUP CTSPC_Desc %STARTSWITH %ALPHAUP  :desc))
     		AND ((CTSPC_DateTo IS NULL)OR(CTSPC_DateTo >= CURRENT_DATE))
 			AND ((CTSPC_DateFrom IS NULL)OR(CTSPC_DateFrom <= CURRENT_DATE)))
     ORDER BY CTSPC_Desc
}

ClassMethod FindSpecBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %String = "") As %Library.Boolean
{
}

}
