/// 该类已作废  JDL 20150828 V4.0
Class web.DHCEQExport Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 87;

/// "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,Origin:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TServiceHandler:%String,TServiceTel:%String,TStatCatDR:%String,TStatCat:%String,TModelDR:%String,TEquiCatDR:%String,TUnitDR:%String,TCountryDR:%String,TManageLocDR:%String,TManageLevelDR:%String,TWorkLoadUnitDR:%String,TUseLocDR:%String,TOriginDR:%String,TFromDeptDR:%String,TToDeptDR:%String,TBuyTypeDR:%String,TEquipTechLevelDR:%String,TProviderDR:%String,TManuFactoryDR:%String,TKeeperDR:%String,TEquipTypeDR:%String,TPurchaseTypeDR:%String,TPurposeTypeDR:%String"
Query GetExportList(BeginDate As %String = "", EndDate As %String = "", ExportType As %String = "", EquipTypeDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,Origin:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TServiceHandler:%String,TServiceTel:%String,TStatCatDR:%String,TStatCat:%String,ChangeDate:%String,ChangeFee:%String")
{
}

ClassMethod GetExportListExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", ExportType As %String = "", EquipTypeDR As %String = "") As %Status
{
	s gnum=1
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("ExportList",curuser)
	
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s index=1
 	
 	new StatCat,ChangeDate,EquipID,Origin,ChangeFee
 	if BeginDate="" Quit $$$OK
 	if EndDate="" s EndDate=+$H
 	s TQuantity=1
 	
	///增加数据
	i ((ExportType="")||(ExportType=1))
	{
		s ChangeDate=BeginDate-1		
		f  s ChangeDate=$o(^DHCEQInStock(0,"BillDate",ChangeDate))  quit:((ChangeDate="")||(ChangeDate>EndDate))  d
		.s StatCat=0
		.f  s StatCat=$o(^DHCEQInStock(0,"BillDate",ChangeDate,StatCat))  quit:(StatCat="")  d
		..s InStockID=0
		..f  s InStockID=$o(^DHCEQInStock(0,"BillDate",ChangeDate,StatCat,InStockID))  quit:(InStockID="")  d
		...s Origin=$p($g(^DHCEQInStock(InStockID)),"^",15)
		...i Origin'="" s Origin=$p($g(^DHCEQCCode("DHCEQCOrigin",Origin)),"^",2)
		...s InStockListID=0
		...f  s InStockListID=$o(^DHCEQInStockList(0,"InStock",InStockID,InStockListID))  quit:(InStockListID="")  d
		....s ChangeFee=$p($g(^DHCEQInStockList(InStockListID)),"^",7)
		....s ChangeStockID=0
		....f  s ChangeStockID=$o(^DHCEQChangeStock(0,"Source",0,InStockListID,ChangeStockID))  quit:(ChangeStockID="")  d
		.....s EquipID=$p($g(^DHCEQChangeStock(ChangeStockID)),"^",1)
		.....d FillExportDate
		.....///s TOriginalFee=
		.....q:((EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR))
		.....d OutputRowGetExportList
	}
	
	///原值变动
	s ChangeAccountID=0
	f  s ChangeAccountID=$o(^DHCEQChangeAccount(ChangeAccountID))  quit:(ChangeAccountID="")  d
	.s ChangeDate=$p($g(^DHCEQChangeAccount(ChangeAccountID)),"^",22)
	.q:((ChangeDate<BeginDate)||(ChangeDate>EndDate))
	.s EquipID=$p($g(^DHCEQChangeAccount(ChangeAccountID)),"^",1)
	.d FillExportDate
	.q:((EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR))
	.s ChangeFee=$p($g(^DHCEQChangeAccount(ChangeAccountID)),"^",2)
	.i ((ChangeFee>0)&&((ExportType="")||(ExportType=1)))  d
	..s Origin="原值变动"
	..d OutputRowGetExportList
	.e  i ((ChangeFee<0)&&((ExportType="")||(ExportType=2)))  d
	..s Origin="原值变动"
	..d OutputRowGetExportList
	
	///折旧数据
	i ((ExportType="")||(ExportType=3))
	{
		s Origin="计提折旧"
		s Loc=0
		f  s Loc=$o(^DHCEQMonthDepre(0,"Loc",Loc))  quit:(Loc="")  d
		.s ChangeDate=BeginDate-1
		.f  s ChangeDate=$o(^DHCEQMonthDepre(0,"Loc",Loc,ChangeDate))  quit:((ChangeDate="")||(ChangeDate>EndDate))  d
		..s MonthDepreID=0
		..f  s MonthDepreID=$o(^DHCEQMonthDepre(0,"Loc",Loc,ChangeDate,MonthDepreID))  quit:(MonthDepreID="")  d
		...s MDStatus=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",20)	//DJ0136
		...q:MDStatus="3"
		...s ChangeFee=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",14)
		...s EquipID=$p($g(^DHCEQMonthDepre(MonthDepreID)),"^",1)
		...d FillExportDate
		...s TStoreLoc=""
		...s TStoreLocDR = Loc
		...i TStoreLocDR '="" s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
		...q:((EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR))
		...d OutputRowGetExportList
	}
	
	///减少数据
	i ((ExportType="")||(ExportType=2))
	{
		s ChangeDate=BeginDate-1		
		f  s ChangeDate=$o(^DHCEQReturn(0,"AckDateStat",3,ChangeDate))  quit:((ChangeDate="")||(ChangeDate>EndDate))  d
		.s StatCat=0
		.f  s StatCat=$o(^DHCEQReturn(0,"AckDateStat",3,ChangeDate,StatCat))  quit:(StatCat="")  d
		..s ReturnID=0
		..f  s ReturnID=$o(^DHCEQReturn(0,"AckDateStat",3,ChangeDate,StatCat,ReturnID))  quit:(ReturnID="")  d
		...s Origin=$p($g(^DHCEQReturn(ReturnID)),"^",17)
		...i Origin'="" s Origin=$p($g(^DHCEQCCode("DHCEQCOutType",Origin)),"^",2)
		...q:Origin="报废"
		...s ReturnListID=0
		...f  s ReturnListID=$o(^DHCEQReturnList(0,"Return",ReturnID,ReturnListID))  quit:(ReturnListID="")  d
		....s ChangeStockID=0
		....f  s ChangeStockID=$o(^DHCEQChangeStock(0,"Source",2,ReturnListID,ChangeStockID))  quit:(ChangeStockID="")  d
		.....s EquipID=$p($g(^DHCEQChangeStock(ChangeStockID)),"^",1)
		.....d FillExportDate
		.....s ChangeFee=TOriginalFee
		.....q:((EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR))
		.....d OutputRowGetExportList
		
		s Origin="报废"
		s ChangeDate=BeginDate-1		
		f  s ChangeDate=$o(^DHCEQDisuseRequest(0,"AuditDateStatus",ChangeDate))  quit:((ChangeDate="")||(ChangeDate>EndDate))  d
		.s DisuseRequestID=0
		.f  s DisuseRequestID=$o(^DHCEQDisuseRequest(0,"AuditDateStatus",ChangeDate,2,DisuseRequestID))  quit:(DisuseRequestID="")  d
		..s DisuseRequestListID=0
		..f  s DisuseRequestListID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DisuseRequestID,DisuseRequestListID))  quit:(DisuseRequestListID="")  d
		...s EquipID=$p($g(^DHCEQDisuseRequestList(DisuseRequestListID)),"^",2)
		...d FillExportDate
		...s ChangeFee=TOriginalFee
		...q:((EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR))
		...d OutputRowGetExportList		
	}
		
	Quit $$$OK
	
