/// 名称: web.DHCEQ.EM.BUSStoreMove
/// 描述: 设备转移管理
/// 编写者：ZX
/// 编写日期: 2018-10-10
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSStoreMove Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSStoreMove","GetStoreMoveList","11")
Query GetStoreMoveList(StoreMoveID) As %Query(ROWSPEC = "SMLRowID:%String,SMLEquipDR:%String,SMLEquipDR_EQName:%String,SMLBatchFlag:%String,SMLInStockListDR:%String,SMLManuFactoryDR:%String,SMLManuFactoryDR_MFName:%String,SMLOriginalFee:%String,SMLQuantityNum:%String,SMLTotalFee:%String,SMLModelDR:%String,SMLModelDR_MDesc:%String,SMLUnitDR:%String,SMLUnitDR_UOMDesc:%String,SMLRemark:%String,SMLMoveNum:%String,SMLFlag:%String,SMLLocationDR_LDesc:%String,SMLLocationDR:%String,SMLHold1:%String,SMLHold2:%String,SMLHold3:%String,SMLHold4:%String,SMLHold5:%String,SMLEquipName:%String,SMJob:%String,TEquipNos:%String,SMLDepreMethodDR:%String,SMLDepreMethodDR_DMDesc:%String,SMLLimitYearsNum:%String,SMLDepreBeginDate:%String")
{
}

ClassMethod GetStoreMoveListExecute(ByRef qHandle As %Binary, StoreMoveID) As %Status
{
 	new repid, index,rowid,TRow
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Job=$J
	s rowid=0
	if (StoreMoveID="")
	{
		d ResetVariablesGetStoreMoveList
		s TJob=Job
		d OutputRowGetStoreMoveList
	}
	else
	{
		s StoreLoc=$p($g(^DHCEQStoreMove(StoreMoveID)),"^",2)
	 	s SMEquipType=$p($g(^DHCEQStoreMove(StoreMoveID)),"^",16)
	 	s SMStatCat=$p($g(^DHCEQStoreMove(StoreMoveID)),"^",17)
	 	i '$Data(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveID)) Quit $$$OK
	 	f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveID,rowid))  quit:rowid=""  d
		.d ResetVariablesGetStoreMoveList
	 	.s DataList=$g(^DHCEQStoreMoveList(rowid))
	 	.s TRowID=rowid
	 	.s TEquipDR=$p(DataList,"^",2)
	 	.i TEquipDR'="" s TMoveNum=1
	 	.s TBatchFlag=$p(DataList,"^",3)
	 	.s TInStockListDR=$p(DataList,"^",4)
	 	.i (TInStockListDR'="")&&(TBatchFlag="Y")  d
	 	..s TSourceType=$p($g(^DHCEQInStockList(TInStockListDR)),"^",18)
		..s TSourceID=$p($g(^DHCEQInStockList(TInStockListDR)),"^",19)
		..i (TSourceType=1) s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",3)
		..i (TSourceType=2) s EquipTypeDR=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",3)
		..s TMoveNum=##Class(web.DHCEQ.EM.BUSStoreMove).GetTotalMoveQuantity(StoreLoc,TInStockListDR,EquipTypeDR,SMStatCat)
		..s MovedQuantity=##Class(web.DHCEQ.EM.BUSStoreMove).GetMoveListQuantity(TInStockListDR,rowid,"StoreMove")
		..s TMoveNum=TMoveNum-MovedQuantity
		.s TCommonName=$p(DataList,"^",5)
	 	.i TInStockListDR'=""  d
		..s TEquip=$p($g(^DHCEQInStockList(TInStockListDR)),"^",16)
		..s TEquipNos=##class(web.DHCEQCommon).GetEquipNos(21,TInStockListDR,"","EquipNo")
		.e  d
		..s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
		..s TEquipNos=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
		.i TEquip'="" s TEquip=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquip)),"^",1)
		.s TManuFactoryDR = $p(DataList,"^",6)
		.s TManuFactory = ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		.s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(rowid)),"^",7),"")
		.s TQuantityNum = $p(DataList,"^",8)
		.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantityNum,"")
		.s TModelDR = $p(DataList,"^",9)
		.s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
		.s TUnitDR = $p(DataList,"^",10)
		.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.s TRemark = $p(DataList,"^",11)
		.//add by zx 2019-06-04 批量标志 modified by wy 2020-1-9 1171183
		.s TFlag="N"
		.i TEquipDR'="" d
		..s TFlag="Y"
		.s TLocationDR = $p(DataList,"^",12)
		.i TLocationDR'="" s TLocation = ##class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
		.s THold1 = $p(DataList,"^",13)
		.s THold2 = $p(DataList,"^",14)
		.s THold3 = $p(DataList,"^",15)
		.s THold4 = $p(DataList,"^",16)
		.s THold5 = $p(DataList,"^",17)
		.s TJob=Job
		.s TDepreMethodDR = $p(DataList,"^",18)		//czf 2023-01-31
		.s TDepreMethod = ##class(web.DHCEQCommon).GetTrakNameByID("depremethod",TDepreMethodDR)
		.s TLimitYearsNum = $p(DataList,"^",19)
		.s TDepreBeginDate = $p(DataList,"^",20)
		.i (TDepreBeginDate="")&&(TDepreMethodDR="1") s TDepreBeginDate=$ZDATE($HOROLOG,3) //add by zyq 2023-04-10 当为平均年限法时，显示默认当前日期
		.s TDepreBeginDate = ##class(web.DHCEQCommon).TransValueToPage(TDepreBeginDate,"date")
		.d OutputRowGetStoreMoveList
	}
 	
	Quit $$$OK
	
OutputRowGetStoreMoveList
	s Data=$lb(TRowID,TEquipDR,TEquip,TBatchFlag,TInStockListDR,TManuFactoryDR,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TModelDR,TModel,TUnitDR,TUnit,TRemark,TMoveNum,TFlag,TLocation,TLocationDR,THold1,THold2,THold3,THold4,THold5,TCommonName,TJob,TEquipNos,TDepreMethodDR,TDepreMethod,TLimitYearsNum,TDepreBeginDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveList
	s (TRowID,TEquipDR,TEquip,TBatchFlag,TInStockListDR,TManuFactoryDR,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TModelDR,TModel,TUnitDR,TUnit,TRemark,TMoveNum,TFlag,TLocation,TLocationDR,THold1,THold2,THold3,THold4,THold5,TCommonName,TJob,TEquipNos)=""
	s (TDepreMethodDR,TDepreMethod,TLimitYearsNum,TDepreBeginDate)=""
	quit
}

ClassMethod GetStoreMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
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

ClassMethod GetStoreMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:取台账中可以转移的设备数量
ClassMethod GetTotalMoveQuantity(Stock, InStockList, EquipType, StatCat)
{
	s Total=0
	s EQRowID=0
	f  s EQRowID=$O(^DHCEQEquip(0,"StoreInStock",Stock,EquipType,"1","N",InStockList,EQRowID)) q:EQRowID=""  d
	.s Total=Total+1
	q Total
}

