Import SQLUser

/// 名称: web.DHCEQ.MP.BUSReduce
/// 描述: 配件退货和减少业务		Maintenance Parts	Mozy0236
/// 创建人：Mozy
/// 编写日期: 2019-11-29
/// 产品组：设备管理
Class web.DHCEQ.MP.BUSReduce Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 退货业务明细
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSReduce","GetAReduceList",5)
Query GetAReduceList(RowID As %String = "") As %Query(ROWSPEC = "ARLRowID:%String,ARLReduceDR:%String,ARLItemDR:%String,ARLBaseUOMDR:%String,ARLStockDetailDR:%String,ARLManuFactoryDR:%String,ARLHold1:%String,ARLHold2:%String,TJob:%String,ARLCode:%String,ARLDesc:%String,ARLModel:%String,ARLBaseUOMDR_UOMDesc:%String,ARLManuFactoryDR_MDesc:%String,ARLPrice:%String,ARLQuantityNum:%String,ARLAmount:%String,ARLRemark:%String,ARLHold1_RRDesc:%String,ARLSerialFlag:%String,ARLBatchFlag:%String,ARLSerialNo:%String,ARLAInStockNo:%String,ARLInvoiceNos:%String,ARLHold3:%String,ARLHold4:%String,ARLHold5:%String,ARLFundsType:%String")
{
}

ClassMethod GetAReduceListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	;new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("web.DHCEQ.MP.BUSReduce.GetAReduceList")=RowID
	s index=1
	s Job=$J
	s (TotalQty,Amount)=0
	if (RowID="")
	{
		d ResetVariablesGetAReduceList
		s TJob=Job
		d OutputRowGetAReduceList
	}
	else
	{
		s rowid=0
		f  s rowid=$o(^DHCEQAReduceList(0,"Reduce",RowID,rowid)) q:rowid=""  d
		.d ResetVariablesGetAReduceList
		.s TAccessoryDR=$p(^DHCEQAReduceList(rowid),"^",2)
		.i TAccessoryDR'="" s TAccessory=$p(^DHCEQCCode("DHCEQCAccessory",TAccessoryDR),"^",2)
		.s ARLModel=$p(^DHCEQAReduceList(rowid),"^",3)
		.s ARLBaseUOMDR=$p(^DHCEQAReduceList(rowid),"^",4)
		.s UOMDesc=##class(web.DHCEQCommon).GetTrakNameByID("uom",ARLBaseUOMDR)
		.s TManuFactoryDR=$p(^DHCEQAReduceList(rowid),"^",6)
		.s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		.s TReturnQtyNum=$p(^DHCEQAReduceList(rowid),"^",10)
		.s TotalQty=TotalQty+TReturnQtyNum                   ///总退货量
		.s TReturnFee=$p(^DHCEQAReduceList(rowid),"^",9)
		.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TReturnQtyNum*TReturnFee,"",2)
		.s Amount=Amount+TTotalFee                           ///总退货费用
		.s TReturnReasonDR=$p(^DHCEQAReduceList(rowid),"^",13)  ///退货原因（Hold1）
		.i TReturnReasonDR'="" s TReturnReason=$p(^DHCEQCCode("DHCEQCReturnReason",TReturnReasonDR),"^",2)
		.s TAInStockListDR=$p(^DHCEQAReduceList(rowid),"^",14)  //入库明细ID(Hold2)
		.i TAInStockListDR'="" d
		..s TAInStockDR=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",1)
		..s TInStockNo=$p($g(^DHCEQAInStock(TAInStockDR)),"^",6)
		..s TInvoiceNos=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",19)
		.s TRemark=$p(^DHCEQAReduceList(rowid),"^",12)
		.s TStockDetailDR=$p($g(^DHCEQAReduceList(rowid)),"^",5)
		.s ARLFundsType=$p($g(^DHCEQAStockDetail(TStockDetailDR)),"^",30)
		.i ARLFundsType'="" s ARLFundsType=$Piece($Get(^DHCEQCCode("DHCEQCFundsType",ARLFundsType)),"^",2)
		.s TRowID=rowid
		.s TJob=Job
		.; //输出标志位
		.s TBatchFlag=$p(^DHCEQAReduceList(rowid),"^",7)
		.s TSerialFlag=$p(^DHCEQAReduceList(rowid),"^",8)
		.i (TSerialFlag="Y") d
		.s ARLSerialNo=$p($g(^DHCEQAStockDetail(TStockDetailDR)),"^",9)
		.i TReturnQtyNum>1  d
		..s TFlag=1
		.e  d
		..s TFlag=0
		.d OutputRowGetAReduceList
	}
	Quit $$$OK
