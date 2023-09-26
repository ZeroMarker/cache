/// 住院收入和发药核对      edit by czx in 2016-09-08
Class web.DHCWLCheckFeeRpt Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator?      czx
/// CreatDate?    2016-12     
/// description:  统计收入总金额、发药总金额收入、收入多于发药总金额、发药多于收入总金额
/// Table?        DHCworkLoad:收入表,DHC_PHACollected: 住院发药主表,
///               DHC_PHACollectItm:住院发药明细表 OE_OrdExec:医嘱执行表
///               DHC_PhaReturn:退药主表 DHC_PhaReturnItm:退药明细表
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       收入总费用、发药总费用、收入比发药多费用、发药比收入多费用
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","CheckInpDrug","2015-03-01","2015-04-01","0") 
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","CheckInpDrug","2020-5-1","2020-10-1","","2,3,9,10,19,20") 
Query CheckInpDrug(startDate As %String, endDate As %String, dep As %String, hosId As %String) As %Query(ROWSPEC = "totalWlFee:%Float,totalDisFee:%Float,totalWLBig:%Float,totalDisBig:%Float") [ SqlProc ]
{
}

ClassMethod CheckInpDrugExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", dep As %String = 0, hosId As %String = "") As %Status
{
	n (qHandle,startDate,endDate,dep,hosId)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLCheck($j)
    K ^TEMPDHCWLCZX($j)
	q:startDate="" $$$OK
	q:endDate="" $$$OK	
  	s sDate=$zdh(startDate,3)
  	s eDate=$zdh(endDate,3)
  	s totalWlFee=0,totalDisFee=0
  	s totalWLBig=0,totalDisBig=0
	
	// 取收入表数据
  	f date=sDate:1:eDate d
  	.s wlid=0 f  s wlid=$o(^DHCWorkLoad(0,"ORDDATE",date,wlid)) q:wlid=""  d
  	..s type=$p(^DHCWorkLoad(wlid),"^",4)
  	..q:type'="I"
  	..s recDep=$p(^DHCWorkLoad(wlid),"^",1) ;接收科室 2016-10-20
  	..q:recDep=""
  	..q:(recDep'=dep)&&(dep'=0) ;过滤科室
  	..s hosDr=$p(^CTLOC(recDep),"^",22)
  	..q:((","_hosId_",")'[(","_hosDr_","))&&($g(hosId)'="")
  	..s itemCate=$p(^DHCWorkLoad(wlid),"^",9)           ;医嘱子分类WorkLoad_ItemCat_Dr	
  	..q:'$d(^ARC("IC",0,"OrderType","R",itemCate))      ;非药品不统计
  	..s fee=$p(^DHCWorkLoad(wlid),"^",16)
  	..s afee=$g(afee)+fee
  	..s oeoreDr=$p(^DHCWorkLoad(wlid),"^",54)  //czx:WorkLoad_OEORE_Dr->OE_OrdExec
  	..s oeori=$p(oeoreDr,"||",1,2)  ;add by czx
  	..s totalWlFee=$g(totalWlFee)+fee
  	..s ^TEMPDHCWL($j,oeori,"wlOeoriFee")=$g(^TEMPDHCWL($j,oeori,"wlOeoriFee"))+fee
    ;b ;总，收入
  
    f date=sDate:1:eDate d
    .i +dep'=0 d
    ..s hosDr=$p(^CTLOC(dep),"^",22)
    ..q:((","_hosId_",")'[(","_hosDr_","))&&($g(hosId)'="")
    ..s phacRowId="" f  s phacRowId=$o(^DHCPHAC(0,"PHA",dep,"DATE",date,phacRowId)) q:phacRowId=""  d
    ...s phacItmId="" f  s phacItmId=$o(^DHCPHAC(phacRowId,"I",phacItmId)) q:phacItmId=""  d
  	....s phachildsub=""
	....f  s phachildsub=$o(^DHCPHAC(phacRowId,"I",phacItmId,"B",phachildsub)) q:phachildsub=""  d
	.....s fee=$p(^DHCPHAC(phacRowId,"I",phacItmId,"B",phachildsub),"^",6)
    .....s oeori=$p(^DHCPHAC(phacRowId,"I",phacItmId) ,"^",7)  ;add by czx
    .....S ord=+oeori
    .....s sub=$p(oeori,"||",2)
    .....s arcId=$p(^OEORD(ord,"I",sub,1),"^",2)
    .....s arc=+arcId
    .....s arcsub=$p(arcId,"||",2)
    .....s itmmastDesc=$p(^ARCIM(arc,arcsub,1),"^",2)
    .....s totalDisFee=$g(totalDisFee)+fee
    .....s ^TEMPDHCWL($j,oeori,"disOeoreFee")=$g(^TEMPDHCWL($j,oeori,"disOeoreFee"))+fee ;add by czx
    .e  d   ;全部发药科室
    ..s loc="" f  s loc=$o(^DHCPHAC(0,"PHA",loc)) q:loc=""  d
    ...s phacRowId="" f  s phacRowId=$o(^DHCPHAC(0,"PHA",loc,"DATE",date,phacRowId)) q:phacRowId=""  d
    ....s hosDr=$p(^CTLOC(loc),"^",22)
    ....q:((","_hosId_",")'[(","_hosDr_","))&&($g(hosId)'="")
    ....s phacItmId="" f  s phacItmId=$o(^DHCPHAC(phacRowId,"I",phacItmId)) q:phacItmId=""  d
    .....s phachildsub=""
	.....f  s phachildsub=$o(^DHCPHAC(phacRowId,"I",phacItmId,"B",phachildsub)) q:phachildsub=""  d
	......s fee=$p(^DHCPHAC(phacRowId,"I",phacItmId,"B",phachildsub),"^",6)
    ......s oeori=$p(^DHCPHAC(phacRowId,"I",phacItmId) ,"^",7)  ;add by czx
    ......S ord=+oeori
    ......s sub=$p(oeori,"||",2)
    ......s arcId=$p(^OEORD(ord,"I",sub,1),"^",2)
    ......s arc=+arcId
    ......s arcsub=$p(arcId,"||",2)
    ......s itmmastDesc=$p(^ARCIM(arc,arcsub,1),"^",2)
    ......;s ^TEMPDHCWLCZX($j,operName)=$G(^TEMPDHCWLCZX($j,operName))+fee
    ......;s ^TEMPDHCWLCZX($j,operName,itmmastDesc)=$G(^TEMPDHCWLCZX($j,operName,itmmastDesc))+fee
    ......s totalDisFee=$g(totalDisFee)+fee
    ......s ^TEMPDHCWL($j,oeori,"disOeoreFee")=$g(^TEMPDHCWL($j,oeori,"disOeoreFee"))+fee ;add by czx
    ;b ;总，发药 
    
    // 退药数据DHC_PhaReturn,  DHC_PhaReturnItm:退药明细表
    f date=sDate:1:eDate d
    .s pharRowid=0 f  s pharRowid=$o(^PHARET(0,"DATE",date,pharRowid)) q:pharRowid=""  d
    ..s childSub=0 f  s childSub=$o(^PHARET(pharRowid,"I",childSub)) q:childSub=""  d
    ...s locDr=$p(^PHARET(pharRowid),"^",5)
    ...q:(locDr'=dep)&&(+dep'=0) ;过滤科室
    ...s hosDr=$p(^CTLOC(locDr),"^",22)
    ...q:((","_hosId_",")'[(","_hosDr_","))&&($g(hosId)'="")
    ...s phaRchildsub=0
	...f  s phaRchildsub=$o(^PHARET(pharRowid,"I",childSub,"B",phaRchildsub)) q:phaRchildsub=""  d
	....s fee=0-$p(^PHARET(pharRowid,"I",childSub,"B",phaRchildsub),"^",6)
	....s feetest=$g(feetest)+fee
    ....s totalDisFee=$g(totalDisFee)+fee    //czx:这里直接得到的是发药减退药的总费用
    ....s oeori=$p(^PHARET(pharRowid,"I",childSub),"^",1)  ;add by czx
    ....s ^TEMPDHCWL($j,oeori,"disOeoreFee")=$g(^TEMPDHCWL($j,oeori,"disOeoreFee"))+fee ;add by czx
    ;b ;总，退药
   
  	s wlOeore=0
  	f  s wlOeore=$o(^TEMPDHCWL($j,wlOeore)) q:wlOeore=""  d
  	.i '$d(^TEMPDHCWL($j,wlOeore,"wlOeoriFee")) d
  	..s wlFee=0
  	.e  d
  	..s wlFee=$g(^TEMPDHCWL($j,wlOeore,"wlOeoriFee"))
  	.i '$d(^TEMPDHCWL($j,wlOeore,"disOeoreFee")) d
  	..s disFee=0
  	.e  d
  	..s disFee=$g(^TEMPDHCWL($j,wlOeore,"disOeoreFee"))
  	.q:$g(wlFee)=$g(disFee)
  	.i $g(wlFee)>$g(disFee) d   ;收入大于发药
  	..s compare1=$g(wlFee)-$g(disFee)
  	..s totalWLBig=$g(totalWLBig)+compare1
  	..s ^TEMPDHCWLCheck($j,"wlbig",wlOeore)=$g(^TEMPDHCWLCheck($j,"wlbig",wlOeore))+compare1
  	.e  d               ;发药大于收入
  	..s compare2=$g(disFee)-$g(wlFee)
  	..s totalDisBig=$g(totalDisBig)+compare2
  	..s ^TEMPDHCWLCheck($j,"disbig",wlOeore)=$g(^TEMPDHCWLCheck($j,"disbig",wlOeore))+compare2
  	
  	d OutputRow1
 	k ^TEMPDHCWL($j)
 	k ^TEMPDHCWLCheck($j)
 	K ^TEMPDHCWLCZX($j)
    Quit $$$OK
    	
OutputRow1
    s data=$lb(totalWlFee,totalDisFee,totalWLBig,totalDisBig)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod CheckInpDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckInpDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckInpDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckInpDrugExecute ]
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

