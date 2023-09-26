Include Nur.DateFormat

/// 护理计划项目
Class web.DHCNurPlanItemMast Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// w ##class(web.DHCNurPlanItemMast).Save("^cc^dd^c^cd^^^16^6^Y^2014-12-25^2014-12-26^cdef")

ClassMethod Save(Parr As %String) As %String
{
	s ^pstmp("ItemMast")=Parr
	s id=$p(Parr,"^")
	s Code=$P(Parr,"^",2)
	s Desc=$P(Parr,"^",3)
	
	s KeyWord=$P(Parr,"^",4)
	s Note=$P(Parr,"^",5)

	s ItemTypID=$P(Parr,"^",6)
	s ItemCatID=$P(Parr,"^",7)
	s Freq=$P(Parr,"^",8)
	s CustomFreq=$P(Parr,"^",9)
	s LocID=$P(Parr,"^",10)
	s FromDat=$P(Parr,"^",11)
	i FromDat["-" s FromDat=$$$zdh(FromDat,3)  //年-月-日
	i FromDat["/" s FromDat=$$$zdh(FromDat,1)  // 月/日/年
	s ToDat=$P(Parr,"^",12)
	i ToDat["-" s ToDat=$$$zdh(ToDat,3)
	i ToDat["/" s ToDat=$$$zdh(ToDat,1)
	
	
	q:(ToDat'="")&&(FromDat>ToDat) "截止日期应该大于开始日期!"
	
	;b ;01
	i id="" s a=##class(User.DHCNurPlanItemMast).%New()
	e  s a=##class(User.DHCNurPlanItemMast).%OpenId(id)
	
    s a.IMCode=Code
    s a.IMDesc=Desc
    s a.IMKeyWord=KeyWord
    s a.IMNote=Note
  
    s a.IMItemType=ItemTypID
    s a.IMItemCat=ItemCatID
    s a.IMFreq=Freq
    s a.IMCustomFreq=CustomFreq
    s a.IMLocID=LocID
    s a.IMDateFrom=FromDat
    s a.IMDateTo=ToDat
    
    ;b ;02
    d a.%Save()
    q a.%Id()
}

ClassMethod Delete(id As %String) As %String
{
	q:id="" 0
	s a=##class(User.DHCNurPlanItemMast).%DeleteId(id)
	q 0
}

ClassMethod FindItemMastListExecute(ByRef qHandle As %Binary, Scode As %String = "", Sdesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^pstmp=Scode_"^"_Sdesc
 	s id=""  f  s id=$o(^DHCNurPlan("Item",id)) q:id=""  d
 	.s adata=^DHCNurPlan("Item",id)
    .s code=$listget(adata,2)
    .q:(Scode'="")&(code'[Scode)
    .s desc=$listget(adata,3)
    .q:(Sdesc'="")&(desc'[Sdesc)
    .s itemtyp=$listget(adata,4)
    .s itemtypDesc=""
    .i itemtyp'="" s itemtypDesc=$listget(^DHCNurPlan("ItemType",itemtyp),3)
    
    .s itemcat=$listget(adata,5)
    .s itemcatDesc=""
    .i itemcat'="" s itemcatDesc=$listget(^DHCNurPlan("ItemCat",itemcat),3)
   
    .s fromdate=$listget(adata,6)
    .i fromdate'="" s fromdate=$$$zd(fromdate,3)
    .s todate=$listget(adata,7)
    .i todate'="" s todate=$$$zd(todate,3)
    
    .s keyword=$listget(adata,8)
    .s loc=$listget(adata,9)
    .s locDesc=""
    .i loc'="" s locDesc=$P(^CTLOC(loc),"^",2)
    .s freq=$listget(adata,10)
    .s freqDesc=""
    .i freq'="" s freqDesc=$P(^PHCFR(freq),"^",3)
    .s note=$listget(adata,11)
    .s customfreq=$listget(adata,12)
 	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,code,desc,$g(itemtypDesc),$g(itemcatDesc),fromdate,todate,keyword,$g(locDesc),$g(freqDesc),note,customfreq,itemtyp,itemcat,loc,freq)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindItemMastListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindItemMastListExecute ]
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

ClassMethod FindItemMastListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindItemMastListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindItemMastList(Scode As %String, Sdesc As %String) As %Query(ROWSPEC = "id:%String,code:%String,desc:%String,itemtypDesc:%String,itemcatDesc:%String,fromdate:%String,todate:%String,keyword:%String,locDesc:%String,freqDesc:%String,note:%String,customfreq:%String,itemtyp:%String,itemcat:%String,loc:%String,freq:%String")
{
}

// w ##class(web.DHCNurPlanItemMast).GetItemTyp()

ClassMethod GetItemMastList(Code As %String = "") As %String
{
	s retJson=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.DHCNurPlanItemMast:FindItemMastList")
	d rs.Execute()
	while(rs.Next()){
		s TypId=rs.GetDataByName("id")
		s Typcode=rs.GetDataByName("code")
		
		s Typdesc=rs.GetDataByName("desc")
		s Typdesc=Typcode_"-"_Typdesc
		s Typfromdate=rs.GetDataByName("fromdate")
		s Typtodate=rs.GetDataByName("todate")
		i Typfromdate'="" s Typfromdate=$$$zdh(Typfromdate,3)
		i Typtodate'="" s Typtodate=$$$zdh(Typtodate,3)
		
		continue:(Typfromdate>+$h)
		continue:(Typtodate'="")&&(Typtodate<+$h)
		s retChildJson=##class(%ArrayOfDataTypes).%New()
		d retChildJson.SetAt(TypId,"ID")
		d retChildJson.SetAt(Typdesc,"Desc")
		d retJson.Insert(retChildJson)
	}
	q ##class(Nur.JSON).Encode(retJson)
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, Sdesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s ^pstmp("FindLocList")=Sdesc
    s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
    .s code=$P(^CTLOC(rw),"^")
    .q:$ISVALIDNUM(code)=1
    .s desc=$P(^CTLOC(rw),"^",2)
    .q:$ISVALIDNUM(desc)=1
    .q:desc=""
    .s DatActiveFrom=$P(^CTLOC(rw),"^",24)
    .q:(DatActiveFrom'="")&&(DatActiveFrom>+$h)
    .s DatActiveTo=$P(^CTLOC(rw),"^",25)
    .q:(DatActiveTo'="")&&(DatActiveFrom<+$h)
    .s loctyp=$P(^CTLOC(rw),"^",13)
    .s CTLOCContactName=$P(^CTLOC(rw),"^",43)
    .q:(Sdesc'="")&(desc'[$$ALPHAUP^SSUTIL4(Sdesc))&(CTLOCContactName'[$$ALPHAUP^SSUTIL4(Sdesc))
 	.Do Output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(rw,code,desc,loctyp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindLocList(Sdesc As %String = "") As %Query(ROWSPEC = "rw:%String,code:%String,desc:%String,loctyp:%String")
{
}

// w ##class(web.DHCNurPlanItemMast).GetLocList()

ClassMethod GetLocList() As %String
{
	s retJson=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.DHCNurPlanItemMast:FindLocList")
	d rs.Execute()
	while(rs.Next()){
		s LocId=rs.GetDataByName("rw")
		s Loccode=rs.GetDataByName("code")
		s Locdesc=rs.GetDataByName("desc")
		
		s retChildJson=##class(%ArrayOfDataTypes).%New()
		d retChildJson.SetAt(LocId,"ID")
		d retChildJson.SetAt(Locdesc,"Desc")
		d retJson.Insert(retChildJson)
	}
	q ##class(Nur.JSON).Encode(retJson)
}

ClassMethod FindDiagListExecute(ByRef qHandle As %Binary, Sdesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
    s rw="" f  s rw=$O(^MRC("ID",rw)) q:rw=""  d
    .s code=$P(^MRC("ID",rw),"^")
    .s desc=$P(^MRC("ID",rw),"^",2)
    .q:desc=""
    .q:(Sdesc'="")&(desc'[$$ALPHAUP^SSUTIL4(Sdesc))
 	.Do OutputDiag
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDiag
	set Data=$lb(rw,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDiagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDiagListExecute ]
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

ClassMethod FindDiagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDiagListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindDiagList(Sdesc As %String = "") As %Query(ROWSPEC = "rw:%String,code:%String,desc:%String")
{
}

// w ##class(web.DHCNurPlanItemMast).GetDiagList()

ClassMethod GetDiagList() As %String
{
	s retJson=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.DHCNurPlanItemMast:FindDiagList")
	d rs.Execute()
	while(rs.Next()){
		s DiagId=rs.GetDataByName("rw")
		s Diagcode=rs.GetDataByName("code")
		s Diagdesc=rs.GetDataByName("desc")
		
		s retChildJson=##class(%ArrayOfDataTypes).%New()
		d retChildJson.SetAt(DiagId,"ID")
		d retChildJson.SetAt(Diagdesc,"Desc")
		d retJson.Insert(retChildJson)
	}
	q ##class(Nur.JSON).Encode(retJson)
}

ClassMethod FindFreqListExecute(ByRef qHandle As %Binary, Sdesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
    s rw="" f  s rw=$O(^PHCFR(rw)) q:rw=""  d
    .s code=$P(^PHCFR(rw),"^")
    .s desc=$P(^PHCFR(rw),"^",3)
    .q:desc=""
    .q:(Sdesc'="")&(desc'[$$ALPHAUP^SSUTIL4(Sdesc))
 	.Do OutputFreq
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputFreq
	set Data=$lb(rw,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFreqListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFreqListExecute ]
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

ClassMethod FindFreqListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFreqListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindFreqList(Sdesc As %String = "") As %Query(ROWSPEC = "rw:%String,code:%String,desc:%String")
{
}

Query FindMasterItem(ARCIMDesc As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, ARCIMDesc As %String) As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s fl=0
	..s AlisDR="" f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:(AlisDR="")!(fl=1)  d
	...q:AlisDR=""
	...s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	...s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	...s ArcimDesc=AlisDesc_"-"_ArcimDesc
	...q:ArcimDesc'[ARCIMDesc
	...s fl=1
	...Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