ResetVariablesGetAReduceList
	Set (TRowID,ARLReduceDR,TAccessoryDR,ARLBaseUOMDR,TStockDetailDR,TManuFactoryDR,TReturnReasonDR,TAInStockListDR,TJob,ARLCode,TAccessory,ARLModel,UOMDesc,TManuFactory,TReturnFee,TReturnQtyNum,TTotalFee,TRemark,TReturnReason,TSerialFlag,TBatchFlag,ARLSerialNo,TInStockNo,TInvoiceNos,ARLHold3,ARLHold4,ARLHold5,ARLFundsType)=""
   	quit
OutputRowGetAReduceList
	Set Data=$lb(TRowID,ARLReduceDR,TAccessoryDR,ARLBaseUOMDR,TStockDetailDR,TManuFactoryDR,TReturnReasonDR,TAInStockListDR,TJob,ARLCode,TAccessory,ARLModel,UOMDesc,TManuFactory,TReturnFee,TReturnQtyNum,TTotalFee,TRemark,TReturnReason,TSerialFlag,TBatchFlag,ARLSerialNo,TInStockNo,TInvoiceNos,ARLHold3,ARLHold4,ARLHold5,ARLFundsType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetAReduceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAReduceListExecute ]
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

ClassMethod GetAReduceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAReduceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 减少类型列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSReduce","GetReduceType")
Query GetReduceType() As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetReduceTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	;s ID=1
	;s TDesc="退货"
	;d OutputRowGetInType
	s ID=2
	s TDesc="报损"
	d OutputRowGetReduceType
	s ID=3
	s TDesc="消耗"
	d OutputRowGetReduceType
	s ID=4
	s TDesc="盘亏"
	d OutputRowGetReduceType
	s ID=9
	s TDesc="其他"
	d OutputRowGetReduceType

	Quit $$$OK
OutputRowGetReduceType
	Set Data=$lb(ID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetReduceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReduceTypeExecute ]
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

