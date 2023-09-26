Import sqluser

/// Descript:库存统计
/// Creater:	gwj
/// CreateDate:	2013-04-01
Class web.DHCSTMHUI.LocItmStkStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	根据条件统计库存(按批次
/// Creater:	gwj
/// CreateDate:	2013-04-01
/// Input:	开始行,一页显示记录数,排序字段,排序方向,
/// 科室id^日期^类组id^生产厂家id^管理组id^
/// 库位id^是否管理药^零库存^6个月有进出^排除零库存^6个月无进出^
/// Output:		
/// Return：
/// W ##class(web.DHCSTMHUI.LocItmStkStat).ItmStkStatbyBat("1","15","","","{""PhaLoc"":""392"",""gUserId"":""6444"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""StartDate"":""31/10/2018"",""StkGrpId"":"""",""StkCat"":"""",""StockType"":"""",""Vendor"":"""",""PhManufacturer"":"""",""LocManGrp"":"""",""StkBin"":"""",""HvFlag"":"""",""MonitorFlag"":"""",""Inci"":"""",""RowId"":"""",""InciDesc"":""""}")
ClassMethod ItmStkStatbyBat(page As %String, rows As %String, Sort As %String = "", Dir As %String = "", StrParam As %String, Usetype As %String) As %String
{
	n (page,rows,Sort,Dir,StrParam,Usetype)
 	s Start=(page-1)*rows
 	s Limit=rows
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	d PJObj.%FromJSON(StrParam)
 	s PJObj1=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	d PJObj1.%FromJSON(Usetype)
 	s PhaLoc=PJObj.%Get("PhaLoc")
 	s pHospId=..sssHospId(PhaLoc)
	s StkDate=PJObj.%Get("StartDate")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s ManfId=PJObj.%Get("PhManufacturer")
	q:PhaLoc="" ""
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=..DH2L(StkDate)		
	s Pid=..NewPid()
	k ^DHCSTTMP("LocItmbatStat",Pid)
	s ManGrpId=PJObj.%Get("LocManGrp")
	s SB=PJObj.%Get("StkBin")
	s pMonitorFlag=PJObj.%Get("MonitorFlag")
	s Zeroqty=PJObj1.%Get("UseFlag") ;有进出零库存
	s MoveMnth=PJObj1.%Get("UseTime") ;包括几个月内
	s NotZeroqty=PJObj1.%Get("NotUseFlag")  ;无进出非零库存
	s NotMoveMnth=PJObj1.%Get("NotUseTime") ;排除几个月内
	s StkCatId=PJObj.%Get("StkCat") //库存分类
	s Ven=PJObj.%Get("Vendor")   //供应商
	s StockType=PJObj.%Get("StockType")   //统计类型
	s ItmId=PJObj.%Get("Inci") //物资ID
	s ItmDesc=PJObj.%Get("InciDesc")  //物资名称
	s HighValueFlag=PJObj.%Get("HvFlag")
	s stdateMove=..DateByMon(-MoveMnth,StkDate)
	s stdateMove=$zdh(stdateMove,3)
	s stdateNoMove=..DateByMon(-NotMoveMnth,StkDate)
	s stdateNoMove=$zdh(stdateNoMove,3)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),PhaLoc,StkGrpId,pHospId)
	s TotalRpAmt=0,TotalSpAmt=0		;合计进价金额,合计售价金额
	s count = 0
	s end=Start+Limit
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s StkType=..sssCode()
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.q:(ItmId'="")&&(Inci'=ItmId)
	.s tmp1=$G(^INCI(Inci,1))
	.s InciCode = $p(tmp1,"^",1)
	.s InciDesc = $p(tmp1,"^",2)
	.q:(ItmDesc'="")&(InciDesc'[ItmDesc)
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=StkType
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId) //分类过滤
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.q:(HighValueFlag'="")&&(HVFlag'=HighValueFlag)
	.s LMGRPDR=""
	.s DHCINCIL=$O(^DHCINCIL(0,"INCIL",Incil,""))
	.i DHCINCIL'=""  S LMGRPDR=$P(^DHCINCIL(DHCINCIL),"^",7)
	.Q:(ManGrpId'="")&&(LMGRPDR'=ManGrpId)
	.s incisb=$p(^INCI(Inci,"IL",Chl),"^",2)
	.i (SB'="") q:(incisb'=SB)
	.s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
	.q:(pMonitorFlag'="")&(MonitorFlag'= pMonitorFlag)           //是否为重点标志材料
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.s IncStockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	.s move=..ItmMoved(Inci,stdateMove,StkDate)   ;是否发生过业务
	.q:(IncStockQty=0)&&(((Zeroqty="Y")&(move=0))||(Zeroqty'="Y"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	.s Notmove=..ItmMoved(Inci,stdateNoMove,StkDate)   ;是否发生过业务
	.q:(Notmove=0)&&(NotZeroqty="Y")&(IncStockQty'=0)		;排除一定月份内无进出的非零库存
	.s IncsbDesc =##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(PhaLoc,Inci)
	.s IncsbDesc=$p(IncsbDesc,"^",1)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(tmp1,"^",10)
	.s LastRealPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,PurUomId,HospId)
	.s LastRealPrice=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(LastRealPrice,HospId,1)
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Chlb=0  f  s Chlb=$o(^INCI(Inci,"IL",Chl,"LB",Chlb)) q:Chlb=""  d 
	..s Inclb=Inci_"||"_Chl_"||"_Chlb
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	..s ManfDr=$p(ManfInfo,"^",1)
	..s ManfDesc=$p(ManfInfo,"^",2)
	..i ManfId'="" q:(ManfDr'=ManfId)  //生产厂家过滤
	..s tmpVen=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	..s Vendor=$p(tmpVen,"^",1)
	..s VendorName=$p(tmpVen,"^",2)
	..i Ven'="" q:Ven'=Vendor
	..s StockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,StkDate,BUomId)
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s PurStockQty = StockQty / Fac
	..q:(StockType=1)&&(PurStockQty'=0)     ;只检索库存为零记录
	..q:(StockType=2)&&(PurStockQty'>0)     ;只检索库存为正记录
	..q:(StockType=3)&&(PurStockQty'<0)     ;只检索库存为负记录
	..q:(StockType=4)&&(PurStockQty=0)		;只检索非零库存
	..s SalePrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,StkDate,PurUomId,HospId)
	..s SpAmt = SalePrice * PurStockQty
	..;s inclbRpBuom=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,"","")
	..s inclbRpBuom=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRpbydate(Inclb,StkDate,"","")
	..s RpAmt=inclbRpBuom*StockQty		;2014-03-31 换成批次进价*库存
	..s inclbRp=inclbRpBuom*Fac
	..s inclbRp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(inclbRp,HospId,1)
	..s INCIB=$p(^INCI(Inci,"IL",Chl,"LB",Chlb),"^",1)
	..s INCIBData=^INCI(Inci,"IB",$p(INCIB,"||",2))
	..s BatNo=$p(INCIBData,"^",1)
	..s ExpDate=$p(INCIBData,"^",2)
	..i ExpDate'="" s ExpDate=..DL2H(ExpDate)
	..s TotalRpAmt=TotalRpAmt+RpAmt
	..s TotalSpAmt=TotalSpAmt+SpAmt
	..s Data1=Inclb_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_BaseCTUomDesc_"^"_BUomId_"^"_StockQty
	..s Data2=IncsbDesc_"^"_BatNo_"^"_ExpDate_"^"_PurchCTUomDesc_"^"_PurUomId_"^"_PurStockQty
	..s Data3=Spec_"^"_ManfDesc_"^"_SalePrice_"^"_SpAmt_"^"_LastRealPrice_"^"_RpAmt_"^"_MonitorFlag_"^"_inclbRp_"^"_VendorName
	..s Data=Data1_"^"_Data2_"^"_Data3
	..s count = count+1
	..s ^DHCSTTMP("LocItmbatStat",Pid,Inclb,count)=Data
	s Title="Inclb^Inci^InciCode^InciDesc^BUomDesc^BUomId^StockQty^StkBin^BatNo^ExpDate"
		_"^PurUomDesc^PurUomId^PurStockQty^Spec^ManfDesc^Sp^SpAmt^Rp^RpAmt^MonitorFlag"
		_"^inclbRp^Vendor"
	s count=0
	w "{""rows"":["
	d OutRow
	w "],""footer"":["
	s TotalTitle="InciDesc^SpAmt^RpAmt"
	s TotalData="合计"_"^"_TotalSpAmt_"^"_TotalRpAmt
	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(TotalData,TotalTitle)
	w "],""total"":"_count_"}"
	
	k ^DHCSTTMP("LocItmbatStat",Pid)
	q ""
OutRow
	s subflag=""
	f  s subflag=$o(^DHCSTTMP("LocItmbatStat",Pid,subflag)) q:subflag=""  d
	.s num=""
	.f  s num=$o(^DHCSTTMP("LocItmbatStat",Pid,subflag,num)) q:num=""  d
	..s RowData=^DHCSTTMP("LocItmbatStat",Pid,subflag,num)
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	q
}

