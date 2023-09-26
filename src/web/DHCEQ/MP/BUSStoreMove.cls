Import SQLUser

/// 名称: web.DHCEQ.MP.BUSStoreMove
/// 描述: 配件管理HisUI		Maintenance Parts
/// 创建人：Mozy
/// 编写日期: 2019-10-25
/// 产品组：设备管理
Class web.DHCEQ.MP.BUSStoreMove Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Mozy	2019-10-25
/// 配件出库业务单出库明细记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSStoreMove","GetAMoveStockList",34)
Query GetAMoveStockList(RowID) As %Query(ROWSPEC = "AMSLRowID:%String,AMSLMoveStockDR:%String,AMSLItemDR:%String,AMSLCode:%String,AMSLDesc:%String,AMSLManuFactoryDR:%String,AMSLManuFactoryDR_MDesc:%String,AMSLQuantityNum:%String,AMSLBaseUOMDR_UOMDesc:%String,AMSLSerialFlag:%String,AMSLBaseUOMDR:%String,AMSLAmount:%String,AMSLModel:%String,AMSLPrice:%String,AMSLRemark:%String,AMSLBatchFlag:%String,AMSLStockDetailDR:%String,AMSLAISListDR:%String,AMSLHold1:%String,AMSLHold2:%String,AMSLHold3:%String,AMSLHold4:%String,AMSLHold5:%String,TJob:%String,TFlag:%String,TMRRowID:%String,AMSLEquipDR:%String,EQName:%String,EQNo:%String,EQUseLoc:%String,MRRequestNo:%String,TMoveNum:%String,AISProviderDR_VDesc:%String,AMSLSerialNo:%String,AMSLFundsType:%String,AISInStockNo:%String")
{
}

ClassMethod GetAMoveStockListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
	;new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Job=$Job
	s (TotalQty,TotalAmount)=0
	
	if (RowID="")
	{
		d ResetVariablesGetAMoveStoreList
		s TJob=Job
		d OutputRowGetAMoveStoreList
	}
	else
	{
		s rowid=0
		f  s rowid=$o(^DHCEQAMoveStockList(0,"MoveStock",RowID,rowid))  quit:rowid=""  d
		.d ResetVariablesGetAMoveStoreList
		.s TRowID=rowid
		.s TItemDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",2)
		.s TCode = $p($g(^DHCEQAMoveStockList(rowid)),"^",3)
		.s TDesc = $p($g(^DHCEQAMoveStockList(rowid)),"^",4)
		.s TModel= $p($g(^DHCEQAMoveStockList(rowid)),"^",5)
		.s TBaseUOMDR=$p($g(^DHCEQAMoveStockList(rowid)),"^",6)
		.s TBaseUOM = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
		.s TManuFactoryDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",7)
		.s TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		.s TBatchFlag=$p($g(^DHCEQAMoveStockList(rowid)),"^",8)
		.s TSerialFlag=$p($g(^DHCEQAMoveStockList(rowid)),"^",9)
		.s TPrice=$p($g(^DHCEQAMoveStockList(rowid)),"^",10)
		.s TQuantityNum=$p($g(^DHCEQAMoveStockList(rowid)),"^",11)
		.i (TQuantityNum'=1&&TSerialFlag="Y")  d
		..s TFlag=1
		.e  d
		..s TFlag=0
		.s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)
		.s TotalQty=TotalQty+TQuantityNum
		.s TAmount=$p($g(^DHCEQAMoveStockList(rowid)),"^",12)
		.s TotalAmount=TotalAmount+TAmount
		.s TRemark=$p($g(^DHCEQAMoveStockList(rowid)),"^",13)
		.s TStockDetailDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",14)
		.s TAInStockListDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",15)
		.///增加设备信息及维修单号
		.s TEquipDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",16)
		.;s TMaintPartDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",17)
		.s TAInStockListDR = $p($g(^DHCEQAMoveStockList(rowid)),"^",15)
		.s TAInStockDR = $p($g(^DHCEQAInStockList(+TAInStockListDR)),"^",1)
		.s AISInStockNo=$p($g(^DHCEQAInStock(+TAInStockDR)),"^",6)	;Mozy0236	2019-12-9	1125840		增加显示入库单号
		.s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQAInStock(+TAInStockDR)),"^",8))
		.s THold1 = $p($g(^DHCEQAMoveStockList(rowid)),"^",18)
		.s THold2 = $p($g(^DHCEQAMoveStockList(rowid)),"^",19)
		.s THold3 = $p($g(^DHCEQAMoveStockList(rowid)),"^",20)
		.s THold4 = $p($g(^DHCEQAMoveStockList(rowid)),"^",21)
		.s THold5 = $p($g(^DHCEQAMoveStockList(rowid)),"^",22)	;库存数
		.s id=$o(^DHCEQMMaintPart(0,"AMoveStockList",rowid,""))
		.;i (id="")&&(TAInStockListDR'="") s id=$o(^DHCEQMMaintPart(0,"AInStockList",TAInStockListDR,""))
		.i id'="" d
		..s TMRRowID=$p($g(^DHCEQMMaintPart(id)),"^",9)	;MTP_MaintRequestDR
		..s TRequestNo=$p($g(^DHCEQMMaintRequest(TMRRowID)),"^",1)
		.
		.i (TMRRowID'="")&&(TEquipDR="") d
		..;获取维修单的设备DR
		..i $Piece($Get(^DHCEQMMaintRequest(TMRRowID)),"^",63)=1 Set TEquipDR=$Piece($Get(^DHCEQMExObj($Piece($Get(^DHCEQMMaintRequest(TMRRowID)),"^",5))),"^",5)	;Mozy0189	2017-5-26
		.
		.i TEquipDR'="" d
		..s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
		..s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(TEquipDR)),"^",67))
		..s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
		..;s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)
		.s TJob=Job
		.
		.;可转移数量
		.s TStock=THold5
		.s FreezeNum=0
		.i TBatchFlag="Y" d
		..s TStock=$p($g(^DHCEQAStockDetail(TStockDetailDR)),"^",17)
		..s TFromLocDR=$p($g(^DHCEQAMoveStock(RowID)),"^",4)
		..s FreezeNum=##class(web.DHCEQ.MP.BUSStoreMove).CheckAccessoryDR(TStockDetailDR,TFromLocDR,rowid,0)      ///被占用的数量
		.e  d
		..s AMSLSerialNo=$p($g(^DHCEQAStockDetail(TStockDetailDR)),"^",9)
		..;s TNo=$p($g(^DHCEQAStockDetail(TStockDetailDR)),"^",10)
		.s TMoveNum=TStock-FreezeNum
		.s AMSLFundsType=$p($g(^DHCEQAStockDetail(TStockDetailDR)),"^",30)
		.i AMSLFundsType'="" s AMSLFundsType=$Piece($Get(^DHCEQCCode("DHCEQCFundsType",AMSLFundsType)),"^",2)	//Mozy0236	修正配件资金类型
		.d OutputRowGetAMoveStoreList
	}
	
	Quit $$$OK
