Import SQLUser

/// 护士长手册公共Query
Class web.DHCNurHBComm Extends %RegisteredObject
{

/// 年份 Query
/// xukun
/// 2016-01-26
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindYear","2015")
Query FindYear(parr As %String) As %Query(ROWSPEC = "desc,id")
{
}

ClassMethod FindYearExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s:parr="" parr=2015
 	s Year = $p($zd($h,3),"-",1)+1
 	f i=Year:-1:parr d YearRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
YearRow
	set Data=$lb(i,i)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindYearFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindYearExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindYearClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindYearExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询护士层级 Query
/// xukun
/// 2016-01-26
Query FindBattery(parr As %String = "") As %Query(ROWSPEC = "CodeDesc,ID")
{
}

ClassMethod FindBatteryExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s rw = ""
 	f  s rw= $o(^DHCMGNUR.CommDictionaryI("Code"," 护士层级",rw)) q:rw=""  d
 	.s srw = ""
 	.f  s srw = $o(^DHCMGNUR.CommDictionarySubD(rw,srw)) q:srw=""  d BatteryRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BatteryRow
	s ID = rw_"||"_srw
	s CodeDesc = $list(^DHCMGNUR.CommDictionarySubD(rw,srw),5)
	q:CodeDesc'[parr
	set Data=$lb(CodeDesc,ID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBatteryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBatteryExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBatteryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBatteryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 人员信息列表 Query
/// xukun
/// 2016-01-26
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindMgPersons","1^102^demo^351^N^12||1")
Query FindMgPersons(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindMgPersonsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMgPersonsFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindMgPersonsExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inSType = $p(parr,"^",5)
	s inSBattery = $p(parr,"^",6)
	
	s:(inSecGrp="nurse")&&(inSecGrp="nurhead") inSLoc = inLoc
	
	i inSBattery'="" d
	.s rw = ""
	.f  s rw = $o(^DHCMGNUR.MgPersonsI("SBattery",inSBattery,rw)) q:rw=""  d PersonsRow
	e  d
	.s rw = ""
	.f  s rw = $o(^DHCMGNUR.MgPersonsD(rw)) q:rw=""  d PersonsRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
PersonsRow
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s dep = obj.PersonDepDR
	s battery = ""
	s:$IsObject(obj.PersonBattery) battery = obj.PersonBattery.CodeDesc
	s id = obj.PersonID
	s name = obj.PersonName
	s type = obj.PersonType2
	d obj.%Close()
	q:dep'=inSLoc
	q:(inSType'="")&&(type'=inSType)
	s dep = $p(^CTLOC(dep),"^",2)
	set Data=$lb("rw|"_rw_"^PersonName|"_name_"^PersonID|"_id_"^PersonBattery|"_battery_"^PersonDep|"_dep)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMgPersonsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMgPersonsExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// DHCMGNUR.MgNurMonthRec Query
/// xukun
/// 2016-03-05
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindMonthRec","69^118^hlbzr^^^2016^^WH^H")
Query FindMonthRec(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindMonthRecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMonthRecFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindMonthRecExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^TEMP("g08091620001") = parr //10925^123^nurhead^^^2016^^QC^M
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inDesc = $p(parr,"^",7)
	s inType = " "_$p(parr,"^",8)
	s inType2 = " "_$p(parr,"^",9)
	s:$p(parr,"^",9)="" inType2 = " M"
	s:(inSecGrp="nurse")||(inSecGrp="nurhead") inSLoc = inLoc
	;b ;000001
	i inSLoc = "" d
	.i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
	..i inFlag = "" d
	...s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Type",inType,inType2,rw),-1) q:rw=""  d MonthRecRow
	..e  d
	...s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Flag",inType,inType2,inFlag,rw),-1) q:rw=""  d MonthRecRow
	.e  i inSecGrp="znurhead" d
	..s code = "" f  s code = $o(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_inUserId,code)) q:code=""  d
 	...s Loc = "" f  s Loc = $o(^DHCMGNUR.MgNurMaCareUnitI("Typ",code,Loc)) q:Loc=""  d
 	....i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	.....s rw = ""
 	.....i inType2 = " Y" d
 	......f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DY",inType,inType2,Loc,inYear,rw),-1) q:rw=""  d MonthRecRow
 	.....i inType2 = " H" d
 	......f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYH",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d MonthRecRow
 	.....i inType2 = " Q" d
 	......f  s rw =  $o(^DHCMGNUR.MgNurMonthRecI("DYQ",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d MonthRecRow
 	.....i inType2 = " M" d
 	......f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYM",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d MonthRecRow
	....e  d
 	.....s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Dep",inType,inType2,Loc,rw),-1) q:rw=""  d MonthRecRow
 	e  d
 	.i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	..;b ;112001
 	..s rw = ""
	..i inType2 = " Y" d
 	...f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DY",inType,inType2,inSLoc,inYear,rw),-1) q:rw=""  d MonthRecRow
 	..i inType2 = " H" d
 	...f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYH",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d MonthRecRow
 	..i inType2 = " Q" d
 	...f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYQ",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d MonthRecRow
 	..i inType2 = " M" d
 	...f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYM",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d MonthRecRow
	.e  d
	..;b ;112002
	..s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Dep",inType,inType2,inSLoc,rw),-1) q:rw=""  d MonthRecRow
	..;s intype="" f  s intype=$O(^DHCMGNUR.MgNurMonthRecI("Dep",intype)) q:intype=""  d
	...;s intype2="" f  s intype2=$O(^DHCMGNUR.MgNurMonthRecI("Dep",intype,intype2)) q:intype2=""  d
	....;s rw="" f  s rw=$O(^DHCMGNUR.MgNurMonthRecI("Dep",intype,intype2,inSLoc,rw)) q:rw=""  d MonthRecRow
	....;i inSecGrp="nurhead" d
	....;s rw="" f  s rw=$O(^DHCMGNUR.MgNurMonthRecI("Flag",inType,inType2,2,rw)) q:rw=""  d MonthRecRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
MonthRecRow
	s obj = ##class(DHCMGNUR.MgNurMonthRec).%OpenId(rw)
	s Flag = obj.Flag
	s Year = obj.Year
	q:obj.DelFlag="N"
	s Desc = ""
	s:inType2=" H" Desc = obj.Half
	s:inType2=" Q" Desc = obj.Quarter
	s:inType2=" M" Desc = obj.Month
	s AddPer = ""
	s:$IsObject(obj.AddPerDr) AddPer = obj.AddPerDr.%Id()
	s DepId = ""
	s:$IsObject(obj.DepDr) DepId = obj.DepDr.%Id()
	d obj.%Close()
	q:(inFlag'="")&&(Flag'=inFlag)
	q:(Flag=0)&&(AddPer'=inUserId)&&(inType'=" B")&&(inType'=" S")&&(inType'=" LT")
	q:(inYear'="")&&(inYear'=Year)
	q:(inDesc'="")&&(inDesc'=Desc)&&(inDesc'=0)
	q:(inSLoc'="")&&(inSLoc'=DepId)
	;q:(inSecGrp="nurhead")&&(Flag'=4!Flag'=1)
	;q:((inSecGrp="demo")&&(Flag'=4))
	s ret = ##class(DHCMGNUR.MgNurMonthRec).getValue(rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMonthRecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMonthRecExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// DHCMGNUR.MgNurHLBMonthRec Query
/// xukun
/// 2016-03-28
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHLBMonthRec","69^118^hlbzr^^2016^3^QC^M")
Query FindHLBMonthRec(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHLBMonthRecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHLBMonthRecFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHLBMonthRecExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^xukun = parr
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inFlag = $p(parr,"^",4)
	s inYear = $p(parr,"^",5)
	s inDesc = $p(parr,"^",6)
	s inType = " "_$p(parr,"^",7)
	s inType2 = " "_$p(parr,"^",8)
	s:$p(parr,"^",9)="" inType2 = " M"
	
	k ^TMP("FindMonthRec",$j)
	
	i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
	.i inFlag="" d
	..s rw = ""
	..f  s rw = $o(^DHCMGNUR.MgNurHLBMonthRecI("Type",inType,inType2,rw)) q:rw=""  d HLBMonthRecRow
	.e  d
	..s rw = ""
	..f  s rw = $o(^DHCMGNUR.MgNurHLBMonthRecI("Flag",inType,inType2,inFlag,rw)) q:rw=""  d HLBMonthRecRow
	e  d
	.s rw = ""
	.f  s rw = $o(^DHCMGNUR.MgNurHLBMonthRecI("Flag",inType,inType2,1,rw)) q:rw=""  d HLBMonthRecRow
	
	s Year = ""
	f  s Year = $o(^TMP("FindMonthRec",$j,Year),-1) q:Year=""  d
	.s Desc = ""
	.f  s Desc = $o(^TMP("FindMonthRec",$j,Year,Desc),-1) q:Desc=""  d
	..s rw = ""
	..f  s rw = $o(^TMP("FindMonthRec",$j,Year,Desc,rw),-1) q:rw=""  d
	...s ret = ^TMP("FindMonthRec",$j,Year,Desc,rw)
	...set Data=$lb(ret)
 	...Set ^CacheTeWP(repid,ind)=Data
 	...Set ind=ind+1
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HLBMonthRecRow
	s obj = ##class(DHCMGNUR.MgNurHLBMonthRec).%OpenId(rw)
	s:inType2=" H" Desc = obj.Half
	s:inType2=" Q" Desc = obj.Quarter
	s:inType2=" M" Desc = obj.Month
	s Year = obj.Year
	s Flag = obj.Flag
	s AddPer = obj.AddPerDr.%Id()
	d obj.%Close()
	q:(inFlag'="")&&(Flag'=inFlag)
	q:(Flag=0)&&(AddPer'=inUserId)
	q:(inYear'="")&&(inYear'=Year)
	q:(inDesc'="")&&(inDesc'=Desc)&&(inDesc'=0)
	s ^TMP("FindMonthRec",$j,Year,Desc,rw) = ##class(DHCMGNUR.MgNurHLBMonthRec).getValue(rw)
	q
}

ClassMethod FindHLBMonthRecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHLBMonthRecExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 月病区工作重点内容 Query
/// xukun
/// 2016-03-05
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWorkFocusSub","1")
Query FindWorkFocusSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindWorkFocusSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWorkFocusSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindWorkFocusSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	i parr'="" d
	.s sub = ""
	.f  s sub = $o(^DHCMGNUR.MgNurWorkFocusSubD(parr,sub)) q:sub=""  d WorkFocusSubRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
WorkFocusSubRow
	s ret = ##class(DHCMGNUR.MgNurWorkFocusSub).getValue(parr_"||"_sub)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWorkFocusSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWorkFocusSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 晨会讲评记录
/// xukun
/// 2016-03-07
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindAmCommentSub","3")
Query FindAmCommentSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindAmCommentSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAmCommentSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindAmCommentSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^jyc112=parr
	i parr'="" d
	.s sub = ""
	.f  s sub = $o(^DHCMGNUR.MgNurAmCommentRecSubD(parr,sub),-1) q:sub=""  d AmCommentRecSubRow
 	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
AmCommentRecSubRow
	s ret = ##class(DHCMGNUR.MgNurAmCommentRecSub).getValue(parr_"||"_sub)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAmCommentSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAmCommentSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 晨会提问记录
/// xukun
/// 2016-03-07
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindAmQuestionsRecSub","3")
Query FindAmQuestionsRecSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindAmQuestionsRecSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAmQuestionsRecSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindAmQuestionsRecSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	i parr'="" d
	.s sub = ""
	.f  s sub = $o(^DHCMGNUR.MgNurAmQuestionsRecSubD(parr,sub),-1) q:sub=""  d AmQuestionsRecSubRow
 	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
AmQuestionsRecSubRow
	s ret = ##class(DHCMGNUR.MgNurAmQuestionsRecSub).getValue(parr_"||"_sub)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAmQuestionsRecSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAmQuestionsRecSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护士下拉列表 Query
/// xukun
/// 2016-03-06
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindNurHead","")
Query FindNurHead(parr As %String) As %Query(ROWSPEC = "desc,id")
{
}

ClassMethod FindNurHeadExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TEMP("g08051135001")=parr
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inText = $p(parr,"^",1)
 	s inType = $p(parr,"^",2)
 	s inUserId = $p(parr,"^",3)
 	s inGroup = $p(parr,"^",4)
 	s inLoc = $p(parr,"^",5)
 	s inSLoc = $p(parr,"^",6)
 	
 	i inType '= "A" d
 	.b ;01
 	.s PersonID = ""
 	.f  s PersonID = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID)) q:PersonID=""  d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID,rw)) q:rw=""  d NurHeadRow
 	e  d
 	.b ;02
 	.s:(inGroup="nurse")||(inGroup="nurhead")||(inGroup="hlb")||(inGroup="demo") inSLoc = inLoc
 	.i inSLoc = "" d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsD(rw)) q:rw=""  d NurHeadRow
 	.e  d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsI("Dep"," "_inSLoc,rw)) q:rw=""  d NurHeadRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
NurHeadRow
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s headship = ""
	s:$IsObject(obj.PersonheadshipDR) headship = obj.PersonheadshipDR.Code
	s desc = obj.PersonName_"("_obj.PersonID_")"
	d obj.%Close()
	q:(inType'="A")&&(headship'="护士长")
	q:desc'[inText
	set Data=$lb(desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurHeadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHeadExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurHeadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHeadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 护士下拉列表 Query(护理工作质量持续改进记录增加(主讲人))
/// jiangyingcan
/// 2016-11-28
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindNurHeadks","")
Query FindNurHeadks(parr As %String) As %Query(ROWSPEC = "desc,id")
{
}

ClassMethod FindNurHeadksExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TEMP("g08051135001")=parr
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inText = $p(parr,"^",1)
 	s inType = $p(parr,"^",2)
 	s inUserId = $p(parr,"^",3)
 	s inGroup = $p(parr,"^",4)
 	s inLoc = $p(parr,"^",5)
 	s inSLoc = $p(parr,"^",6)
 	s headship = ""
 	
 	i inType '= "A" d
 	.s PersonID = ""
 	.f  s PersonID = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID)) q:PersonID=""  d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID,rw)) q:rw=""  d
 	...s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	...s:$IsObject(obj.PersonheadshipDR) headship = obj.PersonheadshipDR.Code
	...i (headship = "护士长")||(headship = "主管护士")||(headship = "总护士长") d NurHeadRow
 	e  d
 	.s:(inGroup="nurse")||(inGroup="nurhead")||(inGroup="hlb")||(inGroup="demo") inSLoc = inLoc
 	.i inSLoc = "" d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsD(rw)) q:rw=""  d
 	...s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	...s:$IsObject(obj.PersonheadshipDR) headship = obj.PersonheadshipDR.Code
	...i obj.PersonType2="N" d
	....i (headship = "护士长")||(headship = "主管护士")||(headship = "总护士长") d NurHeadRow
 	.e  d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsI("Dep"," "_inSLoc,rw)) q:rw=""  d 
 	...s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	...s:$IsObject(obj.PersonheadshipDR) headship = obj.PersonheadshipDR.Code
	...i obj.PersonType2="N" d
	....i (headship = "护士长")||(headship = "主管护士")||(headship = "总护士长") d NurHeadRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
