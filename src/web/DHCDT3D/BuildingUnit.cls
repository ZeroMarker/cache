Class web.DHCDT3D.BuildingUnit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ----------------------------------
/// 创建:lmm  2020-09-21
/// 描述:   获取空间房屋数据明细
/// 	入参:BuildingDR:建筑  FloorIndex:楼层
/// 		 DoorNo:门牌号    UnitType:房间类型
/// 		 Unit3DObjID:房间3d对象id  Desc:房屋名称
/// 		 UseLocDR:使用科室id   AllDesc:模糊查询
/// 		 UnitTypeCode：房间类型代码   UseLoc：使用科室
/// 		 Status：状态   WaterCond：上下水
/// 		 BuilAreaMin：最小房间面积 BuilAreaMax：最大房间面积 
/// 		 
/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.BuildingUnit","GetBuildingUnitDetail","","","","","","","","","21","")
/// ----------------------------------
Query GetBuildingUnitDetail(BuildingDR As %String = "", FloorIndex As %String = "", DoorNo As %String = "", UnitType As %String = "", Unit3DObjID As %String = "", Desc As %String = "", UseLocDR As %String = "", AllDesc As %String = "", UnitTypeCode As %String = "", UseLoc As %String = "", Status As %String = "", WaterCond As %String = "", BuilAreaMin As %String = "", BuilAreaMax As %String = "") As %Query(ROWSPEC = "BURowID:%String,BUBuildingDR:%String,BUFloorIndex:%String,BUDoorNo:%String,BUDesc:%String,BUUseLoc:%String,BUUnitTypeDesc:%String,BUStatusDesc:%String,BUContractPersonDR:%String,BUPurposeDesc:%String,BUUseLocDR:%String,BURoomFacingDesc:%String,BUMinPeople:%String,BUMaxPeople:%String,BUUnitType:%String,BUStatus:%String,BUPurpose:%String,BURoomFacing:%String,BUBuildingArea:%String,BUWaterCondDesc:%String,BUWaterCond:%String,BUElectricCondDesc:%String,BUElectricCond:%String,BUSewageDisposalDesc:%String,BUSewageDisposal:%String,BUSewageDisposalDesc:%String,BURadProtectDesc:%String,BURadProtect:%String,BUFloorNo:%String") [ SqlProc ]
{
}

ClassMethod GetBuildingUnitDetailExecute(ByRef qHandle As %Binary, BuildingDR As %String = "", FloorIndex As %String = "", DoorNo As %String = "", UnitType As %String = "", Unit3DObjID As %String = "", Desc As %String = "", UseLocDR As %String = "", AllDesc As %String = "", UnitTypeCode As %String = "", UseLoc As %String = "", Status As %String = "", WaterCond As %String = "", BuilAreaMin As %String = "", BuilAreaMax As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	i (BuildingDR'="")&&(FloorIndex'="")  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBUBuildingUnit(0,"BuildingFloor",BuildingDR,FloorIndex,rowid)) quit:rowid=""  d
	..d SetBuildingUnitDetail
	e  i (BuildingDR'="")&&(FloorIndex="")  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBUBuildingUnit(0,"Building",BuildingDR,rowid)) quit:rowid=""  d
	..d SetBuildingUnitDetail
	e  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBUBuildingUnit(rowid)) quit:rowid=""  d
	..d SetBuildingUnitDetail
	
	Quit $$$OK
