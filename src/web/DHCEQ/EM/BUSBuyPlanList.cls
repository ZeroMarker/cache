Class web.DHCEQ.EM.BUSBuyPlanList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-08-16
/// 描述：hisui改造 查询采购计划单
/// 入参：Name 设备项名称
///      Type 2:采购单 3:计划单
///      AssetType 资产类型
/// add by lmm 2019-10-23 添加EquipTypeDR入参 1061129
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuyPlanList","GetBPList","","3")
Query GetBPList(Name, Type, AssetType As %Library.String = "", EquipTypeDR As %Library.String = "") As %Query(ROWSPEC = "TItem:%String,TRowID:%String,TModel:%String,TNum:%String,TManuFac:%String,TBuyPlanNo:%String,TItemCode:%String,TEquipType:%String,TEquipTypeDR:%String,TStatCat:%String,TStatCatDR:%String,TEquipCat:%String,TEquipCatDR:%String,TUnit:%String,TUnitDR:%String,TModelDR:%String,TManuFacDR:%String,TTestFlag:%String,TUrgencyFlag:%String,TPrice:%String,TItemDR:%String,TBuyPlanName:%String,TLimitYears:%String,TCommonName:%String,TPurposeTypeDR:%String,TPurposeType:%String,TPurchaseTypeDR:%String,TPurchaseType:%String")
{
}

