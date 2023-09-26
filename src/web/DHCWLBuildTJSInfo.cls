Class web.DHCWLBuildTJSInfo Extends %RegisteredObject
{

/// Creator：		zcx
/// CreatDate：		2018-06-27
/// Description：	出院患者登记表
/// Table：			DHCMRInfo
/// Input：			startDate，endDate 院区id：hosid ,病区：wardid,科室id：locid
/// Output：        住院号,姓名,年龄,性别,入院日期,出院日期,住院天数,出院病区,出院主诊断,手术名称,切口愈合
/// /				,住院医师,家庭住址,住院费用,药费
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLBuildTJSInfo","QueryGetDepOutPatInfo","2013-04-01","2013-05-01",,,)
Query QueryGetDepOutPatInfo(startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Query(ROWSPEC = "zyh:%String,patName:%String,patSex:%String,patAge:%String,patryDate:%String,patcyDate:%String,inDays:%Float,patcyWardDesc:%String,patcyMainDiag:%String,patOperName:%String,PatOperHealLev:%String,patzljg:%String,patinDoc:%String,pataddres:%String,patinallFees:%Float,patYaoFee:%Float") [ SqlProc ]
{
}

ClassMethod QueryGetDepOutPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Status
{
 
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//------以上为固定格式---------------------------
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK   ;表示开始时间为空，直接返回（或者说直接结束该进程）
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
			
		
	s startDate=$zdh(startDate,3)						;将字符串格式日期转换成数字格式。（可使用F1查看$zdh函数作用）
	s endDate=$zdh(endDate,3)
	//1.1-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	//1.2-将科室id串转换成数组
	k wardArr
	s wardNum=$l($g(wardid),",")
	i $g(wardid)'="" d
	.f i=1:1:wardNum d
	..s id=$p($g(wardid),",",i)
	..s wardArr(id)=""
	//1.3-将科室id串转换成数组
	k locArr
	s locNum=$l($g(locid),",")
	i $g(locid)'="" d
	.f i=1:1:locNum d
	..s id=$p($g(locid),",",i)
	..s locArr(id)=""
	
	f date=startDate:1:endDate d
	.s mrid=0 f  s mrid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrid)) q:mrid=""  d
	..s admdr=$p(^DHCMRInfo(mrid),"^",6)			;就诊号
	..q:admdr=""
	..;s patcyWard=$p(^PAADM(admdr),"^",70)			;出院病区
	..;s disLoc=$p(^PAADM(admdr),"^",40)				;出院科室	
	..s patcyWard=$p(^DHCMRInfo(mrid),"^",41)			;出院病区
	..s disLoc=$p(^DHCMRInfo(mrid),"^",40)				;出院科室	
	..q:disLoc=""
	..s hosid=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(disLoc)
	..s:hosid="" hosid="999999"
	..q:('$d(hosArr(hosid)))&&($g(hosId)'="")
	..q:('$d(locArr(disLoc)))&&($g(locid)'="")
	..s zyh=$p(^DHCMRInfo(mrid),"^",4)				;住院号
	..s patName=$p(^DHCMRInfo(mrid),"^",8)			;姓名
	..s patSex=$p(^DHCMRInfo(mrid),"^",9)			;性别
	..s patAge=$p(^DHCMRInfo(mrid),"^",11)			;年龄
	..s patryDate=$p(^DHCMRInfo(mrid),"^",35)		;入院日期
	..s patcyDate=$p(^DHCMRInfo(mrid),"^",39)		;出院日期
	..i patryDate'="" s patryDate=$zd(patryDate,3)
	..i patcyDate'="" s patcyDate=$zd(patcyDate,3)
	..s inDays=$p(^DHCMRInfo(mrid),"^",42)			;住院天数
	..i $IsValidNum(patcyWard)=1 s patcyWardDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(patcyWard) ;病区
	..e  s patcyWardDesc=patcyWard
	..q:('$d(wardArr(patcyWardDesc)))&&($g(wardid)'="")
	..s patcyMainDiag=$p(^DHCMRInfo(mrid),"^",53)	;出院主诊断
	..s patOperName=$p(^DHCMRInfo(mrid),"^",122)	;手术名称
	..s PatOperHealLev=$p(^DHCMRInfo(mrid),"^",127)	;切口愈合
	..s patzljg=$p(^DHCMRInfo(mrid),"^",55)			;治疗效果
	..s patinDoc=$p(^DHCMRInfo(mrid),"^",272)		;住院医师
	..i (patinDoc="")||(patinDoc="Null")||(patinDoc="NULL") d
	...s patinDocDr=$p(^PAADM(admdr),"^",9)
	...s patinDoc=$P(^CTPCP(patinDocDr,1),"^",2)
	..s pataddres=$p(^DHCMRInfo(mrid),"^",25)		;家庭住址
	..s patinallFees=$p(^DHCMRInfo(mrid),"^",231)	;住院费用
	..s patZCYaoFees=$p(^DHCMRInfo(mrid),"^",250)	;中成药费
	..s patXYaoFees=$p(^DHCMRInfo(mrid),"^",248)	;西药费
	..s patZCaoYaoFees=$p(^DHCMRInfo(mrid),"^",251)	;中草药费
	..s patYaoFee=patZCaoYaoFees+patXYaoFees+patZCYaoFees ;药费
	..d OutRow1
	
	Quit $$$OK 
	 
OutRow1
   
	s Data=$lb(zyh,patName,patSex,patAge,patryDate,patcyDate,inDays,patcyWardDesc,patcyMainDiag,patOperName,PatOperHealLev,patzljg,patinDoc,pataddres,patinallFees,patYaoFee)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGetDepOutPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetDepOutPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGetDepOutPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetDepOutPatInfoExecute ]
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

