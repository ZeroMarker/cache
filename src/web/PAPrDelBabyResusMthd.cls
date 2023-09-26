Class web.PAPrDelBabyResusMthd Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 34;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpResusClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpResusFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpResusExecute(ByRef QHandle As %Library.Binary, BabyId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod LookUpResusFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpResusExecute ]
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

Parameter SQLCODE = "PDBRM_RowId";

Parameter SQLDESCRIPTION = "PDBRM_RowId";

Parameter SQLROWID = "PDBRM_RowId";

Query Find(BabyId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,RESUSMTH_Desc,PDBRM_ResusMthd_DR")
{
SELECT 
PDBRM_RowId, 
PDBRM_ResusMthd_DR->RESUSMTH_Desc, 
PDBRM_ResusMthd_DR 
FROM SQLUser.PA_PrDelBabyResusMthd 
WHERE PDBRM_ParRef = :BabyId
}

Query LookUpResus(BabylId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
SELECT 
FROM PAPrDelBabyResusMthd
}

}
