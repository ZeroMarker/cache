Class web.DHCEQ.EM.BUSIFB Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add 20191012 by zy 增加参数输入
/// 招标包查询 hisui改造
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSIFB","IFBBagDetail","","12")
Query IFBBagDetail(RowID As %String = "", PlanListIDs As %String = "") As %Query(ROWSPEC = "IFBBRowID:%String,IFBBIFBDR:%String,IFBBBagNo:%String,IFBBExtendType:%String,IFBBExtendType_Desc:%String,IFBBExtendID:%String,IFBBExtend_Name:%String,IFBBItemDR:%String,IFBBItemDR_MIDesc:%String,IFBBHold1:%String,IFBBUnitDR:%String,IFBBUnitDR_UOMDesc:%String,IFBBModelDR:%String,IFBBModelDR_MDesc:%String,IFBBArg:%String,IFBBQuantity:%String,IFBBWinPrice:%String,IFBBAmount:%String,IFBBManuFactoryDR:%String,IFBBManuFactoryDR_MFDesc:%String,IFBLRowID:%String,IFBLVendorDR:%String,IFBLVendor:%String:,IFBLModelDR:%String,IFBLModel:%String,IFBLManuFactoryDR:%String,IFBLManuFactory:%String,IFBLArg:%String,IFBLPrice:%String,IFBLWinQty:%String,IFBBRemark:%String")
{
}