OutputRowGetAMoveStoreList
	i TPrice'="" s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)
	i TQuantityNum'="" s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)
	s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"",2)
	Set Data=$lb(TRowID,TMoveStockDR,TItemDR,TCode,TDesc,TManuFactoryDR,TManuFactory,TQuantityNum,TBaseUOM,TSerialFlag,TBaseUOMDR,TAmount,TModel,TPrice,TRemark,TBatchFlag,TStockDetailDR,TAInStockListDR,THold1,THold2,THold3,THold4,THold5,TJob,TFlag,TMRRowID,TEquipDR,TEquipName,TNo,TUseLoc,TRequestNo,TMoveNum,TProvider,AMSLSerialNo,AMSLFundsType,AISInStockNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAMoveStoreList
	s (TRowID,TMoveStockDR,TItemDR,TCode,TDesc,TManuFactoryDR,TManuFactory,TQuantityNum,TBaseUOM,TSerialFlag,TBaseUOMDR,TAmount,TModel,TPrice,TRemark,TBatchFlag,TStockDetailDR,TAInStockListDR,THold1,THold2,THold3,THold4,THold5,TSerialNo,TFlag,TMRRowID,TEquipDR,TEquipName,TNo,TUseLoc,TRequestNo,TMoveNum,TProvider,AMSLSerialNo,AMSLFundsType,AISInStockNo)=""
	quit
}

ClassMethod GetAMoveStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAMoveStockListExecute ]
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

