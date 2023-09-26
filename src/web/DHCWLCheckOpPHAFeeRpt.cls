Class web.DHCWLCheckOpPHAFeeRpt Extends %Persistent [ Not ProcedureBlock ]
{

/// Creator?      czx
/// CreatDate?    2016-12     
/// description:  统计收入总金额、发药总金额收入、收入多于发药总金额、发药多于收入总金额
/// Table?        DHCworkLoad:收入表,DHC_PHDISPEN: 门诊发药主表,
///               DHC_PHDISITEM:门诊发药子表 DHC_PHRETURN：退药主表？DHC_PHRETITM：退药子表？PHCPoison:管制分类表
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       收入总费用、发药总费用、收入比发药多费用、发药比收入多费用
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","CheckOpPHAFeeRpt","2021-03-01","2021-07-19","0","") 
Query CheckOpPHAFeeRpt(startDate As %String, endDate As %String, dep As %String, hosId As %String) As %Query(ROWSPEC = "totalWlFee:%Float,totalDisFee:%Float,totalWLBig:%Float,totalDisBig:%Float") [ SqlProc ]
{
}

ClassMethod CheckOpPHAFeeRptExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, dep As %String, hosId As %String) As %Status
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
  	..q:(type="I")||(type="H")
  	..s recDep=$p(^DHCWorkLoad(wlid),"^",1) ;接收科室 2016-10-20
  	..q:(recDep'=dep)&&(dep'=0) ;过滤科室
  	..s hosDr=$p(^CTLOC(recDep),"^",22)
  	..q:((","_hosId_",")'[(","_hosDr_","))&&($g(hosId)'="")
  	..s itemCate=$p(^DHCWorkLoad(wlid),"^",9)           ;医嘱子分类WorkLoad_ItemCat_Dr	
  	..q:'$d(^ARC("IC",0,"OrderType","R",itemCate))      ;非药品不统计
  	..s fee=$p(^DHCWorkLoad(wlid),"^",16)
  	..s afee=$g(afee)+fee
  	..s oeori=$p(^DHCWorkLoad(wlid),"^",21)
  	..s totalWlFee=$g(totalWlFee)+fee
  	..s ^TEMPDHCWL($j,oeori,"wlOeoriFee")=$g(^TEMPDHCWL($j,oeori,"wlOeoriFee"))+fee
    b ;总，收入
    
    //取发药表数据
    f date=sDate:1:eDate d
	.s phl=0
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:phl=""  d	//通过发药主表DHC_PHDISPEN日期索引得到DHC_PHLOC(药房科室)的Rowid
	..s phLoc=$p($g(^DHCPHLOC(phl)),"^",1)	//DHC_PHLOC(药房科室)
	..q:(phLoc'=dep)&&(dep'=0) ;过滤科室
	..s hosDr=$p(^CTLOC(phLoc),"^",22)
    ..q:((","_hosId_",")'[(","_hosDr_","))&&($g(hosId)'="")
	..s phId=0
	..f  s phId=$o(^DHCPHDISPi("FYDATE",date,phl,phId)) q:phId=""  d //得到发药表DHC_PHDISPEN 的Rowid
	...s phSub=""
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:phSub=""  d  
	....s oeori=$p(^DHCPHDI(phId,"PHDI",phSub),"^",5)
	....s phFee=$p(^DHCPHDI(phId,"PHDI",phSub),"^",3)
	....;b ;22
	....;s totalDisFee=$g(totalDisFee)+phFee	 
	....;s ^TEMPDHCWL($j,oeori,"disOeoreFee")=$g(^TEMPDHCWL($j,oeori,"disOeoreFee"))+phFee
	....s phDicSub="" f  s phDicSub=$o(^DHCPHDI(phId,"PHDI",phSub,"INCLB",phDicSub)) q:phDicSub=""  d
	.....s phFee=$p(^DHCPHDI(phId,"PHDI",phSub,"INCLB",phDicSub),"^",8) 
  	.....s ^TEMPDHCWL($j,oeori,"disOeoreFee")=$g(^TEMPDHCWL($j,oeori,"disOeoreFee"))+phFee //门诊进价金额
  	.....s totalDisFee=$g(totalDisFee)+phFee

	;b ;发药
	
	//科室退药
	s fee=0
	f redate=sDate:1:eDate d
	.s phLoci=0
	.f  s phLoci=$o(^DHCPHRETi(redate,phLoci)) q:phLoci=""  d 
	..s phaLoc=$p($g(^DHCPHLOC(phLoci)),"^",1)	//DHC_PHLOC(药房科室)
	..q:(phaLoc'=dep)&&(dep'=0) ;过滤科室
	..s hosDr=$p(^CTLOC(phaLoc),"^",22)
    ..q:((","_hosId_",")'[(","_hosDr_","))&&($g(hosId)'="")
	..s phrId=0
	..f  s phrId=$o(^DHCPHRETi(redate,phLoci,phrId)) q:phrId=""  d
	...s phrItem=""
	...f  s phrItem=$o(^DHCPHRTI(phrId,"RTI",phrItem)) q:phrItem=""  d	
	....s oeori=$p(^DHCPHRTI(phrId,"RTI",phrItem),"^",2)
	....s phFee=0-$p($g(^DHCPHRTI(phrId,"RTI",phrItem)),"^",1)
	....s fee=$g(fee)+phFee
	....s totalDisFee=$g(totalDisFee)+phFee
	....s ^TEMPDHCWL($j,oeori,"disOeoreFee")=$g(^TEMPDHCWL($j,oeori,"disOeoreFee"))+phFee
	;b ;退药
	
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
    b ;the end
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

