Class web.DHCEQPay Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add by JDL 2011-5-25 JDL0081
/// 判断该入库明细是否符合 付款计划条件
/// 入参：	SourceType: 1入库明细
/// 		SourceID: 相应的业务明细ID
/// 		PlanPayDateFrom:开始计划支付日期
/// 		PlanPayDateTo:结束计划支付日期
/// 		PayedFlag:付款计划已支付标志
/// 返回：判断结果^计划付款日期
/// 		 判断结果：0不符合 1符合
/// 		 计划付款日期:符合条件的第一个条付款计划日期
/// w ##Class(web.DHCEQPay).CheckPayPlan(1,21,
ClassMethod CheckPayPlan(SourceType, SourceID, PlanPayDateFrom, PlanPayDateTo, PayedFlag)
{
	n TSourceType,TSourceID,TOCLRowID,TISLRowID
	n TRowID,FindFlag,TDateType,TPlanPayDate,PlanPayDate
	s PlanPayDate=""
	s FindFlag=0
	;
	if ((SourceType="")||(SourceID="")) q 0
	;不需要判断付款计划,则返回1 符合
	if (PlanPayDateFrom="")&&(PlanPayDateTo="")&&(PayedFlag="") q 1
	
	if (SourceType="1")
	{		
		;当为入库明细时,取入库明细对应的验收的明细ID
		s TISLRowID=SourceID
		s TSourceType=$p(^DHCEQInStockList(SourceID),"^",18)
		s TSourceID=$P(^DHCEQInStockList(SourceID),"^",19)
		;非来自验收单的,返回
		i TSourceType'=2 Quit 0
		s TOCLRowID=TSourceID
		
		;如果验收单没有对应的付款计划时,取验收单对应的合同是否有付款计划
		i '$d(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID))
		{			
			s TSourceType=$p(^DHCEQOpenCheckList(TSourceID),"^",63) 
			;非来自于合同的,返回
			i TSourceType'=1 Quit 0		;20140410  Mozy0126
			s TSourceID=$p(^DHCEQOpenCheckList(TSourceID),"^",64)			
		}		
		s TRowID=0
		f  s TRowID=$o(^DHCEQPayPlan(0,"Source",TSourceType,TSourceID,TRowID))  quit:(TRowID="")  d
		.s TDateType=$p($g(^DHCEQPayPlan(TRowID)),"^",5)
		.;1:指定日期 2:相对验收日期  3:相对入库日期
		.i TDateType="1"  d
		..s TPlanPayDate=$p($g(^DHCEQPayPlan(TRowID)),"^",6)
		.else  if TDateType="2"  d
		..s TPlanPayDate=$p(^DHCEQOpenCheckRequest($p($g(^DHCEQOpenCheckList(TOCLRowID)),"^",1)),"^",26)	;AuditDate
		.else  if TDateType="3"  d
		..s TPlanPayDate=$p(^DHCEQInStock($p($g(^DHCEQInStockList(TISLRowID)),"^",1)),"^",13)	;BillAuditDate
		.
		.s TPeriodNum=$p($g(^DHCEQPayPlan(TRowID)),"^",7)
		.s TPeriodUnitDR=$p($g(^DHCEQPayPlan(TRowID)),"^",8)
		.i TDateType'="1"  d
		..s TPlanPayDate=##Class(web.DHCEQCCycleUnit).CycleUnitDate(TPeriodUnitDR,TPeriodNum,TPlanPayDate,1)
		.b TPlanPayDate
		.q:(PlanPayDateFrom'="")&&(PlanPayDateFrom>TPlanPayDate)
		.q:(PlanPayDateTo'="")&&(PlanPayDateTo<TPlanPayDate)
		.i FindFlag'=1  d
		..s PlanPayDate=TPlanPayDate
		..s FindFlag=1
	}
	q FindFlag_"^"_PlanPayDate
}

/// Add by JDL 2011-5-16 JDL0081
/// 判断支付记录信息是否符合条件
/// 入参：	SourceType: 1入库明细
/// 		SourceID: 相应的业务明细ID
/// 		PayNo:支付号
/// 		PayDateFrom:开始支付日期
/// 		PayDateTo:结束支付日期
/// 		PayPlanDR:付款计划
/// 返回：判断结果^总支付金额^符合条件的支付金额^付款次数
/// 		 判断结果：0不符合 1符合
ClassMethod CheckPayInfo(SourceType, SourceID, PayNo, PayDateFrom, PayDateTo, PayPlanDR)
{
	n RowID,FindFlag,Amount,FitAmount,Times
	n TPayDate,TPayNo,TPayPlanDR
	if ((SourceType="")||(SourceID="")) q 0
	s FindFlag=0
	s (Amount,FitAmount,Times)=0
	s RowID=0
	f  s RowID=$o(^DHCEQPayRecord(0,"Source",SourceType,SourceID,RowID))  quit:RowID=""  d
	.//modified by  ZY0122       供货商付款申请单根据状态来
	.q:$p($g(^DHCEQPayRecord(RowID)),"^",29)="Y"
	.q:$p($g(^DHCEQPayRecord(RowID)),"^",18)'="2"
	.s Amount=Amount+$p($g(^DHCEQPayRecord(RowID)),"^",3)
	.s Times=Times+1
	.s TPayDate=$p($g(^DHCEQPayRecord(RowID)),"^",4)
	.q:(PayDateFrom'="")&&(TPayDate<PayDateFrom)
	.q:(PayDateTo'="")&&(TPayDate>PayDateTo)
	.s TPayNo=$p($g(^DHCEQPayRecord(RowID)),"^",5)
	.q:(PayNo'="")&&($ZCONVERT(TPayNo,"U")'[$ZCONVERT(PayNo,"U"))
	.s TPayPlanDR=$p($g(^DHCEQPayRecord(RowID)),"^",17)	
	.q:(PayPlanDR'="")&&(TPayPlanDR'=PayPlanDR)
	.s FindFlag=1
	.s FitAmount=FitAmount+$p($g(^DHCEQPayRecord(RowID)),"^",3)
	
	i ((Times=0)&(PayNo="")&(PayDateFrom="")&(PayDateTo="")&(PayPlanDR="")) s FindFlag=1
	q FindFlag_"^"_Amount_"^"_FitAmount_"^"_Times
}

/// Add by JDL 2011-5-16 JDL0081
/// 判断发票信息是否符合条件
/// 入参：	SourceType:1入库明细 9付款记录
/// 		SourceID:相应的业务明细ID
/// 		InvoiceNo:发票号
/// 		InvoiceDateFrom:开始发票日期
/// 		InvoiceDateTo:结束发票日期
/// 返回：判断结果^总发票金额^符合条件的发票金额^发票号串
/// 		 判断结果：0不符合 1符合
ClassMethod CheckInvoice(SourceType, SourceID, InvoiceNo, InvoiceDateFrom, InvoiceDateTo)
{
	n RowID,FindFlag,Amount,FitAmount,InvoiceNos,Times
	n TInvoiceNo,TInvoiceDate,TInvoiceFee
	if ((SourceType="")||(SourceID="")) q 0
	s FindFlag=0
	s InvoiceNos=""
	s (Amount,FitAmount,Times)=0
	s RowID=0
	f  s RowID=$o(^DHCEQInvoiceUseMap(0,"Source",SourceType,SourceID,RowID)) q:(RowID="")  d
	.s InvoiceDR=$p(^DHCEQInvoiceUseMap(RowID),"^",2)
	.i InvoiceDR'="" d
	..q:$P(^DHCEQInvoice(InvoiceDR),"^",16)="Y"	;InvalidFlag
	..s TInvoiceNo=$P(^DHCEQInvoice(InvoiceDR),"^",2)
	..i InvoiceNos'="" s InvoiceNos=InvoiceNos_","_TInvoiceNo
	..i InvoiceNos="" s InvoiceNos=TInvoiceNo
	..s TInvoiceDate=$P(^DHCEQInvoice(InvoiceDR),"^",3)
	..s TInvoiceFee=$P(^DHCEQInvoice(InvoiceDR),"^",4)
	..s Amount=Amount+TInvoiceFee
	..s Times=Times+1
	..q:(InvoiceDateFrom'="")&&(TInvoiceDate<InvoiceDateFrom)
	..q:(InvoiceDateTo'="")&&(TInvoiceDate>InvoiceDateTo)
	..q:(InvoiceNo'="")&&($ZCONVERT(TInvoiceNo,"U")'[$ZCONVERT(InvoiceNo,"U"))
	..
	..s FindFlag=1	
	..s FitAmount=FitAmount+TInvoiceFee
	
	i ((Times=0)&(InvoiceNo="")&(InvoiceDateFrom="")&(InvoiceDateTo="")) s FindFlag=1
	
	q FindFlag_"^"_Amount_"^"_FitAmount_"^"_InvoiceNos
}

/// 获取入库明细及付款记录信息
/// Add by JDL 2011-5-13 JDL0081
/// d ##class(%ResultSet).RunQuery("web.DHCEQPay","GetInStockDetail",vData)
/// s vData="^PlanPayDateFrom=26/05/2011^PlanPayDateTo=26/06/2011"
Query GetInStockDetail(vData As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TInStockStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TInvoice:%String,TTotalFee:%String,TEquipCat:%String,TUseYearsNum:%String,TISLRowID:%String,TPayAmount:%String,TPayTimes:%String,TPlanPayDate:%String,TReturnNum:%String,TReturnAmount:%String,TRow:%String")
{
}

ClassMethod GetInStockDetailExecute(ByRef qHandle As %Binary, vData As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s TRow=0
 	if (vData="") Quit $$$OK
	s ISNo=##Class(web.DHCEQCommon).GetDataByName(vData,"ISNo")
	s LocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"LocDR")
	s InStockStatus=##Class(web.DHCEQCommon).GetDataByName(vData,"InStockStatus")
	s InDateFrom=##Class(web.DHCEQCommon).GetDataByName(vData,"InDateFrom")
	s InDateTo=##Class(web.DHCEQCommon).GetDataByName(vData,"InDateTo")
	s MinPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MinPrice")
	s MaxPrice=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxPrice")
	s ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
	s Name=##Class(web.DHCEQCommon).GetDataByName(vData,"Name")
	s EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	s InvoiceInfoDR=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceInfoDR")
	s PayRecordInfoDR=##Class(web.DHCEQCommon).GetDataByName(vData,"PayRecordInfoDR")
	s PayNo=##Class(web.DHCEQCommon).GetDataByName(vData,"PayNo")
	s PayDateFrom=##Class(web.DHCEQCommon).GetDataByName(vData,"PayDateFrom")
	s PayDateTo=##Class(web.DHCEQCommon).GetDataByName(vData,"PayDateTo")
	s PayPlanDR=##Class(web.DHCEQCommon).GetDataByName(vData,"PayPlanDR")
	s InvoiceNo=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNo")
	s InvoiceDateFrom=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceDateFrom")
	s InvoiceDateTo=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceDateTo")
	s PlanPayDateFrom=##Class(web.DHCEQCommon).GetDataByName(vData,"PlanPayDateFrom")
	s PlanPayDateTo=##Class(web.DHCEQCommon).GetDataByName(vData,"PlanPayDateTo")
	s QXType=##Class(web.DHCEQCommon).GetDataByName(vData,"QXType")
 	
 	s InDateFrom=##Class(web.DHCEQCommon).TransValueFromPage(InDateFrom,"date")
 	s InDateTo=##Class(web.DHCEQCommon).TransValueFromPage(InDateTo,"date")
 	s PayDateFrom=##Class(web.DHCEQCommon).TransValueFromPage(PayDateFrom,"date")
 	s PayDateTo=##Class(web.DHCEQCommon).TransValueFromPage(PayDateTo,"date")
 	s InvoiceDateFrom=##Class(web.DHCEQCommon).TransValueFromPage(InvoiceDateFrom,"date")
 	s InvoiceDateTo=##Class(web.DHCEQCommon).TransValueFromPage(InvoiceDateTo,"date")
 	s PlanPayDateFrom=##Class(web.DHCEQCommon).TransValueFromPage(PlanPayDateFrom,"date")
 	s PlanPayDateTo=##Class(web.DHCEQCommon).TransValueFromPage(PlanPayDateTo,"date")
 	
 	i InDateFrom="" s InDateFrom=0
 	i InDateTo="" s InDateTo=+$H
	s InvoiceNo=$ZCONVERT(InvoiceNo,"U")
	
	s TISRowID=0
	f  s TISRowID=$o(^DHCEQInStock(TISRowID))  quit:TISRowID=""  d
	.s TInDate=$p($g(^DHCEQInStock(TISRowID)),"^",1)
	.q:(TInDate>InDateTo)||(TInDate<InDateFrom)
	.s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	.s TLocDR=$p(^DHCEQInStock(TISRowID),"^",2)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TInStockStatus=$p(^DHCEQInStock(TISRowID),"^",10)
	.q:(InStockStatus'="")&&(TInStockStatus'=InStockStatus)
	.s TISNo=$p(^DHCEQInStock(TISRowID),"^",14)
	.q:(ISNo'="")&&(TISNo'[ISNo)
	.s TProviderDR=$p(^DHCEQInStock(TISRowID),"^",17)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.s TEquipTypeDR=$p($g(^DHCEQInStock(TISRowID)),"^",20)
	.q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	.s TISLRowID=0
	.f  s TISLRowID=$o(^DHCEQInStockList(0,"InStock",TISRowID,TISLRowID))  quit:TISLRowID=""  d
	..d ResetVariablesGetInStockDetail
	..s TEquipName=$p(^DHCEQInStockList(TISLRowID),"^",5)
	..q:(Name'="")&&(TEquipName'[Name)
	..s TPrice=$p(^DHCEQInStockList(TISLRowID),"^",7)
	..q:(MaxPrice'="")&&(TPrice>MaxPrice)
	..q:(MinPrice'="")&&(TPrice<MinPrice)
	..s TPayPlanInfo=..CheckPayPlan("1",TISLRowID,PlanPayDateFrom,PlanPayDateTo,"")
	..q:$p(TPayPlanInfo,"^",1)=0
	..s TPlanPayDate=$p(TPayPlanInfo,"^",2)
	..s TPlanPayDate=##class(web.DHCEQCommon).TransValueToPage(TPlanPayDate,"date")
	..s TPayRecordInfo=..CheckPayInfo("1",TISLRowID,PayNo,PayDateFrom,PayDateTo,PayPlanDR)
	..q:$p(TPayRecordInfo,"^",1)=0
	..s TPayAmount=$p(TPayRecordInfo,"^",2)
	..s TPayTimes=$p(TPayRecordInfo,"^",4)
	..s TInvoiceInfo=..CheckInvoice("1",TISLRowID,InvoiceNo,InvoiceDateFrom,InvoiceDateTo)
	..q:$p(TInvoiceInfo,"^",1)=0
	..s TInvoice=$p(TInvoiceInfo,"^",4)
	..if ($l(TInvoice,",")>1) s TInvoice=$p(TInvoice,",",1)_"..."
	..d GetOneInStockDetail
	Quit $$$OK
GetOneInStockDetail
	s TInDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TISRowID)),"^",1),"date")
	;s TLoc=$p($g(^CTLOC($p(^DHCEQInStock(TISRowID),"^",2))),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(^DHCEQInStock(TISRowID),"^",2))   //modify by jyp 2019-10-18 CTLOC调整
	s TISNo=$p(^DHCEQInStock(TISRowID),"^",14)
	s TProviderDR=$p(^DHCEQInStock(TISRowID),"^",17)
	s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TStatCatDR=$p($g(^DHCEQInStock(TISRowID)),"^",21)
	i TStatCatDR '="" s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipTypeDR=$p($g(^DHCEQInStock(TISRowID)),"^",20)
	i TEquipTypeDR '="" s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TInStockStatus=$p($g(^DHCEQInStock(TISRowID)),"^",10)
	s TInStockStatus = $CASE(TInStockStatus,"0":"新增","1":"提交","2":"审核",:"没有定义")
	s TModelDR=$p(^DHCEQInStockList(TISLRowID),"^",9)
	i TModelDR'="" d
	.s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	s TUseYearsNum=$p(^DHCEQInStockList(TISLRowID),"^",15)
	s TOriginalFee=$p(^DHCEQInStockList(TISLRowID),"^",7)
	s TQuantityNum=$p(^DHCEQInStockList(TISLRowID),"^",8)
	s TTotalFee=TOriginalFee*TQuantityNum
	s TEquipCatDR=$p(^DHCEQInStockList(TISLRowID),"^",14)
	i TEquipCatDR'="" s TEquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	s TUnitDR=$p(^DHCEQInStockList(TISLRowID),"^",10)
	i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	//Add 2014-8-14 HZY0058
	s returnInfo=..GetReturnInfoOfInstockList(TISLRowID)
	s TReturnNum=$p(returnInfo,"^",1)
	s TReturnAmount=$p(returnInfo,"^",2)
	
	d OutputRowGetInStockDetail
	quit
OutputRowGetInStockDetail
	s TRow=TRow+1
	s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TInStockStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISLRowID,TPayAmount,TPayTimes,TPlanPayDate,TReturnNum,TReturnAmount)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockDetail
	s (TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TInStockStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TPayAmount,TPayTimes,TPlanPayDate,TReturnNum,TReturnAmount)=""
	quit
}

ClassMethod GetInStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockDetailExecute ]
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

ClassMethod GetInStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add 2014-8-14 HZY0058
/// 获取入库明细对应的退货的数量和总金额
ClassMethod GetReturnInfoOfInstockList(ISLRowID)
{
	new num,amount
	s (num,amount)=0
	if (ISLRowID>0)
	{
		s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
		s EquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
		s ProviderDR=$p(^DHCEQInStock(ISRowID),"^",17)
		
		s RRowID=0
		f  s RRowID=$o(^DHCEQReturn(0,"Provider",ProviderDR,RRowID)) q:RRowID=""  d
		.q:(EquipTypeDR'=$p($g(^DHCEQReturn(RRowID)),"^",15))
		.s RLRowID=0
		.f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID)) q:RLRowID=""  d
		..s ISLDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
		..i ""'=ISLDR  d
		...i ISLRowID=ISLDR  d
		....s num=num+$p($g(^DHCEQReturnList(RLRowID)),"^",5)
		....s amount=+$p($g(^DHCEQReturnList(RLRowID)),"^",5)*$p($g(^DHCEQReturnList(RLRowID)),"^",6)+amount
		..e  d
		...s equipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
		...i ISLRowID=$p($g(^DHCEQEquip(equipDR)),"^",70)  d
		....s num=num+1
		....s amount=+$p($g(^DHCEQReturnList(RLRowID)),"^",6)*1+amount
		
	}
	q num_"^"_amount
}

}
