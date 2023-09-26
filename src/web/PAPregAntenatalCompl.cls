Class web.PAPregAntenatalCompl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PANC_RowId";

Parameter SQLDESCRIPTION = "PANC_RowId";

Parameter SQLROWID = "PANC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod LookUpPreComplClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPreComplFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpPreComplExecute(ByRef QHandle As %Library.Binary, PregId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	quit $$$OK
}

ClassMethod LookUpPreComplFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPreComplExecute ]
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

ClassMethod websysSaveAll(PregId As %Library.String, Items As %Library.String)
{
}

Query Find(PregId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,PREPRO_Desc,PANC_Complication_DR")
{
SELECT 
PANC_RowId, 
PANC_Complication_DR->PREPRO_Desc, 
PANC_Complication_DR 
FROM SQLUser.PA_PregAntenatalCompl
WHERE PANC_ParRef = :PregId
}

Query LookUpPreCompl(PregId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