ClassMethod GetMoveListQuantity(InStockList, RowID, OrderType)
{
	new (InStockList, RowID,OrderType)
	s (Total,SMTotal,RTotal)=0
	s SMLRowID=0
	f  s SMLRowID=$O(^DHCEQStoreMoveList(0,"InStockList",InStockList,SMLRowID)) q:SMLRowID=""  d
	.s TSMRowID= $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	.//获取转移和退货数量时，去掉无效单据
	.q:$p($g(^DHCEQStoreMove(TSMRowID)),"^",27)="Y"
	.q:(SMLRowID=RowID)&&(RowID'="")&&(OrderType="StoreMove")
	.s TSMStatus= $p($g(^DHCEQStoreMove(TSMRowID)),"^",13)
	.q:TSMStatus="2"
	.s SMQuantity= $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	.s SMTotal=SMTotal+SMQuantity
	s RLRowID=0
	f  s RLRowID=$O(^DHCEQReturnList(0,"InStockList",InStockList,RLRowID)) q:RLRowID=""  d
	.s TRRowID= $p($g(^DHCEQReturnList(RLRowID)),"^",1)
	.//获取转移和退货数量时，去掉无效单据
	.q:$p($g(^DHCEQReturn(TRRowID)),"^",28)="Y"
	.q:(RLRowID=RowID)&&(RowID'="")&&(OrderType="Return")
	.s TRStatus= $p($g(^DHCEQReturn(TRRowID)),"^",13)
	.q:TRStatus="2"
	.s RQuantity= $p($g(^DHCEQReturnList(RLRowID)),"^",5)
	.s RTotal=RTotal+RQuantity
	s Total=SMTotal+RTotal
	q Total
}

ClassMethod GetOneStoreMove(RowID As %Library.String = "", ApproveRoleDR As %Library.String, Action As %Library.String = "", Step As %Library.String = "")
{
	s $ZT="ERRORGetOneStoreMove"
	s ObjStoreMove=##Class(User.DHCEQStoreMove).%OpenId(RowID)
	s StoreMoveInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjStoreMove)
	d StoreMoveInfo.%Set("SMFromLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjStoreMove.SMFromLocDR))
	d StoreMoveInfo.%Set("SMToLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjStoreMove.SMToLocDR))
	d StoreMoveInfo.%Set("SMMakerDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjStoreMove.SMMakerDR))
	d StoreMoveInfo.%Set("SMAckUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjStoreMove.SMAckUserDR))
	d StoreMoveInfo.%Set("SMInAckUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjStoreMove.SMInAckUserDR))
	d StoreMoveInfo.%Set("SMReciverDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjStoreMove.SMReciverDR))
	d StoreMoveInfo.%Set("SMEquipTypeDR_ETDesc",ObjStoreMove.SMEquipTypeDR.ETDesc)
	d StoreMoveInfo.%Set("SMStatCatDR_SCDesc",ObjStoreMove.SMStatCatDR.SCDesc)
	d StoreMoveInfo.%Set("SMBillAckUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjStoreMove.SMBillAckUserDR))
	d StoreMoveInfo.%Set("SMCancelUser_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjStoreMove.SMCancelUser))
	d StoreMoveInfo.%Set("SMMoveType_Desc",$CASE(ObjStoreMove.SMMoveType,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配")) //Modify by wl 2019-10-31 1071547
	d StoreMoveInfo.%Set("SMHold2_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjStoreMove.SMHold2))		//add by czf 2020-11-05 1559991 管理科室解析
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("14",RowID,ApproveRoleDR)
	d StoreMoveInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d StoreMoveInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d StoreMoveInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d StoreMoveInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d StoreMoveInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d StoreMoveInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d StoreMoveInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d StoreMoveInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d StoreMoveInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d StoreMoveInfo.%Set("NextRole",$p(AppInfo,"^",10))
	s CanChangeValue=""
	i Action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("14",Action,RowID,2,$p(AppInfo,"^",2))		//czf 20210616
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_Step_",")) d
	.s MultipleRoleFlag=1
	
	d StoreMoveInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	
	//add by ZY20230228 bug:3295367
    s SMMakerDRImg=""
    s SMMakerDR=ObjStoreMove.SMMakerDR
    i SMMakerDR'="" d
    .s DeptExType = $p($g(^DHCEQCCode("DHCEQCUser",SMMakerDR)),"^",18)
    .q:(DeptExType'=1)      //"1":"DHC-HIS"
    .s UserID = $p($g(^DHCEQCCode("DHCEQCUser",SMMakerDR)),"^",19)
    .s SMMakerDRImg=##Class(web.DHCEQ.Interface.Inner.DHCEQCA).GetCAImage(UserID)
    .i SMMakerDRImg'="" s SMMakerDRImg="data:image/png;base64,"_SMMakerDRImg
    d StoreMoveInfo.%Set("SMMakerDRImg",SMMakerDRImg)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,StoreMoveInfo)
ERRORGetOneStoreMove
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// add by zx 2018-10-16
/// modified by csj 2020-07-21 添加序号输出列 需求号：1427075
/// 描述：转移单列表中设备下拉框数据Query
/// 入参：RowID：业务明细ID
///       FromLocDR：来源科室
///       EquipTypeDR：资产类组
///       StatCatDR：资产类型
///       StockStatus：资产库房状态
///       ProviderDR：供货商
///       ListType：业务明细RowID类型：1转移单 2退货单
///       Equip：资产名称
///       InStockNo：入库单号
///       UseLocDR：使用科室
///       Flag：是否单台方式检索，true是，其他否	
///       Type：为1时取被服类组
///       AllListInfo：被服信息
/// 	  TIndex:序号	//modified by csj 2020-07-21 需求号：1427075
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSStoreMove","GetInStockList","",228,2,"",1,"",2,"","","","false","","")
Query GetInStockList(RowID, FromLocDR, EquipTypeDR, StatCatDR, StockStatus, ProviderDR, ListType, Equip, InStockNo, UseLocDR As %String = "", Flag As %String = "", Type As %String = "", AllListInfo As %String = "") As %Query(ROWSPEC = "TName:%String,TEquipID:%String,TInStockListID:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TUnitDR:%String,TUnit:%String,TQuantity:%String,TOriginalFee:%String,TInStockNo:%String,TEquipNo:%String,TInvoiceNo:%String,TRequestLoc:%String,TLocationDR:%String,TLocation:%String,TInDate:%String,TCommonName:%String,TRemark:%String,THasConfig:%String,TConfigDR:%String,TIndex:%String,TFromLocDR:%String")
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, RowID, FromLocDR, EquipTypeDR, StatCatDR, StockStatus, ProviderDR, ListType, Equip, InStockNo, UseLocDR As %String = "", Flag As %String = "", Type As %String = "", AllListInfo As %String = "") As %Status
{
	new repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	S Equip=$ZCONVERT(Equip,"U")
	i FromLocDR="" q $$$OK
	i StockStatus="" q $$$OK
	
	i UseLocDR'="" s FromLocDR=UseLocDR
	s EquipTypeValues=""
	i Type="1"  s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	i EquipTypeValues'="" s EquipTypeValues=","_EquipTypeValues_","
	
	s TCurListRow=$p(AllListInfo,"=",1)
	s TJob=$p(AllListInfo,"=",2)
	s TAllListInfo=$p(AllListInfo,"=",3)
	s TAllListCount=$L(TAllListInfo,"&")
	
	s TEquipTypeDR=0
	f  s TEquipTypeDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,TEquipTypeDR)) q:TEquipTypeDR=""  d
	.q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.s TInStockListID=""
	.f  s TInStockListID=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,TEquipTypeDR,StockStatus,"N",TInStockListID)) q:TInStockListID=""  d
	..q:##class(web.DHCEQCommon).FundsTypeIsIn(3,TInStockListID)	// Mozy0231	资金来源类型
	..s (TInStockNo,TInvoiceNo)=""
	..i TInStockListID>0 d
	...s TInStockNo=$P($G(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListID)),"^",1))),"^",14)
	...q:(InStockNo'="")&&(TInStockNo'[InStockNo)
	...s TInvoiceNo=##class(web.DHCEQCommon).GetInvoiceNo(1,TInStockListID)	//czf 2022-06-02
	...;s TInvoiceNo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,TInStockListID)
	...;s TInvoiceNo=$p(TInvoiceNo,"^",1)
	..q:(InStockNo'="")&&((","_TInStockNo_",")'[(","_InStockNo_","))	
	..;q:(InStockNo'="")&&(TInStockNo'[InStockNo)
	..
	..i Flag="true"  d
	...s InStockListID=0
	..e  d
	...s InStockListID=TInStockListID
	..s count=0			//modified by ZY0306 2709865
	..s Num=0
	..s EquipID=""
	..s TEquipDR=0
	..f  s TEquipDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,TEquipTypeDR,StockStatus,"N",TInStockListID,TEquipDR)) q:TEquipDR=""  d
	...d ResetVariablesGetInStockList
	...s CurFlag=0
	...s CurListNo=0
	...f CurListNo=1:1:TAllListCount  d
	....q:CurFlag'=0
	....s CurListInfo=$p(TAllListInfo,"&",CurListNo)
	....q:CurListInfo=""
	....s TCurListID=$p(CurListInfo,"^",1)
	....s TCurMXRowID=$p(CurListInfo,"^",2)
	....i TCurListRow'=TCurListID  d
	.....i TCurMXRowID'=""  d
	......s TCurRowIDs=$g(^TEMPEQ("MXList",TJob,TCurMXRowID))
	.....e  d
	......s TCurRowIDs=$g(^TEMPEQ("MXList","EX",TJob,TCurListID))
	.....i (","_TCurRowIDs_",")[(","_TEquipDR_",") s CurFlag=1
	...q:CurFlag'=0
	...s TProviderDR=$p($g(^DHCEQEquip(TEquipDR)),"^",25)		;provderDR
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...s TStatus=$p($g(^DHCEQEquip(TEquipDR)),"^",38)		;TStatus
	...q:(TStatus="3")||(TStatus="4")
	...s TStatCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",75)
	...q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	...s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)
	...;add by zx 2019-03-14 通过通用名筛选 ZX0061
	...;s TName=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
	...;i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1)
	...s TCommonName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	...s TCommonName=$ZCONVERT(TCommonName,"U")
	...s TCode=$p($g(^DHCEQEquip(TEquipDR)),"^",6)					;Code
	...s TLeaveFactoryNo=$p($g(^DHCEQEquip(TEquipDR)),"^",10)		;LeaveFactoryNo
	...s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	...q:(Equip'="")&&(TCommonName'[Equip)&&($ZCONVERT(TCode,"U")'[Equip)&&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)&&($ZCONVERT(TEquipNo,"U")'[Equip)&&($ZCONVERT(TInStockNo,"U")'[Equip)
	...//Modify by zx 2021-12-20 转移选择设备时过滤被占用 BUG ZX0142
	...;q:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(RowID,TEquipDR,FromLocDR,ListType)'=0
	...q:##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("22",RowID,TEquipDR,FromLocDR,"","N")'=0
	...;InStockListID为0时,按单台显示
	...s TLocationDR=$p($g(^DHCEQEquip(TEquipDR)),"^",72)
	...i TLocationDR'="" s TLocation = $p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	...i InStockListID=0  d
	....s Num=1
	....s EquipID=TEquipDR
	....d EquipInfo
	...e  d
	....s Num=Num+1
	....;只有一台时,也按单台处理
	....i Num=1 s EquipID=TEquipDR
	....i Num>1 s EquipID=""
	..;批量的,按入库明细显示
	..i ((InStockListID>0)&&(Num>0))  d
	...d EquipInfo
	
	Quit $$$OK
EquipInfo
	;单台取设备信息
	i EquipID'=""  d
	.s InStockListID=0
	.s TCommonName = $p($g(^DHCEQEquip(EquipID)),"^",1)
	.s TName=$p($g(^DHCEQEquip(EquipID)),"^",7)
	.i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1)
	.s TCode=$p($g(^DHCEQEquip(EquipID)),"^",6)					;Code
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(EquipID)),"^",10)		;LeaveFactoryNo
	.s TProviderDR=$p($g(^DHCEQEquip(EquipID)),"^",25)		;provderDR
	.s TStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)		;TStatus
	.s TStatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
	.s TEquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	.s TModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)
	.s TUnitDR=$p($g(^DHCEQEquip(EquipID)),"^",5)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(EquipID)),"^",26)
	.s TOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	.s TInDate=$p($g(^DHCEQEquip(EquipID)),"^",45)
	.s ISLRowID=$p($g(^DHCEQEquip(EquipID)),"^",70)
	.//modified by ZY0306 2709865
	.s count=count+1
	.s TRemark=""
	.i ISLRowID'=""  d
	..s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	..s TRemark=$p($g(^DHCEQInStockList(ISLRowID)),"^",12)
	..s countInStockList=0
	..s RequestLocDR=""
	..s ISLLID=0
	..f  s ISLLID=$o(^DHCEQInStockListLoc(0,"InStockList",ISLRowID,ISLLID)) quit:(ISLLID="")||(RequestLocDR'="")  d
	...s ISLLQuantity=$p($g(^DHCEQInStockListLoc(ISLLID)),"^",4)
	...s countInStockList=countInStockList+ISLLQuantity
	...i count<=countInStockList s RequestLocDR=$p($g(^DHCEQInStockListLoc(ISLLID)),"^",3)
	..s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLocDR)
	.
	.;// Mozy0217  2018-11-01
	.i THasConfig'="Y" d
	..s TOpenCheckListDR=$p($g(^DHCEQEquip(EquipID)),"^",77)
	..i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
	.; Mozy	800971	2019-1-11	附属设备从入库明细获取通用名(便于区分普通设备)
	.i THasConfig'="Y" d
	..i ##Class(web.DHCEQ.EM.BUSConfig).EQHasConfig(2,EquipID)=1 s THasConfig="Y"	//获取台账附属设备 czf 2023-02-27 
	.i $Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",24)'="" s TCommonName = $p($g(^DHCEQEquip(EquipID)),"^",1)	//$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
	.s TConfigDR=$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)				; EQHold13
	.i TConfigDR'="" s THasConfig="N"
	e  d
	.;批量取入库明细信息
	.s EquipID=""
	.s TCommonName = $p($g(^DHCEQInStockList(InStockListID)),"^",5)
	.s TName=$p($g(^DHCEQInStockList(InStockListID)),"^",16)
	.i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1)
	.s TCode=""
	.s TLeaveFactoryNo=""
	.s TProviderDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",17)
	.s TStatus=""
	.s TStatCatDR=$p($g(^DHCEQInStockList(InStockListID)),"^",17)
	.s TEquipNo=##class(web.DHCEQCommon).GetEquipNos(21,InStockListID,"","EquipNo")		//czf 2022-06-02
	.s TModelDR=$p($g(^DHCEQInStockList(InStockListID)),"^",9)
	.s TUnitDR=$p($g(^DHCEQInStockList(InStockListID)),"^",10)
	.s TManuFactoryDR=$p($g(^DHCEQInStockList(InStockListID)),"^",6)
	.s TOriginalFee=$p($g(^DHCEQInStockList(InStockListID)),"^",7)
	.s TInDate=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",1)
	.s ISRowID=$p($g(^DHCEQInStockList(InStockListID)),"^",1)
	.s TRemark=$p($g(^DHCEQInStockList(InStockListID)),"^",12)
	.;// Mozy0217  2018-11-01
	.s TOpenCheckListDR=$p($g(^DHCEQInStockList(InStockListID)),"^",19)
	.i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
	.s TConfigDR=$Piece($Get(^DHCEQInStockList(InStockListID)),"^",22)
	.i TConfigDR'="" s THasConfig="N"
	.s countInStockList=0
	.s RequestLocDR=""
	.s ISLLID=0
	.f  s ISLLID=$o(^DHCEQInStockListLoc(0,"InStockList",InStockListID,ISLLID)) quit:(ISLLID="")||(RequestLocDR'="")  d
	..s ISLLQuantity=$p($g(^DHCEQInStockListLoc(ISLLID)),"^",4)
	..s countInStockList=countInStockList+ISLLQuantity
	..i count<=countInStockList s RequestLocDR=$p($g(^DHCEQInStockListLoc(ISLLID)),"^",3)
	.s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLocDR)
	
	s TQuantity=Num
	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	//modified by ZY0306 2709865  
	i TInDate'="" s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")

	d OutputRowGetInStockList
	quit