FillExportDate
	s (TRowID,TName,TABCType,TModelDR,TEquiCatDR,TUnitDR,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TCountryDR,TManageLocDR,TManageLevelDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TWorkLoadUnitDR,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR,TKeeperDR,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TServiceHandler,TServiceTel,TStatCatDR,TStatCat,TDisplayStatus,TDisplayStockStatus)=""	
	s TRowID=EquipID
	s TName = $p($g(^DHCEQEquip(EquipID)),"^",1)
	s TABCType = $p($g(^DHCEQEquip(EquipID)),"^",2)
	s TModelDR = $p($g(^DHCEQEquip(EquipID)),"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TEquiCatDR = $p($g(^DHCEQEquip(EquipID)),"^",4)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	s TUnitDR = $p($g(^DHCEQEquip(EquipID)),"^",5)
	i TUnitDR '=""  d
	.s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TCode = $p($g(^DHCEQEquip(EquipID)),"^",6)
	s TDesc = $p($g(^DHCEQEquip(EquipID)),"^",7)
	s TInstallLocDR = $p($g(^DHCEQEquip(EquipID)),"^",8)
	i TInstallLocDR '=""  d
	.s TInstallLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TInstallLocDR)
	s TInstallDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",9),"date")
	s TLeaveFactoryNo = $p($g(^DHCEQEquip(EquipID)),"^",10)
	s TLeaveFactoryDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",11),"date")
	s TOpenCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",12),"date")
	s TCheckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",13),"date")
	s TMakeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",14),"date")
	s TComputerFlag = $p($g(^DHCEQEquip(EquipID)),"^",15)
	s TCountryDR = $p($g(^DHCEQEquip(EquipID)),"^",16)
	i TCountryDR '=""  d
	.s TCountry = ##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	s TManageLocDR = $p($g(^DHCEQEquip(EquipID)),"^",17)
	i TManageLocDR '=""  d
	.s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	s TManageLevelDR = $p($g(^DHCEQEquip(EquipID)),"^",18)
	i TManageLevelDR '=""  d
	.s TManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",TManageLevelDR)),"^",2)
	s TUseLocDR = $p($g(^DHCEQEquip(EquipID)),"^",19)
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TOriginDR = $p($g(^DHCEQEquip(EquipID)),"^",20)
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	s TFromDeptDR = $p($g(^DHCEQEquip(EquipID)),"^",21)
	i TFromDeptDR '=""  d
	.s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	s TToDeptDR = $p($g(^DHCEQEquip(EquipID)),"^",22)
	i TToDeptDR '=""  d
	.s TToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TToDeptDR)),"^",2)
	s TBuyTypeDR = $p($g(^DHCEQEquip(EquipID)),"^",23)
	i TBuyTypeDR '=""  d
	.s TBuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	s TEquipTechLevelDR = $p($g(^DHCEQEquip(EquipID)),"^",24)
	i TEquipTechLevelDR '=""  d
	.s TEquipTechLevel = $p($g(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	s TProviderDR = $p($g(^DHCEQEquip(EquipID)),"^",25)
	i TProviderDR '=""  d
	.s TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TManuFactoryDR = $p($g(^DHCEQEquip(EquipID)),"^",26)
	i TManuFactoryDR '=""  d
	.s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	s TOriginalFee = $p($g(^DHCEQEquip(EquipID)),"^",27)
	s TNetFee = $p($g(^DHCEQEquip(EquipID)),"^",28)
	s TNetRemainFee = $p($g(^DHCEQEquip(EquipID)),"^",29)
	s TGroupDR = $p($g(^DHCEQEquip(EquipID)),"^",30)
	i TGroupDR '=""  d
	.s TGroup =$p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TLimitYearsNum = $p($g(^DHCEQEquip(EquipID)),"^",31)
	s TContractListDR = $p($g(^DHCEQEquip(EquipID)),"^",32)
	i TContractListDR '=""  d
	.s TContractList = $p($g(^DHCEQContractList(TContractListDR)),"^",1)
	s TDepreMethodDR = $p($g(^DHCEQEquip(EquipID)),"^",33)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TRemark = $p($g(^DHCEQEquip(EquipID)),"^",34)
	s TDepreTotalFee = $p($g(^DHCEQEquip(EquipID)),"^",35)
	s TDesignWorkLoadNum = $p($g(^DHCEQEquip(EquipID)),"^",36)
	s TWorkLoadUnitDR = $p($g(^DHCEQEquip(EquipID)),"^",37)
	i TWorkLoadUnitDR '=""  d
	.s TWorkLoadUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	s TStatus = $p($g(^DHCEQEquip(EquipID)),"^",38)
	s TDisplayStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TStatus)
	s TManageUserDR = $p($g(^DHCEQEquip(EquipID)),"^",39)
	i TManageUserDR '=""  d
	.s TManageUser = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageUserDR)
	s TMaintUserDR = $p($g(^DHCEQEquip(EquipID)),"^",40)
	i TMaintUserDR '=""  d
	.s TMaintUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	s TProviderHandler = $p($g(^DHCEQEquip(EquipID)),"^",41)
	s TProviderTel = $p($g(^DHCEQEquip(EquipID)),"^",42)	
	s TAppendFeeTotalFee = $p($g(^DHCEQEquip(EquipID)),"^",43)
	s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",44),"date")
	s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",45),"date")
	s TGuaranteeFlag = $p($g(^DHCEQEquip(EquipID)),"^",46)
	s TInputFlag = $p($g(^DHCEQEquip(EquipID)),"^",47)
	s TTestFlag = $p($g(^DHCEQEquip(EquipID)),"^",48)
	s TMedicalFlag = $p($g(^DHCEQEquip(EquipID)),"^",49)
	s TGuaranteeStartDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",50),"date")
	s TGuaranteeEndDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",51),"date")
	s TAddUserDR = $p($g(^DHCEQEquip(EquipID)),"^",52)
	i TAddUserDR '=""  d
	.s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",53),"date")
	s TAddTime = $p($g(^DHCEQEquip(EquipID)),"^",54)
	s TUpdateUserDR = $p($g(^DHCEQEquip(EquipID)),"^",55)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",56),"date")
	s TUpdateTime = $p($g(^DHCEQEquip(EquipID)),"^",57)
	s TCurrencyDR = $p($g(^DHCEQEquip(EquipID)),"^",58)
	i TCurrencyDR '=""  d
	.s TCurrency = ##class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	s TInvalidFlag = $p($g(^DHCEQEquip(EquipID)),"^",59)
	s TStockStatus = $p($g(^DHCEQEquip(EquipID)),"^",60)
	s TDisplayStockStatus=##Class(web.DHCEQEquip).GetEquipStockStatusDisplay(TStockStatus)
	s TMemoryCode = $p($g(^DHCEQEquip(EquipID)),"^",61)
	s TUrgencyFlag = $p($g(^DHCEQEquip(EquipID)),"^",62)
	s TEquipTypeDR = $p($g(^DHCEQEquip(EquipID)),"^",63)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TPurchaseTypeDR = $p($g(^DHCEQEquip(EquipID)),"^",64)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TPurposeTypeDR = $p($g(^DHCEQEquip(EquipID)),"^",65)
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TKeeperDR = $p($g(^DHCEQEquip(EquipID)),"^",66)
	i TKeeperDR '=""  d
	.s TKeeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	s TStoreLocDR = $p($g(^DHCEQEquip(EquipID)),"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s TStartDepreMonth = $p($g(^DHCEQEquip(EquipID)),"^",68)
	s TServiceDR = $p($g(^DHCEQEquip(EquipID)),"^",69)
	i TServiceDR '=""  d
	.s TService = $p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)
	s TInStockListDR = $p($g(^DHCEQEquip(EquipID)),"^",70)
	i TInStockListDR '=""  d
	.s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	s TNo = $p($g(^DHCEQEquip(EquipID)),"^",71)
	s TServiceHandler = $p($g(^DHCEQEquip(EquipID)),"^",72)
	s TServiceTel = $p($g(^DHCEQEquip(EquipID)),"^",73)
	s TStatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	quit
	
