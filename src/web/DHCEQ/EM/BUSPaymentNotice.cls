Import SQLUser

/// 创建人:Mozy 2023-2-14
/// 凭证
Class web.DHCEQ.EM.BUSPaymentNotice Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetStatus(Status)
{
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
}

/// Description:   明细来源类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSPaymentNotice","GetPaymentNoticeSourceType")
Query GetPaymentNoticeSourceType() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetPaymentNoticeSourceTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
	;CustomValue="1^入库单&2^转移单&3^减少单";
	s rowid=1
	s Code="01"
	s Desc="发票号"
	d OutputRowGetPaymentNoticeSourceType
	Quit $$$OK
OutputRowGetPaymentNoticeSourceType
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetPaymentNoticeSourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentNoticeSourceTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPaymentNoticeSourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentNoticeSourceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:   通知单明细来源-发票
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSPaymentNotice","GetPaymentNoticeSource","","","","",46)
Query GetPaymentNoticeSource(SourceType As %String = "", SourceDesc As %String = "", SourceID As %String = "", PNLRowID As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "TSourceID:%String,TExtendType:%String,TExtendID:%String,TNo:%String,TInStockNo:%String,TDate:%String,TEquipName:%String,TManuFactory:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String,TBuyLoc:%String,TRemark:%String")
{
}

ClassMethod GetPaymentNoticeSourceExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceDesc As %String = "", SourceID As %String = "", PNLRowID As %String = "", ProviderDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("web.DHCEQ.EM.BUSPaymentNotice.GetInvoice")=SourceType_","_SourceDesc_","_SourceID_","_PNLRowID_","_ProviderDR
	Set index=1
	Set SourceDesc=$ZCONVERT(SourceDesc,"U")
	
	Set IVStatus=""
	For  Set IVStatus=$Order(^DHCEQInvoice(0,"StatusProvider",IVStatus)) Quit:IVStatus=""  Do
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQInvoice(0,"StatusProvider",IVStatus,ProviderDR,rowid)) Quit:rowid=""  Do
	..Set TNo=$Piece($Get(^DHCEQInvoice(rowid)),"^",2)
	..Quit:(SourceDesc'="")&($ZCONVERT(TNo,"U")'[SourceDesc)
	..Set IUMRowID=0
	..For  Set IUMRowID=$Order(^DHCEQInvoiceUseMap(0,"Invoice",rowid,IUMRowID)) Quit:IUMRowID=""  Do
	...Do ResetVariablesGetInvoice
	...Set Type=$Piece($Get(^DHCEQInvoiceUseMap(IUMRowID)),"^",3)
	...Quit:Type'=1		;过滤非入库单的发票
	...
	...Set TExtendType=1
	...Set ISLRowid=$Piece($Get(^DHCEQInvoiceUseMap(IUMRowID)),"^",1)	;SourceID
	...q:'$d(^DHCEQInStockList(ISLRowid))
	...Set TExtendID=ISLRowid
	...Set ISRowID=$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",1)
	...Quit:$Piece($Get(^DHCEQInStock(ISRowID)),"^",25)="Y"
	...Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)
	...Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	...Set TEquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...Set Status=$Piece($Get(^DHCEQInStock(ISRowID)),"^",10)
	...Quit:(Status'=2)
	...Quit:##Class(web.DHCEQ.EM.BUSPaymentNotice).CheckSourceIDIsInValid(1,TExtendID,SourceID)
	...Set TInStockNo=$Piece($Get(^DHCEQInStock(ISRowID)),"^",14)
	...Set TInDate=$Piece($Get(^DHCEQInStock(ISRowID)),"^",1)
	...Set TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	...Set TEquipName=$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",5)
	...Set TManuFactoryDR=$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",6)
	...Set TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	...Set TOriginalFee=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",7)
	...Set TQuantityNum=+$Piece($Get(^DHCEQInStockList(ISLRowid)),"^",8)
	...Set TTotalFee=TOriginalFee*TQuantityNum
	...Set TRemark=$Piece($Get(^DHCEQInStock(ISRowID)),"^",11)
	...Set TBuyLocDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",18)
	...Set TBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", TBuyLocDR)
	...Set TBuyLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TBuyLoc,"-")
	...Do OutputRowGetInvoice
	
	Quit $$$OK
OutputRowGetInvoice
	Set Data=$lb(rowid,TExtendType,TExtendID,TNo,TInStockNo,TInDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TBuyLoc,TRemark)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetInvoice
	Set (TExtendType,TExtendID,TInStockNo,TInDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TBuyLoc,TRemark)=""
	Quit
}

