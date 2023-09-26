/// Creator：		陈乙
/// CreatDate：		2015-06-30
/// Description：	出入转数据核对
Class web.DHCWLDataReconciliationForCRZ Extends %RegisteredObject
{

/// Creator：		陈乙
/// CreatDate：		2015-06-30
/// Description：	出入转数据核对程序主表
/// Table：			DHCMRIPDay,DHC_MRIPDetail
/// Input：			startDate，endDate
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLDataReconciliationForCRZ","QueryMainReport","2020-5-1","2020-10-1","loc")
Query QueryMainReport(startDate As %String, endDate As %String, locOrWard As %String, hosId As %String) As %Query(ROWSPEC = "date:%String,locward:%String,depWardDesc:%String,zyrs:%Float,bedrs:%Float,ddrs:%Float,zrs:%Float,frs:%Float") [ SqlProc ]
{
}

ClassMethod QueryMainReportExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, locOrWard As %String, hosId As %String = "") As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1

 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK		
	i ($g(locOrWard)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s startDate=$zdh(startDate,3)						
	s endDate=$zdh(endDate,3)
	f mdate=startDate:1:endDate d
	.k ^TEMPDHCWL($j)		;每个日期都清一次						
	.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",mdate,mrId)) q:mrId=""  d
	..s loc=$p(^MRIPdaily(mrId),"^",7)				;科室
	..s ward=$p(^MRIPdaily(mrId),"^",19)			;病区
	..q:($g(loc)="")&&(locOrWard="loc")
	..q:($g(ward)="")&&(locOrWard="ward")
	..i locOrWard="loc" d
	...s locWard=loc
	...s hosDr=$p(^CTLOC(loc),"^",22)
	..e  d
	...s locWard=ward
	...q:'$d(^PAWARD(locWard))
	...s wardLocDR=$P(^PAWARD(locWard),"^",5)
	...s hosDr=$p(^CTLOC(wardLocDR),"^",22) 
	..i hosId'=""  q:((","_hosId_",")'[(","_hosDr_","))&&(hosId'="")
	..f type="ZYRS","BEDRS","DDRS" d
	...s adm=0 f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mrId,"Type",type,"Paadm",adm)) q:adm=""  d
	....s ^TEMPDHCWL($j,locWard,type,adm)=""		;计算正人数、负人数使用
	....s ^TEMPDHCWL($j,locWard,type)=$g(^TEMPDHCWL($j,locWard,type))+1	;在院人数、在床人数、等待人数汇总
	.
	.;正人数
	.s locward=""
	.f  s locward=$o(^TEMPDHCWL($j,locward)) q:locward=""  d
	..s adm=""
	..f  s adm=$o(^TEMPDHCWL($j,locward,"ZYRS",adm)) q:adm=""  d
	...i ('$d(^TEMPDHCWL($j,locward,"BEDRS",adm)))&&('$d(^TEMPDHCWL($j,locward,"DDRS",adm))) d
	....;s ^TEMPDHCWL($j,locward,"ZRS",adm)=""
	....s ^TEMPDHCWL($j,locward,"ZRS")=$g(^TEMPDHCWL($j,locward,"ZRS"))+1
	.
	.;负人数
	.s locward=""
	.f  s locward=$o(^TEMPDHCWL($j,locward)) q:locward=""  d
	..s adm=""
	..f  s adm=$o(^TEMPDHCWL($j,locward,"BEDRS",adm)) q:adm=""  d
	...i '$d(^TEMPDHCWL($j,locward,"ZYRS",adm)) d
	....;s ^TEMPDHCWL($j,locward,"ZRS",adm)=""
	....s ^TEMPDHCWL($j,locward,"FRS")=$g(^TEMPDHCWL($j,locward,"FRS"))+1
	.
	.s locward=""
	.f  s locward=$o(^TEMPDHCWL($j,locward)) q:locward=""  d
	..s adm=""
	..f  s adm=$o(^TEMPDHCWL($j,locward,"DDRS",adm)) q:adm=""  d
	...i '$d(^TEMPDHCWL($j,locward,"ZYRS",adm)) d
	....;s ^TEMPDHCWL($j,locward,"ZRS",adm)=""
	....s ^TEMPDHCWL($j,locward,"FRS")=$g(^TEMPDHCWL($j,locward,"FRS"))+1
	.
	.;output
	.s locward=""
	.f  s locward=$o(^TEMPDHCWL($j,locward)) q:locward=""  d
	..s zyrs=$g(^TEMPDHCWL($j,locward,"ZYRS"))
	..s bedrs=$g(^TEMPDHCWL($j,locward,"BEDRS"))
	..s ddrs=$g(^TEMPDHCWL($j,locward,"DDRS"))
	..s zrs=$g(^TEMPDHCWL($j,locward,"ZRS"))
	..s frs=$g(^TEMPDHCWL($j,locward,"FRS"))
	..q:(+$g(zrs)=0)&&(+$g(frs)=0)
	..i locOrWard="loc" d
	...s locwardDesc=$p(^CTLOC(locward),"^",2)
	...i locwardDesc["-" s locwardDesc=$p(locwardDesc,"-",2)
	..e  d
	...s locwardDesc=$p(^PAWARD(locward),"^",2)
	...i locwardDesc["-" s locwardDesc=$p(locwardDesc,"-",2)
	..s date=$zd(mdate,3)
	..d OutRowMain
	k ^TEMPDHCWL($j)
	Quit $$$OK
OutRowMain
	s Data=$lb(date,locward,locwardDesc,zyrs,bedrs,ddrs,zrs,frs)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryMainReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMainReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMainReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMainReportExecute ]
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

/// Creator：		陈乙
/// CreatDate：		2015-06-30
/// Description：	出入转数据核对程序明细表
/// Table：			DHCMRIPDay,DHC_MRIPDetail
/// Input：			startDate，endDate
/// Output：
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLDataReconciliationForCRZ","QueryDetailReport","2015-09-06","ZYRS","loc",15)
Query QueryDetailReport(mDate As %String, type As %String, locOrWard As %String, locward As %String) As %Query(ROWSPEC = "locwardDesc:%String,papmiNo:%String,patName:%String,admDate:%String,disDate:%String,medDisDate:%String,tjDate:%String,adm:%String") [ SqlProc ]
{
}

ClassMethod QueryDetailReportExecute(ByRef qHandle As %Binary, mDate As %String, type As %String, locOrWard As %String, locward As %String) As %Status
{

 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1

 	i ($g(mDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK  	
	i ($g(locOrWard)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	i ($g(locward)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	i ($g(type)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	k ^TEMPDHCWL($j)
	s mDate=$zdh(mDate,3)
	
	i (type="ZYRS")||(type="BEDRS")||(type="DDRS") d					
	.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",mDate,mrId)) q:mrId=""  d
	..s loc=$p(^MRIPdaily(mrId),"^",7)				;科室
	..s ward=$p(^MRIPdaily(mrId),"^",19)			;病区
	..q:($g(loc)'=locward)&&(locOrWard="loc")
	..q:($g(ward)'=locward)&&(locOrWard="ward")
	..s adm=0 f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mrId,"Type",type,"Paadm",adm)) q:adm=""  d
	...s ^TEMPDHCWL($j,type,adm)=""
	
	
	e  i (type="ZRS") d		;正人数
	.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",mDate,mrId)) q:mrId=""  d  ;1
	..s loc=$p(^MRIPdaily(mrId),"^",7)				;科室
	..s ward=$p(^MRIPdaily(mrId),"^",19)			;病区
	..q:($g(loc)'=locward)&&(locOrWard="loc")
	..q:($g(ward)'=locward)&&(locOrWard="ward")
	..f mrType="ZYRS","BEDRS","DDRS" d
	...s adm=0 f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mrId,"Type",mrType,"Paadm",adm)) q:adm=""  d
	....s ^TEMPDHCWL($j,mrType,adm)=""		;计算正人数、负人数使用
	.
	.;正人数
	.s adm=""
	.f  s adm=$o(^TEMPDHCWL($j,"ZYRS",adm)) q:adm=""  d
	..i ('$d(^TEMPDHCWL($j,"BEDRS",adm)))&&('$d(^TEMPDHCWL($j,"DDRS",adm))) d
	...s ^TEMPDHCWL($j,"ZRS",adm)=""
	
	
	e  i (type="FRS") d		;FU人数
	.s mrId=0 f  s mrId=$o(^MRIPdaily("MRIP_DATE",mDate,mrId)) q:mrId=""  d
	..s loc=$p(^MRIPdaily(mrId),"^",7)				;科室
	..s ward=$p(^MRIPdaily(mrId),"^",19)			;病区
	..q:($g(loc)'=locward)&&(locOrWard="loc")
	..q:($g(ward)'=locward)&&(locOrWard="ward")
	..f mrType="ZYRS","BEDRS","DDRS" d
	...s adm=0 f  s adm=$o(^DHCMRIPDetail(0,"IPDayDr",mrId,"Type",mrType,"Paadm",adm)) q:adm=""  d
	....s ^TEMPDHCWL($j,mrType,adm)=""		;计算正人数、负人数使用
	.
	.;负人数
	.s adm=""
	.f  s adm=$o(^TEMPDHCWL($j,"BEDRS",adm)) q:adm=""  d
	..i '$d(^TEMPDHCWL($j,"ZYRS",adm)) d
	...s ^TEMPDHCWL($j,"FRS",adm)=""
	.
	.s adm=""
	.f  s adm=$o(^TEMPDHCWL($j,"DDRS",adm)) q:adm=""  d
	..i '$d(^TEMPDHCWL($j,"ZYRS",adm)) d
	...s ^TEMPDHCWL($j,"FRS",adm)=""
	
	//OUTPUT
	s adm=""
	f  s adm=$o(^TEMPDHCWL($j,type,adm)) Q:adm=""  d
	.s papmi=$p(^PAADM(adm),"^",1)
	.s patName=$$GetPapmiName^DHCWLCommon(papmi)		;病人姓名
	.s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)			;登记号
	.s disDate=$p(^PAADM(adm),"^",17)					;最终结算时间
	.s medDisDate=$p(^PAADM(adm),"^",59)				;医疗结算时间
	.s admDate=$p(^PAADM(adm),"^",6)					;入院时间
	.i $g(admDate)'="" s admDate=$zd(admDate,3)
	.i $g(disDate)'="" s disDate=$zd(disDate,3)
	.i $g(medDisDate)'="" s medDisDate=$zd(medDisDate,3)
	.s mrDetail=$o(^DHCMRIPDetail(0,"TYPE","CYRS","ADM",adm,""),-1)
	.i $g(mrDetail)'="" d
	..s mrId=$p(^DHCMRIPDetail(mrDetail),"^",3)
	..s tjDate=$p(^MRIPdaily(mrId),"^",6)
	.e  s tjDate=""
	.i $g(tjDate)'="" s tjDate=$zd(tjDate,3)
	.i locOrWard="loc" d
	..s locwardDesc=$p(^CTLOC(locward),"^",2)
	..i locwardDesc["-" s locwardDesc=$p(locwardDesc,"-",2)
	.e  d
	..s locwardDesc=$p(^PAWARD(locward),"^",2)
	..i locwardDesc["-" s locwardDesc=$p(locwardDesc,"-",2)
	.d OutRowDetail
	k ^TEMPDHCWL($j)
	Quit $$$OK
OutRowDetail
	s Data=$lb(locwardDesc,papmiNo,patName,admDate,disDate,medDisDate,tjDate,adm)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryDetailReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDetailReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDetailReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailReportExecute ]
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

}
