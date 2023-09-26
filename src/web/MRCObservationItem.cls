Include webimport

IncludeGenerator webimport

Class web.MRCObservationItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 121;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// Log 46462 - multiple itemtypes can be passed in (N,T,E,C,L - numeric, text, external, calculated, lookup)
ClassMethod LookUpBrokerByType(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", types As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "ITM_Code";

Parameter SQLDESCRIPTION = "ITM_Desc";

Parameter SQLROWID = "ITM_RowId";

Query FindEMR(itemid As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ITMDesc")
{
SELECT ITM_Rowid,ITM_Desc
FROM MRC_ObservationItem
WHERE ITM_Rowid = :itemid
}

Query List() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ITMDesc:%String")
{
SELECT ITM_Desc, ITM_Rowid
FROM MRC_ObservationItem
}

/// Log 46462 - multiple itemtypes can be passed in (N,T,E,C,L - numeric, text, external, calculated, lookup)
Query LookUpByType(itemdesc As %String, itemtypes As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "ITMDesc,ITMCode,HIDDEN,ITMType")
{
SELECT ITM_Desc,ITM_Code,ITM_Rowid,ITM_InputType
FROM MRC_ObservationItem
WHERE (ITM_Desc %STARTSWITH :itemdesc)
AND (((:itemtypes)[(ITM_InputType)) OR (:itemtypes IS NULL))
ORDER BY	ITM_Desc
}

}
