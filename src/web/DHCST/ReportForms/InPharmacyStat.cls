/// Description:住院药房相关类报表
/// Creator:    hulihua
/// CreateDate: 2018-07-09
/// Table:
Class web.DHCST.ReportForms.InPharmacyStat Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// Author : MaYuqiang
/// CreateDate : 20171206
/// Description : 根据时间查询各个药房的住院发药进价金额(按照发药类别汇总显示)
/// Input : StartDate - 开始日期 时间 , EndDate - 截止日期 时间 , PhaLocRowid - 发药科室id串 
/// 2018-01-14 09:46:38,2018-01-16 09:46:38,
/// w ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.InPharmacyStat","QueryInDispbyDrugGroup","2021-10-12","2021-10-14","224")
Query QueryInDispbyDrugGroup(StartDate As %String = "", EndDate As %String = "", CTLOCID As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "displocdesc:%String,ordtypedesc:%String,rpamt:%Float") [ SqlProc ]
{
}

ClassMethod QueryInDispbyDrugGroupExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", CTLOCID As %String = "", HOSPID As %String = "") As %Status
{
	s CTLOCID=""
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s CTLOCID=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(CTLOCID)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartTime = $p(StartDate," ",2)
	s StartDate = $p(StartDate," ",1)
	s EndTime = $p(EndDate," ",2)
	s EndDate = $p(EndDate," ",1)
	s PhaLocRowid=CTLOCID

	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate) 
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	
	s intrtypestr="P^Y"
	s intrtypelen=$l(intrtypestr,"^")
	f intrdate=StartDate:1:EndDate d
	.f intrtypenum=1:1:intrtypelen d
	..s intrtype=$p(intrtypestr,"^",intrtypenum)
	..s intrid=""
	..f  s intrid=$o(^DHCINTR(0,"TypeDate",intrtype,intrdate,intrid)) q:intrid=""  d
	...s inclb=$p(^DHCINTR(intrid),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s intrtime=$p(^DHCINTR(intrid),"^",3)	//业务时间
	...q:(StartTime'="")&&(intrdate=StartDate)&&(intrtime<StartTime)
	...q:(EndTime'="")&&(intrdate=EndDate)&&(intrtime>EndTime)
	...s inclb=$p(^DHCINTR(intrid),"^",7)		//科室库存批次id
	...s inci=+inclb
	...s incscdr=$p(^INCI(inci,2),"^",2)
	...s incitype=$p(^INC("SC",incscdr),"^",3)
	...q:incitype'="G"
	...s displocid=$p($g(^INCI(+inclb,"IL",$p(inclb,"||",2))),"^",1)	//发药科室id
	...q:(PhaLocRowid'="")&&((","_PhaLocRowid_",")'[(","_displocid_","))	//过滤发药科室
	...s displocdesc=$p($g(^CTLOC(displocid)),"^",2)
	...s:displocdesc["-" displocdesc=$p(displocdesc,"-",2)
	...s rpamt=+$p(^DHCINTR(intrid),"^",17)		//业务对应进价金额
	...s rpamt=(-1)*rpamt
	...s pointer=$p(^DHCINTR(intrid),"^",9)		//pointer
	...s pmain=+pointer
	...s psub=$p(pointer,"||",2)
	...s pitm=$p(pointer,"||",3)
	...q:+psub=0
	...s ordtype="null"
	...i intrtype="P" d
	....s dodis=$p(^DHCPHAC(pmain,"I",psub,"B",pitm),"^",7)
	....s ordtype=$p(^DHCOEDISQTY(+dodis),"^",27)
	...e  i intrtype="Y" d
	....s dodis=$p($g(^PHARET(pmain,"I",psub)),"^",13)	
	....s ordtype=$p(^DHCOEDISQTY(+dodis),"^",27)	//打包表中的发药类别
	...i ordtype'="null" d
	....i (ordtype="0")||(ordtype="PIVA") d
	.....s ordtypedesc="配液"
	....e  d
	.....s sdgid=$o(^DHCSTDRUGGRP(0,"Code",ordtype,""))		//发药类别表 DHCStkDrugGroup
	.....s ordtypedesc=$s(+sdgid'=0:$p($g(^DHCSTDRUGGRP(sdgid)),"^",2),1:"")		//发药类别描述
	...i ordtypedesc="" s ordtypedesc="未知" 
	...d OutPutInDisp
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutInDisp
 s Data=$lb(displocdesc,ordtypedesc,rpamt)
 s ^CacheTemp(repid,ind)=Data    
 s ind=ind+1
 q
}

/// Desscription:	按照发药类别统计住院的消耗
/// Creator:		hulihua
/// Creatdate:		2014-11-05
/// Input:			StartDate-开始日期，EndDate-结束日期，displocrowid-发药科室，CStTime-开始时间，CEndTime-截止时间
/// Output:         供应商 生产厂家 药品名称 规格 单位 数量 金额
/// others: 		
/// Debug:			d ##Class(%ResultSet).RunQuery("web.DHCST.ReportForms.InPharmacyStat","DispStatByPhaCat","2020-03-01","2020-03-23","244,","","","","ZCY,","")
Query DispStatByPhaCat(StartDate As %String = "", EndDate As %String = "", displocrowid As %String = "", CStTime As %String = "", CEndTime As %String = "", Apcven As %String = "", DrugType As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TName:%String,TDocloc:%String,TUom:%String,TSpec:%String,TQty:%Float,TAmt:%Float,TManfDesc:%String,TVendorDesc") [ SqlProc ]
{
}

ClassMethod DispStatByPhaCatExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", displocrowid As %String = "", CStTime As %String = "", CEndTime As %String = "", Apcven As %String = "", DrugType As %String = "", HOSPID As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s displocrowid  =##class(web.DHCST.ReportForms.ReportCommon).FmtInput(displocrowid)
	s CStTime=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(CStTime)
	s CEndTime=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(CEndTime)
	s Apcven=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(Apcven)
	s DrugType=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(DrugType)
	s HOSPID=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(HOSPID)
	
	s displocrowid=$tr(displocrowid,",","")  //因为润乾下拉数据集传入入参时后面会带一个，逗号，特做处理  2020-03-26 yangsj
	s DrugType=$tr(DrugType,",","")
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i StartDate="" s qHandle=$lb(0,repid,0) q $$$OK
	i EndDate="" s qHandle=$lb(0,repid,0) q $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	i StartDate>EndDate  Set qHandle=$lb(0,repid,0) Quit $$$OK
	s CStTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CStTime)
	s CEndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(CEndTime)
	s pid=..NewPid()
	d ..ClearTmp("DispStatByPhaCat",pid,"locsum1")
	s apcrowid=""
	i Apcven'=""  s apcrowid=$o(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(Apcven),"")) 	
	s strType="P^Y" //统计住院
	s len=$l(strType,"^")
	f i=1:1:len  d
	.s type=$p(strType,"^",i)
	.f date=StartDate:1:EndDate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inci=$p(^DHCINTR(intr),"^",15)
	...q:inci=""
	...q:$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",3)'="G"
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s inciloc=$p($g(^INCI(+inclb,"IL",+$p(inclb,"||",2))),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$p($g(^CTLOC(+inciloc)),"^",22))
	...s time=$p(^DHCINTR(intr),"^",3)
	...q:(CStTime'="")&(date=StartDate)&(time<CStTime)
	...q:(CEndTime'="")&(date=EndDate)&(time>CEndTime)
	...s itmdesc=$p(^INCI(inci,1),"^",2)
	...s tuom=$p(^DHCINTR(intr),"^",10) 
	...s tqty=$p(^DHCINTR(intr),"^",6)
	...s ctuom=$p(^INCI(inci,1),"^",10)   	; basic uom
	...s puom=$p(^INCI(inci,3),"^",6)     ; purchase uom
	...s tamt=$p(^DHCINTR(intr),"^",8)
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s INGR=$o(^DHCINGR(0,"GRI_INCIB",$$CIBrow^at299(inclb),""),-1)
	...i INGR="" d
	....s vendorid="未知",vendordesc="未知"
	...e  d  
	....s vendorid=$p($g(^DHCINGR(INGR)),"^",3)
	....s vendordesc=$p(^APC("APCVM",vendorid),"^",3)
	...s manfdesc=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)	// 厂家应该按发药批次取
	...i apcrowid'="" q:apcrowid'=vendorid
	...i puom="" s puom=ctuom  
	...s phatype=""
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s Ord=+oeori,Chl=$p(oeori,"||",2)
	...q:Ord=""
	...q:'$d(^OEORD(Ord))
	...q:'$d(^OEORD(Ord,"I",Chl))
	...s:type="P" phatype=$p(^DHCPHAC(+pointer),"^",12)
	...s ordept=$p(^OEORD(Ord,"I",Chl,3),"^",6)
	...s docloc=$p(^CTLOC(ordept),"^",2)
	...s:type="P" ordept=$p(^DHCPHAC(+pointer),"^",1)
	...s:type="Y" ordept=$p(^PHARET(+pointer),"^",5)
	...q:(displocrowid'="全部")&&(displocrowid'=ordept)&&(displocrowid'="")
	...//取发药类别
	...s arcim=$p(^OEORD(Ord,"I",Chl,1),"^",2)
	...s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	...s arcimcat=$P(^ARCIM(sub,ver,1),"^",10)
	...s ArcCatCode=$p(^ARC("IC",arcimcat),"^",1)                       			;医嘱子类代码
	...s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
    ...s Priority=$p(^OECPR(PriorDr),"^",1) 			;医嘱优先级代码
    ...i Priority="OUT"  d
    ....s Cat="OUT"   						;需定义出院带药类别的代码为OUT  
    ...e  d
	....s Cat=##class(web.DHCSTPCHCOLLS).GetCat(ArcCatCode)              ;医嘱子类对应的发药类别
	...q:(DrugType'=Cat)&&(DrugType'="全部")&&(DrugType'="OUT")&&(DrugType'="")
	...q:(phatype'=DrugType)&&(DrugType="OUT")
	...i $f(docloc,"-") s docloc=$P(docloc,"-",2)
	...s tqty=-tqty
	...s tamt=-tamt
	...s uomdesc=$p(^CT("UOM",tuom),"^",2)
	...i $d(^TMP("DHCINPHA",$this,"DispStatByPhaCat",pid,"locsum1",inci))  d             
	....s $p(^TMP("DHCINPHA",$this,"DispStatByPhaCat",pid,"locsum1",inci),"^",5)=+$p(^TMP("DHCINPHA",$this,"DispStatByPhaCat",pid,"locsum1",inci),"^",5)+tqty
	....s $p(^TMP("DHCINPHA",$this,"DispStatByPhaCat",pid,"locsum1",inci),"^",6)=+$p(^TMP("DHCINPHA",$this,"DispStatByPhaCat",pid,"locsum1",inci),"^",6)+tamt
	...e  d
	....s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) //规格
	....s ^TMP("DHCINPHA",$this,"DispStatByPhaCat",pid,"locsum1",inci)=itmdesc_"^"_docloc_"^"_uomdesc_"^"_spec_"^"_tqty_"^"_tamt_"^"_manfdesc_"^"_vendordesc
	s inc=""
	f  s inc=$O(^TMP("DHCINPHA",$this,"DispStatByPhaCat",pid,"locsum1",inc)) q:inc=""  d
	.set tmp=^(inc)
	.s tmpqty=$p(tmp,"^",5)
	.s tmpamt=$p(tmp,"^",6)
	.q:(+tmpqty=0)&&(+tmpamt=0)
	.set Data=$LISTFROMSTRING(tmp,"^")
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	d ..ClearTmp("DispStatByPhaCat",pid,"locsum1")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// -------yangsj----2019-10-28 ----报表内容集中整理------Start-------//////
/// Creator：     Wangwulong
/// CreatDate：   2018-12-28
/// Description:：药品消耗信息
/// Table：       DHC_INTRANS
/// Input：       开始日期,截止日期,医院ID
/// Return：         
/// Others：    d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.InPharmacyStat","QueryDispDetail","2019-09-01","2019-11-01","2")
Query QueryDispDetail(StartDate As %String = "", EndDate As %String = "", HospId As %String = "", Inc As %String = "", ManfId As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "SeqNum:%String,IncDesc:%String,VenDesc:%String,Posion:%String,PurlanType:%String,Spec:%String,Dept:%String,Uom:%String,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Hosp:%String,Manf:%String") [ SqlProc ]
{
}

ClassMethod QueryDispDetailExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String, hospId As %String = "", inc As %String = "", ManfId As %String = "", HOSPID As %String = "") As %Status
{
	//s ^YSJTMP("QueryDispDetailExecute")=$LB(startDate , endDate, hospId , inc , ManfId , HOSPID )
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i startDate="" q $$$OK
	i endDate="" q $$$OK
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s pid=..NewPid()
	
	i hospId="" s hospId=HOSPID
 	
	s typeStr="P^Y^F^H^HC^PH^YH^FH^HH"
	s n=0
	s cnt=$l(typeStr,"^")
	f i=1:1:cnt d
	.s type=$p(typeStr,"^",i)
	.f date=startDate:1:endDate d
	..s intrId=""
	..f  s intrId=$o(^DHCINTR(0,"TypeDate",type,date,intrId)) q:intrId=""  d
	...s inclbId=$p(^DHCINTR(intrId),"^",7)
	...q:inclbId=""
	...s incIb=$p(^INCI($p(inclbId,"||",1),"IL",$p(inclbId,"||",2),"LB",$p(inclbId,"||",3)),"^",1)
	...s locId=$p(^INCI($p(inclbId,"||",1),"IL",$p(inclbId,"||",2)),"^",1)
	...s tmpHospId=$p(^CTLOC(locId),"^",22)
	...q:(hospId'="")&(tmpHospId'=hospId)
 	...s hosp=""
 	...s:hospId'="" hosp=$p(^CT("HOSP",hospId),"^",2)	
    ...s inciId=+inclbId
    ...s inciDesc=$p(^INCI(inciId,1),"^",2)            	  //药品商品名称
    ...s inciCode=$p(^INCI(inciId,1),"^",1)               //药品自编码  
    ...q:(inc'="")&(inciDesc'[inc)
	...s stkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inciId)
	...s stkType=$p(stkGrpInfo,"^",3)
	...q:stkType'="G" 	   	 
  
    ...s pointer=$p(^DHCINTR(intrId),"^",9)
    ...s dept=##Class(web.DHCST.ReportForms.ReportCommon).GetDept(type,pointer)
    ...i dept="" s dept="*"
    ...s sp=$p(^DHCINTR(intrId),"^",14)   //单价
    ...s rp=$p(^DHCINTR(intrId),"^",16)   //进价
    ...s rpAmt=$p(^DHCINTR(intrId),"^",17)   //进价金额
    ...s spAmt=$p(^DHCINTR(intrId),"^",8)   //售价金额
    ...//s price=$fn(price,"",2)
  	...s purUom=$p(^INCI(inciId,3),"^",6) 
 	...s bUom=$p(^INCI(inciId,1),"^",10)  
    ...s qty=$p(^DHCINTR(intrId),"^",6)      //数量
    ...s qty=-qty
    ...s rpAmt=-rpAmt
    ...s spAmt=-spAmt
    ...s ctuomDr=$p(^DHCINTR(intrId),"^",10)   
    ...s pUom=$p(^CT("UOM",ctuomDr),"^",2)
    ...  
    ...//s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(purUom,ctuomDr)
    ...//s qty=qty/fac
    ...//s sp=sp*fac
    ...//s rp=rp*fac   
 	...s vendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(incIb) //查找批次供应商及厂家
 	...s vendr=$p(vendManf,"^",1)
	...s pVenDesc=$p(vendManf,"^",2)
	...i vendr="" s vendr="*"
	...s pManfId=$p(vendManf,"^",3)
	...q:(ManfId'="")&(ManfId'=pManfId)
	...s pManf=$p(vendManf,"^",4) 
	...s posionInfo=##class(web.DHCOutPhCommon).getPoisonByInci(inciId)
	...s posion=$p(posionInfo,"^",3)
	...s purType=##Class(web.DHCST.ReportForms.ReportCommon).GetPulanType(inciId)
	...s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciId)  
	...s index=inclbId_"^"_dept_"^"_sp_"^"_rp
	...i $d(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index))  d
	....s $p(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index),"^",8)=$p(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index),"^",8)+qty
	....s $p(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index),"^",10)=$p(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index),"^",10)+rpAmt
	....s $p(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index),"^",12)=$p(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index),"^",12)+spAmt
	...e  d
	....s ^TMP("DrugTypeTotalAll","QueryDispDetail",pid,index)=inciDesc_"^"_ pVenDesc_"^"_posion_"^"_purType_"^"_spec_"^"_dept_"^"_pUom_"^"_qty_"^"_rp_"^"_rpAmt_"^"_sp_"^"_spAmt_"^"_hosp_"^"_pManf
    s cnt=0
   	s newIndex=""
   	f  s newIndex=$o(^TMP("DrugTypeTotalAll","QueryDispDetail",pid,newIndex))  q:newIndex=""  d
   	.s mData=^TMP("DrugTypeTotalAll","QueryDispDetail",pid,newIndex)
   	.s cnt=cnt+1
   	.s incDesc=$p(mData,"^",1)
   	.s venDesc=$p(mData,"^",2)
   	.s posion=$p(mData,"^",3)
   	.s purlanType=$p(mData,"^",4)
   	.s spec=$p(mData,"^",5)
   	.s dept=$p(mData,"^",6)
   	.s uom=$p(mData,"^",7)
   	.s qty=$p(mData,"^",8)
   	.s rp=$p(mData,"^",9)
   	.s rpAmt=$p(mData,"^",10)
   	.s sp=$p(mData,"^",11)
   	.s spAmt=$p(mData,"^",12)
   	.s hosp=$p(mData,"^",13)
   	.s manf=$p(mData,"^",14)

	.d OutPutRowDispDetail
    k ^TMP("DrugTypeTotalAll","QueryDispDetail",pid)
     q $$$OK
             