OutputRowGetExportList
	//modified by zy 2017-03-02 ZY0159 日期格式统一调整
	s ChangeDate=##class(web.DHCEQCommon).TransValueToPage(ChangeDate,"date")
	s Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,Origin,TDisplayStatus,TDisplayStockStatus,TServiceHandler,TServiceTel,TStatCatDR,TStatCat,ChangeDate,ChangeFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	s ^DHCEQTemp("ExportList",curuser,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_Origin_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TServiceHandler_"^"_TServiceTel_"^"_ChangeDate_"^"_ChangeFee_"^"_TRowID
	s gnum=gnum+1
	quit
}

ClassMethod GetExportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExportListExecute ]
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

ClassMethod GetExportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetList(itmjs As %Library.String = "", itmjsex As %Library.String = "", curuser, gnum)
{
	///s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	///s str=^DHCEQTemp("ExportList",curuser,gnum)
  	///q str
  	q ^DHCEQTemp("ExportList",curuser,gnum)
}

ClassMethod GetNum()
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s gnum=$o(^DHCEQTemp("ExportList",curuser,""),-1)
  	q gnum
}

/// d ##Class(web.DHCEQExport).Test()
ClassMethod Test()
{
	s num=$o(^DHCEQTemp("ExportList",1,""),-1)
	for i=1:1:num w num_..GetList(1, num),!
}

