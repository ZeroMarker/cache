Class web.PAPrDelBabyCongAnom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 37;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpCongAnomClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCongAnomFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpCongAnomExecute(ByRef QHandle As %Library.Binary, BabyId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod LookUpCongAnomFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCongAnomExecute ]
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

Parameter SQLCODE = "CA_RowId";

Parameter SQLDESCRIPTION = "CA_RowId";

Parameter SQLROWID = "CA_RowId";

Query Find(BabyId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,CONGANOM_Desc,CA_CongAnom_DR")
{
SELECT 
CA_RowId, 
CA_CongAnom_DR->CONGANOM_Desc, 
CA_CongAnom_DR 
FROM SQLUser.PA_PrDelBabyCongAnom 
WHERE CA_ParRef = :BabyId
}

Query LookUpCongAnom(BabylId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelBabyCongAnom
}

}
