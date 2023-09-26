Import sqluser

/// Descript:库存查询
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-06
Class web.DHCST.LocItmStk Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTLOCITMSTK";

/// Descript:	根据条件查询科室库存
/// Creater:	zhangdongmei	//2013-07-31 wangjiabin 不分页显示(原版本见上侧)
/// CreateDate:	2012-08-06
/// Input:	开始行,一页显示记录数,排序字段,排序方向,
/// 科室id^日期^类组id^库存类型(全部:0,库存为0:1,库存为正:2,库存为负:3)^库存项id^
/// 进口标志^库存分类id^药学分类id^药学子类id^药学小类id^医嘱子类id^管制分类id^厂家id^医保类型id^
/// 剂型id^是否管理药^仅在用品种^仅不可用品种
/// Output:		
/// Return：w ##class(web.DHCST.LocItmStk).LocItmStk("0","30","","","246^14/04/2020^3^0^^^^^^^^^^^^N^Y^N^^0^N")
ClassMethod LocItmStk(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
	n (Start,Limit,Sort,Dir,StrParam)
	s endpage=Start+Limit  //结束行
	s stpage=Start+1 //开始行
	s Pid=..NewPid()
    Set $ZT="ERRORLocItmStk"
	s PhaLoc=$p(StrParam,"^",1)
	s StkDate=$p(StrParam,"^",2)
	s StkGrpId=$p(StrParam,"^",3)
	s StockType=$p(StrParam,"^",4)
	q:PhaLoc="" ""
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StkDate)
	q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	//q:StkGrpId="" ""
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	s IncId=$p(StrParam,"^",5)
	s ImpFlag=$p(StrParam,"^",6)
	s StkCatId=$p(StrParam,"^",7)
	s PhcCat=$p(StrParam,"^",8)
	s PhcSubCat=$p(StrParam,"^",9)
	s PhcMinCat=$p(StrParam,"^",10)
	s ArcSubCatId=$p(StrParam,"^",11)
	s PHCDFPhcDoDR=$p(StrParam,"^",12)
	s ManfId=$p(StrParam,"^",13)
	s InsuType=$p(StrParam,"^",14)
	s FormId=$p(StrParam,"^",15)
	s ManageFlag=$p(StrParam,"^",16)
	s UseFlag=$p(StrParam,"^",17)
	s NotUseFlag=$p(StrParam,"^",18)
	s PhcCatAll=$p(StrParam,"^",19) //多级药学分类
	s ArcStat=$p(StrParam,"^",20) //医嘱项状态(截止/在用/全部)
	s StoNoZeroFlag=$p(StrParam,"^",21)
	s ReservedFlag=$p(StrParam,"^",22)
	s num = 1		//2013-09-10  0-->1  留出^DHCSTTMP("LocItmStk",Pid,sub,1) 保存合计
	s resultString = ""
	s end=Start+Limit
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	//s json = ##class(Code.JsonObj).%New()
	s RpAmtSum=0,SpAmtSum=0		//进价,售价 金额合计
	s Inci=0
	f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
	.s Chl=$o(^INCI("IL_LOC",PhaLoc,Inci,0))
	.s Incil=Inci_"||"_Chl
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.q:(StkGrpId'="")&(Scg'=StkGrpId)
	.q:(IncId'="")&(Inci'=IncId)
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.q:(UseFlag="Y")&(NotUse="Y")
	.q:(NotUseFlag="Y")&(NotUse'="Y")
	.s arcimstopdate=""
	.i ArcStat'="0" s arcimstopdate=+##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDateByInci(Inci)
	.q:(ArcStat="1")&&((+arcimstopdate="0")||(arcimstopdate>+$h))
	.q:(ArcStat="2")&&(+arcimstopdate'="0")&&(arcimstopdate<=+$h)
	.s delflag=1
	.s:StoNoZeroFlag="Y" delflag=##class(web.DHCST.Common.DrugStkCommon).CheckStoNoZeroBt(Inci,PhaLoc)
	.q:delflag'=1
	.i PhcCatAll'="" d
	..s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(Inci)
	..s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	.e  s retflag=""
	.q:(PhcCatAll'="")&&(retflag=0) //add wyx 2014-12-08 药学多级分类
	.i ArcSubCatId'="" d
	..s ArcItmCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(Inci)
	..s ItemCatId=$p(ArcItmCatInfo,"^",1)
	.e  s ItemCatId=""
	.q:(ArcSubCatId'="")&&(ItemCatId'=ArcSubCatId)
	.s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(Inci)
	.s OfficalCode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"",HospId) //医保类别
	.s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfDr=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.q:(ManfId'="")&(ManfDr'=ManfId)
	.s ItmImpFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmImpFlag(Inci)
	.q:(ImpFlag'="")&(ItmImpFlag'=ImpFlag)
	.s ManFlag=##class(web.DHCST.Common.DrugStkCommon).GetManageflag(PhaLoc,Inci)
	.q:(ManageFlag="Y")&(ManFlag'=1)   
	.s StockQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	.q:(StockType=1)&(StockQty'=0)     ;只检索库存为零记录
	.q:(StockType=2)&(StockQty'>0)     ;只检索库存为正记录
	.q:(StockType=3)&(StockQty'<0)     ;只检索库存为负记录
	.s InciCode = $p(^INCI(Inci,1),"^",1)
	.s InciDesc = $p(^INCI(Inci,1),"^",2)
	.//s IncsbDesc =##class(web.DHCST.Common.DrugStkCommon).GetStkBin(PhaLoc,Inci)
	.//取新科室货位表过滤货位 add wyx 2013-11-21 //改为取新的科室货位表DHCIncItmLocBin（可多货位）
    .s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(Incil,",","","") 
    .s stkbinstr=$p(stkbinret,":",2)
	.s IncsbDesc=stkbinstr
	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s PurStockQty = StockQty / Fac
	.s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	.s SalePrice=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,StkDate,PurUomId,HospId,"G","")
	.s LastReailPrice=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,StkDate,PurUomId,HospId,"G","")
	.s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	.s RpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(Incil,StkDate)
	.s SpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(Incil,StkDate)
	.s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	.s StkQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,StockQty)
	.s DirtyQty=##class(web.DHCST.Common.DrugStkCommon).CurIncResQtyLb(Incil,BUomId)
	.s DirtyQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,DirtyQty) 
	.s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(Incil,BUomId)
	.s AvaQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,AvaQty) 
	.s ReservedQty=0 
	.//s ReservedQty=$p(^INCI(+Incil,"IL",$p(Incil,"||",2)),"^",10) //在途数 add wyx 2013-11-13
	.s RetList=##Class(web.DHCSTSTKQTY).GetIncilQtyList(Incil,"N") //wyx modify 2015-01-22在途数调用方法
	.s ReservedQty=$p(RetList,"^",3) //在途数
	.s ReservedQty=$fn(ReservedQty,"N")
	.q:(ReservedFlag="Y")&&(+ReservedQty=0)
	.//q:ReservedQty=0
	.s GeneInfo =##class(web.DHCST.Common.DrugInfoCommon).GetGene(Inci)
	.s Gene=$p(GeneInfo,"^",2)
	.s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(Inci)
	.s FormDr=$p(FormInfo,"^",3)
	.s Form=$p(FormInfo,"^",2)
	.q:(FormId'="")&(FormDr'=FormId)
	.s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugPhcCat(Inci)
	.s PCat=$p(PhcCatInfo,"^",1)
	.s PSubCat=$p(PhcCatInfo,"^",3)
	.s PMinCat=$p(PhcCatInfo,"^",5)
	.q:(PhcCat'="")&(PCat'=PhcCat)
	.q:(PhcSubCat'="")&(PSubCat'=PhcSubCat)
	.q:(PhcMinCat'="")&(PMinCat'=PhcMinCat)
	.s PHCDFPhcDoInfo=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(Inci)
	.s PDFPhcDo=$p(PHCDFPhcDoInfo,"^",2)
	.q:(PHCDFPhcDoDR'="")&(PDFPhcDo'=PHCDFPhcDoDR)
	.//售价金额按系统保留,售价总金额按原始售价金额计算,总金额保留
	.s RpAmtSum=+RpAmt+RpAmtSum
	.s SpAmtSum=+SpAmt+SpAmtSum
	.s Data1=Incil_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_IncsbDesc_"^"_PurchCTUomDesc_"^"_BaseCTUomDesc
	.s Data2=PurStockQty_"^"_StockQty_"^"_StkQtyUom_"^"_SalePrice_"^"_SpAmt_"^"_LastReailPrice_"^"_RpAmt
	.s Data3=Spec_"^"_ManfDesc_"^"_OfficalCode_"^"_ManFlag_"^"_DirtyQtyUom_"^"_AvaQtyUom_"^"_ReservedQty_"^"_Gene_"^"_Form
	.s Data=Data1_"^"_Data2_"^"_Data3
	.s num = num+1
	.i Sort="InciCode"  d
	..s ^DHCSTTMP("LocItmStk",Pid,InciCode,num)=Data
	.e  i Sort="InciDesc"  d
	..s ^DHCSTTMP("LocItmStk",Pid,InciDesc,num)=Data
	.e  i Sort="StkBin"  d
	..s:IncsbDesc="" IncsbDesc=" "
	..s ^DHCSTTMP("LocItmStk",Pid,IncsbDesc,num)=Data
	.e  i (Sort="PurStockQty")||(Sort="StockQty")||(Sort="StkQtyUom")  d
	..s ^DHCSTTMP("LocItmStk",Pid,StockQty,num)=Data
	.e  i Sort="DirtyQty"  d
	..s ^DHCSTTMP("LocItmStk",Pid,DirtyQty,num)=Data
	.e  i Sort="AvaQty"  d 
	..s ^DHCSTTMP("LocItmStk",Pid,AvaQty,num)=Data
	.e  d
	..s ^DHCSTTMP("LocItmStk",Pid,Incil,num)=Data
	.
	q:num=1 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s sub=$o(^DHCSTTMP("LocItmStk",Pid,""))	;取第一个节点, 为使其显示在第一行
	s ^DHCSTTMP("LocItmStk",Pid,sub,1)="^^合计:^^^^^^^^^"_SpAmtSum_"^^"_RpAmtSum_"^^^^NULL^^^^^"
       
       q:Limit=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
       s maxrow=num
       i endpage>maxrow s endpage=maxrow

	i Dir="DESC"  d
	.d OutRowDesc(Pid,stpage,endpage,maxrow,Dir)
	e  d
	.d OutRowAsc(Pid,stpage,endpage,maxrow)

	
	k ^DHCSTTMP("LocItmStk",Pid)
	q ""
 
OutRowAsc(Pid,stpage,endpage,maxrow)
	n (Pid,stpage,endpage,maxrow)
	s subflag=""
	s count=0
	f  s subflag=$o(^DHCSTTMP("LocItmStk",Pid,subflag))  q:subflag=""  d
	.s num=0
	.f  s num=$o(^DHCSTTMP("LocItmStk",Pid,subflag,num))  q:num=""  d
	..s RowData=^DHCSTTMP("LocItmStk",Pid,subflag,num)
	..s count=count+1
	..d ..OutRowDetail(RowData,stpage,endpage,maxrow,count)
	..
	q
 
	
OutRowDesc(Pid,stpage,endpage,maxrow,Dir)
	n (Pid,stpage,endpage,maxrow,Dir)
	q:Dir'="DESC"
	s count=0
	s subflag=""
	f  s subflag=$o(^DHCSTTMP("LocItmStk",Pid,subflag),-1)  q:subflag=""  d
	.s num=""
	.f  s num=$o(^DHCSTTMP("LocItmStk",Pid,subflag,num),-1)  q:num=""  d
	..s RowData=^DHCSTTMP("LocItmStk",Pid,subflag,num)
	..s count=count+1
	..d ..OutRowDetail(RowData,stpage,endpage,maxrow,count)
	..
	q

   
ERRORLocItmStk
    //遇报错,则先kill TMP
    Set Method= "##class(web.DHCST.LocItmStk).LocItmStk"
	Set ErrorMsg=Method_"("_Start_","_Limit_","_StrParam_")"_","_$ZE
	k ^DHCSTTMP("LocItmStk",Pid) 
    q $ze
}

