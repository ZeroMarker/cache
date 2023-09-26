Class web.DHCPE.Report.RegNum Extends %Persistent
{

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.RegNum","GetRegNum","","")

Query GetRegNum(BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Query(ROWSPEC = "yyyymmddDate:%String,Total1:%String,Total2:%String,Total3:%String,Date:%String")
{
}

ClassMethod GetRegNumExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "") As %Status
{
	s ind=1
 	s id=0
 	Set repid=$I(^CacheTemp)
 	i (BeginDate="")&&(EndDate="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s UserID=%session.Get("LOGON.USERID")
 	k ^TempDHCPE("RegNum",UserID)
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 

	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H
	s date=BeginDate-1
	f  s date=$O(^DHCPEUSERREPORT(0,"DATE",date)) q:(date="")||(date>EndDate)  d
	.s rptID=0
	.f  s rptID=$O(^DHCPEUSERREPORT(0,"DATE",date,rptID)) q:(rptID="")  d
	..s invID=0
	..f  s invID=$O(^DHCPEINVPRT(0,"REPORT",rptID,invID)) q:invID=""  d
	...s pbid=$P(^DHCPEINVPRT(invID),"^",3)
	...s paadm=$P(^DHCPEINVPRT(invID),"^",2)
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm)        //Add by 090702
  	...q:LocFlag=1
	...s oldInvID=$P(^DHCPEINVPRT(invID),"^",9)
	...s Flag=1 //退的标志  0正常
	...i oldInvID'="" s Flag=-1
	...s papbid=$O(^DHCPEPAPBR(0,"PBDR",pbid,0))
	...q:papbid=""
	...s paid=$p(^DHCPEPAPBR(papbid),"^",1)
	...s preIADM=0
	...f  s preIADM=$O(^DHCPEPreIADM(0,"PAORDITEM",paid,preIADM)) q:preIADM=""  d
	....s sub=0
	....f  s sub=$O(^DHCPEPreIADM(0,"PAORDITEM",paid,preIADM,sub)) q:sub=""  d
	.....s arcItemID=$P(^DHCPEPreIADM(preIADM,"ORDITEM",sub),"^",1)
	.....i (arcItemID="1688||1")||(arcItemID="22541||1") d //25块的
	......s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arcItemID)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arcItemID))+(Flag*1)
	......s ^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,arcItemID,preIADM)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,arcItemID,preIADM))+(Flag*1)
	......s ^TempDHCPE("RegNum",UserID,"Total",arcItemID)=+$G(^TempDHCPE("RegNum",UserID,"Total",arcItemID))+(Flag*1)
	......s ^TempDHCPE("RegNum",UserID,"PreIADM",date,preIADM)=""
	....i '$D(^TempDHCPE("RegNum",UserID,"PreIADM",date,preIADM)) d
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,"Other")=+$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,"Other"))+(Flag*1)
	.....s ^TempDHCPE("RegNum",UserID,"Total","Other")=+$G(^TempDHCPE("RegNum",UserID,"Total","Other"))+(Flag*1)
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,"Other",preIADM)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,"Other",preIADM))+(Flag*1)
	....k ^TempDHCPE("RegNum",UserID,"PreIADM",date,preIADM)
	s date=0
	f  s date=$O(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date)) q:date=""  d
	.s arc="1688||1"
	.s total1=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc))
	.s arc="22541||1"
	.s total2=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc))
	.s arc="Other"
	.s total3=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,"Other"))
	.s yyyymmddDate=##class(websys.Conversions).DateLogicalToHtml(date)
	.d GetRegNumOut
 	 
 	s yyyymmddDate="合计"
 	s arc="1688||1"
	s total1=$G(^TempDHCPE("RegNum",UserID,"Total",arc))
	s arc="22541||1"
	s total2=$G(^TempDHCPE("RegNum",UserID,"Total",arc))
	s arc="Other"
	s total3=$G(^TempDHCPE("RegNum",UserID,"Total",arc))
	s date=""
	d GetRegNumOut
 	 
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
GetRegNumOut
    s Data=$LB(yyyymmddDate,total1,total2,total3,date)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetRegNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegNumExecute ]
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