ClassMethod IFBBagDetailExecute(ByRef qHandle As %Binary, RowID As %String = "", PlanListIDs As %String = "") As %Status
{
	new repid, index, rowid, flag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set TotalNum=0
 	Set TotalFee=0
 	Kill ^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j)
	If RowID'=""
	{
		Set rowid=0
		For  Set rowid=$Order(^DHCEQIFBBag(0,"IFB",RowID,rowid))  Quit:rowid=""  Do
		.Set TBagNo = $Piece($Get(^DHCEQIFBBag(rowid)),"^",2)
		.Set ^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j,RowID,TBagNo,rowid)=""
		Set TBagNo=""
		For  Set TBagNo=$Order(^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j,RowID,TBagNo))  Quit:TBagNo=""  Do
		.Set rowid=0
		.For  Set rowid=$Order(^DHCEQTemp("DHCEQIFB","IFBBagDetail",$j,RowID,TBagNo,rowid))  Quit:rowid=""  Do
		..Do ResetVariablesIFBBagDetail
		..Set TRowID = rowid
		..Set TIFBDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",1)
		..Set TBagNo = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",2)
		..Set TExtendTypeDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",9)
		..Set TExtendID = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",10)
		..If TExtendTypeDR'="" Do
		...Set TExtendType=##class(web.DHCEQ.EM.BUSIFB).GetExtendTypeList(TExtendTypeDR)
		...If TExtendTypeDR=1 Do
		....Set TExtendName=$Piece($Get(^DHCEQBuyRequestList(TExtendID)),"^",1)	;采购申请
		....Set TExtendName=$Piece($Get(^DHCEQBuyRequest(TExtendName)),"^",1)
		....i TExtendName="" s TExtendName=$Piece($Get(^DHCEQBuyRequestList(TExtendID)),"^",2)   //add by wy 2020-1-10 1166773 项目名称为空时取设备名称           
		...
		...If TExtendTypeDR=2 Do
		....Set TExtendName=$Piece($Get(^DHCEQBuyPlanList(TExtendID)),"^",2)	;采购计划 modifed by wy 2019-3-15
		....;Set TExtendName=$Piece($Get(^DHCEQBuyPlan(TExtendName)),"^",1)
		...If TExtendTypeDR=0 d         
		....Set TExtendName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExtendID)),"^",1)   ;设备项
		..Set TItemDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",3)
		..If TItemDR '="" Set TItem = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)		
		..
		..Set TUnitDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",4)
		..If TUnitDR'="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..Set TQuantity = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",5)
		..Set TManuFactoryDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",6)
		..If TManuFactoryDR '="" Set TManuFactory =##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //modified by CZF0093
		..Set TModelDR = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",7)
		..If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		..Set TArg = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",8)
		..Set TWinPrice = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQIFBBag(TRowID)),"^",11),"")
		..Set TRemark = $Piece($Get(^DHCEQIFBBag(TRowID)),"^",12)
		..Set TCommonName=$Piece($Get(^DHCEQIFBBag(TRowID)),"^",13) //2013-06-24 DJ0118
		..Set flag=0
		..Set IFBLDR=0
		..//moddified by ZY0228 20200509
		..//For  Set IFBLDR=$Order(^DHCEQIFBList(0,"Source",TExtendTypeDR,TExtendID,IFBLDR))  Quit:(IFBLDR="")||(flag'=0)  Do
		..For  Set IFBLDR=$Order(^DHCEQIFBList(0,"Source",3,TRowID,IFBLDR))  Quit:(IFBLDR="")||(flag'=0)  Do
		...Set THold1 = $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",29)    //通过招标明细ID过滤中标供应商
		...q:((THold1'="")&&(THold1'[TRowID))
		...Set WinFlag = $Piece($Get(^DHCEQIFBList(IFBLDR)),"^",14)
		...;中标供应商
		...If WinFlag="Y" Do
		....Set TListRowID = IFBLDR
		....Set flag=1
		....Set TListVendorDR = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",4)
		....s TListVendor=$Piece($Get(^DHCEQIFBList(TListRowID)),"^",3)
	    ....s TListManuFactory=$Piece($Get(^DHCEQIFBList(TListRowID)),"^",5)
	    ....s TListManuFactoryDR=$Piece($Get(^DHCEQIFBList(TListRowID)),"^",6)
        ....s TListModel=$Piece($Get(^DHCEQIFBList(TListRowID)),"^",7)
	    ....s TListModelDR=$Piece($Get(^DHCEQIFBList(TListRowID)),"^",8)		
		....Set TListArg = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",11)
		....Set TListPrice = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQIFBList(TListRowID)),"^",12),"")
		....Set TWinQty = $Piece($Get(^DHCEQIFBList(TListRowID)),"^",15)
		..Set TotalNum = TotalNum+TQuantity
		..Set TAmount = TWinPrice*TQuantity
		..Set TotalFee=TotalFee+TAmount
		..Set TAmount = ##Class(web.DHCEQCommon).FormatNumber(TAmount,"") //add by lmm 2020-05-18 UI调整
		..Do OutputRowIFBBagDetail
	}	///add 20191012 by zy 计划明细合并控制
	else
	{
		if PlanListIDs'=""
		{
			s Len=$l(PlanListIDs,",")
			for i=1:1:Len  d
			.s PlanListID=$Piece(PlanListIDs,",",i)
			.do ResetVariablesIFBBagDetail
			.Set TRowID = ""   //rowid
		    .Set TIFBDR = ""  //$Piece($Get(^DHCEQIFBBag(TRowID)),"^",1)
		    .Set TBagNo = ""  //$Piece($Get(^DHCEQIFBBag(TRowID)),"^",2)
			.Set TItemDR = $Piece($Get(^DHCEQBuyPlanList(PlanListID)),"^",18)
			.If TItemDR '="" Set TItem = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
			.Set TQuantity = $Piece($Get(^DHCEQBuyPlanList(PlanListID)),"^",7)
			.Set TManuFactoryDR = $Piece($Get(^DHCEQBuyPlanList(PlanListID)),"^",4)
			.If TManuFactoryDR '="" Set TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)	//modified by CZF0093
			.Set TModelDR = $Piece($Get(^DHCEQBuyPlanList(PlanListID)),"^",3)
			.If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
			.Set TExtendTypeDR =2  // $Piece($Get(^DHCEQIFBBag(TRowID)),"^",9)
			.Set TExtendID = PlanListID   //$Piece($Get(^DHCEQIFBBag(TRowID)),"^",10)
			.
			.If TExtendTypeDR'="" Do
			..Set TExtendType=##class(web.DHCEQIFB).GetIFBExtendType(TExtendTypeDR)
			..If TExtendTypeDR=1 Do
			...Set TExtendName=$Piece($Get(^DHCEQBuyRequestList(TExtendID)),"^",1)	;采购申请
			...Set TExtendName=$Piece($Get(^DHCEQBuyRequest(TExtendName)),"^",1)
		    ...i TExtendName="" s TExtendName=$Piece($Get(^DHCEQBuyRequestList(TExtendID)),"^",2)   //add by wy 2020-1-10 1166773 项目名称为空时取设备名称           
			
			..If TExtendTypeDR=2 Do
			...Set TExtendName=$Piece($Get(^DHCEQBuyPlanList(TExtendID)),"^",1)	;采购计划
			...Set TExtendName=$Piece($Get(^DHCEQBuyPlan(TExtendName)),"^",1)
			..
			.Set TWinPrice = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQBuyPlanList(PlanListID)),"^",6),"")
			.Set TCommonName=$Piece($Get(^DHCEQBuyPlanList(PlanListID)),"^",2)  //$Piece($Get(^DHCEQIFBBag(TRowID)),"^",13) //2013-06-24 DJ0118
			.If TItemDR '="" Set TUnitDR = $Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)	//modified by wy 2019-12-13 需求1135001
			.If TUnitDR'="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)	//add by csj 2019-10-23
			.Do OutputRowIFBBagDetail
		}
	 	elseif (RowID="")
		{
			d ResetVariablesIFBBagDetail
			d OutputRowIFBBagDetail
		}
		
	}
	Quit $$$OK
OutputRowIFBBagDetail
	Set Data=$lb(TRowID,TIFBDR,TBagNo,TExtendTypeDR,TExtendType,TExtendID,TExtendName,TItemDR,TItem,TCommonName,TUnitDR,TUnit,TModelDR,TModel,TArg,TQuantity,TWinPrice,TAmount,TManuFactoryDR,TManuFactory,TListRowID,TListVendorDR,TListVendor,TListModelDR,TListModel,TListManuFactoryDR,TListManuFactory,TListArg,TListPrice,TWinQty,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesIFBBagDetail
	Set (TRowID,TIFBDR,TBagNo,TExtendTypeDR,TExtendType,TExtendID,TExtendName,TItemDR,TItem,TCommonName,TUnitDR,TUnit,TModelDR,TModel,TArg,TQuantity,TWinPrice,TAmount,TManuFactoryDR,TManuFactory,TListRowID,TListVendorDR,TListVendor,TListModelDR,TListModel,TListManuFactoryDR,TListManuFactory,TListArg,TListPrice,TWinQty,TRemark)=""
	Quit
}

