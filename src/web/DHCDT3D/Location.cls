Class web.DHCDT3D.Location Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by zc 2023-02-23
/// desc:批量保存存放地点信息
/// w ##class(web.DHCDT3D.Location).SaveLocations()
ClassMethod SaveLocations(Data)
{
	s Iterator = Data.%GetIterator()
    //json遍历
    while Iterator.%GetNext(.key,.val) 
    {
	    s RowJson=val	
	    s JsonData = ##class(web.DHCDT3D.Location).SaveLocationJson(RowJson)
	}
	//w "ok"
	Quit JsonData
}

/// add by zc 2023-02-23
/// desc:根据JOSN串信息保存存放地点
/// w ##class(web.DHCDT3D.Location).SaveLocationJson("{""LHospitalDR"":"""",""LDateFrom"":""2023-02-23"",""LDateTo"":""2023-02-24"",""LRemark"":"""",""LInvalidFlag"":""false"",""B3DBuildID"":"""",""LType"":""1"",""LLocDR"":"""","LPlace":""1"",""LDesc"":""1"",""BU3DRoomID"":"""",""LCode"":"""",""LHold2"":"""",""LHold1"":""""}") 
ClassMethod SaveLocationJson(JsonData)
{
	s LRowID=""
	s DT3DBuildingDR = ""
	s DT3DBuildUnitDR = ""
	S SQLCODE=0
	&SQL(select B_RowID into:DT3DBuildingDR from sqluser.DHC_DT3DBuilding where B_3DBuildID = :JsonData.B3DBuildID and B_ActiveFlag='Y')
	i SQLCODE=100 s SQLCODE=0
	&SQL(select BU_RowID into:DT3DBuildUnitDR from sqluser.DHC_DT3DBuildUnit where BU_3DRoomID = :JsonData.BU3DRoomID and BU_InvalidFlag<>'Y')
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE 
	{
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	d JsonData.%Set("LBuildingDR",DT3DBuildingDR)
	d JsonData.%Set("LBuildingUnitDR",DT3DBuildUnitDR)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(JsonData.%ToJSON())
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCLocation",JsonData,.PLIST)
	if (DT3DBuildingDR'="")&&(DT3DBuildUnitDR'="")
	{
		&SQL(select L_RowID into:LRowID from sqluser.DHC_EQCLocation where L_BuildingDR = :DT3DBuildingDR and L_BuildingUnitDR = :DT3DBuildUnitDR and L_InvalidFlag<>'Y')
     	i SQLCODE=100 s SQLCODE=0
	}
    if LRowID'=""
    {
		&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :LRowID)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQCLocation Values :PLIST())
		s LRowID=$g(%ROWID)
	}
	if SQLCODE
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	else
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,LRowID)
	}
	quit SQLCODE
}

/// add by zc 2023-02-23
/// desc:保存存放地点信息
/// w ##class(web.DHCDT3D.Location).SaveLocation("{"LRowID":"1","B3DBuildID":"B1","BU3DRoomID":"RB1_B1-F2_040","LLocDR":"371","LType":"1","LHospitalDR":"","LInvalidFlag":"","LHold1":"B1-F2","LHold2":"RB1_B1-F2_040","LCode":"","LDesc":"","LPlace":"","LDateFrom":"2020-01-01","LDateTo":"2020-01-02","LRemark":""}") 
ClassMethod SaveLocation(dataList, userName)
{
	s SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:+SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)
		q:valList=""
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s DT3DBuildingDR=""
		&SQL(select B_RowID into:DT3DBuildingDR from sqluser.DHC_DT3DBuilding where B_3DBuildID = :JsonData.B3DBuildID and B_ActiveFlag='Y')
		i SQLCODE=100 s SQLCODE=0
		s DT3DBuildUnitDR=""
		&SQL(select BU_RowID into:DT3DBuildUnitDR from sqluser.DHC_DT3DBuildUnit where BU_3DRoomID = :JsonData.BU3DRoomID and BU_InvalidFlag<>'Y')
		i SQLCODE=100 s SQLCODE=0
		s SQLCODE=##Class(web.DHCDT3D.Location).SaveDT3DLocationData(DT3DBuildingDR,DT3DBuildUnitDR,JsonData)
		
	}	
	q SQLCODE
}

