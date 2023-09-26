/// Creator:add by czf
/// CreateDate:2021-08-31
/// Descrition:通用效益分析明细查询
Class web.DHCEQ.BA.RPTBaseList Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// czf 2020-08-07
/// 获取效益分析设备明细信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.RPTBaseList","GetBenefitEquip","2019-01","2019-12","","","","",12214,202,85,13383)
Query GetBenefitEquip(StartDate As %String = "", EndDate As %String = "", StoreLocDR As %String = "", StatCatDR As %String = "", ItemDR As %String = "", Type As %String = "", CurUserID As %String = "", CurLocID As %String = "", CurGroupID As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "TMonth:%String,TRowID:%String,TName:%String,TEquipNo:%String,TStoreLoc:%String,TStatCat:%String,TEquipCat:%String,TItem:%String,TModel:%String,TOriginalFee:%String,TFactualWorkLoad:%String,TWorkLoadPerMonth:%String,TInCome:%String,TConsumableFee:%String,TPersonFee:%String,TWEFee:%String,THouseFee:%String,TMaintFee:%String,TMaintainFee:%String,TInSpectFee:%String,TMaintenanceFee:%String,TDepreFee:%String,TOutFee:%String,TInComeChainRatio:%String,TOutFeeChainRatio:%String,TInComeYearOnYearRate:%String,TOutFeeYearOnYearRate:%String,TOtherIncome:%String,TOutIncome:%String,TInIncome:%String,TEmergencyIncome:%String,TNewBornIncome:%String,THealthIncome:%String,TPerDayIncome:%String,TPerDayOutFee:%String,TInOutRate:%String,TCheckPerson:%String,TExposureNum:%String,TPositiveNum:%String,TServeConsumeFee:%String,TConsumeMaterialFee:%String,TTrainFee:%String,TMeasureFee:%String,TQualityControlFee:%String")
{
}

