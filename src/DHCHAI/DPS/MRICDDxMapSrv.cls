/// 名称: DHCHAI.DPS.MRICDDxMapSrv
/// 描述: 诊断分类对照规则服务类
/// 编写者：chenjb
/// 编写日期: 2017-05-08
Class DHCHAI.DPS.MRICDDxMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-05-08
/// Description:  查询列表
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       aFlg:是否关联诊断字典标志,"":查询全部,0:查询未关联,1:查询已关联
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MRICDDxMapSrv","QryMRICDDxMap","1")
Query QryMRICDDxMap(aFlg As %String = "") As %Query(ROWSPEC = "ID:%String,BTDiagDesc:%String,MapItemDr:%String,MapItemCode:%String,MapItemDesc:%String,BTMapNote:%String,BTSCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryMRICDDxMapExecute(ByRef qHandle As %Binary, aFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.MRICDDxMapD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.MRICDDxMap).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set BTDiagDesc=obj.BTDiagDesc
	 	Set BTMapItemDr="",BTMapItemCode="",BTMapItemDesc=""
	 	If $IsObject(obj.BTMapItemDr) {
			Set BTMapItemDr=obj.BTMapItemDr.%Id()
			Set BTMapItemCode=obj.BTMapItemDr.BTCode
			Set BTMapItemDesc=obj.BTMapItemDr.BTDesc	
	 	}
	 	Continue:(aFlg=0)&&(BTMapItemDr'="")
		Continue:(aFlg=1)&&(BTMapItemDr="")
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
		
		set Data=$lb(xID,BTDiagDesc,BTMapItemDr,BTMapItemCode,BTMapItemDesc,BTMapNote,BTSCode,BTIsActive,BTActDate,BTActTime,BTActUser,HospGroup)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMRICDDxMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRICDDxMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRICDDxMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRICDDxMapExecute ]
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
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       aCode : 是否已对照 1 - 已对照 0 未对
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MRICDDxMapSrv","QryMRICDDxMapByInit")
Query QryMRICDDxMapByInit() As %Query(ROWSPEC = "ID:%String,BTDiagDesc:%String,BTMapItemDr:%String,BTMapNote:%String,BTSCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMRICDDxMapByInitExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1

 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.DP.MRICDDxMapD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.DP.MRICDDxMap).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set BTDiagDesc=obj.BTDiagDesc
	 	Set BTMapItemDr=obj.BTMapItemDr
	 	//默认加载已对照
	 	Continue:($IsObject(BTMapItemDr))&&(BTMapItemDr.BTCode'="")
	 	Set BTMapNote=obj.BTMapNote
	 	Set BTSCode=obj.BTSCode
		Set BTIsActive=obj.BTIsActive
		Set BTActDate =obj.BTActDate
		Set BTActTime =obj.BTActTime
		Set:BTActDate'="" BTActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(BTActDate)
	    Set:BTActTime'="" BTActTime=$zt(BTActTime,1)
		Set BTActUser =obj.BTActUser
		
		set Data=$lb(xID,BTDiagDesc,BTMapItemDr,BTMapNote,BTSCode,BTIsActive,BTActDate,BTActTime,BTActUser)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMRICDDxMapByInitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMRICDDxMapByInitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMRICDDxMapByInitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMRICDDxMapByInitExecute ]
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
/// Table：       DHCHAI.DP.MRICDDxMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.MRICDDxMapSrv).UpdateMap("1","1","med")
ClassMethod UpdateMap(ID As %String, ICDDxID As %String, UsersName As %String) As %String
{
	New (ID,ICDDxID,UsersName)
	Set return=0
	Quit:(ID="")||(ICDDxID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.MRICDDx).GetObjById(ICDDxID)

	Set obj=##class(DHCHAI.DP.MRICDDxMap).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set obj.BTMapItemDr	= objMapItem
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
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.MRICDDx,DHCHAI.DP.MRICDDxMap
/// Input：		  aCatID：匹配规则表DHCHAI.DP.DataMapRule.ID
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.MRICDDxMapSrv).SynMapRule("诊断项目")
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
	    Set xSCode=$o(^DHCHAI.DP.MRICDDxMapI("IndexSCodeDiagDesc",xSCode))
	    Quit:xSCode=""
	    
	    Set xDiagDesc=""
	    For {  
			Set xDiagDesc=$o(^DHCHAI.DP.MRICDDxMapI("IndexSCodeDiagDesc",xSCode,xDiagDesc))
		    Quit:xDiagDesc=""
		   
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.MRICDDxMapI("IndexSCodeDiagDesc",xSCode,xDiagDesc,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.MRICDDxMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)	
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapItemDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
			
				Set DiagDesc = objMap.BTDiagDesc
				Continue:DiagDesc=""
				
				Set ICDDxID = $o(^DHCHAI.DP.MRICDDxI("IndexDesc",DiagDesc,0)) //名称一样可直接匹配
				If (ICDDxID="") {
			     	Set Desc = ""
					Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,0,DiagDesc,0))  //匹配
					If MapRuleID'="" {
						Set objRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
						Continue:'$Isobject(objRule)
						Set Desc   = objRule.BTDesc 
					} Else  {
						Set xMapDesc=""   // 包含（排除）规则
						For {
							Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc))
							Quit:xMapDesc=""
							
							Continue:DiagDesc'[xMapDesc
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
								Continue:DiagDesc'[ExMapDesc
								Set Flg=1
								Quit
							}
							Continue:Flg>0
							Set Desc=tDesc
							Quit
						}
					}
			
					Continue:Desc=""
					Set ICDDxID = $o(^DHCHAI.DP.MRICDDxI("IndexDesc",Desc,0))
					Continue:ICDDxID=""
				}
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_DiagDesc
				Set InputStr=InputStr_"^"_ICDDxID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
		        Set flg=##class(DHCHAI.DP.MRICDDxMap).Update(InputStr,"^")
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

}
