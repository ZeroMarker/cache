Class web.DHCEQ.EM.BUSInStock Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY 20220927  修改global
/// modified by ZY0245 2020-22-25  增加的ManageLocDR参数错误
/// modified by ZY0241 2020-09-07  增加合同的判断
/// 数据输出前排序，把未做入库的数据显示在前面
/// 修改:Mozy 2012-02-21  Mozy0076
/// 描述:调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:根据条件选取验收单
/// Modified By QW20200220 BEGIN BUG号:QW0038 资金来源 OCLFundsStr
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInStock","GetOpenCheckList","","","","","","")
Query GetOpenCheckList(EquipTypeDR As %String = "", StatCatDR As %String = "", ProviderDR As %String = "", OriginDR As %String = "", Equip As %String = "", QXType As %String = "", ManageLocDR As %String = "", ContractNo As %String = "") As %Query(ROWSPEC = "OCRRowID:%String, OCLRowID:%String, OCLName:%String, ISStatus:%String, ISNo:%String, OCLEquipType:%String, OCLStatCat:%String, OCLVendor:%String, OCLModel:%String,OCLPrice:%String,OCLRequestLoc:%String,OCLCommonName:%String,OCLFundsStr:%String,OCLContractNo:%String")
{
}

ClassMethod GetOpenCheckListExecute(ByRef qHandle As %Binary, EquipTypeDR As %String = "", StatCatDR As %String = "", ProviderDR As %String = "", OriginDR As %String = "", Equip As %String = "", QXType As %String = "", ManageLocDR As %String = "", ContractNo As %String = "") As %Status
{
	//new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Job=$j
	
	s Equip=$ZCONVERT(Equip,"U")
	s ContractNo=$ZCONVERT(ContractNo,"U")
    s ContractFlag=##class(web.DHCEQCommon).GetSysInfo("301011")
	s vEquipTypeDR=0
	f  s vEquipTypeDR=$o(^DHCEQOpenCheckRequest(0,"Status",0,vEquipTypeDR)) q:vEquipTypeDR=""  d
	.q:((EquipTypeDR'="")&&(vEquipTypeDR'=EquipTypeDR))
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(vEquipTypeDR)'="0"   //add by zx 2019-07-24
	.s rowid=0
	.f  s rowid=$o(^DHCEQOpenCheckRequest(0,"Status",0,vEquipTypeDR,2,rowid)) q:rowid=""  d
	..;Modified By JDL 2011-10-12 JDL0098 过滤掉已经删除的验收单
	..q:($p($g(^DHCEQOpenCheckRequest(rowid)),"^",45)="Y")
	..q:##class(web.DHCEQCommon).FundsTypeIsIn(0,rowid)	
	..s OCRHospID=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",38)	//czf 2021-09-01 begin
	..q:##class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(OCRHospID,QXType) //czf 2021-09-01 end
	..s TStatCatDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",4) 				//设备类型DR
    ..;q:((StatCatDR'="")&&(StatCatDR'=TStatCatDR))		//czf 2022-10-12 2827541 默认不限制同一类型
	..s TProviderDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",5)				//供应商DR
	..q:((ProviderDR'="")&&(ProviderDR'=TProviderDR))
	..s TOriginDR=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",8)				//来源DR
	..q:((OriginDR'="")&&(OriginDR'=TOriginDR))
	..s OCLRowid=+$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
	..q:OCLRowid<1
	..q:##class(web.DHCEQCommon).FundsTypeIsIn(0,OCLRowid)'=0  //Modify by zx 2020-09-04 根据明细表过滤
	..s CommonName=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",2)		//CommonName 2013-06-24 DJ0118 begin
	..s EQName=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",9)
	..i EQName'="" s EQName=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQName)),"^",1) //2013-06-24 DJ0118 end
	..s EQCode=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",8)						//Name
	..q:(Equip'="")&&(($ZCONVERT(EQName,"U")'[Equip)&&($ZCONVERT(EQCode,"U")'[Equip))
	..//Modify by zx 2020-09-21 管理部门过滤
	..s TManageLocDR=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",32)
	..q:(ManageLocDR'="")&&(ManageLocDR'=TManageLocDR)
	..s StoreLocDR=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",31) //设备库房 2010-10-26 DJ begin
	..s Flag=0
	..i StoreLocDR'=""  d
	...s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR) //2010-10-26 DJ
	..q:Flag'=0
	..//add by ZY
	..s OCLContractNo=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",36) 
    ..q:(ContractFlag=2)&&(ContractNo'="")&&($ZCONVERT(OCLContractNo,"U")'[ContractNo)	//czf 2022-10-12 2827541
	..
	..s Status="N"
	..s ISStatus=""
	..s ISNo=""
	..s ISHold1=""  ;add by kdf 2018-05-18 增加字段判断  //modified by Mozy ZY0169
	..s ISLRowid=0
	..f  s ISLRowid=$o(^DHCEQInStockList(0,"Source",2,OCLRowid,ISLRowid)) q:ISLRowid=""  d
	...s ISNo=$p($g(^DHCEQInStockList(ISLRowid)),"^",1)
	...s ISStatus=$p($g(^DHCEQInStock(ISNo)),"^",10)
	...//modified by Mozy ZY0169
	...s ISHold1=$p($g(^DHCEQInStock(ISNo)),"^",27)    ;借助字段IS_Hold1="Y"，能够手动选到对应的验收单，避免被过滤掉 add by kdf (针对入库单作废，验收单不变，建入库单的时候这里选不到验收单的情况)
	...s ISInvalidFlag=$p($g(^DHCEQInStock(ISNo)),"^",25)
	...i ISInvalidFlag="Y"  d
	....s ISNo=""
	...e  d
	....s ISNo=$p($g(^DHCEQInStock(ISNo)),"^",14)
	....s Status="Y"
	..//modified by Mozy ZY0169
	..q:(ISStatus>1)&(ISHold1'="Y")   //实物入库   这里***需要调整add by kdf 
	..
	..s ^TempDHCEQ("GetOpenCheckList",Job,Status,rowid)=OCLRowid_"^"_ISNo
	
	i '$Data(^TempDHCEQ("GetOpenCheckList",Job)) Quit $$$OK
	s Status=0
	f  s Status=$o(^TempDHCEQ("GetOpenCheckList",Job,Status))  q:Status=""  d
	.s rowid=0
	.f  s rowid=$o(^TempDHCEQ("GetOpenCheckList",Job,Status,rowid))  q:rowid=""  d
	..s OCLRowid=$p($g(^TempDHCEQ("GetOpenCheckList",Job,Status,rowid)),"^",1)
	..s ISNo=$p($g(^TempDHCEQ("GetOpenCheckList",Job,Status,rowid)),"^",2)
	..s EQName=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",2)
	..s APC=##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQOpenCheckRequest(rowid)),"^",5))
	..s EquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p($g(^DHCEQOpenCheckRequest(rowid)),"^",2))
	..s StatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",$p($g(^DHCEQOpenCheckRequest(rowid)),"^",4))
	..s Model=##class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",5))
	..s Price=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",17)
	..s RequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",33))
	..s CommonName=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",2)   //add by zx 2019-07-24 通用名取值
	..;Add By QW20200220 BEGIN BUG号:QW0038 资金来源 FundsStr
	..s FundsStr=""
	..s FTDR=0
	..f  s FTDR=$o(^DHCEQFunds("0","CheckListType",OCLRowid,FTDR))  q:FTDR=""  d
	...s FRowID=0
	...f  s FRowID=$o(^DHCEQFunds("0","CheckListType",OCLRowid,FTDR,FRowID))  q:FRowID=""  d
	....q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
	....s Funds=$p($g(^DHCEQFunds(FRowID)),"^",2)
	....i Funds'=""  d
	.....s Funds=$p($g(^DHCEQCCode("DHCEQCFundsType",Funds)),"^",2)
	.....s Funds=Funds_";"_$p($g(^DHCEQFunds(FRowID)),"^",3)
	....i FundsStr=""  d
	.....s FundsStr=Funds
	....e  d
	.....s FundsStr=FundsStr_";"_Funds
	..;Add By QW20200220 END BUG号:QW0038 资金来源
	..s ContractNo=$p($g(^DHCEQOpenCheckList(OCLRowid)),"^",36)   //add by zy 2020-09-07 合同号取值
	..d OutputRowGetOpenCheckList

	k ^TempDHCEQ("GetOpenCheckList",Job)
	
	Quit $$$OK
	
OutputRowGetOpenCheckList	
	set Data=$lb(rowid,OCLRowid,EQName, Status, ISNo, EquipType, StatCat, APC, Model,Price,RequestLoc,CommonName,FundsStr,ContractNo)		;Modified By QW20200220 BEGIN BUG号:QW0038 资金来源 FundsStr
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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

/// MZY0062	1660622		2020-12-10	增加验收单ID信息
/// modified by ZY0243 2020-09-17  增加发票数量字段编辑
/// Add By ZY 2018-09-18
/// 描述: 入库单明细query
/// 入参:入库单ID
/// 访问表：  DHC_EQInStockList
/// 出参：  
/// 返回值:无
/// 修改方法注释：
/// Modify By DJ 2018-07-06 HISUI改造：页面除入参元素之外的所有Lookup元素初始化
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInStock","GetInStockListNew","93")
/// Moidefied by zc0065 20200409  将列输出ISLUserYearsNum改为ISLLimitYearsNum
Query GetInStockListNew(InStockID) As %Query(ROWSPEC = "ISLRowID:%String,ISLEquipDR:%String,ISLBatchFlag:%String,ISLEquipName:%String,ISLManuFactoryDR:%String,ISLManuFactoryDR_MDesc:%String,ISLOriginalFee:%String,ISLQuantityNum:%String,ISLTotalFee:%String,ISLModelDR:%String,ISLModelDR_MDesc:%String,ISLUnitDR:%String,ISLUnitDR_UOMDesc:%String,ISLHold1:%String,ISLRemark:%String,ISLAppendFee:%String,ISLEquipCatDR:%String,ISLEquipCatDR_ECDesc:%String,ISLLimitYearsNum:%String,ISLItemDR:%String,ISLItemDR_MIDesc:%String,ISLStatCatDR:%String,ISLStatCatDR_SCDesc:%String,ISLSourceType:%String,ISLSourceID:%String,ISLHold2:%String,ISLHold3:%String,ISLHold4:%String,ISLHold5:%String,ISLHold5_EDesc:%String,InvoiceNos:%String,InvoiceDate:%String,InvoiceFee:%String,InvoiceQty:%String,OpenCheckID:%String,ISLLRowID:%String,ISLLBuyLocDR:%String,ISLLBuyLocDR_CTLOCDesc:%String,ISLLQuantity:%String,ISLLFlag:%String")
{
}

ClassMethod GetInStockListNewExecute(ByRef qHandle As %Binary, InStockID) As %Status
{
 	//new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	if InStockID=""
	{
		d ResetVariablesGetInStockListNew
		d OutputRowGetInStockListNew
	}
	else
	{
		i '$Data(^DHCEQInStockList(0,"InStock",InStockID)) Quit $$$OK
		s rowid=0 
		f  s rowid=$o(^DHCEQInStockList(0,"InStock",InStockID,rowid))  quit:rowid=""  d
		.d ResetVariablesGetInStockListNew
		.s DataList=$g(^DHCEQInStockList(rowid))
		.s TRowID = rowid
		.s TInStockDR = $p(DataList,"^",1)
		.s TEquipDR = $p(DataList,"^",2)
		.s TBatchFlag = $p(DataList,"^",3)
		.s TBuyPlanListDR = $p(DataList,"^",4)
		.i TBuyPlanListDR'="" s TMaxInStockNum=##class(web.DHCEQ.EM.BUSInStock).GetArriveNum(TBuyPlanListDR)
		.s TEquipName= $p(DataList,"^",5)	//2013-06-24 DJ0118
		.s TCommonName=TEquipName
		.s TManuFactoryDR = $p(DataList,"^",6)
		.s TManuFactory =##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		.s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p(DataList,"^",7),"")
		.s TQuantityNum = $p(DataList,"^",8)
		.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantityNum,"")
		.s TModelDR = $p(DataList,"^",9)
		.s TModel =##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
		.s TUnitDR = $p(DataList,"^",10)
		.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.s THold1 = $p(DataList,"^",11)
		.s TRemark = $p(DataList,"^",12)
		.s TAppendFee = $p(DataList,"^",13)
		.s TEquipCatDR = $p(DataList,"^",14)
		.s TEquipCat = ##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)
		.s TUserYearsNum = $p(DataList,"^",15)
		.s TItemDR=$p(DataList,"^",16)
		.s TEquip = ##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemDR)
		.s TStatCatDR=$p(DataList,"^",17)
		.s TStatCat = ##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
		.s TSourceType=$p(DataList,"^",18)
		.;s TSourceType=$CASE(TSourceType,"0":"设备","1":"设备项","2":"验收单","":"")
		.s TSourceID=$p(DataList,"^",19)
		.if TSourceType=2 s OpenCheckID=$p(^DHCEQOpenCheckList(TSourceID),"^",1)	// MZY0062	1660622		2020-12-10
		.s THold2=$p(DataList,"^",20)
		.s THold3=$p(DataList,"^",21)
		.s THold4=$p(DataList,"^",22)
		.i THold4'="" s TCommonName="(附)"_TCommonName	//modified by Mozy ZY0169
		.s THold5=$p(DataList,"^",23)
		.;// add by csy 2017-07-21 友谊医院和北京中医入库时经费来源能填写或修改
		.i THold5'=""  d
		..s THold5Desc=$p($g(^DHCEQCCode("DHCEQCExpenditures",THold5)),"^",2)
		.s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,rowid)
		.;Modified By QW20210917 BUG:QW0153 begin 修改取发票数量及相关信息。存在一对多发票,时间取最新
		.s InvoiceLen=$l(return,"&")
		.for i=1:1:InvoiceLen d
		..s InvoiceInfo=$p(return,"&",i)
		..s PerInvoiceNo=$p(InvoiceInfo,"^",1)
		..i (TInvoiceNos'="")&&((","_TInvoiceNos_",")'[(","_PerInvoiceNo_",")) s TInvoiceNos=TInvoiceNos_","_PerInvoiceNo
		..i TInvoiceNos="" s TInvoiceNos=PerInvoiceNo
		..s TInvoiceDate=$p(InvoiceInfo,"^",2)
		..s TInvoiceFee=$p(InvoiceInfo,"^",3)
		..s TInvoiceQty=TInvoiceQty+$p(InvoiceInfo,"^",6)
		..;Modified By QW20210917 BUG:QW0153 end
		./// modified by ZY0260 20210428
		.s ISLLFlag=0
		.s ISLLRowID=$o(^DHCEQInStockListLoc(0,"InStockList",rowid,ISLLRowID))
		.i ISLLRowID'="" d
		..s ISLLBuyLocDR=$p($g(^DHCEQInStockListLoc(ISLLRowID)),"^",3)
		..s ISLLBuyLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", ISLLBuyLocDR)
		..s ISLLQuantity=$p($g(^DHCEQInStockListLoc(ISLLRowID)),"^",4)
		.i (TQuantityNum=ISLLQuantity)  d
		..s ISLLFlag=1
		.e  d
		..;s (ISLLRowID,ISLLBuyLocDR,ISLLBuyLoc,ISLLQuantity)=""
		.
		.d OutputRowGetInStockListNew
	}
	Quit $$$OK
	
OutputRowGetInStockListNew
	s Data=$lb(TRowID,TEquipDR,TBatchFlag,TEquipName,TManuFactoryDR,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TModelDR,TModel,TUnitDR,TUnit,THold1,TRemark,TAppendFee,TEquipCatDR,TEquipCat,TUserYearsNum,TItemDR,TEquip,TStatCatDR,TStatCat,TSourceType,TSourceID,THold2,THold3,THold4,THold5,THold5Desc,TInvoiceNos,TInvoiceDate,TInvoiceFee,TInvoiceQty,OpenCheckID,ISLLRowID,ISLLBuyLocDR,ISLLBuyLoc,ISLLQuantity,ISLLFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockListNew
	s (DataList,TRowID,TEquipDR,TBatchFlag,TEquipName,TManuFactoryDR,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TModelDR,TModel,TUnitDR,TUnit,THold1,TRemark,TAppendFee,TEquipCatDR,TEquipCat,TUserYearsNum,TItemDR,TEquip,TStatCatDR,TStatCat,TSourceType,TSourceID,THold2,THold3,THold4,THold5,THold5Desc,TInvoiceNos,TInvoiceDate,TInvoiceDate,TInvoiceQty,OpenCheckID,ISLLRowID,ISLLBuyLocDR,ISLLBuyLoc,ISLLQuantity,ISLLFlag)=""
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

ClassMethod GetArriveNum(BPLID)
{
	s ExecNum=$p(^DHCEQBuyPlanList(BPLID),"^",11)
	s ArriveNum=$p(^DHCEQBuyPlanList(BPLID),"^",17)
	i ExecNum="" s ExecNum=0
	i ArriveNum="" s ArriveNum=0
	q ExecNum-ArriveNum
}

/// modified by ZY0249 20201228  修改几个变量错误。
/// w ##Class(web.DHCEQ.EM.BUSInStock).GetOneInStock(1)
ClassMethod GetOneInStock(RowID As %Library.String = "", ApproveRoleDR As %Library.String, action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOneInStock"
	s ObjInStock=##Class(User.DHCEQInStock).%OpenId(RowID)
	s InStockInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjInStock)
	d InStockInfo.%Set("ISLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjInStock.ISLocDR))
	d InStockInfo.%Set("ISOriginDR_ODesc",ObjInStock.ISOriginDR.ODesc)
	d InStockInfo.%Set("ISFromDeptDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjInStock.ISFromDeptDR))
	d InStockInfo.%Set("ISProviderDR_VDesc",ObjInStock.ISProviderDR.VName)
	d InStockInfo.%Set("ISBuyLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjInStock.ISBuyLocDR))
	d InStockInfo.%Set("ISBuyUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjInStock.ISBuyUserDR))
	d InStockInfo.%Set("ISEquipTypeDR_ETDesc",ObjInStock.ISEquipTypeDR.ETDesc)
	d InStockInfo.%Set("ISStatCatDR_SCDesc",ObjInStock.ISStatCatDR.SCDesc)
	d InStockInfo.%Set("ISCancelUser_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjInStock.ISCancelUser))
	d InStockInfo.%Set("ISRequestUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjInStock.ISRequestUserDR))
	
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("13",RowID,ApproveRoleDR)
	d InStockInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d InStockInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d InStockInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d InStockInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d InStockInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d InStockInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d InStockInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d InStockInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d InStockInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d InStockInfo.%Set("NextRole",$p(AppInfo,"^",10))
	s CanChangeValue=""
	i action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("13",action,RowID,2)
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_step_",")) d
	.s MultipleRoleFlag=1
	
	d InStockInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	///add by ZY0241 2020-09-07 
	///增加合同和经费来源的输出,然后界面根据系统参数和值来判断
	s ISLRowID=$O(^DHCEQInStockList(0,"InStock",RowID,0))
	i ISLRowID'=""
	{
		s (ContractNo,ISLHold5,ISLHold5EDesc)=""
		s TSourceType=$p($g(^DHCEQInStockList(ISLRowID)),"^",18)	//"0":"设备","1":"设备项","2":"验收单","":""
		s TSourceID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
		i TSourceType=2  d
		.s ContractNo=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",36)
		s ISLHold5=$p($g(^DHCEQInStockList(ISLRowID)),"^",23)
		i ISLHold5'=""  d
		.s ISLHold5EDesc=$p($g(^DHCEQCCode("DHCEQCExpenditures",ISLHold5)),"^",2)
		d InStockInfo.%Set("ContractNo",ContractNo)
		d InStockInfo.%Set("ISLHold5",ISLHold5)
		d InStockInfo.%Set("ISLHold5EDesc",ISLHold5EDesc)
	}
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,InStockInfo)
ERRORGetOneInStock
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

ClassMethod SaveData(data, dataList, DelIs)
{
	s $ZT="ERRORInStock"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	TSTART
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQInStock set IS_InvalidFlag='Y' where IS_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInStock",JsonData,.PLIST)
		s RowID = JsonData.ISRowID
	 	s PLIST(5) = User	;RequestUserDR
	 	s PLIST(6) = Date	;RequestDate
		s PLIST(11) = "0"	;Status
		s PLIST(26) = "N"
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQInStock Values :PLIST() where IS_RowID = :RowID)
		}
		else
		{
			i PLIST(15)="" s PLIST(15)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInStock",Date,JsonData.ISLocDR,JsonData.ISEquipTypeDR)
			
			&SQL(insert into SQLUSER.DHC_EQInStock Values :PLIST())
			s RowID=$g(%ROWID)
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s SQLCODE=##Class(web.DHCEQ.EM.BUSInStock).SaveDataList(RowID,dataList)
	}
	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORInStock
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSInStock).SaveDataList(96,"")
ClassMethod SaveDataList(RowID, dataList)
{
	k PLIST
	s SQLCODE=0
	s ISLRowIDs=""
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-24 分隔符号处理
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
		q:valList=""
		k PLIST,ISLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInStockList",JsonData,.PLIST)
		s PLIST(2)=RowID
		s ISLRowID = JsonData.ISLRowID
	    if ISLRowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQInStockList Values :PLIST() where ISL_RowID = :ISLRowID)
			/// modified by ZY0260 20210428
			if (JsonData.ISLLBuyLocDR'="")
			{
				k LPLIST
				s LPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInStockListLoc",JsonData,.LPLIST)
				s ISLLRowID = JsonData.ISLLRowID
				s LPLIST(2)=ISLRowID
				s LPLIST(5)=JsonData.ISLQuantityNum
				s tmp=0
				&SQL(select count(*) into :tmp from  SQLUSER.DHC_EQInStockListLoc where ISLL_InStockListDR = :ISLRowID)
				/// modified by ZY0264 20210521
			    if ISLLRowID'=""
			    {
				    if tmp>1 k LPLIST(5)
					&SQL(Update SQLUSER.DHC_EQInStockListLoc Values :LPLIST() where ISLL_RowID = :ISLLRowID)
				}
				else
				{
					&SQL(insert into SQLUSER.DHC_EQInStockListLoc Values :LPLIST())
					s ISLLRowID=$g(%ROWID)
				}
				i SQLCODE'=0 q
			}
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQInStockList Values :PLIST())
			s ISLRowID=$g(%ROWID)
			q:SQLCODE'=0
			s SQLCODE=##Class(web.DHCEQ.EM.BUSInStockListLoc).SaveInStockListLoc(ISLRowID)
		}
		q:SQLCODE'=0
		if ISLRowIDs=""
		{
			s ISLRowIDs=ISLRowID
		}
		else
		{
			s ISLRowIDs=ISLRowIDs_","_ISLRowID
		}
		q:SQLCODE'=0
		;Modified By QW20210917 BUG:QW0153 自动截取发票数量 begin
		if (JsonData.InvoiceNos'="") 
		{
			s InvoiceQty=$l(JsonData.InvoiceNos,",")
			s SQLCODE=##Class(web.DHCEQ.EM.BUSInStock).UpdateInvoiceInfo(ISLRowID, JsonData.InvoiceNos, JsonData.InvoiceDate, JsonData.ISLTotalFee,"",InvoiceQty)	//modified by ZY0243 2020-09-17 增加发票号数量字段编辑
	
		}
		;Modified By QW20210917 BUG:QW0153 end
	}
	i SQLCODE'=0 q SQLCODE
	//i ISLRowIDs="" q -1301
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",RowID,ISLRowID))  quit:(ISLRowID="")||(SQLCODE'=0)  d
	.i (","_ISLRowIDs_",")'[(","_ISLRowID_",")  d
	..&SQL(delete from SQLUSER.DHC_EQInStockList where ISL_RowID = :ISLRowID)
	..i SQLCODE=100 s SQLCODE=0
	..
	..&SQL(delete from SQLUSER.DHC_EQInStockListLoc where ISLL_InStockListDR = :ISLRowID)
	..i SQLCODE=100 s SQLCODE=0
	
	/// modified end  by ZY0260 20210428
	q SQLCODE
}

/// w ##Class(web.DHCEQ.EM.BUSInStock).SubmitData("148^^1^^16^2^^",2)
ClassMethod SubmitData(val, OutFlag As %Library.String = "0")
{
	//new (val, AutoFlag, %session)  //ZX0035 清空session值后,影响消息生成
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	//Set ^DHCEQInStock(RowID,"AutoFlag")=AutoFlag
	s InvalidFlag=$p($g(^DHCEQInStock(RowID)),"^",25) //2011-10-31 DJ DJ0098
	i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1015,"当前单据已无效!")
	
	Set $ZT="ERRORSubmit"
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s LocDR=$p($g(^DHCEQInStock(RowID)),"^",2)
	s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
  	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,LocDR)) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1015,"当前库房不是科室!")   //判断入库单中的科室类型是否属于库房
  	
	s PLIST(7) = User	;AuditUserDR
 	s PLIST(8) = Date	;AuditDate
	s PLIST(11)="1"		;Status
	//s PLIST(12)=Remark	
	//add by zy 20120316  zy0091
	s ReturnProvider=##class(web.DHCEQ.EM.BUSInStock).ProviderIsUniqueNew("InStock",RowID)
	i ReturnProvider<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnProvider)	//modified by czf 2020-11-05 1562330 转化json格式输出
	
	s EquipTypeDR=$p($g(^DHCEQInStock(RowID)),"^",20)
	s StatCatDR=$p($g(^DHCEQInStock(RowID)),"^",21)	
	s ReturnEquipType=##class(web.DHCEQ.EM.BUSInStock).EquipTypeIsUniqueNew(RowID,EquipTypeDR,"InStock")	
	i ReturnEquipType<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnEquipType)	//modified by czf 2020-11-05 1562330 转化json格式输出
	
	s Flag=##class(web.DHCEQCommon).GetSysInfo("301007")   //单据中设备类型是否需要一致
	if (Flag=1)
	{
		s ReturnType=##class(web.DHCEQ.EM.BUSInStock).StatCatIsUniqueNew(RowID,StatCatDR)
		i ReturnType<0 	//modified by czf 1562330 2020-11-05
		{
			s ErrMsg=""
			i ReturnType=-1001 s ErrMsg="明细设备类型不一致!"
			i ReturnType=-1002 s ErrMsg="明细设备类型有空值!"
			i ReturnType=-1004 s ErrMsg="明细设备类型与总单不一致!"
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnType,ErrMsg) //add by zx 2019-03-06 ZX0060 转化json格式输出
		}
	} 
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("13")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR, "", "", "","")
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-4007","折旧设置不存在")
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
 		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}

	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
 		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
 		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=##class(web.DHCEQInStockNew).LastAuditAction(RowID, User, Date,OutFlag)
		i SQLCODE
		{
			TROLLBACK
 			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}		
	}
	;Modified by jdl 2011-3-2  jdl0071
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
 		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSubmit
	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// modified by ZY0243 2020-09-17 增加发票号数量字段编辑
