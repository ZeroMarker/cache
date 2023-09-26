/// Add By DJ 2014-12-17
/// 青医附院望海Herp接口
Class web.DHCEQ.Interface.Outer.DHCEQHerpToWH Extends %RegisteredObject
{

/// Add By DJ 2014-12-17
/// 描述:青岛大学第一附属医院入库主表
/// 入参:vStartDate:开始日期(YYYY-MM-DD) vEndDate:结束日期(YYYY-MM-DD)
/// 返回值:入库单号^入库年月^库房DR^供应商DR^单据日期^制单人
ClassMethod QYWHInStock(vStartDate As %String = "", vEndDate As %String = "")
{
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQInStock",$J)
	i vStartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=$ZDH(vStartDate,3)-1
	i vEndDate=""  d
	.s EndDate=+$H
	e  d
	.s EndDate=$ZDH(vEndDate,3)
	
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s ISRowID=0		//入库单rowID
 	..f  s ISRowID=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR,ISRowID)) q:ISRowID=""  d
 	...s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
 	...q:InStockNo=""
 	...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
 	...q:vendorid=""
 	...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
 	...q:ISStatus'=2
 	...s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
 	...s YearMonth=$E($ZD(StockDate,8),1,6)
 	...s StoreLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",2)
 	...s StoreLoc=""
 	...i StoreLocDR'="" s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
 	...s InDate=$ZD(StockDate,8)	//单据审核日期
 	...s TActUser=$p($g(^DHCEQInStock(ISRowID)),"^",6)	//单据审核人
 	...i TActUser'="" s TActUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TActUser)
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)
 	...s ^TEMPDHCEQ("QYWHDHCEQInStock",$J,Num)=InStockNo_"^"_YearMonth_"^"_StoreLocDR_"^"_vendorid_"^"_InDate_"^"_TActUser_"^RK"
 	...s Num=Num+1
}