ClassMethod IFBBagDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IFBBagDetailExecute ]
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

ClassMethod IFBBagDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IFBBagDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description:   招标明细来源类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSIFB","GetIFBExtendType")
Query GetIFBExtendType(ExtendType As %String = "0") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetIFBExtendTypeExecute(ByRef qHandle As %Binary, ExtendType As %String = "0") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
 	s GetExtendType=##class(web.DHCEQCommon).GetSysInfo("103003")   //modified by wy 2019-5-17 868508
		if GetExtendType=0
		{
			;CustomValue="2^采购计划"
			s rowid=2
			s Code="01"
			s Desc="采购计划"
			d OutputRowGetIFBSourceType
		}
		elseif GetExtendType=1
		{
			;CustomValue="0^设备项&2^采购计划"
			s rowid=0
			s Code="01"
			s Desc="设备项"
			d OutputRowGetIFBSourceType
			s rowid=2
			s Code="02"
			s Desc="采购计划"
			d OutputRowGetIFBSourceType
		}
		else
		{
			;CustomValue=0^设备项&1^采购申请&2^采购计划
			s rowid=0
			s Code="01"
			s Desc="设备项"
			d OutputRowGetIFBSourceType
			s rowid=1
			s Code="02"
			s Desc="采购申请"
			d OutputRowGetIFBSourceType
			s rowid=2
			s Code="03"
			s Desc="采购计划"
			d OutputRowGetIFBSourceType
		}
	Quit $$$OK
OutputRowGetIFBSourceType
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetIFBExtendTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExtendTypeExecute ]
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

ClassMethod GetIFBExtendTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExtendTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSIFB","GetIFBExtendID",1,"","","")
Query GetIFBExtendID(ExtendType As %String = "", ExtendTypeDesc As %String = "", ExtendID As %String = "", IFBBRowID As %String = "") As %Query(ROWSPEC = "TExtendID:%String,TItemDR:%String,TName:%String,TModelDR:%String,TModel:%String,TManuFcDR:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TNo:%String,TUnit:%String,TUnitDR:%String")
{
}

