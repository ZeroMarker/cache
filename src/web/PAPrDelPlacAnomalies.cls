Class web.PAPrDelPlacAnomalies Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpPlacAnomClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPlacAnomFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpPlacAnomExecute(ByRef QHandle As %Library.Binary, PlacId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod LookUpPlacAnomFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPlacAnomExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod websysSaveAll(PlacId As %Library.String, Items As %Library.String)
{
}

Parameter SQLCODE = "PDPA_RowId";

Parameter SQLDESCRIPTION = "PDPA_RowId";

Parameter SQLROWID = "PDPA_RowId";

Query Find(PlacId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,PLACANOM_Desc,PDPA_PlacAnomaly_DR")
{
SELECT 
PDPA_RowId, 
PDPA_PlacAnomaly_DR->PLACANOM_Desc, 
PDPA_PlacAnomaly_DR 
FROM SQLUser.PA_PrDelPlacAnomalies 
WHERE PDPA_ParRef = :PlacId
}

Query LookUpPlacAnom(PlaclId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelPlacAnomalies
}

}
