Class DWR.DoctorComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getordaction()
{

 //s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
}

ClassMethod GetOEID(other As %String) As %String
{
  //w ##class(DWR.DoctorComm).GetOEID()
	   s other="6^16^100^"
		s flag=-1
		s userid=$p(other,"^",1)
		s ctlocid=$p(other,"^",2)
		s groupid=$p(other,"^",3)
	    s EpisodeId=$p(other,"^",4)

		s p1="ORDER"
		s p2="OEOrder.PrefTabs.EditList"
		s p3="User.SSUser"
		s p4="User.CTLoc"
		s p5="User.SSGroup"
        s id=""
		&sql(select max(ID) into:id from websys.Preferences where AppSubKey=:p2 and ObjectType=:p3 and ObjectReference=:userid)
		//s params=##Class(websys.Preferences).GetDataExPlus(userid,groupid,"",ctlocid,"",p3,p1,p2)
		//取出id
		i id="" d  //科室
		.&sql(select max(ID) into:id from websys.Preferences where AppSubKey=:p2 and ObjectType=:p4 and ObjectReference=:ctlocid)
		i id="" d  //安全组
		.&sql(select max(ID) into:id from websys.Preferences where AppSubKey=:p2 and ObjectType=:p5 and ObjectReference=:groupid)
		q:(id="") flag
        q id
}

ClassMethod GetOETabs1(tabid) As %String
{
  //w ##class(DWR.DoctorComm).GetOETabs()
		s compref=""
	    ;站点与上下文关系可以不管
	    s pref =##class(websys.Preferences).%OpenId(tabid)
	    s compref = pref.Data
		s comprefall=$LIST(compref,3)
	    s groupll=$LL(comprefall)
		f i=1:1:groupll d
		.s groupone=$LIST(comprefall,i)
		.s nodeName=$p(groupone,$C(1),1)
		.i nodeName'="" s OETabsOne(nodeName)=i
		
		s head=""
		s node="" f  s node=$O(OETabsOne(node)) q:node=""  d
		.s tabIndex=$G(OETabsOne(node))
		.s groupone=$LIST(comprefall,tabIndex)
		.s nodeName=$p(groupone,$C(1),1)
		.w !,nodeName,tabIndex
}