OutputRowGetInStockList
	Set Data=$lb(TName,EquipID,InStockListID,TModelDR,TModel,TManuFactoryDR,TManuFactory,TUnitDR,TUnit,TQuantity,TOriginalFee,TInStockNo,TEquipNo,TInvoiceNo,RequestLoc,TLocationDR,TLocation,TInDate,TCommonName,TRemark,THasConfig,TConfigDR,index,FromLocDR)		// MZY0100	2288153,2288189		2021-11-18	输出来源科室
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockList
	s (TName,TModelDR,TModel,TManuFactoryDR,TManuFactory,TUnitDR,TUnit,TOriginalFee,TEquipNo,RequestLoc,TLocationDR,TLocation,TInDate,TCommonName,TRemark,TConfigDR)=""
	s THasConfig="N"	;无配置设备
	quit
}

ClassMethod GetInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListExecute ]
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

ClassMethod GetInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 转移类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSStoreMove","GetMoveType","")
Query GetMoveType(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetMoveTypeExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Length=4
	f ID=0:1:Length d
	.;add by zx 2019-01-10 科室退库描述错误
	.;"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配"
	.q:(ID="2")||(ID="4")
	.S TDesc=$CASE(ID,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配")
	.q:(Desc'="")&&(TDesc'[Desc)
	.d OutputRowGetMoveType
	
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

/// Modefied by zc0125 2022-12-12 增加入参vInventoryListDR和vInventoryExceptionDR
ClassMethod SaveData(data, dataList, DelIs, vInventoryListDR As %Library.String = "", vInventoryExceptionDR As %Library.String = "", User As %Library.String = "")
{
    s $ZT="ERRORStoreMove"
    k PLIST,RowID,SQLCODE
    s SQLCODE=0
	if User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($h,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s RowID = JsonData.SMRowID
	TSTART
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQStoreMove set SM_InvalidFlag='Y',SM_CancelDate=:Date,SM_CancelTime=:Time,SM_CancelUser=:User where SM_RowID = :RowID)
        //modified by ZY 20220926 2757106 删除明细占用节点记录
        i SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
        s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","22",RowID,1)
        i SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除明细占用节点记录")
        }
        //end by ZY 20220926 2757106 删除明细占用节点记录
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQStoreMove",JsonData,.PLIST)
		s RowID = JsonData.SMRowID
		s Job = JsonData.SMJob
	 	s PLIST(5) = User	;RequestUserDR
	 	s PLIST(6) = Date	;RequestDate
		s PLIST(14) = "0"	;Status
		s PLIST(28) = "N"
		s FromLocDR=JsonData.SMFromLocDR		//add by czf 2021-06-15 begin
		s FromHospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(FromLocDR)
		s ToLocDR=JsonData.SMToLocDR
		s ToHospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(ToLocDR)
		i (FromLocDR'="")&&(FromHospDR="")
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"供给科室所在院区不能为空!")
		}
		i (ToLocDR'="")&&(ToHospDR="")
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"接收科室所在院区不能为空!")
		}
		i FromHospDR=ToHospDR s PLIST(22) = 1
		e  s PLIST(22) = 2					//add by czf 2021-06-15 end
		
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQStoreMove Values :PLIST() where SM_RowID = :RowID)
		}
		else
		{
			i PLIST(2)="" d
			.s MoveTypeCode=##Class(web.DHCEQ.EM.BUSStoreMove).GetMoveTypeCode(JsonData.SMMoveType)
			.s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",Date,"",JsonData.SMEquipTypeDR,"","",MoveTypeCode)
			&SQL(insert into SQLUSER.DHC_EQStoreMove Values :PLIST())
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s RowID=$g(%ROWID)
		
		s SQLCODE=##Class(web.DHCEQ.EM.BUSStoreMove).JudgeSMLQuantityNum(RowID,Job,dataList)
	 	i SQLCODE
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 	}
	 	s SQLCODE=##Class(web.DHCEQ.EM.BUSStoreMove).DeleteStoreMoveList(RowID,DelIs)
	 	i SQLCODE
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 	}
	 	s SQLCODE=##Class(web.DHCEQ.EM.BUSStoreMove).SaveStoreMoveList(RowID,Job,dataList)
	 	i SQLCODE
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 	}
	 	
	 	;检查是否设备已经被其他单据占用
	 	s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(1,RowID)
	 	i SQLCODE
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE) //modified by csj 2020-07-21
	 	}
	 	//Modefied by zc0125 2022-12-12 增加盘点信息记录 begin	
	 	s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveBussInfoByInventory(vInventoryExceptionDR,vInventoryListDR,22,RowID)
 		i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
 		//Modefied by zc0125 2022-12-12 增加盘点信息记录 begin	
	}
	
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORStoreMove
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

