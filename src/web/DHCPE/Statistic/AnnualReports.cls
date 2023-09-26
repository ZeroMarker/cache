Class web.DHCPE.Statistic.AnnualReports Extends %Persistent
{

/// Creator：      ln
/// CreateDate：   2019-09-24
/// Description:：体检中心年度报表
/// Table：       DHC_PE_AdmRecordManager,DHC_PE_InvPrt 
/// Input：       BeginDate,EndDate
/// Output：      ^TempDHCPEAnnualReport(Job)
/// Return：无        
/// Others：d ##class(web.DHCPE.Statistic.AnnualReports).SetGlobalNum("2020-03-01","2020-04-18","304","11849")
ClassMethod SetGlobalNum(BeginDate As %Library.String = "", EndDate As %Library.String = "", CurLoc As %Library.String = "", CurUser As %Library.String = "")
{
	s Job=CurUser
    s ^TempDHCPEAnnualReport("AnnualReport")=BeginDate_"^"_EndDate_"^"_CurLoc_"^"_CurUser
	k ^TempDHCPEAnnualReport(Job)
	i (BeginDate="")&&(EndDate="") q "-1^日期不能都为空"
	
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=+$H
	i EndDate="" s EndDate=+$H
	i +$zd(BeginDate,3)'=+$zd(EndDate,3) q "-1^不能跨年选择日期"
	
	s Date=BeginDate-1
	f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date)) q:(Date="")||(Date>EndDate)  d
	.s Time=""
	.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
	..s IADM=0
	..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM)) q:(IADM="")  d
	...s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM,CurLoc) 
	...q:LocFlag=1
	...s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	...q:Status'="ARRIVED"
	...s PreGADM=$p(^DHCPEPreIADM(PreIADM),"^",2)
	...s Type="I"
	...i PreGADM'="" s Type="G"
	...s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	...s VIPDesc=$p(VIPLevel,"^",2)
	...s VIPLevel=$p(VIPLevel,"^",1)
	...s ArrDate=##class(websys.Conversions).DateLogicalToHtml(Date)
	...s:ArrDate["-" Month=+$p(ArrDate,"-",2)
	...s:ArrDate["/" Month=+$p(ArrDate,"/",2)
	...s ^TempDHCPEAnnualReport(Job,"PersonList",Month,VIPLevel,Type)=$G(^TempDHCPEAnnualReport(Job,"PersonList",Month,VIPLevel,Type))+1
	...s ^TempDHCPEAnnualReport(Job,"PersonType",Type,Month)=$G(^TempDHCPEAnnualReport(Job,"PersonType",Type,Month))+1

    s Date=BeginDate-1
    f  s Date=$o(^DHCPEINVPRT(0,"DATE",Date)) q:((Date="")||(Date>EndDate))  d
    .s PRTRowID=""
    .f  s PRTRowID=$o(^DHCPEINVPRT(0,"DATE",Date,PRTRowID)) q:PRTRowID=""  d
    ..s Flag=$p(^DHCPEINVPRT(PRTRowID),"^",8)
    ..s FH=1
    ..s:Flag'="N" FH=-1
    ..s Amount=$p(^DHCPEINVPRT(PRTRowID),"^",7)
    ..s PayDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    ..s:PayDate["-" Month=+$p(PayDate,"-",2)
    ..s:PayDate["/" Month=+$p(PayDate,"/",2)
    ..s PAADM=$p(^DHCPEINVPRT(PRTRowID),"^",2)
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CurLoc) 
    ..q:LocFlag=1
    ..s Type="I"
    ..i '$D(^DHCPEIADM(0,"PAADM",PAADM)) s Type="G"
    ..s ^TempDHCPEAnnualReport(Job,"AmountList",Type,Month)=+$G(^TempDHCPEAnnualReport(Job,"AmountList",Type,Month))+Amount
    ..s PBDR=$p(^DHCPEINVPRT(PRTRowID),"^",3)
    ..s PAPBRowID=0
    ..f  s PAPBRowID=$o(^DHCPEPAPBR(0,"PBDR",PBDR,PAPBRowID)) q:PAPBRowID=""  d
    ...s PADR=$p(^DHCPEPAPBR(PAPBRowID),"^",1)
    ...s PreIADM=""
    ...f  s PreIADM=$o(^DHCPEPreIADM(0,"PAORDITEM",PADR,PreIADM)) q:PreIADM=""  d   
    ....s Sub=""
    ....f  s Sub=$o(^DHCPEPreIADM(0,"PAORDITEM",PADR,PreIADM,Sub)) q:Sub=""  d
    .....s childSub=""
    .....f  s childSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PADR,PreIADM,Sub,childSub)) q:childSub=""  d
    ......s FactAmount=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",Sub,"FEE",childSub),"^",2)
    ......s ^TempDHCPEAnnualReport(Job,"PersonPayAmount",PreIADM)=+$G(^TempDHCPEAnnualReport(Job,"PersonPayAmount",PreIADM))+(FactAmount*FH)
    ...s PreIADM=""
    ...f  s PreIADM=$o(^DHCPEPreIADM(0,"PAORDENT",PADR,PreIADM)) q:PreIADM=""  d   
    ....s EntSub=""
    ....f  s EntSub=$o(^DHCPEPreIADM(0,"PAORDENT",PADR,PreIADM,EntSub)) q:EntSub=""  d
    .....s EntchildSub=""
    .....f  s EntchildSub=$o(^DHCPEPreIADM(0,"PAORDENT",PADR,PreIADM,EntSub,EntchildSub)) q:EntchildSub=""  d
    ......s FactAmount=$p(^DHCPEPreIADM(PreIADM,"ORDENT",EntSub,"FEE",EntchildSub),"^",2)
    ......s ^TempDHCPEAnnualReport(Job,"PersonPayAmount",PreIADM)=+$G(^TempDHCPEAnnualReport(Job,"PersonPayAmount",PreIADM))+(FactAmount*FH)
     
    
    q "0"
}