OutputRowGetBuildingUnitDetail
	Set Data=$lb(TRowID,TBuildingDR,TFloorIndex,TDoorNo,TDesc,TUseLoc,TUnitType,TStatus,TContractPersonDR,TPurpose,TUseLocDR,TRoomFacing,TMinPeople,TMaxPeople,TUnitTypeID,TStatusID,TPurposeID,TRoomFacingID,TBuildingArea,TWaterCondDesc,TWaterCond,TElectricCondDesc,TElectricCond,TSewageDisposalDesc,TSewageDisposal,TSewageDisposalDesc,TRadProtectDesc,TRadProtect,TFloorNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
	
SetBuildingUnitDetail
	s (TRowID,TBuildingDR,TFloorIndex,TDoorNo,TDesc,TUseLocDR,TUseLoc,TUnitType,TStatus,TContractPersonDR,TPurpose,TDepartmentDR,TRoomFacing,TMinPeople,TMaxPeople,TUnitTypeID,TStatusID,TPurposeID,TRoomFacingID,TFloorNo)=""
	s TRowID=rowid
	Q:(Unit3DObjID'="")&&(Unit3DObjID'=TRowID)
	s TBuildingDR=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",1)
	s TFloorIndex=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",2)
	s TFloorID=$o(^DHCEQBUFloor(0,"BuildingFloorIndex",TBuildingDR,TFloorIndex,0))
	s TFloorNo=$p($g(^DHCEQBUFloor(TFloorID)),"^",4)
	s TDesc=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",3)
	q:(Desc'="")&&(Desc'=TDesc)
	s TDoorNo=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",4)
	q:(DoorNo'="")&&(DoorNo'=TDoorNo)
	s TUseLocDR=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",9)
	q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	q:(UseLoc'="")&&(UseLoc'=TUseLoc)
	s TUnitTypeID=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",10)
	q:(UnitType'="")&&(UnitType'=TUnitTypeID)
	i TUnitTypeID'="" s TUnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",TUnitTypeID)),"^",1)
	q:(UnitTypeCode'="")&&(UnitTypeCode'=TUnitTypeCode)
	i TUnitTypeID'="" s TUnitType=$p($g(^DHCEQCCode("DHCEQCLendType",TUnitTypeID)),"^",2)
	//s TStatusID=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",11)
	s TStatusID=+(rowid#3)
	i TDoorNo="B2-F4-A-21-R008" s TStatusID=1
	i TDoorNo="B2-F4-A-21-R009" s TStatusID=1
	q:(Status'="")&&(Status'=TStatusID)
	s TBuildingArea=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",6)
	q:(BuilAreaMin'="")&&(BuilAreaMin>TBuildingArea)
	q:(BuilAreaMax'="")&&(BuilAreaMax<TBuildingArea)
	s TBuildingArea=TBuildingArea
	s TElectricCond=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",22)
	s TElectricCondDesc=$case(TElectricCond,"0":"无380V","1":"具备380V","2":"无380V可改造",:"")
	s TSewageDisposal=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",24)
	s TSewageDisposalDesc=$case(TSewageDisposal,"0":"无污水处理","1":"有污水处理","2":"可改造",:"")
	s TRadProtect=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",25)
	s TRadProtectDesc=$case(TRadProtect,"0":"无辐射防护","1":"有辐射防护","2":"可改造",:"")
	s TWaterCond=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",23)
	q:(WaterCond'="")&&(WaterCond'=TWaterCond)
	s TWaterCondDesc=$case(TWaterCond,"0":"无上下水","1":"有上下水","2":"可改造上下水",:"")
	//s TStatus=$case(TStatusID,"0":"在用","2":"预约","1":"故障","3":"未用",:"")
	s TStatus=$case(TStatusID,"0":"正常未用","1":"在用","2":"故障停用","3":"预约","4":"变更无效",:"")
	s TContractPersonDR=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",12)
	s TPurposeID=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",13)
	i TPurposeID'="" s TPurpose=$case(TPurposeID,"1":"临床","2":"医技","3":"医辅","4":"行政后勤",:"")
	//i TPurposeID'="" s TPurpose=$p($g(^DHCEQCCode("DHCEQCLandPurpose",TPurposeID)),"^",2)
	q:(AllDesc'="")&&((TDesc'[AllDesc)&&(TDoorNo'[AllDesc)&&(TUseLoc'[AllDesc)&&(TUnitType'[AllDesc)&&(TPurpose'[AllDesc))
	s TRoomFacingID=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",19)
	s TRoomFacing=$case(TRoomFacingID,"1":"东","2":"南","3":"西","4":"北","12":"东南","14":"东北","23":"西南","34":"西北",:"")
	s TMinPeople=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",20)
	s TMaxPeople=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",21)
	d OutputRowGetBuildingUnitDetail
	quit
}

ClassMethod GetBuildingUnitDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuildingUnitDetailExecute ]
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

ClassMethod GetBuildingUnitDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuildingUnitDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by lmm 2020-07-07
/// desc:删除房屋建筑信息
/// Command:w ##class(web.DHCDT3D.BuildingUnit).DeleteData("17$CHAR(3)18")
ClassMethod DeleteData(RowIDStr As %String = "") As %String
{
	 s FloorIndex=""
	 s SQLCODE=0
	Set $ZT="ERRORDelete"	
	TSTART	

	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-24 分隔符号处理
	s Length=$L(RowIDStr,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		k RowID
		s RowID=	$p(RowIDStr,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
		q:RowID=""
	    if RowID'=""
	    {
			&sql(Delete from sqluser.DHC_EQBUBuildingUnit where BU_RowID=:RowID)
			i SQLCODE=100 s SQLCODE=0
	
		}
		
		
	}	
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	} 

	
	TCOMMIT
	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg_SQLCODE     //返回错误消息 ;
}

/// add by lmm 2020-07-07
/// desc:保存房屋建筑信息
/// w ##Class(web.DHCDT3D.BuildingUnit).SaveBuildingUnit("{""BURowID"":""775"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-A-11-R003"",""BUDesc"":""普外3诊室11"",""BUUseLoc"":""普外科门诊"",""BUUnitTypeDesc"":""诊室"",""BUStatusDesc"":""在用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""371"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""2"",""BUStatus"":""1"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""10"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""777"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-C-11-R004"",""BUDesc"":""泌尿外4诊室"",""BUUseLoc"":""泌尿外科门诊"",""BUUnitTypeDesc"":""诊室"",""BUStatusDesc"":""正常未用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""109"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""2"",""BUStatus"":""0"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""10"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""779"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-B-11-R001"",""BUDesc"":""骨外1诊室"",""BUUseLoc"":""骨关节外科门诊"",""BUUnitTypeDesc"":""诊室"",""BUStatusDesc"":""故障停用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""48"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""2"",""BUStatus"":""2"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""10"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""781"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-C-99-R002"",""BUDesc"":""清洁间"",""BUUseLoc"":""泌尿外科门诊"",""BUUnitTypeDesc"":""其他 （原租、借、自用、闲置）"",""BUStatusDesc"":""在用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""109"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""20"",""BUStatus"":""1"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""5"",""BUWaterCondDesc"":"""",""BUWaterCond"":"""",""BUElectricCondDesc"":"""",""BUElectricCond"":"""",""BUSewageDisposalDesc"":"""",""BUSewageDisposal"":"""",""BURadProtectDesc"":"""",""BURadProtect"":"""",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""783"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-C-11-R007"",""BUDesc"":""泌尿外7诊室"",""BUUseLoc"":""泌尿外科门诊"",""BUUnitTypeDesc"":""诊室"",""BUStatusDesc"":""正常未用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""109"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""2"",""BUStatus"":""0"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""10"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""785"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-C-11-R003"",""BUDesc"":""泌尿外3诊室"",""BUUseLoc"":""泌尿外科门诊"",""BUUnitTypeDesc"":""诊室"",""BUStatusDesc"":""故障停用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""109"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""2"",""BUStatus"":""2"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""10"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""787"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-B-11-R006"",""BUDesc"":""骨外6诊室"",""BUUseLoc"":""骨关节外科门诊"",""BUUnitTypeDesc"":""诊室"",""BUStatusDesc"":""在用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""48"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""2"",""BUStatus"":""1"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""10"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""789"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-C-31-R001"",""BUDesc"":""医生办公室"",""BUUseLoc"":""泌尿外科门诊"",""BUUnitTypeDesc"":""医护办公室"",""BUStatusDesc"":""正常未用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""109"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""7"",""BUStatus"":""0"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""15"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""791"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-C-11-R001"",""BUDesc"":""泌尿外1诊室"",""BUUseLoc"":""泌尿外科门诊"",""BUUnitTypeDesc"":""诊室"",""BUStatusDesc"":""故障停用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""109"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""2"",""BUStatus"":""2"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""10"",""BUWaterCondDesc"":""有上下水"",""BUWaterCond"":""1"",""BUElectricCondDesc"":""具备380V"",""BUElectricCond"":""1"",""BUSewageDisposalDesc"":""无污水处理"",""BUSewageDisposal"":""0"",""BURadProtectDesc"":""无辐射防护"",""BURadProtect"":""0"",""BUFloorNo"":""B1-F2""}$CHAR(3){""BURowID"":""793"",""BUBuildingDR"":""1"",""BUFloorIndex"":""2"",""BUDoorNo"":""B1-F2-C-99-R001"",""BUDesc"":""处置室"",""BUUseLoc"":""泌尿外科门诊"",""BUUnitTypeDesc"":""其他 （原租、借、自用、闲置）"",""BUStatusDesc"":""在用"",""BUContractPersonDR"":"""",""BUPurposeDesc"":"""",""BUUseLocDR"":""109"",""BURoomFacingDesc"":"""",""BUMinPeople"":"""",""BUMaxPeople"":"""",""BUUnitType"":""20"",""BUStatus"":""1"",""BUPurpose"":"""",""BURoomFacing"":"""",""BUBuildingArea"":""5"",""BUWaterCondDesc"":"""",""BUWaterCond"":"""",""BUElectricCondDesc"":"""",""BUElectricCond"":"""",""BUSewageDisposalDesc"":"""",""BUSewageDisposal"":"""",""BURadProtectDesc"":"""",""BURadProtect"":"""",""BUFloorNo"":""B1-F2""}","")
ClassMethod SaveBuildingUnit(dataList, userName)
{
	k PLIST
	s SQLCODE=0
	s ISLRowIDs=""
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i) 
		q:valList=""
		k PLIST,BURowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBUBuildingUnit",JsonData,.PLIST)
		s BURowID = JsonData.BURowID
	    if BURowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQBUBuildingUnit Values :PLIST() where BU_RowID = :BURowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQBUBuildingUnit Values :PLIST())
			s FRowID=$g(%ROWID)
		}
		
		
	}	
	q SQLCODE_"^"_BURowID
}