NurHeadRow
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s desc = obj.PersonName_"("_obj.PersonID_")"_"("_headship_")"
	d obj.%Close()
	q:(inType'="A")&&(headship'="护士长")
	q:desc'[inText
	set Data=$lb(desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurHeadksFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHeadksExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurHeadksClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHeadksExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 按照科室获取护士信息
Query FindNurseInfos(parr As %String) As %Query(ROWSPEC = "desc,id")
{
}

ClassMethod FindNurseInfosExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inText = $p(parr,"^",1)
 	s inType = $p(parr,"^",2)
 	s inUserId = $p(parr,"^",3)
 	s inGroup = $p(parr,"^",4)
 	s inLoc = $p(parr,"^",5)
 	s inSLoc = $p(parr,"^",6)

	 s nurid="" f  s nurid=$O(^DHCMGNUR.MgPersonsI("SSID",nurid)) q:nurid=""  d
	 .s raw="" f  s raw=$O(^DHCMGNUR.MgPersonsI("SSID",nurid,raw)) q:raw=""  d
	 ..s obj=##class(DHCMGNUR.MgPersons).%OpenId(raw)
	 ..q:obj.PersonType2'="N"
	 ..q:((inLoc'="")&&(obj.PersonDepDR'=inLoc))
	 ..q:((inText'="")&&((obj.PersonName_obj.PersonID)'[$zcvt($tr(inText," ",""),"U")))
	 ..s desc=obj.PersonName_"("_obj.PersonID_")"
	 ..d OutputNurseInfo
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurseInfo
	set Data=$lb(desc,raw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurseInfosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseInfosExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurseInfosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseInfosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 护士长列表 Query
/// xukun
/// 2016-03-06
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindNurHeadList","1^102^demo^B^2016^^")
Query FindNurHeadList(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurHeadListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindNurHeadListFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindNurHeadListExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	s PersonID = ""
 	f  s PersonID = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID)) q:PersonID=""  d
 	.s rw = ""
 	.f  s rw = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID,rw)) q:rw=""  d NurHeadListRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