ClassMethod GetBenefitEquipExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", StoreLocDR As %String = "", StatCatDR As %String = "", ItemDR As %String = "", Type As %String = "", CurUserID As %String = "", CurLocID As %String = "", CurGroupID As %String = "", EquipDR As %String = "") As %Status
{
	//s ^tempczf("baeql")=$lb(StartDate,EndDate,StoreLocDR,StatCatDR,ItemDR,Type,CurGroupID,CurLocID,CurGroupID,EquipDR)
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Date=+$h
	
	i (StartDate="")||(EndDate="") Quit $$$OK
	i ($ZDH(StartDate_"-01",3)>$ZDH(EndDate_"-01",3)) Quit $$$OK
	
	i CurUserID="" s CurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
	
	i EquipDR'="" d
	.s rowid=EquipDR
	.d GetEQBenefitEquip
	e  d
	.s belrowid=0
	.f  s belrowid=$o(^DHCEQBenefitEquipList(belrowid))  quit:belrowid=""  d
	..s Datalist=$g(^DHCEQBenefitEquipList(belrowid))
	..s rowid=$p(Datalist,"^",1)
	..q:(EquipDR'="")&&(EquipDR'=rowid)
	..d GetEQBenefitEquip
	
	Quit $$$OK
GetEQBenefitEquip
	i rowid'="" d
 	.d ResetGetBenefitEquip
 	.s TRowID=rowid
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.q:InvalidFlag="Y"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:(StockStatus=0)||(StockStatus=3)
	.s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
	.q:EQStatus'=1
	.s TStoreLocID=$p($g(^DHCEQEquip(rowid)),"^",67)
	.q:(StoreLocDR'="")&&(StoreLocDR'=TStoreLocID)
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocID)
	.s TName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s TItemID=$p($g(^DHCEQEquip(rowid)),"^",7)
	.q:(ItemDR'="")&&(ItemDR'=TItemID)
	.s TItem=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItemID)
	.s TStatCatID=$p($g(^DHCEQEquip(rowid)),"^",75)
	.q:(StatCatDR'="")&&(StatCatDR'=TStatCatID)
	.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatID)
	.s TEquipCatID=$p($g(^DHCEQEquip(rowid)),"^",4)
	.s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatID)
	.s TOriginalFee=$fn($p($g(^DHCEQEquip(rowid)),"^",27),"",2)
	.s TEQNum=1
	.s TEquipNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.s TModelID=$p($g(^DHCEQEquip(rowid)),"^",3)
	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelID)
	.s vStart=$ZDH(StartDate_"-01",3)
	.s vEnd=$ZDH(EndDate_"-01",3)
	.f ID=vStart:1:vEnd  d
	..s TMonth=$E($ZD(ID,3),1,7)
	..s DaysNum=##class(web.DHCEQCommon).GetMonthEndDate(TMonth,"1")
	..s TFactualWorkLoad=+##Class(web.DHCEQ.BA.RPTCommon).EquipUseContext(rowid,"Workload",TMonth,TMonth)
	..s TWorkLoadPerMonth=+$p($g(^DHCEQEquip(rowid)),"^",84)
	..s TStandUseRate=$fn(+$p($g(^DHCEQEquip(rowid)),"^",92),"",2)
	..s TUseRate=0
	..i TWorkLoadPerMonth'=0  d
	...s TUseRate=$fn((TFactualWorkLoad/TWorkLoadPerMonth)*100,"",2)
	..s TCount=TFactualWorkLoad
	..;s TInCome=+##Class(web.DHCEQ.BA.STATReport).EquipUseContext(rowid,"InCome",TMonth,TMonth)
	..s TIncomeInfo=##Class(web.DHCEQ.BA.RPTCommon).AllInCome(rowid,TMonth,TMonth,"",CurLocID,CurGroupID)
	..s TInCome=+$p(TIncomeInfo,"^",1)		;总收入
	..s TOtherIncome=+$p(TIncomeInfo,"^",2)	;其他收入 
	..s TOutIncome=+$p(TIncomeInfo,"^",3)	;门诊收入
	..s TInIncome=+$p(TIncomeInfo,"^",4)		;住院收入
	..s TEmergencyIncome=+$p(TIncomeInfo,"^",5)	;急诊收入
	..s TNewBornIncome=+$p(TIncomeInfo,"^",6)	;
	..s THealthIncome=+$p(TIncomeInfo,"^",7)	;体检收入
	..s TCheckPerson=+$p(TIncomeInfo,"^",8)		;人次
	..s TExposureNum=+$p(TIncomeInfo,"^",9)		;曝光次数
	..s TPositiveNum=+$p(TIncomeInfo,"^",10)	;阳性例数
	..s TServeConsumeFee=+$p(TIncomeInfo,"^",11)	;服务使用消耗
	..i DaysNum'=0 s TPerDayIncome=##Class(web.DHCEQCommon).FormatNumber(TInCome/DaysNum,"",2)	;日均收入
	..s TConsumeMaterialFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"13",TMonth,TMonth)	//消耗性材料
	..s TConsumableFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"14",TMonth,TMonth)	//耗材费
	..s TSumConsumableFee=TConsumableFee+TConsumeMaterialFee+TServeConsumeFee	
	..s TPersonFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"01",TMonth,TMonth)		//人员工资
	..s TTrainFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"02",TMonth,TMonth)			//培训费
	..s TPersonnelCost=TPersonFee+TTrainFee		//人工费
	..s TWaterFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"03",TMonth,TMonth)		//水费
	..s TElectricFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"04",TMonth,TMonth)	//电费
	..s TWEFee=TWaterFee+TElectricFee	//水电
	..s THouseFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"06",TMonth,TMonth)		//房屋折旧
	..s TMaintFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"07",TMonth,TMonth)		//维修
	..i TMaintFee=0 s TMaintFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"31", "",CurLocID,CurGroupID)
	..s TMaintainFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"09",TMonth,TMonth)	//保养
	..i TMaintainFee=0 s TMaintainFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"32", "",CurLocID,CurGroupID)
	..s TInSpectFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"10",TMonth,TMonth)		//检查
	..i TInSpectFee=0 s TInSpectFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33", "",CurLocID,CurGroupID,"4")
	..s TMeasureFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"11",TMonth,TMonth)		//计量费
	..i TMeasureFee=0 s TMeasureFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"33", "",CurLocID,CurGroupID,"5")
	..s TQualityControlFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"12",TMonth,TMonth)	//质控费
	..s TMaintenanceFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"08",TMonth,TMonth)	//维保费	
	..s TSumMaintenanceFee=TMaintenanceFee+TMaintFee+TMaintainFee+TInSpectFee+TMeasureFee+TQualityControlFee											//维保费
	..s TDepreFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"05",TMonth,TMonth)		//折旧费
	..i TDepreFee=0 s TDepreFee=+##Class(web.DHCEQ.BA.RPTCommon).GetOutFeeByLifeInfo(rowid,TMonth,TMonth,"35", "",CurLocID,CurGroupID)
	..s TEquipResourceFee=+##Class(web.DHCEQ.BA.RPTCommon).EquipResourceFee(rowid,"",TMonth,TMonth)	//总资源费
	..s TOutFee=TSumConsumableFee+TPersonnelCost+TWEFee+THouseFee+TSumMaintenanceFee+TDepreFee	//总支出=耗材费+人员经费+水电+房屋折旧+维保费+折旧费
	..i DaysNum'=0 s TPerDayOutFee=##Class(web.DHCEQCommon).FormatNumber(TOutFee/DaysNum,"",2)	;日均支出
	..i TOutFee'=0  d
	...s TConsumableRate=##Class(web.DHCEQCommon).FormatNumber(TConsumableFee/TOutFee,"",2)
	...s TPersonRate=##Class(web.DHCEQCommon).FormatNumber(TPersonFee/TOutFee,"",2)
	...s TWERate=##Class(web.DHCEQCommon).FormatNumber(TWEFee/TOutFee,"",2)
	...s TMaintRate=##Class(web.DHCEQCommon).FormatNumber(TMaintFee/TOutFee,"",2)
	...s TMaintainRate=##Class(web.DHCEQCommon).FormatNumber(TMaintainFee/TOutFee,"",2)
	...s TInSpectRate=##Class(web.DHCEQCommon).FormatNumber(TInSpectFee/TOutFee,"",2)
	...s TDepreRate=##Class(web.DHCEQCommon).FormatNumber(TDepreFee/TOutFee,"",2)
	...s THouseRate=##Class(web.DHCEQCommon).FormatNumber(THouseFee/TOutFee,"",2)
	...s TInOutRate=##Class(web.DHCEQCommon).FormatNumber(TInCome/TOutFee,"",2)		//收支比
	..;获取环比信息
	..s LastPeriod=##Class(web.DHCEQCommon).MonthStrAdd("M",-1,TMonth)
	..s LastRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(LastPeriod,LastPeriod,TRowID,"","","","")
	..s LastInCome=+$p(LastRtnStr,"^",3)
	..s LastOutFee=+$p(LastRtnStr,"^",13)
	..i LastInCome'=0 d
	...s TInComeChainRatio=(TInCome-LastInCome)/$ZABS(LastInCome)*100
	...s TInComeChainRatio=##Class(web.DHCEQCommon).FormatNumber(TInComeChainRatio,"",2)
	...s TInComeChainRatio=TInComeChainRatio_"%"
	..e  s TInComeChainRatio="--"
	..i LastOutFee'=0 d
	...s TOutFeeChainRatio=(TOutFee-LastOutFee)/$ZABS(LastOutFee)*100
	...s TOutFeeChainRatio=##Class(web.DHCEQCommon).FormatNumber(TOutFeeChainRatio,"",2)
	...s TOutFeeChainRatio=TOutFeeChainRatio_"%"
	..e  s TOutFeeChainRatio="--"
	..;获取同比信息
	..s CorrespondingPeriod=##Class(web.DHCEQCommon).MonthStrAdd("YYYY",-1,TMonth)
	..s CorrespondingRtnStr=##Class(web.DHCEQ.BA.RPTCommon).GetBenefitStr(CorrespondingPeriod,CorrespondingPeriod,TRowID,"","","","")
	..s CorrespondingInCome=+$p(CorrespondingRtnStr,"^",3)
	..s CorrespondingOutFee=+$p(CorrespondingRtnStr,"^",13)
	..i CorrespondingInCome'=0 d
	...s TInComeYearOnYearRate=(TInCome-CorrespondingInCome)/$ZABS(CorrespondingInCome)*100
	...s TInComeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(TInComeYearOnYearRate,"",2)
	...s TInComeYearOnYearRate=TInComeYearOnYearRate_"%"
	..e  s TInComeYearOnYearRate="--"
	..i CorrespondingOutFee'=0 d
	...s TOutFeeYearOnYearRate=(TOutFee-CorrespondingOutFee)/$ZABS(CorrespondingOutFee)*100
	...s TOutFeeYearOnYearRate=##Class(web.DHCEQCommon).FormatNumber(TOutFeeYearOnYearRate,"",2)
	...s TOutFeeYearOnYearRate=TOutFeeYearOnYearRate_"%"
	..e  s TOutFeeYearOnYearRate="--"
	..s vYear=$E($ZD(ID,3),1,4)
	..s vMonth=$E($ZD(ID,3),6,7)
	..i vMonth=12  d
	...s vYear=vYear+1
	...s vMonth=1
	..e  d
	...s vMonth=vMonth+1
	..s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	..d OutPutGetBenefitEquip

	quit