/// Creator：		zcx
/// CreatDate：		2018-06-27
/// Description：	出院手术患者登记表
/// Table：			DHCMRInfo
/// Input：			startDate，endDate 院区id：hosid ,病区：wardid,科室id：locid
/// Output：        住院号,姓名,年龄,性别,入院日期,出院日期,手术日期,术前住院天数,住院天数,出院病区,出院主诊断,手术名称,切口愈合
/// /				,手术医师,住院费用,手术麻醉方式        
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLBuildTJSInfo","QueryGetDepInfectPatInfo","2015-09-30","2017-09-30",,,)
Query QueryGetDepInfectPatInfo(startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Query(ROWSPEC = "zyh:%String,patName:%String,patSex:%String,patAge:%String,patryDate:%String,patcyDate:%String,inDays:%Float,patcyWardDesc:%String,patcyMainDiag:%String,patzljg:%String,preOperDays:%String,patOperName:%String,patOperDoc:%String,patANAMethod:%String,PatOperHealLev:%String,patinallFees:%Float") [ SqlProc ]
{
}

ClassMethod QueryGetDepInfectPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Status
{
 
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//------以上为固定格式---------------------------
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK   ;表示开始时间为空，直接返回（或者说直接结束该进程）
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
		
		
	//1.1-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	//1.2-将科室id串转换成数组
	k wardArr
	s wardNum=$l($g(wardid),",")
	i $g(wardid)'="" d
	.f i=1:1:wardNum d
	..s id=$p($g(wardid),",",i)
	..s wardArr(id)=""
	//1.3-将科室id串转换成数组
	k locArr
	s locNum=$l($g(locid),",")
	i $g(locid)'="" d
	.f i=1:1:locNum d
	..s id=$p($g(locid),",",i)
	..s locArr(id)=""
	
	s startDate=$zdh(startDate,3)						;将字符串格式日期转换成数字格式。（可使用F1查看$zdh函数作用）
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
	.s mrid=0 f  s mrid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrid)) q:mrid=""  d
	..s admdr=$p(^DHCMRInfo(mrid),"^",6)			;就诊号
	..s Operflag=##class(web.DHCWLStatisticsInterface).GetDisAdmIsOPerFlag(admdr) ;手术名称
	..q:Operflag'="1"
	..;s patcyWard=$p(^PAADM(admdr),"^",70)			;出院病区
	..;s disLoc=$p(^PAADM(admdr),"^",40)				;出院科室
	..s patcyWard=$p(^DHCMRInfo(mrid),"^",41)
	..s disLoc=$p(^DHCMRInfo(mrid),"^",40)
	..q:disLoc=""
	..s hosid=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(disLoc)
	..s:hosid="" hosid="999999"
	
	..q:('$d(hosArr(hosid)))&&($g(hosId)'="")
	..q:('$d(locArr(disLoc)))&&($g(locid)'="")
	..s zyh=$p(^DHCMRInfo(mrid),"^",4)				;住院号
	..s patName=$p(^DHCMRInfo(mrid),"^",8)			;姓名
	..s patSex=$p(^DHCMRInfo(mrid),"^",9)			;性别
	..s patAge=$p(^DHCMRInfo(mrid),"^",11)			;年龄
	..s patryDate=$p(^DHCMRInfo(mrid),"^",35)		;入院日期
	..s patcyDate=$p(^DHCMRInfo(mrid),"^",39)		;出院日期
	..s PatOperDate=$P(^DHCMRInfo(mrid),"^",121)	;手术日期
	..s preOperDays=$g(PatOperDate)-$g(patryDate)	;术前住院天数
	..i patryDate'="" s patryDate=$zd(patryDate,3)
	..i patcyDate'="" s patcyDate=$zd(patcyDate,3)
	..s inDays=$p(^DHCMRInfo(mrid),"^",42)			;住院天数
	..i $IsValidNum(patcyWard)=1 s patcyWardDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(patcyWard) ;病区
	..e  s patcyWardDesc=patcyWard
	..q:('$d(wardArr(patcyWardDesc)))&&($g(wardid)'="")
	..s patcyMainDiag=$p(^DHCMRInfo(mrid),"^",53)	;出院主诊断
	..s patOperDoc=$P(^DHCMRInfo(mrid),"^",123)		;手术医师
	..s patOperName=$p(^DHCMRInfo(mrid),"^",122)	;手术名称
	..s patANAMethod=$P(^DHCMRInfo(mrid),"^",126)	;手术麻醉方式
	..s PatOperHealLev=$p(^DHCMRInfo(mrid),"^",127)	;切口愈合
	..s patzljg=$p(^DHCMRInfo(mrid),"^",55)			;治疗效果
	..s patinallFees=$p(^DHCMRInfo(mrid),"^",231)	;住院费用
	..d OutRow2
	
	Quit $$$OK 
	 
