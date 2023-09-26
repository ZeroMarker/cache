/// Descript:退货汇总相关
/// Creater:	wyx
/// CreateDate:	2013-12-13
Class web.DHCST.DHCINGRTRetStat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Query QueryDetail(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "No:%String,InvNo:%String,Date:%String,InciCode:%String,InciDesc:%String,UomDesc:%String,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Vendor:%String,BatNo:%String,Expire:%String,Manf:%String,StkBin:%String,InvDate:%String,Spec:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCINGRTRetStat","QueryDetail","2013-12-13","2013-12-13","102","1^^^^1","","")
ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,Others,StartTime,EndTime)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:StartDate="" ""			//必选条件
	q:EndDate="" ""
	q:LocId="" ""
    i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s qPid=""
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)       
	//;退货明细单,退货单汇总,退货单单品汇总,供应商汇总
	s ret=..INGRTRetStat(StartDate,EndDate,LocId,Others,StartTime,EndTime)       
	s pid=$p(ret,"^",1)
	s cnt=$p(ret,"^",2)
	s n=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)
	.s No=$p(data,"||",2)
	.s InvNo=$p(data,"||",3)
	.s Date=$p(data,"||",4)
	.s InciCode=$p(data,"||",5)
	.s InciDesc=$p(data,"||",6)
	.s UomDesc=$p(data,"||",7)
	.s Qty=$p(data,"||",8)
	.s Rp=$p(data,"||",9)
	.s RpAmt=$p(data,"||",10)
	.s Sp=$p(data,"||",11)
	.s SpAmt=$p(data,"||",12)
	.s Vendor=$p(data,"||",13)
	.s BatNo=$p(data,"||",14)
	.s Expire=$p(data,"||",24)
	.s Manf=$p(data,"||",15)
	.s StkBin=$p(data,"||",16)
	.s InvDate=$p(data,"||",25)
	.s Spec=$p(data,"||",22)
	.s n=n+1
	.d OutRowItm
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid)
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid)
	Quit $$$OK

OutRowItm   
	s Data=$lb(No,InvNo,Date,InciCode,InciDesc,UomDesc,Qty,Rp,RpAmt,Sp,SpAmt,Vendor,BatNo,Expire,Manf,StkBin,InvDate,Spec)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	
	
	q
}

ClassMethod QueryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailExecute ]
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

Query QueryRetNo(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "No:%String,InvNo:%String,Date:%String,RpAmt:%Float,SpAmt:%Float,Vendor:%String,InciCnt") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCINGRTRetStat","QueryRetNo","2013-12-13","2013-12-13","102","1^^^^2","","")
ClassMethod QueryRetNoExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,Others,StartTime,EndTime)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:StartDate="" ""			//必选条件
	q:EndDate="" ""
	q:LocId="" ""
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s qPid=""
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)       
	//;退货明细单,退货单汇总,退货单单品汇总,供应商汇总
	s ret=..INGRTRetStat(StartDate,EndDate,LocId,Others,StartTime,EndTime)       
	s pid=$p(ret,"^",1)
	s cnt=$p(ret,"^",2)
	s n=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)
	.s No=$p(data,"||",2)
	.s InvNo=$p(data,"||",3)
	.s Date=$p(data,"||",4)
	.s InciCode=$p(data,"||",5)
	.s InciDesc=$p(data,"||",6)
	.s UomDesc=$p(data,"||",7)
	.s Qty=$p(data,"||",8)
	.s Rp=$p(data,"||",9)
	.s RpAmt=$p(data,"||",10)
	.s Sp=$p(data,"||",11)
	.s SpAmt=$p(data,"||",12)
	.s Vendor=$p(data,"||",13)
	.s BatNo=$p(data,"||",14)
	.s Expire=$p(data,"||",24)
	.s Manf=$p(data,"||",15)
	.s StkBin=$p(data,"||",16)
	.s InvDate=$p(data,"||",25)
	.s Spec=$p(data,"||",22)
	.s n=n+1
	.s InciCnt=$g(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid,No))
	.d OutRowRetNo
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid)
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid)
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid)
	Quit $$$OK

OutRowRetNo   
	s Data=$lb(No,InvNo,Date,RpAmt,SpAmt,Vendor,InciCnt)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

ClassMethod QueryRetNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRetNoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRetNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRetNoExecute ]
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