ClassMethod OutRowDetail(RowData, stpage, endpage, maxrow, count)
{
	n (RowData,stpage,endpage,maxrow,count)
	s Incil=$p(RowData,"^",1)
	s Inci=$p(RowData,"^",2)
	s InciCode=$p(RowData,"^",3)
	s InciDesc=$p(RowData,"^",4)
	s StkBin=$p(RowData,"^",5)
	s PurUomDesc=$p(RowData,"^",6)
	s BUomDesc=$p(RowData,"^",7)
	s PurStockQty=$p(RowData,"^",8)
	s StockQty=$p(RowData,"^",9)
	s StkQtyUom=$p(RowData,"^",10)
	s Sp=$p(RowData,"^",11)
	s SpAmt=$p(RowData,"^",12)
	s Rp=$p(RowData,"^",13)
	s RpAmt=$p(RowData,"^",14)
	s Spec=$p(RowData,"^",15)
	s ManfDesc=$p(RowData,"^",16)
	s OfficalCode=$p(RowData,"^",17)
	s ManFlag=$p(RowData,"^",18)
	s DirtyQty=$p(RowData,"^",19)
	s AvaQty=$p(RowData,"^",20)
	s ReservedQty=$p(RowData,"^",21)
	s Gene=$p(RowData,"^",22)
	s Form=$p(RowData,"^",23)
       q:count<stpage
       q:count>endpage
       s Incil=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Incil",Incil)
	s Inci=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Inci",Inci)
	s InciCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciCode",InciCode)
	s InciDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("InciDesc",InciDesc)
	s StkBin=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkBin",StkBin)
	s PurUomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurUomDesc",PurUomDesc)
	s BUomDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("BUomDesc",BUomDesc)
	s PurStockQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PurStockQty",PurStockQty)
	s StockQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StockQty",StockQty)
	s StkQtyUom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("StkQtyUom",StkQtyUom)
	s Sp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Sp",Sp)
	s SpAmt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("SpAmt",SpAmt)
	s Rp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Rp",Rp)
	s RpAmt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RpAmt",RpAmt)
	s Spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Spec",Spec)
	s ManfDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManfDesc",ManfDesc)
	s OfficalCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("OfficalCode",OfficalCode)
	s ManFlag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ManFlag",ManFlag)
	s DirtyQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("DirtyQty",DirtyQty)
	s AvaQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("AvaQty",AvaQty)
	s ReservedQty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ReservedQty",ReservedQty)
	s Gene=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Gene",Gene)
	s Form=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("FormDesc",Form)
       s tmpstr=Incil_Inci_InciCode_InciDesc_StkBin_PurUomDesc_BUomDesc_PurStockQty_StockQty_StkQtyUom_Sp_SpAmt_Rp_RpAmt_Spec_ManfDesc_OfficalCode_ManFlag_DirtyQty_AvaQty_ReservedQty_Gene_Form
       s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
       s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
       s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
       i count=stpage w startString
       i count<endpage w firstrow
       i count=endpage w lastrow
}