OutPutRowDispDetail
	s data=$lb(cnt,incDesc,venDesc,posion,purlanType,spec,dept,uom,qty,rp,rpAmt,sp,spAmt,hosp,manf)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.InPharmacyStat","QueryManf","")

Query QueryManf(manfPar As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "ManfId:%String,Manf:%String") [ SqlProc ]
{
}

ClassMethod QueryManfExecute(ByRef qHandle As %Binary, manfPar As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
    s manfId=0
    f  s manfId=$o(^PHMNF(manfId))  q:manfId=""  d
    .s manf=$p(^PHMNF(manfId),"^",2)
    .q:(HOSPID'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("PH_Manufacturer",manfId,HOSPID)="N")
    .s dhcmanf=$O(^DHCMANF(0,"MANF",manfId,""))
    .s Manftype=""
	.q:(dhcmanf '= "")&&($P(^DHCMANF(dhcmanf),"^",10) = "N")
    .s:dhcmanf'="" Manftype=$P(^DHCMANF(dhcmanf),"^",7)
    .q:(dhcmanf'="")&&(Manftype'="G")
    .q:(manfPar'="")&(manf'[manfPar)
    .d OutPutManf
     q $$$OK
             
OutPutManf
	s data=$lb(manfId,manf)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q
}

/// -------yangsj----2019-10-28 ----报表内容集中整理------End-------//////
/// //================报表整理====yangsj====2019-10-31======Start==================/////////
/// Creator:Kevin_xia
/// CreateDate:2018-11-30
/// Descript:住院发药输液打印汇总
/// Input:日期 以及科室
/// OutPut:	药品名称  规格  单位  数量  病区  "已发,退药"   金额
/// w ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.InPharmacyStat","InfusionSolutions","2020-03-01","2020-03-09","00:00:00","23:59:59","5-Y-5","","")
Query InfusionSolutions(StartDate As %String = "", EndDate As %String = "", StartTime As %String = "", EndTime As %String = "", PHAWardDr As %String = "", CtLoc As %String = "", Priorityid As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "IncDesc,Spec,Uom,DspQty:%Numeric,WarDesc,RetQty:%Numeric,Skin,Money:%Numeric,Qty:%Numeric,PackQty") [ SqlProc ]
{
}

ClassMethod InfusionSolutionsExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", StartTime As %String = "", EndTime As %String = "", PHAWardDr As %String = "", CtLoc As %String = "", Priorityid As %String = "", HOSPID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
    S StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    S EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
    i PHAWardDr="" S PHAWardDr="全部"
    i PHAWardDr'=""   d
    .S WardFlag=$p(PHAWardDr,"-",2)
    .S PHAWardDr=$p(PHAWardDr,"-",1)
	.i WardFlag="Y" s PHAWardLocDr=$p($g(^PAWARD(+PHAWardDr)),"^",5)
	.e  s PHAWardLocDr=PHAWardDr
	S Pid=..NewPid()
   //直接走台账
    S TypeStr="P,Y"
    S TypeLen=$l(TypeStr,",")
    f date=StartDate:1:EndDate  d
    .f k=1:1:TypeLen  d
    ..S Type=$p(TypeStr,",",k)
    ..S IntrId=""
	..f  S IntrId=$o(^DHCINTR(0,"TypeDate",Type,date,IntrId)) Q:IntrId=""  d
	...S DHCIntrData=$g(^DHCINTR(IntrId))
	...s inclb=$p(DHCIntrData,"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...S IntrTime=$p(DHCIntrData,"^",3)
	...q:(date=StartDate)&&(StartTime'="")&&(IntrTime<StartTime)
	...q:(date=EndDate)&&(EndTime'="")&&(IntrTime>EndTime)
	...S Inci=$p(DHCIntrData,"^",15)
    ...S IntrType=$p(DHCIntrData,"^",1) 
	...s catGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci) 
	...q:$p(catGrpStr,"^",3)'="G"        //过滤不是药品的 
	...S InciCode=$p(^INCI(Inci,1),"^",1)	//药品代码
	...S InciDesc=$p(^INCI(Inci,1),"^",2)	//药品名称
	...S PackUomdr=$p(^DHCITMINFO(Inci),"^",51)
	...i PackUomdr'="" S PackUom=$p(^CT("UOM",PackUomdr),"^",2)
	...e  S PackUom=0
	...S PackUomFactor=$p(^DHCITMINFO(Inci),"^",52)
	...S Skin=""        //货位码 
	...S Spec=""
	...S IntrQty=-$p(DHCIntrData,"^",6)   //数量                       //发药取正
	...S OutImp=-$p(DHCIntrData,"^",8)      //售价金额    
	...S InImp=-$p(DHCIntrData,"^",14)  //售价
	...S DspUomDr=$p(DHCIntrData,"^",10)      
	...S DspUom=$p(^CT("UOM",DspUomDr),"^",2)     //单位
	...S Point=$p(DHCIntrData,"^",9)      
	...s inclb=$p(DHCIntrData,"^",7)
	...s incil=$P(inclb,"||",1,2)
	...s Skin=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,"","","")
	...s Skin=$P(Skin,":",2)
	...i Type="P"     d
	....;b  //1.3
	....d IntrDspDetial
	...i Type="Y"     d
	....;b  //1.4
	....d IntrRetDetial
    
    
    S Index=""
	f  S Index=$o(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,Index))  Q:Index=""  D
	.s Inc=""
	.f  S Inc=$o(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,Index,Inc))  Q:Inc=""  D
	..S mdata=^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,Index,Inc)
	..S IncDesc=$p(mdata,"^",1)
	..S Spec=##class(web.DHCSTKUTIL).GetSpec(Inc)        //最后调用方法查询 可以提高查询速度
	..S Uom=$p(mdata,"^",3)
	..S DspQty=$p(mdata,"^",4)
	..S WarDesc=$p(mdata,"^",5)
	..S RetQty=$p(mdata,"^",6)
	..S Skin=""  //货位码   
	..S Money=$p(mdata,"^",8)
	..S Qty=$p(mdata,"^",9)
	..q:Qty="" 
	..S PackUomFactor=$p(mdata,"^",10)
	..S PackUom=$p(mdata,"^",11)
	..i '$d(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc))  d
	...s ^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc)=IncDesc_"^"_Spec_"^"_Uom_"^"_DspQty_"^"_RetQty_"^"_Skin_"^"_Money_"^"_Qty_"^"_PackUomFactor_"^"_PackUom
	..e  d
	...s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc),"^",4)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc),"^",4)+DspQty
	...s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc),"^",5)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc),"^",5)+RetQty
	...s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc),"^",7)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc),"^",7)+Money
	s WarDesc=""
	f  s WarDesc=$o(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc)) q:WarDesc=""  d
	.s Inc=""
	.f  s Inc=$o(^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc)) q:Inc=""  d
	..s IncOutputDATA=^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid,WarDesc,Inc)
	..s IncDesc=$p(IncOutputDATA,"^",1)
	..s Spec=$p(IncOutputDATA,"^",2)
	..s Uom=$p(IncOutputDATA,"^",3)
	..s DspQty=$p(IncOutputDATA,"^",4)
	..s RetQty=$p(IncOutputDATA,"^",5)
	..s Skin=$p(IncOutputDATA,"^",6)
	..s Money=$p(IncOutputDATA,"^",7)
	..s Qty=$p(IncOutputDATA,"^",8)
	..s PackUomFactor=$p(IncOutputDATA,"^",9)
	..s PackUom=$p(IncOutputDATA,"^",10)
	..i PackUom'=0  d 
	...s Qty=DspQty+RetQty
	...S PackQty1=$p((Qty/PackUomFactor),".",1)
	...i PackQty1="" s PackQty1=0
	...S PackQtyPoint=Qty-(PackQty1*PackUomFactor)
	...I (PackQty1=0)&(PackQtyPoint'=0) S PackQty=PackQtyPoint_Uom
	...I (PackQty1'=0)&(PackQtyPoint=0) S PackQty=PackQty1_PackUom
	...I (PackQty1'=0)&(PackQtyPoint'=0) S PackQty=PackQty1_PackUom_PackQtyPoint_Uom
	...I (PackQty1=0)&(PackQtyPoint=0) S PackQty=0
	..e  s PackQty=Qty_Uom ;"未维护包装单位"
	..s DspQty=+DspQty
	..d OutputRow
	;IncDesc,Spec,Uom,DspQty,WarDesc,RetQty,Skin,Money,Qty,PackQty
	k ^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid)
	k ^||TMP("DHCST",$ClassName(),"InfusionSolutions","New",Pid)
	s qHandle=$lb(0,repid,0)
	Quit $$$OK 

IntrDspDetial 
    S DocWareId="",DocWare="",flag=0,PHAWardDra=""
	S PhaId=$p(Point,"||",1)
	S PhaChId=$p(Point,"||",2)
	S PhaType=$p(^DHCPHAC(PhaId),"^",12)  //发药类型
	Q:PhaType'="DSY" -2
	S PhaLoc=$p(^DHCPHAC(PhaId),"^",1)    //药房
	q:(CtLoc'="")&&(CtLoc'=PhaLoc) -1
	S OeOrId=$p(^DHCPHAC(PhaId,"I",PhaChId),"^",7)  //医嘱id
	S Ch=$p(OeOrId,"||",2)
	S Priority=$p(^OEORD(+OeOrId,"I",Ch,1),"^",8)  //优先级1
	q:(Priorityid'="")&(Priority'=Priorityid)
	S OrdDeptDr=$p(^OEORD(+OeOrId,"I",Ch,7),"^",2)       //开单科室
    S DocStr=..DoctorLocRefuse(PhaLoc,OrdDeptDr)      //判断是否为医生科室
    S DoctorFlagb=..DoctorLocRefuse(PhaLoc,PHAWardLocDr)
    s DocWareId=""
    i (DocStr=1)&&(WardFlag="N") d 
    .q:(PHAWardDr'="全部")&&(WardFlag="Y")&&(DoctorFlagb=0)
    .S:(PHAWardDr'="全部") PHAWardDra=PHAWardDr
    .S:(PHAWardDr'="全部")&&(PHAWardDra'=OrdDeptDr) flag=1
    .S DocWareId=OrdDeptDr
    .S DocWare=$p(^CTLOC(DocWareId),"^",2)
    e  d
    .q:(PHAWardDr'="全部")&&(WardFlag="N")&&(DoctorFlagb=1)
    .S DocWareId=$p(^DHCPHAC(PhaId),"^",4)
    .S:(PHAWardDr'="全部")&&(PHAWardDr'=DocWareId) flag=1
    .S:DocWareId'="" DocWare=$p(^PAWARD(DocWareId),"^",2),DocWareId=$p(^PAWARD(DocWareId),"^",5)
    i (PHAWardDr="全部")  d
    .S DocWareId=$p(^DHCPHAC(PhaId),"^",4)
    .i DocWareId'="" S DocWare=$p(^PAWARD(DocWareId),"^",2),DocWareId=$p(^PAWARD(DocWareId),"^",5)
    .e  S DocWareId=OrdDeptDr,DocWare=$p(^CTLOC(DocWareId),"^",2)
    Q:flag=1
    Q:DocWareId="" 
    i $d(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci)) d
    .s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",4)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",4)+IntrQty
    .s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",9)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",9)+IntrQty
    .s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",8)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",8)+OutImp
    e  d
    .s ^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci)= InciDesc_"^"_Spec_"^"_DspUom_"^"_IntrQty_"^"_DocWare_"^"_0_"^"_Skin_"^"_OutImp_"^"_IntrQty_"^"_PackUomFactor_"^"_PackUom
    Q ""