/// /w ##Class(web.DHCEQExport).GetEquipInfoByType("01",2783)
ClassMethod GetEquipInfoByType(TypeInfo, EquipDR)
{
	///通用设备,专用设备,电气设备,仪器仪表及量具,文艺体育设备 是一样的
	new objEquip
	new result
	new OrgID,ModelID
	
	s OrgID="地坛医院???"
	s ModelID="176"
	
	s result=""
	if (##class(User.DHCEQEquip).%ExistsId(EquipDR))
	{
		Set objEquip = ##class(User.DHCEQEquip).%OpenId(EquipDR)
	}
	else
	{
		q result
	}
	
	///土地类
	if (TypeInfo="01")
	{
		s $p(result,"^",1)="529"		///单据标识(BillTag)
		s $p(result,"^",2)=ModelID		///单据模型(ModelID)
		s $p(result,"^",3)=1			///数量(QTY)
		s $p(result,"^",4)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",5)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",6)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",7)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",7)'="" s $p(result,"^",7)=$ZD($p(result,"^",7),3)
		s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
		s $p(result,"^",8)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",9)=$p(result,"^",7)			///取得日期(BuildDate)
		s $p(result,"^",10)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		s $p(result,"^",11)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",12)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",13)=objEquip.EQServiceHandler			///座落位置(ZuoLuoWeiZhi)
		s $p(result,"^",14)=0			///土地面积(TuDiMianJi)
		s $p(result,"^",15)=""			///地号(DiHao)
		s $p(result,"^",16)="有产权"			///产权形式(CQXSBH)
		s $p(result,"^",17)="原值"			///价值类型(ZCZTAJZXSBH）
		s $p(result,"^",18)="平方米"			///计量单位(XJLDW)
		s $p(result,"^",19)=0			///自用面积(SYFXFUMJ)
		s $p(result,"^",20)=0			///闲置面积(XZMJ)
		s $p(result,"^",21)=0			///出借面积(CJMJ)
		s $p(result,"^",22)=0			///出租面积(CZMJ)
		s $p(result,"^",23)=0			///经营面积(JYMJ)
		s $p(result,"^",24)=0			///其他面积(QTMJ)
		s $p(result,"^",25)=""			///出租单位(DW)
		s $p(result,"^",26)=objEquip.EQManageLocDR			///管理部门(SYBM)
		s $p(result,"^",27)=""			///出借单位(CJDW)
		s $p(result,"^",28)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",29)=""			///会计凭证号(KJPZH)
		s $p(result,"^",30)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",31)=""			///自筹(ZC)
		s $p(result,"^",32)=""			///权属证明(QSZM)
		s $p(result,"^",33)=""			///土地证号(TuDiZhengHao)
		s $p(result,"^",34)=""			///制单人(Operator)
		s $p(result,"^",35)="国有"			///权属性质(QSXZBM)
		s $p(result,"^",36)=""			///发证时间(FZSJ)
		s $p(result,"^",37)=""			///土地证载明面积(TDZZMMJ)
		s $p(result,"^",38)="TRUE"			///未处置(WCZ)
		s $p(result,"^",39)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",40)="FALSE"			///是否引用(SFYY)
	}
	
	///房屋建筑物
	if (TypeInfo="02")
	{
		s $p(result,"^",1)="528"		///单据标识(BillTag)
		s $p(result,"^",2)=ModelID		///单据模型(ModelID)		
		s $p(result,"^",3)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=1			///数量(QTY)
		s $p(result,"^",6)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		s $p(result,"^",7)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",8)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",8)'="" s $p(result,"^",8)=$ZD($p(result,"^",8),3)
		s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")
		s $p(result,"^",9)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",10)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",11)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",11)="不提折旧"	}		
		s $p(result,"^",12)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		
		s $p(result,"^",13)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",14)=""			///建筑结构ID(JianZhuJieGouId)
		s $p(result,"^",15)=0			///建筑面积(JianXZhuMianJi)	
		s $p(result,"^",16)=0			///使用面积(ShiYongMianJi)	
		s $p(result,"^",17)=0			///地下面积(DiXiaMianJi)
		s $p(result,"^",18)=objEquip.EQServiceHandler			///座落位置(ZuoLuoWeiZhi)
		s $p(result,"^",19)=$p(result,"^",8)			///取得日期(BuildDate)
		s $p(result,"^",20)="平方米"			///计量单位(XJLDW)
		s $p(result,"^",21)="有产权"			///产权形式(CQXSBH)
		s $p(result,"^",22)="原值"			///价值类型(ZCZTAJZXSBH）
		s $p(result,"^",23)=0			///自用面积(SYFXFUMJ)
		s $p(result,"^",24)=0			///出借面积(CJMJ)
		s $p(result,"^",25)=0			///出租面积(CZMJ)
		s $p(result,"^",26)=0			///经营面积(JYMJ)
		s $p(result,"^",27)=0			///闲置面积(XZMJ)
		s $p(result,"^",28)=0			///其他面积(QTMJ)
		s $p(result,"^",29)=""			///出租单位(DW)
		s $p(result,"^",30)=objEquip.EQManageLocDR			///管理部门(SYBM)
		s $p(result,"^",31)=""			///出借单位(CJDW)
		s $p(result,"^",32)=""			///会计凭证号(KJPZH)
		s $p(result,"^",33)=0			///机房面积(JZJSJJFMJ)
		s $p(result,"^",34)=0			///会议室面积(HYSMJ)
		s $p(result,"^",35)=0			///车库面积(CKMJ)
		s $p(result,"^",36)=0			///食堂面积(STYFMJ)
		s $p(result,"^",37)=0			///配电房面积(PDFMJ)
		s $p(result,"^",38)=$p(result,"^",8)			///投入使用时间(TRSYSJ)
		s $p(result,"^",39)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",40)=""			///自筹(ZC)
		s $p(result,"^",41)=""			///权属证明(QSZM)
		s $p(result,"^",42)=""			///权属证号(FangWuChanQuanZhengHao)
		s $p(result,"^",43)=""			///发证时间(FZSJ)
		s $p(result,"^",44)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",45)=""			///制单人(Operator)
		s $p(result,"^",46)="TRUE"			///未处置(WCZ)
		s $p(result,"^",47)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",48)="FALSE"			///是否引用(SFYY)
	}
	
	///通用设备
	if (TypeInfo="03")
	{
		s $p(result,"^",1)="765"		///单据标识(BillTag)			
		s $p(result,"^",2)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",3)=ModelID		///单据模型(ModelID)	
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",6)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",7)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",7)'="" s $p(result,"^",7)=$ZD($p(result,"^",7),3)
		s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
		s $p(result,"^",8)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",9)=$p(result,"^",8)			///取得日期(BuildDate)
		s $p(result,"^",10)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		s $p(result,"^",11)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",12)=objEquip.EQModelDR.MDesc			///规格型号(Spec)
		s $p(result,"^",13)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",14)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",15)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		s $p(result,"^",16)=1			///数量(QTY)
		s $p(result,"^",17)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",18)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",18)="不提折旧"	}
		s $p(result,"^",19)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",20)=""			///使用人(ZYIDSYR)
		s $p(result,"^",21)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",22)=""			///品牌(PinPai)
		s $p(result,"^",23)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",24)=""			///会计凭证号(KJPZH)
		s $p(result,"^",25)=""			///保修截至日(BXJZR)
		s $p(result,"^",26)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",27)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",28)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",29)=""			///制单人(Operator)
		s $p(result,"^",30)=""			///制单人(Operator)		
		s $p(result,"^",31)="TRUE"			///未处置(WCZ)
		s $p(result,"^",32)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",33)="FALSE"			///是否引用(SFYY)		
	}
	
	///专用设备
	if (TypeInfo="04")
	{
		s $p(result,"^",1)="766"		///单据标识(BillTag)			
		s $p(result,"^",2)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",3)=ModelID		///单据模型(ModelID)	
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",6)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",7)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",7)'="" s $p(result,"^",7)=$ZD($p(result,"^",7),3)
		s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
		s $p(result,"^",8)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",9)=$p(result,"^",8)			///取得日期(BuildDate)
		s $p(result,"^",10)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		s $p(result,"^",11)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",12)=objEquip.EQModelDR.MDesc			///规格型号(Spec)
		s $p(result,"^",13)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",14)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",15)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		s $p(result,"^",16)=1			///数量(QTY)
		s $p(result,"^",17)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",18)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",18)="不提折旧"	}
		s $p(result,"^",19)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",20)=""			///使用人(ZYIDSYR)
		s $p(result,"^",21)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",22)=""			///品牌(PinPai)
		s $p(result,"^",23)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",24)=""			///会计凭证号(KJPZH)
		s $p(result,"^",25)=""			///保修截至日(BXJZR)
		s $p(result,"^",26)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",27)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",28)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",29)=""			///制单人(Operator)
		s $p(result,"^",30)=""			///管理人(ZYIDGLR)
		s $p(result,"^",31)="TRUE"			///未处置(WCZ)
		s $p(result,"^",32)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",33)="FALSE"			///是否引用(SFYY)		
	}
	
	
	///交通运输设备
	if (TypeInfo="05")
	{
		s $p(result,"^",1)="527"		///单据标识(BillTag)
		s $p(result,"^",2)=1			///数量(QTY)
		s $p(result,"^",3)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		s $p(result,"^",4)=ModelID		///单据模型(ModelID)
		s $p(result,"^",5)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",6)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",7)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",8)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)		
		s $p(result,"^",9)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",9)'="" s $p(result,"^",9)=$ZD($p(result,"^",9),3)
		s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")
		s $p(result,"^",10)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",11)=$p(result,"^",9)			///取得日期(BuildDate)
		s $p(result,"^",12)=$p(result,"^",9)			///??使用日期(UseDate)
		s $p(result,"^",13)=objEquip.EQModelDR.MDesc			///规格型号(Spec)
		s $p(result,"^",14)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",15)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",16)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",16)="不提折旧"	}
		s $p(result,"^",17)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",18)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",19)=""			///使用人(ZYIDSYR)
		s $p(result,"^",20)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",21)=""			///车牌号(ChePaiHao)
		s $p(result,"^",22)=""			///发动机号(FaDongJiHao)
		s $p(result,"^",23)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",24)=""			///品牌(PinPai)
		s $p(result,"^",25)=""			///车架号(CJH)	
		s $p(result,"^",26)=""			///编制情况编号(BZQKBH)	
		s $p(result,"^",27)=""			///排气量(PQL)	
		s $p(result,"^",28)=""			///车辆产地编号(QCBH)
		s $p(result,"^",29)=""			///会计凭证号(KJPZH)
		s $p(result,"^",30)=""			///保修截至日(BXJZR)
		s $p(result,"^",31)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",32)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",33)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",34)=""			///车辆用途分类ID(CLYTFLid)
		s $p(result,"^",35)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",36)=""			///制单人(Operator)
		s $p(result,"^",37)=""			///管理人(ZYIDGLR)
		s $p(result,"^",38)="TRUE"			///未处置(WCZ)
		s $p(result,"^",39)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",40)="FALSE"			///是否引用(SFYY)		
	}
	
	///电气设备
	if (TypeInfo="06")
	{
		s $p(result,"^",1)="764"		///单据标识(BillTag)			
		s $p(result,"^",2)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",3)=ModelID		///单据模型(ModelID)	
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",6)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",7)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",7)'="" s $p(result,"^",7)=$ZD($p(result,"^",7),3)
		s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
		s $p(result,"^",8)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",9)=$p(result,"^",8)			///取得日期(BuildDate)
		s $p(result,"^",10)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		s $p(result,"^",11)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",12)=objEquip.EQModelDR.MDesc			///规格型号(Spec)
		s $p(result,"^",13)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",14)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",15)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		s $p(result,"^",16)=1			///数量(QTY)
		s $p(result,"^",17)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",18)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",18)="不提折旧"	}
		s $p(result,"^",19)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",20)=""			///使用人(ZYIDSYR)
		s $p(result,"^",21)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",22)=""			///品牌(PinPai)
		s $p(result,"^",23)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",24)=""			///会计凭证号(KJPZH)
		s $p(result,"^",25)=""			///保修截至日(BXJZR)
		s $p(result,"^",26)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",27)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",28)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",29)=""			///制单人(Operator)
		s $p(result,"^",30)=""			///管理人(ZYIDGLR)
		s $p(result,"^",31)="TRUE"			///未处置(WCZ)
		s $p(result,"^",32)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",33)="FALSE"			///是否引用(SFYY)		
	}
	
	///电子产品及通讯设备
	if (TypeInfo="07")
	{
		s $p(result,"^",1)="762"		///单据标识(BillTag)
		s $p(result,"^",2)=1			///数量(QTY)
		s $p(result,"^",3)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		s $p(result,"^",4)=ModelID		///单据模型(ModelID)				
		s $p(result,"^",5)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		
		
		s $p(result,"^",6)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",7)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",8)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",9)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",9)'="" s $p(result,"^",9)=$ZD($p(result,"^",9),3)
		s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")
		s $p(result,"^",10)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",11)=$p(result,"^",9)			///取得日期(BuildDate)
		s $p(result,"^",12)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		s $p(result,"^",13)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",14)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",15)=objEquip.EQModelDR.MDesc			///规格型号(Spec)				
		s $p(result,"^",16)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",17)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		
		
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",18)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",18)="不提折旧"	}
		s $p(result,"^",19)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",20)=""			///使用人(ZYIDSYR)
		s $p(result,"^",21)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",22)=""			///品牌(PinPai)
		s $p(result,"^",23)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",24)=""			///会计凭证号(KJPZH)
		s $p(result,"^",25)=""			///保修截至日(BXJZR)
		s $p(result,"^",26)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",27)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",28)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",29)=""			///制单人(Operator)
		s $p(result,"^",30)=""			///管理人(ZYIDGLR)
		s $p(result,"^",31)="TRUE"			///未处置(WCZ)
		s $p(result,"^",32)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",33)="FALSE"			///是否引用(SFYY)		
	}
	
	///仪器仪表及量具
	if (TypeInfo="08")
	{
		s $p(result,"^",1)="526"		///单据标识(BillTag)			
		s $p(result,"^",2)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",3)=ModelID		///单据模型(ModelID)	
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",6)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",7)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",7)'="" s $p(result,"^",7)=$ZD($p(result,"^",7),3)
		s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
		s $p(result,"^",8)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",9)=$p(result,"^",8)			///取得日期(BuildDate)
		s $p(result,"^",10)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		s $p(result,"^",11)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",12)=objEquip.EQModelDR.MDesc			///规格型号(Spec)
		s $p(result,"^",13)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",14)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",15)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		s $p(result,"^",16)=1			///数量(QTY)
		s $p(result,"^",17)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",18)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",18)="不提折旧"	}
		s $p(result,"^",19)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",20)=""			///使用人(ZYIDSYR)
		s $p(result,"^",21)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",22)=""			///品牌(PinPai)
		s $p(result,"^",23)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",24)=""			///会计凭证号(KJPZH)
		s $p(result,"^",25)=""			///保修截至日(BXJZR)
		s $p(result,"^",26)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",27)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",28)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",29)=""			///制单人(Operator)
		s $p(result,"^",30)=""			///管理人(ZYIDGLR)
		s $p(result,"^",31)="TRUE"			///未处置(WCZ)
		s $p(result,"^",32)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",33)="FALSE"			///是否引用(SFYY)		
	}
	
	///文艺体育设备
	if (TypeInfo="09")
	{
		s $p(result,"^",1)="768"		///单据标识(BillTag)			
		s $p(result,"^",2)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",3)=ModelID		///单据模型(ModelID)	
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",6)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",7)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",7)'="" s $p(result,"^",7)=$ZD($p(result,"^",7),3)
		s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
		s $p(result,"^",8)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",9)=$p(result,"^",8)			///取得日期(BuildDate)
		s $p(result,"^",10)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		s $p(result,"^",11)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",12)=objEquip.EQModelDR.MDesc			///规格型号(Spec)
		s $p(result,"^",13)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",14)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",15)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		s $p(result,"^",16)=1			///数量(QTY)
		s $p(result,"^",17)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",18)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",18)="不提折旧"	}
		s $p(result,"^",19)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",20)=""			///使用人(ZYIDSYR)
		s $p(result,"^",21)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",22)=""			///品牌(PinPai)
		s $p(result,"^",23)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",24)=""			///会计凭证号(KJPZH)
		s $p(result,"^",25)=""			///保修截至日(BXJZR)
		s $p(result,"^",26)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",27)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",28)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",29)=""			///制单人(Operator)
		s $p(result,"^",30)=""			///管理人(ZYIDGLR)
		s $p(result,"^",31)="TRUE"			///未处置(WCZ)
		s $p(result,"^",32)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",33)="FALSE"			///是否引用(SFYY)		
	}
	
	
	///图书文物及陈列品
	if (TypeInfo="10")
	{
		s $p(result,"^",1)="562"		///单据标识(BillTag)			
		s $p(result,"^",2)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",3)=ModelID		///单据模型(ModelID)	
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",5)'="" s $p(result,"^",5)=$ZD($p(result,"^",5),3)
		s $p(result,"^",5)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")
		s $p(result,"^",6)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",7)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",8)=objEquip.EQOriginalFee			///价值(OrgnValue)		
		s $p(result,"^",9)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",10)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)		
		s $p(result,"^",11)=$p(result,"^",5)			///取得日期(BuildDate)
		s $p(result,"^",12)=""			///制单人(Operator)
		s $p(result,"^",13)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",14)=""			///文物等级ID(WWDJID)
		s $p(result,"^",15)=""			///会计凭证号(KJPZH)
		s $p(result,"^",16)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",17)=""			///自筹(ZC)
		s $p(result,"^",18)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",19)=objEquip.EQManageLocDR			///管理部门(SYBM)		
		s $p(result,"^",20)=objEquip.EQServiceHandler			///座落位置(ZuoLuoWeiZhi)
		s $p(result,"^",21)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",22)=""			///使用人(ZYIDSYR)
		s $p(result,"^",23)=""			///管理人(ZYIDGLR)
		s $p(result,"^",24)=1			///数量(QTY)
		s $p(result,"^",25)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",26)="有产权"			///产权形式(CQXSBH)
		s $p(result,"^",27)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		s $p(result,"^",28)="TRUE"			///未处置(WCZ)
		s $p(result,"^",29)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",30)="FALSE"			///是否引用(SFYY)		
	}
	
	///家具用具及其他类
	if (TypeInfo="11")
	{
		s $p(result,"^",1)="530"		///单据标识(BillTag)			
		s $p(result,"^",2)=OrgID			///组织ID??(OrgID)  必须和帐套名称完全一致  如：北京市丰台区政府机关事务管理处本级事业
		s $p(result,"^",3)=ModelID		///单据模型(ModelID)	
		s $p(result,"^",4)=""			///固定资产编号(BillCode)	不填（自动生成）
		s $p(result,"^",5)=objEquip.EQName			///名称(StdName)
		s $p(result,"^",6)=objEquip.EQEquiCatDR.ECDesc			///分类代码ID(CatalogID)
		s $p(result,"^",7)=objEquip.EQInStockListDR.ISLInStockDR.ISBillAuditDate			///单据日期(BillDate)
		
		//modified by zy 2017-03-02 ZY0159 日期格式统一调整
		//if $p(result,"^",7)'="" s $p(result,"^",7)=$ZD($p(result,"^",7),3)
		s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")
		s $p(result,"^",8)=objEquip.EQModelDR.MDesc			///规格型号(Spec)
		s $p(result,"^",9)=""			///品牌(PinPai)		
		s $p(result,"^",10)=objEquip.EQOriginDR.ODesc			///取得方式ID(SrcID)
		s $p(result,"^",11)=$p(result,"^",7)			///取得日期(BuildDate)
		s $p(result,"^",12)=""			///使用方向ID(ShiYongFangXianID)  自用,出租,出借,经营,其他
		s $p(result,"^",13)=##Class(web.DHCEQCommon).GetTrakNameByID("dept",objEquip.EQUseLocDR)			///使用部门ID(BMID)
		s $p(result,"^",14)=""			///使用人(ZYIDSYR)		
		s $p(result,"^",15)=objEquip.EQServiceHandler			///存放地点(PlaceID)
		if objEquip.EQGuaranteeFlag="Y"
		{	s $p(result,"^",16)="提折旧"	}			///折旧状态编码(DPRCTState)
		else
		{	s $p(result,"^",16)="不提折旧"	}
		s $p(result,"^",17)=..TransStatus(objEquip.EQStatus)			///资产使用状况ID(NewColumn1)	在用，未使用，不需用，其他
		s $p(result,"^",18)="原值"			///价值类型(ZCZTAJZXSBH)
		s $p(result,"^",19)=objEquip.EQOriginalFee			///价值(OrgnValue)
		s $p(result,"^",20)=objEquip.EQRemark			///备注(Remark)
		s $p(result,"^",21)=""			///制单人(Operator)
		s $p(result,"^",22)=""			///管理人(ZYIDGLR)
		s $p(result,"^",23)=""			///出租/出借对方单位(DFDW)
		s $p(result,"^",24)=""			///保修截至日(BXJZR)
		s $p(result,"^",25)=""			///会计凭证号(KJPZH)
		s $p(result,"^",26)=1			///数量(QTY)		
		s $p(result,"^",27)=##Class(web.DHCEQCommon).GetTrakNameByID("uom",objEquip.EQUnitDR)			///计量单位(XJLDW)
		s $p(result,"^",28)="TRUE"			///财政性资金(CZXZJ)
		s $p(result,"^",29)="FALSE"			///非财政性资金(FCZXZJ)
		s $p(result,"^",30)="TRUE"			///未处置(WCZ)
		s $p(result,"^",31)="FALSE"			///资产入库(IsUsed)
		s $p(result,"^",32)="FALSE"			///是否引用(SFYY)
		///s $p(result,"^",17)=objEquip.EQDepreMethodDR.DMDesc			///折旧方法编码(DPRCTWayID)		
	}
	d objEquip.%Close()
	q result
}

ClassMethod TransStatus(EQStatus)
{
	q $CASE(EQStatus,"1":"在用",:"未用")
}

}
