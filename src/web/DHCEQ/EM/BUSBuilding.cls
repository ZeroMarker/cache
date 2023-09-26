/// 名称: web.DHCEQ.EM.BUSBuilding
/// 描述: 房屋信息
/// 编写者：ZX
/// 编写日期: 2019-07-02
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSBuilding Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2019-07-03
/// Description:   数据获取,前台填充
/// Input：        EQRowID:来源id 暂时处理为设备id
/// Return：       DHC_EQBuilding 解析数据
ClassMethod GetOneBuilding(BDRowID As %Library.String = "")
{
    i BDRowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("","")
    s $ZT="ERRORGetOneBuilding"
    s ObjBuilding=##Class(User.DHCEQBuilding).%OpenId(BDRowID)
    s BuildingInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjBuilding)
    s EQName=ObjBuilding.BDEquipDR.EQName
    i EQName="" s EQName=ObjBuilding.BDOpenCheckListDR.OCLName
    d BuildingInfo.%Set("BDEquipDR_EQName",EQName)
    d BuildingInfo.%Set("BDRowID",BDRowID)
    d BuildingInfo.%Set("BDStructDR_BSDesc",ObjBuilding.BDStructDR.BSDesc)
    d BuildingInfo.%Set("BDRightTypeDR_RTDesc",ObjBuilding.BDRightTypeDR.RTDesc)
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,BuildingInfo)
ERRORGetOneBuilding
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// Creator：      ZX
/// CreatDate：    2019-07-03
/// Description:   数据保存
/// Input：        data:前台获取字符串 field:value,filed:vale
/// Return：       ID
/// modify by lmm 2021-07-08 同步更新空间建筑表数据记楼层数据
ClassMethod SaveData(Data)
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuilding",JsonData,.PLIST)
	s RowID = JsonData.BDRowID
	s BDFloorNum = JsonData.BDFloorNum
	s BDUnderFloorNum = JsonData.BDUnderFloorNum
	if RowID'=""
    {
		&SQL(Update SQLUSER.DHC_EQBuilding Values :PLIST() where BD_RowID = :RowID)
		s PreBDFloorNum=$p($g(^DHCEQBuilding(RowID)),"^",19)
		s PreBDUnderFloorNum=$p($g(^DHCEQBuilding(RowID)),"^",20)
		
		if (PreBDFloorNum'=BDFloorNum)||(BDUnderFloorNum'=PreBDUnderFloorNum)
		{
			&SQL(Delete SQLUSER.DHC_EQBUFloor where F_BuildingDR=:RowID)
			i SQLCODE=100 s SQLCODE=0			
			&SQL(Delete SQLUSER.DHC_EQBUBuildingUnit where BU_BuildingDR=:RowID)
			i SQLCODE=100 s SQLCODE=0			
		}
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQBuilding Values :PLIST())
		s RowID=$g(%ROWID)
	}
	if SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	s SQLCODE=##Class(web.DHCEQ.EM.BUSBuilding).SaveBUBuildingData(RowID,JsonData)
	i SQLCODE=100 s SQLCODE=0
	if SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}    
	for FloorIndex=1:1:BDFloorNum  d
	.k PLIST
	.i (BDUnderFloorNum<1)&&((BDUnderFloorNum+FloorIndex-1)>=0)  d
	..s CurFloorNum=BDUnderFloorNum+FloorIndex
	.e  d
	..s CurFloorNum=BDUnderFloorNum+FloorIndex-1
	.s PLIST(2)=RowID
	.s PLIST(3)=FloorIndex
	.s PLIST(4)=CurFloorNum
	.&SQL(Insert Into SQLUSER.DHC_EQBUFloor Values :PLIST())
	if SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}

	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

