Class web.DHCEQ.Stat.DHCEQEquipBase Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// MZY0139	3014531		2022-10-21
/// Add By DJ  2016-01-08
/// 描述:获取设备清单或快照清单
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQEquipBase","SnapEquip")
/// modify by mwz 
/// 增加入参：pMinValue,pMaxValue,pIncludeFlag
/// 增加过滤条件:TStatus,TOriginalFee,TStatCatDR,TEquipTypeDR,OverDateFlag(役龄逾龄) 
/// 当报表需要按资金来源过滤时，pHFundFlag 在润乾报表中传"Y"
Query SnapEquip(pMonthStr As %String = "", pEquipDR As %String = "", pEquipNo As %String = "", PEquipCode As %String = "", PEquipName As %String = "", pOldEquipNo As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", pEquipCatDR As %String = "", pModelDR As %String = "", pProviderDR As %String = "", pManufacturerDR As %String = "", pUseLoc As %String = "", pUseLocDR As %String = "", pFundsTypeDR As %String = "", pOutLayTypeDR As %String = "", pStatus As %String = "", pTransSDate As %String = "", pTransEDate As %String = "", pDisUseFlag As %String = "", pDisUseSDate As %String = "", pDisUseEDate As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vOverLimitFlag As %String = "", CurHospID As %String = "", CurUserID As %String = "", pMinValue As %String = "", pMaxValue As %String = "", pIncludeFlag As %String = "", pFindAllFlag As %String = "", pHFundFlag As %String = "", pItemDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEQNo:%String,TEquipName:%String,TModel:%String,TUseLoc:%String,TEquipType:%String,TStatCat:%String,TEquipCatCode:%String,TEquipCat:%String,TOriginalFee:%String,TLimitYearsNum:%String,TNetFee:%String,TDepreTotalFee:%String,TManuFactory:%String,TUnit:%String,TProvider:%String,TStatus:%String,TCode:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TCountry:%String,TOrigin:%String,TRemark:%String,TDepreMethod:%String,TManageUser:%String,TStartDate:%String,TTransAssetDate:%String,TKeeper:%String,TQuantityNum:%String,TOldEquipNo:%String,TBrand:%String,TOutLayType:%String,TFundsType:%String,TFundsFee:%String,TDisUseDate:%String,TOverDateFlag:%String,TInvoiceNo:%String,ContractNo:%String,TTransAssetYear:%String") [ SqlProc ]
{
}