/// Add By DJ 2014-12-17
/// 描述:青岛大学第一附属医院入库明细表
/// 入参:vStartDate:开始日期(YYYY-MM-DD) vEndDate:结束日期(YYYY-MM-DD) InStockFlag:入库标识 1:只取入库
/// 返回值:入库单号^资产分类^资产编号^资金来源^金额
ClassMethod QYWHInStockList(vStartDate As %String = "", vEndDate As %String = "", InStockFlag As %String = "")
{
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQInStockList",$J)
	i vStartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=$ZDH(vStartDate,3)-1
	i vEndDate=""  d
	.s EndDate=+$H
	e  d
	.s EndDate=$ZDH(vEndDate,3)
	
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s ISRowID=0		//入库单rowID
 	..f  s ISRowID=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR,ISRowID)) q:ISRowID=""  d
 	...s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
 	...q:InStockNo=""
 	...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
 	...q:vendorid=""
 	...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
 	...q:ISStatus'=2
 	...s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
 	...s StoreLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",2)
 	...s EquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
 	...s ISLRowID=0
 	...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
 	....s ItemDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",16)
 	....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
 	....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
 	....s TOriginalFee=$fn($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
 	....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
 	....s TInvoiceNo=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ISLRowID),"^",1)
 	....i $D(^DHCEQFunds("0","Source","3",ISLRowID))  d		//入库记录资金来源
 	.....s FRowID=0
 	.....f  s FRowID=$o(^DHCEQFunds("0","Source","3",ISLRowID,FRowID))  q:FRowID=""  d
 	......s TFundsTypeDR=$p($g(^DHCEQFunds(FRowID)),"^",2)
 	......s TFundsFee=$fn($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
 	......s ^TEMPDHCEQ("QYWHDHCEQInStockList",$J,Num)=InStockNo_"^"_EquipTypeDR_"^"_ItemDR_"^"_TFundsTypeDR_"^"_TFundsFee_"^"_TInvoiceNo
 	......s Num=Num+1
 	....e  d
 	.....s ISLSourceType=$p($g(^DHCEQInStockList(ISLRowID)),"^",18)
 	.....s ISLSourceID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
 	.....i ((InStockFlag'="1")&&(ISLSourceType=2))  d		//入库资金来源不存在时取验收资金来源
 	......s FTRowID=0
 	......f  s FTRowID=$o(^DHCEQFunds("0","CheckListType",ISLSourceID,FTRowID))  q:FTRowID=""  d
 	.......s FRowID=0
 	.......f  s FRowID=$o(^DHCEQFunds("0","CheckListType",ISLSourceID,FTRowID,FRowID))  q:FRowID=""  d
 	........s TFundsFee=$fn($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
 	........s ^TEMPDHCEQ("QYWHDHCEQInStockList",$J,Num)=InStockNo_"^"_EquipTypeDR_"^"_ItemDR_"^"_FTRowID_"^"_TFundsFee_"^"_TInvoiceNo
 	........s Num=Num+1
 	.....e  d
 	......s ^TEMPDHCEQ("QYWHDHCEQInStockList",$J,Num)=InStockNo_"^"_EquipTypeDR_"^"_ItemDR_"^"_0_"^"_TAmount_"^"_TInvoiceNo
 	......s Num=Num+1
}

/// Add By DJ 2014-12-17
/// 描述:青岛大学第一附属医院资产折旧表
/// 入参:vMonth:折旧年月(YYYY-MM)
/// 返回值:折旧年月^资产类别^资金来源^使用科室^折旧金额^资产编码
ClassMethod QYWHDerpeList(vMonth As %String = "")
{
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
 	s CurYear=$p(vMonth,"-",1)
 	s CurMonth=+$p(vMonth,"-",2)
 	i CurMonth=1
 	{
	 	s PreYear=CurYear-1
	 	s PreMonth=12
 	}
 	else
 	{
	 	s PreYear=CurYear
	 	s PreMonth=CurMonth-1
 	}
 	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PreYear_"-"_PreMonth)
	i ((vMonth="")||(SelfFundsFlag="")||(SnapID="")) q ""
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQDepreList",$J)
	s MDRowID=0
	f  s MDRowID=$o(^DHCEQMonthDepre(0,"Month",vMonth,MDRowID))  q:MDRowID=""  d
	.s EQRowID=$p($g(^DHCEQMonthDepre(MDRowID)),"^",1)
	.s EquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",63)
	.s UseLocDR=$p($g(^DHCEQMonthDepre(MDRowID)),"^",33)
	.s TDepreFee=$p($g(^DHCEQMonthDepre(MDRowID)),"^",14)
	.s ItemDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",7)
	.s CADRowID=0
	.s CADFlag=0
	.f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADRowID)) q:CADRowID=""  d
	..s CADFlag=CADFlag+1
	..s CurLocDR=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	..s DepreFee=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	..s TFundsType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	..i TFundsType="" s TFundsType=SelfFundsFlag
	..s ^DHCEQTemp("QYWHDHCEQDepreList",$J,Num)=vMonth_"^"_EquipTypeDR_"^"_TFundsType_"^"_CurLocDR_"^"_DepreFee_"^"_ItemDR
	.i CADFlag=0  d
	..s ^DHCEQTemp("QYWHDHCEQDepreList",$J,Num)=vMonth_"^"_EquipTypeDR_"^"_SelfFundsFlag_"^"_UseLocDR_"^"_TDepreFee_"^"_ItemDR
	.s Num=Num+1
}