/// Descript:查询某一科室库存项的所有批次信息
/// Creater:	zhangdongmei
/// CreateDate:	2012-08-08
/// Input:	开始行,一页显示记录数,排序字段,排序方向,
/// 科室库存id^日期
/// Output:		
/// Return：
/// Others:w ##class(web.DHCST.LocItmStk).Batch("0","30","","","2627||7^13/04/2020^1^^")
ClassMethod Batch(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
	n (Start,Limit,Sort,Dir,StrParam)
	//s ^YSJTMP("Batch")=$LB(Start,Limit,Sort,Dir,StrParam)
	s Incil=$p(StrParam,"^",1)
	s Date=$p(StrParam,"^",2)
	//s StoNoZeroFlag=$p(StrParam,"^",3)
	s IncilIfNotZero=$p(StrParam,"^",3)
	s IncilStkActive=$p(StrParam,"^",4)
	s IncilArcActive=$p(StrParam,"^",5)
	
	s Pid=..NewPid()
	q:Incil="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	i Date=""  d
	.s Date=+$h
	e  d
	.s Date=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(Date)
	s Title="BatNo^ExpDate^QtyUom^BRp^PRp^Inclb^DirtyQty^AvaQty^PVenDesc^PManf^NotUseFlag^BSp^PSp^InclbResQty^LockUser^LockDate^StkNotUseFlag"
	// 排序
	i Sort="" s Dir="DESC"
	s sortNum=$lf($lfs(Title,"^"),Sort)
	s sortAsNum=""
	i (Sort["Qty")||(Sort["Amt")||(Sort["Sp")||(Sort["Rp") s sortAsNum="Y"
	s Num=0
	s LB=0
	s Inci=+Incil
	s IL=$p(Incil,"||",2)
	s PhaLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	s HospId=$p(^CTLOC(PhaLoc),"^",22)
	f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB))  q:LB=""  d
	.s Inclb=Inci_"||"_IL_"||"_LB
    .s Incib=""
    .s Incib=$P(^INCI(Inci,"IL",IL,"LB",LB),"^",1)
    .s Chl=$p(Incib,"||",2)
    .s IncQty=##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLB(Inclb,Date)
    .;b ;1
    .s BatNo=$p(^INCI(Inci,"IB",Chl),"^",1)
 	.s ExpDate=+$p(^INCI(Inci,"IB",Chl),"^",2)
 	.i ExpDate'=0  d
 	..s Expire=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
 	.e  d
 	..s Expire=""
 	.s PurUomId=$p(^INCI(Inci,3),"^",6)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId) 
 	.s BRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId,"G",Date,"")
	.s PRp=##class(web.DHCST.Common.PriceCommon).GetClbRp(Inclb,PurUomId,HospId,"G",Date,"")
	.s BSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,Date,BUomId,HospId,"G","")
	.s PSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,Date,PurUomId,HospId,"G","")
	.s QtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,IncQty)
	.s DirtyQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbResQty(Inclb,BUomId)
	.s DirtyQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,DirtyQty) 
	.s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurInclbAvaQty(Inclb,BUomId)
	.s AvaQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,AvaQty)
	.s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(Incib) //查找批次供应商及厂家
	.s InclbResQty=##class(web.DHCST.Common.DrugStkCommon).InclbReservedQty(Inclb,BUomId)
	.s InclbResQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,InclbResQty) 
	.s PVenDesc=$p(VendManf,"^",2)
	.s PManf=$p(VendManf,"^",4)
	.s (active,LockUser,LockDate,LockTime,stkactive)=""
	.s dhcinclb=$o(^DHCINCLB(0,"LB",Inclb,""))
	.i dhcinclb'="" d
	..s active=$p(^DHCINCLB(dhcinclb),"^",2)
	..s stkactive=$p(^DHCINCLB(dhcinclb),"^",4)
	..s LockUser=$p(^DHCINCLB(dhcinclb),"^",6)
	..s LockUser=$s(LockUser'="":$p(^SSU("SSUSR",LockUser),"^",2),1:"")
	..s LockDate=$p(^DHCINCLB(dhcinclb),"^",7)
	..s:LockDate'="" LockDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(LockDate,"ST")
	..s LockTime=$p(^DHCINCLB(dhcinclb),"^",8)
	..s:LockTime'="" LockTime=$zt(LockTime,1)
	..s LockDate=LockDate_" "_LockTime
	.//q:(StoNoZeroFlag="Y")&&((IncQty=0)||(active="Y"))
	.q:(IncilIfNotZero=1)&&(IncQty=0)
	.q:(IncilIfNotZero=2)&&(IncQty'=0)
	.
	.q:(IncilStkActive=1)&&(stkactive'="Y")
	.q:(IncilStkActive=2)&&(stkactive="Y")
	.q:(IncilArcActive=1)&&(active'="Y")
	.q:(IncilArcActive=2)&&(active="Y")
	.i active="Y" s notuseflag="N"
	.e  s notuseflag="Y"
	.i stkactive="Y" s stknotuseflag="N"
	.e  s stknotuseflag="Y"
	.s Data=BatNo_"^"_Expire_"^"_QtyUom_"^"_BRp_"^"_PRp_"^"_Inclb_"^"_DirtyQtyUom_"^"_AvaQtyUom_"^"_PVenDesc_"^"_PManf_"^"_notuseflag_"^"_BSp_"^"_PSp_"^"_InclbResQtyUom_"^"_LockUser_"^"_LockDate_"^"_stknotuseflag
 	.i +sortNum=0 d
 	..s index=$j(IncQty,10)_"||"_ExpDate
 	.e  d
 	..s index=$p(Data,"^",sortNum)
 	..i sortAsNum="Y" s index=+index
 	.i index="" s index="ZZZZZZZZZ"
 	.s ^||TMPDHCST("LocItmStk",Pid,index,Inclb)=Data
 	.s Num=Num+1
 	q:'$d(^||TMPDHCST("LocItmStk",Pid)) ##class(web.DHCSTEXTCOMMON).GetNoJson()
 	s End=Start+Limit
	s Start=Start+1
	s count=0
	i $ZCVT(Dir,"U")="DESC" s orderflag=-1 //正序
	e  s orderflag=1 //倒序
	s retstring=""
	s outputi=""
	f  s outputi=$o(^||TMPDHCST("LocItmStk",Pid,outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^||TMPDHCST("LocItmStk",Pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputdata=^||TMPDHCST("LocItmStk",Pid,outputi,outputj)
	..s count=count+1
	..q:count<Start
	..q:count>End
	..i count=Start d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(Num)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w ","_retstring
	i retstring'="" w "]}"  //如果不报错,至少有一条记录
	e  w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	k ^||TMPDHCST("LocItmStk",Pid)
 	q ""
}

/// Descript:占用数量单据查询
/// Creater:	zhangdongmei
/// CreateDate:	2012-08-16
/// Input:	科室库存批次id
/// Output:		
/// Return：
ClassMethod GetDirtyQtyInfo(Inclb As %String) As %String
{
	n (Inclb)
	q:Inclb="" ""
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
 	;
 	d GetInfoFromTr
	;d GetInfoFromRet	2013-08-13 wangjiabin 注释对于退货占用的查询
	s resultString = json.getJsonData("Rowid^No^Qty^Uom^Date^Type",count)
	k json
	q resultString
 
GetInfoFromTr
 s init=""
 f  s init=$o(^DHCINIT(0,"INCLB",Inclb,init)) q:init=""  d
 .;b
 .s stat=$p(^DHCINIT(init),"^",14)
 .q:(stat=21)!(stat=31)!(stat=30)!(stat=40)			;转移出库审核通过和转移入库审核通过不存在占用   //新增拒绝接收 和 重转作废都不占占用
 .s trno=$p(^DHCINIT(init),"^",1)
 .s trdate=$p(^DHCINIT(init),"^",2)
 .s trdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(trdate,"ST")
 .s chl=""
 .f  s chl=$o(^DHCINIT(0,"INCLB",Inclb,init,chl))  q:chl=""  d
 ..s tmpinci=+Inclb
 ..s rowid=init_"||"_chl
 ..s qty=$p(^DHCINIT(init,"ITI",chl),"^",1)
 ..s uomdr=$p(^DHCINIT(init,"ITI",chl),"^",7)
 ..s uom=$p(^CT("UOM",uomdr),"^",2)
 ..s incicode=$p(^INCI(tmpinci,1),"^",1)
 ..s incidesc=$p(^INCI(tmpinci,1),"^",2)
 ..s count = count+1
 ..s result=rowid_"^"_trno_"^"_qty_"^"_uom_"^"_trdate_"^"_"T"
 ..d json.InsertRowData(result)
 .
 q 
 
GetInfoFromRet
 s grt=""
 f  s grt=$o(^INGRT(0,"INCLB",Inclb,grt)) q:grt=""  d
 .s auditdate=+$p(^INGRT(grt),"^",9)
 .q:auditdate>0					;已审核的单据不存在占用
 .s retno=$p(^INGRT(grt),"^",1)
 .s retdate=$p(^INGRT(grt),"^",3)
 .s retdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retdate,"ST")
 .s chl=""
 .f  s chl=$o(^INGRT(0,"INCLB",Inclb,grt,chl))  q:chl=""  d
 ..s tmpinci=+Inclb
 ..s rowid=grt_"||"_chl
 ..s qty=$p(^INGRT(grt,"DHCGRR",chl),"^",2)
 ..s uomdr=$p(^INGRT(grt,"DHCGRR",chl),"^",3)
 ..s uom=$p(^CT("UOM",uomdr),"^",2)
 ..s incicode=$p(^INCI(tmpinci,1),"^",1)
 ..s incidesc=$p(^INCI(tmpinci,1),"^",2)
 ..s count = count+1
 ..
 ..s result=rowid_"^"_retno_"^"_qty_"^"_uom_"^"_retdate_"^"_"R"
 ..d json.InsertRowData(result)
 .
 q
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("LocStk"))
}

/// d ##class(web.DHCST.LocItmStk).ClrResQtyAll()
ClassMethod ClrResQtyAll() As %String
{
	d ##class(PHA.COM.Reserve).ClrRes()
	q 1
}

/// d ##class(web.DHCST.LocItmStk).ClrResQtyLoc(科室ID)
ClassMethod ClrResQtyLoc(locdr) As %String
{
	N (locdr)
	d ##class(PHA.COM.Reserve).ClrLocRes(locdr)
	q 1
}

ClassMethod ClrResQtyLocInci(Incil) As %String
{
	n (Incil)
	d ##class(PHA.COM.Reserve).ClrIncilRes(Incil)
	q 1
}

ClassMethod SynIncilLoc(locdr)
{
 
 n ADJ,incil,ch
 q:locdr="" -2
 s inci="0"
 f  s inci=$o(^INCI(inci)) q:inci=""  d
 .s ch=""
 .f  s ch=$o(^INCI("IL_LOC",locdr,inci,ch))  q:ch=""  d
 ..s incil=inci_"||"_ch
 ..q:ch=""
 ..d ..equal(incil)
 q 1
}

ClassMethod SynInciLocInci(Incil)
{
 n ini,ch
 s inci=+Incil
 s ch=$p(Incil,"||",2)
 q:inci="" -1
 q:ch="" -2
 //s ch=$o(^INCI("IL_LOC",locdr,inci,""))  q:ch="" -4
 s incil=inci_"||"_ch
 d ..equal(incil)
 q 1
}

ClassMethod equal(incil)
{
 n inci,ch,lbch,inclb
 n lbqty,dhclbqty,adjqty,ctuom,lpkqty
 n ADJI,incicode,incidesc
 ;
 s inci=+incil,ch=$P(incil,"||",2)
 s lbch=0
 s i=0,j=0
 
 f  s lbch=$O(^INCI(inci,"IL",ch,"LB",lbch)) q:lbch=""  d
  .s inclb=incil_"||"_lbch
  .s lbqty=$P(^INCI(inci,"IL",ch,"LB",lbch),"^",2)
  .s today=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"ST")
  .s dhclbqty=+##CLASS(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,today)
  .s lpkqty=lbqty+$g(^DHCSTCOMMONSRV4($j,"PACKCLB",inclb))       ;------------打包数量计算在内
  .i +lpkqty'=dhclbqty  d
  . . i +dhclbqty<0 s dhclbqty=0
  . . s adjqty=dhclbqty-lpkqty
  . . i (adjqty<0)&(lbqty+adjqty<0) s adjqty=-lbqty
  . . s i=i+1
  . . //s err=##class(web.DHCSTPCHCOLLS4).MakeUpStk(inclb,adjqty)
  . . s err=##class(web.DHCSTLOCDTOTAL).MakeUpStk(inclb,adjqty)
  . . i $g(err)'=0 d
  . . . s j=j+1
  . . . s incicode=$P(^INCI(inci,1),"^",1)
  . . . s incidesc=$P(^INCI(inci,1),"^",2)
  . . . s ^TMP($j,"INSERTITEM",j)="Insert Item Err: " _inclb_"^"_incicode_"^"_incidesc_"^"_adjqty_"^"_$h
 q i
}

/// Descript:取库存查询界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：台帐信息^全院在途数清除^科室在途数清除^科室单品在途数清除^科室库存同步^科室单品库存同步
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    ;s ^zdm("GetParamProp")=GroupId_"^"_LocId_"^"_UserId
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.LocItmStk).%GetParameter("AppName")
    s TransShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"TransShow",Param)
    s ClrResQtyAllShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ClrResQtyAllShow",Param)
    s ClrResQtyLocShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ClrResQtyLocShow",Param)
    s ClrResQtyLocInciShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ClrResQtyLocInciShow",Param)
    s SynInciLocShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SynInciLocShow",Param)
    s SynInciLocInciShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SynInciLocInciShow",Param)
    s DayTotalShow=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DayTotalShow",Param)                  ;hulihua-2014-05-30
    
    s Data1=TransShow_"^"_ClrResQtyAllShow_"^"_ClrResQtyLocShow_"^"_ClrResQtyLocInciShow_"^"_SynInciLocShow_"^"_SynInciLocInciShow_"^"_DayTotalShow
    q Data1
}