ClassMethod SnapEquipExecute(ByRef qHandle As %Binary, pMonthStr As %String = "", pEquipDR As %String = "", pEquipNo As %String = "", PEquipCode As %String = "", PEquipName As %String = "", pOldEquipNo As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", pEquipCatDR As %String = "", pModelDR As %String = "", pProviderDR As %String = "", pManufacturerDR As %String = "", pUseLoc As %String = "", pUseLocDR As %String = "", pFundsTypeDR As %String = "", pOutLayTypeDR As %String = "", pStatus As %String = "", pTransSDate As %String = "", pTransEDate As %String = "", pDisUseFlag As %String = "", pDisUseSDate As %String = "", pDisUseEDate As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vOverLimitFlag As %String = "", CurHospID As %String = "", CurUserID As %String = "", pMinValue As %String = "", pMaxValue As %String = "", pIncludeFlag As %String = "", pFindAllFlag As %String = "", pHFundFlag As %String = "", pItemDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	;i pFindAllFlag=""  QUIT $$$OK     //需求号：785151  add by mwz 控制初始化润乾时不加载任何数据（暂不使用）
 	i pDisUseFlag'="" s pMonthStr=$E($ZD(+$H,3),1,7)
 	i pMonthStr="" s pMonthStr=$E($ZD(+$H,3),1,7)
	
	s vDisUseSDate=##class(web.DHCEQCommon).TransValueFromPage(pDisUseSDate,"date")
	i vDisUseSDate="" s vDisUseSDate=0
	
	s vDisUseEDate=##class(web.DHCEQCommon).TransValueFromPage(pDisUseEDate,"date")
	i vDisUseEDate="" s vDisUseEDate=+$H
 	
	s vTransSDate=##class(web.DHCEQCommon).TransValueFromPage(pTransSDate,"date")
	i vTransSDate="" s vTransSDate=0
	
	s vTransEDate=##class(web.DHCEQCommon).TransValueFromPage(pTransEDate,"date")
	i vTransEDate="" s vTransEDate=+$H
 	i pIncludeFlag'="" s pIncludeFlag=##class(web.DHCEQCommon).TransValueFromPage(pIncludeFlag,"bool")
 	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(pMonthStr)
 	
 	i pDisUseFlag'="" s SnapID=""
 	s RowID=0
 	i SnapID=""  d
 	.f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d
 	..d ResetVariablesGetSnapEquip
 	..s EquipData=$g(^DHCEQEquip(RowID))
 	..d BuildDataList
 	e  d
 	.f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  q:RowID=""  d
 	..d ResetVariablesGetSnapEquip
 	..s EquipData=$g(^DHCEQSnapShot(SnapID,"Equip",RowID))
 	..d BuildDataList
 	
	Quit $$$OK
	
BuildDataList	
 	q:$p(EquipData,"^",59)="Y"
 	s EQStoreLocDR=$p(EquipData,"^",67)	//设备库房
 	q:(pUseLocDR'="")&&((","_pUseLocDR_",")'[(","_EQStoreLocDR_",")) //add by csj 2020-10-20 多科室查询
 	s EQEquipTypeDR=$p(EquipData,"^",63)	//设备类组
 	q:(EquipTypeDR'="")&&(EquipTypeDR'=EQEquipTypeDR)  //modify hly 2019-6-6
 	q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
 	s EQOriginalFee=$p(EquipData,"^",27)	//设备原值
 	s EQStatus=$p(EquipData,"^",38)
 	q:(pStatus'="")&&(EQStatus'=pStatus)
 	s EQStockStatus=$p(EquipData,"^",60)
 	q:'((EQStockStatus="1")&&(EQStatus<=2))
 	s EQItemDR=$p(EquipData,"^",7)
 	q:((pItemDR'="")&&(EQItemDR'=pItemDR))
 	s TRowID=RowID
 	s TEQNo=$p(EquipData,"^",71)		//设备编号
 	q:(pEquipNo'="")&&(TEQNo'=pEquipNo)
	s TOldEquipNo=$p(EquipData,"^",91)
	q:(pOldEquipNo'="")&&(TOldEquipNo'=pOldEquipNo)
	s TBrandDR=$p(EquipData,"^",94)
	i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
	s TOutLayTypeDR=$p(EquipData,"^",95)
	q:(pOutLayTypeDR'="")&&(TOutLayTypeDR'=pOutLayTypeDR)
	i TOutLayTypeDR'="" s TOutLayType=$p($g(^DHCEQCCode("DHCEQCOutLayType",TOutLayTypeDR)),"^",2)
 	s TEquipName=$p(EquipData,"^",1)	//设备名称
 	q:(PEquipName'="")&&(PEquipName'=TEquipName)    //add by mwz 2021-01-25 MWZ0044
 	s TModel=$p(EquipData,"^",3)		//规格型号
 	i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
 	s TUseLoc=$p(EquipData,"^",67)	//使用科室
 	i TUseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
 	s TOriginalFee=$fn($p(EquipData,"^",27),"",2) //设备原值
 	q:(pMinValue'="")&&(TOriginalFee<pMinValue)
	q:(pMaxValue'="")&&(TOriginalFee>pMaxValue)
 	s TStatCatDR=$p(EquipData,"^",75)		//设备类型
	q:(StatCatDR'="")&&(StatCatDR'=TStatCatDR)  //modify hly 2019-6-6
 	i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
 	s TEquipCatDR=$p(EquipData,"^",4)		//设备分类
	/*****************包含子类*****************/
	s passed=0
	i (pEquipCatDR'="")&&(pEquipCatDR'=TEquipCatDR) d
	.i (pIncludeFlag'="Y") d
	..s passed=0
	.e  d
	..s passed=##class(web.DHCEQCEquipeCat).IsChildPar(pEquipCatDR,TEquipCatDR)
	e  d
	.s passed=1
	q:passed=0
 	/******************************************/
 	i TEquipCatDR'=""  d
 	.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
 	.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
 	i EQEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EQEquipTypeDR)),"^",2)
 	s TLimitYearsNum=$p(EquipData,"^",31)	//使用年限
 	s TNetFee=$fn($p(EquipData,"^",28),"",2)		//净值
 	s TDepreTotalFee=$fn($p(EquipData,"^",35),"",2)	//累计折旧
 	s TManuFactoryDR=$p(EquipData,"^",26)	//生产厂家
 	i TManuFactoryDR'=""  d
 	.s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) // MZY	2440180		2022-01-29
 	.s TManuFactory=##Class(web.DHCEQCommon).GetSplitDataByFlag(TManuFactory,"-")
 	s TUnitDR=$p(EquipData,"^",5)			//单位
 	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	s TProviderDR=$p(EquipData,"^",25)	//供应商
 	q:((pProviderDR'="")&&(TProviderDR'=pProviderDR))
 	i TProviderDR'=""  d
 	.s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
 	.s TProvider=##Class(web.DHCEQCommon).GetSplitDataByFlag(TProvider,"-")
 	i EQStatus=0 s TStatus="新增"
 	i EQStatus=1 s TStatus="启用"
 	i EQStatus=2 s TStatus="封存"
 	s TCode=$p(EquipData,"^",6)		//编码(拼音码)
 	s TLeaveFactoryNo=$p(EquipData,"^",10)	//出厂编号
 	s TLeaveFactoryDate=$p(EquipData,"^",11)	//出厂日期
 	i TLeaveFactoryDate'="" s TLeaveFactoryDate=$ZD(TLeaveFactoryDate,3)
	s TOpenCheckDate=$p(EquipData,"^",12)		//开箱日期
	i TOpenCheckDate'="" s TOpenCheckDate=$ZD(TOpenCheckDate,3)
	s TCheckDate=$p(EquipData,"^",13)			//验收日期
	i TCheckDate'="" s TCheckDate=$ZD(TCheckDate,3)
	s TCountryDR=$p(EquipData,"^",16)			//国别
	i TCountryDR'="" s TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	s TOriginDR=$p(EquipData,"^",20)			//来源
	i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	s TRemark=$p(EquipData,"^",34)			//备注
	s TDepreMethodDR=$p(EquipData,"^",33)		//折旧方法
	i TDepreMethodDR'="" s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TManageUserDR=$p(EquipData,"^",39)		//管理员
	i TManageUserDR'="" s TManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	s TStartDate=$p(EquipData,"^",44)			//启用日期
	i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
	s TTransAssetDate=$p(EquipData,"^",45)	//转资日期
	q:(vTransSDate'="")&&(TTransAssetDate<vTransSDate)
	q:(vTransEDate'="")&&(TTransAssetDate>vTransEDate)
	s TOverDateFlag=""
	i (TTransAssetDate'="") d    //modified by LMH 20220825 2666675 修正错误 去掉vOverLimitFlag的判断
	.s months=##Class(web.DHCEQCommon).DateDiffInt("m",TTransAssetDate,+$H)
	.i (months>(TLimitYearsNum*12)) d
	..s TOverDateFlag="Y"   //超龄
	.e  d
	..s TOverDateFlag="N"  //役龄
	;q:(vOverLimitFlag'="")&&(vOverLimitFlag'=TOverDateFlag)   //modify by mwz 20211120 mwz0054 //modified by LMH 20220816 2666675 输出设备总数量错误
	i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
	s TKeeperDR=$p(EquipData,"^",66)			//保管人
	i TKeeperDR'="" s TKeeper=##Class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	//add by mwz 2020-02-27 begin MWZ0028
	s TInStockListDR=$p(EquipData,"^",70)
	i TInStockListDR'="" s TInvoiceDR=$o(^DHCEQInvoiceUseMap(0,"Source","1",TInStockListDR,0))
	i TInvoiceDR'="" s TInvoiceNo=$P($g(^DHCEQInvoice(TInvoiceDR)),"^",2)
	s ContractNo=$p(EquipData,"^",76)
	s TTransAssetYear=+$zd($p(EquipData,"^",45),3)	;MZY0139	3014531		2022-10-21
	s TQuantityNum="1"
	i pHFundFlag="Y"  d                  //modify by mwz 2021-01-25 MWZ0044
	.s FRowID=0
	.i SnapID'=""  d
	..f  s FRowID=$o(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID))  q:FRowID=""  d
	...s FTFundsType=$p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",2)
	...q:(pFundsTypeDR'="")&&(FTFundsType'=pFundsTypeDR) //add by csj 2020-10-20 资金来源查询
	...i FTFundsType'="" s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTFundsType)),"^",2)
	...s TFundsFee=$p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",3)
	...q:TFundsFee<=0
	...d OutputRowGetSnapEquip
	.e  d
	..f  s FRowID=$o(^DHCEQFunds(0,"Equip",RowID,FRowID))  q:FRowID=""  d
	...s FTFundsType=$p($g(^DHCEQFunds(FRowID)),"^",2)
	...q:(pFundsTypeDR'="")&&(FTFundsType'=pFundsTypeDR) //add by csj 2020-10-20 资金来源查询
	...i FTFundsType'="" s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTFundsType)),"^",2)
	...s TFundsFee=$p($g(^DHCEQFunds(FRowID)),"^",3)
	...q:TFundsFee<=0
	...d OutputRowGetSnapEquip
	e  d
	.d OutputRowGetSnapEquip
	
	quit

OutputRowGetSnapEquip
	Set Data=$lb(TRowID,TEQNo,TEquipName,TModel,TUseLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TOrigin,TRemark,TDepreMethod,TManageUser,TStartDate,TTransAssetDate,TKeeper,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsType,TFundsFee,TDisUseDate,TOverDateFlag,TInvoiceNo,ContractNo,TTransAssetYear)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetSnapEquip
	s (TRowID,TInStockListDR,TEQNo,TEquipName,TModel,TUseLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TOrigin,TRemark,TDepreMethod,TManageUser,TStartDate,TTransAssetDate,TKeeper,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsType,TFundsFee,TDisUseDate,TOverDateFlag,TInvoiceNo,TInvoiceDR,ContractNo,TTransAssetYear)=""
	quit
}

ClassMethod SnapEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SnapEquipExecute ]
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

ClassMethod SnapEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SnapEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Add By CSJ 2020-10-22
/// 描述:根据审批类型、角色获取审批明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Stat.DHCEQEquipBase","ApproveList","5","8")
Query ApproveList(pApproveTypeDR As %String = "", pApproveRoleDR As %String = "", pStartDate As %String = "", pEndDate As %String = "") As %Query(ROWSPEC = "ApproveType,ApproveOpinion,ApproveRole,ApproveUser,ApproveDate,RequestNo") [ SqlProc ]
{
}

ClassMethod ApproveListExecute(ByRef qHandle As %Binary, pApproveTypeDR As %String = "", pApproveRoleDR As %String = "", pStartDate As %String = "", pEndDate As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
#; 	i pMonthStr="" s pMonthStr=$E($ZD(+$H,3),1,7)
	
	s pStartDate=##class(web.DHCEQCommon).TransValueFromPage(pStartDate,"date")
	i pStartDate="" s pStartDate=0
	
	s pEndDate=##class(web.DHCEQCommon).TransValueFromPage(pEndDate,"date")
	i pEndDate="" s pEndDate=+$H

 	s RowID=0

 	f  s RowID=$o(^DHCEQApproveList(RowID))  q:RowID=""  d
 	.d ResetVariablesGetApproveList
 	.s ApproveListData=$g(^DHCEQApproveList(RowID))
 	.d BuildApproveList
 	
	Quit $$$OK
	
BuildApproveList
	q:$p(ApproveListData,"^",10)="Y"
	s ApproveTypeDR=$p(ApproveListData,"^",1)
	 s ApproveSourceID=$p(ApproveListData,"^",2)
 	i (ApproveSourceID'="")&&(ApproveTypeDR=5) d
 	.s RequestNo=$p($g(^DHCEQDisuseRequest(ApproveSourceID)),"^",33)
 	q:(pApproveTypeDR'="")&&(pApproveTypeDR'=ApproveTypeDR)
 	s ApproveType=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR)),"^",2)
 	s ApproveOpinion=$p(ApproveListData,"^",3)
 	s ApproveRole=$p(ApproveListData,"^",5)
 	;q:(pApproveRoleDR'="")&&(ApproveRole'=pApproveRoleDR) //Modified By QW20201223 BUG:QW0086 需求号 1646581
 	s ApproveRole=##Class(web.DHCEQCommon).GetTrakNameByID("role", ApproveRole)
 	s ApproveUserDR=$p(ApproveListData,"^",6)
 	s ApproveUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", ApproveUserDR)
	s ApproveDate=$p(ApproveListData,"^",7)
	q:(ApproveDate>pEndDate)||(ApproveDate<pStartDate)
	s ApproveDate=##class(web.DHCEQCommon).TransValueToPage(ApproveDate,"date")
	d OutputRowGetApproveList
	quit

OutputRowGetApproveList
	s Data=$lb(ApproveType,ApproveOpinion,ApproveRole,ApproveUser,ApproveDate,RequestNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetApproveList
	s (ApproveTypeDR,ApproveType,ApproveOpinion,ApproveRoleDR,ApproveRole,ApproveUserDR,ApproveUser,ApproveDate,RequestNo)=""
	quit
}

ClassMethod ApproveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ApproveListExecute ]
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

ClassMethod ApproveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ApproveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
