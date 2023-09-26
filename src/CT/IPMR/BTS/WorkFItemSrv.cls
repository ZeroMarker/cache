/// 名称: CT.IPMR.BTS.WorkFItemSrv
/// 描述: 工作流操作项目相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BTS.WorkFItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询工作流操作项目
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       
/// output:       工作流操作项目列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.WorkFItemSrv","QryWFItem",1)
Query QryWFItem(aWorkFlowID As %String, aType As %String = "") As %Query(ROWSPEC = "WFItemID:%String,WFItemDesc:%String")
{
}

ClassMethod QryWFItemExecute(ByRef qHandle As %Binary, aWorkFlowID As %String, aType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:aWorkFlowID="" $$$OK
 	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	Set xSubId = ""
 	For {
	 	Set xSubId = $O(^CT.IPMR.BT.WorkFlowD(aWorkFlowID,"I",xSubId))
	 	Quit:xSubId=""
	 	
 		Set WFItemID=aWorkFlowID_"||"_xSubId
 		Set objWFItem = ##class(CT.IPMR.BT.WorkFItem).GetObjById(WFItemID)
 		Continue:'$IsObject(objWFItem)
		Continue:'$IsObject(objWFItem.BWItem)
		Continue:objWFItem.BWIsActive'=1
 		Continue:(aType'="")&&(aType'=objWFItem.BWType)
 		Set WFItemDesc  = objWFItem.BWItem.BWDesc
 		Set ItemAlias = objWFItem.BWAlias
 		Set:ItemAlias'="" WFItemDesc=ItemAlias
 		
		Set:WFItemDesc'="" WFItemDesc=##class(CT.IPMR.BT.WorkItem).GetTranByDesc("BWDesc",WFItemDesc,langid)
 		Set Data = $LB(WFItemID,WFItemDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryWFItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWFItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     WHui
/// CreatDate：   2019-10-26
/// Description:  查询工作流配置前置项目列表
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       aWFItemID ：工作流项目ID
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.WorkFItemSrv","QryWFCfgPreItem","1||1")
Query QryWFCfgPreItem(aWFItemID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemDesc:%String,IsChecked:%String")
{
}

ClassMethod QryWFCfgPreItemExecute(ByRef qHandle As %Binary, aWFItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aWFItemID="" $$$OK
 	Set WFlowID=+aWFItemID
 	
 	Set objWFItem=##class(CT.IPMR.BT.WorkFItem).GetObjById(aWFItemID)
	//Quit:'$IsObject(objWFItem) $$$OK
	
	// 判断传入参数是否为工作流操作项目
	if ($IsObject(objWFItem)){
		Quit:'$IsObject(objWFItem.BWItem) $$$OK
		Set cItemID=objWFItem.BWItem.%Id()
		Set PreItems=objWFItem.BWPreItems
		Set PreItems="#"_PreItems_"#"
	 	;b	;1
	 	Set xSub=""
	 	For {
		 	Set xSub = $O(^CT.IPMR.BT.WorkFlowD(WFlowID,"I",xSub))
		 	Quit:xSub=""
		 	
		 	Set obj=##class(CT.IPMR.BT.WorkFItem).GetObjById(WFlowID_"||"_xSub)
		 	Continue:'$IsObject(obj)
		 	
		 	Set ItemID=obj.BWItem.%Id()
		 	Continue:cItemID=ItemID
		 	Set ItemDesc=obj.BWItem.BWDesc
		 	Set yItemID="#"_ItemID_"#"
		 	If PreItems[yItemID {
			 	Set IsChecked=1
			} Else {
				Set IsChecked=0
			}
		 	
			Set Data=$lb(ItemID,ItemDesc,IsChecked)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}else{
	 	Set xSub=""
	 	For {
		 	Set xSub = $O(^CT.IPMR.BT.WorkFlowD(WFlowID,"I",xSub))
		 	Quit:xSub=""
		 	
		 	Set obj=##class(CT.IPMR.BT.WorkFItem).GetObjById(WFlowID_"||"_xSub)
		 	Continue:'$IsObject(obj)
		 	
		 	Set ItemID=obj.BWItem.%Id()
		 	Set ItemDesc=obj.BWItem.BWDesc
			Set IsChecked=0
		 	
			Set Data=$lb(ItemID,ItemDesc,IsChecked)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryWFCfgPreItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFCfgPreItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWFCfgPreItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFCfgPreItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     liyi
/// CreatDate：   2020-12-03
/// Description:  导入工作流项目
/// Table：       CT.IPMR.BT.WorkFItem
/// Input：       工作流项目数据
/// w ##class("CT.IPMR.BTS.WorkFItemSrv").ImportWFItem("IP^初始状态^初始状态^顺序项^顺序^初始状态^在院^在院^^1^0^0^0^纸张病历^","^")
ClassMethod ImportWFItem(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return = 0
	Quit:aInput="" return
	Set WFCode = $p(aInput,aSeparate,1)
	Set WItemDesc = $p(aInput,aSeparate,2)
	Set ItemAlias = $p(aInput,aSeparate,3)
	Set WorkTypeDesc = $p(aInput,aSeparate,4)
	Set SubFlowDesc = $p(aInput,aSeparate,5)
	Set SysOperaDesc = $p(aInput,aSeparate,6)
	Set PreStepDesc = $p(aInput,aSeparate,7)
	Set PostStepDesc = $p(aInput,aSeparate,8)
	Set PreItemDesc = $p(aInput,aSeparate,9)
	Set IsActive	=+$p(aInput,aSeparate,10)
	Set CheckUser	=+$p(aInput,aSeparate,11)
	Set BeRequest	=+$p(aInput,aSeparate,12)
	Set BatchOper	=+$p(aInput,aSeparate,13)
	Set MRCategoryDesc	= $p(aInput,aSeparate,14)
	Set Resume		= $p(aInput,aSeparate,15)
	
	Set objWorkFlow =  ##class(CT.IPMR.BT.WorkFlow).GetObjByCode(WFCode)
	Quit:'$isobject(objWorkFlow) return
	Set objWorkItem =  ##class(CT.IPMR.BT.WorkItem).GetObjByDesc(WItemDesc)
	Quit:'$isobject(objWorkItem) return
	Set objWorkType = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("WorkType",WorkTypeDesc)
	Quit:'$IsObject(objWorkType) return
	Set objWorkSubFlow = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("WorkSubFlow",SubFlowDesc)
	Quit:'$IsObject(objWorkSubFlow) return
	Set objSysOperation = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("SysOperation",SysOperaDesc)
	Quit:'$IsObject(objSysOperation) return
	Set objPreStep = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("WorkFlowStep",PreStepDesc)
	Set objPostStep = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("WorkFlowStep",PostStepDesc)
	Set objMRCategory = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("MRCategory",MRCategoryDesc)
	Quit:'$IsObject(objMRCategory) return
	Set PreItems=""
	For ind = 1:1:$length(PreItemDesc,"#") {
		Set xItem = $p(PreItemDesc,"#",ind)
		Continue:xItem=""
		Set xobjItem =  ##class(CT.IPMR.BT.WorkItem).GetObjByDesc(xItem)
		Continue:'$isobject(xobjItem)
		Set PreItems=$s(PreItems="":xobjItem.%Id(),1:PreItems_"#"_xobjItem.%Id())
	}
	Set InputStr = objWorkFlow.%Id()
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_objWorkItem.%Id()
	Set InputStr=InputStr_"^"_ItemAlias
	Set InputStr=InputStr_"^"_objWorkType.%Id()
	Set InputStr=InputStr_"^"_objWorkSubFlow.%Id()
	Set InputStr=InputStr_"^"_objSysOperation.%Id()
	Set InputStr=InputStr_"^"_$s($isobject(objPreStep):objPreStep.BDCode,1:"")
	Set InputStr=InputStr_"^"_$s($isobject(objPostStep):objPostStep.BDCode,1:"")
	Set InputStr=InputStr_"^"_PreItems
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_CheckUser
	Set InputStr=InputStr_"^"_BeRequest
	Set InputStr=InputStr_"^"_BatchOper
	Set InputStr=InputStr_"^"_objMRCategory.BDCode
	Set InputStr=InputStr_"^"_Resume
	Set return = ##class(CT.IPMR.BT.WorkFItem).Update(InputStr,aSeparate)
	Quit +return
}

}