/// 检索全院库存查询数据
/// Author:wyx
/// Date:2013-11-14
/// Argu:
/// Input:StrParam=日期^类组^类型^库存项rowid^进口标志^库存分类^药学大类^药学子类^药学小类^医嘱子类
///                 ^管制分类^厂商^医保类别^剂型^管理药^仅在用品种^仅不在用品种
///  
/// D ##class(%ResultSet).RunQuery("web.DHCST.LocItmStk","LocItmStkAll","2020-06-08^3^0^^^^^^^^^^^^N^N^N^") 
Query LocItmStkAll(StrParam As %String, HOSPID As %String = "") As %Query(ROWSPEC = "PhaLocDesc:%String,Incil:%String,Inci:%String,InciCode:%String,InciDesc:%String,IncsbDesc:%String,PurchCTUomDesc:%String,BaseCTUomDesc:%String,PurStockQty:%String,StockQty:%String,StkQtyUom:%String,SalePrice:%String,SpAmt:%String,LastReailPrice:%String,RpAmt:%String,Spec:%String,ManfDesc:%String,OfficalCode:%String,ManFlag:%String,DirtyQtyUom:%String,AvaQtyUom:%String,ReservedQty:%String,Gene:%String,Form:%String") [ SqlProc ]
{
}

ClassMethod LocItmStkAllExecute(ByRef qHandle As %Binary, StrParam As %String, HOSPID As %String = "") As %Status
{
	
	n (qHandle,StrParam,HOSPID)
	//s ^YSJTMP("LocItmStkAllExecute")=StrParam
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
	s StkDate=$p(StrParam,"^",1)
	s StkGrpId=$p(StrParam,"^",2)
	s StockType=$p(StrParam,"^",3)
	i StkDate=""  d
	.s StkDate=+$h
	e  d
	.s StkDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StkDate)
	s Pid=..NewPid()
	s IncId=$p(StrParam,"^",4)
	s ImpFlag=$p(StrParam,"^",5)
	s StkCatId=$p(StrParam,"^",6)
	s PhcCat=$p(StrParam,"^",7)   //药学大类
	s PhcSubCat=$p(StrParam,"^",8) //药学子类
	s PhcMinCat=$p(StrParam,"^",9) //药学小类
	s ArcSubCatId=$p(StrParam,"^",10) //医嘱子类
	s PHCDFPhcDoDR=$p(StrParam,"^",11) //管制分类
	s ManfId=$p(StrParam,"^",12)
	s InsuType=$p(StrParam,"^",13)
	s FormId=$p(StrParam,"^",14) //剂型
	s ManageFlag=$p(StrParam,"^",15)
	s UseFlag=$p(StrParam,"^",16)
	s NotUseFlag=$p(StrParam,"^",17) 
	s PhcCatAll=$p(StrParam,"^",18) //多级药学分类 
	s count = 1		//2013-09-10  0-->1  留出^DHCSTTMP("LocItmStk",Pid,sub,1) 保存合计
	s resultString = ""
	s RpAmtSum=0,SpAmtSum=0		//进价,售价 金额合计
	s PhaLoc=""
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci=0
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s Scg=$p(StkGrpInfo,"^",5)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.q:ScgType'=..sssCode()
	.q:(StkGrpId'="")&(Scg'=StkGrpId)
	.q:(IncId'="")&(Inci'=IncId)
	.s Incsc=$p(^INCI(Inci,2),"^",2)
	.q:(StkCatId'="")&(Incsc'=StkCatId)
	.s NotUse=$p(^INCI(Inci,2),"^",9)
	.q:(UseFlag="Y")&(NotUse="Y")
	.q:(NotUseFlag="Y")&(NotUse'="Y")
	.s ArcItmCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(Inci)
	.s ItemCatId=$p(ArcItmCatInfo,"^",1)
	.q:(ArcSubCatId'="")&(ItemCatId'=ArcSubCatId)
	.s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(Inci)
	.s OfficalCode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"",HOSPID) //医保类别
	.s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(Inci)
	.s ManfDr=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	.q:(ManfId'="")&(ManfDr'=ManfId)
	.s ItmImpFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmImpFlag(Inci)
	.q:(ImpFlag'="")&(ItmImpFlag'=ImpFlag)
	.s GeneInfo =##class(web.DHCST.Common.DrugInfoCommon).GetGene(Inci)
	.s Gene=$p(GeneInfo,"^",2)
	.s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(Inci)
	.s FormDr=$p(FormInfo,"^",3)
	.s Form=$p(FormInfo,"^",2)
	.q:(FormId'="")&(FormDr'=FormId)
	.s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugPhcCat(Inci)
	.s PCat=$p(PhcCatInfo,"^",1)
	.s PSubCat=$p(PhcCatInfo,"^",3)
	.s PMinCat=$p(PhcCatInfo,"^",5)
	.q:(PhcCat'="")&(PCat'=PhcCat)
	.q:(PhcSubCat'="")&(PSubCat'=PhcSubCat)
	.q:(PhcMinCat'="")&(PMinCat'=PhcMinCat)
	.
	.s PhaCatAllDesc=""
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(Inci)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	.q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	.s PHCDFPhcDoInfo=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(Inci)
	.s PDFPhcDo=$p(PHCDFPhcDoInfo,"^",2)
	.q:(PHCDFPhcDoDR'="")&(PDFPhcDo'=PHCDFPhcDoDR)
	.s Sub=0
	.f  s Sub=$o(^INCI(Inci,"IL",Sub)) q:Sub=""  d
	..s Incil=Inci_"||"_Sub
	..q:$p($g(^INCI(Inci,"IL",Sub)),"^",1)=""
	..s PhaLoc=$p(^INCI(Inci,"IL",Sub),"^",1)
	..q:PhaLoc=""
	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(PhaLoc),"^",22))
	..s PhaLocDesc=$P(^CTLOC(PhaLoc),"^",2)
	..i PhaLocDesc["-" s PhaLocDesc=$p(PhaLocDesc,"-",2)
	..s PhaLocType=$P(^CTLOC(PhaLoc),"^",13)
	..//q:PhaLocType'="D"
	..s HospId=$p(^CTLOC(PhaLoc),"^",22)
	..s ManFlag=##class(web.DHCST.Common.DrugStkCommon).GetManageflag(PhaLoc,Inci)
	..q:(ManageFlag="Y")&(ManFlag'=1)   
	..s StockQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,PhaLoc,StkDate)
	..q:(StockType=1)&(StockQty'=0)     ;只检索库存为零记录
	..q:(StockType=2)&(StockQty'>0)     ;只检索库存为正记录
	..q:(StockType=3)&(StockQty'<0)     ;只检索库存为负记录
	..s InciCode = $p(^INCI(Inci,1),"^",1)
	..s InciDesc = $p(^INCI(Inci,1),"^",2)
    ..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(Incil,",","","") 
    ..s IncsbDesc=$p(stkbinret,":",2)
	..s PurUomId=$p(^INCI(Inci,3),"^",6)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s PurStockQty = StockQty / Fac
	..s PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
	..s SalePrice=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inci,StkDate,PurUomId,HospId,"G","")
	..s LastReailPrice=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(Inci,StkDate,PurUomId,HospId,"G","")
	..s SpAmt = ##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(Incil,StkDate)
	..s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
	..s RpAmt=##class(web.DHCST.Common.DrugStkCommon).GetRpAmt(Incil,StkDate)
	..s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	..s StkQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,StockQty)
	..s DirtyQty=##class(web.DHCST.Common.DrugStkCommon).CurIncResQty(Incil,BUomId)
	..s DirtyQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,DirtyQty) 
	..s AvaQty=##class(web.DHCST.Common.DrugStkCommon).CurItmAvaQtyB(Incil,BUomId)
	..s AvaQtyUom=##class(web.DHCST.Common.DrugStkCommon).QtyWithUom(Inci,AvaQty) 
	..s ReservedQty=0 
	..s ReservedQty=$p(^INCI(+Incil,"IL",$p(Incil,"||",2)),"^",10) //在途数 add wyx 2013-11-13
	..i ManFlag="1" s ManFlag="管理药"
	..e  s ManFlag="非管理药"
	..s RpAmtSum=+RpAmt+RpAmtSum
	..s SpAmtSum=+SpAmt+SpAmtSum
	..s SpAmtSum=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmtSum,HospId)
	..s RpAmtSum=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmtSum,HospId)
	..s SpAmt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(SpAmt,HospId)
	..s RpAmt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(RpAmt,HospId)
	..s count = count+1
	..d OutPurRow
	.
 
 Quit $$$OK