ResetGetBenefitEquip
	s (TRowID,TName,TEquipNo,TStoreLocID,TStoreLoc,TStatCatID,TStatCat,TEquipCatID,TEquipCat,TItemID,TItem,TModelID,TModel,TOriginalFee)=""
	s (TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TInComeChainRatio,TOutFeeChainRatio,TInComeYearOnYearRate,TOutFeeYearOnYearRate)=0
	s (TConsumableRate,TPersonRate,TWERate,TMaintRate,TMaintainRate,TInSpectRate,TDepreRate,THouseRate,TInOutRate)=0
	s (DaysNum,TIncomeInfo,TOtherIncome,TOutIncome,TInIncome,TEmergencyIncome,TNewBornIncome,THealthIncome,TPerDayIncome,TCheckPerson,TExposureNum)=0
	s (TPositiveNum,TServeConsumeFee,TConsumeMaterialFee,TTrainFee,TMeasureFee,TQualityControlFee)=0
	quit
	
OutPutGetBenefitEquip
	s Data=$lb(TMonth,TRowID,TName,TEquipNo,TStoreLoc,TStatCat,TEquipCat,TItem,TModel,TOriginalFee,TFactualWorkLoad,TWorkLoadPerMonth,TInCome,TConsumableFee,TPersonFee,TWEFee,THouseFee,TMaintFee,TMaintainFee,TInSpectFee,TMaintenanceFee,TDepreFee,TOutFee,TInComeChainRatio,TOutFeeChainRatio,TInComeYearOnYearRate,TOutFeeYearOnYearRate,TOtherIncome,TOutIncome,TInIncome,TEmergencyIncome,TNewBornIncome,THealthIncome,TPerDayIncome,TPerDayOutFee,TInOutRate,TCheckPerson,TExposureNum,TPositiveNum,TServeConsumeFee,TConsumeMaterialFee,TTrainFee,TMeasureFee,TQualityControlFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
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

ClassMethod GetBenefitEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zy 2020-02-18
/// 取效益设备的基本信息清单
/// 入参：vData:参数拼的字符串"^para1=value1^para2=value2^para3=value3"
///       NodeStr:  其他类中调用传入的一个临时golable节点
///       Job:      临时golable节点
///       CurTime:  临时golable节点
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.RPTBaseList","BAEquipList","")
Query BAEquipList(vData As %String = "", NodeStr As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquipName:%String,TModel:%String,TEquiCatDR:%String,TEquiCat:%String,TNo:%String,TStartdate:%String,TUseLocDR:%String,TUseLoc:%String,TManuFactory:%String,TOriginalFee:%String,TTransAssetDate:%String,TPurposeType:%String,TRegistrationNo:%String,TFunds:%String,TInitYear:%String,TPreWorkLoad:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TEquipStatus:%String,TEQRunState:%String,TEquipStatusDesc:%String,TEQRunStateDesc:%String") [ SqlProc ]
{
}

ClassMethod BAEquipListExecute(ByRef qHandle As %Binary, vData As %String = "", NodeStr As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set EquipDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipDR")
 	Set ItemDR=##class(web.DHCEQCommon).GetDataByName(vData,"ItemDR")
 	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set EquipCatDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
 	Set EquipName=##class(web.DHCEQCommon).GetDataByName(vData,"EquipName")
 	Set Model=##class(web.DHCEQCommon).GetDataByName(vData,"Model")
 	Set ManuFactory=##class(web.DHCEQCommon).GetDataByName(vData,"ManuFactory")
 	
 	if EquipDR'=""
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(0,"Equip",EquipDR,rowid)) q:rowid=""  d
	 	.d BAEquipList
	}
 	else
 	{
	 	s rowid=0
	 	f  s rowid=$o(^DHCEQBenefitEquipList(rowid)) q:rowid=""  d
	 	.d BAEquipList
	}
 	
 	Quit $$$OK
BAEquipList 	
 	d ResetVariablesBAEquipList
 	s BenefitEquipListData=$g(^DHCEQBenefitEquipList(rowid))
 	s TRowID=rowid
 	s TEquipDR=$p(BenefitEquipListData,"^",1)
 	s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)		             //设备名称
	q:(EquipName'="")&(TEquipName'[EquipName)
 	s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)		                 //规格型号
 	s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	q:(Model'="")&(TModel'[Model)
 	/// modified by ZY0260 20210428
	s TEquiCatDR = $p($g(^DHCEQEquip(TEquipDR)),"^",4)
	q:(EquipCatDR'="")&&(EquipCatDR'=TEquiCatDR)&&(##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,TEquiCatDR)=0)
 	s TEquiCat=##class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquiCatDR)
	
 	s TNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)	             //出厂编号
 	s TStartdate=$p($g(^DHCEQEquip(TEquipDR)),"^",44) 
 	s TStartdate=##class(web.DHCEQCommon).TransValueToPage(TStartdate,"date")                  //启用日期
 	s TUseLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",67)
 	q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
 	s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
 	s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	q:(ManuFactory'="")&(TManuFactory'[ManuFactory)
 	s TOriginalFee = $p($g(^DHCEQEquip(TEquipDR)),"^",27)
 	s TTransAssetDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)
 	s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
 	s TPurposeTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",65)
 	i TPurposeTypeDR'="" s TPurposeType=$p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
 	s TRegistrationNo=$p($g(^DHCEQEquip(TEquipDR)),"^",92)
 	Set Funds=##Class(web.DHCEQFunds).GetFundsInfo(1,TEquipDR)
	i Funds'="" d
	.Set n=$Length(Funds,";")
	.For i=1:1:n Do
	..If TFunds'="" Set TFunds=TFunds_"/"
	..Set TFunds=TFunds_$p($p(Funds,";",i),",",1)
	
 	s TInitYear=$p(BenefitEquipListData,"^",2)
 	s TPreWorkLoad=$p(BenefitEquipListData,"^",3)
 	s TNewFunction=$p(BenefitEquipListData,"^",4)
 	s TSpecialService=$p(BenefitEquipListData,"^",5)
 	s TOtherSocial=$p(BenefitEquipListData,"^",6)
 	s TGraduateNum=$p(BenefitEquipListData,"^",7)
 	s TStaffNum=$p(BenefitEquipListData,"^",8)
 	s TOtherTasks=$p(BenefitEquipListData,"^",9)
 	s THold1=$p(BenefitEquipListData,"^",10)
 	s THold2=$p(BenefitEquipListData,"^",11)
 	s THold3=$p(BenefitEquipListData,"^",12)
 	s THold4=$p(BenefitEquipListData,"^",13)
 	s THold5=$p(BenefitEquipListData,"^",14)
 	s ObjEquip=##class(web.DHCDT3D.OnlineCheck).GetOneEquipOnlineData(TEquipDR,1)
 	s ObjEquip=ObjEquip.Data
 	s TEquipStatus=ObjEquip.EquipStatus
 	s TEQRunState=ObjEquip.EQRunState
 	s TEQRunState=1
 	s TEquipStatusDesc=ObjEquip.EquipStatusDesc
 	s TEQRunStateDesc=ObjEquip.EQRunStateDesc
 	d OutputRowBAEquipList
 	quit
OutputRowBAEquipList
	s Data=$lb(TRowID,TEquipDR,TEquipName,TModel,TEquiCatDR,TEquiCat,TNo,TStartdate,TUseLocDR,TUseLoc,TManuFactory,TOriginalFee,TTransAssetDate,TPurposeType,TRegistrationNo,TFunds,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5,TEquipStatus,TEQRunState,TEquipStatusDesc,TEQRunStateDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBAEquipList
	s (TRowID,TEquipDR,TEquipName,TModelDR,TModel,TEquiCat,TNo,TStartdate,TEquiCatDR,TUseLocDR,TUseLoc,TManuFactoryDR,TManuFactory,TOriginalFee,TTransAssetDate,TPurposeTypeDR,TPurposeType,TRegistrationNo,Funds,TFunds,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5,TEquipStatus,TEQRunState,TEquipStatusDesc,TEQRunStateDesc)=""
	quit
}

ClassMethod BAEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BAEquipListExecute ]
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