ClassMethod SaveDT3DLocationData(DT3DBuildingDR, DT3DBuildUnitDR, JsonData)
{
	k PLIST
	s LRowID=JsonData.LRowID
 	s PLIST(2)=JsonData.LCode
 	s PLIST(3)=JsonData.LDesc
 	s PLIST(4)=JsonData.LType
 	s PLIST(5)=JsonData.LHospitalDR
 	s PLIST(6)=JsonData.LLocDR
 	s PLIST(7)=DT3DBuildingDR
 	s PLIST(8)=DT3DBuildUnitDR
 	s PLIST(9)=JsonData.LPlace
 	s PLIST(10)=JsonData.LDateFrom
 	s PLIST(11)="Y"
 	s PLIST(12)=JsonData.LRemark
 	s PLIST(13)=JsonData.LHold1
 	s PLIST(14)=JsonData.LHold2
	
	s LocationDR=""
	&SQL(select L_RowID into:LocationDR from sqluser.DHC_EQCLocation where L_BuildingDR = :DT3DBuildingDR and L_BuildingUnitDR = :DT3DBuildUnitDR and L_InvalidFlag<>'Y')
	if (LocationDR'="")
	{
		&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :LocationDR)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQCLocation Values :PLIST())
		s LRowID=$g(%ROWID)
	}
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.Location","GetLocation","","","","","9996")
/// ----------------------------------
Query GetLocation(Desc As %String = "", BUNo As %String = "", FloorID As %String = "", FBuildingDR As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,TBUNo:%String,TDesc:%String,TBuilding:%String,TFloorNo:%String,TF3DFloorID:%String,TBU3DRoomID:%String") [ SqlProc ]
{
}

ClassMethod GetLocationExecute(ByRef qHandle As %Binary, Desc As %String = "", BUNo As %String = "", FloorID As %String = "", FBuildingDR As %String = "", Job As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i Job="" s Job=$j
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp("GetLocation",curuser)
	s rowid=0
	f  s rowid=$Order(^DHCEQCCode("DHCEQCLocation",rowid)) quit:rowid=""  d
	.q:$P($g(^DHCEQCCode("DHCEQCLocation",rowid)),"^",11)="Y"
	.q:$P($G(^DHCEQCCode("DHCEQCLocation",rowid)),"^",6)=""
	.q:$P($G(^DHCEQCCode("DHCEQCLocation",rowid)),"^",7)=""
	.q:(Desc'="")&&($P($G(^DHCEQCCode("DHCEQCLocation",rowid)),"^",2)'=Desc)
	.q:(FBuildingDR'="")&&($P($G(^DHCEQCCode("DHCEQCLocation",rowid)),"^",6)'=FBuildingDR)
	.s (TRowID,TBUNo,TDesc,TBuilding,TFloorNo,TBuildingDR,TBuildUnitDR,TFloorDR,TF3DFloorID,TBU3DRoomID)=""
	.s TRowID=rowid
	.s TBuildingDR=$P($G(^DHCEQCCode("DHCEQCLocation",rowid)),"^",6)
	.s TBuildUnitDR=$P($G(^DHCEQCCode("DHCEQCLocation",rowid)),"^",7)
	.s TBUNo=$p($g(^DHCDT3DBuildUnit(TBuildUnitDR)),"^",5)
	.q:(BUNo'="")&&(BUNo'=TBUNo)
	.s TBU3DRoomID=$p($g(^DHCDT3DBuildUnit(TBuildUnitDR)),"^",13)
	.s TFloorDR=$p($g(^DHCDT3DBuildUnit(TBuildUnitDR)),"^",1)
	.q:(FloorID'="")&&(FloorID'=TFloorDR)
	.s TFloorNo=$p($g(^DHCDT3DFloor(TFloorDR)),"^",4)
	.s TF3DFloorID=$p($g(^DHCDT3DFloor(TFloorDR)),"^",5)
	.s TBuilding=$Piece($Get(^DHCDT3DBuilding(TBuildingDR)),"^",2)
	.s TDesc=$P($G(^DHCEQCCode("DHCEQCLocation",rowid)),"^",2)
	.d OutputRowGetLocation
	
	
	Quit $$$OK
OutputRowGetLocation
	Set Data=$lb(TRowID,TBUNo,TDesc,TBuilding,TFloorNo,TF3DFloorID,TBU3DRoomID)
	s ^DHCEQTemp("GetLocation",curuser,Job,index)=TRowID
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
}

ClassMethod GetLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocationExecute ]
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

ClassMethod GetLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// czf 2022-06-24
/// 获取导出明细数量
/// node:"GetLocation" 
/// w ##class(web.DHCDT3D.Location).GetTempDataRows("GetLocation",9996,77)
ClassMethod GetTempDataRows(node As %Library.String = "", job, User)
{
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $o(^DHCEQTemp(node,User,job,""),-1)
}

/// czf 2022-06-24
/// 获取行导出明细数据
/// node:"GetLocation" 
/// w ##class(web.DHCDT3D.Location).GetTempData("GetLocation",9996,77,1)
ClassMethod GetTempData(node As %Library.String = "", job, User, gnum)
{
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $g(^DHCEQTemp(node,User,job,gnum))
}

/// w ##class(web.DHCDT3D.Location).GetOneLocation(441)
ClassMethod GetOneLocation(RowID As %Library.String = "")
{
    i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("","")
    s $ZT="ERRORGetOneLocation"
    s obj=##Class(User.DHCEQCLocation).%OpenId(RowID)
    s objInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(obj)
    d objInfo.%Set("BName","")
    d objInfo.%Set("BUNo","") 
    d objInfo.%Set("FFloorNum","") 
    i obj.LBuildingDR'="" d
    .d objInfo.%Set("BName",obj.LBuildingDR.BName)
    i obj.LBuildingUnitDR'="" d
    .d objInfo.%Set("BUNo",obj.LBuildingUnitDR.BUNo) 
    .i obj.LBuildingUnitDR.BUFloorDR'="" d
    ..d objInfo.%Set("FFloorNum",obj.LBuildingUnitDR.BUFloorDR.FFloorNum)
    d objInfo.%Set("LRowID",RowID)
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,objInfo)
ERRORGetOneLocation
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// w ##class(web.DHCDT3D.Location).GetLocationByRoomNo("B1F10001")
ClassMethod GetLocationByRoomNo(RoomNo As %Library.String = "")
{
	i RoomNo="" q ""
	i '$d(^DHCDT3DBuildUnit(0,"BUNo",RoomNo))  q ""
	s LastRowID=""
	s rowid=0
	f  s rowid=$Order(^DHCDT3DBuildUnit(0,"BUNo",RoomNo,rowid)) quit:rowid=""  d
	.q:$p($g(^DHCDT3DBuildUnit(rowid)),"^",25)="Y"
	.s lrowid=0
	.f  s lrowid=$Order(^DHCEQCCode("DHCEQCLocation",0,"BuildUnit",rowid,lrowid)) quit:lrowid=""  d
	..q:$P($G(^DHCEQCCode("DHCEQCLocation",lrowid)),"^",11)="Y"
	..s LastRowID=lrowid
	i LastRowID="" q ""
	s BuildUnitDR=$P($G(^DHCEQCCode("DHCEQCLocation",LastRowID)),"^",7)
	s BU3DRoomID=$p($g(^DHCDT3DBuildUnit(BuildUnitDR)),"^",13)
	s FloorDR=$p($g(^DHCDT3DBuildUnit(BuildUnitDR)),"^",1)
	s F3DFloorID=""
	i FloorDR'="" s F3DFloorID=$p($g(^DHCDT3DFloor(FloorDR)),"^",5)
	s Desc=$P($G(^DHCEQCCode("DHCEQCLocation",LastRowID)),"^",2)
	q LastRowID_"^"_Desc_"^"_F3DFloorID_"^"_BU3DRoomID
}