ClassMethod GetMoveTypeCode(MoveType)
{
	;q $CASE(MoveType,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退货","4":"库房调配",:"没有定义")
	q $CASE(MoveType,"0":"CK","1":"TP","2":"ZF","3":"FK","4":"ZY",:"ZY")
}

/// w ##Class(web.DHCEQ.EM.BUSStoreMove).SubmitData("36^327^30^0^^^3^30^71^^^5376")
ClassMethod SubmitData(val)
{
	new (val, %session)
	k PLIST
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s RowID = $p(val,"^",1)
	i RowID'="" 
	{
		s InvalidFlag=$p($g(^DHCEQStoreMove(RowID)),"^",27)
		i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1015","单据已无效!")
	}
	s User=$p(val,"^",9)
	s EquipTypeDR=$p($g(^DHCEQStoreMove(RowID)),"^",16)
	s StatCatDR=$p($g(^DHCEQStoreMove(RowID)),"^",17)
	s MoveType=$p($g(^DHCEQStoreMove(RowID)),"^",12)
	s FormLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",2)
	s ToLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",3)
	s Loc1=FormLocDR
	s Loc2=ToLocDR
	s CheckType=0
	i MoveType=1 s CheckType=1
	i MoveType=3
	{
		s Loc1=ToLocDR
		s Loc2=FormLocDR
	}
	s ManageLocFlag=##Class(web.DHCEQCStoreManageLoc).CheckManageLoc(CheckType,Loc1,Loc2)
	i ManageLocFlag'=1 quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1016","科室不属于当前院区!")
	s PLIST(5) = User	;MakerDR
 	s PLIST(6) = Date
	s PLIST(14) = "1"
	//判断总单与明细单类组，类型是否一致
	s ReturnEquipType=##CLASS(web.DHCEQ.EM.BUSInStock).EquipTypeIsUniqueNew(RowID,EquipTypeDR,"StoreMove")
	i ReturnEquipType<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnEquipType)
	i ReturnEquipType=0 s ReturnEquipType=""
	s PLIST(17)=ReturnEquipType
	s Flag=##class(web.DHCEQCommon).GetSysInfo("301007")   //是否需要单据设备类型一致
	if Flag=1
	{
		s ReturnType=##Class(web.DHCEQ.EM.BUSStoreMove).StatCatIsUnique(RowID,StatCatDR)
		i ReturnType<0
		{
			s ErrMsg=""
			i ReturnType=-1001 s ErrMsg="明细设备类型不一致!"
			i ReturnType=-1002 s ErrMsg="明细设备类型有空值!"
			i ReturnType=-1004 s ErrMsg="明细设备类型与总单不一致!"
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnType,ErrMsg)
		}
		
		i ReturnType=0 s ReturnType=""
		s PLIST(18)=ReturnType
	}
	s ApproveCondition="MoveType,DHCEQStoreMove,"_MoveType
	s CrossHosp=$p($g(^DHCEQStoreMove(RowID)),"^",21)			//czf 2021-06-15 begin
	s ApproveCondition=ApproveCondition_"^"_"CrossHosp,DHCEQStoreMove,"_CrossHosp
	
	s EquipType=EquipTypeDR
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, "", "", "","",ApproveCondition)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4007","审批设置不存在!") //add by zx 2019-03-06 ZX0060 转化json格式输出
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"
	//检测是否最后一步,是则自动审核 Add By DJ 2010-08-24
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s PLIST(10)=User
		s PLIST(11)=Date
		s PLIST(14)="2"
		s AppInfoStatus="2"
	}
	TSTART	
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"14",User)
	i SQLCODE
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
	&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	i NextStep="" s SQLCODE=##Class(web.DHCEQ.EM.BUSStoreMove).LastStepAction(RowID,User)
	i SQLCODE'=0
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9200,SQLCODE)	//modified by ZY0229 20200511
	}
	s AuditFlag=0
	i NextStep="" s AuditFlag=1
	/// Modify By zx 2020-02-20 BUG ZX0076 科室接收限定动作
	s vLimitLocActions=$o(^DHCEQCCode("DHCEQCAction",0,"Code","Move_Receive",0))
	s LimitLocDR=$Piece($Get(^DHCEQStoreMove(RowID)),"^",3)
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("22", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag,"","","",vLimitLocActions,LimitLocDR)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg) //返回错误消息 ;
}

/// modified by ZY 20220926 2757106
ClassMethod LastStepAction(RowID, User)
{
    new SQLCODE
    s SQLCODE=0
    s SQLCODE=##class(web.DHCEQ.EM.BUSStoreMove).InsertChangeStock(RowID,User)      //写入设备变动信息
    i SQLCODE q SQLCODE
	s SQLCODE=##class(web.DHCEQ.EM.BUSStoreMove).InsertEQLifeInfo(RowID,User)		//生命周期信息
	i SQLCODE q SQLCODE
	//生成资金来源信息
	// Modefied by zc0125 2022-12-12 最终业务处理结果记录 begin
	s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveDisposeResultByBussType(22,RowID)
	i SQLCODE q SQLCODE
	// Modefied by zc0125 2022-12-12 最终业务处理结果记录 begin
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(SQLCODE'=0)  d
	.s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(4, SMLRowID)
	.Quit:SQLCODE'=0
	.Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(4, SMLRowID)
	///modified by ZY0297 20220415
    i SQLCODE q SQLCODE
	s SQLCODE=##class(web.DHCEQ.EM.BUSCostAllot).CreateCostAllot(3,RowID)		//写入设备分摊信息
    /// modified by ZY 20220926 2757106
    i SQLCODE q SQLCODE
    s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","22",RowID,1)
	q SQLCODE
}

ClassMethod InsertChangeStock(RowID, User)
{
	new (RowID, User)
	q:RowID=""
	s Date=+$H
	s Flag=0
	s FromLoc=$P(^DHCEQStoreMove(RowID),"^",2)
	s ToLoc=$P(^DHCEQStoreMove(RowID),"^",3)
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(Flag'=0)  d
	.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
	.i BatchFlag="Y" d
	..s RowIDs=$G(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	..s equipRowIDs=RowIDs
	.e  d
	..s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	..s equipRowIDs=EquipDR
	.s count=$l(equipRowIDs,",")
	.f k=1:1:count d
	..q:Flag'=0
	..s EquipDR=$p(equipRowIDs,",",k)
	..i EquipDR'=""  d
	...s CSPL(2)=EquipDR
	...s CSPL(3)=FromLoc
	...s CSPL(4)=ToLoc
	...s CSPL(5)=SMLRowID
	...s CSPL(6)="1"
	...s CSPL(7)=Date
	...s CSPL(8)=User
	...s CSPL(9)=Date
	...s CSPL(10)=Date
	...s SQLCODE=0
	...&SQL(Insert into sqluser.DHC_EQChangeStock values :CSPL())
	...i SQLCODE s Flag=SQLCODE
	q Flag
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:写设备的生命周期信息
/// w ##Class(web.DHCEQStoreMoveNew).InsertEQLifeInfo("117")
/// ----------------------------------
ClassMethod InsertEQLifeInfo(RowID, User)
{
	new (RowID, User)
	q:RowID=""
	s Date=+$H
	s Time=$P($H,",",2)
	s Flag=0
	s FromLoc=$P(^DHCEQStoreMove(RowID),"^",2)		;供给部门
	s ToLoc=$P(^DHCEQStoreMove(RowID),"^",3)		;接收部门
	s MoveType=$P(^DHCEQStoreMove(RowID),"^",12)	;转移类型
	s Status=$P(^DHCEQStoreMove(RowID),"^",13)		;状态
	
	s LI(16)=Date				//变动日期
	s LI(17)=Time				//变动时间
 	s LI(19)="C"				//生命周期类型
 	s LI(20)=22					//来源类型
 	s LI(22)=MoveType			//来源辅助类型
 	s LI(27)=User				//更新人
 	s LI(28)=Date				//更新日期
 	s LI(29)=Time				//更新时间
	
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(Flag'=0)  d
	.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
	.i BatchFlag="Y" d
	..s RowIDs=$G(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	..s equipRowIDs=RowIDs
	.e  d
	..s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	..s equipRowIDs=EquipDR
	.s Remark=$P(^DHCEQStoreMoveList(SMLRowID),"^",11)
	.s LocationDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",12)
	.s count=$l(equipRowIDs,",")
	.f k=1:1:count d
	..q:Flag'=0
	..s EquipDR=$p(equipRowIDs,",",k)
	..i EquipDR'=""  d
	...s LI(2)=EquipDR
	...s LI(4)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   	//原使用科室 
	...s LI(5)=$p($g(^DHCEQEquip(EquipDR)),"^",17)  	//原管理科室
	...s LI(6)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  	//原库房
	...s LI(7)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  	//原值
	...s LI(8)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  	//原净值
	...;2011-08-10 DJ begin
	...i +LI(7)'=+$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7) s Flag=-1300		//"["_$p($g(^DHCEQEquip(EquipDR)),"^",1)_"]原值有发生变化,不可批量处理!"
	...q:Flag'=0
	...s Flag=##Class(web.DHCEQ.EM.BUSStoreMove).UpdateEquip(MoveType,RowID,EquipDR,User,Remark,LocationDR)
	...q:Flag'=0
	...s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)  	//变动后使用科室 
 	...s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) 	//变动后管理科室
 	...s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  	//变动后库房
 	...s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  	//变动后原值
 	...s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  	//变动后净值 
 	...s LI(21)=SMLRowID 								//来源ID
 	...s LI(23)=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",11) //备注
 	...&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	...i SQLCODE s Flag=SQLCODE
	q Flag
}

ClassMethod UpdateEquip(MoveType, RowID, EquipDR, User, Remark, LocationDR)
{
	n (MoveType,RowID,EquipDR,User,Remark,LocationDR)	
	k EQPL
	//'0:首次出库自动更新启用日期(启用日期为空时) 1:每次出库皆自动更新启用日期'
	s updateSDateFlag=##class(web.DHCEQCommon).GetSysInfo("302011") 
	s ToLoc=$p($g(^DHCEQStoreMove(RowID)),"^",3)
	s MoveType =$p($g(^DHCEQStoreMove(RowID)),"^",12)
	s EQName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	s EQInvalidFlag=$p($g(^DHCEQEquip(EquipDR)),"^",59)
	i EQInvalidFlag="Y"  q EQName_"["_EQNo_"]设备已无效!"
	s EQStockStatus=$p($g(^DHCEQEquip(EquipDR)),"^",60)
	s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	i (EQStockStatus'="1")||(EQStatus=3)  q EQName_"["_EQNo_"]库房状态不符合条件!"
	s FromLoc=$p($g(^DHCEQStoreMove(RowID)),"^",2)
	s EQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	i FromLoc'=EQStoreLocDR  q EQName_"["_EQNo_"]所在库房不是供给部门!"
	s EQPL(20)=ToLoc		;使用科室
	i MoveType="0" s EQPL(39)=1			;设备状态	0:新增|1:启用|2:封存|3:报废|4:其他
	//设备状态为0:在库|1:启用|2:停用|3:报废|4:其他
	i MoveType="3" s EQPL(39)=0

	i MoveType="4" k EQPL(20)
	//转移类型为出库时才更新启用日期
	if (MoveType="0")||(MoveType="1")
	{
		s EQPL(104)=+$H		//领用日期
		if updateSDateFlag=1
		{
			s EQPL(45)=+$H		;启用日期
		}
		else
		{
			i $p($g(^DHCEQEquip(EquipDR)),"^",44)="" s EQPL(45)=+$H		;启用日期
		}
	}
	s EQPL(56)=User  			;更新人
	s EQPL(57)=+$H  				;更新日期
	s EQPL(58)=$P($H,",",2)  	;更新时间
	s EQPL(61)=1  		;0:新增|1:入库|2:转移出库|3:出库
	s EQPL(68)=ToLoc		;库房
	;i Remark'="" s EQPL(35)=Remark
	i LocationDR'="" s EQPL(73)=LocationDR
	i MoveType=3  d
	.s EQPL(73)=""
	.s EQPL(20)=""
	&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR)
 	q SQLCODE
}

ClassMethod StatCatIsUnique(RowID, StatCatID)
{
	new (RowID, StatCatID)
	s diffrentFlag=0
	s noStatCatFlag=0
	s ReturnType=1
	s ListStatCatID=""
	s StatID=""
	s SMLRowID=0
	f  s SMLRowID=$O(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID)) q:(SMLRowID="")||(diffrentFlag=1)||(noStatCatFlag=1)  d
	.q:$P(^DHCEQStoreMoveList(SMLRowID),"^",15)'=""		;Mozy	2019-4-30	过滤附属设备
	.s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	.i EquipDR="" d
	..s InStockListDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",4)
	..i InStockListDR'="" s StatCat=$P(^DHCEQInStockList(InStockListDR),"^",17)
	.e  d
	..s StatCat=$P(^DHCEQEquip(EquipDR),"^",75)
	.i StatCat="" s noStatCatFlag=1
	.i ListStatCatID="" s ListStatCatID=StatCat
	.i StatCat'=ListStatCatID s diffrentFlag=1

	q:diffrentFlag=1 -1001
	q:noStatCatFlag=1 -1004
	q:(ListStatCatID'=StatCatID)&&(StatCatID'="") -1002
	
	q ListStatCatID
}

/// Modify By zx 2020-02-20 BUG ZX0076 增加动作处理
/// w ##class(web.DHCEQ.EM.BUSStoreMove).AuditData("2^202^1^0^^^2^11^1^^30^5100^同意^","20","1","DHC_EQStoreMove&^,173","")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo, ActionCode As %String = "")
{
	new (val,CurRole,RoleStep,editFieldsInfo,%session,ActionCode)
	n RowID,User,Date
	n ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	
	Set $ZT="ERRORAudit"
	k PLIST
	s RowID=$P(val,"^",1)
	s User=$P(val,"^",9)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Opinion=$P(val,"^",13)		//czf 2021-06-17 保存审批意见
	s RejectReason=$P(val,"^",14)
	
	s Date=+$H
	s Time=$p($h,",",2)			//czf 2021-06-24
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("14", RowID)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-4007,"审批设置不存在!")	
	
	//Modify By zx 2020-02-20 BUG ZX0076 传动作时 根据动作获取角色和步骤
	i ActionCode'="" d
	.s RoleInfo=##class(web.DHCEQCApproveSet).GetRoleByAction(ApproveSet,ActionCode)
	.s CurRole=$p(RoleInfo,"^",1)
	.s RoleStep=$p(RoleInfo,"^",2)
	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	
	TSTART	
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQStoreMove(RowID)),"^",13)=2)
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1010,"当前单据已审核!")
		}
		s AppInfoStatus="2"
		
		s Date=+$H
		s PLIST(10)=User
		s PLIST(11)=Date
		s PLIST(12)=Time		//czf 20210624
		s PLIST(14)="2"
		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,RejectReason,CurRole,RoleStep,User)		//czf 2021-06-17 保存审批意见
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	} 
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
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
	if Actions'=""
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	i NextStep="" s SQLCODE=##Class(web.DHCEQ.EM.BUSStoreMove).LastStepAction(RowID,User)
	i SQLCODE'=0
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9200,SQLCODE)	//modified by ZY0229 20200511
	}
	
	s AuditFlag=0
	i NextStep="" s AuditFlag=1
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("22", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)

ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)     //返回错误消息 ;
}

ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole,%session)
	Set $ZT="ERRORCancel"
	k PLIST
	s RowID=$P(val,"^",1)
	s User=$P(val,"^",9)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s CancelToFlowDR=$P(val,"^",10)
	s ApproveSet=$P(val,"^",11)
	s Opinion=$P(val,"^",13)		//czf 2021-06-17 保存审批意见
	s RejectReason=$P(val,"^",14)
	
	s Date=+$H
	s PLIST(5) = User	;MakerDR
 	s PLIST(6) = Date
 	s PLIST(14) = "0"
 	
 	s ApproveRoleDR=""
 	s Step=""
 	s Status="0"
	TSTART
	if (CancelToFlowDR'="")
	{
		s PLIST(14)="1"
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
	 	s Status="1"
	}
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("14", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,Opinion,RejectReason,CurRole,RoleStep,User,"1")		//czf 2021-06-17 保存审批意见
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
	&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("22", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
		
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)     //返回错误消息 ;
}