ClassMethod BAEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BAEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备效益分析记录
/// add by zy 2020-02-18
/// 入参：Year:YYYY    年度
///       MonthStr:YYYY-MM  年月
///       pLocDR            科室id
///       pEquipDR           设备id
/// 使用该query的报表:医疗设备科室使用评价,附件3：经济效益,附件1：设备使用情况
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.STATReport","UseContextList","")
Query UseContextList(pYear As %String = "", pMonth As %String = "", pEquipDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", HospID As %String = "", YearReport As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TEquipDR:%String,TExpectedSatis:%String,TActualSatis:%String,TPatientSatis:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,TTotalScore:%String,TBenefitAnalysis:%String,TUseEvaluation:%String,TBriefEvaluation:%String,TOverallEvaluation:%String,TIncome:%String,TPersonTime:%String,TActualWorkLoad:%String,TPositiveCases:%String,TRunTime:%String,TFailureTimes:%String,TMaintTimes:%String,TPMTimes:%String,TDetectionTimes:%String,TWaitingTimes:%String,TAverageWorkHour:%String,TActualWorkDays:%String,TFailureDays:%String,TUCHold1:%String,TUCHold2:%String,TUCHold3:%String,TUCHold4:%String,TUCHold5:%String") [ SqlProc ]
{
}

