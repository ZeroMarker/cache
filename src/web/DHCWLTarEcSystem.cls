Class web.DHCWLTarEcSystem Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetWorkLoadInfo","2022-11-30","2022-11-30","","","","2","WorkLoad_PatDep_DR","","WorkLoad_OrdDate","WorkLoad_TarEC_Dr","","")
Query GetWorkLoadInfo(startDate As %String, endDate As %String, paadm As %String, arcId As %String, tarId As %String, HOSPID As %String, depType As %String, ctdep As %String, dateType As %String, tarType As %String, category As %Text, paType As %String) As %Query(ROWSPEC = "recDep:%String,itemOrd:%String,resDep:%String,type:%String,ordDate:%String,itemcat:%String,admId:%String,papmi:%String,qty:%Float,price:%Float,resDoc:%String,oeori:%String,taritem:%String,patDep:%String,ward:%String,patDoc:%String,flagDate:%String,arpbl:%String,paName") [ SqlProc ]
{
}

ClassMethod GetWorkLoadInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, paadm As %String, arcId As %String, tarId As %String, HOSPID As %String, depType As %String, ctdep As %String, dateType As %String, tarType As %String, category As %String, paType As %String) As %Status
{
	n (qHandle,startDate,endDate,paadm,arcId,tarId,HOSPID,depType,ctdep,dateType,tarType,category,paType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:startDate="" 1
    q:endDate="" 1
    s sDate = startDate
    s eDate = endDate
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate = sDate:1:eDate  d
    .s dateStr = $g(dateStr)_",'"_$zd(lDate,3)_"'"
    .;s dateStr = $g(dateStr)_",'"_lDate_"'"
    s fStr = $e(dateStr,2,$l(dateStr))
    s sql = "SELECT  WorkLoad_RecDep_DR,WorkLoad_ItemOrd_DR,WorkLoad_ResDep_DR,WorkLoad_Type,WorkLoad_OrdDate,WorkLoad_ItemCat_DR,WorkLoad_PAADM_DR,WorkLoad_PAPMI_DR,WorkLoad_Quantity,WorkLoad_TotalPrice,WorkLoad_ResDoc_DR,WorkLoad_ARPBL_DR,WorkLoad_OEORI_DR,WorkLoad_TarItem_DR,WorkLoad_PatDep_DR ,WorkLoad_PatWard_DR,WorkLoad_PatDoc_DR,WorkLoad_FlagDate"
    s sql = $g(sql)_" FROM DHC_WorkLoad WHERE "_dateType_ " In ("_fStr_")"
    i paadm'="" s sql =$g(sql)_" AND WorkLoad_PAADM_DR= "_paadm
    i arcId'="" s sql =$g(sql)_" AND WorkLoad_ItemOrd_DR->ARCIM_Desc like '%"_arcId_"%'"
    i tarId'="" s sql =$g(sql)_" AND WorkLoad_TarItem_DR->Tari_Desc like '%"_tarId_"%'"
    i ctdep'="" s sql =$g(sql)_" AND "_depType_"='"_ctdep_"'"
    i category'="" d
    .s cateLen = $l(category,",")
    .f catDex = 1:1:cateLen  d
    ..s catePara = $g(catePara)_","_$p(category,",",catDex)
    ..s catL = $l(catePara)
    .s catePara = $e(catePara,"2",catL)
    .s sql =$g(sql)_" AND "_tarType_" in ("_catePara_")"
    i paType'=""  d
    .s typeLen = $l(paType,",")
    .f typeDex = 1:1:typeLen  d
    ..s typePara = $g(typePara)_",'"_$p(paType,",",typeDex)_"'"
    .s typeL = $l(typePara)
    .s typePara = $e(typePara,"2",typeL)
    .s sql = $g(sql)_" AND WorkLoad_Type in ( "_typePara_" ) "
    s rs = ##class(%ResultSet).%New()
    s sc = rs.Prepare(sql)
    s sc = rs.Execute()
    while rs.Next() {
	 s recDep  = rs.Data("WorkLoad_RecDep_DR") 
	 i recDep'=""  s recDep =$p(^CTLOC(recDep),"^",2)
	 e  s recDep=""
	 s itemOrd  = rs.Data("WorkLoad_ItemOrd_DR")
	 s itemOrd = $p(^ARCIM(+itemOrd,$p(itemOrd,"||",2),1),"^",2)
	 s resDep  = rs.Data("WorkLoad_ResDep_DR")
	 s hos = $P(^CTLOC(resDep),"^",22)
	 I hos=HOSPID  d
	 .i resDep["-" s resDep = $p($p(^CTLOC(resDep),"^",2),"-",2)
	 .e  s resDep =$p(^CTLOC(resDep),"^",2)
	 .s type  = rs.Data("WorkLoad_Type")
	 .s type = $case(type,"I":"住院","E":"急诊","O":"门诊","H":"体检",:"其它")
	 .s ordDate  = rs.Data("WorkLoad_OrdDate")
	 .s itemcat  = rs.Data("WorkLoad_ItemCat_DR")
	 .s itemcat = $p(^ARC("IC",itemcat),"^",2)
	 .s admId  = rs.Data("WorkLoad_PAADM_DR")
	 .s papmi = rs.Data("WorkLoad_PAPMI_DR")
	 .s paName = $$GetPaName^DHCWLAnalysisMethod(papmi)
	 .s papmi =$P($G(^PAPER(papmi,"PAT",1)),"^",2)  ;$$GetPaNo^DHCWLAnalysisMethod(papmi)
	 .s qty  = rs.Data("WorkLoad_Quantity")
	 .s price  = rs.Data("WorkLoad_TotalPrice")
	 .s resDoc  = rs.Data("WorkLoad_ResDoc_DR")
	 .i (resDoc="")||(resDoc=0)||('$d(^CTPCP(resDoc,1)))  s resDoc=""
	 .e  s resDoc = $p(^CTPCP(resDoc,1),"^",2)
	 .s arpbl = rs.Data("WorkLoad_ARPBL_DR")
	 .s oeori  = rs.Data("WorkLoad_OEORI_DR")
	 .s taritem  = rs.Data("WorkLoad_TarItem_DR")
	 .s taritem = $p(^DHCTARI(taritem),"^",2)
	 .s patDep  = rs.Data("WorkLoad_PatDep_DR")
	 .s test =$g(test)+price
	 .i patDep["-" s patDep =$p($p(^CTLOC(patDep),"^",2),"-",2)
	 .e  s patDep = $p(^CTLOC(patDep),"^",2)
	 .s ward  = rs.Data("WorkLoad_PatWard_DR")
	 .i (ward="")!(ward=99999) s ward=""  
	 .e  s ward = $p(^CTLOC(ward),"^",2)
	 .s patDoc  = rs.Data("WorkLoad_PatDoc_DR")
	 .i (patDoc="")||(patDoc=0)||('$d(^CTPCP(patDoc,1)))  s patDoc=""
	 .e  s patDoc = $p(^CTPCP(patDoc,1),"^",2)
	 .s flagDate  = rs.Data("WorkLoad_FlagDate")
	 .d outputRow1
	 }
   
	Quit $$$OK
	
outputRow1
 s row=$listbuild(recDep,itemOrd,resDep,type,ordDate,itemcat,admId,papmi,qty,price,resDoc,oeori,taritem,patDep,ward,patDoc,flagDate,arpbl,paName)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetWorkLoadInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkLoadInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWorkLoadInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkLoadInfoExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetWorkLoadFlagInfo","2013-03-01","2013-09-01","","315||1","","2")
Query GetWorkLoadFlagInfo(startDate As %String, endDate As %String, paadm As %String, arcId As %String, tarId As %String, hosp As %String) As %Query(ROWSPEC = "recDep:%String,itemOrd:%String,resDep:%String,type:%String,ordDate:%String,itemcat:%String,admId:%String,papmi:%String,qty:%Float,price:%Float,resDoc:%String,oeori:%String,taritem:%String,patDep:%String,ward:%String,patDoc:%String,flagDate:%String,arpbl:%String") [ SqlProc ]
{
}

ClassMethod GetWorkLoadFlagInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, paadm As %String, arcId As %String, tarId As %String, hosp As %String) As %Status
{
	n (qHandle,startDate,endDate,paadm,arcId,tarId,hosp)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:startDate="" 1
    q:endDate="" 1
    ;s startDate = $zdh(startDate,3)
    ;s endDate = $zdh(endDate,3)
    s sql = "SELECT  WorkLoad_RecDep_DR,WorkLoad_ItemOrd_DR,WorkLoad_ResDep_DR,WorkLoad_Type,WorkLoad_OrdDate,WorkLoad_ItemCat_DR,WorkLoad_PAADM_DR,WorkLoad_PAPMI_DR,WorkLoad_Quantity,WorkLoad_TotalPrice,WorkLoad_ResDoc_DR,WorkLoad_ARPBL_DR,WorkLoad_OEORI_DR,WorkLoad_TarItem_DR,WorkLoad_PatDep_DR ,WorkLoad_PatWard_DR,WorkLoad_PatDoc_DR,WorkLoad_FlagDate"
    s sql = $g(sql)_" FROM DHC_WorkLoad WHERE WorkLoad_FlagDate BETWEEN '"_startDate_"' AND '"_endDate_"' "
    //AND WorkLoad_PAADM_DR=? AND WorkLoad_ItemOrd_DR=? AND WorkLoad_TarItem_DR=?
    i paadm'="" s sql =$g(sql)_" AND WorkLoad_PAADM_DR= "_paadm
    i arcId'="" s sql =$g(sql)_" AND WorkLoad_ItemOrd_DR= '"_arcId_"'"
    i tarId'="" s sql =$g(sql)_" AND WorkLoad_TarItem_DR= '"_tarId_"'"
    s rs = ##class(%ResultSet).%New()
    s sc = rs.Prepare(sql)
    s sc = rs.Execute()
    while rs.Next() {
	 s recDep  = rs.Data("WorkLoad_RecDep_DR") 
	 s recDep  =$p($p(^CTLOC(recDep),"^",2),"-",2)
	 s itemOrd  = rs.Data("WorkLoad_ItemOrd_DR")
	 s itemOrd = $p(^ARCIM(+itemOrd,$p(itemOrd,"||",2),1),"^",2)
	 s resDep  = rs.Data("WorkLoad_ResDep_DR")
	 s resDep = $p($p(^CTLOC(resDep),"^",2),"-",2)
	 s type  = rs.Data("WorkLoad_Type")
	 s type = $case(type,"I":"住院","E":"急诊","O":"门诊","H":"体检",:"其它")
	 s ordDate  = rs.Data("WorkLoad_OrdDate")
	 i ordDate'=""  s ordDate = $zd(rs.Data("WorkLoad_OrdDate"),3)
	 s itemcat  = rs.Data("WorkLoad_ItemCat_DR")
	 s admId  = rs.Data("WorkLoad_PAADM_DR")
	 s papmi = rs.Data("WorkLoad_PAPMI_DR")
	 s papmi = $$GetPaNo^DHCWLAnalysisMethod(papmi)
	 s qty  = rs.Data("WorkLoad_Quantity")
	 s price  = rs.Data("WorkLoad_TotalPrice")
	 s resDoc  = rs.Data("WorkLoad_ResDoc_DR")
	 ;s resDoc = $p(^CTPCP(resDoc,1),"^",2)
	 s arpbl = rs.Data("WorkLoad_ARPBL_DR")
	 s oeori  = rs.Data("WorkLoad_OEORI_DR")
	 s taritem  = rs.Data("WorkLoad_TarItem_DR")
	 s taritem = $p(^DHCTARI(taritem),"^",2)
	 s patDep  = rs.Data("WorkLoad_PatDep_DR")
	 s hos = $P(^CTLOC(patDep),"^",22)
	 q:hos'=hosp
	 s patDep = $p($p(^CTLOC(patDep),"^",2),"-",2)
	 s ward  = rs.Data("WorkLoad_PatWard_DR")
	 s patDoc  = rs.Data("WorkLoad_PatDoc_DR")
	 ;s patDoc = $p(^CTPCP(patDoc,1),"^",2)
	 s flagDate  = rs.Data("WorkLoad_FlagDate")
	 i flagDate'="" s flagDate = $zd(rs.Data("WorkLoad_FlagDate"),3)
	 d outputRow2
	 }
 
    
	Quit $$$OK
	
outputRow2
 s row=$listbuild(recDep,itemOrd,resDep,type,ordDate,itemcat,admId,papmi,qty,price,resDoc,oeori,taritem,patDep,ward,patDoc,flagDate,arpbl)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetWorkLoadFlagInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkLoadFlagInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWorkLoadFlagInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkLoadFlagInfoExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetICUPatInfo","2013-03-01","2013-09-01","2")
Query GetICUPatInfo(startDate As %String, endDate As %String, hosp As %String) As %Query(ROWSPEC = "locDesc:%String,paName:%String,paSex:%String,paZYH:%String,allCost:%String") [ SqlProc ]
{
}

ClassMethod GetICUPatInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosp As %String) As %Status
{
	n (qHandle,startDate,endDate,hosp)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
    q:startDate="" 1
    q:endDate="" 1
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate= sDate:1:eDate  d
    .s wlId=0 f  s wlId=  $O(^DHCWorkLoad(0,"ORDDATE",lDate,wlId)) q:wlId=""  d
    ..s paType = $p(^DHCWorkLoad(wlId),"^",4)
    ..q:paType'="I"
    ..s patDep = $p(^DHCWorkLoad(wlId),"^",3)
    ..s hos = $p(^CTLOC(patDep),"^",22)
    ..q:hosp'=hos
    ..s cost = $p(^DHCWorkLoad(wlId),"^",16)
    ..s admId = $p(^DHCWorkLoad(wlId),"^",12)
    ..s analysis = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(patDep,"TarEcDep","CTLOC")
 	..q:analysis="NULL"
 	..s ^TEMPDHCWL($j,"icucost",patDep,admId) = $g(^TEMPDHCWL($j,"icucost",patDep,admId))+cost
 	s loc=0 f  s loc = $o(^TEMPDHCWL($j,"icucost",loc)) q:loc=""  d
 	.s locDesc = $$GetLocDesc^DHCWLAnalysisMethod(loc)
 	.s paadm = 0 s paadm = $o(^TEMPDHCWL($j,"icucost",loc,paadm)) q:paadm=""  d
 	..s papmi = $p(^PAADM(paadm),"^",1)
 	..s paName = $$GetPaName^DHCWLAnalysisMethod(papmi)
 	..s paSex = $$GetSexDesc^DHCWLAnalysisMethod(papmi)
 	..s paZYH= $$GetpaBAH^DHCWLAnalysisMethod(papmi)
 	..s allCost = $g(^TEMPDHCWL($j,"icucost",loc,paadm))
    ..d outputRow3
	Quit $$$OK
	
outputRow3
 s row=$listbuild(locDesc,paName,paSex,paZYH,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetICUPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICUPatInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICUPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICUPatInfoExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetICUFlagPat","2013-03-01","2013-09-01","2")
Query GetICUFlagPat(startDate As %String, endDate As %String, hosp As %String) As %Query(ROWSPEC = "locDesc:%String,paName:%String,paSex:%String,paZYH:%String,allCost:%String") [ SqlProc ]
{
}

ClassMethod GetICUFlagPatExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosp As %String) As %Status
{
	n (qHandle,startDate,endDate,hosp)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
    q:startDate="" 1
    q:endDate="" 1
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate= sDate:1:eDate  d
    .s wlId=0 f  s wlId=  $O(^DHCWorkLoad(0,"FlagDate",lDate,wlId)) q:wlId=""  d
    ..s paType = $p(^DHCWorkLoad(wlId),"^",4)
    ..q:paType'="I"
    ..s patDep = $p(^DHCWorkLoad(wlId),"^",3)
    ..s hos = $p(^CTLOC(patDep),"^",22)
    ..q:hosp'=hos
    ..s cost = $p(^DHCWorkLoad(wlId),"^",16)
    ..s admId = $p(^DHCWorkLoad(wlId),"^",12)
    ..s analysis = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(patDep,"TarEcDep","CTLOC")
 	..q:analysis="NULL"
 	..s ^TEMPDHCWL($j,"icucost",patDep,admId) = $g(^TEMPDHCWL($j,"icucost",patDep,admId))+cost
 	s loc=0 f  s loc = $o(^TEMPDHCWL($j,"icucost",loc)) q:loc=""  d
 	.s locDesc = $$GetLocDesc^DHCWLAnalysisMethod(loc)
 	.s paadm = 0 s paadm = $o(^TEMPDHCWL($j,"icucost",loc,paadm)) q:paadm=""  d
 	..s papmi = $p(^PAADM(paadm),"^",1)
 	..s paName = $$GetPaName^DHCWLAnalysisMethod(papmi)
 	..s paSex = $$GetSexDesc^DHCWLAnalysisMethod(papmi)
 	..s paZYH= $$GetpaBAH^DHCWLAnalysisMethod(papmi)
 	..s allCost = $g(^TEMPDHCWL($j,"icucost",loc,paadm))
    ..d outputRow4
	Quit $$$OK
	
outputRow4
 s row=$listbuild(locDesc,paName,paSex,paZYH,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetICUFlagPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICUFlagPatExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICUFlagPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICUFlagPatExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetHumPerCost","2018-07-31","2018-07-31","TarEc","1")
Query GetHumPerCost(startDate As %String, endDate As %String, ec As %String, hosp As %String) As %Query(ROWSPEC = "paadm:%String,paper:%String,depDesc:%String,ectype:%String,ecCost:%Float,rc:%Integer,rt:%Integer") [ SqlProc ]
{
}

ClassMethod GetHumPerCostExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, ec As %String, hosp As %String) As %Status
{
	n (qHandle,startDate,endDate,ec,hosp)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^TEMPDHCWL($j)
    q:startDate="" 1
    q:endDate="" 1
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"ORDDATE",lDate,wlId)) q:wlId=""  d
    ..s paType= $p(^DHCWorkLoad(wlId),"^",4)
    ..q:paType="I"
    ..s admId = $p(^DHCWorkLoad(wlId),"^",12)
    ..s tarEc = $p(^DHCWorkLoad(wlId),"^",41)
    ..s tarEcDesc = $p(^DHCTarC("EC",tarEc),"^",2)
    ..s tarC = $p(^DHCTarC("EC",tarEc),"^",3)
    ..s tarCDesc = $p( ^DHCTarC("TEC",tarC),"^",2)
    ..s patDep = $p(^DHCWorkLoad(wlId),"^",3)
    ..s hos = $P(^CTLOC(patDep),"^",22)
    ..q:hos'=hosp
    ..s cost = $p(^DHCWorkLoad(wlId),"^",16)
    ..s ^TEMPDHCWL($j,"admId",patDep,admId) = $g(^TEMPDHCWL($j,"admId",patDep,admId))+cost
    ..i ec="TarEc"  d
    ...s ^TEMPDHCWL($j,"admId",patDep,admId,tarEcDesc) = $g(^TEMPDHCWL($j,"admId",patDep,admId,tarEcDesc))+cost
    ..e  i ec = "TarBigEc"  d
    ...s ^TEMPDHCWL($j,"admId",patDep,admId,tarCDesc) = $g(^TEMPDHCWL($j,"admId",patDep,admId,tarCDesc))+cost
    ..e  i ec = "TarEcGrp" d
    ...s taremc =  ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(tarEc,"TarEcGrp","TAREC")
    ...s taremc = $p(taremc,"^",1)
    ...s ^TEMPDHCWL($j,"admId",patDep,admId,taremc) = $g(^TEMPDHCWL($j,"admId",patDep,admId,taremc))+cost
    s dep=0 f  s dep = $o(^TEMPDHCWL($j,"admId",dep)) q:dep=""  d
    .s depDesc = $$GetLocDesc^DHCWLAnalysisMethod(dep)
    .s paadm = 0 f  s paadm = $o(^TEMPDHCWL($j,"admId",dep,paadm)) q:paadm=""  d
    ..q:$g(^TEMPDHCWL($j,"admId",dep,paadm))<=0
    ..s paper = $p(^PAADM(paadm),"^",1)
    ..s ectype =0 f  s ectype = $O(^TEMPDHCWL($j,"admId",dep,paadm,ectype)) q:ectype=""  d
    ...s ^TEMPDHCWL($j,"pat",dep,paadm)=$g(^TEMPDHCWL($j,"pat",dep,paadm))+1
    ...s ^TEMPDHCWL($j,"per",dep,paper)=$g(^TEMPDHCWL($j,"per",dep,paper))+1
    ...s ecCost = $g(^TEMPDHCWL($j,"admId",dep,paadm,ectype))
    ...s alrc = $g(^TEMPDHCWL($j,"pat",dep,paadm))
    ...s rc = $case(alrc,1:1,:0)
    ...s alrt = $g(^TEMPDHCWL($j,"per",dep,paper))
    ...s rt = $case(alrt,1:1,:0)
    ...d outputRow5
	Quit $$$OK
	
outputRow5
 s row=$listbuild(paadm,paper,depDesc,ectype,ecCost,rc,rt)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetHumPerCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHumPerCostExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHumPerCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHumPerCostExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetHumPerFlagCost","2013-03-01","2013-09-01","TarEc","2")
Query GetHumPerFlagCost(startDate As %String, endDate As %String, ec As %String, hosp As %String) As %Query(ROWSPEC = "paadm:%String,depDesc:%String,ectype:%String,ecCost:%Float") [ SqlProc ]
{
}

ClassMethod GetHumPerFlagCostExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, ec As %String, hosp As %String) As %Status
{
 n (qHandle,startDate,endDate,ec,hosp)
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
    ..s paType= $p(^DHCWorkLoad(wlId),"^",4)
    ..q:paType="I"
    ..s admId = $p(^DHCWorkLoad(wlId),"^",12)
    ..s tarEc = $p(^DHCWorkLoad(wlId),"^",41)
    ..s tarEcDesc = $p(^DHCTarC("EC",tarEc),"^",2)
    ..s tarC = $p(^DHCTarC("EC",tarEc),"^",3)
    ..s tarCDesc = $p( ^DHCTarC("TEC",tarC),"^",2)
    ..s patDep = $p(^DHCWorkLoad(wlId),"^",3)
    ..s hos = $P(^CTLOC(patDep),"^",22)
    ..q:hos'=hosp
    ..s cost = $p(^DHCWorkLoad(wlId),"^",16)
    ..s ^TEMPDHCWL($j,"admId",patDep,admId) = $g(^TEMPDHCWL($j,"admId",patDep,admId))+cost
    ..i ec="TarEc"  d
    ...s ^TEMPDHCWL($j,"admId",patDep,admId,tarEcDesc) = $g(^TEMPDHCWL($j,"admId",patDep,admId,tarEcDesc))+cost
    ..e  i ec = "TarBigEc"  d
    ...s ^TEMPDHCWL($j,"admId",patDep,admId,tarCDesc) = $g(^TEMPDHCWL($j,"admId",patDep,admId,tarCDesc))+cost
    ..e  i ec = "TarEcGrp" d
    ...s taremc =  ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(tarEc,"TarEcGrp","TAREC")
    ...s taremc = $p(taremc,"^",1)
    ...s ^TEMPDHCWL($j,"admId",patDep,admId,taremc) = $g(^TEMPDHCWL($j,"admId",patDep,admId,taremc))+cost
    s dep=0 f  s dep = $o(^TEMPDHCWL($j,"admId",dep)) q:dep=""  d
    .s depDesc = $$GetLocDesc^DHCWLAnalysisMethod(dep)
    .s paadm = 0 f  s paadm = $o(^TEMPDHCWL($j,"admId",dep,paadm)) q:paadm=""  d
    ..q:$g(^TEMPDHCWL($j,"admId",dep,paadm))=0
    ..s ectype =0 f  s ectype = $O(^TEMPDHCWL($j,"admId",dep,paadm,ectype)) q:ectype=""  d
    ...s ecCost = $g(^TEMPDHCWL($j,"admId",dep,paadm,ectype))
    ...d outputRow6
	Quit $$$OK
	
outputRow6
 s row=$listbuild(paadm,depDesc,ectype,ecCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetHumPerFlagCostClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHumPerFlagCostExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHumPerFlagCostFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHumPerFlagCostExecute ]
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

// d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetZRICU","2018-07-03","2018-07-10")

Query GetZRICU(startDate As %String, endDate As %String) As %Query(ROWSPEC = "admId:%String,djh:%String,paName:%String,resDep:%String,ordDoc:%String,patLoc:%String,lDate:%String,beginTime:%String,disDate:%String,tzcDate:%String,tzcTime:%String,disTime:%String,inDateTime:%String,tzcDateTime:%String,disDateTime:%String,allCost:%Float") [ SqlProc ]
{
}

ClassMethod GetZRICUExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	n (qHandle,startDate,endDate)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" 1
 	q:endDate="" 1
 	s sDate = $zdh(startDate,3)
 	s eDate = $zdh(endDate,3)
 	;s sDate = startDate
 	;s eDate = endDate
 	s sql = "SELECT sum(WorkLoad_TotalPrice) allCost, WorkLoad_PAADM_DR admId,WorkLoad_ResDep_DR patDep FROM DHC_WorkLoad WHERE WorkLoad_FlagDate BETWEEN ? AND ? AND WorkLoad_Type='I'  GROUP BY WorkLoad_PAADM_DR HAVING  sum(WorkLoad_TotalPrice)>0"
 	s rs = ##class(%ResultSet).%New()
 	s sc = rs.Prepare(sql)
 	s sc = rs.Execute(sDate,eDate)
	 while rs.Next() {
	 s patDep = rs.Data("patDep")
	 s admId = rs.Data("admId") 
	 s detId=0 f  s detId = $o(^DHCMRIPDetail(0,"TYPE","ZRKS","ADM",admId,detId)) q:detId=""  d  //看这个人有没有转入ICU的转科记录
	 .;q:admId'="3209330"
	 .s mripday = $P(^DHCMRIPDetail(detId),"^",3)
     .s locDr = $P(^MRIPdaily(mripday),"^",7)
     .;q:locDr'="161"  //不是转入ICU的 q
     .s analysis = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(locDr,"ICU","CTLOC")
     .q:analysis="NULL"
	 .s flag=0
 	 .s papmi = $p(^PAADM(admId),"^",1)
 	 .s djh = $$GetPaNo^DHCWLAnalysisMethod(papmi)
     .s paName = $$GetPaName^DHCWLAnalysisMethod(papmi)
     .s lDate = $P(^MRIPdaily(mripday),"^",6)
     .s sub = 0 f  s sub = $o(^PAADM(admId,"TRANS",sub)) q:sub=""  d
 	 ..s ctloc = $p(^PAADM(admId,"TRANS",sub),"^",6)  //取转科记录中的科室
 	 ..q:ctloc=""   //为空的记录q
 	 ..;q:ctloc'=161
 	 ..s analysis1 = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(ctloc,"ICU","CTLOC")
     ..q:analysis1="NULL"
 	 ..s beginDate =  $p(^PAADM(admId,"TRANS",sub),"^",1)
 	 ..s beginTime = $p(^PAADM(admId,"TRANS",sub),"^",2)
 	 ..s disDate = $p(^PAADM(admId),"^",17)
 	 ..s disTime  = $p(^PAADM(admId),"^",18)
 	 ..i disDate'="" s disDate = $zd($g(disDate),3)
 	 ..i disTime'=""  s disTime = $zt($g(disTime),1)
 	 .s flag=0,tzcDate="",tzcTime=""
 	 .s zcDate=0 f  s zcDate = $o(^PAADMi("TransDateTime",zcDate)) q:zcDate=""  d
 	 ..q:beginDate>=zcDate //在记录的转入时间之前的q
 	 ..s zcTime = 0 f  s zcTime = $o(^PAADMi("TransDateTime",zcDate,zcTime)) q:zcTime=""  d
 	 ...s zcSub = 0 f  s zcSub = $o(^PAADMi("TransDateTime",zcDate,zcTime,admId,zcSub)) q:zcSub=""  d
 	 ....q:flag'=0
 	 ....s loc = $p(^PAADM(admId,"TRANS",zcSub),"^",6) 
 	 ....q:loc=""
 	 ....;q:loc=161
 	 ....s analysis1 = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(ctloc,"ICU","CTLOC")
     ....q:analysis1'="NULL"
 	 ....s zcDate = $p(^PAADM(admId,"TRANS",zcSub),"^",1)
 	 ....s zcTime = $p(^PAADM(admId,"TRANS",zcSub),"^",2)
 	 ....i (zcDate '="")&&(tzcDate="") s tzcDate = $zd(zcDate,3)
 	 ....i (zcTime '="")&&(tzcTime="") s tzcTime = $zt(zcTime,1)
 	 ....i tzcDate'=""&&tzcTime'="" d
 	 .....s flag=1
 	 .s wlId = 0 f  s wlId = $o(^DHCWorkLoad(0,"PAADM",admId,wlId)) q:wlId=""  d
 	 ..;q:admId'="3209330"
 	 ..s itemCate=$p(^DHCWorkLoad(wlId),"^",9)              ;医嘱子分类	
	 ..;q:itemCate'="105"  //无费用转科医嘱子类
	 ..s analysis2 = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(itemCate,"transcat","ARCIC")
     ..q:analysis2="NULL"
	 ..s inDateTime="",tzcDateTime="",disDateTime=""
	 ..s inDateTime=$zd(lDate,3)_" "_$zt(beginTime,1)
	 ..s tzcDateTime=tzcDate_" "_tzcTime
	 ..s disDateTime=disDate_" "_disTime
	 ..s ordDate = $p(^DHCWorkLoad(wlId),"^",5)  
	 ..s ordTime = $p(^DHCWorkLoad(wlId),"^",6)  
	 ..q:beginDate'=ordDate
	 ..q:ordTime>beginTime
	 ..;i (tzcTime'="")&&($zth(tzcTime,1)<ordTime) s tzcDate="" , tzcTime=""
	 ..s ordDoc = $$GetDocDesc^DHCWLAnalysisMethod($p(^DHCWorkLoad(wlId),"^",19))
	 ..s resDep =  $$GetLocDesc^DHCWLAnalysisMethod($p(^DHCWorkLoad(wlId),"^",23))
	 ..;q:resDep["重症医学科"
	 ..s analysis3 = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(resDep,"ICU","CTLOC")
     ..q:analysis3'="NULL"
     .s grpId = $o(^DHCWL.CodeCfg.GroupI("Code"," ICU",""))
     .s locrId = 0  f  s locrId = $o(^DHCWL.CodeCfg.SubGroupItemI("Grp",grpId,locrId)) q:locrId=""  d
	 ..s locbid = $tr(locrId," ","")
	 ..s locStr = $g(locStr)_","_locbid  
	 .s len = $l(locStr)
	 .s locStr = $e(locStr,2,len)
	 .;q:admId'="3209330"
	 .s sql1 = "SELECT WorkLoad_ResDep_DR brloc, sum(WorkLoad_TotalPrice) icuCost FROM DHC_WorkLoad WHERE WorkLoad_PAADM_DR="_admId_" AND WorkLoad_ResDep_DR in ("_locStr_") GROUP BY WorkLoad_ResDep_DR"
 	 .s rs1 = ##class(%ResultSet).%New()
 	 .s sc1 = rs1.Prepare(sql1)
 	 .s sc1 = rs1.Execute()
 	 .while rs1.Next() { s allCost = rs1.Data("icuCost"), brloc = rs1.Data("brloc"), brDesc = $p($p(^CTLOC(brloc),"^",2),"-",2) d outputRow7}
 	 .;d outputRow7  //如果先转其它科再转icu,会产生两条记录,取最后一条所以放到循环外
	 }
	 
 	
	Quit $$$OK
	
outputRow7
 s row=$listbuild(admId,djh,paName,resDep,ordDoc,brDesc,$zd(lDate,3),$zt(beginTime,1),disDate,tzcDate,tzcTime,disTime,inDateTime,tzcDateTime,disDateTime,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetZRICUClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZRICUExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetZRICUFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZRICUExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetOperCostInfo","2018-07-19","2018-07-24",1)
Query GetOperCostInfo(startDate As %String, endDate As %String, hosp As %String) As %Query(ROWSPEC = "depDesc:%String,opName:%String,ecDesc:%String,allCost:%Float") [ SqlProc ]
{
}

ClassMethod GetOperCostInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosp As %String) As %Status
{
	n (qHandle,startDate,endDate,hosp)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" 1
 	q:endDate="" 1
 	s sDate = $zdh(startDate,3)
 	s eDate = $zdh(endDate,3)
 	k ^TEMPDHCWL($j)
 	f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"ORDDATE",lDate,wlId)) q:wlId=""  d
    ..s arcim =  $p(^DHCWorkLoad(wlId),"^",2) 
 	..s analysis = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(arcim,"Notification","ARCIM")
 	..q:analysis="NULL"
 	..s patDep = $p(^DHCWorkLoad(wlId),"^",3) 
 	..s hos = $p(^CTLOC(patDep),"^",22)
 	..q:hos'=hosp
 	..s admId = $p(^DHCWorkLoad(wlId),"^",12)
 	..;q:admId'="3519505" 
 	..s oeitem = $p(^DHCWorkLoad(wlId),"^",21)
 	..;s notes = $p(^OEORD(+oeitem,"I",$p(oeitem,"||",2),"DEP"),"^")
 	..q:'$d(^OEORD(+oeitem,"I",$p(oeitem,"||",2),4))
 	..s oranaes = $p(^OEORD(+oeitem,"I",$p(oeitem,"||",2),4),"^",9)  //麻醉表
 	..s arrId=0 f  s arrId = $o(^DHCANOPArrange(0,"Adm",admId,arrId)) q:arrId=""  d
 	...s arranaes = $p(^DHCANOPArrange(arrId),"^",2) //排班表中指向麻醉表
 	...q:arranaes'=oranaes
 	...s patDep=$p(^DHCANOPArrange(arrId),"^",21)  //病人科室
 	...s andubDr=$p(arranaes,"||",2)
 	...s anamethod=$p(^OR(admId,"ANA",andubDr),"^",5)    ;麻醉方式  OR_Anaesthesia->ANA_Method 
 	...s anateacher=$p(^OR(admId,"ANA",andubDr),"^",6)       ;麻醉师 
 	...s anachild=0 s anachild=$o(^OR(admId,"ANA",andubDr,"OP",anachild)) q:anachild=""    ;手术表OR_Anaest_Operation中取手术信息
 	...s operName=+$p(^OR(admId,"ANA",andubDr,"OP",anachild),"^",6)  //手术名
 	...s operDoc=+$p(^OR(admId,"ANA",andubDr,"OP",anachild),"^",8)      ;主刀医生
 	...s wlId1=0 f  s wlId1=  $O(^DHCWorkLoad(0,"PAADM",admId,wlId1)) q:wlId1=""  d
 	....s tarEc1 =$P(^DHCWorkLoad(wlId1),"^",41)
 	....s analysis1 = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(tarEc1,"OperTarEc","TarEC")  //过滤手术核算分类
 	....q:analysis1="NULL"
 	....s cost = $p(^DHCWorkLoad(wlId1),"^",16)
 	....s ^TEMPDHCWL($j,"admId",admId,patDep,operName,tarEc1)  =$g(^TEMPDHCWL($j,"admId",admId,patDep,operName,tarEc1))+cost
 	s paadm=0 f  s paadm = $o(^TEMPDHCWL($j,"admId",paadm)) q:paadm=""  d
 	.s dep = 0 f  s dep = $o(^TEMPDHCWL($j,"admId",paadm,dep)) q:dep=""  d
 	..s depDesc = $$GetLocDesc^DHCWLAnalysisMethod(dep)
 	..s name=0 f  s name = $O(^TEMPDHCWL($j,"admId",paadm,dep,name)) q:name=""  d
 	...s opName = $p(^ORC("OPER",name),"^",2)
 	...s ec = 0 f  s ec = $O(^TEMPDHCWL($j,"admId",paadm,dep,name,ec)) q:ec=""  d
 	....s ecDesc = $p(^DHCTarC("EC",ec),"^",2)
 	....s allCost =$g(^TEMPDHCWL($j,"admId",paadm,dep,name,ec))
 	....d outputRow8
	Quit $$$OK
	
outputRow8
 s row=$listbuild(depDesc,opName,ecDesc,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOperCostInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperCostInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperCostInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperCostInfoExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetOperFeeInfo","2018-07-19","2018-07-24")
Query GetOperFeeInfo(startDate As %String, endDate As %String, hosp As %String) As %Query(ROWSPEC = "patDesc:%String,resDesc:%String,recDesc:%String,arcDesc:%String,ecDesc:%String,allCost:%Float") [ SqlProc ]
{
}

ClassMethod GetOperFeeInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hosp As %String) As %Status
{
	n (qHandle,startDate,endDate,hosp,hosp)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" 1
 	q:endDate="" 1
 	s sDate = $zdh(startDate,3)
 	s eDate = $zdh(endDate,3)
 	k ^TEMPDHCWL($j)
 	f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"ORDDATE",lDate,wlId)) q:wlId=""  d
 	..s tarEc =$P(^DHCWorkLoad(wlId),"^",41)
 	..s analysis = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(tarEc1,"OperTarEc","TarEC")  //过滤手术核算分类
 	..q:analysis="NULL"
 	..s patDep =$P(^DHCWorkLoad(wlId),"^",3)
 	..s hos = $p(^CTLOC(patDep),"^",22)
 	..q:hos'=hosp
 	..s resDep =$P(^DHCWorkLoad(wlId),"^",23)
 	..s recDep =$P(^DHCWorkLoad(wlId),"^",1) 
 	..s arcim = $P(^DHCWorkLoad(wlId),"^",2) 
 	..s cost = $p(^DHCWorkLoad(wlId),"^",16)
 	..s ^TEMPDHCWL($j,"admId",patDep,resDep,recDep,arcim,tarEc)  =$g(^TEMPDHCWL($j,"admId",patDep,resDep,recDep,arcim,tarEc))+cost
 	s pat=0 f  s pat = $O(^TEMPDHCWL($j,"admId",pat)) q:pat=""  d
 	.s patDesc =$p( $P(^CTLOC(pat),"^",2),"-",2)
 	.s res=0 f  s res = $o(^TEMPDHCWL($j,"admId",pat,res)) q:res=""  d
 	..s resDesc =$p( $P(^CTLOC(res),"^",2),"-",2)
 	..s rec=0 f  s rec = $o(^TEMPDHCWL($j,"admId",pat,res,rec)) q:rec=""  d
 	...s recDesc =$p( $P(^CTLOC(rec),"^",2),"-",2)
 	...s arc=0  f  s arc=$o(^TEMPDHCWL($j,"admId",pat,res,rec,arc)) q:arc=""  d
 	....s arcDesc = $p(^ARCIM(+arc,$p(arc,"||",2),1),"^",2)
 	....s ec=0 f  s ec = $o(^TEMPDHCWL($j,"admId",pat,res,rec,arc,ec)) q:ec=""  d
 	.....s ecDesc = $p(^DHCTarC("EC",ec),"^",2)
 	.....s allCost = $g(^TEMPDHCWL($j,"admId",pat,res,rec,arc,ec))
 	.....d outputRow9
	Quit $$$OK
	
outputRow9
 s row=$listbuild(patDesc,resDesc,recDesc,arcDesc,ecDesc,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOperFeeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperFeeInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperFeeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperFeeInfoExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetZZJHInfo","2018-07-05","2018-07-05","1")
Query GetZZJHInfo(startDate As %String, endDate As %String, hos As %String) As %Query(ROWSPEC = "adm:%String,bah:%String,stDate:%String,stTime:%String,chlocDesc:%String,upLocDesc:%String,ecDesc:%String,cost:%Float") [ SqlProc ]
{
}

ClassMethod GetZZJHInfoExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hos As %String) As %Status
{
	n (qHandle,startDate,endDate,hos)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" 1
 	q:endDate="" 1
 	s sDate = $zdh(startDate,3)
 	s eDate = $zdh(endDate,3)
 	k ^TEMPDHCWL($j)
 	f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"FlagDate",lDate,wlId)) q:wlId=""  d
    ..s admId = $p(^DHCWorkLoad(wlId),"^",12)
    ..;q:admId'="3432578"
    ..s cost =$p(^DHCWorkLoad(wlId),"^",16)
    ..s ^TEMPDHCWL($j,"flagnum",admId)= $g(^TEMPDHCWL($j,"flagnum",admId))+cost
    s paadm=0 f  s paadm = $o(^TEMPDHCWL($j,"flagnum",paadm)) q:paadm=""  d
    .s num=1
    .q:$g(^TEMPDHCWL($j,"flagnum",paadm))<=0
    .s transId=0 f  s transId = $o(^PAADM(paadm,"TRANS",transId)) q:transId=""  d
    ..s traloc = $p(^PAADM(paadm,"TRANS",transId),"^",6)
    ..s tradoc = $p(^PAADM(paadm,"TRANS",transId),"^",5)
    ..q:(""=tradoc)!(""=traloc)
    ..;s iculoc = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(traloc,"ICU","CTLOC")
    ..;q:iculoc="NULL"  //不是ICU
    ..s trasDate = $p(^PAADM(paadm,"TRANS",transId),"^",1)
    ..s trasTime = $p(^PAADM(paadm,"TRANS",transId),"^",2)
    ..s ^TEMPDHCWL($j,"transInfo",paadm,trasDate,trasTime,traloc)=num  //存入所有不为空的信息
    ..s ^TEMPDHCWL($j,"transloc",paadm,num)=traloc
    ..s num = $g(num)+1
    s adm=0 f  s adm = $o(^TEMPDHCWL($j,"transInfo",adm)) q:adm=""  d
    .s tempLoc=""
    .s stDate=0 f  s stDate = $o(^TEMPDHCWL($j,"transInfo",adm,stDate)) q:stDate=""  d
    ..s stTime = 0 f  s stTime = $o(^TEMPDHCWL($j,"transInfo",adm,stDate,stTime)) q:stTime=""  d
    ...s chloc=0 f  s chloc = $o(^TEMPDHCWL($j,"transInfo",adm,stDate,stTime,chloc)) q:chloc=""  d
    ....s chhos = $p(^CTLOC(chloc),"^",22)
    ....q:hos'[chhos
    ....s allCost=0
    ....s chlocDesc = $p($p(^CTLOC(chloc),"^",2),"-",2)
    ....s iculoc = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(chloc,"ICU","CTLOC")
    ....q:iculoc="NULL"  //不是ICU
    ....s count = $g(^TEMPDHCWL($j,"transInfo",adm,stDate,stTime,chloc))
    ....s count = count-1
    ....s upLoc = $g(^TEMPDHCWL($j,"transloc",adm,count))  //转出的科室
    ....q:upLoc=""
    ....q:tempLoc=upLoc
    ....s tempLoc = chloc
    ....s upLocDesc = $p($p(^CTLOC(upLoc),"^",2),"-",2)
    ....;w adm_","_stDate_","_stTime_","_chloc_","_upLoc,!
    ....s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"PAADM",adm,wlId) ) q:wlId=""  d
    .....s patDep = $p(^DHCWorkLoad(wlId),"^",3)
    .....q:patDep'=chloc
    .....s cost = $p(^DHCWorkLoad(wlId),"^",16)
    .....s tarEc = $p(^DHCWorkLoad(wlId),"^",41)
    .....s tarbEc = $p(^DHCTarC("EC",tarEc),"^",3)
    .....s ecDesc = $p(^DHCTarC("TEC",tarbEc),"^",2)
    .....s ^TEMPDHCWL($j,"end",adm,stDate,stTime,chlocDesc,upLocDesc,ecDesc)=$g(^TEMPDHCWL($j,"end",adm,stDate,stTime,chlocDesc,upLocDesc,ecDesc))+cost
 	s jzh=0 f  s jzh = $o( ^TEMPDHCWL($j,"end",jzh)) q:jzh=""  d
 	.s bah = $$GetBAH^DHCWLAnalysisMethod(jzh)
 	.s tDate=0 f  s tDate = $o(^TEMPDHCWL($j,"end",jzh,tDate)) q:tDate=""  d
 	..s tTime =0 f  s tTime = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime)) q:tTime=""  d
 	...s locDesc = 0 f  s locDesc = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc)) q:locDesc=""  d
 	....s upDesc =0 f  s upDesc = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc,upDesc)) q:upDesc=""  d
 	.....s tarDesc=0 f  s tarDesc = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc,upDesc,tarDesc)) q:tarDesc=""  d
 	......s allCost = $g(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc,upDesc,tarDesc))
 	......d outputRow10
	Quit $$$OK
	