ClassMethod CheckOpPHAFeeRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckOpPHAFeeRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CheckOpPHAFeeRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckOpPHAFeeRptExecute ]
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
/// description:  统计医嘱明细数据(收入大于发药)
/// Table?        DHC_WorkLoad:收入表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "医嘱Id","医嘱项Id","医嘱项目名称","费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","GetWLBigDisFee","2021-03-01","2021-07-19","0","")
Query GetWLBigDisFee(startDate As %String, endDate As %String, dep As %String, hosId = "") As %Query(ROWSPEC = "wlOeori:%String,arcim:%String,arcimDes:%String,fee:%Float") [ SqlProc ]
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
    d CheckDrugData^DHCWLCheckOpPHAData(startDate,endDate,dep,hosId)
    b 	;after CheckDrugData
	
	s oeori=0 f  s oeori=$o(^TEMPDHCWLCheck($j,"wlbig",oeori)) q:oeori=""  d
 	.s fee=$g(^TEMPDHCWLCheck($j,"wlbig",oeori))
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
    .d OutputRow2
    
    
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLCheck($j)
    Quit $$$OK
    	
OutputRow2
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
/// description:  统计医嘱明细数据(发药大于发药收入)
/// Table?        DHC_WorkLoad:收入表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "医嘱Id","医嘱项Id","医嘱项目名称","费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","GetDisBigWLFee","2021-03-01","2021-07-19","0","")
Query GetDisBigWLFee(startDate As %String, endDate As %String, dep As %String, hosId As %String = "") As %Query(ROWSPEC = "wlOeori:%String,arcim:%String,arcimDes:%String,fee:%Float") [ SqlProc ]
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
    d CheckDrugData^DHCWLCheckOpPHAData(startDate,endDate,dep,hosId)	
    b ;test
	s oeori=0 f  s oeori=$o(^TEMPDHCWLCheck($j,"disbig",oeori)) q:oeori=""  d
 	.s fee=$g(^TEMPDHCWLCheck($j,"disbig",oeori))
 	.s ^TEMPDHCWL($j,"oeoriFee",oeori)=$g(^TEMPDHCWL($j,"oeoriFee",oeori))+fee
 	
 	s oeori=0 f  s oeori=$o(^TEMPDHCWL($j,"oeoriFee",oeori)) q:oeori=""  d
    .s ord=+oeori
 	.s ordSub=$p(oeori,"||",2)
 	.s arcim=$P($G(^OEORD(ord,"I",ordSub,1)),"^",2)
 	.s arcSub=+arcim
 	.s arcVer=$p(arcim,"||",2) 
 	.s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
 	.s fee=$g(^TEMPDHCWL($j,"oeoriFee",oeori))
    .d OutputRow3
    k ^TEMPDHCWL($j)
    k ^TEMPDHCWLCheck($j)
    Quit $$$OK
    	