OutRow2
   
	s Data=$lb(zyh,patName,patSex,patAge,patryDate,patcyDate,inDays,patcyWardDesc,patcyMainDiag,patzljg,preOperDays,patOperName,patOperDoc,patANAMethod,PatOperHealLev,patinallFees)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGetDepInfectPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetDepInfectPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGetDepInfectPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetDepInfectPatInfoExecute ]
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

/// Creator：		zcx
/// CreatDate：		2017-12-6
/// Description：	出院感染患者患者登记表
/// Table：			DHCWorkRegReport
/// Input：			startDate，endDate  院区id：hosid ,病区：wardid,科室id：locid
/// Output：        住院号,姓名,年龄,性别,家庭住址,入院日期,出院日期,手术日期,住院天数,出院病区,出院主诊断,
/// /				,治疗效果,住院费用     
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLBuildTJSInfo","QueryGetDepOutInfectPatInfo","2015-09-30","2017-09-30")
Query QueryGetDepOutInfectPatInfo(startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Query(ROWSPEC = "zyh:%String,patName:%String,patSex:%String,patAge:%String,pataddres:%String,patryDate:%String,patcyDate:%String,inDays:%Float,patcyWardDesc:%String,patcyMainDiag:%String,patzljg:%String,patinallFees:%Float") [ SqlProc ]
{
}

ClassMethod QueryGetDepOutInfectPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Status
{
 
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//------以上为固定格式---------------------------
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK   ;表示开始时间为空，直接返回（或者说直接结束该进程）
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK			
	
	//1.1-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	//1.2-将科室id串转换成数组
	k wardArr
	s wardNum=$l($g(wardid),",")
	i $g(wardid)'="" d
	.f i=1:1:wardNum d
	..s id=$p($g(wardid),",",i)
	..s wardArr(id)=""
	//1.3-将科室id串转换成数组
	k locArr
	s locNum=$l($g(locid),",")
	i $g(locid)'="" d
	.f i=1:1:locNum d
	..s id=$p($g(locid),",",i)
	..s locArr(id)=""
	
	s startDate=$zdh(startDate,3)						;将字符串格式日期转换成数字格式。（可使用F1查看$zdh函数作用）
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
	.s mrid=0 f  s mrid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrid)) q:mrid=""  d
	..s admdr=$p(^DHCMRInfo(mrid),"^",6)			;就诊号
	..;s patcyWard=$p(^PAADM(admdr),"^",70)			;出院病区
	..;s disLoc=$p(^PAADM(admdr),"^",40)				;出院科室	
	..s patcyWard=$p(^DHCMRInfo(mrid),"^",41)			;出院病区
	..s disLoc=$p(^DHCMRInfo(mrid),"^",40)				;出院科室	
	..q:(disLoc="")
	..s hosid=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(disLoc)
	..s:hosid="" hosid="999999"
	..q:('$d(hosArr(hosid)))&&($g(hosId)'="")
	..q:('$d(locArr(disLoc)))&&($g(locid)'="")
	..s crbFlag=##class(web.DHCWLStatisticsInterface).GetDisAdmIsCRFlag(admdr) ;传染病判断 
	..q:crbFlag'="1"
	..s zyh=$p(^DHCMRInfo(mrid),"^",4)				;住院号
	..s patName=$p(^DHCMRInfo(mrid),"^",8)			;姓名
	..s patSex=$p(^DHCMRInfo(mrid),"^",9)			;性别
	..s patAge=$p(^DHCMRInfo(mrid),"^",11)			;年龄
	..s pataddres=$p(^DHCMRInfo(mrid),"^",25)		;家庭住址
	..s patryDate=$p(^DHCMRInfo(mrid),"^",35)		;入院日期
	..s patcyDate=$p(^DHCMRInfo(mrid),"^",39)		;出院日期
	..i patryDate'="" s patryDate=$zd(patryDate,3)
	..i patcyDate'="" s patcyDate=$zd(patcyDate,3)
	..s inDays=$p(^DHCMRInfo(mrid),"^",42)			;住院天数
	..i $IsValidNum(patcyWard)=1 s patcyWardDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(patcyWard) ;病区
	..e  s patcyWardDesc=patcyWard
	..q:('$d(wardArr(patcyWardDesc)))&&($g(wardid)'="")
	..s patcyMainDiag=$p(^DHCMRInfo(mrid),"^",53)	;出院主诊断
	..s patzljg=$p(^DHCMRInfo(mrid),"^",55)			;治疗效果
	..s patinallFees=$p(^DHCMRInfo(mrid),"^",231)	;住院费用
	..d OutRow3
	
	Quit $$$OK 
	 
