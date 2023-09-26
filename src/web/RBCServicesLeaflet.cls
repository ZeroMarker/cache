Class web.RBCServicesLeaflet Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLCODE = "LFT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLDATEFROM = "LFT_DateFrom";

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", service As %Library.String = "", locid As %Library.String = "") As %Library.Boolean
{
}

Query LookUpWithService(leaflet As %String = "", service As %String = "", locid As %String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
	SELECT LFT_Leaflet_DR->LFT_Desc,LFT_Leaflet_DR->LFT_RowId,LFT_Leaflet_DR->LFT_Code
	FROM SQLUser.RBC_ServicesLeaflet
	WHERE  (%ALPHAUP LFT_ParRef->SER_Desc= %ALPHAUP :service )
	AND ((LFT_ParRef->SER_CTLOC_DR=:locid) OR (LFT_ParRef->SER_CTLOC_DR IS NULL))
	AND ((%ALPHAUP LFT_Leaflet_DR->LFT_Desc %startswith %ALPHAUP :leaflet) OR (%ALPHAUP LFT_Leaflet_DR->LFT_Code = %ALPHAUP :leaflet))
}

Parameter SQLDATETO = "LFT_DateTo";

Parameter SQLDESCRIPTION = "LFT_RowId";

Parameter SQLROWID = "LFT_RowId";

}
