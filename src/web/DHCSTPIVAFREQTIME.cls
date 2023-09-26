Import SQLUser

Class web.DHCSTPIVAFREQTIME Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetfreqtimeExecute(ByRef qHandle As %Binary, plocrowid As %String) As %Status
{
	//获取频率时间设置
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	;q:plocrowid="" $$$OK 
	s rowid=0
    f  s rowid=$o(^PIVABF(rowid)) q:rowid=""  d
    .s freqdr=$p(^PIVABF(rowid),"^",1)
    .s freq=$p(^PHCFR(freqdr),"^",3)
    .s batno=$p(^PIVABF(rowid),"^",2)
    .s stiem=$p(^PIVABF(rowid),"^",3)
    .s stiem=$zt(stiem,2)
    .s locdr=$p(^PIVABF(rowid),"^",4)
    .q:(locdr'=plocrowid)&(plocrowid'="")
    .s loc=$p(^CTLOC(locdr),"^",2)
    .s grpno=$p(^PIVABF(rowid),"^",5)
	.d OutPutRow
	Quit $$$OK
	
OutPutRow
	set Data=$lb(freq,batno,stiem,loc,grpno,rowid,locdr,freqdr)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod GetfreqtimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetfreqtimeExecute ]
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

Query Getfreqtime(plocrowid As %String) As %Query(ROWSPEC = "Tfreq:%String,Tbatno:%String,Tstiem:%String,Tloc:%String,Tgrpno:%String,Trowid:%String,Tlocid:%String,Tfreqid:%String")
{
}

ClassMethod GetfreqtimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetfreqtimeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Update(Ploc, Freq, Batno, Grpno, Stime, flag, rowid) As %String
{
 n (Ploc,Freq,Batno,Grpno,Stime,flag,rowid)
 q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Ploc)))&(flag="2") -1
 i flag="2" s Ploc=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Ploc),""))
 q:'$d(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(Freq))) -1
 s Freq=$o(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(Freq),"")) 
 k PLIST
 s Stime=$zth(Stime,1)
 s PLIST(1)=""
 s PLIST(2)=Freq
 s PLIST(3)=Batno
 s PLIST(4)=Stime
 s PLIST(5)=Ploc
 s PLIST(6)=Grpno
 i flag=1 &sql(insert into  PIVA_BatFreq values PLIST())
 i flag=2 &sql(update  PIVA_BatFreq set PBF_PHCFR_Dr=:Freq,PBF_BatNo=:Batno,PBF_Time=:Stime,PBF_Ctloc_dr=:Ploc,PBF_GrpNo=:Grpno where PBF_RowId=:rowid)
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
 q
}

ClassMethod Delete(rowid) As %String
{
 n (rowid)
 &sql(delete  from   PIVA_BatFreq where PBF_RowId=:rowid)
 q:SQLCODE'=0 -1
 q $p(%ROWID,$c(1))
 q
}

ClassMethod GetfreqlistExecute(ByRef qHandle As %Binary) As %Status
{
	//获取频率列表
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现； 
	s rowid=0
    f  s rowid=$o(^PHCFR(rowid) ) q:rowid=""  d
    .s code=$p(^PHCFR(rowid),"^",1)
    .s desc=$p(^PHCFR(rowid),"^",3)
	.d OutPutRow1
	Quit $$$OK
	
OutPutRow1
	set Data=$lb(code,desc,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod GetfreqlistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetfreqlistExecute ]
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

Query Getfreqlist() As %Query(ROWSPEC = "Tcode:%String,Tdesc:%String,Trowid:%String")
{
}

ClassMethod GetfreqlistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetfreqlistExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