ClassMethod UseContextListExecute(ByRef qHandle As %Binary, pYear As %String = "", pMonth As %String = "", pEquipDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", HospID As %String = "", YearReport As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s (Year,Month)=""
 	s Year=pYear
 	s Month=pMonth
 	//if Year="" Quit $$$OK
	
	s EquipID=0
 	f  s EquipID=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID)) q:EquipID=""  d
	.q:(pEquipDR'="")&&(pEquipDR'=EquipID)
 	.//s BELRowID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID,0))
 	.//s TInitYear=""
 	.//i BELRowID'="" s TInitYear=+$p($g(^DHCEQBenefitEquipList(BELRowID)),"^",2)                    //分析初始年度
	.s UCYear=0
	.f  s UCYear=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear)) q:UCYear=""  d
	..q:(Year'="")&&(+UCYear'=+Year)
	..s UCMonth=""
	..f  s UCMonth=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear,UCMonth)) q:UCMonth=""  d
	...q:(Month'="")&&(+UCMonth'=+Month)
	...s UCRowID=0
	...f  s UCRowID=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,UCYear,UCMonth,UCRowID)) q:UCRowID=""  d
	....s UseContextData=$g(^DHCEQUseContext(UCRowID))
	....d BuildUseContextList
	
 	Quit $$$OK
 	