ClassMethod GetSMInfoByISL(EquipDR, InStockListDR, MoveType, CurFromLocDR As %String = "", User As %String = "")
{
	n FromLocDR,ToLocDR,EquipTypeDR,StatCatDR
	s Result=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i (InStockListDR="ZY")||(InStockListDR=0) //单台信息
	{
		s FromLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
		s ToLocDR=""
		;重新获取入库单的申购科室
		If $Piece($Get(^DHCEQEquip(EquipDR)),"^",70)'=""
		{
			Set InStockDR=$Piece($Get(^DHCEQInStockList($Piece($Get(^DHCEQEquip(EquipDR)),"^",70))),"^",1)
			Set ToLocDR=$Piece($Get(^DHCEQInStock(InStockDR)),"^",18)
		}
		s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
		s StatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	}
	else //批量信息
	{
		s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
		s FromLocDR=$p($g(^DHCEQInStock(InStockDR)),"^",2)
		s ToLocDR=$p($g(^DHCEQInStock(InStockDR)),"^",18)
		s EquipTypeDR=$p($g(^DHCEQInStock(InStockDR)),"^",20)
		s StatCatDR=$p($g(^DHCEQInStock(InStockDR)),"^",21)
		i ((MoveType'=0)&&(MoveType'=4)) s FromLocDR=CurFromLocDR
	}
	i MoveType'=0 s ToLocDR=""
	d Result.%Set("SMFromLocDR",FromLocDR)
	d Result.%Set("SMToLocDR",ToLocDR)
	d Result.%Set("SMMoveType",MoveType)
	d Result.%Set("SMEquipTypeDR",EquipTypeDR)
	d Result.%Set("SMStatCatDR",StatCatDR)
	d Result.%Set("SMMakerDR",User)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Result)
}

ClassMethod JudgeSMLQuantityNum(SMRowID, Job, DataList)
{
	new (SMRowID, Job, DataList)
	i SMRowID="" q -1
	i DataList="" q 0
	s Flag=0
	s StoreLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)		;StoreLocDR
	s MoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)		;MoveType
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-22 分割标志替换
	s Length=$l(DataList,SplitRowCode)
	for k=1:1:Length
	{
		q:Flag'=0
		s valList=$p(DataList,SplitRowCode,k)   //add by zx 2019-07-22
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s index=JsonData.SMLIndex //index处理
		s SMLRowID= JsonData.SMLRowID //SMLRowID
		s InStockListDR=JsonData.SMLInStockListDR
		i JsonData.SMLEquipDR'=""
		{
			if SMLRowID=""  //新增明细
			{
				s ^TEMPEQ("MXList","EX",Job,index)=JsonData.SMLEquipDR
			}
			else
			{
				s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=JsonData.SMLEquipDR
				k ^TEMPEQ("MXList",Job,SMLRowID)
			}
			continue //单台设备不处理
		}
		s QuantityNum=JsonData.SMLQuantityNum
 		s RowIDs=""
		s Len=0
 		if SMLRowID=""  //新增明细
 		{
 			s RowIDs=$g(^TEMPEQ("MXList","EX",Job,index))
 		}
 		else
 		{
	 		s RowIDs=$g(^TEMPEQ("MXList",Job,SMLRowID))
 			i ((RowIDs="")&&(InStockListDR=$p(^DHCEQStoreMoveList(SMLRowID),"^",4))) s RowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	 	}
	 	if RowIDs'="" s Len=$l(RowIDs,",")
	 	if (Len'=QuantityNum)
	 	{
			s Flag=##Class(web.DHCEQUpdateEquipsByList).GetRowIDsByQuantityNum(InStockListDR,QuantityNum,SMLRowID,StoreLocDR,Job,index,"1")
		}
		else
		{
			if (SMLRowID'="")&&($Data(^TEMPEQ("MXList",Job,SMLRowID)))
			{
				s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$g(^TEMPEQ("MXList",Job,SMLRowID))
				k ^TEMPEQ("MXList",Job,SMLRowID)
			}
		}
	}
	q Flag
}

ClassMethod DeleteStoreMoveList(SMRowID, DelRowid)
{
	new Length,SMLRowID,Flag,i
	s Flag=0
	i SMRowID="" q -1
	i DelRowid="" q 0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s SMLRowID=$p(DelRowid,",",i)
		if (SMLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQStoreMoveList where SML_RowID=:SMLRowID)
			i SQLCODE s Flag=SMLRowID_"^更新操作失败"
            ///modified by ZY 20220926 2757106
            s ListEquip=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
            s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"22",SMRowID,1)
            i SQLCODE s Flag=SMLRowID_"^记录业务占用信息失败!"
 			k ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")
		}
	}
	q Flag
}