ClassMethod GetIFBExtendIDExecute(ByRef qHandle As %Binary, ExtendType As %String = "", ExtendTypeDesc As %String = "", ExtendID As %String = "", IFBBRowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	if ExtendType=0
	{
		;0设备项
		s Hospital=##Class(web.DHCEQCommon).GetHospital()
		i Hospital'=""
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR)) quit:TEquipTypeDR=""  d
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR,rowid)) quit:rowid=""  d
			..d BuildDataGetItem
		}
		else
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid)) quit:rowid=""  d
			..d BuildDataGetItem
		}
		}
	elseif ExtendType=1
	{
		;1:采购申请
		s rowid=0
	 f  s rowid=$Order(^DHCEQBuyRequestList(rowid))  q:rowid=""  d
	.q:(ExtendID'="")&&(ExtendID'=rowid)
	.d ResetGetIFBExtendID
	.s TExtendID = rowid
	.s TBuyRequestDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",1)
	.s Status=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",16)
	.q:Status'=2  
	.s TPrjName=$Piece($Get(^DHCEQBuyRequest(TBuyRequestDR)),"^",1)
	.s TCommonName=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",2) 
	.q:(ExtendTypeDesc'="")&&(TCommonName'[ExtendTypeDesc) 
	.s TModelDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",3)
	.i TModelDR'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TManuFacDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",4)
	.i TManuFacDR'="" Set TManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)	//$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1) //moodified by CZF0093
	.s TPriceFee=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",6)
	.s TQuantityNum=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",7)
	.s BussListID=0    //add by wy 2019-6-3 920105   业务为招标时,检索计划明细占用采购申请的数量
	.For  s BussListID=$Order(^DHCEQBuyPlanList(0,"BuyRequestList",TExtendID,BussListID)) Quit:BussListID=""  Do
	..s TQuantityNum=TQuantityNum-$Piece($Get(^DHCEQBuyPlanList(BussListID)),"^",7)
	.q:TQuantityNum<1
	.s TTotalFee=TQuantityNum*TPriceFee
	.s TItemDR=$Piece($Get(^DHCEQBuyRequestList(rowid)),"^",17)
	.;modified by wy 2020-1-10 1166773 判断采购申请设备项是否为空并获取信息 
	.i TItemDR'="" d
	..Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	..i TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.e  d
	..s TName=TCommonName
	.;i TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	.;i TUnitDR'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.;i TItemDR'="" s TName=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1) //2013-06-24 DJ0118
	.s TRequestLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",2)
	.s TUseLoc=$p($g(^DHCEQBuyRequest(TBuyRequestDR)),"^",4)
	.i TRequestLoc'="" s TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLoc)
	.i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	
	.d OutputRowGetIFBExtendID
	}
	elseif ExtendType=2
	{
		;2计划		
		s rowid=0
		f  s rowid=$Order(^DHCEQBuyPlanList(rowid)) q:rowid=""  d
		.q:(ExtendID'="")&&(ExtendID'=rowid)
		.d ResetGetIFBExtendID
		.s TExtendID = rowid
		.s TBPDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",1)
		.;招标、合同、验收中,仅能使用状态为审核的计划明细
		.q:$p($g(^DHCEQBuyPlan(TBPDR)),"^",6)'=2
		.i TBPDR'="" Do
		..;s TName=$Piece($Get(^DHCEQBuyPlan(TBPDR)),"^",1)
		..s TNo=$Piece($Get(^DHCEQBuyPlan(TBPDR)),"^",25)
		.;i TName'="" Set TName=TName_"->"
		.;s TName=TName_$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",2)
		.s TName=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",2)    //add by wy 2019-3-15 需求850713
		.q:(ExtendTypeDesc'="")&&(TName'[ExtendTypeDesc)
		.s TModelDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",3)
		.s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
		.s TManuFacDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",4)
		.s TManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFacDR)
		.s TPriceFee=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",6)
		.s TQuantityNum=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",7)
		.
		.;业务为招标时,检索其他招标中已经使用该计划明细的数量
		.;业务为合同时,如果该计划明细已有对应招标记录则合同可用数应减去招标占用数,合同应从招标处选取数据
		.s BussListID=0
		.For  s BussListID=$Order(^DHCEQIFBBag(0,"Extend",2,TExtendID,BussListID)) Quit:BussListID=""  Do
		..s TQuantityNum=TQuantityNum-$Piece($Get(^DHCEQIFBBag(BussListID)),"^",5)
		.
		.;业务为招标时,除上面减去其它招标中已经占用的计划明细数量外还需要减去合同来自计划的明细数量
		.;业务为合同时,除上面减去招标中已经使用该计划明细的数量再减去其他合同中使用的计划明细数量
		.s BussListID=0
		.f  s BussListID=$Order(^DHCEQContractList(0,"SourceID",1,TExtendID,BussListID))  Quit:BussListID=""  Do
		..q:(IFBBRowID=BussListID)
		..s TQuantityNum=TQuantityNum-$Piece($Get(^DHCEQContractList(BussListID)),"^",7)
		.s BussListID=0         //add by wy 2019-6-3 920161 begin 业务为招标时,除上面减去其它中已经占用，再减去验收占用的数量
		.f  s BussListID=$o(^DHCEQOpenCheckList(0,"Source",3,TExtendID,BussListID))  Quit:BussListID=""  Do
		..q:$Piece($Get(^DHCEQOpenCheckRequest($p($g(^DHCEQOpenCheckList(BussListID)),"^",1))),"^",45)="Y"
		..s TQuantityNum=TQuantityNum-$Piece($Get(^DHCEQOpenCheckList(BussListID)),"^",16)	  //add by wy end 	
		.q:TQuantityNum<1
		.s TTotalFee=TQuantityNum*TPriceFee
		.s TItemDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",18)
		.i TItemDR'="" Set TUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
		.s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.d OutputRowGetIFBExtendID
	}	
	Quit $$$OK
OutputRowGetIFBExtendID
	s TPriceFee=##Class(web.DHCEQCommon).FormatNumber(TPriceFee,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s Data=$lb(TExtendID,TItemDR,TName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TNo,TUnit,TUnitDR)
 	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
ResetGetIFBExtendID
	s (TExtendID,TItemDR,TName,TModelDR,TModel,TManuFacDR,TManuFac,TPriceFee,TQuantityNum,TTotalFee,TNo,TUnit,TUnitDR)=""
	Quit
BuildDataGetItem
	d ResetGetIFBExtendID
	Quit:(ExtendID'="")&&(ExtendID'=rowid)
	s TExtendID = rowid
	s TItemDR = rowid
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TNo=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(ExtendTypeDesc'="")&&($ZCONVERT(TName ,"U")'[$ZCONVERT(ExtendTypeDesc,"U"))
	
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	;Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TCatDR,"","",rowid)) 
	q:($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12)="Y")
	;s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	;i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	d OutputRowGetIFBExtendID
	
	Quit
}

ClassMethod GetIFBExtendIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIFBExtendIDExecute ]
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

ClassMethod GetIFBExtendIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIFBExtendIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetExtendTypeList(ExtendType)
{
	Quit $CASE(ExtendType,"0":"设备项","1":"采购申请","2":"采购计划",:"")
}