OutputRow3
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

/// Creator?      czx
/// CreatDate?    2016-12 
/// description:  统计收入明细数据(收入大于发药)
/// Table?        DHC_WorkLoad:收入表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "就诊ID","病人姓名",,"收费项目Id","收费项目名称",数量、费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","GetDiffWLDetailFee","0","2020-02-01","2020-03-31","407||7") 
Query GetDiffWLDetailFee(dep As %String, startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcim:%String,arcimDes:%String,fee:%Float,ordDate:%String,flag:%String") [ SqlProc ]
{
}

ClassMethod GetDiffWLDetailFeeExecute(ByRef qHandle As %Binary, dep As %String, startDate As %String, endDate As %String, oeori As %String) As %Status
{
	n (qHandle,oeori,startDate,endDate,dep)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	q:oeori="" $$$OK
	s sDate=$zdh(startDate,3) ;add by czx
	s eDate=$zdh(endDate,3)   ;add by czx
    k ^TEMPDHCWL($j)
                       
    /*
    f date=sDate:1:eDate  d
    .s wlid=0 f  s wlid=$o(^DHCWorkLoad(0,"DateOEORI",date,oeori,wlid)) q:wlid=""  d
    ..s amount=$p(^DHCWorkLoad(wlid),"^",15)
  	..s fee=$p(^DHCWorkLoad(wlid),"^",16)
  	..s type=$p(^DHCWorkLoad(wlid),"^",4)
    ..q:type="I"
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
    ..d OutputRow4
    */
    s wlid="" f  s wlid=$o(^DHCWorkLoad(0,"OEORI",oeori,wlid)) q:wlid=""  d
    .;b ;test
    .s recDep=$p(^DHCWorkLoad(wlid),"^",1)
    .q:(dep'=0)&&(dep'=recDep)
    .s amount=$p(^DHCWorkLoad(wlid),"^",15)
  	.s fee=$p(^DHCWorkLoad(wlid),"^",16)
  	.s type=$p(^DHCWorkLoad(wlid),"^",4)
    .q:type="I"
    .s itemCate=$p(^DHCWorkLoad(wlid),"^",9)           ;医嘱子分类	
    .q:'$d(^ARC("IC",0,"OrderType","R",itemCate))      ;非药品不统计
    .s ordDate=$p(^DHCWorkLoad(wlid),"^",5)  ;add by czx
  	.s admId=$p(^DHCWorkLoad(wlid),"^",12)
  	.s arcim=$p(^DHCWorkLoad(wlid),"^",2) 
  	.s ^TEMPDHCWL($j,ordDate,admId,arcim,"DrugFee")=$g(^TEMPDHCWL($j,ordDate,admId,arcim,"DrugFee"))+fee
  	;b ;test
  	
  	
  	s date="" f  s date=$o(^TEMPDHCWL($j,date)) q:date=""  d
  	.;b ;000
  	.s flag=0
  	.s admId=0 f  s admId=$o(^TEMPDHCWL($j,date,admId)) q:admId=""  d
    ..s papmi=$p(^PAADM(admId),"^",1)
    ..s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	..s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
    ..s arcim=0 f  s arcim=$o(^TEMPDHCWL($j,date,admId,arcim)) q:arcim=""  d
    ...s arcSub=+arcim
 	...s arcVer=$p(arcim,"||",2) 
 	...s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
    ...s fee=$g(^TEMPDHCWL($j,date,admId,arcim,"DrugFee"))
    ...i (date<sDate)||(date>eDate)  s flag=1
    ...s ordDate=$zd(date,3)
    ...d OutputRow4
    
    k ^TEMPDHCWL($j)
    Quit $$$OK
    	
OutputRow4
    s data=$lb(admId,papmiNo,papmiName,arcim,arcimDes,fee,ordDate,flag)
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

/// Creator?      czx
/// CreatDate?    2016-12
/// description:  统计门诊发药明细数据(收入多于发药)
/// Table?        DHC_PHDISPEN: 门诊发药主表,DHC_PHDISITEM:门诊发药子表   
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?      "发药科室Id"、"发药科室名称"、"医嘱项"、"数量"、"单价"、"费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","GetDifDisDetailFee","0","2020-02-01","2020-03-31","407||7") 
/// phldr:%String,phalocDesc:%String,
Query GetDifDisDetailFee(dep As %String, startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcitmast:%String,arcItmDesc:%String,fee:%Float,fyDate:%String,flag:%String") [ SqlProc ]
{
}

ClassMethod GetDifDisDetailFeeExecute(ByRef qHandle As %Binary, dep As %String, startDate As %String, endDate As %String, oeori As %String) As %Status
{
	n (qHandle,oeori,startDate,endDate,dep)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    q:oeori="" $$$OK
    s sDate=$zdh(startDate,3)
    s eDate=$zdh(endDate,3)
    k ^TEMPDHCWL($j)
	
	/*
	//取发药表数据
    f date=sDate:1:eDate d
	.s phl=0
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:phl=""  d	//通过发药主表DHC_PHDISPEN日期索引得到DHC_PHLOC(药房科室)的Rowid
	..;s phLoc=$p($g(^DHCPHLOC(phl)),"^",1)	//DHC_PHLOC(药房科室)
	..;b ;1
	..;q:(phLoc'=dep)&&(dep'=0) ;过滤科室
	..s phId=0
	..f  s phId=$o(^DHCPHDISPi("FYDATE",date,phl,phId)) q:phId=""  d //得到发药表DHC_PHDISPEN 的Rowid
	...s phSub=""
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:phSub=""  d  
	....s oeori1=$p(^DHCPHDI(phId,"PHDI",phSub),"^",5)
	....I oeori1="5120||3" b ; 2222
	....q:oeori1'=oeori
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2)
	....s arcitmast=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	....s arcSub=+arcitmast
 	....s arcVer=$p(arcitmast,"||",2) 
 	....s arcimDesc=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
	....s admId=$p(^OEORD(ord),"^",1)
	....s papmi=$p(^PAADM(admId),"^",1)
    ....s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	....s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
	....s fee=$p(^DHCPHDI(phId,"PHDI",phSub),"^",3)
	....d OutputRow5
	*/
	
	
	s phId="" f  s phId=$o(^DHCPHDI(0,"OEORI",oeori,phId)) q:phId=""  d
    .s phSub="" f  s phSub=$o(^DHCPHDI(0,"OEORI",oeori,phId,phSub)) q:phSub=""  d
    ..s fyDate=$p(^DHCPHDISP(phId),"^",3)
    ..s phl=$p(^DHCPHDISP(phId,1),"^",1)
    ..s phLoc=$p($g(^DHCPHLOC(phl)),"^",1)	//DHC_PHLOC(药房科室)
    ..;b ;000
    ..q:(phLoc'=dep)&&(dep'=0) ;过滤科室
    ..s ord=+oeori
	..s ordSub=$p(oeori,"||",2)
	..s arcitmast=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	..s admId=$p(^OEORD(ord),"^",1)
	..s fee=$p(^DHCPHDI(phId,"PHDI",phSub),"^",3)
	..q:fyDate=""
	..s ^TEMPDHCWL($j,fyDate,admId,arcitmast,"fee")=$g(^TEMPDHCWL($j,fyDate,admId,arcitmast,"fee"))+fee
	b ;test
	s mfyDate="" f  s mfyDate=$o(^TEMPDHCWL($j,mfyDate)) q:mfyDate=""  d
	.s flag=0
	.s admId="" f  s admId=$o(^TEMPDHCWL($j,mfyDate,admId)) q:admId=""  d
	..s arcitmast="" f  s arcitmast=$o(^TEMPDHCWL($j,mfyDate,admId,arcitmast)) q:arcitmast=""  d 
	...s arcSub=+arcitmast
 	...s arcVer=$p(arcitmast,"||",2) 
 	...s arcItmDesc=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
	...s papmi=$p(^PAADM(admId),"^",1)
    ...s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	...s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
  	...s fee=$g(^TEMPDHCWL($j,mfyDate,admId,arcitmast,"fee"))
  	...i (mfyDate<sDate)||(mfyDate>eDate)  s flag=1
  	...s fyDate=$zd(mfyDate,3)
  	...d OutputRow5
	
	k ^TEMPDHCWL($j)  
    Quit $$$OK
    	
OutputRow5
    s data=$lb(admId,papmiNo,papmiName,arcitmast,arcItmDesc,fee,fyDate,flag)
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
/// description:  统计门诊账单明细(收入大于发药)
/// Table?        DHC_PatientBill:账单主表、DHC_PatBillOrder:账单子表、DHC_PatBillDetails:账单明细表  
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?       "就诊ID","病人姓名","收费项目Id","收费项目名称",数量、费用",!
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","GetDiffPBDetailFee","2017-07-04","2017-07-04","484||9") 
Query GetDiffPBDetailFee(startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcim:%String,arcItmDesc:%String,fee:%Float,ordDate:%String,flag:%String") [ SqlProc ]
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
                  
    
    /*
    f date=sDate:1:eDate d
    .s pbId=0 f  s pbId=$o(^DHCPB(0,"BILLDATE",date,pbId)) q:pbId=""  d
    ..s pboId=0 f  s pboId=$o(^DHCPB(0,"BILLDATE",date,pbId,pboId)) q:pboId=""  d
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
   	*/
   	
    s pbId=0 f  s pbId=$o(^DHCPBi(0,"OEORI",oeori,pbId)) q:pbId=""  d
    .s pboId=0 f  s pboId=$o(^DHCPBi(0,"OEORI",oeori,pbId,pboId)) q:pboId=""  d
    ..s payedFlag=$p(^DHCPB(pbId),"^",16)
    ..q:(payedFlag'="P")
    ..q:'$d(^DHCPB(pbId,"O",pboId))
    ..s admId=$p(^DHCPB(pbId),"^",1)  ;就诊Id
    ..s arcim=$P(^DHCPB(pbId,"O",pboId),"^",3)
    ..s fee=$P(^DHCPB(pbId,"O",pboId),"^",8)
    ..;s ordDate=$P(^DHCPB(pbId,"O",pboId),"^",12)
    ..s updateDate=$P(^DHCPB(pbId),"^",19)
    ..w pbId_","_updateDate_","_fee,!
    ..s ^TEMPDHCWL($j,updateDate,admId,arcim,"DrugFee")=$g(^TEMPDHCWL($j,updateDate,admId,arcim,"DrugFee"))+fee
    b ;middle
    
    s fee=0,amount=0
    s date="" f  s date=$o(^TEMPDHCWL($j,date)) q:date=""  d
    .s flag=0
    .s admId=0 f  s admId=$o(^TEMPDHCWL($j,date,admId)) q:admId=""  d
    ..s papmi=$p(^PAADM(admId),"^",1)
    ..s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	..s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
    ..s arcim=0 f  s arcim=$o(^TEMPDHCWL($j,date,admId,arcim)) q:arcim=""  d
    ...s arc=+arcim
  	...s arcverson=$p(arcim,"||",2)
  	...s arcItmDesc=$p(^ARCIM(arc,arcverson,1),"^",2)         ;医嘱项
    ...s fee=$g(^TEMPDHCWL($j,date,admId,arcim,"DrugFee"))
    ...i (date<sDate)||(date>eDate)  s flag=1
    ...s ordDate=$zd(date,3)
    ...d OutputRow6
   
    
    
 	k ^TEMPDHCWL($j)
    Quit $$$OK
    	
OutputRow6
    s data=$lb(admId,papmiNo,papmiName,arcim,arcItmDesc,fee,ordDate,flag)
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
///  description:  统计门诊退药明细数据(收入多于发药)
///  Table?       DHC_PHRETURN：退药主表？DHC_PHRETITM：退药子表
///  Input?        startDate(开始日期),endDate(结束日期)
///  Output?      "发药科室Id"、"发药科室名称"、"医嘱项"、"数量"、"单价"、"费用"
///  d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","GetDifDisReDetailFee","2018-04-12","2018-04-12","584||4") 
///  phldr:%String,phalocDesc:%String,
Query GetDifDisReDetailFee(dep As %String, startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcitmast:%String,arcItmDesc:%String,fee:%Float,reDate:%String,flag:%String") [ SqlProc ]
{
}

ClassMethod GetDifDisReDetailFeeExecute(ByRef qHandle As %Binary, dep As %String, startDate As %String, endDate As %String, oeori As %String) As %Status
{
	n (qHandle,oeori,startDate,endDate,dep)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    q:oeori="" $$$OK
    s sDate=$zdh(startDate,3)
    s eDate=$zdh(endDate,3)
    k ^TEMPDHCWL($j)
	
	//科室退药
	/*
	f redate=sDate:1:eDate d
	.s phLoci=0
	.f  s phLoci=$o(^DHCPHRETi(redate,phLoci)) q:phLoci=""  d 
	..;s phaLoc=$p($g(^DHCPHLOC(phLoci)),"^",1)	//DHC_PHLOC(药房科室)
	..;q:(phaLoc'=dep)&&(dep'=0) ;过滤科室
	..s phrId=0
	..f  s phrId=$o(^DHCPHRETi(redate,phLoci,phrId)) q:phrId=""  d
	...s phrItem=""
	...f  s phrItem=$o(^DHCPHRTI(phrId,"RTI",phrItem)) q:phrItem=""  d	
	....s oeori1=$p(^DHCPHRTI(phrId,"RTI",phrItem),"^",2)
	....i oeori1="64720||7" b ;3333
	....q:oeori1'=oeori
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2)
	....s admId=$p(^OEORD(ord),"^",1)
	....s papmi=$p(^PAADM(admId),"^",1)
    ....s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	....s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
	....s arcitmast=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	....s arcSub=+arcitmast
 	....s arcVer=$p(arcitmast,"||",2) 
 	....s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
 	....s fee=$p($g(^DHCPHRTI(phrId,"RTI",phrItem)),"^",1) ;add in 2016-12-07
    ....d OutputRow7
    */
    
    
    s phrId=0 f  s phrId=$o(^DHCPHRTIi(oeori,"ORDI",phrId)) q:phrId=""  d
    .s phrItem=0 f  s phrItem=$o(^DHCPHRTIi(oeori,"ORDI",phrId,phrItem)) q:phrItem=""  d
    ..s phloc=$p(^DHCPHRET(phrId),"^",7)
    ..s phaLoc=$p($g(^DHCPHLOC(phloc)),"^",1)
    ..q:(phaLoc'=dep)&&(dep'=0) ;过滤科室
  	..s ord=+oeori
	..s ordSub=$p(oeori,"||",2)
	..s admId=$p(^OEORD(ord),"^",1)
	..s arcitmast=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	..s fee=$p($g(^DHCPHRTI(phrId,"RTI",phrItem)),"^",1)
	..s reDate=$p(^DHCPHRET(phrId),"^",2)
	..s ^TEMPDHCWL($j,reDate,admId,arcitmast,"fee")=$g(^TEMPDHCWL($j,reDate,admId,arcitmast,"fee"))+fee
	b ;test
	s fee=0,amount=0
    s reDate="" f  s reDate=$o(^TEMPDHCWL($j,reDate)) q:reDate=""  d
    .s flag=0
    .s admId=0 f  s admId=$o(^TEMPDHCWL($j,reDate,admId)) q:admId=""  d
    ..s papmi=$p(^PAADM(admId),"^",1)
    ..s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	..s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
    ..s arcim=0 f  s arcim=$o(^TEMPDHCWL($j,reDate,admId,arcim)) q:arcim=""  d
    ...s arcSub=+arcim
 	...s arcVer=$p(arcim,"||",2) 
 	...s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
 	...s fee=$g(^TEMPDHCWL($j,reDate,admId,arcim,"fee"))
 	...i (reDate<sDate)||(reDate>eDate)  s flag=1
 	...s reDate=$zd(reDate,3)
 	...d OutputRow7
  
  	
 	
 	k ^TEMPDHCWL($j)
    Quit $$$OK
    
OutputRow7
    s data=$lb(admId,papmiNo,papmiName,arcim,arcimDes,fee,reDate,flag)
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

/// Creator?      czx
/// CreatDate?    2017-07
/// description:  统计门诊隔日发药明细数据(收入多于发药)
/// Table?        DHC_PHDISPEN: 门诊发药主表,DHC_PHDISITEM:门诊发药子表   
/// Input?        startDate(开始日期),endDate(结束日期)
/// Output?      "发药科室Id"、"发药科室名称"、"医嘱项"、"数量"、"单价"、"费用"
/// d ##class(%ResultSet).RunQuery("web.DHCWLCheckOpPHAFeeRpt","GetAfterDisDetailFee","2017-06-15","2017-06-15","316||11") 
/// phldr:%String,phalocDesc:%String,
Query GetAfterDisDetailFee(startDate As %String, endDate As %String, oeori As %String) As %Query(ROWSPEC = "admId:%String,papmiNo:%String,papmiName:%String,arcitmast:%String,arcItmDesc:%String,fee:%Float,fyDate:%String") [ SqlProc ]
{
}

ClassMethod GetAfterDisDetailFeeExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, oeori As %String) As %Status
{
	n (qHandle,oeori,startDate,endDate,dep)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
    q:oeori="" $$$OK
    s sDate=$zdh(startDate,3)
    s eDate=$zdh(endDate,3)
    k ^TEMPDHCWL($j)
    
    
    f date=sDate:1:eDate d
    .s pbId=0 f  s pbId=$o(^DHCPB(0,"BILLDATE",date,pbId)) q:pbId=""  d
    ..s pboId=0 f  s pboId=$o(^DHCPB(0,"BILLDATE",date,pbId,pboId)) q:pboId=""  d
    ...q:'$d(^DHCPB(pbId,"O",pboId))
    ...s oeoriId=$P(^DHCPB(pbId,"O",pboId),"^",4)
    ...;b ;8888
    ...q:oeoriId'=oeori
    ...s phId="" f  s phId=$o(^DHCPHDI(0,"OEORI",oeori,phId)) q:phId=""  d
    ....s phSub="" f  s phSub=$o(^DHCPHDI(0,"OEORI",oeori,phId,phSub)) q:phSub=""  d
    .....s fyDate=$p(^DHCPHDISP(phId),"^",3)
    .....i (phId'="")&&(phSub'="")&&(fyDate'=date) d
    ......s ord=+oeori
	......s ordSub=$p(oeori,"||",2)
	......s arcitmast=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	......s admId=$p(^OEORD(ord),"^",1)
	......s fee=$p(^DHCPHDI(phId,"PHDI",phSub),"^",3)
	......s ^TEMPDHCWL($j,fyDate,admId,arcitmast,"DrugFee")=$g(^TEMPDHCWL($j,fyDate,admId,arcitmast,"DrugFee"))+fee
	
	s fyDate="" f  s fyDate=$o(^TEMPDHCWL($j,fyDate)) q:fyDate=""  d
	.s flag=0
	.s admId="" f  s admId=$o(^TEMPDHCWL($j,fyDate,admId)) q:admId=""  d
	..s arcitmast="" f  s arcitmast=$o(^TEMPDHCWL($j,fyDate,admId,arcitmast)) q:arcitmast=""  d
	...s arcSub=+arcitmast
 	...s arcVer=$p(arcitmast,"||",2) 
 	...s arcItmDesc=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
 	...s papmi=$p(^PAADM(admId),"^",1)
    ...s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	...s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
  	...s fee=$g(^TEMPDHCWL($j,fyDate,admId,arcitmast,"DrugFee"))
  	...i (fyDate<sDate)||(fyDate>eDate)  s flag=1
  	...s fyDate=$zd(fyDate,3)
	...d OutputRow8
    
    
	/*
	//取发药表数据
    f date=sDate:1:eDate d
	.s phl=0
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:phl=""  d	//通过发药主表DHC_PHDISPEN日期索引得到DHC_PHLOC(药房科室)的Rowid
	..;s phLoc=$p($g(^DHCPHLOC(phl)),"^",1)	//DHC_PHLOC(药房科室)
	..;b ;1
	..;q:(phLoc'=dep)&&(dep'=0) ;过滤科室
	..s phId=0
	..f  s phId=$o(^DHCPHDISPi("FYDATE",date,phl,phId)) q:phId=""  d //得到发药表DHC_PHDISPEN 的Rowid
	...s phSub=""
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:phSub=""  d  
	....s oeori1=$p(^DHCPHDI(phId,"PHDI",phSub),"^",5)
	....I oeori1="5120||3" b ; 2222
	....q:oeori1'=oeori
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2)
	....s arcitmast=$p(^OEORD(ord,"I",ordSub,1),"^",2)
	....s arcSub=+arcitmast
 	....s arcVer=$p(arcitmast,"||",2) 
 	....s arcimDes=$P($G(^ARCIM(arcSub,arcVer,1)),"^",2) ;医嘱项
	....s admId=$p(^OEORD(ord),"^",1)
	....s papmi=$p(^PAADM(admId),"^",1)
    ....s papmiNo=$$GetPapmiNo^DHCWLCommon(papmi)
  	....s papmiName=$$GetPapmiName^DHCWLCommon(papmi)
	....s fee=$p(^DHCPHDI(phId,"PHDI",phSub),"^",3)
	....d OutputRow8
	*/
	
	
	k ^TEMPDHCWL($j)
    Quit $$$OK
    	
OutputRow8
    s data=$lb(admId,papmiNo,papmiName,arcitmast,arcItmDesc,fee,fyDate)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetAfterDisDetailFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAfterDisDetailFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAfterDisDetailFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAfterDisDetailFeeExecute ]
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

Storage Default
{
<Data name="DHCWLCheckOpPHAFeeRptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWLCheckOpPHAFeeRptD</DataLocation>
<DefaultData>DHCWLCheckOpPHAFeeRptDefaultData</DefaultData>
<IdLocation>^web.DHCWLCheckOpPHAFeeRptD</IdLocation>
<IndexLocation>^web.DHCWLCheckOpPHAFeeRptI</IndexLocation>
<StreamLocation>^web.DHCWLCheckOpPHAFeeRptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