Query QueryRetInci(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "InciCode:%String,InciDesc:%String,UomDesc:%String,Qty:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Manf:%String,phcg:%String,Spec:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCINGRTRetStat","QueryRetInci","2013-12-13","2013-12-13","102","1^^^^3","","")
ClassMethod QueryRetInciExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,Others,StartTime,EndTime)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:StartDate="" ""			//必选条件
	q:EndDate="" ""
	q:LocId="" ""
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s qPid=""
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	//;退货明细单,退货单汇总,退货单单品汇总,供应商汇总
	s ret=..INGRTRetStat(StartDate,EndDate,LocId,Others,StartTime,EndTime)       
	s pid=$p(ret,"^",1)
	s cnt=$p(ret,"^",2)
	s n=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)
	.s No=$p(data,"||",2)
	.s InvNo=$p(data,"||",3)
	.s Date=$p(data,"||",4)
	.s InciCode=$p(data,"||",5)
	.s InciDesc=$p(data,"||",6)
	.s UomDesc=$p(data,"||",7)
	.s Qty=$p(data,"||",8)
	.s Rp=$p(data,"||",9)
	.s RpAmt=$p(data,"||",10)
	.s Sp=$p(data,"||",11)
	.s SpAmt=$p(data,"||",12)
	.s Vendor=$p(data,"||",13)
	.s BatNo=$p(data,"||",14)
	.s Expire=$p(data,"||",24)
	.s Manf=$p(data,"||",15)
	.s StkBin=$p(data,"||",16)
	.s InvDate=$p(data,"||",25)
	.s Spec=$p(data,"||",22)
	.s phcg=$p(data,"||",26)
	.
	.s n=n+1
	.d OutRowRetInci
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid)
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid)
	Quit $$$OK

OutRowRetInci   
	s Data=$lb(InciCode,InciDesc,UomDesc,Qty,RpAmt,Sp,SpAmt,Manf,phcg,Spec)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1	
	q
}

ClassMethod QueryRetInciClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRetInciExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRetInciFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailExecute ]
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

Query QueryRetVen(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "RpAmt:%Float,SpAmt:%Float,Vendor:%String,RetNoCnt,InciCnt") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCINGRTRetStat","QueryRetVen","2013-12-13","2013-12-13","102","1^^^^4","","")
ClassMethod QueryRetVenExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,Others,StartTime,EndTime)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:StartDate="" ""			//必选条件
	q:EndDate="" ""
	q:LocId="" ""
	i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s qPid=""
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime) 
	//;退货明细单,退货单汇总,退货单单品汇总,供应商汇总
	s ret=..INGRTRetStat(StartDate,EndDate,LocId,Others,StartTime,EndTime)
	s pid=$p(ret,"^",1)
	s cnt=$p(ret,"^",2)
	s n=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,h)
	.s No=$p(data,"||",2)
	.s InvNo=$p(data,"||",3)
	.s Date=$p(data,"||",4)
	.s InciCode=$p(data,"||",5)
	.s InciDesc=$p(data,"||",6)
	.s UomDesc=$p(data,"||",7)
	.s Qty=$p(data,"||",8)
	.s Rp=$p(data,"||",9)
	.s RpAmt=$p(data,"||",10)
	.s Sp=$p(data,"||",11)
	.s SpAmt=$p(data,"||",12)
	.s Vendor=$p(data,"||",13)
	.s BatNo=$p(data,"||",14)
	.s Expire=$p(data,"||",24)
	.s Manf=$p(data,"||",15)
	.s StkBin=$p(data,"||",16)
	.s InvDate=$p(data,"||",25)
	.s Spec=$p(data,"||",22)
	.s InciCnt=$g(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid,Vendor))
	.s RetNoCnt=$g(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","retnocnt",pid,Vendor)) 
	.s n=n+1
	.d OutRowRetVen
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid)
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid)
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid)
	k ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","retnocnt",pid)
	Quit $$$OK
OutRowRetVen   
	s Data=$lb(RpAmt,SpAmt,Vendor,RetNoCnt,InciCnt)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

ClassMethod QueryRetVenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRetVenExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryRetVenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailExecute ]
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

