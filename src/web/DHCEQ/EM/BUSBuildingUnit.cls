Class web.DHCEQ.EM.BUSBuildingUnit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// ----------------------------------
/// 创建:lmm  2020-09-21
/// 描述:   查询各设备属性设备数量
/// 	入参:Building:建筑
/// 		 Floor:楼层
/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.BuildingUnit","GetBuildingUnitDetail","","","","","","","","","21","")
/// ----------------------------------
Query GetBuildingUnitDetail(BuildingDR As %String = "", FloorIndex As %String = "", DoorNo As %String = "", UnitType As %String = "", Unit3DObjID As %String = "", Desc As %String = "", UseLocDR As %String = "", AllDesc As %String = "", UnitTypeCode As %String = "", UseLoc As %String = "", Status As %String = "", WaterCond As %String = "", BuilAreaMin As %String = "", BuilAreaMax As %String = "") As %Query(ROWSPEC = "Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,BUDesc:%String,BUUseLoc:%String,BUUnitTypeDesc:%String,BUStatusDesc:%String,BUContractPersonDR:%String,BUPurposeDesc:%String,BUUseLocDR:%String,BURoomFacingDesc:%String,BUMinPeople:%String,BUMaxPeople:%String,BUUnitType:%String,BUStatus:%String,BUPurpose:%String,BURoomFacing:%String,BUBuildingArea:%String,BUWaterCondDesc:%String,BUWaterCond:%String,BUElectricCondDesc:%String,BUElectricCond:%String,BUSewageDisposalDesc:%String,BUSewageDisposal:%String,BUSewageDisposalDesc:%String,BURadProtectDesc:%String,BURadProtect:%String,BUFloorNo:%String") [ SqlProc ]
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
	.f  s rowid=$o(^DHCEQBuildingUnit(0,"BuildingFloor",BuildingDR,FloorIndex,rowid)) quit:rowid=""  d
	..d SetBuildingUnitDetail
	e  i (BuildingDR'="")&&(FloorIndex="")  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBuildingUnit(0,"Building",BuildingDR,rowid)) quit:rowid=""  d
	..d SetBuildingUnitDetail
	e  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBuildingUnit(rowid)) quit:rowid=""  d
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
	s TBuildingDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",1)
	s TFloorIndex=$p($g(^DHCEQBuildingUnit(rowid)),"^",2)
	s TFloorID=$o(^DHCEQBUFloor(0,"BuildingFloorIndex",TBuildingDR,TFloorIndex,0))
	s TFloorNo=$p($g(^DHCEQBUFloor(TFloorID)),"^",4)
	s TDesc=$p($g(^DHCEQBuildingUnit(rowid)),"^",3)
	q:(Desc'="")&&(Desc'=TDesc)
	s TDoorNo=$p($g(^DHCEQBuildingUnit(rowid)),"^",4)
	q:(DoorNo'="")&&(DoorNo'=TDoorNo)
	s TUseLocDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",9)
	q:(UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	q:(UseLoc'="")&&(UseLoc'=TUseLoc)
	s TUnitTypeID=$p($g(^DHCEQBuildingUnit(rowid)),"^",10)
	q:(UnitType'="")&&(UnitType'=TUnitTypeID)
	i TUnitTypeID'="" s TUnitTypeCode=$p($g(^DHCEQCCode("DHCEQCLendType",TUnitTypeID)),"^",1)
	q:(UnitTypeCode'="")&&(UnitTypeCode'=TUnitTypeCode)
	i TUnitTypeID'="" s TUnitType=$p($g(^DHCEQCCode("DHCEQCLendType",TUnitTypeID)),"^",2)
	s TStatusID=$p($g(^DHCEQBuildingUnit(rowid)),"^",11)
	q:(Status'="")&&(Status'=TStatusID)
	s TBuildingArea=$p($g(^DHCEQBuildingUnit(rowid)),"^",6)
	q:(BuilAreaMin'="")&&(BuilAreaMin>TBuildingArea)
	q:(BuilAreaMax'="")&&(BuilAreaMax<TBuildingArea)
	s TBuildingArea=TBuildingArea
	s TElectricCond=$p($g(^DHCEQBuildingUnit(rowid)),"^",22)
	s TElectricCondDesc=$case(TElectricCond,"0":"无380V","1":"具备380V","2":"无380V可改造",:"")
	s TSewageDisposal=$p($g(^DHCEQBuildingUnit(rowid)),"^",24)
	s TSewageDisposalDesc=$case(TSewageDisposal,"0":"无污水处理","1":"有污水处理","2":"可改造",:"")
	s TRadProtect=$p($g(^DHCEQBuildingUnit(rowid)),"^",25)
	s TRadProtectDesc=$case(TRadProtect,"0":"无辐射防护","1":"有辐射防护","2":"可改造",:"")
	s TWaterCond=$p($g(^DHCEQBuildingUnit(rowid)),"^",23)
	q:(WaterCond'="")&&(WaterCond'=TWaterCond)
	s TWaterCondDesc=$case(TWaterCond,"0":"无上下水","1":"有上下水","2":"可改造上下水",:"")
	//s TStatus=$case(TStatusID,"0":"在用","2":"预约","1":"故障","3":"未用",:"")
	s TStatus=$case(TStatusID,"0":"正常未用","1":"在用","2":"故障停用","3":"预约","4":"变更无效",:"")
	s TContractPersonDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",12)
	s TPurposeID=$p($g(^DHCEQBuildingUnit(rowid)),"^",13)
	i TPurposeID'="" s TPurpose=$case(TPurposeID,"1":"临床","2":"医技","3":"医辅","4":"行政后勤",:"")
	//i TPurposeID'="" s TPurpose=$p($g(^DHCEQCCode("DHCEQCLandPurpose",TPurposeID)),"^",2)
	q:(AllDesc'="")&&((TDesc'[AllDesc)&&(TDoorNo'[AllDesc)&&(TUseLoc'[AllDesc)&&(TUnitType'[AllDesc)&&(TPurpose'[AllDesc))
	s TRoomFacingID=$p($g(^DHCEQBuildingUnit(rowid)),"^",19)
	s TRoomFacing=$case(TRoomFacingID,"1":"东","2":"南","3":"西","4":"北","12":"东南","14":"东北","23":"西南","34":"西北",:"")
	s TMinPeople=$p($g(^DHCEQBuildingUnit(rowid)),"^",20)
	s TMaxPeople=$p($g(^DHCEQBuildingUnit(rowid)),"^",21)
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

}