ClassMethod GetAMoveStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAMoveStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 入库业务类型列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSStoreMove","GetMoveType","")
Query GetMoveType(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetMoveTypeExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	;new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s ID=0
	s TDesc="出库"
	d OutputRowGetMoveType
	;s ID=1
	;s TDesc="库房调配"
	;d OutputRowGetInType
	s ID=2
	s TDesc="退库"
	d OutputRowGetMoveType

	Quit $$$OK
OutputRowGetMoveType
	Set Data=$lb(ID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetMoveTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoveTypeExecute ]
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

ClassMethod GetMoveTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoveTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 配件转移业务单数据填充取值
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).GetOneAStoreMove(42)
ClassMethod GetOneAStoreMove(RowID As %Library.String = "", ApproveRoleDR As %Library.String = "")
{
	s $ZT="ERRORGetOneAStoreMove"
	// AISRowID,AISInDate,AISAccessoryTypeDR,AISLocDR,AISRequestUserDR,AISRequestDate,AISInStockNo,AISInType,AISProviderDR,AISSourceID,AISBuyLocDR
	// AISBuyUserDR,AISRejectReason,AISRejectUserDR,AISRejectDate,AISRejectTime,AISStatus,AISAddUserDR,AISAddDate,AISAddTime,AISSubmitUserDR,
	// AISSubmitDate,AISSubmitTime,AISAuditUserDR,AISAuditDate,AISAuditTime,AISRemark,AISHold1,AISHold2,AISHold3,AISHold4,AISHold5,
	// AISHold6,AISHold7,AISHold8,AISHold9,AISHold10,AISHold11
	
	s ObjAMoveStock=##Class(User.DHCEQAMoveStock).%OpenId(RowID)
	s AMoveStockInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjAMoveStock)
	d AMoveStockInfo.%Set("AMSMoveType_Desc", $CASE(ObjAMoveStock.AMSMoveType,"0":"出库","1":"库房调配","2":"退库",:"没有定义"))
	d AMoveStockInfo.%Set("AMSAccessoryTypeDR_ATDesc",ObjAMoveStock.AMSAccessoryTypeDR.ATDesc)
	d AMoveStockInfo.%Set("AMSFromLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjAMoveStock.AMSFromLocDR))
	d AMoveStockInfo.%Set("AMSToLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjAMoveStock.AMSToLocDR))
	d AMoveStockInfo.%Set("AMSReciverDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjAMoveStock.AMSReciverDR))
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("11",RowID,ApproveRoleDR)
	d AMoveStockInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d AMoveStockInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d AMoveStockInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d AMoveStockInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d AMoveStockInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d AMoveStockInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d AMoveStockInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d AMoveStockInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d AMoveStockInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d AMoveStockInfo.%Set("NextRole",$p(AppInfo,"^",10))
	
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,AMoveStockInfo)
ERRORGetOneAStoreMove
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// 只能用于放大镜不能用于Table
/// 重写库存配件查询简略输出列信息(把ID值移动靠前)
/// Flag :批量选项
/// 增加单台批量显示，增加一个标志位
/// 增加一个changetype区分退货减少和转移
/// ChangeType:
/// 		   0：转移		1: 退货和减少
/// MXRowID  转移明细或退货明细RowID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSStoreMove","GetAStockDetail","",327,43,"","",0)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSStoreMove","GetAStockDetail","",327,44,"漏血探测器","",1)
Query GetAStockDetail(ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, MXRowID As %String = "", ProviderDR As %String = "", ChkFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TLocDR:%String,TAccessoryTypeDR:%String,TItemDR:%String,TAInStockListDR:%String,TBaseUOMDR:%String,TManuFactoryDR:%String,TProviderDR:%String,TStockDR:%String,TInType:%String,TInSourceID:%String,TToType:%String,TToSourceID:%String,TOriginDR:%String,TDesc:%String,TCode:%String,TLoc:%String,TAccessoryType:%String,TModel:%String,TBprice:%String,TManuFactory:%String,TProvider:%String,TStock:%String,CanUseNum:%String,FreezeNum:%String,TInStockNo:%String,TInDate:%String,TStatus:%String,THasStockFlag:%String,TItem:%String,TBatchNo:%String,TExpiryDate:%String,TSerialNo:%String,TNo:%String,TBaseUOM:%String,TFreezeStock:%String,TStartDate:%String,TDisuseDate:%String,TOrigin:%String,TReturnFee:%String,TTotalFee:%String,TBatchFlag:%String,TBillPage:%String,TInvoiceNos:%String,TSerialFlag:%String,TFund:%String")
{
}

ClassMethod GetAStockDetailExecute(ByRef qHandle As %Binary, ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, ChangeType, vMXRowID As %String = "", ProviderDR As %String = "", ChkFlag As %String = "") As %Status
{
	;new repid, index,rowid,TAStockListDR,TStockSum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("web.DHCEQ.MP.BUSStoreMove")=ASDRowID_","_LocDR_","_AccessoryTypeDR_","_Desc_","_Flag_","_ChangeType_","_vMXRowID_","_ProviderDR_","_ChkFlag
 	i ChkFlag="Y" Quit $$$OK
	s index=1
	s rowid=0
	s TAStockListDR=0
	s TStockSum=0
	s FreezeNumSum=0
	S Desc=$ZCONVERT(Desc,"U")
	i LocDR="" Set LocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0302")	;Mozy	默认取 SBLJCK-设备零件仓库的配件
	;i LocDR="" q $$$OK
	i AccessoryTypeDR="" q $$$OK
	i Flag="true" s ASDRowID=""
	s TAInStockListDR=""
	
	if ASDRowID'=""
	{
		d ResetVariablesGetAStockDetail
		s rowid=ASDRowID
		d BuildDataGetAStockDetail
	}
	else
	{
		if Flag="true"
		{
			//按入库明细倒序显示
            s TAInStockListDR=""
			f  s TAInStockListDR=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR),-1) q:TAInStockListDR=""  d
			.d ResetVariablesGetAStockDetail
			.s (TStock,rowid,TID)=0
			.s FreezeNumSum=0
			.s FirstID=0
			.f  s rowid=$o(^DHCEQAStockDetail(0,"AInStockList",TAInStockListDR,rowid)) q:rowid=""  d
			..;s TBatchNo=$p($g(^DHCEQAStockDetail(rowid)),"^",6)
			..s TAInStockListDR=$p($g(^DHCEQAStockDetail(rowid)),"^",3) //用批号标志做判断
			..s TSerialFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)
			..i TSerialFlag'="Y" d
			...d BuildDataGetAStockDetail
			..e  d
			...; 序列号管理
			...s TLocDR=$p($g(^DHCEQAStockDetail(rowid)),"^",1)
		    ...q:(LocDR'=TLocDR) 
			...s TStatus=$p($g(^DHCEQAStockDetail(rowid)),"^",12)
		    ...;转移		Mozy0237	2019-12-9
		    ...q:(TStatus'=0)&&(TStatus'=1)
		    ...s TStockSum=$p($g(^DHCEQAStockDetail(rowid)),"^",17)
		    ...q:(TStockSum=0)
		    ...s TStock=TStock+TStockSum
		    ...s FreezeNum=##class(web.DHCEQ.MP.BUSStoreMove).CheckAccessoryDR(rowid,LocDR,vMXRowID,ChangeType)      ///被占用的数量
		    ...s FreezeNumSum=FreezeNumSum+FreezeNum
			...i ((FirstID=0)&&(FreezeNum=0))  d
			....s TID=rowid
			....s FirstID=1
			.s TNo=""
			.s TSerialNo=""
			.s rowid=TID
			.q:($p($g(^DHCEQAStockDetail(rowid)),"^",10)="")
			.;s TSerialNo=$e($p($g(^DHCEQAStockDetail(rowid)),"^",9),0,1)
			.d BuildDataGetAStockDetail
		}
		else
		{	
			s rowid=""
			f  s rowid=$o(^DHCEQAStockDetail(rowid),-1) q:rowid=""  d
			.d ResetVariablesGetAStockDetail
			.d BuildDataGetAStockDetail
		}
	}
	Quit $$$OK
	
BuildDataGetAStockDetail
	s TRowID=rowid
	s TLocDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",1)
	q:(LocDR'=TLocDR)	; Mozy0237	2019-12-9
	s TAccessoryTypeDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",11)
	q:##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
	q:(AccessoryTypeDR'="")&&(AccessoryTypeDR'=TAccessoryTypeDR)
	q:##class(web.DHCEQCommon).FundsTypeIsIn(12,TRowID)	// Mozy0231	访问资金来源类型
	s TCode=$p($g(^DHCEQAStockDetail(TRowID)),"^",4)
	s TDesc=$p($g(^DHCEQAStockDetail(TRowID)),"^",5)
	s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	s TItemDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",2)
	s TItem=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",2)
	s TAInStockListDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",3)
	s TShortDesc=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",3)
	s TBillPage= $p($g(^DHCEQAStockDetail(TRowID)),"^",29)
	q:(Desc'="")&&(($ZCONVERT(TCode,"U")'[Desc)&&($ZCONVERT(TDesc,"U")'[Desc)&&($ZCONVERT(TShortDesc,"U")'[Desc)&&(TBillPage'=Desc))
	s TStatus=$p($g(^DHCEQAStockDetail(TRowID)),"^",12)
	; Mozy0237	2019-12-9	修正状态取值错误	;转移
	q:(TStatus'=0)&&(TStatus'=1)
	s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
	q:(THasStockFlag="N")
	s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	i TAInStockListDR="" d
	.;导入配件按批量处理
	.s TBatchFlag="Y"
	.s TSerialFlag="N"
	e  d
	.s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
	.s TSerialFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)
	.s TBatchFlag=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",16)
	.s TInvoiceNos=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",19)
	.i (Flag'="true")&&(TSerialFlag="Y")  d  //	批量选项	序列号管理
	..s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
	..s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
	.i TAInStockDR'="" d
	..s TInStockNo=$p($g(^DHCEQAInStock(TAInStockDR)),"^",6)  //入库单号
	..s TInDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(TAInStockDR)),"^",1),"date") //入库日期
	s TBatchNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",6)
	s TExpiryDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",7),"date")
	s TBprice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQAStockDetail(TRowID)),"^",8),"",2)
	s TBaseUOMDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",13)
	i TBaseUOMDR'="" s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
	s TManuFactoryDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",14)
	i TManuFactoryDR '="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)  //CZF0093
	s TModel=$p($g(^DHCEQAStockDetail(TRowID)),"^",15)
	s TProviderDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",16)
	q:((ProviderDR'="")&&(TProviderDR'=ProviderDR))
	i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
	// MZY0075	1850024		2021-05-20
	;i TSerialFlag="Y"  d
	;.s FreezeNum=FreezeNumSum
	;e  d
	;.
	s FreezeNum=##class(web.DHCEQ.MP.BUSStoreMove).CheckAccessoryDR(TRowID,LocDR,vMXRowID,ChangeType)      ///被占用的数量
	/*
	i ((Flag="false")||(TBatchNo'="")) d
	.s TSerialNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",9)
	.s TNo=$p($g(^DHCEQAStockDetail(TRowID)),"^",10)
	.s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
	else  d
	.i TStock=""  d
	..s TStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
	*/
	q:(TStock=0)
	s CanUseNum=TStock-FreezeNum                 ///可退数量 
	q:CanUseNum<0   //Modefied by zc0131 2023-03-08 支持录入小数
	
	s TFreezeStock=$p($g(^DHCEQAStockDetail(TRowID)),"^",18)
	s TStartDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",19),"date")
	s TDisuseDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAStockDetail(TRowID)),"^",20),"date")
	s TStockDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",21)
	s TInType=$p($g(^DHCEQAStockDetail(TRowID)),"^",22)
	s TInSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",23)
	s TToType=$p($g(^DHCEQAStockDetail(TRowID)),"^",24)
	s TToSourceID=$p($g(^DHCEQAStockDetail(TRowID)),"^",25)
	s THasStockFlag=$p($g(^DHCEQAStockDetail(TRowID)),"^",26)
	s TOriginDR=$p($g(^DHCEQAStockDetail(TRowID)),"^",27)	;改为备注
	;i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	;s StockQtyNum=$p($g(^DHCEQAStockDetail(TRowID)),"^",17)
	
	s TReturnFee=$p($g(^DHCEQAStockDetail(TRowID)),"^",8)
	s TTotalFee=CanUseNum*TReturnFee
	s TFund=$p($g(^DHCEQAStockDetail(TRowID)),"^",30)
	i TFund'="" s TFund=$Piece($Get(^DHCEQCCode("DHCEQCFundsType",TFund)),"^",2)	//Mozy0231	配件资金
	d OutputRowGetAStockDetail

	quit