BuildUseContextList 
 	d ResetVariablesUseContextList
 	//q:$p(UseContextData,"^",44)="Y"
 	//q:$p(UseContextData,"^",45)'="2"
 	s TRowID=UCRowID
 	s TSummaryDR=$p(UseContextData,"^",1)
 	//q:(YearReport="Y")&&(TSummaryDR="") 
 	s TEquipDR=$p(UseContextData,"^",2)
 	s TYear=+$p(UseContextData,"^",3)                                   //输出统计年度
 	s TMonth=+$p(UseContextData,"^",4)                                  //输出统计月份
 	s TExpectedSatis=$p(UseContextData,"^",5)                          //预期满意度
 	s TActualSatis=$p(UseContextData,"^",6)                            //实际满意度
 	s TPatientSatis=$p(UseContextData,"^",7)                           //患者满意度
 	s TNewFunction=$p(UseContextData,"^",8)          //填补诊治空白
 	s TSpecialService=$p(UseContextData,"^",9)    //服务特殊人群
 	s TOtherSocial=$p(UseContextData,"^",10)         //其他社会效益
 	s TGraduateNum=$p(UseContextData,"^",11)         //培养研究生数量
 	s TStaffNum=$p(UseContextData,"^",12)               //培养进修人员数量
 	s TOtherTasks=$p(UseContextData,"^",13)           //承担的其他科研教学任务
 	s TTotalScore=$p(UseContextData,"^",14)                            //总分(得分)
 	s TBenefitAnalysis=$p(UseContextData,"^",15)                       //经济效益分析
 	s TUseEvaluation=$p(UseContextData,"^",16)                         //使用评价（维修维护、运行情况）
 	s TBriefEvaluation=$p(UseContextData,"^",17)                       //简要评价
 	s TOverallEvaluation=$p(UseContextData,"^",18)                     //总体评价
 	s TIncome=$p(UseContextData,"^",19)                                //设备收入
 	s TPersonTime=$p(UseContextData,"^",20)                            //检查人次
 	s TActualWorkLoad=$p(UseContextData,"^",21)                        //实际工作量
 	s TPositiveCases=$p(UseContextData,"^",22)                         //阳性例数
 	s TRunTime=$p(UseContextData,"^",23)                               //开机时间
 	s TFailureTimes=$p(UseContextData,"^",24)                          //故障次数
 	s TMaintTimes=$p(UseContextData,"^",25)                            //维修次数
 	s TPMTimes=$p(UseContextData,"^",26)                               //保养次数
 	s TDetectionTimes=$p(UseContextData,"^",27)                        //检测次数
 	s TWaitingTimes=$p(UseContextData,"^",28)                          //预约等待时间
 	s TAverageWorkHour=$p(UseContextData,"^",29)                       //平均工作小时/日
 	s TActualWorkDays=$p(UseContextData,"^",30)                        //实际工作天数
 	s TFailureDays=$p(UseContextData,"^",31)                           //故障天数（0.5天起计算）
 	s TUCHold1=$p(UseContextData,"^",46)
 	s TUCHold2=$p(UseContextData,"^",47)
 	s TUCHold3=$p(UseContextData,"^",48)
 	s TUCHold4=$p(UseContextData,"^",49)
 	s TUCHold5=$p(UseContextData,"^",50)
 	d OutputRowUseContextList
	quit
OutputRowUseContextList
	s Data=$lb(TRowID,TYear,TMonth,TEquipDR,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUseContextList
	s (TRowID,TYear,TMonth,TEquipDR,TExpectedSatis,TActualSatis,TPatientSatis,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)=""
 	quit
}

ClassMethod UseContextListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UseContextListExecute ]
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

