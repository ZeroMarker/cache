Class web.PAPrDelBabyNeoMorb Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpNeoMorbClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpNeoMorbFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpNeoMorbExecute(ByRef QHandle As %Library.Binary, BabyId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod LookUpNeoMorbFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpNeoMorbExecute ]
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

ClassMethod websysSaveAll(BabyId As %Library.String, Items As %Library.String)
{
}

Parameter SQLCODE = "PDBNM_RowId";

Parameter SQLDESCRIPTION = "PDBNM_RowId";

Parameter SQLROWID = "PDBNM_RowId";

Query Find(BabyId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,NEOMORB_Desc,PDBNM_Morbidity_DR")
{
SELECT 
PDBNM_RowId, 
PDBNM_Morbidity_DR->NEOMORB_Desc, 
PDBNM_Morbidity_DR 
FROM SQLUser.PA_PrDelBabyNeoMorb
WHERE PDBNM_ParRef = :BabyId
}

Query LookUpNeoMorb(BabylId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelBabyNeoMorb
}

}