/// ----------------------------------
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:修改发票信息
/// 访问表:DHC_EQInvoice,DHC_EQInvoiceUseMap
/// w ##Class(web.DHCEQ.EM.BUSInStock).UpdateInvoiceInfo
/// ----------------------------------
ClassMethod UpdateInvoiceInfo(ISLRowID, Invoice, InvoiceDate, InvoiceFee, IUMType As %String = "", Quantity As %String = "")
{
	//new ISRowID,ProviderID,ISStatus,IUMRowID,InvoiceID
	//new OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee,RowID,Times
	

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
	s INPLIST(11)="1" //Status modified by csj 2020-04-29 修改发票状态为提交状态 需求号：1296929
	s INPLIST(6)=ProviderID
	s INPLIST(17)="N"
	s INPLIST(18)=Quantity
	
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
		///Modefied by zc0051 2019-10-24   Begin   修改RowID变量名冲突的问题将RowID改为vRowID
		s vRowID=0
		f  s vRowID=$o(^DHCEQInvoice(0,"InvoiceNo",Invoice,vRowID)) q:((vRowID="")||(InvoiceID'=""))  d
		.q:$p(^DHCEQInvoice(vRowID),"^",16)'="N"
		.i ProviderID=$p(^DHCEQInvoice(vRowID),"^",5) s InvoiceID=vRowID	
		///Modefied by zc0051 2019-10-24   end   修改RowID变量名冲突的问题将RowID改为vRowID	
	}
	
	i InvoiceID'=""
	{
		s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,ISLRowID,InvoiceID)
		i Times>0
		{
			///modified by ZY0238 去掉日期和费用的判断。
			;该发票与原有信息不符!
			//i InvoiceDate'=$p(^DHCEQInvoice(InvoiceID),"^",3) q -1008
			//i InvoiceFee'=$p(^DHCEQInvoice(InvoiceID),"^",4) q -1008				
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

/// ----------------------------------
/// 创建:zy 20120316  zy0091
/// 判断入库单设备供应商的唯一性
/// ResultFlag :0,一性;小于0,不一致
/// w ##class(web.DHCEQ.EM.BUSInStock).ProviderIsUniqueNew("Return",1)
ClassMethod ProviderIsUniqueNew(vType, RowID)
{
	//new ProviderID,ResultFlag,ISLRowID,SourceType,SourceID,OpenCheckRequestID,ProviderDR
	
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

/// ----------------------------------
/// 创建: add by zy
/// 描述:判断入库单设备类组的唯一性
/// 	入参：
/// 		RowID			业务单ID
/// 	EquipTypeID		业务单类组
/// 		vType			业务类型
/// w ##Class(web.DHCEQ.EM.BUSInStock).EquipTypeIsUniqueNew("63","1","StoreMove")
/// 返回值：-1006：明细的类组不一致，-1007:明细与单据的类组不一致
ClassMethod EquipTypeIsUniqueNew(RowID, EquipTypeID, vType)
{
	//new (RowID, EquipTypeID, vType)
	
	//new ResultFlag,PreEquipTypeID,EquipTypeDR
	//new SourceType,SourceID
	//new ISLRowID,SMLRowID,RLRowID
	//new DLRowID,DRLRowID,DRLEquipDR,DLSourceType,DLSourceID,DLEquipDR,DLCount		//Add By DJ 2016-04-01 DJ0177
	
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

/// ----------------------------------
/// 创建: add by jdl 2009-04-13
/// 判断入库单设备类型的唯一性
/// ----------------------------------
ClassMethod StatCatIsUniqueNew(ISRowID, StatCatID)
{
	//new (ISRowID, StatCatID)
	
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

/// 创建:zy 2009-12-02  No ZY0018
/// 描述:反提交
/// w ##Class(web.DHCEQInStockNew).CancelSubmitData("202^^1^^5^1^112^28")
ClassMethod CancelSubmitData(val, CurRole)
{
	//new (val,CurRole, %session)  //ZX0035 清空session值后,影响消息生成
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
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
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
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
 	
ERRORCancel
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息 
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)  //返回错误消息 ;
}

/// Mozy0185	增加自动出库审核标志
/// 创建:zy 2009-12-02  No ZY0018
/// 描述:审核
/// w ##Class(web.DHCEQ.EM.BUSInStock).AuditData("202^^1^^5^1^^28","13","2","202^,3^,4@455^1111113434,1^11111343434,2")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo, OutFlag As %Library.String = "0")
{
	//new (val, CurRole,RoleStep, editFieldsInfo, %session, OutFlag)  //ZX0035 清空session值后,影响消息生成
	//n EquipType,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	//n User,Date,RowID,AuditFlag,PLIST
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	
	s User=$P(val,"^",3)
	s Date=+$H
	
	s EquipType=$p($g(^DHCEQInStock(RowID)),"^",20)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("13")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("13", RowID)	
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-4007,"折旧设置不存在!")
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	Set AppInfoStatus="1"			;AppInfoStatus	
	
	TSTART
	//Set ^DHCEQInStock(RowID,"AutoFlag")=AutoFlag	;20170329 Mozy0185
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQInStock(RowID)),"^",10)=2)
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1010")
		}
		s AuditFlag=1
		s PLIST(11)="2"
		s PLIST(13)=User	;BillAuditUserDR
		s PLIST(14)=Date	;BillAuditDate
		&SQL(update sqluser.DHC_EQInStock values :PLIST() where IS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		
		Set AppInfoStatus="2"			;AppInfoStatus
	}
	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User)
	if SQLCODE
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
	if editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)		//编辑要修改的字段
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	;最后一步,需要调用审核方法
	if AuditFlag=1
	{
		s SQLCODE=##class(web.DHCEQInStockNew).LastAuditAction(RowID, User, Date,OutFlag)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}		
	}
	;Modified by jdl 2011-3-2  jdl0071		
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("21", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
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
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)  //返回错误消息 ;
}