OutPurRow
 
 s Data=$lb(PhaLocDesc,Incil,Inci,InciCode,InciDesc,IncsbDesc,PurchCTUomDesc,BaseCTUomDesc,PurStockQty,StockQty,StkQtyUom,SalePrice,SpAmt,LastReailPrice,RpAmt,Spec,ManfDesc,OfficalCode,ManFlag,DirtyQtyUom,AvaQtyUom,ReservedQty,Gene,Form)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmStkAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmStkAllExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmStkAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmStkAllExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// creator:yunhaibao
/// createdate:20151118
/// description:修改批次不可用状态
/// input:inclb^notuseflag$c(1)inclb^notuseflag
/// w ##class(web.DHCST.LocItmStk).ChangeBatchUseFlag("s")
ClassMethod ChangeBatchUseFlag(batlistdetail As %String) As %Library.String
{
	n (batlistdetail)
	q:batlistdetail="" "保存信息为空!"
	s ret=0
	ts
	s $ZT="Error^DHCSTERROR"
	s listlength=$l(batlistdetail,$c(1))
	f listi=1:1:listlength  d
	.s listdata=$p(batlistdetail,$c(1),listi)
	.s inclb=$p(listdata,"^",1)
	.s notuseflag=$p(listdata,"^",2)
	.s userid=$p(listdata,"^",3)
	.s stknotuseflag=$p(listdata,"^",4)
	.s ret=##class(web.DHCST.DrugInfoMaintain).SaveBatInfo(inclb,notuseflag,userid,stknotuseflag)
	.i ret'=0 tro
	q:ret'=0 -10
	tc
	q 0
}