OutputRowGetAStockDetail
	Set TStock=##Class(web.DHCEQCommon).FormatNumber(TStock,"",2)
	Set CanUseNum=##Class(web.DHCEQCommon).FormatNumber(CanUseNum,"",2)
	Set FreezeNum=##Class(web.DHCEQCommon).FormatNumber(FreezeNum,"",2)
	Set Data=$lb(TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag,TBillPage,TInvoiceNos,TSerialFlag,TFund)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAStockDetail
	Set (TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,FreezeNum,CanUseNum,TReturnFee,TTotalFee,TAInStockDR,TInStockNo,TInDate,TBatchFlag,TBillPage,TInvoiceNos,TSerialFlag,TFund)=""      
	Quit
}

ClassMethod GetAStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStockDetailExecute ]
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

ClassMethod GetAStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:新增,更新数据
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).SaveData()
ClassMethod SaveData(val, valList)
{
	Set $ZT="ERRORSave"
	;s ^DHCEQMozy("SaveData")=val_","_valList
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	k PLIST
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAMoveStock",JsonData,.PLIST)
	s RowID = JsonData.AMSRowID
 	s Job = JsonData.AMSJob
	s PLIST(31)="N"						;AMS_Hold1		自动建单未编辑标志
 	
	TSTART
 	if RowID=""
 	{
		i PLIST(2)="" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAMoveStock",Date,"",PLIST(3))
		s PLIST(7)=User  				;AMS_MakerDR
		s PLIST(8)=Date  				;AMS_MakeDate
		s PLIST(9)=Time					;AMS_MakeTime
		s PLIST(29)=0
		&SQL(insert into sqluser.DHC_EQAMoveStock values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "插入主单记录失败")
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
	 	i $P(^DHCEQAMoveStock(RowID),"^",30)="Y" s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAMoveStock",Date,"",PLIST(3))
		&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单记录失败")
		}
 	}
 	
 	s SQLCODE=##CLASS(web.DHCEQ.MP.BUSStoreMove).JudgeAMSLQuantityNum(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "转移明细配件选项有误")
 	}
 	s SQLCODE=##CLASS(web.DHCEQ.MP.BUSStoreMove).SaveAMoveStockList(RowID,valList,Job)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "保存转移明细记录失败")
 	}
 	/// 检查配件是否已经被其他单据占用
 	s result=##CLASS(web.DHCEQ.MP.BUSStoreMove).CheckOrder(RowID)
 	i result
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(result, "配件被占用")
 	}
	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
 	
ERRORSave 
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:判断按序列号转移的配件数量与选择的RowIDs是否一致
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).JudgeAMSLQuantityNum(13,2780,"1^^1^PJLZ^配件1^^41^1^false^true^50^1^50^^34^^^^")
ClassMethod JudgeAMSLQuantityNum(AMSRowID, Job, val)
{
	;new (AMSRowID, Job, val)
	i AMSRowID="" q -9001
	i val="" q 0
	s Flag=0
	s StoreLocDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",4)		;StoreLocDR
	s MoveType=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",14)		;MoveType
	
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$l(val,SplitRowCode)
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,SplitRowCode,i)
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s index=JsonData.AMSLIndex //index处理
		s AMSLRowID=JsonData.AMSLRowID
		s StockDetailDR=JsonData.AMSLStockDetailDR
		s QuantityNum=+JsonData.AMSLQuantityNum		// Mozy0231		强制转换数量
		i (JsonData.AMSLSerialFlag'="Y") continue //过滤掉不是按序列号管理的配件
		
		; 序列号管理
		if (QuantityNum=1)
		{			
			if AMSLRowID=""  //新增明细
			{
				s ^TEMPEQ("AMXList","EX",Job,index)=StockDetailDR
			}
			else
			{
				s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=StockDetailDR
				k ^TEMPEQ("AMXList",Job,AMSLRowID)
			}		
			//continue //单台设备不处理
		}
		else
		{
			;SML_TQuantityNum=1序列号管理非批量所以不适用以下判断(需累加)
	 		s RowIDs=""
			s Len=0
	 		if AMSLRowID=""  //新增明细
	 		{
		 		s RowIDs=$g(^TEMPEQ("AMXList","EX",Job,index))
	 		}
	 		else
	 		{
			 	s RowIDs=$g(^TEMPEQ("AMXList",Job,AMSLRowID))
		 		; 当InStockListDR相同时,才取原来的rowids
	 			i (RowIDs="") s RowIDs=$g(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))
		 	}
		 	if RowIDs'="" s Len=$l(RowIDs,",")
		 	if (Len'=QuantityNum)
		 	{
			 	s Flag=##Class(web.DHCEQUpdateAccessoryByList).GetRowIDsByQuantityNum(StockDetailDR,QuantityNum,AMSLRowID,StoreLocDR,Job,index,"1")
			 	I Flag'=0 s Flag=-7405
			}
			else
			{
				if (AMSLRowID'="")&&($Data(^TEMPEQ("AMXList",Job,AMSLRowID)))
				{
					s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList",Job,AMSLRowID))
					k ^TEMPEQ("AMXList",Job,AMSLRowID)
				}
			}
		}
	}
	q Flag
}

ClassMethod SaveAMoveStockList(AMSRowID, valstring, Job)
{
	;new (AMSRowID, valstring, Job)
	i (AMSRowID="")||(valstring="") q -9001
	s SQLCODE=0
	s AMSLRowIDs=""
	
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$l(valstring,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(valstring,SplitRowCode,i)
		q:valList=""
		k PLISTMX,AMSLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLISTMX=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAMoveStockList",JsonData,.PLISTMX)
		s AMSLRowID = JsonData.AMSLRowID
		s PLISTMX(2)=AMSRowID
		s index=JsonData.AMSLIndex 		//index处理
		s PLISTMX(9)="Y"  ;BatchFlag
		i PLISTMX(10)="" s PLISTMX(10)="N"
		i PLISTMX(10)="Y" s PLISTMX(9)="N"
		
		s SQLCODE=##CLASS(web.DHCEQ.MP.BUSStoreMove).AccessoryTypeIsUnique(AMSRowID,PLISTMX(15))
		i SQLCODE 
		{
			//明细与总单的类组不相同,更新明细记录失败!
			q
		}
		if (AMSLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQAMoveStockList Values :PLISTMX())
			i SQLCODE 
			{
				//更新明细记录失败!
				q
			}
			s AMSLRowID=$G(%ROWID)
 			if (PLISTMX(10)="Y")  //序列号管理
			{
	 			i $d(^TEMPEQ("AMXList","EX",Job,index))
	 			{
		 			s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList","EX",Job,index))
		 		}
		 		else
		 		{
			 		s ^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs")=JsonData.AMSLStockDetailDR
			 	}
			 	k ^TEMPEQ("AMXList","EX",Job,index)
 			}
		}
		else
		{
			&SQL(update sqluser.DHC_EQAMoveStockList values :PLISTMX() where AMSL_RowID=:AMSLRowID)
		}
		i SQLCODE'=0 q	;更新明细记录失败!"
		if AMSLRowIDs'="" s AMSLRowIDs=AMSLRowIDs_","
		s AMSLRowIDs=AMSLRowIDs_AMSLRowID
	}
	i SQLCODE'=0 q SQLCODE
	; 删除未处理的转移明细
	s AMSLRowID=0
	f  s AMSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",AMSRowID,AMSLRowID)) quit:(AMSLRowID="")||(SQLCODE'=0)  d
	.i (","_AMSLRowIDs_",")'[(","_AMSLRowID_",") &SQL(delete from SQLUSER.DHC_EQAMoveStockList where AMSL_RowID = :AMSLRowID)

	q SQLCODE
}

