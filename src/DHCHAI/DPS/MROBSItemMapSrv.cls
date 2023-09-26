/// 名称: DHCHAI.DPS.MROBSItemMapSrv
/// 描述: 护理分类对照相关服务
/// 编写者：maxiangping
/// 编写日期: 2017-05-05
Class DHCHAI.DPS.MROBSItemMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  查询列表
/// Table：       DHCHAI.DP.MROBSItem
/// Input：       aFlg:是否关联检查项目标志,"":查询全部,0:查询未关联,1:查询已关联
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.MROBSItemMapSrv","QryMROBSItemMap")
Query QryMROBSItemMap(aFlg As %String = "") As %Query(ROWSPEC = "ID:%String,BTItemDesc:%String,MapItemDr:%String,MapItemCode:%String,MapItemDesc:%String,MapNote:%String,BTSCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryMROBSItemMapExecute(ByRef qHandle As %Binary, aFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set xBTSCode=""
	For {
		Set xBTSCode=$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",xBTSCode))
		Quit:xBTSCode=""
		
		Set xItemDesc=""
		For {
			Set xItemDesc=$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",xBTSCode,xItemDesc))
			Quit:xItemDesc=""
		
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",xBTSCode,xItemDesc,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.DP.MROBSItemMap).GetObjById(xID)
	 			Continue:'$IsObject(obj)
	 			Set ItemDesc=obj.BTItemDesc
				
				If $IsObject(obj.BTMapItemDr) {
					Set MapItemDr=obj.BTMapItemDr.%Id()
					Set MapItemCode=obj.BTMapItemDr.BTItemCode
					Set MapItemDesc=obj.BTMapItemDr.BTItemDesc
				} Else {
					Set MapItemDr="",MapItemCode="",MapItemDesc=""
				}
				Continue:(aFlg=0)&&(MapItemDr'="")
				Continue:(aFlg=1)&&(MapItemDr="")
				Set MapNote=obj.BTMapNote
				Set BTSCode=obj.BTSCode
				Set HospGroup=""
				Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(BTSCode)
				If $IsObject(objSystem) {
					Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
				}
				
				Set IsActive=obj.BTIsActive
				Continue:(aFlg=0)&&(IsActive'=1) //未对照不显示无效项目
				Set ActDate=obj.BTActDate
				Set:ActDate'="" ActDate=##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set ActTime=obj.BTActTime
				Set:ActTime'="" ActTime=$zt(ActTime,1)
				Set ActUser=obj.BTActUser
				Set Data=$lb(xID,ItemDesc,MapItemDr,MapItemCode,MapItemDesc,MapNote,BTSCode,IsActive,ActDate,ActTime,ActUser,HospGroup)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryMROBSItemMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMROBSItemMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMROBSItemMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMROBSItemMapExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-08-06
/// Description:  更新护理项目对照
/// Table：       DHCHAI.DP.MROBSItemMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.OEAntiMastMapSrv).UpdateMap("1","1","9")
ClassMethod UpdateMap(ID As %String, ItemID As %String, UserName As %String) As %String
{
	New (ID,ItemID,UserName)
	Set return=0
	Quit:(ID="")||(ItemID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.MROBSItem).GetObjById(ItemID)

	Set obj=##class(DHCHAI.DP.MROBSItemMap).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set obj.BTMapItemDr	= objMapItem
	Set obj.BTActUser = UserName
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
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.MROBSItem,DHCHAI.DP.MROBSItemMap
/// Input：		  aCatID：匹配规则表DHCHAI.DP.DataMapRule.ID
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.OEAntiMastMapSrv).SynMapRule("护理项目")
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
	    Set xSCode=$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",xSCode))
	    Quit:xSCode=""
	    
	    Set xItemDesc=""
	    For {  
			Set xItemDesc=$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",xSCode,xItemDesc))
		    Quit:xItemDesc=""
		   
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.MROBSItemMapI("IndexSCodeItemDesc",xSCode,xItemDesc,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.MROBSItemMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)	
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapItemDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
				
				Set ItemDesc = objMap.BTItemDesc
				Continue:ItemDesc=""
				Set ItemID = $o(^DHCHAI.DP.MROBSItemI("IndexItemDesc",ItemDesc,0)) //名称一样可直接匹配
				If (ItemID="") {
			     	Set Desc = ""
					
					Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,0,ItemDesc,0))  //匹配
					If MapRuleID'="" {
						Set objRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
						Continue:'$Isobject(objRule)
						Set Desc   = objRule.BTDesc 
		
					} Else  {
						Set xMapDesc=""   // 包含（排除）规则
						For {
							Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc))
							Quit:xMapDesc=""
							
							Continue:ItemDesc'[xMapDesc
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
								Continue:ItemDesc'[ExMapDesc
								Set Flg=1
								Quit
							}
							Continue:Flg>0
							Set Desc=tDesc
							Quit
						}
					}
					
					Continue:Desc=""
					Set ItemID = $o(^DHCHAI.DP.MROBSItemI("IndexItemDesc",Desc,0))
					Continue:ItemID=""
				}
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_ItemDesc
				Set InputStr=InputStr_"^"_ItemID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
		        Set flg=##class(DHCHAI.DP.MROBSItemMap).Update(InputStr,"^")
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

}
