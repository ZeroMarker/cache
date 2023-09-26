Class web.DHCEQForCA Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 折旧费及维修费读取函数(开始日期，终止日期, 资金来源类型）？
/// 类方法格式：ClassMethod getDepreciation(start,end) As %String
/// 数据列：日期、科室代码、科室名称、折旧金额。
/// 日期格式（3）,
/// Global：^TMP("dhc","ca","Depreciation",$j,row)=日期^科室代码^科室名称^类组代码^类组名称^折旧金额^科室DR^类组DR^资金来源DR^资金来源代码^资金来源名称
/// Global：^TMP("dhc","ca","MaintFee",$j,row)=日期^科室代码^科室名称^类组代码^类组名称^维修费金额^科室DR^类组DR^资金来源DR^资金来源代码^资金来源名称
/// d ##Class(web.DHCEQForCA).getDepreciation(+$H-1000,+$H)
ClassMethod getDepreciation(start, end, fundstypecode, DepreTypeID As %Library.String = "1") As %String
{
	n (start,end,fundstypecode)
	;new rowid,occDate,row
	;new equipDR,locID,locCode,locDesc,equiptypeID,equiptypeCode,equiptypeDesc,fee
	k ^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j)
	//检测是否有设置自有资金参数 Add By DJ 2012-02-20 DJ0105
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	i SelfFundsFlag="" q "未设置自有资金参数"
	s occDate=start-1
	s node="Depreciation"
	f  s occDate=$o(^DHCEQMonthDepre(0,"AuditDate","Y",occDate)) quit:((occDate="")||(occDate>end))  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMonthDepre(0,"AuditDate","Y",occDate,rowid)) quit:rowid=""  d
	..s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	..q:MDStatus="3"
	..s equipDR=$p($g(^DHCEQMonthDepre(rowid)),"^",1)
	..s locID=$p($g(^DHCEQMonthDepre(rowid)),"^",33)
	..s DepreTypeDR=$p($g(^DHCEQMonthDepre(rowid)),"^",36)
	..q:DepreTypeDR'=DepreTypeID	//只取对应折旧类型的折旧数据 ZY0108
	..s fee=$p($g(^DHCEQMonthDepre(rowid)),"^",14)
	..s CADCount=0
	..s CADRowID=0	//Add By DJ 2012-02-20 DJ0105
	..f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",rowid,CADRowID)) q:CADRowID=""  d
	...s CADCount=1
	...s CADType=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",1)
	...q:CADType'=1
	...s locID=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	...s fundstypeID=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	...i fundstypeID="" s fundstypeID=SelfFundsFlag
	...s fee=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	...d AddFeeToTemp
	..i CADCount=0  d
	...s fundstypeID=SelfFundsFlag
	...d AddFeeToTemp
	
	s occDate=start-1
	s node="MaintFee"
	///31:维修 32:保养 33:检查
	f  s occDate=$o(^DHCEQLifeInfo(0,"SourceType","31",occDate)) quit:((occDate="")||(occDate>end))  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQLifeInfo(0,"SourceType","31",occDate,rowid)) quit:rowid=""  d
	..s equipDR=$p($g(^DHCEQLifeInfo(rowid)),"^",1)
	..s locID=$p($g(^DHCEQLifeInfo(rowid)),"^",8)
	..s fee=$p($g(^DHCEQLifeInfo(rowid)),"^",17)
	..s fundstypeID=SelfFundsFlag //Add By DJ 2012-02-20 DJ0105
	..d AddFeeToTemp
	
	s node="Depreciation"
	d AddFeeToCATemp
	s node="MaintFee"
	d AddFeeToCATemp
	
	k ^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j)
	q 1
AddFeeToTemp
	q:locID=""
	q:fee'>0
	s equiptypeID=$p($g(^DHCEQEquip(equipDR)),"^",63)
	q:equiptypeID=""
	s StatCatID=$p($g(^DHCEQEquip(equipDR)),"^",75)
	q:StatCatID=""
	;w node_locID_"&"_fee_"&"_equiptypeID_"&"_occDate,!
	i $d(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID,equiptypeID,StatCatID,fundstypeID))
	{
		s fee=+fee+$g(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID,equiptypeID,StatCatID,fundstypeID))
	}
	s ^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID,equiptypeID,StatCatID,fundstypeID)=fee
	quit
	