OutRow3
   
	s Data=$lb(zyh,patName,patSex,patAge,pataddres,patryDate,patcyDate,inDays,patcyWardDesc,patcyMainDiag,patzljg,patinallFees)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGetDepOutInfectPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetDepOutInfectPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGetDepOutInfectPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetDepOutInfectPatInfoExecute ]
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

/// Creator：		zcx
/// CreatDate：		2018-06-27
/// Description：	出院抢救患者患者登记表
/// Table：			DHCMRInfo
/// Input：			startDate，endDate  院区id：hosid ,病区：wardid,科室id：locid
/// Output：        住院号,姓名,年龄,性别,职业,家庭住址,入院日期,出院日期,手术日期,住院天数,出院病区,出院主诊断,抢救次数,抢救成功次数
/// /				,治疗效果,住院费用      
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLBuildTJSInfo","QueryGetDepOutRescuePatInfo","2015-09-30","2017-09-30")
Query QueryGetDepOutRescuePatInfo(startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Query(ROWSPEC = "zyh:%String,patName:%String,patSex:%String,patAge:%String,patWork:%String,pataddres:%String,patryDate:%String,patcyDate:%String,inDays:%Float,patcyWardDesc:%String,patcyMainDiag:%String,patzljg:%String,patinallFees:%Float,qjNums:%Float,qjcgNums:%Float") [ SqlProc ]
{
}

ClassMethod QueryGetDepOutRescuePatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Status
{
 
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//------以上为固定格式---------------------------
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK   ;表示开始时间为空，直接返回（或者说直接结束该进程）
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
			
		
	//1.1-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	//1.2-将科室id串转换成数组
	k wardArr
	s wardNum=$l($g(wardid),",")
	i $g(wardid)'="" d
	.f i=1:1:wardNum d
	..s id=$p($g(wardid),",",i)
	..s wardArr(id)=""
	//1.3-将科室id串转换成数组
	k locArr
	s locNum=$l($g(locid),",")
	i $g(locid)'="" d
	.f i=1:1:locNum d
	..s id=$p($g(locid),",",i)
	..s locArr(id)=""
	
	s startDate=$zdh(startDate,3)						;将字符串格式日期转换成数字格式。（可使用F1查看$zdh函数作用）
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
	.s mrid=0 f  s mrid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrid)) q:mrid=""  d
	..s admdr=$p(^DHCMRInfo(mrid),"^",6)			;就诊号
	..;s patcyWard=$p(^PAADM(admdr),"^",70)			;出院病区
	..;s disLoc=$p(^PAADM(admdr),"^",40)				;出院科室	
	..s patcyWard=$p(^DHCMRInfo(mrid),"^",41)			;出院病区
	..s disLoc=$p(^DHCMRInfo(mrid),"^",40)				;出院科室	
	..q:(disLoc="")
	..s hosid=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(disLoc)
	..s:hosid="" hosid="999999"
	..q:('$d(hosArr(hosid)))&&($g(hosId)'="")
	..q:('$d(locArr(disLoc)))&&($g(locid)'="")
	..s qjFlag=##class(web.DHCWLStatisticsInterface).GetDisAdmIsRescueFlag(admdr)	;抢救标志
	..q:qjFlag'="1"
	..s zyh=$p(^DHCMRInfo(mrid),"^",4)				;住院号
	..s patName=$p(^DHCMRInfo(mrid),"^",8)			;姓名
	..s patSex=$p(^DHCMRInfo(mrid),"^",9)			;性别
	..s patAge=$p(^DHCMRInfo(mrid),"^",11)			;年龄
	..s patWork=$p(^DHCMRInfo(mrid),"^",20)			;职业
	..s pataddres=$p(^DHCMRInfo(mrid),"^",25)		;家庭住址
	..s patryDate=$p(^DHCMRInfo(mrid),"^",35)		;入院日期
	..s patcyDate=$p(^DHCMRInfo(mrid),"^",39)		;出院日期
	..i patryDate'="" s patryDate=$zd(patryDate,3)
	..i patcyDate'="" s patcyDate=$zd(patcyDate,3)
	..s inDays=$p(^DHCMRInfo(mrid),"^",42)			;住院天数
	..i $IsValidNum(patcyWard)=1 s patcyWardDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(patcyWard) ;病区
	..e  s patcyWardDesc=patcyWard
	..q:('$d(wardArr(patcyWardDesc)))&&($g(wardid)'="")
	..s patcyMainDiag=$p(^DHCMRInfo(mrid),"^",53)	;出院主诊断
	..s patzljg=$p(^DHCMRInfo(mrid),"^",55)			;治疗效果
	..s patinallFees=$p(^DHCMRInfo(mrid),"^",231)	;住院费用
	..s qjNums=$p(^DHCMRInfo(mrid),"^",229)			;抢救次数
	..s qjcgNums=$p(^DHCMRInfo(mrid),"^",230)		;抢救成功次数
	..d OutRow4
	
	Quit $$$OK 
	 