/// creator:yunhaibao
/// createdate:2015-12-18
/// description:根据任务清除门诊未交费医嘱在途数,规则为这次执行任务,清除前24到12小时的未交费数据,或72-36
/// input:任务间隔的小时数,比如12小时一次则入参为12,Type:1-清除未交费,2清除未发药,ParaAdmType:病人就诊类型(O/E)
/// 先发药后交费的不清
/// w ##class(web.DHCST.LocItmStk).ClearReserveQtyClinicNoPay(720,2)
ClassMethod ClearReserveQtyClinicNoPay(Hours, Type, ParaAdmType = "")
{
	n (Hours,Type,ParaAdmType)
	q:+Hours=0 ""
	s nowtime=$zdt($h,3)  //此处不格式化   
	&SQL(SELECT DATEADD(hh,-:Hours,:nowtime),DATEADD(hh,-2*:Hours,:nowtime) into :enddatetime,:begindatetime)
	s begindatetime=$zdth(begindatetime,3)
	s enddatetime=$zdth(enddatetime,3)
	s begindate=+begindatetime,begintime=$p(begindatetime,",",2)   //开始日期，开始时间
	s enddate=+enddatetime,endtime=$p(enddatetime,",",2)
	s locStr="",locid="",countnum=0
	f  s locid=$o(^CTLOC(0,"LocType","D",locid)) q:locid=""  d  
	.i locStr="" s locStr=locid
	.e  s locStr=locStr_"^"_locid
	q:locStr="" ""	 
	f i=1:1:$l(locStr,"^") d
	.s locdr=$p(locStr,"^",i)
	.s hospid=$p($g(^CTLOC(locdr)),"^",22)
	.s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(hospid)
	.s orddate=""
	.f orddate=begindate:1:enddate d
	..s ord=""
	..f  s ord=$o(^OEORDi(0,"LocStDtArr",locdr,0,orddate,ord)) q:ord=""  d
	...s AdmDr=$p(^OEORD(ord),"^",1)
	...s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
	...q:(AdmType'="O")&(AdmType'="E") //门急诊
	...q:(ParaAdmType'="")&(AdmType'=ParaAdmType)
	...s chl=""
	...f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,orddate,ord,chl)) q:chl=""  d
	....s bill=$p(^OEORD(ord,"I",chl,3),"^",5)
	....q:(Type=1)&&(bill="P")  //过滤已交费   bill 费别
 	....s pr=+$p(^OEORD(ord,"I",chl,1),"^",8)
    ....i pr'=0 s prcode=$p(^OECPR(pr),"^",1)
    ....q:prcode["OM" //自备药
	....s ordstatus=$p(^OEORD(ord,"I",chl,3),"^",5)
	....s ordstatdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	....s ordstat=$p(^OEC("OSTAT",ordstatdr),"^",1)       
    ....q:(ordstat'="V")&(ordstat'="E") //非有效医嘱
	....s ordtime=$p(^OEORD(ord,"I",chl,1),"^",10)
	....q:(orddate=begindate)&&(ordtime<begintime) 
	....q:(orddate=enddate)&&(ordtime>endtime)
	....s arcim=$p(^OEORD(ord,"I",chl,1),"^",2)
	....s arcsub=+arcim
	....s arcver=+$p(arcim,"||",2)
	....q:(arcsub=0)||(arcver=0)
	....q:'$d(^INCI(0,"ARCIM_DR",+arcim))
	....s dsp=$o(^DHCOEDISQTY(0,"OEORI",ord_"||"_chl,""),-1) //可能有R记录
	....q:dsp=""
	....s status=$p(^DHCOEDISQTY(dsp),"^",7)
	....q:status'="TC"  
	....s category=$p(^DHCOEDISQTY(dsp),"^",27)
	....q:category=0 //过滤门诊静配
	....s dspsub=0
	....f  s dspsub=$o(^DHCOEDISQTY(dsp,"I",dspsub)) q:dspsub=""  d
	.....d ##class(PHA.COM.Reserve).ClrReserveByPointer(dsp_"||"_dspsub)
	q ""
}

/// creator:    yunhaibao 
/// createdate: 2017-06-09
/// description:在途数明细查询
/// tables:		User.DHCIncReservedQtyDetail(下医嘱后INCRQDClrFlag字段为N)
/// input:      strParams^1(批次ID或科室库存项ID)
/// others:     w ##class(web.DHCST.LocItmStk).GetReserveQtyInfo("309||1")
ClassMethod GetReserveQtyInfo(strParams, Start, Limit)
{
	n (strParams,Start,Limit) 
	s End=Start+Limit
	s Start=Start+1
	k GetReserveQtyInfoDATA
	s incilRowId=$p(strParams,"^",1)
	q:(+incilRowId=0) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s inciRowId=+incilRowId
	s title1="incilRowId^pointer^patNo^patName"
	s title2="orderDept^prescNo^resQty^uomDesc^oeDspDate"
	s title3="oeDspTime"
	s title=title1_"^"_title2_"^"_title3
	s bUomDr=$p(^INCI(inciRowId,1),"^",10)
	s pUomDr=$p(^INCI(inciRowId,3),"^",6)
	s bUomDesc=$p(^CT("UOM",bUomDr),"^",2)
	s pUomDesc=$p(^CT("UOM",pUomDr),"^",2)
	s bpFac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUomDr,bUomDr)
	s typeStr="1^5"
	s typeLen=$l(typeStr,"^")
	f typeI=1:1:typeLen d
	.s type=$p(typeStr,"^",typeI)
	.s date=""
	.f  s date=$o(^DHCSTINCRQDi("IncilFlagTypeDate",incilRowId,"N",type,date)) q:date=""  d
	..q:+date=0
	..s id=""
	..f  s id=$o(^DHCSTINCRQDi("IncilFlagTypeDate",incilRowId,"N",type,date,id)) q:id=""  d
	...q:+id=0
	...s DHCSTINCRQD=$g(^DHCSTINCRQD(id))
	...s qty=$p(DHCSTINCRQD,"^",3)
	...q:+qty<=0
	...s pointer=$p(DHCSTINCRQD,"^",5)
	...s index=+pointer
	...s $p(GetReserveQtyInfoDATA(index,pointer),"^",1)=id
	...s $p(GetReserveQtyInfoDATA(index,pointer),"^",2)=$p(GetReserveQtyInfoDATA(index,pointer),"^",2)+qty
	i '$d(GetReserveQtyInfoDATA) w ##class(web.DHCSTEXTCOMMON).GetNoJson() q ""
	
	s count=0
	s index=""
	f  s index=$o(GetReserveQtyInfoDATA(index)) q:index=""  d
	.q:+index=0
	.s pointer=""
	.f  s pointer=$o(GetReserveQtyInfoDATA(index,pointer)) q:pointer=""  d
	..s count=count+1
 	..q:count<Start
 	..q:count>End
	..s pData=GetReserveQtyInfoDATA(index,pointer)
	..s lastId=$p(pData,"^",1)
	..s qty=$p(pData,"^",2)
	..s qty=$fn(qty,"N")
	..s incrqData=$g(^DHCSTINCRQD(lastId))
	..s incrqDate=$p(incrqData,"^",6)
	..s incrqTime=$p(incrqData,"^",7)
	..s inclbRowId=$p(incrqData,"^",4)
	..s (incrqDateHtml,incrqTimeHtml)=""
	..i incrqDate'="" s incrqDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(incrqDate)
	..i incrqTime'="" s incrqTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(incrqTime)
	..s oeoriId=$p($g(^DHCOEDISQTY(+pointer)),"^",1)
	..s ordId=+oeoriId
	..s ordItm=+$p(oeoriId,"||",2)
	..q:ordItm=0
	..s paadmId=+$p($g(^OEORD(ordId)),"^",1)
	..q:paadmId=0
	..s papmiId=+$p($g(^PAADM(paadmId)),"^",1)  
	..q:papmiId=0
	..s patNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1) 
	..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) 
	..s orderDept=$p($g(^OEORD(ordId,"I",ordItm,7)),"^",2)   	
	..i orderDept'="" s orderDept=$p($g(^CTLOC(orderDept)),"^",2)
	..s prescNo=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",14)
	..s uomDesc=bUomDesc
	..s data1=incilRowId_"^"_pointer_"^"_patNo_"^"_patName
	..s data2=orderDept_"^"_prescNo_"^"_qty_"^"_uomDesc_"^"_incrqDateHtml
	..s data3=incrqTimeHtml
	..s data=data1_"^"_data2_"^"_data3
    ..i count=Start d
    ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(data,title)
	...w "{rows:["_retstring
    ..e  d
    ...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(data,title)
	...w ","_retstring
	q:count'>0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	w "],results:"_count_"}"
	q ""
}