ClassMethod GetRegNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegNumExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRegNum(startDate, endDate)
{
	
	s UserID="1"
	k ^TempDHCPE("RegNum",UserID)
	i startDate="" s startDate=1
	i endDate="" s endDate=+$H
	s date=startDate-1
	f  s date=$O(^DHCPEUSERREPORT(0,"DATE",date)) q:(date="")||(date>endDate)  d
	.s rptID=0
	.f  s rptID=$O(^DHCPEUSERREPORT(0,"DATE",date,rptID)) q:(rptID="")  d
	..s invID=0
	..f  s invID=$O(^DHCPEINVPRT(0,"REPORT",rptID,invID)) q:invID=""  d
	...s pbid=$P(^DHCPEINVPRT(invID),"^",3)
	...s paadm=$P(^DHCPEINVPRT(invID),"^",2)
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm)        //Add by 090702
  	...q:LocFlag=1
	
	...s oldInvID=$P(^DHCPEINVPRT(invID),"^",9)
	...s Flag=1 //退的标志  0正常
	...i oldInvID'="" s Flag=-1
	...s papbid=$O(^DHCPEPAPBR(0,"PBDR",pbid,0))
	...q:papbid=""
	...s paid=$p(^DHCPEPAPBR(papbid),"^",1)
	...s preIADM=0
	...f  s preIADM=$O(^DHCPEPreIADM(0,"PAORDITEM",paid,preIADM)) q:preIADM=""  d
	....s sub=0
	....f  s sub=$O(^DHCPEPreIADM(0,"PAORDITEM",paid,preIADM,sub)) q:sub=""  d
	.....s arcItemID=$P(^DHCPEPreIADM(preIADM,"ORDITEM",sub),"^",1)
	.....i (arcItemID="1688||1")||(arcItemID="22541||1") d //25块的
	......s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arcItemID)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arcItemID))+(Flag*1)
	......s ^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,arcItemID,preIADM)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,arcItemID,preIADM))+(Flag*1)
	......s ^TempDHCPE("RegNum",UserID,"PreIADM",date,preIADM)=""
	....i '$D(^TempDHCPE("RegNum",UserID,"PreIADM",date,preIADM)) d
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,"Other")=+$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,"Other"))+(Flag*1)
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,"Other",preIADM)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,"Other",preIADM))+(Flag*1)
	....k ^TempDHCPE("RegNum",UserID,"PreIADM",date,preIADM)
	s date=0
	f  s date=$O(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date)) q:date=""  d
	.s arc="1688||1"
	.s total1=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc))
	.s arc="22541||1"
	.s total2=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc))
	.s arc="Other"
	.s total3=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,"Other"))
	.s yyyymmddDate=$ZD(date,3)
	.w yyyymmddDate_"^"_total1_"^"_total2_"^"_total3,!
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.RegNum","GetItem","","")

Query GetItem(BeginDate As %Library.String = "", EndDate As %Library.String = "", ArcItemID As %String = "") As %Query(ROWSPEC = "yyyymmddDate:%String,Total1:%String,Total2:%String,Total3:%String,Date:%String")
{
}

