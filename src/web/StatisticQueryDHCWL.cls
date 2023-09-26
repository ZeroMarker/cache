Import SQLUser

Class web.StatisticQueryDHCWL Extends %RegisteredObject [ Not ProcedureBlock ]
{

//床位维护病区信息获取

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","GetCwWhwardXX","","")	

ClassMethod GetCwWhwardXXExecute(ByRef qHandle As %Binary, Date As %String, ward As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    
    i Date'="" s Date=$zdh(Date,3)
    s sysdate=$p($h,",",1)
    s sysdate=$zd(sysdate,3)
    
    i (ward'="")&&('$d(^DHCMRBed(0,"Ward",ward))) d
	.s WardDesc=$P($G(^PAWARD(ward)),"^",2)  
    .i WardDesc [ "-" s desc=$p(WardDesc,"-",2)
    .q:desc["停用"
    .e  s desc=WardDesc
    .s MRDate="",MRward=ward,MRGDNum=0,MRSYNum=0,MRBZNum=0,sysdate="",MRRowId=""
    .d OutputRow1

    s MRRowId=0  f  s MRRowId=$o(^DHCMRBed(MRRowId)) q:MRRowId=""   d 
	.s MRDate=$P(^DHCMRBed(MRRowId),"^",1)
	.i Date'="" q:MRDate'=Date
	.s MRward=$P(^DHCMRBed(MRRowId),"^",6) q:MRward=""
	.i ward'="" q:MRward'=ward
	.s WardDesc=$P($G(^PAWARD(MRward)),"^",2)  
    .i WardDesc [ "-" s desc=$p(WardDesc,"-",2)
    .q:desc["停用"
    .e  s desc=WardDesc
	.s MRGDNum=$P(^DHCMRBed(MRRowId),"^",3)  
	.s MRSYNum=$P(^DHCMRBed(MRRowId),"^",4)
	.s MRBZNum=$P(^DHCMRBed(MRRowId),"^",5)
    .d OutputRow1
    k ^temp($j)
 	q $$$OK	

OutputRow1
    i MRDate'="" s Mdate=$zd(MRDate,3)
    e  s Mdate=""
    s Data=$lb(Mdate,MRward,desc,MRGDNum,MRSYNum,MRBZNum,sysdate,MRRowId)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCwWhwardXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCwWhwardXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCwWhwardXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCwWhwardXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCwWhwardXX(Date As %String, ward As %String) As %Query(ROWSPEC = "Mdate:%String,MRward:%String,desc:%String,MRGDNum:%String,MRSYNum:%String,MRBZNum:%String,sysdate:%String,MRRowId:%Integer") [ SqlProc ]
{
}

//床位维护病区总数

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","GetCwWhwardZs","","")	

ClassMethod GetCwWhwardZsExecute(ByRef qHandle As %Binary, Date As %String, ward As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    
    i Date'="" s Date=$zdh(Date,3)
    s sysdate=$p($h,",",1)
    s sysdate=$zd(sysdate,3)
    
    s MRRowId=0  f  s MRRowId=$o(^DHCMRBed(MRRowId)) q:MRRowId=""   d 
	.s MRDate=$P(^DHCMRBed(MRRowId),"^",1)
	.i Date'="" q:MRDate'=Date
	.s MRward=$P(^DHCMRBed(MRRowId),"^",6) q:MRward=""
	.i ward'="" q:MRward'=ward
	.s WardDesc=$P($G(^PAWARD(MRward)),"^",2)  
    .i WardDesc [ "-" s desc=$p(WardDesc,"-",2)
    .q:desc["停用"
    .e  s desc=WardDesc
	.s MRGDNum=$P(^DHCMRBed(MRRowId),"^",3)  
	.s MRSYNum=$P(^DHCMRBed(MRRowId),"^",4)
	.s MRBZNum=$P(^DHCMRBed(MRRowId),"^",5)
	.s ^temp($j,MRward,MRDate,"MRGDNum")=MRGDNum
	.s ^temp($j,MRward,MRDate,"MRSYNum")=MRSYNum
	.s ^temp($j,MRward,MRDate,"MRBZNum")=MRBZNum
	
	s MRGDNumZs=0,MRSYNumZs=0,MRBZNumZs=0
	s MRward=""  f  s MRward=$o(^temp($j,MRward)) q:MRward=""  d
	.s MaxDate=$o(^temp($j,MRward,""),-1)
	.s MRGDNumZs=$g(MRGDNumZs)+$g(^temp($j,MRward,MaxDate,"MRGDNum"))
	.s MRSYNumZs=$g(MRSYNumZs)+$g(^temp($j,MRward,MaxDate,"MRSYNum"))
	.s MRBZNumZs=$g(MRBZNumZs)+$g(^temp($j,MRward,MaxDate,"MRBZNum"))
    d OutputRow2
    k ^temp($j)
 	q $$$OK	

OutputRow2
    s Data=$lb(MRGDNumZs,MRSYNumZs,MRBZNumZs)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCwWhwardZsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCwWhwardZsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCwWhwardZsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCwWhwardZsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCwWhwardZs(Date As %String, ward As %String) As %Query(ROWSPEC = "MRGDNumZs:%Integer,MRSYNumZs:%Integer,MRBZNumZs:%Integer") [ SqlProc ]
{
}

//床位维护科室信息获取

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","GetCwWhDepXX","","")	

ClassMethod GetCwWhDepXXExecute(ByRef qHandle As %Binary, Date As %String, dept As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    
    i Date'="" s Date=$zdh(Date,3)
    s sysdate=$p($h,",",1)
    s sysdate=$zd(sysdate,3)
    i (dept'="")&&('$d(^DHCMRBed(0,"Loc",dept))) d
	.s depDesc=$P($G(^CTLOC(dept)),"^",2)  
    .i depDesc [ "-" s desc=$p(depDesc,"-",2)
    .q:desc["停用"
    .e  s desc=depDesc
    .s MRDate="",MRLoc=dept,MRGDNum=0,MRSYNum=0,MRBZNum=0,sysdate=""
    .d OutputRow3
    s MRRowId=0  f  s MRRowId=$o(^DHCMRBed(MRRowId)) q:MRRowId=""   d 
	.s MRDate=$P(^DHCMRBed(MRRowId),"^",1)
	.i Date'="" q:MRDate'=Date
	.s MRLoc=$P(^DHCMRBed(MRRowId),"^",2) q:MRLoc=""
	.i dept'="" q:MRLoc'=dept
	.s depDesc=$P($G(^CTLOC(MRLoc)),"^",2)  
    .i depDesc [ "-" s desc=$p(depDesc,"-",2)
    .q:desc["停用"
    .e  s desc=depDesc
	.s MRGDNum=$P(^DHCMRBed(MRRowId),"^",3)  
	.s MRSYNum=$P(^DHCMRBed(MRRowId),"^",4)
	.s MRBZNum=$P(^DHCMRBed(MRRowId),"^",5)  
    .d OutputRow3
    k ^temp($j)
 	q $$$OK	

OutputRow3
    i MRDate'="" s Mdate=$zd(MRDate,3)
    e  s Mdate=""
    s Data=$lb(Mdate,MRLoc,desc,MRGDNum,MRSYNum,MRBZNum,sysdate)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCwWhDepXXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCwWhDepXXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCwWhDepXXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCwWhDepXXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCwWhDepXX(Date As %String, dept As %String) As %Query(ROWSPEC = "Mdate:%String,MRLoc:%String,desc:%String,MRGDNum:%String,MRSYNum:%String,MRBZNum:%String,sysdate:%String") [ SqlProc ]
{
}

//床位维护科室总数

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","GetCwWhDepZs","","")	

ClassMethod GetCwWhDepZsExecute(ByRef qHandle As %Binary, Date As %String, dept As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^temp($j)
    
    i Date'="" s Date=$zdh(Date,3)
    s sysdate=$p($h,",",1)
    s sysdate=$zd(sysdate,3)
    
    s MRRowId=0  f  s MRRowId=$o(^DHCMRBed(MRRowId)) q:MRRowId=""   d 
	.s MRDate=$P(^DHCMRBed(MRRowId),"^",1)
	.i Date'="" q:MRDate'=Date
	.s MRLoc=$P(^DHCMRBed(MRRowId),"^",2) q:MRLoc=""
	.i dept'="" q:MRLoc'=dept
	.s depDesc=$P($G(^CTLOC(MRLoc)),"^",2)  
    .i depDesc [ "-" s desc=$p(depDesc,"-",2)
    .q:desc["停用"
    .e  s desc=depDesc
	.s MRGDNum=$P(^DHCMRBed(MRRowId),"^",3)  
	.s MRSYNum=$P(^DHCMRBed(MRRowId),"^",4)
	.s MRBZNum=$P(^DHCMRBed(MRRowId),"^",5) 
	.s ^temp($j,MRLoc,MRDate,"MRGDNum")=MRGDNum
	.s ^temp($j,MRLoc,MRDate,"MRSYNum")=MRSYNum
	.s ^temp($j,MRLoc,MRDate,"MRBZNum")=MRBZNum
	
	s MRGDNumZs=0,MRSYNumZs=0,MRBZNumZs=0
	s MRLoc=""  f  s MRLoc=$o(^temp($j,MRLoc)) q:MRLoc=""  d
	.s MaxDate=$o(^temp($j,MRLoc,""),-1)
	.s MRGDNumZs=$g(MRGDNumZs)+$g(^temp($j,MRLoc,MaxDate,"MRGDNum"))
	.s MRSYNumZs=$g(MRSYNumZs)+$g(^temp($j,MRLoc,MaxDate,"MRSYNum"))
	.s MRBZNumZs=$g(MRBZNumZs)+$g(^temp($j,MRLoc,MaxDate,"MRBZNum"))
    d OutputRow4
    k ^temp($j)
 	q $$$OK	

OutputRow4
    s Data=$lb(MRGDNumZs,MRSYNumZs,MRBZNumZs)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCwWhDepZsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCwWhDepZsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetCwWhDepZsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCwWhDepZsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCwWhDepZs(Date As %String, dept As %String) As %Query(ROWSPEC = "MRGDNumZs:%Integer,MRSYNumZs:%Integer,MRBZNumZs:%Integer") [ SqlProc ]
{
}

//科室对照

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","StatisticsCtlocTrans","","","")	

ClassMethod StatisticsCtlocTransExecute(ByRef qHandle As %Binary, hosdept As %String, sbdept As %String, ks As %String, depttype As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
        
    s CtlocId=0  f  s CtlocId=$o(^CTLOC(CtlocId)) q:CtlocId=""   d 
	.i hosdept'="" q:CtlocId'=hosdept
	.s CtlocCode=$P(^CTLOC(CtlocId),"^",1)
	.s CtlocDesc=$P(^CTLOC(CtlocId),"^",2)
	.q:CtlocDesc["停用"
	.q:CtlocDesc["诊室"
	.q:CtlocDesc["党支部"
	.q:CtlocDesc["办公室"
	.s CtlocTransId=0  f  s CtlocTransId=$o(^DHCWL.Statistics.CtlocTransI("CtlocTransRowID",CtlocId,CtlocTransId)) q:CtlocTransId=""  d
	..q:'$d(^DHCWL.Statistics.CtlocTransD(CtlocTransId))
	..s CtlocTransSbCode=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),5)
	..s CtlocTransSbDesc=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),6)
	..s CtlocTransTjCode=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),7)
	..s CtlocTransTjDesc=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),8)
	..i (ks="Sb")&(sbdept'="") q:CtlocTransSbDesc'=sbdept
	..i (ks'="Sb")&(sbdept'="") q:CtlocTransTjDesc'=sbdept
	..s CtlocTransType=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),9)
	..i depttype'="" q:CtlocTransType'=depttype
	..i CtlocTransType="I" s TypeDesc="住院科室"
	..i CtlocTransType="O" s TypeDesc="门诊科室"
	..i CtlocTransType="W" s TypeDesc="病房"
	..i CtlocTransType="O,I" s TypeDesc="门诊和住院科室"
	..i CtlocTransType="" s TypeDesc=""
    ..d OutputRow5
 	q $$$OK	

OutputRow5
    s Data=$lb(CtlocId,CtlocCode,CtlocDesc,CtlocTransId,CtlocTransSbCode,CtlocTransSbDesc,CtlocTransTjCode,CtlocTransTjDesc,CtlocTransType,TypeDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod StatisticsCtlocTransFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatisticsCtlocTransExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StatisticsCtlocTransClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatisticsCtlocTransExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query StatisticsCtlocTrans(hosdept As %String, sbdept As %String, ks As %String, depttype As %String) As %Query(ROWSPEC = "CtlocId:%String,CtlocCode:%String,CtlocDesc:%String,CtlocTransId:%String,CtlocTransSbCode:%String,CtlocTransSbDesc:%String,CtlocTransTjCode:%String,CtlocTransTjDesc:%String,CtlocTransType:%String,TypeDesc:%String") [ SqlProc ]
{
}

//科室对照链接

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","StatisticsCtlocTransLj","")	

ClassMethod StatisticsCtlocTransLjExecute(ByRef qHandle As %Binary, ctlocid As %String, sbdept As %String, ks As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
        
   	s CtlocTransId=0  f  s CtlocTransId=$o(^DHCWL.Statistics.CtlocTransI("CtlocTransRowID",ctlocid,CtlocTransId)) q:CtlocTransId=""  d
	.q:'$d(^DHCWL.Statistics.CtlocTransD(CtlocTransId))
	.s CtlocId=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),2)
	.s CtlocCode=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),3)
	.s CtlocDesc=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),4)
	.s CtlocTransSbCode=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),5)
	.s CtlocTransSbDesc=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),6)
	.s CtlocTransTjCode=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),7)
	.s CtlocTransTjDesc=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),8)
	.i (sbdept'="")&(ks="Sb") q:CtlocTransSbDesc'=sbdept
	.i (sbdept'="")&(ks'="Sb") q:CtlocTransTjDesc'=sbdept
	.s CtlocTransType=$LIST(^DHCWL.Statistics.CtlocTransD(CtlocTransId),9)
	.i CtlocTransType="I" s TypeDesc="住院科室"
	.i CtlocTransType="O" s TypeDesc="门诊科室"
	.i CtlocTransType="W" s TypeDesc="病房"
	.i CtlocTransType="O,I" s TypeDesc="门诊和住院科室"
	.i CtlocTransType="" s TypeDesc=""
    .d OutputRow6
 	q $$$OK	

OutputRow6
    s Data=$lb(CtlocId,CtlocCode,CtlocDesc,CtlocTransId,CtlocTransSbCode,CtlocTransSbDesc,CtlocTransTjCode,CtlocTransTjDesc,CtlocTransType,TypeDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod StatisticsCtlocTransLjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatisticsCtlocTransLjExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StatisticsCtlocTransLjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatisticsCtlocTransLjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query StatisticsCtlocTransLj(ctlocid As %String, sbdept As %String, ks As %String) As %Query(ROWSPEC = "CtlocId:%String,CtlocCode:%String,CtlocDesc:%String,CtlocTransId:%String,CtlocTransSbCode:%String,CtlocTransSbDesc:%String,CtlocTransTjCode:%String,CtlocTransTjDesc:%String,CtlocTransType:%String,TypeDesc:%String") [ SqlProc ]
{
}

//获取各月工作日

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","GetGzr","O","")	

ClassMethod GetGzrExecute(ByRef qHandle As %Binary, type As %String, year As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
   	f month=1:1:12  d
   	.s month1=month+1,year1=year
   	.i month=12 s year1=year+1,month1=1
    .s startdate=year_"-"_month_"-01",enddate=year1_"-"_month1_"-01"
    .s sdate=$zdh(startdate,3),edate=$zdh(enddate,3)
    .s gzr=edate-sdate
   	.s date=0  f  s date=$o(^DHCWLSundayCFG(date)) q:date=""  d
   	..q:(date<sdate)||(date>edate) 
   	..i type="O" s gzr=gzr-1 
   	..i type="E" s gzr=gzr
    .d OutputRow7
 	q $$$OK	

OutputRow7
    s Data=$lb(month,gzr)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetGzrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGzrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGzrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGzrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetGzr(type As %String, year As %String) As %Query(ROWSPEC = "month:%Float,gzr:%Float") [ SqlProc ]
{
}

//历年床位

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","GetLnCw","O","")	

ClassMethod GetLnCwExecute(ByRef qHandle As %Binary, Syear As %String, Eyear As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    k ^temp($j),^temp1($j)
    s MRRowId=0  f  s MRRowId=$o(^DHCMRBed(MRRowId)) q:MRRowId=""   d 
	.s MRDate=$P(^DHCMRBed(MRRowId),"^",1)
	.s MRward=$P(^DHCMRBed(MRRowId),"^",6) q:MRward=""
	.s WardDesc=$P($G(^PAWARD(MRward)),"^",2)  
    .i WardDesc [ "-" s desc=$p(WardDesc,"-",2)
    .e  s desc=WardDesc
	.s MRSYNum=$P(^DHCMRBed(MRRowId),"^",4)
	.s ^temp($j,MRward,MRDate,"MRSYNum")=MRSYNum
	
	s MRSYNumZs=0
	s MRward=""  f  s MRward=$o(^temp($j,MRward)) q:MRward=""  d
   	.f year=Syear:1:Eyear q:year<2012  d
   	..s date=year_"-12-31"
   	..s date=$zdh(date,3)
	..s WhDate=$o(^temp($j,MRward,date),-1) q:WhDate>date
	..s ^temp1($j,year)=$g(^temp1($j,year))+$g(^temp($j,MRward,WhDate,"MRSYNum"))
	
	s year=0 f  s year=$o(^temp1($j,year)) q:year=""  d
	.s Cws=$g(^temp1($j,year))
    .d OutputRow8
    k ^temp($j),^temp1($j)
 	q $$$OK	

OutputRow8
    s Data=$lb(year,Cws)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetLnCwFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLnCwExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLnCwClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLnCwExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetLnCw(Syear As %String, Eyear As %String) As %Query(ROWSPEC = "year:%Float,Cws:%Float") [ SqlProc ]
{
}

//获取节假日数

//d ##class(%ResultSet).RunQuery("web.StatisticQueryDHCWL","GetJJRqty","","")	

ClassMethod GetJJRqtyExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    k ^TEMPDHCWL($j)
    
    s SDate=$zdh(SDate,3)
    s EDate=$zdh(EDate,3)
    s ZTS=EDate-SDate+1
    s JJRZs=0,JJRZs1=0,JJRZs2=0,GZRZs=0,GZRZs1=0,GZRZs2=0
    
    f Date=SDate:1:EDate d
    .s Rowid=0
	.f  s Rowid=$o(^User.DHCHolidayI("DHCHolidayCode",Date,Rowid)) q:Rowid=""  d
	..s Half1=$LIST(^User.DHCHolidayD(Rowid),3)
	..s Half2=$LIST(^User.DHCHolidayD(Rowid),4)
	..s JJRZs=JJRZs+1,GZRZs=ZTS-JJRZs
	..s JJRZs1=JJRZs1+1,GZRZs1=ZTS-JJRZs1
	..s JJRZs2=JJRZs2+1,GZRZs2=ZTS-JJRZs2
	..i Half1=1 s JJRZs1=JJRZs1-0.5,GZRZs1=GZRZs1+0.5
	..i Half2=1 s JJRZs2=JJRZs2-0.5,GZRZs2=GZRZs2+0.5
	
	f Date=SDate:1:EDate d
    .s Rowid=0
	.f  s Rowid=$o(^User.DHCHolidayI("DHCHolidayCode",Date,Rowid)) q:Rowid=""  d
	..s JJDate=$zd(Date,3)
	..s Half1=$LIST(^User.DHCHolidayD(Rowid),3)
	..s Half2=$LIST(^User.DHCHolidayD(Rowid),4)
	..s User=$LIST(^User.DHCHolidayD(Rowid),5)
	..s Remark=$LIST(^User.DHCHolidayD(Rowid),6)
    ..s JJRTS=JJRZs,GZRTS=GZRZs,JJRTS1=JJRZs1,GZRTS1=GZRZs1,JJRTS2=JJRZs2,GZRTS2=GZRZs2
    ..w 1
    ..d OutputRow9
    k ^TEMPDHCWL($j)
 	q $$$OK	

OutputRow9
    s Data=$lb(Rowid,JJDate,Half1,Half2,User,Remark,JJRTS,GZRTS,JJRTS1,GZRTS1,JJRTS2,GZRTS2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetJJRqtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJJRqtyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetJJRqtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJJRqtyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetJJRqty(SDate As %String, EDate As %String) As %Query(ROWSPEC = "Rowid:%String,JJDate:%String,Half1:%String,Half2:%String,User:%String,Remark:%String,JJRTS:%String,GZRTS:%String,JJRTS1:%String,GZRTS1:%String,JJRTS2:%String,GZRTS2:%String") [ SqlProc ]
{
}

}
