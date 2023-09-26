/// Modified By HZY 2012-02-07 HZY0021
/// Desc:修改函数DeleteData:删除入库单的同时,无效掉对应入库明细的资金来源记录.
/// 	 修改函数DeleteInStockList:在删除入库单明细的同时将明细对应的资金来源记录无效掉.
/// ------------------------------------------------------------------------
/// 创建人:zy 2009-12-02  No ZY0018
/// 设备入库批量操作
/// flag:为1时取被服类组
Class web.DHCEQInStockNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
Query GetInStock(QXType, LocDR, Status, StartDate, EndDate, Type, ApproveRole, WaitAD, InStockNo, EquipNo, BuyLocDR, InvalidFlag As %String = "N", flag As %String = "", CancelOper As %String = "", HospitalDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInDate:%String,TLocDR:%String,TRejectReasonDR:%String,TRequestUserDR:%String,TRequestDate:%String,TAuditUserDR:%String,TAuditDate:%String,TRejectUserDR:%String,TRejectDate:%String,TStatus:%String,TRemark:%String,TBillAuditUserDR:%String,TBillAuditDate:%String,TInStockNo:%String,TOriginDR:%String,TFromDeptDR:%String,TProviderDR:%String,TLoc:%String,TRejectReason:%String,TRequestUser:%String,TAuditUser:%String,TRejectUser:%String,TBillAuditUser:%String,TOrigin:%String,TFromDept:%String,TProvider:%String,TBuyLoc:%String,TBuyUser:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TNum:%String,TFee:%String,TApproveStep:%String,TApproveRole:%String,TRow:%String,TListInfo:%String,TApprovals:%String,TFinanceType:%String")
{
}

ClassMethod GetInStockExecute(ByRef qHandle As %Binary, QXType, LocDR, Status, StartDate, EndDate, Type, ApproveRole, WaitAD, InStockNo, EquipNo, BuyLocDR, InvalidFlag As %String = "N", flag As %String = "", CancelOper As %String = "", HospitalDR As %String = "") As %Status
{
 	new repid, index,rowid,ApproveType,lrowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("13")
	s EquipTypeValues=""
	i flag="1"  s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	i EquipTypeValues'="" s EquipTypeValues=","_EquipTypeValues_","
	s index=2  ;Modified By QW20210422 bug:QW0100
	///modified by zy0172  hisui改造
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	s rowid=0
	s TRow=0
	s Total=0
	s TotalFee=0
	d BuildDataGetInStock
	Quit $$$OK
BuildDataGetInStock
	f  s rowid=$o(^DHCEQInStock(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStock
	.s TRowID = rowid
	.s ISFlag=$p($g(^DHCEQInStock(rowid)),"^",25)
	.i ISFlag="" s ISFlag="N"
	.s TStatus = $p($g(^DHCEQInStock(rowid)),"^",10)
	.q:(CancelOper="Y")&&(TStatus'=3)&&(InvalidFlag'="")&&(InvalidFlag'=ISFlag)	//modified by CZF0060 入库作废界面过滤未作废的无效单据
	.q:(CancelOper'="Y")&&(InvalidFlag'="")&&(InvalidFlag'=ISFlag)		//modified by CZF0060 2020-02-20 非入库作废界面过滤所有无效单据
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQInStock(rowid)),"^",1)>EndDate)||($p($g(^DHCEQInStock(rowid)),"^",1)<StartDate)
	.s TInDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",1),"date")
	.s TLocDR = $p($g(^DHCEQInStock(rowid)),"^",2)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.s TEquipTypeDR=$p($g(^DHCEQInStock(rowid)),"^",20) //modefy BY:GBX
	.q:(flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
	.i TLocDR '=""  d
	..s TLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.s TRejectReasonDR = $p($g(^DHCEQInStock(rowid)),"^",3)
	.i TRejectReasonDR '=""  d
	..s TRejectReason = $p($g(^DHCEQCCode("DHCEQCRejectReason",TRejectReasonDR)),"^",2)
	.s TRequestUserDR = $p($g(^DHCEQInStock(rowid)),"^",4)
	.i TRequestUserDR '=""  d
	..s TRequestUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TRequestUserDR)
	.s TRequestDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",5),"date")
	.s TAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",6)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
	.s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",7),"date")
	.s TRejectUserDR = $p($g(^DHCEQInStock(rowid)),"^",8)
	.i TRejectUserDR '=""  d
	..s TRejectUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TRejectUserDR)
	.s TRejectDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",9),"date")
	.s TStatus = $p($g(^DHCEQInStock(rowid)),"^",10)
	.q:(WaitAD="on")&&(TStatus="0")
	.q:(Status'="")&&(Status'=TStatus)
	.s TStatus=..GetInStockStatus(TStatus)
	.s TRemark = $p($g(^DHCEQInStock(rowid)),"^",11)
	.s TBillAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",12)
	.i TBillAuditUserDR '=""  d
	..s TBillAuditUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TBillAuditUserDR)
	.s TBillAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(rowid)),"^",13),"date")
	.s TInStockNo = $p($g(^DHCEQInStock(rowid)),"^",14)
	.q:TInStockNo="" //2011-07-22 DJ
	.q:(InStockNo'="")&&($e(TInStockNo,1,$l(InStockNo))'=InStockNo)
	.s Find=##Class(web.DHCEQInStockNew).CheckOrderEqNo("InStock",rowid,EquipNo)
	.q:(EquipNo'="")&&(Find=0)
	.s TOriginDR = $p($g(^DHCEQInStock(rowid)),"^",15)
	.i TOriginDR '=""  d
	..s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	.s TFromDeptDR = $p($g(^DHCEQInStock(rowid)),"^",16)
	.i TFromDeptDR '=""  d
	..s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	.s TProviderDR = $p($g(^DHCEQInStock(rowid)),"^",17)
	.i TProviderDR '=""  d
	..s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TBuyLocDR = $p($g(^DHCEQInStock(rowid)),"^",18)
	.q:(BuyLocDR'="")&&(TBuyLocDR'=BuyLocDR)
	.i TBuyLocDR '=""  d
	..s TBuyLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TBuyLocDR)
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TLocDR) ;Add QW20210629 BUG:QW0131
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	.s TBuyUserDR = $p($g(^DHCEQInStock(rowid)),"^",19)
	.i TBuyUserDR '=""  d
	..s TBuyUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBuyUserDR)
	.s TEquipTypeDR=$p($g(^DHCEQInStock(rowid)),"^",20)
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.q:+result'=0
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TFinanceTypeDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",9)
	.s TFinanceType=##class(web.DHCEQCommon).GetTrakNameByID("financetype",TFinanceTypeDR)
	.s TStatCatDR=$p($g(^DHCEQInStock(rowid)),"^",21)
	.i TStatCatDR '=""  d
	..s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.s TTotal=..GetOneInStockTotalFeeNum(rowid)
	.s TNum=$P(TTotal,"^",1)
	.s TFee=$P(TTotal,"^",2)
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s TApprovals="无"
	.s (AppSetDR,NextStepID)=""
	.i AIRowID'="" d
	..s AppSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)		//czf 2021-09-01
	..s NextStepID=$p(^DHCEQApproveInfo(AIRowID),"^",5)
	..s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	.i $p($g(^DHCEQInStock(rowid)),"^",10)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	.i ((WaitAD="on")&&(CurRole'="")) q:CurRole'=ApproveRole
	.s (AppFlowID,HospLimit)=""		//czf 2021-09-01 begin
	.i (AppSetDR'="")&&(NextStepID'="") d
	..s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSetDR,NextStepID,""))
	..i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	.q:(WaitAD="on")&&(ApproveRole=CurRole)&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("13",rowid)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	.// Mozy0231	访问资金来源类型
	.;Mozy0247		1190068		2020-02-17
	.s TMPCount=0
	.s lrowid=0 
	.f  s lrowid=$o(^DHCEQInStockList(0,"InStock",rowid,lrowid)) quit:(lrowid="")||(result'=0)  d
	..s result=##class(web.DHCEQCommon).FundsTypeIsIn(3,lrowid)
	..s TMPCount=TMPCount+1		;计数,只显示前两条
	..i TMPCount<3 d
	...i TListInfo'="" s TListInfo=TListInfo_";"
	...s TListInfo=TListInfo_$p($g(^DHCEQInStockList(lrowid)),"^",5)_","_$p($g(^DHCEQInStockList(lrowid)),"^",7)
	...s InvoiceInfos=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,lrowid)
	...s TListInfo=TListInfo_","_$p(InvoiceInfos,"^",1)
	.i TMPCount>2 s TListInfo=TListInfo_";..."
	.q:+result'=0
	.s Total=Total+TNum
	.s TotalFee=TotalFee+TFee
	.s TRow=TRow+1
	.d OutputRowGetInStock
	;Add By QW20210422 bug:QW0100 统计总数 begin 
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesGetInStock
		s TNum=Total
		s TFee=TotalFee
		s TRow="合计:"
		s Data=$lb(TRowID,TInDate,TLocDR,TRejectReasonDR,TRequestUserDR,TRequestDate,TAuditUserDR,TAuditDate,TRejectUserDR,TRejectDate,TStatus,TRemark,TBillAuditUserDR,TBillAuditDate,TInStockNo,TOriginDR,TFromDeptDR,TProviderDR,TLoc,TRejectReason,TRequestUser,TAuditUser,TRejectUser,TBillAuditUser,TOrigin,TFromDept,TProvider,TBuyLoc,TBuyUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TNum,TFee,TApproveStep,TApproveRole,TRow,TListInfo,TApprovals,TFinanceType)
		Set ^CacheTemp(repid,TotalLoc)=Data
	}
	;Add By QW20210422 bug:QW0100 统计总数 end 
	quit
OutputRowGetInStock
	s Data=$lb(TRowID,TInDate,TLocDR,TRejectReasonDR,TRequestUserDR,TRequestDate,TAuditUserDR,TAuditDate,TRejectUserDR,TRejectDate,TStatus,TRemark,TBillAuditUserDR,TBillAuditDate,TInStockNo,TOriginDR,TFromDeptDR,TProviderDR,TLoc,TRejectReason,TRequestUser,TAuditUser,TRejectUser,TBillAuditUser,TOrigin,TFromDept,TProvider,TBuyLoc,TBuyUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TNum,TFee,TApproveStep,TApproveRole,TRow,TListInfo,TApprovals,TFinanceType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStock
	s (TRowID,TInDate,TLocDR,TRejectReasonDR,TRequestUserDR,TRequestDate,TAuditUserDR,TAuditDate,TRejectUserDR,TRejectDate,TStatus,TRemark,TBillAuditUserDR,TBillAuditDate,TInStockNo,TOriginDR,TFromDeptDR,TProviderDR,TLoc,TRejectReason,TRequestUser,TAuditUser,TRejectUser,TBillAuditUser,TOrigin,TFromDept,TProvider,TBuyLocDR,TBuyLoc,TBuyUserDR,TBuyUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TNum,TFee,CurRole,TApproveStep,TApproveRole,TListInfo,TApprovals,TFinanceTypeDR,TFinanceType)=""
	quit
}

ClassMethod GetInStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockExecute ]
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

ClassMethod GetInStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:根据设备入库单的状态显示入库单明细信息
/// ----------------------------------
Query GetInStockListNew(RowID) As %Query(ROWSPEC = "TStatCat:%String,TItemDR:%String,TTotalFee:%String,TInvoiceNos:%String,TInvoiceDate:%String,TInvoiceFee:%String,TRowID:%String,TInStockDR:%String,TEquipDR:%String,TBatchFlag:%String,TBuyPlanListDR:%String,TManuFactoryDR:%String,TOriginalFee:%String,TQuantityNum:%String,TModelDR:%String,TUnitDR:%String,THold1:%String,TRemark:%String,TAppendFee:%String,TEquipCatDR:%String,TUserYearsNum:%String,TInStock:%String,TEquip:%String,TBuyPlanList:%String,TManuFactory:%String,TModel:%String,TUnit:%String,TEquipCat:%String,TMaxInStockNum:%String,TSourceType:%String,TSourceID:%String,TRow:%String,TStatCatDR:%String,TCommonName:%String,THold5:%String,THold5Desc:%String")
{
}

ClassMethod GetInStockListNewExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	new rowid,TRow,TotalFlag,TotalQty,Total,InStockDR
	s (TotalQty,Total)=0
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	s TRow=0
	s InStockDR=RowID
	if InStockDR'=""  d
	.s rowid=0 
	.f  s rowid=$o(^DHCEQInStockList(0,"InStock",InStockDR,rowid))  quit:rowid=""  d
	..d ResetVariablesGetInStockListNew
	..s TRowID = rowid
	..s TInStockDR = $p($g(^DHCEQInStockList(rowid)),"^",1)
	..s TEquipDR = $p($g(^DHCEQInStockList(rowid)),"^",2)
	..i TEquipDR '=""  d
	...s TStockStatus = $p($g(^DHCEQEquip(TEquipDR)),"^",60)
	..s TBatchFlag = $p($g(^DHCEQInStockList(rowid)),"^",3)
	..s TBuyPlanListDR = $p($g(^DHCEQInStockList(rowid)),"^",4)
	..i TBuyPlanListDR'="" s TMaxInStockNum=..GetArriveNum(TBuyPlanListDR)
	..s TCommonName= $p($g(^DHCEQInStockList(rowid)),"^",5)	//2013-06-24 DJ0118
	..s TManuFactoryDR = $p($g(^DHCEQInStockList(rowid)),"^",6)
	..i TManuFactoryDR '=""  d
	...s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by czf 1252357
	..s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(rowid)),"^",7),"")
	..s TQuantityNum = $p($g(^DHCEQInStockList(rowid)),"^",8)
	..i TOriginalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantityNum,"")
	..;s TotalQty=TotalQty+TQuantityNum	// Mozy0217  2018-11-01
	..;s Total=Total+TTotalFee
	..s TModelDR = $p($g(^DHCEQInStockList(rowid)),"^",9)
	..i TModelDR '=""  d
	...s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TUnitDR = $p($g(^DHCEQInStockList(rowid)),"^",10)
	..i TUnitDR '=""  d
	...s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",(TUnitDR))
	..s TQuantityNum=TQuantityNum   //_" "_TUnit
	..s THold1 = $p($g(^DHCEQInStockList(rowid)),"^",11)
	..s TRemark = $p($g(^DHCEQInStockList(rowid)),"^",12)
	..s TAppendFee = $p($g(^DHCEQInStockList(rowid)),"^",13)
	..s TEquipCatDR = $p($g(^DHCEQInStockList(rowid)),"^",14)
	..i TEquipCatDR '=""  d
	...s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	..s TUserYearsNum = $p($g(^DHCEQInStockList(rowid)),"^",15)
	..s TItemDR=$p($g(^DHCEQInStockList(rowid)),"^",16)
	..i TItemDR'="" d
	...s TEquip=$P($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1) //2013-06-24 DJ0118
	...s TStatCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",TItemDR),"^",5)
	..i TEquipDR'="" d
	...s TStatCatDR=$P(^DHCEQEquip(TEquipDR),"^",75)
	..s TStatCatDR=$p($g(^DHCEQInStockList(rowid)),"^",17)
	..s TSourceType=$p($g(^DHCEQInStockList(rowid)),"^",18)
	..;s TSourceType=$CASE(TSourceType,"0":"设备","1":"设备项","2":"验收单","":"")
	..s TSourceID=$p($g(^DHCEQInStockList(rowid)),"^",19)
	..s THold2=$p($g(^DHCEQInStockList(rowid)),"^",20)
	..s THold3=$p($g(^DHCEQInStockList(rowid)),"^",21)
	..s THold4=$p($g(^DHCEQInStockList(rowid)),"^",22)
	..// Mozy0217  2018-11-01
	..i THold4="" d
	...s TotalQty=TotalQty+TQuantityNum
	...s Total=Total+TTotalFee
	..s THold5=$p($g(^DHCEQInStockList(rowid)),"^",23)
	..;// add by csy 2017-07-21 友谊医院和北京中医入库时经费来源能填写或修改
	..i THold5'=""  d
	...s THold5Desc=$p($g(^DHCEQCCode("DHCEQCExpenditures",THold5)),"^",2)
	..i TStatCatDR'="" d
	...s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	..s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,rowid)
	..s TInvoiceNos=$p(return,"^",1)
	..s TInvoiceDate=$p(return,"^",2)
	..s TInvoiceFee=$p(return,"^",3)
	..s TRow=TRow+1
	..d OutputRowGetInStockListNew
	
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetInStockListNew
	.s TRow=1
	.d OutputRowGetInStockListNew
	
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetInStockListNew
	.s TRowID=-1
	.s TEquipName="合计:"
	.s TQuantityNum=TotalQty
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Total,"")
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.d OutputRowGetInStockListNew
	Quit $$$OK
	