/// creator:    yunhaibao 
/// createdate: 2017-06-19
/// description:按打包表记录查询在途数总数
/// input:      oeDsp(打包表ID)
/// others:     w ##class(web.DHCST.LocItmStk).GetReserveQtyByOeDsp("99841||1")
ClassMethod GetReserveQtyByOeDsp(oeDsp As %String) As %String
{
	n (oeDsp)
	q:oeDsp="" 0
	s incrqAllQty=0
	s clrFlag=""
	s incrqType=""
	f  s incrqType=$o(^DHCSTINCRQDi("Type",incrqType)) q:incrqType=""  d
	.s incrqRowId=""
	.f  s incrqRowId=$o(^DHCSTINCRQDi("Type",incrqType,oeDsp,incrqRowId)) q:incrqRowId=""  d
	..s clrFlag=$p(^DHCSTINCRQD(incrqRowId),"^",10)
	..s incrqQty=$p(^DHCSTINCRQD(incrqRowId),"^",3)
	..s incrqAllQty=incrqAllQty+incrqQty
	q:clrFlag="Y" 0
	q incrqAllQty
}

/// creator:    yunhaibao 
/// createdate: 2017-07-07
/// description:结合在途数查询界面,按打包表ID+数量清指定数量在途
/// input:      oeDsp(打包表ID),incilRowId(科室库存ID),resQty(清除数量)
/// 写的什么玩意...
/// others:     w ##class(web.DHCST.LocItmStk).ClrResQtyByOeDsp("13288","1043||4",100)
ClassMethod ClrResQtyByOeDsp(oeDsp, incilRowId, resQty) As %String
{
	n (oeDsp,incilRowId,resQty)
	i resQty<0 s resQty=0
	e  s resQty=-resQty
	s lastIncrqId=""
	s date=""
	f  s date=$o(^DHCSTINCRQDi("DateIncil",date),-1) q:(date="")||(lastIncrqId'="")  d
	.q:lastIncrqId'=""
	.s lastIncrqId=$o(^DHCSTINCRQDi("DateIncil",date,incilRowId,""),-1)
	s lastLbQty=0
	i lastIncrqId'="" s lastLbQty=$p(^DHCSTINCRQD(lastIncrqId),"^",9)
	s incId=+incilRowId
	s incCh=$p(incilRowId,"||",2)
	s locId=$p(^INCI(incId,"IL",incCh),"^",1)
	s resRet=##class(web.DHCST01).UPDINVRESQTY(incId,locId,resQty)
	q:resRet'=1 -1
    s sqlStr=incilRowId_"^"_4_"^"_resQty_"^"_""_"^"_oeDsp_"^"_locId
    s resRet=##Class(User.DHCIncReservedQtyDetail).Insert(sqlStr)
    q resRet
}

/// Author : MaYuqiang
/// Date Created : 20190308
/// Description : 根据科室库存项id以及在途数插入在途数明细表
/// 			倒序遍历在途明细表，将不存在负记录的数据插入一条负记录，当处理的在途数量与当前在途数量一致时退出
/// Input : incil - 科室库存项id , resqty - 在途数 , cleardate - 清除在途日期
/// Output : 0 - 成功 , 其他 - 失败
/// Table : INC_ItmLoc  DHC_IncReservedQtyDetail
/// w ##class(web.DHCST.LocItmStk).InsResInfo("685||1",3,"")
/// 有问题啊,先不掉
ClassMethod InsResInfo(incil, resqty, cleardate) As %String
{
	n (incil,resqty,cleardate)
	q:(incil="")||(resqty=0) 0
	s:cleardate="" cleardate=+$h
	s unclrqty=0	//未清除的在途数
	s ClrResTypeStr="2^3^4"			//清在途方式串
	s ClrResTypeLen=$l(ClrResTypeStr,"^")
	s succflag="0"
	s resdate=cleardate+1
	f  s resdate=$o(^DHCSTINCRQDi("DateIncil",resdate),-1) q:((resdate="")||(succflag'="0"))  d
	.s incrqdid=""
	.f  s incrqdid=$o(^DHCSTINCRQDi("DateIncil",resdate,incil,incrqdid),-1) q:((incrqdid="")||(succflag'="0"))  d
	..q:'$d(^DHCSTINCRQD(incrqdid))
	..s incrqdData=$g(^DHCSTINCRQD(incrqdid))
	..s incrqdQty=$p(incrqdData,"^",3)		//在途数量
	..q:incrqdQty<0							//仅判断在途增加的业务数据
	..s pointer=$p(incrqdData,"^",5)
	..s clredflag=$$ChkClrResQtyFlag()
	..q:clredflag="1"
	..s RecLocID=$p(^INCI(+incil,"IL",$p(incil,"||",2)),"^",1)
	..s lastResQty=resqty-unclrqty-incrqdQty
	..s sqlStr=incil_"^"_4_"^"_-incrqdQty_"^"_""_"^"_pointer_"^"_RecLocID_"^"_lastResQty_"^"_"Y"
	..s InsResRet=##Class(User.DHCIncReservedQtyDetail).Insert(sqlStr)
	..i InsResRet>0 d
	...s unclrqty=unclrqty+incrqdQty
	..i unclrqty'<resqty d
	...s succflag="1"
	
	q unclrqty


ChkClrResQtyFlag()
	s ClrFlag="0"	//清除标记 0-未清除，1-已清除
	f TypeNum=1:1:ClrResTypeLen q:ClrFlag'="0"  d
	.s ClrType=$p(ClrResTypeStr,"^",TypeNum)
	.s rqdid=$o(^DHCSTINCRQDi("Type",ClrType,pointer,""))
	.i rqdid'="" d
	..s ClrFlag="1"
	q ClrFlag
}

/// Description: 检查是否有垃圾科室库存项 1:无科室字段的 2:存在节点没数据的
/// Creator:yangsj
/// CreateDate:2020-02-05
/// Input:
/// OutPut:
/// Table:
/// Other: w ##class(web.DHCST.LocItmStk).CheckErorrIncil()
ClassMethod CheckErorrIncil()
{
	s inci=0
	f  s inci=$O(^INCI(inci)) q:inci=""  d 
	.s sub=0 
	.f  s sub=$o(^INCI(inci,"IL",sub)) q:sub=""  d
	..i '$D(^INCI(inci,"IL",sub)) k ^INCI(inci,"IL",sub) q
	..i $D(^INCI(inci,"IL",sub))=10 k ^INCI(inci,"IL",sub) q
	..s loc=$P(^INCI(inci,"IL",sub),"^",1)
	..i loc="" k ^INCI(inci,"IL",sub)

	
	q ""
}

/// Description:全院库存查询(批次)
/// Creator: 	zhaoxinlong
/// CreatDate:	2022-03-08	
/// Input:		inputStr
/// Output:		
/// Debug:		d ##class(%ResultSet).RunQuery("web.DHCST.LocItmStk","AllBatStock","2022-05-31^3^0^^^^^^^^^^^^N^N^N^")
Query AllBatStock(inputStr As %String) As websys.Query(ROWSPEC = "inciDesc, spec, spellCode, locDesc, inclbQty:%Float, vendor, baseFlag, rp, batNo, sp, rpAmt:%Float, spAmt:%Float, expdate, vendorCode , phcCatDesc, form, stkGrpDesc, poison, manf, stkBinStr, puom, lastUseDateTime, inci, inciCode, centPurFlag") [ SqlProc ]
{
}

ClassMethod AllBatStockExecute(ByRef qHandle As %Binary, inputStr As %String) As %Status
{
	tro 
	s ^PHATMP("MYQ", $this, "AllBatStock") = $lb(inputStr)
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1 
	q:(inputStr = "") $$$OK
	s pid = ..NewPid()
	s date = $p(inputStr, "^", 1)
	s pStkGrpID = $p(inputStr, "^", 2)
	s pStockType = $p(inputStr, "^", 3)
	s pInci = $p(inputStr, "^", 4)
	s date = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(date)
	s pImpFlag = $p(inputStr, "^", 5)
	s pStkCatID = $p(inputStr, "^", 6)
	s pArcIetmCat = $p(inputStr, "^", 10)
	s pPhcDoDr = $p(inputStr, "^", 11)
	s pManfID = $p(inputStr, "^", 12)
	s pOfficialType = $p(inputStr, "^", 13)
	s pFormID = $p(inputStr, "^", 14)
	s pManDrug = $p(inputStr, "^", 15)
	s pUseFlag = $p(inputStr, "^", 16)
	s pNotUseFlag = $p(inputStr, "^", 17)
	s pPhcCatAll = $p(inputStr, "^", 18)
	s lastDate = date - 1
	s inci = "0"
	for {
		s inci = $o(^INCI(inci))
		q:(inci = "")
		continue:('$$GetInciData())
		s ilSub = ""
		for {
			s ilSub = $o(^INCI(inci, "IL", ilSub))
			q:(ilSub = "")
			s loc = $p($g(^INCI(inci, "IL", ilSub)), "^", 1)
			continue:(+loc = 0)
			s locType = $p($g(^CTLOC(loc)), "^", 13)
			continue:(locType '= "D")
			s incil = inci _"||"_ ilSub
			s manFlag = ##class(web.DHCST.Common.DrugStkCommon).GetManageflag(loc,inci)
			continue:(pManDrug = "Y")&(manFlag '= 1)  
			s locDesc = $p(^CTLOC(loc), "^", 2)
			s hospID = $p(^CTLOC(loc), "^", 22)
			s stkBinRet=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    		s stkBinStr=$p(stkBinRet,":",2)
			s inclb = ""
			for {
				s inclb = $o(^DHCBTLOCTOT(0,"INCIDateLocINCLB", inci, lastDate, loc, inclb))
				q:(inclb = "")
				d GetInclbData
			}
			// 当天新增批次记录
			s inclb = ""
			for {
				s inclb = $o(^DHCBTLOCTOT(0,"INCIDateLocINCLB", inci, date, loc, inclb))
				q:(inclb = "")
				continue:$d(^DHCBTLOCTOT(0,"INCLBDATE",inclb,lastDate))
				d GetInclbData
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
		
GetLastUseInfo(inclb)
	s trDate = $o(^DHCINTR(0,"INCLB", inclb, ""), -1)
	q:(trDate = "") ""
	s lastIntrID = $o(^DHCINTR(0,"INCLB", inclb, trDate, ""), -1)
	q:(lastIntrID = "") ""
	s time = $p($g(^DHCINTR(lastIntrID)), "^", 3)	
	q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(trDate) _" "_ ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(time)
	
GetInciData()
	q:(pInci '= "")&&(pInci '= inci) $$$NO
	s incsc = $p($g(^INCI(inci, 2)), "^", 2)
	q:(+incsc = 0) $$$NO
	s notUse = $p(^INCI(inci, 2), "^", 9)
	q:(pNotUseFlag = "Y")&(notUse '= "Y") $$$NO
	q:(pUseFlag = "Y")&(notUse = "Y") $$$NO
	q:(pStkCatID '= "")&(incsc '= pStkCatID) $$$NO
	s stkGrpStr = ##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	s stkType = $p(stkGrpStr, "^", 3)
	q:(stkType '= "G") $$$NO
	s stkGrpID = $p(stkGrpStr, "^", 5)
	q:(pStkGrpID '= "")&&(pStkGrpID '= stkGrpID) $$$NO
	s stkGrpDesc = $p(stkGrpStr, "^", 2)
	s ItmImpFlag = ##class(web.DHCST.Common.DrugInfoCommon).GetItmImpFlag(inci)
	q:(pImpFlag '= "")&(ItmImpFlag '= pImpFlag)
	s arcItmCatInfo = ##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(inci)
	s ItemCatId = $p(arcItmCatInfo, "^", 1)
	q:(pArcIetmCat '= "")&(ItemCatId '= pArcIetmCat) $$$NO
	s phcDoInfo = ##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inci)
	s phcDo = $p(phcDoInfo,"^",2)
	q:(pPhcDoDr '= "")&(pPhcDoDr '= phcDo) $$$NO
	s poison = $p(phcDoInfo,"^",1)
	s PhaCatAllstr = ##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(inci)
	s PhaCatAlls = $p(PhaCatAllstr, "^", 1)
	s PhaCatAllDesc = $p(PhaCatAllstr, "^", 2)
	s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(pPhcCatAll,PhaCatAlls)
	q:(pPhcCatAll'="")&(retflag=0) $$$NO  
	s inciDesc = $p(^INCI(inci, 1), "^", 2)
	s spec = ##class(web.DHCST.Common.DrugInfoCommon).GetSpec("", inci)
	s spellCode = ##class(ext.util.String).ToChineseSpell(inciDesc) 
	s baseFlag = ##class(web.DHCST.Common.DrugInfoCommon).GetBasicByInci(inci)
	s phcCatStr = ##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(inci)
	s phcCatDesc = $p(phcCatStr, "^", 2)
	s formStr = ##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci)
	s formID = $p(formStr, "^", 1)
	q:(pFormID '= "")&&(pFormID '= formID) $$$NO
	s form = $p(formStr, "^", 2)
	s puomID = $p(^INCI(inci, 3), "^", 6)
	s puom = $p(^CT("UOM", puomID), "^", 2)
	s inciCode = $p($g(^INCI(inci, 1)), "^", 1)
	s centPurFlag = ##Class(web.DHCST.Common.DrugInfoCommon).IsCentPur(inci)
	q $$$YES

GetInclbData
	s inclbQty = ##class(web.DHCST.Common.DrugStkCommon).QtyINCLBU(inclb , date, puomID)
	q:(pStockType = 1)&(inclbQty '= 0)     ;只检索库存为零记录
	q:(pStockType = 2)&(inclbQty '> 0)     ;只检索库存为正记录
	q:(pStockType = 3)&(inclbQty '< 0)     ;只检索库存为负记录
	s incib = $p(^INCI(inci, "IL", ilSub, "LB", $p(inclb, "||", 3)), "^", 1)
	s vendorManfStr = ##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(incib)
	s vendorId = $p(vendorManfStr, "^", 1)
	s vendorCode = $p($g(^APC("APCVM",+vendorId)),"^",2) 
	s vendor = $p(vendorManfStr, "^", 2)
	s manfID = $p(vendorManfStr, "^", 3)
	q:(pManfID '= "")&&(manfID '= pManfID)
	s manf = $p(vendorManfStr, "^", 4)
	s rp=##class(web.DHCST.Common.PriceCommon).GetClbRp(inclb, puomID, hospID, "G", date, "")
	s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inclb, date, puomID, hospID, "G", "")
	s batInfo = ##class(web.DHCST.Common.DrugStkCommon).Bat(inclb)
	s batNo = $p(batInfo, "^", 1)
	s expdate = $p(batInfo, "^", 2)
	s rpAmt = rp * inclbQty
	s spAmt = sp * inclbQty
	s lastUseDateTime = $$GetLastUseInfo(inclb)	
	s data1 = $lb(inciDesc, spec, spellCode, locDesc, inclbQty)
	s data2 = $lb(vendor, baseFlag, rp, batNo, sp)
	s data3 = $lb(rpAmt, spAmt, expdate, vendorCode , phcCatDesc)
	s data4 = $lb(form, stkGrpDesc, poison, manf, stkBinStr)
	s data5 = $lb(puom, lastUseDateTime, inci, inciCode, centPurFlag)
	set ^CacheTemp(repid,ind)= data1 _ data2 _ data3 _ data4 _ data5
	set ind=ind+1
	q
}

/// Description：挂任务追加库存批次表记录
/// Author:		 zhaoxinlong 
/// CreatDate:	 2022-03-08
/// Input:
/// Output:		 0 -- 成功
/// w ##class(web.DHCST.LocItmStk).AddDHCLocDayTask()
ClassMethod AddDHCLocDayTask()
{
	s date = +$H - 1 
	q ##class(web.DHCST.Common.StockHandle).InitBTDaily(date,date)
}

}