AddFeeToCATemp
	k ^TMP("dhc","ca",node,$j)
	s row=0
	s occDate=0
	f  s occDate=$o(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate)) quit:occDate=""  d
	.s locID=0
	.f  s locID=$o(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID)) quit:locID=""  d
	..s equiptypeID=0
	..f  s equiptypeID=$o(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID,equiptypeID)) quit:equiptypeID=""  d
	...s StatCatID=0
	...f  s StatCatID=$o(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID,equiptypeID,StatCatID)) quit:StatCatID=""  d
	....s fundstypeID=0
	....f  s fundstypeID=$o(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID,equiptypeID,StatCatID,fundstypeID)) quit:fundstypeID=""  d
	.....s fundscode=$p($g(^DHCEQCCode("DHCEQCFundsType",fundstypeID)),"^",1) //Add By DJ 2012-02-20 DJ0105 begin
	.....q:(fundstypecode'="")&&(fundstypecode'=fundscode)
	.....s fundstype=$p($g(^DHCEQCCode("DHCEQCFundsType",fundstypeID)),"^",2) //Add By DJ 2012-02-20 DJ0105 end
	.....;s locCode=$p($g(^CTLOC(locID)),"^",1)   //modify by jyp 2019-10-18 CTLOC调整
	.....s locCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",locID)  //modify by jyp 2019-10-18 CTLOC调整
	.....;s locDesc=$p($g(^CTLOC(locID)),"^",2)  //modify by jyp 2019-10-18 CTLOC调整
	.....s locDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",locID)  //modify by jyp 2019-10-18 CTLOC调整
	.....s equiptypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptypeID)),"^",1)
	.....s equiptypeDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptypeID)),"^",2)
	.....s StatCode=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",1)
	.....s StatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatID)),"^",2)
	.....s fee=+$g(^DHCEQTemp("web.DHCEQForCA","getDepreciation",$j,node,occDate,locID,equiptypeID,StatCatID,fundstypeID))
	.....s row=row+1
	.....s ^TMP("dhc","ca",node,$j,row)=$ZD(occDate,3)_"^"_locCode_"^"_locDesc_"^"_equiptypeCode_"^"_equiptypeDesc_"^"_fee_"^"_locID_"^"_equiptypeID_"^"_fundstypeID_"^"_fundscode_"^"_fundstype_"^"_StatCode_"^"_StatDesc
	quit
}