OutputRowGetInStockListNew
	s Data=$lb(TStatCat,TItemDR,TTotalFee,TInvoiceNos,TInvoiceDate,TInvoiceFee,TRowID,TInStockDR,TEquipDR,TBatchFlag,TBuyPlanListDR,TManuFactoryDR,TOriginalFee,TQuantityNum,TModelDR,TUnitDR,THold1,TRemark,TAppendFee,TEquipCatDR,TUserYearsNum,TInStock,TEquip,TBuyPlanList,TManuFactory,TModel,TUnit,TEquipCat,TMaxInStockNum,TSourceType,TSourceID,TRow,TStatCatDR,TCommonName,THold5,THold5Desc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockListNew
	s (TStatCatDR,TStatCat,TItemDR,TTotalFee,TInvoiceNos,TInvoiceDate,TInvoiceFee,TRowID,TInStockDR,TEquipDR,TBatchFlag,TBuyPlanListDR,TManuFactoryDR,TOriginalFee,TQuantityNum,TModelDR,TUnitDR,THold1,TRemark,TAppendFee,TEquipCatDR,TUserYearsNum,TInStock,TEquip,TBuyPlanList,TManuFactory,TModel,TUnit,TEquipCat,TMaxInStockNum,TSourceType,TSourceID,TCommonName,THold5,THold5Desc)=""
	quit
}

ClassMethod GetInStockListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListNewExecute ]
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

ClassMethod GetInStockListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ----------------------------------
/// 修改:Mozy 2012-02-21  Mozy0076
/// 描述:调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:根据条件选取验收单
/// ----------------------------------
Query GetOpenCheckList(EquipTypeDR As %String = "", StatCatDR As %String = "", ProviderDR As %String = "", OriginDR As %String = "", Equip As %String = "", QXType As %String = "") As %Query(ROWSPEC = "hidden:%String, hidden:%String, EQName:%String, Status:%String, ISNo:%String, EquipType:%String, StatCat:%String, APC:%String, Model:%String,Price:%String,RequestLoc:%String,CommonName:%String")
{
}

ClassMethod GetOpenCheckListExecute(ByRef qHandle As %Binary, EquipTypeDR As %String = "", StatCatDR As %String = "", ProviderDR As %String = "", OriginDR As %String = "", Equip As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	s Equip=$ZCONVERT(Equip,"U")
	s vEquipTypeDR=0
	f  s vEquipTypeDR=$o(^DHCEQOpenCheckRequest(0,"Status",0,vEquipTypeDR)) q:vEquipTypeDR=""  d
	.q:((EquipTypeDR'="")&&(vEquipTypeDR'=EquipTypeDR))
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(vEquipTypeDR)'="0"
	.s rowid=0
	.f  s rowid=$o(^DHCEQOpenCheckRequest(0,"Status",0,vEquipTypeDR,2,rowid)) q:rowid=""  d
	..d ResetVariablesGetOpenCheckList
	..
	..;Modified By JDL 2011-10-12 JDL0098 过滤掉已经删除的验收单
	..q:($p($g(^DHCEQOpenCheckRequest(rowid)),"^",45)="Y")
	..
	..s TStatCatDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",4) 				//设备类型DR
	..q:((StatCatDR'="")&&(StatCatDR'=TStatCatDR))
	..s TProviderDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",5)				//供应商DR
	..q:((ProviderDR'="")&&(ProviderDR'=TProviderDR))
	..s TOriginDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",8)				//来源DR
	..q:((OriginDR'="")&&(OriginDR'=TOriginDR))
	..
	..s APC=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	..s EquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",vEquipTypeDR)),"^",2)
	..s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	..
	..s OCLRowid=0
	..f  s OCLRowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,OCLRowid)) q:OCLRowid=""  d
	...q:##Class(web.DHCEQFinance2019).BussFilter(11,OCLRowid)'=0   //Add By QW 2019-01-14  bug:QW0025  比较设备项与业务单据类组是否一致
	...s CommonName=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",2)		//CommonName 2013-06-24 DJ0118 begin
	...s EQName=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",9)
	...i EQName'="" s EQName=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQName)),"^",1) //2013-06-24 DJ0118 end
	...s EQCode=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",8)						//Name
	...q:(Equip'="")&&(($ZCONVERT(EQName,"U")'[Equip)&&($ZCONVERT(EQCode,"U")'[Equip))
	...s StoreLocDR=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",31) //设备库房 2010-10-26 DJ begin
	...s Flag=0
	...i StoreLocDR'=""  d
	....s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR) //2010-10-26 DJ
	...q:Flag'=0
	...s Status="N"
	...s ISStatus=""
	...s ISNo=""
	...s ISLRowid=0
	...f  s ISLRowid=$o(^DHCEQInStockList(0,"Source",2,OCLRowid,ISLRowid)) q:ISLRowid=""  d
	....s ISNo=$p($g(^DHCEQInStockList(ISLRowid)),"^",1)
	....s ISStatus=$p($g(^DHCEQInStock(ISNo)),"^",10)
	....s ISInvalidFlag=$p($g(^DHCEQInStock(ISNo)),"^",25)
	....i ISInvalidFlag="Y"  d
	.....s ISNo=""
	....e  d
	.....s ISNo=$p($g(^DHCEQInStock(ISNo)),"^",14)
	.....s Status="Y"
	...
	...q:ISStatus>1  //实物入库
	...
	...//add by jdl 2010-12-09 JDL0062
	...s Model=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",5)
	...i Model'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	...s Price=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",17)
	...s RequestLocDR=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",33)  //2012-03-12 DJ
	...i RequestLocDR'="" s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLocDR)
	...d OutputRowGetOpenCheckList
	Quit $$$OK
OutputRowGetOpenCheckList	
	set Data=$lb(rowid,OCLRowid,EQName, Status, ISNo, EquipType, StatCat, APC, Model,Price,RequestLoc,CommonName)		; Mozy0076 2012-02-21	调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheckList
	s (EQName, Status, ISNo, EquipType, StatCat, APC,Model,Price,RequestLoc,CommonName)=""
	quit
}

ClassMethod GetOpenCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckListExecute ]
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

ClassMethod GetOpenCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ???
ClassMethod GetArriveNum(BPLID)
{
	s ExecNum=$p(^DHCEQBuyPlanList(BPLID),"^",11)
	s ArriveNum=$p(^DHCEQBuyPlanList(BPLID),"^",17)
	i ExecNum="" s ExecNum=0
	i ArriveNum="" s ArriveNum=0
	q ExecNum-ArriveNum
}

/*
ClassMethod StatusList(name, width) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	//w "<option value=0>设备</option>"
	w "<option value=1>设备项</option>"
	w "<option value=2>验收单</option>"
	w "</select>",!
}
*/
/// ???
/// 描述:根据验收单rowid取验收单信息
/// ----------------------------------
ClassMethod GetOpenCheckInfo(rowid)
{
	if rowid="" q ""
	new result,resultex
	s (result,resultex)=""
	s OCLRowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
	if OCLRowid="" q ""
	s result= ^DHCEQOpenCheckList(OCLRowid)
	s TOriginDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",8)		//TOriginDR
	s resultex=resultex_"^"	;
	
	i $p(result,"^",5)'=""  d  //TModel
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",5))),"^",2)
	s resultex=resultex_"^"	;
	i $p(result,"^",6)'=""  d  //TEquiCatDR
	.s resultex=resultex_$p(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",6)),"^",2)
	s resultex=resultex_"^"	;
	i $p(result,"^",7)'=""  d  //TUnitDR
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("uom",($p(result,"^",7)))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	s resultex=resultex_"^"	;
	i $p(result,"^",15)'=""  d  	//TManuFactoryDR
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^",15))		//modified by czf 1252357
	s resultex=resultex_"^"	;
	i $p(result,"^",28)'=""  d  	//TStatCatDR
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",28))),"^",2)
	s resultex=resultex_"^" ;	//2013-06-24 DJ0118 begin
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",9))),"^",1) //2013-06-24 DJ0118 end
   	// add by csy 2017-07-21 友谊医院和北京中医入库时经费来源能填写或修改 begin 
	s resultex=resultex_"^" ;
	i $p(result,"^",59)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCExpenditures",$p(result,"^",59))),"^",2) 
	s result=OCLRowid_"^"_result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:新增、更新数据
/// ----------------------------------
ClassMethod SaveData(val, valList, DelRowid)
{
	new (val, valList, DelRowid)
	Set $ZT="ERRORSave"
	s Date=+$H
	s RowID=$P(val,"^",1)
	i RowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQInStock(RowID)),"^",25) //2011-10-31 DJ DJ0098
		i InvalidFlag="Y" q -1015 //2011-10-31 DJ DJ0098
	}
	s PLIST(2) = $p(val,"^",2)	;InDate
 	i $p(val,"^",2)'=""  s PLIST(2) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",2),"date")	;InDate
 	s PLIST(3) = $p(val,"^",3)	;LocDR
 	//s PLIST(4) = $p(val,"^",4)	;RejectReasonDR
 	
 	;Modified by jdl 2011-3-2  jdl0071
 	s PLIST(5) = $p(val,"^",5)	;RequestUserDR
 	s PLIST(6) = Date	;RequestDate
 	//s PLIST(7) = $p(val,"^",7)	;AuditUserDR
 	//s PLIST(8) = $p(val,"^",8)	;AuditDate
 	//s PLIST(9) = $p(val,"^",9)	;RejectUserDR
 	//s PLIST(10) = $p(val,"^",10)	;RejectDate 	
 	s PLIST(11) = "0"	;Status
 	s PLIST(12) = $p(val,"^",12)	;Remark
 	//s PLIST(13) = $p(val,"^",13)	;BillAuditUserDR
 	//s PLIST(14) = $p(val,"^",14)	;BillAuditDate 	
 	s PLIST(15) = $p(val,"^",15)	;InStockNo
 	s PLIST(16) = $p(val,"^",16)	;OriginDR
 	s PLIST(17) = $p(val,"^",17)	;FromDeptDR
 	s PLIST(18) = $p(val,"^",18)	;ProviderDR
 	s PLIST(19) = $p(val,"^",20)	;BuyLocDR
 	s PLIST(20) = $p(val,"^",21)	;BuyUserDR
 	s PLIST(21) = $p(val,"^",22)	;EquipTypeDR
 	s PLIST(22) = $p(val,"^",23)	;StatCatDR
 	s PLIST(26) = "N"
 	// Mozy0064	2011-10-24
 	Set PLIST(27) = $Piece(val,"^",24)	;RejectReason
 	Set PLIST(28) = $Piece(val,"^",25)	;Hold1
 	Set PLIST(29) = $Piece(val,"^",26)	;Hold2
 	Set PLIST(30) = $Piece(val,"^",27)	;Hold3
 	Set PLIST(31) = $Piece(val,"^",28)	;Hold4
 	Set PLIST(32) = $Piece(val,"^",29)	;Hold5
	TSTART	
 	if RowID=""
 	{
		i PLIST(15)="" s PLIST(15)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",Date,$p(val,"^",3),$p(val,"^",22))
		&SQL(insert into sqluser.DHC_EQInStock values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	;Modified by jdl 2011-8-17 JDL0090 调整顺序，先删除明细，再保存明细
 	s SQLCODE=..DeleteInStockList(DelRowid)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
 	s SQLCODE=..SaveInStockList(RowID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORSave 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// Modified By HZY 2012-02-07 HZY0021
/// Desc:删除入库单的同时,删除对应入库明细的资金来源记录.
/// ----------------------------------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:删除入库单
/// w ##Class(web.DHCEQInStockNew).DeleteData("205^^1^^5^1^^")
ClassMethod DeleteData(val)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;Modified By JDL 2011-10-12 JDL0098 保留变量User
	new (val,User)
	Set $ZT="ERRORDelete"
	s RowID=$P(val,"^",1)
	s Date=+$H
	s Time=$P($H,",",2)
	i RowID="" q ""
	
	s SQLCODE=0
	TSTART
	&SQL(Update SQLUSER.DHC_EQInStock Set IS_InvalidFlag='Y',IS_CancelUser=:User,IS_CancelDate=:Date,IS_CancelTime=:Time where IS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//删除对应入库明细的资金来源记录. Start Add By HZY 2012-02-07 HZY0021
	s listRowID=0
	f  s listRowID=$o(^DHCEQInStockList(0,"InStock",RowID,listRowID))  q:(listRowID="")||(SQLCODE'=0)  d
	.i ($p($g(^DHCEQInStockList(listRowID)),"^",18)=1)   d  //来源类型为设备项时,要删除对应入库明细的资金来源记录
	..s fundsRowID=0
	..f  s fundsRowID=$o(^DHCEQFunds("0","Source",3,listRowID,fundsRowID))  q:(fundsRowID="")||(SQLCODE'=0)  d
	...&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_RowID=:fundsRowID )
	if (SQLCODE'=0)
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
	}
	//End Add By HZY 2012-02-07 HZY0021
 	q SQLCODE
ERRORDelete 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:提交
/// w ##Class(web.DHCEQInStockNew).SubmitData("148^^1^^16^2^^",2)
ClassMethod SubmitData(val, OutFlag As %Library.String = "0")
{
	new (val, InFlag,OutFlag, %session)  //ZX0035 清空session值后,影响消息生成
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s InvalidFlag=$p($g(^DHCEQInStock(RowID)),"^",25) //2011-10-31 DJ DJ0098
	i InvalidFlag="Y" q -1015 //2011-10-31 DJ DJ0098
	
	Set $ZT="ERRORSubmit"
	;s RejectReasonDR=$P(val,"^",2)
	s User=$P(val,"^",3)
	s Remark=$P(val,"^",4)
	
	s Date=+$H
	s LocDR=$p($g(^DHCEQInStock(RowID)),"^",2)
	s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
  	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,LocDR)) q -1005   //判断入库单中的科室类型是否属于库房
  	
	s PLIST(7) = User	;AuditUserDR
 	s PLIST(8) = Date	;AuditDate
	s PLIST(11)="1"		;Status
	s PLIST(12)=Remark	
	//add by zy 20120316  zy0091
	s ReturnProvider=##class(web.DHCEQInStockNew).ProviderIsUniqueNew("InStock",RowID)
	i ReturnProvider<0 q ReturnProvider
	
	s EquipTypeDR=$p($g(^DHCEQInStock(RowID)),"^",20)
	s StatCatDR=$p($g(^DHCEQInStock(RowID)),"^",21)	
	s ReturnEquipType=..EquipTypeIsUniqueNew(RowID,EquipTypeDR,"InStock")	
	i ReturnEquipType<0 q ReturnEquipType
	
	s Flag=##class(web.DHCEQCommon).GetSysInfo("301007")   //单据中设备类型是否需要一致
	if (Flag=1)
	{
		s ReturnType=..StatCatIsUniqueNew(RowID,StatCatDR)
		i ReturnType<0 q ReturnType
	} 
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("13")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;AppInfoStatus
	
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s PLIST(11)="2"		;Status
		s PLIST(13)=User	;BillAuditUserDR
		s PLIST(14)=Date	;BillAuditDate
		Set AppInfoStatus="2"			;AppInfoStatus
	}
	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"13",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}

	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=..LastAuditAction(RowID, User, Date,OutFlag)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}		
	}
	;Modified by jdl 2011-3-2  jdl0071
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:反提交
/// w ##Class(web.DHCEQInStockNew).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole, %session)  //ZX0035 清空session值后,影响消息生成
	Set $ZT="ERRORCancel"
	s RowID=$P(val,"^",1)
	q:RowID=""
	s RejectReasonDR=$P(val,"^",2)
	s User=$P(val,"^",3)
	s Remark=$P(val,"^",4)
	s CancelToFlowDR=$P(val,"^",7)
	s ApproveSet=$P(val,"^",8)
	s Date=+$H
	// Mozy0064	2011-10-24
	Set RejectReason=$PIECE(val,"^",9)
	;获取取消到上一步的信息
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}	 	

	
	s PLIST(4)=RejectReasonDR
	//s PLIST(9)=User		;RejectUserDR
	//s PLIST(10)=Date	;RejectDate
	s PLIST(11)=Status
	s PLIST(12)=Remark
	//Set PLIST(27)=RejectReason		// Mozy0064	2011-10-24
	TSTART
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("13")
	
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("13", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RejectReason,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	else
	{
		;Modified by jdl 2011-3-2  jdl0071
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
			
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow, "Y",CurRole)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	TCOMMIT
 	s ID=RowID
 	q ID
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// Mozy0185	增加自动出库审核标志
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:审核
/// w ##Class(web.DHCEQInStockNew).AuditData("202^^1^^5^1^^28","13","2","202^,3^,4@455^1111113434,1^11111343434,2")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo, OutFlag As %Library.String = "0")
{
	new (val, CurRole,RoleStep, editFieldsInfo, %session,OutFlag)  //ZX0035 清空session值后,影响消息生成
	n EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,Date,RowID,AuditFlag,PLIST
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s User=$P(val,"^",3)
	s Date=+$H
	
	s EquipType=$p($g(^DHCEQInStock(RowID)),"^",20)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("13")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("13", RowID)	
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;AppInfoStatus	
	
	TSTART
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQInStock(RowID)),"^",10)=2)
		{
			TROLLBACK
			q -1010
		}
		s AuditFlag=1
		s PLIST(11)="2"
		s PLIST(13)=User	;BillAuditUserDR
		s PLIST(14)=Date	;BillAuditDate
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		
		Set AppInfoStatus="2"			;AppInfoStatus
	}
	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=..LastAuditAction(RowID, User, Date,OutFlag)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}		
	}
	;Modified by jdl 2011-3-2  jdl0071		
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:写入入库单明细
/// 入参： ISRowID：入库单ID
/// w ##Class(web.DHCEQInStockNew).SaveInStockList("65","1^100^10403&1^100^10403")
ClassMethod SaveInStockList(ISRowID, val)
{
	new Length,ISLRowID,Flag,i,InvoiceNo,InvoiceDate,InvoiceFee
	n valList,TSourceType,TSourceID
	k PLISTMX
	i val="" q 0
	i ISRowID="" q -1
	
	s Length=$l(val,"&")
	s PLISTMX(2)=ISRowID  				;InStockDR
	
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s ISLRowID= $p(valList,"^",2)
		;s PLISTMX(3)=$p(valList,"^",3)  	;EquipDR
		;s PLISTMX(4)="Y"					;BatchFlag
		;s PLISTMX(5)=$p(valList,"^",)		;BuyPlanListDR
		s PLISTMX(6)=$p(valList,"^",25)  	;EquipName	//2013-06-24 DJ0118
		s PLISTMX(7)=$p(valList,"^",5)  	;TManuFactoryDR
		s PLISTMX(8)=$p(valList,"^",6)  	;TOriginalFee
		s PLISTMX(9)=$p(valList,"^",7)  	;TQuantityNum
		s PLISTMX(10)=$p(valList,"^",8)  	;TModelDR
		s PLISTMX(11)=$p(valList,"^",9)  	;TUnitDR
		
		s PLISTMX(13)=$p(valList,"^",10)  	;TRemark
		//s PLISTMX(14)=$p(valList,"^",)	;AppendFee
		s PLISTMX(15)=$p(valList,"^",11)  	;TEquipCatDR
		s PLISTMX(16)=$p(valList,"^",12)  	;TUserYearsNum
		;s PLISTMX(17)=$p(valList,"^",13)  	;TItemDR
		s PLISTMX(18)=$p(valList,"^",14)  	;TStatCatDR
		s TSourceType=$p(valList,"^",15)
		s TSourceID=$p(valList,"^",16)
		s PLISTMX(19)=TSourceType 	;TSourceType
		s PLISTMX(20)=TSourceID 	;TSourceID
		i TSourceType="1"
		{
			s PLISTMX(17)=TSourceID  	;TItemDR
		}
		elseif (TSourceType="2")
		{
			;Modified by JDL 2012-2-23 补充Mozy0076
			;首先判断验收单还是否有效存在
			if TSourceID="" s Flag=-1016
			q:Flag'=0
			s OCRowID=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",1)
			if $g(^DHCEQOpenCheckRequest(OCRowID))="" s Flag=-1016
			q:Flag'=0
			if $p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",45)="Y" s Flag=-1016	;OCR_InvalidFlag
			q:Flag'=0
			
			s PLISTMX(17)=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",9)  	;TItemDR
			//modified by zy 2011-10-10   zy0081
			s tmpISLRowID=0
			for  s tmpISLRowID=$o(^DHCEQInStockList(0,"Source",TSourceType,TSourceID,tmpISLRowID))  q:(tmpISLRowID="")||(Flag'=0)  d
			.s tmpISRowID=$p($g(^DHCEQInStockList(tmpISLRowID)),"^",1)
			.s InvalidFlag=$p($g(^DHCEQInStock(tmpISRowID)),"^",25)
			.q:InvalidFlag="Y"
			.if tmpISLRowID'=ISLRowID s Flag="-1"
			.;q "本单据已经录入该设备"	
		
			;i $o(^DHCEQInStockList(0,"Source",TSourceType,TSourceID,0))'=ISLRowID s Flag="-1"
			
		}
		elseif (TSourceType="3")
		{
			;Add By ZY ZY0103 直接从计划单，入库
			if TSourceID="" s Flag=-1019
			q:Flag'=0
			s BPRowID=$p($g(^DHCEQBuyPlanList(TSourceID)),"^",1)
			if $g(^DHCEQBuyPlan(BPRowID))="" s Flag=-1019
			q:Flag'=0
			if $p($g(^DHCEQBuyPlan(BPRowID)),"^",46)="Y" s Flag=-1019	;OCR_InvalidFlag
			q:Flag'=0
			
			s PLISTMX(17)=$p($g(^DHCEQBuyPlanList(TSourceID)),"^",18)  	;TItemDR
			s tmpISLRowID=0
			for  s tmpISLRowID=$o(^DHCEQInStockList(0,"Source",TSourceType,TSourceID,tmpISLRowID))  q:(tmpISLRowID="")||(Flag'=0)  d
			.s tmpISRowID=$p($g(^DHCEQInStockList(tmpISLRowID)),"^",1)
			.s InvalidFlag=$p($g(^DHCEQInStock(tmpISRowID)),"^",25)
			.q:InvalidFlag="Y"
			.if tmpISLRowID'=ISLRowID s Flag="-1"
		
			
		}
		q:Flag'=0
		
 		s InvoiceNo=$p(valList,"^",17)
 		s InvoiceDate=$p(valList,"^",18)
 		s InvoiceFee=$p(valList,"^",19)
 		
 		s PLISTMX(12)=$p(valList,"^",20)		;Hold1
 		s PLISTMX(21)=$p(valList,"^",21)		;Hold2
 		s PLISTMX(22)=$p(valList,"^",22)		;Hold3
 		s PLISTMX(23)=$p(valList,"^",23)		;Hold4
 		s PLISTMX(24)=$p(valList,"^",24)		;Hold5
 		;b
		if (ISLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQInStockList Values :PLISTMX())
			s ISLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQInStockList values :PLISTMX() where ISL_RowID=:ISLRowID)
		}
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		q:Flag'=0
		
		s SQLCODE=..UpdateInvoiceInfo(ISLRowID, InvoiceNo, InvoiceDate, InvoiceFee)
 		i SQLCODE
		{
			s Flag=SQLCODE
		}
		
	}
	q Flag
}

