Class web.DHCPE.Report.AppiontArrDateStatitic Extends %RegisteredObject
{

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.AppiontArrDateStatitic","AppiontArrDateStatitic","62000","")

Query AppiontArrDateStatitic(DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String, TName:%String, TSexName:%String, TAge:%String, TGroupName:%String,TRegArrDate:%String")
{
}

ClassMethod AppiontArrDateStatiticExecute(ByRef qHandle As %Binary, DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Status
{
 	s ind=2
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if (""=DateFrom)&&(""=DateTo){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
 	i DateTo'=""   s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
 	
 	s CurUserID=%session.Get("LOGON.USERID")   
 	k ^DHCPETMP
 	k ^DHCPETMP("ExportAppiontArrDateStatitic",CurUserID)	 
 	i DateFrom=""  s DateFrom=1
 	i DateFrom'=""  s Date=DateFrom-1
 	i DateFrom=""  s DateFrom=0

 	f  s Date=$o(^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","Date",Date))  q:(Date="")||((DateTo'="")&&(DateTo<Date))  d
 	.s PreIADM=0
 	.f  s PreIADM=$o(^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","Date",Date,PreIADM))  q:PreIADM=""  d
 	..s PIBIID=$P(^DHCPEPreIADM(PreIADM),"^",1)
 	..q:PIBIID=""
 	..s PatRegNo=$p(^DHCPEPreIBI(PIBIID),"^", 1)
 	..s PatName=$p(^DHCPEPreIBI(PIBIID),"^", 2)
 	..s PatSexName=""
 	..s PatSex=$p(^DHCPEPreIBI(PIBIID),"^", 3)
 	..i PatSex'=""  s PatSexName=$p(^CT("SEX",PatSex),"^",2)
 	..S Dob=""
	..s Dob=$p(^DHCPEPreIBI(PIBIID),"^",4)
 	..i Dob'="" s PAPERDob=$ZD(Dob,3)
 	..s Age=""
 	..s:(""'=Dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(Dob,+$h)
 	..s Age=$P(Age,"Y")
 	..s Age=Age_" 岁"
 	..s PGADMDR=$P(^DHCPEPreIADM(PreIADM),"^",2)
 	..s GName=""
 	..i PGADMDR'=""  d
 	...s PGBID=$P(^DHCPEPreGADM(PGADMDR),"^",1)
 	...i PGBID'=""  s GName=$p(^DHCPEPreGBI(PGBID),"^",2)
 	..s RegDate=##class(websys.Conversions).DateLogicalToHtml(Date)
 	..s ^DHCPETMP("TotalRegArriveDate")=+$g(^DHCPETMP("TotalRegArriveDate"))+1
    ..d QueryOut
    
    s ind=1
    s Total=$G(^DHCPETMP("TotalRegArriveDate"))
    s PatRegNo="合计"
    s PatName=Total_"人"
    s PatSexName=""
    s Age=""
    s GName=""
    s RegDate=""
    d QueryOut
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
QueryOut
    s Data=$LB(PatRegNo, PatName,PatSexName, Age, GName, RegDate)
 	Set ^CacheTemp(repid,ind)=Data
    s ^DHCPETMP("ExportAppiontArrDateStatitic",CurUserID,ind)=PatRegNo_"^"_PatName_"^"_PatSexName_"^"_Age_"^"_GName_"^"_RegDate    //add by zl
    Set ind=ind+1
 	q
}

ClassMethod AppiontArrDateStatiticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AppiontArrDateStatiticExecute ]
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

ClassMethod AppiontArrDateStatiticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AppiontArrDateStatiticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRowNum() As %Status
{
  
	s CurUserID=%session.Get("LOGON.USERID")
	s StrNum=""
	s num=0
	f  s num=$o(^DHCPETMP("ExportAppiontArrDateStatitic",CurUserID,num))  q:num=""  d
	.i StrNum=""  s StrNum=num
	.else  s StrNum=StrNum_"^"_num

	q StrNum
}

ClassMethod ExportInfo(Num) As %Status
{
	q:Num="" ""
	s UserID=%session.Get("LOGON.USERID")
 	s Data=$G(^DHCPETMP("ExportAppiontArrDateStatitic",UserID,Num))
	Q Data
}

}
