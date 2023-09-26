Include webimport

IncludeGenerator webimport

Class web.OECPriority Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 154;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OECPR_Code";

Parameter SQLDESCRIPTION = "OECPR_Desc";

Parameter SQLROWID = "OECPR_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetLTTestSetDefPriority(arcimid As %Library.String = "") As %Library.String
{
}

ClassMethod GetOrderDefPriority(arcimid As %Library.String = "", cPriority As %Library.String = "", dPriority As %Library.String = "", ordertype As %Library.String = "")
{
}

ClassMethod GetDefPriOnItem(arcimid As %Library.String = "")
{
}

ClassMethod GetSequenceOrder(ByRef sortlist As %Library.String)
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerOrdResPriority(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Query FindAll() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OECPRCode,OECPRDesc,OECPRPriority")
{
SELECT OECPR_RowID, OECPR_Code, OECPR_Desc, OECPR_Priority
FROM SQLUser.OEC_Priority
}

Query LookUpOrdResPriority(val As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "OECPRDesc , OECPRCode")
{
SELECT OECPR_Desc, OECPR_Code
FROM SQLUser.OEC_Priority
WHERE ((%ALPHAUP OECPR_Desc [ %ALPHAUP :val) OR (%ALPHAUP OECPR_Code [ %ALPHAUP :val) OR (:val IS NULL))
ORDER   BY OECPR_Desc
}

ClassMethod LookUpPriRecLocBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %String = "", adm As %String = "", arcim As %String = "", sttdate As %String = "", OEORISttTim As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpPriRecLocClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPriRecLocFetch ]
{
}

ClassMethod LookUpPriRecLocExecute(ByRef QHandle As %Library.Binary, desc As %String = "", adm As %String = "", arcim As %String = "", sttdate As %String = "", OEORISttTim As %String = "") As %Library.Status
{
}

ClassMethod LookUpPriRecLocFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPriRecLocExecute ]
{
}

Query LookUpPriRecLoc(desc As %String, adm As %String, arcim As %String, sttdate As %String, OEORISttTim As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "OECPRDesc:%String,OECPRCode:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// log 63684
ClassMethod GetPriorityLookupResult(OECPRDesc As %Library.String = "", EpisodeID As %Library.String = "", OEORIItmMastDR As %Library.String = "", OEORISttTim As %Library.String = "") As %Library.String
{
}

}