/// Modified By HZY 2012-02-08 HZY0021
/// Desc:修改函数,在删除入库单明细的同时将明细对应的资金来源记录无效掉.
/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:删除入库单明细
/// w ##Class(web.DHCEQInStockNew).DeleteInStockList("65"," ,0,0,0")
ClassMethod DeleteInStockList(DelRowIDs)
{
	new Length,ISLRowID,Flag,i
	
	i DelRowIDs="" q 0
	
	s Flag=0
	s Length=$l(DelRowIDs,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s ISLRowID=$p(DelRowIDs,",",i)
		if (ISLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQInStockList where ISL_RowID=:ISLRowID)
			i SQLCODE s Flag=SQLCODE
			q:Flag'=0
			s fundsRowID=0
			f  s fundsRowID=$o(^DHCEQFunds("0","Source",3,ISLRowID,fundsRowID))  q:((fundsRowID="")||(Flag'=0))  d
			.&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_RowID=:fundsRowID )	//无效掉入库明细对应的资金来源记录.2012-02-08 HZY0021
			.s Flag=SQLCODE
		}
	}
	q Flag
}

/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:修改发票信息
/// 访问表:DHC_EQInvoice,DHC_EQInvoiceUseMap
/// w ##Class(web.DHCEQInStockNew).UpdateInvoiceInfo
/// ----------------------------------
ClassMethod UpdateInvoiceInfo(ISLRowID, Invoice, InvoiceDate, InvoiceFee, IUMType As %String = "")
{
	new ISRowID,ProviderID,ISStatus,IUMRowID,InvoiceID
	new OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee,RowID,Times
	

	s (OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee)=""
	i IUMType="6"  d		//Add By DJ 2016-08-16
	.s ISRowID=$P(^DHCEQOpenCheckList(ISLRowID),"^",1)
	.s ProviderID=$P(^DHCEQOpenCheckRequest(ISRowID),"^",5)
	.s ISStatus=$P(^DHCEQOpenCheckRequest(ISRowID),"^",20)
	e  d
	.s IUMType=1
	.s ISRowID=$P(^DHCEQInStockList(ISLRowID),"^",1)
	.s ProviderID=$P(^DHCEQInStock(ISRowID),"^",17)
	.s ISStatus=$P(^DHCEQInStock(ISRowID),"^",10)
	
	s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",IUMType,ISLRowID,0))
	s InvoiceDate=##class(web.DHCEQCommon).TransValueFromPage(InvoiceDate,"date")
	k INPLIST
	s INPLIST(3)=Invoice
	s INPLIST(4)=InvoiceDate
	s INPLIST(5)=InvoiceFee
	s INPLIST(11)="0" //Status
	s INPLIST(6)=ProviderID
	s INPLIST(17)="N"
	
	;获取原来的发票信息
	i IUMRowID'=""
	{		
		s OldInvoiceID=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
		s OldInvoiceNo=$p(^DHCEQInvoice(OldInvoiceID),"^",2)
		s OldInvoiceDate=$p(^DHCEQInvoice(OldInvoiceID),"^",3)
		s OldInvoiceFee=$p(^DHCEQInvoice(OldInvoiceID),"^",4)
	}
	;获取新的发票ID
	s InvoiceID=""
	i Invoice'=""
	{
		s RowID=0
		f  s RowID=$o(^DHCEQInvoice(0,"InvoiceNo",Invoice,RowID)) q:((RowID="")||(InvoiceID'=""))  d
		.q:$p(^DHCEQInvoice(RowID),"^",16)'="N"
		.i ProviderID=$p(^DHCEQInvoice(RowID),"^",5) s InvoiceID=RowID		
	}
	
	i InvoiceID'=""
	{
		s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,ISLRowID,InvoiceID)
		i Times>0
		{
			;该发票与原有信息不符!
			i (InvoiceDate'="")&&(InvoiceDate'=$p(^DHCEQInvoice(InvoiceID),"^",3)) q -1008
			i (InvoiceFee'="")&&(InvoiceFee'=$p(^DHCEQInvoice(InvoiceID),"^",4)) q -1008				
		}
		;发票已经提交
		i $p(^DHCEQInvoice(InvoiceID),"^",10)="2" q -1009
		&SQL(update sqluser.DHC_EQInvoice values INPLIST() where IV_RowID=:InvoiceID)
	}
	else
	{
		i Invoice'=""
		{
			&SQL(insert into sqluser.DHC_EQInvoice values INPLIST())
			if SQLCODE q SQLCODE
			s InvoiceID=$G(%ROWID)
			;q "InvoiceID"_InvoiceID
		}
	}	
	
	;处理原来发票		
	i (OldInvoiceID'="")&&(OldInvoiceID'=InvoiceID)
	{
		;删除对照
		&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_RowID=:IUMRowID)
		if SQLCODE<0 q SQLCODE
		s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,ISLRowID,OldInvoiceID)
		;没有其他单据使用则删除发票
		i Times=0
		{
			&SQL(delete from sqluser.DHC_EQInvoice where IV_RowID=:OldInvoiceID)
		}
		if SQLCODE<0 q SQLCODE			
	}
	;增加新发票对照
	i ((InvoiceID'="")&&(OldInvoiceID'=InvoiceID))
	{
		k INMPLIST
		s INMPLIST(2)=ISLRowID
		s INMPLIST(3)=InvoiceID
		s INMPLIST(4)=IUMType
		&SQL(insert into sqluser.DHC_EQInvoiceUseMap values INMPLIST())
		if SQLCODE
		{
			q SQLCODE
		}
	}	
	q 0
}

/// 生成该入库单的相应
/// 		设备变动信息记录
/// 		生成或修改设备信息
ClassMethod ChangeStock(RowID, User, Date)
{
	//modified by zy ZY0191  20191010  把其他变量给初始化了
	//new (RowID, User, Date)
	s Time=$P($H,",",2)
	
	s EQPL(39)="0" //设备状态
	s EQPL(48)="N" //直接手工录入
	s EQPL(61)="1" //库房状态
	s EQPL(60)="N" //无效标志
	s EQPL(68)=$P(^DHCEQInStock(RowID),"^",2) //库房
	
	//add by jdl 2010-10-13 JDL0053
	s EQPL(46)=Date
	
	s DepreMehtod=##class(web.DHCEQCommon).GetSysInfo("301002")	
	
	s CSSQLCODE=0
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",RowID,ISLRowID))  quit:(ISLRowID="")||(CSSQLCODE'=0)  d
	.s EQPL(71)=ISLRowID //入库明细
	.s EQPL(5)=$P(^DHCEQInStockList(ISLRowID),"^",14) //设备分类
	.s EQPL(32)=$P(^DHCEQInStockList(ISLRowID),"^",15) //使用年限
	.s EQPL(44)=$P(^DHCEQInStockList(ISLRowID),"^",13) //附加费用
	.s EQPL(96)=$P(^DHCEQInStockList(ISLRowID),"^",23) //经费来源 add by csy 2017-07-25
	.s EquipNum=$P(^DHCEQInStockList(ISLRowID),"^",8) //设备数量
	.
	.s SourceType=$p(^DHCEQInStockList(ISLRowID),"^",18)
	.s SourceID=$P(^DHCEQInStockList(ISLRowID),"^",19)
	.;设置折旧方法
	.i SourceType="0"  d
	..i $P(^DHCEQEquip(SourceID),"^",33)="" s EQPL(34)=DepreMehtod
	.else  if SourceType="1" d
	..s EQPL(34)=DepreMehtod
	.else  if SourceType="2" d
	..i $P(^DHCEQOpenCheckList(SourceID),"^",20)="" s EQPL(34)=DepreMehtod
	..//modified by zy ZY0191  20191010  在入库的时候写台帐
	..//生成台帐时间点','0,验收审核;1,入库审核;'
	..s InsertEquipFlag=+##class(web.DHCEQCommon).GetSysInfo("990074")
	..i InsertEquipFlag=1 d
	...q:$P(^DHCEQInStockList(ISLRowID),"^",22)'=""	// ISLHold4 czf 2022-04-24 过滤附属设备，防止生成多次台账
	...s OCRRowID=$P(^DHCEQOpenCheckList(SourceID),"^",1)
	...s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRRowID,0))
	...s CSSQLCODE=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).SaveEquipData(OCRRowID, OCLRowID, User, Date,Time)
	..q:CSSQLCODE'=0
	..
	..//add by zy 2017-04-27 ZY0163 入账未入账处理
	..s AccountShapeFlag=+##class(web.DHCEQCommon).GetSysInfo("990057")
	..i AccountShapeFlag=1  d
	...i $P(^DHCEQOpenCheckList(SourceID),"^",69)="0"  d
	....s EQPL(46)=""
	...e  d
	....s AcountList=""
	....s AcountList=AcountList_"^"_ISLRowID
	....s AcountList=AcountList_"^"_$P(^DHCEQInStock(RowID),"^",20)
	....s AcountList=AcountList_"^"_$P(^DHCEQInStockList(ISLRowID),"^",17)
	....s AcountList=AcountList_"^"_$P(^DHCEQInStockList(ISLRowID),"^",14)
	....s AcountList=AcountList_"^"_$P(^DHCEQInStockList(ISLRowID),"^",15)
	....s AcountList=AcountList_"^"_"验收入账"
	....s AcountList=AcountList_"^"
	....s AcountList=AcountList_"^"
	....s AcountList=AcountList_"^"
	....s AcountList=AcountList_"^"
	....s AcountList=AcountList_"^"
	....s CSSQLCODE=##Class(web.DHCEQAccountList).SaveData(AcountList,"")
	..
	.else  if SourceType="3" d
	..s EQPL(34)=DepreMehtod
	.q:CSSQLCODE'=0	////add by zy 2017-04-27 ZY0163 入账未入账处理
	.s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")		//2014-12-16 DJ	DJ0131
	.i (SourceType="1")||(SourceType="3")  d
	..s EQPL(53)=User //新增人
	..s EQPL(54)=Date //新增时间
	..s EQPL(2)=$P(^DHCEQInStockList(ISLRowID),"^",5) //设备名称
	..s EQPL(27)=$P(^DHCEQInStockList(ISLRowID),"^",6) //生产厂商
	..s EQPL(28)=$P(^DHCEQInStockList(ISLRowID),"^",7) //设备原值
	..s EQPL(29)=EQPL(28) //设备净值
	..s EQPL(30)=##Class(web.DHCEQCommon).FormatNumber(EQPL(28)*RemainFeeRate/100,"",2)		//2014-12-16 DJ	DJ0131
	..s EQPL(4)=$P(^DHCEQInStockList(ISLRowID),"^",9) //设备机型
	..s EQPL(6)=$P(^DHCEQInStockList(ISLRowID),"^",10) //设备单位
	..s EQPL(76)=$P(^DHCEQInStockList(ISLRowID),"^",17) //设备类别
	..
	..s EQPL(8)=$P(^DHCEQInStockList(ISLRowID),"^",16) //设备项
	..i EQPL(8)'="" s EQPL(7)=$P($G(^DHCEQCCode("DHCEQCMasterItem",EQPL(8))),"^",2) //Code
	..
	..s EQPL(21)=$P(^DHCEQInStock(RowID),"^",15) //设备来源
	..s EQPL(22)=$P(^DHCEQInStock(RowID),"^",16) //来源部门
	..s EQPL(26)=$P(^DHCEQInStock(RowID),"^",17) //供应商
	..s EQPL(64)=$P(^DHCEQInStock(RowID),"^",20) //类组
	..
	.;插入设备变动信息,更新或插入设备信息
	.
	.s EQRowID=0
	.For i = 1:1:EquipNum q:CSSQLCODE'=0  d
    ..
	..;设备项插入设备表记录
	..i (SourceType="1")||(SourceType="3")  d
    .../// add by ZY20221115 Bug:3086173
    ...s EQPL(11)=##Class(web.DHCEQ.EM.BUSInStockListLoc).GetLeaveFactoryNoOrFileNo(ISLRowID,"1",i)
    ...s EQPL(86)=##Class(web.DHCEQ.EM.BUSInStockListLoc).GetLeaveFactoryNoOrFileNo(ISLRowID,"2",i)
	...&SQL(insert into sqluser.DHC_EQEquip values :EQPL())
	...s CSSQLCODE=SQLCODE
	...q:CSSQLCODE'=0
	...s EQRowID=$G(%ROWID)
	...s CSSQLCODE=##class(web.DHCEQEquip).UpdateEquipNo(EQRowID,+$H)
	..e  i SourceType="0"  d
	...;设备更新设备信息
	...s EQRowID=SourceID
	...i $p($g(^DHCEQEquip(EQRowID)),"^",60)=1 s CSSQLCODE=-1011
    .../// add by ZY20221115 Bug:3086173
    ...i $p($g(^DHCEQEquip(EQRowID)),"^",10)="" s EQPL(11)=##Class(web.DHCEQ.EM.BUSInStockListLoc).GetLeaveFactoryNoOrFileNo(ISLRowID,"1",i)
    ...i $p($g(^DHCEQEquip(EQRowID)),"^",85)="" s EQPL(86)=##Class(web.DHCEQ.EM.BUSInStockListLoc).GetLeaveFactoryNoOrFileNo(ISLRowID,"2",i)
	...q:CSSQLCODE'=0
	...s EQOriginalFee=$p($g(^DHCEQEquip(EQRowID)),"^",27)		//2014-12-16 DJ DJ0131
	...s EQPL(30)=##Class(web.DHCEQCommon).FormatNumber(EQOriginalFee*RemainFeeRate/100,"",2)		//2014-12-16 DJ DJ0131
	...&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EQRowID)
	...s CSSQLCODE=SQLCODE
	..e  i (SourceType="2")  d
	...;验收单更新设备信息
	...s ISLHold4=$P(^DHCEQInStockList(ISLRowID),"^",22)	// Mozy0217  2018-11-01	增加设备配置的入库明细处理
	...i ISLHold4="" d
	....s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",SourceID,EQRowID))
	....d CheckConfig
	....s ISStatus=$P(^DHCEQInStock(RowID),"^",10)  ;0:新增|1:提交|2:审核|3:作废 add by kdf 2018-05
	....i i=1  d
	.....i ($p($g(^DHCEQEquip(EQRowID)),"^",60)=1)&&(ISLHold4="") s CSSQLCODE=-1011
	.....q:CSSQLCODE'=0
	.....s EQOriginalFee=$p($g(^DHCEQEquip(EQRowID)),"^",27)
	.....s EQPL(30)=##Class(web.DHCEQCommon).FormatNumber(EQOriginalFee*RemainFeeRate/100,"",2)
	.....&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_OpenCheckListDR=:SourceID)
	...e  d
	....s EQRowID=$o(^DHCEQEquip("0","Hold13",ISLHold4,EQRowID))
	....i i=1  d
	.....&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_Hold13=:ISLHold4)
	....s CSSQLCODE=SQLCODE
	..
	..q:CSSQLCODE'=0
	..//begin modify by jyp 2020-03-03  JYP0021  保修信息表
	..s CSSQLCODE=##Class(web.DHCEQ.EM.BUSEquipGuaranteeInfo).SaveEquipGuaranteeInfo("0",EQRowID)
	..q:CSSQLCODE'=0
	..//end modify by jyp 2020-03-03  JYP0021  保修信息表
	..;插入设备变动信息
	..s CSPLIST(5)=ISLRowID //原ID
	..s CSPLIST(6)="0" //变动类型
	..s CSPLIST(7)=Date	//ChangeDate
	..s CSPLIST(8)=User	//AuditUserDR
	..s CSPLIST(9)=Date	//AuditDate
	..s CSPLIST(10)=Date	//BillChangeDate
	..//s CSPLIST(3)=	 //FromLocDR
	..s CSPLIST(4)=$P(^DHCEQInStock(RowID),"^",2) 	//ToLocDR
	..s CSPLIST(2)=EQRowID //设备
	..&SQL(insert into sqluser.DHC_EQChangeStock values :CSPLIST())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	..	
	q CSSQLCODE
