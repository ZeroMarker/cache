/// 排班统计
Class web.DHCNurArgStatistics Extends %RegisteredObject
{

/// 统计一年的夜班小时数和假期班数
/// d ##class(%ResultSet).RunQuery("web.DHCNurArgStatistics","CountArgData","^2015-01-01^2015-09-13^^")
Query CountArgData(parr As %String = "") As %Query(ROWSPEC = "ret:%String") [ SqlProc ]
{
}

ClassMethod CountArgDataExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s wardid=$P(parr,"^",1)
	s stdate=$P(parr,"^",2)
	s:stdate["-" stdtae=$zdh(stdate,3)
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	s pertype=$zcvt($P(parr,"^",4),"U")
	s perid=$zcvt($P(parr,"^",5),"U")
	s count="",pertotal="",wardtotal=""
	s warddr="" f  s warddr=$O(^DHCMGNUR.MgNurPerWardD(warddr)) q:warddr=""  d
	.s wardobj=##class(DHCMGNUR.MgNurPerWard).%OpenId(warddr)
	.s wardloc=wardobj.WardLoc
	.q:$d(^CTLOC(wardloc))=0
	.s nurtyp="" f  s nurtyp=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_wardloc,nurtyp)) q:nurtyp=""  d
	..q:(pertype'="")&&(pertype'=$P(nurtyp," ",2))
	..s nurid="" f  s nurid=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_wardloc,nurtyp,nurid)) q:nurid=""  d
	...q:(perid'="")&&($zcvt(perid,"U")'=$P(nurid," ",2))
	...s perdr=$O(^DHCMGNUR.MgPersonsI("SSID",nurid,""))
	...q:perdr=""
	...s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	...s personid=perobj.PersonID
	...s persontyp=perobj.PersonType2
	...q:(persontyp'=$P(nurtyp," ",2))
	...f admdate=stdate:1:enddate d
	....s argid=$O(^DHCMGNUR.MgNurArrangeJobI("AJNurDateIndex"," "_wardloc,nurtyp,nurid," "_admdate,""))
	....q:argid=""
	....d GetArgDetial
	
	s filepath="/dthealth/app/dthis/web/scripts/nurse/expot/"
	s filename="NurArg"_$zd(+$h,8)_".txt"
	if '##class(%Library.File).DirectoryExists(filepath)
	{
		s Result = ##class(%Library.File).CreateDirectoryChain(filepath)
	}
	s file=##class(%Library.File).%New(filepath_filename)
	d file.Open("WNSK\UTF8\")
	d file.WriteLine("病区;工号;姓名;病区护士夜班小时数;病区护士节假日班数;护士夜班总小时数;护士节假日夜班数;护士总夜班数")
	s locid="" f  s locid=$O(count(locid)) q:locid=""  d
	.s warddesc=$P(^CTLOC(locid),"^",2)
	.i warddesc["-" s warddesc=$P(warddesc,"-",2)
	.s nurseid="" f  s nurseid=$O(count(locid,nurseid)) q:nurseid=""  d
	..s nurdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(nurseid,"U"),""))
	..q:nurdr=""
	..s nurobj=##class(DHCMGNUR.MgPersons).%OpenId(nurdr)
	..s nursename=nurobj.PersonName
	..s ret="WardDesc|"_warddesc_"^PersonID|"_nurseid_"^PersonName|"_nursename
	..s ret1=warddesc_";"_nurseid_";"_nursename
	..s counttyp="" f  s counttyp=$O(count(locid,nurseid,counttyp)) q:counttyp=""  d
	...s ret=ret_"^"_counttyp_"|"_$g(count(locid,nurseid,counttyp))
	..;s ret1=ret1_";"_$g(count(locid,nurseid,"DayHour"))
	..s ret1=ret1_";"_$g(count(locid,nurseid,"NightHour")) //病区护士夜班小时数
	..s ret1=ret1_";"_$g(count(locid,nurseid,"PostHoliday")) //病区护士节假日班数 
	..;s ret1=ret1_";"_$g(count(locid,nurseid,"NightHoliday"))
	..;s ret1=ret1_";"_$g(count(locid,nurseid,"TotalHour"))
	..s totalpertyp="" f  s totalpertyp=$O(pertotal(nurseid,totalpertyp)) q:totalpertyp=""  d
	...s ret=ret_"^Per"_totalpertyp_"|"_$g(pertotal(nurseid,totalpertyp))
	..;s ret1=ret1_";"_$g(pertotal(nurseid,"DayHour"))
	..s ret1=ret1_";"_$g(pertotal(nurseid,"NightHour"))  //护士夜班总小时数
	..;s ret1=ret1_";"_$g(pertotal(nurseid,"PostHoliday"))
	..s ret1=ret1_";"_$g(pertotal(nurseid,"NightHoliday")) //护士节假日夜班数
	..;s ret1=ret1_";"_$g(pertotal(nurseid,"TotalHour"))
	..i $g(pertotal(nurseid,"NightHour"))="" s pertotal(nurseid,"NightHour")=0
	..i $g(pertotal(nurseid,"NightHoliday"))="" s pertotal(nurseid,"NightHoliday")=0
	..s ret1=ret1_";"_((pertotal(nurseid,"NightHour")/8)+(pertotal(nurseid,"NightHoliday")*1.5)) //护士总夜班数
	..d OutputArgCount
	..d file.WriteLine(ret1)
	d file.Close()
    ;q file.SizeGet()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetArgDetial
	s argobj=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(argid)
	s argtypes=argobj.AJType
	s argcodes=argobj.AJCodeDR
	s argintervals=argobj.AJJobInterval
	s len=$L(argtypes,",")
	f i=1:1:len d
	.s argtyp=$P(argtypes,",",i)
	.s argcode=$P(argcodes,",",i)
	.s arginterval=$P(argintervals,",",i)
	.q:(argtyp="")||(argcode="")
	.i argtyp="Post" d
	..s postobj=##class(DHCMGNUR.MgNurPost).%OpenId(argcode)
	..s posttyp=postobj.PostType
	..s posttypobj=##class(DHCMGNUR.CommDictionarySub).%OpenId(posttyp)
	..s posthldy=postobj.PostHoliday
	..s postdesc=postobj.PostDesc
	..s posthour=postobj.PostHours
	..s postnighthour=postobj.PostNightHours
	..i postnighthour="" s postnighthour=0
	..i postobj.PostHoliday="Y" d 
	...i $g(count(wardloc,personid,"PostHoliday"))="" s count(wardloc,personid,"PostHoliday")=1
	...e  s count(wardloc,personid,"PostHoliday")=count(wardloc,personid,"PostHoliday")+1
	...i $g(pertotal(personid,"PostHoliday"))="" s pertotal(personid,"PostHoliday")=1
	...e  s pertotal(personid,"PostHoliday")=pertotal(personid,"PostHoliday")+1
	...i ($zcvt(postdesc,"U")="节24H")!($zcvt(postdesc,"U")="节12H夜") d
	....i $g(count(wardloc,personid,"NightHoliday"))="" s count(wardloc,personid,"NightHoliday")=1
	....e  s count(wardloc,personid,"NightHoliday")=count(wardloc,personid,"NightHoliday")+1
	....i $g(pertotal(personid,"NightHoliday"))="" s pertotal(personid,"PostHoliday")=1
	....e  s pertotal(personid,"NightHoliday")=pertotal(personid,"PostHoliday")+1
	..e  d
	...i $g(count(wardloc,personid,"NightHour"))="" s count(wardloc,personid,"NightHour")=postobj.PostNightHours
	...e  s count(wardloc,personid,"NightHour")=count(wardloc,personid,"NightHour")+postobj.PostNightHours
	...i $g(pertotal(personid,"NightHour"))=""  s pertotal(personid,"NightHour")=postnighthour
	...e  s pertotal(personid,"NightHour")=pertotal(personid,"NightHour")+postnighthour
	...s dayhour=postobj.PostHours-postnighthour
	...i $g(count(wardloc,personid,"DayHour"))="" s count(wardloc,personid,"DayHour")=dayhour
	...e  s count(wardloc,personid,"DayHour")=count(wardloc,personid,"DayHour")+dayhour
	...i $g(pertotal(personid,"DayHour"))="" s pertotal(personid,"DayHour")=dayhour
	...e  s pertotal(personid,"DayHour")=pertotal(personid,"DayHour")+dayhour
	
	...i $g(count(wardloc,personid,"TotalHour"))="" s count(wardloc,personid,"TotalHour")=posthour
	...e  s count(wardloc,personid,"TotalHour")=count(wardloc,personid,"TotalHour")+posthour
	...i $g(pertotal(personid,"TotalHour"))="" s pertotal(personid,"TotalHour")=posthour
	...e  s pertotal(personid,"TotalHour")=pertotal(personid,"TotalHour")+posthour
	.;i argtyp="Holiday" d
	.;i argtyp="Rest" d
	.;i argtyp="OverTime" d
	q
OutputArgCount    
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CountArgDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CountArgDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod CountArgDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CountArgDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 夜班病区列表
/// d ##class(%ResultSet).RunQuery("web.DHCNurArgStatistics","ArgWardStat","","")
Query ArgWardStat(wardid As %String = "", month As %String = "", nurtyp As %String = "") As %Query(ROWSPEC = "WardID:%String,WardDesc:%String,Month:%String,NurTyp:%String") [ SqlProc ]
{
}

ClassMethod ArgWardStatExecute(ByRef qHandle As %Binary, wardid As %String = "", month As %String = "", nurtyp As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i wardid=""
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s year=$P($zd(+$h,3),"-",1)
	s order="" f  s order=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",order)) q:order=""  d
	.s pwid="" f  s pwid=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",order,pwid)) q:pwid=""  d
	..s pwobj=##class(DHCMGNUR.MgNurPerWard).%OpenId(pwid)
	..s locid=pwobj.WardLoc
	..q:$d(^CTLOC(locid))=0
	..q:(wardid'="")&&(wardid'=locid)
	..s locdesc=$P(^CTLOC(locid),"^",2)
	..s:locdesc["-" locdesc=$P(locdesc,"-",2)
	..f i=1:1:12 d
	...i i<10 s mon=year_"-0"_i
	...e  s mon=year_"-"_i
	...q:(month'="")&&(month'=mon)
	...d WardStat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
WardStat    
	set Data=$lb(locid,locdesc,mon,nurtyp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ArgWardStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArgWardStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod ArgWardStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArgWardStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 夜班、节假日班统计
/// d ##class(%ResultSet).RunQuery("web.DHCNurArgStatistics","ArgNightStat","76","2015-08")
Query ArgNightStat(wardid As %String, month As %String = "", nurtyp As %String = "") As %Query(ROWSPEC = "NurseID:%String,NurseName:%String,NightHour:%String,HolidayNum:%String") [ SqlProc ]
{
}

ClassMethod ArgNightStatExecute(ByRef qHandle As %Binary, wardid As %String, month As %String = "", nurtyp As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i (wardid="")||(month="") 
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s year=$P(month,"-",1)
	s mon=+$P(month,"-",2)
	s monthdays=##class(web.DHCNurseManageComm).GetMonthDay(year,mon)
	s stdate=$zdh(month_"-01",3),enddate=$zdh(month_"-"_monthdays,3)
	f admdate=stdate:1:enddate d
	.s argid="" f  s argid=$O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_wardid," "_admdate,argid)) q:argid=""  d
	..s argobj=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(argid)
	..s nurseid=argobj.AJNurseDR
	..s nursetyp=argobj.AJNurseType
	..q:(nurtyp'="")&&(nurtyp'[nursetyp)
	..q:$g(NurseDate(nurseid,admdate))'=""
	..s NurseDate(nurseid,admdate)=1
	..d NightArg
	s nurid="" f  s nurid=$O(count(nurid)) q:nurid=""  d
	.s perdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(nurid,"U"),""))
	.q:perdr=""
	.s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	.s nurname=perobj.PersonName
	.q:($g(count(nurid,"NightHour"))="")&&($g(count(nurid,"NightHoliday"))="")
	.s NightHour=$g(count(nurid,"NightHour"))
	.s HolidayNum=$g(count(nurid,"NightHoliday"))
	.d NightStat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
NightArg
	;s argobj=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(argid)
	s argtypes=argobj.AJType
	s argcodes=argobj.AJCodeDR
	s argintervals=argobj.AJJobInterval
	s len=$L(argtypes,",")
	f i=1:1:len d
	.s argtyp=$P(argtypes,",",i)
	.s argcode=$P(argcodes,",",i)
	.s arginterval=$P(argintervals,",",i)
	.q:(argtyp="")||(argcode="")
	.i argtyp="Post" d
	..s postobj=##class(DHCMGNUR.MgNurPost).%OpenId(argcode)
	..s posttyp=postobj.PostType
	..s posttypobj=##class(DHCMGNUR.CommDictionarySub).%OpenId(posttyp)
	..s posthldy=postobj.PostHoliday
	..s postdesc=postobj.PostDesc
	..s posthour=postobj.PostHours
	..s postnighthour=postobj.PostNightHours
	..i postnighthour="" s postnighthour=0
	..i postobj.PostHoliday="Y" d 
	...i ($zcvt(postdesc,"U")="节24H")!($zcvt(postdesc,"U")="节12H夜") d
	....i $g(count(nurseid,"NightHoliday"))="" s count(nurseid,"NightHoliday")=1
	....e  s count(nurseid,"NightHoliday")=count(nurseid,"NightHoliday")+1
	..e  d
	...i $g(count(nurseid,"NightHour"))="" s count(nurseid,"NightHour")=postobj.PostNightHours
	...e  s count(nurseid,"NightHour")=count(nurseid,"NightHour")+postobj.PostNightHours
	q
NightStat    
	set Data=$lb(nurid,nurname,NightHour,HolidayNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ArgNightStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArgNightStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod ArgNightStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArgNightStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