OutRow4
   
	s Data=$lb(zyh,patName,patSex,patAge,patWork,pataddres,patryDate,patcyDate,inDays,patcyWardDesc,patcyMainDiag,patzljg,patinallFees,qjNums,qjcgNums)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGetDepOutRescuePatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetDepOutRescuePatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGetDepOutRescuePatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetDepOutRescuePatInfoExecute ]
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

/// Creator：		zcx
/// CreatDate：		2018-06-27
/// Description：	出院死亡患者患者登记表
/// Table：			DHCMRInfo
/// Input：			startDate，endDate 院区id：hosid ,病区：wardid,科室id：locid
/// Output：        住院号,姓名,年龄,性别,职业,家庭住址,入院日期,出院日期,死亡日期,死亡时间,住院天数,出院病区,出院主诊断,
/// /				,手术名称,住院费用       
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLBuildTJSInfo","QueryGetDepSWPatInfo","2015-09-30","2017-09-30",,,)
Query QueryGetDepSWPatInfo(startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Query(ROWSPEC = "zyh:%String,patName:%String,patSex:%String,patAge:%String,patWork:%String,pataddres:%String,patryDate:%String,PatOperDate:%String,mDeceDate:%String,mDeceTime:%String,inDays:%String,patcyWardDesc:%String,patcyMainDiag:%String,patOperName:%String,patinallFees:%Float") [ SqlProc ]
{
}

ClassMethod QueryGetDepSWPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Status
{
 
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//------以上为固定格式---------------------------
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK   ;表示开始时间为空，直接返回（或者说直接结束该进程）
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK		
	
			
	//1.1-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	//1.2-将科室id串转换成数组
	k wardArr
	s wardNum=$l($g(wardid),",")
	i $g(wardid)'="" d
	.f i=1:1:wardNum d
	..s id=$p($g(wardid),",",i)
	..s wardArr(id)=""
	//1.3-将科室id串转换成数组
	k locArr
	s locNum=$l($g(locid),",")
	i $g(locid)'="" d
	.f i=1:1:locNum d
	..s id=$p($g(locid),",",i)
	..s locArr(id)=""
	
	s startDate=$zdh(startDate,3)						;将字符串格式日期转换成数字格式。（可使用F1查看$zdh函数作用）
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
	.s mrid=0 f  s mrid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrid)) q:mrid=""  d
	..s admdr=$p(^DHCMRInfo(mrid),"^",6)			;就诊号
	..q:admdr=""
	..;s patcyWard=$p(^PAADM(admdr),"^",70)			;出院病区
	..;s disLoc=$p(^PAADM(admdr),"^",40)				;出院科室	
	..s patcyWard=$p(^DHCMRInfo(mrid),"^",41)			;出院病区
	..s disLoc=$p(^DHCMRInfo(mrid),"^",40)				;出院科室	
	..q:(disLoc="")
	..s hosid=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(disLoc)
	..s:hosid="" hosid="999999"
	..q:('$d(hosArr(hosid)))&&($g(hosId)'="")
	..q:('$d(locArr(disLoc)))&&($g(locid)'="")
	..s deadFlag=##class(web.DHCWLStatisticsInterface).GetDisAdmIsDeadFlag(admdr)
	..q:deadFlag'="1"							;过滤非死亡患者
	..s zyh=$p(^DHCMRInfo(mrid),"^",4)				;住院号
	..s patName=$p(^DHCMRInfo(mrid),"^",8)			;姓名
	..s patSex=$p(^DHCMRInfo(mrid),"^",9)			;性别
	..s patAge=$p(^DHCMRInfo(mrid),"^",11)			;年龄
	..s patWork=$p(^DHCMRInfo(mrid),"^",20)			;职业
	..s pataddres=$p(^DHCMRInfo(mrid),"^",25)		;家庭住址
	..s patryDate=$p(^DHCMRInfo(mrid),"^",35)		;入院日期
	..s PatOperDate=$P(^DHCMRInfo(mrid),"^",121)	;手术日期
	..s papmiDr=$p(^PAADM(admdr),"^",1)
	..s mDeceDate=$P($G(^PAPER(papmiDr,"ALL")),"^",13)	;死亡日期
	..s mDeceTime=$P($G(^PAPER(papmiDr,"ALL")),"^",8)	;死亡时间
	..s inDays=$p(^DHCMRInfo(mrid),"^",42)			;住院天数
	..i patryDate'="" s patryDate=$zd(patryDate,3)  
	..i PatOperDate'="" s PatOperDate=$zd(PatOperDate,3)  
	..i mDeceDate'="" s mDeceDate=$zd(mDeceDate,3)
	..i mDeceTime'="" s mDeceTime=$zt(mDeceTime)
	..i $IsValidNum(patcyWard)=1 s patcyWardDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(patcyWard) ;病区
	..e  s patcyWardDesc=patcyWard
	..q:('$d(wardArr(patcyWardDesc)))&&($g(wardid)'="")
	..s patcyMainDiag=$p(^DHCMRInfo(mrid),"^",53)	;出院主诊断
	..s patOperName=$p(^DHCMRInfo(mrid),"^",122)	;手术名称
	..s patinallFees=$p(^DHCMRInfo(mrid),"^",231)	;住院费用
	..d OutRow5
	
	Quit $$$OK 
	 
