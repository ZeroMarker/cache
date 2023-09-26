Class web.NewClass3 Extends %RegisteredObject
{

Query NewQuery1(stdate, enddate, User) As %Query(ROWSPEC = "name:%String,payamount:%String,paymod:%String,username:%String,time:%String,date:%String")
{
}

ClassMethod NewQuery1Execute(ByRef qHandle As %Binary, stdate, enddate, User) As %Status
{
 Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
 // s stdate=$zdh(stdate,3),enddate=$zdh(enddate,3)
  
  f prtdate=stdate:1:enddate d
  .s prtrowid="" 
  .f  s prtrowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  d 
  ..  s one=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
  
  ..  s time=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3),3)
  ..  ;s time=$zt("time1",3)
  ..  s date=$zd($p(^DHCSFPRINTDETAIL(prtrowid),"^",2),3)
  ..  ;s date=$zd("date1",3)
  ..  s two=$p(^PAADM(one),"^",1)
  ..  s name=$p(^PAPER(two,"ALL"),"^",1)
  ..  s payamount=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
  ..  s payid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
  ..  s paymod=$p(^CT("CTPM",payid),"^",2)

  ..  s userid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
  ..  i $d(^SSU("SSUSR",userid))   s username=$p(^SSU("SSUSR",userid),"^",2)
  ..  q:(User'="")&(User'=username)
  ..d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(name,payamount,paymod,username,time,date)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NewQuery1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQuery1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

//放大镜 根据输入姓名查询

Query NewQuery2(User) As %Query(ROWSPEC = "username:%String,RowID:%String")
{
}

ClassMethod NewQuery2Execute(ByRef qHandle As %Binary, User) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    
    s RowID=""
     
    f  s RowID=$o(^SSU("SSUSR",RowID))  q:RowID=""  d
    .i $d(^SSU("SSUSR",RowID))   s username=$p(^SSU("SSUSR",RowID),"^",2)
    .q:(User'="")&(User'=username)
    .d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
		
OutputRow
	set Data=$lb(username,RowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NewQuery2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQuery2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery2Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

//放大镜 根据登记号查询就诊信息号

Query NewQuery3(patno) As %Query(ROWSPEC = "patnum:%String,RowId:%String")
{
}

ClassMethod NewQuery3Execute(ByRef qHandle As %Binary, patno) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    
    i patno="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s rowid=""
    s rowid=$o(^PAPERi("PAPMI_PatNo",patno,rowid))
    q:rowid=""
    s patnum=""
    f  s patnum=$o(^PAPERdr(rowid,"ADM","I",patnum)) q:patnum=""  d
    .s RowId=$p(^PAADM(patnum),"^",81)
   
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(patnum,RowId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod NewQuery3Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery3Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQuery3Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery3Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

//Link组件显示信息

Query NewQuery4(LinkId) As %Query(ROWSPEC = "iteam:%String,money:%String,number:%String,totalmoney:%String,date:%String,time:%String")
{
}

ClassMethod NewQuery4Execute(ByRef qHandle As %Binary, LinkId) As %Status
{
	
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    if LinkId=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK	
    
    s ordSub=""
    f  s ordSub=$O(^DHCPB(LinkId,"O",ordSub)) q:ordSub=""  d
    .s detSub=""
    .f  s detSub=$O(^DHCPB(LinkId,"O",ordSub,"D",detSub)) q:detSub=""  d
    ..s trialRowid = $p(^DHCPB(LinkId,"O",ordSub,"D",detSub),"^",3)
    ..q:trialRowid=""
    ..s trialName=""
    ..i $d(^DHCTARI(trialRowid)) s iteam=$p(^DHCTARI(trialRowid),"^",2)
    ..s money = $p(^DHCPB(LinkId,"O",ordSub,"D",detSub),"^",4) 
    ..s number = $p(^DHCPB(LinkId,"O",ordSub,"D",detSub),"^",5)
    ..s totalmoney = $p(^DHCPB(LinkId,"O",ordSub,"D",detSub),"^",7)
    ..s date = $p(^DHCPB(LinkId,"O",ordSub,"D",detSub),"^",11)
    ..s time = $p(^DHCPB(LinkId,"O",ordSub,"D",detSub),"^",12)    
    ..d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(iteam,money,number,totalmoney,date,time)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NewQuery4Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery4Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod NewQuery4Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery4Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

}