/// w ##class(web.DHCPE.Statistic.AnnualReports).GetFeeRange("-380")
ClassMethod GetFeeRange(Amount)
{
	s FeeRange=""
	s ^DHCPESetting("Statistic","FeeRange")="<500^501-1000^1001-2000^2001-5000^5001-10000^>10000"
	s RangeStr=$G(^DHCPESetting("Statistic","FeeRange"))
	s Len=$L(RangeStr,"^")
	f i=1:1:Len d
	.s Range=$p(RangeStr,"^",i)
	.s Flag=..GetRangeFlag(Range,Amount)
	.q:Flag=0
	.s FeeRange=i_"^"_Range
	q FeeRange
}

/// w ##class(web.DHCPE.Statistic.AnnualReports).GetRangeFlag("")
ClassMethod GetRangeFlag(Range, Amount)
{
	s Flag=0
	q:Range="" Flag
	i Range["<" d
	.s Range=$p(Range,"<",2)
	.s EqualFlag=0
	.i Range["=" d
	..s Range=$p(Range,"=",2)
	..s EqualFlag=1
	.s Range=+Range
	.s:(EqualFlag=1)&&(Amount<=Range) Flag=1
	.s:(EqualFlag=0)&&(Amount<Range) Flag=1
	e  i Range[">" d
	.s Range=$p(Range,">",2)
	.s EqualFlag=0
	.i Range["=" d
	..s Range=$p(Range,"=",2)
	..s EqualFlag=1
	.s Range=+Range
	.s:(EqualFlag=1)&&(Amount>=Range) Flag=1
	.s:(EqualFlag=0)&&(Amount>Range) Flag=1
	e  d
	.s RangeLow=$p(Range,"-",1)
	.s RangeHigh=$p(Range,"-",2)
	.i (Amount>=RangeLow)&&(Amount<=RangeHigh) s Flag=1
	q Flag
}

/// Creator：      ln
/// CreateDate：   2019-09-20
/// Description:：体检中心年度报表
/// Table：       ^TempDHCPEAnnualReport(Job,"PersonList")
/// Input：       USERID
/// Output：      Month:月份,VIPLevel:VIP,VIPDesc:VIP描述,Type:I/G,Num:人数
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.AnnualReports","PEAnnualReport","2022-08-01","2022-08-31","18853")                       
Query PEAnnualReport(BeginDate As %Library.String = "", EndDate As %Library.String = "", CurUser As %Library.String = "") As %Query(ROWSPEC = "Month:%String,VIPLevel:%String,VIPDesc:%String,Type:%String,Num:%Float") [ SqlProc ]
{
}

ClassMethod PEAnnualReportExecute(ByRef qHandle As %Binary, BeginDate As %Library.String = "", EndDate As %Library.String = "", CurUser As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i (BeginDate="")&(EndDate="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
 	s Job=CurUser
	
	s Month=0
	f  s Month=$o(^TempDHCPEAnnualReport(Job,"PersonList",Month)) q:Month=""  d
	.s VIPLevel=""
	.f  s VIPLevel=$o(^TempDHCPEAnnualReport(Job,"PersonList",Month,VIPLevel)) q:VIPLevel=""  d
	..s VIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPLevel)),3)
	..s Type=""
	..f  s Type=$o(^TempDHCPEAnnualReport(Job,"PersonList",Month,VIPLevel,Type)) q:Type=""  d
	...s Num=$G(^TempDHCPEAnnualReport(Job,"PersonList",Month,VIPLevel,Type))
	...d OutAnnualDetail
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutAnnualDetail
	set Data=$lb(Month,VIPLevel,VIPDesc,Type,Num)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PEAnnualReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PEAnnualReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod PEAnnualReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PEAnnualReportExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ln
/// CreateDate：   2019-09-24
/// Description:：体检中心年度报表
/// Table：       ^TempDHCPEAnnualReport(Job,"PersonType")
/// Input：       USERID
/// Output：      Type:类型,TypeDesc:描述,Num:人数
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.AnnualReports","PEAnnualReportByMonth","11849")                       
Query PEAnnualReportByMonth(CurUser As %Library.String = "") As %Query(ROWSPEC = "Type:%String,TypeDesc:%String,Num1:%Float,Num2:%Float,Num3:%Float,Num4:%Float,Num5:%Float,Num6:%Float,Num7:%Float,Num8:%Float,Num9:%Float,Num10:%Float,Num11:%Float,Num12:%Float") [ SqlProc ]
{
}

ClassMethod PEAnnualReportByMonthExecute(ByRef qHandle As %Binary, CurUser As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Job=CurUser
	
	s Type=""
	f  s Type=$o(^TempDHCPEAnnualReport(Job,"PersonType",Type)) q:Type=""  d
	.s:Type="I" TypeDesc="个人"
	.s:Type="G" TypeDesc="团体"
	.f i=1:1:12 d
	..s PLIST(i)=$G(^TempDHCPEAnnualReport(Job,"PersonType",Type,i))
	.d OutMonthDetail
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutMonthDetail
	set Data=$lb(Type,TypeDesc,PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7),PLIST(8),PLIST(9),PLIST(10),PLIST(11),PLIST(12))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PEAnnualReportByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PEAnnualReportByMonthExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod PEAnnualReportByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PEAnnualReportByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ln
/// CreateDate：   2019-09-27
/// Description:：体检中心年度报表
/// Table：       ^TempDHCPEAnnualReport(Job,"PersonPayAmount")
/// Input：       USERID
/// Output：      Range:费用区间,FeeRangeNum:区间人数,PersonNum:总人数,AmountTotal:总金额
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.AnnualReports","FeeRangeAnnualReport","11849")                       
Query FeeRangeAnnualReport(CurUser As %Library.String = "") As %Query(ROWSPEC = "Range:%String,FeeRangeNum:%Float,PersonNum:%Float,AmountTotal:%Float,Average:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod FeeRangeAnnualReportExecute(ByRef qHandle As %Binary, CurUser As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Job=CurUser
	k ^TempDHCPEFeeRangeAnnual(Job)
	
	s PersonNum=0
	s AmountTotal=0
	s PreIADM=""
	f  s PreIADM=$o(^TempDHCPEAnnualReport(Job,"PersonPayAmount",PreIADM)) q:PreIADM=""  d
	.s Amount=$G(^TempDHCPEAnnualReport(Job,"PersonPayAmount",PreIADM))
	.s PersonNum=PersonNum+1
	.s AmountTotal=AmountTotal+Amount
	.s FeeRange=..GetFeeRange(Amount)
	.s No=$p(FeeRange,"^",1)
	.s FeeRange=$p(FeeRange,"^",2)
	.q:FeeRange=""
	.s ^TempDHCPEFeeRangeAnnual(Job,"FeeRange",FeeRange)=$G(^TempDHCPEFeeRangeAnnual(Job,"FeeRange",FeeRange))+1
	
	s Average=0
	i PersonNum'=0 s Average=AmountTotal/PersonNum
	s AmountTotal=AmountTotal/10000
	s RangeStr=$G(^DHCPESetting("Statistic","FeeRange"))
	s Len=$L(RangeStr,"^")
	f i=1:1:Len d
	.s Range=$p(RangeStr,"^",i)
	.s Num=""
	.s Num=$G(^TempDHCPEFeeRangeAnnual(Job,"FeeRange",Range))
	.s:Num="" Num=0
	.d OutFeeRangeDetail
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutFeeRangeDetail
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2))
	set Data=$lb(Range,Num,PersonNum,AmountTotal,Average,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FeeRangeAnnualReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FeeRangeAnnualReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod FeeRangeAnnualReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FeeRangeAnnualReportExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ln
/// CreateDate：   2019-09-25
/// Description:：体检中心年度报表
/// Table：       ^TempDHCPEAnnualReport(Job,"AmountList")
/// Input：       USERID
/// Output：      Month:月份,VIPLevel:VIP,VIPDesc:VIP描述,Type:I/G,Num:人数
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.AnnualReports","FeeAnnualReport","11849")                       
Query FeeAnnualReport(CurUser As %Library.String = "") As %Query(ROWSPEC = "Type:%String,TypeDesc:%String,Num1:%Float,Num2:%Float,Num3:%Float,Num4:%Float,Num5:%Float,Num6:%Float,Num7:%Float,Num8:%Float,Num9:%Float,Num10:%Float,Num11:%Float,Num12:%Float") [ SqlProc ]
{
}

ClassMethod FeeAnnualReportExecute(ByRef qHandle As %Binary, CurUser As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Job=CurUser
	
	s Type=""
	f  s Type=$o(^TempDHCPEAnnualReport(Job,"AmountList",Type)) q:Type=""  d
	.s:Type="I" TypeDesc="个人"
	.s:Type="G" TypeDesc="团体"
	.f i=1:1:12 d
	..s PLIST(i)=$G(^TempDHCPEAnnualReport(Job,"AmountList",Type,i))
	.d OutFeeMonthDetail
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutFeeMonthDetail
	set Data=$lb(Type,TypeDesc,PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7),PLIST(8),PLIST(9),PLIST(10),PLIST(11),PLIST(12))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FeeAnnualReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FeeAnnualReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	if ind=""
	{
		Set AtEnd=1
		Set Row=""		
	}
	  Else 
	{
		Set Row=^CacheTemp(repid,ind)
		}
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod FeeAnnualReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FeeAnnualReportExecute ]
{
	Set repid=$LIST(qHandle,2)
	kill ^cacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ln
/// CreateDate：   2019-09-26
/// Description:：团体年度报表
/// Table：       DHC_PE_InvPrt  
/// Input：       BeginDate,EndDate
/// Output：      GADM:团体就诊ID,GDesc:团体名称,Amount:%Float,Count:%Float
/// Return：无        
/// Others：d ##class(%ResultSet).RunQuery("web.DHCPE.Statistic.AnnualReports","GroupAnnualReport","2020-03-01","2020-03-24","","304")                       
Query GroupAnnualReport(BeginDate As %Library.String = "", EndDate As %Library.String = "", CurGADM As %Library.String = "", CurLoc As %Library.String = "") As websys.Query(ROWSPEC = "GADM:%String,GDesc:%String,Amount:%Float,Count:%Float,RegNo:%String,Name:%String,Sex:%String,Age:%String,VIPLevel:%String,Tel:%String,CheckDate:%String,GroupName:%String,GTName:%String,PerAmount:%Float,Now:%String") [ SqlProc ]
{
}

ClassMethod GroupAnnualReportExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, CurGADM As %Library.String = "", CurLoc As %Library.String = "") As %Status
{
 
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ((BeginDate="")&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s Job=$j
 	k ^TempDHCPEGroupAnnualReport(Job)
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	
	s Date=BeginDate-1
    f  s Date=$o(^DHCPEINVPRT(0,"DATE",Date)) q:((Date="")||(Date>EndDate))  d
    .s PRTRowID=""
    .f  s PRTRowID=$o(^DHCPEINVPRT(0,"DATE",Date,PRTRowID)) q:PRTRowID=""  d
    ..s PAADM=$p(^DHCPEINVPRT(PRTRowID),"^",2)
    ..q:$D(^DHCPEIADM(0,"PAADM",PAADM)) 
    ..s PRTFlag=$p(^DHCPEINVPRT(PRTRowID),"^",8)
    ..s FH=1
    ..i PRTFlag'="N" s FH=-1
    ..s Amount=$p(^DHCPEINVPRT(PRTRowID),"^",7)
    ..s GADM=$o(^DHCPEGADM(0,"DelegateADM",PAADM,0))
    ..q:GADM=""
    ..q:(CurGADM'="")&&(CurGADM'=GADM)
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",GADM,CurLoc) 
	..q:LocFlag=1
    ..s Count=0
    ..s PBDR=$p(^DHCPEINVPRT(PRTRowID),"^",3)
    ..s PAPBRowID=0
    ..f  s PAPBRowID=$o(^DHCPEPAPBR(0,"PBDR",PBDR,PAPBRowID)) q:PAPBRowID=""  d
    ...s PADR=$p(^DHCPEPAPBR(PAPBRowID),"^",1)
    ...s PreIADM=""
    ...f  s PreIADM=$o(^DHCPEPreIADM(0,"PAORDITEM",PADR,PreIADM)) q:PreIADM=""  d
    ....s Sub=""
    ....f  s Sub=$o(^DHCPEPreIADM(0,"PAORDITEM",PADR,PreIADM,Sub)) q:Sub=""  d
    .....s childSub=""
    .....f  s childSub=$o(^DHCPEPreIADM(0,"PAORDITEM",PADR,PreIADM,Sub,childSub)) q:childSub=""  d
    ......s FactAmount=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",Sub,"FEE",childSub),"^",2)
    ......s ^TempDHCPEGroupAnnualReport(Job,"PersonPayAmount",GADM,PreIADM)=+$G(^TempDHCPEGroupAnnualReport(Job,"PersonPayAmount",GADM,PreIADM))+(FactAmount*FH)
    ....q:$D(^TempDHCPEGroupAnnualReport(Job,"PersonNum",GADM,PreIADM))
    ....s ^TempDHCPEGroupAnnualReport(Job,"PersonNum",GADM,PreIADM)=""
    ....s Count=Count+1
    ...s PreIADM=""
    ...f  s PreIADM=$o(^DHCPEPreIADM(0,"PAORDENT",PADR,PreIADM)) q:PreIADM=""  d
    ....s EntSub=""
    ....f  s EntSub=$o(^DHCPEPreIADM(0,"PAORDENT",PADR,PreIADM,EntSub)) q:EntSub=""  d
    .....s EntchildSub=""
    .....f  s EntchildSub=$o(^DHCPEPreIADM(0,"PAORDENT",PADR,PreIADM,EntSub,EntchildSub)) q:EntchildSub=""  d
    ......s FactAmount=$p(^DHCPEPreIADM(PreIADM,"ORDENT",EntSub,"FEE",EntchildSub),"^",2)
    ......s ^TempDHCPEGroupAnnualReport(Job,"PersonPayAmount",GADM,PreIADM)=+$G(^TempDHCPEGroupAnnualReport(Job,"PersonPayAmount",GADM,PreIADM))+(FactAmount*FH)
    ....q:$D(^TempDHCPEGroupAnnualReport(Job,"PersonNum",GADM,PreIADM))
    ....s ^TempDHCPEGroupAnnualReport(Job,"PersonNum",GADM,PreIADM)=""
    ....s Count=Count+1
    ..s Count=Count*FH
    ..s ^TempDHCPEGroupAnnualReport(Job,"AmountTotal",GADM)=$G(^TempDHCPEGroupAnnualReport(Job,"AmountTotal",GADM))+Amount
    ..s ^TempDHCPEGroupAnnualReport(Job,"PersonTotal",GADM)=$G(^TempDHCPEGroupAnnualReport(Job,"PersonTotal",GADM))+Count
    
    if (CurGADM="")
    {
	    s GADM=""
	    f  s GADM=$o(^TempDHCPEGroupAnnualReport(Job,"AmountTotal",GADM)) q:GADM=""  d
	    .s AmountTotal=$G(^TempDHCPEGroupAnnualReport(Job,"AmountTotal",GADM))
	    .s ^TempDHCPEGroupAnnualReport(Job,"Sequence",AmountTotal,GADM)=""
	    s (AmountTotal,Info,Amount)=""
	    f  s AmountTotal=$o(^TempDHCPEGroupAnnualReport(Job,"Sequence",AmountTotal),-1) q:(AmountTotal="")||(AmountTotal=0)  d
	    .s GADM=""
	    .f  s GADM=$o(^TempDHCPEGroupAnnualReport(Job,"Sequence",AmountTotal,GADM)) q:GADM=""  d
	    ..s GBIDR=$p(^DHCPEGADM(GADM),"^",1)
	    ..s GDesc=$p(^DHCPEGBI(GBIDR),"^",2)
	    ..s Count=$G(^TempDHCPEGroupAnnualReport(Job,"PersonTotal",GADM))   
		..d OutGroupAnnualInfo
    }
    else
    {
	    s (GADM,GDesc,Count,AmountTotal)=""
	    s PreIADM=""
		f  s PreIADM=$o(^TempDHCPEGroupAnnualReport(Job,"PersonPayAmount",CurGADM,PreIADM)) q:PreIADM=""  d
		.s Info=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("Pre",PreIADM)
		.s Amount=$G(^TempDHCPEGroupAnnualReport(Job,"PersonPayAmount",CurGADM,PreIADM))	
		.d OutGroupAnnualInfo
	}
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutGroupAnnualInfo
    set Now=##class(websys.Conversions).DateLogicalToHtml(+$H)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($H,",",2)) 
	set Data=$lb(GADM,GDesc,AmountTotal,Count,$p(Info,"^",1),$p(Info,"^",2),$p(Info,"^",3),$p(Info,"^",4),$p(Info,"^",5),$p(Info,"^",6),$p(Info,"^",7),$p(Info,"^",8),$p(Info,"^",9),Amount,Now)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

Storage Default
{
<Data name="AnnualReportsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.St3C1A.AnnualReportsD</DataLocation>
<DefaultData>AnnualReportsDefaultData</DefaultData>
<IdLocation>^web.DHCPE.St3C1A.AnnualReportsD</IdLocation>
<IndexLocation>^web.DHCPE.St3C1A.AnnualReportsI</IndexLocation>
<StreamLocation>^web.DHCPE.St3C1A.AnnualReportsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
