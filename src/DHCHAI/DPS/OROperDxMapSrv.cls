/// 名称: DHCHAI.DPS.OROperDxMapSrv
/// 描述: 手术切口标准化相关服务
/// 编写者：chenjb
/// 编写日期: 2017-03-20
Class DHCHAI.DPS.OROperDxMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-05-08
/// Description:  查询列表
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       aFlg:是否关联检查字典标志,"":查询全部,0:查询未关联,1:查询已关联
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OROperDxMapSrv","QryOROperDxMap","1")
Query QryOROperDxMap(aFlg As %String = "") As %Query(ROWSPEC = "ID:%String,BTOperDesc:%String,BTMapOperDr:%String,BTMapOperCode:%String,BTMapOperDesc:%String,BTMapNote:%String,BTSCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUser:%String,DrBTOperDesc:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryOROperDxMapExecute(ByRef qHandle As %Binary, aFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1 

 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OROperDxMapD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OROperDxMap).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set BTOperDesc=obj.BTOperDesc
	 	Set BTMapOperDr="",BTMapOperCode="",BTMapOperDesc=""
	 	If $IsObject(obj.BTMapOperDr) {
			Set BTMapOperDr=obj.BTMapOperDr.%Id()
			Set BTMapOperCode=obj.BTMapOperDr.BTOperCode
			Set BTMapOperDesc=obj.BTMapOperDr.BTOperDesc	
	 	}
	 	Continue:(aFlg=0)&&(BTMapOperDr'="")
		Continue:(aFlg=1)&&(BTMapOperDr="")
		
	 	Set BTMapNote=obj.BTMapNote
	 	Set BTSCode=obj.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(BTSCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		
		Set BTIsActive=obj.BTIsActive
		Continue:(aFlg=0)&&(BTIsActive'=1) //未对照不显示无效项目
		Set BTActDate =obj.BTActDate
		Set BTActTime =obj.BTActTime
		Set:BTActDate'="" BTActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(BTActDate)
	    Set:BTActTime'="" BTActTime=$zt(BTActTime,1)
		Set BTActUser =obj.BTActUser
		
		set Data=$lb(xID,BTOperDesc,BTMapOperDr,BTMapOperCode,BTMapOperDesc,BTMapNote,BTSCode,BTIsActive,BTActDate,BTActTime,BTActUser,HospGroup)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOROperDxMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOROperDxMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOROperDxMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOROperDxMapExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-05-08
/// Description:  查询列表
/// Table：       DHCHAI.DP.OROperDxMap
/// Input：       aCode : 是否已对照 1 - 已对照 0 未对
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.OROperDxMapSrv","QryOROperDxMapByInit")
Query QryOROperDxMapByInit() As %Query(ROWSPEC = "ID:%String,BTOperDesc:%String,BTMapItemDr:%String,BTMapNote:%String,BTSCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUser:%String,DrBTOperDesc:%String") [ SqlProc ]
{
}

ClassMethod QryOROperDxMapByInitExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.OROperDxMapD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.OROperDxMap).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set BTOperDesc=obj.BTOperDesc
	 	Set BTMapItemDr=obj.BTMapOperDr
	 	//默认加载
	 	Continue:($IsObject(BTMapItemDr))&&(BTMapItemDr.BTOperCode'="")
	 	Set BTMapNote=obj.BTMapNote
	 	Set BTSCode=obj.BTSCode
		Set BTIsActive=obj.BTIsActive
		Set BTActDate =obj.BTActDate
		Set BTActTime =obj.BTActTime
		Set:BTActDate'="" BTActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(BTActDate)
	    Set:BTActTime'="" BTActTime=$zt(BTActTime,1)
		Set BTActUser =obj.BTActUser
		
		set Data=$lb(xID,BTOperDesc,"",BTMapNote,BTSCode,BTIsActive,BTActDate,BTActTime,BTActUser,"")
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOROperDxMapByInitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOROperDxMapByInitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOROperDxMapByInitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOROperDxMapByInitExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-05-09
/// Description:  更新诊断分类对照
/// Table：       DHCHAI.DP.RBItmMastMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.OROperDxMapSrv).UpdateMap("1","1","med")
ClassMethod UpdateMap(ID As %String, MapItemID As %String, UsersName As %String) As %String
{
	New (ID,MapItemID,UsersName)
	Set return=0
	Quit:(ID="")||(MapItemID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.OROperDx).GetObjById(MapItemID)

	Set obj=##class(DHCHAI.DP.OROperDxMap).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set obj.BTMapOperDr	= objMapItem
	Set obj.BTActUser = UsersName
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
		Do $system.OBJ.DisplayError(sc)
		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-06
/// Description:  自动匹配对照规则
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.OROperDx,DHCHAI.DP.OROperDxMap
/// Input：		  aCatID：匹配规则表DHCHAI.DP.DataMapRule.ID
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.OROperDxMapSrv).SynMapRule("手术项目")
ClassMethod SynMapRule(aCatDesc As %String) As %String
{
	New (aCatDesc)
	Set return=""
	Quit:(aCatDesc="") return
	
	Set aCatID=""
	Set objDic  = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule",aCatDesc)
	If $Isobject(objDic) {
		Set aCatID = objDic.%Id()
	}
	Quit:(aCatID="") return

	Set Count=0	
    Set xSCode =""
    For {
	    Set xSCode=$o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",xSCode))
	    Quit:xSCode=""
	    
	    Set xOperDesc=""
	    For {  
			Set xOperDesc=$o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",xSCode,xOperDesc))
		    Quit:xOperDesc=""
		   
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.OROperDxMapI("IndexSCodeOperDesc",xSCode,xOperDesc,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.OROperDxMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)	
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapOperDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
			
				Set OperDesc = objMap.BTOperDesc
				Continue:OperDesc=""
				Set OperDxID = $o(^DHCHAI.DP.OROperDxI("IndexOperDesc",OperDesc,0))  //名称一样可直接匹配
				If (OperDxID="") {
				
			     	Set Desc = ""
					Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,0,OperDesc,0))  //匹配
					If MapRuleID'="" {
						Set objRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
						Continue:'$Isobject(objRule)
						Set Desc   = objRule.BTDesc 
					} Else  {
						Set xMapDesc=""   // 包含（排除）规则
						For {
							Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc))
							Quit:xMapDesc=""
							
							Continue:OperDesc'[xMapDesc
							Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc,0))
							Set objRule=##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
							Continue:'$Isobject(objRule)
							Set tDesc=objRule.BTDesc
							
							Set xExID="",Flg=0 
							For {
								Set xExID=$o(^DHCHAI.DP.DataMapRuleI("IndexDesc",tDesc,xExID))
								Quit:xExID=""
								
								Set objExRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(xExID)
								Continue:'$Isobject(objExRule)
								Set Type =	objExRule.BTType
								Continue:Type'=2
								Set ExMapDesc = objExRule.BTMapDesc
								Continue:OperDesc'[ExMapDesc
								Set Flg=1
								Quit
							}
							Continue:Flg>0
							Set Desc=tDesc
							Quit
						}
					}
			
					Continue:Desc=""
					Set OperDxID = $o(^DHCHAI.DP.OROperDxI("IndexOperDesc",Desc,0))
					Continue:OperDxID=""
				}
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_OperDesc
				Set InputStr=InputStr_"^"_OperDxID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
		        Set flg=##class(DHCHAI.DP.OROperDxMap).Update(InputStr,"^")
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

}