ClassMethod GetReduceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReduceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 退货原因
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSReduce","ReasonList")
Query ReasonList(Desc As %Library.String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod ReasonListExecute(ByRef qHandle As %Binary, Desc As %Library.String = "") As %Status
{
 	;new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCReturnReason",rowid)) q:rowid=""  d
	.s TRowID=rowid
	.s TName=$p(^DHCEQCCode("DHCEQCReturnReason",TRowID),"^",2)
	.s TCode=$p(^DHCEQCCode("DHCEQCReturnReason",TRowID),"^",1)
	.q:$p(^DHCEQCCode("DHCEQCReturnReason",TRowID),"^",4)'="N"
	.q:(Desc'="")&&(TName'[Desc)
	.d OutputRowGetReasonList
	Quit $$$OK
OutputRowGetReasonList
	Set Data=$lb(TName,TRowID,TCode)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ReasonListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReasonListExecute ]
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

ClassMethod ReasonListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReasonListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 配件退货减少业务单数据填充取值
/// w ##Class(web.DHCEQ.MP.BUSReduce).GetOneAReduce(42)
ClassMethod GetOneAReduce(RowID As %Library.String = "", ApproveRoleDR As %Library.String = "")
{
	s $ZT="ERRORGetOneAReduce"
	s ObjAReduce=##Class(User.DHCEQAReduce).%OpenId(RowID)
	s AReduceInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjAReduce)
	
	d AReduceInfo.%Set("ARAccessoryTypeDR_ATDesc",ObjAReduce.ARAccessoryTypeDR.ATDesc)
	d AReduceInfo.%Set("ARReduceType_Desc",$CASE(ObjAReduce.ARReduceType,"1":"退货","2":"报损","3":"消耗","4":"盘亏","9":"其他","":""))	// Mozy0239		2019-12-17
	d AReduceInfo.%Set("ARLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjAReduce.ARLocDR))
	d AReduceInfo.%Set("ARProviderDR_VDesc",ObjAReduce.ARProviderDR.VName)
	;d AReduceInfo.%Set("ARMakerDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjAReduce.ARMakerDR))
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("21",RowID,ApproveRoleDR)
	d AReduceInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d AReduceInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d AReduceInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d AReduceInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d AReduceInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d AReduceInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d AReduceInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d AReduceInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d AReduceInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d AReduceInfo.%Set("NextRole",$p(AppInfo,"^",10))
	
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,AReduceInfo)
ERRORGetOneAReduce
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// Flag :批量选项
/// MXRowID  转移明细或退货明细RowID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSReduce","GetAStockDetail","",327,44,"","")
Query GetAStockDetail(ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, MXRowID As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TLocDR:%String,TAccessoryTypeDR:%String,TItemDR:%String,TAInStockListDR:%String,TBaseUOMDR:%String,TManuFactoryDR:%String,TProviderDR:%String,TStockDR:%String,TInType:%String,TInSourceID:%String,TToType:%String,TToSourceID:%String,TOriginDR:%String,TDesc:%String,TCode:%String,TLoc:%String,TAccessoryType:%String,TModel:%String,TBprice:%String,TManuFactory:%String,TProvider:%String,TStock:%String,CanUseNum:%String,FreezeNum:%String,TInStockNo:%String,TInDate:%String,TStatus:%String,THasStockFlag:%String,TItem:%String,TBatchNo:%String,TExpiryDate:%String,TSerialNo:%String,TNo:%String,TBaseUOM:%String,TFreezeStock:%String,TStartDate:%String,TDisuseDate:%String,TOrigin:%String,TReturnFee:%String,TTotalFee:%String,TBatchFlag:%String,TBillPage:%String,TInvoiceNos:%String,TSerialFlag:%String,TFundsType:%String")
{
}

ClassMethod GetAStockDetailExecute(ByRef qHandle As %Binary, ASDRowID, LocDR, AccessoryTypeDR, Desc, Flag, vMXRowID As %String = "", ProviderDR As %String = "") As %Status
{
	;new repid, index,rowid,TAStockListDR,TStockSum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("web.DHCEQ.MP.BUSReduce")=ASDRowID_","_LocDR_","_AccessoryTypeDR_","_Desc_","_Flag_","_vMXRowID_","_ProviderDR
 	
	s index=1
	s rowid=0
	s TAStockListDR=0
	s TStockSum=0
	s FreezeNumSum=0
	S Desc=$ZCONVERT(Desc,"U")
	i LocDR="" Set LocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0302")	;默认取配件第一个仓库
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
		    ...q:(TStatus'=0)&&(TStatus'=1)		;转移
		    ...s TStockSum=$p($g(^DHCEQAStockDetail(rowid)),"^",17)
		    ...q:(TStockSum=0)
		    ...s TStock=TStock+TStockSum
		    ...s FreezeNum=##class(web.DHCEQ.MP.BUSReduce).CheckAccessoryDR(rowid,LocDR,vMXRowID,1)      ///被占用的数量
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
	q:##class(web.DHCEQCommon).FundsTypeIsIn(12,TRowID)	// 访问资金来源类型
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
	i TManuFactoryDR '="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer", TManuFactoryDR)	// MZY0027	1326222		2020-05-21
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
	s FreezeNum=##class(web.DHCEQ.MP.BUSStoreMove).CheckAccessoryDR(TRowID,LocDR,vMXRowID,1)      ///被占用的数量
	q:(TStock=0)
	s CanUseNum=TStock-FreezeNum                 ///可退数量 
	q:CanUseNum<1 
	
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
	s TFundsType=$p($g(^DHCEQAStockDetail(TRowID)),"^",30)
	i TFundsType'="" s TFundsType=$Piece($Get(^DHCEQCCode("DHCEQCFundsType",TFundsType)),"^",2)	//Mozy0231	配件资金
	d OutputRowGetAStockDetail

	quit
OutputRowGetAStockDetail
	Set TStock=##Class(web.DHCEQCommon).FormatNumber(TStock,"",2)
	Set CanUseNum=##Class(web.DHCEQCommon).FormatNumber(CanUseNum,"",2)
	Set FreezeNum=##Class(web.DHCEQCommon).FormatNumber(FreezeNum,"",2)
	Set Data=$lb(TRowID,TLocDR,TAccessoryTypeDR,TItemDR,TAInStockListDR,TBaseUOMDR,TManuFactoryDR,TProviderDR,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TDesc,TCode,TLoc,TAccessoryType,TModel,TBprice,TManuFactory,TProvider,TStock,CanUseNum,FreezeNum,TInStockNo,TInDate,TStatus,THasStockFlag,TItem,TBatchNo,TExpiryDate,TSerialNo,TNo,TBaseUOM,TFreezeStock,TStartDate,TDisuseDate,TOrigin,TReturnFee,TTotalFee,TBatchFlag,TBillPage,TInvoiceNos,TSerialFlag,TFundsType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAStockDetail
	Set (TRowID,TDesc,TCode,TLocDR,TLoc,TAccessoryTypeDR,TAccessoryType,TStatus,THasStockFlag,TItemDR,TItem,TBatchNo,TExpiryDate,TBprice,TSerialNo,TNo,TBaseUOMDR,TBaseUOM,TManuFactoryDR,TManuFactory,TModel,TProviderDR,TProvider,TStock,TFreezeStock,TStartDate,TDisuseDate,TStockDR,TInType,TInSourceID,TToType,TToSourceID,TOriginDR,TOrigin,FreezeNum,CanUseNum,TReturnFee,TTotalFee,TAInStockDR,TInStockNo,TInDate,TBatchFlag,TBillPage,TInvoiceNos,TSerialFlag,TFundsType)=""      
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

/// 更新插入数据、删除数据
///  d ##Class(web.DHCEQ.MP.BUSReduce).SaveData("1^1^114^1^20/11/2012^luosi^^1^2764","1^1^^1^3^100^1^hao^^^^^","")
ClassMethod SaveData(val, valList, DelRowID)
{
	;new RowID,PLIST
	Set $ZT="ERRORSave"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	k PLIST
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAReduce",JsonData,.PLIST)
	s RowID = JsonData.ARRowID
 	s Job = JsonData.ARJob
	s PLIST(10)=$P($H,",",2)    //MakeTime
	s PLIST(24)="0"            	//Status
	
	TSTART
	if RowID=""
	{
		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAReduce",+$H,PLIST(5),PLIST(3))
		&SQL(Insert into SQLUSER.DHC_EQAReduce values :PLIST())
		s RowID=$G(%ROWID)
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQAReduce values :PLIST() where AR_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单记录失败")
		}
	}
	s SQLCODE=##CLASS(web.DHCEQ.MP.BUSReduce).JudgeRLQuantityNum(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "明细记录数据不正确")
 	}
	s SQLCODE=##Class(web.DHCEQ.MP.BUSReduce).SaveAReduceList(RowID,valList,Job)
	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "保存明细记录失败")
 	}
 
 	s SQLCODE=##Class(web.DHCEQ.MP.BUSReduce).CheckOrder(RowID)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "配件被占用,保存明细记录失败")
 	}
	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:判断按序列号转移的配件数量与选择的RowIDs是否一致QW0006-2014-08-21
/// w ##Class(web.DHCEQ.MP.BUSReduce).JudgeAMSLQuantityNum("13","2780","1^^1^PJLZ^配件1^^41^1^false^true^50^1^50^^34^^^^")
ClassMethod JudgeRLQuantityNum(ARRowID, Job, val)
{
	;new (AMSRowID, Job, val)
	i ARRowID="" q -9001
	i val="" q 0
	Set Flag=0
	Set StoreLocDR=$p($g(^DHCEQAReduce(ARRowID)),"^",4)		;StoreLocDR
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$l(val,SplitRowCode)
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=$p(val,SplitRowCode,i)
		
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s index=JsonData.ARLIndex //index处理
		s ARLRowID=JsonData.ARLRowID
		s StockDetailDR=JsonData.ARLStockDetailDR
		s QuantityNum=+JsonData.ARLQuantityNum
		i (JsonData.ARLSerialFlag'="Y") continue //过滤掉不是按序列号管理的配件
		
		; 序列号管理
		if (QuantityNum=1)
		{			
			if ARLRowID=""  //新增明细
			{
				s ^TEMPEQ("AMXList","EX",Job,index)=StockDetailDR
			}
			else
			{
				s ^DHCEQAReduceList(ARLRowID,"EX","RowIDs")=StockDetailDR
				k ^TEMPEQ("AMXList",Job,ARLRowID)
			}		
			//continue //单台设备不处理
		}
		else
		{
 			s RowIDs=""
			s Len=0
 			if ARLRowID=""  //新增明细
 			{
	 			s RowIDs=$g(^TEMPEQ("AMXList","EX",Job,index))
 			}
 			else
 			{
			 	s RowIDs=$g(^TEMPEQ("AMXList",Job,ARLRowID))
	 			; 当InStockListDR相同时,才取原来的rowids
 				i (RowIDs="") s RowIDs=$g(^DHCEQAReduceList(ARLRowID,"EX","RowIDs"))
	 		}
	 		if RowIDs'="" s Len=$l(RowIDs,",")
	 		if (Len'=QuantityNum)
	 		{
				 s Flag=##Class(web.DHCEQUpdateAccessoryByList).GetRowIDsByQuantityNum(StockDetailDR,QuantityNum,ARLRowID,StoreLocDR,Job,index,"0") //movetype=0为退货
				 i Flag'=0 s Flag=-7405
			}
			else
			{
				if (ARLRowID'="")&&($Data(^TEMPEQ("AMXList",Job,ARLRowID)))
				{
					s ^DHCEQAReduceList(ARLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList",Job,ARLRowID))
					k ^TEMPEQ("AMXList",Job,ARLRowID)
				}
			}
		}
	}
	q Flag
}

/// 修正Flag标识	 MZY0067	1699986		2021-01-20
/// 更新插入退货明细业务表
/// 参数：ARRowID:退货单rowid
///        val:明细串
/// w ##Class(web.DHCEQ.MP.BUSReduce).SaveAReduceList(14,"",1144)
ClassMethod SaveAReduceList(ARRowID, val, Job)
{
	;new Length,RLRowID,Flag,valList
	i (ARRowID="")||(val="") q -9001
	s SQLCODE=0
	s ARLRowIDs=""
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$l(val,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(val,SplitRowCode,i)
		q:valList=""
		k PLISTMX,ARLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLISTMX=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAReduceList",JsonData,.PLISTMX)
		s ARLRowID = JsonData.ARLRowID
		s PLISTMX(2)=ARRowID
		s index=JsonData.ARLIndex 		//index处理
		s PLISTMX(8)="Y"  ;BatchFlag
		i PLISTMX(9)="" s PLISTMX(9)="N"
		i PLISTMX(9)="Y" s PLISTMX(8)="N"
		;;;;;s PLISTMX(12)=PLISTMX(10)*PLISTMX(11) ;ARL_Amount
		s SQLCODE=##CLASS(web.DHCEQ.MP.BUSReduce).AccessoryTypeIsUnique(ARRowID,PLISTMX(6))
		i SQLCODE 
		{
			//明细与总单的类组不相同,更新明细记录失败!
			q
		}
		
		if (ARLRowID="")
		{			
			&SQL(Insert Into SQLUSER.DHC_EQAReduceList Values :PLISTMX())
			i SQLCODE 
			{
				;s Flag=index_"^更新明细记录失败!"
				q
			}
			s ARLRowID=$G(%ROWID)
			if (PLISTMX(9)="Y")  //序列号管理
			{
				i $d(^TEMPEQ("AMXList","EX",Job,index))
				{
					s ^DHCEQAReduceList(ARLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList","EX",Job,index))
					//k ^TEMPEQ("AMXList","EX",Job,index) 
				}
				else
				{
					s ^DHCEQAReduceList(ARLRowID,"EX","RowIDs")=$g(^TEMPEQ("AMXList","EX",Job,ARLRowID))
				}
				k ^TEMPEQ("AMXList","EX",Job,index)		// MZY0067	1699986		2021-01-20
			}
		}
		else
		{
			&SQL(update sqluser.DHC_EQAReduceList values :PLISTMX() where ARL_RowID=:ARLRowID)
		}
		// MZY0067	1699986		2021-01-20
		i SQLCODE'=0 q 	;Flag=index_"^更新明细记录失败!!"
		if ARLRowIDs'="" s ARLRowIDs=ARLRowIDs_","
		s ARLRowIDs=ARLRowIDs_ARLRowID		;有效的明细ID
	}
	i SQLCODE'=0 q SQLCODE
	; 删除未处理的退货减少明细
	// MZY0057	1477698		2020-10-09	修正索引
	s ARLRowID=0
	f  s ARLRowID=$o(^DHCEQAReduceList(0,"Reduce",ARRowID,ARLRowID)) quit:(ARLRowID="")||(SQLCODE'=0)  d
	.i (","_ARLRowIDs_",")'[(","_ARLRowID_",") &SQL(delete from SQLUSER.DHC_EQAReduceList where ARL_RowID = :ARLRowID)
	
	q SQLCODE
}

/// 检查明细与总单的类组是否相同
ClassMethod AccessoryTypeIsUnique(ARRowID, ASDRowID)
{
	if ($p($g(^DHCEQAReduce(ARRowID)),"^",2)'=$p($g(^DHCEQAStockDetail(ASDRowID)),"^",11)) q -7403
	q 0
}

/// w ##Class(web.DHCEQ.MP.BUSReduce).DeleteData()
ClassMethod DeleteData(RowID)
{
	Set $ZT="ERRORDelete"
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	s SQLCODE=0
	&SQL(Update SQLUSER.DHC_EQAReduce Set AR_Status='3' where AR_RowID=:RowID)
	i SQLCODE Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "删除主单记录失败")
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORDelete 
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 检查单据数据是否有效,配件是否已经被其他单据占用
/// 参数:SourceID:对应业务单据ID
/// w ##Class(web.DHCEQ.MP.BUSStoreMove).CheckOrder(56)
ClassMethod CheckOrder(SourceID)
{
	;n ListID,AccessoryID,Len,i,Flag,FromLocDR,Index
	i SourceID="" q -7403
	s Flag=0
	s FromLocDR=$p($g(^DHCEQAReduce(SourceID)),"^",4)
	
	///检查是否已被退货减少单占用
	s ListID=0
	f  s ListID=$o(^DHCEQAReduceList(0,"Reduce",SourceID,ListID)) quit:(ListID="")||(Flag'=0)  d
	.s AStockDetailDR = $p($g(^DHCEQAReduceList(ListID)),"^",5)
	.s FreezeNum=##class(web.DHCEQ.MP.BUSStoreMove).CheckAccessoryDR(AStockDetailDR,FromLocDR,ListID,1)
	.i ((FreezeNum+$p($g(^DHCEQAReduceList(ListID)),"^",10))>$p($g(^DHCEQAStockDetail(AStockDetailDR)),"^",17)) s Flag=-7406	;配件库存数量不足(占用)
	
	q Flag
}

/// 描述:提交转移单
/// w ##Class(web.DHCEQ.MP.BUSReduce).SubmitData(40)
ClassMethod SubmitData(RowID)
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	i $p($g(^DHCEQAReduce(RowID)),"^",23)="3" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)
	
	Set $ZT="ERRORSubmit"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
  	k PLIST
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAReduce(RowID)),"^",23) //状态
	if Status'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	s AccessoryTypeDR=$p($g(^DHCEQAReduce(RowID)),"^",2)
	s PLIST(13) = User 	
 	s PLIST(14) = Date
 	s PLIST(15) = Time
	s PLIST(24) = "1"	

	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("21")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, AccessoryTypeDR, "", "", "","","")
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
		s PLIST(16)=User
		s PLIST(17)=Date
		s PLIST(18)=Time
		s PLIST(24)="2"
		s AppInfoStatus="2"
	}
	
	TSTART
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"21",User)
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
	&SQL(update sqluser.DHC_EQAReduce values :PLIST() where AR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//最终审核调用
	i NextStep=""
	{
		s SQLCODE=##Class(web.DHCEQ.MP.BUSReduce).LastAuditAction(RowID,User)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")
		}
	}
	s BussType="A04"
	i $p($g(^DHCEQAReduce(RowID)),"^",3)=1 s BussType="A03"
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(BussType, RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
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

/// 描述:取消提交
/// w ##Class(web.DHCEQ.MP.BUSReduce).CancelSubmitData(42,2,"")
ClassMethod CancelSubmitData(RowID, CurRole, CancelToFlowDR)
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	Set $ZT="ERRORCancel"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAReduce(RowID)),"^",23) //状态
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	k PLIST
	;s PLIST(21) = $P(val,"^",12)	//ARRejectReason
	s PLIST(20) = User 				//ARRejectUserDR
 	s PLIST(21) = +$H				//ARRejectDate
 	s PLIST(22) = $p($H,",",2)		//ARRejectTime
 	s ApproveRoleDR=""
 	s Step=""
 	s Status="0"
	if (CancelToFlowDR'="")
	{
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	s PLIST(24)=Status
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("21")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("21", RowID)
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
	&SQL(update sqluser.DHC_EQAReduce values :PLIST() where AR_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单失败")
	}
	s ApproveFlow=""
	i CancelToFlowDR'="" s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	s BussType="A04"
	i $p($g(^DHCEQAReduce(RowID)),"^",3)=1 s BussType="A03"
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(BussType, RowID, User, ApproveFlow, "Y", CurRole)
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

/// 审核功能
/// w ##Class(web.DHCEQ.MP.BUSReduce).AuditData(42,1796,2,1)
ClassMethod AuditData(RowID, CurRole, RoleStep, EditFieldsInfo As %String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单
	//new RowID,Date,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions,ReduceType
	Set $ZT="ERRORAudit"
	s (ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions)=""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	k PLIST
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAReduce(RowID)),"^",23) //状态
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("21")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("21", RowID)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9021)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"		;Status	
	s AuditFlag=0		//是否最后一步	0:否		1:是
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ("2"=$p($g(^DHCEQAReduce(RowID)),"^",23)) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002, "单据状态错误")
		s AuditFlag=1
		s AppInfoStatus="2"
	}
	TSTART
	//生成审批的记录
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
	i EditFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(EditFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//做定义要做的操作
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,EditFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")
		}
	}
	;最后一步需要调用审核方法 
	i AuditFlag=1
	{
		s SQLCODE=##Class(web.DHCEQ.MP.BUSReduce).LastAuditAction(RowID,User)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")
		}
	}
	s BussType="A04"
	i $p($g(^DHCEQAReduce(RowID)),"^",3)=1 s BussType="A03"
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo(BussType, RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole, AuditFlag)
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