outputRow10
 s row=$listbuild(jzh,bah,tDate,tTime,locDesc,upDesc,tarDesc,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetZZJHInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZZJHInfoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetZZJHInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZZJHInfoExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetOrdZR","2018-08-14","2018-08-14","1")
Query GetOrdZR(startDate As %String, endDate As %String, hos As %String) As %Query(ROWSPEC = "adm:%String,bah:%String,stDate:%String,stTime:%String,chlocDesc:%String,upLocDesc:%String,ecDesc:%String,cost:%Float") [ SqlProc ]
{
}

ClassMethod GetOrdZRExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hos As %String) As %Status
{
	n (qHandle,startDate,endDate,hos)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" 1
 	q:endDate="" 1
 	s sDate = $zdh(startDate,3)
 	s eDate = $zdh(endDate,3)
 	k ^TEMPDHCWL($j)
 	f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"ORDDATE",lDate,wlId)) q:wlId=""  d
    ..s admId = $p(^DHCWorkLoad(wlId),"^",12)
    ..s cost =$p(^DHCWorkLoad(wlId),"^",16)
    ..s ^TEMPDHCWL($j,"flagnum",admId)= $g(^TEMPDHCWL($j,"flagnum",admId))+cost
    s paadm=0 f  s paadm = $o(^TEMPDHCWL($j,"flagnum",paadm)) q:paadm=""  d
    .s num=1
    .q:$g(^TEMPDHCWL($j,"flagnum",paadm))<=0
    .s transId=0 f  s transId = $o(^PAADM(paadm,"TRANS",transId)) q:transId=""  d
    ..s traloc = $p(^PAADM(paadm,"TRANS",transId),"^",6)
    ..s tradoc = $p(^PAADM(paadm,"TRANS",transId),"^",5)
    ..q:(""=tradoc)!(""=traloc)
    ..;s iculoc = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(traloc,"ICU","CTLOC")
    ..;q:iculoc="NULL"  //不是ICU
    ..s trasDate = $p(^PAADM(paadm,"TRANS",transId),"^",1)
    ..s trasTime = $p(^PAADM(paadm,"TRANS",transId),"^",2)
    ..s ^TEMPDHCWL($j,"transInfo",paadm,trasDate,trasTime,traloc)=num  //存入所有不为空的信息
    ..s ^TEMPDHCWL($j,"transloc",paadm,num)=traloc
    ..s num = $g(num)+1
    s adm=0 f  s adm = $o(^TEMPDHCWL($j,"transInfo",adm)) q:adm=""  d
    .s tempLoc=""
    .s stDate=0 f  s stDate = $o(^TEMPDHCWL($j,"transInfo",adm,stDate)) q:stDate=""  d
    ..s stTime = 0 f  s stTime = $o(^TEMPDHCWL($j,"transInfo",adm,stDate,stTime)) q:stTime=""  d
    ...s chloc=0 f  s chloc = $o(^TEMPDHCWL($j,"transInfo",adm,stDate,stTime,chloc)) q:chloc=""  d
    ....s chhos = $p(^CTLOC(chloc),"^",22)
    ....q:hos'[chhos
    ....s allCost=0
    ....s chlocDesc = $p($p(^CTLOC(chloc),"^",2),"-",2)
    ....s iculoc = ##class(DHCWL.CodeCfgData.FunctionModule).GetSubGrpByItemDr(chloc,"ICU","CTLOC")
    ....q:iculoc="NULL"  //不是ICU
    ....s count = $g(^TEMPDHCWL($j,"transInfo",adm,stDate,stTime,chloc))
    ....s count = count-1
    ....s upLoc = $g(^TEMPDHCWL($j,"transloc",adm,count))  //转出的科室
    ....q:upLoc=""
    ....q:tempLoc=upLoc
    ....s tempLoc = chloc
    ....s upLocDesc = $p($p(^CTLOC(upLoc),"^",2),"-",2)
    ....;w adm_","_stDate_","_stTime_","_chloc_","_upLoc,!
    ....s wlId=0 f  s wlId = $o(^DHCWorkLoad(0,"PAADM",adm,wlId) ) q:wlId=""  d
    .....s patDep = $p(^DHCWorkLoad(wlId),"^",3)
    .....q:patDep'=chloc
    .....s ordDate = $p(^DHCWorkLoad(wlId),"^",5)
    .....q:(ordDate<sDate)!(ordDate>eDate)
    .....s cost = $p(^DHCWorkLoad(wlId),"^",16)
    .....s tarEc = $p(^DHCWorkLoad(wlId),"^",41)
    .....s tarbEc = $p(^DHCTarC("EC",tarEc),"^",3)
    .....s ecDesc = $p(^DHCTarC("TEC",tarbEc),"^",2)
    .....s ^TEMPDHCWL($j,"end",adm,stDate,stTime,chlocDesc,upLocDesc,ecDesc)=$g(^TEMPDHCWL($j,"end",adm,stDate,stTime,chlocDesc,upLocDesc,ecDesc))+cost
 	s jzh=0 f  s jzh = $o( ^TEMPDHCWL($j,"end",jzh)) q:jzh=""  d
 	.s bah = $$GetBAH^DHCWLAnalysisMethod(jzh)
 	.s tDate=0 f  s tDate = $o(^TEMPDHCWL($j,"end",jzh,tDate)) q:tDate=""  d
 	..s tTime =0 f  s tTime = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime)) q:tTime=""  d
 	...s locDesc = 0 f  s locDesc = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc)) q:locDesc=""  d
 	....s upDesc =0 f  s upDesc = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc,upDesc)) q:upDesc=""  d
 	.....s tarDesc=0 f  s tarDesc = $o(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc,upDesc,tarDesc)) q:tarDesc=""  d
 	......s allCost = $g(^TEMPDHCWL($j,"end",jzh,tDate,tTime,locDesc,upDesc,tarDesc))
 	......d outputRow11
	Quit $$$OK
	
