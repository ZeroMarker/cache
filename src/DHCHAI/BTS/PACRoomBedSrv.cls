/// 名称: DHCHAI.BTS.PACRoomBedSrv
/// 描述: 床位图相关业务处理
/// 编写者：zhoubo
/// 编写日期: 2017-09-14
Class DHCHAI.BTS.PACRoomBedSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-09-21
/// Description:  根据病区ID查询该病区下没有关联的床位信息JSon串
/// Table：       
/// Input：       aLocID:科室（病区）ID
/// return:       返回json结构串
/// w ##class(DHCHAI.BTS.PACRoomBedSrv).BuildBedJson("24")
ClassMethod BuildBedJson(aLocID As %String) As %String
{
	New (aLocID)
	set json=""
	Quit:aLocID="" json
	Set xIndNo=""
	For {
		Set xIndNo=$o(^DHCHAI.BT.PACBedI("IndexLocIndNoBeds",aLocID,xIndNo))
		Quit:xIndNo=""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.BT.PACBedI("IndexLocIndNoBeds",aLocID,xIndNo,xID))
			Quit:xID=""
			Set objBed=##class(DHCHAI.BT.PACBed).GetObjById(xID)
			Continue:'$IsObject(objBed)
			
			If ($IsObject(objBed.BTLocDr)){
				Set LocDr   = objBed.BTLocDr.%Id()
				Set LocDesc = objBed.BTLocDr.BTDesc2
				Set:LocDesc="" LocDesc=objBed.BTLocDr.BTDesc
			}Else{
				Set LocDr="",LocDesc=""
			}
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Continue:$IsObject(objBed.BTRoomDr) //过滤关联房间的床位
			Set BedDesc  = objBed.BTDesc
			Set IsActive = objBed.BTIsActive
			Continue:IsActive=0
			Set ActDate = objBed.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objBed.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			
			If ($IsObject(objBed.BTActUserDr)){
				Set ActUserDr   = objBed.BTActUserDr.%Id()
				Set ActUserDesc = objBed.BTActUserDr.BTDesc
			}Else{
				Set (ActUserDr,ActUserDesc) = ""
			}
			set:json'="" json=json_","
			
			set proJson="{"_"""BedID"":"""_xID_""",""LocDesc"":"""_LocDesc_""",""BedDesc"":"""_BedDesc_""",""IndNo"":"""_xIndNo_"""}"
			set json=json_proJson
		}
	}
	Quit "{""PACNoBed"":["_json_"]}"
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-21
/// Description:  根据病区ID查询该病区下没有关联的床位信息
/// Table：       DHCHAI.BT.PACBed
/// Input：       aLocID:DHCHAI.BT.Location.ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACRoomBedSrv","QryPACBedByLocID","24")
Query QryPACBedByLocID(aLocID As %String) As %Query(ROWSPEC = "ID:%String,IndNo:%String,LocDr:%String,LocDesc:%String,BedDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserDr:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryPACBedByLocIDExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aLocID="") $$$OK
	
	Set xDesc=""
	For {
		Set xDesc=$o(^DHCHAI.BT.PACBedI("IndexLocDrDesc",aLocID,xDesc))
		Quit:xDesc=""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.BT.PACBedI("IndexLocDrDesc",aLocID,xDesc,xID))
			Quit:xID=""
			Set objBed=##class(DHCHAI.BT.PACBed).GetObjById(xID)
			Continue:'$IsObject(objBed)
			
			If ($IsObject(objBed.BTLocDr)){
				Set LocDr   = objBed.BTLocDr.%Id()
				Set LocDesc = objBed.BTLocDr.BTDesc2
				Set:LocDesc="" LocDesc=objBed.BTLocDr.BTDesc
			}Else{
				Set LocDr="",LocDesc=""
			}
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Continue:$IsObject(objBed.BTRoomDr) //过滤关联房间的床位
			Set IndNo    = objBed.BTIndNo
			Set BedDesc  = objBed.BTDesc
			Set IsActive = objBed.BTIsActive
			Continue:IsActive=0
			Set ActDate = objBed.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objBed.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,1)
			
			If ($IsObject(objBed.BTActUserDr)){
				Set ActUserDr   = objBed.BTActUserDr.%Id()
				Set ActUserDesc = objBed.BTActUserDr.BTDesc
			}Else{
				Set (ActUserDr,ActUserDesc) = ""
			}
			Set Data = $lb(xID,IndNo,LocDr,LocDesc,BedDesc,IsActive,ActDate,ActTime,ActUserDr,ActUserDesc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPACBedByLocIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPACBedByLocIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPACBedByLocIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPACBedByLocIDExecute ]
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
/// CreatDate：   2017-09-14
/// Description:  房间列表，取房间参数设置信息
/// Table：       DHCHAI.BT.PACRoom
/// Input：       aLocID:DHCHAI.BT.Location.ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACRoomBedSrv","QryPACRoomSrv","")
Query QryPACRoomSrv(aLocID As %String) As %Query(ROWSPEC = "ID:%String,RoomDesc:%String,RoomDescPos:%String,RoomTypeDr:%String,RoomType:%String,LocID:%String,LocDesc:%String,PosTop:%String,PosLeft:%String,PosWidth:%String,PosHeight:%String,PosRotate:%String,BedCnt:%String,BedWidth:%String,BedHeight:%String,LeftBedCnt:%String,RightBedCnt:%String,ContBedCnt:%String,WardDr:%String,SubNo:%String,RoomColor:%String,RoomIcon:%String") [ SqlProc ]
{
}

ClassMethod QryPACRoomSrvExecute(ByRef qHandle As %Binary, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aLocID="" $$$OK
	
	Set xRoomID = 0
	For {
		Set xRoomID = $o(^DHCHAI.BT.PACRoomD(xRoomID))
		Quit:xRoomID=""
		Set objRoom = ##class(DHCHAI.BT.PACRoom).GetObjById(xRoomID)
		Continue:'$IsObject(objRoom)
		
		If ($Isobject(objRoom.BTLocDr)){
			Set LocID   = objRoom.BTLocDr.%Id()
			Set LocDesc = objRoom.BTLocDr.BTDesc2
			Set:LocDesc="" LocDesc=objRoom.BTLocDr.BTDesc
		}Else{
			Set (LocID,LocDesc) = ""
		}
		Continue:LocID'=aLocID
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set (RoomTypeDr,RoomType) = ""
		If ($IsObject(objRoom.BTTypeDr)){
			Set RoomTypeDr = objRoom.BTTypeDr.%Id()
			Set RoomType = objRoom.BTTypeDr.BTDesc
		}
		
		Set RoomDesc  = objRoom.BTDesc
		Set RoomDescPos = objRoom.BTDescPos
		Set PosTop    = objRoom.BTPosTop
		Set PosLeft   = objRoom.BTPosLeft
		Set PosWidth  = objRoom.BTPosWidth
		Set PosHeight = objRoom.BTPosHeight
		Set PosRotate = objRoom.BTPosRotate
		Set BedCnt    = objRoom.BTBedCnt
		Set LeftBedCnt     = objRoom.BTLeftBedCnt
		Set RightBedCnt    = objRoom.BTRightBedCnt
		Set BedWidth  = objRoom.BTBedWidth
		Set BedHeight = objRoom.BTBedHeight
		// 取已关联床位数
		Set ContBedCnt=0
		Set xBed=0
		For {
			Set xBed=$o(^DHCHAI.BT.PACBedI("IndexRoomDr",xRoomID,xBed))
			Quit:xBed=""
			Set ContBedCnt=ContBedCnt+1
		}
		Set RoomColor = objRoom.BTRoomColor
		Set RoomIcon  = objRoom.BTRoomIcon
		If ($IsObject(objRoom.BTWardDr)){
			Set WardDr = objRoom.BTWardDr.%Id()
			Set SubNo  = objRoom.BTWardDr.BTSubNo
		}Else{ 
			Set (WardDr,SubNo)=""
		}
		Set Data = $lb(xRoomID,RoomDesc,RoomDescPos,RoomTypeDr,RoomType,LocID,LocDesc,PosTop,PosLeft,PosWidth,PosHeight,PosRotate,BedCnt,BedWidth,BedHeight,LeftBedCnt,RightBedCnt,ContBedCnt,WardDr,SubNo,RoomColor,RoomIcon)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryPACRoomSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPACRoomSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPACRoomSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPACRoomSrvExecute ]
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
/// CreatDate：   2017-09-14
/// Description:  房间床位列表，取床位参数设置信息
/// Table：       DHCHAI.BT.PACBed
/// Input：       aLocID:DHCHAI.BT.Location.ID
/// 			  aRoomID:DHCHAI.BT.PACWard.ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACRoomBedSrv","QryPACRoomBedSrv","2356","")
Query QryPACRoomBedSrv(aLocID As %String = "", aRoomID As %String = "") As %Query(ROWSPEC = "ID:%String,IndNo:%String,LocID:%String,LocDesc:%String,RoomID:%String,RoomDesc:%String,BedDesc:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserDr:%String,ActUserDesc:%String,XCode:%String") [ SqlProc ]
{
}

ClassMethod QryPACRoomBedSrvExecute(ByRef qHandle As %Binary, aLocID As %String = "", aRoomID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:((aLocID="")||(aRoomID="")) $$$OK
	
	Set xBedID = 0
	For {
		Set xBedID = $o(^DHCHAI.BT.PACBedD(xBedID))
		Quit:xBedID=""
		
		Set objBed = ##class(DHCHAI.BT.PACBed).GetObjById(xBedID)
		Continue:'$IsObject(objBed)
		
		If ($IsObject(objBed.BTLocDr)){
			Set LocDr = objBed.BTLocDr.%Id()
			Set LocDesc = objBed.BTLocDr.BTDesc2
			Set:LocDesc="" LocDesc=objBed.BTLocDr.BTDesc
		}Else{
			Set LocDr = "",LocDesc=""
		}
		Continue:LocDr'=aLocID
		Continue:'$IsObject(objBed.BTRoomDr) //过滤未关联房间的床位
		Set RoomID = objBed.BTRoomDr.%Id()
		Continue:aRoomID'=RoomID //只过滤出该房间的床位
		Set XCode = objBed.BTXCode  
		Set IndNo = objBed.BTIndNo
		Set LocID = LocDr
		Set RoomDesc = objBed.BTRoomDr.BTDesc
		Set BedDesc = objBed.BTDesc
		Set IsActive = objBed.BTIsActive
		
		Set ActDate = objBed.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime = objBed.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		
		If ($IsObject(objBed.BTActUserDr)){
			Set ActUserDr = objBed.BTActUserDr.%Id()
			Set ActUserDesc = objBed.BTActUserDr.BTDesc
		}Else{
			Set (ActUserDr,ActUserDesc) = ""
		}
		Set Data = $lb(xBedID,IndNo,LocID,LocDesc,RoomID,RoomDesc,BedDesc,IsActive,ActDate,ActTime,ActUserDr,ActUserDesc,XCode)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryPACRoomBedSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPACRoomBedSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPACRoomBedSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPACRoomBedSrvExecute ]
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
/// CreatDate：   2017-09-14
/// Description:  取床位图关联床位列表（包括已关联和未关联床位）
/// Table：       DHCHAI.BT.PACBed
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.PACRoomBedSrv","QryPACBedSrv",661,12)
Query QryPACBedSrv(aLocID As %String = "", aRoomID As %String = "") As %Query(ROWSPEC = "ID:%String,IndNo:%String,LocID:%String,LocDesc:%String,RoomID:%String,RoomDesc:%String,IsRoomBed:%String,BedDesc:%String,IsActive:%String,ActUserDr:%String,ActUserDesc:%String,XCode:%String,IsRoomFlag:%String") [ SqlProc ]
{
}

ClassMethod QryPACBedSrvExecute(ByRef qHandle As %Binary, aLocID As %String = "", aRoomID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aLocID="" $$$OK
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) $$$OK
	Set xLocID=aLocID
	If $IsObject(objLoc.BTParLocDr) {
		Set xLocID=objLoc.BTParLocDr.%Id()
	}
	
	Set xIndNo=""
	For {
		Set xIndNo=$o(^DHCHAI.BT.PACBedI("IndexLocDrIndNo",xLocID,xIndNo))
		Quit:xIndNo=""
		
		Set xBedID=0
		For {
			Set xBedID=$o(^DHCHAI.BT.PACBedI("IndexLocDrIndNo",xLocID,xIndNo,xBedID))
			Quit:xBedID=""
			
			Set objBed = ##class(DHCHAI.BT.PACBed).GetObjById(xBedID)
			Continue:'$IsObject(objBed)
			
			If ($IsObject(objBed.BTLocDr)){
				Set LocID = objBed.BTLocDr.%Id()
				Set LocDesc = objBed.BTLocDr.BTDesc2
				Set:LocDesc="" LocDesc=objBed.BTLocDr.BTDesc
			}Else{
				Set LocID = "",LocDesc=""
			}
			
			Set IsRoomBed = 0  //是否关联房间
			Set (RoomID,RoomDesc) = ""
			If ($IsObject(objBed.BTRoomDr)){
				Set RoomID = objBed.BTRoomDr.%Id()
				Set RoomDesc = objBed.BTRoomDr.BTDesc
			}
			Set:RoomID'="" IsRoomBed = 1
			
			Set IsRoomFlag=0   //是否属于该房间
			If ((aRoomID'="")&&(RoomID=aRoomID)) {
				Set IsRoomFlag=1
			}
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Set BedDesc = objBed.BTDesc
			Set IsActive = objBed.BTIsActive
			Set XCode    = objBed.BTXCode
			If ($IsObject(objBed.BTActUserDr)){
				Set ActUserDr = objBed.BTActUserDr.%Id()
				Set ActUserDesc = objBed.BTActUserDr.BTDesc
			}Else{
				Set (ActUserDr,ActUserDesc) = ""
			}
			
			Set Data = $lb(xBedID,xIndNo,LocID,LocDesc,RoomID,RoomDesc,IsRoomBed,BedDesc,IsActive,ActUserDr,ActUserDesc,XCode,IsRoomFlag)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryPACBedSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPACBedSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPACBedSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPACBedSrvExecute ]
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

/// 取对照转换信息
/// w ##class(DHCHAI.BTS.PACRoomBedSrv).GetMapDic("科室","N1/6病房国际医疗部")
ClassMethod GetMapDic(aType As %String, aValue As %String, aSCode As %String = "") As %String
{
	New (aType,aValue,aSCode)
	Set return=""
	Quit:(aType="")||(aValue="") return
	
	//需要字典对照内容
	Set ^TMP("HAIMap.ImportRoom","房间类型","医生休息室")        = "医生值班室"
	Set ^TMP("HAIMap.ImportRoom","房间类型","医生工作站")        = "医生办公室"
	Set ^TMP("HAIMap.ImportRoom","房间类型","开水间")            = "开水房"
	Set ^TMP("HAIMap.ImportRoom","房间类型","手术间")            = "手术室"
	Set ^TMP("HAIMap.ImportRoom","房间类型","护士休息室")        = "护士值班室"
	Set ^TMP("HAIMap.ImportRoom","房间类型","护士更衣室")        = "女更衣室"
	Set ^TMP("HAIMap.ImportRoom","科室","整形口腔病房","HIS01")  = "整形美容外科病房"
	
	If aSCode="" {
		Set tValue=$g(^TMP("HAIMap.ImportRoom",aType,aValue))
	} Else {
		Set tValue=$g(^TMP("HAIMap.ImportRoom",aType,aValue,aSCode))
	}
	Set:tValue'="" aValue=tValue
	
	If aType="科室" {
		Set:aSCode="" aSCode="HIS01"
		Set objDic=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
		If return="" {
			Set objDic=##class(DHCHAI.BT.Location).GetObjByLocDesc2(aValue)
			Set:$IsObject(objDic) return=objDic.%Id()
		}
	}
	
	If aType="房间类型" {
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByDesc("RoomType",aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	If aType="病房大楼" {
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByDesc("WardBuilding",aValue)
		Set:$IsObject(objDic) return=objDic.%Id()
	}
	
	//有值返回
	Quit:return'="" return
	
	If aSCode="" {
		Set ^TMP("HAIMap.ImportRoom",aType,aValue)=""
	} Else {
		Set ^TMP("HAIMap.ImportRoom",aType,aValue,aSCode)=""
	}
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2017-10-31
/// Description:  床位图导入程序
/// Table：       DHCHAI.BT.PACRoom
/// Input:		  各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.PACRoomBedSrv).ImportRoom("HIS01^儿科病房^15^60^10^70^160^90^上^病房","^")
ClassMethod ImportRoom(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete="^"
	Set SCode     = $p(aInputStr,aSeparete,1)
	Set WardDesc  = $p(aInputStr,aSeparete,2)
	Set RoomDesc  = $p(aInputStr,aSeparete,3)
	Set PosTop    = $p(aInputStr,aSeparete,4)
	Set PosLeft   = $p(aInputStr,aSeparete,5)
	Set PosWidth  = $p(aInputStr,aSeparete,6)
	Set PosHeight = $p(aInputStr,aSeparete,7)
	Set PosRotate = $p(aInputStr,aSeparete,8)
	Set DescPos   = $p(aInputStr,aSeparete,9)
	Set TypeDesc  = $p(aInputStr,aSeparete,10)
	Quit:(SCode="")||(WardDesc="")||(RoomDesc="") return
	
	Set LocDr=..GetMapDic("科室",WardDesc,SCode)
	Quit:LocDr="" return
	
	Set WardSubNo=1  //病区分区号
	Set DescPos=$s(DescPos["上":1,DescPos["下":2,1:1)
	Set TypeDr=..GetMapDic("房间类型",TypeDesc)
	Set BuildingDr=..GetMapDic("病房大楼","第一住院大楼")
	
	Set objWard = ##class(DHCHAI.BT.PACWard).GetObjByLocDr(LocDr,WardSubNo) //默认分区号为1
	If '$IsObject(objWard){
		Set WardID=##class(DHCHAI.BT.PACWard).Update("^"_LocDr_"^"_BuildingDr_"^1^A^^","^")
	}Else{
		Set WardID=objWard.%Id()
	}
	Quit:WardID<0 return
	
	//维护房间
	Set (BedWidth,BedHeight) = 0
	If TypeDesc="病房"{
		Set BedWidth = 50
		Set BedHeight = 30
	}
	
	Set return=##class(DHCHAI.BT.PACRoom).Update("^"_LocDr_"^"_RoomDesc_"^"_DescPos_"^"_TypeDr_"^"_PosTop_"^"_PosLeft_"^"_PosWidth_"^"_PosHeight_"^"_PosRotate_"^0^0^"_BedWidth_"^"_BedHeight_"^"_WardID_"^^","^")
	Quit return
}

}
