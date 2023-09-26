Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCANArnursebyroom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1060;

/// d ##class(%ResultSet).RunQuery("web.DHCANArnursebyroom","FindArList","","","","","")
Query FindArList(stdate As %String = "", enddate As %String = "", oproom As %String = "", scrubnurse As %String = "", circulnurse As %String = "") As %Query(ROWSPEC = "oproomdr,sttdate,eddate,room,scrstr,cirstr")
{
}

ClassMethod FindArListExecute(ByRef qHandle As %Binary, stdate As %String = "", enddate As %String = "", oproom As %String = "", scrubnurse As %String = "", circulnurse As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    if (stdate="")!(enddate="") s sdate=+$H,edate=+$H
    e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
    s oproomdr=""
    f  s oproomdr=$o(^DHCANArNurseList(oproomdr))  q:oproomdr=""  d
    .i oproom'="" q:oproomdr'=oproom
    .s sttdate=$zd($p($g(^DHCANArNurseList(oproomdr)),"^",2),3)
    .s eddate=$zd($p($g(^DHCANArNurseList(oproomdr)),"^",3),3)
    .s room=$p($g(^DHCANArNurseList(oproomdr)),"^",1)
    .s scrnurdr=$p($g(^DHCANArNurseList(oproomdr)),"^",4)
    .s scrlen=$l(scrnurdr,",")
    .s scrstr=""
    .f scrnum=1:1:scrlen  d
    ..s scrdr=$p((scrnurdr),",",scrnum)
    ..s scrdesc=##class(web.DHCANOPCom).GetNameById(scrdr)
    ..i scrstr="" s scrstr=scrdesc
    ..e  s scrstr=scrstr_","_scrdesc
    .s cirnurdr=$p($g(^DHCANArNurseList(oproomdr)),"^",5)
    .s cirlen=$l(cirnurdr,",")
    .s cirstr=""
    .f cirnum=1:1:cirlen  d
    ..s cirdr=$p((cirnurdr),",",cirnum)
    ..s cirdesc=##class(web.DHCANOPCom).GetNameById(cirdr)
    ..i cirstr="" s cirstr=cirdesc
    ..e  s cirstr=cirstr_","_cirdesc
    .do OutRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutRow
 	set Data=$lb(oproomdr,sttdate,eddate,room,scrstr,cirstr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindArListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindArListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##Class(web.DHCANArnursebyroom).SetArList("","","1","1468,3754","791,3722")
ClassMethod SetArList(stdate As %String, enddate As %String, oproomdr As %String, scrubnursedr As %String, circulnursedr As %String) As %Query(ROWSPEC="")
{
	if (stdate="")!(enddate="") s sdate=+$H,edate=+$H
    e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate)
    s oproom=$p(^DHCANC("OPRoom",oproomdr),"^",2)
    i (oproom'="门")&&(oproom'="急")&&(oproom'="介")  s oproom=oproom_"间"
    s ^DHCANArNurseList(oproomdr)=oproom_"^"_sdate_"^"_edate_"^"_scrubnursedr_"^"_circulnursedr
	q 0
}

ClassMethod DeleteArList(oproomdr As %String) As %Query(ROWSPEC="")
{
	q:oproomdr=""
    k ^DHCANArNurseList(oproomdr)
	q 0
}

/// w ##Class(web.DHCANArnursebyroom).GetArList("113")
ClassMethod GetArList(oproomdr)
{
    s sttdate=$zd($p($g(^DHCANArNurseList(oproomdr)),"^",2),3)
    s eddate=$zd($p($g(^DHCANArNurseList(oproomdr)),"^",3),3)
    s room=$p($g(^DHCANArNurseList(oproomdr)),"^",1)
    s scrnurdr=$p($g(^DHCANArNurseList(oproomdr)),"^",4)
    s scrlen=$l(scrnurdr,",")
    s scrstr=""
    f scrnum=1:1:scrlen  d
    .s scrdr=$p((scrnurdr),",",scrnum)
    .s scrdesc=##class(web.DHCANOPCom).GetNameById(scrdr)
    .i scrstr="" s scrstr=scrdesc
    .e  s scrstr=scrstr_","_scrdesc
    s cirnurdr=$p($g(^DHCANArNurseList(oproomdr)),"^",5)
    s cirlen=$l(cirnurdr,",")
    s cirstr=""
    f cirnum=1:1:cirlen  d
    .s cirdr=$p((cirnurdr),",",cirnum)
    .s cirdesc=##class(web.DHCANOPCom).GetNameById(cirdr)
    .i cirstr="" s cirstr=cirdesc
    .e  s cirstr=cirstr_","_cirdesc
    s retstr=oproomdr_"^"_sttdate_"^"_eddate_"^"_room_"^"_scrstr_"^"_cirstr_"^"_scrnurdr_"^"_cirnurdr
    q retstr
}

}
