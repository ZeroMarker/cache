/// 名称: DHCHAI.DPS.LabSpecSrv
/// 描述: 标本相关服务
/// 编写者：pylian
/// 编写日期: 2017-05-09
Class DHCHAI.DPS.LabSpecSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-05-09
/// Description:  查询标本
/// Table：       DHCHAI.DP.LabSpecimen
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabSpecSrv","QryLabSpecimen")
Query QryLabSpecimen(aActive As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,SpecCode:%String,SpecDesc:%String,WCode:%String,IsActive:%String,IsActDesc:%String,PropertyID:%String,PropertyCode:%String,PropertyDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabSpecimenExecute(ByRef qHandle As %Binary, aActive As %String = "", aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabSpecimenD(xID))
		Quit:xID=""
	  
		Set objSpec = ##class(DHCHAI.DP.LabSpecimen).GetObjById(xID)
		Continue:'$Isobject(objSpec)
			
		Set SpecCode  = objSpec.BTSpecCode
		Set SpecDesc  = objSpec.BTSpecDesc
		Continue:(aAlias'="")&&('(SpecDesc[aAlias))&&('(SpecCode[aAlias))
		Set WCode     = objSpec.BTWCode
		Set IsActive  = objSpec.BTIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		
		Set PropertyID="",PropertyCode="",PropertyDesc=""
		If $IsObject(objSpec.BTPropertyDr){
			Set PropertyID   = objSpec.BTPropertyDr.%Id()
			Set PropertyCode = objSpec.BTPropertyDr.BTCode
			Set PropertyDesc = objSpec.BTPropertyDr.BTDesc
		}
		
		Set Data = $lb(xID,SpecCode,SpecDesc,WCode,IsActive,IsActDesc,PropertyID,PropertyCode,PropertyDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabSpecimenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabSpecimenExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabSpecimenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabSpecimenExecute ]
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
/// CreatDate：   2017-05-09
/// Description:  标本对照
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       aFlg:是否关联细菌字典标志,"":查询全部,0:查询未关联,1:查询已关联
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabSpecSrv","QryLabSpecMap","","")
Query QryLabSpecMap(aFlg As %String = "", aActive As %String = "") As %Query(ROWSPEC = "ID:%String,SpecDesc:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryLabSpecMapExecute(ByRef qHandle As %Binary, aFlg As %String = "", aActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	 
	Set MapRuleCatDr=""
	Set objMapRuleCat=##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule","检验标本")
	If $Isobject(objMapRuleCat) {
		Set MapRuleCatDr=objMapRuleCat.%Id()
	}
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabSpecMapD(xID))
		Quit:xID=""
	  
		Set objMap = ##class(DHCHAI.DP.LabSpecMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
			
		Set SpecDesc  = objMap.BTSpecDesc
		Set MapItemDr = objMap.BTMapItemDr
		Set MapItemID="",MapItemCode="",MapItemDesc=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set MapItemCode = objMap.BTMapItemDr.BTSpecCode
			Set MapItemDesc = objMap.BTMapItemDr.BTSpecDesc
		} Else {
			Set SpecID=$o(^DHCHAI.DP.LabSpecimenI("IndexDesc",SpecDesc,0)) //名称一样可直接匹配
			If SpecID'="" {
				Set objSpec=##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecID)
				If $IsObject(objSpec){
					Set MapItemDesc=objSpec.BTSpecDesc
				}
			} Else {
				Set MapItemDesc=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(MapRuleCatDr,SpecDesc)
				Set:MapItemDesc["^" MapItemDesc=$tr(MapItemDesc,"^","、")
			}
			Set:MapItemDesc'="" MapItemDesc=MapItemDesc_"[!!]"
		}
		Continue:(aFlg=0)&&(MapItemID'="")
		Continue:(aFlg=1)&&(MapItemID="")
		
		Set MapNote  = objMap.BTMapNote
		Set SCode    = objMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		Set IsActive = objMap.BTIsActive
		Continue:(aFlg=0)&&(IsActive'=1) //未对照不显示无效项目
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set ActDate  = objMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser  = objMap.BTActUser
		
		If $d(^DHCHAI.DP.LabVisitNumberI("IndexSpecimen"," "_SpecDesc)){
			Set SpecDesc=SpecDesc_"[√]"
		}
		
		Set Data = $lb(xID,SpecDesc,MapItemID,MapItemCode,MapItemDesc,MapNote,SCode,IsActive,IsActDesc,ActDate,ActTime,ActUser,HospGroup)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabSpecMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabSpecMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabSpecMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabSpecMapExecute ]
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
/// CreatDate：   2017-05-09
/// Description:  根据标准标本名称查询标本对照
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabSpecSrv","QrySpecMapByItem","1")
Query QrySpecMapByItem(aItemID As %String) As %Query(ROWSPEC = "ID:%String,SpecDesc:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QrySpecMapByItemExecute(ByRef qHandle As %Binary, aItemID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Quit:(aItemID="") $$$OK
    
    Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabSpecMapI("IndexMapItemDr",aItemID,xID))
		Quit:xID="" 
			
		Set objMap = ##class(DHCHAI.DP.LabSpecMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
			
		Set SpecDesc  = objMap.BTSpecDesc
		Set MapItemDr = objMap.BTMapItemDr
		Set MapItemID="",MapItemCode="",MapItemDesc=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set MapItemCode = objMap.BTMapItemDr.BTSpecCode
			Set MapItemDesc = objMap.BTMapItemDr.BTSpecDesc
		}
		Set MapNote  = objMap.BTMapNote
		Set SCode    = objMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		
		Set IsActive = objMap.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set ActDate  = objMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser  = objMap.BTActUser
					
		Set Data = $lb(xID,SpecDesc,MapItemID,MapItemCode,MapItemDesc,MapNote,SCode,IsActive,IsActDesc,ActDate,ActTime,ActUser,HospGroup)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QrySpecMapByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySpecMapByItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySpecMapByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySpecMapByItemExecute ]
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
/// CreatDate：   2017-08-04
/// Description:  更新标本对照
/// Table：       DHCHAI.DP.LabSpecMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.LabSpecSrv).UpdateMap("1","1","med")
ClassMethod UpdateMap(ID As %String, SpeID As %String, UsersName As %String) As %String
{
	New (ID,SpeID,UsersName)
	Set return=0
	Quit:(ID="")||(SpeID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.LabSpecimen).GetObjById(SpeID)

	Set obj=##class(DHCHAI.DP.LabSpecMap).%OpenId(ID)
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
/// CreatDate：   2017-08-04
/// Description:  自动匹配对照规则
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.LabSpecimen,DHCHAI.DP.LabSpecMap
/// Input：		  aCatDesc：匹配规则表分类描述
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.LabSpecSrv).SynMapRule("检验标本")
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
	    Set xSCode=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",xSCode))
	    Quit:xSCode=""
	    
	    Set xSpecDesc=""
	    For {  
			Set xSpecDesc=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",xSCode,xSpecDesc))
		    Quit:xSpecDesc=""
		   
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",xSCode,xSpecDesc,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.LabSpecMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)	
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapItemDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
				
				Set SpecDesc = objMap.BTSpecDesc
				Continue:SpecDesc=""
				Set SpeID = $o(^DHCHAI.DP.LabSpecimenI("IndexDesc",SpecDesc,0)) //名称一样可直接匹配
				If (SpeID="") {
					Set RuleDesc=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(aCatID,SpecDesc)
					Continue:RuleDesc=""
					Continue:$l(RuleDesc,"^")>1
					Set SpeID=$o(^DHCHAI.DP.LabSpecimenI("IndexDesc",RuleDesc,0))
					Continue:SpeID=""
				}
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_SpecDesc
				Set InputStr=InputStr_"^"_SpeID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
				Set flg=##class(DHCHAI.DP.LabSpecMap).Update(InputStr,"^")
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

/// Creator：     pylian
/// CreatDate：   2019-04-24
/// Description:  导入标本字典
/// Table：       DHCHAI.DP.LabSpecimen
/// Input：      
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.DPS.LabSpecSrv).ImportSpec("^142^引流液^dn^1^","^")
ClassMethod ImportSpec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set:aSeparate="" aSeparate="^"
	Set ID       = $p(aInput,aSeparate,1)    //ID
	Set SpecCode = $p(aInput,aSeparate,2)  
	Set SpecDesc = $p(aInput,aSeparate,3)  
	Set WCode    = $p(aInput,aSeparate,4)  
	Set IsActive = $p(aInput,aSeparate,5)  
	Set Property = $p(aInput,aSeparate,6)  
	Quit:(SpecCode="")||(SpecDesc="")||(IsActive="") return
	
	Set SpecDesc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)  //去掉特殊字符
	
	Set PropertyDr=""
	Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("LabSpecType",Property)
	Set:$Isobject(objDic) PropertyDr = objDic.%Id()
	
	Set ID=$o(^DHCHAI.DP.LabSpecimenI("IndexCode",SpecCode,0))
	If ID="" {
		Set ID=$o(^DHCHAI.DP.LabSpecimenI("IndexDesc",SpecDesc,0))
	}
	Set InputStr=ID                             //ID
	Set InputStr=InputStr_aSeparate_SpecCode    //关键词
	Set InputStr=InputStr_aSeparate_SpecDesc    //优先级ID
	Set InputStr=InputStr_aSeparate_WCode       //属性
    Set InputStr=InputStr_aSeparate_IsActive    //疑似诊断ID
    Set InputStr=InputStr_aSeparate_PropertyDr 
    
	Set return=##Class(DHCHAI.DP.LabSpecimen).Update(InputStr,aSeparate)
	Quit return
}

}