ClassMethod GetOETabsExecute(ByRef qHandle As %Binary, id As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s compref=""
	;站点与上下文关系可以不管
    s pref =##class(websys.Preferences).%OpenId(id)
    s compref = pref.Data
	s comprefall=$LIST(compref,3)
    s groupll=$LL(comprefall)
	f i=1:1:groupll d
	.s groupone=$LIST(comprefall,i)
	.s nodeName=$p(groupone,$C(1),1)
	.i nodeName'="" s OETabsOne(nodeName)=i
	
	s head=""
	s node="" f  s node=$O(OETabsOne(node)) q:node=""  d
	.s tabIndex=$G(OETabsOne(node))
	.s groupone=$LIST(comprefall,tabIndex)
	.s nodeName=$p(groupone,$C(1),1)
	.d out1
	
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
	
out1
	set Data=$lb(tabIndex,nodeName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOETabsItemExecute(ByRef qHandle As %Binary, parrm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=$P(parrm,"^")
 	s tabid=$P(parrm,"^",2)
 	s ls=$P(parrm,"^",3)
	//listIndex_$C(2)_j_$C(2)_arcname_$C(2)_row_$C(2)_typ_$C(2)_qty
    s rw=""  f  s rw=$O(^TMP("tmp",id,tabid,ls,rw)) q:rw=""  d
    .s ListId=$P(^TMP("tmp",id,tabid,ls,rw),$C(2),1)
    .s ArcimName=$P(^TMP("tmp",id,tabid,ls,rw),$C(2),3)
    .s ArcimId=$P(^TMP("tmp",id,tabid,ls,rw),$C(2),4)
    .s ArcTyp=$P(^TMP("tmp",id,tabid,ls,rw),$C(2),5)
    .s Qty=$P(^TMP("tmp",id,tabid,ls,rw),$C(2),6)
    .d out1
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
	
out1
	set Data=$lb(ArcimName,ArcimId,ArcTyp,Qty,ListId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOETabsItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOETabsItemExecute ]
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

ClassMethod GetOETabsItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOETabsItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetOETabsItem(parrm As %String) As %Query(ROWSPEC = "ArcimName,ArcimId,ArcTyp,Qty,ListId")
{
}

ClassMethod getoetabitem(other As %String) As %String
{
  //s a=##class(DWR.DoctorComm).getoetabitem()
  // s other="246^3^"
     s ret=""
	s id=$p(other,"^",1)
	s tabIndex=$p(other,"^",2)
	s EpisodeId=$p(other,"^",3)
	k ^TMP("tmp",id)
 
	q:id="" ""
    s pref =##class(websys.Preferences).%OpenId(id)
    s compref = pref.Data
	s comprefAll=$LIST(compref,3)
	s groupOne=$LIST(comprefAll,tabIndex)
	s listLen=$L(groupOne,$C(1))
	f i=2:1:listLen d
	.s listStr=$P(groupOne,$C(1),i)
	.s headName=$P(listStr,$C(28),1)
	.s listIndex=i-1
	.s arcLen=$L(listStr,$C(28))
	.s ^TMP("tmp",id,tabIndex,listIndex)=headName
	.s ret=ret_listIndex_"^"_headName_"|"
	.f j=2:1:arcLen d
	..s listOne=$P(listStr,$C(28),j)
	..s typ=$P(listOne,$C(4))
	..s row=$P(listOne,$C(4),2)
	..s mp=$P(row,"||"),chl=$P(row,"||",2)
	..s qty=1
	..s arcStr=""
	..i (typ="ARCIM") d
	...s catdr=$P(^ARCIM(mp,chl,1),"^",10)
	...s ordtyp=##class(web.DHCPdaComm).GetOrdType(catdr)
	...i ordtyp="R" s qty=##class(web.DHCPdaComm).stockenough(EpisodeId,row)
	...i qty>0 s qty=1
	..i (typ="ARCIM") d
	...q:$G(^ARCIM(mp,chl,1))=""
	...s arcname=$P($G(^ARCIM(mp,chl,1)),"^",2)
	...s arcStr=listIndex_$C(2)_j_$C(2)_arcname_$C(2)_row_$C(2)_typ_$C(2)_qty
	..i (typ="ARCOS") d
	...q:$G(^ARCOS(row))=""
	...s arcos=$P(^ARCOS(row),"^",2)
	...s arcStr=listIndex_$C(2)_j_$C(2)_arcos_$C(2)_row_$C(2)_typ_$C(2)_qty
	..q:arcStr=""
	..s ^TMP("tmp",id,tabIndex,listIndex,j)=arcStr
   q ret
}

ClassMethod GetOETabsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOETabsExecute ]
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

ClassMethod GetOETabsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOETabsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetOETabs(Adm, CDate, Grp) As %Query(ROWSPEC = "id,des")
{
}

ClassMethod GetOETabsOneExecute(ByRef qHandle As %Binary, Adm As %String, CDate As %String, Grp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s timstr=""
    s MRADMROWId=$P(^PAADM(Adm),"^",61) 
    s CDate=$ZDH(CDate,3)  
    s itmstr=##class(web.DHCPdaComm).GetOBInOutItm(Grp,.itm)
    s itmstr="^"_itmstr
    s itm=""  f  s itm=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm)) q:itm=""  d
    .s itmdr="^"_itm_"^"
    .q:itmstr'[itmdr
    .s chl=0  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",CDate,itm,chl)) q:chl=""  d
    ..s Ctim=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ..s Ctim=$ZT(Ctim,1)
    ..q:(timstr[Ctim)&(timstr'="")
    ..s timstr=timstr_Ctim_"^"
    ..s id=ind, des=Ctim
    ..d out1
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
	
out1
	set Data=$lb(id,des)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOETabsOneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOETabsOneExecute ]
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

ClassMethod GetOETabsOneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOETabsOneExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetOETabsOne(Adm, CDate, Grp) As %Query(ROWSPEC = "id,des")
{
}

Query GetPhcin(userid As %String) As %Query(ROWSPEC = "Id,Desc,Sel:%String")
{
}

ClassMethod GetPhcinExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^PHCIN(chl) )  q:chl=""  d
    .s des=$P(^PHCIN(chl) ,"^",2)
    .s rw="^"_chl_"^"
    .//if $G(^DHCPdaNurSCHSet("default","PhcIn",userid))[rw s sel="√"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhcinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcinExecute ]
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

ClassMethod GetPhcinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOecpr(userid As %String) As %Query(ROWSPEC = "Id,Desc,Sel")
{
}

ClassMethod GetOecprExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
   s chl=0  f  s chl=$O(^OECPR(chl))  q:chl=""  d
    .s des=$P(^OECPR(chl),"^",2)
    .s rw="^"_chl_"^"
    .//if $G(^DHCPdaNurSCHSet("default","Prior",userid))[rw s sel="√"
    .e  s sel=0
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOecprFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOecprExecute ]
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

ClassMethod GetOecprClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOecprExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPhFreq(userid As %String) As %Query(ROWSPEC = "Id,Desc,Sel")
{
}

ClassMethod GetPhFreqExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^PHCFR(chl))  q:chl=""  d
    .s des=$P(^PHCFR(chl),"^",1)
    .//s rw="^"_chl_"^"
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,"")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhFreqExecute ]
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

ClassMethod GetPhFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhFreqExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAction(userid As %String) As %Query(ROWSPEC = "Id,Desc,Sel:%String")
{
}

ClassMethod GetActionExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	 s rw="" f  s rw=$O(^OEC("ACT",rw))  q:rw=""  d
     .s actDesc=$p(^OEC("ACT",rw),"^",2)
     .s chl=rw,des=actDesc
     .s sel=0
     .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetActionExecute ]
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

ClassMethod GetActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetActionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