ClassMethod UseContextListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UseContextListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取设备对应成本数据
/// add by zy 2020-02-18
/// 入参：	SourceType:		YYYY
/// 		SourceID:	YYYY-MM
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.STATReport","UsedResourceList")
Query UsedResourceList(pYear As %String = "", pMonthStr As %String = "", pSourceType As %String = "", pSourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TSourceType:%String,TSourceID:%String,TResourceTypeDR:%String,TPrice:%String,TQuantity:%String,TAmount:%String,TIsInputFlag:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
{
}

ClassMethod UsedResourceListExecute(ByRef qHandle As %Binary, pYear As %String = "", pMonthStr As %String = "", pSourceType As %String = "", pSourceID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (pSourceType="")||(pSourceID="") d
	.s rowid=0
	.f  s rowid=$o(^DHCEQUsedResource(rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQUsedResource(rowid))
	..d BuildDataList
	e  d
	.q:'$Data(^DHCEQUsedResource(0,"Source",pSourceType,pSourceID))
	.s rowid=0
	.f  s rowid=$o(^DHCEQUsedResource(0,"Source",pSourceType,pSourceID,rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQUsedResource(rowid))
	..d BuildDataList
	Quit $$$OK
BuildDataList
	d ResetVariablesUsedResourceList
	q:$p(DataList,"^",18)'="2"
	s TRowID = rowid	//rowid
	s TYear=$p(DataList,"^",1)
	q:(pYear'="")&&(pYear'=TYear)
	s TMonth=$p(DataList,"^",2)
	q:(pMonthStr'="")&&(pMonthStr'=TMonth)
	s TSourceType=$p(DataList,"^",3)
	s TSourceID=$p(DataList,"^",4)
	s TResourceTypeDR=$p(DataList,"^",5)
	s TPrice=$p(DataList,"^",6)
	s TQuantity=$p(DataList,"^",8)
	s TAmount=$p(DataList,"^",9)
	s TRemark=$p(DataList,"^",29)
	s TIsInputFlag=$p(DataList,"^",30)
	s THold1=$p(DataList,"^",30)
	s THold2=$p(DataList,"^",31)
	s THold3=$p(DataList,"^",32)
	s THold4=$p(DataList,"^",33)
	s THold5=$p(DataList,"^",34)
	d OutputRowUsedResourceList
	quit
OutputRowUsedResourceList
	s Data=$lb(TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceTypeDR,TPrice,TQuantity,TAmount,TIsInputFlag,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUsedResourceList
	s (TRowID,TYear,TMonth,TSourceType,TSourceID,TResourceTypeDR,TPrice,TQuantity,TAmount,TIsInputFlag,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod UsedResourceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UsedResourceListExecute ]
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

ClassMethod UsedResourceListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UsedResourceListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 取月份内的所有月份
/// add by zy 2020-02-18
/// 使用该query来设置效益分析报表的框架
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.STATReport","MonthList","2018-12","2019-11")
Query MonthList(pStartMonth As %String = "", pEndMonth As %String = "") As %Query(ROWSPEC = "TYear:%String,TMonth:%String") [ SqlProc ]
{
}

ClassMethod MonthListExecute(ByRef qHandle As %Binary, pStartMonth As %String = "", pEndMonth As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i (pStartMonth="")||(pEndMonth="") Quit $$$OK
	
	s StartDate=$ZDH(pStartMonth_"-01",3)
	s EndDate=$ZDH(pEndMonth_"-01",3)
	i StartDate>EndDate Quit $$$OK
	
	f Date=StartDate:1:EndDate  d
	.s TYear=+$E($ZD(Date,3),1,4)
	.s TMonth=+$E($ZD(Date,3),6,7)
	.d OutputRowMonthList
	.i TMonth=12  d
	..s TYear=TYear+1
	..s TMonth=1
	.e  d
	..s TMonth=TMonth+1
	.s Date=$ZDH(TYear_"-"_TMonth_"-01",3) - 1
 	Quit $$$OK
OutputRowMonthList
	s Data=$lb(TYear,TMonth)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MonthListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthListExecute ]
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

ClassMethod MonthListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 取期间内设备使用耗材信息
/// add by czf 2021-09-20
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.RPTBaseList","GetUseComsumable","101","2021-11","2021-11","","202","85")
Query GetUseComsumable(EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TMonth:%String,TServiceItemDesc:%String,TConsumableDesc:%String,TUOMDesc:%String,TQuantity:%String,TPrice:%String,TFee:%String") [ SqlProc ]
{
}

ClassMethod GetUseComsumableExecute(ByRef qHandle As %Binary, EquipDR As %String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "") As %Status
{
	new repid,index,rowid
	n start,end,limit		//2297885
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i (StartDate="")||(EndDate="")||(EquipDR="") Quit $$$OK
	i CurLocID="" s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i CurGroupID="" s CurGroupID=%session.Get("LOGON.GROUPID")
	
	s SYear=$p(StartDate,"-",1)
	s EYear=$p(EndDate,"-",1)
	s SMonth=$p(StartDate,"-",2)
	s EMonth=$p(EndDate,"-",2)
	s (TotalFee,URFee,WorkLoadNum,PURFee)=0
	
	s Year=0
	f  s Year=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year)) quit:(Year="")  d
	.q:(Year<SYear)||(Year>EYear)
	.s Month=0
	.f  s Month=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year,Month)) quit:Month=""  d
	..q:(SYear=Year)&(Month<SMonth)
	..q:(EYear=Year)&(Month>EMonth)
	..s URSRowID=0
	..f  s URSRowID=$o(^DHCEQUseRecordStat(0,"SourceMonth",1,EquipDR,Year,Month,URSRowID))  q:URSRowID=""  d
	...s UseLocID=$p($g(^DHCEQUseRecordStat(URSRowID)),"^",5)
	...q:(UseLocID'="")&&(##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLocID,CurLocID,CurGroupID)'=0)
	...s UCSRowID=0
	...f  s UCSRowID=$o(^DHCEQUseConsumableStat(0,"UseRecordstat",URSRowID,UCSRowID))  q:UCSRowID=""  d
	....d ResetVariablesUseComsumable
	....s TRowID=UCSRowID
	....s TYear=Year
	....s TMonth=Month
	....s TConsumableItemDR=$p($g(^DHCEQUseConsumableStat(TRowID)),"^",2)
	....s TConsumableUOMDR=$p($g(^DHCEQUseConsumableStat(TRowID)),"^",3)
	....s TQuantity=$p($g(^DHCEQUseConsumableStat(TRowID)),"^",4)
	....s TPrice=$p($g(^DHCEQUseConsumableStat(TRowID)),"^",5)
	....s TFee=$p($g(^DHCEQUseConsumableStat(TRowID)),"^",6)
	....s TServiceItemDR=$p($g(^DHCEQUseConsumableStat(TRowID)),"^",7)
	....s TServiceItemDesc=$p($g(^DHCEQCCode("DHCEQCServiceItem",TServiceItemDR)),"^",1)
	....s TConsumableDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItemDR)),"^",1)
	....s TUOMDesc=$p($g(^DHCEQCCode("DHCEQCUOM",TConsumableUOMDR)),"^",4)
	....d OutputRowUseComsumable
	
	s start=$ZDH(StartDate_"-01",3)
	s end=##Class(web.DHCEQCommon).DateAddInt("M",1,$ZDH(EndDate_"-01",3))-1
	s EQItem=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	s URRowID=0
	f  s URRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID)) q:URRowID=""  d
	.s UCIRowID=0
	.f  s UCIRowID=$o(^DHCEQUseConsumableItem(0,"UseRecord",URRowID,UCIRowID)) q:UCIRowID=""  d
	..s DataList=$g(^DHCEQUseConsumableItem(UCIRowID))
	..s UseDate=$p(DataList,"^",16)
	..q:(start>UseDate)||(end<UseDate)
	..s ConsumableItemID=$p(DataList,"^",2)
	..s TSourceType=$p($g(^DHCEQUseRecord(URRowID)),"^",1)
	..s TSourceID=$p($g(^DHCEQUseRecord(URRowID)),"^",2)
	..q:(TSourceType=1)&&(EquipDR'=TSourceID)
	..q:(TSourceType=2)&&(EQItem'=TSourceID)
	..q:(TSourceType'=1)&&(TSourceType'=2)
	..s Amount=+$p(DataList,"^",6)
	..d ResetVariablesUseComsumable
	..s TRowID=UCIRowID
	..s TYear=$p($zd(UseDate,3),"-",1)
	..s TMonth=$p($zd(UseDate,3),"-",2)
	..s TConsumableItemDR=$p(DataList,"^",2)
	..s TConsumableUOMDR=$p(DataList,"^",3)
	..s TQuantity=$p(DataList,"^",4)
	..s TPrice=$p(DataList,"^",5)
	..s TFee=$p(DataList,"^",6)
	..s TServiceItemDR=$p(DataList,"^",12)
	..i TServiceItemDR="" s TServiceItemDR=$p($g(^DHCEQUseRecord(URRowID)),"^",15)
	..s TServiceItemDesc=$p($g(^DHCEQCCode("DHCEQCServiceItem",TServiceItemDR)),"^",1)
	..s TConsumableDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",TConsumableItemDR)),"^",1)
	..s TUOMDesc=$p($g(^DHCEQCCode("DHCEQCUOM",TConsumableUOMDR)),"^",4)
	..d OutputRowUseComsumable
	
	Quit $$$OK
OutputRowUseComsumable
	s Data=$lb(TRowID,TYear,TMonth,TServiceItemDesc,TConsumableDesc,TUOMDesc,TQuantity,TPrice,TFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUseComsumable
	s (TRowID,TYear,TMonth,TConsumableItemDR,TConsumableUOMDR,TServiceItemDR,TServiceItemDesc,TConsumableDesc,TUOMDesc,TQuantity,TPrice,TFee)=""
	quit
}

ClassMethod GetUseComsumableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseComsumableExecute ]
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

ClassMethod GetUseComsumableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseComsumableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
