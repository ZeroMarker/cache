Class web.CTSignificantFacility Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 77;

Parameter SQLDATEFROM = "SIGNF_DateFrom";

Parameter SQLDATETO = "SIGNF_DateTo";

Parameter SQLCODE = "SIGNF_Code";

Parameter SQLDESCRIPTION = "SIGNF_Desc";

Parameter SQLROWID = "SIGNF_RowId";

ClassMethod LookUpPRS2Broker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpPRS2Close(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPRS2Fetch ]
{
}

ClassMethod LookUpPRS2Execute(ByRef QHandle As %Library.Binary, desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpPRS2Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPRS2Execute ]
{
}

/// / KK 14/Jul/2003 Log 35348 LookUp Query and Broker implemented for SignificantFacility based on Logon Hospital
ClassMethod LookUpSigniFacilitytBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", hospid As %String = "") As %Library.Boolean
{
}

Query LookUpSigniFacility(val As %String = "", hospid As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "HIDDEN:%String,SIGNFDesc:%String,SIGNFCode:%String")
{
	SELECT DISTINCT CTLOC_SignifFacility_DR,CTLOC_SignifFacility_DR->SIGNF_Desc,CTLOC_SignifFacility_DR->SIGNF_Code
	FROM  SQLUser.CT_Loc 
	WHERE CTLOC_Hospital_DR=:hospid 
	AND (CTLOC_SignifFacility_DR is not null)
	AND ((%UPPER CTLOC_SignifFacility_DR->SIGNF_Desc [ %UPPER :val) OR (%UPPER CTLOC_SignifFacility_DR->SIGNF_Code [ %UPPER :val))
}

Query LookUpPRS2(desc As %Library.String = "") As %Library.Query(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
}

}