/// add by lmm 2020-07-07
/// desc:保存房屋类型
/// w ##Class(web.DHCDT3D.BuildingUnit).UpdateBuildingUnitUnitType()
ClassMethod UpdateBuildingUnitUnitType()
{
	k PLIST
	s SQLCODE=0
	s rowid=0
	f  s rowid=$o(^DHCEQBUBuildingUnit(rowid)) quit:rowid=""  d
	.;s TUnitTypeID=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",10)
	.s TDoorNo=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",4)
	.s TUnitTypeDesc=$p(TDoorNo,"-",4)
	.s UnitTypeID=""
	.&SQL(select LT_RowID into :UnitTypeID from SQLUSER.DHC_EQCLendType where LT_Code=:TUnitTypeDesc)
	.k PLIST
	.s PLIST(11)=UnitTypeID
	.&SQL(Update SQLUSER.DHC_EQBUBuildingUnit Values :PLIST() where BU_RowID = :rowid)
	
	Q SQLCODE
}

/// add by lmm 2020-07-07
/// desc:保存设备房屋建筑信息
ClassMethod SaveEquipBuildingData(JsonData)
{
	k PLIST
	s EquipBuildingDR=""
	&SQL(select B_BuildingDR into:EquipBuildingDR from sqluser.DHC_EQBUBuilding where B_RowID = :JsonData.BUBuildingDR)
	s JsonData.BUBuildingDR=EquipBuildingDR
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBuildingUnit",JsonData,.PLIST)
	
	s EquipBuildingUnitDR=""
	&SQL(select BU_RowID into:EquipBuildingUnitDR from sqluser.DHC_EQBuildingUnit where BU_DoorNo=:JsonData.BUDoorNo)
	if (EquipBuildingUnitDR'="")
	{
		&SQL(Update SQLUSER.DHC_EQBuildingUnit Values :PLIST() where BU_RowID = :EquipBuildingUnitDR)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQBuildingUnit Values :PLIST())
		s EquipBuildingUnitDR=$g(%ROWID)
	}
	q SQLCODE_"^"_EquipBuildingUnitDR
}

