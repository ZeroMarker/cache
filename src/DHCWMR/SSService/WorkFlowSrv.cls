/// 名称: DHCWMR.SSService.WorkFlowSrv
/// 描述: 工作流相关服务
/// 编写者：李阳
/// 编写日期: 2014-08-25
Class DHCWMR.SSService.WorkFlowSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案类型取工作流项目列表
/// Table：       DHCWMR.SS.WorkFlow、DHCWMR.SS.WorkFItem
/// Input：       MrTypeID : 病案类型ID
///               OperaList : 菜单操作列表（权限控制）
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.WorkFlowSrv","QryWFItemList","","")
Query QryWFItemList(aMrTypeID As %String, aOperaList As %String) As %Query(ROWSPEC = "WFItemID:%String,WFItemDesc:%String,ItemID:%String,ItemType:%String,SubFlow:%String,PostStep:%String,SysOpera:%String,CheckUser:%String,BeRequest:%String,BatchOper:%String,MRCategory:%String")
{
}

ClassMethod QryWFItemListExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aOperaList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aOperaList="" $$$OK
	Set aOperaList="#"_aOperaList_"#"
	
	Set objWorkFlow=##class(DHCWMR.SS.WorkFlow).GetWorkFlow(aMrTypeID)
	Quit:'$IsObject(objWorkFlow) $$$OK
	Set WorkFlowID=objWorkFlow.%Id()
	
	Set xItemIndex=""
	For {
		Set xItemIndex=$o(^DHCWMR.SS.WorkFlowI("WFI","IndexItemNo",WorkFlowID,xItemIndex))
		Quit:xItemIndex=""
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.SS.WorkFlowI("WFI","IndexItemNo",WorkFlowID,xItemIndex,xSub))
			Quit:xSub=""
			
			Set WFItemID=WorkFlowID_"||"_xSub
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(WFItemID)
			Continue:'$IsObject(objWFItem)
			Continue:objWFItem.WFIIsActive'=1
			Continue:'$IsObject(objWFItem.WFIItem)
			Set ItemID=objWFItem.WFIItem.%Id()
			Set ItemDesc=objWFItem.WFIItem.WIDesc
			Set tmpItemDesc="#"_ItemDesc_"#"
			Continue:(aOperaList'="")&&(aOperaList'[ItemDesc)
			Set WFItemDesc=ItemDesc
			Set ItemAlias=objWFItem.WFIAlias
			Set:ItemAlias'="" WFItemDesc=ItemAlias
			Set ItemType=objWFItem.WFIType
			Set SubFlow=objWFItem.WFISubFlow
			Set PostStep=objWFItem.WFIPostStep
			Set SysOpera=objWFItem.WFISysOpera
			Set CheckUser=objWFItem.WFICheckUser
			Set BeRequest=objWFItem.WFIBeRequest
			Set BatchOper=objWFItem.WFIBatchOper
			Set MRCategory=objWFItem.WFIMRCategory
			
			Set Data=$lb(WFItemID,WFItemDesc,ItemID,ItemType,SubFlow,PostStep,SysOpera,CheckUser,BeRequest,BatchOper,MRCategory)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryWFItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFItemListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWFItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFItemListExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案类型取工作流项目列表
/// Table：       DHCWMR.SS.WorkFlow、DHCWMR.SS.WorkFItem
/// Input：       MrTypeID : 病案类型ID
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.WorkFlowSrv","QryWFItemByMrType","7")
Query QryWFItemByMrType(aMrTypeID As %String) As %Query(ROWSPEC = "WFItemID:%String,WFItemDesc:%String,ItemID:%String,ItemType:%String,SubFlow:%String,PostStep:%String,SysOpera:%String,CheckUser:%String,BeRequest:%String")
{
}

ClassMethod QryWFItemByMrTypeExecute(ByRef qHandle As %Binary, aMrTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objWorkFlow=##class(DHCWMR.SS.WorkFlow).GetWorkFlow(aMrTypeID)
	Quit:'$IsObject(objWorkFlow) $$$OK
	Set WorkFlowID=objWorkFlow.%Id()
	
	Set xItemIndex=""
	For {
		Set xItemIndex=$o(^DHCWMR.SS.WorkFlowI("WFI","IndexItemNo",WorkFlowID,xItemIndex))
		Quit:xItemIndex=""
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.SS.WorkFlowI("WFI","IndexItemNo",WorkFlowID,xItemIndex,xSub))
			Quit:xSub=""
			
			Set WFItemID=WorkFlowID_"||"_xSub
			Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(WFItemID)
			Continue:'$IsObject(objWFItem)
			Continue:objWFItem.WFIIsActive'=1
			Continue:'$IsObject(objWFItem.WFIItem)
			Set ItemID=objWFItem.WFIItem.%Id()
			Set ItemDesc=objWFItem.WFIItem.WIDesc
			Set WFItemDesc=ItemDesc
			Set ItemAlias=objWFItem.WFIAlias
			Set:ItemAlias'="" WFItemDesc=ItemAlias
			Set ItemType=objWFItem.WFIType
			Set SubFlow=objWFItem.WFISubFlow
			Set PostStep=objWFItem.WFIPostStep
			Set SysOpera=objWFItem.WFISysOpera
			Set CheckUser=objWFItem.WFICheckUser
			Set BeRequest=objWFItem.WFIBeRequest
			
			Set Data=$lb(WFItemID,WFItemDesc,ItemID,ItemType,SubFlow,PostStep,SysOpera,CheckUser,BeRequest)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryWFItemByMrTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFItemByMrTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWFItemByMrTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFItemByMrTypeExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-11-18
/// Description:  查询工作流配置项目列表
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       WFlowID ：工作流ID
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.WorkFlowSrv","QryWFCfgItem",1)
Query QryWFCfgItem(aWFlowID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemDesc:%String,ItemIndex:%String,ItemAlias:%String,WFItemID:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,PreStepCode:%String,PreStepDesc:%String,PostStepCode:%String,PostStepDesc:%String,PreItems:%String,SysOperaID:%String,SysOperaCode:%String,SysOperaDesc:%String,CheckUser:%String,CheckUserDesc:%String,BeRequest:%String,BeRequestDesc:%String,BatchOper:%String,BatchOperDesc:%String,MRCategory:%String,MRCategoryDesc:%String,SubFlowID:%String,SubFlowDesc:%String,IsActive:%String,IsActiveDesc:%String,Resume:%String")
{
}

ClassMethod QryWFCfgItemExecute(ByRef qHandle As %Binary, aWFlowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Kill arrWorkFlowItems
 	Set xSub="",WFItemList=""
 	For {
	 	Set xSub = $O(^DHCWMR.SS.WorkFlowD(aWFlowID,"I",xSub))
	 	Quit:xSub=""
	 	
	 	Set WFItemID=aWFlowID_"||"_xSub
	 	Set obj=##class(DHCWMR.SS.WorkFItem).GetObjById(WFItemID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ItemID = obj.WFIItem.%Id()
	 	Set ItemDesc = obj.WFIItem.WIDesc
	 	Set ItemIndex = obj.WFIIndex
	 	Set ItemAlias = obj.WFIAlias
	 	
	 	Set TypeCode = obj.WFIType
	 	Set TypeDesc =""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkType",TypeCode,"")
	 	If $IsObject(objDic){
		 	Set TypeID=objDic.%Id()
	 		Set TypeDesc=objDic.SDDesc
	 	}
	 	
	 	Set PreStepCode = obj.WFIPreStep
	 	Set PreStepDesc=""
	 	For indStep=1:1:$l(PreStepCode,"#") {
		 	Set tmpStepCode=$p(PreStepCode,"#",indStep)
		 	Continue:tmpStepCode=""
		 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkFlowStep",tmpStepCode,"")
		 	If $IsObject(objDic){
		 		Set PreStepDesc=PreStepDesc_","_objDic.SDDesc
		 	}
		}
		Set PreStepCode=$tr(PreStepCode,"#",",")
		Set:PreStepDesc'="" PreStepDesc=$e(PreStepDesc,2,$l(PreStepDesc))
	 	
	 	Set PostStepCode = obj.WFIPostStep
	 	Set PostStepDesc=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkFlowStep",PostStepCode,"")
	 	If $IsObject(objDic){
	 		Set PostStepDesc=objDic.SDDesc
	 	}
	 	
	 	Set PreItems = obj.WFIPreItems
	 	
	 	Set SysOperaCode = obj.WFISysOpera
	 	Set SysOperaDesc="",SysOperaID=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("SysOperation",SysOperaCode,"")
	 	If $IsObject(objDic){
		 	Set SysOperaID=objDic.%Id()
	 		Set SysOperaDesc=objDic.SDDesc
	 	}
	 	
	 	Set CheckUser = obj.WFICheckUser
	 	Set CheckUserDesc=""
	 	Set:CheckUser="1" CheckUserDesc="是"
	 	Set:CheckUser="0" CheckUserDesc="否"
	 	
	 	Set BeRequest = obj.WFIBeRequest
	 	Set BeRequestDesc=""
	 	Set:BeRequest="1" BeRequestDesc="是"
	 	Set:BeRequest="0" BeRequestDesc="否"
	 	
	 	Set BatchOper = obj.WFIBatchOper
	 	Set BatchOperDesc=""
	 	Set:BatchOper="1" BatchOperDesc="是"
	 	Set:BatchOper="0" BatchOperDesc="否"
	 	
	 	Set MRCategory = obj.WFIMRCategory
	 	Set MRCategoryDesc=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("MRCategory",MRCategory,"")
	 	If $IsObject(objDic){
	 		Set MRCategoryDesc=objDic.SDDesc
	 	}
	 	
	 	Set SubFlow = obj.WFISubFlow
	 	Set SubFlowID="",SubFlowDesc=""
	 	Set objDic = ##class(DHCWMR.SS.Dictionary).GetByTypeCode("WorkSubFlow",SubFlow,"")
	 	If $IsObject(objDic){
		 	Set SubFlowID=objDic.%Id()
	 		Set SubFlowDesc=objDic.SDDesc
	 	}
	 	Set IsActive=obj.WFIIsActive
	 	Set IsActive=+IsActive
	 	Set IsActiveDesc=""
	 	Set:IsActive="1" IsActiveDesc="是"
	 	Set:IsActive="0" IsActiveDesc="否"
	 	Set Resume = obj.WFIResume
	 	
	 	Set arrWorkFlowItems(1,ItemIndex)=$lb(ItemID,ItemDesc,ItemIndex,ItemAlias,WFItemID,TypeID,TypeCode,TypeDesc,PreStepCode,PreStepDesc,PostStepCode,PostStepDesc,PreItems,SysOperaID,SysOperaCode,SysOperaDesc,CheckUser,CheckUserDesc,BeRequest,BeRequestDesc,BatchOper,BatchOperDesc,MRCategory,MRCategoryDesc,SubFlowID,SubFlowDesc,IsActive,IsActiveDesc,Resume)
		Set WFItemList=WFItemList_$lb(ItemID)
	}
	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.SS.WorkItemD(xID))
	 	Quit:xID=""
	 	Continue:$listfind(WFItemList,xID)>0
	 	
	 	Set (ItemID,ItemDesc,ItemIndex,ItemAlias,WFItemID,TypeID,TypeCode,TypeDesc,PreStepCode,PreStepDesc)=""
	 	Set (PostStepCode,PostStepDesc,PreItems,SysOperaID,SysOperaCode,SysOperaDesc)=""
	 	Set (CheckUser,CheckUserDesc,BeRequest,BeRequestDesc,BatchOper,BatchOperDesc,MRCategory,MRCategoryDesc,SubFlowID,SubFlowDesc)=""
	 	Set (IsActive,IsActiveDesc,Resume)=""
	 	
	 	Set objWorkItem=##class(DHCWMR.SS.WorkItem).GetObjById(xID)
	 	Continue:'$IsObject(objWorkItem)
	 	Set ItemID = objWorkItem.%Id()
	 	Set ItemDesc = objWorkItem.WIDesc
	 	Set IsActive=0
	 	Set IsActiveDesc="否"
	 	
 		Set arrWorkFlowItems(2,ItemID)=$lb(ItemID,ItemDesc,ItemIndex,ItemAlias,WFItemID,TypeID,TypeCode,TypeDesc,PreStepCode,PreStepDesc,PostStepCode,PostStepDesc,PreItems,SysOperaID,SysOperaCode,SysOperaDesc,CheckUser,CheckUserDesc,BeRequest,BeRequestDesc,BatchOper,BatchOperDesc,MRCategory,MRCategoryDesc,SubFlowID,SubFlowDesc,IsActive,IsActiveDesc,Resume)
	}
 	
 	Set xCategory=""
 	For {
	 	Set xCategory=$o(arrWorkFlowItems(xCategory))
		Quit:xCategory=""
		Set xIndex=""
		For {
			Set xIndex=$o(arrWorkFlowItems(xCategory,xIndex))
			Quit:xIndex=""
			
			Set Data=$g(arrWorkFlowItems(xCategory,xIndex))
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
 	}
	Kill arrWorkFlowItems
	
	Quit $$$OK
}

ClassMethod QryWFCfgItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWFCfgItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWFCfgItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWFCfgItemExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-11-18
/// Description:  查询工作流配置前置项目列表
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       WFlowID ：工作流ID
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.WorkFlowSrv","QryWFCfgPreItem","1||1")
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
 	
 	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(aWFItemID)
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set cItemID=objWFItem.WFIItem.%Id()
	Set PreItems=objWFItem.WFIPreItems
	Set PreItems="#"_PreItems_"#"
 	
 	Set xSub=""
 	For {
	 	Set xSub = $O(^DHCWMR.SS.WorkFlowD(WFlowID,"I",xSub))
	 	Quit:xSub=""
	 	
	 	Set obj=##class(DHCWMR.SS.WorkFItem).GetObjById(WFlowID_"||"_xSub)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ItemID=obj.WFIItem.%Id()
	 	Continue:cItemID=ItemID
	 	Set ItemDesc=obj.WFIItem.WIDesc
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

}
