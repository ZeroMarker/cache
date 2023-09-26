Class web.DHCMGPersonArchives Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getperImgExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s per=$P(parr,"^")
    if per="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	//s per=$P(parr,"^",2)
    b
    s rw=""  f  s rw=$O(^User.DHCMGPersonImageI("Person",per,rw)) q:rw=""  d
    .
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (person,picname,mem)=""
    s a=^User.DHCMGPersonImageD(rw)
    s typdr=$List(a,3)
    s perdr=$List(a,2)
    s mem=$List(a,4)
    s parr=^User.DHCMGPersonsD(perdr)
    s person=$list(parr,21)
    //当案类别
    s a=^User.DHCMGCCodeD(typdr)
	s picname=$list(a,3)

    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(person,picname,mem,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getperImgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getperImgExecute ]
{
	Set AtEnd=$LIST($g(qHandle),1)
 	Set repid=$LIST($g(qHandle),2)
 	Set ind=$LIST($g(qHandle),3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=$g(^CacheTemp(repid,ind))
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod getperImgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getperImgExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getperImg(parr As %String) As %Query(ROWSPEC = "person,picname,mem,rw")
{
}

ClassMethod GetTechPersonExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	//if per=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    //s date=""  f  s date=$O(^User.DHCMGNurResearchI("DateDep",date)) q:date=""  d
    //.s dep=""  f  s dep=$O(^User.DHCMGNurResearchI("DateDep",date,dep)) q:dep=""  d
    //..q:(dep'=loc)&(loc'="")
    b
    s nur=""  f  s nur=$O(^User.DHCMGTechArchiveI("depper"," "_loc,nur)) q:nur=""  d
    .
    .q:(per'=nur)&(per'="")
    .b
    .s rw="" f  s rw=$O(^User.DHCMGTechArchiveI("depper"," "_loc,nur,rw)) q:rw=""  d
    ..b
    ..d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,sdate,arctyp,pro,proval ,content,sign,point)=""
    s a=^User.DHCMGTechArchiveD(rw)
    s depdr=$List(a,4)
    s content=$List(a,9)
    s prvaldr=$List(a,3)
    s sdate=$List(a,2)
    s sdate=$ZD(sdate,3)
    s point=$List(a,6)
    s arctyp=$List(a,8)
    s sign=$List(a,7)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    //s属性值
    s a=^User.DHCMGTechArcProValD(prvaldr)
    s catdr=$List(a,2)
    s proval=$List(a,3)
    //属性
    s a=^User.DHCMGTechArcProD(catdr)
    s pro=$list(a,2)
    //当案类别
    s a=^User.DHCMGCCodeD(arctyp)
	s arctyp=$list(a,3)

    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,sdate,arctyp,pro,proval ,content,sign,point,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTechPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTechPersonExecute ]
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

ClassMethod GetTechPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTechPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetTechPerson(parr As %String) As %Query(ROWSPEC = "depdes,person,sdate,arctyp,pro,proval ,content,sign,point,rw")
{
}

ClassMethod GetNurTrainExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	if per=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    //s date=""  f  s date=$O(^User.DHCMGNurResearchI("DateDep",date)) q:date=""  d
    //.s dep=""  f  s dep=$O(^User.DHCMGNurResearchI("DateDep",date,dep)) q:dep=""  d
    //..q:(dep'=loc)&(loc'="")
    s rw=""  f  s rw=$O(^User.DHCMGNurTrainI("Nur",per,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,content,sdate,edate,sign,point,place,unit)=""
    s a=^User.DHCMGNurTrainD(rw)
    s depdr=$List(a,2)
    s nur=$List(a,4)
    if (nur'=per)&(per'="") q
    s content=$List(a,6)
    s sdate=$List(a,5)
    s sdate=$ZD(sdate,3)
    s edate=$List(a,3)
    s edate=$ZD(edate,3)
    s point=$List(a,8)
    s unit=$List(a,10)
    s place=$List(a,7)
    s sign=$List(a,9)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,content,sdate,edate,sign,point,place,unit,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurTrainFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurTrainExecute ]
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

ClassMethod GetNurTrainClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurTrainExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurTrain(parr As %String) As %Query(ROWSPEC = "depdes,person,content,sdate,edate,sign,point,place,unit,rw")
{
}

ClassMethod GetNurEncourageExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	if per=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s rw=""  f  s rw=$O(^User.DHCMGNurEncourageI("NUR",per,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,content,accdate)=""
    s a=^User.DHCMGNurEncourageD(rw)
    s depdr=$List(a,4)
    s nur=$List(a,5)
    if (nur'=per)&(per'="") q
    s content=$List(a,2)
    s accdate=$List(a,3)
    ;s accdate=$ZD(accdate,3)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,content,accdate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurEncourageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurEncourageExecute ]
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