ClassMethod GetPaymentNoticeSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentNoticeSourceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPaymentNoticeSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentNoticeSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 一张发票只能做一张付款通知单
/// SourceID:入库明细
/// 返回:0	有效,1	无效
/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).CheckSourceIDIsInValid(1,1955)
ClassMethod CheckSourceIDIsInValid(SourceType As %String = "", SourceID As %String = "", ID As %String = "")
{
	Quit:(SourceType="")||(SourceID="") 1
	new (SourceType,SourceID,ID)
	
	Set Flag=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQPaymentNoticeList(0,"Extend",SourceType,SourceID,Rowid)) Quit:Rowid=""  Do
	.Set PaymentNoticeDR=$Piece($Get(^DHCEQPaymentNoticeList(Rowid)),"^",1)
	.Set Status=$Piece($Get(^DHCEQPaymentNotice(PaymentNoticeDR)),"^",12)
	.Quit:($Piece($Get(^DHCEQPaymentNotice(PaymentNoticeDR)),"^",26)="Y")
	.If (Status'=3)&&(ID'=Rowid) Set Flag=1
	
	Quit Flag
}

/// 设备付款通知单查找
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSPaymentNotice","GetPaymentNotice","FK2022031","",225)
Query GetPaymentNotice(PaymentNoticeNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", Status As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Query(ROWSPEC = "TJob:%String,TRowID:%String,TPaymentNoticeNo:%String,TPaymentNoticeDate:%String,TLoc:%String,TProvider:%String,TBank:%String,TBankAccount:%String,TAccountDate:%String,TTotalFee:%String,TPurposeType:%String,TType:%String,TAgent:%String,TStatus:%String,TRemark:%String")
{
}

ClassMethod GetPaymentNoticeExecute(ByRef qHandle As %Binary, PaymentNoticeNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", Status As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N") As %Status
{
 	new repid, index, rowid, flag, id, no, TJob, PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	Set TJob=$Job
 	Kill ^DHCEQTemp("GetPaymentNotice",TJob)
 	Set PNum=1
 	;s ^DHCEQMozy("web.DHCEQ.EM.BUSPaymentNotice")=PaymentNoticeNo _","_ InvoiceNo _","_ LocDR_","_ Status _","_ ProviderDR _","_ StartDate _","_ EndDate_","_ InvalidFlag
	
	i StartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$h
	e  d
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQPaymentNotice(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetPaymentNotice
	.Set TRowID = rowid
	.Quit:$Piece($Get(^DHCEQPaymentNotice(rowid)),"^",26)'="N"
	.Set TPaymentNoticeNo = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",1)
	.Quit:(PaymentNoticeNo'="")&(TPaymentNoticeNo'[PaymentNoticeNo)
	.Set TPaymentNoticeDate = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",2)
	.Quit:(TPaymentNoticeDate>EndDate)||(TPaymentNoticeDate<StartDate)
	.If TPaymentNoticeDate'="" Set TPaymentNoticeDate = ##class(web.DHCEQCommon).TransValueToPage(TPaymentNoticeDate,"date")
	.Set TLocDR = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",3)
	.Quit:(LocDR'="")&(TLocDR'=LocDR)
	.Set TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.Set TProviderDR = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",4)
	.Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	.Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.;Set TEquipTypeDR = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",5)
	.;Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.;If TEquipTypeDR '="" Set TEquipType = $Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Set TBank = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",5)
	.Set TBankAccount = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",6)
	.Set TAccountDate = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",7)
	.If TAccountDate'="" Set TAccountDate = ##class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.Set TTotalFee = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",8)
	.If TTotalFee'="" Set TTotalFee=$FN(TTotalFee,"",2)
	.Set TPurposeType = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",9)
	.Set TType = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",10)
	.Set TAgent = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",11)
	.Set TStatus = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",12)
	.Quit:(Status'="")&&(Status'="4")&&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQ.EM.BUSPaymentNotice).GetStatus(TStatus)
	.Set TRemark = $Piece($Get(^DHCEQPaymentNotice(rowid)),"^",13)
	.
	.If InvoiceNo'="" Do
	..Set flag=1
	..Set id=0
	..For  Set id=$order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",rowid,id)) Quit:(id="")||(flag'=1)  Do
	...Quit:($Piece($Get(^DHCEQPaymentNoticeList(id)),"^",2))'=1
	...Set no = $Piece($Get(^DHCEQPaymentNoticeList(id)),"^",3)
	...Set no = $Piece($Get(^DHCEQInvoice(no)),"^",2)
	...If no[InvoiceNo Set flag=""
	.Quit:flag'=""
	.Do OutputRowGetPaymentNotice
	
	Quit $$$OK
OutputRowGetPaymentNotice
	Set Data=$lb(TJob,TRowID,TPaymentNoticeNo,TPaymentNoticeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TType,TAgent,TStatus,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("GetPaymentNotice",TJob,PNum)=TRowID_"^"_TPaymentNoticeNo_"^"_TPaymentNoticeDate_"^"_TLoc_"^"_TProvider_"^"_TEquipType_"^"_TAccountDate_"^"_TTotalFee_"^"_TStatus_"^"_TRemark
	Set PNum=PNum+1
	
	Quit
ResetVariablesGetPaymentNotice
	Set (TRowID,TPaymentNoticeNo,TPaymentNoticeDate,TLocDR,TLoc,TProviderDR,TProvider,TEquipTypeDR,TProvider,TEquipType,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TType,TAgent,TStatus,TRemark,flag)=""
	Quit
}

ClassMethod GetPaymentNoticeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentNoticeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPaymentNoticeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentNoticeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).GetOnePaymentNoticeDetail(0,3824)
ClassMethod GetOnePaymentNoticeDetail(PNum As %Library.String = "", job As %Library.String = "")
{
	Quit:(PNum="")||(job="") ""
	Quit:PNum=0 $Order(^DHCEQTemp("GetPaymentNotice",job,""),-1)
	Quit $Get(^DHCEQTemp("GetPaymentNotice",job,PNum))
}

/// 描述:凭单业务明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSPaymentNotice","GetPaymentNoticeList",6)
Query GetPaymentNoticeList(RowID As %String = "") As %Query(ROWSPEC = "PNLRowID:%String,TRow:%String,PNLPaymentNoticeDR:%String,PNLSourceType:%String,PNLSourceID:%String,PNLSourceType_Desc:%String,PNLSourceID_Desc:%String,PNLExtendType:%String,PNLExtendID:%String,PNLExtendID_Desc:%String,PNLMakeDate:%String,PNLEquipName:%String,PNLManuFactory:%String,PNLOriginalFee:%String,PNLQuantityNum:%String,PNLTotalFee,PNLAmountFee:%String,PNLRemark:%String,PNLHold1:%String,PNLHold2:%String,PNLHold3:%String,PNLHold4:%String,PNLHold5:%String")
{
}

ClassMethod GetPaymentNoticeListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
 	new repid, index, TotalQty, Total, TotalFlag, SourceInfo
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	
	Set (TotalQty,Total,RowTotal)=0
	Set index=1
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	
	Set TRow=0
	Set PaymentNoticeDR=RowID
	If PaymentNoticeDR'=""
	{
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",PaymentNoticeDR,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetPaymentNoticeList
		.Set TRowID = rowid
		.Set TSourceType=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",2)
		.Set TSourceTypeDesc="发票号"
		.Set TSourceID=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",3)
		.Set TSourceNo=$Piece($Get(^DHCEQInvoice(TSourceID)),"^",2)
		.Set TExtendType=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",4)
		.Set TExtendID=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",5)
		.If TExtendType=0 Do
		..;来源类型是验收明细
		..;Set ISRowID=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",1)
		..;Set TExtendNo=$Piece($Get(^DHCEQInStock(ISRowID)),"^",14)
		..;Set TInDate=$Piece($Get(^DHCEQInStock(ISRowID)),"^",1)
		..;If TInDate'="" Set TInDate = ##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
		..;Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)
		..;Set TEquipName=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",5)
		..;Set TManuFactoryDR=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",6)
		..;Set TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		..;Set TOriginalFee=+$Piece($Get(^DHCEQInStockList(TExtendID)),"^",7)
		..;Set TQuantityNum=+$Piece($Get(^DHCEQInStockList(TExtendID)),"^",8)
		.If TExtendType=1 Do
		..;来源类型是入库明细
		..Set ISRowID=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",1)
		..Set TExtendNo=$Piece($Get(^DHCEQInStock(ISRowID)),"^",14)
		..Set TExtendDate=$Piece($Get(^DHCEQInStock(ISRowID)),"^",1)
		..If TExtendDate'="" Set TExtendDate = ##class(web.DHCEQCommon).TransValueToPage(TExtendDate,"date")
		..Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)
		..Set TEquipName=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",5)
		..Set TManuFactoryDR=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",6)
		..Set TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		..Set TOriginalFee=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",7)
		..Set TQuantityNum=$Piece($Get(^DHCEQInStockList(TExtendID)),"^",8)
		.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.;Set TProviderDR=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",6)
		.;If TProviderDR'="" Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		.Set RowTotal=TOriginalFee*TQuantityNum
		.Set TAmountFee=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",7)
		.Set TRemark=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",8)
		.Set THold1=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",12)
		.Set THold2=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",13)
		.Set THold3=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",14)
		.Set THold4=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",15)
		.Set THold5=$Piece($Get(^DHCEQPaymentNoticeList(rowid)),"^",16)
		.Set TRow=TRow+1
		.Set Total=Total+TAmountFee
		.Do OutputRowGetPaymentNoticeList
	}
	;没有数据时,也返回一个空行,用于编辑
	If TRow=0 Do
	.Do ResetVariablesGetPaymentNoticeList
	.Set TRow=1
	.Do OutputRowGetPaymentNoticeList
	
	;处理合计行
	/*If TotalFlag>0 Do
	.Do ResetVariablesGetPaymentNoticeList
	.Set TRowID=-1
	.Set TTotalNum=TotalQty
	.Set TAmountFee=$FN(Total,"",2)
	.If TotalFlag="1" Do
	..Set index=1
	.Else  Do
	..Set index=index+1
	.Do OutputRowGetPaymentNoticeList*/
	
	Quit $$$OK
	
OutputRowGetPaymentNoticeList
	Set Data=$lb(TRowID,TRow,PaymentNoticeDR,TSourceType,TSourceID,TSourceTypeDesc,TSourceNo,TExtendType,TExtendID,TExtendNo,TExtendDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,RowTotal,TAmountFee,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetPaymentNoticeList
	Set (TRowID,TSourceType,TSourceTypeDesc,TSourceID,TSourceNo,TExtendType,TExtendID,TExtendNo,TExtendDate,TEquipName,TManuFactory,TOriginalFee,TQuantityNum,TAmountFee,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetPaymentNoticeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentNoticeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPaymentNoticeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentNoticeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).GetSourceType(1)
ClassMethod GetSourceType(Type As %String = "")
{
	Quit:Type=1 "发票号"
	Quit ""
}

/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).GetOnePaymentNotice(2)
ClassMethod GetOnePaymentNotice(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOnePaymentNotice"
	
	s ObjPaymentNotice=##Class(User.DHCEQPaymentNotice).%OpenId(RowID)
	s PaymentNoticeInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjPaymentNotice)
	d PaymentNoticeInfo.%Set("PNLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjPaymentNotice.PNLocDR))
	d PaymentNoticeInfo.%Set("PNProviderDR_VDesc",ObjPaymentNotice.PNProviderDR.VName)
	d PaymentNoticeInfo.%Set("PNTotalFeeA",##Class(web.DHCEQCommon).RMBDXXZH("","",ObjPaymentNotice.PNTotalFee))	;大写金额
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, PaymentNoticeInfo)
ERRORGetOnePaymentNotice
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000", ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).SaveData("","","")
ClassMethod SaveData(data, dataList, DelRowid)
{
	s $ZT="ERRORPaymentNotice"
	k PLIST,RowID
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQPaymentNotice",JsonData,.PLIST)
	s RowID = JsonData.%Get("PNRowID")
	
 	Set PLIST(13) = 0					;PN_Status
 	Set PLIST(15) = User
 	Set PLIST(16) = Date
 	Set PLIST(17) = Time
 	Set PLIST(27) = "N"					;PN_InvalidFlag
	
 	TSTART
	if RowID'=""
	{
		&SQL(update sqluser.DHC_EQPaymentNotice values :PLIST() where PN_RowID=:RowID)
	}
	else
	{
		Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQPayRecord",Date,JsonData.PNLocDR)
		&SQL(insert into sqluser.DHC_EQPaymentNotice values :PLIST())
		Set RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}	
	Set SQLCODE=##Class(web.DHCEQ.EM.BUSPaymentNotice).DeletePaymentNoticeList(DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
 	Set SQLCODE=##Class(web.DHCEQ.EM.BUSPaymentNotice).SavePaymentNoticeList(RowID,dataList,User)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORPaymentNotice
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).DeletePaymentNoticeList(",2,0,-1")
ClassMethod DeletePaymentNoticeList(DelRowIDs As %String = "")
{
	Quit:DelRowIDs="" 0
	new Length,PNLRowID,i
	
	Set SQLCODE=0
	Set Length=$l(DelRowIDs,",")
	For i=1:1:Length
	{
		Set PNLRowID=+$Piece(DelRowIDs,",",i)
		If (PNLRowID>0)
		{
			&SQL(Delete from sqluser.DHC_EQPaymentNoticeList where PNL_RowID=:PNLRowID)
		}
		Quit:SQLCODE
	}
	Quit SQLCODE
}

/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).SavePaymentNoticeList(5,"{""TRowID"":"""",""TRow"":""1"",""TSourceType"":"""",""TSourceID"":"""",""TSourceNo"":"""",""TExtendType"":"""",""TExtendID"":"""",""TExtendNo"":"""",""TExtendDate"":"""",""TEquipName"":"""",""TManuFactory"":"""",""TOriginalFee"":"""",""TQuantityNum"":"""",""TAmountFee"":"""",""TRemark"":"""",""THold1"":"""",""THold2"":"""",""THold3"":"""",""THold4"":"""",""THold5"":"""",""PNLSourceType"":""1"",""PNLSourceType_Desc"":""发票号"",""PNLSourceID_Desc"":""67503989"",""PNLAmountFee"":""7550"",""PNLSourceID"":""5"",""PNLExtendType"":""1"",""PNLExtendID"":""821"",""PNLExtendType_Desc"":""1"",""PNLExtendID_Desc"":""RK2021110013"",""PNLProviderDR"":""46"",""PNLMakeDate"":""2021-11-09"",""PNLEquipName"":""储物柜"",""PNLManuFactory"":"""",""PNLOriginalFee"":""7550"",""PNLQuantityNum"":""1"",""PNLTotalFee"":""7550""}",1)
ClassMethod SavePaymentNoticeList(PNRowID As %String = "", dataList As %String = "", User As %String = "")
{
	Quit:PNRowID="" -1
	Quit:dataList="" 0
	;s ^DHCEQMozy("SaveDataList")=PNRowID_"&"_dataList
	new Length,PNLRowID,Flag,i
	new valList,TSourceType,TSourceID,TotalFee,id
	
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	Set Length=$L(dataList,SplitRowCode)
	Set Flag=0
	For i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(dataList,SplitRowCode,i)
		q:valList=""
		k PLIST,PNLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQPaymentNoticeList",JsonData,.PLIST)
		s PLIST(2)=PNRowID
		s PLIST(10)=User						;PNL_UpdateUserDR
		s PLIST(11)=+$H  						;PNL_UpdateDate
		s PNLRowID = JsonData.PNLRowID
	    if PNLRowID'=""
	    {
			&SQL(update sqluser.DHC_EQPaymentNoticeList Values :PLIST() where PNL_RowID=:PNLRowID)
		}
		else
		{
			&SQL(Insert Into SQLUSER.DHC_EQPaymentNoticeList Values :PLIST())
			;Set PNLRowID=$Get(%ROWID)
		}
		i SQLCODE
 		{
			Set Flag=SQLCODE
 		}
 		Quit:Flag'=0
	}
	;汇总明细总金额,更新总单的总金额
	Set TotalFee=0
	Set id=0
	For  Set id=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",PNRowID,id)) Quit:id=""  Do
	.Set TotalFee = TotalFee+$Piece($Get(^DHCEQPaymentNoticeList(id)),"^",7)
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_TotalFee=:TotalFee where PN_RowID=:PNRowID)
	
	Quit Flag
}