OutRow5
   
	s Data=$lb(zyh,patName,patSex,patAge,patWork,pataddres,patryDate,PatOperDate,mDeceDate,mDeceTime,inDays,patcyWardDesc,patcyMainDiag,patOperName,patinallFees)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGetDepSWPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetDepSWPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGetDepSWPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetDepSWPatInfoExecute ]
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

/// Creator：		zcx
/// CreatDate：		2018-06-27
/// Description：	感染病人登记簿
/// Table：			DHCMRInfo
/// Input：			startDate，endDate 院区id：hosid ,病区：wardid,科室id：locid
/// Input：			startDate，endDate 院区id：hosid ,病区：wardid,科室id：locid
/// Output：        住院号,病案号,姓名,性别,职业,单位地址,入院日期,出院日期,,出院病区,院内感染名称,
/// /				,治疗结果,住院费用      
/// Return： 		无
/// Others： 		无
/// d ##class(%ResultSet).RunQuery("web.DHCWLBuildTJSInfo","QueryGetYNGRPatInfo","2015-09-30","2017-09-30",,)
Query QueryGetYNGRPatInfo(startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Query(ROWSPEC = "zyh:%String,bah:%String,patName:%String,patSex:%String,patWork:%String,pataddres:%String,patryDate:%String,patcyDate:%String,patcyWardDesc:%String,patGRMC:%String,patzljg:%String,patinallFees:%Float") [ SqlProc ]
{
}

ClassMethod QueryGetYNGRPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosId As %String, wardid As %Text, locid As %Text) As %Status
{
 
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//------以上为固定格式---------------------------
 	i ($g(startDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK   ;表示开始时间为空，直接返回（或者说直接结束该进程）
	i ($g(endDate)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK	
	
			
	//1.1-将院区id串转换成数组
	k hosArr
	s hosNum=$l($g(hosId),",")
	i $g(hosId)'="" d
	.f i=1:1:hosNum d
	..s id=$p($g(hosId),",",i)
	..s hosArr(id)=""
	//1.2-将科室id串转换成数组
	k wardArr
	s wardNum=$l($g(wardid),",")
	i $g(wardid)'="" d
	.f i=1:1:wardNum d
	..s id=$p($g(wardid),",",i)
	..s wardArr(id)=""
	//1.3-将科室id串转换成数组
	k locArr
	s locNum=$l($g(locid),",")
	i $g(locid)'="" d
	.f i=1:1:locNum d
	..s id=$p($g(locid),",",i)
	..s locArr(id)=""
		
	s startDate=$zdh(startDate,3)						;将字符串格式日期转换成数字格式。（可使用F1查看$zdh函数作用）
	s endDate=$zdh(endDate,3)

	f date=startDate:1:endDate d
	.s mrid=0 f  s mrid=$o(^DHCMRInfo(0,"MR_DIS_DATE",date,mrid)) q:mrid=""  d
	..s admdr=$p(^DHCMRInfo(mrid),"^",6)			;就诊号
	..q:admdr=""
	..;s patcyWard=$p(^PAADM(admdr),"^",70)			;出院病区
	..;s disLoc=$p(^PAADM(admdr),"^",40)				;出院科室	
	..s patcyWard=$p(^DHCMRInfo(mrid),"^",41)			;出院病区
	..s disLoc=$p(^DHCMRInfo(mrid),"^",40)				;出院科室	
	..q:(disLoc="")
	..s hosid=$$GetHosIDByCTLoc^DHCWLBuildDimDataCTLOC(disLoc)
	..s:hosid="" hosid="999999"
	..q:('$d(hosArr(hosid)))&&($g(hosId)'="")
	..q:('$d(locArr(disLoc)))&&($g(locid)'="")
	..s GrICD=##class(web.DHCWLStatisticsInterface).GetDisAdmIsGRFlag(admdr)			;院内感染
	..q:GrICD=0
	..s zyh=$p(^DHCMRInfo(mrid),"^",4)				;住院号
	..s bah=$p(^DHCMRInfo(mrid),"^",4)				;病案号
	..s patName=$p(^DHCMRInfo(mrid),"^",8)			;姓名
	..s patSex=$p(^DHCMRInfo(mrid),"^",9)			;性别
	..s patWork=$p(^DHCMRInfo(mrid),"^",20)			;职业
	..s pataddres=$p(^DHCMRInfo(mrid),"^",27)		;单位住址
	..s patryDate=$p(^DHCMRInfo(mrid),"^",35)		;入院日期
	..s patcyDate=$p(^DHCMRInfo(mrid),"^",39)		;出院日期
	..i patryDate'="" s patryDate=$zd(patryDate,3)
	..i patcyDate'="" s patcyDate=$zd(patcyDate,3)
	..i $IsValidNum(patcyWard)=1 s patcyWardDesc=$$GetWardDesc^DHCWLBuildDimDataWARD(patcyWard) ;病区
	..e  s patcyWardDesc=patcyWard
	..q:('$d(wardArr(patcyWardDesc)))&&($g(wardid)'="")
	..s patGRMC=$p(^DHCMRInfo(mrid),"^",118)		;院内感染
	..s patzljg=$p(^DHCMRInfo(mrid),"^",55)			;治疗效果
	..s patinallFees=$p(^DHCMRInfo(mrid),"^",231)	;住院费用
	..d OutRow6
	
	Quit $$$OK 
	 
OutRow6
   
	s Data=$lb(zyh,bah,patName,patSex,patWork,pataddres,patryDate,patcyDate,patcyWardDesc,patGRMC,patzljg,patinallFees)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QueryGetYNGRPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGetYNGRPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryGetYNGRPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGetYNGRPatInfoExecute ]
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