ClassMethod SaveStoreMoveList(SMRowID, Job, DataList)
{
	new (SMRowID, Job, DataList)
	i SMRowID="" q -1
	i DataList="" q 0
	s SMLRowIDs=""
	s Flag=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-22 分割标志替换
	s Length=$l(DataList,SplitRowCode)
	for k=1:1:Length
	{
		q:Flag'=0
		s valList=$p(DataList,SplitRowCode,k)  //add by zx 2019-07-22
		q:valList=""
		k PLIST,SMLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQStoreMoveList",JsonData,.PLIST)
		s PLIST(2)=SMRowID
		s SMLRowID=JsonData.SMLRowID
		s index=JsonData.SMLIndex //index处理
		if (SMLRowID="")
		{
			&SQL(insert into SQLUSER.DHC_EQStoreMoveList Values :PLIST())
			s SMLRowID=$G(%ROWID)
 			if (JsonData.SMLEquipDR="")
 			{
	 			s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$g(^TEMPEQ("MXList","EX",Job,index))
	 		}
	 		else
	 		{
		 		s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=JsonData.SMLEquipDR
	 		}
	 		k ^TEMPEQ("MXList","EX",Job,index)
		}
		else
		{
			&SQL(Update SQLUSER.DHC_EQStoreMoveList Values :PLIST() where SML_RowID = :SMLRowID)
		}
		if SMLRowIDs'="" s SMLRowIDs=SMLRowIDs_","
		s SMLRowIDs=SMLRowIDs_SMLRowID
		
		s ListEquip=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		s ListCount=$L(ListEquip,",")
		for j=1:1:ListCount
		{
			q:Flag'=0
			s EquipID=$p(ListEquip,",",j)			
			s EQOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
			i +EQOriginalFee'=+JsonData.SMLOriginalFee
			{
				s Flag=index_"^设备原值已发生变动,不可批量处理!设备编号:"_$p($g(^DHCEQEquip(EquipID)),"^",71)   /// Modefied by zc0051 2019-10-24  修改资产原值改动转移提示信息不对
            }
            ///modified by ZY 20221107   BugNo=2129677
            q:Flag'=0
            /* czf 2023-02-27 czf 附属设备台账名称与入库明细不一致
            s EQName=$p($g(^DHCEQEquip(EquipID)),"^",1)
            i EQName'=JsonData.SMLEquipName
            {
                s Flag=index_"^设备名称与台账记录的名称不一致,不可保存!设备编号:"_$p($g(^DHCEQEquip(EquipID)),"^",71)
			}
			*/
		}
		i SQLCODE s Flag=index_"^更新明细记录失败!"
        ///modified by ZY 20220926 2757106
        q:Flag'=0
        s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"22",SMRowID,0)
        
        i SQLCODE s Flag=index_"^记录业务占用信息失败!"
	}
	;Mozy	765433	2018-12-12	删除未传入的转移单明细记录
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) quit:(SMLRowID="")||(SQLCODE'=0)  d
    .i (","_SMLRowIDs_",")'[(","_SMLRowID_",")  d
    ..&SQL(delete from SQLUSER.DHC_EQStoreMoveList where SML_RowID = :SMLRowID)
    ..q:SQLCODE'=0
    ..s ListEquip=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
    ..s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"22",SMRowID,1)
    i SQLCODE s Flag=index_"^删除未传入的转移单明细记录失败!"
	q Flag
}

ClassMethod CheckStoreMoveLoc(RowID)
{
	n (RowID)
	s MoveType=$p($g(^DHCEQStoreMove(RowID)),"^",12)
	s FromLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",2)
	s ToLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",3)
	i FromLocDR="" q "供给部门未保存,请先更新数据"
	i ToLocDR="" q "接收部门未保存,请先更新数据"
	i FromLocDR=ToLocDR q "供给部门与接收部门相同!"
	s FromLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FromLocDR)
	s ToLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ToLocDR)
	i ((MoveType="0")||(MoveType="4")) //库房分配
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0101",FromLocDR)
		i Flag'=0 q "供给部门不是库房"
	}
	else
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0102",FromLocDR)
		i Flag'=0 q "供给部门不是科室"
	}
	i ((MoveType="3")||(MoveType="4")) //科室退库
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0101",ToLocDR)
		i Flag'=0 q "接收部门不是库房"
	}
	else
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0102",ToLocDR)
		i Flag'=0 q "接收部门不是科室"
	}
	s CheckFlag=##class(web.DHCEQCommon).GetSysInfo("990012")
	i (CheckFlag="")||(CheckFlag=0) q ""
	//判断当前库房管理科室
	i MoveType="0"
	{
		s Flag=$D( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",ToLocDR,FromLocDR))
		i Flag=0 q ToLocDesc_"不在"_FromLocDesc_"管理范围内"
	}
	i MoveType="1" //判断科室调配时供给部门与接收部门是否属于同一库房
	{
		s FromStore=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",FromLocDR,0))
		i FromStore="" q "库房管理科室中未设置供给部门的所属管理库房"
		s ToStore=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",ToLocDR,0))
		i ToStore="" q "库房管理科室中未设置接收部门的所属管理库房"
		i FromStore'=ToStore q FromLocDesc_" 和 "_ToLocDesc_"不在同一库房管理下"
	}
	i MoveType="3"
	{
		s Flag=$D( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",FromLocDR,ToLocDR))
		i Flag=0 q FromLocDesc_"不在"_ToLocDesc_"管理范围内"
	}
	q ""
}

/// Mozy  765433	2018-12-12
/// 描述:根据来源生成其设备配置的转移单明细
/// 入参： SourceType：		0:入库单明细ID		1:设备DR
/// 			OCLRowid:验收明细ID
/// w ##Class(web.DHCEQ.EM.BUSStoreMove).GetSMLForConfig(0, 707, 571)
/// w ##Class(web.DHCEQ.EM.BUSStoreMove).GetSMLForConfig(1, 45459, 571)
ClassMethod GetSMLForConfig(SourceType As %String = "", SourceID As %String = "", FromLocDR As %String = "", index As %String = "0")
{
	i (SourceType="")||(SourceID="") q ""
	
	//valList=&index+"^^"+EquipDR+"^"+InStockListDR+"^"+TName+"^"+TManuFactoryDR+"^"+TOriginalFee+"^"+TQuantity+"^"+TModelDR+"^"+TUnitDR+"^^"+TLocationDR+"^^^^^^"+TCommonName
	n valList, OCLRowid, ConfigDRs, ConfigDR, Length, i, ISRowID, tmpISLRowID, StoreLocDR, RowIDs, tmpEquipID, Hold13
	s valList=""
	s Num=index		;序号计数器
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") //add by zx 2019-07-22
	i SourceType=0
	{
		i $p($g(^DHCEQInStockList(SourceID)),"^",18)'=2 q 0		;过滤非来自验收明细的入库记录
		i $p($g(^DHCEQInStockList(SourceID)),"^",22)'="" q 0	;设备配置的入库明细不需要再次生成转移明细记录
		s OCLRowid=$p($g(^DHCEQInStockList(SourceID)),"^",19)
		i OCLRowid="" q 0
		s ConfigDRs=##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1, OCLRowid)
		i ConfigDRs="" q 0
		s ISRowID=$p($g(^DHCEQInStockList(SourceID)),"^",1)
		s Length=$l(ConfigDRs,",")
		
		for i=1:1:Length
		{
			s ConfigDR=	$p(ConfigDRs,",",i)
			Set tmpISLRowID=0
			For  Set tmpISLRowID=$Order(^DHCEQInStockList(0,"InStock",ISRowID,tmpISLRowID)) Quit:(tmpISLRowID="")  Do
			.Quit:$p($g(^DHCEQInStockList(tmpISLRowID)),"^",22)'=ConfigDR
			.
			.;拼设备ID串存储临时节点
			.Set RowIDs=""
			.Set StoreLocDR=""
			.For  Set StoreLocDR=$Order(^DHCEQEquip(0,"InStockList",tmpISLRowID,StoreLocDR)) Quit:(StoreLocDR="")  Do
			..Quit:(FromLocDR'="")&&(StoreLocDR'=FromLocDR)
			..Set tmpEquipID=0
			..For  Set tmpEquipID=$Order(^DHCEQEquip(0,"InStockList",tmpISLRowID,StoreLocDR,tmpEquipID)) Quit:(tmpEquipID="")  Do
			...Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="3")||($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="4")
			...Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",59)'="N")
			...Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(tmpEquipID)),"^",63))
			...
			...;查看设备是不是已经存在其他的转移单
			...Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("",tmpEquipID,StoreLocDR,1)'=0
			...If RowIDs'="" Set RowIDs=RowIDs_","
			...Set RowIDs=RowIDs_tmpEquipID
			.Quit:RowIDs=""
			.
			.s Num=Num+1
			.i valList'="" s valList=valList_SplitRowCode
			.s valList=valList_Num_"^^^"_tmpISLRowID_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", $Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",16))
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",6)	;;SML_TManuFactoryDR
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",7)	;;SML_TOriginalFee
			.s valList=valList_"^"_$l(RowIDs,",")	;$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;SML_TQuantityNum
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",9)	;;SML_TModelDR
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",10)	;;SML_TUnitDR
			.s valList=valList_"^^"
			.If ($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",18)=2) s valList=valList_$Piece($Get(^DHCEQOpenCheckList($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",19))),"^",26)  	;LocationDR
			.s valList=valList_"^^^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",22)
			.s valList=valList_"^^^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",5)
			.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",9))
			.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",6))
			.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",10))
			.s valList=valList_"^"
			.If ($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",18)=2) s valList=valList_##Class(web.DHCEQCommon).GetTrakNameByID("location",$Piece($Get(^DHCEQOpenCheckList($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",19))),"^",26))
		}
	}
	elseif SourceType=1
	{
		/*
		Set Hold13=0
		For  Set Hold13=$Order(^DHCEQEquip(0,"Hold13",Hold13)) Quit:(Hold13="")  Do
		.Set tmpEquipID=0
		.For  Set tmpEquipID=$Order(^DHCEQEquip(0,"Hold13",Hold13,tmpEquipID)) Quit:(tmpEquipID="")  Do
		..Quit:$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",24)'=SourceID		; EQHold11		过滤主设备
		..Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="3")||($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="4")
		..Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",59)'="N")
		..Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(tmpEquipID)),"^",63))
		..
		..Set StoreLocDR=$p($g(^DHCEQEquip(tmpEquipID)),"^",67)
		..Quit:(StoreLocDR'=FromLocDR)
		..;查看设备是不是已经存在其他的转移单
		..Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("",tmpEquipID,StoreLocDR,1)'=0
		..
		..Set RowIDs=tmpEquipID
		..s Num=Num+1
		..i valList'="" s valList=valList_SplitRowCode
		..s valList=valList_Num_"^^"_tmpEquipID_"^^"_##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", $Piece($Get(^DHCEQEquip(tmpEquipID)),"^",7))
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26)	;;SML_TManuFactoryDR
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",27)	;;SML_TOriginalFee
		..s valList=valList_"^"_$l(RowIDs,",")	;$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;SML_TQuantityNum
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3)	;;SML_TModelDR
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5)	;;SML_TUnitDR
		..s valList=valList_"^^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",72) ;LocationDR
		..s valList=valList_"^^^"_$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",26)		;ConfigDR
		..s valList=valList_"^^^(附)"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",1)
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3))
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26))
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5))
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("location",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",72))
		*/
		Set tmpEquipID=0
		For  Set tmpEquipID=$Order(^DHCEQEquip(0,"Parent",SourceID,tmpEquipID)) Quit:(tmpEquipID="")  Do
		.Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="3")||($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="4")
		.Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",59)'="N")
		.Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(tmpEquipID)),"^",63))
		.
		.Set StoreLocDR=$p($g(^DHCEQEquip(tmpEquipID)),"^",67)
		.Quit:(StoreLocDR'=FromLocDR)
		.;查看设备是不是已经存在其他的转移单
		.Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("",tmpEquipID,StoreLocDR,1)'=0
		.
		.Set RowIDs=tmpEquipID
		.s Num=Num+1
		.i valList'="" s valList=valList_SplitRowCode
		.s valList=valList_Num_"^^"_tmpEquipID_"^^"_##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", $Piece($Get(^DHCEQEquip(tmpEquipID)),"^",7))
		.s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26)	;;SML_TManuFactoryDR
		.s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",27)	;;SML_TOriginalFee
		.s valList=valList_"^"_$l(RowIDs,",")	;$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;SML_TQuantityNum
		.s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3)	;;SML_TModelDR
		.s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5)	;;SML_TUnitDR
		.s valList=valList_"^^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",72) ;LocationDR
		.s valList=valList_"^^^"_$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",26)		;ConfigDR
		.s valList=valList_"^^^(附)"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",1)
		.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3))
		.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26))
		.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5))
		.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("location",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",72))

	}
	
	Quit valList
}

