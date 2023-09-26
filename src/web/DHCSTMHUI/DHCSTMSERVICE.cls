Import SQLUser

/// up :xuchao
/// 2015-3-3
/// Description:为其它组提供接口函数,其它组统一调用这里
Class web.DHCSTMHUI.DHCSTMSERVICE Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 批次价调用方法,大概说明: 共10个.
/// 除GetBatSpFlag/InsDspBatch/InsDspBatchForOut等几个之外,基本都在web.DHCSTINTERFACE包裹了一层.
/// 
/// 0.批次售价标记
/// 	GetBatSpFlag
/// 1.医嘱录入-库存判断
/// ##class(web.DHCSTINTERFACE).GetIncilQtyList
/// 	这个方法没有调用物流的程序. 医嘱录入环节,显示数量的时候用到.
/// 	如web.DHCDocOrderEntry,web.DHCDocOrderEntryCM,web.DHCOEOrdItem
/// 	注:截止2021-04,该方法直接使用了药库的代码.
/// ##class(web.DHCSTINTERFACE).GetAvailQtyByArc
/// 	在web.DHCDocOrderCommon中调用
/// 
/// 2.价格取值
/// 	这几个价格取法, 在##class(web.UDHCJFPRICE).GetPriceByBatch中集中调用,且仅有一次.
/// 	分别按照医嘱执行记录(oeore)/医嘱id(oeori)/接收科室(incil)/库存项目(inci)这4个优先级进行取值.
/// ##class(web.DHCSTINTERFACE).GetDspSp			;oeore
/// ##class(web.DHCSTINTERFACE).GetDispBatFirstSp	;oeori
/// ##class(web.DHCSTINTERFACE).GetNotEmptyINCILSp	;incil
/// ##class(web.DHCSTINTERFACE).GetIncibLastSp		;inci
/// 
/// 3.批次打包表处理/在途处理
/// 	目前医生站均在##class(web.DHCOEDispensing).PortForDurg中调用.
/// 	不论是否批次售价流程,均调用了InsDspBatch/InsDspBatchForOut方法(设置在途,也是在此方法内实现).
/// 	SetOeResQty作为在途数处理的专用方法,仅在清除在途时使用到了.
/// ##class(web.DHCSTMHUI.DHCSTMSERVICE).InsDspBatch
/// ##class(web.DHCSTMHUI.DHCSTMSERVICE).InsDspBatchForOut
/// ##class(web.DHCSTINTERFACE).SetOeResQty
/// 
/// 4.特殊内容
/// ##class(web.DHCSTINTERFACE).BILLDisp, 该方法是供计费调用的(本来计划通过集成平台).自8.4之后的版本中,计费调用物资方法,优先使用这个!
/// ##class(web.DHCSTINTERFACE).AllowDispFlag, 该方法供计费组调用,判断医嘱是否可以调用物资的Disp方法
/// 
/// Descript：	是否采用批次售价
/// Input:		医院ID, 医嘱项ID(Arc_ItmMast)
/// Return:		1-采用 0-不采用
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetBatSpFlag(2,"",65565)
ClassMethod GetBatSpFlag(HospID As %String = "", ArcimId = "", DateH = "")
{
	n (HospID,ArcimId,DateH)
	s Inci=""
	i ArcimId'="" d
	.s ArcSub=$p(ArcimId,"||",1)
	.q:ArcSub=""
	.s Inci=$o(^INCI(0,"ARCIM_DR",ArcSub,0))
	
	s BatSpFlag=..sssBatSpFlag(HospID,Inci,"",DateH)
	i BatSpFlag=2 s BatSpFlag=0
	q BatSpFlag
}