/// modified BY ZY0198 逻辑错误
/// Creator：      WL
/// CreatDate：    2019-10-25
/// Description:   出厂编号的信息
/// Input：        SourceID,SourceType  入库明细的ID,业务类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInStock","GetLeaveFactoryNum","1","181")
Query GetLeaveFactoryNum(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "EquipID:%String,LeavefactoryNo:%String")
{
}

ClassMethod GetLeaveFactoryNumExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	if (SourceType="")||(SourceID="") Quit $$$OK
 	if SourceType=2
 	{
	 	if $Data(^DHCEQEquip(0,"OpenCheckList",SourceID))>0
	 	{
		 	s EquipID=0
			f  s EquipID=$o(^DHCEQEquip(0,"OpenCheckList",SourceID,EquipID))  q:EquipID=""  d
			.q:$p($g(^DHCEQEquip(EquipID,"OtherInfo")),"^",24)'=""
			.s LeavefactoryNo=$p($g(^DHCEQEquip(EquipID)),"^",10)
			.d OutputRowGetLeaveFactoryNo
		}
		else
		{
			s EquipID=""
			s StrLeavefactoryNo=$g(^DHCEQOpenCheckList(SourceID,"EX"))
			i StrLeavefactoryNo'="" d
			.s len=$l(StrLeavefactoryNo,",")
			.f i=1:1:len  d
			..s LeavefactoryNo=$p(StrLeavefactoryNo,",",i)
			..d OutputRowGetLeaveFactoryNo
		}
	}
	Quit $$$OK	 