CheckConfig
	;需求：	844192		Mozy	2019-3-18
	while ($p($g(^DHCEQEquip(EQRowID,"OtherInfo")),"^",26)'="")
	{
		s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",SourceID,EQRowID))
	}
	q
}

/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:修改发票信息
/// ----------------------------------
ClassMethod BillUpdateInvoice(ISRowID)
{
	new (ISRowID)
	s ISLRowID=0
	s SQLCODE=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  quit:(ISLRowID="")||SQLCODE'=0  d
	.s InvoiceID=$o(^DHCEQInvoiceUseMap(0,"Source","1",ISLRowID,0))
	.i InvoiceID'="" d 
	..s InvoiceDR=$p(^DHCEQInvoiceUseMap(InvoiceID),"^",2)
	..&SQL(update sqluser.DHC_EQInvoice set IV_Status='1' where IV_RowID=:InvoiceDR)
	q SQLCODE
}

/// ----------------------------------
/// 创建: add by jdl 2009-04-13
/// 判断入库单设备类型的唯一性
/// ----------------------------------
ClassMethod StatCatIsUniqueNew(ISRowID, StatCatID)
{
	new (ISRowID, StatCatID)
	
	s ResultFlag=0
	s PreStatCatID=0	
	
	s ListStatCatID=""
	s ISLRowID=0	
	f  s ISLRowID=$O(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:(ISLRowID="")||(ResultFlag'=0)  d
	.s ListStatCatID=$P(^DHCEQInStockList(ISLRowID),"^",17)
	.i (ListStatCatID="")  d
	..;类型为空
	..s ResultFlag=-1004
	.e  d
	..i (PreStatCatID=0) s PreStatCatID=ListStatCatID
	..;明细中类型不一致
	..i (PreStatCatID'=ListStatCatID) d
	...s ResultFlag=-1001
	..e  i ((StatCatID'="")&&(StatCatID'=ListStatCatID))  d
	...;明细中类型与单据类型不一致
	...s ResultFlag=-1002
	i ResultFlag'=0 q ResultFlag	
	q ListStatCatID
}

/// ----------------------------------
/// 创建: add by zy
/// 描述:判断入库单设备类组的唯一性
/// 	入参：
/// 		RowID			业务单ID
/// 	EquipTypeID		业务单类组
/// 		vType			业务类型
/// w ##Class(web.DHCEQInStockNew).EquipTypeIsUniqueNew("63","1","StoreMove")
/// 返回值：-1006：明细的类组不一致，-1007:明细与单据的类组不一致
ClassMethod EquipTypeIsUniqueNew(RowID, EquipTypeID, vType)
{
	new (RowID, EquipTypeID, vType)
	
	new ResultFlag,PreEquipTypeID,EquipTypeDR
	new SourceType,SourceID
	new ISLRowID,SMLRowID,RLRowID
	new DLRowID,DRLRowID,DRLEquipDR,DLSourceType,DLSourceID,DLEquipDR,DLCount		//Add By DJ 2016-04-01 DJ0177
	
	s ResultFlag=0	
	s PreEquipTypeID=0

	s EquipTypeDR=""
	if (vType="InStock")	//入库单明细的判断
	{
		s ISLRowID=0
		f  s ISLRowID=$O(^DHCEQInStockList(0,"InStock",RowID,ISLRowID)) q:(ISLRowID="")||(ResultFlag'=0)  d
		.;;配置设备不需判断类组	// Mozy0217  2018-11-01
		.i ($P(^DHCEQInStockList(ISLRowID),"^",22)'="") d
		..s EquipTypeDR=$p($g(^DHCEQInStock(RowID)),"^",20)
		.e  d
		..s SourceType=$P(^DHCEQInStockList(ISLRowID),"^",18)
		..s SourceID=$P(^DHCEQInStockList(ISLRowID),"^",19)
		..i SourceType="0" d 	//设备
		...s EquipTypeDR=$p($g(^DHCEQEquip(SourceID)),"^",63)
		..i SourceType="1" d  	//设备项
		...s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",SourceID)),"^",3)
		..i SourceType="2" d  	//验收单
		...s EquipTypeDR=$p($g(^DHCEQOpenCheckList(SourceID)),"^",3)
		..i SourceType="3" d  	//计划单
		...s BuyPlanDR=$p($g(^DHCEQBuyPlanList(SourceID)),"^",1)
		...s EquipTypeDR=$p($g(^DHCEQBuyPlan(BuyPlanDR)),"^",12)
		.d CheckEquipType
	}
	elseif (vType="StoreMove")	//转移单明细的判断
	{
		s FromLocDR=$P(^DHCEQStoreMove(RowID),"^",2)
		s SMLRowID=0
		f  s SMLRowID=$O(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID)) q:(SMLRowID="")||(ResultFlag'=0)  d
		.;;配置设备不需判断类组	// Mozy0217  2018-11-01
		.i ($P(^DHCEQStoreMoveList(SMLRowID),"^",15)'="") d
		..s EquipTypeDR=$p($g(^DHCEQStoreMove(RowID)),"^",16)
		..d CheckEquipType
		.e  d
		..;Mozy0218	2019-2-1	取明细记录设备的当前类组进行判断
		..s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)		;EquipDR
		..i EquipDR="" s EquipDR=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		..i EquipDR="" s ResultFlag=-1008
		..q:ResultFlag'=0
		..s EQLen=$l(EquipDR,",")
		..f count=1:1:EQLen q:ResultFlag'=0  d
		...s EQStoreLocDR=$p($g(^DHCEQEquip($p(EquipDR,",",count))),"^",67)
		...i FromLocDR'=EQStoreLocDR s ResultFlag=-1008
		...q:ResultFlag'=0
		...s EquipTypeDR=$p($g(^DHCEQEquip($p(EquipDR,",",count))),"^",63)
		...d CheckEquipType
	}
	elseif (vType="Return")	//退货单明细的判断
	{
		;Mozy0218	2019-2-1	取明细记录设备的当前类组进行判断
		s FromLocDR=$P(^DHCEQReturn(RowID),"^",2)
		s UseLocDR=$P(^DHCEQReturn(RowID),"^",24)
		i UseLocDR'="" s FromLocDR=UseLocDR
		s RLRowID=0
		f  s RLRowID=$O(^DHCEQReturnList(0,"Return",RowID,RLRowID)) q:(RLRowID="")||(ResultFlag'=0)  d
		.i $p($g(^DHCEQReturnList(RLRowID)),"^",12)'="" d
		..;配置设备不需判断类组
		..s EquipTypeDR=$p($g(^DHCEQReturn(RowID)),"^",15)
		..d CheckEquipType
		.e  d
		..s EquipDR=$P(^DHCEQReturnList(RLRowID),"^",4)		;EquipDR
		..i EquipDR="" s EquipDR=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
		..i EquipDR="" s ResultFlag=-1008
		..q:ResultFlag'=0
		..s EQLen=$l(EquipDR,",")
		..f count=1:1:EQLen q:ResultFlag'=0  d
		...s EQStoreLocDR=$p($g(^DHCEQEquip($p(EquipDR,",",count))),"^",67)
		...i FromLocDR'=EQStoreLocDR s ResultFlag=-1008
		...q:ResultFlag'=0
		...s EquipTypeDR=$p($g(^DHCEQEquip($p(EquipDR,",",count))),"^",63)
		...d CheckEquipType
	}
	elseif (vType="BuyRequest")	//采购申请的判断 2013-07-19 DJ DJ0120
	{
		s RLRowID=0
		f  s RLRowID=$O(^DHCEQBuyRequestList(0,"BuyRequest",RowID,RLRowID)) q:(RLRowID="")||(ResultFlag'=0)  d
		.s ItemDR=$p($g(^DHCEQBuyRequestList(RLRowID)),"^",17)
		.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
		.d CheckEquipType
	}
	elseif (vType="DisUse")		//多批报废明细类组判断 Add By DJ 2016-04-01 DJ0177 
	{
		s DRLRowID=0
		f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",RowID,DRLRowID))  q:(DRLRowID="")||(ResultFlag'=0)  d
		.s DRLEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
		.s EquipTypeDR=$p($g(^DHCEQEquip(DRLEquipDR)),"^",63)
		.d CheckEquipType
		
		s DLRowID=0
		f  s DLRowID=$o(^DHCEQDisuseList(0,"Request",RowID,DLRowID))  q:(DLRowID="")||(ResultFlag'=0)  d
		.s DLSourceType=$p($g(^DHCEQDisuseList(DLRowID)),"^",2)
		.s DLSourceID=$p($g(^DHCEQDisuseList(DLRowID)),"^",3)
		.i DLSourceType=0  d
		..s EquipTypeDR=$p($g(^DHCEQEquip(DLSourceID)),"^",63)
		..d CheckEquipType
		.e  d
		..s DLEquipDR=0
		..s DLCount=$L(^DHCEQDisuseList(DLRowID,"EX"),",")
		..f DLEquipDR=1:1:DLCount  d
		...q:(ResultFlag'=0)
		...s DLSourceID=$p(^DHCEQDisuseList(DLRowID,"EX"),",",DLEquipDR)
		...s EquipTypeDR=$p($g(^DHCEQEquip(DLSourceID)),"^",63)
		...d CheckEquipType
	}
	i ResultFlag'=0 q ResultFlag
	q EquipTypeDR	
CheckEquipType
	;EquipTypeDR为当前设备的类组
	i PreEquipTypeID=0 s PreEquipTypeID=EquipTypeDR
	i PreEquipTypeID'=EquipTypeDR  d
	.s ResultFlag=-1006		;明细设备的类组不一致
	e  i (EquipTypeID'="")&&(EquipTypeID'=EquipTypeDR)  d
	.s ResultFlag=-1007		;明细与单据的类组不一致
	q
}

/// ?????
/// 通过入库单生成其他单据
/// ToFlag：1.生成转移分配单  2.生成退货单
/// 		3.复制生成入库单(不使用)
ClassMethod TransFromInStock(InStockId, UserID, ToFlag)
{
	new CurDate,RowID,InStockListID,EquipID,LocID,RequestNo
	if InStockId="" q ""
	
	;审核后的入库单才可操作
	if $p($g(^DHCEQInStock(InStockId)),"^",10)<2 q ""
	s CurDate=+$H
	s RequestNo=""
	s LocDR=$p($g(^DHCEQInStock(InStockId)),"^",2)
	s EquipTypeDR=$p($g(^DHCEQInStock(InStockId)),"^",20)	;2014-01-03  Mozy0115
	TStart
	i ToFlag=1
	{
		s RequestNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,LocDR,EquipTypeDR)
		&SQL(insert into sqluser.DHC_EQStoreMove
			(SM_StoreMoveNo,SM_FromLocDR,SM_ToLocDR,SM_MakerDR,SM_MakeDate,SM_MoveType,SM_Status,SM_EquipTypeDR,SM_StatCatDR) 
		select :RequestNo,IS_LocDR,IS_BuyLocDR,:UserID,:CurDate,0,0,IS_EquipTypeDR,IS_StatCatDR from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	}
	elseif ToFlag=2
	{
		Set RequestNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",+$H,LocDR,EquipTypeDR)	;2014-01-03  Mozy0115
		&SQL(insert into sqluser.DHC_EQReturn
			(R_ReturnNo,R_ReturnLocDR,R_MakerDR,R_MakeDate,R_ReturnDate,R_ProviderDR,R_Status,R_EquipTypeDR,R_StatCatDR,R_OutTypeDR) 
		select :RequestNo,IS_LocDR,:UserID,:CurDate,:CurDate,IS_ProviderDR,0,IS_EquipTypeDR,IS_StatCatDR,1 from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	}
	elseif ToFlag=3
	{
		s RequestNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$H,LocDR,EquipTypeDR)
		&SQL(insert into sqluser.DHC_EQInStock
			(IS_InDate,IS_LocDR,IS_RequestUserDR,IS_RequestDate,IS_Status,IS_Remark,IS_InStockNo,IS_OriginDR,IS_FromDeptDR,IS_ProviderDR,IS_BuyLocDR,IS_BuyUserDR,IS_EquipTypeDR,IS_StatCatDR) 
		select :CurDate,IS_LocDR,IS_RequestUserDR,:CurDate,0,IS_Remark,:RequestNo,IS_OriginDR,IS_FromDeptDR,IS_ProviderDR,IS_BuyLocDR,IS_BuyUserDR,IS_EquipTypeDR,IS_StatCatDR
		 from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	}
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	s RowID=$G(%ROWID)
	s InStockListID=0
	f  s InStockListID=$o(^DHCEQInStockList(0,"InStock",InStockId,InStockListID)) q:((InStockListID="")||(SQLCODE'=0))  d
	.s EquipID=""
	.s Qty=$p($g(^DHCEQInStockList(InStockListID)),"^",8)
	.i Qty=1  d
	..s EquipID=$p($g(^DHCEQInStockList(InStockListID)),"^",2)
	..i EquipID=""  d
	...s LocID=$o(^DHCEQEquip(0,"InStockList",InStockListID,0))
	...i LocID'=""  d
	....s EquipID=$o(^DHCEQEquip(0,"InStockList",InStockListID,LocID,0))
	.s InvoiceID=$o(^DHCEQInvoiceUseMap(0,"Source",1,InStockListID,0))
	.if InvoiceID'="" s InvoiceID=$p($g(^DHCEQInvoiceUseMap(InvoiceID)),"^",2)
	.i ToFlag=1  d
	..&SQL(insert into sqluser.DHC_EQStoreMoveList(SML_StoreMoveDR,SML_EquipDR,SML_BatchFlag,SML_InStockListDR,SML_EquipName,SML_ManuFactoryDR,SML_OriginalFee,SML_QuantityNum,SML_ModelDR,SML_UnitDR,SML_Remark) select :RowID,:EquipID,ISL_BatchFlag,ISL_RowID,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Remark from sqluser.DHC_EQinstocklist where ISL_RowID=:InStockListID)
	.i ToFlag=2  d
	..&SQL(insert into sqluser.DHC_EQReturnList(RL_ReturnDR,RL_EquipDR,RL_BatchFlag,RL_InStockListDR,RL_ReturnQtyNum,RL_ReturnFee) select :RowID,:EquipID,ISL_BatchFlag,ISL_RowID,ISL_QuantityNum,ISL_OriginalFee from sqluser.DHC_EQinstocklist where ISL_RowID=:InStockListID)
	..q:SQLCODE'=0
	..i InvoiceID'=""  d
	...s IUMSourceID=$G(%ROWID)
	...&SQL(Insert into sqluser.DHC_EQInvoiceUseMap (IUM_SourceID,IUM_InvoiceDR,IUM_Type) values(:IUMSourceID,:InvoiceID,2))
	.i ToFlag=3  d
	..&SQL(Insert into sqluser.DHC_EQInStockList (ISL_InStockDR,ISL_EquipDR,ISL_BatchFlag,ISL_BuyPlanListDR,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Hold1,ISL_Remark,ISL_AppendFee,ISL_EquipCatDR,ISL_LimitYearsNum,ISL_ItemDR) select :RowID,ISL_EquipDR,ISL_BatchFlag,ISL_BuyPlanListDR,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Hold1,ISL_Remark,ISL_AppendFee,ISL_EquipCatDR,ISL_LimitYearsNum,ISL_ItemDR from sqluser.DHC_EQInStockList Where ISL_RowID=:InStockListID)
	..q:SQLCODE'=0
	..i InvoiceID'=""  d
	...s IUMSourceID=$G(%ROWID)
	...&SQL(Insert into sqluser.DHC_EQInvoiceUseMap (IUM_SourceID,IUM_InvoiceDR,IUM_Type) values(:IUMSourceID,:InvoiceID,1))
	.
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	
	TCommit
	quit RowID
}

/// /????
/// 根据入库明细和科室获取空闲可用于转移或退货的数量
/// w ##Class(web.DHCEQInStockNew).GetIdleQty(ISLRowID,StoreLocDR)
ClassMethod GetIdleQty(ISLRowID, StoreLocDR)
{
	n RowID,IdleQty,LRowID,RRowID,Qty
	i ((ISLRowID="")||(StoreLocDR="")) q 0
	s IdleQty=0
	s RowID=0
	f  s RowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,RowID)) q:(RowID="")  d
	.;只取非报废和其他的
	.q:$p(^DHCEQEquip(RowID),"^",38)>2
	.;只取在库的
	.q:$p(^DHCEQEquip(RowID),"^",60)'=1
	.s IdleQty=IdleQty+1
	.s LRowID=0
	.f  s LRowID=$o(^DHCEQStoreMoveList(0,"Equip",RowID,LRowID)) q:(LRowID="")  d
	..d CheckStoreMoveQty
	.f  s LRowID=$o(^DHCEQReturnList(0,"Equip",RowID,LRowID)) q:(LRowID="")  d
	..d CheckReturnQty
	if IdleQty<0 s IdleQty=0
	if IdleQty=0 q IdleQty
	.f  s LRowID=$o(^DHCEQStoreMoveList(0,"InStockList",ISLRowID,LRowID)) q:(LRowID="")  d
	..d CheckStoreMoveQty
	.f  s LRowID=$o(^DHCEQReturnList(0,"InStockList",ISLRowID,LRowID)) q:(LRowID="")  d
	..d CheckReturnQty
	if IdleQty<0 s IdleQty=0
	q IdleQty
CheckStoreMoveQty
	s RRowID=$p(^DHCEQStoreMoveList(LRowID),"^",1)
	s Qty=$p(^DHCEQStoreMoveList(LRowID),"^",8)
	;过滤掉非本供给部门的
	q:$p($g(^DHCEQStoreMove(RRowID)),"^",2)'=StoreLocDR
	;过滤掉已经审核的
	q:$p($g(^DHCEQStoreMove(RRowID)),"^",13)'=2
	s IdleQty=IdleQty-Qty
	q
CheckReturnQty
	s RRowID=$p(^DHCEQReturnList(LRowID),"^",1)
	s Qty=$p(^DHCEQReturnList(LRowID),"^",5)
	;过滤掉非本供给部门的
	q:$p($g(^DHCEQReturn(RRowID)),"^",2)'=StoreLocDR
	;过滤掉已经审核的
	q:$p($g(^DHCEQReturn(RRowID)),"^",13)'=2
	s IdleQty=IdleQty-Qty
	q
}

/// ????
/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:通过审核的入库单自动生成转移单
/// ----------------------------------
ClassMethod TransInToMove(InStockId, UserID)
{
	new (InStockId, UserID)
	if InStockId="" q ""
	s CurDate=+$H
	s StoreMoveNo=""
	TStart
	if StoreMoveNo="" s StoreMoveNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,"",$p($g(^DHCEQInStock(InStockId)),"^",20))	;2014-01-03  Mozy0115
	&SQL(insert into sqluser.DHC_EQStoreMove
		(SM_StoreMoveNo,SM_FromLocDR,SM_ToLocDR,SM_MakerDR,SM_MakeDate,SM_MoveType,SM_Status,SM_EquipTypeDR,SM_StatCatDR) 
	select :StoreMoveNo,IS_LocDR,IS_BuyLocDR,:UserID,:CurDate,0,0,IS_EquipTypeDR,IS_StatCatDR from sqluser.DHC_EQInStock where IS_RowID=:InStockId)
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	s RowID=$G(%ROWID)
	s InStockListID=0
	f  s InStockListID=$o(^DHCEQInStockList(0,"InStock",InStockId,InStockListID)) q:((InStockListID="")||(SQLCODE'=0))  d
	.s EquipID=""
	.s Qty=$p($g(^DHCEQInStockList(InStockListID)),"^",8)
	.i Qty=1  d
	..s EquipID=$p($g(^DHCEQInStockList(InStockListID)),"^",2)
	..i EquipID=""  d
	...s LocID=$o(^DHCEQEquip(0,"InStockList",InStockListID,0))
	...i LocID'=""  d
	....s EquipID=$o(^DHCEQEquip(0,"InStockList",InStockListID,LocID,0))
	.&SQL(insert into sqluser.DHC_EQStoreMoveList(SML_StoreMoveDR,SML_EquipDR,SML_BatchFlag,SML_InStockListDR,SML_EquipName,SML_ManuFactoryDR,SML_OriginalFee,SML_QuantityNum,SML_ModelDR,SML_UnitDR,SML_Remark) select :RowID,:EquipID,ISL_BatchFlag,ISL_RowID,ISL_EquipName,ISL_ManuFactoryDR,ISL_OriginalFee,ISL_QuantityNum,ISL_ModelDR,ISL_UnitDR,ISL_Remark from sqluser.DHC_EQinstocklist where ISL_RowID=:InStockListID)
	.
	if SQLCODE'=0 
	{	TRollBack 
		quit SQLCODE}
	
	TCommit
	quit RowID
}

/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:解析入库设备类型
/// ----------------------------------
ClassMethod GetSourceType(TSourceType)
{
	q $CASE(TSourceType,"0":"设备","1":"设备项","2":"验收单","3":"计划单","":"")
}

/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:根据设备验收单,对已审核但未入库的设备进行选择自动生成入库单
/// w ##class(web.DHCEQInStockNew).SaveDataFromOpenCheck("166^166^^2371^1","2")
ClassMethod SaveDataFromOpenCheck(val As %Library.String = "", SourceType As %Library.String = "2")
{
	Set $ZT="SaveDataFromOpenCheck"
	;Modified By ZY0103 增加入库选择计划单时处理
	i SourceType=3
	{
		s Result=..SaveDataFromPlan(val)
		q Result
	}

	n OCRowID,OCLRowID,ISRowID,Loc,UserDR
	k PLIST, PLISTMX
	s OCRowID=$p(val,"^",1)		;验收单ID
	s OCLRowID=$p(val,"^",2)	;验收明细ID
	s ISRowID=$p(val,"^",3)		;入库单ID
	s Loc=$p(val,"^",4)			;库房
	s UserDR=$p(val,"^",5)		;操作员

	;Modified by JDL 2012-2-23 补充Mozy0076
	;首先判断验收单还是否有效存在
	if OCRowID="" q -1016
	if $g(^DHCEQOpenCheckRequest(OCRowID))="" q -1016
	if $p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",45)="Y" q -1016	;OCR_InvalidFlag
	
	TStart
	i ISRowID="" //增加主表和明细表
	{
		s PLIST(2)=##class(web.DHCEQCommon).TransValueFromPage($ZDate($H,4),"date") //入库日期
		S PLIST(3)=Loc //库房
		S PLIST(5)=UserDR //申请人
		s PLIST(6)=PLIST(2) //申请日期
		S PLIST(11)="0" //状态
		Set PLIST(12)=$Piece($Get(^DHCEQOpenCheckRequest(OCRowID)),"^",21) //备注	Mozy0057	2011-8-15
		s EquipTypeDR=$p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",2) //设备类组
		S PLIST(15)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$H,$p(val,"^",4),EquipTypeDR) //入库单号	Mozy0094
		S PLIST(16)=$p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",8) //设备来源
		S PLIST(17)=$p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",9) //来源部门
		S PLIST(18)=$p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",5) //供应商
		s PLIST(19)=$Piece($Get(^DHCEQOpenCheckList(OCLRowID)),"^",33) //申购部门	Mozy0057	2011-8-15
		S PLIST(21)=$p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",2) //设备类组
		S PLIST(22)=$p($g(^DHCEQOpenCheckRequest(OCRowID)),"^",4) //设备类型
		S PLIST(26)="N"
		//主表
	 	&SQL(insert into sqluser.DHC_EQInStock values :PLIST())
	 	if SQLCODE
	 	{
		 	TRollBack
		 	q SQLCODE
	 	}
	 	s ISRowID=$G(%ROWID)
	}
	
	//明细表
	s PLISTMX(2)=ISRowID //主表Rowid
	s PLISTMX(4)="Y" //批入库标志
	s PLISTMX(6)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",2) //设备名称
	s PLISTMX(7)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",15) //生产厂家
	s PLISTMX(8)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17) //设备原值
	s PLISTMX(9)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16) //数量
	s PLISTMX(10)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",5) //机型
	s PLISTMX(11)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",7) //单位
	s PLISTMX(13)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",34) //备注
	s PLISTMX(15)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",6) //设备分类
	s PLISTMX(17)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",9) //设备项DR
	s PLISTMX(16)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",19) //使用年限	
	;s PLISTMX(16)=##class(web.DHCEQCEquipeCat).GetYearsByCatID(PLISTMX(15)) //使用年限	
	s PLISTMX(18)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",28) //设备类型
	s PLISTMX(19)="2" //来源类型0:设备,1:设备项,2:验收单
	s PLISTMX(20)=OCLRowID //来源ID
	s PLISTMX(24)=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",59) // add by csy 2017-07-21 经费来源
	&SQL(insert into sqluser.DHC_EQInStockList values :PLISTMX())
	if SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	//更新发票号 Add By DJ 2010-10-15
	s InvoiceNo=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",55)
	s ISLRowID=$G(%ROWID)
 	if InvoiceNo'=""
 	{
		s SQLCODE=..UpdateInvoiceInfo(ISLRowID, InvoiceNo, "", "")
 		if SQLCODE
 		{
	 		TRollBack
	 		q SQLCODE
 		}
 	}
 	//检测验收单对应发票号同步到入库 Add By DJ 2016-08-16
 	s IUMRowID=0
 	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",6,OCLRowID,IUMRowID))  q:(IUMRowID="")||(SQLCODE'=0)  d
 	.s InvoiceDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)
 	.s InvoiceNo=$p($g(^DHCEQInvoice(InvoiceDR)),"^",2)
 	.s SQLCODE=..UpdateInvoiceInfo(ISLRowID, InvoiceNo, "", "")
 	
 	i SQLCODE
 	{
	 	TROLLBACK
	 	q SQLCODE
 	}
 	// MZY0053	1505555		2020-09-08	合同采购人更新至入库单
 	i $p($g(^DHCEQOpenCheckList(OCLRowID)),"^",37)'=""
 	{
	 	s tmpCTRowID=$p($g(^DHCEQContractList($p($g(^DHCEQOpenCheckList(OCLRowID)),"^",37))),"^",1)
	 	s CTHold2=$p($g(^DHCEQContract(tmpCTRowID)),"^",54)
	 	i CTHold2'="" &SQL(Update SQLUSER.DHC_EQInStock Set IS_BuyUserDR=:CTHold2 where IS_RowID=:ISRowID)
 	}
 	i SQLCODE
 	{
	 	TROLLBACK
	 	q SQLCODE
 	}
 	
	/// modified by ZY0260 20210428
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSInStockListLoc).SaveInStockListLoc(ISLRowID)
 	i SQLCODE
 	{
	 	TROLLBACK
	 	q SQLCODE
 	}
	TCommit
	q ISRowID
	
SaveDataFromOpenCheck 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息 ;
}

/// w ##Class(web.DHCEQInStockNew).GetOneInStock("187")
ClassMethod GetOneInStock(rowid)
{
	new result,resultex,LocCode,AppInfo,Total
	s (result,resultex,LocCode,AppInfo,Total)=""
	s result= ^DHCEQInStock(rowid)
	s $p(result,"^",1)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",1),"date")	;InDate
	s resultex=resultex_"^"	;LocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	.s LocCode=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p(result,"^",2))
	s resultex=resultex_"^"	;RejectReasonDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCRejectReason",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;RequestUserDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s $p(result,"^",5)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;RequestDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",6))
	s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;AuditDate
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;RejectDate
	s resultex=resultex_"^"	;BillAuditUserDR
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",12))
	s $p(result,"^",13)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;BillAuditDate
	s resultex=resultex_"^"	;OriginDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",15))),"^",2)
	s resultex=resultex_"^"	;FromDeptDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",16))),"^",2)
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",17))
	.//s ProviderCode=$P($G(^APC("APCVM",$p(result,"^",17))),"^",3)
	s resultex=resultex_"^"	;BuyLocDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",18))
	s resultex=resultex_"^"	;BuyUserDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",21))),"^",2)
	s Total=..GetOneInStockTotalFeeNum(rowid)
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("13",rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_Total_"^"_LocCode_"^"_AppInfo
}

ClassMethod GetOneInStockTotalFeeNum(ISRowID)
{
	i ISRowID="" q ""
	new ISLRowID,Fee,Num
	s ISLRowID=0
	s Fee=0
	s Num=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
	.s QuantityNum=$P(^DHCEQInStockList(ISLRowID),"^",8)
	.s OriginalFee=$P(^DHCEQInStockList(ISLRowID),"^",7)
	.s Fee=Fee+(QuantityNum*OriginalFee)
	.s Num=Num+QuantityNum
	i Fee=0  d
	.s Fee=""
	e  d
	.s Fee=##Class(web.DHCEQCommon).FormatNumber(Fee,"")
	i Num=0 s Num=""
	q Num_"^"_Fee
}

ClassMethod GetInStockStatus(Status)
{
	q $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")		//modified by CZF0060 2020-02-20
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQInStorckNew).LastAuditAction(52,1,61963)
/// ----------------------------------
ClassMethod LastAuditAction(RowID, User, Date, OutFlag)
{
	// Mozy0217  2018-11-01
	s SQLCODE = ##Class(web.DHCEQInStockNew).InsertISLForConfig(RowID)				/// Mozy	2016-5-16
	i SQLCODE q SQLCODE
	s SQLCODE=##class(web.DHCEQInStockNew).ChangeStock(RowID,User,Date)
	i SQLCODE q SQLCODE
	s SQLCODE=##class(web.DHCEQInStockNew).BillUpdateInvoice(RowID)				//修改发票状态 modifeid by csj 2020-03-04 放开注释
	//Function:Funds	2012-2-16 生成资金来源信息
	s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfoByEquip(RowID, Date)		//Mozy75	2011-12-27
	If SQLCODE Quit SQLCODE
	Set SQLCODE = ##Class(web.DHCEQOpenCheckRequest).AutoInOutExecute(2,RowID,$P(^DHCEQInStock(RowID),"^",2),User,,OutFlag)
	If SQLCODE Quit SQLCODE
	q SQLCODE
}

/// Add By DJ 2010-08-27
/// 判断输入条件EquipNo是否在vType单据类型下RowID单据中
ClassMethod CheckOrderEqNo(vType, RowID, EquipNo)
{
	n (vType,RowID,EquipNo)
	n Find, EQRowID,SMLRowID,EquipDR,EQRowIDs, ISLRowID, RLRowID, StoreLocDR
	
	s Find=0
	i (vType="")||(RowID="")||(EquipNo="") q Find
	
	s EQRowID=$o(^DHCEQEquip(0,"No",EquipNo,0))
	i EQRowID="" q Find
	
	if (vType="InStock")
	{
		s ISLRowID=0
		f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",RowID,ISLRowID))  q:(ISLRowID="")||(Find'=0)  d
		.s StoreLocDR=0
		.f  s StoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR))  q:(StoreLocDR="")||(Find'=0)  d
		..s EquipDR=0
		..f  s EquipDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,EquipDR)) q:(EquipDR="")||(Find'=0)  d
		...i EquipDR=EQRowID s Find=1
	}
	elseif (vType="StoreMove")
	{
		s SMLRowID=0
		f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID)) q:(SMLRowID="")||(Find'=0)  d
		.s EquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
		.i EquipDR=EQRowID s Find=1
		.q:Find'=0
		.s EQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		.i (","_EQRowIDs_",")[(","_EQRowID_",") s Find=1
	}
	elseif (vType="Return")
	{
		s RLRowID=0
		f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,RLRowID))  q:(RLRowID="")||(Find'=0)  d
		.s EquipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
		.i EquipDR=EQRowID s Find=1
		.q:Find'=0
		.s EQRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
		.i (","_EQRowIDs_",")[(","_EQRowID_",") s Find=1
	}
	q Find
}

// Mozy0030	2010-11-11

/// modified by zy0172  hisui改造
ClassMethod StatusList(name, width, Type, value As %String = "", CancelOper As %String = "") As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")   //by kdf
	//modify by lmm 2018-08-16 hisui改造 添加默认
	s selectfir=$case(value,0:"selected",:"")
	s selectsec=$case(value,1:"selected",:"")
	s selectthi=$case(value,2:"selected",:"")
	s selectedfour=$case(value,3:"selected",:"")		//modified by CZF0060 2020-02-20 begin
	
	w "<option value=></option>"
	i CancelOper="Y"
	{
		w "<option value=2 "_selectthi_">"_..GetInStockStatus(2)_"</option>"
		w "<option value=3 "_selectedfour_">"_..GetInStockStatus(3)_"</option>"
	}
	else
	{
		i (Type="")||(Type="0")||(Type="4") w "<option value=0 "_selectfir_">"_..GetInStockStatus(0)_"</option>"
		i Type'="2" w "<option value=1 "_selectsec_">"_..GetInStockStatus(1)_"</option>"
		w "<option value=2 "_selectthi_">"_..GetInStockStatus(2)_"</option>"		//modified by CZF0060 2020-02-20 end
	}
	w "</select>",!
}

/// Function:Funds	2012-2-16 生成资金来源信息
/// Mozy75	2011-12-27
/// 生成设备的资金来源信息
/// RowID: 入库单ID
/// w ##class(web.DHCEQInStockNew).CreateFundsInfoByEquip(7614,$h)
/// modified by czf 2020-10-29 将入库明细资金来源保存方法拆开，用于单据调整资金来源
ClassMethod CreateFundsInfoByEquip(RowID, Date, SelfFlag As %String = "")
{
	new (RowID, Date, SelfFlag)
 	
	Set RtnCode=0
	Set ISLRowID=0
	For  Set ISLRowID=$Order(^DHCEQInStockList(0,"InStock",RowID,ISLRowID)) Quit:(ISLRowID="")||(RtnCode'=0)  Do
	.s RtnCode=..CreateFundsInfoByISLID(ISLRowID,Date, SelfFlag)
	
	Quit RtnCode
}

/// Function:Funds	2012-2-16 生成资金来源信息
/// Mozy75	2011-12-27
/// 根据入库明细生成资金来源
/// RowID: 入库单ID
/// w ##class(web.DHCEQInStockNew).CreateFundsInfoByEquip(7614,$h)
ClassMethod CreateFundsInfoByISLID(ISLRowID, Date, SelfFlag As %String = "")
{
	new (ISLRowID, Date, SelfFlag)
 	
	Set FSQLCODE=0
	Set Quantity=+$Piece($Get(^DHCEQInStockList(ISLRowID)),"^",8)
	Set Price=+$Piece($Get(^DHCEQInStockList(ISLRowID)),"^",7)
	Set Amount=Quantity*Price
	s ISLFundsRowID=0
	f  s ISLFundsRowID=$o(^DHCEQFunds("0","Source",3,ISLRowID,ISLFundsRowID)) q:(ISLFundsRowID="")||(SelfFlag=1)  d
	.q:$p($g(^DHCEQFunds(ISLFundsRowID)),"^",10)="Y"
	.s SelfFlag=1	//Modify DJ 2019-09-23
	s FSQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(3,ISLRowID,Amount,SelfFlag)
	q:FSQLCODE'=0
	
	Set FundsNodeType="3"
	Set FundsNodeID=ISLRowID
	
	;Modified by JDL 2012-2-27 JDL0117
	s LastFundsID=##Class(web.DHCEQFunds).GetFundsAmountInfo(FundsNodeType,FundsNodeID)
	s LastFundsID=$p(LastFundsID,"^",2)
	
	Set FundsID=0
	For  Set FundsID=$Order(^DHCEQFunds(0,"Source",FundsNodeType,FundsNodeID,FundsID)) Quit:(FundsID="")||(FSQLCODE'=0)  Do
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.Set EquipID=0
	.Set FRowID=0
	.Kill LIST
	.
	.;拆分入库单明细,生成设备的资金来源信息
	.Set LIST(3)=$Piece($Get(^DHCEQFunds(FundsID)),"^",2)
	.Set Fee=+$Piece($Get(^DHCEQFunds(FundsID)),"^",3)		;Fee
	.Set tmpTotal=Fee
	.;Set LIST(5)=$Piece($Get(^DHCEQFunds(FundsID)),"^",4)		;CheckListDR	索引重置,出现死循环
	.Set LIST(6)=FundsID
	.Set LIST(7)=0
	.Set LIST(8)=$Piece($Get(^DHCEQFunds(FundsID)),"^",7)
	.Set LIST(9)=+Date
	.Set LIST(10)=+$Piece($H,",",2)
	.Set LIST(11)="N"
	.//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.s LIST(21) =$Piece($Get(^DHCEQFunds(FundsID)),"^",20)
	.s LIST(22) =$Piece($Get(^DHCEQFunds(FundsID)),"^",21)
	.//End By QW20190410 BUG:QW0027
	.
	.;;Modified by JDL 2012-2-27 JDL0117
	.s Remainder=0
	.
	.Set StoreLocDR=0
	.For  Set StoreLocDR=$Order(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR)) Quit:(StoreLocDR="")||(FSQLCODE'=0)  Do
	..Set EquipID=0
	..For  Set EquipID=$Order(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,EquipID)) Quit:(EquipID="")||(FSQLCODE'=0)  Do
	...Set LIST(2)=EquipID
	...i $Order(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,EquipID))=""  d
	....Set LIST(4)=tmpTotal
	...e  d
	....Set LIST(4)=Fee/Quantity
	....
	....;Modified by JDL 2012-2-27 JDL0117
	....;平衡余数,尽量减少误差
	....s Remainder=Remainder+LIST(4)-##Class(web.DHCEQCommon).FormatNumber(LIST(4),"")
	....i Remainder>0.01  d
	.....s Remainder=Remainder-0.01
	.....s LIST(4)=LIST(4)+0.01
	....e  i Remainder<-0.01  d
	.....s Remainder=Remainder+0.01
	.....s LIST(4)=LIST(4)-0.01
	....;当资金来源合计金额大于原值时,取设备的余额作为资金来源金额
	....s FundsAmount=##Class(web.DHCEQFunds).GetFundsAmountInfo("1",EquipID)
	....i (LIST(4)+FundsAmount)>$p($g(^DHCEQEquip(EquipID)),"^",27)  d
	.....s Remainder=Remainder+LIST(4)+FundsAmount-$p($g(^DHCEQEquip(EquipID)),"^",27)
	.....s LIST(4)=+$p($g(^DHCEQEquip(EquipID)),"^",27)-FundsAmount
	....;最后一个资金来源时,取设备的余额作为资金来源金额
	....i LastFundsID=FundsID  d
	.....s LIST(4)= +$p($g(^DHCEQEquip(EquipID)),"^",27)-FundsAmount
	....
	....Set LIST(4)=##Class(web.DHCEQCommon).FormatNumber(LIST(4),"")
	....Set tmpTotal=tmpTotal-LIST(4)
	...
	...;Modified by JDL 2012-2-27 JDL0117
	...i LIST(4)<0 s FSQLCODE=-1017
	...q:FSQLCODE'=0
	...
	...Set LIST(15)="1"
	...Set LIST(16)=EquipID
	...&SQL(insert into sqluser.DHC_EQFunds values :LIST())
	...Set FSQLCODE=SQLCODE
	...Quit:FSQLCODE'=0
	...;add by zy 2013-07-30 zy0108
	...;写入非主折旧对应资金来源的折旧记录信息
	...s FRowID=$G(%ROWID)
	...i $d(^DHCEQCCode("DHCEQCDepreType",2)) d
	....&SQL(insert into sqluser.DHC_EQFundsDepreInfo set FD_FundsDR=:FRowID,FD_DepreTypeDR='2')
	
	Quit FSQLCODE
}

/// Mozy75	2011-12-27
/// 根据业务生成设备的资金来源信息
/// FromType 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细
/// w ##class(web.DHCEQInStockNew).CreateFundsInfo(3,7637)
ClassMethod CreateFundsInfo(FromType, ListRowID)
{
	new (FromType, ListRowID)
	Kill FLIST
	Set SQLCODE=0
	Set Fee = 0
	
	k ^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID)
	Set FLIST(7)=0	;OperFlag 0:新增|1:修改|2:删除
	;Set FLIST(8)=$Piece($Get(^DHCEQFunds(FundsID)),"^",7)	;UpdateUserDR
	Set FLIST(9)=+$h										;UpdateDate
	Set FLIST(10)=+$Piece($H,",",2)						;UpdateTime
	Set FLIST(11)="N"						;InvalidFlag
	Set FLIST(15)=FromType					;SourceType
	Set FLIST(16)=ListRowID				;SourceID
	Set SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
	;入库明细		  ;转移明细		;退货明细
	If (FromType=3)||(FromType=4)||(FromType=5)
	{
		s CSRowID=0
		s ChangeType=FromType-3
		i FromType=5		//Add By DJ 2020-01-20 新版HISUI减少业务,张钰修改ChangeType为3
		{
			s ReturnType=$P(^DHCEQReturn($p($g(^DHCEQReturnList(ListRowID)),"^",1)),"^",17)
			i ReturnType'=1 s ChangeType=3
		}
		f  s CSRowID=$o(^DHCEQChangeStock(0,"Source",ChangeType,ListRowID,CSRowID)) Quit:(CSRowID="")  Do
		.s EquipID=$p(^DHCEQChangeStock(CSRowID),"^",1)
		.d AddEquipFundsInfo
	}
	ElseIf FromType=6		;报废明细
	{
		s EquipID=$p(^DHCEQDisuseRequestList(ListRowID),"^",2)
		d AddEquipFundsInfo
	}
	ElseIf FromType=7		;调账明细
	{
		s EquipID=$p(^DHCEQChangeAccount(ListRowID),"^",1)
		d AddEquipFundsInfo		
	}
	Else					;其他
	{
		;
	}
	Set LIST(4)=##Class(web.DHCEQCommon).FormatNumber(Fee,"")
	//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	s FundsType=""
	f  s FundsType=$o(^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID,FundsType)) q:(FundsType="")||(SQLCODE'=0)  d
	.s FinaceItem=""
	.f  s FinaceItem=$o(^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID,FundsType,FinaceItem)) q:(FinaceItem="")||(SQLCODE'=0)  d
	..s FunctionCat=""
	..f  s FunctionCat=$o(^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID,FundsType,FinaceItem,FunctionCat)) q:(FunctionCat="")||(SQLCODE'=0)  d
	...s FundsInfo=$g(^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID,FundsType,FinaceItem,FunctionCat))
	...s FundsFee=+$p(FundsInfo,"^",1)
	...s DepreTotal=+$p(FundsInfo,"^",2)
	...s FLIST(3)=FundsType	;FundsTypeDR
	...s FLIST(4)=FundsFee
	...s FLIST(14)=DepreTotal
	...s FLIST(21)=FinaceItem
	...i FinaceItem=0 k FLIST(21)	///modified by ZY022
	...s FLIST(22)=FunctionCat
	...i FunctionCat=0 k FLIST(22)	///modified by ZY022
	...&SQL(insert into sqluser.DHC_EQFunds values :FLIST())
	//End By QW 20190410 BUG:QW0027
	k ^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID)
	
	q SQLCODE