outputRow11
 s row=$listbuild(jzh,bah,tDate,tTime,locDesc,upDesc,tarDesc,allCost)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetOrdZRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdZRExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdZRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdZRExecute ]
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

/// 根据统计子组维护的 和 具体明细项目 是否缺失
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","GetColGrpNo","CUREDRUG")
Query GetColGrpNo(group As %String) As %Query(ROWSPEC = "num:%Integer,groupId:%String,group:%String,qsitem:%String") [ SqlProc ]
{
}

ClassMethod GetColGrpNoExecute(ByRef qHandle As %Binary, group As %String) As %Status
{
	n (qHandle,group)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:group="" 1
 	k ^TEMPDHCWL($j)
 	k ^TEMPDHCWLCode($j)
 	s groupId = $o(^DHCWL.CodeCfg.GroupI("Code"," "_group,"")) 
 	s type = $li(^DHCWL.CodeCfg.GroupD(groupId),11)
 	s exeCode = $li(^DHCWL.MKPI.MKPIDimTypeD(type),9)  //纬度的执行代码
 	s exepara = " s allEx=$$"_exeCode_"()"
 	x exepara
 	s dimpro=0 f  s dimpro =$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",type,dimpro)) q:dimpro=""  d
 	.s proId = 0 f  s proId = $o(^DHCWL.MKPI.DimPropertyI("DimCodeI",type,dimpro,proId)) q:proId=""  d
 	..s yFlag = $li(^DHCWL.MKPI.DimPropertyD(proId),7)
 	..i yFlag="Y"  d
 	...s zxCode = $li(^DHCWL.MKPI.DimPropertyD(proId),6)  //纬度属性执行代码
    s detCode=0  f  s detCode = $o(^DHCWL.CodeCfg.SubGroupI("Code",groupId,detCode)) q:detCode=""  d
    .s detId=0 f  s detId = $o(^DHCWL.CodeCfg.SubGroupI("Code",groupId,detCode,detId)) q:detId=""  d
    ..s dataId=0 f  s dataId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",detId,dataId)) q:dataId=""  d
    ...s fomdata=##Class(LIS.Core.Util).Trim(dataId)   
    ...s exeStr="s analysis=$$"_zxCode_"("_fomdata_")"
    ...x exeStr
    ...s ^TEMPDHCWL($j,"analysis",analysis)=1
    ...s num=0 f  s num = $o(^TEMPDHCWLCode($j,num)) q:num=""  d
    ....s desc = $g(^TEMPDHCWLCode($j,num))
    ....s ^TEMPDHCWL($j,"desc",$p(desc,"^",3))=1
    ...s ms=0 f  s ms = $o(^TEMPDHCWL($j,"desc",ms)) q:ms=""  d
    ....q:$d(^TEMPDHCWL($j,"analysis",ms))  
    ....s qsitem = ms
    ....s num = num+1
    ....d outputRow12
	Quit $$$OK
	
outputRow12
 s row=$listbuild(num,groupId,group,qsitem)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetColGrpNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetColGrpNoExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetColGrpNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetColGrpNoExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","WorkLoadDetail","2022-02-22","2022-02-22","FlagDate","I","","","","0000002042","2","41","","","")
Query WorkLoadDetail(startDate As %String, endDate As %String, dateType As %String, admType As %String, patLoc As %String, resLoc As %String, recLoc As %String, RegNo As %String, HOSPID As %String, tarNod As %String, tarType As %String, yzx As %String, sfx As %String) As %Query(ROWSPEC = "admId,paNo,paName,paType,brks,kdks,jsks,brys,kdys,arcDesc,itemDesc,quantity:%Float,cost:%Float,catDesc,arpbl,oeori,admDate") [ SqlProc ]
{
}

ClassMethod WorkLoadDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String, admType As %String, patLoc As %String, resLoc As %String, recLoc As %String, RegNo As %String, HOSPID As %String, tarNod As %String, tarType As %String, yzx As %String, sfx As %String) As %Status
{
	n (qHandle,startDate,endDate,dateType,admType,patLoc,resLoc,recLoc,RegNo,HOSPID,tarNod,tarType,yzx,sfx)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:startDate="" 1
    q:endDate="" 1
    k typeArr,patArr,resArr,recArr,tarArr
    d GetRunQianArr^DHCWLCommonParsingMethods(admType,.typeArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(patLoc,.patArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(resLoc,.resArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(recLoc,.recArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(tarType,.tarArr)
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId=$o(^DHCWorkLoad(0,dateType,lDate,wlId)) q:wlId=""  d
    ..s paType = $P(^DHCWorkLoad(wlId),"^",4)
    ..i admType'="" q:'$d(typeArr(paType))
    ..s patDep = $P(^DHCWorkLoad(wlId),"^",3)
    ..s patDepHos = $P(^CTLOC(patDep),"^",22)
    ..q:patDepHos'=HOSPID
    ..i patLoc'="" q:'$d(patArr(patDep))
    ..s resDep = $P(^DHCWorkLoad(wlId),"^",23)
    ..i resLoc'="" q:'$d(resArr(resDep))
    ..s recDep = $P(^DHCWorkLoad(wlId),"^",1)
    ..i recLoc'="" q:'$d(recArr(recDep))
    ..s admId=$P(^DHCWorkLoad(wlId),"^",12)
    ..s papmi=$p(^PAADM(admId),"^",1)
    ..s paNo = +$P(^PAPER(papmi,"PAT",1),"^",2)
    ..s paName = $p(^PAPER(papmi,"ALL"),"^")
    ..i RegNo'="" q:paNo'=RegNo
    ..s feeType = $P(^DHCWorkLoad(wlId),"^",tarNod)
    ..i tarType'="" q:'$d(tarArr(feeType))
    ..s arcim=$P(^DHCWorkLoad(wlId),"^",2)
    ..s arcDesc = $$GetArcDesc^DHCWLCommonParsingMethods(arcim)
    ..s arcJP = $$GetCHCODE^DHCWLCommonParsingMethods(arcDesc,4,"")
    ..i yzx'="" s arcJP=$zcvt(arcJP,"L") q:arcJP'[yzx
    ..s tarItem = $P(^DHCWorkLoad(wlId),"^",22)
    ..s itemDesc = $p(^DHCTARI(tarItem),"^",2)
    ..s tarJP = $$GetCHCODE^DHCWLCommonParsingMethods(itemDesc,4,"")
    ..i sfx'="" s tarJP=$zcvt(tarJP,"L") q:tarJP'[sfx
    ..s brks = $$GetLocDesc^DHCWLCommonParsingMethods(patDep)
    ..s kdks = $$GetLocDesc^DHCWLCommonParsingMethods(resDep)
    ..s jsks = $$GetLocDesc^DHCWLCommonParsingMethods(recDep)
    ..s patDoc = $P(^DHCWorkLoad(wlId),"^",25)
    ..s resDoc = $P(^DHCWorkLoad(wlId),"^",19)
    ..s brys = $$GetDocDesc^DHCWLCommonParsingMethods(patDoc)
    ..s kdys = $$GetDocDesc^DHCWLCommonParsingMethods(resDoc)
    ..s quantity = $P(^DHCWorkLoad(wlId),"^",15)
    ..s cost = $P(^DHCWorkLoad(wlId),"^",16)
    ..s itemCat = $p(^DHCWorkLoad(wlId),"^",9) 
    ..i $d(^ARC("IC",0,"OrderType","R",itemCat)) s arcDesc="药品数据不做显示",itemDesc="药品数据不做显示"
    ..s catDesc = $p(^ARC("IC",itemCat),"^",2)
    ..s arpbl = $P(^DHCWorkLoad(wlId),"^",20)
    ..s oeori = $P(^DHCWorkLoad(wlId),"^",21)
    ..i paType ="I" s admDate=$zd($p(^PAADM(admId,"DHC"),"^",31),3)
    ..e  s admDate=$zd($p(^PAADM(admId),"^",6),3)
	..d outputRow15
	Quit $$$OK
	
outputRow15
 s row=$listbuild(admId,paNo,paName,paType,brks,kdks,jsks,brys,kdys,arcDesc,itemDesc,quantity,cost,catDesc,arpbl,oeori,admDate)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod WorkLoadDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WorkLoadDetailExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WorkLoadDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WorkLoadDetailExecute ]
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

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarEcSystem","WorkLoadDetailZero","2022-11-23","2022-11-23","ORDDATE","I","","","","","2","41","","","")
Query WorkLoadDetailZero(startDate As %String, endDate As %String, dateType As %String, admType As %String, patLoc As %String, resLoc As %String, recLoc As %String, RegNo As %String, HOSPID As %String, tarNod As %String, tarType As %String, yzx As %String, sfx As %String) As %Query(ROWSPEC = "admId,paNo,paName,paType,brks,kdks,jsks,brys,kdys,arcDesc,itemDesc,quantity:%Float,cost:%Float,catDesc,arpbl,oeori,admDate,ordDate,flagDate") [ SqlProc ]
{
}

ClassMethod WorkLoadDetailZeroExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dateType As %String, admType As %String, patLoc As %String, resLoc As %String, recLoc As %String, RegNo As %String, HOSPID As %String, tarNod As %String, tarType As %String, yzx As %String, sfx As %String) As %Status
{
	n (qHandle,startDate,endDate,dateType,admType,patLoc,resLoc,recLoc,RegNo,HOSPID,tarNod,tarType,yzx,sfx)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:startDate="" 1
    q:endDate="" 1
    k typeArr,patArr,resArr,recArr,tarArr
    d GetRunQianArr^DHCWLCommonParsingMethods(admType,.typeArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(patLoc,.patArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(resLoc,.resArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(recLoc,.recArr)
    d GetRunQianArr^DHCWLCommonParsingMethods(tarType,.tarArr)
    s sDate = $zdh(startDate,3)
    s eDate = $zdh(endDate,3)
    f lDate = sDate:1:eDate  d
    .s wlId=0 f  s wlId=$o(^DHCWorkLoad(0,dateType,lDate,wlId)) q:wlId=""  d
    ..s paType = $P(^DHCWorkLoad(wlId),"^",4)
    ..i admType'="" q:'$d(typeArr(paType))
    ..s patDep = $P(^DHCWorkLoad(wlId),"^",3)
    ..s patDepHos = $P(^CTLOC(patDep),"^",22)
    ..q:patDepHos'=HOSPID
    ..i patLoc'="" q:'$d(patArr(patDep))
    ..s resDep = $P(^DHCWorkLoad(wlId),"^",23)
    ..i resLoc'="" q:'$d(resArr(resDep))
    ..s recDep = $P(^DHCWorkLoad(wlId),"^",1)
    ..i recLoc'="" q:'$d(recArr(recDep))
    ..s admId=$P(^DHCWorkLoad(wlId),"^",12)
    ..s papmi=$p(^PAADM(admId),"^",1)
    ..s paNo = $P(^PAPER(papmi,"PAT",1),"^",2)
    ..s paName = $p(^PAPER(papmi,"ALL"),"^")
    ..i RegNo'="" q:paNo'=RegNo
    ..s feeType = $P(^DHCWorkLoad(wlId),"^",tarNod)
    ..i tarType'="" q:'$d(tarArr(feeType))
    ..s arcim=$P(^DHCWorkLoad(wlId),"^",2)
    ..s arcDesc = $$GetArcDesc^DHCWLCommonParsingMethods(arcim)
    ..s arcJP = $$GetCHCODE^DHCWLCommonParsingMethods(arcDesc,4,"")
    ..i yzx'="" s arcJP=$zcvt(arcJP,"L") q:arcJP'[yzx
    ..s tarItem = $P(^DHCWorkLoad(wlId),"^",22)
    ..s itemDesc = $p(^DHCTARI(tarItem),"^",2)
    ..s tarJP = $$GetCHCODE^DHCWLCommonParsingMethods(itemDesc,4,"")
    ..i sfx'="" s tarJP=$zcvt(tarJP,"L") q:tarJP'[sfx
    ..s brks = $$GetLocDesc^DHCWLCommonParsingMethods(patDep)
    ..s kdks = $$GetLocDesc^DHCWLCommonParsingMethods(resDep)
    ..s jsks = $$GetLocDesc^DHCWLCommonParsingMethods(recDep)
    ..s patDoc = $P(^DHCWorkLoad(wlId),"^",25)
    ..s resDoc = $P(^DHCWorkLoad(wlId),"^",19)
    ..s brys = $$GetDocDesc^DHCWLCommonParsingMethods(patDoc)
    ..s kdys = $$GetDocDesc^DHCWLCommonParsingMethods(resDoc)
    ..s quantity = $P(^DHCWorkLoad(wlId),"^",15)
    ..s cost = $P(^DHCWorkLoad(wlId),"^",16)
    ..s itemCat = $p(^DHCWorkLoad(wlId),"^",9) 
    ..i $d(^ARC("IC",0,"OrderType","R",itemCat)) s arcDesc="药品数据不做显示",itemDesc="药品数据不做显示"
    ..s catDesc = $p(^ARC("IC",itemCat),"^",2)
    ..s arpbl = $P(^DHCWorkLoad(wlId),"^",20)
    ..s oeori = $P(^DHCWorkLoad(wlId),"^",21)
    ..i paType ="I" s admDate=$zd($p(^PAADM(admId,"DHC"),"^",31),3)
    ..e  s admDate=$zd($p(^PAADM(admId),"^",6),3)
    ..s ordDate = $P(^DHCWorkLoad(wlId),"^",5)
    ..i ordDate'="" s ordDate=$zd(ordDate,3)
    ..s flagDate = $P(^DHCWorkLoad(wlId),"^",27)
    ..i flagDate'="" s flagDate=$zd(flagDate,3)
    ..s nod = admId_","_paNo_","_paName_","_paType_","_brks_","_kdks_","_jsks_","_brys_","_kdys_","_arcDesc_","_itemDesc_","_catDesc_","_arpbl_","_oeori_","_admDate_","_ordDate_","_flagDate
	..s nod1 = admId_","_paNo_","_paName_","_paType_","_brks_","_kdks_","_jsks_","_brys_","_kdys_","_arcDesc_","_itemDesc_","_catDesc_","_oeori
	..s ^TEMPDHCWL($j,"save",nod)=$g(^TEMPDHCWL($j,"save",nod))+cost
	..s ^TEMPDHCWL($j,"qty",nod)=$g(^TEMPDHCWL($j,"qty",nod))+quantity
	..s ^TEMPDHCWL($j,"zeroqty",nod1)=$g(^TEMPDHCWL($j,"zeroqty",nod1))+quantity
	s str=0 f  s str= $O(^TEMPDHCWL($j,"save",str)) q:str=""  d
	.s admId=$p(str,",",1)
	.s paNo=$p(str,",",2)
	.s paName=$p(str,",",3)
	.s paType=$p(str,",",4)
	.s brks=$p(str,",",5)
	.s kdks=$p(str,",",6)
	.s jsks=$p(str,",",7)
	.s brys=$p(str,",",8)
	.s kdys=$p(str,",",9)
	.s arcDesc=$p(str,",",10)
	.s itemDesc=$p(str,",",11)
	.;s quantity=$p(str,",",12)
	.;s cost=$p(str,",",13)
	.s catDesc=$p(str,",",12)
	.s arpbl=$p(str,",",13)
	.s oeori=$p(str,",",14)
	.s admDate=$p(str,",",15)
	.s ordDate=$p(str,",",16)
	.s flagDate=$p(str,",",17)
	.s point = admId_","_paNo_","_paName_","_paType_","_brks_","_kdks_","_jsks_","_brys_","_kdys_","_arcDesc_","_itemDesc_","_catDesc_","_oeori
	.q:$g(^TEMPDHCWL($j,"zeroqty",point))=0  //过滤正负记录冲抵的
	.s cost = $g(^TEMPDHCWL($j,"save",str))
	.s quantity = $g(^TEMPDHCWL($j,"qty",str))
	.d outputRow16
	Quit $$$OK
	
outputRow16
 s row=$listbuild(admId,paNo,paName,paType,brks,kdks,jsks,brys,kdys,arcDesc,itemDesc,quantity,cost,catDesc,arpbl,oeori,admDate,ordDate,flagDate)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod WorkLoadDetailZeroClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WorkLoadDetailZeroExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WorkLoadDetailZeroFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WorkLoadDetailZeroExecute ]
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