/// 检查明细与总单的类组是否相同
ClassMethod AccessoryTypeIsUnique(AMSRowID, ASDRowID)
{
	if ($p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)'=$p($g(^DHCEQAStockDetail(ASDRowID)),"^",11)) q -7403
	q 0
}

/// 检查单据数据是否有效,配件是否已经被其他单据占用
/// 参数:SourceID:对应业务单据ID
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).CheckOrder(56)
ClassMethod CheckOrder(SourceID)
{
	;n ListID,AccessoryID,Len,i,Flag,FromLocDR,Index
	i SourceID="" q -7403
	s Flag=0
	s FromLocDR=$p($g(^DHCEQAMoveStock(SourceID)),"^",4)
	
	///检查是否已被转移单占用
	s ListID=0
	f  s ListID=$o(^DHCEQAMoveStockList(0,"MoveStock",SourceID,ListID)) quit:(ListID="")||(Flag'=0)  d
	.s AStockDetailDR = $p($g(^DHCEQAMoveStockList(ListID)),"^",14)
	.s FreezeNum=##class(web.DHCEQ.MP.BUSStoreMove).CheckAccessoryDR(AStockDetailDR,FromLocDR,ListID,0)
	.i ((FreezeNum+$p($g(^DHCEQAMoveStockList(ListID)),"^",11))>$p($g(^DHCEQAStockDetail(AStockDetailDR)),"^",17)) s Flag=-7406	;配件库存数量不足(占用)
	
	q Flag
}

/// 被占用的配件数量
/// RowID			为StockDetailDR
/// vMXRowID 		转移明细,退货减少明细或维修单配件明细ID
/// vChangeType     0:转移单	1:退货,减少单 	2:维修单
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).CheckAccessoryDR(1723,485,"",2)
ClassMethod CheckAccessoryDR(RowID, LocDR, vMXRowID, vChangeType)
{
	;s ^DHCEQMozy("CheckAccessoryDR",$h)=RowID_","_LocDR_","_vMXRowID_","_vChangeType
	s movenum=0
	s reducenum=0
	s maintnum=0
	s Num=0
	
	//被转移单占据的数量
	s rowid=0 
	f  s rowid=$o(^DHCEQAMoveStock(0,"FromLoc",LocDR,rowid))  q:(rowid="")  d
	.s Status=$p($g(^DHCEQAMoveStock(rowid)),"^",28)
	.q:(Status>1)		//过滤掉非'新增','提交' 状态的单据.
	.s mrowid=0 
	.f  s mrowid=$o(^DHCEQAMoveStockList(0,"MoveStock",rowid,mrowid))  q:(mrowid="")  d
	..q:((vMXRowID'="")&&(mrowid=vMXRowID)&&(vChangeType=0))
	..
	..;维修配件
	..s WXPartRowID=""
	..i (vChangeType=2) s WXPartRowID=$o(^DHCEQMMaintPart(0,"AMoveStockList",mrowid,""))
	..q:(WXPartRowID'="")&&(WXPartRowID=vMXRowID)
	..
	..;s mStockDetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	..s DetailIDs=$g(^DHCEQAMoveStockList(mrowid,"EX","RowIDs"))
	..s TSerialFlag=$p($g(^DHCEQAMoveStockList(mrowid)),"^",9)
	..i TSerialFlag="Y" d
	...i DetailIDs'=""  d
	....s DetailLen=$L(DetailIDs,",")
	....s idx=1
	....f  s DetailDR=$p(DetailIDs,",",idx) q:idx>DetailLen  d
	.....s idx=idx+1
	.....q:(DetailDR'="")&&(RowID'=DetailDR)
	.....s movenum=movenum+1
	...e  d
	....s DetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	....q:(DetailDR'="")&&(RowID'=DetailDR)
	....s movenum=movenum+$p($g(^DHCEQAMoveStockList(mrowid)),"^",11)
	..e  d
	...s DetailDR=$p($g(^DHCEQAMoveStockList(mrowid)),"^",14)
	...q:(DetailDR'="")&&(RowID'=DetailDR)
	...s movenum=movenum+##Class(web.DHCEQAReduce).GetMaxQuantityNum(mrowid)
	
	//退货减少单占据的数量
	s Status=""
	f  s Status=$o(^DHCEQAReduce(0,"StatusReturnloc",Status)) q:Status=""  d
	.q:(Status>1)
	.s rowid=0
	.f  s rowid=$o(^DHCEQAReduce(0,"StatusReturnloc",Status,LocDR,rowid)) q:rowid=""  d
	..s mrowid=0
	..f  s mrowid=$o(^DHCEQAReduceList(0,"Reduce",rowid,mrowid)) q:mrowid=""  d
	...q:((vMXRowID'="")&&(mrowid=vMXRowID)&&(vChangeType=1))
	...s DetailIDs=$g(^DHCEQAReduceList(mrowid,"EX","RowIDs"))
	...s TSerialFlag=$p($g(^DHCEQAReduceList(mrowid)),"^",8) //增加序列号标志判断
	...i TSerialFlag="Y" d
	....i DetailIDs'=""  d  //不为空时存的为库存详细表ID,取ID的数量
	.....s DetailLen=$L(DetailIDs,",")
	.....s idx=1
	.....f  s DetailDR=$p(DetailIDs,",",idx) q:idx>DetailLen  d
	......s idx=idx+1
	......q:(DetailDR'="")&&(RowID'=DetailDR)
	......s reducenum=reducenum+1
	....e  d
	.....s DetailDR=$p($g(^DHCEQAReduceList(mrowid)),"^",5)
	.....q:(DetailDR'="")&&(RowID'=DetailDR)
	.....s reducenum=reducenum+$p($g(^DHCEQAReduceList(mrowid)),"^",10)
	...e  d  //为空时直接取业务详细表的数量
	....s DetailDR=$p($g(^DHCEQAReduceList(mrowid)),"^",5)
	....q:(DetailDR'="")&&(RowID'=DetailDR)
	....s reducenum=reducenum+$p($g(^DHCEQAReduceList(mrowid)),"^",10)
	
	//被维修单占用的数量
	s mrowid=0
	f  s mrowid=$o(^DHCEQMMaintPart(0,"MaintRequest",mrowid)) q:mrowid=""  d
	.s MTPRowID=0
	.f  s MTPRowID=$o(^DHCEQMMaintPart(0,"MaintRequest",mrowid,MTPRowID)) q:MTPRowID=""  d
	..q:$p($g(^DHCEQMMaintPart(MTPRowID)),"^",12)="Y"				//待购标志
	..s DetailDR=$p($g(^DHCEQMMaintPart(MTPRowID)),"^",13)			//ASDRowID
	..q:(RowID'="")&&(DetailDR'=RowID)
	..q:((vMXRowID'="")&&(RowID'="")&&(mrowid'=vMXRowID)&&(DetailDR'=RowID)&&(vChangeType=2))
	..q:((vMXRowID'="")&&(vMXRowID=MTPRowID)&&(vChangeType=2))		//选择记录过滤
	..;;;;;;;;;;;;;;;;;;;;;;;;无效转移要算占用
	..s mslrowid=+$p($g(^DHCEQMMaintPart(MTPRowID)),"^",11)
	..q:(mslrowid>0)&($d(^DHCEQAMoveStockList(mslrowid)))
	..s maintnum=maintnum+$p($g(^DHCEQMMaintPart(MTPRowID)),"^",3)
	
	
	s Num=movenum+reducenum+maintnum
	q Num
}

/// w ##Class(web.DHCEQ.MP.BUSStoreMove).DeleteData()
ClassMethod DeleteData(RowID)
{
	Set $ZT="ERRORDelete"
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	s SQLCODE=0
	&SQL(Update SQLUSER.DHC_EQAMoveStock Set AMS_Status='3' where AMS_RowID=:RowID)
	i SQLCODE Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "删除主单记录失败")
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORDelete 
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:提交转移单
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).SubmitData(40)
ClassMethod SubmitData(RowID)
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	i $p($g(^DHCEQAMoveStock(RowID)),"^",28)="3" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)
	i $p($g(^DHCEQAMoveStock(RowID)),"^",30)="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-7401)	;AMS_Hold1		自动建单未编辑标志
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAMoveStock(RowID)),"^",28) //状态
	if Status'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	
	Set $ZT="ERRORSubmit"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
  	k PLIST
	
	s AccessoryTypeDR=$p($g(^DHCEQAMoveStock(RowID)),"^",2)
	s MoveType=$p($g(^DHCEQAMoveStock(RowID)),"^",14)
	s PLIST(12) = User 	
 	s PLIST(13) = Date
 	s PLIST(14) = Time
	s PLIST(29) = "1"	

	s ApproveCondition="MoveType,DHCEQAMoveStock,"_MoveType
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("11")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, AccessoryTypeDR, "", "", "","",ApproveCondition)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9021)
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	//检测是否最后一步,是则自动审核 
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s PLIST(17)=User
		s PLIST(18)=Date
		s PLIST(19)=Time
		s PLIST(29)="2"
		s AppInfoStatus="2"
	}
	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"11",User)
	i SQLCODE
	{
		TROLLBACK
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除审批记录失败")
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批记录失败")
	}
	&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//最终审核调用
	i NextStep=""
	{
		s SQLCODE=##Class(web.DHCEQ.MP.BUSStoreMove).LastAuditAction(RowID,User)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")
		}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A02", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成消息失败")
	}

	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
 	