AddEquipFundsInfo
	q:$p(^DHCEQEquip(EquipID),"^",59)="Y"	;InvalidFlag
	s FundsID=0
	f  s FundsID=$o(^DHCEQFunds(0,"Source",1,EquipID,FundsID)) q:(FundsID="")  d
	.q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
	.q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
	.s FundsType=$p(^DHCEQFunds(FundsID),"^",2)
	.//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
	.s FinaceItem=$p($g(^DHCEQFunds(FundsID)),"^",20)
	.s FunctionCat=$p($g(^DHCEQFunds(FundsID)),"^",21)
	.i FundsType="" s FundsType=SelfFundsType
	.s FundsFee=+$p($g(^DHCEQFunds(FundsID)),"^",3)
	.s DepreTotal=$p($g(^DHCEQFunds(FundsID)),"^",13)
	.s FundsInfo=$g(^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID,FundsType,+FinaceItem,+FunctionCat))	 	///modified by ZY022
	.s FundsFee=+$p(FundsInfo,"^",1)+FundsFee
	.s DepreTotal=+$p(FundsInfo,"^",2)+DepreTotal
	.;Add By DJ 2019-09-24
	.i FromType=4  d
	..s ^DHCEQStoreMoveList(ListRowID,"FundsInfo",EquipID,FundsType)=FundsFee_"^"_DepreTotal	//需要测试
	.s ^DHCEQTemp("CreateFundsInfo",$j,FromType,ListRowID,FundsType,+FinaceItem,+FunctionCat)=FundsFee_"^"_DepreTotal			///modified by ZY022
	.//End By QW 20190410 BUG:QW0027
	q
}

