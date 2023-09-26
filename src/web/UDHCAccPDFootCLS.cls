Import SQLUser

Class web.UDHCAccPDFootCLS Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 41;

ClassMethod getPDbyUser(itmjs As %Library.String = "", itmjsex As %Library.String = "", userid As %Library.String = "") As %String
{
   s rtn=..getPDbyUser1(userid)
   q rtn
}

ClassMethod getPDbyUser1(userid As %Library.String = "") As %String
{
   q:userid="" "-1"
   q:'$d(^DHCACDi("AccM",0,"User",userid)) "-2"
   k pdPLIST
   s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
   s footnum=0,refundnum=0,rcptstr=""
   s stdate="",sttime="",enddate="",endtime=""
   s rtn=..getUserPDFootLast(userid)
   i +rtn>"0"  s stdate=$p(rtn,"^",2),sttime=$p(rtn,"^",3)
   ;b
   s pddate=+rtn
   f  s pddate=$o(^DHCACDi("AccM",0,"User",userid,pddate)) q:pddate=""  d
   .s accid="0"
   .f  s accid=$o(^DHCACDi("AccM",0,"User",userid,pddate,accid)) q:accid=""  d
   ..s pdsub="0"
   ..f  s pdsub=$o(^DHCACDi("AccM",0,"User",userid,pddate,accid,"AccPD",pdsub)) q:pdsub=""  d
   ...s footid=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",7)
   ...;
   ...q:footid'=""
   ...i (+rtn="0")&(footnum=0)  d
   ....s stdate=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",3)
   ....i stdate'=""  s stdate=$ZD(stdate,4)
   ....s sttime=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",4)
   ....i sttime'=""  s sttime=$ZT(sttime)
   ...s footnum=footnum+1
   ...s pdPLIST(footnum)=accid_"||"_pdsub
   ...s pdPLIST=footnum
   ...s pdamt=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",2)
   ...s pmsub="0"
   ...f  s pmsub=$o(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub)) q:pmsub=""  d
   ....s pmid=$p(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub),"^",1)
   ....q:pmid=""
   ....s pmdesc=$p(^CT("CTPM",pmid),"^",2)
   ....i pmdesc="现金" s cashsum=cashsum+pdamt
   ....i pmdesc="支票" s chequesum=chequesum+pdamt
   ...s footsum=footsum+pdamt
   ...i pdamt>0  s pdsum=pdsum+pdamt
   ...i pdamt<0  s refundsum=refundsum-pdamt,refundnum=refundnum+1
   ...s receiptsno=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",6)
   ...s rcptstr=..getrcptstr(rcptstr,receiptsno)
   q:footnum=0 "-2"
   s othersum=footsum-cashsum-chequesum
   s enddate=$ZD(+$H,4),endtime=$ZT($p($H,",",2))
   s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr
   q rtn
}

ClassMethod getUserPDFootLast(userid As %Library.String = "") As %String
{
   q:'$d(^DHCACDi("AccPDFL",0,"OperUser",userid)) "0^^"
   s lastfootdate1="",lastfoottime1=""
   s lastdate=$o(^DHCACDi("AccPDFL",0,"OperUser",userid,""),-1)
   s lastfootid=$o(^DHCACDi("AccPDFL",0,"OperUser",userid,lastdate,""),-1)
   s lastfootdate=$p(^DHCACD("AccPDFL",lastfootid),"^",1)
   i lastfootdate'=""  s lastfootdate1=$ZD(lastfootdate,4)
   s lastfoottime=$p(^DHCACD("AccPDFL",lastfootid),"^",2)
   i lastfoottime'=""  s lastfoottime1=$ZT(lastfoottime)
   s lastdate=lastdate-1
   q lastdate_"^"_lastfootdate1_"^"_lastfoottime1_"^"_lastfootdate_"^"_lastfoottime
}

ClassMethod getrcptstr(rcptstr As %Library.String = "", receiptsno As %Library.String = "") As %String
{
   s receiptsno=""
   
   q rcptstr
}