ERRORSubmit
	TRollBack
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.MP.BUSStoreMove).LastAuditAction()
ClassMethod LastAuditAction(RowID, User)
{
	s SQLCODE=##Class(web.DHCEQ.MP.BUSStoreMove).InsertAChangeStock(RowID,User)		//写入变动信息
	i SQLCODE q SQLCODE
	s SQLCODE=##Class(web.DHCEQ.MP.BUSStoreMove).UpdateAStockDetailInfo(RowID,User)	//更新配件库存明细信息
	q SQLCODE
}

/// 描述:库房变动信息
ClassMethod InsertAChangeStock(RowID, User)
{
	i RowID="" q -9001
	k ACSPL,ACSDPL
	s Date=+$H
	s Flag=0,ACSRowID="",DetailIDs=""
	s AccessoryTypeDR=$P($g(^DHCEQAMoveStock(RowID)),"^",2)
	s FromLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",4)
	s ToLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",5)
	s SubmitDate=$P($g(^DHCEQAMoveStock(RowID)),"^",12)
	s AuditDate=$P($g(^DHCEQAMoveStock(RowID)),"^",17)
	s AMSLRowID=0
	f  s AMSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",RowID,AMSLRowID)) quit:(AMSLRowID="")||(Flag'=0)  d
	.s ACSPL(2)=FromLoc		//ACS_FromLocDR
	.s ACSPL(3)=ToLoc		//ACS_ToLocDR
	.s ACSPL(4)=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",2)	//ACS_ItemDR
	.s ACSPL(5)=AccessoryTypeDR		//ACS_AccessoryTypeDR
	.s ACSPL(6)=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",7)	//ACS_BaseUOMDR
	.//s ACSPL(7)=		//ACS_UOMDR
	.//s ACSPL(8)=		//ACS_BaseStock
	.s ACSPL(9)=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",10)	//ACS_Price
	.s ACSPL(10)="1"		//ACS_SourceType
	.s ACSPL(11)=AMSLRowID	//ACS_SourceID
	.s ACSPL(12)=##Class(web.DHCEQ.MP.BUSStoreMove).GetAMSLTotalStock(AMSLRowID)		//ACS_Stock
	.s ACSPL(13)=User		//ACS_AuditUserDR
	.s ACSPL(14)=SubmitDate	//ACS_OutDate
	.s ACSPL(15)=AuditDate	 //ACS_AuditDate
	.&SQL(Insert into sqluser.DHC_EQAChangeStock values :ACSPL())
	.i SQLCODE 
	..s Flag=SQLCODE q
	.s ACSRowID=$G(%ROWID)	
	.s BatchFlag=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",8)
	.i BatchFlag="Y" d
	..s DetailIDs=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",14)		//批号管理
	.e  d
	..s DetailIDs=$G(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))		//序列号管理
	.s count=$l(DetailIDs,",")
	.f i=1:1:count d
	..q:Flag'=0
	..s DetailID=$p(DetailIDs,",",i)
	..i DetailID'=""  d
	...s ACSDPL(2)=ACSRowID		//ACSD_ChangeStockDR
	...s ACSDPL(3)=DetailID		//ACSD_StockDetailDR
	...s ToSourceID=##Class(web.DHCEQ.MP.BUSStoreMove).GetToAStockDR(ToLoc, ACSPL(4), DetailID)
	...s ACSDPL(4)=$p(ToSourceID,"^",2)	//ACSD_ToStockDetailDR
	...//s ACSDPL(5)=	//ACSD_BaseStock
	...s ACSDPL(6)=+$P($G(^DHCEQAStockDetail(DetailID)),"^",17)	//ACSD_Stock
	...s SQLCODE=0
	...&SQL(Insert into sqluser.DHC_EQAChangeStockDetail values :ACSDPL())
	...i SQLCODE s Flag=SQLCODE
	q Flag
}