ClassMethod GetBPListExecute(ByRef qHandle As %Binary, Name, Type, AssetType As %Library.String = "", EquipTypeDR As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;type 2:采购单 3:计划单
	s index=1
	s rowid=0
	d BuildDataGetBPList
	Quit $$$OK
BuildDataGetBPList
	if Type=3  //Modified By QW20200820 BUG:QW0076 begin 增加来源方式招标输出
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQBuyPlan(0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
		.;过滤掉不能访问的类组
		.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR) //add by lmm 2019-10-23 1061129
		.s TEquipType = $P(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR),"^",2)
		.s TBuyPlanDR=0
		.f  s TBuyPlanDR=$o(^DHCEQBuyPlan(0,"EquipType",TEquipTypeDR,TBuyPlanDR)) quit:TBuyPlanDR=""  d
		..;过滤掉状态非审核的
		..q:$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",6)'=2
		..s (TPurposeTypeDR,TPurposeType)=""
		..s (TPurchaseTypeDR,TPurchaseType)=""  ;add by lmm 2018-03-01 begin 523557
		..;获取计划信息
		..s TBuyPlanName=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",1)
		..s TBuyPlanNo=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",25)	
		..s TUrgencyFlag=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",33)
		..s TPurposeTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",42)
		..i TPurposeTypeDR'="" s TPurposeType=$P(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR),"^",2)
		..;add by lmm 2018-03-01 begin 523557
		..s TPurchaseTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",28)
		..i TPurchaseTypeDR'="" s TPurchaseType=$P(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR),"^",2)
		..;add by lmm 2018-03-01 end 523557
		..;获取计划明细信息
		..s rowid=0
		..f  s rowid=$o(^DHCEQBuyPlanList(0,"BuyPlan",TBuyPlanDR,rowid)) quit:rowid=""  d
		...d ResetVariablesGetBPList
		...s TRowID = rowid
		...s TCommonName = $p($g(^DHCEQBuyPlanList(rowid)),"^",2)	//2013-06-24 DJ0118
		...s TModelDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",3)
		...i TModelDR'="" s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
		...s TManuFacDR=$p($g(^DHCEQBuyPlanList(rowid)),"^",4)
		...i TManuFacDR'="" s TManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)		//modiified by czf 1244449
		...s TTestFlag=$p($g(^DHCEQBuyPlanList(rowid)),"^",5)
		...s TPrice=$p($g(^DHCEQBuyPlanList(rowid)),"^",6)
		...s TQuantityNum = $p($g(^DHCEQBuyPlanList(rowid)),"^",7)
		...s TArriveNum=$p($g(^DHCEQBuyPlanList(rowid)),"^",17)
		...s TNum=TQuantityNum-TArriveNum
		...q:TNum<1
		...
		...s ItemDR= $p($g(^DHCEQBuyPlanList(rowid)),"^",18)
		...i ItemDR'="" d	//start by csj 2020-02-24 需求号：1187719
		....s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1) //2013-06-24 DJ0118
		....s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
		....s TStatCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
		....i TStatCatDR '="" s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
		....s TEquipCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
		....i TEquipCatDR '="" s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
		....s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
		....i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		...q:(Name'="")&&(TName'[Name)&&(TBuyPlanName'[Name)&&($e(TBuyPlanNo,1,$l(Name))'=Name)&&($ZCONVERT($e(TCode,1,$l(Name)),"U")'=Name)
		...Quit:(TStatCatDR'="")&&(AssetType'="")&&(AssetType'=0)&&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	/// modified by GR0027 卫计委与武汉资产类型兼容
		...//end by csj 2020-02-24 
		...;Modified by jdl 2012-3-7 JDL0120
		...s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
		...;modified by ZY0303 20220615 2712646
		...;quit:$D(^DHCEQOpenCheckList(0,"Source",3,rowid)) //过滤被验收占用招标
		...s FindFlag=0
		...s MXRowID=$o(^DHCEQOpenCheckList(0,"Source",3,rowid,0))
		...i MXRowID'=""  d
		....s MRowID=$p($g(^DHCEQOpenCheckList(MXRowID)),"^",1)		//modified by ZY0306 2712646
		....q:$p($g(^DHCEQOpenCheckRequest(MRowID)),"^",45)="Y"
		....s FindFlag=1
		...q:FindFlag'=0
		...
		...quit:$D(^DHCEQContractList(0,"SourceID",1,rowid))  //过滤被合同占用招标
		...quit:$D(^DHCEQIFBBag(0,"Extend",2,rowid))  //过滤被合同占用招标
		...d OutputRowGetBPList
	}
	elseif Type=2
	{
		;2招标
		s IFBRowID=0
 		f  s IFBRowID=$o(^DHCEQIFB(IFBRowID))	q:IFBRowID=""  d
 		.s BagRowID=0
 		.f  s BagRowID=$o(^DHCEQIFBBag(0,"IFB",IFBRowID,BagRowID))	q:BagRowID=""  d
 		..s BagData=$g(^DHCEQIFBBag(BagRowID))
 		..quit:$D(^DHCEQOpenCheckList(0,"Source",2,BagRowID)) //过滤被验收占用招标
		..quit:$D(^DHCEQContractList(0,"SourceID",2,BagRowID))  //过滤被合同占用招标
		..Set IFBDR=$Piece($Get(^DHCEQIFBBag(BagRowID)),"^",1)
		..Quit:$Piece($Get(^DHCEQIFB(IFBDR)),"^",43)'=2
		..s (TPurposeTypeDR,TPurposeType)=""
		..s (TPurchaseTypeDR,TPurchaseType)=""
		..Do ResetVariablesGetBPList
		..s TCommonName=$p(BagData,"^",13)	//设备名称
		..s TRowID=BagRowID
		..Set ItemDR=$Piece($Get(^DHCEQIFBBag(BagRowID)),"^",3)
		..i ItemDR'="" d
		...s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",1) //2013-06-24 DJ0118
		...s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
		...s TStatCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5)
		...i TStatCatDR '="" s TStatCat = $P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
		...s TEquipCatDR = $p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
		...i TEquipCatDR '="" s TEquipCat = $P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
		...s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
		...i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		...s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
		...i TEquipTypeDR'=""  s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		..q:(TEquipTypeDR'="")&&(##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0)
		..Set TBuyPlanNo=$Piece($Get(^DHCEQIFB(IFBDR)),"^",3)
		..s TBuyPlanName=$Piece($Get(^DHCEQIFB(IFBDR)),"^",1)
		..Set TPrice=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",11)
		..Set TQuantityNum=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",5)
		..s TNum=TQuantityNum
		..Set Unit=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",4)
		..Set Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
		..Set TExtendTypeDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",9)
		..Set TExtendID = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",10)
		..i TExtendTypeDR=2
		...s TBuyPlanDR=$Piece($Get(^DHCEQBuyPlanList(TExtendID)),"^",1)
		...s TUrgencyFlag=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",33)
		...s TPurposeTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",42)
		...i TPurposeTypeDR'="" s TPurposeType=$P(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR),"^",2)
		...s TPurchaseTypeDR=$p($g(^DHCEQBuyPlan(TBuyPlanDR)),"^",28)
		...i TPurchaseTypeDR'="" s TPurchaseType=$P(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR),"^",2)
		...s TPrice=$p($g(^DHCEQBuyPlanList(TExtendID)),"^",6)
		...s TQuantityNum = $p($g(^DHCEQBuyPlanList(TExtendID)),"^",7)
		...s TArriveNum=$p($g(^DHCEQBuyPlanList(TExtendID)),"^",17)
		...s TNum=TQuantityNum-TArriveNum
		..q:TNum<1
		..Set TManuFacDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",6)
		..i TManuFacDR'="" Set TManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)
		..Set TModelDR=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",7)
		..i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
		..s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
		..q:(Name'="")&&(TName'[Name)&&(TBuyPlanName'[Name)&&($e(TBuyPlanNo,1,$l(Name))'=Name)&&($ZCONVERT($e(TCode,1,$l(Name)),"U")'=Name)
		..Quit:(TStatCatDR'="")&&(AssetType'="")&&(AssetType'=0)&&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))
		..Do OutputRowGetBPList
	}  //Modified By QW20200820 BUG:QW0076 End 增加来源方式招标输出
	quit
OutputRowGetBPList
	s Data=$lb(TName,TRowID,TModel,TNum,TManuFac,TBuyPlanNo,TCode,TEquipType,TEquipTypeDR,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TTestFlag,TUrgencyFlag,TPrice,ItemDR,TBuyPlanName,TLimitYears,TCommonName,TPurposeTypeDR,TPurposeType,TPurchaseTypeDR,TPurchaseType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBPList
	s (TName,TRowID,TModel,TNum,TManuFac,TCode,TStatCat,TStatCatDR,TEquipCat,TEquipCatDR,TUnit,TUnitDR,TModelDR,TManuFacDR,TTestFlag,TPrice,ItemDR,TCommonName)=""
	;s (TBuyPlanNo,TEquipType,TEquipTypeDR,TUrgencyFlag)="
	s TLimitYears=""
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

}
