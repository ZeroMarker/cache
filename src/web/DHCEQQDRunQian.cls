Class web.DHCEQQDRunQian Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/********************************************************************/
/// Add By DJ 2013-12-30
/// 描述:固定资产月报
ClassMethod MonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod MonthReportExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set job=$J
 	k ^DHCEQTemp("MonthReport",job)
 	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
 	i (MonthStr="") Quit $$$OK
 	s CurYear=$p(MonthStr,"-",1)
 	s CurMonth=+$p(MonthStr,"-",2)
 	i CurMonth=1
 	{
	 	s PreYear=CurYear-1
	 	s PreMonth=12
 	}
 	else
 	{
	 	s PreYear=CurYear
	 	s PreMonth=CurMonth-1
 	}
 	s PreSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PreYear_"-"_PreMonth)
	s CurSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	
	s index=1
	
	i CurSnapID'=""  d
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID))  q:EQRowID=""  d
	..s InvalidFlag=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",59)
	..q:InvalidFlag="Y"
	..s EQStatus=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",38)
	..s EQStockStatus=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",60)
	..q:((EQStockStatus'=1)||(EQStatus>2))
	..s TEquipTypeDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",63)
	..s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..q:+result'=0
	..s StatCatDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",75)
	..s TransAssetDate=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",45)
	..s OriginalFee=$fn($p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",27),"",2)
	..s TStoreLocDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",67)
	..s TEquipName=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",1)
	..s TModelDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",3)
	..s TEquipeCatDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",4)
	..s TUnitDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",5)
	..s LimitYearsNum=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",31)
	..s DepreMethodDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",33)
	..s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,TStoreLocDR,TEquipName,+TModelDR,+TEquipeCatDR,+TUnitDR,TransAssetDate,+DepreMethodDR,+LimitYearsNum,OriginalFee,1)=1+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,TStoreLocDR,TEquipName,+TModelDR,+TEquipeCatDR,+TUnitDR,TransAssetDate,+DepreMethodDR,+LimitYearsNum,OriginalFee,1))
	e  d
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQEquip(EQRowID))  q:EQRowID=""  d
	..s InvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	..q:InvalidFlag="Y"
	..s EQStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	..s EQStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	..q:((EQStockStatus'=1)||(EQStatus>2))
	..s TEquipTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",63)
	..s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..q:+result'=0
	..s StatCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",75)
	..s TransAssetDate=$p($g(^DHCEQEquip(EQRowID)),"^",45)
	..s OriginalFee=$fn($p($g(^DHCEQEquip(EQRowID)),"^",27),"",2)
	..s TStoreLocDR=$p($g(^DHCEQEquip(EQRowID)),"^",67)
	..s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	..s TModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
	..s TEquipeCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",4)
	..s TUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
	..s LimitYearsNum=$p($g(^DHCEQEquip(EQRowID)),"^",31)
	..s DepreMethodDR=$p($g(^DHCEQEquip(EQRowID)),"^",33)
	..s ^DHCEQTemp("MonthReport",job,TEquipTypeDR,TStoreLocDR,TEquipName,+TModelDR,+TEquipeCatDR,+TUnitDR,TransAssetDate,+DepreMethodDR,+LimitYearsNum,OriginalFee,1)=1+$g(^DHCEQTemp("MonthReport",job,TEquipTypeDR,TStoreLocDR,TEquipName,+TModelDR,+TEquipeCatDR,+TUnitDR,TransAssetDate,+DepreMethodDR,+LimitYearsNum,OriginalFee,1))
	
	//输出明细汇总
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR))  q:EquipTypeDR=""  d
	.d ResetVariablesGetMonthReport
	.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s StoreLocDR=0
	.f  s StoreLocDR=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR))  q:StoreLocDR=""  d
	..s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	..i TStoreLoc'="" s TStoreLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag(TStoreLoc,"-")
	..s EquipName=""
	..f  s EquipName=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName))  q:EquipName=""  d
	...s TEquipName=EquipName
	...s ModelDR=""
	...f  s ModelDR=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR))  q:ModelDR=""  d
	....s TModel=$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	....s EquipeCatDR=""
	....f  s EquipeCatDR=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR,EquipeCatDR))  q:EquipeCatDR=""  d
	.....s TEquipeCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipeCatDR)),"^",2)
	.....s UnitDR=""
	.....f  s UnitDR=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR,EquipeCatDR,UnitDR))  q:UnitDR=""  d
	......s TUnit=$p($g(^DHCEQCCode("DHCEQCUOM",UnitDR)),"^",2)
	......s TransAssetDate=0
	......f  s TransAssetDate=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR,EquipeCatDR,UnitDR,TransAssetDate))  q:TransAssetDate=""  d
	.......s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
	.......s DepreMethodDR=""
	.......f  s DepreMethodDR=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR,EquipeCatDR,UnitDR,TransAssetDate,DepreMethodDR))  q:DepreMethodDR=""  d
	........s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	........s LimitYearsNum=""
	........f  s LimitYearsNum=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR,EquipeCatDR,UnitDR,TransAssetDate,DepreMethodDR,LimitYearsNum)) q:LimitYearsNum=""  d
	.........s TLimitYearsNum=LimitYearsNum
	.........s OriginalFee=0
	.........f  s OriginalFee=$o(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR,EquipeCatDR,UnitDR,TransAssetDate,DepreMethodDR,LimitYearsNum,OriginalFee))  q:OriginalFee=""  d
	..........s TQuantity=$g(^DHCEQTemp("MonthReport",job,EquipTypeDR,StoreLocDR,EquipName,ModelDR,EquipeCatDR,UnitDR,TransAssetDate,DepreMethodDR,LimitYearsNum,OriginalFee,1))
	..........s TOriginalFee=$fn(OriginalFee,"",2)
	..........s TAmount=$fn(TQuantity*TOriginalFee,"",2)
	..........d OutputRowGetMonthReport
	
	//输出结束删除临时global
	k ^DHCEQTemp("MonthReport",job)
	
	Quit $$$OK
