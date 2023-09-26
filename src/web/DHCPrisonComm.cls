Class web.DHCPrisonComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod setmoudtmp(parr, tmval)
{
  //class(web.DHCPrisonComm).setmoudtmp()

    s par1=$P(parr,"&")
    s chepar=$P(parr,"&",2)
	s l=$L(chepar,"^")
	//s ^TMVAL("V")=chepar
	s comboret=$P(parr,"&",3)
	f i=1:1:l
	{
	  s itm=$P(chepar,"^",i)
	  if itm="" continue
	  s arr=$P(itm,"|")
	  s name=$P(arr,"_")
	  s selcode=$P(arr,"_",2)
	  s val=$P(itm,"|",2)
      //if '$D(tmval(name)) s tmval(name)=selcode_"|"_val
	  //e  s tmval(name)=tmval(name)_selcode_"|"_val_"^"
	  if '$D(tmval(name)) s tmval(name)=val
	  e  s tmval(name)=tmval(name)_";"_val
	}
	s l=$L(par1,"^")
	for i=1:1:l
	{
	  s itm=$P(par1,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  s val=$P(itm,"|",2)
	  s tmval(name)=val
	}
	s l=$L(comboret,"^")
	for i=1:1:l
	{
	  s itm=$P(comboret,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  s arr=$P(itm,"|",2)
	  s val=$P(arr,"!",1)
	  s des=$P(arr,"!",2)
	  s tmval(name)=val_"!"_des
	}
	//m ^TMVAL=tmval
}

ClassMethod getprisper(dtid) As %String
{
 //s a=##class(web.DHCPrisonComm).getprisper()
    s tmp=""
   	s ret2=##class(PRISON.DetainRec).getVal(dtid)
   	s aa=##class(web.DHCPrisonComm).settmp(ret2,.tmp)
	s ret1=##class(PRISON.SuspicionPer).getVal(tmp("LSuspicionPer"))
   	s aa=##class(web.DHCPrisonComm).settmp(ret1,.tmp)
   q tmp("SpName")_" "_tmp("SpSex")_" "_ tmp("DetUnit")_" "_tmp("DetRoom")
}

ClassMethod settmp(parr, tmp) As %String
{
 //s aa=##class(web.DHCPrisonComm).settmp(parr,.tmp)
	s l=$L(parr,"^")
	for i=1:1:l
	{
	  s itm=$P(parr,"^",i)
	  if itm="" continue
	  s name=$P(itm,"|")
	  if $P(name,"_",2)'=""  s name=$P(name,"_",1)
	  s val=$P(itm,"|",2)
	  if '$D(tmp(name)) s tmp(name)=val
	  e  s tmp(name)=tmp(name)_";"_val
	  if $F(val,"!")'=0
	  {
	    s rw=$P(val,"!")
	    s rwv=$P(val,"!",2)
	    if rwv'=""
	    {
		  if (rwv="date")
		  {
			  if (rw'="") s val=$ZDH(rw,3)
			  e  s val=""
		  }
		  if (rwv="time")
		  {
			  if (rw'="") s val=$ZTH(rw,4)
			  e  s val=""
		  }
		}else{
			s val=""
			}
	   s tmp(name)=val
	  }
	 
	}
  q 0
}

ClassMethod SuspicionperRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s ^TMP("parr1")=parr
   //s parr="2011-09-01^2011-12-25"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
    s stdate=$P(parr,"^",1)
    s edate=$P(parr,"^",2)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    
 	f date=stdate:1:edate
 	{
	  s rw=""
	  f { 
	     s ret1="",ret2="",ret=""
	     s rw=$O(^PRISON.SuspicionPerI("RDate",date,rw))
	     q:rw=""
	     s ret1=##class(PRISON.SuspicionPer).getVal(rw)
	     s dtid=..getCurrDetain(rw)
	     s mgtyp=""
	     if dtid'="" 
	     {
		   s ret2=##class(PRISON.DetainRec).getVal(dtid)
		   s mgid=##class(PRISON.MedMgRec).GetCurMedMgId(dtid)
		   if mgid'=""
		   {
		      s b=##class(PRISON.MedMgRec).%OpenId(mgid)
		      s mgtyp=b.MgTypDr
		   }
		 }
		 s ret=ret1_"^"_ret2_"^SpId|"_rw_"^dtId|"_dtid
		 if mgtyp'=""  s ret=ret_"^MgTyp|"_mgtyp
	     d OutRowtyp
	  }
	}
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SuspicionperRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SuspicionperRecExecute ]
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

ClassMethod SuspicionperRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SuspicionperRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query SuspicionperRec(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getCurrDetain(SpId) As %String
{
 //s a=##class(web.DHCPrisonComm).getCurrDetain
   s dtId=""
   s rw=""  f  s rw=$O(^PRISON.DetainRecI("LSU"," "_SpId,rw)) q:rw=""  d
   .s a=##class(PRISON.DetainRec).%OpenId(rw)
   .s flag=a.SpStatus
   .if (flag="A")!(flag="T") s dtId=rw
   .b
   q dtId
}

ClassMethod LinkManExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s ^TMP("parr")=parr
    //s parr="2009-10-4^2009-12-25"
    //s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
    s SpId=$P(parr,"^",1)
    
	  s rw=""
	  f { 
	     s ret=""
	     s rw=$O(^PRISON.SpLinkManI("LSU"," "_SpId,rw))
	     q:rw=""
	     s ret=##class(PRISON.SpLinkMan).getVal(rw)
	     s ret=ret_"^SpId|"_SpId_"^rowid|"_rw

	     d OutRowtyp
	  }

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LinkManFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LinkManExecute ]
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

ClassMethod LinkManClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LinkManExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query LinkMan(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod hiscondemExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s ^TMP("parr")=parr
    //s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
    s SpId=$P(parr,"^",1)
    
	  s rw=""
	  f { 
	     s ret=""
	     s rw=$O(^PRISON.SpHistoryCondemI("LSU"," "_SpId,rw))
	     q:rw=""
	     s ret=##class(PRISON.SpHistoryCondem).getVal(rw)
	     s ret=ret_"^SpId|"_SpId_"^rowid|"_rw
	     d OutRowtyp
	  }

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod hiscondemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = hiscondemExecute ]
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

ClassMethod hiscondemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = hiscondemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query hiscondem(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod RegUnitExecute(ByRef qHandle As %Binary, Loc As %String) As %Status
{
	//Set repid=$I(^CacheTemp)
 	//s ind=1
 	//补贴调节记录
 	//s ^TMP("parr")=parr
    //s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
	  //s rw=""
	 // f { 
	     //s ret1=""
	     //s rw=$O(^PRISONC.RegUnitI("Unit",rw))
	     //q:rw=""
	     //s ret1=##class(PRISONC.Region).getVal($TR(rw," ",""))
	    // s id=""
	     //f {
		   // s ret=""
		    //s id=$O(^PRISONC.RegUnitI("Unit",rw,id)) 
		    //q:id=""
		    //s a=##class(PRISONC.RegUnit).%OpenId(id)
            //s ret="desc|"_a.RegUnitName_"^id|"_id
	      // d OutRowtyp
		 // }
	 // }
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s r=""  f  s r=$O(^PRISONC.RegionI("Loc"," "_Loc,r)) q:r=""  d
 	.s u=""  f  s u=$O(^PRISONC.RegUnitI("Unit"," "_r,u)) q:u=""  d
 	..//s a=##class(PRISONC.RegUnit).%OpenId(u)
	..s rw=u
	..s ret=""
	..s ret=##class(PRISONC.RegUnit).getVal(rw)
	..s ret=ret_"^rw|"_rw
	..d outtyp2
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK  
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod RegUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegUnitExecute ]
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

ClassMethod RegUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RegUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query RegUnit(Loc) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getroom()
{
  //##class(web.DHCPrisonComm).getroom()
 	s Loc=211
 	s unit=""
 	s r=""  f  s r=$O(^PRISONC.RegionI("Loc"," "_Loc,r)) q:r=""  d
 	.b
 	.s u=""  f  s u=$O(^PRISONC.RegUnitI("Unit"," "_r,u)) q:u=""  d
 	..q:(u'=unit)&(unit'="")
 	..s id="" f  s id=$O(^PRISONC.RegURoomI("Room"," "_u,id)) q:id=""  d
 	...s a=##class(PRISONC.RegURoom).%OpenId(id)
	...s rw=id
	...s ret=""
	...s ret=##class(PRISONC.RegURoom).getVal(rw)
	...s ret=ret_"^rw|"_id
	...b
}

ClassMethod RegRoomExecute(ByRef qHandle As %Binary, parr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Loc=$P(parr,"^",1)
 	s unit=$P(parr,"^",2)
 	;if WardId="" Quit $$$OK
 	s r=""  f  s r=$O(^PRISONC.RegionI("Loc"," "_Loc,r)) q:r=""  d
 	.q:(r'=unit)&(unit'="")
 	.s id="" f  s id=$O(^PRISONC.RegURoomI("Room"," "_r,id)) q:id=""  d
 	..s a=##class(PRISONC.RegURoom).%OpenId(id)
	..s rw=id
	..s ret=""
    ..s ret=##class(PRISONC.RegURoom).getVal(rw)
	..s ret=ret_"^rw|"_id
	..d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod RegRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegRoomExecute ]
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

ClassMethod RegRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RegRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query RegRoom(Parr) As %Query(ROWSPEC = "aa")
{
}

ClassMethod ArcItemCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.ArcItemCatD(id)) q:id=""  d
 	.s a=##class(PRISONC.ArcItemCat).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.ArcItemCat).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ArcItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArcItemCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ArcItemCat() As %Query(ROWSPEC = "aa")
{
}

ClassMethod ArcItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArcItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ArcItemmastExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s cat=$P(Parr,"^",2)
 	s loc=$P(Parr,"^",1)
 	s ct="" f  s ct=$O(^PRISONC.ArcItmmastI("ArcLoc"," "_loc,ct)) q:ct=""  d
	.q:($TR(ct," ","")'=cat)&(cat'="")
	.s id="" f  s id=$O(^PRISONC.ArcItmmastI("ArcLoc"," "_loc,ct,id)) q:id=""  d
	..s rw=id
	..s ret=""
	..s ret=##class(PRISONC.ArcItmmast).getVal(rw)
	..s ret=ret_"^rw|"_id
	..d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ArcItemmastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArcItemmastExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ArcItemmast(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod ArcItemmastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArcItemmastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CTDurExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.CTDurD(id)) q:id=""  d
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.CTDur).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CTDurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTDurExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CTDur() As %Query(ROWSPEC = "aa")
{
}

ClassMethod CTDurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTDurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod CTUomExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.CTUomD(id)) q:id=""  d
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.CTUom).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CTUomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTUomExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CTUom() As %Query(ROWSPEC = "aa")
{
}