OutputRowGetLeaveFactoryNo
	set Data=$lb(EquipID,LeavefactoryNo)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetLeaveFactoryNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLeaveFactoryNumExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
	  Set AtEnd=1
	  Set Row=""
	 }
	 Else
	 {
	  Set Row=^CacheTemp(repid,ind)
	 }
	 s qHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

ClassMethod GetLeaveFactoryNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLeaveFactoryNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by czf 2023-03-01
/// 描述:检测入库主单与明细类组是否一致
/// 入参:ISEquipTypeDR 主单类组 EquipDR 明细设备id InStockListDR 明细入库明细ID
ClassMethod CheckInStockEquipType(ISEquipTypeDR, SourceType, SourceID)
{
	i (SourceType="")&&(SourceID="") q -1
	new ISLEquipTypeDR,InStockDR
 	if (SourceType=2)
 	{
	 	s ISLEquipTypeDR=$p($g(^DHCEQOpenCheckList(SourceID)),"^",3)
	 	
	}
	if (ISEquipTypeDR'=ISLEquipTypeDR)
	{
		q -1
		
	} 
	q 0
}

Storage Default
{
<Data name="BUSInStockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.EM.BUSInStockD</DataLocation>
<DefaultData>BUSInStockDefaultData</DefaultData>
<IdLocation>^web.DHCEQ.EM.BUSInStockD</IdLocation>
<IndexLocation>^web.DHCEQ.EM.BUSInStockI</IndexLocation>
<StreamLocation>^web.DHCEQ.EM.BUSInStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