OutputRowGetMonthReport
	s Data=$lb(TEquipType,TStoreLoc,TEquipName,TTransAssetDate,TDepreMethod,TLimitYearsNum,TQuantity,TOriginalFee,TAmount,TModel,TEquipeCat,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMonthReport
	s (TEquipType,TStoreLoc,TEquipName,TTransAssetDate,TDepreMethod,TLimitYearsNum,TQuantity,TOriginalFee,TAmount,TModel,TEquipeCat,TUnit)=""
	quit
}

ClassMethod MonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthReportExecute ]
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

Query MonthReport(MonthStr As %String = "", QXType As %String = "", UseLocDR As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TEquipType:%String,TStoreLoc:%String,TEquipName:%String,TTransAssetDate:%String,TDepreMethod:%String,TLimitYearsNum:%String,TQuantity:%String,TOriginalFee:%String,TAmount:%String,TModel:%String,TEquipeCat:%String,TUnit:%String") [ SqlProc ]
{
}

/*************************************************************/
/// Add By DJ 2016-09-27
/// 描述:无形资产摊销
Query WXAssetsDepre(vMonthStr As %String = "", vEquipTypeDR As %String = "", vFundsTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TMonth:%String,TEQNo:%String,TEqName:%String,TModel:%String,TEquipTypeDR:%String,TEquipType:%String,TEquipCatCode:%String,TEquipCatDesc:%String,TOriginalFee:%String,TNetFee:%String,TDepreTotalFee:%String,TDepreFee:%String,TLimitYearsNum:%String,TTransassetDate:%String,TStartDate:%String,TStoreLoc:%String,TFundsTypeDR:%String,TFundsType:%String,TGroup:%String,TInStockListDR:%String") [ SqlProc ]
{
}

ClassMethod WXAssetsDepreExecute(ByRef qHandle As %Binary, vMonthStr As %String = "", vEquipTypeDR As %String = "", vFundsTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s CurSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(vMonthStr)
 	i (vMonthStr="")||(CurSnapID="") Quit $$$OK
 	//获取当月无形资产折旧摊销明细
 	s TGInStockListDRs=",10986,12140,12142,13041,"
 	s StoreLocDR=0
 	f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreInStock",StoreLocDR))  q:StoreLocDR=""  d
 	.s EquipTypeDR=0
 	.f  s EquipTypeDR=$o(^DHCEQEquip(0,"StoreInStock",StoreLocDR,EquipTypeDR))  q:EquipTypeDR=""  d
 	..q:(vEquipTypeDR'="")&&(EquipTypeDR'=vEquipTypeDR)
 	..s StockStatus=""
 	..f  s StockStatus=$o(^DHCEQEquip(0,"StoreInStock",StoreLocDR,EquipTypeDR,StockStatus))  q:StockStatus=""  d
 	...q:StockStatus'=1
 	...s InStockListDR=""
 	...f  s InStockListDR=$o(^DHCEQEquip(0,"StoreInStock",StoreLocDR,EquipTypeDR,StockStatus,"N",InStockListDR))  q:InStockListDR=""  d
 	....s EQRowID=0
 	....f  s EQRowID=$o(^DHCEQEquip(0,"StoreInStock",StoreLocDR,EquipTypeDR,StockStatus,"N",InStockListDR,EQRowID))  q:EQRowID=""  d
 	.....d ResetVariablesGetWXAssetsDepre
 	.....s EQInvalidFlag=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",59)
 	.....q:EQInvalidFlag="Y"
 	.....s TInStockListDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",70)
 	.....s TEQNo=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",71)		//设备编号
 	.....s TEqName=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",1)		//设备名称
 	.....s TModel=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",3)		//规格型号
 	.....i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
 	.....s TEquipTypeDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",63)	//设备类组
 	.....i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
 	.....s TEquipCatDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",4)	//设备分类
 	.....i TEquipCatDR'=""  d
 	......s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
 	......s TEquipCatDesc=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
 	.....s TOriginalFee=$fn($p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",27),"",2) //设备原值
 	.....s TNetFee=$fn($p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",28),"",2)		//净值
 	.....s TDepreTotalFee=$fn($p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",35),"",2)	//累计折旧
 	.....s TLimitYearsNum=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",31)	//使用年限
 	.....s TTransassetDate=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",45)	//转资日期
 	.....s TTransassetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
 	.....s TStartDate=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",44)			//启用日期
 	.....s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
 	.....s TStoreLocDR=$p($g(^DHCEQSnapShot(CurSnapID,"Equip",EQRowID)),"^",67)	//使用科室
 	.....i TStoreLocDR'="" s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
 	.....s TMonth=vMonthStr
 	.....s TGroup="0"
 	.....i (TGInStockListDRs[(","_TInStockListDR_",")) s TGroup="1"
 	.....i '$D(^DHCEQMonthDepre(0,"EquipMonth",EQRowID,vMonthStr))  d
 	......d OutputRowGetWXAssetsDepre
 	.....e  d
 	......s MDRowID=0
 	......f  s MDRowID=$o(^DHCEQMonthDepre(0,"EquipMonth",EQRowID,vMonthStr,MDRowID))  q:MDRowID=""  d
 	.......s TDepreFee=$fn($p($g(^DHCEQMonthDepre(MDRowID)),"^",14),"",2)
 	.......d OutputRowGetWXAssetsDepre
 	
 	
	Quit $$$OK
OutputRowGetWXAssetsDepre
	s Data=$lb(TMonth,TEQNo,TEqName,TModel,TEquipTypeDR,TEquipType,TEquipCatCode,TEquipCatDesc,TOriginalFee,TNetFee,TDepreTotalFee,TDepreFee,TLimitYearsNum,TTransassetDate,TStartDate,TStoreLoc,TFundsTypeDR,TFundsType,TGroup,TInStockListDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetWXAssetsDepre
	s (TMonth,TEQNo,TEqName,TModel,TEquipTypeDR,TEquipType,TEquipCatCode,TEquipCatDesc,TOriginalFee,TNetFee,TDepreTotalFee,TDepreFee,TLimitYearsNum,TTransassetDate,TStartDate,TStoreLoc,TFundsTypeDR,TFundsType,TGroup,TInStockListDR)=""
	quit
}

ClassMethod WXAssetsDepreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WXAssetsDepreExecute ]
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

ClassMethod WXAssetsDepreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WXAssetsDepreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/******************************************************/
/// Add By MWZ 2020-03-08 MWZ0028
/// 描述:报废设备明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQQDRunQian","GetDisuseRequestDetail","","","","","","")
Query GetDisuseRequestDetail(RequestNo As %String = "", No As %String = "", MinPrice As %String = "", MaxPrice As %String = "", vStatus As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", EquipTypeDR As %String = "", SAuditDate As %String = "", EAuditDate As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDRRowID:%String,TRequestNo:%String,TRequestDate:%String,TRequestLoc:%String,TUserLoc:%String,TEquip:%String,TNo:%String,TOriginalFee:%String,TQuantityNum:%String,TEquipType:%String,TStatus:%String,TUnit:%String,TInStockNo:%String,TModel:%String,TTransAssetDate:%String,TStartDate:%String,TNetFee:%String,FundsDepreFee:%String,FundsType:%String,FundsNetFee:%String") [ SqlProc ]
{
}

ClassMethod GetDisuseRequestDetailExecute(ByRef qHandle As %Binary, RequestNo As %String = "", No As %String = "", MinPrice As %String = "", MaxPrice As %String = "", vStatus As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", EquipTypeDR As %String = "", SAuditDate As %String = "", EAuditDate As %String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	If StartDate'="" Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")		//modified by czf 1231517 2020-04-01 begin
	If EndDate'="" Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	If StartDate="" Set StartDate=0
 	If EndDate="" Set EndDate=+$H
 	
 	If SAuditDate'="" Set SAuditDate=##class(web.DHCEQCommon).TransValueFromPage(SAuditDate,"date")
	If EAuditDate'="" Set EAuditDate=##class(web.DHCEQCommon).TransValueFromPage(EAuditDate,"date")
 	If SAuditDate="" Set SAuditDate=0
 	If EAuditDate="" Set EAuditDate=+$H
	Set index=1
	s ApproveRoleID=##class(web.DHCEQCommon).GetSysInfo("601003")  //哪个角色审批时作为院内审批完成
	
	Set DRLRowID=0
	For  Set DRLRowID=$Order(^DHCEQDisuseRequestList(DRLRowID)) Quit:DRLRowID=""  Do
	.Do ResetVariablesGetDisuseRequestDetail
	.s TRowID=DRLRowID
	.Set TDRRowID=$Piece($Get(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
	.Set TEquipDR=$Piece($Get(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	.Set TRequestNo=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",33)
	.Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",63)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
	.q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.Set TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.Quit:(RequestNo'="")&&(TRequestNo'=RequestNo)
	.Set TInStockNo=""
	.Set TInStockListDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",70)
	.If TInStockListDR'="" Do
	..Set TISRowID=$Piece($Get(^DHCEQInStockList(TInStockListDR)),"^",1)
	..Set TInStockNo=$Piece($Get(^DHCEQInStock(TISRowID)),"^",14)
	.Set TEquip=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	.Set TNo=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	.Quit:(No'="")&&(TNo'[$ZCONVERT(No,"U"))
	.Set TOriginalFee=+$fn($Piece($Get(^DHCEQEquip(TEquipDR)),"^",27),"",2)
	.Quit:(+MinPrice'=0)&&(TOriginalFee<+MinPrice)
	.Quit:(+MaxPrice'=0)&&(TOriginalFee>+MaxPrice)
	.Set TStatus=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",10)
	.s TApproveRoleDR = $p($g(^DHCEQDisuseRequest(TDRRowID)),"^",31)
	.q:(ApproveRoleID'=TApproveRoleDR) 		//modified by QW20210130 BUG:QW0091 需求号:1748097
	.Quit:(vStatus'="")&&(TStatus'=vStatus)
	.Set TStatus=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.Set TRequestLocDR=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",3)
	.If TRequestLocDR'="" Set TRequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
	.If TRequestLoc'="" Set TRequestLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TRequestLoc,"-")
	.Set TUserLocDR=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",34)
	.If TUserLocDR'="" Set TUserLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUserLocDR)
	.If TUserLoc'="" Set TUserLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUserLoc,"-")
	.Set TEquipTypeDR=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",43)
	.Set TRequestDate=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",4)
	.Set TInvalidFlag=$Piece($Get(^DHCEQDisuseRequest(TDRRowID)),"^",53)	
	.Quit:TInvalidFlag="Y"
	.Quit:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	.If TRequestDate'="" Set TRequestDate=$ZD(TRequestDate,3)
	.;Modified By QW20210917 BUG:QW0151 修改审批时间取值错误 begin  
	.Set ApproveType=##class(web.DHCEQMessages).GetApproveTypeByBussType(34)
	.Set ALRowID=$Order(^DHCEQApproveList(0,"Source",ApproveType,TDRRowID,""),-1)
	.Set TAuditDate=$Piece($Get(^DHCEQApproveList(ALRowID)),"^",7)
	.;Modified By QW20210917 BUG:QW0151  end
	.Quit:(TAuditDate>EAuditDate)||(TAuditDate<SAuditDate)
	.Set TUnitDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",5)
	.If TUnitDR'="" Set TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.Set TModelDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",3)
	.If TModelDR'="" Set TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.Set TTransAssetDate=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",45)
	.If TTransAssetDate'="" Set TTransAssetDate=$ZD(TTransAssetDate,3)
	.Set TStartDate=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",44)
	.If TStartDate'="" Set TStartDate=$ZD(TStartDate,3)
	.Set TNetFee=+$fn($Piece($Get(^DHCEQEquip(TEquipDR)),"^",28),"",2)
	.Set TQuantityNum=1
	.Do OutputRowGetDisuseRequestDetail

	Quit $$$OK
OutputRowGetDisuseRequestDetail
	Set Data=$lb(TRowID,TDRRowID,TRequestNo,TRequestDate,TRequestLoc,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TEquipType,TStatus,TUnit,TInStockNo,TModel,TTransAssetDate,TStartDate,TNetFee,FundsDepreFee,FundsType,FundsNetFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	Quit
ResetVariablesGetDisuseRequestDetail
	Set (TRowID,TDRRowID,TRequestNo,TRequestDate,TRequestLoc,TUserLoc,TEquip,TNo,TOriginalFee,TQuantityNum,TEquipType,TStatus,TUnit,TInStockNo,TModel,TTransAssetDate,TStartDate,TNetFee,FundsDepreFee,FundsType,FundsNetFee)=""
	Quit
}

ClassMethod GetDisuseRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
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

ClassMethod GetDisuseRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ////////////////////////////////////////////////////////////////////////////////////////////
/// d ##class(%ResultSet).RunQuery("web.DHCEQQDRunQian","FTMonthReport","2019-04","","85")
Query FTMonthReport(MonthStr As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipTypeDR:%String,TStatCatDR:%String,TLocDR:%String,TOriginDR:%String,TFundsTypeDR:%String,TEquipType:%String,TStatCat:%String,TLoc:%String,TOrigin:%String,TFundsType:%String,TUsedBegin:%String,TStockBegin:%String,TUsedEnd:%String,TStockEnd:%String,TDepre:%String,TNetFee:%String,TDepreTotal:%String,TStockIn:%String,TStockReturn:%String,TDisuseDepre:%String,TDisuseNDepre:%String,TReduce:%String,TCATotalDepre:%String,TChangeAccount:%String,TAdjustData:%String") [ SqlProc ]
{
}

ClassMethod FTMonthReportExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i MonthStr="" Quit $$$OK
	//月结数据
	s MRLYear=$p(MonthStr,"-",1)
	s MRLMonth=+$p(MonthStr,"-",2)
	s MRLEquipTypeDR=0
	f  s MRLEquipTypeDR=$o(^DHCEQMonthReportList(0,"YearMonth",MRLYear,MRLMonth,MRLEquipTypeDR))  q:MRLEquipTypeDR=""  d
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(MRLEquipTypeDR,CurGroupID)'=0
	.s MRLRowID=0
	.f  s MRLRowID=$o(^DHCEQMonthReportList(0,"YearMonth",MRLYear,MRLMonth,MRLEquipTypeDR,MRLRowID))  q:MRLRowID=""  d
	..d ResetVariablesFTMonthReport
	..s TRowID="MRL_"_MRLRowID
	..s TFinanceType=""
	..s TFinanceTypeDR=$p($g(^DHCEQCCode("DHCEQCEquipType",MRLEquipTypeDR)),"^",9)
	..i TFinanceTypeDR'="" s TFinanceType=$p($g(^DHCEQCCode("DHCEQCFinanceType",TFinanceTypeDR)),"^",2)
	..i MRLYear>=2019  d		//2019年新会计制度调整后按照财务大类汇总统计
	...s TEquipTypeDR=TFinanceTypeDR
	...s TEquipType=TFinanceType
	..e  d						//2019年之前按照类组汇总统计
	...s TEquipTypeDR=MRLEquipTypeDR
	...s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	..s TStatCatDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",5)
	..i TStatCatDR'="" s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	..s TOriginDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",26)
	..i TOriginDR'="" s TOrigin=##Class(web.DHCEQCommon).GetTrakNameByID("origin",TOriginDR)
	..s TLocDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",3)
	..i TLocDR'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	..s TFundsTypeDR=$p($g(^DHCEQMonthReportList(MRLRowID)),"^",38)
	..i TFundsTypeDR'="" s TFundsType=##Class(web.DHCEQCommon).GetTrakNameByID("fundstype",TFundsTypeDR)
	..s TUsedBegin=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",13))
	..s TStockBegin=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",6))
	..s TUsedEnd=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",19))
	..s TStockEnd=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",12))
	..s TDepre=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",29))
	..s TNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",33))
	..s TDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",28))
	..s TStockIn=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",7))
	..s TStockReturn=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",8))
	..s TStockReduce=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",9))
	..s TUsedReduce=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",35))
	..s TReduce=TStockReduce+TUsedReduce
	..s TStockCATotalDepre=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",39))
	..s TUsedCATotalDepre=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",40))
	..s TCATotalDepre=TStockCATotalDepre+TUsedCATotalDepre
	..s TStockChange=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",34))
	..s TUsedChange=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",25))
	..s TChangeAccount=TStockChange+TUsedChange
	..s TUsedOther=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",37))
	..s TStockOther=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQMonthReportList(MRLRowID)),"^",36))
	..s TAdjustData=TUsedOther+TStockOther
	..d OutputRowFTMonthReport
	
	//报废数据(仅取当月报废设备对应已提累计折旧和未提折旧净值数据)
	i MRLMonth'=0
	{
		s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
		s StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
		s EndDate=$p(StartDate,"^",2)
		s StartDate=$p(StartDate,"^",1)
		
		s EquipType=0
		f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""  d
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)'=0
		.s BillDate=StartDate-1
		.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
		..s rowid=0
		..f  s rowid=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
		...s DRInvalidFlag=$p($g(^DHCEQDisuseRequest(rowid)),"^",53)
		...q:DRInvalidFlag="Y"
		...s DRStatus=$p($g(^DHCEQDisuseRequest(rowid)),"^",10)
		...q:DRStatus'=2
		...s StoreLoc=$p($g(^DHCEQDisuseRequest(rowid)),"^",34)
		...s ListRowID=0
		...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) q:(ListRowID="")  d
		....s EquipID=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
		....q:$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'=""	// Mozy0217  2018-11-01	过滤设备配置的报废
		....s FundsID=0
		....f  s FundsID=$o(^DHCEQFunds(0,"Source",6,ListRowID,FundsID)) q:(FundsID="")  d
		.....q:$p(^DHCEQFunds(FundsID),"^",10)="Y"		;F_InvalidFlag
		.....q:$p(^DHCEQFunds(FundsID),"^",6)="2"		;F_OperFlag
		.....d ResetVariablesFTMonthReport
		.....s TRowID="Dis"_FundsID
		.....s TFinanceType=""
		.....s TFinanceTypeDR=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",9)
		.....i TFinanceTypeDR'="" s TFinanceType=$p($g(^DHCEQCCode("DHCEQCFinanceType",TFinanceTypeDR)),"^",2)
		.....i MRLYear>=2019  d		//2019年新会计制度调整后按照财务大类汇总统计
		......s TEquipTypeDR=TFinanceTypeDR
		......s TEquipType=TFinanceType
		.....e  d						//2019年之前按照类组汇总统计
		......s TEquipTypeDR=EquipType
		......s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		.....s TFundsTypeDR=$p(^DHCEQFunds(FundsID),"^",2)
		.....i TFundsTypeDR="" s TFundsTypeDR=SelfFundsType
		.....s TFundsType=##Class(web.DHCEQCommon).GetTrakNameByID("fundstype",TFundsTypeDR)
		.....s FundsFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQFunds(FundsID)),"^",3))
		.....s TDisuseDepre=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQFunds(FundsID)),"^",13))
		.....s TDisuseNDepre=FundsFee-TDisuseDepre
		.....d OutputRowFTMonthReport
	}
	
    Quit $$$OK
ResetVariablesFTMonthReport
	s (TRowID,TEquipTypeDR,TStatCatDR,TLocDR,TOriginDR,TFundsTypeDR,TEquipType,TStatCat,TLoc,TOrigin,TFundsType,TUsedBegin,TStockBegin,TUsedEnd,TStockEnd,TDepre,TNetFee,TDepreTotal,TStockIn,TStockReturn,TDisuseDepre,TDisuseNDepre,TReduce,TCATotalDepre,TChangeAccount,TAdjustData)=""
	quit
OutputRowFTMonthReport
	s Data=$lb(TRowID,TEquipTypeDR,TStatCatDR,TLocDR,TOriginDR,TFundsTypeDR,TEquipType,TStatCat,TLoc,TOrigin,TFundsType,TUsedBegin,TStockBegin,TUsedEnd,TStockEnd,TDepre,TNetFee,TDepreTotal,TStockIn,TStockReturn,TDisuseDepre,TDisuseNDepre,TReduce,TCATotalDepre,TChangeAccount,TAdjustData)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod FTMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FTMonthReportExecute ]
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

ClassMethod FTMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FTMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