/// Add By DJ 2014-12-17
/// 描述:青岛大学第一附属医院资产维修表
/// 入参:vStartDate:开始日期(YYYY-MM-DD) vEndDate:结束日期(YYYY-MM-DD)
/// 返回值:维修年月^资产类别^支付方式^使用科室^材料费^维修费
ClassMethod QYWHGetMaint(vStartDate As %String = "", vEndDate As %String = "")
{
 	s SDate=0
 	s EDate=+$H
 	i vStartDate'="" s SDate=$ZDH(vStartDate,3)
 	i vEndDate'="" s EDate=$ZDH(vEndDate,3)
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQMaint",$J)
	
	s MTType=0
	f  s MTType=$o(^DHCEQMaint(0,"Equip",MTType))  q:MTType=""  d
	.q:MTType'=3
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQMaint(0,"Equip",MTType,EQRowID))  q:EQRowID=""  d
	..s MTRowID=0
	..f  s MTRowID=$o(^DHCEQMaint(0,"Equip",MTType,EQRowID,MTRowID))  q:MTRowID=""  d
	...s TRowID=MTRowID
	...s MTStatus=$p($g(^DHCEQMaint(TRowID)),"^",13)
	...q:MTStatus'=2
	...s MTInvalidFlag=$p($g(^DHCEQMaint(TRowID)),"^",39)
	...q:MTInvalidFlag="Y"
	...s MTAuditDate=$p($g(^DHCEQMaint(TRowID)),"^",19)
	...q:(SDate'="")&&(MTAuditDate<SDate)
	...q:(EDate'="")&&(MTAuditDate>EDate)
	...s MonthStr=$E($ZD(MTAuditDate,3),1,7)
	...s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	...i SnapID'=""  d
	....s TEquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",63)
	...e  d
	....s TEquipTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",63)
	...s TUseLocDR=$p($g(^DHCEQMaint(TRowID)),"^",12)
	...s Amount=$p($g(^DHCEQMaint(TRowID)),"^",9)
	...s ^TEMPDHCEQ("QYWHDHCEQMaint",$J,Num)=MonthStr_"^"_TEquipTypeDR_"^现金^"_TUseLocDR_"^^"_Amount
	...s Num=Num+1
}

ClassMethod QYWHReturn(vStartDate As %String = "", vEndDate As %String = "") As %String
{
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQReturn",$J)
	i vStartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=$ZDH(vStartDate,3)-1
	i vEndDate=""  d
	.s EndDate=+$H
	e  d
	.s EndDate=$ZDH(vEndDate,3)
	
 	s REquipType=0
	f  s REquipType=$o(^DHCEQReturn(0,"TypeDate",REquipType))  q:REquipType=""  d
	.s OutType=0
	.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",REquipType,OutType)) q:OutType=""  d
	..s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",1)
	..q:OutTypeCode'="TH"
	..s StockDate=StartDate
	..f  s StockDate=$o(^DHCEQReturn(0,"TypeDate",REquipType,OutType,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	...s RRowID=0		//退货单rowID
 	...f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",REquipType,OutType,StockDate,RRowID)) q:RRowID=""  d
 	....s RStatus=$p($g(^DHCEQReturn(RRowID)),"^",13)
 	....q:RStatus'=2
 	....s ReturnNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
 	....s vendorid=$p($g(^DHCEQReturn(RRowID)),"^",3)
 	....q:vendorid=""
 	....s YearMonth=$E($ZD(StockDate,8),1,6)
 	....s StoreLocDR=$p($g(^DHCEQReturn(RRowID)),"^",2)
 	....s StoreLoc=""
 	....i StoreLocDR'="" s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
 	....s InDate=$ZD(StockDate,8)	//单据审核日期
 	....s TActUser=$p($g(^DHCEQReturn(RRowID)),"^",7)	//单据审核人
 	....i TActUser'="" s TActUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TActUser)
 	....s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)
 	....s ^TEMPDHCEQ("QYWHDHCEQReturn",$J,Num)=ReturnNo_"^"_YearMonth_"^"_StoreLocDR_"^"_vendorid_"^"_InDate_"^"_TActUser_"^TH"
 	....s Num=Num+1
 	
 	q Num
}

ClassMethod QYWHReturnList(vStartDate As %String = "", vEndDate As %String = "")
{
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQReturnList",$J)
	i vStartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=$ZDH(vStartDate,3)-1
	i vEndDate=""  d
	.s EndDate=+$H
	e  d
	.s EndDate=$ZDH(vEndDate,3)
	
 	s REquipType=0
	f  s REquipType=$o(^DHCEQReturn(0,"TypeDate",REquipType))  q:REquipType=""  d
	.s OutType=0
	.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",REquipType,OutType)) q:OutType=""  d
	..s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",1)
	..q:OutTypeCode'="TH"
	..s StockDate=StartDate
	..f  s StockDate=$o(^DHCEQReturn(0,"TypeDate",REquipType,OutType,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	...s RRowID=0		//退货单rowID
 	...f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",REquipType,OutType,StockDate,RRowID)) q:RRowID=""  d
 	....s RStatus=$p($g(^DHCEQReturn(RRowID)),"^",13)
 	....q:RStatus'=2
 	....s ReturnNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
 	....s vendorid=$p($g(^DHCEQReturn(RRowID)),"^",3)
 	....q:vendorid=""
 	....s YearMonth=$E($ZD(StockDate,8),1,6)
 	....s StoreLocDR=$p($g(^DHCEQReturn(RRowID)),"^",2)
	....s RLRowID=0
	....f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
 	.....s TQuantity=$p($g(^DHCEQReturnList(RLRowID)),"^",5)
 	.....s TOriginalFee=$fn($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
 	.....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
 	.....s TInvoiceNo=$p($g(^DHCEQReturnList(RLRowID)),"^",7)
	.....s TInStockListDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
	.....s TEquipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
	.....i TEquipDR'=""  d
	......s ItemDR=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
	.....e  d
	......s ItemDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",16)
 	.....i $D(^DHCEQFunds("0","Source","5",RLRowID))  d		//退货记录资金来源
 	......s FRowID=0
 	......f  s FRowID=$o(^DHCEQFunds("0","Source","5",RLRowID,FRowID))  q:FRowID=""  d
 	.......s TFundsTypeDR=$p($g(^DHCEQFunds(FRowID)),"^",2)
 	.......s TFundsFee=$fn($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
 	.......s ^TEMPDHCEQ("QYWHDHCEQReturnList",$J,Num)=ReturnNo_"^"_REquipType_"^"_ItemDR_"^"_TFundsTypeDR_"^"_TFundsFee_"^"_TInvoiceNo
 	.......s Num=Num+1
 	.....e  d
 	......s ^TEMPDHCEQ("QYWHDHCEQReturnList",$J,Num)=ReturnNo_"^"_REquipType_"^"_ItemDR_"^"_0_"^"_TAmount_"^"_TInvoiceNo
 	......s Num=Num+1
 	
 	q Num
}

/**************************************************/
ClassMethod QYWHDisuse(vStartDate As %String = "", vEndDate As %String = "") As %String
{
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQDisuse",$J)
	i vStartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=$ZDH(vStartDate,3)-1
	i vEndDate=""  d
	.s EndDate=+$H
	e  d
	.s EndDate=$ZDH(vEndDate,3)
	
 	s DEquipType=0
	f  s DEquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType))  q:DEquipType=""  d
	.s StockDate=StartDate
	.f  s StockDate=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	..s DRowID=0		//报废单rowID
 	..f  s DRowID=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType,StockDate,DRowID)) q:DRowID=""  d
 	...s DStatus=$p($g(^DHCEQDisuseRequest(DRowID)),"^",10)
 	...q:DStatus'=2
 	...s DisuseNo=$p($g(^DHCEQDisuseRequest(DRowID)),"^",33)
 	...s DEquipDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",1)
 	...s DInStockListDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",45)
 	...s vendorid=""
 	...i DEquipDR'=""  d
 	....s vendorid=$p($g(^DHCEQEquip(DEquipDR)),"^",25)
 	...e  d
 	....s DInStock=""
 	....i DInStockListDR'="" s DInStock=$p($g(^DHCEQInStockList(DInStockListDR)),"^",1)
 	....i DInStock'="" s vendorid=$p($g(^DHCEQInStock(DInStock)),"^",17)
 	...;q:vendorid=""
 	...s YearMonth=$E($ZD(StockDate,8),1,6)
 	...s StoreLocDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",34)
 	...s StoreLoc=""
 	...i StoreLocDR'="" s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
 	...s InDate=$ZD(StockDate,8)	//单据审核日期
 	...s TActUser=$p($g(^DHCEQDisuseRequest(DRowID)),"^",20)	//单据审核人
 	...i TActUser'="" s TActUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TActUser)
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)
 	...s ^TEMPDHCEQ("QYWHDHCEQDisuse",$J,Num)=DisuseNo_"^"_YearMonth_"^"_StoreLocDR_"^"_vendorid_"^"_InDate_"^"_TActUser_"^BF"
 	...;w ^TEMPDHCEQ("QYWHDHCEQDisuse",$J,Num),!
 	...s Num=Num+1
 	
 	q Num
}

ClassMethod QYWHDisuseList(vStartDate As %String = "", vEndDate As %String = "")
{
	s Num=1
	k ^TEMPDHCEQ("QYWHDHCEQDisuseList",$J)
	i vStartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=$ZDH(vStartDate,3)-1
	i vEndDate=""  d
	.s EndDate=+$H
	e  d
	.s EndDate=$ZDH(vEndDate,3)
	
 	s DEquipType=0
	f  s DEquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType))  q:DEquipType=""  d
	.s StockDate=StartDate
	.f  s StockDate=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	..s DRowID=0		//报废单rowID
 	..f  s DRowID=$o(^DHCEQDisuseRequest(0,"TypeDate",DEquipType,StockDate,DRowID)) q:DRowID=""  d
 	...s DStatus=$p($g(^DHCEQDisuseRequest(DRowID)),"^",10)
 	...q:DStatus'=2
 	...s DisuseNo=$p($g(^DHCEQDisuseRequest(DRowID)),"^",33)
 	...s DEquipDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",1)
 	...s DInStockListDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",45)
 	...s vendorid=""
 	...i DEquipDR'=""  d
 	....s vendorid=$p($g(^DHCEQEquip(DEquipDR)),"^",25)
 	...e  d
 	....i DInStockListDR'=""  d
 	.....s DInStock=$p($g(^DHCEQInStockList(DInStockListDR)),"^",1)
 	.....i DInStock'="" s vendorid=$p($g(^DHCEQInStock(DInStock)),"^",17)
 	...;q:vendorid=""
 	...s YearMonth=$E($ZD(StockDate,8),1,6)
 	...s StoreLocDR=$p($g(^DHCEQDisuseRequest(DRowID)),"^",34)
	...s DRLRowID=0
	...f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRowID,DRLRowID))  q:DRLRowID=""  d
	....s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	....s ItemDR=$p($g(^DHCEQEquip(DRLEquipDR)),"^",7)
	....s TAmount=$fn($p($g(^DHCEQEquip(DRLEquipDR)),"^",27),"",2)
	....s TInvoiceNo=""
	....i $D(^DHCEQFunds("0","Source","6",DRLRowID))  d		//报废记录资金来源
 	.....s FRowID=0
 	.....f  s FRowID=$o(^DHCEQFunds("0","Source","6",DRLRowID,FRowID))  q:FRowID=""  d
 	......s TFundsTypeDR=$p($g(^DHCEQFunds(FRowID)),"^",2)
 	......s TFundsFee=$fn($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)
 	......s ^TEMPDHCEQ("QYWHDHCEQDisuseList",$J,Num)=DisuseNo_"^"_DEquipType_"^"_ItemDR_"^"_TFundsTypeDR_"^"_TFundsFee_"^"_TInvoiceNo
 	......s Num=Num+1
 	....e  d
 	.....s ^TEMPDHCEQ("QYWHDHCEQDisuseList",$J,Num)=DisuseNo_"^"_DEquipType_"^"_ItemDR_"^"_0_"^"_TAmount_"^"_TInvoiceNo
 	.....s Num=Num+1
 	
 	q Num
}

}