/// Descript： 	根据医嘱项和科室取库存数量、在途数等
/// CreateDate：2015-01-19
/// Input：		医嘱项ID,科室ID
/// Return：	当前库存数^可用库存数^医嘱占用数^库存业务占用数
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetIncilQtyList("3271||1","6")
ClassMethod GetIncilQtyList(Arcim As %String, RecLocId As %String) As %String
{
	n (Arcim,RecLocId)
	s $ZT=..sssError()
	q:Arcim="" ""
	q:RecLocId="" ""
	s Inci=##Class(web.DHCSTMHUI.SRVCOMMON).GetInciID(Arcim)
	q:Inci="" ""
	s IL=$o(^INCI("IL_LOC",RecLocId,Inci,""))
	q:IL="" ""
	s Incil=Inci_"||"_IL
	//判断科室库存项是否加锁
	s DhcIncil=$o(^DHCINCIL(0,"INCIL",Incil,""),-1)
	s LockFlag=$s(DhcIncil'="":$p(^DHCINCIL(DhcIncil),"^",1),1:"N")
	q:LockFlag="Y" ""
	s RetList=##Class(web.DHCSTMHUI.SRVINTERFACE).GetIncilQtyList(Incil,"Y")
	q RetList
}

/// Descript：	开医嘱或发药时判断是否有可用库存(批次价与非批次价通用)
/// CreateDate：2013-08-12
/// Input：		医嘱项ID,接收科室ID,基本单位数量,判断逻辑库存还是实库存(0可用库存,1当前库存,目前只对非批次价有意义,批次价必须判断逻辑库存程序已经写死)
/// Return:		0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetAvailQtyByArc("61||1","115","1","0","","Y")
ClassMethod GetAvailQtyByArc(Arcim As %String, RecLocId As %String, Qty As %String, ResFlag As %String = "0", Barcode As %String = "", IfCheckExp As %String = "Y")
{
	n (Arcim,RecLocId,Qty,ResFlag,Barcode,IfCheckExp)
	q:Arcim="" 0
	q:RecLocId="" 0
	s ArcSub=$p(Arcim,"||",1)
	q:ArcSub="" 0
	s Inci=$o(^INCI(0,"ARCIM_DR",ArcSub,""))
	q:Inci="" 0
	s IL=$o(^INCI("IL_LOC",RecLocId,Inci,0))
	q:IL="" 0
	s Incil=Inci_"||"_IL
	
	//记录是否过滤过期物资参数
	i '$d(^DHCSTM("CheckExp")) d
	.s ^DHCSTM("CheckExp")=IfCheckExp
	
	s RetCode=0
	s HospID=$p(^CTLOC(RecLocId),"^",22)
	s RuleFlag=..sssBatSpFlag(HospID,Inci)
	
	s HVFlag=##class(web.DHCSTMHUI.PCHCOLLSM).GetArcimHighValueFlag(Arcim)
	s StockControl=##class(web.DHCSTMHUI.Common.UtilCommon).GetStockControl(RecLocId)
	q:(HVFlag'="Y")&&(StockControl="N")&&(RuleFlag=0) 1
	
	s AvialQty=0
	i RuleFlag=1 d
	.s AvialQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,"",2,"N",IfCheckExp)
	e  d
	.i ResFlag=1 d
	..s AvialQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,"",3,"N",IfCheckExp)	//判断当前库存
	.e  d
	..s AvialQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).CurItmAvaQtyB(Incil,"",2,"N",IfCheckExp)	//判断在途和占用
	..//非批次价科室医嘱在途数在科室库存表$p(^INCI(Inci,"IL",IL),"^",10)中，批次价科室在+$p(^DHCINCLB(dhcinclb),"^",3)中
	..//AvialQty的数量里没有包含非批次价科室的医嘱在途数需要再减去
	..//有没有科室先是走批次价，后来改为非批次价，这样会不会出现多减在途数的情况？
	..s oeResQty=$p(^INCI(Inci,"IL",IL),"^",10)
	..s AvialQty=AvialQty-oeResQty
	.
	
	i AvialQty>=Qty s RetCode=1
	q RetCode
}

/// Description:判断科室内是否有库存记录(入库/接收等)
/// CreateDate:	2021-12-09
/// Input：		医嘱项ID,接收科室ID
/// Return:		0或"",没有库存记录; 1-存在库存记录(入库或接收过)
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetStockFlag("11796||1",163)
ClassMethod GetStockFlag(Arcim As %String, LocId As %String)
{
	n (Arcim,LocId)
	q:Arcim="" ""
	q:LocId="" ""
	s RetCode=0
	
	s ArcSub=$p(Arcim,"||",1)
	q:ArcSub="" ""
	s InciId=$o(^INCI(0,"ARCIM_DR",ArcSub,""))
	q:InciId="" ""
	s Qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(InciId,LocId,+$h)
	i +Qty>0 s RetCode=1 q RetCode
	
	;入库或接收过
	i $d(^DHCINTR(0,"LOCTYPEDATE",LocId,"G"))||$d(^DHCINTR(0,"LOCTYPEDATE",LocId,"K")) s RetCode=1 q RetCode
	
	q RetCode
}