/// add by lmm 2019-08-30 994942
/// 描述:检测未保存转移主单与明细类组是否一致
/// 入参:SMEquipTypeDR 主单类组 EquipDR 明细设备id InStockListDR 明细入库明细ID
/// w ##class(web.DHCEQ.EM.BUSStoreMove).CheckStoreMoveEquipType("3","173","")
ClassMethod CheckStoreMoveEquipType(SMEquipTypeDR, EquipDR, InStockListDR)
{
	i (EquipDR="")&&(InStockListDR="") q -1
	new SMLEquipTypeDR,InStockDR
 	if (InStockListDR'="")
 	{
	 	s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	 	s SMLEquipTypeDR=$p($g(^DHCEQInStock(InStockDR)),"^",20)
	 	s IsConfig="N"
		s ConfigDR=$Piece($Get(^DHCEQInStockList(InStockListDR)),"^",22)
		i ConfigDR'="" s IsConfig="Y"
		i IsConfig="Y" q 0		//czf 2023-02-27 begin
	}
	else
	{
	 	s SMLEquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	 	s IsConfig="N"
	 	s ConfigDR=$Piece($Get(^DHCEQEquip(EquipDR,"OtherInfo")),"^",26)				; EQHold13
		i ConfigDR'="" s IsConfig="Y"
	 	i IsConfig="Y" q 0		//czf 2023-02-27 end 
	}
	if (SMEquipTypeDR'=SMLEquipTypeDR)
	{
		q -1
		
	} 
	q 0
}

/// add by csj 2020-02-11 标准版-扫码调拨
/// w ##class(web.DHCEQ.EM.BUSStoreMove).CreateStoreMoveByID(306,30,1,1,1,"扫码调拨")
ClassMethod CreateStoreMoveByID(EQID As %String, FromLocDR As %String, ToLocDR As %String, ReciverDR As %String = "", UserID As %String = "", Remark As %String = "")
{
	i EQID="" quit "-1^设备ID不能为空"
	s EQInfo = $g(^DHCEQEquip(EQID))	
	Kill PLISTSM,PLISTSML
	;主表
	Set PLISTSM(3) = $p(EQInfo,"^",19)	;FromLocDR
	i PLISTSM(3)'= FromLocDR	q "-2^登录科室与供给科室不一致！"
	Set PLISTSM(4) = ToLocDR		;ToLocDR
	Set PLISTSM(5) = UserID			;MakerDR
	Set PLISTSM(6) = +$H			;MakeDate
	Set PLISTSM(13) = "1"			;MoveType
	Set PLISTSM(14) = "0"			;Status
	Set PLISTSM(15) = Remark		;Remark
	Set PLISTSM(17) = $p(EQInfo,"^",63)	;EquipTypeDR
	Set PLISTSM(18) = $p(EQInfo,"^",75)	;StatCatDR
	Set PLISTSM(28) = "N"
	Set MoveTypeCode=##Class(web.DHCEQStoreMoveNew).GetMoveTypeCode(1)
	Set PLISTSM(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,PLISTSM(3),PLISTSM(17),"","",MoveTypeCode)
	TStart
	&SQL(insert into sqluser.DHC_EQStoreMove values :PLISTSM())
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	Set SMRowID=$Get(%ROWID)
	;明细表
	Set PLISTSML(2)=SMRowID
	Set PLISTSML(3)=EQID	
	Set PLISTSML(4)="N"				;SML_BatchFlag
	;Set PLISTSML(5)=$p(EQInfo,"^",70)  		;SML_InStockListDR
	Set PLISTSML(6)=$p(EQInfo,"^",1) 		;SML_Equip
	Set PLISTSML(7)=$p(EQInfo,"^",26)   	;SML_TManuFactoryDR
	Set PLISTSML(8)=$p(EQInfo,"^",27)   	;SML_TOriginalFee
	Set PLISTSML(9)="1"  	;SML_TQuantityNum
	Set PLISTSML(10)=$p(EQInfo,"^",3)  	;SML_TModelDR
	Set PLISTSML(11)=$p(EQInfo,"^",5)   	;SML_TUnitDR
	Set PLISTSML(13)=$p(EQInfo,"^",72)   	;LocationDR
	&SQL(Insert Into SQLUSER.DHC_EQStoreMoveList Values :PLISTSML())
	Set SMLRowID=$Get(%ROWID)
	;拼设备DI串存储临时节点
#;	Set RowIDs=""
#;	Set tmpEquipID=0
#;	For  Set tmpEquipID=$Order(^DHCEQEquip(0,"InStockList",PLISTSML(5),$p(^DHCEQInStock($p(^DHCEQInStockList(PLISTSML(5)),"^",1)),"^",2),tmpEquipID)) Quit:(tmpEquipID="")  Do
#;	.If RowIDs'="" Set RowIDs=RowIDs_","
#;	.Set RowIDs=RowIDs_tmpEquipID
	Set ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=EQID
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	;检查是否设备已经被其他单据占用
 	s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(1,SMRowID)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
	;提交自动生成的出库单
	Set val=SMRowID_"^^^^^^^^"_UserID
	Set SMRowID = ##Class(web.DHCEQStoreMoveNew).SubmitData(val)
	If SMRowID<0
	{
		TROLLBACK
		Quit SMRowID
	}
	TCOMMIT
	q 0
}

/// modified by ZY 20220928
/// add by ZY0220 2020-04-14
/// 台账批量调科
/// 逻辑：按照同一类组生成一张转移单的规则生成新增状态的转移单。单据信息记录在临时golable中
/// 入参：SMFromLocDR：调出科室，默认取EquipIDs第一个设备的科室;
/// 		  SMToLocDR:调入科室，取界面填写科室
/// 		  EquipIDs：设备ID串'1,2,3,4'
/// 		  MoveType：默认为1，转科
/// 出参：返回SMRowIDs. 生成的转移单ID拼串返回。
ClassMethod BatchStockMove(SMFromLocDR, SMToLocDR, EquipIDs, MoveType As %String = "1")
{
	new Job,User,Date,Time,ErrorMess,Len,EquipDR,Str,SQLCODE
	new EQStatus,EquipTypeDR,StoreLocDR,EQNo,SMRowIDs,SplitRowCode
    Set $ZT="ERRORBatchSave"
	s Job=$j
    k ^TempDHCEQ("BatchStockMoveEquipIDs",Job)
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s ErrorMess=""
	s MoveType=""
	
	//czf 2021-06-25 begin
	i SMFromLocDR="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"供给科室不能为空!")
	i SMToLocDR="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"接收科室不能为空!")
	s FromHospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(SMFromLocDR)
	s ToHospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(SMToLocDR)
	i FromHospDR="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"供给科室所在院区不能为空!")
	i ToHospDR="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"接收科室所在院区不能为空!")
	//czf 2021-06-25 end
		
	//判断供给科室科室类型
	s LGTKFTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
	s LGTLocTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0102",0))
	// MZY0153	3244591		2023-02-20	修正Global名称
	s FromKFLTID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTKFTypeID,SMFromLocDR,""))
	s FromLOCLTID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTLocTypeID,SMFromLocDR,""))
	//判断接收科室类型
	s ToKFLTID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTKFTypeID,SMToLocDR,""))
	s ToLOCLTID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTLocTypeID,SMToLocDR,""))
	i FromKFLTID'=""
	{
		i ToKFLTID'="" s MoveType=4		//库房调配
		i ToLOCLTID'="" s MoveType=0	//库房分配
	}
	elseif FromLOCLTID'=""
	{
		i ToKFLTID'="" s MoveType=3		//科室退库
		i ToLOCLTID'="" s MoveType=1	//科室调拨
	}
	i MoveType="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"科室类型有误!")
	s Len=$l(EquipIDs,",")
 	f i=1:1:Len 
 	{
	 	q:ErrorMess'=""
	 	s EquipDR=$p(EquipIDs,",",i)
	 	s Str=##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("","",EquipDR,"","","Y")
	 	i $p(Str,"^",1)=1 s ErrorMess=$p(Str,"^",2)
	 	q:$p(Str,"^",1)=1
	 	s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	 	s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	 	s StoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	 	s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	 	i SMFromLocDR'=StoreLocDR  s ErrorMess="设备编号"_EQNo_"使用科室是"_##Class(web.DHCEQCommon).getMapIDBySource("deptname",StoreLocDR)_",不在转出科室."
	 	q:ErrorMess'=""
	 	i (EQStatus'=1)&&(EQStatus'=2)&&(MoveType'=0) s ErrorMess="设备编号"_EQNo_"状态不是'启用'"
	 	q:ErrorMess'=""
	 	
        s ^TempDHCEQ("BatchStockMoveEquipIDs",Job,"EquipList",EquipTypeDR,EquipDR)=""
	}
	if ErrorMess'=""
	{
        k ^TempDHCEQ("BatchStockMoveEquipIDs",Job)
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMess)
	}else
	{
		TSTART
		s SMRowIDs=""
		k PLIST,PLISTMX
		s SQLCODE=0
		s MoveTypeCode=##Class(web.DHCEQStoreMoveNew).GetMoveTypeCode(MoveType)
		s EquipTypeDR=0
        f  s EquipTypeDR=$o(^TempDHCEQ("BatchStockMoveEquipIDs",Job,"EquipList",EquipTypeDR))  q:(EquipTypeDR="")||(SQLCODE'=0)  d
		.s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",Date,"",EquipTypeDR,"","",MoveTypeCode)
		.s PLIST(3) = SMFromLocDR	;FromLocDR
		.s PLIST(4) = SMToLocDR	;ToLocDR
		.s PLIST(5) = User			;MakerDR
		.s PLIST(6) = Date			;MakeDate
		.s PLIST(13) = MoveType	;MoveType
		.s PLIST(14) = "0"			;Status
		.s PLIST(15) = "台账批量转移"	;Remark
		.s PLIST(16) = ""	;ReciverDR
		.s PLIST(17) = EquipTypeDR	;EquipTypeDR
		.s PLIST(18) = "" ;StatCatDR
		.s PLIST(28) = "N"
		.i FromHospDR=ToHospDR s PLIST(22) = 1		//czf 2021-06-25
		.e  s PLIST(22) = 2
		.&SQL(insert into sqluser.DHC_EQStoreMove values :PLIST())
		.s SMRowID=$G(%ROWID)
		.q:SQLCODE'=0
		.s PLISTMX(2)=SMRowID
		.s EquipDR=""
        .f  s EquipDR=$o(^TempDHCEQ("BatchStockMoveEquipIDs",Job,"EquipList",EquipTypeDR,EquipDR)) q:(EquipDR="")||(SQLCODE'=0)  d
		..s EquipData=$g(^DHCEQEquip(EquipDR))
		..s PLISTMX(3)=EquipDR	;SML_EquipDR
		..s PLISTMX(4)=""		;SML_BatchFlag
		..s PLISTMX(5)=""		;SML_InStockListDR
		..s PLISTMX(6)=$p(EquipData,"^",1)		;SML_Equip
		..s PLISTMX(7)=$p(EquipData,"^",26)		;SML_TManuFactoryDR
		..s PLISTMX(8)=$p(EquipData,"^",27)		;SML_TOriginalFee
		..s PLISTMX(9)=1		;SML_TQuantityNum
		..s PLISTMX(10)=$p(EquipData,"^",3)		;SML_TModelDR
		..s PLISTMX(11)=$p(EquipData,"^",5)		;SML_TUnitDR
		..s PLISTMX(12)=""		;SML_TRemark
		..s PLISTMX(13)=$p(EquipData,"^",72)		;LocationDR
		..s PLISTMX(14)=""		;Hold1
		..s PLISTMX(15)=""		;Hold2
		..s PLISTMX(16)=""		;Hold3
		..s PLISTMX(17)=""		;Hold4
		..s PLISTMX(18)=""		;Hold5
		..&SQL(Insert Into SQLUSER.DHC_EQStoreMoveList Values :PLISTMX())
		..s SMLRowID=$G(%ROWID)
		..s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=EquipDR
		.i SMRowIDs="" d
		..s SMRowIDs=SMRowID
		.e  d
		..s SMRowIDs=SMRowIDs_SplitRowCode_SMRowID
	 	i SQLCODE
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 	}
	 	TCOMMIT
        k ^TempDHCEQ("BatchStockMoveEquipIDs",Job)
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,SMRowIDs)
    }
