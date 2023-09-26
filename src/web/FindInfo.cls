Class web.FindInfo Extends %RegisteredObject
{

Query FindQuery(startDate, endDate, username) As %Query(ROWSPEC = "patName:%String,payAmount:%String,paymode:%String,userName:%String,detailDate:%String,detailTime:%String")
{
}

ClassMethod FindQueryExecute(ByRef qHandle As %Binary, startDate, endDate, username) As %Status
{
	Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
 ///s start=$zdh(startDate,3)
   ///s end = $zdh(endDate,3)
   ///w startDate,endDate
   f prtdate = startDate:1:endDate do
   .s prtrowid = ""
   .f  s prtrowid=$O(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  do
   
   ..s detailDate1=$P(^DHCSFPRINTDETAIL(prtrowid),"^",2)
   ..s detailDate=$zd(detailDate1,3)
   ..s detailTime=$zt($P(^DHCSFPRINTDETAIL(prtrowid),"^",3),3)
   
   ..;取得就诊信息的rowid
   ..s admRowid = $P(^DHCSFPRINTDETAIL(prtrowid),"^",4)
   ..q:admRowid=""
  
   ..;取得病人信息的rowid
   
   ..s patRowid= $P(^PAADM(admRowid),"^",1)
   ..s patName = $P(^PAPER(patRowid,"ALL"),"^",1)
  
   ..s payAmount =$P(^DHCSFPRINTDETAIL(prtrowid),"^",6)
   
   ..;取得付款方式的rowid
   ..s paymodeRowid = $P(^DHCSFPRINTDETAIL(prtrowid),"^",9)
   ..s paymode =$P(^CT("CTPM",paymodeRowid),"^",2)
   
   ..;取得收费人员的信息
   ..;s userName=""
   ..s addUser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
   ..i $d(^SSU("SSUSR",addUser)) s userName=$p(^SSU("SSUSR",addUser),"^",2)
   ..q:(username'="")&(username'=userName)
   ..d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(patName,payAmount,paymode,userName,detailDate,detailTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery12Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	///Quit $$$OK
	Quit $$$OK
}

ClassMethod FindQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery12Execute ]
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

Query usernameQuery(user) As %Query(ROWSPEC = "name:%String,RowID:%String")
{
}

ClassMethod usernameQueryExecute(ByRef qHandle As %Binary, user) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    
    s RowID=""
     
    f  s RowID=$o(^SSU("SSUSR",RowID))  q:RowID=""  d
    .i $d(^SSU("SSUSR",RowID))   s name=$p(^SSU("SSUSR",RowID),"^",2)
    
    .q:(user'="")&(user'=name)
    .d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
		
OutputRow
	set Data=$lb(name,RowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod usernameQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery13Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod usernameQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery13Execute ]
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