/// for 宁医
/// 获取设备折旧数据
/// 输入：start,end 开始日期，结束日期 格式如"2012-01-31"
/// 输出：完成 返回数据条数
/// 	数据存储：							            = 1折旧日期 2固定资产代码 3类型 4使用部门科室 5折旧金额 6购置日期 7财务折旧年限 8财务折旧金额 9核算折旧年限
/// 		^TMPDHCEQ("OutPutDepreDetail","Detail",$j,num)= occDate_"^"_equipDR_"^"_typecode_"^"_locID_"^"_fee_"^"_buyDate_"^"_years_"^"_fee_"^"_years
/// w ##Class(web.DHCEQForCA).OutPutDepreDetail("2011-11-1","2011-11-30")
ClassMethod OutPutDepreDetail(start, end) As %String
{
	n (start,end)
	
	k ^TMPDHCEQ("OutPutDepreDetail","tmp",$j)
	k ^TMPDHCEQ("OutPutDepreDetail","Detail",$j)
	s start=##Class(web.DHCEQCommon).TransValueFromPage(start,"date") ;修改前为：$zdh(start,3)
 	s end=##Class(web.DHCEQCommon).TransValueFromPage(start,"date") ;修改前为：$zdh(end,3)
	
	s occDate=start-1
	f  s occDate=$o(^DHCEQMonthDepre(0,"AuditDate","Y",occDate)) quit:((occDate="")||(occDate>end))  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMonthDepre(0,"AuditDate","Y",occDate,rowid)) quit:rowid=""  d
	..s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	..q:MDStatus="3"
	..s equipDR=$p($g(^DHCEQMonthDepre(rowid)),"^",1)
	..s locID=$p($g(^DHCEQMonthDepre(rowid)),"^",33)
	..s fee=$p($g(^DHCEQMonthDepre(rowid)),"^",14)
	..
	..s equiptypeID=$p($g(^DHCEQEquip(equipDR)),"^",63)
	..if (equiptypeID=4)||(equiptypeID=5)  d
	...s typecode=2
	..else  if (equiptypeID=8)  d
	...s typecode=3
	..e  d
	...s typecode=1
	..s equiptypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptypeID)),"^",1)
	..s years=$p($g(^DHCEQEquip(equipDR)),"^",31)
	..s buyDate=$p($g(^DHCEQEquip(equipDR)),"^",45)
	..s buyDate=##Class(web.DHCEQCommon).TransValueToPage(buyDate,"date") ;$zd(buyDate,3)
	..s equipNo=$p($g(^DHCEQEquip(equipDR)),"^",71)
	..s fee=fee+$p($g(^TMPDHCEQ("OutPutDepreDetail","tmp",$j,locID,equipDR)),"^",5)
	..s ^TMPDHCEQ("OutPutDepreDetail","tmp",$j,locID,equipDR)=##Class(web.DHCEQCommon).TransValueToPage(occDate,"date")_"^"_equipDR_"^"_typecode_"^"_locID_"^"_fee_"^"_buyDate_"^"_years_"^"_fee_"^"_years ;$zd(occDate,3)
	 
	s num=0
	s locID=0
	f  s locID=$o(^TMPDHCEQ("OutPutDepreDetail","tmp",$j,locID)) quit:(locID="")  d
	.s equipDR=0
	.f  s equipDR=$o(^TMPDHCEQ("OutPutDepreDetail","tmp",$j,locID,equipDR)) quit:(equipDR="")  d
	..s num=num+1
	..s ^TMPDHCEQ("OutPutDepreDetail","Detail",$j,num)=$g(^TMPDHCEQ("OutPutDepreDetail","tmp",$j,locID,equipDR))
	
	k ^TMPDHCEQ("OutPutDepreDetail","tmp",$j)
	
	q num
}

/// for 宁医
/// 获取设备字典
/// 输出：完成 返回数据条数
/// 	数据存储：							  设备ID  2设备编号 3设备名称
/// 		^TMPDHCEQ("OutPutEquip",$j,num)= RowID_"^"_No_"^"_Name	
/// w ##Class(web.DHCEQForCA).OutPutEquip()
ClassMethod OutPutEquip() As %String
{
	k ^TMPDHCEQ("OutPutEquip",$j)
	s num=0
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(RowID))  quit:RowID=""  d
	.///过滤出库状态、未入库状态、无效标志、报废设备
	.s StockStatus=$p(^DHCEQEquip(RowID),"^",60)
	.q:StockStatus="3"
	.q:StockStatus="0"
	.s InvalidFlag=$p(^DHCEQEquip(RowID),"^",59)
	.q:InvalidFlag="Y"
	.;报废状态的过滤
	.q:(+$p(^DHCEQEquip(RowID),"^",38))>2
	.s Name = $p($g(^DHCEQEquip(RowID)),"^",1)
	.s No = $p($g(^DHCEQEquip(RowID)),"^",71)
	.s num=num+1
	.s ^TMPDHCEQ("OutPutEquip",$j,num)=RowID_"^"_No_"^"_Name	
	q num
}