/// Descript：	取医嘱执行记录售价(批次价格使用,住院按执行取价格)
/// CreateDate：2014-12-24
/// Table：		DHC_OEDispensing,DHC_OEDispBatch
/// Input：		DspID-DHC_OEDispensing的ID
/// Output：	批次售价
/// Return：	批次售价
ClassMethod GetDspSp(DspID As %String) As %String
{
	n (DspID)
	s batsp=##Class(web.DHCSTMHUI.SRVCOMMON).GetDspSp(DspID)
	q batsp
}

/// Descript：	获取配药批次表中第一个批次售价(门诊按医嘱取价格)
/// CreateDate：2013-09-16
/// Return:		售价
ClassMethod GetDispBatFirstSp(HospID As %String, OrdItmdr As %String, Recloc As %String)
{
	n (HospID,OrdItmdr,Recloc)
	q:OrdItmdr="" 0
	s oedosdr="",batsp=0
	s oedosdr=$o(^DHCOEDISQTY(0,"OEORI",OrdItmdr,oedosdr))
	q:(oedosdr="") 0
	q:'$D(^DHCOEDISQTY(oedosdr)) 0
	s batsp=##Class(web.DHCSTMHUI.SRVCOMMON).GetDspSp(oedosdr)
	i batsp=0 d
	.s HospID=""
	.s Recloc=$p($g(^OEORD(+OrdItmdr,"I",+$p(OrdItmdr,"||",2),3)),"^",6)
	.i Recloc'="" s HospID=$p($g(^CTLOC(Recloc)),"^",22)
	.s ArcitmDr=$p($g(^OEORD(+OrdItmdr,"I",+$p(OrdItmdr,"||",2),1)),"^",2)
	.s batsp=##Class(web.DHCSTMHUI.SRVINTERFACE).GetBatSp(ArcitmDr,Recloc)
	q batsp
}

/// Descript：	获取有库存材料的批次售价(仅仅开医嘱时取价格显示使用，其它业务不要用)
/// CreateDate：2013-09-16
/// Input：		Arc_ItmMast的ID,接收科室ID
/// Output：	批次售价
/// Return：	批次售价,-100加锁失败,-102医嘱项为空,-103科室为空,-104对应库存项不存在,-106科室库存项不存在
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetNotEmptyINCILSp("2","61||1","115","")
ClassMethod GetNotEmptyINCILSp(HospID As %String, Arcim As %String, Recloc As %String, BarCode As %String = "")
{
	n (HospID,Arcim,Recloc,BarCode)
	s sp=##Class(web.DHCSTMHUI.SRVINTERFACE).GetBatSp(Arcim,Recloc,BarCode)
	q sp
}

/// Descript：	获取当前药品最后一个批次的当前售价(按医院取批次售价)
/// CreateDate：2013-09-16
/// Return:		售价
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetIncibLastSp("2","443||1")
ClassMethod GetIncibLastSp(HospID As %String, Arcim As %String)
{
	n (HospID,Arcim)
	s inciID=##Class(web.DHCSTMHUI.SRVCOMMON).GetInciID(Arcim)
	q:inciID="" 0
	s sp=+##Class(web.DHCSTMHUI.SRVCOMMON).GetCurSp(inciID,"",HospID)
	q sp
}