/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.Location","GetRoomInventory","","PDD2022090001","","","","")
/// 根据盘点计划、盘点单、科室、楼层、盘点时间（为空不限时间）、类组（为空不限类组）获取各个房间的盘点信息
Query GetRoomInventory(pInventoryPlanDR As %String = "", pInventoryNo As %String = "", pInventoryLocDR As %String = "", pFloorID As %String = "", pInventoryDate As %String = "", pIEquipTypeIDs As %String = "") As %Query(ROWSPEC = "BU3DRoomID:%String,RoomInventoryStatus:%String,InventoryNum:%String,UnInventoryNum:%String,InExceptionNum:%String,LoseNum:%String") [ SqlProc ]
{
}

ClassMethod GetRoomInventoryExecute(ByRef qHandle As %Binary, pInventoryPlanDR As %String = "", pInventoryNo As %String = "", pInventoryLocDR As %String = "", pFloorID As %String = "", pInventoryDate As %String = "", pIEquipTypeIDs As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	k ^DHCEQTemp("GetRoomInventory",$j)
 	i (pInventoryPlanDR="")&&(pInventoryNo="") Quit $$$OK
 	s pInventoryDR=""
	i pInventoryNo'="" d
	.s pInventoryDR=$o(^DHCEQInventory(0,"InventoryNo",pInventoryNo,0)) 
	s pFloorDR=""
	i pFloorID'="" d
	.s pFloorDR=$o(^DHCDT3DFloor(0,"FloorID",pFloorID,0)) 
	s index=1
	s pInventoryDate=##class(web.DHCEQCommon).TransValueFromPage(pInventoryDate,"date")
	i pInventoryPlanDR'="" d
	.s InventoryDR=0
	.f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",pInventoryPlanDR,InventoryDR)) quit:(InventoryDR="")  d
	..q:(pInventoryDR'="")&&(InventoryDR'=pInventoryDR)
	..s rowid=0
	..f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid))  quit:(rowid="")  d
	...q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",4)'=pInventoryLocDR)
	...s InEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	...q:(pIEquipTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds($p($g(^DHCEQEquip(InEquipDR)),"^",63),pIEquipTypeIDs)'=1)
	...s LocationObj=##Class(web.DHCDT3D.EquipLocation).GetRoomIDByEquip(InEquipDR)
	...s InELocationDR = LocationObj.%Get("LocationDR")
	...s LBuildingUnitDR = LocationObj.%Get("3DBuildUnitDR")
	...s InBUFloorDR=LocationObj.%Get("3DFloorDR")
	...s InBU3DRoomID=LocationObj.%Get("3DRoomID")
	...q:(pFloorDR'="")&&(InBUFloorDR'=pFloorDR)
	...i InBU3DRoomID="" s InBU3DRoomID=0
	...s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID)=""
	...s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"TotalNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"TotalNum"))+1
	...i pInventoryDate="" d
	....i $p($g(^DHCEQInventoryList(rowid)),"^",12)'="" d
	.....s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"InventoryNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"InventoryNum"))+1
	....i $p($g(^DHCEQInventoryList(rowid)),"^",14)=3  d
	.....s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"LoseNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"LoseNum"))+1
	...e  d
	....i $p($g(^DHCEQInventoryList(rowid)),"^",12)'="" d
	.....i $p($g(^DHCEQInventoryList(rowid)),"^",12)<=pInventoryDate d
	......s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"InventoryNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"InventoryNum"))+1
	......i $p($g(^DHCEQInventoryList(rowid)),"^",14)=3  d
	.......s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"LoseNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"LoseNum"))+1
	..s ierowid=0
	..f  s ierowid=$o(^DHCEQInventoryException(0,"Inventory",InventoryDR,ierowid))  quit:ierowid=""  d
	...q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryException(ierowid)),"^",9)'=pInventoryLocDR)
	...s IELocationDR=$p($g(^DHCEQInventoryException(ierowid)),"^",12)
	...s (IEBuildingUnitDR,IEBUFloorDR,IEBU3DRoomID)=""
	...i IELocationDR'="" s IEBuildingUnitDR=$p($g(^DHCEQCCode("DHCEQCLocation",IELocationDR)),"^",7)
	...i IEBuildingUnitDR'="" d
	....s IEBUFloorDR=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",1)
	....s IEBU3DRoomID=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",13)
	...q:(pFloorDR'="")&&(IEBUFloorDR'=pFloorDR)
	...i IEBU3DRoomID="" s IEBU3DRoomID=0
	...i pInventoryDate="" d
	....s ^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum")=$g(^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum"))+1
	...e  d
	....i $p($g(^DHCEQInventoryException(ierowid)),"^",14)<=pInventoryDate d
	.....s ^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum")=$g(^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum"))+1
	e  d
	.q:pInventoryDR=""
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",pInventoryDR,rowid))  quit:(rowid="")  d
	..q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",4)'=pInventoryLocDR)
	..s InEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	..q:(pIEquipTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds($p($g(^DHCEQEquip(InEquipDR)),"^",63),pIEquipTypeIDs)'=1)
	..s LocationObj=##Class(web.DHCDT3D.EquipLocation).GetRoomIDByEquip(InEquipDR)
	..s InELocationDR = LocationObj.%Get("LocationDR")
	..s LBuildingUnitDR = LocationObj.%Get("3DBuildUnitDR")
	..s InBUFloorDR=LocationObj.%Get("3DFloorDR")
	..s InBU3DRoomID=LocationObj.%Get("3DRoomID")
	..q:(pFloorDR'="")&&(InBUFloorDR'=pFloorDR)
	..i InBU3DRoomID="" s InBU3DRoomID=0
	..s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID)=""
	..s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"TotalNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"TotalNum"))+1
	..i pInventoryDate="" d
	...i $p($g(^DHCEQInventoryList(rowid)),"^",12)'="" d
	....s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"InventoryNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"InventoryNum"))+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",14)=3  d
	....s ^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"LoseNum")=$g(^DHCEQTemp("GetRoomInventory",$j,InBU3DRoomID,"LoseNum"))+1
	..e  d
	...i $p($g(^DHCEQInventoryList(rowid)),"^",12)'="" d
	....i $p($g(^DHCEQInventoryList(rowid)),"^",12)<=pInventoryDate d
	.....s ^DHCEQTemp("GetRoomInventory",$j,+InBU3DRoomID,"InventoryNum")=$g(^DHCEQTemp("GetRoomInventory",$j,+InBU3DRoomID,"InventoryNum"))+1
	.....i $p($g(^DHCEQInventoryList(rowid)),"^",14)=3  d
	......s ^DHCEQTemp("GetRoomInventory",$j,+InBU3DRoomID,"LoseNum")=$g(^DHCEQTemp("GetRoomInventory",$j,+InBU3DRoomID,"LoseNum"))+1
	.s ierowid=0
	.f  s ierowid=$o(^DHCEQInventoryException(0,"Inventory",pInventoryDR,ierowid))  quit:ierowid=""  d
	..q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryException(ierowid)),"^",9)'=pInventoryLocDR)
	..q:(pIEquipTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds($p($g(^DHCEQInventoryException(ierowid)),"^",28),pIEquipTypeIDs)'=1)
	..s IELocationDR=$p($g(^DHCEQInventoryException(ierowid)),"^",12)
	..s (IEBuildingUnitDR,IEBUFloorDR,IEBU3DRoomID)=""
	..i IELocationDR'="" s IEBuildingUnitDR=$p($g(^DHCEQCCode("DHCEQCLocation",IELocationDR)),"^",7)
	..i IEBuildingUnitDR'="" d
	...s IEBUFloorDR=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",1)
	...s IEBU3DRoomID=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",13)
	..q:(pFloorDR'="")&&(IEBUFloorDR'=pFloorDR)
	..i IEBU3DRoomID="" s IEBU3DRoomID=0
	..s ^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID)=""
	..i pInventoryDate="" d
	...s ^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum")=$g(^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum"))+1
	..e  d
	...i $p($g(^DHCEQInventoryException(ierowid)),"^",14)<=pInventoryDate d
	....s ^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum")=$g(^DHCEQTemp("GetRoomInventory",$j,IEBU3DRoomID,"InExceptionNum"))+1
	
	s RoomID=0
	f  s RoomID=$o(^DHCEQTemp("GetRoomInventory",$j,RoomID))  quit:(RoomID="")  d
	.s (BU3DRoomID,RoomInventoryStatus,InventoryNum,UnInventoryNum,InExceptionNum,TotalNum)=""
	.s BU3DRoomID=RoomID
	.s InventoryNum=+$g(^DHCEQTemp("GetRoomInventory",$j,RoomID,"InventoryNum"))
	.s TotalNum=+$g(^DHCEQTemp("GetRoomInventory",$j,RoomID,"TotalNum"))
	.s UnInventoryNum=TotalNum-InventoryNum
	.s RoomInventoryStatus="盘点中"
	.i UnInventoryNum=0 s RoomInventoryStatus="已盘完"
	.i TotalNum=UnInventoryNum s RoomInventoryStatus="未盘"
	.s InExceptionNum=+$g(^DHCEQTemp("GetRoomInventory",$j,RoomID,"InExceptionNum"))
	.s LoseNum=+$g(^DHCEQTemp("GetRoomInventory",$j,RoomID,"LoseNum"))
	.d OutputRowGetRoomInventory
	
	k ^DHCEQTemp("GetRoomInventory",$j)
	Quit $$$OK