/// ADD By DJ 2014-02-18   需求79212
/// 某一时间段内供应商应付款统计
/// TYear_"^"_TMonth_"^"_vendorid_"^"_TVendor_"^"_TInvoice_"^"_TEquipTypeCode_"^"_TEquipType_"^"_TAmount_"^"_TQuantity_"^人民币^1^"_TAmount_"^"_TEquipName_"^"_TActUser_"^"_TBank_"^"_TBankNo_"^"_TVendorID
/// 年         月         供应商RowID   供应商名称  发票号        设备类组编码      设备类组       金额        数量        币种  汇率  本位币     设备名称       单据审核人   开户行    银行账号    供应商ID
/// d ##Class(web.DHCEQForCA).GetInStock("2014-10-01","2014-10-31")
ClassMethod GetInStock(vStartDate As %String = "", vEndDate As %String = "", vJQType As %String = "")
{
	i vStartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1 ;$ZDH(vStartDate,3)-1
	i vEndDate=""  d
	.s EndDate=+$H
	e  d
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date") ;$ZDH(vEndDate,3)
	//入库明细
	s node="InStock"
	K ^TMP("dhc","ca","InStock",$j)
	s CurRow=1
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
 	...s YearMonth=##Class(web.DHCEQCommon).TransValueToPage(StockDate,"date") ;$ZD(StockDate,3)
 	...s TYear=$P(YearMonth,"-",1)
 	...s TMonth=+$P(YearMonth,"-",2)
 	...s TActUser=$p($g(^DHCEQInStock(ISRowID)),"^",6)
 	...i TActUser'="" s TActUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TActUser)
 	...s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",14)
 	...s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",13)
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	...s TVendorCode=""
 	...i vJQType=""  d
 	....s TVendorCode=vendorid
 	...e  d
 	....s TVendorCode=##Class(web.DHCEQCommon).GetContrastInfo(vJQType,"prov",vendorid,1)
 	...s TVendorID=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",16)
 	...s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
 	...s (TEquipTypeCode,TEquipType)=""
 	...i TEquipTypeDR'=""  d
 	....s TEquipTypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",1)
 	....s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
 	...s ISLRowID=0
 	...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
 	....s TInvoice=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ISLRowID)
 	....s TInvoice=$p(TInvoice,"^",1)
 	....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
 	....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
 	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	....s ^TMP("dhc","ca",node,$j,CurRow)=TYear_"^"_TMonth_"^"_vendorid_"^"_TVendor_"^"_TInvoice_"^"_TEquipTypeCode_"^"_TEquipType_"^"_TAmount_"^"_TQuantity_"^人民币^1^"_TAmount_"^"_TEquipName_"^"_TActUser_"^"_TBank_"^"_TBankNo_"^"_TVendorID_"^"_TVendorCode
 	....s CurRow=CurRow+1
 	
 	//退货明细
	s node="Return"
	K ^TMP("dhc","ca","Return",$j)
	s CurRow=1
 	s StockDate=StartDate
 	f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s RRowID=0		
 	..f  s RRowID=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR,RRowID)) q:RRowID=""  d
 	...s vendorid=$p($g(^DHCEQReturn(RRowID)),"^",3)
 	...q:vendorid=""
 	...s RType=$p($g(^DHCEQReturn(RRowID)),"^",17)
 	...q:RType'=1
 	...s YearMonth=##Class(web.DHCEQCommon).TransValueToPage(StockDate,"date") ;$ZD(StockDate,3)
 	...s TYear=$P(YearMonth,"-",1)
 	...s TMonth=+$P(YearMonth,"-",2)
 	...s TActUser=$p($g(^DHCEQReturn(RRowID)),"^",7)
 	...i TActUser'="" s TActUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TActUser)
 	...s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",14)
 	...s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",13)
 	...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
  	...s TVendorCode=""
 	...i vJQType=""  d
 	....s TVendorCode=vendorid
 	...e  d
 	....s TVendorCode=##Class(web.DHCEQCommon).GetContrastInfo(vJQType,"prov",vendorid,1)
 	...s TVendorID=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",16)
 	...s TEquipTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",15)
 	...s (TEquipTypeCode,TEquipType)=""
 	...i TEquipTypeDR'=""  d
 	....s TEquipTypeCode=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",1)
 	....s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
 	...s RLRowID=0
 	...f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
 	....s TInvoice=""
 	....s TInStockListDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
 	....s TEquipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
 	....i TInStockListDR'=""  d
 	.....s TEquipName=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5)
 	....e  d
 	.....s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
 	....s TQuantity=0-$p($g(^DHCEQReturnList(RLRowID)),"^",5)
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
 	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	....s ^TMP("dhc","ca",node,$j,CurRow)=TYear_"^"_TMonth_"^"_vendorid_"^"_TVendor_"^"_TInvoice_"^"_TEquipTypeCode_"^"_TEquipType_"^"_TAmount_"^"_TQuantity_"^人民币^1^"_TAmount_"^"_TEquipName_"^"_TActUser_"^"_TBank_"^"_TBankNo_"^"_TVendorID_"^"_TVendorCode
 	....s CurRow=CurRow+1
}

}
