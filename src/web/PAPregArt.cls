Class web.PAPregArt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 30;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PARM_RowId";

Parameter SQLDESCRIPTION = "PARM_RowId";

Parameter SQLROWID = "PARM_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpArtClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpArtFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpArtExecute(ByRef QHandle As %Library.Binary, PregId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	n repid
    s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s ^CacheTemp(repid,ind)=$lb()
	s ind=ind+1
	quit $$$OK
}

ClassMethod LookUpArtFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpArtExecute ]
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

Query Find(PregId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ART_Desc,PARM_Method_DR")
{
SELECT 
PARM_RowId, 
PARM_Method_DR->Art_Desc, 
PARM_Method_DR 
FROM SQLUser.PA_PregArt
WHERE PARM_ParRef = :PregId
}

Query LookUpArt(PregId As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
