Class web.GetPatInfor Extends %RegisteredObject
{

Query PatInfor(StartDate, EndDate, Acceptor) As %Query(ROWSPEC = "papname:%String,pdate:%String,ptime:%String,payAmount:%String,paymodel:%String,userName:%String")
{
}

ClassMethod PatInforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatInforExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PatInforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatInforExecute ]
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

ClassMethod PatInforExecute(ByRef qHandle As %Binary, StartDate, EndDate, Acceptor) As %Status
{
   ;w !,StartDate_"^"_EndDate_"^"_Acceptor
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
 	
   ;s start = $zdh(StartDate,3)
   ;s end = $zdh(EndDate,3)
   f prtdate = StartDate:1:EndDate  do
   .s prtrowid=""
   .f  s prtrowid = $O(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,prtrowid)) q:prtrowid=""  do 
   ..s pdate=$zd($p(^DHCSFPRINTDETAIL(prtrowid),"^",2),3)
   ..s ptime=$zt($p(^DHCSFPRINTDETAIL(prtrowid),"^",3),3)
   ..;取得就诊信息rowid
   ..s admIndex=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
   ..q:admIndex=""
   ..;取得病人信息rowid
   ..s papmi=""
   ..i $d(^PAADM(admIndex)) s papmi=$p(^PAADM(admIndex),"^",1)  
   ..q:papmi=""
   ..i $d(^PAPER(papmi)) s papname=$p(^PAPER(papmi,"ALL"),"^",1)
   
   ..s payAmount = $p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
   
   ..;取得付款方式 
   ..s pmrowid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
   ..s paymodel=""
   ..i $d(^CT("CTPM",pmrowid)) s paymodel=$p(^CT("CTPM",pmrowid),"^",2)
   ..;取得收费人员信息
   ..s userrowid=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
   
  
   ..s userName=""
   ..i $d(^SSU("SSUSER",userrowid)) s userName=$p(^SSU("SSUSER",userrowid),"^",2)
   ..q:(Acceptor'=userName)&(Acceptor'="")
   
   ..d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(papname,pdate,ptime,payAmount,paymodel,userName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query Acceptor() As %Query(ROWSPEC = "AcceptorName:%String,rowid:%String")
{
}

ClassMethod AcceptorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AcceptorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod AcceptorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AcceptorExecute ]
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

/// Creator     :qzl
/// CreatDate   :2010-3-23
/// Function    :取得所有收费员姓名
ClassMethod AcceptorExecute(ByRef qHandle As %Binary) As %Status
{
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
   s index=""
   f  s index=$O(^SSU("SSUSR",index)) q:index=""  d
   .s AcceptorName=$p(^SSU("SSUSR",index),"^",2)
   .d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(AcceptorName,index)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Storage Default
{
<Data name="GetPatInforDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.GetPatInforD</DataLocation>
<DefaultData>GetPatInforDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.GetPatInforD</IdLocation>
<IndexLocation>^web.GetPatInforI</IndexLocation>
<StreamLocation>^web.GetPatInforS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