ClassMethod INGRTRetStat(StartDate, EndDate, LocId, Others, StartTime, EndTime)
{
	n (StartDate,EndDate,LocId,Others,StartTime,EndTime)
	s datefrom=StartDate,dateto=EndDate
	s parGrpType=$p(Others,"^",1) //类组
	s parIncRowid=$p(Others,"^",2) //药品rowid
	s parVendorId=$p(Others,"^",3) //供应商id
	s parRetReasonid=$p(Others,"^",4) //退药原因id
	s parType=$p(Others,"^",5) //查询类型
	s rpsumcosts=0,spsumcosts=0,i=0
	q:LocId="" 0     
	s pid=..NewPid() 
	f date=datefrom:1:dateto d
	. ;s ingrtid="" f  s ingrtid=$o(^INGRT(0,"DATE",date,ingrtid))  q:ingrtid=""  d
	. ;改为使用"审核"日期
	. s ingrtid=""  f  s ingrtid=$o(^INGRT(0,"AUDITDATE",date,ingrtid))  q:ingrtid=""  d  //主表
	.. s rpsumcosts=0,spsumcosts=0
	.. s incicntnum=0  ;每张退货单中的品种数
	.. q:'$d(^INGRT(ingrtid))
	.. s retstr=^INGRT(ingrtid)
	.. s rettime=$p(retstr,"^",10)
	.. q:(StartDate=date)&&(StartTime'="")&&(rettime<StartTime)
	.. q:(EndDate=date)&&(EndTime'="")&&(rettime>EndTime)
	.. s retcom=$p(retstr,"^",6) q:retcom'="Y"   ; 未※完成＂
	.. s auditusr=$p(retstr,"^",8) q:auditusr=""   ;未审核的过滤
	.. s locid=$p(retstr,"^",7) q:locid'=LocId  ;非查询科室
	.. s change=$p(retstr,"^",11)
	.. //q:(change="1")&(flag3'="调价换票")
	.. //q:(change="0")&(flag3="调价换票")
	.. s retno=$p(retstr,"^",1)
	.. s retdate=$p(retstr,"^",3)
	.. s retdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retdate,"ST")
	.. s apcvmid=$p(^INGRT(ingrtid),"^",2)
	.. s vendor=..Vendor(apcvmid)
	.. //i flag2="1" q:flag1'=vendor   ;by vendor
	.. q:(parVendorId'=apcvmid)&(parVendorId'="")
	.. s retch="" f  s retch=$o(^INGRT(ingrtid,"DHCGRR",retch)) q:retch=""  d  //子表
	... q:'$d(^INGRT(ingrtid,"DHCGRR",retch))
	... ;任晓娜 增加 退货损益统计这一列
	... s AspAmount=0,aspRowid=""
	... i $d(^DHCRETA(0,"TypePointer","R",ingrtid_"||"_retch)) d //判断损益表是否有子表的ID，有则说明产生过损益
	....s aspRowid=$o(^DHCRETA(0,"TypePointer","R",ingrtid_"||"_retch,aspRowid))
	....s AspAmount=$p(^DHCRETA(aspRowid),"^",5)  //取出损益表的损益金额
	... s retistr=^INGRT(ingrtid,"DHCGRR",retch)
	... s retqty=$p(retistr,"^",2)
	... s retuom=$p(retistr,"^",3)
	... s retrp=+$p(retistr,"^",7)
	... s retrpamt=$p(retistr,"^",4) 
	... s retsp=+$p(retistr,"^",8)
	... s retspamt=$p(retistr,"^",9)
	... s retpp=$p(retistr,"^",10)
	... s retppamt=$p(retistr,"^",11)
	... s retinvono=$p(retistr,"^",12)
	... s retinvdate=$p(retistr,"^",14)
	... i retinvdate'="" s retinvdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retinvdate,"ST")
	... s retres=$p(retistr,"^",5)
	... s retresdesc=$p($g(^INC("RET",retres)),"^",2)      ;退货原因描述
	... q:(parRetReasonid'="")&(parRetReasonid'=retres)
	... s ingriid=$p(retistr,"^",1)
	... s inclbid=""
	... s inclbid=$p(^DHCINGR(+ingriid,"GRI",$p(ingriid,"||",2)),"^",1) q:inclbid=""
	... s inciid=""
	... s inciid=$p(inclbid,"||",1)
	... q:'$d(^INCI(inciid,1))
	... q:'$d(^INCI(inciid,2))
	... q:'$d(^INCI(inciid,3))
	... s incicode=$p(^INCI(inciid,1),"^",1) s incidesc=$p(^INCI(inciid,1),"^",2) 
	... //i flag4="1" q:flag3'=retresdesc   ;by 退货原因
	... //i flag6="1" q:flag5'=incidesc    ;by 库存项
	...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
	...s Scg=$p(StkGrpInfo,"^",5)
	...s ScgType=$p(StkGrpInfo,"^",3)
	...q:ScgType'=..sssCode()
	...q:(parGrpType'="")&(Scg'=parGrpType)
	... q:(parIncRowid'="")&(parIncRowid'=inciid)
	... s incibid=""
	... s incibid=$p(^INCI($p(inclbid,"||",1),"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
	... s batno="",expdate=""
	... i incibid'="" d
	.... s batno=$p(^INCI($p(incibid,"||",1),"IB",$p(incibid,"||",2)),"^",1)
	.... s expdate=$p(^INCI($p(incibid,"||",1),"IB",$p(incibid,"||",2)),"^",2)
	... i expdate'="" s expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expdate,"ST")
	... s dhcingri=$p(ingriid,"||",1),dhcingrich=$p(ingriid,"||",2)
	... i dhcingrich'="" s gmanfid=$p(^DHCINGR(dhcingri,"GRI",dhcingrich),"^",29)
	... s gmanf=""
	... i ($g(gmanfid)'="") d
	.... i $d(^PHMNF(gmanfid))  s gmanf=$p(^PHMNF(gmanfid),"^",2)
	... s buom=+$p(^INCI(inciid,1),"^",10)
	... s puruom=$p(^INCI(inciid,3),"^",6)
	... i $g(puruom)="" s puruom=buom 
	... s puruomdesc=$p(^CT("UOM",puruom),"^",2)
	... s bfac=##class(web.DHCST.Common.UtilCommon).UOMFac(retuom,buom)
	... s pfac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,buom)
	... s retuom=$p(^CT("UOM",retuom),"^",2) //退货单位
	... s cpcosts=retspamt-retrpamt
	... s rpsumcosts=rpsumcosts+retrpamt
	... s spsumcosts=spsumcosts+retspamt
	... s incil=$p(incibid,"||",1)_"||"_$p(incibid,"||",2)
	... //取新科室货位表过滤货位 add wyx 2013-11-21 //改为取新的科室货位表DHCIncItmLocBin（可多货位）
	... s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
	... s stkbinstr=$p(stkbinret,":",2)
	... s stkbin=stkbinstr 
	... S GeneStr=##Class(web.DHCST.Common.DrugInfoCommon).GetGene(inciid)						//通用名
	... S GeneCode=$P(GeneStr,"^",1)									//通用名代码
	... S GeneName=$P(GeneStr,"^",2)	
	... s phcge=GeneName							//通用名描述
	... s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciid)
	... s retqty=(retqty*bfac)/pfac
	... s retsp=(retsp*pfac)/bfac
	... s retrp=(retrp*pfac)/bfac
	... s i=i+1
	... s data=i_"||"_retno_"||"_retinvono_"||"_retdate_"||"_$g(incicode)_"||"_$g(incidesc)_"||"_puruomdesc_"||"_retqty_"||"_retrp_"||"_retrpamt_"||"_retsp_"||"_retspamt_"||"_$g(vendor)_"||"_$g(batno)_"||"_$g(gmanf)_"||"_$g(stkbin)_"||"_$g(retresdesc)_"||"_$g(retpp)_"||"_$g(retppamt)_"||"_$g(rpsumcosts)_"||"_$g(spsumcosts)_"||"_$g(spec)_"||"_AspAmount_"||"_expdate_"||"_retinvdate_"||"_phcge
	... i parType="1" s indexData=i
	... i parType="2" s indexData=retno
	... i parType="3" s indexData=incicode
	... i parType="4" s indexData=vendor
	...i '$d(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData)) d
	....s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData)=data
	...e  d
	....s $p(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData),"||",8)=$p(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData),"||",8)+retqty
	....s $p(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData),"||",10)=$p(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData),"||",10)+retrpamt
	....s $p(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData),"||",12)=$p(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat",pid,indexData),"||",12)+retspamt 
	...;(按退货单汇总)
	...
	...
	...i parType="2"  d
	....i '$d(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid,indexData,incicode)) d
	.....s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid,indexData,incicode)=1
	.....s incicntnum=incicntnum+1  
	.....s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid,indexData)=incicntnum  ;每张单中的品种数
	....
	... 
	...i parType="4" d
	....i '$d(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid,indexData,retno)) d
	.....s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid,indexData,retno)=1 
	.....i '$d(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","retnocnt",pid,indexData)) d
	......s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","retnocnt",pid,indexData)=1  ;退货单张数
	.....e  d
	......s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","retnocnt",pid,indexData)=^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","retnocnt",pid,indexData)+1  ;退货单张数 
	.....
	....i '$d(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid,indexData,incicode)) d
	.....s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","cnt",pid,indexData,incicode)=1
	.....i '$d(^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid,indexData)) d
	......s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid,indexData)=1
	.....e  d
	......s ^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid,indexData)=^TMP("DHCST","DHCINGRTRetStat","INGRTRetStat","incicnt",pid,indexData)+1  ;按供应商汇总的品种数
	......
	q pid_"^"_i
}

ClassMethod Vendor(apcvmid)
{
 n (apcvmid)
 i $d(^APC("APCVM",apcvmid)) d
 . s vendor=$p(^APC("APCVM",apcvmid),"^",3)
 e  d
 . s vendor="BX"
 q $g(vendor)
}

ClassMethod NewPid()
{
   q $I(^DHCSTPID("RetStat"))
}

}