/// add by lmm 2021-07-08
/// desc:同步保存空间建筑表结构数据
ClassMethod SaveBUBuildingData(EquipBuildingUnitDR, JsonData)
{
	k PLIST
	s BUBuildingDR=""
 	s PLIST(116)=JsonData.BDEquipDR
 	s PLIST(101)=JsonData.BDBuildName
 	s PLIST(102)=JsonData.BDBuildKey
 	s PLIST(117)=EquipBuildingUnitDR
 	s PLIST(82)=JsonData.BDStructDR
 	s PLIST(83)=JsonData.BDBuildingArea
 	s PLIST(84)=JsonData.BDUtilizationArea
 	s PLIST(85)=JsonData.BDSubArea
 	s PLIST(86)=JsonData.BDPlace
 	s PLIST(87)=$case(JsonData.BDOwnerFlag,"true":"1","false":"0",:"")
 	s PLIST(88)=JsonData.BDSelfUseArea
 	s PLIST(89)=JsonData.BDLendingArea
 	s PLIST(90)=JsonData.BDRentArea
 	s PLIST(91)=JsonData.BDWorkArea
 	s PLIST(92)=JsonData.BDIdleArea
 	s PLIST(93)=JsonData.BDOtherArea
 	s PLIST(94)=JsonData.BDLendCompany
 	s PLIST(95)=JsonData.BDRentCompany
 	s PLIST(96)=JsonData.BDOwnerCertificate
 	s PLIST(97)=JsonData.BDCertificateNo
 	s PLIST(98)=##Class(web.DHCEQCommon).TransValueFromPage(JsonData.BDCertificateDate,"date")
 	s PLIST(99)=JsonData.BDFloorNum
 	s PLIST(100)=JsonData.BDUnderFloorNum
 	s PLIST(101)=JsonData.BDBuildName
 	s PLIST(102)=JsonData.BDBuildKey
 	s PLIST(103)=JsonData.BDUseState
 	s PLIST(104)=JsonData.BDFunctionCat
 	s PLIST(105)=JsonData.BDFunctionSub
 	s PLIST(106)=JsonData.BDOwnerKind
 	s PLIST(107)=JsonData.BDOwnershipYear
 	s PLIST(108)=JsonData.BDOwner
 	s PLIST(109)=##Class(web.DHCEQCommon).TransValueFromPage(JsonData.BDCompletionDate,"date")
 	s PLIST(110)=JsonData.BDSelfUseFee
 	s PLIST(111)=JsonData.BDLendingFee
 	s PLIST(112)=JsonData.BDRentFee
 	s PLIST(113)=JsonData.BDWorkFee
 	s PLIST(114)=JsonData.BDIdleFee
 	s PLIST(115)=JsonData.BDOtherFee
	
	&SQL(select B_RowID into:BUBuildingDR from sqluser.DHC_EQBUBuilding where B_EquipDR = :JsonData.BDEquipDR)
	if (BUBuildingDR'="")
	{
		&SQL(Update SQLUSER.DHC_EQBUBuilding Values :PLIST() where B_RowID = :BUBuildingDR)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQBUBuilding Values :PLIST())
		s BUBuildingDR=$g(%ROWID)
	}
	q SQLCODE_"^"_BUBuildingDR
}

/// Creator：      ZX
/// CreatDate：    2020-04-10
/// Description:   建筑结构
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuilding","GetBuildingList")
/// modify by lmm 2021-07-07 2025902 增加出参描述，部分出参隐藏
Query GetBuildingList(Desc As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "TBuildName:%String:名称,TBuildKey:%String:建筑编号,Hidden:%String,Hidden:%String,Hidden:%String,TBuildingArea:%String:建筑面积,TUtilizationArea:%String:使用面积,TSubArea:%String:地下面积,TPlace:%String:位置,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,TFloorNum:%String:楼层数,TUnderFloorNum:%String:地下楼层数")
{
}

ClassMethod GetBuildingListExecute(ByRef qHandle As %Binary, Desc As %String = "", EquipDR As %String = "") As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	If EquipDR'="" Do
	.For  Set rowid=$Order(^DHCEQBuilding(0,"EquipDR",EquipDR,rowid)) Quit:rowid=""  Do
	..Do BuildDataGetBuildingList
	Else  Do
	.For  Set rowid=$Order(^DHCEQBuilding(rowid)) Quit:rowid=""  Do
	..Do BuildDataGetBuildingList
	Quit $$$OK
BuildDataGetBuildingList
    Do ResetVariablesGetBuildingList
	Set TRowID=rowid
	Set TEquipDR=$Piece($Get(^DHCEQBuilding(rowid)),"^",1)
	//add by lmm 2021-06-24
	i TEquipDR'="" s TBuildName=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	Set TBuildKey=$Piece($Get(^DHCEQBuilding(rowid)),"^",22)
	Set TStructDR=$Piece($Get(^DHCEQBuilding(rowid)),"^",2)
	Set TBuildingArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",3)
	Set TUtilizationArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",4)
	Set TSubArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",5)
	Set TPlace=$Piece($Get(^DHCEQBuilding(rowid)),"^",6)
	Set TOwnerFlag=$Piece($Get(^DHCEQBuilding(rowid)),"^",7)
	Set TSelfUseArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",8)
	Set TLendingArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",9)
	Set TRentArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",10)
	Set TWorkArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",11)
	Set TIdleArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",12)
	Set TOtherArea=$Piece($Get(^DHCEQBuilding(rowid)),"^",13)
	Set TLendCompany=$Piece($Get(^DHCEQBuilding(rowid)),"^",14)
	Set TRentCompany=$Piece($Get(^DHCEQBuilding(rowid)),"^",15)
	Set TOwnerCertificate=$Piece($Get(^DHCEQBuilding(rowid)),"^",16)
	Set TCertificateNo=$Piece($Get(^DHCEQBuilding(rowid)),"^",17)
	Set TCertificateDate=$Piece($Get(^DHCEQBuilding(rowid)),"^",18)
	Set TFloorNum=$Piece($Get(^DHCEQBuilding(rowid)),"^",19)
	Set TUnderFloorNum=$Piece($Get(^DHCEQBuilding(rowid)),"^",20)
 	d OutputRowGetBuildingList
	Quit