ERRORBatchSave
    	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// add by ZY0220 2020-04-14
/// 批量转移单明细
/// 逻辑：根据Job取临时golable中的转移单
/// 入参：转移明细ID串。
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSStoreMove","GetBatchStockMove","")
Query GetBatchStockMove(SMRowIDs As %String = "") As %Query(ROWSPEC = "SMRowID:%String,SMStoreMoveNo:%String,SMEquipType:%String")
{
}

ClassMethod GetBatchStockMoveExecute(ByRef qHandle As %Binary, SMRowIDs As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i SMRowIDs="" Quit $$$OK
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s Len=$l(SMRowIDs,SplitRowCode)
 	f i=1:1:Len d
 	.s SMRowID=$p(SMRowIDs,SplitRowCode,i)
	.s SMStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	.s SMEquipType=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
	.s SMEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", SMEquipType)
	.d OutputRowGetBatchStockMove
	
	Quit $$$OK
OutputRowGetBatchStockMove
	Set Data=$lb(SMRowID,SMStoreMoveNo,SMEquipType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBatchStockMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBatchStockMoveExecute ]
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

ClassMethod GetBatchStockMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBatchStockMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// MZY0100	2288153,2288189		2021-11-18
/// w ##Class(web.DHCEQ.EM.BUSStoreMove).GetEQIDs(228,2)
ClassMethod GetEQIDs(FromLocDR, InStockListID, StockStatus As %String = "1")
{
	n str,EquipTypeDR,EQRowID
	s str=""
	i (FromLocDR="")||(InStockListID="") q str
	
	s EquipTypeDR=0
	f  s EquipTypeDR=$O(^DHCEQEquip(0,"StoreInStock",FromLocDR,EquipTypeDR)) q:EquipTypeDR=""  d
	.s EQRowID=0
	.f  s EQRowID=$O(^DHCEQEquip(0,"StoreInStock",FromLocDR,EquipTypeDR,StockStatus,"N",InStockListID,EQRowID)) q:EQRowID=""  d
	..i str'="" s str=str_","
	..s str=str_EQRowID
	q str
}

/// add by ZY 2844708 20220810
/// 根据入库单明细取验收单是否填写使用科室
/// w ##Class(web.DHCEQ.EM.BUSStoreMove).GetOpenCheckUseLoc(11)
ClassMethod GetOpenCheckUseLoc(inStockList)
{
	new SourceType,SourceID,OpenCheckUseLocDR
	s OpenCheckUseLocDR=""
	//"0":"设备","1":"设备项","2":"验收单"
	s SourceType=$p($g(^DHCEQInStockList(inStockList)),"^",18)
	if (SourceType=2)
	{
		s SourceID=$p($g(^DHCEQInStockList(inStockList)),"^",19)
		s OpenCheckUseLocDR=$p(^DHCEQOpenCheckList(SourceID),"^",33)
	}
	q OpenCheckUseLocDR
}

/// Modefied by zc0131 2023-03-07 退库设备标记
/// 根据设备id判断设备是否退库过
/// w ##Class(web.DHCEQ.EM.BUSStoreMove).CheckEquipReturnStock(163)
ClassMethod CheckEquipReturnStock(vEquipID)
{
	s vRFlag=0
	i (vEquipID="") q vRFlag
	i '$d(^DHCEQChangeStock(0,"Equip",vEquipID)) q vRFlag
	s CSRowID=0
	f  s CSRowID=$O(^DHCEQChangeStock(0,"Equip",vEquipID,CSRowID)) q:(CSRowID="")||(vRFlag'=0)  d
	.q:$p($g(^DHCEQChangeStock(CSRowID)),"^",5)'=1
	.s StoreMoveListID=$p($g(^DHCEQChangeStock(CSRowID)),"^",4)
	.q:$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",1)=""
	.s StoreMoveID=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",1)
	.q:$p($g(^DHCEQStoreMove(StoreMoveID)),"^",27)="Y"
	.q:$p($g(^DHCEQStoreMove(StoreMoveID)),"^",12)'=3
	.s vRFlag=1
	q vRFlag
}

}