OutputRowGetRoomInventory
	Set Data=$lb(BU3DRoomID,RoomInventoryStatus,InventoryNum,UnInventoryNum,InExceptionNum,LoseNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
}

ClassMethod GetRoomInventoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoomInventoryExecute ]
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

ClassMethod GetRoomInventoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoomInventoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.Location","GetRoomUserInventory","","PDD2022090001","","B2-F2","","")
/// 根据盘点计划、盘点单、科室、楼层、盘点时间（为空不限时间）、类组（为空不限类组）获取各个房间的盘点信息
Query GetRoomUserInventory(pInventoryPlanDR As %String = "", pInventoryNo As %String = "", pInventoryLocDR As %String = "", pFloorID As %String = "", pInventoryDate As %String = "", pIEquipTypeIDs As %String = "") As %Query(ROWSPEC = "User:%String,InventoryNum:%String,InExceptionNum:%String,RoomID:%String,InFrist:%String,InLast:%String") [ SqlProc ]
{
}

ClassMethod GetRoomUserInventoryExecute(ByRef qHandle As %Binary, pInventoryPlanDR As %String = "", pInventoryNo As %String = "", pInventoryLocDR As %String = "", pFloorID As %String = "", pInventoryDate As %String = "", pIEquipTypeIDs As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i (pInventoryPlanDR="")&&(pInventoryNo="") Quit $$$OK
 	s pInventoryDR=""
	i pInventoryNo'="" d
	.s pInventoryDR=$o(^DHCEQInventory(0,"InventoryNo",pInventoryNo,0)) 
	s pFloorDR=""
	i pFloorID'="" d
	.s pFloorDR=$o(^DHCDT3DFloor(0,"FloorID",pFloorID,0)) 
 	k ^DHCEQTemp("GetRoomUserInventory",$j)
 	k ^DHCEQTemp("GetBU3DRoomIDUserInventory",$j)
	s index=1
	s pInventoryDate=##class(web.DHCEQCommon).TransValueFromPage(pInventoryDate,"date")
	i pInventoryPlanDR'="" d
	.s InventoryDR=0
	.f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",pInventoryPlanDR,InventoryDR)) quit:(InventoryDR="")  d
	..q:(pInventoryDR'="")&&(InventoryDR'=pInventoryDR)
	..s rowid=0
	..f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid))  quit:(rowid="")  d
	...q:$p($g(^DHCEQInventoryList(rowid)),"^",12)=""
	...q:$p($g(^DHCEQInventoryList(rowid)),"^",13)=""
	...s ILUserDR=$p($g(^DHCEQInventoryList(rowid)),"^",11)
	...q:ILUserDR=""
	...q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",4)'=pInventoryLocDR)
	...s InEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	...q:(pIEquipTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds($p($g(^DHCEQEquip(InEquipDR)),"^",63),pIEquipTypeIDs)'=1)
	...s LocationObj=##Class(web.DHCDT3D.EquipLocation).GetRoomIDByEquip(InEquipDR)
	...s InBUFloorDR=LocationObj.%Get("3DFloorDR")
	...s InBU3DRoomID=LocationObj.%Get("3DRoomID")
	...q:(pFloorDR'="")&&(InBUFloorDR'=pFloorDR)
	...i InBU3DRoomID="" s InBU3DRoomID=0
	...s ^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR)=""
	...s ^DHCEQTemp("GetBU3DRoomIDUserInventory",$j,ILUserDR,InBU3DRoomID)=""
	...i pInventoryDate="" d
	....s ^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum"))+1
	...e  d
	....i $p($g(^DHCEQInventoryList(rowid)),"^",12)<=pInventoryDate d
	.....s ^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum"))+1
	..s ierowid=0
	..f  s ierowid=$o(^DHCEQInventoryException(0,"Inventory",InventoryDR,ierowid))  quit:ierowid=""  d
	...q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryException(ierowid)),"^",9)'=pInventoryLocDR)
	...s IELocationDR=$p($g(^DHCEQInventoryException(ierowid)),"^",12)
	...s IEUserDR=$p($g(^DHCEQInventoryException(ierowid)),"^",32)
	...q:IEUserDR=""
	...s (IEBuildingUnitDR,IEBUFloorDR,IEBU3DRoomID)=""
	...i IELocationDR'="" s IEBuildingUnitDR=$p($g(^DHCEQCCode("DHCEQCLocation",IELocationDR)),"^",7)
	...i IEBuildingUnitDR'="" d
	....s IEBUFloorDR=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",1)
	....s IEBU3DRoomID=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",13)
	...q:(pFloorDR'="")&&(IEBUFloorDR'=pFloorDR)
	...i IEBU3DRoomID="" s IEBU3DRoomID=0
	...s ^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR)=""
	...s ^DHCEQTemp("GetBU3DRoomIDUserInventory",$j,IEUserDR,IEBU3DRoomID)=""
	...i pInventoryDate="" d
	....s ^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum"))+1
	...e  d
	....i $p($g(^DHCEQInventoryException(ierowid)),"^",14)<=pInventoryDate d
	.....s ^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum"))+1
	e  d
	.q:pInventoryDR=""
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",pInventoryDR,rowid))  quit:(rowid="")  d
	..q:$p($g(^DHCEQInventoryList(rowid)),"^",12)=""
	..q:$p($g(^DHCEQInventoryList(rowid)),"^",13)=""
	..q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",4)'=pInventoryLocDR)
	..s InEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	..q:(pIEquipTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds($p($g(^DHCEQEquip(InEquipDR)),"^",63),pIEquipTypeIDs)'=1)
	..s ILUserDR=$p($g(^DHCEQInventoryList(rowid)),"^",11)
	..q:ILUserDR=""
	..s LocationObj=##Class(web.DHCDT3D.EquipLocation).GetRoomIDByEquip(InEquipDR)
	..s InBUFloorDR=LocationObj.%Get("3DFloorDR")
	..s InBU3DRoomID=LocationObj.%Get("3DRoomID")
	..q:(pFloorDR'="")&&(InBUFloorDR'=pFloorDR)
	..i InBU3DRoomID="" s InBU3DRoomID=0
	..;w ILUserDR_" "_InEquipDR_" "_InBU3DRoomID,!
	..s ^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR)=""
	..s ^DHCEQTemp("GetBU3DRoomIDUserInventory",$j,ILUserDR,InBU3DRoomID)=""
	..i pInventoryDate="" d
	...s ^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum"))+1
	..e  d
	...i $p($g(^DHCEQInventoryList(rowid)),"^",12)<=pInventoryDate d
	....s ^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,ILUserDR,"InventoryNum"))+1
	.s ierowid=0
	.f  s ierowid=$o(^DHCEQInventoryException(0,"Inventory",pInventoryDR,ierowid))  quit:ierowid=""  d
	..q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryException(ierowid)),"^",9)'=pInventoryLocDR)
	..q:(pIEquipTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds($p($g(^DHCEQInventoryException(ierowid)),"^",28),pIEquipTypeIDs)'=1)
	..s IELocationDR=$p($g(^DHCEQInventoryException(ierowid)),"^",12)
	..s IEUserDR=$p($g(^DHCEQInventoryException(ierowid)),"^",32)
	..q:IEUserDR=""
	..s (IEBuildingUnitDR,IEBUFloorDR,IEBU3DRoomID)=""
	..i IELocationDR'="" s IEBuildingUnitDR=$p($g(^DHCEQCCode("DHCEQCLocation",IELocationDR)),"^",7)
	..i IEBuildingUnitDR'="" d
	...s IEBUFloorDR=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",1)
	...s IEBU3DRoomID=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",13)
	..q:(pFloorDR'="")&&(IEBUFloorDR'=pFloorDR)
	..i IEBU3DRoomID="" s IEBU3DRoomID=0
	..s ^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR)=""
	..s ^DHCEQTemp("GetBU3DRoomIDUserInventory",$j,IEUserDR,IEBU3DRoomID)=""
	..i pInventoryDate="" d
	...s ^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum"))+1
	..e  d
	...i $p($g(^DHCEQInventoryException(ierowid)),"^",14)<=pInventoryDate d
	....s ^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum")=$g(^DHCEQTemp("GetRoomUserInventory",$j,IEUserDR,"InExceptionNum"))+1

	s UserID=0
	f  s UserID=$o(^DHCEQTemp("GetRoomUserInventory",$j,UserID))  quit:(UserID="")  d
	.s (User,InventoryNum,InExceptionNum)=""
	.s User=##class(web.DHCEQCommon).GetTrakNameByID("user",UserID)
	.s InventoryNum=+$g(^DHCEQTemp("GetRoomUserInventory",$j,UserID,"InventoryNum"))
	.s InExceptionNum=+$g(^DHCEQTemp("GetRoomUserInventory",$j,UserID,"InExceptionNum"))
	.s BU3DRoomID=""
	.f  s BU3DRoomID=$o(^DHCEQTemp("GetBU3DRoomIDUserInventory",$j,UserID,BU3DRoomID))  quit:(BU3DRoomID="")  d
	..s (RoomID,InFrist,InLast,RoomInfo)=""
	..s RoomID=BU3DRoomID
	..s RoomInfo=##class(web.DHCDT3D.Location).GetUserInventoryInfo(pInventoryPlanDR,pInventoryDR,UserID,pInventoryLocDR,RoomID)
	..s InFrist=##class(web.DHCEQCommon).TransValueToPage($p(RoomInfo,"^",1),"date")_" "_##class(web.DHCEQCommon).TransValueToPage($p(RoomInfo,"^",2),"time")
	..s InLast=##class(web.DHCEQCommon).TransValueToPage($p(RoomInfo,"^",3),"date")_" "_##class(web.DHCEQCommon).TransValueToPage($p(RoomInfo,"^",4),"time")
	..d OutputRowGetRoomUserInventory
	
	k ^DHCEQTemp("GetRoomUserInventory",$j)
	k ^DHCEQTemp("GetBU3DRoomIDUserInventory",$j)
	Quit $$$OK