/// hisui改造
/// w ##Class(web.DHCEQ.EM.BUSIFB).GetOneIFB(207)
ClassMethod GetOneIFB(RowID As %Library.String = "", ApproveRoleDR As %Library.String = "", action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOneContract"
	s ObjIFB=##Class(User.DHCEQIFB).%OpenId(RowID)
	s IFBInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjIFB)   // modify by jyp 2019-08-26
	
	d IFBInfo.%Set("IFBModeDR_IFBMDesc",ObjIFB.IFBModeDR.IFBMDesc)
    d IFBInfo.%Set("IFBBuyTypeDR_BTDesc",ObjIFB.IFBBuyTypeDR.BTDesc)
    d IFBInfo.%Set("IFBAgencyDR_IFBADesc",ObjIFB.IFBAgencyDR.IFBADesc)
    
	//d IFBInfo.%Set("IFBExtendType_Desc",##Class(web.DHCEQ.EM.BUSIFB).GetExtendType(ObjIFB.IFBExtendType))	
	d IFBInfo.%Set("IFBRejectUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjIFB.IFBRejectUserDR))
	d IFBInfo.%Set("IFBSubmitUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjIFB.IFBSubmitUserDR))
	d IFBInfo.%Set("IFBUpdateUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjIFB.IFBUpdateUserDR))
	d IFBInfo.%Set("IFBAuditUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjIFB.IFBAuditUserDR))
	d IFBInfo.%Set("IFBCurrency_CDesc",ObjIFB.IFBCurrency.CDesc)
	d IFBInfo.%Set("IFBManageLocDRR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjIFB.IFBManageLocDR))		//czf 2021-09-02
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("17",RowID,ApproveRoleDR)
	d IFBInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d IFBInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d IFBInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d IFBInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d IFBInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d IFBInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d IFBInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d IFBInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d IFBInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d IFBInfo.%Set("NextRole",$p(AppInfo,"^",10))
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,IFBInfo)    // modify by jyp 2019-08-26
ERRORGetOneContract
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)    // modify by jyp 2019-08-26
}

/// w ##class(web.DHCEQ.EM.BUSIFB).SaveData("""IFBPrjName:第一节课,IFBNo:017498,IFBModeDR_IFBMDesc:,IFBBuyTypeDR_BTDesc:,IFBBuyFilePrice:0.00,IFBDeposit:0.00,IFBBuyFileFromDate:,IFBBuyFileFromTime:,IFBBuyFileToDate:,IFBBuyFileToTime:,IFBBuyFilePlace:,IFBAgencyDR_IFBADesc:,IFBAgencyConPerson:,IFBAgencyTel:,IFBDisabuseDate:,IFBDeterminationDate:,IFBAgencyFax:,IFBAnnouncementDate:,IFBAnnouncementMedia:,OpenPlace:,IFBOpenDate:26/11/2018,IFBOpenTime:00:00:00,IFBDeadlineDate:30/11/2018,IFBDeadlineTime:11,IFBTendereeAddress:,IFBTenderee:,IFBEvaluationCommittee:,IFBCondition:,IFBRemark:,IFBStatus:0,QXType:,Type:,IFBRowID:9,CurRole:,WaitAD:,ReadOnly:,GetSourceType:0,Action:,RoleStep:0,ApproveSetDR:,NextRoleDR:,NextFlowStep:,CancelFlag:,CancelToFlowDR:,IFBModeDR:,IFBBuyTypeDR:,IFBAgencyDR:,IFBBExtendType:1,IFBBExtendType_Desc:采购申请,IFBBExtendID:,IFBBRowID:""","{""IFBBRowID"":""16"",""IFBBIFBDR"":""9"",""IFBBBagNo"":""12"",""IFBBExtendType"":""1"",""IFBBExtendType_Desc"":""采购申请"",""IFBBExtendID"":""2"",""IFBBExtend_Name"":""A超扫描仪"",""IFBBItemDR"":""4"",""IFBBItemDR_MIDesc"":""A超扫描仪"",""IFBBHold1"":""A超扫描仪"",""IFBBUnitDR"":""4"",""IFBBUnitDR_UOMDesc"":""台"",""IFBBModelDR"":""2"",""IFBBModelDR_MDesc"":""描述02"",""IFBBArg"":""11"",""IFBBQuantity"":""2"",""IFBBWinPrice"":""2000.00"",""IFBBAmount"":""4000"",""IFBBManuFactoryDR"":""2"",""IFBBManuFactoryDR_MFDesc"":""奥地利佩施卡国际公司"",""IFBLRowID"":""1"",""IFBLVendorDR"":""1"",""IFBLVendor"":""奥地利AVL医疗公司"",""IFBLModelDR"":""2"",""IFBLModel"":""描述02"",""IFBLManuFactoryDR"":""2"",""IFBLManuFactory"":""奥地利佩施卡国际公司"",""IFBLArg"":""11"",""IFBLPrice"":""2000.00"",""IFBLWinQty"":""2"",""IFBBRemark"":""""}&{""IFBBExtendType"":""1"",""IBFExtendType_Desc"":""采购申请"",""IFBBExtendID"":""1"",""IFBBItemDR"":""130"",""IFBBItemDR_MIDesc"":""超声血流显象分析仪"",""IFBBModelDR"":""1"",""IFBBModelDR_MDesc"":""描述01"",""IFBLManuFactoryDR"":""23"",""IFBBWinPrice"":""3000.00"",""IFBBQuantity"":""2"",""IFBBAmount"":""6000.00"",""IFBBUnitDR"":""4"",""IFBBUnitDR_UOMDesc"":""台"",""IFBBHold1"":""超声血流显象分析仪"",""IFBBArg"":""19"",""IFBBManuFactoryDR_MFDesc"":""台湾良彦有限公司"",""IFBBBagNo"":""19"",""IFBBList"":"""",""IFBBRemark"":"""",""IFBBExtendType_Desc"":""采购申请"",""IFBBExtend_Name"":""超声血流显象分析仪"",""IFBLVendorDR"":""10"",""IFBLVendor"":""MADSEN公司""}","{""IFBLRowID"":""1"",""IFBLSourceType"":""1"",""IFBLSourceID"":""2"",""IFBLVendorDR"":""1"",""IFBLVendor"":""奥地利AVL医疗公司"",""IFBLModelDR"":""2"",""IFBLModel"":""描述02"",""IFBLManuFactoryDR"":""2"",""IFBLManuFactory"":""奥地利佩施卡国际公司"",""IFBLArg"":""11"",""IFBLPrice"":""2000.00"",""IFBLWinQty"":""2"",""IFBLAmount"":""4000""}&{""IFBLSourceType"":""1"",""IFBLSourceID"":""1"",""IFBLVendorDR"":""10"",""IFBLVendor"":""MADSEN公司"",""IFBLModelDR"":""1"",""IFBLModel"":""描述01"",""IFBLManuFactory"":""台湾良彦有限公司"",""IFBLArg"":""19"",""IFBLPrice"":""3000.00"",""IFBLWinQty"":""2"",""IFBLAmount"":""6000.00""}",0)
/// 创建:Mozy 2011-1-8
/// 描述:新增、更新、删除数据记录
ClassMethod SaveData(data As %Library.String = "", list As %Library.String = "", Listinfo As %Library.String = "", OperateType As %Library.String = "")
{
	Kill PLIST,LIST,SLIST,RowID,Rowid,No,valdata
	Set $ZT="ERRORSaveData"
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s RowID = JsonData.%Get("IFBRowID")    //modify by jyp 2019-08-26
	//add by zx 2019-09-11
	TStart
	If (+OperateType=1)
	{
	 	&SQL(delete from sqluser.DHC_EQIFBBag where IFBB_IFBDR=:RowID)
	 	&SQL(delete from sqluser.DHC_EQIFB where IFB_RowID=:RowID)
	 	If SQLCODE
		{
			TROLLBACK
	        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
		}
	 	
 	}
 	If (+OperateType=0) //新增,更新
 	{
	 	Set IFBRowID=RowID
	    s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQIFB",JsonData,.PLIST)
		Set No=JsonData.%Get("IFBNo")    //modify by jyp 2019-08-26
		&SQL(select IFB_RowID into :Rowid from SQLUSER.DHC_EQIFB where IFB_No=:No)
		Set SQLCODE=Rowid_"^招标编号重复:"_No
		if (Rowid'="")&(Rowid'=IFBRowID) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		
	 	If (RowID="")  //新增按钮操作
	 	{		
		 	Set PLIST(38)=	User	// IFB_AddUserDR	38
			Set PLIST(39)=	updDate	// IFB_AddDate	39
			Set PLIST(40)=	updTime	// IFB_AddTime	40
		 	Set PLIST(44)=	0		// IFB_Status	44
		 	&SQL(Insert Into SQLUSER.DHC_EQIFB Values :PLIST())
	 	}
	 	Else  //更新按钮操作
	 	{
		 	Set PLIST(41)=	User	// IFB_UpdateUserDR	41
			Set PLIST(42)=	updDate	// IFB_UpdateDate	42
			Set PLIST(43)=	updTime	// IFB_UpdateTime	43
			&SQL(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID = :IFBRowID)
	 	}
	 	i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
		}
	 	Set RowID=$Get(%ROWID)
	 	Set SQLCODE=##Class(web.DHCEQ.EM.BUSIFB).DeleteIFBBag(RowID,list)
	 	If SQLCODE
		{
			TROLLBACK
	    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
		}

	 	Set Length=$Length(list,"&")
	 	For n=1:1:Length
		{
			Set valList= $Piece(list,"&",n)
		    s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		    s LIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQIFBBag",JsonData,.LIST)
		    s IFBBrowid = JsonData.%Get("IFBBRowID")    //modify by jyp 2019-08-26
		    s valdata=$Piece(Listinfo,"&",n)
		    s TModelDR=##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valdata).%Get("IFBLModelDR") //add by wl 2019-11-27 WL0017
		 	// 设备招标包号表
		 	If (IFBBrowid="")  //新增按钮操作
		 	{
		 	    s LIST(2)=RowID   //modified by wy 2018-12-14
			 	&SQL(Insert Into SQLUSER.DHC_EQIFBBag Values :LIST())
		 	}
		 	Else  //更新按钮操作
		 	{
			 	s LIST(8)=TModelDR //add by wl 2019-11-27 WL0017
				&SQL(Update SQLUSER.DHC_EQIFBBag Values :LIST() where IFBB_RowID = :IFBBrowid)
		 	}
		 	Set BagID=$Get(%ROWID)
		 	//moddified by ZY0228 20200509
	   		i SQLCODE=100 s SQLCODE=0
		 	q:SQLCODE'=0
		 	// 设备供应商应标记录
		 	  //modify by jyp 2019-08-26
	 	    if JsonData.%Get("IFBLVendorDR")'=""
		     {
			    s valdata=$Piece(Listinfo,"&",n)
		        s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valdata)
		        s SLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQIFBList",JsonData,.SLIST)
		        s IFBLrowid=JsonData.%Get("IFBLRowID")  //modify by jyp 2019-08-26
		        //moddified by ZY0228 20200509
				s SLIST(2)="3"
				s SLIST(3)=BagID
				If (IFBLrowid="")  //新增按钮操作
			 	{
				    Set SLIST(15)="Y"							//	IFBL_WinFlag
				    Set SLIST(30)=BagID							//	IFBL_Hold1 
				 	&SQL(Insert Into SQLUSER.DHC_EQIFBList Values :SLIST())
			 	}
			 	Else  //更新按钮操作
			 	{
					&SQL(Update SQLUSER.DHC_EQIFBList Values :SLIST() where IFBL_RowID = :IFBLrowid)
			 	}
		 	}
		}
	   i SQLCODE=100 s SQLCODE=0
	   i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		} 	
	 	
 	}
 	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSaveData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 创建:Mozy 2011-1-18