/// 更新配件库存信息
/// W ##Class(web.DHCEQ.MP.BUSStoreMove).UpdateAStockDetailInfo(53,1)
ClassMethod UpdateAStockDetailInfo(RowID, User)
{
	k ASPL,ASDPL
	s Flag=0,AStockDetailDR="",ASDList="",ASRowID="",ASList="",ToSourceID="",Status="",NewRowID=""
	s FromLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",4)
	s ToLoc=$P($g(^DHCEQAMoveStock(RowID)),"^",5)
	s AccessoryTypeDR=$P($g(^DHCEQAMoveStock(RowID)),"^",2)
	s MoveType=$P($g(^DHCEQAMoveStock(RowID)),"^",14)
	i MoveType="2"  d
	.s Status="0"
	e  d
	.s Status="1"
	s AMSLRowID=0
	f  s AMSLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",RowID,AMSLRowID)) q:(AMSLRowID="")||(Flag'=0)  d
	.k ASPL,ASDPL
	.s QuantityNum=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",11)
	.s ItemDR=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",2)
	.s BatchFlag=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",8)
	.s SerialFlag=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",9)
	.//批号管理
	.i SerialFlag'="Y" d
	..s AStockDetailDR=$P($g(^DHCEQAMoveStockList(AMSLRowID)),"^",14)
	..s ASDList=$g(^DHCEQAStockDetail(AStockDetailDR))
	..s ASRowID=$p(ASDList,"^",21)
	..i ASRowID'="" s ASList=$g(^DHCEQAStock(ASRowID))
	..s Amount=+$p(ASList,"^",7)*QuantityNum	//AS_Amount
	..s ToSourceID=##Class(web.DHCEQ.MP.BUSStoreMove).GetToAStockDR(ToLoc,ItemDR,AStockDetailDR)
	..s ARowID=$p(ToSourceID,"^",1)
	..s ADRowID=$p(ToSourceID,"^",2)
	..i ARowID=""  d
	...d AddAStockValues
	...q:Flag
	...d AddAStockDetailValues
	...q:Flag
	..e  d
	...i ADRowID=""  d
	....s NewRowID=ARowID
	....d AddAStockDetailValues
	....q:Flag
	...e  d
	....&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_Stock=ASD_Stock+:QuantityNum where ASD_RowID=:ADRowID)
	....s AID=$Get(%ROWID)
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	....i AMSLRowID'="" d
	.....&SQL(Update SQLUSER.DHC_EQAMoveStockList Set AMSL_StockDetailDR=:AID Where AMSL_RowID=:AMSLRowID)
	.....i SQLCODE d
	......s Flag=SQLCODE q
	....&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_Stock=ASD_Stock-:QuantityNum where ASD_RowID=:AStockDetailDR)
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	...&SQL(Update SQLUSER.DHC_EQAStock Set AS_Amount=AS_Amount-:Amount,AS_Stock=AS_Stock-:QuantityNum  Where AS_RowID=:ASRowID)	
	...i SQLCODE  d
	....s Flag=SQLCODE q
	...&SQL(Update SQLUSER.DHC_EQAStock Set AS_Amount=AS_Amount+:Amount,AS_Stock=AS_Stock+:QuantityNum  Where AS_RowID=:ARowID)	
	...i SQLCODE  d
	....s Flag=SQLCODE q
	.e  d //序列号管理
	..s DetailIDs=$G(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))
	..s length=$l(DetailIDs,",")
	..f i=1:1:length  d
	...q:Flag
	...k ASPL,ASDPL
	...s AStockDetailDR=$p(DetailIDs,",",i)
	...s ASDList=$g(^DHCEQAStockDetail(AStockDetailDR))
	...s ASRowID=$p(ASDList,"^",21)
	...s Bprice=$p(ASDList,"^",8)	//ASD_Bprice
	...s ASList=$g(^DHCEQAStock(ASRowID))
	...s ToSourceID=##Class(web.DHCEQ.MP.BUSStoreMove).GetToAStockDR(ToLoc,ItemDR,AStockDetailDR)
	...s ARowID=$p(ToSourceID,"^",1)
	...s ADRowID=$p(ToSourceID,"^",2)
	...i ARowID=""  d
	....d AddAStockValues
	....q:Flag
	...e  d
	....s NewRowID=ARowID
	....&SQL(Update SQLUSER.DHC_EQAStock Set AS_Stock=AS_Stock+1,AS_Amount=AS_Amount+:Bprice Where AS_RowID=:ARowID)
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	....&SQL(Update SQLUSER.DHC_EQAStock Set AS_Stock=AS_Stock-1,AS_Amount=AS_Amount-:Bprice Where AS_RowID=:ASRowID)
	....i SQLCODE  d
	.....s Flag=SQLCODE q
	...&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_LocDR=:ToLoc,ASD_StockDR=:NewRowID,ASD_Status=:Status Where ASD_RowID=:AStockDetailDR ) //qw0005-2014-06-11:AStockDetailDR
	...i SQLCODE  d
	....s Flag=SQLCODE q
	
	Quit Flag
	
AddAStockValues
	s ASPL(2)=ToLoc				//AS_LocDR
	s ASPL(3)=$p(ASList,"^",2)	//AS_ItemDR
	s ASPL(4)=$p(ASList,"^",3)	//AS_Code
	s ASPL(5)=$p(ASList,"^",4)	//AS_Desc
	s ASPL(6)=$p(ASList,"^",5)	//AS_AccessoryTypeDR
	s ASPL(8)=+$p(ASList,"^",7)	//AS_FinalBPrice
	s ASPL(10)=+$p(ASList,"^",7)*QuantityNum	//AS_Amount
	s ASPL(11)=QuantityNum		//AS_Stock
	&SQL(Insert Into SQLUSER.DHC_EQAStock Values :ASPL())	//插入新的库存记录
	i SQLCODE d
	.s Flag=SQLCODE q
	s NewRowID=$G(%ROWID)
	&SQL(Update SQLUSER.DHC_EQAStock Set AS_Amount=AS_Amount-:ASPL(10),AS_Stock=AS_Stock-:ASPL(11) Where AS_RowID=:ASRowID)	//更新旧的库存记录
	i SQLCODE d
	.s Flag=SQLCODE q
	quit