OutputRowGetBuildingList
	Set Data=$ListBuild(TBuildName,TBuildKey,TRowID,TEquipDR,TStructDR,TBuildingArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetBuildingList
	Set (TRowID,TEquipDR,TStructDR,TBuildingArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum,TBuildName,TBuildKey)=""
	Quit
}

ClassMethod GetBuildingListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuildingListExecute ]
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
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetBuildingListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuildingListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZX
/// CreatDate：    2020-04-10
/// Description:   房屋单元
Query BuildingUnit(EquipDR As %String = "", BuildingDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TBuildingDR:%String,TBuildingName:%String,TDesc:%String,TFloor:%String,TDoorNo:%String,TPlace:%String,TBuildingArea:%String,TUtilizationArea:%String,TStuct:%String,TUseLocDR:%String,TUseLoc:%String,TLendTypeDR:%String,TLendType:%String,TCompany:%String,TContractPerson:%String,TPurposeDR:%String,TPurpose:%String,TOriginalFee:%String,TRentFee:%String,TRentFeeType:%String,TBeginDate:%String,TEndDate:%String,TUserDR:%String,TUser:%String,TDate:%String,TSubmitUserDR:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod BuildingUnitExecute(ByRef qHandle As %Binary, EquipDR As %String = "", BuildingDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i (EquipDR="")&&(BuildingDR="") Quit $$$OK
	i BuildingDR'="" d
	.f  s rowid=$o(^DHCEQBuildingUnit(0,"Building",BuildingDR,rowid)) q:rowid=""  d
	..d BuildDataBuildingUnit
	e  d
	.s BuildingDR=0
	.f  s BuildingDR=$o(^DHCEQBuilding(0,"EquipDR",EquipDR,BuildingDR)) q:BuildingDR=""  d
	..f  s rowid=$o(^DHCEQBuildingUnit(0,"Building",BuildingDR,rowid)) q:rowid=""  d
	...d BuildDataBuildingUnit
	Quit $$$OK
BuildDataBuildingUnit
	d ResetVariablesBuildingUnit
	s TRowID=rowid
	s TBuildingDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",1)
	s EquipDR=$p($g(^DHCEQBuilding(TBuildingDR)),"^",1)
	s TBuildingName=$p($g(^DHCEQEquip(EquipDR)),"^",1) 
	s TDesc=$p($g(^DHCEQBuildingUnit(rowid)),"^",2)
	s TFloor=$p($g(^DHCEQBuildingUnit(rowid)),"^",3)
	s TDoorNo=$p($g(^DHCEQBuildingUnit(rowid)),"^",4)
	s TPlace=$p($g(^DHCEQBuildingUnit(rowid)),"^",5)
	s TBuildingArea=$p($g(^DHCEQBuildingUnit(rowid)),"^",6)
	s TUtilizationArea=$p($g(^DHCEQBuildingUnit(rowid)),"^",7)
	s TStuct=$p($g(^DHCEQBuildingUnit(rowid)),"^",8)
	s TUseLocDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",9)
	i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TLendTypeDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",10)
	i TLendTypeDR'="" s TLendType=$p($g(^DHCEQCCode("DHCEQCLendType",TLendTypeDR)),"^",2)
	s TCompany=$p($g(^DHCEQBuildingUnit(rowid)),"^",11)
	s TContractPerson=$p($g(^DHCEQBuildingUnit(rowid)),"^",12)
	s TPurposeDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",13)
	i TPurposeDR'="" s TPurpose=$p($g(^DHCEQCCode("DHCEQCLandPurpose",TPurposeDR)),"^",2)
	s TOriginalFee=$p($g(^DHCEQBuildingUnit(rowid)),"^",14)
	s TRentFee=$p($g(^DHCEQBuildingUnit(rowid)),"^",15)
	s TRentFeeType=$p($g(^DHCEQBuildingUnit(rowid)),"^",16)
	s TBeginDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",17)
	i TBeginDate'="" s TBeginDate=##Class(web.DHCEQCommon).TransValueToPage(TBeginDate,"date")
	s TEndDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",18)
	i TEndDate'="" s TEndDate=##Class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
	s TUserDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",19)
	i TUserDR'="" s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
	s TDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",20)
	i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	s TSubmitUserDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",21)
	i TSubmitUserDR'="" s TSubmitUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",22)
	i TSubmitDate'="" s TSubmitDate=##Class(web.DHCEQCommon).TransValueToPage(TSubmitDate,"date")
	s TSubmitTime=$p($g(^DHCEQBuildingUnit(rowid)),"^",23)
	s TAuditUserDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",24)
	i TAuditUserDR'="" s TAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",25)
	i TAuditDate'="" s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	s TAuditTime=$p($g(^DHCEQBuildingUnit(rowid)),"^",26)
	s TStatus=$p($g(^DHCEQBuildingUnit(rowid)),"^",27)
	s TStatus=##Class(web.DHCEQ.EM.BUSBuilding).GetBuildingUnitStatusDisplay(TStatus)
	s THold1=$p($g(^DHCEQBuildingUnit(rowid)),"^",28)
	s THold2=$p($g(^DHCEQBuildingUnit(rowid)),"^",29)
	s THold3=$p($g(^DHCEQBuildingUnit(rowid)),"^",30)
	s THold4=$p($g(^DHCEQBuildingUnit(rowid)),"^",31)
	s THold5=$p($g(^DHCEQBuildingUnit(rowid)),"^",32)
	s TBuildingArea=##Class(web.DHCEQCommon).FormatNumber(TBuildingArea,"",2)
	s TUtilizationArea=##Class(web.DHCEQCommon).FormatNumber(TUtilizationArea,"",2)
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TRentFee=##Class(web.DHCEQCommon).FormatNumber(TRentFee,"",2)
	
	d OutputRowBuildingUnit
	quit
OutputRowBuildingUnit
	Set Data=$lb(TRowID,TBuildingDR,TBuildingName,TDesc,TFloor,TDoorNo,TPlace,TBuildingArea,TUtilizationArea,TStuct,TUseLocDR,TUseLoc,TLendTypeDR,TLendType
	,TCompany,TContractPerson,TPurposeDR,TPurpose,TOriginalFee,TRentFee,TRentFeeType,TBeginDate,TEndDate,TUserDR,TUser,TDate
	,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBuildingUnit
	s (TRowID,EquipDR,TBuildingDR,TBuildingName,TDesc,TFloor,TDoorNo,TPlace,TBuildingArea,TUtilizationArea,TStuct,TUseLocDR,TUseLoc,TLendTypeDR,TLendType
	,TCompany,TContractPerson,TPurposeDR,TPurpose,TOriginalFee,TRentFee,TRentFeeType,TBeginDate,TEndDate,TUserDR,TUser,TDate
	,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod BuildingUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildingUnitExecute ]
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

ClassMethod BuildingUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildingUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBuildingUnitStatusDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "新增"
	i +status=1  q "提交"
	i +status=2  q "审核"
	q "未定义"
}

/// add by CZF 2022-11-01 建筑结构
/// 入参：建筑结构
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSBuilding","GetBuildingStructure","")
Query GetBuildingStructure(vDesc) As %SQLQuery(ROWSPEC = "TRowID:%String,TCode:%String:代码,TName:%String:描述")
{
}

ClassMethod GetBuildingStructureExecute(ByRef qHandle As %Binary, vDesc) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vDesc=$ZCONVERT(vDesc,"U")  
    s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCBuildingStruct",rowid))  quit:rowid=""  d
    .q:$p($g(^DHCEQCCode("DHCEQCBuildingStruct",rowid)),"^",4)="Y"
    .s Desc=$p($g(^DHCEQCCode("DHCEQCBuildingStruct",rowid)),"^",2)
    .s Code=$p($g(^DHCEQCCode("DHCEQCBuildingStruct",rowid)),"^",1)
    .q:(vDesc'="")&&($ZCONVERT(Desc,"U")'[vDesc)&&($ZCONVERT(Code,"U")'[vDesc)
    .d OutputRowGetBuyMode
    Quit $$$OK
OutputRowGetBuyMode
    s Data=$lb(rowid,Code,Desc)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetBuildingStructureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuildingStructureExecute ]
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

ClassMethod GetBuildingStructureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuildingStructureExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