/// w ##Class(web.DHCEQ.MP.BUSReduce).LastAuditAction()
ClassMethod LastAuditAction(RowID, User)
{
	;new RLRowID,SQLCODE
	i RowID="" q ""
	k PLIST
	s PLIST(16)=User
	s PLIST(17)=+$H
	s PLIST(18)=$p($H,",",2)
	s PLIST(24)="2"
	;改变库存量
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQAReduceList(0,"Reduce",RowID,RLRowID)) q:RLRowID=""  d
	.s QtyNum=$p($g(^DHCEQAReduceList(RLRowID)),"^",10)
	.s StockDetailDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",5)
	.s ReduceDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",1)
	.s ReduceType=$p($g(^DHCEQAReduce(ReduceDR)),"^",3)
	.s StockDetailNum=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",17)
	.s Num=StockDetailNum-QtyNum  ///库存明细中未被占用的库存量
	.s SQLCODE=##Class(web.DHCEQ.MP.BUSReduce).CheckNum(Num,QtyNum,ReduceType,RLRowID)	;更新配件库存明细信息
	i $p($g(^DHCEQAReduce(RowID)),"^",23)=2 q -7406
	&SQL(update sqluser.DHC_EQAReduce values:PLIST() where AR_RowID=:RowID)
	i SQLCODE q SQLCODE
	q SQLCODE
}