AddAStockDetailValues
	s ASDPL(2)=ToLoc					//ASD_LocDR
	s ASDPL(3)=$p(ASDList,"^",2)		//ASD_ItemDR
	s ASDPL(4)=$p(ASDList,"^",3)		//ASD_AInStockListDR
	s ASDPL(5)=$p(ASDList,"^",4)		//ASD_Code
	s ASDPL(6)=$p(ASDList,"^",5)		//ASD_Desc
	s ASDPL(7)=$p(ASDList,"^",6)		//ASD_BatchNo
	s ASDPL(8)=$p(ASDList,"^",7)		//ASD_ExpiryDate
	s ASDPL(9)=$p(ASDList,"^",8)		//ASD_Bprice
	s ASDPL(10)=$p(ASDList,"^",9)		//ASD_SerialNo
	s ASDPL(11)=$p(ASDList,"^",10)		//ASD_No
	s ASDPL(12)=$p(ASDList,"^",11)		//ASD_AccessoryTypeDR
	s ASDPL(13)=Status					//ASD_Status
	s ASDPL(14)=$p(ASDList,"^",13)		//ASD_BaseUOMDR
	s ASDPL(15)=$p(ASDList,"^",14)		//ASD_ManuFactoryDR
	s ASDPL(16)=$p(ASDList,"^",15)		//ASD_Model
	s ASDPL(17)=$p(ASDList,"^",16)		//ASD_ProviderDR
	s ASDPL(18)=QuantityNum				//ASD_Stock
	s ASDPL(22)=NewRowID				//ASD_StockDR
	s ASDPL(31)=$p(ASDList,"^",30)		//ASD_Hold1	Mozy0236	资金类型
	&SQL(Insert Into SQLUSER.DHC_EQAStockDetail Values :ASDPL())
	s AID=$Get(%ROWID)
	i SQLCODE d
	.s Flag=SQLCODE q  
	i AMSLRowID'="" d
	.&SQL(Update SQLUSER.DHC_EQAMoveStockList Set AMSL_StockDetailDR=:AID Where AMSL_RowID=:AMSLRowID)
	.i SQLCODE d
	..s Flag=SQLCODE q
	&SQL(Update SQLUSER.DHC_EQAStockDetail Set ASD_Stock=ASD_Stock-:ASDPL(18) Where ASD_RowID=:AStockDetailDR)
	i SQLCODE d
	.s Flag=SQLCODE q
	quit
}

/// 获取将要转入到的库房的AStockDR和AStockDetailDR . 若没有 则返回空.
ClassMethod GetToAStockDR(ToLocDR, FromItemDR, FromStockDetailDR)
{
	s FromAISLDR=$p($g(^DHCEQAStockDetail(FromStockDetailDR)),"^",3)	//ASD_AInStockListDR
	s rowid=0,findFlag=0,findARowID="",findADRowID=""
	f  s rowid=$o(^DHCEQAStock(0,"Loc",ToLocDR,rowid)) q:(rowid="")||(findFlag=1)  d
	.q:$p($g(^DHCEQAStock(rowid)),"^",2)'=FromItemDR
	.s findARowID=rowid
	.s Drowid=0
	.f  s Drowid=$o(^DHCEQAStockDetail(0,"AStock",rowid,Drowid)) q:(Drowid="")||(findFlag=1)  d
	..q:$p($g(^DHCEQAStockDetail(Drowid)),"^",2)'=FromItemDR
	..s ToAISLDR=$p($g(^DHCEQAStockDetail(Drowid)),"^",3) 	//ASD_AInStockListDR
	..i FromAISLDR=ToAISLDR  d
	...s findFlag=1
	...s findADRowID=Drowid
	
	q findARowID_"^"_findADRowID
}

/// 得到转移明细单对应配件的总库存
ClassMethod GetAMSLTotalStock(AMSLRowID)
{
	i AMSLRowID="" q ""
	s TotalStock=0
	s serialFlag=$P($G(^DHCEQAMoveStockList(AMSLRowID)),"^",9)
	i serialFlag="Y"
	{
		s detailDRs=$G(^DHCEQAMoveStockList(AMSLRowID,"EX","RowIDs"))
		s count=$l(detailDRs,",")
		f i=1:1:count
		{
			s detailDR=$p(detailDRs,",",i)
			i detailDR'=""
			{
				s TotalStock=TotalStock+$P($G(^DHCEQAStockDetail(detailDR)),"^",17)
			}
		}
	}
	else
	{
		s detailDR=$P($G(^DHCEQAMoveStockList(AMSLRowID)),"^",14)
		i detailDR'=""
		{
			s TotalStock=+$P($G(^DHCEQAStockDetail(detailDR)),"^",17)
		}
	}
	q TotalStock
}

/// 描述:取消提交
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).CancelSubmitData(42,2,"")
ClassMethod CancelSubmitData(RowID, CurRole, CancelToFlowDR, RejectReason As %Library.String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	Set $ZT="ERRORCancel"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAMoveStock(RowID)),"^",28) //状态
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	k PLIST
	s PLIST(25) = RejectReason	//AMS_RejectReason	MZY0074	1849905		2021-04-30
	s PLIST(26) = User 	//AMS_RejectUserDR
 	s PLIST(27) = +$H	//AMS_RejectDate
 	s PLIST(28) = $p($H,",",2)	//AMS_RejectTime
 	s ApproveRoleDR=""
 	s Step=""
 	s Status="0"
	if (CancelToFlowDR'="")
	{
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	s PLIST(29)=Status
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("11")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("11", RowID)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9021)
	
	TSTART
	// MZY0027	1326004		2020-05-21
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批流失败")
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批记录失败")
	}
	&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单失败")
	}
	s ApproveFlow=""
	i CancelToFlowDR'="" s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A02", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成消息失败")
	}
	
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORCancel
	TRollBack
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// 描述:审核
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).AuditData(42,1796,2,1)
ClassMethod AuditData(RowID, CurRole, RoleStep, editFieldsInfo As %Library.String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	;n ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	;n User,Date,AuditFlag
	Set $ZT="ERRORAudit"
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	k PLIST
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAMoveStock(RowID)),"^",28) //状态
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("11")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("11", RowID)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9021)
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"
	
	TSTART	
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ("2"=$p($g(^DHCEQAMoveStock(RowID)),"^",28))
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002, "单据状态错误")
		}
		s AuditFlag=1
		s AppInfoStatus="2"
		s Date=+$H
		s PLIST(17)=User
		s PLIST(18)=Date
		s PLIST(19)=Time
		s PLIST(29)="2"
		&SQL(update sqluser.DHC_EQAMoveStock values :PLIST() where AMS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单失败")
		}
	}
	//转移审核增加保存生成审批的记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新审批流失败")
	}
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批记录失败")
	}
	//可编辑字段更新 
	i editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")
		}
	}
	;最后一步需要调用审核方法 
	i AuditFlag=1
	{
		s SQLCODE=##Class(web.DHCEQ.MP.BUSStoreMove).LastAuditAction(RowID,User)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")
		}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A02", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成消息失败")
	}
	TCOMMIT

 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, RowID)
ERRORAudit
	TRollBack
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

}