IntrRetDetial
    S DocWareId="",DocWare="",flag=0,PHAWardDrb=""
    S RetId=$p(Point,"||",1)
    S RetChId=$p(Point,"||",2) 
    s RetChLbId=$p(Point,"||",3) 
    S RecLocDr=$p(^PHARET(RetId),"^",5)      //药房
    q:(CtLoc'="")&&(CtLoc'=RecLocDr) -1 
    S OeoriId=$p(^PHARET(RetId,"I",RetChId),"^",1)   //医嘱id
    S PhaType=##Class(web.DHCSTPCHCOLLS).OrdCatType(OeoriId)
    Q:PhaType'="DSY" -2
    
    S DoctorFlag=..DoctorLocRefuse(RecLocDr,PHAWardLocDr)
    S:(PHAWardDr'="全部")&&(DoctorFlag=0)&&(WardFlag="Y") PHAWardDrb=$p(^PAWARD(PHAWardDr),"^",5)  //若入参是病区 直接取病区CtlocId
    S:(PHAWardDr'="全部")&&(DoctorFlag=1)&&(WardFlag="N") PHAWardDrb=PHAWardDr        //若入参是医生科室 则 直接用医生科室
    S Ch=$p(OeoriId,"||",2)
    S Priority=$p(^OEORD(+OeoriId,"I",Ch,1),"^",8)  //优先级2
	q:(Priorityid'="")&(Priority'=Priorityid)
    S OrdDeptDr=$p(^OEORD(+OeoriId,"I",Ch,7),"^",2)     //开单科室
    S DocStr=..DoctorLocRefuse(RecLocDr,OrdDeptDr)      //判断是否为医生科室
    i (DocStr=1)&&(WardFlag="N") d 
    .q:(PHAWardDr'="全部")&&(DoctorFlag=0)&&(WardFlag="Y")
    .S:(PHAWardDr'="全部")&&(PHAWardDrb'=OrdDeptDr) flag=1
    .S DocWareId=OrdDeptDr
    .S DocWare=$p(^CTLOC(DocWareId),"^",2)
    e  d  
    .q:(PHAWardDr'="全部")&&(DoctorFlag=1)&&(WardFlag="N")
    .S DocWareId=$p(^PHARET(RetId),"^",6)
    .S:(PHAWardDr'="全部")&&(PHAWardDrb'=DocWareId) flag=1
    .S:DocWareId'="" DocWare=$p(^CTLOC(DocWareId),"^",2)
    Q:DocWareId=""     
    Q:flag=1
    i (PHAWardDr="全部")&&(DocStr=1)  S DocWareId=OrdDeptDr,DocWare=$p(^CTLOC(DocWareId),"^",2)
    i (PHAWardDr="全部")&&(DocStr'=1) S DocWareId=$p(^PHARET(RetId),"^",6),DocWare=$p(^CTLOC(DocWareId),"^",2)
    i $d(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci)) d
    .s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",6)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",6)+IntrQty
    .s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",9)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",9)+IntrQty
    .s $p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",8)=$p(^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci),"^",8)+OutImp
    e  d
    .s ^||TMP("DHCST",$ClassName(),"InfusionSolutions",Pid,DocWareId,Inci)= InciDesc_"^"_Spec_"^"_DspUom_"^"_0_"^"_DocWare_"^"_IntrQty_"^"_Skin_"^"_OutImp_"^"_IntrQty_"^"_PackUomFactor_"^"_PackUom
    Q ""
   
OutputRow
	set ^CacheTemp(repid,ind)=$lb(IncDesc,Spec,Uom,DspQty,WarDesc,RetQty,Skin,Money,Qty,PackQty)
	set ind=ind+1
	q
}

/// Descriprtion:判断是否医特殊科室
/// Input:phaloc -药房科室, doctorloc -医生科室
/// Output: 1:拒绝的医生科室 0:非拒绝的医生科室
/// Table:CT_LocLinkLocation
/// Creator:Liang Qiang
/// CreatDate:2008-11-03
/// w ##class(web.DHCST.ReportForms.InPharmacyStat).DoctorLocRefuse(456,428)
ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
 &sql(select * from SQLUser.CT_LocLinkLocation where link_parref=:phaloc and link_ctloc_dr=:doctorloc)
 q:'SQLCODE 1
 q 0
}