/// ----------------------------------
/// 创建:zy 20120316  zy0091
/// 判断入库单设备供应商的唯一性
/// ResultFlag :0,一性;小于0,不一致
/// w ##class(web.DHCEQInStockNew).ProviderIsUniqueNew("Return",1)
ClassMethod ProviderIsUniqueNew(vType, RowID)
{
	new ProviderID,ResultFlag,ISLRowID,SourceType,SourceID,OpenCheckRequestID,ProviderDR
	
	s ResultFlag=0
	if vType="InStock"
	{
		s ProviderID=$P(^DHCEQInStock(RowID),"^",17)
		s ResultFlag=0
		
		s ListID=0	
		f  s ListID=$O(^DHCEQInStockList(0,"InStock",RowID,ListID)) q:(ListID="")||(ResultFlag'=0)  d
		.s (SourceType,SourceID,OpenCheckRequestID,ProviderDR)=""
		.s SourceType=$P(^DHCEQInStockList(ListID),"^",18)
		.i (SourceType="2")  d
		..s SourceID=$P(^DHCEQInStockList(ListID),"^",19)
		..s OpenCheckRequestID=$P(^DHCEQOpenCheckList(SourceID),"^",1)
		..s ProviderDR=$P(^DHCEQOpenCheckRequest(OpenCheckRequestID),"^",5)
		.i (ProviderDR'="")&(ProviderID'="")&(ProviderID'=ProviderDR) s ResultFlag=-1018
	}
	elseif (vType="Return")
	{
		s ProviderID=$P(^DHCEQReturn(RowID),"^",3)
		
		s ListID=0	
		f  s ListID=$O(^DHCEQReturnList(0,"Return",RowID,ListID)) q:(ListID="")||(ResultFlag'=0)  d
		.s (EquipID,ProviderDR)=""
		.s EquipIDs=$G(^DHCEQReturnList(ListID,"EX","RowIDs"))
		.s Len=$l(EquipIDs,",")
		.f i=1:1:Len d
		..q:ResultFlag'=0
		..s EquipID=$P(EquipIDs,",",i)
		..s ProviderDR=$P(^DHCEQEquip(EquipID),"^",25)
		..i (ProviderDR'="")&(ProviderID'="")&(ProviderID'=ProviderDR) s ResultFlag=-1018
	}
	q ResultFlag
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQInStockNew","GetBPList")
Query GetBPList(EquipTypeDR, Equip) As %Query(ROWSPEC = "Hidden:%String,Hidden:%String,TName:%String,Status:%String,ISNo:%String,TManuFac:%String,TQuantityNum:%String,TCommonName:%String")
{
}

ClassMethod GetBPListExecute(ByRef qHandle As %Binary, EquipTypeDR, Equip) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s BPID=0
	f  s BPID=$o(^DHCEQBuyPlan(0,"Status",2,BPID)) q:BPID=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBuyPlanList(0,"BuyPlan",BPID,rowid)) q:rowid=""  d
	..d ResetVariablesGetBPList
	..q:##Class(web.DHCEQBuyPlanNew).CheckBuyPlanListIsInUsed(rowid,3)=0
	..s TRowID = rowid
	..s TCommonName = $p($g(^DHCEQBuyPlanList(rowid)),"^",2)	//2013-06-24 DJ0118 begin
	..s TName=$p($g(^DHCEQBuyPlanList(rowid)),"^",18)
	..i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1) //2013-06-24 DJ0118 end
	..q:(Equip'="")&&(TName'[Equip)
	..;s TModelDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",3)
	..;i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	..;s TManuFacDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",4)
	..;i TManuFacDR'="" s TManumFac=$P(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR),"^",1)
	..s TQuantityNum = $p($g(^DHCEQBuyPlanList(rowid)),"^",7)
	..;s TExecNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",11)
	..;s TArriveNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",17)
	..;q:TArriveNum'<TExecNum
	
	..s Status="N"
	..s ISStatus=""
	..s ISNo=""
	..s ISLRowid=0
	..f  s ISLRowid=$o(^DHCEQInStockList(0,"Source",3,TRowID,ISLRowid)) q:ISLRowid=""  d
	...s ISNo=$p($g(^DHCEQInStockList(ISLRowid)),"^",1)
	...s ISStatus=$p($g(^DHCEQInStock(ISNo)),"^",10)
	...s ISInvalidFlag=$p($g(^DHCEQInStock(ISNo)),"^",25)
	...i ISInvalidFlag="Y"  d
	....s ISNo=""
	...e  d
	....s ISNo=$p($g(^DHCEQInStock(ISNo)),"^",14)
	....s Status="Y"
	..
	..q:ISStatus>1  //实物入库
	
	..d OutputRowGetBPList
	Quit $$$OK
OutputRowGetBPList
	s Data=$lb(BPID,TRowID,TName,Status,ISNo,TManuFac,TQuantityNum,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBPList
	s (TRowID,TName,Status,ISNo,TManuFac,TQuantityNum,TCommonName)=""
	quit
}

ClassMethod GetBPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBPListExecute ]
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

ClassMethod GetBPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBPListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ???
/// 描述:根据验收单rowid取验收单信息
/// ----------------------------------
/// w ##Class(web.DHCEQInStockNew).GetBuyPlanListInfo(1)
ClassMethod GetBuyPlanListInfo(rowid)
{
	if rowid="" q ""
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQBuyPlanList(rowid)
	
	s resultex=resultex_"^"	;
	i $p(result,"^",3)'=""  d  //TModel
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;
	i $p(result,"^",4)'=""  d  //TManuFactoryDR
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^",4))		//modified by czf 1252357
	
	s resultex=resultex_"^"	;
	s (EquipTypeDR,EquipType,EquipCatDR,EquipCat,StatCatDR,StatCat,UnitDR,Unit,LimitYearsNum,DepreMethodDR,DepreMethod)=""
	i $p(result,"^",18)'=""  d  //TItemDR->EquipType
	.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",18))),"^",3)
	.i EquipTypeDR'="" s EquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s EquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",18))),"^",4)
	.i EquipCatDR'="" s EquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",2)
	.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",18))),"^",5)
	.i StatCatDR'=""  d
	..s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	..s LimitYearsNum=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",9)
	..s DepreMethodDR=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",10)
	..i DepreMethodDR'="" s DepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	..
	.s UnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",18))),"^",7)
	.i UnitDR'="" s Unit=$p($g(^DHCEQCCode("DHCEQCUOM",UnitDR)),"^",2)
	s resultex=resultex_EquipTypeDR_"^"_EquipType_"^"_EquipCatDR_"^"_EquipCat_"^"_StatCatDR_"^"_StatCat_"^"_UnitDR_"^"_Unit_"^"_LimitYearsNum_"^"_DepreMethodDR_"^"_DepreMethod
	
	s (MaxInStockNum)=""
	i $p(result,"^",4)'=""  d 
	.s MaxInStockNum=$p(result,"^",4)
	e  d
	.i $p(result,"^",9)'=""  d
	..s MaxInStockNum=$p($g(^DHCEQBuyRequestList($p(result,"^",9))),"^",7)
	s resultex=resultex_"^"_MaxInStockNum
	s resultex=resultex_"^"	; //2013-06-24 DJ0118 begin
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",18))),"^",1) //2013-06-24 DJ0118 end
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// ----------------------------------
/// 创建:zy   No ZY0103
/// 描述:根据设备计划单,对已审核但未入库的设备进行选择自动生成入库单
/// ----------------------------------
/// w ##Class(web.DHCEQInStockNew).SaveDataFromPlan("11^11^^224^1","3")
ClassMethod SaveDataFromPlan(val As %Library.String = "")
{
	n SourceMainID,SourceListID,ISRowID,Loc,UserDR
	k PLIST, PLISTMX
	s SourceMainID=$p(val,"^",1)	;验收单ID
	s SourceListID=$p(val,"^",2)	;验收明细ID
	s ISRowID=$p(val,"^",3)		;入库单ID
	s Loc=$p(val,"^",4)			;库房
	s UserDR=$p(val,"^",5)			;操作员
	s SourceType=3

	if SourceMainID="" q -1019
	if $g(^DHCEQBuyPlan(SourceMainID))="" q -1019
	if $p($g(^DHCEQBuyPlan(SourceMainID)),"^",46)="Y" q -1019	;OCR_InvalidFlag
	TStart
	i ISRowID="" //增加主表和明细表
	{
		s PLIST(2)=##class(web.DHCEQCommon).TransValueFromPage($ZDate($H,4),"date") //入库日期
		S PLIST(3)=Loc //库房
		S PLIST(5)=UserDR //申请人
		s PLIST(6)=PLIST(2) //申请日期
		S PLIST(11)="0" //状态
		s (Remark,EquipTypeDR,ISNo,OriginDR,FromDeptDR,ProviderDR,BuyLocDR,StatCatDR)=""
		s Remark=$Piece($Get(^DHCEQBuyPlanList(SourceListID)),"^",9) //备注	Mozy0057	2011-8-15
		s ItemDR=$Piece($Get(^DHCEQBuyPlanList(SourceListID)),"^",18)
		i ItemDR'="" d
		.s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3) //设备类组
		.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5) //设备类型
		.S ISNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",+$H,$p(val,"^",3),EquipTypeDR) //入库单号
		S OriginDR=""
		S FromDeptDR=""
		S ProviderDR=""
		S BuyReqListDR=$Piece($Get(^DHCEQBuyPlanList(SourceListID)),"^",10) //申购部门
		i BuyReqListDR'=""  d
		.s BuyReqDR=$Piece($Get(^DHCEQBuyRequestList(BuyReqListDR)),"^",1)
		.s BuyLocDR=$Piece($Get(^DHCEQBuyRequest(BuyReqDR)),"^",2)
		S PLIST(12)=Remark //备注
		S PLIST(15)=ISNo //入库单号
		S PLIST(16)=OriginDR //设备来源
		S PLIST(17)=FromDeptDR //来源部门
		S PLIST(18)=ProviderDR //供应商
		S PLIST(19)=BuyLocDR //申购部门
		S PLIST(21)=EquipTypeDR	 //设备类组
		S PLIST(22)=StatCatDR //设备类型
		S PLIST(26)="N" //无效标识
		
		//主表
	 	&SQL(insert into sqluser.DHC_EQInStock values :PLIST())
	 	if SQLCODE
	 	{
		 	TRollBack
		 	q SQLCODE
	 	}
	 	s ISRowID=$G(%ROWID)
	}
	
	//明细表
	s PLISTMX(2)=ISRowID //主表Rowid
	s PLISTMX(4)="Y" //批入库标志
	s (InvoiceNo,Name,ManuFactoryDR,OriginalFee,QuantityNum,ModelDR,UnitDR,EquipCatDR,ItemDR,LimitYearsNum,StatCatDR,SourceID)=""
	s Name=$p($g(^DHCEQBuyPlanList(SourceListID)),"^",2) //设备名称
	s ManuFactoryDR=$p($g(^DHCEQBuyPlanList(SourceListID)),"^",4) //生产厂家
	s OriginalFee=$p($g(^DHCEQBuyPlanList(SourceListID)),"^",6) //设备原值
	s QuantityNum=$p($g(^DHCEQBuyPlanList(SourceListID)),"^",7) //数量
	s ModelDR=$p($g(^DHCEQBuyPlanList(SourceListID)),"^",3) //机型
	
	s ItemDR=$p($g(^DHCEQBuyPlanList(SourceListID)),"^",18) //设备项DR
	i ItemDR'="" d
	.s UnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	.s EquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	.s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
	.i StatCatDR'=""  d
	..s LimitYearsNum=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",9)
	..s DepreMethodDR=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",10)
	s PLISTMX(6)=Name //设备名称
	s PLISTMX(7)=ManuFactoryDR //生产厂家
	s PLISTMX(8)=OriginalFee //设备原值
	s PLISTMX(9)=QuantityNum //数量
	s PLISTMX(10)=ModelDR //机型
	s PLISTMX(11)=UnitDR //单位
	s PLISTMX(15)=EquipCatDR //设备分类
	s PLISTMX(17)=ItemDR //设备项DR
	s PLISTMX(16)=LimitYearsNum //使用年限	
	s PLISTMX(18)=StatCatDR //设备类型
	s PLISTMX(19)=SourceType //来源类型0:设备,1:设备项,2:验收单
	s PLISTMX(20)=SourceListID //来源ID
	&SQL(insert into sqluser.DHC_EQInStockList values :PLISTMX())
	if SQLCODE
	{
		TRollBack
		q SQLCODE
	}
	
 	if InvoiceNo'=""
 	{
 		s ISLRowID=$G(%ROWID)
		s SQLCODE=..UpdateInvoiceInfo(ISLRowID, InvoiceNo, "", "")
 		if SQLCODE
 		{
	 		TRollBack
	 		q SQLCODE
 		}
 	}
 	
	TCommit
	q ISRowID
}

/// Add By DJ 2013-06-21
/// 描述:检测发票号在哪些业务单据中使用过,按总单统计
/// w ##Class(web.DHCEQInStockNew).CheckInvoiceNo("12345","6353","",1)
ClassMethod CheckInvoiceNo(InvoiceNo As %String = "", vISRowID As %String = "", ProviderDR As %String = "", IUMType As %String = "")
{
	i InvoiceNo="" q 0	//2013-11-06 DJ
	s vTimes=0
	s IVRowID=0
	f  s IVRowID=$o(^DHCEQInvoice(0,"InvoiceNo",InvoiceNo,IVRowID))  q:IVRowID=""  d
	.q:$p(^DHCEQInvoice(IVRowID),"^",16)'="N"
	.s SourceID=0
	.f  s SourceID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",IUMType,IVRowID,SourceID))  q:SourceID=""  d
	..i IUMType=1  d
	...s ISRowID=$p($g(^DHCEQInStockList(SourceID)),"^",1)
	...s ISProvider=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	...i (ISRowID'=vISRowID)&&((ProviderDR="")||(ISProvider=ProviderDR)) s vTimes=vTimes+1
	
	q vTimes
}

/// Mozy	2014-3-13
/// 设备入库单审阅
/// d ##class(%ResultSet).RunQuery("web.DHCEQInStockNew","GetCheckInStock")
Query GetCheckInStock(InStockNo As %Library.String = "", LocDR As %Library.String = "", ProviderDR As %Library.String = "", EquipNo As %Library.String = "", EquipName As %Library.String = "", BuyLocDR As %Library.String = "", EquipTypeDR As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", ApproveRole As %Library.String = "", CheckedFlag As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TInStockNo:%String,TInDate:%String,TProvider:%String,TLoc:%String,TBuyLoc:%String,TBuyUser:%String,TStatus:%String,TOrigin:%String,TPurposeType:%String,TEquipType:%String,TRemark:%String,TEquipName:%String,TNum:%String,TTotalFee:%String,TCheckInfos")
{
}

ClassMethod GetCheckInStockExecute(ByRef qHandle As %Binary, InStockNo As %Library.String = "", LocDR As %Library.String = "", ProviderDR As %Library.String = "", EquipNo As %Library.String = "", EquipName As %Library.String = "", BuyLocDR As %Library.String = "", EquipTypeDR As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", ApproveRole As %Library.String = "", CheckedFlag As %Library.String = "") As %Status
{
 	new repid, index,rowid,ApproveType,CheckInfos
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQInStock(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetCheckInStock
	.Set TRowID = rowid
	.Set TInDate = $Piece($Get(^DHCEQInStock(rowid)),"^",1)
	.Quit:(TInDate>EndDate)||(TInDate<StartDate)
	.Set TInDate = ##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	.Set TInStockNo = $Piece($Get(^DHCEQInStock(rowid)),"^",14)
	.Quit:TInStockNo=""
	.Quit:(InStockNo'="")&(TInStockNo'[InStockNo)
	.Set TProviderDR = $Piece($Get(^DHCEQInStock(rowid)),"^",17)
	.Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	.If TProviderDR '="" Do
	..Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	..Set TProvider = ##class(web.DHCEQCommon).GetSplitDataByFlag(TProvider,"-")
	.Set TLocDR = $Piece($Get(^DHCEQInStock(rowid)),"^",2)
	.Quit:(1=(##class(web.DHCEQCommon).LocIsInEQ(2,TLocDR)))
	.Quit:(LocDR'="")&&(LocDR'=TLocDR)
	.If TLocDR '="" Do
	..Set TLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	..Set TLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag(TLoc,"-")
	.Set TStatus = $Piece($Get(^DHCEQInStock(rowid)),"^",10)
	.Quit:(TStatus'="2")
	.Set TStatus="审核"
	.Set TBuyLocDR = $Piece($Get(^DHCEQInStock(rowid)),"^",18)
	.Quit:(BuyLocDR'="")&&(TBuyLocDR'=BuyLocDR)
	.If TBuyLocDR '="" Do
	..Set TBuyLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TBuyLocDR)
	..Set TBuyLoc = ##class(web.DHCEQCommon).GetSplitDataByFlag(TBuyLoc,"-")
	.Set TBuyUserDR = $Piece($Get(^DHCEQInStock(rowid)),"^",19)
	.If TBuyUserDR '="" Set TBuyUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TBuyUserDR)
	.Set TOriginDR = $Piece($Get(^DHCEQInStock(rowid)),"^",15)
	.If TOriginDR '="" Set TOrigin = $Piece($Get(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	.Set TEquipTypeDR = $Piece($Get(^DHCEQInStock(rowid)),"^",20)
	.Quit:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.If TEquipTypeDR '="" Set TEquipType = $Piece($Get(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.If $Piece($Get(^DHCEQInStock(rowid)),"^",23)'="" Set TPurposeType=$Piece($Get(^DHCEQCCode("DHCEQCPurposeType",$Piece($Get(^DHCEQInStock(rowid)),"^",23))),"^",2)
	.Set TRemark = $Piece($Get(^DHCEQInStock(rowid)),"^",11)
	.Set TTotal=##Class(web.DHCEQInStockNew).GetOneInStockTotalFeeNum(rowid)
	.Set TNum=$Piece(TTotal,"^",1)
	.Set TTotalFee=$Piece(TTotal,"^",2)
	.Set id=""
	.For  Set id=$Order(^DHCEQInStockList(0,"InStock",rowid,id)) Quit:id=""  Do
	..If TEquipName'="" Set TEquipName=TEquipName_","
	..Set TEquipName=TEquipName_$Piece($Get(^DHCEQInStockList(id)),"^",5)
	.Quit:(EquipName'="")&&(TEquipName'[EquipName)
	.
	.;审阅记录
	.Set Flag="N"
	.If $Data(^DHCEQInStock(rowid,"Check")) Do
	..Set CheckInfos=$Get(^DHCEQInStock(rowid,"Check"))
	..Set LenCheck=$L(CheckInfos,",")
	..For n=1:1:LenCheck Do
	...Set Info=$Piece(CheckInfos,",",n)
	...If ApproveRole=$Piece(Info,"^",1) Set Flag="Y"
	...If TCheckInfos'="" Set TCheckInfos=TCheckInfos_","
	...Set TCheckInfos=TCheckInfos_$Piece($Get(^DHCEQCCode("DHCEQCApproveRole",$Piece(Info,"^",1))),"^",2)
	...Set TCheckInfos=TCheckInfos_":"_##Class(web.DHCEQCommon).GetTrakNameByID("user", $Piece(Info,"^",2))
	.Quit:(CheckedFlag'="")&(CheckedFlag'=Flag)
	.Quit:(CheckedFlag="")&(Flag="Y")
	.
	.Do OutputRowGetCheckInStock
	Quit $$$OK
OutputRowGetCheckInStock
	Set Data=$lb(TRowID,TInStockNo,TInDate,TProvider,TLoc,TBuyLoc,TBuyUser,TStatus,TOrigin,TPurposeType,TEquipType,TRemark,TEquipName,TNum,TTotalFee,TCheckInfos)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetCheckInStock
	Set (TRowID,TInStockNo,TInDate,TProvider,TLoc,TBuyLoc,TBuyUser,TStatus,TOrigin,TPurposeType,TEquipType,TRemark,TEquipName,TNum,TTotalFee,TCheckInfos)=""
	Quit
}

ClassMethod GetCheckInStockFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckInStockExecute ]
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

ClassMethod GetCheckInStockClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckInStockExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 审阅入库单操作
/// RowIDs:入库单id串
/// ApproveRole:审阅角色id
/// ReCheck:是否重载审阅信息
/// w ##Class(web.DHCEQInStockNew).GetToCheck("13101^13102", 18)
ClassMethod GetToCheck(RowIDs As %String = "", ApproveRole As %String = "", ReCheck As %String = "N")
{
	Quit:(RowIDs="")||(ApproveRole="")
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (RowIDs,ApproveRole,ReCheck,User)
	
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set LenRowID=$L(RowIDs,"^")
	Set Count=0
	For id=1:1:LenRowID Do
	.Set RowID=$Piece(RowIDs,"^",id)
	.If $Data(^DHCEQInStock(RowID)) Do
	..If $Data(^DHCEQInStock(RowID,"Check")) Do
	...Set CheckInfos=$Get(^DHCEQInStock(RowID,"Check"))
	...;遍历审阅记录
	...Set FindFlag=0
	...Set LenCheck=$L(CheckInfos,",")
	...For n=1:1:LenCheck Do
	....Set Info=$Piece(CheckInfos,",",n)
	....If ApproveRole=$Piece(Info,"^",1) Set FindFlag=n
	...
	...If FindFlag>0 Do
	....;检索到同角色的审阅记录
	....If ReCheck'="N" Do
	.....Set $Piece(CheckInfos,",",n)=ApproveRole_"^"_User_"^"_Date_"^"_Time
	.....Set ^DHCEQInStock(RowID,"Check")=CheckInfos
	...Else  DO
	....Set ^DHCEQInStock(RowID,"Check")=CheckInfos_","_ApproveRole_"^"_User_"^"_Date_"^"_Time
	..Else  Do
	...Set ^DHCEQInStock(RowID,"Check")=ApproveRole_"^"_User_"^"_Date_"^"_Time
	..Set Count=Count+1
	
	Quit Count
}

/// Add By DJ 2017-01-05
/// 描述:检测入库单是否满足自动出库条件
/// w ##Class(web.DHCEQInStockNew).CheckAutoMoveFlag(50)
ClassMethod CheckAutoMoveFlag(vRowID As %String = "")
{
	n CheckFlag,ISLRowID,ISLSourceType,ISLSourceID,ISLUseLoc,ISLName,Result
	s Result=""
	i vRowID="" q "N"
	
	s CheckFlag="Y"
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",vRowID,ISLRowID))  q:(ISLRowID="")||(CheckFlag'="Y")  d
	.s ISLSourceType=$p($g(^DHCEQInStockList(ISLRowID)),"^",18)
	.s ISLSourceID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
	.s ISLName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
	.i ISLSourceType="1" s CheckFlag="N^"_ISLName		//设备项无使用科室不能自动出库
	.q:CheckFlag'="Y"
	.i ISLSourceType="2"  d
	..///modified by ZY 20210308
	..s LocListFlag=+##class(web.DHCEQCommon).GetSysInfo("201015")
	..i LocListFlag'=1  d
	...s ISLUseLocDR=$p($g(^DHCEQOpenCheckList(ISLSourceID)),"^",33)		//入库明细来自验收单,验收单中无使用科室
	...i ISLUseLocDR="" s CheckFlag="N^"_ISLName
	..e  d
	...s Result=##Class(web.DHCEQ.EM.BUSInStockListLoc).CheckInStockListLoc(vRowID,ISLRowID)
	...i Result'="" s CheckFlag="N^"_ISLName
	
	q CheckFlag
}

/// 20170329 Mozy0185
/// 获取自动入库出库参数
/// 返回：自动出库
/// w ##Class(web.DHCEQInStockNew).GetAutoInOut(5)
ClassMethod GetAutoInOut(val As %String = "")
{
	;判断单据当前是否为最后一步
	n (val)
	s RowID=$p(val,"^",1)
	s CurRole=$p(val,"^",2)
	s RoleStep=+$p(val,"^",3)
	
	s EquipTypeDR=$p($g(^DHCEQInStock(RowID)),"^",20)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("13")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","")
	i ApproveSet="" q 0	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	i (LastFlag="Y")||(NextStep="")
	{
	 	Quit +##class(web.DHCEQCommon).GetSysInfo("301010")
	}
	Quit 0
}

/// Mozy0217  2018-11-01
/// 判断入库明细记录是否存在有配置设备
/// 		返回值		Find:空		未匹配到配置记录
/// w ##Class(web.DHCEQInStockNew).CheckConfigDR(712)
ClassMethod CheckConfigDR(RowID As %String = "")
{
	n Find, ListID
	
	s Find=""
	i (RowID="") q Find
	
	s ListID=0	
	f  s ListID=$O(^DHCEQInStockList(0,"InStock",RowID,ListID)) q:(ListID="")||(Find'="")  d
	.q:($Piece($Get(^DHCEQInStockList(ListID)),"^",18)'=2)
	.s Find = ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1, $Piece($Get(^DHCEQInStockList(ListID)),"^",19))
	
	q Find
}

/// Mozy0217  2018-11-01
/// 描述:根据入库单明细对应的验收明细生成其设备配置的入库单明细
/// 入参： ISRowID：入库单ID
/// 			OCLRowid:验收明细ID
/// w ##Class(web.DHCEQInStockNew).InsertISLForConfig(707)
ClassMethod InsertISLForConfig(ISRowID As %String = "")
{
	i ISRowID="" q -1
	i ##class(web.DHCEQCommon).GetSysInfo("201011")'=1 q 0  //Mozy	976774	2019-8-1	0:复制 1：生成台账
	n ParentISLDR, OCLRowid, ConfigDRs, ConfigDR, Length,ISLRowID,Flag,i,valList,InvoiceNo
	
	s Flag=0
	s ParentISLDR=0 
	f  s ParentISLDR=$o(^DHCEQInStockList(0,"InStock",ISRowID,ParentISLDR)) quit:(ParentISLDR="")||(Flag'=0)  d
	.q:$p($g(^DHCEQInStockList(ParentISLDR)),"^",18)'=2		;过滤非来自验收明细的入库记录
	.q:$p($g(^DHCEQInStockList(ParentISLDR)),"^",22)'=""	;过滤设备配置的入库明细记录
	.s OCLRowid=$p($g(^DHCEQInStockList(ParentISLDR)),"^",19)
	.q:OCLRowid=""
	.s ConfigDRs=##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1, OCLRowid)
	.q:ConfigDRs=""
	.d InsertNewList
	
	q Flag
InsertNewList
	k PLISTMX
	s Length=$l(ConfigDRs,",")
	s PLISTMX(2)=ISRowID  					;InStockDR
	
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s ConfigDR=	$p(ConfigDRs,",",i)
		if ($p($g(^DHCEQConfig(ConfigDR)),"^",1)=1)
		{
			;Type：0:附件，1:附属设备，2:文件， 3:硬件配置，4：软件配置
			;s PLISTMX(3)=$p(valList,"^",3)  	;EquipDR
			s PLISTMX(4)="Y"					;BatchFlag
			;s PLISTMX(5)=$p(valList,"^",)		;BuyPlanListDR
			s PLISTMX(6)="(附)"_$p($g(^DHCEQConfig(ConfigDR)),"^",5)  			;EquipName
			s PLISTMX(17)=$p($g(^DHCEQConfig(ConfigDR)),"^",4)  		;TItemDR
			s PLISTMX(18)=$p($g(^DHCEQCCode("DHCEQCMasterItem", PLISTMX(17))),"^",5)  	;TStatCatDR
			s PLISTMX(7)=$p($g(^DHCEQConfig(ConfigDR)),"^",11)  		;TManuFactoryDR
			s PLISTMX(8)=$p($g(^DHCEQConfig(ConfigDR)),"^",6)  			;TOriginalFee
			s PLISTMX(9)=$p($g(^DHCEQConfig(ConfigDR)),"^",7)  			;TQuantityNum
			s PLISTMX(10)=##Class(web.DHCEQCModel).UpdModel($p($g(^DHCEQConfig(ConfigDR)),"^",13), PLISTMX(17))  	;TModelDR
			s PLISTMX(11)=$p($g(^DHCEQConfig(ConfigDR)),"^",8)  			;TUnitDR
			;s PLISTMX(13)=$p(valList,"^",10)  	;TRemark
			//s PLISTMX(14)=$p(valList,"^",)	;AppendFee
			s PLISTMX(15)=$p($g(^DHCEQCCode("DHCEQCMasterItem", PLISTMX(17))),"^",4)  	;TEquipCatDR
			i PLISTMX(15)'="" d
	 		.s PLISTMX(16) = ##Class(web.DHCEQCEquipeCat).GetYearsByCatID(PLISTMX(15), PLISTMX(18))	;TUserYearsNum
			s PLISTMX(19)=2 					;TSourceType
			s PLISTMX(20)=OCLRowid 				;TSourceID
			s PLISTMX(23)=ConfigDR 				;Hold4
			&SQL(Insert Into SQLUSER.DHC_EQInStockList Values :PLISTMX())
			i SQLCODE
	 		{
				s Flag=SQLCODE
	 		}
	 		q:Flag'=0
	 		s ISLRowID=$G(%ROWID)
	 		
	 		s InvoiceNo=$p($g(^DHCEQConfig(ConfigDR)),"^",26)
	 		s SQLCODE=..UpdateInvoiceInfo(ISLRowID, InvoiceNo, "", "")
	 		i SQLCODE
			{
				s Flag=SQLCODE
			}
		}
	}
	Quit
}

/// Modified By ZY0201 增加附属设备信息输出
/// HISUI改造需重新调整 曾超
/// add by kdf 2018-01-16
/// 用于入库单润乾打印
/// modified by sjh BUG00019 增加输出采购人
/// d ##class(%ResultSet).RunQuery("web.DHCEQInStockNew","InStockList","1")
Query InStockList(RowID As %String = "") As %Query(ROWSPEC = "TInStockNo:%String,TInDate:%String,TLoc:%String,TEquipType:%String,TProvider:%String,TRowid:%String,TName:%String,TManuFactory:%String,TOriginalfee:%String,TQty:%String,TAmount:%String,TModel:%String,TEquipCat:%String,TUnit:%String,TLimityear:%String,TInvoiceNos:%String,TBuyUser:%String,THold4:%String,TEquipNo:%String,TStatCat:%String") [ SqlProc ]
{
}

ClassMethod InStockListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i RowID="" Quit $$$OK
	s TInStockNo=$p($g(^DHCEQInStock(RowID)),"^",14)
	s TInDate=$p($g(^DHCEQInStock(RowID)),"^",1)
	s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"CHNDate")
	
	s TLocDR = $p($g(^DHCEQInStock(RowID)),"^",2)
	s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)	//czf 2021-03-23 1835471
	
	s TEquipTypeDR = $p($g(^DHCEQInStock(RowID)),"^",20)
	i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	
	s TProviderDR = $p($g(^DHCEQInStock(RowID)),"^",17)
	i TProviderDR'="" s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TBuyUserDR=$p($g(^DHCEQInStock(RowID)),"^",19)
	s TBuyUser=""
	i TBuyUserDR'="" s TBuyUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TBuyUserDR) // add by sjh 2019-12-05 BUG00019
	
	s rowid=0 
	f  s rowid=$o(^DHCEQInStockList(0,"InStock",RowID,rowid))  quit:rowid=""  d
	.d ResetVariablesInStockList
	.q:$p($g(^DHCEQInStockList(rowid)),"^",22)'=""		//过滤附属设备
	.s TRowid = rowid
	.s TName=$p($g(^DHCEQInStockList(rowid)),"^",5)
	.s TManuFactoryDR = $p($g(^DHCEQInStockList(rowid)),"^",6)
    .i TManuFactoryDR'="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by czf 1252357
    .s TOriginalfee=+$p($g(^DHCEQInStockList(rowid)),"^",7)
    .s TQty=+$p($g(^DHCEQInStockList(rowid)),"^",8)
    .s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQty*TOriginalfee,"",2)
	.s TModelDR = $p($g(^DHCEQInStockList(rowid)),"^",9)
	.i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TEquipCatDR =$p($g(^DHCEQInStockList(rowid)),"^",14)
	.i TEquipCatDR'="" s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	.s TUnitDR = $p($g(^DHCEQInStockList(rowid)),"^",10)
	.i TUnitDR'="" s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TLimityear=$p($g(^DHCEQInStockList(rowid)),"^",15)
	.s TStatCatDR=$p($g(^DHCEQInStockList(RowID)),"^",17)	//fx 2022-09-7
	.i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,rowid)		//czf 2022-05-19 入库单发票号取值错误
	.s InvoiceLen=$l(return,"&")
	.for i=1:1:InvoiceLen d
	..s InvoiceInfo=$p(return,"&",i)
	..s PerInvoiceNo=$p(InvoiceInfo,"^",1)
	..i (TInvoiceNos'="")&&((","_TInvoiceNos_",")'[(","_PerInvoiceNo_",")) s TInvoiceNos=TInvoiceNos_","_PerInvoiceNo
	..i TInvoiceNos="" s TInvoiceNos=PerInvoiceNo
	.s THold4=$p($g(^DHCEQInStockList(rowid)),"^",22)
	.i THold4'="" s THold4=TAmount
	.s TEquipNo=##class(web.DHCEQCommon).GetEquipNos(21,rowid,"","EquipNo")		//czf 2022-04-21
	.d OutputRowInStockList
	Quit $$$OK
OutputRowInStockList
	s Data=$lb(TInStockNo,TInDate,TLoc,TEquipType,TProvider,TRowid,TName,TManuFactory,TOriginalfee,TQty,TAmount,TModel,TEquipCat,TUnit,TLimityear,TInvoiceNos,TBuyUser,THold4,TEquipNo,TStatCat)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesInStockList
	s (TRowid,TName,TManuFactory,TOriginalfee,TQty,TAmount,TModel,TEquipCat,TUnit,TLimityear,TInvoiceNos,THold4,TEquipNo,TStatCatDR,TStatCat)=""
	quit
}

ClassMethod InStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InStockListExecute ]
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

ClassMethod InStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by lmm 2020-03-15 LMM0063
/// 描述：根据入库单id更改设备入库日期
/// 入参：vRowID 入库单id  TransDate入库日期
/// d ##Class(web.DHCEQInStockNew).CreateTransDate(2,"1111")
ClassMethod CreateTransDate(vRowID As %String = "", TransDate As %String = "")
{
	i (vRowID="")||(TransDate="")  q 0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s TransDate=##Class(web.DHCEQCommon).TransValueFromPage(TransDate,"date")
	s result=0
	i vRowID="" q "0"
	//add by lmm 2020-03-11
	s InStockNo=$p($g(^DHCEQInStock(vRowID)),"^",14)
	s AdjustInfo="1^false^^^入库单入库日期及折旧调整^1^^^0^"_InStockNo_"^^^"
	s ADID=##Class(web.DHCEQAdjustData).SaveAdjustData("",AdjustInfo)
	i (ADID<0) q "-1^未生成调整记录"  
	
	
	
	k ^TempDHCEQEquipNew
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",vRowID,ISLRowID))  q:(ISLRowID="")  d
	.s StoreLocDR=0
	.f  s StoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR))  q:(StoreLocDR="")  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocDR,rowid))  q:(rowid="")  d
	...s ^TempDHCEQEquipNew("Equip",rowid)=""
	
	s EquipID=0
	f  s EquipID=$o(^TempDHCEQEquipNew("Equip",EquipID))  q:(EquipID="")  d
	.s FromTransDate =$p($g(^DHCEQEquip(EquipID)),"^",45)
	.s TEquipTypeDR =$p($g(^DHCEQEquip(EquipID)),"^",63)
	.s TStatCatDR =$p($g(^DHCEQEquip(EquipID)),"^",75)
	.s TOriginDR =$p($g(^DHCEQEquip(EquipID)),"^",20)
	.s StoreLocDR =$p($g(^DHCEQEquip(EquipID)),"^",67)
	.s val=""
	.s val=EquipID_"^5^"_TransDate_"^入库日期修改^"_User
	.s result=##Class(web.DHCEQMonthDepre).ExecuteAdjustDataNew(val,1)
	.q:result'="0"
	.s TDepreTotal =$p($g(^DHCEQEquip(EquipID)),"^",35)
	.s TNetFee =$p($g(^DHCEQEquip(EquipID)),"^",28)
	.s AdjustListInfo=ADID_"^"_EquipID_"^"_"^"_StoreLocDR_"^"_TEquipTypeDR_"^"_TStatCatDR_"^"_TOriginDR_"^"_"^"_TDepreTotal_"^"_TNetFee_"^"_FromTransDate_"^"_TransDate_"^"
	.s ADLID=##Class(web.DHCEQAdjustData).SaveAdjustDataList("",AdjustListInfo,"0")
	k ^TempDHCEQEquipNew
	
	q result
}

/// 固定资产入库单打印信息
/// w ##class(web.DHCEQInStockNew).GetInStockInfo(1)
ClassMethod GetInStockInfo(rowid) As %String
{
	q:rowid="" ""
	s retInfo=##Class(web.DHCEQInStockNew).GetOneInStock(rowid)
	s InStockDR=rowid,Rowid=0
	s InvoiceNosList=""
	f  s Rowid=$o(^DHCEQInStockList(0,"InStock",InStockDR,Rowid))  quit:Rowid=""  d
	.s InStockD=$p($g(^DHCEQInStockList(Rowid)),"^",1)
	.q:InStockD'=InStockDR
	.s InvoiceNos=""
	.s InvoiceNos=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,Rowid),"^",1) //发票号
	.q:InvoiceNos=""
	.i InvoiceNosList="" s InvoiceNosList=InvoiceNos
	.e  i InvoiceNosList'[InvoiceNos s InvoiceNosList=InvoiceNosList_","_InvoiceNos 
	q retInfo_"^"_InvoiceNosList
}

}