OutputRowGetRoomUserInventory
	Set Data=$lb(User,InventoryNum,InExceptionNum,RoomID,InFrist,InLast)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
}

ClassMethod GetRoomUserInventoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoomUserInventoryExecute ]
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

ClassMethod GetRoomUserInventoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoomUserInventoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCDT3D.Location).GetUserInventoryInfo("",3,56,"","")
ClassMethod GetUserInventoryInfo(vInventoryPlanDR As %String = "", vInventoryDR As %String = "", vUser As %String = "", vInventoryLocDR As %String = "", vRoomID As %String = "")
{
	s (MinDate,MaxDate,InventoryDate)=0 
	s (FisrtRoomID,LastRoomID)=""
	i (vInventoryPlanDR="")&&(vInventoryDR="") q ""
	i vInventoryPlanDR'="" d
	.s uInventoryDR=0
	.f  s uInventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",vInventoryPlanDR,uInventoryDR)) quit:(uInventoryDR="")  d
	..s urowid=0
	..f  s urowid=$o(^DHCEQInventoryList(0,"Inventory",uInventoryDR,urowid))  quit:(urowid="")  d
	...q:$p($g(^DHCEQInventoryList(urowid)),"^",11)'=vUser
	...q:(vInventoryLocDR'="")&&($p($g(^DHCEQInventoryList(urowid)),"^",4)'=vInventoryLocDR)
	...s InventoryDate=$p($g(^DHCEQInventoryList(urowid)),"^",12)*86400+$p($g(^DHCEQInventoryList(urowid)),"^",13)
	...s InUEquipDR=$p($g(^DHCEQInventoryList(urowid)),"^",2)
	...s InLocationObj=##Class(web.DHCDT3D.EquipLocation).GetRoomIDByEquip(InUEquipDR)
	...s InUBU3DRoomID=InLocationObj.%Get("3DRoomID")
	...q:(vRoomID'="")&&(InUBU3DRoomID'=vRoomID)
	...i MinDate=0 s MinDate=InventoryDate
	...i MinDate>InventoryDate d
	....s MinDate=InventoryDate
	...i MaxDate<InventoryDate d
	....s MaxDate=InventoryDate
	e  d
	.s nrowid=0
	.f  s nrowid=$o(^DHCEQInventoryList(0,"Inventory",vInventoryDR,nrowid))  quit:(nrowid="")  d
	..q:$p($g(^DHCEQInventoryList(nrowid)),"^",11)'=vUser
	..q:(vInventoryLocDR'="")&&($p($g(^DHCEQInventoryList(nrowid)),"^",4)'=vInventoryLocDR)
	..s InventoryDate=$p($g(^DHCEQInventoryList(nrowid)),"^",12)*86400+$p($g(^DHCEQInventoryList(nrowid)),"^",13)
	..s InUEquipDR=$p($g(^DHCEQInventoryList(nrowid)),"^",2)
	..s InLocationObj=##Class(web.DHCDT3D.EquipLocation).GetRoomIDByEquip(InUEquipDR)
	..s InUBU3DRoomID=InLocationObj.%Get("3DRoomID")
	..q:(vRoomID'="")&&(InUBU3DRoomID'=vRoomID)
	..i MinDate=0 s MinDate=InventoryDate
	..i MinDate>InventoryDate d
	...s MinDate=InventoryDate
	..i MaxDate<InventoryDate d
	...s MaxDate=InventoryDate

	s FisrtDate=+$p($fn(MinDate/86400,""),".",1)
	s FisrtTime=MinDate-(FisrtDate*86400)
	s LastDate=+$p($fn(MaxDate/86400,""),".",1)
	s LastTime=MaxDate-(LastDate*86400)
	i FisrtDate=0 s FisrtDate=""
	i FisrtTime=0 s FisrtTime=""
	i LastDate=0 s LastDate=""
	i LastTime=0 s LastTime=""
	q FisrtDate_"^"_FisrtTime_"^"_LastDate_"^"_LastTime
}