NurHeadListRow
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s headship = "" , battery = ""
	s:$IsObject(obj.PersonheadshipDR) headship = obj.PersonheadshipDR.Code
	s:$IsObject(obj.PersonBattery) battery = obj.PersonBattery.CodeDesc
	s ret = "rw|"_obj.%Id()_"^PersonName|"_obj.PersonName_"^PersonID|"_obj.PersonID_"^PersonDep|"_$p($g(^CTLOC(obj.PersonDepDR)),"^",2)_"^PersonBattery|"_battery_"^HeadShip|"_headship
	d obj.%Close()
	q:(headship'="护士长")
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurHeadListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindNurHeadListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护士列表 Query
/// xukun
/// 2016-03-06
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindNurList","351")
Query FindNurList(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindNurListFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindNurListExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	s rw = ""
 	f  s rw = $o(^DHCMGNUR.MgPersonsI("Dep"," "_parr,rw)) q:rw=""  d NurListRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
NurListRow
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s headship = "" , battery = "",type = ""
	s:$IsObject(obj.PersonheadshipDR) headship = obj.PersonheadshipDR.Code
	s:$IsObject(obj.PersonBattery) battery = obj.PersonBattery.CodeDesc
	s type = obj.PersonType2
	s type = $s(type="P":"实习",type="N":"正式",type="S":"进修",1:"")
	s ret = "rw|"_obj.%Id()_"^PersonName|"_obj.PersonName_"^PersonID|"_obj.PersonID_"^PersonDep|"_$p($g(^CTLOC(obj.PersonDepDR)),"^",2)_"^PersonBattery|"_battery_"^HeadShip|"_headship_"^Type|"_type
	d obj.%Close()
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindNurListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护士下拉列表 Query
/// xukun
/// 2016-03-06
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindNurList","351")
Query FindNurComboList(parr As %String) As %Library.Query(ROWSPEC = "desc,id")
{
}

ClassMethod FindNurComboListExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^TEMP("g08121530001") = parr
	s inName = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	
	s nurseid="" f  s nurseid=$O(^DHCMGNUR.MgPersonsI("SSID",nurseid)) q:nurseid=""  d
	.s rw="" f  s rw=$O(^DHCMGNUR.MgPersonsI("SSID",nurseid,rw)) q:rw=""  d
	..d NurListRow 
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
NurListRow
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s type = obj.PersonType2
	s PersonName = obj.PersonName_"("_obj.PersonID_")"
	d obj.%Close()
	q:((inLoc'="")&&(obj.PersonDepDR'=inLoc))
	q:type'="N" ;过滤非正式人员
	q:PersonName'[inName
	
	set Data=$lb(PersonName,rw)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurComboListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindNurComboListExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurComboListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindNurComboListFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

/// 根据科室id获取科室描述
ClassMethod getCtLocDesc(CTLocID As %String = "")
{
	q:CTLocID="" ""
	q $p(^CTLOC(CTLocID),"^",2)
}

/// 获取当前日期
ClassMethod getNowDate()
{
	q $zd($h,3)
}

/// 获取科室当前在院病人
/// xukun
/// 2016-03-06
/// 入参：
/// 	parr:科室RowId
/// 出参：
/// 	HisNo:住院号
/// 		Patient:病人姓名
/// 		BedNo:床号
/// 		Diagnosis:诊断
/// 	Adm:就诊号
/// 	PapNo:登记号
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindPatients","27")
Query FindPatients(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPatientsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
	
	s getwardid = $o(^PAWARD(0,"WARD_LocationDR",parr,""))
 	s admId = ""
 	k ^TMP("FINDPATIENTS",$j)
 	f  s admId = $o(^PAADMi("PAADM_Type","I",admId)) q:admId=""  d
 	.q:'$d(^PAADM(admId))
 	.s curWardId=$p(^PAADM(admId),"^",70)
 	.q:curWardId=""
 	.q:curWardId'=getwardid
 	.s visitstatus = $p(^PAADM(admId),"^",20)
 	.q:visitstatus=""
 	.q:visitstatus'="A"
 	.s papno=$p(^PAPER(+^PAADM(admId),"PAT",1),"^",1)
 	.s papname=$p(^PAPER(+^PAADM(admId),"ALL"),"^",1)
 	.s bedrowid=$p(^PAADM(admId),"^",73)
 	.s MainMRADMDR = $p(^PAADM(admId),"^",61)
 	.s Diagnos = ##class(web.DHCMRDiagnos).GetMRDiagnosDesc($G(MainMRADMDR),"/")
 	.i bedrowid'="" d
 	..s wardid=$p(bedrowid,"||",1),bedid=$p(bedrowid,"||",2)
 	..s bedname=$p(^PAWARD(wardid,"BED",bedid),"^",1)
 	..i bedname'["床" s bedname = bedname_"床"
 	..s ^TMP("FINDPATIENTS",$j,bedname,admId)=papno_"^"_papname_"^"_Diagnos_"^"_admId
 	.e  s ^TMP("FINDPATIENTS",$j,"无",admId)=papno_"^"_papname_"^"_Diagnos_"^"_admId
 	
 	s BedName=""
 	f  s BedName = $o(^TMP("FINDPATIENTS",$j,BedName)) q:BedName=""  d
 	.s ADMID = ""
 	.f  s ADMID = $o(^TMP("FINDPATIENTS",$j,BedName,ADMID)) q:ADMID=""  d
 	..s papno = $p(^TMP("FINDPATIENTS",$j,BedName,ADMID),"^",1)
 	..s papname = $p(^TMP("FINDPATIENTS",$j,BedName,ADMID),"^",2)
 	..s bedname=BedName
 	..s Diagnos = $p(^TMP("FINDPATIENTS",$j,BedName,ADMID),"^",3)
 	..s adm = $p(^TMP("FINDPATIENTS",$j,BedName,ADMID),"^",4)
 	..d FindPatientsRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindPatientsRow
	s papmi=$o(^PAPERi("PAPMI_PatNo",papno,""))
	s HisNo=##Class(web.DHCWMRService).IGetMrNoByPatientID(papmi) /// 住院号
	s ret = "HisNo|"_HisNo_"^Patient|"_papname_"^BedNo|"_$g(bedname)_"^Diagnos|"_Diagnos_"^Adm|"_adm_"^PapNo|"_papno
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPatientsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPatientsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 病区健康教育记录-人员列表 Query
/// xukun
/// 2016-03-14
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindPersonsSub","47")
Query FindPersonsSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonsSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPersonsSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindPersonsSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^TEMP("g11161414001") = parr
	s rw = "" f  s rw = $o(^DHCMGNUR.MgNurPersonsSubD(parr,rw),-1) q:rw=""  d FindPersonsRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
FindPersonsRow
	s ret = ##class(DHCMGNUR.MgNurPersonsSub).getValue(parr_"||"_rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonsSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPersonsSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护理部危重症患者抢救技术培训及演练记录-人员列表 Query
/// jiangyingcan
/// 2016-10-24
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindPersonsSub","47")
Query FindHLBPersonsSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHLBPersonsSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHLBPersonsSubExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHLBPersonsSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	s rw = ""
	f  s rw = $o(^DHCMGNUR.MgNurHLBPersonsSubD(parr,rw),-1) q:rw=""  d FindHLBPersonsRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
FindHLBPersonsRow
	s ret = ##class(DHCMGNUR.MgNurHLBPersonsSub).getValue(parr_"||"_rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHLBPersonsSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHLBPersonsSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 病区健康教育记录-人员列表 Query
/// xukun
/// 2016-03-14
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindPatientsSub","47")
Query FindPatientsSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindPatientsSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientsSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindPatientsSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^xukun(1) = "FindPatientsSub"_parr
	s rw = ""
	f  s rw = $o(^DHCMGNUR.MgNurPatientsSubD(parr,rw),-1) q:rw=""  d FindPatientsSubRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
FindPatientsSubRow
	b
	s ret = ##class(DHCMGNUR.MgNurPatientsSub).getValue(parr_"||"_rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatientsSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientsSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 病区健康教育记录-问题列表 Query
/// xukun
/// 2016-03-14
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindEhsEduRecQue","351")
Query FindEhsEduRecQue(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindEhsEduRecQueClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEhsEduRecQueFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindEhsEduRecQueExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s rw = ""
	f  s rw = $o(^DHCMGNUR.MgNurEhsEduRecQueSubD(parr,rw),-1) q:rw=""  d EhsEduRecPerRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
EhsEduRecPerRow
	s ret = ##class(DHCMGNUR.MgNurEhsEduRecQueSub).getValue(parr_"||"_rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindEhsEduRecQueFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEhsEduRecQueExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 康复训练计划及实施效果评价 Query
/// xukun
/// 2016-03-16
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindRecoveryTrain","1^59^demo^^^2016^^R")
Query FindRecoveryTrain(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindRecoveryTrainClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRecoveryTrainFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindRecoveryTrainExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inMonth = $p(parr,"^",7)
	s ^xukun = "xukun"_parr
	s:(inSecGrp="nurse")||(inSecGrp="nurhead") inSLoc = inLoc
	i inSLoc = "" d
	.i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
	..i inFlag = "" d
	...s rw = ""
	...f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Type"," R"," M",rw),-1) q:rw=""  d RecoveryTrainRow
	..e  d
	...s rw = "" d
	...f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Flag"," R"," M"," "_inFlag,rw),-1) q:rw=""  d RecoveryTrainRow
	.e  i inSecGrp="znurhead" d
	..s code = ""
	..f  s code = $o(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_inUserId,code)) q:code=""  d
 	...s Loc = ""
 	...f  s Loc = $o(^DHCMGNUR.MgNurMaCareUnitI("Typ",code,Loc)) q:Loc=""  d
 	....i (inYear'=""&&inMonth'="") d
 	.....s rw = ""
 	.....f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYM"," R"," M",Loc," "_inYear," "_inMonth,rw),-1) q:rw=""  d RecoveryTrainRow
 	....e  d
 	.....s rw = ""
 	.....f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Dep"," R"," M",Loc,rw),-1) q:rw=""  d RecoveryTrainRow
 	e  d
 	.i (inYear'="")&&(inMonth'="") d
	..s rw = ""
	..f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYM"," R"," M",inSLoc," "_inYear," "_inMonth,rw),-1) q:rw=""  d RecoveryTrainRow
	.e  d
	..s rw = ""
	..f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Dep"," R"," M",inSLoc,rw),-1) q:rw=""  d RecoveryTrainRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
RecoveryTrainRow
	
	s obj = ##class(DHCMGNUR.MgNurMonthRec).%OpenId(rw)
	s Flag = obj.Flag
	s Year = obj.Year
	s Month = obj.Month
	s AddPer = ""
	s:$IsObject(obj.AddPerDr) AddPer = obj.AddPerDr.%Id()
	s DepId = ""
	s:$IsObject(obj.DepDr) DepId = obj.DepDr.%Id()
	d obj.%Close()
	b ;1
	q:(inFlag'="")&&(Flag'=inFlag)
	q:(Flag=0)&&(AddPer'=inUserId)
	q:(inYear'="")&&(inYear'=Year)
	q:(inMonth'="")&&(inMonth'=Month)
	q:(inSLoc'="")&&(inSLoc'=DepId)
	b
	;s ret = ##class(DHCMGNUR.MgNurMonthRec).getValue(rw)_"^Theme|"_##class(DHCMGNUR.MgNurRecoveryTrainSub).getTheme(rw)
	s ret = ##class(DHCMGNUR.MgNurRecoveryTrainSub).getValue1(rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRecoveryTrainFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRecoveryTrainExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 康复训练计划及实施效果评价详情 Query
/// xukun
/// 2016-03-16
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindRecoveryTrainSub","69^118^hlbzr^^2016^^")
Query FindRecoveryTrainSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindRecoveryTrainSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRecoveryTrainSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindRecoveryTrainSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	s rw=""
	f  s rw = $o(^DHCMGNUR.MgNurRecoveryTrainSubD(parr,rw)) q:rw=""  d RecoveryTrainSubRow
	
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
RecoveryTrainSubRow
	s obj = ##class(DHCMGNUR.MgNurRecoveryTrainSub).%OpenId(parr_"||"_rw)
	s Condition="",Problems="",Reasons="",Measures="",Evaluate=""
	s l = obj.Condition.Count()
	s:l>0 Condition = ..clearHTML(obj.Condition.GetAt(1).getText(),1,100)
	s l = obj.Problems.Count()
	s:l>0 Problems = ..clearHTML(obj.Problems.GetAt(1).getText(),1,100)
	s l = obj.Reasons.Count()
	s:l>0 Reasons = ..clearHTML(obj.Reasons.GetAt(1).getText(),1,100)
	s l = obj.Measures.Count()
	s:l>0 Measures = ..clearHTML(obj.Measures.GetAt(1).getText(),1,100)
	s l = obj.Evaluate.Count()
	s:l>0 Evaluate = ..clearHTML(obj.Evaluate.GetAt(1).getText(),1,100)
	d obj.%Close()
	s ret = "Code|实施情况记录^Content|"_Condition_"^Type|Condition^raw|"_parr_"__"_rw
	d RecoveryTrainSubRow2
	s ret = "Code|存在问题^Content|"_Problems_"^Type|Problems^raw|"_parr_"__"_rw
	d RecoveryTrainSubRow2
	s ret = "Code|原因分析^Content|"_Reasons_"^Type|Reasons^raw|"_parr_"__"_rw
	d RecoveryTrainSubRow2
	s ret = "Code|改进措施^Content|"_Measures_"^Type|Measures^raw|"_parr_"__"_rw
	d RecoveryTrainSubRow2
	s ret = "Code|效果评价^Content|"_Evaluate_"^Type|Evaluate^raw|"_parr_"__"_rw
	d RecoveryTrainSubRow2
	q
RecoveryTrainSubRow2
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRecoveryTrainSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRecoveryTrainSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 除去HTML标签并截取长度
/// w ##class(web.DHCNurHBComm).clearHTML()
/// 入参:
/// 	text:操作文本
/// 	from:截取开始位置
/// 	to:截取结束位置（截取包括两端）
/// 	出参:
/// 	ret:操作完成文本
ClassMethod clearHTML(text As %String = "", from As %String = "", to As %String = "")
{
	q:text="" ""
	s:(from="")||(from<1) from = 1
	s:(to="")||(to<1) to = 50
	s len = $l(text)
	/// HTML标签(删除<>之间的部分)
	f  q:($find(text,"<")=0)||($find(text,">")=0)  d
	.s ltag = $find(text,"<")
	.s rtag = $find(text,">")
	.s text = $p(text,"<",1)_$e(text,rtag,$l(text))
	/// 空格
	;s len = $l(text,"&nbsp;")
	;s ret = ""
	;f i=1:1:len d
	;.s ret=text_$p(text,"&nbsp;",i)
	/// 换行
	;s len = $l(ret,$c(10,10))
	;s text = ""
	;f i=1:1:len d
	;.s text=text_$p(ret,$c(10,10),i)
	q $e(text,from,to)
}

/// 病区护理质量检查记录 Query
/// xukun
/// 2016-03-17
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindQualityCheck","9")
Query FindQualityCheck(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualityCheckClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindQualityCheckFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindQualityCheckExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1
	s ^TEMP("g12131654001")=parr
	Set QHandle=$lb(0,repid,0)
	s TotalSum=0,PassNumSum=0,NoPassNumSum=0
	s rw = ""
	f  s rw = $o(^DHCMGNUR.MgNurQualityCheckSubD(parr,rw),-1) q:rw=""  d
	.s obj = ##class(DHCMGNUR.MgNurQualityCheckSub).%OpenId(parr_"||"_rw)
	.s SDate = "",Inspection = "",InspectionId = "",ReDate = ""
	.s:obj.SDate SDate = $zd(obj.SDate,3)
	.s:obj.ReDate ReDate = $zd(obj.ReDate,3)
	.;i $IsObject(obj.Inspection) d
	..;s Inspection = obj.Inspection.CodeDesc
	..;s InspectionId = obj.Inspection.%Id()
	.s InspectionId=obj.Inspection
	.s Inspection=""
	.i obj.Inspection'="" d
	..s IObj=##class(DHCMGNUR.QualCodeItem).%OpenId(obj.Inspection)
	..s Inspection=IObj.QualDesc
	.s SecInspectionId=obj.SecInspection
	.i obj.SecInspection'="" d
	..s SObj=##class(DHCMGNUR.QualCodeItemSub).%OpenId(obj.SecInspection)
	..s SecInspection=SObj.ItemDesc
	.e  s SecInspection=""
	.s TotalSum = obj.Total + TotalSum
	.s PassNumSum = obj.PassNum + PassNumSum
	.s NoPassNumSum = obj.NoPassNum + NoPassNumSum
	.s ret = "raw|"_$tr(obj.%Id(),"||","__")_"^SDate|"_SDate_"^ReDate|"_ReDate_"^Inspection|"_Inspection_"^InspectionId|"_$tr(InspectionId,"||","__")_"^Total|"_obj.Total_"^PassNum|"_obj.PassNum_"^NoPassNum|"_obj.NoPassNum_"^PassRate|"_obj.PassRate_"^Problems|"_obj.Problems_"^Measures|"_obj.Measures_"^Result|"_obj.Result_"^SecInspection|"_SecInspection_"^SecInspectionId|"_SecInspectionId
	.d obj.%Close()
	.d QualityCheckRow
	s ret = "raw|0^SDate|合计^ReDate|^Inspection|^InspectionId|^Total|"_TotalSum_"^PassNum|"_PassNumSum_"^NoPassNum|"_NoPassNumSum_"^PassRate|^Problems|^Measures|^Result|"
	d QualityCheckRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
QualityCheckRow
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualityCheckFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindQualityCheckExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询公共代码下拉框 Query
/// xukun
/// 2016-03-17
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindCommDictionary","^病区安全检查")
Query FindCommDictionary(parr As %String = "") As %Query(ROWSPEC = "Desc,ID")
{
}

ClassMethod FindCommDictionaryExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s lastQuery = $p(parr,"^",1)
 	s code = $p(parr,"^",2)
 	
 	s rw = ""
 	f  s rw= $o(^DHCMGNUR.CommDictionaryI("Code"," "_code,rw)) q:rw=""  d
 	.s srw = ""
 	.f  s srw = $o(^DHCMGNUR.CommDictionarySubD(rw,srw)) q:srw=""  d CommDictionaryRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
CommDictionaryRow
	s ID = rw_"||"_srw
	s obj = ##class(DHCMGNUR.CommDictionarySub).%OpenId(ID)
	s Desc = obj.CodeDesc
	s EDate = obj.EndDate
	d obj.%Close()
	q:(EDate'="")&(EDate<$p($h,",",1))
	q:Desc'[lastQuery
	set Data=$lb(Desc,$tr(ID,"||","__"))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCommDictionaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCommDictionaryExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCommDictionaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCommDictionaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 培训提问 Query
/// xukun
/// 2016-03-17
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindTrainQuestions","1030^27^nurhead^47")
Query FindTrainQuestions(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTrainQuestionsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
 	s prw = $p(parr,"^",4)
 	s NO = 1
 	i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
 	.s rw = ""
 	.f  s rw = $o(^DHCMGNUR.MgNurTrainQuestionsSubD(prw,rw),-1) q:rw=""  d
 	..s obj = ##class(DHCMGNUR.MgNurTrainQuestionsSub).%OpenId(prw_"||"_rw)
	..s Questions = "",ReleaseTime = "",AddPerId = "",AddPer = ""
	..s:obj.Questions.Count()>0 Questions = ..clearHTML(obj.Questions.GetAt(1).getText())
	..s:$IsObject(obj.AddPerDr) AddPer = obj.AddPerDr.SSUSRName
	..s:(obj.ReleaseDate'="")&&(obj.ReleaseTime'="") ReleaseTime = $zdt(obj.ReleaseDate_","_obj.ReleaseTime,3)
	..s ret = "rw|"_$tr(obj.%Id(),"||","__")_"^Flag|"_obj.Flag_"^Questions|"_Questions_"^ReleaseTime|"_ReleaseTime_"^NO|"_NO_"^AddPer|"_AddPer
	..s:$IsObject(obj.AddPerDr) AddPerId = obj.AddPerDr.%Id()
	..s Flag = obj.Flag
	..d obj.%Close()
	..q:(AddPerId'=inUserId)&(Flag="0")
	..s NO = NO + 1
 	..d TrainQuestionsRow
 	e  d
 	.k ^TMP("HB",$j)
 	.s rw = ""
 	.f  s rw = $o(^DHCMGNUR.MgNurTrainQuestionsSubD(prw,rw)) q:rw=""  d
 	..s obj = ##class(DHCMGNUR.MgNurTrainQuestionsSub).%OpenId(prw_"||"_rw)
	..s Questions = "",ReleaseTime = "",AddPerId = "",Date = "",Time = "",AddPer = ""
	..s:obj.Questions.Count()>0 Questions = ..clearHTML(obj.Questions.GetAt(1).getText())
	..s:(obj.ReleaseDate'="")&&(obj.ReleaseTime'="") ReleaseTime = $zdt(obj.ReleaseDate_","_obj.ReleaseTime,3)
	..s:$IsObject(obj.AddPerDr) AddPer = obj.AddPerDr.SSUSRName
	..s ret = "rw|"_$tr(obj.%Id(),"||","__")_"^Flag|"_obj.Flag_"^Questions|"_Questions_"^ReleaseTime|"_ReleaseTime_"^AddPer|"_AddPer
	..s:$IsObject(obj.AddPerDr) AddPerId = obj.AddPerDr.%Id()
	..s Flag = obj.Flag
	..s Date = $s(obj.ReleaseDate'="":obj.ReleaseDate,1:1)
	..s Time = $s(obj.ReleaseTime'="":obj.ReleaseTime,1:1)
	..d obj.%Close()
	..q:(AddPerId'=inUserId)&(Flag="0")
 	..s ^TMP("HB",$j,Date,Time,rw) = ret
 	.s Date = ""
 	.f  s Date = $o(^TMP("HB",$j,Date),-1) q:Date=""  d
 	..s Time = ""
 	..f  s Time = $o(^TMP("HB",$j,Date,Time),-1) q:Time=""  d
 	...s rw = ""
 	...f  s rw = $o(^TMP("HB",$j,Date,Time,rw)) q:rw=""  d
 	....s ret = ^TMP("HB",$j,Date,Time,rw)_"^NO|"_NO
 	....s NO = NO + 1
 	....d TrainQuestionsRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TrainQuestionsRow
	
	
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTrainQuestionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainQuestionsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTrainQuestionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainQuestionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 培训提问作答 Query
/// xukun
/// 2016-03-17
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindTrainAnswers","70^27^nurse^47__3")
Query FindTrainAnswers(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTrainAnswersExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
 	s prw = $p(parr,"^",4)
 	s pprw = $p(prw,"__",1)
 	s prw = $p(prw,"__",2)
 	s NO = 1
 	i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
 	.s rw = ""
 	.f  s rw = $o(^DHCMGNUR.MgNurTrainAnswersSubD(pprw,prw,rw),-1) q:rw=""  d
 	..s obj = ##class(DHCMGNUR.MgNurTrainAnswersSub).%OpenId(pprw_"||"_prw_"||"_rw)
	..s Answers = "",SubTime = "",RespondentId = "",Respondent = "",Raters = "",ScoreTime = ""
	..s:obj.Answers.Count()>0 Answers = ..clearHTML(obj.Answers.GetAt(1).getText())
	..s:(obj.SubDate'="")&&(obj.SubTime'="") SubTime = $zdt(obj.SubDate_","_obj.SubTime,3)
	..s:(obj.ScoreDate'="")&&(obj.ScoreTime'="") ScoreTime = $zdt(obj.ScoreDate_","_obj.ScoreTime,3)
	..s:$IsObject(obj.Respondent) Respondent = obj.Respondent.SSUSRName
	..s:$IsObject(obj.Raters) Raters = obj.Raters.SSUSRName
	..s ret = "rw|"_$tr(obj.%Id(),"||","__")_"^Flag|"_obj.Flag_"^Answers|"_Answers_"^SubTime|"_SubTime_"^NO|"_NO_"^Respondent|"_Respondent_"^Score|"_obj.Score_"^Raters|"_Raters_"^Views|"_obj.Views_"^ScoreTime|"_ScoreTime
	..s:$IsObject(obj.Respondent) RespondentId = obj.Respondent.%Id()
	..s Flag = obj.Flag
	..d obj.%Close()
	..q:(RespondentId'=inUserId)&(Flag="0")
	..s NO = NO + 1
 	..d TrainAnswersRow
 	e  d
 	.k ^TMP("HB",$j)
 	.s rw = ""
 	.f  s rw = $o(^DHCMGNUR.MgNurTrainAnswersSubD(pprw,prw,rw)) q:rw=""  d
 	..s obj = ##class(DHCMGNUR.MgNurTrainAnswersSub).%OpenId(pprw_"||"_prw_"||"_rw)
	..s Answers = "",SubTime = "",RespondentId = "",Respondent = "",Date = "1",Time = "1",Raters="",ScoreTime = ""
	..s:obj.Answers.Count()>0 Answers = ..clearHTML(obj.Answers.GetAt(1).getText())
	..s:(obj.SubDate'="")&&(obj.SubTime'="") SubTime = $zdt(obj.SubDate_","_obj.SubTime,3)
	..s:(obj.ScoreDate'="")&&(obj.ScoreTime'="") SocreTime = $zdt(obj.ScoreDate_","_obj.ScoreTime,3)
	..s:$IsObject(obj.Raters) Raters = obj.Raters.SSUSRName
	..s:$IsObject(obj.Respondent) Respondent = obj.Respondent.SSUSRName
	..s ret = "rw|"_$tr(obj.%Id(),"||","__")_"^Flag|"_obj.Flag_"^Answers|"_Answers_"^SubTime|"_SubTime_"^Respondent|"_Respondent_"^Score|"_obj.Score_"^Raters|"_Raters_"^Views|"_obj.Views_"^ScoreTime|"_ScoreTime
	..s:$IsObject(obj.Respondent) RespondentId = obj.Respondent.%Id()
	..s Flag = obj.Flag
	..s Date = $s(obj.SubDate'="":obj.SubDate,1:1)
	..s Time = $s(obj.SubTime'="":obj.SubTime,1:1)
	..d obj.%Close()
	..q:(RespondentId'=inUserId)&(Flag="0")
 	..s ^TMP("HB",$j,Date,Time,rw) = ret
 	.s Date = ""
 	.f  s Date = $o(^TMP("HB",$j,Date),-1) q:Date=""  d
 	..s Time = ""
 	..f  s Time = $o(^TMP("HB",$j,Date,Time),-1) q:Time=""  d
 	...s rw = ""
 	...f  s rw = $o(^TMP("HB",$j,Date,Time,rw)) q:rw=""  d
 	....s ret = ^TMP("HB",$j,Date,Time,rw)_"^NO|"_NO
 	....s NO = NO + 1
 	....d TrainAnswersRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
TrainAnswersRow
	
	
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTrainAnswersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainAnswersExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindTrainAnswersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainAnswersExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 工作计划类型 Query
/// xukun
/// 2016-03-20
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWorkType","")
Query FindWorkType1(parr As %String = "") As %Query(ROWSPEC = "Desc,rw")
{
}

ClassMethod FindWorkType1Execute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inText = $zcvt($p(parr,"^",1),"U")
 	s Desc = "病区护理工作计划",id = "W"
 	d WorkType1Row
 	s Desc = "护理质控计划",id = "Q"
 	d WorkType1Row
 	s Desc = "康复训练计划",id = "H"
 	d WorkType1Row
 	s Desc = "业务学习计划",id = "L"
 	d WorkType1Row
 	s Desc = "急救仪器及操作技能培训",id = "T"
 	d WorkType1Row
 	s Desc = "法律法规",id = "R"
 	d WorkType1Row
 	s Desc = "健康教育",id = "E"
 	d WorkType1Row
 	s Desc = "查房计划",id = "I"
 	d WorkType1Row
 	s Desc = "应急培训及演练计划",id = "D"
 	d WorkType1Row
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
WorkType1Row
	q:$zcvt(Desc,"U")'[inText
	set Data=$lb(Desc,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWorkType1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkType1Execute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkType1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 工作计划类型 Query
/// xukun
/// 2016-03-20
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWorkType","")
Query FindWorkType(parr As %String = "") As %Query(ROWSPEC = "Desc,rw")
{
}

ClassMethod FindWorkTypeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inText = $zcvt($p(parr,"^",1),"U")
 	s Desc = "年度"
 	s id = "Y"
 	d WorkTypeRow
 	s Desc = "季度"
 	s id = "Q"
 	d WorkTypeRow
 	s Desc = "月份"
 	s id = "M"
 	d WorkTypeRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
WorkTypeRow
	q:$zcvt(Desc,"U")'[inText
	set Data=$lb(Desc,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWorkTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 工作计划描述/时间 Query
/// xukun
/// 2016-03-20
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWorkDesc","")
Query FindWorkDesc(parr As %String = "") As %Query(ROWSPEC = "Desc,rw")
{
}

ClassMethod FindWorkDescExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s inText = $zcvt($p(parr,"^",1),"U")
 	s inType  =$p(parr,"^",2)
 	q:inType=""
 	
 	i inType = "Y" d
 	.s Desc = "全年"
 	.s rw = "0"
 	.d WorkDescRow
 	e  i inType = "Q" d
 	.f n=1:1:4 d
 	..s Desc = "第"_n_"季度"
 	..s rw = n
 	..d WorkDescRow
 	e  i inType = "M" d
 	.f n=1:1:12 d
 	..s Desc = n_"月"
 	..s rw = n
 	..d WorkDescRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
WorkDescRow
	q:$zcvt(Desc,"U")'[inText
	set Data=$lb(Desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWorkDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkDescExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 护理单元
/// xukun
/// 2016-03-20
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindCTLoc","")
Query FindCTLoc(parr As %String = "") As %Query(ROWSPEC = "Desc,Loc")
{
}

ClassMethod FindCTLocExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s inText = $zcvt($p(parr,"^",1),"U")
 	s inUserId = $p(parr,"^",2)
 	s inLoc = $p(parr,"^",3)
 	s inSecGrp = $p(parr,"^",4)
 	i ((inSecGrp="demo")||(inSecGrp="hlbzr")||(inSecGrp="hlb")) d
 	.s rw = ""
 	.f  s rw = $o(^DHCMGNUR.MgNurPerWardD(rw)) q:rw=""  d
 	..s a = ##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
 	..s Loc = a.WardLoc
 	..d a.%Close()
 	..d OutputRow
 	e  i (inSecGrp="znurhead") d
 	.s code = ""
 	.f  s code = $o(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_inUserId,code)) q:code=""  d
 	..s Loc = ""
 	..f  s Loc = $o(^DHCMGNUR.MgNurMaCareUnitI("Typ",code,Loc)) q:Loc=""  d OutputRow
 	e  i (inSecGrp="nurhead")||(inSecGrp="nurse") d
 	.s Loc = inLoc d OutputRow	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	q:(Loc=0)||($d(^CTLOC(Loc))=0)||(Loc="9999")||(Loc="9998")||(Loc="9997")
	s a = ##class(User.CTLoc).%OpenId(Loc)
	s Desc = a.CTLOCDesc
	d a.%Close()
	
	q:$zcvt(Desc,"U")'[inText
	set Data=$lb(Desc,Loc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 护理工作质量持续改进记录 Query
/// xukun
/// 2016-03-14
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindQualityIMPSub","351")
Query FindQualityIMPSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualityIMPSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindQualityIMPSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindQualityIMPSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	s rw = ""
	f  s rw = $o(^DHCMGNUR.MgNurQualityIMPSubD(parr,rw),-1) q:rw=""  d
	.s obj = ##class(DHCMGNUR.MgNurQualityIMPSub).%OpenId(parr_"||"_rw)
	.s Participant = "",	Discussion = "",Aanalysis = "",Measure = "",Evaluation = ""
	.s len = obj.Participant.Count()
	.s RowId = $tr(obj.%Id(),"||","__")
	.f i=1:1:len d
	..s:i'=1 Participant = Participant_","
	..s Participant = Participant_obj.Participant.GetAt(i).PersonName
	.s ret = "rw|"_RowId_"^Name|参与人员^Content|"_Participant
	.d QualityIMPSubRow
	.s:obj.Discussion.Count()>0 Discussion = ##class(web.DHCNurHBComm).clearHTML(obj.Discussion.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|讨论内容^Content|"_Discussion
	.d QualityIMPSubRow
	.s:obj.Analysis.Count()>0 Aanalysis = ##class(web.DHCNurHBComm).clearHTML(obj.Analysis.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|质量分析^Content|"_Aanalysis
	.d QualityIMPSubRow
	.s:obj.Measure.Count()>0 Measure = ##class(web.DHCNurHBComm).clearHTML(obj.Measure.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|改进措施^Content|"_Measure
	.d QualityIMPSubRow
	.s:obj.Evaluation.Count()>0 Evaluation = ##class(web.DHCNurHBComm).clearHTML(obj.Evaluation.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|效果评价^Content|"_Evaluation
	.d QualityIMPSubRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
QualityIMPSubRow
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualityIMPSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindQualityIMPSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {	
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 危重症患者抢救技术培训及演练记录 Query
/// 精神科突发事件应急预案培训及演练记录 Query
/// xukun
/// 2016-03-05
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindDrillRec",^xukun)
Query FindDrillRec(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindDrillRecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDrillRecFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindDrillRecExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inDesc = $p(parr,"^",7)
	s inType = " "_$p(parr,"^",8)
	s inType2 = " "_$p(parr,"^",9)
	s:$p(parr,"^",9)="" inType2 = " M"
	s:(inSecGrp="nurse")||(inSecGrp="nurhead") inSLoc = inLoc
	i inSLoc = "" d
	.i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
	..i inFlag = "" d
	...s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Type",inType,inType2,rw),-1) q:rw=""  d DrillRecRow
	..e  d
	...s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Flag",inType,inType2,inFlag,rw),-1) q:rw=""  d DrillRecRow
	.e  i inSecGrp="znurhead" d
	..s code = "" f  s code = $o(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_inUserId,code)) q:code=""  d
 	...s Loc = "" f  s Loc = $o(^DHCMGNUR.MgNurMaCareUnitI("Typ",code,Loc)) q:Loc=""  d
 	....i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	.....s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYM",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d DrillRecRow
	....e  d
 	.....s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Dep",inType,inType2,Loc,rw),-1) q:rw=""  d DrillRecRow
 	e  d
 	.i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	..s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("DYM",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d DrillRecRow
	.e  d
	..s rw = "" f  s rw = $o(^DHCMGNUR.MgNurMonthRecI("Dep",inType,inType2,inSLoc,rw),-1) q:rw=""  d DrillRecRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
DrillRecRow
	s obj = ##class(DHCMGNUR.MgNurMonthRec).%OpenId(rw)
	s Flag = obj.Flag
	s Year = obj.Year
	s Month = obj.Month
	s AddPer = ""
	q:obj.DelFlag="N"
	s:$IsObject(obj.AddPerDr) AddPer = obj.AddPerDr.%Id()
	s DepId = ""
	s:$IsObject(obj.DepDr) DepId = obj.DepDr.%Id()
	d obj.%Close()
	q:(inDesc'="")&&(inDesc'=Month)
	q:(inFlag'="")&&(Flag'=inFlag)
	q:(Flag=0)&&(AddPer'=inUserId)
	q:(inYear'="")&&(inYear'=Year)
	q:(inSLoc'="")&&(inSLoc'=DepId)
	q:((inSecGrp="demo")&&(Flag'=4))
	s srw = $o(^DHCMGNUR.MgNurDrillRecSubD(rw,""))
	s:srw'="" ret = ##class(DHCMGNUR.MgNurDrillRecSub).getValue(rw_"||"_srw)_"^"_##class(DHCMGNUR.MgNurMonthRec).getValue(rw)
	s:srw="" ret = ##class(DHCMGNUR.MgNurMonthRec).getValue(rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindDrillRecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDrillRecExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护理部危重症患者抢救技术培训及演练记录 Query
/// 护理部精神科突发事件应急预案培训及演练记录 Query
/// jiangyingcan
/// 2016-10-24
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHLBDrillRec",)
Query FindHLBDrillRec(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHLBDrillRecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHLBDrillRecFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHLBDrillRecExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^jyc=parr
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inDesc = $p(parr,"^",7)
	s inType = " "_$p(parr,"^",8)
	s inType2 = " "_$p(parr,"^",9)
	s:$p(parr,"^",9)="" inType2 = " M"
	s:(inSecGrp="nurse")||(inSecGrp="nurhead") inSLoc = inLoc
	b
	i inSLoc = "" d
	.i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
	..i inFlag = "" d
	...s rw = ""
	...f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Type",inType,inType2,rw),-1) q:rw=""  d HLBDrillRecRow
	..e  d
	...s rw = "" d
	...f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Flag",inType,inType2,inFlag,rw),-1) q:rw=""  d HLBDrillRecRow
	.e  i inSecGrp="znurhead" d
	..s code = ""
	..f  s code = $o(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_inUserId,code)) q:code=""  d
 	...s Loc = ""
 	...f  s Loc = $o(^DHCMGNUR.MgNurMaCareUnitI("Typ",code,Loc)) q:Loc=""  d
 	....i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	.....s rw = ""
 	.....f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DYM",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d HLBDrillRecRow
	....e  d
 	.....s rw = ""
 	.....f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Dep",inType,inType2,Loc,rw),-1) q:rw=""  d HLBDrillRecRow
 	e  d
 	.b
 	.i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DYM",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d HLBDrillRecRow
	.e  d
	..s rw = ""
	..f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Dep",inType,inType2,inSLoc,rw),-1) q:rw=""  d HLBDrillRecRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HLBDrillRecRow
	s obj = ##class(DHCMGNUR.MgNurHeadMonthRec).%OpenId(rw)
	s Flag = obj.Flag
	s Year = obj.Year
	s Month = obj.Month
	s AddPer = ""
	s:$IsObject(obj.AddPerDr) AddPer = obj.AddPerDr.%Id()
	s DepId = ""
	s:$IsObject(obj.DepDr) DepId = obj.DepDr.%Id()
	d obj.%Close()
	q:(inDesc'="")&&(inDesc'=Month)
	q:(inFlag'="")&&(Flag'=inFlag)
	q:(Flag=0)&&(AddPer'=inUserId)
	q:(inYear'="")&&(inYear'=Year)
	q:(inSLoc'="")&&(inSLoc'=DepId)
	s srw = $o(^DHCMGNUR.MgNurHLBDrillRecSubD(rw,""))
	s:srw'="" ret = ##class(DHCMGNUR.MgNurHLBDrillRecSub).getValue(rw_"||"_srw)_"^"_##class(DHCMGNUR.MgNurHeadMonthRec).getValue(rw)
	s:srw="" ret = ##class(DHCMGNUR.MgNurHeadMonthRec).getValue(rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHLBDrillRecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHLBDrillRecExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 病区安全检查记录 
/// xukun
/// 2016-03-22
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWardSafetyCheckSub","41")
Query FindWardSafetyCheckSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardSafetyCheckSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindWardSafetyCheckSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindWardSafetyCheckSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s count = 1
	i parr'="" d
	.s SDate = ""
	.f  s SDate = $o(^DHCMGNUR.MgNurWardSafetyCheckSubD("SDate",parr,SDate),-1) q:SDate=""  d
	..s sub = ""
	..f  s sub = $o(^DHCMGNUR.MgNurWardSafetyCheckSubD("SDate",parr,SDate,sub),-1) q:sub=""  d WardSafetyCheckSubRow
 	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
WardSafetyCheckSubRow
	s ret = ##class(DHCMGNUR.MgNurWardSafetyCheckSub).getValue(parr_"||"_sub)_"^No|"_count
	s count = count + 1
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardSafetyCheckSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindWardSafetyCheckSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWorkSType","")
/// 工作总结类型
Query FindWorkSType(parr As %String = "") As %Query(ROWSPEC = "Desc,rw")
{
}

ClassMethod FindWorkSTypeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s inText = $zcvt($p(parr,"^",1),"U")
 	
 	s Desc = "年度"
 	s id = "H"
 	d OutputRow3
 	;s Desc = "季度"
 	;s id = "Q"
 	;d OutputRow3
 	s Desc = "月份"
 	s id = "M"
 	d OutputRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	q:$zcvt(Desc,"U")'[inText
	set Data=$lb(Desc,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWorkSTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkSTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkSTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkSTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWorkSDesc","^67||3")
/// 工作总结描述/时间
Query FindWorkSDesc(parr As %String = "") As %Query(ROWSPEC = "Desc,rw")
{
}

ClassMethod FindWorkSDescExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	s inText = $zcvt($p(parr,"^",1),"U")
 	s inType  =$p(parr,"^",2)
 	q:inType
 	i inType = "H" d
 	.s Desc = "上半年"
 	.s rw = "1"
 	.d OutputRow4
 	.s Desc = "全年"
 	.s rw = "2"
 	.d OutputRow4
 	e  i inType = "Q" d
 	.f n=1:1:4 d
 	..s Desc = "第"_n_"季度"
 	..s rw = n
 	..d OutputRow4
 	e  i inType = "M" d
 	.f n=1:1:12 d
 	..s Desc = n_"月"
 	..s rw = n
 	..d OutputRow4
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	q:$zcvt(Desc,"U")'[inText
	set Data=$lb(Desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWorkSDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkSDescExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkSDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkSDescExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// DHCMGNUR.MgNurHLBQualityCheck Query
/// xukun
/// 2016-03-28
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHLBQualityCheck","1")
Query FindHLBQualityCheck(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHLBQualityCheckClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHLBQualityCheckFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHLBQualityCheckExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^xukun = parr
	
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inGroup = $p(parr,"^",3)
	s inPrw = $p(parr,"^",4)
	
	k ^TMP("FindHLBQualityCheck",$j)
	s raw = ""
	f  s raw = $o(^DHCMGNUR.MgNurHLBQualityCheckD(inPrw,raw)) q:raw=""  d HLBQualityCheckRow
	
	s DepId = ""
	f  s DepId = $o(^TMP("FindHLBQualityCheck",$j,DepId),-1) q:DepId=""  d
	.s Date = ""
	.f  s Date = $o(^TMP("FindHLBQualityCheck",$j,DepId,Date),-1) q:Date=""  d
	..s rw = ""
	..f  s rw = $o(^TMP("FindHLBQualityCheck",$j,DepId,Date,rw),-1) q:rw=""  d
	...s ret = ^TMP("FindHLBQualityCheck",$j,DepId,Date,rw)
	...set Data=$lb(ret)
 	...Set ^CacheTeWP(repid,ind)=Data
 	...Set ind=ind+1
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HLBQualityCheckRow
	s rw = inPrw_"||"_raw
	s obj = ##class(DHCMGNUR.MgNurHLBQualityCheck).%OpenId(rw)
	s DepId = obj.DepDr.%Id()
	s Date = obj.Date
	d obj.%Close()
	q:((inGroup="nurhead")||(inGroup="nurse"))&&(DepId'=inLoc)
	s ^TMP("FindHLBQualityCheck",$j,..getPerWardSort(DepId),Date,rw) = ##class(DHCMGNUR.MgNurHLBQualityCheck).getValue(rw)
	q
}

ClassMethod FindHLBQualityCheckFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHLBQualityCheckExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 考核项目(取最高版本)
/// xukun 2016-03-29
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindExamineItem","3")
Query FindExamineItem(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindExamineItemClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindExamineItemFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindExamineItemExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	k ^TMP("HB","FindExamineItem",$j)
	s code = ""
	f  s code = $o(^DHCMGNUR.MgNurExamineItemI("Version",code)) q:code=""  d
	.s version = $o(^DHCMGNUR.MgNurExamineItemI("Version",code,""),-1)
	.s rw = ""
	.f  s rw = $o(^DHCMGNUR.MgNurExamineItemI("Version",code,version,rw)) q:rw=""  d
	..s ^TMP("HB","FindExamineItem",$j,$l(code),code,rw) = rw
	
	s l = ""
	f  s l = $o(^TMP("HB","FindExamineItem",$j,l)) q:l=""  d
	.s tmp = ""
	.f  s tmp = $o(^TMP("HB","FindExamineItem",$j,l,tmp)) q:tmp=""  d
	..s rw = ""
	..f  s rw = $o(^TMP("HB","FindExamineItem",$j,l,tmp,rw)) q:rw=""  d ExamineItemRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
ExamineItemRow
	s ret = ##class(DHCMGNUR.MgNurExamineItem).getValue(rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindExamineItemFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExamineItemExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 考核项目下拉列表
/// 2016-03-29 xukun
Query FindExamineItemCom(parr As %String) As %Library.Query(ROWSPEC = "desc,id")
{
}

ClassMethod FindExamineItemComClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindExamineItemComFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindExamineItemComExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^xukun = parr
	k ^TMP("HB","FindExamineItemCom",$j)
	s inDesc = $p(parr,"^",1)
	s code = ""
	f  s code = $o(^DHCMGNUR.MgNurExamineItemI("Version",code)) q:code=""  d
	.s version = $o(^DHCMGNUR.MgNurExamineItemI("Version",code,""),-1)
	.s rw = ""
	.f  s rw = $o(^DHCMGNUR.MgNurExamineItemI("Version",code,version,rw)) q:rw=""  d
	..s ^TMP("HB","FindExamineItemCom",$j,$l(code),code,rw) = rw
	
	s l = ""
	f  s l = $o(^TMP("HB","FindExamineItemCom",$j,l)) q:l=""  d
	.s tmp = ""
	.f  s tmp = $o(^TMP("HB","FindExamineItemCom",$j,l,tmp)) q:tmp=""  d
	..s rw = ""
	..f  s rw = $o(^TMP("HB","FindExamineItemCom",$j,l,tmp,rw)) q:rw=""  d ExamineItemRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
ExamineItemRow
	s obj = ##class(DHCMGNUR.MgNurExamineItem).%OpenId(rw)
	s Desc = obj.Desc
	d obj.%Close()
	q:inDesc'="" Desc'[inDesc 
	set Data=$lb(Desc,rw)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindExamineItemComFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExamineItemComExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 考核项目子项
/// xukun 2016-03-29
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindExamineItemSub","3")
Query FindExamineItemSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindExamineItemSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindExamineItemSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindExamineItemSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	k ^TMP("HB","FindExamineItemSub",$j)
	s Level = ""
	f  s Level = $o(^DHCMGNUR.MgNurExamineItemSubI("Code",parr,Level)) q:Level=""  d
	.s Code = ""
	.f  s Code = $o(^DHCMGNUR.MgNurExamineItemSubI("Code",parr,Level,Code)) q:Code=""  d
	..s rw = ""
	..f  s rw = $o(^DHCMGNUR.MgNurExamineItemSubI("Code",parr,Level,Code,rw)) q:rw=""  d 
	...s tmp = $tr(Code," ","")
	...s t1 = $s($p(tmp,".",1)'="":$p(tmp,".",1),1:0)
	...s t2 = $s($p(tmp,".",2)'="":$p(tmp,".",2),1:0)
	...s ^TMP("HB","FindExamineItemSub",$j,t1,t2,rw) = rw
	
	s t1 = ""
	f  s t1 = $o(^TMP("HB","FindExamineItemSub",$j,t1)) q:t1=""  d
	.s t2 = ""
	.f  s t2 = $o(^TMP("HB","FindExamineItemSub",$j,t1,t2)) q:t2=""  d
	..s rw = ""
	..f  s rw = $o(^TMP("HB","FindExamineItemSub",$j,t1,t2,rw)) q:rw=""  d ExamineItemSubRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
ExamineItemSubRow
	s ret = ##class(DHCMGNUR.MgNurExamineItemSub).getValue(parr_"||"_rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindExamineItemSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExamineItemSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护理技术操作考核记录
/// xukun 2016-03-29
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindExamineRec","1030^27^nurhead^^^2016^3^^")
Query FindExamineRec(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindExamineRecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindExamineRecFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindExamineRecExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inGroup = $P(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inMonth = $p(parr,"^",7)
	s inItem = $p(parr,"^",8)
	s inPer = $p(parr,"^",9)
	k ^TMP("ExamineRec",$j)
	
	s:(inGroup="nurse")||(inGroup="nurhead") inSLoc = inLoc
	
	i inSLoc = "" d
	.i (inGroup="demo")||(inGroup="hlbzr")||(inGroup="hlb") d
	..i inFlag '= "" d
	...s rw = ""
	...f  s rw = $o(^DHCMGNUR.MgNurExamineRecI("Flag",inFlag,rw)) q:rw=""  d ExamineRecRow
	..e  d
	...s rw = ""
	...f  s rw = $o(^DHCMGNUR.MgNurExamineRecD(rw)) q:rw=""  d ExamineRecRow
	e  d
	.s rw = ""
	.f  s rw = $o(^DHCMGNUR.MgNurExamineRecI("Dep",inSLoc,rw)) q:rw=""  d ExamineRecRow
	
	s date = ""
	f  s date = $o(^TMP("ExamineRec",$j,date),-1) q:date=""  d
	.s rw = ""
	.f  s rw = $o(^TMP("ExamineRec",$j,date,rw),-1) q:rw=""  d
	..s ret = ^TMP("ExamineRec",$j,date,rw)
	..set Data=$lb(ret)
 	..Set ^CacheTeWP(repid,ind)=Data
 	..Set ind=ind+1
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
ExamineRecRow
	s obj = ##class(DHCMGNUR.MgNurExamineRec).%OpenId(rw)
	s Flag = obj.Flag
	s DepId = obj.DepDr.%Id()
	s Year = obj.Year
	s Month = obj.Month
	s ItemId = obj.ItemDr.%Id()
	s PerId = obj.PerDr.%Id()
	s AddPer = obj.AddPerDr.%Id()
	s Date = obj.Date
	d obj.%Close()
	s UserID = ""
	i inGroup="nurse" d
	.s UserID = ..getUserIDByPersonRW(PerId)
	q:(inGroup="nurse")&&(UserID'=inUserId)
	q:(inFlag'="")&(inFlag'=Flag)
	q:(Flag=0)&(inUserId'=AddPer)
	q:(inSLoc'="")&(inSLoc'=DepId)
	q:(inYear'="")&(inYear'=Year)
	q:(inMonth'="")&(inMonth'=Month)
	q:(inItem'="")&(inItem'=ItemId)
	q:(inPer'="")&(inPer'=PerId)
	s ^TMP("ExamineRec",$j,Date,rw) = ##class(DHCMGNUR.MgNurExamineRec).getValue(rw)
	q
}

ClassMethod FindExamineRecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExamineRecExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护理技术操作考核记录详情
/// xukun 2016-03-29
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindExamineRecSub","3")
Query FindExamineRecSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindExamineRecSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindExamineRecSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindExamineRecSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s Sum = 0,DedSum = 0
	s Level = ""
	f  s Level = $o(^DHCMGNUR.MgNurExamineRecSubI("Code",parr,Level)) q:Level=""  d
	.s Code = ""
	.f  s Code = $o(^DHCMGNUR.MgNurExamineRecSubI("Code",parr,Level,Code)) q:Code=""  d
	..s rw = ""
	..f  s rw = $o(^DHCMGNUR.MgNurExamineRecSubI("Code",parr,Level,Code,rw)) q:rw=""  d ExamineRecSubRow
	
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
ExamineRecSubRow
	s ret = ##class(DHCMGNUR.MgNurExamineRecSub).getValue(parr_"||"_rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindExamineRecSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindExamineRecSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 参加病区交班会记录
/// jiangyingcan 2016-12-01
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindShiftExchange","")
Query FindShiftExchange(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindShiftExchangeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindShiftExchangeFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindShiftExchangeExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s userid=$p(parr,"^",1)
	s CtLocId=$p(parr,"^",2)
	s group=$p(parr,"^",3)
	s depid=$p(parr,"^",4)
	s data=$p(parr,"^",5)
	s rw="",PerId=""
	i group="demo" d
	.f  s rw=$o(^DHCMGNUR.MgNURDepShiftExchangeD(rw)) q:rw=""  d ShiftExchangeRow
	e  d
	.f  s rw=$o(^DHCMGNUR.MgNURDepShiftExchangeD(rw)) q:rw=""  d
	..s obj=##class(DHCMGNUR.MgNURDepShiftExchange).%OpenId(rw)
	..s:$IsObject(obj.AddPerson) PerId = obj.AddPerson.%Id()
	..i userid=PerId  d ShiftExchangeRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
ShiftExchangeRow
	s ret = ##class(DHCMGNUR.MgNURDepShiftExchange).getValue(rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindShiftExchangeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindShiftExchangeExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护理查房
/// xukun 2016-03-30
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindRoundsRecSub","11474^36^nurhead^^^2016^4")
Query FindRoundsRecSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindRoundsRecSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRoundsRecSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindRoundsRecSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inGroup = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inMonth = $p(parr,"^",7)
	s ^TEMP("g08121103001") = parr
	s:(inGroup="nurse")||(inGroup="nurhead") inSLoc = inLoc
	
	i inSLoc = "" d
	.i (inGroup="demo")||(inGroup="hlbzr")||(inGroup="hlb") d
	..s prw = ""
	..f  s prw = $o(^DHCMGNUR.MgNurMonthRecI("Type"," NR"," M",prw)) q:prw=""  d RoundsRecSubRow
	e  d
	.s prw = ""
	.f  s prw = $o(^DHCMGNUR.MgNurMonthRecI("Dep"," NR"," M",inSLoc,prw)) q:prw=""  d RoundsRecSubRow

	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
RoundsRecSubRow
	s obj = ##class(DHCMGNUR.MgNurMonthRec).%OpenId(prw)
	s Year = obj.Year
	s Month = obj.Month
	s Flag = obj.Flag
	s AddPer = obj.AddPerDr.%Id()
	d obj.%Close()
	q:(inYear'="")&&(inYear'=Year)
	q:(inMonth'="")&&(inMonth'=Month)
	q:(inFlag'="")&&(inFlag'=Flag)
	q:(Flag=0)&&(inUserId'=AddPer)
	s rw = $o(^DHCMGNUR.MgNurRoundsRecSubD(prw,""),-1)
	q:rw=""
	s ret = ##class(DHCMGNUR.MgNurRoundsRecSub).getValue(prw)
	s ^jyc=ret
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindRoundsRecSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRoundsRecSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 护理部查房记录
/// jiangyingcan
/// 2016-10-25
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHLBRoundsRecSub","11474^36^nurhead^^^2016^4")
Query FindHLBRoundsRecSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHLBRoundsRecSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHLBRoundsRecSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHLBRoundsRecSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inGroup = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inMonth = $p(parr,"^",7)
	s:(inGroup="nurse")||(inGroup="nurhead") inSLoc = inLoc
	
	i inSLoc = "" d
	.i (inGroup="demo")||(inGroup="hlbzr")||(inGroup="hlb") d
	..s prw = ""
	..f  s prw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Type"," NH"," M",prw)) q:prw=""  d HLBRoundsRecSubRow
	e  d
	.s prw = ""
	.f  s prw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Dep"," NH"," M",inSLoc,prw)) q:prw=""  d HLBRoundsRecSubRow

	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HLBRoundsRecSubRow
	s obj = ##class(DHCMGNUR.MgNurHeadMonthRec).%OpenId(prw)
	s Year = obj.Year
	s Month = obj.Month
	s Flag = obj.Flag
	s AddPer = obj.AddPerDr.%Id()
	d obj.%Close()
	q:(inYear'="")&&(inYear'=Year)
	q:(inMonth'="")&&(inMonth'=Month)
	q:(inFlag'="")&&(inFlag'=Flag)
	q:(Flag=0)&&(inUserId'=AddPer)
	s rw = $o(^DHCMGNUR.MgNurHLBRoundsRecSubD(prw,""),-1)
	q:rw=""
	s ret = ##class(DHCMGNUR.MgNurHLBRoundsRecSub).getValue(prw)
	s ^jyc=ret
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod FindHLBRoundsRecSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHLBRoundsRecSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// DHCMGNUR.MgNurHeadMonthRec Query
/// jiangyingcan
/// 2016-09-22
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHeadMonthRec","69^118^hlbzr^^^2016^^WH^H")
Query FindHeadMonthRec(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHeadMonthRecClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHeadMonthRecFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHeadMonthRecExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^JYC = parr
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inDesc = $p(parr,"^",7)
	s inType = " "_$p(parr,"^",8)
	s inType2 = " "_$p(parr,"^",9)
	s:$p(parr,"^",9)="" inType2 = " M"
	s:(inSecGrp="nurse")||(inSecGrp="nurhead") inSLoc = inLoc
	b
	i inSLoc = "" d
	.i (inSecGrp="demo")||(inSecGrp="hlb")||(inSecGrp="hlbzr") d
	..i inFlag = "" d
	...s rw = ""
	...f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Type",inType,inType2,rw),-1) q:rw=""  d HeadMonthRecRow
	..e  d
	...s rw = "" d
	...f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Flag",inType,inType2,inFlag,rw),-1) q:rw=""  d HeadMonthRecRow
	.e  i inSecGrp="znurhead" d
	..s code = ""
	..f  s code = $o(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_inUserId,code)) q:code=""  d
 	...s Loc = ""
 	...f  s Loc = $o(^DHCMGNUR.MgNurMaCareUnitI("Typ",code,Loc)) q:Loc=""  d
 	....i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	.....s rw = ""
 	.....i inType2 = " Y" d
 	......f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DY",inType,inType2,Loc,inYear,rw),-1) q:rw=""  d HeadMonthRecRow
 	.....i inType2 = " H" d
 	......f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DYH",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d HeadMonthRecRow
 	.....i inType2 = " Q" d
 	......f  s rw =  $o(^DHCMGNUR.MgNurHeadMonthRecI("DYQ",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d HeadMonthRecRow
 	.....i inType2 = " M" d
 	......f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DYM",inType,inType2,Loc,inYear,inDesc,rw),-1) q:rw=""  d HeadMonthRecRow
	....e  d
 	.....s rw = ""
 	.....f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Dep",inType,inType2,Loc,rw),-1) q:rw=""  d HeadMonthRecRow
 	e  d
 	.i (inYear'="")&&(inDesc'="")&&(inDesc'=0) d
 	..s rw = ""
	..i inType2 = " Y" d
 	...f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DY",inType,inType2,inSLoc,inYear,rw),-1) q:rw=""  d HeadMonthRecRow
 	..i inType2 = " H" d
 	...f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DYH",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d HeadMonthRecRow
 	..i inType2 = " Q" d
 	...f  s rw =  $o(^DHCMGNUR.MgNurHeadMonthRecI("DYQ",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d HeadMonthRecRow
 	..i inType2 = " M" d
 	...f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("DYM",inType,inType2,inSLoc,inYear,inDesc,rw),-1) q:rw=""  d HeadMonthRecRow
	.e  d
	..s rw = ""
	..b
	..f  s rw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Dep",inType,inType2,inSLoc,rw),-1) q:rw=""  d HeadMonthRecRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HeadMonthRecRow
	b
	s obj = ##class(DHCMGNUR.MgNurHeadMonthRec).%OpenId(rw)
	s Flag = obj.Flag
	s Year = obj.Year
	s Desc = ""
	s:inType2=" H" Desc = obj.Half
	s:inType2=" Q" Desc = obj.Quarter
	s:inType2=" M" Desc = obj.Month
	s AddPer = ""
	s:$IsObject(obj.AddPerDr) AddPer = obj.AddPerDr.%Id()
	s DepId = ""
	s:$IsObject(obj.DepDr) DepId = obj.DepDr.%Id()
	d obj.%Close()
	b
	q:(inFlag'="")&&(Flag'=inFlag)
	q:(Flag=0)&&(AddPer'=inUserId)
	q:(inYear'="")&&(inYear'=Year)
	q:(inDesc'="")&&(inDesc'=Desc)&&(inDesc'=0)
	q:(inSLoc'="")&&(inSLoc'=DepId)
	
	s ret = ##class(DHCMGNUR.MgNurHeadMonthRec).getValue(rw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHeadMonthRecFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHeadMonthRecExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// web.DHCNurHBComm
/// jiangyingcan
/// 2016-09-23
/// 查询登录的护士职务 
ClassMethod FindNurseDutyInfo(nurseId As %String) As %String
{
	s ret=""
	s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_nurseId,""))
	i id'="" d
	.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	.i a.PersonheadshipDR'="" s NurseDuty=a.PersonheadshipDR.Code
	.e  s NurseDuty=""
	.s ret=NurseDuty
	q ret
}

/// web.DHCNurHBComm
/// jiangyingcan
/// 2016-09-23
/// 查询登录的护士信息 
ClassMethod FindNurseInfo(nurseId As %String) As %String
{
	s ret=""
	s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_nurseId,""))
	i id'="" d
	.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	.i a.PersonheadshipDR'="" s NurseDuty=a.PersonheadshipDR.Code
	.e  s NurseDuty=""
	.s NurseDutyId1=$o(^DHCMGNUR.CommDictionarySubI("Code"," "_a.PersonheadshipDR.Code,""))
	.s NurseDutyId2=$o(^DHCMGNUR.CommDictionarySubI("Code"," "_a.PersonheadshipDR.Code,NurseDutyId1,""))
	.s NurseDutyId=NurseDutyId1_"__"_NurseDutyId2
	.i a.PersonSchoolAgeDr'="" s education=a.PersonSchoolAgeDr.Code
	.e  s education=""
	.s educationId1=$o(^DHCMGNUR.CommDictionarySubI("Code"," "_a.PersonSchoolAgeDr.Code,""))
	.s educationId2=$o(^DHCMGNUR.CommDictionarySubI("Code"," "_a.PersonSchoolAgeDr.Code,educationId1,""))
	.s educationId=educationId1_"__"_educationId2
	.s sex=a.PersonSexDR
	.i sex="1"  s sex="女"
	.i sex="2"  s sex="男"
	.i a.PersonAppDutyDR'="" s duty=a.PersonAppDutyDR.Code
	.e  s duty=""
	.s dutyId1=$o(^DHCMGNUR.CommDictionarySubI("Code"," "_a.PersonAppDutyDR.Code,""))
	.s dutyId2=$o(^DHCMGNUR.CommDictionarySubI("Code"," "_a.PersonAppDutyDR.Code,dutyId1,""))
	.s dutyId=dutyId1_"__"_dutyId2
	.;s seniority=$zd(a.PersonBirthDay,3)
	.;s Now=$zd($h,3)
	.s seniority=##class(web.DHCMgNurStatDistibute).CalAge(a.PersonBirthDay,$h)
	.s seniority=$p(seniority,"Y",1)
	.s ret="NurseDuty|"_NurseDuty_"^education|"_education_"^sex|"_sex_"^duty|"_duty_"^seniority|"_seniority_"^NurseDutyId|"_NurseDutyId_"^educationId|"_educationId_"^dutyId|"_dutyId
	q ret
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
	//b ;1109
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

/// 月总护士长工作重点内容 Query
/// jiangyingcan
/// 2016-10-08
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHeadWorkFocusSub","1")
Query FindHeadWorkFocusSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHeadWorkFocusSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHeadWorkFocusSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHeadWorkFocusSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	
	i parr'="" d
	.s sub = ""
	.f  s sub = $o(^DHCMGNUR.MgNurHeadWorkFocusSubD(parr,sub)) q:sub=""  d HeadWorkFocusSubRow
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HeadWorkFocusSubRow
	s ret = ##class(DHCMGNUR.MgNurHeadWorkFocusSub).getValue(parr_"||"_sub)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHeadWorkFocusSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHeadWorkFocusSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 总护士长晨会讲评记录
/// jiangyingcan
/// 2016-09-22
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHeadAmCommentSub","3")
Query FindHeadAmCommentSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHeadAmCommentSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHeadAmCommentSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHeadAmCommentSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s ^jyc111=parr
	i parr'="" d
	.s sub = ""
	.f  s sub = $o(^DHCMGNUR.MgNurHeadAmCommentRecSubD(parr,sub),-1) q:sub=""  d AmCommentRecSubRow
 	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
AmCommentRecSubRow
	s ret = ##class(DHCMGNUR.MgNurHeadAmCommentRecSub).getValue(parr_"||"_sub)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHeadAmCommentSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHeadAmCommentSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 总护士长下拉列表 Query
/// jiangyingcan
/// 2016-10-11
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindNurHeadNur","")
Query FindNurHeadNur(parr As %String) As %Query(ROWSPEC = "desc,id")
{
}

ClassMethod FindNurHeadNurExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inText = $p(parr,"^",1)
 	s inType = $p(parr,"^",2)
 	s inUserId = $p(parr,"^",3)
 	s inGroup = $p(parr,"^",4)
 	s inLoc = $p(parr,"^",5)
 	s inSLoc = $p(parr,"^",6)
 	i inType '= "A" d	
 	.s PersonID = ""
 	.f  s PersonID = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID)) q:PersonID=""  d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsI("SType"," N",PersonID,rw)) q:rw=""  d NurHeadNurRow
 	e  d
 	.s:(inGroup="nurse")||(inGroup="nurhead") inSLoc = inLoc
 	.i inSLoc = "" d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsD(rw)) q:rw=""  d NurHeadNurRow
 	.e  d
 	..s rw = ""
 	..f  s rw = $o(^DHCMGNUR.MgPersonsI("Dep"," "_inSLoc,rw)) q:rw=""  d NurHeadNurRow
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
NurHeadNurRow
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s headship = ""
	s:$IsObject(obj.PersonheadshipDR) headship = obj.PersonheadshipDR.Code
	s desc = obj.PersonName_"("_obj.PersonID_")"
	d obj.%Close()
	q:(headship'="总护士长")
	q:desc'[inText
	set Data=$lb(desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurHeadNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurHeadNurExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNurHeadNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurHeadNurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 总护士长护理质量检查记录 Query
/// jiangyingcan
/// 2016-10-10
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHeadQualityCheck","9")
Query FindHeadQualityCheck(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHeadQualityCheckClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHeadQualityCheckFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHeadQualityCheckExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s TotalSum=0,PassNumSum=0,NoPassNumSum=0
	s rw = ""
	f  s rw = $o(^DHCMGNUR.MgNurHeadQualityCheckSubD(parr,rw),-1) q:rw=""  d
	.s obj = ##class(DHCMGNUR.MgNurHeadQualityCheckSub).%OpenId(parr_"||"_rw)
	.s SDate = "",Inspection = "",InspectionId = "",ReDate = ""
	.s itms=..getitmsM(obj)
    .s Dep=itms
	.s:obj.SDate SDate = $zd(obj.SDate,3)
	.s:obj.ReDate ReDate = $zd(obj.ReDate,3)
	.;i $IsObject(obj.Inspection) d
	..;s Inspection = obj.Inspection.CodeDesc
	..;s InspectionId = obj.Inspection.%Id()
	.s InspectionId=obj.Inspection
	.s Inspection=""
	.i obj.Inspection'="" d
	..s IObj=##class(DHCMGNUR.QualCodeItem).%OpenId(obj.Inspection)
	..s Inspection=IObj.QualDesc
	.s SecInspectionId=obj.SecInspection
	.i obj.SecInspection'="" d
	..s SObj=##class(DHCMGNUR.QualCodeItemSub).%OpenId(obj.SecInspection)
	..s SecInspection=SObj.ItemDesc
	.s TotalSum = obj.Total + TotalSum
	.s PassNumSum = obj.PassNum + PassNumSum
	.s NoPassNumSum = obj.NoPassNum + NoPassNumSum
	.s ret = "raw|"_$tr(obj.%Id(),"||","__")_"^SDate|"_SDate_"^ReDate|"_ReDate_"^Inspection|"_Inspection_"^InspectionId|"_$tr(InspectionId,"||","__")_"^Total|"_obj.Total_"^PassNum|"_obj.PassNum_"^NoPassNum|"_obj.NoPassNum_"^PassRate|"_obj.PassRate_"^Problems|"_obj.Problems_"^Measures|"_obj.Measures_"^Result|"_obj.Result_"^Dep2|"_Dep_"^SecInspection|"_SecInspection_"^SecInspectionId|"_SecInspectionId
	.d obj.%Close()
	.d QualityCheckRow
	s ret = "raw|0^SDate|合计^ReDate|^Inspection|"_InspectionId_"^Total|"_TotalSum_"^PassNum|"_PassNumSum_"^NoPassNum|"_NoPassNumSum_"^PassRate|^Problems|^Measures|^Result|^Dep2|"
	d QualityCheckRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
QualityCheckRow
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHeadQualityCheckFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHeadQualityCheckExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod getitmsM(itm) As %String
{
	s ret=""
    s l=itm.Dep.Count()
	for i=1:1:l
	{
	  s rw=itm.Dep.GetAt(i)
	  s des=$p($p(^CTLOC(rw),"^",2),"-",2)    
	  s ret=ret_des_";"
	}
	q ret
}

/// 
/// 查询三级项目
Query findWChkThirdLists(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod findWChkThirdListsExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TEMP("g081718200011")=parr
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ret="" 
 	s parsub=$p(parr,"||",2)
 	s par=$p(parr,"||",1)
 	s raw="" f  s raw=$O(^DHCMGNUR.MgNurWChkContentD(par,"ChildSub",parsub,"ChildSub",raw)) q:raw=""  d
 	.s obj=##class(DHCMGNUR.MgNurWChkContentSubSub).%OpenId(par_"||"_parsub_"||"_raw)
 	.s content2=obj.ConDescSub
 	.s CreateUser=""
 	.i obj.CreateUserSub'="" d
 	..s CreateUserSub=$P(^SSU("SSUSR",obj.CreateUserSub),"^",2)
 	.e  s CreateUserSub=""
 	.s ret="content2|"_content2_"^CreateUserSub|"_CreateUserSub_"^rawsub|"_raw_"^parsub|"_parsub_"^raw|"_par
 	.d OutputChkList
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputChkList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findWChkThirdListsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findWChkThirdListsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod findWChkThirdListsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findWChkThirdListsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 总护士长护理工作计划类型 Query
/// jiangyingcan
/// 2016-09-22
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindWorkType2","")
Query FindWorkType2(parr As %String = "") As %Query(ROWSPEC = "Desc,rw")
{
}

ClassMethod FindWorkType2Execute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s inText = $zcvt($p(parr,"^",1),"U")
 	s Desc = "病区护理工作计划",id = "Z"
 	d WorkType1Row
 	s Desc = "护理质控计划",id = "Q"
 	d WorkType1Row
 	s Desc = "康复训练计划",id = "H"
 	d WorkType1Row
 	s Desc = "业务学习计划",id = "L"
 	d WorkType1Row
 	s Desc = "急救仪器及操作技能培训",id = "T"
 	d WorkType1Row
 	s Desc = "法律法规",id = "R"
 	d WorkType1Row
 	s Desc = "健康教育",id = "E"
 	d WorkType1Row
 	s Desc = "查房计划",id = "I"
 	d WorkType1Row
 	s Desc = "应急培训及演练计划",id = "W"
 	d WorkType1Row
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
WorkType1Row
	q:$zcvt(Desc,"U")'[inText
	set Data=$lb(Desc,id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWorkType2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkType1Execute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWorkType2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 总护士长工作质量持续改进记录 Query
/// jiangyingcan
/// 2016-10-11
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHeadQualityIMPSub","351")
Query FindHeadQualityIMPSub(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHeadQualityIMPSubClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHeadQualityIMPSubFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHeadQualityIMPSubExecute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s rw = ""
	f  s rw = $o(^DHCMGNUR.MgNurHeadQualityIMPSubD(parr,rw),-1) q:rw=""  d
	.s obj = ##class(DHCMGNUR.MgNurHeadQualityIMPSub).%OpenId(parr_"||"_rw)
	.s Participant = "",	Discussion = "",Aanalysis = "",Measure = "",Evaluation = ""
	.s len = obj.Participant.Count()
	.s RowId = $tr(obj.%Id(),"||","__")
	.f i=1:1:len d
	..s:i'=1 Participant = Participant_","
	..s Participant = Participant_obj.Participant.GetAt(i).PersonName
	.s ret = "rw|"_RowId_"^Name|参与人员^Content|"_Participant
	.d HeadQualityIMPSubRow
	.s:obj.Discussion.Count()>0 Discussion = ##class(web.DHCNurHBComm).clearHTML(obj.Discussion.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|讨论内容^Content|"_Discussion
	.d HeadQualityIMPSubRow
	.s:obj.Analysis.Count()>0 Aanalysis = ##class(web.DHCNurHBComm).clearHTML(obj.Analysis.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|质量分析^Content|"_Aanalysis
	.d HeadQualityIMPSubRow
	.s:obj.Measure.Count()>0 Measure = ##class(web.DHCNurHBComm).clearHTML(obj.Measure.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|改进措施^Content|"_Measure
	.d HeadQualityIMPSubRow
	.s:obj.Evaluation.Count()>0 Evaluation = ##class(web.DHCNurHBComm).clearHTML(obj.Evaluation.GetAt(1).getText())
	.s ret = "rw|"_RowId_"^Name|效果评价^Content|"_Evaluation
	.d HeadQualityIMPSubRow
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HeadQualityIMPSubRow
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHeadQualityIMPSubFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHeadQualityIMPSubExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 总护士长工作质量持续改进记录 Query
/// jiangyingcan
/// 2016-10-11
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindHeadQualityIMPSub1","1^59^demo^^^2016^^HI")
Query FindHeadQualityIMPSub1(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindHeadQualityIMPSub1Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindHeadQualityIMPSub1Fetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindHeadQualityIMPSub1Execute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inDesc = $p(parr,"^",7)
	s:(inSecGrp="nurse")||(inSecGrp="nurhead") inSLoc = Loc
	i inSLoc="" d	
	.s prw = ""
	.f  s prw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Type"," HI"," M",prw)) q:prw=""  d HeadQualityIMPSub1Row
	e  d
	.s prw = ""
	.f  s prw = $o(^DHCMGNUR.MgNurHeadMonthRecI("Dep"," HI"," M",inSLoc,prw)) q:prw=""  d HeadQualityIMPSub1Row
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
HeadQualityIMPSub1Row
	s obj = ##class(DHCMGNUR.MgNurHeadMonthRec).%OpenId(prw)
	s Flag = obj.Flag
	s Year = obj.Year
	s Month = obj.Month
	s AddPer = obj.AddPerDr.%Id()
	d obj.%Close()
	q:(inFlag'="")&&(inFlag'=Flag)
	q:(Flag=0)&&(AddPer'=inUserId)
	q:(inYear'="")&&(inYear'=Year)
	q:(inDesc'="")&&(inDesc'=Month)
	s raw = $o(^DHCMGNUR.MgNurHeadQualityIMPSubD(prw,""))
	s ret = ##class(DHCMGNUR.MgNurHeadQualityIMPSub).getValue(prw_"||"_raw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHeadQualityIMPSub1Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindHeadQualityIMPSub1Execute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取病人主诉、现病史、既往史
/// 入参：
/// 	adm:病人就诊id
/// 	type:
/// 		zs:主诉
/// 		xbs:现病史
/// 		jws:既往史
/// 出参：
/// 	 	主诉/现病史/既往史
/// 回龙观
/// xukun 2016-03-30
ClassMethod getEPRData(adm, type)
{
	s ^TEMP("g07231421001")=adm
	q:adm="" ""
	q:type="zs" ##class(EPRservice.BOScatterData).GetEPRData(adm,"#TYPE:TextDesc#TID:28#TVER:0#ECODE:E0026")
	q:type="xbs" ##class(EPRservice.BOScatterData).GetEPRData(adm,"#TYPE:TextDesc#TID:28#TVER:0#ECODE:E0027")
	q:type="jws" ##class(EPRservice.BOScatterData).GetEPRData(adm,"#TYPE:Segment#TID:28#TVER:0#GCODE:G0029")
	;q:type="zs" "主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉主诉"
	;q:type="xbs" "现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史现病史"
	;q:type="jws" "既往史既往史既往史既往史既往史既往史既往史既往史既往史既往史既往史既往史既往史既往史既往史"
	q ""
}

/// 根据CT_Loc的ID 获取护理单元顺序
/// 入参：
/// 	loc:科室id
/// 出参:
/// 	护理单元维护科室顺序
ClassMethod getPerWardSort(loc As %String = "")
{
	q:loc="" "999999"
	s rw = $o(^DHCMGNUR.MgNurPerWardI("WardLoc",loc,""))
	q:rw="" "999999"
	s obj = ##class(DHCMGNUR.MgNurPerWard).%OpenId(rw)
	q obj.WardOrd
}

/// 根据工号获取User.SSUER ID
/// 入参：
/// 	PersonID:工号
/// 出参：
/// 	对应User.SSUER表ID
ClassMethod getUserIDByPersonID(PersonID As %String = "")
{
	q:PersonID="" ""
	q:$o(^SSU("SSUSR",0,"SSUSR_Initials",PersonID,""))
}

/// 根据DHCMGNUR.MgPersons 表ID获取 User.SSUER表ID
/// 入参：
/// 	PersonRW：DHCMGNUR.MgPersons表ID
/// 出参：
/// 	User.SSUER表ID
ClassMethod getUserIDByPersonRW(PersonRW As %String = "")
{
	q:PersonRW="" ""
	s obj = ##class(DHCMGNUR.MgPersons).%OpenId(PersonRW)
	s PersonID = obj.PersonID
	q ..getUserIDByPersonID(PersonID)
}

/// 获取护理部检查记录的检查内容以及检查结果
/// 入参:
/// 	Date:检查日期
/// 	DepId:护理单元
/// 出参：
/// 		ret:检查内容@@检查结果
/// 表：
/// 	DHCMGNUR.MgNurHLBQualityCheck
/// 	DHCMGNUR.MgNurHLBMonthRec
/// 测试:
/// 	w ##class(web.DHCNurHBComm).getCheckRec("2016-04-06",36)
ClassMethod getCheckRec(Date As %String = "", DepId As %String = "")
{
	q:(Date="")||(DepId="") ""
	s Date = $zdh(Date,3)
	s ^xukun("getCheckRec") = Date_"^"_DepId
	s prw = "",Item = "",Result = "",i = 0
	f  s prw = $o(^DHCMGNUR.MgNurHLBQualityCheckI("DepDate",DepId,Date,prw)) q:prw=""  d
	.s obj1 = ##class(DHCMGNUR.MgNurHLBMonthRec).%OpenId(prw)
	.s Flag = obj1.Flag
	.d obj1.%Close()
	.b ;1
	.q:Flag'=1
	.b ;2
	.s raw = ""
	.f  s raw = $o(^DHCMGNUR.MgNurHLBQualityCheckI("DepDate",DepId,Date,prw,raw)) q:raw=""  d
	..s obj = ##class(DHCMGNUR.MgNurHLBQualityCheck).%OpenId(prw_"||"_raw)
	..q:obj.Problems=""
	..s i = i + 1
	..i i'=1 d
	...s Item = Item_";"
	...s Result = Result_";"
	..s Item = Item_i_"."_obj.Item
	..s Result = Result_i_"."_obj.Result
	..d obj.%Close()
	q Item_"@@"_Result
}

/// 控制元素
/// d ##class(web.DHCNurHBComm).addMenuSystemSub()
ClassMethod addMenuSystemSub()
{
	
	w "危重症患者抢救技术培训及演练记录 DHCNURDrillRecCD-->1",!
	s rw = ..getMenuIDByCode("DHCNURDrillRecCD")
	w ..addMenuSysSub(rw,"labelDeprt","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addPerBtn","参与人员添加","button"),!
	w ..addMenuSysSub(rw,"editPerBtn","参与人员修改","button"),!
	w ..addMenuSysSub(rw,"deletePerBtn","参与人员删除","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!

	
	w "精神科突发事件应急预案培训及演练记录DHCNURDrillRecSD-->2",!
	s rw = ..getMenuIDByCode("DHCNURDrillRecSD")
	w ..addMenuSysSub(rw,"labelDeprt","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addPerBtn","参与人员添加","button"),!
	w ..addMenuSysSub(rw,"editPerBtn","参与人员修改","button"),!
	w ..addMenuSysSub(rw,"deletePerBtn","参与人员删除","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "病区安全检查记录DHCNURWardSafetyCheck-->3",!
	s rw = ..getMenuIDByCode("DHCNURWardSafetyCheck")
	w ..addMenuSysSub(rw,"labelDeprt","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"saveBtn","添加、修改窗口保存","button"),!
	w ..addMenuSysSub(rw,"addItemBtn","子项添加","button"),!
	w ..addMenuSysSub(rw,"editItemBtn","子项修改","button"),!
	w ..addMenuSysSub(rw,"deleteItemBtn","子项删除","button"),!
	
	w "公休会DHCNURHolidayMeeting-->4",!
	s rw = ..getMenuIDByCode("DHCNURHolidayMeeting")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	
	
	w "护理工作总结DHCNURWorkSummary-->5",!
	s rw = ..getMenuIDByCode("DHCNURWorkSummary")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	;w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	;w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "月护理工作重点DHCNURWorkFocus-->6",!
	s rw = ..getMenuIDByCode("DHCNURWorkFocus")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	;w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	;w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "晨会提问记录DHCNURAmQuestionsRec-->7",!
	s rw = ..getMenuIDByCode("DHCNURAmQuestionsRec")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addItemBtn","子项添加","button"),!
	w ..addMenuSysSub(rw,"saveItemBtn","子项保存","button"),!
	w ..addMenuSysSub(rw,"deleteItemBtn","子项删除","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "晨会讲评记录DHCNURAmCommentRec-->8",!
	s rw = ..getMenuIDByCode("DHCNURAmCommentRec")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addItemBtn","子项添加","button"),!
	w ..addMenuSysSub(rw,"saveItemBtn","子项保存","button"),!
	w ..addMenuSysSub(rw,"deleteItemBtn","子项删除","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "业务学习记录DHCNURTrainRecB-->9",!
	s rw = ..getMenuIDByCode("DHCNURTrainRecB")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addQBtn","提问添加","button"),!
	w ..addMenuSysSub(rw,"editQBtn","提问修改","button"),!
	w ..addMenuSysSub(rw,"deleteQBtn","提问删除","button"),!
	w ..addMenuSysSub(rw,"submitQBtn","提问发布","button"),!
	w ..addMenuSysSub(rw,"rmQSubmit","提问发布撤销","button"),!
	w ..addMenuSysSub(rw,"addABtn","答案添加","button"),!
	w ..addMenuSysSub(rw,"editABtn","答案修改","button"),!
	w ..addMenuSysSub(rw,"deleteABtn","答案删除","button"),!
	w ..addMenuSysSub(rw,"submitABtn","答案提交","button"),!
	w ..addMenuSysSub(rw,"auditABtn","答案审核","button"),!
	w ..addMenuSysSub(rw,"rmASubmit","答案提交撤销","button"),!
	w ..addMenuSysSub(rw,"rmAAudit","答案审核撤销","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "急救仪器使用及操作技能培训记录DHCNURTrainRecS-->10",!
	s rw = ..getMenuIDByCode("DHCNURTrainRecS")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addQBtn","提问添加","button"),!
	w ..addMenuSysSub(rw,"editQBtn","提问修改","button"),!
	w ..addMenuSysSub(rw,"deleteQBtn","提问删除","button"),!
	w ..addMenuSysSub(rw,"submitQBtn","提问发布","button"),!
	w ..addMenuSysSub(rw,"rmQSubmit","提问发布撤销","button"),!
	w ..addMenuSysSub(rw,"addABtn","答案添加","button"),!
	w ..addMenuSysSub(rw,"editABtn","答案修改","button"),!
	w ..addMenuSysSub(rw,"deleteABtn","答案删除","button"),!
	w ..addMenuSysSub(rw,"submitABtn","答案提交","button"),!
	w ..addMenuSysSub(rw,"auditABtn","答案审核","button"),!
	w ..addMenuSysSub(rw,"rmASubmit","答案提交撤销","button"),!
	w ..addMenuSysSub(rw,"rmAAudit","答案审核撤销","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "法律法规培训及考核记录DHCNURTrainRecLT-->11",!
	s rw = ..getMenuIDByCode("DHCNURTrainRecLT")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addQBtn","提问添加","button"),!
	w ..addMenuSysSub(rw,"editQBtn","提问修改","button"),!
	w ..addMenuSysSub(rw,"deleteQBtn","提问删除","button"),!
	w ..addMenuSysSub(rw,"submitQBtn","提问发布","button"),!
	w ..addMenuSysSub(rw,"rmQSubmit","提问发布撤销","button"),!
	w ..addMenuSysSub(rw,"addABtn","答案添加","button"),!
	w ..addMenuSysSub(rw,"editABtn","答案修改","button"),!
	w ..addMenuSysSub(rw,"deleteABtn","答案删除","button"),!
	w ..addMenuSysSub(rw,"submitABtn","答案提交","button"),!
	w ..addMenuSysSub(rw,"auditABtn","答案审核","button"),!
	w ..addMenuSysSub(rw,"rmASubmit","答案提交撤销","button"),!
	w ..addMenuSysSub(rw,"rmAAudit","答案审核撤销","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "病区健康教育DHCNUREhsEduRec-->12",!
	s rw = ..getMenuIDByCode("DHCNUREhsEduRec")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addPerBtn","人员添加","button"),!
	w ..addMenuSysSub(rw,"deletePerBtn","人员删除","button"),!
	w ..addMenuSysSub(rw,"savePerBtn","人员保存","button"),!
	w ..addMenuSysSub(rw,"addQueBtn","问题添加","button"),!
	w ..addMenuSysSub(rw,"editQueBtn","问题编辑","button"),!
	w ..addMenuSysSub(rw,"deleteQueBtn","问题删除","button"),!
	
	w "护理工作质量持续改进记录DHCNURQualityIMP-->13",!
	s rw = ..getMenuIDByCode("DHCNURQualityIMP")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	
	w "病区护理质量检查记录DHCNURQualityCheck-->14",!
	s rw = ..getMenuIDByCode("DHCNURQualityCheck")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"addItemBtn","子项添加","button"),!
	w ..addMenuSysSub(rw,"editItemBtn","子项修改","button"),!
	w ..addMenuSysSub(rw,"deleteItemBtn","子项删除","button"),!
	
	w "护理工作计划DHCNURWorkPlan-->15",!
	s rw = ..getMenuIDByCode("DHCNURWorkPlan")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	;w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	;w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	
	w "康复训练计划及实施效果评价DHCNURRecoveryTrain-->16",!
	s rw = ..getMenuIDByCode("DHCNURRecoveryTrain")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	
	w "护理部质量检查记录DHCNURHLBQualityCheck-->17",!
	s rw = ..getMenuIDByCode("DHCNURHLBQualityCheck")
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"releaseBtn","发布","button"),!
	w ..addMenuSysSub(rw,"rmRelease","撤销发布","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"addItemBtn","子项添加","button"),!
	w ..addMenuSysSub(rw,"editItemBtn","子项修改","button"),!
	w ..addMenuSysSub(rw,"deleteItemBtn","子项删除","button"),!
	
	w "护理部质量检查记录反馈表DHCNURHLBQualityCheckBack-->18",!
	s rw = ..getMenuIDByCode("DHCNURHLBQualityCheckBack")
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"releaseBtn","发布","button"),!
	w ..addMenuSysSub(rw,"rmRelease","撤销发布","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"addItemBtn","子项添加","button"),!
	w ..addMenuSysSub(rw,"editItemBtn","子项修改","button"),!
	w ..addMenuSysSub(rw,"deleteItemBtn","子项删除","button"),!
	
	w "考核项目DHCNURExamineItem-->19",!
	s rw = ..getMenuIDByCode("DHCNURExamineItem")
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"addItemBtn","子项添加","button"),!
	w ..addMenuSysSub(rw,"editItemBtn","子项修改","button"),!
	w ..addMenuSysSub(rw,"importBtn","导入","button"),!
	
	w "考核记录DHCNURExamineRec-->20",!
	s rw = ..getMenuIDByCode("DHCNURExamineRec")
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"releaseBtn","发布","button"),!
	w ..addMenuSysSub(rw,"rmRelease","撤销发布","button"),!
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"labelPer","考核人","label"),!
	w ..addMenuSysSub(rw,"comboPer","考核人","combobox"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "护理查房记录DHCNURRoundsRec-->21",!
	s rw = ..getMenuIDByCode("DHCNURRoundsRec")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	
	
		
	w "带教人员DHCNURTeachPersons-->22",!
	s rw = ..getMenuIDByCode("DHCNURTeachPersons")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"labelLevel","护士层级","label"),!
	w ..addMenuSysSub(rw,"comboLevel","护士层级","combobox"),!
	w ..addMenuSysSub(rw,"labelPersons","护理人员","label"),!
	w ..addMenuSysSub(rw,"comboPersons","护理人员","combobox"),!
	w ..addMenuSysSub(rw,"labelSDate","开始工作日期","label"),!
	w ..addMenuSysSub(rw,"SWorkDate","开始日期","DateField"),!
	w ..addMenuSysSub(rw,"EWorkDate","结束日期","DateField"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	w "实习小组DHCNURPSTeam-->23",!
	s rw = ..getMenuIDByCode("DHCNURPSTeam")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"labelTeachPer","带教人员","label"),!
	w ..addMenuSysSub(rw,"comboTeachPer","带教人员","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
	w ..addMenuSysSub(rw,"deletePersonBtn","小组成员删除","button"),!
	
	w "带教记录查询DHCNURTeachInfo-->24",!
	s rw = ..getMenuIDByCode("DHCNURTeachInfo")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"labelTeachPer","带教人员","label"),!
	w ..addMenuSysSub(rw,"comboTeachPer","带教人员","combobox"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"exportBtn","导出","button"),!
	
	
	w "授课记录DHCNURTeachContent-->25",!
	s rw = ..getMenuIDByCode("DHCNURTeachContent")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"labelTeachPer","带教人员","label"),!
	w ..addMenuSysSub(rw,"comboTeachPer","带教人员","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","填写","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	
	w "双向评价DHCNURTwoWayEval-->26",!
	s rw = ..getMenuIDByCode("DHCNURTwoWayEval")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"labelTeachPer","带教人员","label"),!
	w ..addMenuSysSub(rw,"comboTeachPer","带教人员","combobox"),!
	w ..addMenuSysSub(rw,"addStuBtn","老师对学生评价","button"),!
	w ..addMenuSysSub(rw,"addTeaBtn","学生对老师评价","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"printBtn","打印","button"),!
	
	w "业务考核项DHCNURWorkAssessItem-->27",!
	s rw = ..getMenuIDByCode("DHCNURWorkAssessItem")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"exportFn","导出","button"),!
	
	w "业务考核记录DHCNURWorkAssessment-->28",!
	s rw = ..getMenuIDByCode("DHCNURWorkAssessment")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"viewsBtn","考核意见","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"exportFn","导出","button"),!
	
	w "业务学习记录DHCNURLearning-->29",!
	s rw = ..getMenuIDByCode("DHCNURLearning")
	w ..addMenuSysSub(rw,"labelDepart","护理单元","label"),!
	w ..addMenuSysSub(rw,"comboDepart","护理单元","combobox"),!
	w ..addMenuSysSub(rw,"addBtn","添加","button"),!
	w ..addMenuSysSub(rw,"editBtn","修改","button"),!
	w ..addMenuSysSub(rw,"deleteBtn","删除","button"),!
	w ..addMenuSysSub(rw,"clearBtn","清空","button"),!
	w ..addMenuSysSub(rw,"searchBtn","查询","button"),!
	w ..addMenuSysSub(rw,"exportFn","导出","button"),!
	w ..addMenuSysSub(rw,"submitBtn","提交","button"),!
	w ..addMenuSysSub(rw,"rmSubmit","撤销提交","button"),!
}

/// w ##class(web.DHCNurHBComm).getMenuIDByCode("DHCNURTrainRecB")
ClassMethod getMenuIDByCode(Code)
{
	s Code = $zcvt(" "_Code,"U")
	q $o(^DHCMGNUR.MenuSystemI("MenuCode",Code,""))
}

ClassMethod addMenuSysSub(prw, Code, Desc, Type)
{
	q:prw="" -1
	s:Type="" Type="button"
	
	s rw = "",count = 0
	f  s rw = $o(^DHCMGNUR.MenuSystemSubD(prw,rw)) q:rw=""  d
	.s obj1 = ##class(DHCMGNUR.MenuSystemSub).%OpenId(prw_"||"_rw)
	.s:obj1.ItemCode=Code count = count + 1
	q:count>0 2
	s obj = ##class(DHCMGNUR.MenuSystemSub).%New()
	d obj.MenuParrefSetObjectId(prw)
	s obj.ItemCode = Code
	s obj.ItemDesc = Desc
	s obj.ItemTyp = Type
	s s = obj.%Save()
	q:$$$ISERR(s) 0
	q 1
}

/// 获取模板目录
/// w ##class(web.DHCNurHBComm).getImportPath()
ClassMethod getImportPath()
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

/// 许坤  2016-04-06
/// d ##class(%ResultSet).RunQuery("web.DHCNurHBComm","FindQualityIMPSub1","1^59^demo^^^2016^^QI")
Query FindQualityIMPSub1(parr As %String) As %Library.Query(ROWSPEC = "aa")
{
}

ClassMethod FindQualityIMPSub1Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindQualityIMPSub1Fetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTeWP(repid)
 	Quit $$$OK
}

ClassMethod FindQualityIMPSub1Execute(ByRef QHandle As %Library.Binary, parr As %String) As %Library.Status
{
	Set repid=$I(^CacheTeWP)
	Set ind=1	
	Set QHandle=$lb(0,repid,0)
	s inUserId = $p(parr,"^",1)
	s inLoc = $p(parr,"^",2)
	s inSecGrp = $p(parr,"^",3)
	s inSLoc = $p(parr,"^",4)
	s inFlag = $p(parr,"^",5)
	s inYear = $p(parr,"^",6)
	s inDesc = $p(parr,"^",7)
	s ^xukun("FindQualityIMPSub1") = parr
	s:(inSecGrp="nurse")||(inSecGrp="nurhead") inSLoc = inLoc
	i inSLoc="" d	
	.s prw = ""
	.f  s prw = $o(^DHCMGNUR.MgNurMonthRecI("Type"," QI"," M",prw)) q:prw=""  d QualityIMPSub1Row
	e  d
	.s prw = ""
	.b
	.f  s prw = $o(^DHCMGNUR.MgNurMonthRecI("Dep"," QI"," M",inSLoc,prw)) q:prw=""  d QualityIMPSub1Row
	
	Set ind=ind+1
	Set QHandle = $lb(0,repid,0)
	Quit $$$OK
QualityIMPSub1Row
	s obj = ##class(DHCMGNUR.MgNurMonthRec).%OpenId(prw)
	s Flag = obj.Flag
	s Year = obj.Year
	s Month = obj.Month
	s AddPer = obj.AddPerDr.%Id()
	d obj.%Close()
	b
	q:obj.DelFlag="N"
	q:(inFlag'="")&&(inFlag'=Flag)
	q:(Flag=0)&&(AddPer'=inUserId)
	q:(inYear'="")&&(inYear'=Year)
	q:(inDesc'="")&&(inDesc'=Month)
	s raw = $o(^DHCMGNUR.MgNurQualityIMPSubD(prw,""))
	s ret = ##class(DHCMGNUR.MgNurQualityIMPSub).getValue(prw_"||"_raw)
	set Data=$lb(ret)
 	Set ^CacheTeWP(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindQualityIMPSub1Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindQualityIMPSub1Execute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTeWP(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else	  {				// fetch row
 		Set Row=^CacheTeWP(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取病区护理质量检查记录结果
ClassMethod getQualityRec(DepId As %String = "", Year As %String = "", Month As %String = "")
{
	q:(DepId="")||(Year="")||(Month="") ""
	s ^xukun("getQualityRec") = DepId_"^"_Year_"^"_Month
	s ret = "", prw = ""
	f  s prw = $o(^DHCMGNUR.MgNurMonthRecI("DYM"," QC"," M",DepId,Year,Month,prw)) q:prw=""  d
	.s obj = ##class(DHCMGNUR.MgNurMonthRec).%OpenId(prw)
	.s Flag = obj.Flag
	.d obj.%Close()
	.q:Flag'=1
	.s raw = ""
	.f  s raw = $o(^DHCMGNUR.MgNurQualityCheckSubD(prw,raw)) q:raw=""  d
	..s obj1 = ##class(DHCMGNUR.MgNurQualityCheckSub).%OpenId(prw_"||"_raw)
	..s:ret'="" ret=ret_";"
	..s ret =  ret_obj1.Inspection.CodeDesc_"("_obj1.Total_","_obj1.PassRate_"%)"
	..d obj1.%Close()
	q ret
}

}