/// createor:xialiangwen
/// date:2018-12-04
/// deccription:病区
/// table:      User.PACWard
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.InPharmacyStat","PACWard","","",459)
Query PACWard(inputStr As %String = "", filterText As %String = "", CTLOC As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod PACWardExecute(ByRef qHandle As %Binary, inputStr As %String = "", filterText As %String = "", CTLOC As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	;S ^XLW("PACWardExecute.1")=$LB(inputStr,filterText,CTLOC)
	i filterText'="" s inputStr=filterText
	s inputStr=$zcvt(inputStr,"U")
	s warddr=0
	f  s warddr=$o(^PAWARD(warddr)) q:(warddr="")||(+warddr=0)  d
	.s warddesc=$p(^PAWARD(warddr),"^",2)
	.s locdr=$p(^PAWARD(warddr),"^",5)
	.s WARDActive=$p(^PAWARD(warddr),"^",6) q:WARDActive="N"
	.q:locdr=""
	.q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(locdr),"^",22))  //按院区过滤
	.s locconname=$zcvt($p(^CTLOC(locdr),"^",43),"U")
	.s warddescpy=##class(web.DHCST.Common.AppCommon).GetCNCODE(warddesc)
	.q:(inputStr'="")&&($zcvt(warddesc,"U")'[inputStr)&&(locconname'[inputStr)&&(warddescpy'[inputStr)
	.q:warddesc=""
	.;q:warddesc["康健"
	.;q:warddesc="心血管内科护理单元(忠山院区)"
	.;q:warddesc="测试病区"
	.s warddra=warddr_"-"_"Y"
	.d outputRow
    S LinkDr=""
    f  S LinkDr=$o(^CTLOC(CTLOC,"LINK",0,"Loc",LinkDr)) q:LinkDr=""  d
    .S warddr=LinkDr
    .S warddesc=$P(^CTLOC(LinkDr),"^",2)_""_"(医生科室)"
    .s warddra=warddr_"-"_"N"
    .d outputRow
	Quit $$$OK
outputRow 
  
	s Data=$lb(warddra_"-"_ind,warddesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// //================报表整理====yangsj====2019-10-31======End==================/////////
/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).NewPid()
ClassMethod NewPid() As %String
{
  	Q $I(^DHCINPHAPID("DHCINPHA",$this))
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).ClearTmp()
ClassMethod ClearTmp(MethodName As %String, pid As %String, PAR As %String = "") As %String
{
	I PAR'="" D
	.K ^TMP("DHCINPHA",$this,MethodName,pid,PAR)
	.K ^TEMP("DHCINPHA",$this,MethodName,pid,PAR)
	E  D
	.K ^TMP("DHCINPHA",$this,MethodName,pid)
	.K ^TEMP("DHCINPHA",$this,MethodName,pid)
	Q ""
}

}
