/// 集团化医院
Class web.UDHCHospitalGroup Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：       lid
/// CreatDate：     2014-12-29
/// Description:：  根据就诊Rowid取其所在医院的RowID
/// Table：       
/// Input：         就诊Rowid
/// Output：          
/// Return：        医院的RowID
/// Others：  w ##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
ClassMethod GetHospitalByAdm(adm)
{
	q:adm="" ""
	s AdmDep=$p($g(^PAADM(adm)),"^",4)
	s HospID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDep)
	q $g(HospID)
}

/// Creator：       lrl
/// CreatDate：     2009-06-10
/// Description:：  根据科室RowID取其所在医院的RowID
/// Table：       
/// Input：         科室RowID 
/// Output：          
/// Return：        医院的RowID
/// Others：        
ClassMethod GetHospitalIDByLocID(LocID As %String = "") As %String
{
	;w ##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(131)
	new (LocID)
	set HospitalID=""
	if LocID="" quit HospitalID
	set HospitalID=$piece($get(^CTLOC(LocID)),"^",22)
	;if (+HospitalID=0) set HospitalID=$o(^CT("HOSP","0"))   
	quit HospitalID
}

/// Creator：       lrl
/// CreatDate：     2009-06-10
/// Description:：  根据用户RowID取其所在医院的RowID
/// Table：       
/// Input：         用户RowID   
/// Output：          
/// Return：        医院的RowID 
/// Others：
ClassMethod GetHospitalIDByUserID(UserID As %String = "") As %String
{
	new (UserID)
	set HospitalID=""
	if UserID="" quit HospitalID
	set HospitalID=$piece($get(^SSU("SSUSR",UserID)),"^",98)
	quit HospitalID
}

/// Creator：       lrl
/// CreatDate：     2009-06-11
/// Description:：  根据科室名称、用户RowID、就诊类型查询科室列表
/// Table：       
/// Input：         科室名称、用户RowID、就诊类型 
/// Output：          
/// Return：        科室列表
/// Others：   
Query CTLocLookup(Desc As %String, UserID As %String, AdmType As %String) As %Query(ROWSPEC = "Desc:%String,HIDDEN:%String,HospitalName:%String")
{
}