ClassMethod CTUomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTUomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod MedProfessionExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.MedProfessionD(id)) q:id=""  d
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.MedProfession).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MedProfessionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedProfessionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query MedProfession() As %Query(ROWSPEC = "aa")
{
}

ClassMethod MedProfessionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedProfessionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod PhFreqExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.PhFreqD(id)) q:id=""  d
 	.s a=##class(PRISONC.PhFreq).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.PhFreq).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PhFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PhFreqExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query PhFreq() As %Query(ROWSPEC = "aa")
{
}

ClassMethod PhFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PhFreqExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod PHInstrucExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.PHInstrucD(id)) q:id=""  d
 	.s a=##class(PRISONC.PHInstruc).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.PHInstruc).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PHInstrucFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PHInstrucExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query PHInstruc() As %Query(ROWSPEC = "aa")
{
}

ClassMethod PHInstrucClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PHInstrucExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod RegionExecute(ByRef qHandle As %Binary, Loc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
    
 	s id="" f  s id=$O(^PRISONC.RegionI("Loc"," "_Loc,id)) q:id=""  d
 	.s a=##class(PRISONC.Region).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.Region).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod RegionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query Region(Loc) As %Query(ROWSPEC = "aa")
{
}

ClassMethod RegionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RegionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetRegion(funname As %String) As %String
{
	s rw=0  f  s rw=$o(^PRISONC.RegionD(rw)) q:rw=""  d
	.s name=$List(^PRISONC.RegionD(rw),3)
	.b
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

ClassMethod GetUnit(funname As %String) As %String
{
	s rw=0  f  s rw=$o(^PRISONC.RegUnitD(rw)) q:rw=""  d
	.s name=$List(^PRISONC.RegUnitD(rw),3)
	
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

ClassMethod GetCat(funname As %String) As %String
{
	s rw=0  f  s rw=$o(^PRISONC.ArcItemCatD(rw)) q:rw=""  d
	.s name=$List(^PRISONC.ArcItemCatD(rw),3)
	
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

ClassMethod GetCat1(funname As %String) As %String
{
	s rw=0  f  s rw=$o(^PRISONC.ArcItemCatD(rw)) q:rw=""  d
	.s name=$List(^PRISONC.ArcItemCatD(rw),3)
	
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

ClassMethod MrcDiagnosExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.MrcDiagnosD(id)) q:id=""  d
 	.s a=##class(PRISONC.MrcDiagnos).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.MrcDiagnos).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MrcDiagnosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MrcDiagnosExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query MrcDiagnos() As %Query(ROWSPEC = "aa")
{
}

ClassMethod MrcDiagnosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MrcDiagnosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod PhPriorityExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.PhPriorityD(id)) q:id=""  d
 	.s a=##class(PRISONC.PhPriority).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.PhPriority).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PhPriorityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PhPriorityExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query PhPriority() As %Query(ROWSPEC = "aa")
{
}

ClassMethod PhPriorityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PhPriorityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetQueryCombox(QueryName As %String, parrm As %String, funname As %String, desc As %String) As %String
{
  //s a=##class(web.DHCPrisonComm).GetQueryCombox()
  //s QueryName="web.DHCPrisonComm:ArcItemCat"
  // s parrm=""
  // s funname="addLab"
  // s desc="CatDesc"

   //s ^TT("a")=QueryName
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     if itm="" continue
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
 b //
  if pp="" s sc=rset.Execute()
  else  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
       s coldata=""
       s rd="["
       For col = 1:1:columns {
	       s aa=rset.GetData(col)
	       s l=$L(aa,"^")
	       k tmp
	       s tmp=""
	       s aa=##class(web.DHCPrisonComm).settmp(aa,.tmp)
		   s colret="{id:'"_tmp("rw")_"',desc:'"_tmp(desc)_"'}"
        }
        s coldata="'"_$ZCVT(colret,"O","JS")_"'"
   s rtnval=funname_"("_coldata_");"
   b
  &javascript<#(rtnval)#>
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

ClassMethod GetSuspicionListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s ^TMP("parr")=parr
    //s parr="2009-10-4^2009-12-25"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
    s Reg=$P(parr,"^",1)
    s detRoom=$P(parr,"^",2)
    s supName=$P(parr,"^",3)
    if (Reg="")&(supName="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
    s con="^Admit^Temporary^"
    if supName'=""
    {
     s supName=$ZConvert(supName,"U")
     s supName=" "_supName
	 s id=supName
	 s ln=$L(supName)
	 s im=supName
	 s flag=0
	 s ret=""
	 s rw="" s rw=$O(^PRISON.SuspicionPerI("SpName",id,rw))
	 if rw'=""  d sa
	 f  s id=$O(^PRISON.SuspicionPerI("SpName",id)) q:(id="")!(flag=1)  d
	 .if $E(id,0,ln)'=im s flag=1
	 .s rw=""  f  s rw=$O(^PRISON.SuspicionPerI("SpName",id,rw)) q:rw=""!(flag=1)  d
     ..d sa
     ..
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
sa
	   	 q:rw=""
	     s ret1=##class(PRISON.SuspicionPer).getVal(rw)
         s dtid=..getCurrDetain(rw)
	     s mgtyp=""
	     s ret2=""
	     if dtid'="" 
	     {
		   s ret2=##class(PRISON.DetainRec).getVal(dtid)
		   s mgid=##class(PRISON.MedMgRec).GetCurMedMgId(dtid)
		   if mgid'=""
		   {
		      s b=##class(PRISON.MedMgRec).%OpenId(mgid)
		      s mgtyp=b.MgTypDr
		   }
		 }
		 s ret=ret1_"^"_ret2_"^SpId|"_rw_"^dtId|"_dtid
		 if mgtyp'=""  s ret=ret_"^MgTyp|"_mgtyp
		 d OutRowtyp
       q


	}
    s rw=""  f  s rw=$O(^PRISON.DetainRecI("Region"," "_Reg,rw)) q:rw=""  d
    .s a=##class(PRISON.DetainRec).%OpenId(rw)
    .s status="^"_a.SpStatus_"^"
    .q:con['status
    .s room=a.DetRoomDr
    .q:(detRoom'=room)&(detRoom'="")
   	.s mgtyp=""
    .s supregid=a.LSuspicionPer
    .s ret1=##class(PRISON.SuspicionPer).getVal(supregid)
	.s ret2=##class(PRISON.DetainRec).getVal(rw)
	.s mgid=##class(PRISON.MedMgRec).GetCurMedMgId(rw)
	.if mgid'="" d
	..s b=##class(PRISON.MedMgRec).%OpenId(mgid)
	..s mgtyp=b.MgTypDr
	.s ret=ret1_"^"_ret2_"^SpId|"_supregid_"^dtId|"_rw
    .if mgtyp'=""  s ret=ret_"^MgTyp|"_mgtyp
    .d OutRowtyp

    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSuspicionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSuspicionListExecute ]
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

ClassMethod GetSuspicionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSuspicionListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetSuspicionList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getsusp(supName) As %String
{
   //s a=##class(web.DHCPrisonComm).getsusp()
     s supName=$ZConvert(supName,"U")
     s supName=" "_supName
	 s id=supName
	 s ln=$L(supName)
	 s im=supName
	 s flag=0
	 s ret=""
	 s rw="" s rw=$O(^PRISON.SuspicionPerI("SpName",id,rw))
	 if rw'=""  d sa
	 f  s id=$O(^PRISON.SuspicionPerI("SpName",id)) q:(id="")!(flag=1)  d
	 .if $E(id,0,ln)'=im s flag=1
	 .s rw=""  f  s rw=$O(^PRISON.SuspicionPerI("SpName",id,rw)) q:rw=""!(flag=1)  d
     ..d sa
     ..
   q 0
sa
  w !,id,"--",rw
  q
}

ClassMethod CrimeTypExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s id="" f  s id=$O(^PRISONC.CrimeTypD(id)) q:id=""  d
	.s rw=id
	.s ret=""
	.s ret=##class(PRISONC.CrimeTyp).getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CrimeTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CrimeTypExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CrimeTyp() As %Query(ROWSPEC = "aa")
{
}

ClassMethod CrimeTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CrimeTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