ClassMethod GetNurEncourageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurEncourageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurEncourage(parr As %String) As %Query(ROWSPEC = "depdes,person,content,encdate,rw")
{
}

ClassMethod GetNurPunishExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	//
 	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	if per=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s rw=""  f  s rw=$O(^User.DHCMGNurPunishI("NUR",per,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,content,accdate)=""
    s a=^User.DHCMGNurPunishD(rw)
    s depdr=$List(a,4)
    s nur=$List(a,5)
    if (nur'=per)&(per'="") q
    s content=$List(a,2)
    s accdate=$List(a,3)
    ;s accdate=$ZD(accdate,3)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    d OutRowtyp
    q    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,content,accdate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurPunishFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurPunishExecute ]
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

ClassMethod GetNurPunishClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurPunishExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurPunish(parr As %String) As %Query(ROWSPEC = "depdes,person,content,pudate,rw")
{
}

ClassMethod GetResearchExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	if per=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    //s date=""  f  s date=$O(^User.DHCMGNurResearchI("DateDep",date)) q:date=""  d
    //.s dep=""  f  s dep=$O(^User.DHCMGNurResearchI("DateDep",date,dep)) q:dep=""  d
    //..q:(dep'=loc)&(loc'="")
    s rw=""  f  s rw=$O(^User.DHCMGNurResearchI("Per",per,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,content,Resdate,level,sign,point,selfun)=""
    s a=^User.DHCMGNurResearchD(rw)
    s depdr=$List(a,4)
    s nur=$List(a,6)
    if (nur'=per)&(per'="") q
    s content=$List(a,2)
    s Resdate=$List(a,3)
    s Resdate=$ZD(Resdate,3)
    s point=$List(a,7)
    s selfun=$List(a,8)
    s level=$List(a,5)
    s sign=$List(a,9)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,content,Resdate,level,sign,point,selfun,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetResearchFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResearchExecute ]
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

ClassMethod GetResearchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResearchExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetResearch(parr As %String) As %Query(ROWSPEC = "depdes,person,content,Resdate,level,sign,point,selfun,rw")
{
}

ClassMethod GetNurAccidentExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=$P(parr,"^")
 	s per=$P(parr,"^",2)
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s date=""  f  s date=$O(^User.DHCMGNurAccidentI("DateDep",date)) q:date=""  d
    .s dep=""  f  s dep=$O(^User.DHCMGNurAccidentI("DateDep",date,dep)) q:dep=""  d
    ..q:(dep'=loc)&(loc'="")
    ..s rw=""  f  s rw=$O(^User.DHCMGNurAccidentI("DateDep",date,dep,rw)) q:rw=""  d
    ...b
    ...d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,content,accdate,Pro,deal)=""
    s a=^User.DHCMGNurAccidentD(rw)
    s depdr=$List(a,2)
    s nur=$List(a,3)
    if (nur'=per)&(per'="") q
    s content=$List(a,4)
    s accdate=$List(a,5)
    s accdate=$ZD(accdate,3)
    s Pro=$List(a,6)
    s deal=$List(a,7)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,content,accdate,Pro,deal,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetNurAccidentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNurAccidentExecute ]
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

ClassMethod GetNurAccidentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNurAccidentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetNurAccident(parr As %String) As %Query(ROWSPEC = "depdes,person,content,accdate,Pro,deal,rw")
{
}