ClassMethod GetItemExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", ArcItemID) As %Status
{
	s ind=1
 	s id=0
 	Set repid=$I(^CacheTemp)
 	
 	i (ArcItemID="")
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s UserID=%session.Get("LOGON.USERID")
 	k ^TempDHCPE("RegNum",UserID)
 	
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	i BeginDate="" s BeginDate=1
	i EndDate="" s EndDate=+$H
	s date=BeginDate-1
	/*
	f  s date=$O(^DHCPEUSERREPORT(0,"DATE",date)) q:(date="")||(date>EndDate)  d
	.s rptID=0
	.f  s rptID=$O(^DHCPEUSERREPORT(0,"DATE",date,rptID)) q:(rptID="")  d
	..s invID=0
	..f  s invID=$O(^DHCPEINVPRT(0,"REPORT",rptID,invID)) q:invID=""  d
	*/
	f  s date=$O(^DHCPEINVPRT(0,"RPDATE",date)) q:(date="")||(date>EndDate)  d
	.s User=""
	.f  s User=$o(^DHCPEINVPRT(0,"RPDATE",date,User)) q:User=""  d
	..s invID=0 
	..f  s invID=$o(^DHCPEINVPRT(0,"RPDATE",date,User,invID)) q:invID=""  d
	...s pbid=$P(^DHCPEINVPRT(invID),"^",3)
	...s paadm=$P(^DHCPEINVPRT(invID),"^",2)
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",paadm)        //Add by 090702
  	...q:LocFlag=1
	
	...s oldInvID=$P(^DHCPEINVPRT(invID),"^",9)
	...s Flag=1 //退的标志  0正常
	...i oldInvID'="" s Flag=-1
	...s papbid=$O(^DHCPEPAPBR(0,"PBDR",pbid,0))
	...q:papbid=""
	...s paid=$p(^DHCPEPAPBR(papbid),"^",1)
	...s preIADM=0
	...f  s preIADM=$O(^DHCPEPreIADM(0,"PAORDITEM",paid,preIADM)) q:preIADM=""  d
	....s sub=0
	....f  s sub=$O(^DHCPEPreIADM(0,"PAORDITEM",paid,preIADM,sub)) q:sub=""  d
	.....s amount=+##class(web.DHCPE.Cashier).GetFactAmount("1",preIADM_"||"_sub,paid)
	.....s arcItemID=$P(^DHCPEPreIADM(preIADM,"ORDITEM",sub),"^",1)
	.....q:ArcItemID'=arcItemID
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arcItemID)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arcItemID))+(Flag*1)
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMAmount",date,arcItemID)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMAmount",date,arcItemID))+(Flag*amount)
	.....s ^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,arcItemID,preIADM)=+$G(^TempDHCPE("RegNum",UserID,"ARCIMDetail",date,arcItemID,preIADM))+(Flag*1)
	.....s ^TempDHCPE("RegNum",UserID,"Total",arcItemID)=+$G(^TempDHCPE("RegNum",UserID,"Total",arcItemID))+(Flag*1)
	.....s ^TempDHCPE("RegNum",UserID,"Amount",arcItemID)=+$G(^TempDHCPE("RegNum",UserID,"Amount",arcItemID))+(Flag*amount)
	s date=0
	f  s date=$O(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date)) q:date=""  d
	.s arc=ArcItemID
	.s total1=$G(^TempDHCPE("RegNum",UserID,"ARCIMTotal",date,arc))
	.s amount=$G(^TempDHCPE("RegNum",UserID,"ARCIMAmount",date,arc))
	.s yyyymmddDate=##class(websys.Conversions).DateLogicalToHtml(date)
	.d GetItemOut
 	 
 	s yyyymmddDate="合计"
 	s date=""
 	s arc=ArcItemID
	s total1=$G(^TempDHCPE("RegNum",UserID,"Total",arc))
	s amount=$G(^TempDHCPE("RegNum",UserID,"Amount",arc))
	d GetItemOut
 	 
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
GetItemOut
    s Data=$LB(yyyymmddDate,total1,amount,date)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemExecute ]
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

ClassMethod GetItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetRegNumDetail(Date As %Library.String = "", ArcimID As %Library.String = "") As %Query(ROWSPEC = "yyyymmddDate:%String,regNo:%String,Name:%String,Tel:%String")
{
}

// yyyymmddDate,total1,total2,total3,date

ClassMethod GetRegNumDetailExecute(ByRef qHandle As %Binary, Date As %Library.String = "", ArcimID As %Library.String = "") As %Status
{
	s ind=1
 	s id=0
 	Set repid=$I(^CacheTemp)
 	s UserID=%session.Get("LOGON.USERID")
 	i Date="" d
 	.f  s Date=$O(^TempDHCPE("RegNum",UserID,"ARCIMDetail",Date)) q:Date=""  d
 	..s preIADM=""
 	..f  s preIADM=$O(^TempDHCPE("RegNum",UserID,"ARCIMDetail",Date,ArcimID,preIADM)) q:preIADM=""  d
 	...d GetOneInfo(preIADM)
 	e  d
 	.s preIADM=""
 	.f  s preIADM=$O(^TempDHCPE("RegNum",UserID,"ARCIMDetail",Date,ArcimID,preIADM)) q:preIADM=""  d
 	..d GetOneInfo(preIADM)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOneInfo(preIADM)
	s yyyymmddDate=$ZD(Date,3)
	s ibaseInfoID=$P(^DHCPEPreIADM(preIADM),"^",1)
	s regNo=$P(^DHCPEPreIBI(ibaseInfoID),"^",1)
	s Name=$P(^DHCPEPreIBI(ibaseInfoID),"^",2)
	s Tel=$P(^DHCPEPreIBI(ibaseInfoID),"^",8)
	i Tel="" s Tel=$P(^DHCPEPreIBI(ibaseInfoID),"^",6)
	i Tel="" s Tel=$P(^DHCPEPreIBI(ibaseInfoID),"^",7)
	d GetRegNumDetailOut
 	q
 	 
   	 	
GetRegNumDetailOut
    s Data=$LB(yyyymmddDate,regNo,Name,Tel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetRegNumDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegNumDetailExecute ]
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

ClassMethod GetRegNumDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegNumDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="RegNumDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.Report.RegNumD</DataLocation>
<DefaultData>RegNumDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.Report.RegNumD</IdLocation>
<IndexLocation>^web.DHCPE.Report.RegNumI</IndexLocation>
<StreamLocation>^web.DHCPE.Report.RegNumS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
