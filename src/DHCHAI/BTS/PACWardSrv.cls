/// 名称: DHCHAI.BTS.PACWardSrv
/// 描述: 床位图相关业务处理
/// 编写者：zhoubo
/// 编写日期: 2017-09-01
Class DHCHAI.BTS.PACWardSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-09-26
/// Description:  根据病区ID查询该病区分区号信息(下拉框使用)
/// Table：       DHCHAI.BT.PACWard
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACWardSrv","QryWardSubNo","22")
Query QryWardSubNo(aLocID As %String) As %Query(ROWSPEC = "ind:%String,ID:%String,SubNo:%String") [ SqlProc ]
{
}

ClassMethod QryWardSubNoExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aLocID="" $$$OK
	Set xNo=0
	For {
		Set xNo=$o(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",aLocID,xNo))
		Quit:xNo=""
		Set xID=""
		Set xID=$o(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",aLocID,xNo,xID))
		Quit:xID=""
		Set SubNo=xNo
		
		Set Data=$lb(ind,xID,SubNo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryWardSubNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWardSubNoExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWardSubNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWardSubNoExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-14
/// Description:  根据病区ID获取该病区内房间、床位JSon串
/// Table：       
/// Input：       aLocID:科室（病区）ID
/// return:       返回json结构串
/// w ##class(DHCHAI.BTS.PACWardSrv).BuildBedRoomJson("2330")
ClassMethod BuildBedRoomJson(aLocID As %String) As %String
{
	New (aLocID)
	set json=""
	Quit:aLocID="" json
	
	Set xWardID=""
	For {
		Set xWardID=$o(^DHCHAI.BT.PACRoomI("IndexLocWardDrDesc",aLocID,xWardID))
		Quit:(xWardID="")
		Set objWard = ##class(DHCHAI.BT.PACWard).GetObjById(xWardID)
		Continue:'$IsObject(objWard)
		set:json'="" json=json_","
		If ($IsObject(objWard.BTBuildingDr)){
			Set BuildingID = objWard.BTBuildingDr.%Id()
			Set BuildingDesc = objWard.BTBuildingDr.BTDesc
		}Else{
			Set (BuildingID,BuildingDesc) = ""
		}
		If ($IsObject(objWard.BTLocDr)){
			Set LocID   = objWard.BTLocDr.%Id()
			Set LocDesc = objWard.BTLocDr.BTDesc2
			Set:LocDesc="" LocDesc=objWard.BTLocDr.BTDesc
		}Else{
			Set (LocID,LocDesc) = ""
		}
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set WardID    = xWardID
		Set Floor     = objWard.BTFloor
		Set Area      = objWard.BTArea
		Set SubNo     = objWard.BTSubNo
		Set AreaColor = objWard.BTAreaColor
		set WardJson="{"_"""WardID"":"""_WardID_""",""Floor"":"""_Floor_""",""Area"":"""_Area_""",""SubNo"":"""_SubNo_""",""AreaColor"":"""_AreaColor_""",""LocDesc"":"""_LocDesc_""","
		// 取房间床位信息
		set RoomJson="[]"
		Set proJson=""
		Set xRoom=""
		For {
			Set xRoom=$o(^DHCHAI.BT.PACRoomI("IndexLocWardDrDesc",aLocID,xWardID,xRoom))
			Quit:(xRoom="")
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.BT.PACRoomI("IndexLocWardDrDesc",aLocID,xWardID,xRoom,xID))
				Quit:(xID="")
				Set objRoom = ##class(DHCHAI.BT.PACRoom).GetObjById(xID)
				Continue:'$IsObject(objRoom)
				set:proJson'="" proJson=proJson_","
				Set RoomDesc    = objRoom.BTDesc
				Set PosTop      = objRoom.BTPosTop
				Set PosLeft     = objRoom.BTPosLeft
				Set PosWidth    = objRoom.BTPosWidth
				Set PosHeight   = objRoom.BTPosHeight
				Set PosRotate   = objRoom.BTPosRotate
				Set LeftBedCnt  = objRoom.BTLeftBedCnt
				Set RightBedCnt = objRoom.BTRightBedCnt
				Set BedWidth    = objRoom.BTBedWidth
				Set BedHeight   = objRoom.BTBedHeight
				Set DescPos     = objRoom.BTDescPos //房间号位置(1上，2下)
				If ($IsObject(objRoom.BTTypeDr)){
					Set TypeID   = objRoom.BTTypeDr.%Id()
					Set TypeDesc = objRoom.BTTypeDr.BTDesc
				}Else{
					Set (TypeID,TypeDesc) = ""
				}
				Set RoomColor   = objRoom.BTRoomColor
				Set RoomIcon    = objRoom.BTRoomIcon
				If (TypeDesc'="病房") {   // 去掉非病房的编号
					Set:RoomDesc["-" RoomDesc=$p(RoomDesc,"-",2)
				}
				If ((PosRotate>0)&&((PosRotate#90)=0)) {  // 如果旋转90、270度直角需换算高宽
					If (PosWidth>PosHeight) {
						Set PosTop=PosTop-((PosWidth/2)-(PosHeight/2))
						Set PosLeft=PosLeft+((PosWidth/2)-(PosHeight/2))
					}
					If (PosWidth<PosHeight) {
						Set PosTop=PosTop+((PosHeight/2)-(PosWidth/2))
						Set PosLeft=PosLeft-((PosHeight/2)-(PosWidth/2))
					}
					Set tmpPosWidth=PosWidth
					Set tmpPosHeight=PosHeight
					Set PosWidth=tmpPosHeight
					Set PosHeight=tmpPosWidth
				}

				set proJson=proJson_"{"_"""RoomID"":"""_xID_""",""RoomDesc"":"""_RoomDesc_""",""PosTop"":"""_PosTop_""","
				set proJson=proJson_"""PosLeft"":"""_PosLeft_""",""PosWidth"":"""_PosWidth_""",""PosHeight"":"""_PosHeight_""","
				set proJson=proJson_"""PosRotate"":"""_PosRotate_""",""LeftBedCnt"":"""_LeftBedCnt_""",""RightBedCnt"":"""_RightBedCnt_""",""BedWidth"":"""_BedWidth_""","
				set proJson=proJson_"""BedHeight"":"""_BedHeight_""",""RoomColor"":"""_RoomColor_""",""RoomIcon"":"""_RoomIcon_""","
				set proJson=proJson_"""DescPos"":"""_DescPos_""",""TypeID"":"""_TypeID_""",""TypeDesc"":"""_TypeDesc_""","
				// 取病房床位信息
				set BedJson="[]"
				Set childjson=""
				Set xIndNo=0
				For {
					Set xIndNo=$o(^DHCHAI.BT.PACBedI("IndexLocIndNoBeds",aLocID,xIndNo))
					Quit:xIndNo=""
					Set xBedID=0
					For {
						Set xBedID=$o(^DHCHAI.BT.PACBedI("IndexLocIndNoBeds",aLocID,xIndNo,xBedID))
						Quit:xBedID=""
						Set objBed = ##class(DHCHAI.BT.PACBed).GetObjById(xBedID)
						Continue:'$IsObject(objBed)||'$IsObject(objBed.BTRoomDr)
						Continue:xID'=objBed.BTRoomDr.%Id()
						set:childjson'="" childjson=childjson_","
						Set BedDesc   = objBed.BTDesc
						Set IndNo     = objBed.BTIndNo
						set childjson = childjson_"{"_"""BedID"":"""_xBedID_""",""BedDesc"":"""_BedDesc_""",""IndNo"":"""_IndNo_"""}"
					}
				}
				Set:childjson'="" BedJson = "["_childjson_"]"
				set proJson=proJson_"""BedJson"":"_BedJson_"}"
			}
		}
		Set:proJson'="" RoomJson = "["_proJson_"]"
		set WardJson=WardJson_"""RoomJson"":"_RoomJson_"}"
		set json=json_WardJson	
	}
	Quit "{""PACWard"":["_json_"]}"
}

/// CreatDate：   2017-09-27
/// Description:  默认把病区分成2个区
/// Table：       DHCHAI.BT.PACWard
/// Input：       病区ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.PACWardSrv).PACWardSubNo("1")
ClassMethod PACWardSubNo(aWardID As %String) As %String
{
	New (aWardID)
	Set return=0
	Quit:aWardID="" return
	Set objWard=##class(DHCHAI.BT.PACWard).GetObjById(aWardID)
	Quit:'$IsObject(objWard) return
	Quit:'$IsObject(objWard.BTLocDr) return
	Set LocDr = objWard.BTLocDr.%Id()
	
	Set NewSubNo=$o(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",LocDr,""),-1)
	Set NewSubNo=NewSubNo+1
	If ($IsObject(objWard.BTBuildingDr)){
		Set BuildingDr=objWard.BTBuildingDr.%Id()
	}Else{
		Set BuildingDr=""
	}
	Set InputStr = ""
	Set InputStr = InputStr_"^"_LocDr
	Set InputStr = InputStr_"^"_BuildingDr
	Set InputStr = InputStr_"^"_objWard.BTFloor
	Set InputStr = InputStr_"^"_objWard.BTArea
	Set InputStr = InputStr_"^"_NewSubNo
	Set InputStr = InputStr_"^"_objWard.BTAreaColor
	Set flg=##class(DHCHAI.BT.PACWard).Update(InputStr,"^")
	Set return=flg
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-09-13
/// Description:  取病区参数设置信息
/// Table：       DHCHAI.BT.PACWard
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACWardSrv","QryPACWardSrv")
Query QryPACWardSrv() As %Query(ROWSPEC = "ID:%String,LocID:%String,LocDesc:%String,BuildingID:%String,Building:%String,Floor:%String,Area:%String") [ SqlProc ]
{
}

ClassMethod QryPACWardSrvExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = 0
	For {
		Set xID = $o(^DHCHAI.BT.PACWardD(xID))
		Quit:xID=""
		
		Set objWard=##class(DHCHAI.BT.PACWard).GetObjById(xID)
		Continue:'$isobject(objWard)
		
		If ($IsObject(objWard.BTLocDr)){
			Set LocID   = objWard.BTLocDr.%Id()
			Set LocDesc = objWard.BTLocDr.BTDesc2
			Set:LocDesc="" LocDesc=objWard.BTLocDr.BTDesc
		}Else{
			Set (LocID,LocDesc) = ""
		}
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		If (objWard.BTBuildingDr){
			Set BuildingID = objWard.BTBuildingDr.%Id()
			Set Building = objWard.BTBuildingDr.BTDesc
		}Else{
			Set (BuildingID,Building) = ""
		}
		Set Floor = objWard.BTFloor
		Set Area = objWard.BTArea
		
		Set Data = $lb(xID,LocID,LocDesc,BuildingID,Building,Floor,Area)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryPACWardSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPACWardSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPACWardSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPACWardSrvExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-27
/// Description:  查询病区列表（房间分布定义使用）
/// Table：       DHCHAI.BT.Location
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACWardSrv","QryPACWard")
Query QryPACWard() As %Query(ROWSPEC = "ID:%String,LocDesc:%String,IsMainWard:%String") [ SqlProc ]
{
}

ClassMethod QryPACWardExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=0
	For {
		Set xID = $o(^DHCHAI.BT.LocationD(xID))
		Quit:xID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xID)
		Continue:'$isobject(objLoc)
		Set IsActive = objLoc.BTIsActive
		Continue:IsActive'=1
		
		If $IsObject(objLoc.BTTypeDr) {
			Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
			Set LocTypeCode	= objLoc.BTTypeDr.BTCode
		}Else{
			Set (LocTypeDr,LocTypeCode) = ""
		}
		Continue:LocTypeCode'="W" //过滤出病区
		
		/* 这个暂时不需要判断，有些病区类型为急诊
		If $IsObject(objLoc.BTCateDr) {
			Set LocCateDr 	= objLoc.BTCateDr.%Id()
			Set LocCateCode	= objLoc.BTCateDr.BTCode
		}Else{
			Set (LocCateDr,LocCateCode) = ""
		}
		Continue:LocCateCode'="I" //过滤出住院
		*/
		
		Set LocID=xID
		Set LocDesc=objLoc.BTDesc
		Set:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
		Set LocDesc2=objLoc.BTDesc2
		Set:LocDesc2'="" LocDesc=LocDesc2
		
		Set IsMainWard=0   // 是否维护病区信息
		If ($d(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",LocID))){
			Set IsMainWard=1
		}
		Set Data=$lb(xID,LocDesc,IsMainWard)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPACWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPACWardExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPACWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPACWardExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     mayanpeng
/// CreatDate：   2017-09-13
/// Description:  查询病区列表（病区分布定义使用）
/// Table：       DHCHAI.BT.Location
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACWardSrv","QryWard")
Query QryWard() As %Query(ROWSPEC = "ID:%String,WardID:%String,LocDesc:%String,BuildingID:%String,Building:%String,Floor:%String,Area:%String,SubNo:%String,AreaColor:%String") [ SqlProc ]
{
}

ClassMethod QryWardExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=0
	For {
		Set xID = $o(^DHCHAI.BT.LocationD(xID))
		Quit:xID=""
		
		Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(xID)
		Continue:'$isobject(objLoc)
		Set IsActive = objLoc.BTIsActive
		Continue:IsActive'=1
		
		If $IsObject(objLoc.BTTypeDr) {
			Set LocTypeDr 	= objLoc.BTTypeDr.%Id()
			Set LocTypeCode	= objLoc.BTTypeDr.BTCode
		}Else{
			Set (LocTypeDr,LocTypeCode) = ""
		}
		Continue:LocTypeCode'="W" //过滤出病区
		
		/*
		If $IsObject(objLoc.BTCateDr) {
			Set LocCateDr 	= objLoc.BTCateDr.%Id()
			Set LocCateCode	= objLoc.BTCateDr.BTCode
		}Else{
			Set (LocCateDr,LocCateCode) = ""
		}
		Continue:LocCateCode'="I" //过滤出住院
		*/
		
		Set LocID = xID
		Set LocDesc = objLoc.BTDesc
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set LocDesc2 = objLoc.BTDesc2
		Set:LocDesc2'="" LocDesc=LocDesc2
		
		If ($d(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",LocID))){
			Set xNo=0
			For {
				Set xNo=$o(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",LocID,xNo))
				Quit:xNo=""
				Set xWardID=""
				For {
					Set xWardID=$o(^DHCHAI.BT.PACWardI("IdxofLocDrSubNo",LocID,xNo,xWardID))
					Quit:xWardID=""
					Set objWard = ##class(DHCHAI.BT.PACWard).GetObjById(xWardID)
					If ($IsObject(objWard)){
						If ($IsObject(objWard.BTBuildingDr)){
							Set BuildingID = objWard.BTBuildingDr.%Id()
							Set Building = objWard.BTBuildingDr.BTDesc
						}Else{
							Set (BuildingID,Building) = ""
						}
						Set WardID    = objWard.%Id()
						Set Floor     = objWard.BTFloor
						Set Area      = objWard.BTArea
						Set SubNo     = objWard.BTSubNo
						Set AreaColor = objWard.BTAreaColor
					}Else{
						Set (WardID,BuildingID,Building,Floor,Area,SubNo,AreaColor) = ""
					}
					Set Data=$lb(xID,WardID,LocDesc,BuildingID,Building,Floor,Area,SubNo,AreaColor)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}Else {
			Set (WardID,BuildingID,Building,Floor,Area,SubNo,AreaColor) = ""
			Set Data=$lb(xID,WardID,LocDesc,BuildingID,Building,Floor,Area,SubNo,AreaColor)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWardExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWardExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