ClassMethod getperarcticleExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s per=$P(parr,"^",1)
    if per'=""{
      s rw=""  f  s rw=$O(^User.DHCMGNurArticleI("NurDr",per,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGNurArticleD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .//s a.PostFlag="N"
	    .//s a.Postmem="sdf"
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (realease,subject,comm,maga,authno,sign,point)=""
    s a=^User.DHCMGNurArticleD(rw)
    s authno=$List(a,2)
    s comm=$List(a,3)
    s maga=$List(a,4)
    s nur=$List(a,5)
    s point=$List(a,6)
    s realease=$List(a,7)
    s subject=$List(a,9)
    s sign=$List(a,8)
    s realease=$ZD(realease,3)
    
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(realease,subject,comm,maga,authno,sign,point,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getperarcticleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getperarcticleExecute ]
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

ClassMethod getperarcticleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getperarcticleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getperarcticle(parr As %String) As %Query(ROWSPEC = "realease,subject,comm,maga,authno,sign,point,rw")
{
}

ClassMethod getswmenExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s dep=$P(parr,"^",1)
    if dep'=""{
      s rw=""  f  s rw=$O(^User.DHCMGSuckleWomanI("dep"," "_dep,rw)) q:rw=""  d
	    .
	    .d out
    }
	    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (wmen,stdate,edate)=""
    s a=^User.DHCMGSuckleWomanD(rw)
    s wmen=$List(a,4)
    s edate=$List(a,2)
    s stdate=$List(a,3)
    if edate'="" s edate=$ZD(edate,3)
    if stdate'="" s stdate=$ZD(stdate,3)
    s parr=^User.DHCMGPersonsD(wmen)
    s wmen=$list(parr,21)

    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(wmen,stdate,edate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getswmenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getswmenExecute ]
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

ClassMethod getswmenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getswmenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getswmen(parr As %String) As %Query(ROWSPEC = "women,stdate,endate,rw")
{
}

ClassMethod getperexamExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s per=$P(parr,"^",1)
    if per'=""{
      s rw=""  f  s rw=$O(^User.DHCMGExamI("Person",per,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGExamD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .//s a.PostFlag="N"
	    .//s a.Postmem="sdf"
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (exdate,oppoint,opsub,tpoint,tsub)=""
    s a=^User.DHCMGExamD(rw)
    s exdate=$List(a,2)
    s oppoint=$List(a,4)
    s opsub=$List(a,5)
    s tpoint=$List(a,6)
    s tsub=$List(a,7)
    s exdate=$ZD(exdate,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(exdate,oppoint,opsub,tpoint,tsub,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getperexamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getperexamExecute ]
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

ClassMethod getperexamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getperexamExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getperexam(parr As %String) As %Query(ROWSPEC = "exdate,oppoint,opsub,tpoint,tsub,rw")
{
}

ClassMethod GetAuditRecordExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 //	s parr="^2010-01-12^2010-01-12"
 	s loc=$P(parr,"^",1)
 	s stdate=$P(parr,"^",2)
	s edate=$P(parr,"^",3)
	s stdate1=$ZDH(stdate,3)
	s edate1=$ZDH(edate,3)
	for date=stdate1:1:edate1 
	{
	    s dep=""  f  s dep=$O(^User.DHCMGAuditArrangeI("DepDate",dep)) q:dep=""  d
	    .if (dep'=loc)&(loc'="") q
	    .s rw=""  f  s rw=$O(^User.DHCMGAuditArrangeI("DepDate",dep,date,rw)) q:rw=""  d
	    ..w !,rw,"-",dep
	    ..d out
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,stdate,edate,person,audate,autime,SmUser,SmDate,SmTime,Stat,mem)=""
    s a=^User.DHCMGAuditArrangeD(rw)
    
    s user=$List(a,7)
    s Stdate=$List(a,5)
    s eDate=$List(a,4)
    s audate=$List(a,2)
    s autime=$List(a,6)
    s SmDate=$List(a,10)
    s SmTime=$List(a,9)
    s SmUser=$List(a,11)
    q:SmUser=""
    s Stat=$List(a,8)
    s mem= $List(a,12)
    if audate'="" s audate=$ZD(audate,3)
    if autime'="" s autime=$ZT(autime,2)
    if SmDate'="" s SmDate=$ZD(SmDate,3)
    if SmTime'="" s SmTime=$ZT(SmTime,2)
    
    s depdr=$List(a,3)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s edate=$ZD(eDate,3)
    s stdate=$ZD(Stdate,3)
    s parr=^User.DHCMGPersonsD(SmUser)
    s SmUser=$list(parr,21)
    if user'="" s parr=^User.DHCMGPersonsD(user)
    if user'="" s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,stdate,edate,person,audate,autime,dep,rw,SmUser,SmDate,SmTime,Stat,mem,"false")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAuditRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAuditRecordExecute ]
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

ClassMethod GetAuditRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAuditRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAuditRecord(parr As %String) As %Query(ROWSPEC = "depdes,stdate,edate,person,audate,autime,dep,rw,SmUser,SmDate,SmTime,Stat,mem,Sel:%Boolean")
{
}

ClassMethod GetImageId(per As %String, Code As %String) As %String
{
    s imgid=""
    s rw=""  f  s rw=$O(^User.DHCMGPersonImageI("Person",per,rw)) q:rw=""  d
    .
    .s a=^User.DHCMGPersonImageD(rw)
    .s typdr=$List(a,3)
    .//当案类别
    .s a=^User.DHCMGCCodeD(typdr)
	.s picCode=$list(a,2)
	.if picCode=Code  s imgid=rw
	q imgid
}

}