/// Creator?      yw
/// CreatDate?    2014-09 
/// description:  统计医嘱明细数据(收入大于发药)
/// Table?        DHC_WorkLoad:收入表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "医嘱Id","医嘱项Id","医嘱项目名称","费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","GetWLBigDisFee","2015-03-10","2015-03-10","0")
Query GetWLBigDisFee(startDate As %String, endDate As %String, dep As %String, hosId As %String) As %Query(ROWSPEC = "wlOeori:%String,arcim:%String,arcimDes:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetWLBigDisFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dep As %String, hosId As %String) As %Status
{
	n (qHandle,startDate,endDate,dep,hosId)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	s test11=0
    q:startDate="" $$$OK
	q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLCheck($j)
    d CheckDrugData^DHCWLCheckDataCommon(startDate,endDate,dep,hosId)

	s wlOeore=0 f  s wlOeore=$o(^TEMPDHCWLCheck($j,"wlbig",wlOeore)) q:wlOeore=""  d
  	.s ord=+wlOeore
 	.s ordSub=$p(wlOeore,"||",2)
 	.s oeori=ord_"||"_ordSub   //czx:oeori=DSP_OEORE_DR,SELECT DSP_OEORE_DR  FROM DHC_OEDispensing--6||19||1,36||5||2,36||5||1
 	.s fee=$g(^TEMPDHCWLCheck($j,"wlbig",wlOeore))
 	.s ^TEMPDHCWL($j,"oeoriFee",oeori)=$g(^TEMPDHCWL($j,"oeoriFee",oeori))+fee
 	;b ;ceshi1
    
    s oeori=0 f  s oeori=$o(^TEMPDHCWL($j,"oeoriFee",oeori)) q:oeori=""  d
    .s ord=+oeori      
 	.s ordSub=$p(oeori,"||",2)
 	.s arcim=$P($G(^OEORD(ord,"I",ordSub,1)),"^",2)  //czx:医嘱OE_OrdItem:^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
 	.s arcSub=+arcim                                 //(1,2):OEORI_ItmMast_DR
 	.s arcVer=$p(arcim,"||",2) 
 	.s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ; ARCIM_Desc,医嘱项ARC_ItmMast
 	.s fee=$g(^TEMPDHCWL($j,"oeoriFee",oeori))
    .d OutputRow9
    
    
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLCheck($j)
    Quit $$$OK
    	
OutputRow9
    s data=$lb(oeori,arcim,arcimDes,fee)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetWLBigDisFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWLBigDisFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWLBigDisFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWLBigDisFeeExecute ]
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

/// Creator?      czx
/// CreatDate?    2016-12
/// description:  统计住院发药明细数据(收入多于发药)
/// Table?        DHC_PHACollected: 住院发药主表,DHC_PHACollectItm:住院发药明细表 OE_OrdExec:医嘱执行表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?      "发药科室Id"、"发药科室名称"、"医嘱项"、"数量"、"单价"、"费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","GetDifDisDetailFee","2015-03-10","2016-03-10","14||2") 
/// phldr:%String,phalocDesc:%String,
Query GetDifDisDetailFee(startDate As %String, endDate As %String, oeori As %String, dep As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcitmast:%String,arcItmDesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetDifDisDetailFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, oeori As %String, dep As %String) As %Status
{
	n (qHandle,oeori,startDate,endDate,dep)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:oeori="" $$$OK
	s sDate=$zdh(startDate,3) ;add by czx
	s eDate=$zdh(endDate,3)   ;add by czx
              //czx:terminal???^DHCPHAC(0,"PHADSP",{PHACI_OEDIS_DR},{DHC_PHACollected.DHC_PHACollect_RowID},{PHACI_ChildSub})
              //czx:studio???^DHCPHAC(0,"PHADSP",{PHACI_OEDIS_DR},{PHACI_DateDosing},{DHC_PHACollected.DHC_PHACollect_RowID},{PHACI_ChildSub})
  	          //DHC_PHACollectItm:住院发药明细表
  	
  	f date=sDate:1:eDate d
  	.i dep'=0  d
    ..s phacRowId="" f  s phacRowId=$o(^DHCPHAC(0,"PHA",dep,"DATE",date,phacRowId)) q:phacRowId=""  d
    ...;b ;2
    ...;q:(locDr'=dep)&&(dep'=0) ;过滤科室
    ...s phacItmId="" f  s phacItmId=$o(^DHCPHAC(phacRowId,"I",phacItmId)) q:phacItmId=""  d
    ....;b ;3 
    ....s admId=$p(^DHCPHAC(phacRowId,"I",phacItmId),"^",3) ;就诊号
    ....s papmi=$p(^PAADM(admId),"^",1)
    ....s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	....s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
  	....s oeori2=$p(^DHCPHAC(phacRowId,"I",phacItmId) ,"^",7)  ;医嘱子表
  	....q:oeori2'=oeori
  	....s ord=+oeori
  	....s ordSub=$p(oeori,"||",2)
  	....s arcitmast=$P($G(^OEORD(ord,"I",ordSub,1)),"^",2)
  	....s arc=+arcitmast
  	....s arcverson=$p(arcitmast,"||",2)
  	....s arcItmDesc=$p(^ARCIM(arc,arcverson,1),"^",2)
  	....s fee=$p(^DHCPHAC(phacRowId,"I",phacItmId) ,"^",15)      ;金额 DODIS
    ....d OutputRow11
    .e  d
    ..s loc="" f  s loc=$o(^DHCPHAC(0,"PHA",loc)) q:loc=""  d
    ...s phacRowId="" f  s phacRowId=$o(^DHCPHAC(0,"PHA",loc,"DATE",date,phacRowId)) q:phacRowId=""  d
    ....s phacItmId="" f  s phacItmId=$o(^DHCPHAC(phacRowId,"I",phacItmId)) q:phacItmId=""  d
    .....;b ;3 
    .....s admId=$p(^DHCPHAC(phacRowId,"I",phacItmId),"^",3) ;就诊号
    .....s papmi=$p(^PAADM(admId),"^",1)
    .....s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	.....s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
  	.....s oeori2=$p(^DHCPHAC(phacRowId,"I",phacItmId) ,"^",7)  ;医嘱子表
  	.....q:oeori2'=oeori
  	.....s ord=+oeori
  	.....s ordSub=$p(oeori,"||",2)
  	.....s arcitmast=$P($G(^OEORD(ord,"I",ordSub,1)),"^",2)
  	.....s arc=+arcitmast
  	.....s arcverson=$p(arcitmast,"||",2)
  	.....s arcItmDesc=$p(^ARCIM(arc,arcverson,1),"^",2)
  	.....s fee=$p(^DHCPHAC(phacRowId,"I",phacItmId) ,"^",15)      ;金额 DODIS
    .....d OutputRow11
    
  	
  
  
    Quit $$$OK
    	
OutputRow11
    s data=$lb(admId,papmiNo,papmiName,arcitmast,arcItmDesc,fee)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetDifDisDetailFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDifDisDetailFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDifDisDetailFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDifDisDetailFeeExecute ]
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

/// Creator?      yw
/// CreatDate?    2014-09 
/// description:  统计医嘱明细数据(发药大于发药收入)
/// Table?        DHC_WorkLoad:收入表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "医嘱Id","医嘱项Id","医嘱项目名称","费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","GetDisBigWLFee","2013-07-01","2013-09-01")
Query GetDisBigWLFee(startDate As %String, endDate As %String, dep As %String, hosId As %String) As %Query(ROWSPEC = "wlOeori:%String,arcim:%String,arcimDes:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetDisBigWLFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dep As %String, hosId As %String) As %Status
{
	n (qHandle,startDate,endDate,dep,hosId)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	
    q:startDate="" $$$OK
	q:endDate="" $$$OK
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLCheck($j)
    d CheckDrugData^DHCWLCheckDataCommon(startDate,endDate,dep,hosId)	

	s wlOeore=0 f  s wlOeore=$o(^TEMPDHCWLCheck($j,"disbig",wlOeore)) q:wlOeore=""  d
  	.s ord=+wlOeore
 	.s ordSub=$p(wlOeore,"||",2)
 	.s oeori=ord_"||"_ordSub
 	.s fee=$g(^TEMPDHCWLCheck($j,"disbig",wlOeore))
 	.s ^TEMPDHCWL($j,"oeoriFee",oeori)=$g(^TEMPDHCWL($j,"oeoriFee",oeori))+fee
 	
 	s oeori=0 f  s oeori=$o(^TEMPDHCWL($j,"oeoriFee",oeori)) q:oeori=""  d
    .s ord=+oeori
 	.s ordSub=$p(oeori,"||",2)
 	.s arcim=$P($G(^OEORD(ord,"I",ordSub,1)),"^",2)
 	.s arcSub=+arcim
 	.s arcVer=$p(arcim,"||",2) 
 	.s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
 	.s fee=$g(^TEMPDHCWL($j,"oeoriFee",oeori))
    .d OutputRow13
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLCheck($j)
    Quit $$$OK
    	
OutputRow13
    s data=$lb(oeori,arcim,arcimDes,fee)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetDisBigWLFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisBigWLFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDisBigWLFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisBigWLFeeExecute ]
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

/// Creator?      yw
/// CreatDate?    2014-09 
/// description:  统计收入明细数据(收入大于发药)
/// Table?        DHC_WorkLoad:收入表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "就诊ID","病人姓名",,"收费项目Id","收费项目名称",数量、费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","GetDiffWLDetailFee","2015-03-10","2015-03-10","573||1") 
Query GetDiffWLDetailFee(startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcim:%String,arcimDes:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetDiffWLDetailFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, oeori As %String) As %Status
{
	n (qHandle,oeori,startDate,endDate)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:oeori="" $$$OK
	s sDate=$zdh(startDate,3) ;add by czx
	s eDate=$zdh(endDate,3)   ;add by czx
    k ^TEMPDHCWL($j)
                       
    
    f date=sDate:1:eDate  d
    .s wlid=0 f  s wlid=$o(^DHCWorkLoad(0,"DateOEORI",date,oeori,wlid)) q:wlid=""  d
    ..s amount=$p(^DHCWorkLoad(wlid),"^",15)
  	..s fee=$p(^DHCWorkLoad(wlid),"^",16)
  	..s type=$p(^DHCWorkLoad(wlid),"^",4)
    ..q:type'="I"
    ..s itemCate=$p(^DHCWorkLoad(wlid),"^",9)           ;医嘱子分类	
    ..q:'$d(^ARC("IC",0,"OrderType","R",itemCate))      ;非药品不统计
    ..s ordDate=$p(^DHCWorkLoad(wlid),"^",5)  ;add by czx
  	..s admId=$p(^DHCWorkLoad(wlid),"^",12)
  	..s arcim=$p(^DHCWorkLoad(wlid),"^",2)
  	..w $zd(ordDate,3)_"^"_arcim_"^"_fee,!
  	..s ^TEMPDHCWL($j,admId,arcim,"DrugFee")=$g(^TEMPDHCWL($j,admId,arcim,"DrugFee"))+fee
  	b 
    
    s admId=0 f  s admId=$o(^TEMPDHCWL($j,admId)) q:admId=""  d
    .s papmi=$p(^PAADM(admId),"^",1)
    .s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	.s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
    .s arcim=0 f  s arcim=$o(^TEMPDHCWL($j,admId,arcim)) q:arcim=""  d
    ..s arcSub=+arcim
 	..s arcVer=$p(arcim,"||",2) 
 	..s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
    ..s fee=$g(^TEMPDHCWL($j,admId,arcim,"DrugFee"))
    ..d OutputRow14
    
    k ^TEMPDHCWL($j)
    Quit $$$OK
    	
OutputRow14
    s data=$lb(admId,papmiNo,papmiName,arcim,arcimDes,fee)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetDiffWLDetailFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiffWLDetailFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiffWLDetailFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiffWLDetailFeeExecute ]
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

/// Creator?      yw
/// CreatDate?    2014-09
/// description:  统计住院账单明细(收入大于发药)
/// Table?        DHC_PatientBill:账单主表、DHC_PatBillOrder:账单子表、DHC_PatBillDetails:账单明细表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "就诊ID","病人姓名","收费项目Id","收费项目名称",数量、费用",!
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","GetDiffPBDetailFee","2017-01-04","2017-01-09","625||1") 
Query GetDiffPBDetailFee(startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcim:%String,arcItmDesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetDiffPBDetailFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, oeori As %String) As %Status
{
	n (qHandle,oeori,startDate,endDate)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    q:oeori="" $$$OK
    s sDate=$zdh(startDate,3)
    s eDate=$zdh(endDate,3)
    k ^TEMPDHCWL($j)
                  
    
    
    f date=sDate:1:eDate d
    .;b ;1
    .s pbId="" f  s pbId=$o(^DHCPB(0,"BILLDATE",date,pbId)) q:pbId=""  d
    ..;b ;2
    ..s pboId="" f  s pboId=$o(^DHCPB(0,"BILLDATE",date,pbId,pboId)) q:pboId=""  d
    ...q:'$d(^DHCPB(pbId,"O",pboId))
    ...s oeoriId=$P(^DHCPB(pbId,"O",pboId),"^",4)
    ...;b ;8888
    ...q:oeoriId'=oeori
    ...s admId=$p(^DHCPB(pbId),"^",1)  ;就诊Id
  	...s papmi=$p(^PAADM(admId),"^",1) 
  	...s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
  	...s arcim=$P(^DHCPB(pbId,"O",pboId),"^",3)
  	...s fee=$P(^DHCPB(pbId,"O",pboId),"^",8)                   ;费用
  	...s ordDate=$zd($P(^DHCPB(pbId,"O",pboId),"^",12),3)   ;add by czx
  	...w ordDate_"^"_fee,!         ;add by czx
   	...s ^TEMPDHCWL($j,admId,arcim,"DrugFee")=$g(^TEMPDHCWL($j,admId,arcim,"DrugFee"))+fee
    
    s fee=0,amount=0
    s admId="" f  s admId=$o(^TEMPDHCWL($j,admId)) q:admId=""  d
    .s papmi=$p(^PAADM(admId),"^",1)
    .s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	.s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
    .s arcim=0 f  s arcim=$o(^TEMPDHCWL($j,admId,arcim)) q:arcim=""  d
    ..s arc=+arcim
  	..s arcverson=$p(arcim,"||",2)
  	..s arcItmDesc=$p(^ARCIM(arc,arcverson,1),"^",2)         ;医嘱项
    ..s fee=$g(^TEMPDHCWL($j,admId,arcim,"DrugFee"))
    ..d OutputRow15
   
    
    
 	k ^TEMPDHCWL($j)
    Quit $$$OK
    	
OutputRow15
    s data=$lb(admId,papmiNo,papmiName,arcim,arcItmDesc,fee)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetDiffPBDetailFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiffPBDetailFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiffPBDetailFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiffPBDetailFeeExecute ]
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

///  Creator?      czx
///  CreatDate?    2016-09
///  description:  统计住院退药明细数据(收入多于发药)
///  Table?        DHC_PhaReturn:退药主表 DHC_PhaReturnItm:退药明细表
///  Input?        startDate(开始日期),endDate(结束日期)
///  Output?      "发药科室Id"、"发药科室名称"、"医嘱项"、"数量"、"单价"、"费用"
///  d ##class(%ResultSet).RunQuery("web.DHCWLCheckFeeRpt","GetDifDisReDetailFee","2015-03-10","2015-03-10","14||2") 
///  phldr:%String,phalocDesc:%String,
Query GetDifDisReDetailFee(startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcitmast:%String,arcItmDesc:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetDifDisReDetailFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, oeori As %String) As %Status
{
		// 退药数据
	n (qHandle,oeori,startDate,endDate)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    q:oeori="" $$$OK
    s sDate=$zdh(startDate,3)
    s eDate=$zdh(endDate,3)
    k ^TEMPDHCWL($j)
    f date=sDate:1:eDate d
    .s pharRowid=0 f  s pharRowid=$o(^PHARET(0,"DATE",date,pharRowid)) q:pharRowid=""  d
    ..s childSub=0 f  s childSub=$o(^PHARET(pharRowid,"I",childSub)) q:childSub=""  d
    ...s oeoriId=$p(^PHARET(pharRowid,"I",childSub),"^",1)  ;add by czx
    ...q:oeoriId'=oeori
    ...s fee=0-$P(^PHARET(pharRowid,"I",childSub),"^",5) 
    ...s bfee=$g(bfee)+fee
    ...s ^TEMPDHCWL($j,oeori,"disOeoreFee")=$g(^TEMPDHCWL($j,oeori,"disOeoreFee"))+fee ;add by czx
    ...s admId=$P(^PHARET(pharRowid,"I",childSub),"^",8) 
    ...s papmi=$p(^PAADM(admId),"^",1)
    ...s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	...s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
  	...s ord=+oeori
  	...w date_"^"_fee
  	...i oeori="24||4" b
  	...s ordSub=$p(oeori,"||",2)
  	...s arcitmast=$P($G(^OEORD(ord,"I",ordSub,1)),"^",2)
  	...s arc=+arcitmast
  	...s arcverson=$p(arcitmast,"||",2)
  	...s arcItmDesc=$p(^ARCIM(arc,arcverson,1),"^",2)
    ...d OutputRow16
  	
  
  	
 	
 	k ^TEMPDHCWL($j)  ;以后注意这里不要忘掉
    Quit $$$OK
    
OutputRow16
    s data=$lb(admId,papmiNo,papmiName,arcim,arcItmDesc,fee)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetDifDisReDetailFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDifDisReDetailFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDifDisReDetailFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDifDisReDetailFeeExecute ]
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
