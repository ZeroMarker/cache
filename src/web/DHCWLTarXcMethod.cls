Class web.DHCWLTarXcMethod Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarXcMethod","GetMaterialInfo","2022-11-23","2022-11-23","","","10","3")
/// input : disLoc 科室 disPah:住院号 dj:单价
Query GetMaterialInfo(startDate As %String, endDate As %String, disLoc As %String, disPah As %String, dj As %String, hos As %String) As %Query(ROWSPEC = "paBah,papName,paId,admDate,disDate,locDesc,docDesc,itemDesc,uomDesc,qty:%Float,unit:%Float,cost:%Float,rea") [ SqlProc ]
{
}

ClassMethod GetMaterialInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, disLoc As %String, disPah As %String, dj As %String, hos As %String) As %Status
{
	n (qHandle,startDate,endDate,disLoc,disPah,dj,hos)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:startDate="" 1
    q:endDate="" 1
    k hosArr
    d GetRunQianArr^DHCWLCommonParsingMethods(hos,.hosArr)
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate = sDate:1:eDate  d
    .s mrId=0 f  s mrId = $o(^MRIPdaily("MRIP_DATE",lDate,mrId)) q:mrId=""  d
    ..s locDr = $p(^MRIPdaily(mrId),"^",7)
    ..i disLoc'="" q:locDr'=disLoc  //有科室入参直接判断匹配
    ..e  q:(locDr="")           //没有科室入参 过滤病区
    ..s hosp = $p(^CTLOC(locDr),"^",22)
    ..i hos'=""  q:'$d(hosArr(hosp))
 	..s detId=0 f  s detId = $o(^DHCMRIPDetail(0,"IPType",mrId,"CYRS",detId)) q:detId=""  d
 	...s admId = $p(^DHCMRIPDetail(detId),"^",1)
 	...s paBah = $$GetBAH^DHCWLAnalysisMethod(admId)
 	...i disPah '="" q:disPah'=paBah
 	...s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"PAADM",admId,wlId)) q:wlId=""  d
 	....s unit = $p(^DHCWorkLoad(wlId),"^",14)
 	....q:unit<(+dj)  //单价小于入参q
 	....s tarEc = $p(^DHCWorkLoad(wlId),"^",41)
 	....s ecDesc = $p(^DHCTarC("EC",tarEc),"^",2)
 	....s itemCate=$p(^DHCWorkLoad(wlId),"^",9)              ;医嘱子分类	
	....q:'$d(^ARC("IC",0,"OrderType","M",itemCate)) 
 	....s arcim = $p(^DHCWorkLoad(wlId),"^",2)
 	....s tarItem = $p(^DHCWorkLoad(wlId),"^",22)
 	....s qty = $p(^DHCWorkLoad(wlId),"^",15)
 	....s cost = $p(^DHCWorkLoad(wlId),"^",16)
 	....s admDoc = $p(^PAADM(admId),"^",9)
 	....s papmi = $p(^PAADM(admId),"^",1)
 	....s papName=  $$GetPaName^DHCWLAnalysisMethod(papmi)
 	....s paId = $$GetPatId^DHCWLAnalysisMethod(papmi)
 	....i paId="Null" s paId=""
 	....s itemDesc=  $p(^DHCTARI(tarItem),"^",2)
 	....s locDesc = $$GetLocDesc^DHCWLAnalysisMethod(locDr)
 	....s docDesc = $$GetDocDesc^DHCWLAnalysisMethod(admDoc)
 	....s admDate = $zd($p(^PAADM(admId),"^",6),3)
 	....s disDate = $zd(lDate,3)
 	....s uom = $p(^DHCTARI(tarItem),"^",3)
 	....s uomDesc = $p(^CT("UOM",uom),"^",2)
 	....s rea = $p($$GetInsuType^DHCWLAnalysisMethod(admId),"^",2)
    ....d outputRow1
	Quit $$$OK
	