/// Descript：		根据医嘱医嘱处理在途数(医生站接口,批次价和非批次价通用)
/// CreateDate：	2015-01-15
/// Table：			
/// Input：			医嘱ID,医嘱执行ID,seFlag(开医嘱:1，停医嘱或执行:2)
/// 				医嘱ID,医嘱执行ID只能输入其一，如果两个都录入就按执行ID处理
/// Return：		0-成功,其它-失败
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).SetOeResQty("483||8","",2)
ClassMethod SetOeResQty(OeItmID As %String, OeExeID As %String, seFlag As %String) As %String
{
	n (OeItmID,OeExeID,seFlag)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"SetOeResQty"
	s Params=OeItmID_";"_OeExeID_";"_seFlag
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="SetOeResQtyErr"
	s Ret=##Class(web.DHCSTMHUI.SRVINTERFACE).SetOeResQty(OeItmID,OeExeID,seFlag)
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",Ret)
	q Ret
SetOeResQtyErr
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// Descript：	住院开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// CreateDate：2013-08-08
/// Table：		DHC_OEDispensing,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input：		DHC_OEDispensing的ID,RollFlag(1为滚医嘱)
/// Return：    0-没有满足条件的批次, 1-保存成功, <0-表示错误,对非1的需要回滚整个医嘱
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).InsDspBatch(24448,0,"","fffff")
ClassMethod InsDspBatch(DspID As %String, RollFlag As %String, barcode As %String = "") As %String
{
	n (DspID,RollFlag,barcode)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"InsDspBatch"
	s Params=DspID_";"_RollFlag_";"_barcode
	s OeoriID=$p($g(^DHCOEDISQTY(DspID)),"^",1)
	s Oeord=$p(OeoriID,"||",1),Ch=$p(OeoriID,"||",2)
	s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	s priorCode=""
	i $d(^OECPR(priority)) d
	.s priorCode=$p(^OECPR(priority),"^",1)
	q:priorCode["OM" 1
	
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="DspBatErr"
	
	;医嘱绑定来源-此字段不为空,表示该医嘱是通过其他医嘱绑定插入的
	;s BindSource=$p($g(^OEORD(Oeord,"I",Ch,"DHC")),"^",41)
	;i BindSource'="" s RollFlag=1
	s RollFlag=1
	s:barcode="" barcode=##class(web.DHCSTMHUI.SRVCOMMON).GetBarcodeByOrd(OeoriID)
	i barcode'="" d
	.s dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
	.s:dhcit'="" barcode=$p(^DHCIT(dhcit),"^",2)
	s Ret=##Class(web.DHCSTMHUI.SRVINTERFACE).InsDspBatch(DspID,RollFlag,barcode)
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",Ret)
	q Ret
DspBatErr
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// Descript：	门诊开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// CreateDate：2013-08-08
/// Table：		OE_OrdItem,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input：		OE_OrdItem的ID
/// Output：	INCLB^数量^进价^售价
/// Return：	0-没有满足条件的批次,1-有满足条件的批次,<0表示错误,对非1的需要回滚整个医嘱
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).InsDspBatchForOut("483||8","","")
ClassMethod InsDspBatchForOut(OeoriID As %String, barcode As %String = "", RollFlag = "") As %String
{
	n (OeoriID,barcode,RollFlag)
	k ^||TMPDHCSTMZTCOUNT
	s TLevel=$TL ;当前事务层级
	s LogTypeInfo="HIS"_"^"_$CLASSNAME()_"^"_"InsDspBatchForOut"
	s Params=OeoriID_";"_barcode_";"_RollFlag
	s Oeord=$p(OeoriID,"||",1),Ch=$p(OeoriID,"||",2)
	s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	s priorCode=""
	i $d(^OECPR(priority)) d
	.s priorCode=$p(^OECPR(priority),"^",1)
	q:priorCode["OM" 1
	
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,LogTypeInfo,Params)
	s $ZT="DspBatForOutErr"

	;医嘱绑定来源-此字段不为空,表示该医嘱是通过其他医嘱绑定插入的
	;s BindSource=$p($g(^OEORD(Oeord,"I",Ch,"DHC")),"^",41)
	;i BindSource'="" s RollFlag=1
	s RollFlag=1
	s:barcode="" barcode=##class(web.DHCSTMHUI.SRVCOMMON).GetBarcodeByOrd(OeoriID) 
	i barcode'="" d
	.s dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
	.s:dhcit'="" barcode=$p(^DHCIT(dhcit),"^",2)
	s Ret=##Class(web.DHCSTMHUI.SRVINTERFACE).InsDspBatchForOut(OeoriID,barcode,RollFlag)
	d ##class(web.DHCSTMHUI.InterfaceLog).Log(.LogRowId,"","",Ret)
	q Ret
DspBatForOutErr
	q $$InterfaceError^DHCSTMHUIERROR(.LogRowId,TLevel)
}

/// Description:独立计费调用(可批量传递医嘱rowid) [计费组调用]
/// 			计费调用的Disp方法,希望独立出来(可能走集成平台)
/// CreatDate:	2021-08-11
/// Input:		Arcim, 检查日期(为空则默认为当天)
/// OutPut:		1/0 (1-可以调用物资Disp方法; 0-不需要调用物资Disp方法)
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).AllowDispFlag("9317||1")
ClassMethod AllowDispFlag(Arcim, Date = "")
{
	n (Arcim,Date)
	s:Date="" Date=+$h
	q:Arcim="" 0
	s Arc=$p(Arcim,"||",1),Sub=$p(Arcim,"||",2)
	q:(Arc="")||(Sub="") 0
	
	s Flag=0
	s Inci=$o(^INCI(0,"ARCIM_DR",Arc,0))
	i Inci'="" d
	.s Incsc=$p($g(^INCI(Inci,2)),"^",2)
	.q:Incsc=""
	.s IncscStkType=$p($g(^INC("SC",Incsc)),"^",3)
	.q:IncscStkType="G"		;过滤药品
	.s Flag=1
	e  d
	.s Tariff=""
	.f  s Tariff=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff)) q:(Tariff="")||(Flag=1)  d
	..s StartDate=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff,""))
	..q:(StartDate="")||(StartDate>Date)
	..s LinkId=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff,StartDate,""))
	..q:LinkId=""
	..s EndDate=$p(^DHCOLT(LinkId),"^",5)
	..q:(EndDate'="")&&(EndDate<+$h)
	..q:'$d(^DHCILT(0,"Tariff",Tariff))		;未做"计费项物资管理"
	..s Flag=1
	q Flag
}