/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).DeleteData()
ClassMethod DeleteData(RowID As %String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	Set $ZT="ERRORDelete"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_InvalidFlag='Y',PN_UpdateUserDR=:User,PN_UpdateDate=:Date,PN_UpdateTime=:Time where PN_RowID=:RowID)
 	i SQLCODE=100 s SQLCODE=0
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	
ERRORDelete
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:审核
/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).Audit("4")
ClassMethod Audit(RowID As %String = "")
{
	If RowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	Set $ZT="ERRORAudit"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_Status=2,PN_AuditUserDR=:User,PN_AuditDate=:Date,PN_AuditTime=:Time where PN_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORAudit 
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     	//返回错误消息
}

/// 描述:作废
/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).Cancel("4")
ClassMethod Cancel(RowID As %String = "")
{
	If RowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	Set $ZT="ERRORCancel"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPaymentNotice Set PN_Status=3,PN_DisUseUserDR=:User,PN_DisUseDate=:Date,PN_DisUseTime=:Time where PN_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORCancel
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg		//返回错误消息
}

/// w ##Class(web.DHCEQ.EM.BUSPaymentNotice).GetOnePaymentNoticeStr(7)
ClassMethod GetOnePaymentNoticeStr(rowid)
{
	new result,resultex,tmp
	Set (result,resultex)=""
	Set result=^DHCEQPaymentNotice(rowid)
	Set $Piece(result,"^",2)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",2),"date")	;PN_MakeDate
	Set resultex=resultex_"^"	;LocDR
	If $Piece(result,"^",3)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(result,"^",3))
	Set resultex=resultex_"^"	;ProviderDR
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",4))
	Set $Piece(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",7),"date")	;PN_AccountDate
	Set resultex=resultex_"^"	;PN_TotalFee
	If $Piece(result,"^",8)'="" Do
	.Set tmp=##Class(web.DHCEQCommon).RMBDXXZH("","",$Piece(result,"^",8))	;大写金额
	.Set resultex=resultex_##Class(web.DHCEQCommon).Trim(tmp)
	.Set $Piece(result,"^",8)=$Fn($Piece(result,"^",8),",",2)
	Set resultex=resultex_"^"	;PN_AuditUserDR
	If $Piece(result,"^",20)'="" Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user", $Piece(result,"^",20))
	
	//发票号处理
	s rowid1=0
	s TSourceNoStr=""
	f  s rowid1=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",rowid,rowid1)) Quit:rowid1=""  d
	.s TSourceID=$Piece($Get(^DHCEQPaymentNoticeList(rowid1)),"^",3)
	.s TSourceNo=$Piece($Get(^DHCEQInvoice(TSourceID)),"^",2)
	.s TSourceNoStr=TSourceNoStr_","_TSourceNo
	s TSourceNoStr=$e(TSourceNoStr,2,*)
	s resultex=resultex_"^"_TSourceNoStr
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex
}