/// 描述:提交
/// w ##Class(web.DHCEQIFB).SubmitData("8^1^")
ClassMethod SubmitData(val)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($Get(^DHCEQIFB(RowID)),"^",43)
	if Status'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9002",RowID)  //该记录状态不符合,不能执行操作!
	//Quit:##Class(web.DHCEQIFB).CheckWinVendor(RowID) -3001
	
	///add by ZY0209 判断设备项信息填写情况
	i ##Class(web.DHCEQ.Con.BUSContract).CheckMasterItem("93",RowID)=0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","'设备项'信息为空!")
	i ##Class(web.DHCEQ.Con.BUSContract).CheckMasterItemType(RowID)=0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1002","设备项填写的数据与来源方式中的数据不匹配")  //add by wy 2020-4-15 1270662
	
	Set $ZT="ERRORSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
 	
 	// Mozy0042	2011-2-21
 	Set MaxPrice=0
 	Set ListRowID=0
 	For  Set ListRowID=$Order(^DHCEQIFBBag(0,"IFB",RowID,ListRowID))  Quit:ListRowID=""  Do
 	.If +$Piece(^DHCEQIFBBag(ListRowID),"^",11)>MaxPrice  Do
 	..Set MaxPrice=+$Piece(^DHCEQIFBBag(ListRowID),"^",11)
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("17")
	//modified by ZY0196 增加管理科室的条件限制
	s ApproveCondition="ManageLocDR,DHCEQIFB,"_$Piece(^DHCEQIFB(RowID),"^",34)
	Set ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", MaxPrice,"",ApproveCondition)
	If ApproveSet="" Quit -4007
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;Status
	
	Set AuditFlag=0
	If (AutoAuditFlag="Y")&&(NextStep="") 
	{
		Set AppInfoStatus="2"
		Set AuditFlag=1
	}
	Set ApproveInfoID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,RowID,0))
	TSTART
	Set SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"17",User)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	Set PLIST(44)=	1		// IFB_Status	44
 	Set PLIST(45)=	User	// IFB_SubmitUserDR	45
	Set PLIST(46)=	updDate	// IFB_SubmitDate	46
	Set PLIST(47)=	updTime	// IFB_SubmitTime	47
	&SQL(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
	if SQLCODE
	{
	 	TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQIFB).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
		    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}		
	}
	;Modified by jdl 2011-3-17  jdl0073
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("93", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息 ;
}