/// Description:独立计费调用(可批量传递医嘱rowid) [计费组调用]
/// 			计费调用的Disp方法,希望独立出来(可能走集成平台)
/// CreatDate:	2020-08-11
/// Table:		
/// Input:		Params :myOEORIStr_"@"_prtRowId, 其中myOEORIStr为医嘱rowid的串(^隔开)
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).BILLDisp(***)
ClassMethod BILLDisp(Params)
{
	n (Params)
	q:Params="" ""

	s StkType=..sssCode()
	s OeoriStr=$p(Params,"@",1)		;oeori^oeori^...
	s PrtRowId=$p(Params,"@",2)		;结算发票的RowId
	q:OeoriStr="" ""
	s Len=$l(OeoriStr,"^")
	f i=1:1:Len d
	.s Oeori=$p(OeoriStr,"^",i)
	.s Ord=$p(Oeori,"||",1),Ch=$p(Oeori,"||",2)
	.q:(Oeori="")||(Ord="")||(Ch="")
	.s Arcim=$p(^OEORD(Ord,"I",Ch,1),"^",2)
	.s Arc=$p(Arcim,"||",1)
	.q:Arc=""
	.s Inci=$o(^INCI(0,"ARCIM_DR",Arc,0))
	.s IncscStkType=""
	.i Inci'="" d
	..s Incsc=$p($g(^INCI(Inci,2)),"^",2)
	..q:Incsc=""
	..s IncscStkType=$p($g(^INC("SC",Incsc)),"^",3)
	.q:(Inci'="")&&(IncscStkType'="M")	;过滤药品
	.
	.s Ret=##class(web.DHCSTMHUI.PCHCOLLSM).Disp(Oeori,"","BILL")
	q 0
}

/// Description：获取是否走住院发放参数[计费组调用，涉及计费点]
/// Creator：lxt
/// CreateDate：2021-07-01
/// input：LocId
/// output：Y/N
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetInMatDispFlag(163)
ClassMethod GetInMatDispFlag(LocId As %String = "") As %String
{
	n (LocId)
	s Param="^"_LocId_"^^"
	s:LocId="" LocId="loc"
	i '$d(^||TMPDHCSTM("InMatDispFlag",LocId,$j)) d
	.s Flag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTINMATDISPM","InMatDisp",Param)
	.s ^||TMPDHCSTM("InMatDispFlag",LocId,$j)=Flag
	e  d
	.s Flag=$p(^||TMPDHCSTM("InMatDispFlag",LocId,$j),"^",1)
	q Flag
}