/// 增加退掉的配件明细	Mozy0242	1157259		2020-01-02
/// 更新配件库存明细信息
/// 参数：
/// 		Stock为该明细中没有被其他单据占据的库存量
/// 		ReduceNum为审核的退货数量
/// 		ReduceType减少类型
/// 		RLRowID退货减少明细
/// d ##Class(web.DHCEQ.MP.BUSReduce).CheckNum("3","1","3",5)
ClassMethod CheckNum(Stock, ReduceNum, ReduceType, RLRowID)
{
	k PLISTMIX
	s SQLCODE=0
	s StockDetailDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",5)
	s PLISTMIX(13)=2	//Status
	i ReduceType=1 s PLISTMIX(13)=3
	i $p($g(^DHCEQAReduceList(RLRowID)),"^",8)="Y"   //序列号管理 直接修改状态
	{
		s RLRowIDs=^DHCEQAReduceList(RLRowID,"EX","RowIDs")
		s count=$l(RLRowIDs,",")
		f i=1:1:count q:SQLCODE  d
		.s RowIDs=$p(RLRowIDs,",",i)
		.&SQL(update sqluser.DHC_EQAStockDetail values :PLISTMIX() where ASD_RowID=:RowIDs)
	}
	else
	{
		//批号管理则需在明细加上一条退库明细
		s PLISTMIX(2)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",1)  //LocDR
		s PLISTMIX(3)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",2)  //AccessoryDR
		s PLISTMIX(4)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",3)  //AInStockListDR
		s PLISTMIX(5)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",4)  //code
		s PLISTMIX(6)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",5)  //desc
		s PLISTMIX(7)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",6)  //batchno
		s PLISTMIX(8)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",7) //expirydate
		s PLISTMIX(9)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",8)  //Price
		s PLISTMIX(10)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",9)  //seriano
		s PLISTMIX(11)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",10)  //no
		s PLISTMIX(12)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",11)  //AccessoryTypeDR
		s PLISTMIX(14)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",13)  //baseUOMDR
		s PLISTMIX(15)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",14)  //ManuFactory
		s PLISTMIX(16)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",15)  //Model
		s PLISTMIX(17)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",16)  //provider
		s PLISTMIX(18)=ReduceNum //Stock
		s PLISTMIX(19)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",18)  //FreezeStock
		s PLISTMIX(20)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",19)  //StartDate
		s PLISTMIX(21)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",20)  //DisuseDate
		s PLISTMIX(22)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",21)  //StockDR
		s PLISTMIX(23)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",22)  //InType
		s PLISTMIX(24)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",23)  //InSourceID
		s PLISTMIX(25)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",24)  //ToType
		s PLISTMIX(26)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",25)  //ToSourceI
		s PLISTMIX(27)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",26)  //HasStockFlag
		s PLISTMIX(28)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",27)  //OriginDR	
		/// Mozy0248	1194267		2020-02-18
		s PLISTMIX(29)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",28)	//Location
		s PLISTMIX(30)=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",29)	//BillPage
		&SQL(update sqluser.DHC_EQAStockDetail set ASD_Stock=:Stock where ASD_RowID=:StockDetailDR )
		i SQLCODE q SQLCODE
		&SQL(insert into sqluser.DHC_EQAStockDetail values :PLISTMIX())
	}
	i SQLCODE q SQLCODE
	;更新有效的库存数
	s StockDR=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",21)
	s StockNum=$p($g(^DHCEQAStock(StockDR)),"^",10)
	s ReturnNum=StockNum-ReduceNum
	&SQl(update sqluser.DHC_EQAStock set AS_Stock=:ReturnNum where AS_RowID=:StockDR)
	
	q SQLCODE
}

}
