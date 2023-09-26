Import sqluser

/// Descript:库存统计
/// Creater:	gwj
/// CreateDate:	2013-04-01
Class web.DHCST.LocItmStkStat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	根据条件统计库存(按批次
/// Creater:	gwj
/// CreateDate:	2013-04-01
/// Input:	开始行,一页显示记录数,排序字段,排序方向,
/// 科室id^日期^类组id^厂家id^管理组id^
/// 库位id^是否管理药^零库存^6个月有进出^排除零库存^6个月无进出^
/// Output:		
/// Return：
/// W ##class(web.DHCST.LocItmStkStat).ItmStkStat("0","30","","","102^2013-05-08^1^^^^N^N^6^N^6")
ClassMethod ItmStkStatbyBat(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
	n (Sort,Dir,Limit,Start,StrParam)
	
	//s StrParam="102^2013-05-31^1^^^^N^N^6^N^6^13"
	s PhaLoc=$p(StrParam,"^",1)
	s StkDate=$p(StrParam,"^",2)
	s StkGrpId=$p(StrParam,"^",3)
	s ManfId=$p(StrParam,"^",4)
	q:PhaLoc="" ""
	s HospId=$p($g(^CTLOC(+PhaLoc)),"^",22)
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StkDate)
	//q:StkGrpId="" ""
	
	s Pid=..NewPid()
	k ^||DHCSTTMP("LocItmbatStat",Pid)
	s ManGrpId=$p(StrParam,"^",5)
	
	s SB=$p(StrParam,"^",6)
	s ManageFlag=$p(StrParam,"^",7)
	s Zeroqty=$p(StrParam,"^",8)
	s MoveMnth=$p(StrParam,"^",9)
	s NotZeroqty=$p(StrParam,"^",10)
	s NotMoveMnth=$p(StrParam,"^",11)
	s StkCatId=$p(StrParam,"^",12)  //库存分类

	s stdateMove=..DateByMon(-MoveMnth,StkDate)
	s stdateMove=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdateMove)
	s stdateNoMove=..DateByMon(-NotMoveMnth,StkDate)
	s stdateNoMove=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdateNoMove)
	s Title1="Inclb^Inci^InciCode^InciDesc^BUomDesc^BUomId^StockQty^StkBin^Btno^Expdate^PurUomDesc^PurUomId"
	s Title2="PurStockQty^Spec^ManfDesc^Sp^SpAmt^Rp^RpAmt^ManFlag^PVenDesc"
	s Title=Title1_"^"_Title2
	// 排序
	s sortNum=$lf($lfs(Title,"^"),Sort)
	s sortAsNum=""
	i (Sort["Qty")||(Sort["Amt")||(Sort["Sp")||(Sort["Rp") s sortAsNum="Y"
	s TotalRpAmt=0,TotalSpAmt=0		;合计进价金额,合计售价金额
	s count = 0
	s resultString = ""
	s end=Start+Limit
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s json = ##class(Code.JsonObj).%New()
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.q:(StkGrpId'="")&(Scg'=StkGrpId)  //类组过滤
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId) //分类过滤
	.
	.s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfDr=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.q:(ManfId'="")&(ManfDr'=ManfId)
	.s DHCINCIL=$O(^DHCINCIL(0,"INCIL",Incil,""))
	.i DHCINCIL'=""  S LMGRPDR=$P(^DHCINCIL(DHCINCIL),"^",7)
	.e  s LMGRPDR=""
	.Q:(ManGrpId'="")&(LMGRPDR'=ManGrpId)
	.s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(Incil,",",SB,"") 
    .s stkbinstr=$p(stkbinret,":",2)
    .s stkbinquit=$p(stkbinret,":",1)
	.s IncsbDesc=stkbinstr
	.q:(SB'="")&&(stkbinquit=0)
	.s ManFlag=##class(web.DHCST.Common.DrugStkCommon).GetManageflag(PhaLoc,Inci)
	.q:(ManageFlag="Y")&(ManFlag'=1)  
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.;q:(UseFlag="Y")&(NotUse="Y")
	.;q:(NotUseFlag="Y")&(NotUse'="Y")
	.s IncStockQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	.s move=..ItmMoved(Inci,stdateMove,StkDate)   ;是否发生过业务
	.q:(IncStockQty=0)&(((Zeroqty="Y")&(move=0))||(Zeroqty="N"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	.s Notmove=..ItmMoved(Inci,stdateNoMove,StkDate)   ;是否发生过业务
	.q:(Notmove=0)&(NotZeroqty="Y")&(IncStockQty'=0)		;排除一定月份内无进出的非零库存
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s GeneInfo =##class(web.DHCST.Common.DrugInfoCommon).GetGene(Inci)
	.s Gene=$p(GeneInfo,"^",2)
	.s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Chlb=0  f  s Chlb=$o(^INCI(Inci,"IL",Chl,"LB",Chlb)) q:Chlb=""  d 
	..s Inclb=Inci_"||"_Chl_"||"_Chlb
	..s SalePrice=##class(web.DHCSTPRICE).GetSp(Inclb,StkDate,PurUomId,HospId,"")	//zhouyg 20141208
	..s LastReailPrice=##class(web.DHCSTPRICE).GetRp(Inclb,StkDate,PurUomId,HospId,"")
	..s SalePrice = ##class(web.DHCST.Common.AppCommon).FormatSp(SalePrice,HospId,1,"G","",Inci)
	..s LastReailPrice = ##class(web.DHCST.Common.AppCommon).FormatRp(LastReailPrice,HospId,1,"G","",Inci)
	..s StockQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBU(Inclb,StkDate,BUomId)
	..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s PurStockQty = StockQty / Fac
	..s PurStockQty=##class(web.DHCST.Common.AppCommon).FormatSq(PurStockQty,HospId,"1","")
	..s SpAmt = SalePrice * PurStockQty
	..s RpAmt=LastReailPrice* PurStockQty
	..s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	..s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	..s INCIB=$p(^INCI(Inci,"IL",Chl,"LB",Chlb),"^",1)
	..s Btno=$p(^INCI(Inci,"IB",$p(INCIB,"||",2)),"^",1)
	..s Expdate=$p(^INCI(Inci,"IB",$p(INCIB,"||",2)),"^",2)
	..i Expdate'="" s Expdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Expdate,"ST")
	..;q:(StockQty=0)&(NotZeroqty="Y")
	..
	..s TotalRpAmt=TotalRpAmt+RpAmt
	..s TotalSpAmt=TotalSpAmt+SpAmt
	..s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(INCIB) //查找批次供应商及厂家
	..i $l($p(StockQty,".",2))>6 s StockQty=##class(web.DHCST.Common.AppCommon).FormatSq(StockQty,HospId,1,"G")
	..i $l($p(PurStockQty,".",2))>6 s PurStockQty=##class(web.DHCST.Common.AppCommon).FormatSq(PurStockQty,HospId,1,"G")
	..s PVenDesc=$p(VendManf,"^",2)
	..s Data1=Inclb_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_BaseCTUomDesc_"^"_BUomId_"^"_StockQty
	..s Data2=IncsbDesc_"^"_Btno_"^"_$g(Expdate)_"^"_PurchCTUomDesc_"^"_PurUomId_"^"_PurStockQty
	..s Data3=Spec_"^"_ManfDesc_"^"_SalePrice_"^"_SpAmt_"^"_LastReailPrice_"^"_RpAmt_"^"_ManFlag_"^"_PVenDesc
	..s Data=Data1_"^"_Data2_"^"_Data3
	..s count = count+1
 	..i +sortNum=0 s index="1" 
 	..e  d
 	...s index=$p(Data,"^",sortNum)
 	...i sortAsNum="Y" s index=+index
 	..i index="" s index="ZZZZZZ"
	..s ^||DHCSTTMP("LocItmbatStat",Pid,index,count)=Data	
	s count=0
	w "{rows:["
	s TotalData="^^合计:^^^^^^^^^^^^^^"_TotalSpAmt_"^^"_TotalRpAmt_"^NULL^"
	w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(TotalData,Title)
	s count=count+1
	s orderDir=1
	i Dir="DESC" s orderDir=-1
	s subflag=""
	s tmp=""
	f  s subflag=$o(^||DHCSTTMP("LocItmbatStat",Pid,subflag),orderDir)  q:subflag=""  d
	.s num=""
	.f  s num=$o(^||DHCSTTMP("LocItmbatStat",Pid,subflag,num),orderDir)  q:num=""  d
	..s RowData=^||DHCSTTMP("LocItmbatStat",Pid,subflag,num)
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	...w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	w "],results:"_count_"}"
	k ^||DHCSTTMP("LocItmbatStat",Pid)  //2013-07-25 清除临时global
	
	q ""
}

/// Descript:	根据条件统计库存（按项目
/// Creater:	gwj
/// CreateDate:	2013-04-01
/// Input:	开始行,一页显示记录数,排序字段,排序方向,
/// 科室id^日期^类组id^厂家id^管理组id^
/// 库位id^是否管理药^零库存^6个月有进出^排除零库存^6个月无进出^
/// Output:		
/// Return：
/// W ##class(web.DHCST.LocItmStkStat).ItmStkStat("","","30","0","165^29/01/2021^3^^^^N^N^6^N^6^")
/// W ##class(web.DHCST.LocItmStkStat).ItmStkStat("0","30","","","320^2018-04-04^3^^^^N^N^6^N^6^")
ClassMethod ItmStkStat(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
	n (Sort,Dir,Limit,Start,StrParam)
	s ^YSJTMP("ItmStkStat")=$LB(Sort,Dir,Limit,Start,StrParam)
	s PhaLoc=$p(StrParam,"^",1)
	s StkDate=$p(StrParam,"^",2)
	s StkGrpId=$p(StrParam,"^",3)  //类组rowid
	s ManfId=$p(StrParam,"^",4)  //厂商
	q:PhaLoc="" ""
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StkDate)
	//q:StkGrpId="" ""
	
	s Pid=..NewPid()
	k ^||DHCSTTMP("LocItmStat",Pid)
	s ManGrpId=$p(StrParam,"^",5)
	
	s SB=$p(StrParam,"^",6)   // 货位rowid
	s ManageFlag=$p(StrParam,"^",7)  //关注标志
	s Zeroqty=$p(StrParam,"^",8)   //零库存
	s MoveMnth=$p(StrParam,"^",9)
	s NotZeroqty=$p(StrParam,"^",10)
	s NotMoveMnth=$p(StrParam,"^",11)
	s StkCatId=$p(StrParam,"^",12)  //库存分类
	
	s stdateMove=..DateByMon(-MoveMnth,StkDate)
	s stdateMove=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdateMove)
	s stdateNoMove=..DateByMon(-NotMoveMnth,StkDate)
	s stdateNoMove=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdateNoMove)	
	s count = 0
	s resultString = ""
	s end=Start+Limit
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s Title1="Inci^InciCode^InciDesc^BUomDesc^BUomId^StockQty^StkBin^PurUomDesc^PurUomId"
	s Title2="PurStockQty^Spec^ManfDesc^Sp^SpAmt^Rp^RpAmt^ManFlag"
	s Title=Title1_"^"_Title2
	// 排序
	s sortNum=$lf($lfs(Title,"^"),Sort)
	s sortAsNum=""
	i (Sort["Qty")||(Sort["Amt")||(Sort["Sp")||(Sort["Rp") s sortAsNum="Y"
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s TotalRpAmt=0,TotalSpAmt=0		;合计进价金额,合计售价金额

	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)  //库存类型过滤
	.q:ScgType'=..sssCode() 
	.q:(StkGrpId'="")&(Scg'=StkGrpId)  //类组过滤
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId) //分类过滤
	.s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfDr=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.q:(ManfId'="")&(ManfDr'=ManfId)  //厂商过滤
	.
	.s DHCINCIL=$O(^DHCINCIL(0,"INCIL",Incil,""))
	.i DHCINCIL'=""  S LMGRPDR=$P(^DHCINCIL(DHCINCIL),"^",7)
	.e  s LMGRPDR=""
	.Q:(ManGrpId'="")&(LMGRPDR'=ManGrpId)  //管理组过滤
	.s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(Incil,",",SB,"") 
    .s stkbinstr=$p(stkbinret,":",2)
    .s stkbinquit=$p(stkbinret,":",1)
	.s IncsbDesc=stkbinstr
	.q:(SB'="")&&(stkbinquit=0)
	.s ManFlag=##class(web.DHCST.Common.DrugStkCommon).GetManageflag(PhaLoc,Inci)
	.q:(ManageFlag="Y")&(ManFlag'=1)   //管理药品过滤
	.;s NotUse=$p(^INCI(Inci,2),"^",9)
	.;q:(UseFlag="Y")&(NotUse="Y")
	.;q:(NotUseFlag="Y")&(NotUse'="Y")
	.s StockQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	.s move=..ItmMoved(Inci,stdateMove,StkDate)   ;是否发生过业务
	.q:(StockQty=0)&(((Zeroqty="Y")&(move=0))||(Zeroqty="N"))	;不显示零库存,对于ZeroQty="Y"且move=1的予以显示
	.s Notmove=..ItmMoved(Inci,stdateNoMove,StkDate)   ;是否发生过业务
	.q:(Notmove=0)&(NotZeroqty="Y")&(StockQty'=0)		;排除一定月份内无进出的非零库存
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s SalePrice=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,StkDate,PurUomId,HospId,"G","")
	.s LastReailPrice=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,StkDate,PurUomId,HospId,"G","")
	.s SalePrice = ##class(web.DHCST.Common.AppCommon).FormatSp(SalePrice,HospId,1,"G","",Inci)
	.s LastReailPrice = ##class(web.DHCST.Common.AppCommon).FormatRp(LastReailPrice,HospId,1,"G","",Inci)
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s GeneInfo =##class(web.DHCST.Common.DrugInfoCommon).GetGene(Inci)
	.s Gene=$p(GeneInfo,"^",2)
	.s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	.//s StockQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s PurStockQty = StockQty / Fac
	.s PurStockQty=##class(web.DHCST.Common.AppCommon).FormatSq(PurStockQty,HospId,"1","")
	.s RpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(Incil,StkDate)
	.s SpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(Incil,StkDate)
	.
	.
	.s TotalRpAmt=TotalRpAmt+RpAmt
	.s TotalSpAmt=TotalSpAmt+SpAmt
	.
	.s Data1=Inci_"^"_InciCode_"^"_InciDesc_"^"_BaseCTUomDesc_"^"_BUomId_"^"_StockQty
	.s Data2=IncsbDesc_"^"_PurchCTUomDesc_"^"_PurUomId_"^"_PurStockQty
	.s Data3=Spec_"^"_ManfDesc_"^"_SalePrice_"^"_SpAmt_"^"_LastReailPrice_"^"_RpAmt_"^"_ManFlag
	.s Data=Data1_"^"_Data2_"^"_Data3
	.s count = count+1
 	.i +sortNum=0 s index="1" 
 	.e  d
 	..s index=$p(Data,"^",sortNum)
 	..i sortAsNum="Y" s index=+index
 	.i index="" s index="ZZZZZZ"
 	.s ^||DHCSTTMP("LocItmStat",Pid,index,count)=Data	
	s count=0
	
	w "{rows:["
	s TotalData="^合计:^^^^^^^^^^^^"_TotalSpAmt_"^^"_TotalRpAmt_"^NULL"
	w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(TotalData,Title)
	s count=count+1
	s orderDir=1
	i Dir="DESC" s orderDir=-1
	s subflag=""
	f  s subflag=$o(^||DHCSTTMP("LocItmStat",Pid,subflag),orderDir)  q:subflag=""  d
	.s num=""
	.f  s num=$o(^||DHCSTTMP("LocItmStat",Pid,subflag,num),orderDir)  q:num=""  d
	..s RowData=^||DHCSTTMP("LocItmStat",Pid,subflag,num)
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	..e  d
	..w ","_##class(web.DHCST.Common.UtilCommon).GetJsonStr(RowData,Title)
	w "],results:"_count_"}"
	k ^||DHCSTTMP("LocItmStat",Pid)  //2013-07-25 清除临时global
	q ""
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("LocStkStat"))
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
 s grp=+$P(^PHMC(MC),"^",5)
 q $g(grp)
}

/// 按月数返回某日期之前或之后的日期
/// Argu:
/// Monnum  -月数
/// inDate - 日期
/// Return:
/// 日期
ClassMethod DateByMon(Monnum As %Library.Float, inDate As %Library.String) As %Library.String
{
	n (Monnum,inDate)
	s newdd=""
	&sql(select DATEADD("month",:Monnum,:inDate)into:newdd )
	//对于版本较老的cache, 使用下面的sql
	//&sql(select distinct DATEADD('month',:Monnum,:inDate) into :newdd from inc_itmloc)
	s newdd=$p(newdd," ")
	q newdd
}

}
