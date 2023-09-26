Class web.DHCPE.Report.CashierNotesStatistic Extends %RegisteredObject
{

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.AppiontArrDateStatitic","AppiontArrDateStatitic","62000","")

Query CashierNotesStatistic(DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String, TName:%String, TSexName:%String, TAge:%String, TPrintDate:%String,TAmount:%String")
{
}

ClassMethod CashierNotesStatisticExecute(ByRef qHandle As %Binary, DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Status
{
 	s ind=2
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if (""=DateFrom)&&(""=DateTo){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s CurUserID=%session.Get("LOGON.USERID")   
 	k ^DHCPETMP
 	k ^DHCPETMP("ExportCaShierData",CurUserID)
 		
 	i DateFrom'=""  s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
 	i DateTo'=""  s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
 	
 	
 	i DateFrom="" s DateFrom=1
 	i DateFrom'=""  s Date=DateFrom-1
 	i DateFrom=""  s DateFrom=0
 	f  s Date=$o(^DHCPEDataEx("DHCPEPreIADM","CaShierData",Date))  q:(Date="")||(Date="ADM")||((DateTo'="")&&(Date>DateTo))  d
 	.s PreIADM=0
 	.f  s PreIADM=$o(^DHCPEDataEx("DHCPEPreIADM","CaShierData",Date,PreIADM))  q:PreIADM=""  d
 	..s Amount=$p($g(^DHCPEDataEx("DHCPEPreIADM","CaShierData",Date,PreIADM)),"^",1)
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
 	..s PrintDate=##class(websys.Conversions).DateLogicalToHtml(Date)
 	..s ^DHCPETMP("TotalCashierAmount")=+$g(^DHCPETMP("TotalCashierAmount"))+Amount
    ..d QueryOut
    i DateFrom'=""  s Date=DateFrom-1
 	i DateFrom=""  s DateFrom=0
    f  s Date=$o(^DHCPEDataEx("DHCPEPreGADM","CaShierData",Date)) q:(Date="")||(Date="ADM")||((DateTo'="")&&(Date>DateTo))  d
 	.s PreGADM=0
 	.f  s PreGADM=$o(^DHCPEDataEx("DHCPEPreGADM","CaShierData",Date,PreGADM))  q:PreGADM=""  d
 	..s Amount=$p($g(^DHCPEDataEx("DHCPEPreGADM","CaShierData",Date,PreGADM)),"^",1)
 	..s PGBIDR=$P(^DHCPEPreGADM(PreGADM),"^",1)
 	..q:PGBIDR=""
 	..s PatRegNo=$p(^DHCPEPreGBI(PGBIDR),"^", 13)
 	..s PatName=$p(^DHCPEPreGBI(PGBIDR),"^", 2)
 	..s PatSexName=""
 	..s PatSex=""
 	..S PAPERDob=""
 	..s Age=""
 	..s PrintDate=##class(websys.Conversions).DateLogicalToHtml(Date)
 	..s ^DHCPETMP("TotalCashierAmount")=+$g(^DHCPETMP("TotalCashierAmount"))+Amount
    ..d QueryOut
    
    s ind=1
    s Amount=$G(^DHCPETMP("TotalCashierAmount"))
    s PatRegNo="合计"
    s PatName=""
    s PatSexName=""
    s Age=""
    s GName=""
    s PrintDate=""
    d QueryOut
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
QueryOut
    s Data=$LB(PatRegNo, PatName,PatSexName, Age, PrintDate,Amount)
 	Set ^CacheTemp(repid,ind)=Data
    s ^DHCPETMP("ExportCaShierData",CurUserID,ind)=PatRegNo_"^"_PatName_"^"_PatSexName_"^"_Age_"^"_PrintDate_"^"_Amount    //add by zl
    Set ind=ind+1
 	q
}

ClassMethod CashierNotesStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CashierNotesStatisticExecute ]
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

ClassMethod CashierNotesStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CashierNotesStatisticExecute ]
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
	f  s num=$o(^DHCPETMP("ExportCaShierData",CurUserID,num))  q:num=""  d
	.i StrNum=""  s StrNum=num
	.else  s StrNum=StrNum_"^"_num

	q StrNum
}

ClassMethod ExportInfo(Num) As %Status
{
	q:Num="" ""
	s UserID=%session.Get("LOGON.USERID")
 	s Data=$G(^DHCPETMP("ExportCaShierData",UserID,Num))
	Q Data
}

}
