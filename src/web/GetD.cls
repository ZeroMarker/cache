Class web.GetD Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetDetail()
{
	
 s prtid=0,num=0
 f  s prtid=$o(^DHCSFPRINTDETAIL(prtid)) q:prtid=""  d
 .s date=$p(^DHCSFPRINTDETAIL(prtid),"^",2)
 .s amount=$p(^DHCSFPRINTDETAIL(prtid),"^",6)
 .s paymode=$p(^DHCSFPRINTDETAIL(prtid),"^",9)
 .s admid=$p(^DHCSFPRINTDETAIL(prtid),"^",4)
 .q:admid=""
 .s personid=0
 .i $d(^PAADM(admid)) s personid=$p(^PAADM(admid),"^",1)
 .q:personid="" 
 .i $d(^PAPER(personid,"ALL")) d
 ..s name=$p(^PAPER(personid,"ALL"),"^",1)
 ..s no=$p(^PAPER(personid,"PAT",1),"^",1)
 .s num=num+1
 .w !,$zd(date,3)_"^"_name_"^"_no_"^"_amount_"^"_paymode
 q num
}

Query getdetail(startDate, endDate, username) As %Query(ROWSPEC = "patName:%String,payAmount:%String,paymode:%String,userName:%String,detailDate:%String,detailTime:%String")
{
}

ClassMethod getdetailExecute(ByRef qHandle As %Binary, startDate, endDate, username) As %Status
{
	Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=0
   
   f prtdate=startDate:1:endDate d
   .s rowid=""
   .s rowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",prtdate,rowid))  q:rowid=""  d
   ..s payAmount=$p(^DHCSFPRINTDETAIL(rowid),"^",6)  
   ..s detailDate=$p(^DHCSFPRINTDETAIL(rowid),"^",2)
   ..s detailTime=$p(^DHCSFPRINTDETAIL(rowid),"^",3)
   ;取得病人就诊adm
   ..s admid=$p(^DHCSFPRINTDETAIL(rowid),"^",4)
   ..i $d(^PAADM(admid))  s patid=$p(^PAADM(admid),"^",1)
   ;取得病人基本信息表rowid
   ..q:patid=""
   ..i $d(^PAPER(patid)) s patName=$p(^PAPER(patid),"^",1)
   ;取得支付方式rowid
   ..s paymodeid=$p(^DHCSFPRINTDETAIL(rowid),"^",9)
   ..s payMode=$p(^CT("CTPM",paymodeRowid),"^",2)
   ;取得收费员信息表rowid
   ..s userid=$p(^DHCSFPRINTDETAIL(rowid),"^",14)
   ..s userName=$p(^SSU("SSUSR",userid),"^",2)
   ..q:(userName'="")&(userName'=username)
   ..d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	set Data=$lb(patName,payAmount,paymode,userName,detailDate,detailTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod getdetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getdetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getdetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getdetailExecute ]
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

Storage Default
{
<Data name="GetDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.GetDD</DataLocation>
<DefaultData>GetDDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.GetDD</IdLocation>
<IndexLocation>^web.GetDI</IndexLocation>
<StreamLocation>^web.GetDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