/// 创建:Mozy 2011-1-18
/// 描述:取消提交
/// w ##Class(web.DHCEQIFB).CancelSubmitData("8^4674^33^",6)
ClassMethod CancelSubmitData(val, CurRole)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	
	Set $ZT="ERRORCancelSubmitData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
	Set CancelToFlowDR=$Piece(val,"^",3)
	
	;获取取消到上一步的信息
	Set Status="0"
	Set ApproveRoleDR=""
	Set Step=""
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("17")
	if (CancelToFlowDR'="")
	{
		Set ApproveRoleDR=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		Set Step=$Piece($Get(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		Set Status="1"
	}
	
	TSTART
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("17", RowID)

	Set PLIST(44)=	Status	// IFB_Status	44
	Set PLIST(56)=	User	// IFB_RejectUserDR	55
	Set PLIST(57)=	updDate	// IFB_RejectDate	56
	Set PLIST(58)=	updTime	// IFB_RejectTime	57
	&sql(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}	
	//add by wy 2020-5-9 1309389 审批信息更新 begin
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;Modified by jdl 2011-3-17  jdl0073
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("93", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORCancelSubmitData 
	TRollBack	
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息 ;
}

/// 创建:Mozy 2011-1-18
/// 描述:审核
/// w ##Class(web.DHCEQIFB).AuditData("19^1^","3","2","")
/// w ##Class(web.DHCEQIFB).AuditData("42^1^","3","2","DHC_EQIFB&41^12312312,25^项目联系人,30@DHC_EQIFBBag&112^21,29")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	Set RowID=$Piece(val,"^",1)
	Quit:RowID="" ""
	s Status=$Piece($Get(^DHCEQIFB(RowID)),"^",43)
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9002",RowID)   //Modified By HZY 2011-10-18 HZY0015 .该记录状态不符合,不能执行操作!
	
	Set $ZT="ERRORAuditData"
	Set User=$Piece(val,"^",2)
	Set updDate=+$H
 	Set updTime=$Piece($H,",",2)
    ///modified by ZY 20220913  增加意见填写保存
    Set Opinion=$Piece(val,"^",4)
    Set Remark=$Piece(val,"^",5)
 	
	
	Set ApproveType=##class(web.DHCEQApproveList).GetApproveType("17")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("17", RowID)	
	If ApproveSet="" Quit -4007	
	Set ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	Set AutoAuditFlag=$Piece(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	Set LastFlag=$Piece(ApproveFlow,"^",1)
	Set NextStep=$Piece(ApproveFlow,"^",2)
	Set NextRole=$Piece(ApproveFlow,"^",3)

	Set AppInfoStatus="1"	;Status	
	
	TSTART
	Set AuditFlag=0
	If ((NextStep="")||(LastFlag="Y"))
	{
		Set AuditFlag=1
		
		Set PLIST(48)=	User	// IFB_AuditUserDR	48
		Set PLIST(49)=	updDate	// IFB_AuditDate	49
		Set PLIST(50)=	updTime	// IFB_AuditTime	50
		&sql(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
		If SQLCODE
		{
		 	TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		Set AppInfoStatus="2"	;Status
	}
	
	;生成审批记录
    ///modified by ZY 20220913  增加意见填写保存
    Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,Remark,CurRole,RoleStep)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	;编辑要修改的字段
	If editFieldsInfo'=""
	{
		Set SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		If SQLCODE
		{
			TROLLBACK
		    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	;执行当前角色要执行的动作
	Set Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	If Actions'=""
	{
		Set SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		If SQLCODE
		{
			TROLLBACK
		    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	;最后一步,需要调用审核方法
	If AuditFlag=1
	{
		Set SQLCODE=##Class(web.DHCEQIFB).LastAuditAction(RowID)
		If SQLCODE
		{
			TROLLBACK
		    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	;Modified by jdl 2011-3-9  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("93", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	
  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORAuditData
    TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)     //返回错误消息 ;
}

/// ----------------------------------
/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// 	在此处，需调用
/// w ##Class(web.DHCEQIFB).LastAuditAction(5)
/// ----------------------------------
ClassMethod LastAuditAction(RowID)
{
	Set PLIST(44)=	2		// IFB_Status	44
	&sql(Update SQLUSER.DHC_EQIFB Values :PLIST() where IFB_RowID=:RowID)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// 创建:Mozy 2011-1-17
/// 描述:删除招标包明细
/// 
/// w ##Class(web.DHCEQ.EM.BUSIFB).DeleteIFBBag(9,"{""IFBBRowID"":""14"",""IFBBIFBDR"":""9"",""IFBBBagNo"":""11"",""IFBBExtendType"":""1"",""IFBBExtendType_Desc"":""采购申请"",""IFBBExtendID"":""3"",""IFBBExtend_Name"":""CO2孵箱"",""IFBBItemDR"":""5"",""IFBBItemDR_MIDesc"":""CO2孵箱"",""IFBBHold1"":""CO2孵箱"",""IFBBUnitDR"":""4"",""IFBBUnitDR_UOMDesc"":""台"",""IFBBModelDR"":""4"",""IFBBModelDR_MDesc"":""2米"",""IFBBArg"":""cc"",""IFBBQuantity"":""10"",""IFBBWinPrice"":""1000.00"",""IFBBAmount"":""10000"",""IFBBManuFactoryDR"":""4"",""IFBBManuFactoryDR_MFDesc"":""莱卡公司"",""IFBLRowID"":""3"",""IFBLVendorDR"":""20"",""IFBLVendor"":""瑞士大昌洋行有限公司"",""IFBLModelDR"":""4"",""IFBLModel"":""2米"",""IFBLManuFactoryDR"":""4"",""IFBLManuFactory"":""莱卡公司"",""IFBLArg"":""cc"",""IFBLPrice"":""1000.00"",""IFBLWinQty"":""10"",""IFBBRemark"":""ccc""}")
ClassMethod DeleteIFBBag(IFBRowID, list)
{
	new Length,IFBBRowID,Flag,j,rowid,RLRowIDs
	If list="" Quit 0
	if IFBRowID="" q -1
	s RLRowIDs=""
	Set Flag=0
	Set Length=$Length(list,"&")
	for j=1:1:Length
	{
		Set valList= $Piece(list,"&",j)
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s IFBBRowID = JsonData.%Get("IFBBRowID")   //modify by jyp 2019-08-26
		if RLRowIDs=""
		{
			s RLRowIDs=IFBBRowID
		}
		else
		{
			s RLRowIDs=RLRowIDs_","_IFBBRowID
		}
	}
	s rowid=0
    For  Set rowid=$Order(^DHCEQIFBBag(0,"IFB",IFBRowID,rowid))  Quit:rowid=""  Do
	.i (","_RLRowIDs_",")'[(","_rowid_",") &SQL(delete from  sqluser.DHC_EQIFBBag where IFBB_RowID=:rowid)
	If SQLCODE Set Flag=SQLCODE
	Quit Flag
}

}