/// Descript:	判断此就诊记录开的医嘱中是否包含材料
/// Creator:	zx
/// CreateDate:	2022-08-9
/// Input:		paamd
/// Output:     Y/N
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).CheckMatByPaAdm(2)
ClassMethod CheckMatByPaAdm(PaAdm) As %Library.String
{
	n (PaAdm)
	s Flag="N"
	q:PaAdm="" Flag
	
	s Ord=$o(^OEORD(0,"Adm",PaAdm,0))
	q:Ord="" Flag
	s Itm=0
	f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:(Itm="")||(Flag="Y")  d
	.s ArcId=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	.q:ArcId=""
	.s Inci=$o(^INCI(0,"ARCIM_DR",+ArcId,0))
	.q:Inci=""
	.s StkcatId=$p(^INCI(Inci,2),"^",2)
	.q:StkcatId=""
	.s Stktype=$p(^INC("SC",StkcatId),"^",3)
	.q:Stktype'="M"
	.s Flag="Y"
	
	q Flag
}

/// Descript:	根据科室ID判断科室是否存在材料库存低于库存下限
/// Creator:	wxj
/// CreateDate:	2022-10-11
/// Input:		科室ID
/// Output:     1：存在 0 不存在
/// w ##class(web.DHCSTMHUI.DHCSTMSERVICE).CheckLocMatMinQty(2)
ClassMethod CheckLocMatMinQty(LocId) As %Library.String
{
	n (LocId)
	q:LocId="" 0
	s Stktype=..sssCode()
	s Inci=0,Flag=0
	f  s Inci = $O(^INCI("IL_LOC",LocId,Inci)) q:(+Inci'>0)  d
	.q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))
	.s NotUseFlag=$p(^INCI(Inci,2),"^",9)
	.q:NotUseFlag="Y"
	.s IncscId=$p(^INCI(Inci,2),"^",2)
	.q:IncscId=""
	.s Arcim=$p(^INCI(Inci,1),"^",3)
	.q:+Arcim'>0
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s BUom = $P(^INCI(Inci, 1), "^",10)
	.s PUom = $P(^INCI(Inci, 3), "^",6)
	.s IncStktype=$p(^INC("SC",IncscId),"^",3)
	.q:IncStktype'=Stktype
	.s ConFac = ##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUom, BUom)
	.s Sub = ""
	.f  s Sub = $o(^INCI("IL_LOC",LocId,Inci, Sub)) q:(Sub = "")||(Flag=1)  d
	..s ILData = $g(^INCI(Inci, "IL", Sub))
	..s MinQty = $p(ILData, "^", 4)
	..q:+MinQty'>0
	..s StockQty = ##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci, LocId, +$h)
	..i (+MinQty>0)&&(StockQty<=MinQty) d
	...s Flag=1
	q Flag
}

/// Descript： 	根据医嘱项和科室返回一条高值材料可用条码
/// CreateDate：2022-11-02
/// Input：		医嘱项ID,科室ID
/// Return：	HVBarcoded
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCSTMSERVICE","GetBarcode","2||1","163")
Query GetBarcode(Arcim As %String, RecLocId As %String) As Query(ROWSPEC = "HVBarcode") [ SqlProc ]
{
}

ClassMethod GetBarcodeExecute(ByRef qHandle As %Binary, Arcim As %String, RecLocId As %String) As %Status
{
	n (qHandle,Arcim,RecLocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:Arcim="" ""
	q:RecLocId="" ""
	s Inci=##Class(web.DHCSTMHUI.SRVCOMMON).GetInciID(Arcim)
	q:Inci="" ""
	s IL=$o(^INCI("IL_LOC",RecLocId,Inci,""))
	q:IL="" ""
	s PIncil=Inci_"||"_IL
	
	s Dhcit=0,HVBarcode=""
	f  s Dhcit=$o(^DHCIT(0,"StatusInci","Enable",Inci,Dhcit)) q:(Dhcit="")||(HVBarcode'="")  d
	.s Inclb=$p(^DHCIT(Dhcit),"^",12)
	.s Incil=$p(Inclb,"||",1,2)
	.q:Incil'=PIncil
	.s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	.s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
	.q:(ExpDate'="")&&(ExpDate<$h)
	.s HVBarcode=$p(^DHCIT(Dhcit),"^",2)
	d OutPutRow
	Quit $$$OK
	
OutPutRow
	s Data=$lb(HVBarcode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