ClassMethod CTLocLookupExecute(ByRef qHandle As %Binary, Desc As %String = "", UserID As %String = "", AdmType As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	set ToDay=+$H
	set myUserHospitalID=##Class(web.UDHCHospitalGroup).GetHospitalIDByUserID(UserID)
	set Desc=$$ALPHAUP^SSUTIL4(Desc)
	if (AdmType="")
	{
		do QueryCTLoc
	}
	else
	{
		if (AdmType["I") do QueryAdmTypeLoc("I")
		if (AdmType["O") do QueryAdmTypeLoc("O")
		if (AdmType["E") do QueryAdmTypeLoc("E")
		if (AdmType["H") do QueryAdmTypeLoc("H")
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryAdmTypeLoc(myAdmType)
	set myLocID=""
	while ($order(^PAC("ADMLOC",0,"AdmType",myAdmType,myLocID))'="")
	{
		set myLocID=$order(^PAC("ADMLOC",0,"AdmType",myAdmType,myLocID))
		do GetLoc
	}
	quit
QueryCTLoc
	set myLocID="0"
	while ($order(^CTLOC(myLocID))'="")
	{
		set myLocID=$order(^CTLOC(myLocID))
		do GetLoc			
	}    
	quit
GetLoc
	set myDesc=$piece($get(^CTLOC(myLocID)),"^",2)
	set myDescUp=$$ALPHAUP^SSUTIL4(myDesc)
	if ((Desc'="")&&(myDescUp'[Desc)) quit
	set myHospitalID=$piece($get(^CTLOC(myLocID)),"^",22)
	if (myUserHospitalID'=myHospitalID) quit
	set DateActiveFrom=$piece($get(^CTLOC(myLocID)),"^",24)
	set DateActiveTo=$piece($get(^CTLOC(myLocID)),"^",25)
	if ((DateActiveFrom'="")&&(DateActiveFrom>ToDay)) quit
	if ((DateActiveTo'="")&&(DateActiveTo<ToDay)) quit
	set CTLocDesc=myDesc
	set CTLocRowID=myLocID
	set HospitalName=""
	if myHospitalID'="" set HospitalName=$piece($get(^CT("HOSP",myHospitalID)),"^",2)
	do OutputRowCTLoc
	quit
OutputRowCTLoc
	set Data=$lb(CTLocDesc,CTLocRowID,HospitalName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CTLocLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTLocLookupExecute ]
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

ClassMethod CTLocLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTLocLookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：       lrl
/// CreatDate：     2009-06-11
/// Description:：  根据病区名称、用户RowID查询病区列表
/// Table：       
/// Input：         病区名称、用户RowID 
/// Output：          
/// Return：        病区列表
/// Others： 
Query WardLookup(Desc As %String, UserID As %String) As %Query(ROWSPEC = "Desc:%String,HIDDEN:%String,HospitalName:%String")
{
}

ClassMethod WardLookupExecute(ByRef qHandle As %Binary, Desc As %String = "", UserID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	set ToDay=+$H
	set myUserHospitalID=##Class(web.UDHCHospitalGroup).GetHospitalIDByUserID(UserID)
	set Desc=$$ALPHAUP^SSUTIL4(Desc)
	set WardRowID="0"
	while (($order(^PAWARD(WardRowID))'="")&&(+($order(^PAWARD(WardRowID)))'=0))
	{
		set WardRowID=$order(^PAWARD(WardRowID))
		set WardDesc=$piece($get(^PAWARD(WardRowID)),"^",2)
		set myLocID=$piece($get(^PAWARD(WardRowID)),"^",5)
		set DateActiveFrom=$piece($get(^CTLOC(myLocID)),"^",24)
		set DateActiveTo=$piece($get(^CTLOC(myLocID)),"^",25)
		if ((DateActiveFrom'="")&&(DateActiveFrom>ToDay)) continue
		if ((DateActiveTo'="")&&(DateActiveTo<ToDay)) continue
		set myDescUp=$$ALPHAUP^SSUTIL4(WardDesc)
		if ((Desc'="")&&(myDescUp'[Desc)) continue
		set myHospitalID=$piece($get(^CTLOC(myLocID)),"^",22)
		if (myUserHospitalID'=myHospitalID) continue
		set HospitalName=""
		if myHospitalID'="" set HospitalName=$piece($get(^CT("HOSP",myHospitalID)),"^",2)
		do OutputRowWard
	}    
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK


OutputRowWard
	set Data=$lb(WardDesc,WardRowID,HospitalName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod WardLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardLookupExecute ]
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

ClassMethod WardLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardLookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query HospLookup() As %Query(ROWSPEC = "HospitalName:%String,HosptialID:%String")
{
}

ClassMethod HospLookupExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s HospName="全部"
 	s HospId=""
 	d OutputRowHos
 	s HospId=0
 	f  s HospId=$o(^CT("HOSP",HospId)) q:HospId=""  d
 	.s HospName=$p(^CT("HOSP",HospId),"^",2)
 	.d OutputRowHos
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK


OutputRowHos
	set Data=$lb(HospName,HospId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod HospLookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HospLookupExecute ]
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

ClassMethod HospLookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HospLookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取默认的登陆医院
ClassMethod GetDefHospitalInfoByLocID(LocID As %String = "") As %String
{
	;w ##class(web.UDHCHospitalGroup).GetDefHospitalInfoByLocID(693)
	new (LocID)
	set HospitalID=""
	if LocID="" quit HospitalID
	set HospitalID=$piece($get(^CTLOC(LocID)),"^",22)
	
	if (+HospitalID=0) set HospitalID=$o(^CT("HOSP","0"))
	i HospitalID'="" set HospitalDesc=$p(^CT("HOSP",HospitalID),"^",2)
	quit HospitalID_"^"_$g(HospitalDesc)
}

/// Creator：       pjf
/// CreatDate：     2015-01-30
/// Description:：  根据登录科室ID获取医院名称
/// Table：       
/// Input：         LocID:登录科室ID 
/// Output：          
/// Return：        医院名称
/// Others：        
ClassMethod getHospitalNameByLoc(LocID As %String) As %String
{
	
	;w ##class(web.UDHCHospitalGroup).getHospitalNameByLoc(131)
	n (LocID)
	s HospitalID=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocID)
	
	q ##class(web.UDHCHospitalGroup).getHospitalName(HospitalID)
}

/// Creator：       pjf
/// CreatDate：     2015-01-30
/// Description:：  根据医院ID获取医院名称
/// Table：       
/// Input：         LocID:登录科室ID 
/// Output：          
/// Return：        医院名称
/// Others：        
ClassMethod getHospitalName(HospitalID As %String) As %String
{
	;w ##class(web.UDHCHospitalGroup).getHospitalName(131)
	n (HospitalID)
	q:HospitalID="" ""
	s HospitalName=$P(^CT("HOSP",HospitalID),"^",2)
	q HospitalName
}

/// Creator：       bishengwen
/// CreatDate：     2015-04-04
/// Description:：  根据医院ID获取医院编码
/// Table：       
/// Input：         LocID:登录科室ID 
/// Output：          
/// Return：        医院编码
/// Others：        
ClassMethod getHospitalCode(HospitalID As %String) As %String
{
	;w ##class(web.UDHCHospitalGroup).getHospitalName(131)
	n (HospitalID)
	q:HospitalID="" ""
	s HospitalCode=$P(^CT("HOSP",HospitalID),"^",1)
	q HospitalCode
}

/// Creator：       bishengwen
/// CreatDate：     2015-04-04
/// Description:：  根据医院ID获取医院编码
/// Table：       
/// Input：         LocID:登录科室ID 
/// Output：          
/// Return：        医院编码
/// Others：        
ClassMethod getHospitalPhone(HospitalID As %String) As %String
{
	;w ##class(web.UDHCHospitalGroup).getHospitalPhone(1)
	n (HospitalID)
	q:HospitalID="" ""
	s HospitalPhone=$P(^CT("HOSP",HospitalID),"^",11)
	q HospitalPhone
}

/// Creator：       pjf
/// CreatDate：     2015-01-08
/// Description:：  根据登录科室ID和病人就诊号判断是否进行隔离
/// Table：       
/// Input：         LocID:登录科室ID   EpisodeID:就诊号 
/// Output：          
/// Return：        ret^医院ID    ret:  1: 需要进行隔离   0: 不需要
/// Others：        
ClassMethod IfNeedSpliterByADM(LocID As %String = "", EpisodeID As %String = "") As %String
{
	;w ##class(web.UDHCHospitalGroup).IfNeedSpliterByADM(131)
	n (LocID,EpisodeID)
	s PatAdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	s Ret=##class(web.UDHCHospitalGroup).IfNeedSpliterByLoc(LocID,PatAdmLoc)
	q Ret
}

/// Creator：       pjf
/// CreatDate：     2015-01-08
/// Description:：  根据登录科室ID和UserID判断是否进行隔离
/// Table：       
/// Input：         LocID:登录科室ID   UserID:用户ID
/// Output：          
/// Return：   ret^医院ID    ret:  1: 需要进行隔离   0: 不需要
/// Others：        
ClassMethod IfNeedSpliterByUser(LocID As %String = "", UserID As %String = "") As %String
{
	;w ##class(web.UDHCHospitalGroup).IfNeedSpliterByUser(131)
	n (LocID,UserID)
	s HospitalID1=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocID)
	//取默认医院ID
	;s HospitalID2=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(UserID)
	;s Ret=##class(web.UDHCHospitalGroup).IfNeedSpliterByHospitalID(HospitalID1,HospitalID2)
	;q:$p(Ret,"^",1)=0 Ret
	;i $p(Ret,"^",1)=0 q Ret
	;默认登录科室
	q:UserID="" 0
	q:$g(^SSU("SSUSR",UserID))="" 0
	s UserLocID=$p(^SSU("SSUSR",UserID),"^",4)
	s Ret=##class(web.UDHCHospitalGroup).IfNeedSpliterByLoc(LocID,UserLocID)
	q:$p(Ret,"^",1)=0 Ret
	//循环其他登录科室对应的医院
	s Sub=""
	f  s Sub=$o(^SSU("SSUSR",UserID,"OTHLL",Sub)) q:(Sub="")!($p(Ret,"^",1)=0)  d
	.s LocID2=$p(^SSU("SSUSR",UserID,"OTHLL",Sub),"^",1)
	.s Ret=##class(web.UDHCHospitalGroup).IfNeedSpliterByLoc(LocID,LocID2)
	
	q Ret
}

/// Creator：       pjf
/// CreatDate：     2015-01-08
/// Description:：  根据医院ID判断是否进行隔离
/// Table：       
/// Input：         HospitalID1:登录医院ID   HospitalID2:其他医院ID
/// Output：          
/// Return：         ret^医院ID    ret:  1: 需要进行隔离   0: 不需要
/// Others：        
ClassMethod IfNeedSpliterByHospitalID(HospitalID1 As %String = "", HospitalID2 As %String = "") As %String
{
	;w ##class(web.UDHCHospitalGroup).IfNeedSpliterByHospitalID(131)
	n (HospitalID1,HospitalID2)
	//两个科室对应的医院ID相等且都不为空才不需要隔离,其他情况都需要隔离
	s Ret=$s((HospitalID1=HospitalID2)&&(HospitalID1'="")&&(HospitalID2'=""):0,1:1)
	;b ;w HospitalID1,!,HospitalID2
	q Ret_"^"_HospitalID1
}

/// Creator：       pjf
/// CreatDate：     2015-01-08
/// Description:：  根据登录科室ID和科室ID判断是否进行隔离
/// Table：       
/// Input：         LocID1:登录科室ID   LocID2:科室ID 
/// Output：          
/// Return：        ret^医院ID    ret:  1: 需要进行隔离   0: 不需要
/// Others：        
/// Debug: //w ##class(web.UDHCHospitalGroup).IfNeedSpliterByLoc("","")
ClassMethod IfNeedSpliterByLoc(LocID1 As %String = "", LocID2 As %String = "") As %String
{
	;w ##class(web.UDHCHospitalGroup).IfNeedSpliterByLoc(131)
	n (LocID1,LocID2)
	s HospitalID1=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocID1)
	s HospitalID2=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocID2)
	s Ret=##class(web.UDHCHospitalGroup).IfNeedSpliterByHospitalID(HospitalID1,HospitalID2)
	;b ;w HospitalID2
	q Ret
}

/// Creator：       zg
/// CreatDate：     2015-01-09
/// Description:：  根据当前登录医院id和UserID判断是否进行隔离
/// Table：       
/// Input：         HosID:登录医院ID   UserID:用户id 
/// Output：          
/// Return：   ret^医院ID    ret:  1: 需要进行隔离   0: 不需要
/// Others：        
ClassMethod IfNeedSpliterByHospitalAndUser(HosID As %String = "", UserID As %String = "") As %String
{
	;w ##class(web.UDHCHospitalGroup).IfNeedSpliterByUser(131)
	n (HosID,UserID)
	//取默认医院ID
	s HospitalID2=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(UserID)
	s Ret=##class(web.UDHCHospitalGroup).IfNeedSpliterByHospitalID(HosID,HospitalID2)
	i $p(Ret,"^",1)=0 q Ret
	//循环其他登录科室对应的医院
	s Sub=""
	f  s Sub=$o(^SSU("SSUSR",UserID,"OTHLL",Sub)) q:(Sub="")!($p(Ret,"^",1)=0)  d
	.s LocID2=$p(^SSU("SSUSR",UserID,"OTHLL",Sub),"^",1)
	.s HosID2=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocID2)
	.s Ret=##class(web.UDHCHospitalGroup).IfNeedSpliterByHospitalID(HosID,HosID2)
	q Ret
}

}