outputRow1
 s row=$listbuild(paBah,papName,paId,admDate,disDate,locDesc,docDesc,itemDesc,uomDesc,qty,unit,cost,rea)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetMaterialInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaterialInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMaterialInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaterialInfoExecute ]
{
	n (qHandle,Row,AtEnd)
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarXcMethod","GetPatInfoCost","2019-08-05","2019-08-05","TarGrp","","","2")
Query GetPatInfoCost(startDate As %String, endDate As %String, category As %String = "TarBigXc", rea As %String, zyh As %String, hos As %String) As %Query(ROWSPEC = "paNo,paBah,paName,insu,admDate,disDate,depDesc,ecDesc,allCost:%Float") [ SqlProc ]
{
}

ClassMethod GetPatInfoCostExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, category As %String = "TarBigXc", rea As %String, zyh As %String, hos As %String) As %Status
{
	n (qHandle,startDate,endDate,category,rea,zyh,hos)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
    q:startDate="" 1
    q:endDate="" 1
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"FlagDate",lDate,wlId)) q:wlId=""  d
    ..s paType = $p(^DHCWorkLoad(wlId),"^",4)
    ..q:paType'="I"
    ..s xNod = $g(^DHCWLTarEc("tarNode"))  //取初始化节点
 	..s tarXc =$p(^DHCWorkLoad(wlId),"^",xNod)
 	..s tarCategory = $g(^DHCWLTarCategory("tarType"))_"-"_tarXc
 	..s admId = $p(^DHCWorkLoad(wlId),"^",12)
 	..s patDep = $p(^DHCWorkLoad(wlId),"^",3)
 	..s paType = $p(^DHCWorkLoad(wlId),"^",4)
 	..s cost = $p(^DHCWorkLoad(wlId),"^",16)
    ..s ^TEMPDHCWL($j,"adm",patDep,admId,paType,tarCategory) = $g(^TEMPDHCWL($j,"adm",patDep,admId,paType,tarCategory))+cost
    s dep=0 f  s dep = $o(^TEMPDHCWL($j,"adm",dep)) q:dep=""  d
    .s yq = $p(^CTLOC(dep),"^",22)
    .i hos'=""  q:hos'=yq
    .s depDesc = $$GetLocDesc^DHCWLAnalysisMethod(dep)
    .s paadm=0 f  s paadm = $o(^TEMPDHCWL($j,"adm",dep,paadm)) q:paadm=""  d
    ..s insu = $p($$GetInsuType^DHCWLAnalysisMethod(paadm),"^",2)
    ..s suId = $p($$GetInsuType^DHCWLAnalysisMethod(paadm),"^",1)
    ..i rea'="" q:rea'=suId
    ..s admDate = $zd($p(^PAADM(paadm),"^",6),3)
    ..i $p(^PAADM(paadm),"^",17)="" s disDate=""
    ..e  s disDate = $zd($p(^PAADM(paadm),"^",17),3)
    ..s paBah = $$GetBAH^DHCWLAnalysisMethod(paadm)
    ..i zyh'="" q:paBah'=zyh
    ..s papmi = $p(^PAADM(paadm),"^",1)
    ..s paName = $$GetPaName^DHCWLAnalysisMethod(papmi)
    ..s paNo = $p(^PAPER(papmi,"PAT",1),"^",2) ;$$GetPaNo^DHCWLAnalysisMethod(papmi)
    ..s type=0 f  s type = $o(^TEMPDHCWL($j,"adm",dep,paadm,type)) q:type=""  d
    ...s tarcat=0 f  s tarcat = $O(^TEMPDHCWL($j,"adm",dep,paadm,type,tarcat)) q:tarcat=""  d
    ....i category="TarXc" s ecDesc = $$GetTarType^DHCWLTarEcAnalysis(tarcat)
    ....e  i category="TarBigXc"  s ecDesc = $$GetBigTarType^DHCWLTarEcAnalysis(tarcat)
    ....e  s ecDesc = $$GetGrpTarType^DHCWLTarEcAnalysis(tarcat_"~TarXcGrp")
    ....s allCost = $g(^TEMPDHCWL($j,"adm",dep,paadm,type,tarcat))
    ....d outputRow2
	Quit $$$OK
	
outputRow2
 s row=$listbuild(paNo,paBah,paName,insu,admDate,disDate,depDesc,ecDesc,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetPatInfoCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatInfoCostExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatInfoCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfoCostExecute ]
{
	n (qHandle,Row,AtEnd)
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

}