/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.Location","GetRoomEquipList","","PDD2022090001","","B2-F2","","","","")
/// 根据盘点计划、盘点单、科室、楼层、盘点时间（为空不限时间）、类组（为空不限类组）获取各个盘点人的盘点信息
Query GetRoomEquipList(pInventoryPlanDR As %String = "", pInventoryNo As %String = "", pInventoryLocDR As %String = "", pFloorID As %String = "", pInventoryDate As %String = "", pIEquipTypeIDs As %String = "", pBU3DRoomID As %String = "", pDisplayFlag As %String = "") As %Query(ROWSPEC = "EqName:%String,EqNo:%String,ILStatusDesc:%String,BUNo:%String,BU3DRoomID:%String") [ SqlProc ]
{
}

ClassMethod GetRoomEquipListExecute(ByRef qHandle As %Binary, pInventoryPlanDR As %String = "", pInventoryNo As %String = "", pInventoryLocDR As %String = "", pFloorID As %String = "", pInventoryDate As %String = "", pIEquipTypeIDs As %String = "", pBU3DRoomID As %String = "", pDisplayFlag As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (pInventoryPlanDR="")&&(pInventoryNo="") Quit $$$OK
	s pInventoryDR=""
	i pInventoryNo'="" d
	.s pInventoryDR=$o(^DHCEQInventory(0,"InventoryNo",pInventoryNo,0)) 
	s pFloorDR=""
	i pFloorID'="" d
	.s pFloorDR=$o(^DHCDT3DFloor(0,"FloorID",pFloorID,0)) 
	k ^DHCEQTemp("GetRoomEquipList",$j)
	s pInventoryDate=##class(web.DHCEQCommon).TransValueFromPage(pInventoryDate,"date")
	i pInventoryPlanDR'="" d
	.s InventoryDR=0
	.f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",pInventoryPlanDR,InventoryDR)) quit:(InventoryDR="")  d
	..q:(pInventoryDR'="")&&(InventoryDR'=pInventoryDR)
	..d BuildInventoryDataList
	e  d
	.q:pInventoryDR=""
	.s InventoryDR=pInventoryDR
	.d BuildInventoryDataList
	
	s RoomID=0
	f  s RoomID=$o(^DHCEQTemp("GetRoomEquipList",$j,RoomID))  quit:(RoomID="")  d
	.s InDate=""
	.f  s InDate=$o(^DHCEQTemp("GetRoomEquipList",$j,RoomID,InDate),-1)  quit:(InDate="")  d
	..s InType=0
	..f  s InType=$o(^DHCEQTemp("GetRoomEquipList",$j,RoomID,InDate,InType))  quit:(InType="")  d
	...s InRowID=0
	...f  s InRowID=$o(^DHCEQTemp("GetRoomEquipList",$j,RoomID,InDate,InType,InRowID))  quit:(InRowID="")  d
	....s BU3DRoomID=RoomID
	....s BUNo=$g(^DHCEQTemp("GetRoomEquipList",$j,RoomID,InDate,InType,InRowID,"BUNo"))
	....i InType=1 d
	.....s EqName=$p($g(^DHCEQEquip($p($g(^DHCEQInventoryList(InRowID)),"^",2))),"^",1)
	.....s EqNo=$p($g(^DHCEQEquip($p($g(^DHCEQInventoryList(InRowID)),"^",2))),"^",71)
	.....s ILStatusDesc=$CASE($p($g(^DHCEQInventoryList(InRowID)),"^",14),"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"未盘")
	....e  i InType=2 d
	.....s EqName=$p($g(^DHCEQInventoryException(InRowID)),"^",2)
	.....s EqNo=$p($g(^DHCEQInventoryException(InRowID)),"^",3)
	.....s ILStatusDesc="盘盈"
	....d OutputRowGetRoomEquipList
	k ^DHCEQTemp("GetRoomEquipList",$j)
	Quit $$$OK
	
BuildInventoryDataList	
	s rowid=0
	f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid))  quit:(rowid="")  d
	.s (EqName,EqNo,ILStatusDesc,BUNo,BU3DRoomID)=""
	.;q:$p($g(^DHCEQInventoryList(rowid)),"^",12)=""
	.;q:$p($g(^DHCEQInventoryList(rowid)),"^",13)=""
	.q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",4)'=pInventoryLocDR)
	.s InEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	.s InventoryDate=$p($g(^DHCEQInventoryList(rowid)),"^",12)
	.q:(pIEquipTypeIDs'="")&&(##Class(web.DHCEQCommon).IdInIds($p($g(^DHCEQEquip(InEquipDR)),"^",63),pIEquipTypeIDs)'=1)
	.s LocationObj=##Class(web.DHCDT3D.EquipLocation).GetRoomIDByEquip(InEquipDR)
	.s InELocationDR = LocationObj.%Get("LocationDR")
	.s LBuildingUnitDR = LocationObj.%Get("3DBuildUnitDR")
	.s (InBUFloorDR,InBU3DRoomID,BUNo)=""
	.i LBuildingUnitDR'="" d
	..s InBUFloorDR=$p($g(^DHCDT3DBuildUnit(LBuildingUnitDR)),"^",1)
	..s InBU3DRoomID=$p($g(^DHCDT3DBuildUnit(LBuildingUnitDR)),"^",13)
	..s BUNo=$p($g(^DHCDT3DBuildUnit(LBuildingUnitDR)),"^",5)
	.q:(pFloorDR'="")&&(InBUFloorDR'=pFloorDR)
	.q:(pBU3DRoomID'="")&&(InBU3DRoomID'=pBU3DRoomID)
	.s BU3DRoomID=InBU3DRoomID
	.;s EqName=$p($g(^DHCEQEquip(InEquipDR)),"^",1)
	.;s EqNo=$p($g(^DHCEQEquip(InEquipDR)),"^",71)
	.i BU3DRoomID="" s BU3DRoomID=0
	.;s ILStatusDesc=$CASE($p($g(^DHCEQInventoryList(rowid)),"^",14),"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"未盘")
	.s ^DHCEQTemp("GetRoomEquipList",$j,BU3DRoomID,+InventoryDate,1,rowid)=""
	.s ^DHCEQTemp("GetRoomEquipList",$j,BU3DRoomID,+InventoryDate,1,rowid,"BUNo")=BUNo
	.;d OutputRowGetRoomEquipList
	
	s ierowid=0
	f  s ierowid=$o(^DHCEQInventoryException(0,"Inventory",InventoryDR,ierowid))  quit:ierowid=""  d
	.s (EqName,EqNo,ILStatusDesc,BUNo,BU3DRoomID)=""
	.q:(pInventoryLocDR'="")&&($p($g(^DHCEQInventoryException(ierowid)),"^",9)'=pInventoryLocDR)
	.s IELocationDR=$p($g(^DHCEQInventoryException(ierowid)),"^",12)
	.s IEInventoryDate=$p($g(^DHCEQInventoryException(ierowid)),"^",14)
	.s (IEBuildingUnitDR,IEBUFloorDR,IEBU3DRoomID)=""
	.i IELocationDR'="" s IEBuildingUnitDR=$p($g(^DHCEQCCode("DHCEQCLocation",IELocationDR)),"^",7)
	.i IEBuildingUnitDR'="" d
	..s IEBUFloorDR=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",1)
	..s IEBU3DRoomID=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",13)
	..s BUNo=$p($g(^DHCDT3DBuildUnit(IEBuildingUnitDR)),"^",5)
	.q:(pFloorDR'="")&&(IEBUFloorDR'=pFloorDR)
	.q:(pBU3DRoomID'="")&&(IEBU3DRoomID'=pBU3DRoomID)
	.s BU3DRoomID=IEBU3DRoomID
	.;s EqName=$p($g(^DHCEQInventoryException(ierowid)),"^",2)
	.;s EqNo=$p($g(^DHCEQInventoryException(ierowid)),"^",3)
	.;s ILStatusDesc="盘盈"
	.i BU3DRoomID="" s BU3DRoomID=0
	.s ^DHCEQTemp("GetRoomEquipList",$j,BU3DRoomID,+IEInventoryDate,2,ierowid)=""
	.s ^DHCEQTemp("GetRoomEquipList",$j,BU3DRoomID,+IEInventoryDate,2,ierowid,"BUNo")=BUNo
	.;d OutputRowGetRoomEquipList
	q
	
OutputRowGetRoomEquipList
	Set Data=$lb(EqName,EqNo,ILStatusDesc,BUNo,BU3DRoomID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
}

ClassMethod GetRoomEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoomEquipListExecute ]
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

ClassMethod GetRoomEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoomEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