/// Descript:	根据条件统计库存（按项目
/// Creater:	gwj
/// CreateDate:	2013-04-01
/// Input:	开始行,一页显示记录数,排序字段,排序方向,
/// 科室id^日期^类组id^生产厂家id^管理组id^
/// 库位id^是否管理药^零库存^6个月有进出^排除零库存^6个月无进出^
/// Output:		
/// Return：
/// W ##class(web.DHCSTMHUI.LocItmStkStat).ItmStkStat("","","","",^zx(2),^zx(3))
ClassMethod ItmStkStat(page As %Integer, rows As %Integer, Sort As %String = "", Dir As %String = "", StrParam As %String, Usetype As %String) As %String
{
	n (page,rows,Sort,Dir,StrParam,Usetype)
	s Start=(page-1)*rows
	s Limit=rows
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(StrParam)
	s PJObj1=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj1.%FromJSON(Usetype)
	s PhaLoc=PJObj.%Get("PhaLoc")
	s pHospId=..sssHospId(PhaLoc)
	s StkDate=PJObj.%Get("StartDate")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s ManfId=PJObj.%Get("PhManufacturer")
	q:PhaLoc="" ""
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=..DH2L(StkDate)
	s Pid=..NewPid()
	k ^DHCSTTMP("LocItmStat",Pid)
	s ManGrpId=PJObj.%Get("LocManGrp")
	s SB=PJObj.%Get("StkBin")
	s pMonitorFlag=PJObj.%Get("MonitorFlag")
	s Zeroqty=PJObj1.%Get("UseFlag") ;有进出零库存
	s MoveMnth=PJObj1.%Get("UseTime") ;包括几个月内
	s NotZeroqty=PJObj1.%Get("NotUseFlag")  ;无进出非零库存
	s NotMoveMnth=PJObj1.%Get("NotUseTime") ;排除几个月内
	s StkCatId=PJObj.%Get("StkCat") //库存分类
	s Ven=PJObj.%Get("Vendor")   //供应商
	s StockType=PJObj.%Get("StockType")   //统计类型
	s ItmId=PJObj.%Get("Inci") //物资ID
	s ItmDesc=PJObj.%Get("InciDesc")  //物资名称
	s HighValueFlag=PJObj.%Get("HvFlag")
	
	s stdateMove=..DateByMon(-MoveMnth,StkDate)
	s stdateMove=$zdh(stdateMove,3)
	s stdateNoMove=..DateByMon(-NotMoveMnth,StkDate)
	s stdateNoMove=$zdh(stdateNoMove,3)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),PhaLoc,StkGrpId,pHospId)
	s count = 0
	s end=Start+Limit
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s TotalRpAmt=0,TotalSpAmt=0		;合计进价金额,合计售价金额
	s StkType=..sssCode()
	s incisb="",MonitorFlag="",ManfDr=""
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.q:(ItmId'="")&(Inci'=ItmId)
	.s tmp1=$G(^INCI(Inci,1))
	.s InciCode = $p(tmp1,"^",1)
	.s InciDesc = $p(tmp1,"^",2)
	.q:(ItmDesc'="")&(InciDesc'[ItmDesc)
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)  //库存类型过滤
	.q:ScgType'=StkType
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_Scg_"^")) //类组过滤
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.i StkCatId'="" q:Incsc'=StkCatId //分类过滤
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.q:(HighValueFlag'="")&&(HVFlag'=HighValueFlag)
	.s LMGRPDR=""
	.s DHCINCIL=$O(^DHCINCIL(0,"INCIL",Incil,""))
	.i DHCINCIL'=""  S LMGRPDR=$P(^DHCINCIL(DHCINCIL),"^",7)
	.Q:(ManGrpId'="")&&(LMGRPDR'=ManGrpId)  //管理组过滤
	.s incisb=$p(^INCI(Inci,"IL",Chl),"^",2)
	.i SB'="" q:incisb'=SB   //货位过滤
	.s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
	.q:(pMonitorFlag'="")&(MonitorFlag'= pMonitorFlag)           //是否为重点标志材料
	.s RpAmt=0,SpAmt=0
	.s VendorName="",ManfDesc=""
	.s lb=0
	.s lbcnt=0,StockQty=0
	.f  s lb=$o(^INCI(Inci,"IL",Chl,"LB",lb)) q:lb=""  d
	..s inclb=Inci_"||"_Chl_"||"_lb
	..s Vendor="",VendorName=""
	..s tmp2=""
	..s tmp2=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb)
	..s Vendor=$p(tmp2,"^",1)
	..i Ven'="" q:Vendor'=Ven
	..s VendorName=$p(tmp2,"^",2)
	..s ManfInfo=""
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
	..s ManfDr=$p(ManfInfo,"^",1)
	..i ManfId'="" q:(ManfDr'=ManfId)  //生产厂家过滤
	..s ManfDesc=$p(ManfInfo,"^",2)
	..s lbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,StkDate)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s lbRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,BUomId,HospId)
	..s lbSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetSp(inclb,StkDate,BUomId,HospId)
	..s StockQty=StockQty+lbQty
	..s RpAmt=RpAmt+(lbRp*lbQty)
	..s SpAmt=SpAmt+(lbSp*lbQty)
	..s lbcnt=lbcnt+1
	.q:+lbcnt=0  ;没有任何批次
	.q:(StockType=1)&&(StockQty'=0)     ;只检索库存为零记录
	.q:(StockType=2)&&(StockQty'>0)     ;只检索库存为正记录
	.q:(StockType=3)&&(StockQty'<0)     ;只检索库存为负记录
	.q:(StockType=4)&&(StockQty=0)		;只检索非零库存
	.i Ven'="" s VendorName=$p($G(^APC("APCVM",Ven)),"^",3)
	.i ManfId'="" s ManfDesc=$p($G(^PHMNF(ManfId)),"^",2)
	.s move=..ItmMoved(Inci,stdateMove,StkDate)   ;是否发生过业务
	.q:(StockQty=0)&&(((Zeroqty="Y")&(move=0))||(Zeroqty'="Y"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	.s Notmove=..ItmMoved(Inci,stdateNoMove,StkDate)   ;是否发生过业务
	.q:(Notmove=0)&&(NotZeroqty="Y")&(StockQty'=0)		;排除一定月份内无进出的非零库存
	.s BUomId=$p(tmp1,"^",10)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s lbSp=lbSp*Fac
	.s lbRp=lbRp*Fac
	.s PurStockQty = StockQty / Fac
	.s TotalRpAmt=TotalRpAmt+RpAmt
	.s TotalSpAmt=TotalSpAmt+SpAmt
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s IncsbDesc =##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(PhaLoc,Inci)
	.s IncsbDesc=$p(IncsbDesc,"^",1)
	.s RpChangeFlag=##class(web.DHCSTMHUI.LocItmStkStat).CheaclIncibRpChange(Inci)
	.
	.s Data1=Inci_"^"_InciCode_"^"_InciDesc_"^"_BaseCTUomDesc_"^"_BUomId_"^"_StockQty
	.s Data2=IncsbDesc_"^"_PurchCTUomDesc_"^"_PurUomId_"^"_PurStockQty_"^"_Spec_"^"_ManfDesc
	.s Data3=lbSp_"^"_SpAmt_"^"_lbRp_"^"_RpAmt_"^"_MonitorFlag_"^"_VendorName_"^"_RpChangeFlag
	.s Data=Data1_"^"_Data2_"^"_Data3
	.s count = count+1
	.i Sort="InciCode"  d
	..s ^DHCSTTMP("LocItmStat",Pid,InciCode,count)=Data
	.e  i Sort="InciDesc"  d
	..s ^DHCSTTMP("LocItmStat",Pid,InciDesc,count)=Data
	.e  i Sort="StkBin"  d
	..s ^DHCSTTMP("LocItmStat",Pid,IncsbDesc,count)=Data
	.e  i (Sort="PurStockQty")||(Sort="StockQty")||(Sort="StkQtyUom")  d
	..s ^DHCSTTMP("LocItmStat",Pid,StockQty,count)=Data
	.e  d
	..s ^DHCSTTMP("LocItmStat",Pid,Inci,count)=Data
	.
	
	s Title="Incil^InciCode^InciDesc^BUomDesc^BUomId^StockQty^StkBin^PurUomDesc^PurUomId^PurStockQty"
		_"^Spec^ManfDesc^Sp^SpAmt^Rp^RpAmt^MonitorFlag^Vendor^RpChangeFlag"
	s count=0
	w "{""rows"":["
	i Dir="DESC"  d
	.d OutRowDescItm
	e  d
	.d OutRowAscItm
	w "],""footer"":["
	s TotalTitle="InciDesc^SpAmt^RpAmt"
	s TotalData="合计"_"^"_TotalSpAmt_"^"_TotalRpAmt
	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(TotalData,TotalTitle)
	w "],""total"":"_count_"}"
	k ^DHCSTTMP("LocItmStat",Pid)
	q ""
	
OutRowAscItm
	s subflag=""
	f  s subflag=$o(^DHCSTTMP("LocItmStat",Pid,subflag))  q:subflag=""  d
	.s num=0
	.f  s num=$o(^DHCSTTMP("LocItmStat",Pid,subflag,num))  q:num=""  d
	..s RowData=^DHCSTTMP("LocItmStat",Pid,subflag,num)
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
    q
OutRowDescItm
	s subflag=""
	f  s subflag=$o(^DHCSTTMP("LocItmStat",Pid,subflag),-1)  q:subflag=""  d
	.s num=0
	.f  s num=$o(^DHCSTTMP("LocItmStat",Pid,subflag,num),-1)  q:num=""  d
	..s RowData=^DHCSTTMP("LocItmStat",Pid,subflag,num)
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	q
}

/// 发生过业务
/// return:
///  0 - 没有
///  >0 有
ClassMethod ItmMoved(itm, date1, date2) As %Library.String
{
	n (itm, date1, date2)
	s rid=""
 	s i=0
 	f date=date1:1:date2  q:i>0  d
 	.s rid=$o(^DHCINTR(0,"INCI",itm,date,rid))  q:(rid="")
 	.s i=i+1
 	q i
}

ClassMethod ManGrp(inci, locdr)
{
 n (inci, locdr)
 ;get the man grp according inci and loc
 q:inci="" ""
 q:locdr="" ""
 n MC
 s MC=$o(^PHMCi(locdr,inci,"")) q:MC="" ""
 s grp=+$P($g(^PHMC(MC)),"^",5)
 q grp
}

/// 按月数返回某日期之前或之后的日期
/// Argu:
/// Monnum  -月数
/// inDate - 日期
/// Return:
/// 日期(Y-m-d)
ClassMethod DateByMon(Monnum As %Library.Float, inDate As %Library.String) As %Library.String
{
	n (Monnum,inDate)
	s newdd=$p($SYSTEM.SQL.DATEADD("mm",Monnum,inDate)," ")
	q newdd
}

/// Descripiton:取项目明细，批次明细
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmStkStat","QueryDetail",^liy(1),^liy(2))
Query QueryDetail(StrParam As %String(MAXLEN=""), Usetype As %String) As Query(ROWSPEC = "Inclb,Inci,InciCode,InciDesc,BUomDesc,BUomId,StockQty:%Float,StkBin,Btno,Expdate,PurUomDesc,PurUomId,PurStockQty:%Float,Spec,ManfDesc,Sp:%Float,SpAmt:%Float,LastRealPrice:%Float,RpAmt:%Float,MonitorFlag,inclbRp:%Float,Vendor") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, StrParam As %String(MAXLEN=""), Usetype As %String) As %Status
{
	n (qHandle,StrParam,Usetype)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	d PJObj.%FromJSON(StrParam)
	s PJObj1=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	d PJObj1.%FromJSON(Usetype)
 	s PhaLoc=PJObj.%Get("PhaLoc")
 	s pHospId=..sssHospId(PhaLoc)
 	q:PhaLoc="" ""
	s StkDate=PJObj.%Get("StartDate")
	i StkDate'="" s StkDate=..DH2L(StkDate)	
	else  s StkDate=+$h
	s StkGrpId=PJObj.%Get("StkGrpId")
	s ManfId=PJObj.%Get("PhManufacturer")
	s ManGrpId=PJObj.%Get("LocManGrp")
	s SB=PJObj.%Get("StkBin")
	s pMonitorFlag=PJObj.%Get("MonitorFlag")
	s Zeroqty=PJObj1.%Get("UseFlag")
	s MoveMnth=PJObj1.%Get("UseTime")
	s NotZeroqty=PJObj1.%Get("NotUseFlag")
	s NotMoveMnth=PJObj1.%Get("NotUseTime")
	s StkCatId=PJObj.%Get("StkCat")  //库存分类
	s Ven=PJObj.%Get("Vendor")  //供应商   
	s StockType=PJObj.%Get("StockType")   //统计类型 
 	s Pid=..NewPid()
	k ^DHCSTTMP("LocItmbatStat",Pid)
   
	s stdateMove=..DateByMon(-MoveMnth,StkDate)
	s stdateMove=$zdh(stdateMove,3)
	s stdateNoMove=..DateByMon(-NotMoveMnth,StkDate)
	s stdateNoMove=$zdh(stdateNoMove,3)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),PhaLoc,StkGrpId,pHospId)
	
	s count = 0
	s resultString = ""
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_Scg_"^")) //类组过滤
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId) //分类过滤
	.
	.s DHCINCIL=$O(^DHCINCIL(0,"INCIL",Incil,""))
	.s LMGRPDR=""
	.i DHCINCIL'=""  S LMGRPDR=$P(^DHCINCIL(DHCINCIL),"^",7)
	.Q:(ManGrpId'="")&(LMGRPDR'=ManGrpId)
	.s incisb=$p(^INCI(Inci,"IL",Chl),"^",2)
	.q:(SB'="")&(incisb'=SB)
	.s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
	.q:(pMonitorFlag'="")&(MonitorFlag'=pMonitorFlag)           //是否为重点标志材料
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.s IncStockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	.
	.s move=..ItmMoved(Inci,stdateMove,StkDate)   ;是否发生过业务
	.;q:(IncStockQty=0)&(((Zeroqty="Y")&(move=0))||(Zeroqty="N"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	.q:(IncStockQty=0)&(((Zeroqty="Y")&(move=0))||(Zeroqty'="Y"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	.
	.s Notmove=..ItmMoved(Inci,stdateNoMove,StkDate)   ;是否发生过业务
	.q:(Notmove=0)&(NotZeroqty="Y")&(IncStockQty'=0)		;排除一定月份内无进出的非零库存
	.
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.s IncsbDesc =##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(PhaLoc,Inci)
	.s IncsbDesc=$p(IncsbDesc,"^",1)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s LastRealPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,PurUomId,HospId)
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Chlb=0  f  s Chlb=$o(^INCI(Inci,"IL",Chl,"LB",Chlb)) q:Chlb=""  d 
	..s Inclb=Inci_"||"_Chl_"||"_Chlb
	..
	..s tmp2=""
	..s tmp2=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	..s Vendor=$p(tmp2,"^",1)
	..s VendorName=$p(tmp2,"^",2)
	..i Ven'="" q:Vendor'=Ven
	..
	..s ManfInfo=""
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	..s ManfDr=$p(ManfInfo,"^",1)
	..s ManfDesc=$p(ManfInfo,"^",3)
	..q:(ManfId'="")&(ManfDr'=ManfId)
	..
	..s StockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLBU(Inclb,StkDate,BUomId)
	..q:(StockType=1)&(StockQty'=0)     ;只检索库存为零记录
	..q:(StockType=2)&(StockQty'>0)     ;只检索库存为正记录
	..q:(StockType=3)&(StockQty'<0)     ;只检索库存为负记录
	..q:(StockType=4)&(StockQty=0)		;只检索非零库存
	..s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s PurStockQty = StockQty / Fac
	..s SalePrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,StkDate,PurUomId,HospId)
	..s SpAmt = SalePrice * PurStockQty
	..;s inclbRpBuom=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,"","")
	..s inclbRpBuom=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRpbydate(Inclb,StkDate,"","")
	..s RpAmt=inclbRpBuom*StockQty		;2014-03-31 换成批次进价*库存
	..s inclbRp=inclbRpBuom*Fac
	..s INCIB=$p(^INCI(Inci,"IL",Chl,"LB",Chlb),"^",1)
	..s Btno=$p(^INCI(Inci,"IB",$p(INCIB,"||",2)),"^",1)
	..s Expdate=$p(^INCI(Inci,"IB",$p(INCIB,"||",2)),"^",2)
	..i Expdate'="" s Expdate=..DL2H(Expdate)
	..s Data1=Inclb_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_BaseCTUomDesc_"^"_BUomId_"^"_StockQty
	..s Data2=IncsbDesc_"^"_Btno_"^"_Expdate_"^"_PurchCTUomDesc_"^"_PurUomId_"^"_PurStockQty
	..s Data3=Spec_"^"_ManfDesc_"^"_SalePrice_"^"_SpAmt_"^"_LastRealPrice_"^"_RpAmt_"^"_MonitorFlag_"^"_inclbRp_"^"_VendorName
	..s Data=Data1_"^"_Data2_"^"_Data3
	..d OutPutRow1
	 Quit $$$OK
OutPutRow1
 s Data=$lb(Inclb,Inci,InciCode,InciDesc,BaseCTUomDesc,BUomId,StockQty,IncsbDesc,Btno,Expdate,PurchCTUomDesc,PurUomId,PurStockQty,Spec,ManfDesc,SalePrice,SpAmt,LastRealPrice,RpAmt,MonitorFlag,inclbRp,VendorName)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript: 根据不同进价统计库存
/// Creater: tsr
/// CreateDate: 2017-03-08
/// Input:	开始行,一页显示记录数,排序字段,排序方向,
/// 科室id^日期^类组id^生产厂家id^管理组id^
/// 库位id^是否管理药^零库存^6个月有进出^排除零库存^6个月无进出^
/// W ##class(web.DHCSTMHUI.LocItmStkStat).ItmStkStatbyRp(1,15,"","",^xj(1))
ClassMethod ItmStkStatbyRp(page As %Integer, rows As %Integer, Sort As %String = "", Dir As %String = "", StrParam As %String, Usetype As %String) As %String
{
	n (page,rows,Sort,Dir,StrParam,Usetype)
 	s Start=(page-1)*rows
 	s Limit=rows
 	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	d PJObj.%FromJSON(StrParam)
 	s PJObj1=##class(web.DHCSTMHUI.Common.FromJson).%New()
 	d PJObj1.%FromJSON(Usetype)
 	s PhaLoc=PJObj.%Get("PhaLoc")
	s StkDate=PJObj.%Get("StartDate")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s ManfId=PJObj.%Get("PhManufacturer")
	q:PhaLoc="" ""
	s pHospId=..sssHospId(PhaLoc)
	i StkDate'="" s StkDate=..DH2L(StkDate)	
	else  s StkDate=+$h
	s Pid=..NewPid()
	s ManGrpId=PJObj.%Get("LocManGrp")
	s SB=PJObj.%Get("StkBin")
	s pMonitorFlag=PJObj.%Get("MonitorFlag")
	s Zeroqty=PJObj1.%Get("UseFlag") ;有进出零库存
	s MoveMnth=PJObj1.%Get("UseTime") ;包括几个月内
	s NotZeroqty=PJObj1.%Get("NotUseFlag")  ;无进出非零库存
	s NotMoveMnth=PJObj1.%Get("NotUseTime") ;排除几个月内
	s StkCatId=PJObj.%Get("StkCat") //库存分类
	s Ven=PJObj.%Get("Vendor")   //供应商
	s StockType=PJObj.%Get("StockType")   //统计类型
	s ItmId=PJObj.%Get("Inci") //物资ID
	s ItmDesc=PJObj.%Get("InciDesc")  //物资名称
	s HighValueFlag=PJObj.%Get("HvFlag")
	
	k ^DHCSTTMP("LocItmRpStat",Pid)
	k ^DHCLISTMP("ItmRpStat")
	
	s stdateMove=..DateByMon(-MoveMnth,StkDate)
	s stdateMove=$zdh(stdateMove,3)
	s stdateNoMove=..DateByMon(-NotMoveMnth,StkDate)
	s stdateNoMove=$zdh(stdateNoMove,3)
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),PhaLoc,StkGrpId,pHospId)
	s count = 0
	s end=Start+Limit
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s TotalRpAmt=0,TotalSpAmt=0		;合计进价金额,合计售价金额
	s Inci=0
	s incisb="",MonitorFlag="",ManfDr=""

	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.q:(ItmId'="")&(Inci'=ItmId)
	.s tmp1=$G(^INCI(Inci,1))
	.s InciDesc = $p(tmp1,"^",2)
	.q:(ItmDesc'="")&(InciDesc'[ItmDesc)
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)  //库存类型过滤
	.q:ScgType'=..sssCode()
	.q:(StkGrpId'="")&&(("^"_StkGrpId_"^")'[("^"_Scg_"^")) //类组过滤
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.i StkCatId'="" q:Incsc'=StkCatId //分类过滤
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	.q:(HighValueFlag'="")&&(HVFlag'=HighValueFlag)
	.
	.s LMGRPDR=""
	.s DHCINCIL=$O(^DHCINCIL(0,"INCIL",Incil,""))
	.i DHCINCIL'=""  S LMGRPDR=$P(^DHCINCIL(DHCINCIL),"^",7)
	.Q:(ManGrpId'="")&(LMGRPDR'=ManGrpId)  //管理组过滤
	.s incisb=$p(^INCI(Inci,"IL",Chl),"^",2)
	.i SB'="" q:incisb'=SB   //货位过滤
	.s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
	.q:(pMonitorFlag'="")&(MonitorFlag'= pMonitorFlag)           //是否为重点标志材料
	.s VendorName="",ManfDesc=""
	.s lb=0
	.s lbcnt=0
	.f  s lb=$o(^INCI(Inci,"IL",Chl,"LB",lb)) q:lb=""  d
	..s inclb=Inci_"||"_Chl_"||"_lb
	..s tmp2=""
	..s tmp2=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb)
	..s Vendor=$p(tmp2,"^",1)
	..i Ven'="" q:Vendor'=Ven
	..s VendorName=$p(tmp2,"^",2)
	..s ManfInfo=""
	..s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
	..s ManfDr=$p(ManfInfo,"^",1)
	..i ManfId'="" q:(ManfDr'=ManfId)  //生产厂家过滤
	..s ManfDesc=$p(ManfInfo,"^",2)
	..s lbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,StkDate)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s lbRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,BUomId,HospId)
	..s lbSp=##class(web.DHCSTMHUI.Common.PriceCommon).GetSp(inclb,StkDate,BUomId,HospId)
	..s lbcnt=lbcnt+1
	..s:lbRp=0 lbRp="L"
	..s:lbSp=0 lbSp="L"
	..s ^DHCLISTMP("ItmRpStat",Inci,lbRp,lbSp,lbcnt)=lbQty_"^"_inclb_"^"_VendorName_"^"_ManfDesc_"^"_MonitorFlag
	.q:+lbcnt=0  ;没有任何批次

	s RpAmt=0,SpAmt=0
	s Vendor="",VendorName=""
	s inci=0
	f  s inci=$o(^DHCLISTMP("ItmRpStat",inci)) q:inci=""  d
	.s rp=0 f  s rp=$o(^DHCLISTMP("ItmRpStat",inci,rp)) q:rp=""  d
	..s sp=0 f  s sp=$o(^DHCLISTMP("ItmRpStat",inci,rp,sp)) q:sp=""  d
	...s StockQty=0
	...s cnt=0 f  s cnt=$o(^DHCLISTMP("ItmRpStat",inci,rp,sp,cnt)) q:cnt=""  d
	....s tmp3=^DHCLISTMP("ItmRpStat",inci,rp,sp,cnt)
	....s lbQty=$p(tmp3,"^",1)
	....s inclb=$p(tmp3,"^",2)
	....s VendorName=$p(tmp3,"^",3)
	....s ManfDesc=$p(tmp3,"^",4)
	....s MonitorFlag=$p(tmp3,"^",5)
	....s StockQty=StockQty+lbQty
	...s lbRp=rp
	...s lbSp=sp
	...s:rp="L" lbRp=0
	...s:sp="L" lbSp=0
	...s RpAmt=lbRp*StockQty
	...s SpAmt=lbSp*StockQty
	...q:(StockType=1)&(StockQty'=0)     ;只检索库存为零记录
	...q:(StockType=2)&(StockQty'>0)     ;只检索库存为正记录
	...q:(StockType=3)&(StockQty'<0)     ;只检索库存为负记录
	...q:(StockType=4)&(StockQty=0)		;只检索非零库存
	...i Ven'="" s VendorName=$p($G(^APC("APCVM",Ven)),"^",3)
	...i ManfId'="" s ManfDesc=$p($G(^PHMNF(ManfId)),"^",2)
	...s move=..ItmMoved(inci,stdateMove,StkDate)   ;是否发生过业务
	...;q:(StockQty=0)&(((Zeroqty="Y")&(move=0))||(Zeroqty="N"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	...q:(StockQty=0)&(((Zeroqty="Y")&(move=0))||(Zeroqty'="Y"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	...s Notmove=..ItmMoved(inci,stdateNoMove,StkDate)   ;是否发生过业务
	...q:(Notmove=0)&(NotZeroqty="Y")&(StockQty'=0)		;排除一定月份内无进出的非零库存
	...s InciCode = $p(^INCI(inci,1),"^",1)
	...s InciDesc = $p(^INCI(inci,1),"^",2)
	...s BUomId=$p(^INCI(inci,1),"^",10)
	...s PurUomId=$p(^INCI(inci,3),"^",6)
	...s Fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	...s lbSp=lbSp*Fac
	...s lbRp=lbRp*Fac
	...s PurStockQty = StockQty / Fac
	...s TotalRpAmt=TotalRpAmt+RpAmt
	...s TotalSpAmt=TotalSpAmt+SpAmt
	...s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	...s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	...s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	...s IncsbDesc =##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(PhaLoc,inci)
	...s IncsbDesc=$p(IncsbDesc,"^",1)
	...s Data1=inclb_"^"_inci_"^"_InciCode_"^"_InciDesc_"^"_BaseCTUomDesc_"^"_BUomId_"^"_StockQty
	...s Data2=IncsbDesc_"^"_PurchCTUomDesc_"^"_PurUomId_"^"_PurStockQty_"^"_Spec_"^"_ManfDesc
	...s Data3=lbSp_"^"_SpAmt_"^"_lbRp_"^"_RpAmt_"^"_MonitorFlag_"^"_VendorName
	...s Data=Data1_"^"_Data2_"^"_Data3
	...s count = count+1
	...i Sort="InciCode"  d
	....s ^DHCSTTMP("LocItmRpStat",Pid,InciCode,count)=Data
	...e  i Sort="InciDesc"  d
	....s ^DHCSTTMP("LocItmRpStat",Pid,InciDesc,count)=Data
	...e  i Sort="StkBin"  d
	....s ^DHCSTTMP("LocItmRpStat",Pid,IncsbDesc,count)=Data
	...e  i (Sort="PurStockQty")||(Sort="StockQty")||(Sort="StkQtyUom")  d
	....s ^DHCSTTMP("LocItmRpStat",Pid,StockQty,count)=Data
	...e  d
	....s ^DHCSTTMP("LocItmRpStat",Pid,inclb,count)=Data

	s Title1="inclb^Inci^InciCode^InciDesc^BUomDesc^BUomId^StockQty^StkBin^PurUomDesc^PurUomId"
	s Title2="PurStockQty^Spec^ManfDesc^Sp^SpAmt^Rp^RpAmt^MonitorFlag^Vendor"
	s Title3="InciDesc"
	s Title4="SpAmt^RpAmt"
	s Title=Title1_"^"_Title2
	s Title5=Title3_"^"_Title4
	s count=0
	w "{""rows"":["
	i Dir="DESC"  d
	.d OutRowDescRp
	e  d
	.d OutRowAscRp
	w "],""footer"":["
	s TotalData="合计"_"^"_TotalSpAmt_"^"_TotalRpAmt_""
	w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(TotalData,Title5)
	s count=count+1
	w "],""results"":"_count_"}"
	k ^DHCSTTMP("LocItmRpStat",Pid)
	k ^DHCLISTMP("ItmRpStat")
	q ""
	
OutRowAscRp
	s subflag=""
	f  s subflag=$o(^DHCSTTMP("LocItmRpStat",Pid,subflag))  q:subflag=""  d
	.s num=0
	.f  s num=$o(^DHCSTTMP("LocItmRpStat",Pid,subflag,num))  q:num=""  d
	..s RowData=^DHCSTTMP("LocItmRpStat",Pid,subflag,num)
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
    q
OutRowDescRp
	s subflag=""
	f  s subflag=$o(^DHCSTTMP("LocItmRpStat",Pid,subflag),-1)  q:subflag=""  d
	.s num=0
	.f  s num=$o(^DHCSTTMP("LocItmRpStat",Pid,subflag,num),-1)  q:num=""  d
	..s RowData=^DHCSTTMP("LocItmRpStat",Pid,subflag,num)
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(RowData,Title)
	q
}

/// 批次价格是否有变化(最后一个批次和倒数第二个批次对比)
/// return:
///  Y - 有变化
///  >N 没有变化
/// w ##class(web.DHCSTMHUI.LocItmStkStat).CheaclIncibRpChange(948)
ClassMethod CheaclIncibRpChange(Inci) As %Library.String
{
	n (Inci)
	s Flag="N"
	q:+Inci=0 Flag
	s LastCh=$o(^INCI(Inci,"IB",""),-1)
	q:+LastCh=0 Flag
	s SecondToLastCh=$o(^INCI(Inci,"IB",LastCh),-1)
	q:+SecondToLastCh=0 Flag
	s LastIncib=Inci_"||"_LastCh
	s SecondToLastIncib=Inci_"||"_SecondToLastCh
	
	s LastRp="",SecondToLastRp=""
	s LastDhIncib=$o(^DHCINCIB(0,"INCIB",LastIncib,""))
	s SecondToLastDhIncib=$o(^DHCINCIB(0,"INCIB",SecondToLastIncib,""))
	s:LastDhIncib'="" LastRp=$p(^DHCINCIB(LastDhIncib),"^",3)
	s:SecondToLastDhIncib'="" SecondToLastRp=$p(^DHCINCIB(SecondToLastDhIncib),"^",3)
	s:LastRp'=SecondToLastRp Flag="Y"
 	q Flag
}

}