/// 描述:润乾打印
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSPaymentNotice","GetPaymentNoticeListPrt",1)
Query GetPaymentNoticeListPrt(TRowID As %Library.String = "") As %Query(ROWSPEC = "NoticeNo:%String,Provider:%String,BankAccount:%String,Bank:%String,TotalFee:%String,TotalFeeA:%String,MakeDate:%String,PurposeType:%String,Type:%String,Agent:%String,InvoiceNoStr:%String") [ SqlProc ]
{
}

ClassMethod GetPaymentNoticeListPrtExecute(ByRef qHandle As %Binary, TRowID As %Library.String = "") As %Status
{
 	New repid, index
	Set repid=$INCREMENT(^CacheTemp)
 	Set qHandle=$LISTBUILD(0,repid,0)
    Set index=1
    If TRowID="" Quit $$$OK
	Set rowid=TRowID
	
	Set NoticeNo=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",1)
	Set Provider=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",4)
	Set Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)
	Set BankAccount=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",6)
	Set Bank=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",5)
	Set TotalFee=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",8)
	Set TotalFeeA=##Class(web.DHCEQCommon).RMBDXXZH("","",TotalFee)	;大写金额
	Set MakeDate=##class(web.DHCEQCommon).TransValueToPage($PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",2),"date")
	Set PurposeType=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",9)
	Set Type=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",10)
	Set Agent=$PIECE($GET(^DHCEQPaymentNotice(rowid)),"^",10)
	
	//发票号处理
	s rowid1=0
	s InvoiceNoStr=""
	f  s rowid1=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",rowid,rowid1)) Quit:rowid1=""  d
	.s TSourceID=$Piece($Get(^DHCEQPaymentNoticeList(rowid1)),"^",3)
	.s TSourceNo=$Piece($Get(^DHCEQInvoice(TSourceID)),"^",2)
	.s InvoiceNoStr=InvoiceNoStr_","_TSourceNo
	s InvoiceNoStr=$e(InvoiceNoStr,2,*)

 	Do OutputRowGetPaymentNoticeListPrt
	Quit $$$OK
	
OutputRowGetPaymentNoticeListPrt
	Set Data=$LISTBUILD(NoticeNo,Provider,BankAccount,Bank,TotalFee,TotalFeeA,MakeDate,PurposeType,Type,Agent,InvoiceNoStr)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetPaymentNoticeListPrtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPaymentNoticeListPrtExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$ORDER(^CacheTemp(repid,ind))
 	If ind=""
	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$LISTBUILD(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPaymentNoticeListPrtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPaymentNoticeListPrtExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