/// w ##Class(web.DHCDT3D.BuildingUnit).GetBuilUnitTypeNum("","21")
/// desc：统计各类型房间的数量
/// 在用：1  未用：0   故障：2
///   类型：再用病房：21,1
/// {"21":"3","21,1":"3"}
ClassMethod GetBuilUnitTypeNum(UseLoc As %String = "", UnitType As %String = "")
{
	k ^TempDHCEQ("UnitTypeNum")
	k ^TempDHCEQ("UnitTypeStatusNum")
	k ^TempDHCEQ("UnitTypeLocNum")
	k ^TempDHCEQ("UnitTypeLocStatusNum")
	s UnitTypeNumInfo={}
	s rowid=0
	f  s rowid=$o(^DHCEQBUBuildingUnit(rowid)) quit:rowid=""  d
	.s (TUnitTypeCode,TUnitTypeID,TStatus,TUseLocDR,TUseLoc)=""
	.s TUnitTypeID=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",10)
	.i TUnitTypeID'="" s TUnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",TUnitTypeID)),"^",1)
	.q:(UnitType'="")&&(TUnitTypeCode'=UnitType)
	.s TUseLocDR=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",9)
	.i TUseLocDR'=""  d
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	.q:(UseLoc'="")&&(UseLoc'=TUseLoc)
	.s TStatus=+(rowid#3)
	.i TUnitTypeID'=""  d
	..i ('$d(^TempDHCEQ("UnitTypeNum",TUnitTypeID)))  d
	...s ^TempDHCEQ("UnitTypeNum",TUnitTypeID)=1
	..e  d
	...s ^TempDHCEQ("UnitTypeNum",TUnitTypeID)=^TempDHCEQ("UnitTypeNum",TUnitTypeID)+1
	..i ('$d(^TempDHCEQ("UnitTypeStatusNum",TStatus,TUnitTypeID)))  d
	...s ^TempDHCEQ("UnitTypeStatusNum",TStatus,TUnitTypeID)=1
	..e  d
	...s ^TempDHCEQ("UnitTypeStatusNum",TStatus,TUnitTypeID)=^TempDHCEQ("UnitTypeStatusNum",TStatus,TUnitTypeID)+1
	.i (TUseLocDR'="")&&(TUnitTypeID'="")  d
	..i ('$d(^TempDHCEQ("UnitTypeLocNum",TUseLocDR,TUnitTypeID)))  d
	...s ^TempDHCEQ("UnitTypeLocNum",TUseLocDR,TUnitTypeID)=1
	..e  d
	...s ^TempDHCEQ("UnitTypeLocNum",TUseLocDR,TUnitTypeID)=^TempDHCEQ("UnitTypeLocNum",TUseLocDR,TUnitTypeID)+1
	.i (TUseLocDR'="")&&(TUnitTypeID'="")  d
	..i ('$d(^TempDHCEQ("UnitTypeLocStatusNum",TUseLocDR,TStatus,TUnitTypeID)))  d
	...s ^TempDHCEQ("UnitTypeLocStatusNum",TUseLocDR,TStatus,TUnitTypeID)=1
	..e  d
	...s ^TempDHCEQ("UnitTypeLocStatusNum",TUseLocDR,TStatus,TUnitTypeID)=^TempDHCEQ("UnitTypeLocStatusNum",TUseLocDR,TStatus,TUnitTypeID)+1
	
	
	
	s UnitTypeID=0
	f  s UnitTypeID=$o(^TempDHCEQ("UnitTypeNum",UnitTypeID)) quit:UnitTypeID=""  d
	.s UnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",UnitTypeID)),"^",1)
	.s UnitTypeNum=^TempDHCEQ("UnitTypeNum",UnitTypeID)
	.d UnitTypeNumInfo.%Set(UnitTypeCode,UnitTypeNum)
	
	
	s Status=-1
	f  s Status=$o(^TempDHCEQ("UnitTypeStatusNum",Status)) quit:Status=""  d
	.s UnitTypeID=0
	.f  s UnitTypeID=$o(^TempDHCEQ("UnitTypeStatusNum",Status,UnitTypeID)) quit:UnitTypeID=""  d
	..s UnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",UnitTypeID)),"^",1)
	..s UnitTypeNum=^TempDHCEQ("UnitTypeStatusNum",Status,UnitTypeID)
	..d UnitTypeNumInfo.%Set(UnitTypeCode_","_Status,UnitTypeNum)
	
	
	s LocID=0
	f  s LocID=$o(^TempDHCEQ("UnitTypeLocNum",LocID)) quit:LocID=""  d
	.s UnitTypeID=0
	.f  s UnitTypeID=$o(^TempDHCEQ("UnitTypeLocNum",LocID,UnitTypeID)) quit:UnitTypeID=""  d
	..s UnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",UnitTypeID)),"^",1)
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", LocID)
	..s UnitTypeNum=^TempDHCEQ("UnitTypeLocNum",LocID,UnitTypeID)
	..d UnitTypeNumInfo.%Set(UnitTypeCode_",,"_TUseLoc,UnitTypeNum)
	
	s LocID=0
	f  s LocID=$o(^TempDHCEQ("UnitTypeLocStatusNum",LocID)) quit:LocID=""  d
	.s Status=-1
	.f  s Status=$o(^TempDHCEQ("UnitTypeLocStatusNum",LocID,Status)) quit:Status=""  d
	..s UnitTypeID=0
	..f  s UnitTypeID=$o(^TempDHCEQ("UnitTypeLocStatusNum",LocID,Status,UnitTypeID)) quit:UnitTypeID=""  d
	...s UnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",UnitTypeID)),"^",1)
	...s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", LocID)
	...s UnitTypeNum=^TempDHCEQ("UnitTypeLocStatusNum",LocID,Status,UnitTypeID)
	...d UnitTypeNumInfo.%Set(UnitTypeCode_","_Status_","_TUseLoc,UnitTypeNum)
	
	
	Q UnitTypeNumInfo.%ToJSON()
}

/// w ##Class(web.DHCDT3D.BuildingUnit).GetBuildingAreaByLoc("1")
/// desc：统计各类型房间的数量
/// 在用：1  未用：0   故障：2
///   类型：再用病房：21,1
/// {"21":"3","21,1":"3"}
ClassMethod GetBuildingAreaByLoc(UseLocDR As %String = "")
{
	
	s BuildingAreaTotal=0
	s rowid=0
	f  s rowid=$o(^DHCEQBUBuildingUnit(rowid)) quit:rowid=""  d
	.s (TUnitTypeCode,TUnitTypeID,TStatus,TUseLocDR,TUseLoc)=""
	.s TUseLocDR=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",9)
	.q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	.s TBuildingArea=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",6)
	.s BuildingAreaTotal=BuildingAreaTotal+TBuildingArea
	
	Q BuildingAreaTotal
}

ClassMethod GetUnitTypeDesc(UnitTypeID)
{
	i UnitTypeID="" q ""
	s UnitType=$case(UnitTypeID,"0":"闲置","11":"诊室","12":"病房","21":"手术室","22":"治疗室","23":"检查室","31":"医护办公室","32":"消毒供应室","41":"后勤办公室","42":"会议室","43":"机房","44":"配电房","45":"保安室","46":"卫生间","47":"杂物房","51":"走廊","52":"停车场","53":"绿化","99":"其他",:"")
	Q UnitType
}

/// add by lmm 2021-06-09
/// w ##Class(web.DHCDT3D.BuildingUnit).GetUnitTypeHtml()
ClassMethod GetUnitTypeHtml()
{
	s Info={}
	s EQGroupInfo={}
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("闲置","0","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("诊室","11","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("病房","12","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("手术室","21","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("治疗室","22","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("检查室","23","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("医护办公室","31","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("消毒供应室","32","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("后勤办公室","41","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("会议室","42","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("机房","43","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("配电室","44","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("保安室","45","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("卫生间","46","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("杂物房","47","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("走廊","51","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("停车场","52","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("绿化","53","","","","",,EQGroupInfo)
	d ##Class(web.DHCEQ.Plat.CTChartsDefineNew).CreateChartsDataNew("其他","99","","","","",,EQGroupInfo)
	//d Info.%Set("UnitType",EQGroupInfo)
	q EQGroupInfo.%ToJSON()
}

/// ----------------------------------
/// 创建:lmm  2020-09-21
/// 描述:   获取空间房屋数据明细
/// 	入参:BuildingDR:建筑  FloorIndex:楼层
/// 		 DoorNo:门牌号    UnitType:房间类型
/// 		 Unit3DObjID:房间3d对象id  Desc:房屋名称
/// 		 UseLocDR:使用科室id   AllDesc:模糊查询
/// 		 UnitTypeCode：房间类型代码   UseLoc：使用科室
/// 		 Status：状态   WaterCond：上下水
/// 		 BuilAreaMin：最小房间面积 BuilAreaMax：最大房间面积 
/// 		 
/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.BuildingUnit","GetShortBuildingUnit","","","")
/// ----------------------------------
Query GetShortBuildingUnit(BuildingDR As %String = "", Desc As %String = "", UseLocDR As %String = "") As %Query(ROWSPEC = "Hidden:%String,Hidden:%String,Hidden:%String,TDoorNo:%String:门牌号,TDesc:%String:名称,TUseLoc:%String:使用科室,Hidden:%String:房间类型,Hidden:%String,TFloorNo:%String:楼层号") [ SqlProc ]
{
}

ClassMethod GetShortBuildingUnitExecute(ByRef qHandle As %Binary, BuildingDR As %String = "", Desc As %String = "", UseLocDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (BuildingDR'="")  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBUBuildingUnit(0,"Building",BuildingDR,rowid)) quit:rowid=""  d
	..d SetShortBuildingUnit
	e  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBUBuildingUnit(rowid)) quit:rowid=""  d
	..d SetShortBuildingUnit
	
	Quit $$$OK
OutputRowGetShortBuildingUnit
	Set Data=$lb(TRowID,TBuildingDR,TFloorIndex,TDoorNo,TDesc,TUseLoc,TUnitType,TUseLocDR,TFloorNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
	
SetShortBuildingUnit
	s (TRowID,TBuildingDR,TFloorIndex,TDoorNo,TDesc,TUseLocDR,TUseLoc,TUnitType,TStatus,TContractPersonDR,TPurpose,TDepartmentDR,TRoomFacing,TMinPeople,TMaxPeople,TUnitTypeID,TStatusID,TPurposeID,TRoomFacingID,TFloorNo)=""
	s TRowID=rowid
	s TBuildingDR=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",1)
	s TFloorIndex=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",2)
	s TFloorID=$o(^DHCEQBUFloor(0,"BuildingFloorIndex",TBuildingDR,TFloorIndex,0))
	s TFloorNo=$p($g(^DHCEQBUFloor(TFloorID)),"^",4)
	s TDesc=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",3)
	q:(Desc'="")&&(Desc'=TDesc)
	s TDoorNo=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",4)
	s TUseLocDR=$p($g(^DHCEQBUBuildingUnit(rowid)),"^",9)
	q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	i TUnitTypeID'="" s TUnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",TUnitTypeID)),"^",1)
	i TUnitTypeID'="" s TUnitType=$p($g(^DHCEQCCode("DHCEQCLendType",TUnitTypeID)),"^",2)
	d OutputRowGetShortBuildingUnit
	quit
}

ClassMethod GetShortBuildingUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortBuildingUnitExecute ]
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

ClassMethod GetShortBuildingUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortBuildingUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