ClassMethod FootPDbyUser(userid As %String, num As %String, sum As %String) As %String
{
   
   s rtn=..getPDbyUser1(userid)
   q:+rtn<0 rtn
   s pdnum0=+rtn
   q:pdnum0'=num "-3"
   s pdsum0=$p(rtn,"^",3)
   q:pdsum0'=sum "-3"
   s str=rtn
   k PLIST
   s PLIST(2)=+$H
   s PLIST(3)=$p($H,",",2)
   s PLIST(4)=userid
   i $g(lastfootdate)'=""  s PLIST(5)=lastfootdate
   i $g(lastfoottime)'=""  s PLIST(6)=lastfoottime
   s PLIST(7)=userid
   s PLIST(15)=$p(str,"^",1)
   s PLIST(16)=$p(str,"^",2)
   s PLIST(17)=$p(str,"^",3)
   s PLIST(18)=$p(str,"^",4)
   s PLIST(19)=$p(str,"^",5)
   s PLIST(20)=$p(str,"^",6)
   s PLIST(21)=$p(str,"^",7)
   s PLIST(22)=$p(str,"^",8)
   s PLIST(8)=$p(str,"^",9)
   s PLIST(9)=$p(str,"^",10)
   s PLIST(10)=$p(str,"^",11)
   s PLIST(11)=$p(str,"^",12)
   s PLIST(23)=$p(str,"^",13)
   
   s $ZT="ERROR^DHCSSERR" d ##Class(web.UDHCCardRef).tb()
	
	s rtn=##Class(web.UDHCAccPDFootLog).INSERT()
	i (rtn=0)&($g(myRowID)'="")  d          //s rtn=..DepositFootUpdate(myRowID)
	.&sql(update DHC_AccPreDeposit set AccPD_PDFoot_DR=:myRowID where AccPD_User_DR=:userid and (AccPD_PDFoot_DR is null or AccPD_PDFoot_DR=""))
	.s rtn=SQLCODE
	i rtn=0  d ##Class(web.UDHCCardRef).tc()
	e  TROLLBACK
   q rtn
}

ClassMethod getPDbyFootID(FootID As %Library.String = "") As %String
{
   q:FootID="" "-1"
   q:'$d(^DHCACD("AccPDFL",FootID)) "-2"
   k pdPLIST
   s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
   s footnum=0,refundnum=0,rcptstr=""
   s stdate="",sttime="",enddate="",endtime=""
   s str=^DHCACD("AccPDFL",FootID)
   s footnum=$p(str,"^",14),refundnum=$p(str,"^",15),footsum=$p(str,"^",16),pdsum=$p(str,"^",17),refundsum=$p(str,"^",18),cashsum=$p(str,"^",19),chequesum=$p(str,"^",20),othersum=$p(str,"^",21)
   s stdate=$p(str,"^",7),sttime=$p(str,"^",8),enddate=$p(str,"^",9),endtime=$p(str,"^",10),rcptstr=$p(str,"^",22)
   s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr
   q rtn
}

ClassMethod FindFootClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFootExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindFootExecute(ByRef qHandle As %Binary, UserID As %String, RecStartDate As %String, RecEndDate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i ($g(UserID)="")!(RecStartDate="")!(RecEndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	f fdate=RecStartDate:1:RecEndDate  d
	.s rowid=0
	.s rowid=$o(^DHCACDi("AccPDFL",0,"OperUser",UserID,fdate,""))
	.q:rowid'>0
	.s tdate=$zd($p(^DHCACD("AccPDFL",rowid),"^",1),4)
	.s ttime=$zt($p(^DHCACD("AccPDFL",rowid),"^",2))
	.s tsum=$j($p(^DHCACD("AccPDFL",rowid),"^",16),3,2)
	.s tid=rowid
	.
 	.Do OutputRow1	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow1
	set Data=$lb(tdate,ttime,tsum,tid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFootFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFootExecute ]
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

Query FindFoot(UserID As %String, RecStartDate As %String, RecEndDate As %String) As %Query(ROWSPEC = "Tdate:%String,Ttime:%String,Tsum:%String,TID:%String")
{
}

}
