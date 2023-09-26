Class web.DHCEQ.Plat.BUSMonthDepre Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSMonthDepre","GetEquipPreDepre","^SSLocID=107^SSGroupID=85^SSUserID=1^QXType=")
Query GetEquipPreDepre(vData As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TUseLoc:%String,TNo:%String,TModel:%String,TEquipType:%String,TOriginalFee:%String,TTransAssetDate:%String,TDepreTotalFee:%String,TNetFee:%String,TStartDate:%String,TDepreMethod:%String,TLimitYearsNum:%String,TStoreLoc:%String,TStartDepreDate:%String,TPreMonthDepre:%String,TPreMonthDepreTotal:%String")
{
}

ClassMethod GetEquipPreDepreExecute(ByRef qHandle As %Binary, vData As %String = "") As %Status
{
 	new repid, index,rowid
 	new passed
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s CurMonth=$p($zd(+$h,3),"-",1,2)
	s NonFixEQEquipType=##class(web.DHCEQCommon).GetSysInfo("990089")
	
	s SSLocID=##class(web.DHCEQCommon).GetDataByName(vData,"SSLocID")
	s SSGroupID=##class(web.DHCEQCommon).GetDataByName(vData,"SSGroupID")
	s SSUserID=##class(web.DHCEQCommon).GetDataByName(vData,"SSUserID")
	s QXType=##class(web.DHCEQCommon).GetDataByName(vData,"QXType")
	s Name=##class(web.DHCEQCommon).GetDataByName(vData,"Name")
	s Name=$ZCONVERT(Name,"U")
	s No=##class(web.DHCEQCommon).GetDataByName(vData,"No")
	s UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
	s EquipTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
	s BeginStartDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginStartDate")
	i BeginStartDate="" s BeginStartDate=0
	e  s BeginStartDate=##class(web.DHCEQCommon).TransValueFromPage(BeginStartDate,"date")
	s EndStartDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndStartDate")
	i EndStartDate="" s EndStartDate=+$h
	e  s EndStartDate=##class(web.DHCEQCommon).TransValueFromPage(EndStartDate,"date")
	s BeginDepreDate=##class(web.DHCEQCommon).GetDataByName(vData,"BeginDepreDate")
	i BeginDepreDate="" s BeginDepreDate=0
	e  s BeginDepreDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDepreDate,"date")
	s EndDepreDate=##class(web.DHCEQCommon).GetDataByName(vData,"EndDepreDate")
	i EndDepreDate="" s EndDepreDate=+$h
	e  s EndDepreDate=##class(web.DHCEQCommon).TransValueFromPage(EndDepreDate,"date")
	s FixEquipFlag=##class(web.DHCEQCommon).GetDataByName(vData,"FixEquipFlag")
	s OriginalFeeFrom=##class(web.DHCEQCommon).GetDataByName(vData,"OriginalFeeFrom")
	s OriginalFeeTo=##class(web.DHCEQCommon).GetDataByName(vData,"OriginalFeeTo")
	s IsDepre=##class(web.DHCEQCommon).GetDataByName(vData,"IsDepre")			//折旧年限是否为0
	s IsDepring=##class(web.DHCEQCommon).GetDataByName(vData,"IsDepring")		//净值是否为0
	s IsCostAllot=##class(web.DHCEQCommon).GetDataByName(vData,"IsCostAllot")	//是否分摊
	s IsPostpone=##class(web.DHCEQCommon).GetDataByName(vData,"IsPostpone")		//是否延期
	
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid)) q:rowid=""  d
	.s TTransAssetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	.s TEquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)			//设备类组
 	.s TEuipTypeManCode=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",12)

	.s TCode=$p($g(^DHCEQEquip(rowid)),"^",6)
	.s TName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.q:(Name'="")&&($ZCONVERT(TName,"U")'[Name)
	.s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	.q:(No'="")&&($ZCONVERT(TNo,"U")'[No)
	.d BuildDataGetEquipPreDepre
	Quit $$$OK
	
BuildDataGetEquipPreDepre
	d ResetVariablesGetEquipPreDepre
	s TRowID = rowid
	d CheckDataGetEquipPreDepre
	i passed=0 q
	
	s TName=$p($g(^DHCEQEquip(rowid)),"^",1)
	
	s TModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	
	s TEquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	
	s TEquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i TEquipTypeDR '="" d
	.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	
	s TManageLocDR = $p($g(^DHCEQEquip(rowid)),"^",17)
	i TManageLocDR '=""  d
	.s TManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR) ; ##class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR)	
	
	s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	
	s TOriginalFee = $p($g(^DHCEQEquip(rowid)),"^",27)
	q:(OriginalFeeFrom'="")&(OriginalFeeFrom>TOriginalFee)
	q:(OriginalFeeTo'="")&(OriginalFeeTo<TOriginalFee)
	
	s TNetFee = $p($g(^DHCEQEquip(rowid)),"^",28)
	q:(IsDepring=1)&(+TNetFee=0)
	q:(IsDepring=0)&(+TNetFee>0)
	
	s TNetRemainFee = $p($g(^DHCEQEquip(rowid)),"^",29)
	s TLimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	q:(IsDepre=1)&(+TLimitYearsNum=0)
	q:(IsDepre=0)&(+TLimitYearsNum>0)
	
	s TDepreMethodDR = $p($g(^DHCEQEquip(rowid)),"^",33)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	
	s TDepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
	s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	s TStartDate = $p($g(^DHCEQEquip(rowid)),"^",44)
	s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")
	
	s TStoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	
	s TNo=$p($g(^DHCEQEquip(rowid)),"^",71)
	
	s TDepreSetID=$o(^DHCEQDepreSet(0,"Equip",rowid,""))
	i TDepreSetID'="" d
	.s TStartDepreDate=$p($g(^DHCEQDepreSet(TDepreSetID)),"^",25)	//开始折旧日期
	
	q:(IsPostpone=1)&(+TStartDepreDate<=+TStartDate)	//延期折旧
	q:(IsPostpone=0)&(+TStartDepreDate>+TStartDate)	//非延期折旧
	
	s TStartDate = ##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TStartDepreDate=##class(web.DHCEQCommon).TransValueToPage(TStartDepreDate,"date")
	
	s TPreDepreMonthID=$o(^DHCEQPreMonthDepre(0,"EquipMonth",rowid,CurMonth,""))
	i TPreDepreMonthID'="" d
	.s TPreMonthDepre=$p($g(^DHCEQPreMonthDepre(TPreDepreMonthID)),"^",14)	//预折旧月折旧金额
	.s TPreMonthDepreTotal=$p($g(^DHCEQPreMonthDepre(TPreDepreMonthID)),"^",12)	//预折旧累计折旧
	
	s TCARowID=$o(^DHCEQCostAllot(0,"StatusSourceType","N","1",rowid,""))
	s CostNum=0
	i TCARowID'="" d
	.s TCALRowID=""
	.f  s TCALRowID=$o(^DHCEQCostAllotList(0,"CostAllotDR",TCARowID,TCALRowID)) q:TCALRowID=""  d
	..s CostNum=CostNum+1
	q:(IsCostAllot=1)&(CostNum<2)	//分摊折旧
	q:(IsCostAllot=0)&(CostNum>1)	//不分摊
	
	d OutputRowGetEquipPreDepre
	quit
OutputRowGetEquipPreDepre
	s TOriginalFee=##class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TDepreTotalFee=##class(web.DHCEQCommon).FormatNumber(TDepreTotalFee,"",2)
	s TNetFee=##class(web.DHCEQCommon).FormatNumber(TNetFee,"",2)
	s TPreMonthDepre=##class(web.DHCEQCommon).FormatNumber(TPreMonthDepre,"",2)
	s TPreMonthDepreTotal=##class(web.DHCEQCommon).FormatNumber(TPreMonthDepreTotal,"",2)
	s Data=$lb(TName,TRowID,TUseLoc,TNo,TModel,TEquipType,TOriginalFee,TTransAssetDate,TDepreTotalFee,TNetFee,TStartDate,TDepreMethod,TLimitYearsNum,TStoreLoc,TStartDepreDate,TPreMonthDepre,TPreMonthDepreTotal)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipPreDepre
	s (TName,TModelDR,TModel,TEquiCatDR,TEquiCat,TEquipTypeDR,TEquipType,TManageLocDR,TManageLoc,TUseLocDR,TUseLoc,TOriginalFee,TNetFee,TNetRemainFee,TLimitYearsNum,TDepreMethodDR,TDepreMethod,TDepreTotalFee,TStatus,TStartDate,TTransAssetDate,TStoreLocDR,TStoreLoc,TNo,TStartDepreDate,TPreMonthDepre,TPreMonthDepreTotal)=""
	quit
CheckDataGetEquipPreDepre
	s passed=1
	s TInvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i TInvalidFlag'="N" s passed=0
	i passed=0 q
	
	i (##Class(web.DHCEQCommon).CheckManageLimit(SSUserID,SSGroupID,"","","","","",rowid)) s passed=0
	i passed=0 q
	
	s TEquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i ("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,SSGroupID,"","")) s passed=0
	i passed=0 q
	i (EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR) s passed=0
	i passed=0 q
	i (FixEquipFlag=1)&&((","_NonFixEQEquipType_",")[(","_TEquipTypeDR_",")) s passed=0
	i passed=0 q 
	
	s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	i (UseLocDR'="")&&(UseLocDR'=TUseLocDR) s passed=0
	i passed=0 q
	
	s TStoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i TStoreLocDR'=""  d
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,SSLocID,SSGroupID)))  d 
	..s passed=0
	i passed=0 q
	
	s TStockStatus = $p($g(^DHCEQEquip(rowid)),"^",60)
	i ((TStockStatus="0")||(TStockStatus="3")) s passed=0
	i passed=0 q
	
	s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	i (TStatus="4") s passed=0
	i passed=0 q
	
	i ((TStatus=0)&&(TStockStatus=1)) s passed=0
	i passed=0 q
	
	s TStartDate = $p($g(^DHCEQEquip(rowid)),"^",44)
	i (TStartDate'="")&&((TStartDate<BeginStartDate)||(TStartDate>EndStartDate)) s passed=0
	i passed=0 q
	
	s TDepreSetID=$o(^DHCEQDepreSet(0,"Equip",rowid,""))
	i TDepreSetID'="" d
	.s TStartDepreDate=$p($g(^DHCEQDepreSet(TDepreSetID)),"^",25)	//开始折旧日期
	i (TStartDepreDate'="")&&((TStartDepreDate<BeginDepreDate)||(TStartDepreDate>EndDepreDate)) s passed=0
	i passed=0 q
	
	quit
}

ClassMethod GetEquipPreDepreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipPreDepreExecute ]
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

ClassMethod GetEquipPreDepreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipPreDepreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// czf 2023-02-22
/// 设备折旧设置
/// Amount:初始化默认分摊总额
/// LocID：初始化默认分摊科室
/// DepreFee:初始化默认月折旧额
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSMonthDepre","CostAllot","15")
Query CostAllot(CARowID As %String = "", Amount As %String = "", LocID As %String = "", DepreFee As %String = "", vCATypes As %String = "", vCAHold2 As %String = "", vCAAllotType As %String = "") As %Query(ROWSPEC = "CARowID:%String,CATypes:%String,CAHold2:%String,CAAllotType:%String,CAAllotTypeDesc:%String,CALRowID:%String,CALAllotLocDR:%String,CALAllotLoc:%String,CALAllotPercentNum:%String,CALRemark:%String,CALWorkLoadNum:%String,CALHold1:%String,CALHold2:%String,CALHold3:%String,CALHold4:%String,CALHold5:%String,CALDepreFee:%String")
{
}

ClassMethod CostAllotExecute(ByRef qHandle As %Binary, CARowID As %String = "", Amount As %String = "", LocID As %String = "", DepreFee As %String = "", vCATypes As %String = "", vCAHold2 As %String = "", vCAAllotType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i CARowID=""
	{
		s (CARowID,CATypes,CAHold2,CAAllotType,CAAllotTypeDesc)=""
		d ResetVariablesGetCostAllot
		s CATypes=vCATypes
		s CAHold2=vCAHold2
		s CAAllotType=vCAAllotType
		s CALAllotLocDR=LocID
		s CALAllotLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",CALAllotLocDR)
		s CALAllotPercentNum=100
		s CALWorkLoadNum=##class(web.DHCEQCommon).FormatNumber(Amount,"",2)
		s CALDepreFee=##class(web.DHCEQCommon).FormatNumber(DepreFee,"",2)
		d OutputRowGetCostAllot
	}
	else
	{
		s CATypes=$p($g(^DHCEQCostAllot(CARowID)),"^",3)
		s CAHold2=$p($g(^DHCEQCostAllot(CARowID)),"^",17)
		s CAAllotType=$p($g(^DHCEQCostAllot(CARowID)),"^",14)
		s CAAllotTypeDesc=##Class(web.DHCEQFind).GetDisplayAllotType(CAAllotType)
		s ListID=0
		f  s ListID=$o(^DHCEQCostAllotList(0,"CostAllotDR",CARowID,ListID))  quit:ListID=""  d
		.d ResetVariablesGetCostAllot
		.s DataList=$g(^DHCEQCostAllotList(ListID))
		.s CALRowID = ListID	//rowid
		.s CALAllotLocDR=$p(DataList,"^",2)
		.s CALAllotLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",CALAllotLocDR)
		.s CALAllotPercentNum=##class(web.DHCEQCommon).FormatNumber($p(DataList,"^",3),"",2)
		.s CALRemark=$p(DataList,"^",4)
		.s CALWorkLoadNum=##class(web.DHCEQCommon).FormatNumber($p(DataList,"^",5),"",2)
		.s CALHold1=$p(DataList,"^",6)
		.s CALHold2=$p(DataList,"^",7)
		.s CALHold3=$p(DataList,"^",8)
		.s CALHold4=$p(DataList,"^",9)
		.s CALHold5=$p(DataList,"^",10)
		.s CALDepreFee=##class(web.DHCEQCommon).FormatNumber($p(DataList,"^",3)/100*DepreFee,"",2)	//分摊月折旧
		.d OutputRowGetCostAllot
	}
	Quit $$$OK
OutputRowGetCostAllot
	s Data=$lb(CARowID,CATypes,CAHold2,CAAllotType,CAAllotTypeDesc,CALRowID,CALAllotLocDR,CALAllotLoc,CALAllotPercentNum,CALRemark,CALWorkLoadNum,CALHold1,CALHold2,CALHold3,CALHold4,CALHold5,CALDepreFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCostAllot
	s (DataList,CALRowID,CALAllotLocDR,CALAllotLoc,CALAllotPercentNum,CALRemark,CALWorkLoadNum,CALHold1,CALHold2,CALHold3,CALHold4,CALHold5,CALDepreFee)=""
	quit
}

ClassMethod CostAllotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CostAllotExecute ]
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

ClassMethod CostAllotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CostAllotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      CZF
/// CreatDate：    2022-02-22
/// Description:   解析单条台账信息
/// Table：        DHC_EQEquip
/// Input：        RowID:台账ID
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.Plat.BUSMonthDepre).GetOneEquip(3)
ClassMethod GetOneEquip(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneEquip"
	s ObjEquip=##Class(User.DHCEQEquip).%OpenId(RowID)
	s EquipInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjEquip)
	d EquipInfo.%Set("EQModelDR_MDesc",ObjEquip.EQModelDR.MDesc)
    d EquipInfo.%Set("EQEquiCatDR_ECCode",ObjEquip.EQEquiCatDR.ECCode) //added by LMH 20220919 2904739 
	d EquipInfo.%Set("EQEquiCatDR_ECDesc",ObjEquip.EQEquiCatDR.ECDesc)
	d EquipInfo.%Set("EQUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjEquip.EQUnitDR))
	d EquipInfo.%Set("EQItemDR_MIDesc",ObjEquip.EQItemDR.MIDesc)
	d EquipInfo.%Set("EQInstallLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQInstallLocDR))
	d EquipInfo.%Set("EQCountryDR_CTCOUDesc",##class(web.DHCEQCommon).GetTrakNameByID("cou",ObjEquip.EQCountryDR))
	d EquipInfo.%Set("EQManageLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQManageLocDR))
	d EquipInfo.%Set("EQManageLevelDR_MLDesc",ObjEquip.EQManageLevelDR.MLDesc)
	d EquipInfo.%Set("EQUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQUseLocDR))
	d EquipInfo.%Set("EQOriginDR_ODesc",ObjEquip.EQOriginDR.ODesc)
	d EquipInfo.%Set("EQFromDeptDR_FTDDesc",ObjEquip.EQFromDeptDR.FTDDesc)
	d EquipInfo.%Set("EQToDeptDR_FTDDesc",ObjEquip.EQToDeptDR.FTDDesc)
	d EquipInfo.%Set("EQBuyTypeDR_BTDesc",ObjEquip.EQBuyTypeDR.BTDesc)
	d EquipInfo.%Set("EQEquipTechLevelDR_TLDesc",ObjEquip.EQEquipTechLevelDR.TLDesc)
	d EquipInfo.%Set("EQProviderDR_VName",##class(web.DHCEQCommon).GetTrakNameByID("prov",ObjEquip.EQProviderDR))
	d EquipInfo.%Set("EQManuFactoryDR_MFName",ObjEquip.EQManuFactoryDR.VName)		//modified by CZF0103 20200408
	//s EQManuFactoryDR=ObjEquip.EQManuFactoryDRGetObjectId()
	//d EquipInfo.%Set("EQManuFactoryDR_MFName",##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",EQManuFactoryDR))	//modified by CZF0093 2020-03-17
	d EquipInfo.%Set("EQOriginalFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQOriginalFee,""))
	d EquipInfo.%Set("EQNetFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQNetFee,""))
	d EquipInfo.%Set("EQNetRemainFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQNetRemainFee,""))
	d EquipInfo.%Set("EQGroupDR_GRName",ObjEquip.EQGroupDR.GRName)
	d EquipInfo.%Set("EQDepreMethodDR_DMDesc",ObjEquip.EQDepreMethodDR.DMDesc)
	d EquipInfo.%Set("EQDepreTotalFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQDepreTotalFee,""))
	d EquipInfo.%Set("EQWorkLoadUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjEquip.EQWorkLoadUnitDR))
	d EquipInfo.%Set("EQManageUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQManageUserDR))
	d EquipInfo.%Set("EQMaintUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQMaintUserDR))
	d EquipInfo.%Set("EQAppendFeeTotalFee",##class(web.DHCEQCommon).FormatNumber(ObjEquip.EQAppendFeeTotalFee,""))
	d EquipInfo.%Set("EQAddUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQAddUserDR))
	d EquipInfo.%Set("EQUpdateUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQUpdateUserDR))
	d EquipInfo.%Set("EQEquipTypeDR_ETDesc",ObjEquip.EQEquipTypeDR.ETDesc)
	d EquipInfo.%Set("EQPurchaseTypeDR_PTDesc",ObjEquip.EQPurchaseTypeDR.PTDesc)
	d EquipInfo.%Set("EQPurposeTypeDR_PTDesc",ObjEquip.EQPurposeTypeDR.PTDesc)
	d EquipInfo.%Set("EQKeeperDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQKeeperDR))
	d EquipInfo.%Set("EQStoreLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQStoreLocDR))
	//d EquipInfo.%Set("EQServiceDR_SVName",ObjEquip.EQServiceDR.SVName)
	s EQServiceDR=ObjEquip.EQServiceDRGetObjectId()
	d EquipInfo.%Set("EQServiceDR_SVName",##class(web.DHCEQCommon).GetTrakNameByID("cservice",EQServiceDR))	//modified by CZF0093 2020-03-17
	d EquipInfo.%Set("EQLocationDR_LDesc",ObjEquip.EQLocationDR.LDesc)
	d EquipInfo.%Set("EQStatCatDR_SCDesc",ObjEquip.EQStatCatDR.SCDesc)
	d EquipInfo.%Set("EQRentLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjEquip.EQRentLocDR))
	d EquipInfo.%Set("EQUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjEquip.EQUserDR))
	if ObjEquip.EQHold10'="" d EquipInfo.%Set("EQHold10_EDesc",$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",ObjEquip.EQHold10)),"^",2))
	d EquipInfo.%Set("EQAddDepreMonths",$p(##Class(web.DHCEQChangeAccount).GetAddDepreTotalNum(RowID),"^",1))  //调整折旧月份数	//modified by czf 1560234 2020-11-05
	d EquipInfo.%Set("EQStatusDisplay",##Class(web.DHCEQEquip).GetEquipStatusDisplay(ObjEquip.EQStatus)) 
	d EquipInfo.%Set("EQGuaranteePeriodNum",ObjEquip.EQGuaranteePeriodNum)
	d EquipInfo.%Set("EQLimitYearsNum",ObjEquip.EQLimitYearsNum)
	d EquipInfo.%Set("EQAdvanceDisFlagDesc",##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(ObjEquip.EQAdvanceDisFlag))
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	d EquipInfo.%Set("EQSelfFundsFlag",SelfFundsFlag)
	s FundsInfo=##Class(web.DHCEQFunds).GetSourceFunds(1,RowID,ObjEquip.EQOriginalFee,SelfFundsFlag)
	d EquipInfo.%Set("EQSelfFundFee",$p(FundsInfo,"^",1))
	d EquipInfo.%Set("EQClassFlag",ObjEquip.EQClassFlag)		//Modify DJ 2019-06-27
	i ObjEquip.EQStoreLocDR'="" d
	.d EquipInfo.%Set("EQHospital",##Class(web.DHCEQCommon).GetHospitalDesc(ObjEquip.EQStoreLocDR))	;Mozy	2019-9-28
	e  d
	.d EquipInfo.%Set("EQHospital","")
	d EquipInfo.%Set("EQRowID",RowID)
    d EquipInfo.%Set("EQBrand_BDesc",##class(web.DHCEQCommon).GetTrakNameByID("brand",ObjEquip.EQBrand)) //Add by QW20220531  BUG:QW0162 增加品牌
	
	s (DepreSetID,DepreTotal,RemainDepreMonth,StartDepreDate,EQLastMonthDepre,EQPreMonthDepre,DepreStatus)=""
	s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",RowID,""))
	i DepreSetID'="" d
	.s DepreTotal=$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)
	.s DSYears=$p($g(^DHCEQDepreSet(DepreSetID)),"^",24)
	.s RemainDepreMonth=DSYears*12-DepreTotal
	.s StartDepreDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDepreSet(DepreSetID)),"^",25),"date")
	.s DepreStatus=$p($g(^DHCEQDepreSet(DepreSetID)),"^",26)
	s DepreStatus=$case(DepreStatus,"1":"true","true":"true",:"false")
	
	d EquipInfo.%Set("EQDepreTotal",DepreTotal)
	d EquipInfo.%Set("EQRemainDepreMonth",RemainDepreMonth)
	d EquipInfo.%Set("EQStartDepreDate",StartDepreDate)
	d EquipInfo.%Set("EQDepreStatus",DepreStatus)
	
	s DepreSetInfo=$g(^DHCEQEquipShadow("RecordEQCurDepre",RowID))
	s TPreDepreMonth=$p(DepreSetInfo,"^",1)	//最近一次折旧月
	s TCurDepreFee=$p(DepreSetInfo,"^",3)	//最近一次月折旧
	d EquipInfo.%Set("EQLastMonthDepre",TCurDepreFee)	//上月折旧
	
	s PreDepreFee=""
	s PreMDRowID=$o(^DHCEQPreMonthDepre(0,"Equip",RowID,""))
	i PreMDRowID'="" d
	.s PreDepreFee=$p($g(^DHCEQPreMonthDepre(PreMDRowID)),"^",14)
	d EquipInfo.%Set("EQPreMonthDepre",PreDepreFee)	//预计折旧金额
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,EquipInfo)
ERRORGetOneEquip
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// 保存设备折旧信息
/// w ##Class(web.DHCEQ.Plat.BUSMonthDepre).SaveEquipData("","",1)
ClassMethod SaveEquipData(Data, EquipAttribute As %Library.String = "", User As %Library.String = "", SSLocID As %Library.String = "")
{
	k EQPLIST,RowID
	s $ZT="ERRORSaveEquipData"
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s EQPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQEquip",JsonData,.EQPLIST)
	s RowID = JsonData.%Get("EQRowID")
	i RowID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9040","设备ID不能为空!")
	i User=""  s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$h
	s Time=$p($h,",",2)
	s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",RowID,""))
	s DepreTotalNum=""
	i DepreSetID'="" s DepreTotalNum=$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)
	s EQOldObj=##Class(User.DHCEQEquip).%OpenId(RowID)
	s EQOldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(EQOldObj)
	i DepreSetID'=""
	{
		d EQOldObj.%Set("DSHold1",##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDepreSet(DepreSetID)),"^",25),"date"))	//折旧开始日期
		d EQOldObj.%Set("DSHold2",$p($g(^DHCEQDepreSet(DepreSetID)),"^",26))	//折旧状态
	}
	s EQOldValue=EQOldObj.%ToJSON()
	
	TStart
	//若金额包含了累计折旧修改，同步修改资金来源，自动生成调账记录
	i JsonData.%IsDefined("EQDepreTotalFee")
	{
		s EQDepreTotal=JsonData.EQDepreTotal
		s EQDepreTotalFee=##class(web.DHCEQCommon).FormatNumber(JsonData.EQDepreTotalFee,"",2)
		s OldEQDepreTotalFee=##class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(RowID)),"^",35),"",2)
		i EQDepreTotalFee'=OldEQDepreTotalFee
		{
			;生成主设备调账记录
			&SQL(Select CA_RowID from SQLUSER.DHC_EQChangeAccount Where CA_EquipDR=:RowID and CA_Status<2)
			if (%ROWCOUNT>0)  q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1003,"当前设备存在未完成调账记录，需删除未完成调账单!")
			s ChangeFee=0
			s ChangeDepreTotalFee=EQDepreTotalFee-OldEQDepreTotalFee
			k CAPLIST
			s CAPLIST(2) = RowID	;EquipDR
			s CAPLIST(3) = ChangeFee	;ChangeFee
			s CAPLIST(4) = $p($g(^DHCEQEquip(RowID)),"^",27)	;ChangedOriginalFee
			s CAPLIST(5) = JsonData.EQNetFee					;ChangedNetFee
			s CAPLIST(6) = EQDepreTotalFee			;TotalDepreFee
			s CAPLIST(9) = "设备累计折旧调整"		;ChangeReason
			s CAPLIST(10) = Date					;ChangeDate
			s CAPLIST(11) = "设备累计折旧调整"		;Remark
			s CAPLIST(12) = 0					;Status
			s CAPLIST(13) = User				;AddUser
			s CAPLIST(14) = Date				;AddDate
			s CAPLIST(15) = Time				;AddTime
			s CAPLIST(16) = User				;UpdateUser
			s CAPLIST(17) = Date				;UpdateDate
			s CAPLIST(18) = Time				;UpdateTime
			s CAPLIST(25) = $p($g(^DHCEQEquip(RowID)),"^",27)		;OriginalFee
			s CAPLIST(26) = $p($g(^DHCEQEquip(RowID)),"^",28)		;NetFee
			s CAPLIST(27) = $p($g(^DHCEQEquip(RowID)),"^",29)		;NetRemainFee
			s CAPLIST(29) = $p($g(^DHCEQEquip(RowID)),"^",67)		;StoreLocDR
			s CAPLIST(30) = $p($g(^DHCEQEquip(RowID)),"^",19)		;UseLocDR
			s CAPLIST(31) = $p($g(^DHCEQEquip(RowID)),"^",63)		;EquipTypeDR
			s CAPLIST(32) = $p($g(^DHCEQEquip(RowID)),"^",75)		;StatCatDR
			s CAPLIST(34) = ChangeDepreTotalFee						;Hold2 调整的累计折旧
			s CAPLIST(35) = EQDepreTotal-DepreTotalNum				;Hold3	调整月份数
			&SQL(Insert Into SQLUSER.DHC_EQChangeAccount Values :CAPLIST())
			if SQLCODE
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,EQNo_"调账记录生成失败!错误信息:"_$g(%msg))
			}
			Set CAID=$g(%ROWID)
			
			;生成调账资金来源记录
			s SOriginalFee=$p($g(^DHCEQEquip(RowID)),"^",27)
			s RemainChangeFee=ChangeFee
			s RemainChangeDepreFee=ChangeDepreTotalFee
			s SFRowID=0
			f  s SFRowID=$o(^DHCEQFunds("0","Equip",RowID,SFRowID)) q:((SFRowID="")||(SQLCODE'=0))  d
			.q:$p($g(^DHCEQFunds(SFRowID)),"^",10)="Y"
		 	.s SEQFundsFee=+$p($g(^DHCEQFunds(SFRowID)),"^",3)
			.s SEQFDepreTotalFee=+$p($g(^DHCEQFunds(SFRowID)),"^",13)
			.s SFundsType=$p($g(^DHCEQFunds(SFRowID)),"^",2)
			.s SFinaceItemDR=$Piece($Get(^DHCEQFunds(SFRowID)),"^",20)	//核算项目
			.s SFunctionCatDR=$Piece($Get(^DHCEQFunds(SFRowID)),"^",21)	//功能分类
			.i +SOriginalFee=0 s SCAFundsFee=0,SCADepreFee=0
			.e  d
			..s SCAFundsFee=SEQFundsFee*ChangeFee/SOriginalFee		//按原资金来源比例计算调整的金额
			..s SCAFundsFee=##Class(web.DHCEQCommon).FormatNumber(SCAFundsFee,"",2)
			..s SCADepreFee=SEQFundsFee*ChangeDepreTotalFee/SOriginalFee
			..s SCADepreFee=##Class(web.DHCEQCommon).FormatNumber(SCADepreFee,"",2)
			.s SCurFundFee=SCAFundsFee+SEQFundsFee
			.s SCurDepreFee=SCADepreFee+SEQFDepreTotalFee
			.i SCurFundFee<0 s SCAFundsFee=-SEQFundsFee		//若调后金额小于0，则调整金额为负的调前金额
			.i SCurDepreFee<0 s SCADepreFee=-SEQFDepreTotalFee	//调后累计折旧小于0，则调整金额为负的调前累计折旧
			.i SCurDepreFee>SCurFundFee s SCADepreFee=SCurFundFee-SEQFDepreTotalFee	 //调后累计折旧大于调后金额
			.i $ZABS(RemainChangeFee)<$ZABS(SCAFundsFee) s SCAFundsFee=RemainChangeFee	//取绝对值
			.i $ZABS(RemainChangeDepreFee)<$ZABS(SCADepreFee) s SCADepreFee=RemainChangeDepreFee	//取绝对值
			.s RemainChangeFee=RemainChangeFee-SCAFundsFee
			.s RemainChangeDepreFee=RemainChangeDepreFee-SCADepreFee
			.q:SCAFundsFee=0
			.k FPLIST
			.s FPLIST(3)=SFundsType
			.s FPLIST(4)=SCAFundsFee
			.s FPLIST(7)=0
			.s FPLIST(8)=User
			.s FPLIST(9)=Date
			.s FPLIST(10)=Time
			.s FPLIST(11)="N"
			.s FPLIST(14)=SCADepreFee
			.s FPLIST(15)=7
			.s FPLIST(16)=CAID
			.s FPLIST(19)=SEQFundsFee
			.s FPLIST(20)=SEQFDepreTotalFee
			.s FPLIST(21)=SFinaceItemDR
			.s FPLIST(22)=SFunctionCatDR
			.&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FPLIST())
			.q:SQLCODE
			i SQLCODE
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"调账记录资金来源生成失败!"_$g(%msg))
			}
			;审核设备调账记录
			s RtnCode=##class(web.DHCEQChangeAccount).AuditData("","",CAID,User,5)
			i RtnCode<0 
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,"调账记录审核失败!"_$g(%msg))
			}
		}
	}
	
    &SQL(Update SQLUSER.DHC_EQEquip Values :EQPLIST() where EQ_RowID = :RowID)
	i SQLCODE=100 s SQLCODE=0
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存设备信息失败，错误信息:"_$g(%msg))
	}
	s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",RowID,""))
	//保存折旧设置信息
	i DepreSetID'=""
	{
		i JsonData.%IsDefined("EQStartDepreDate")
		{
			s EQStartDepreDate=JsonData.EQStartDepreDate
			s EQStartDepreDate=##class(web.DHCEQCommon).TransValueFromPage(EQStartDepreDate,"date")
			&SQL(Update SQLUSER.DHC_EQDepreSet set DS_Hold1=:EQStartDepreDate where DS_RowID = :DepreSetID)
			if SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存折旧开始日期失败！"_$g(%msg))
			}
		}
		i JsonData.%IsDefined("EQDepreStatus")
		{
			s EQDepreStatus=JsonData.EQDepreStatus
			&SQL(Update SQLUSER.DHC_EQDepreSet set DS_Hold2=:EQDepreStatus where DS_RowID = :DepreSetID)
			if SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存折旧状态失败！"_$g(%msg))
			}
		}
		i JsonData.%IsDefined("EQDepreTotal")
		{
			s EQDepreTotal=JsonData.EQDepreTotal
			&SQL(Update SQLUSER.DHC_EQDepreSet set DS_DepreTotal=:EQDepreTotal where DS_RowID = :DepreSetID)
			if SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存已折期数失败！"_$g(%msg))
			}
		}
		i JsonData.%IsDefined("EQDepreTotalFee")
		{
			s DSDepreTotalFee=JsonData.EQDepreTotalFee
			&SQL(Update SQLUSER.DHC_EQDepreSet set DS_DepreTotalFee=:DSDepreTotalFee where DS_RowID = :DepreSetID)
			if SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存累计折旧失败！"_$g(%msg))
			}
		}
	}else{
		s EQDepreMethodDR=$p($g(^DHCEQEquip(RowID)),"^",33)
		i EQDepreMethodDR'=""
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"折旧设置不能为空!")
		}
		
	}
	
	//保存数据折旧修改日志
	s ^DHCEQMark("DHCEQEquip",RowID,User,$H)=$g(^DHCEQEquip(RowID))
	
	s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQEquip","User.DHCEQEquip",RowID,"U",Data,EQOldValue,User,"")
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存数据日志失败！"_$g(%msg))
	}
		
	s SQLCODE=##Class(web.DHCEQ.EM.BUSRentEquip).SavaOperateLog("52",RowID,"",User)
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存操作日志失败！"_$g(%msg))
	}
	TCommit
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSaveEquipData
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012", $ZE)
}

/// 保存设备折旧信息
/// w ##Class(web.DHCEQ.Plat.BUSMonthDepre).EQHasDepre(1)
ClassMethod EQHasDepre(EQRowID)
{
	i EQRowID="" q 0
	s HasDepreFlag=$d(^DHCEQMonthDepre(0,"EquipMonth",EQRowID))
	i HasDepreFlag q 1
	e  q 0
}

}
