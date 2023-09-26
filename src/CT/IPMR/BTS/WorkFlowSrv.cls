/// 名称: CT.IPMR.BTS.WorkFlowSrv
/// 描述: 工作流服务类
/// 创建者：whui
/// 创建日期: 2019-10-23
Class CT.IPMR.BTS.WorkFlowSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     WHui
/// CreatDate：   2019-12-23
/// Description:  根据病案类型取工作流项目列表
/// Table：       CT.IPMR.BT.WorkFlow、CT.IPMR.BT.WorkFItem
/// Input：       MrTypeID : 病案类型ID
///               OperaList : 菜单操作列表（权限控制）
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("CT.IPMR.BTS.WorkFlowSrv","QryWFItemList","7","病案回收#归档上架#病案复印#病案借阅#借阅还回#病案封存#病案解封")
Query QryWFItemList(aMrTypeID As %String, aOperaList As %String = "") As %Query(ROWSPEC = "WFItemID:%String,WFItemDesc:%String,ItemID:%String,ItemType:%String,SubFlow:%String,SysOpera:%String,PreStep:%String,PreItems:%String,PostStep:%String,CheckUser:%String,BeRequest:%String,BatchOper:%String,MRCategory,ItemIndex:%String")
{
}

ClassMethod QryWFItemListExecute(ByRef qHandle As %Binary, aMrTypeID As %String, aOperaList As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	// 多语言
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Quit:(aMrTypeID="") $$$OK
	Set:aOperaList'="" aOperaList="#"_aOperaList_"#"
	
	Set objWorkFlow=##class(CT.IPMR.BT.WorkFlow).GetWorkFlow(aMrTypeID)
	Quit:'$IsObject(objWorkFlow) $$$OK
	Set WorkFlowID=objWorkFlow.%Id()
	
	Set xItemIndex=""
	For {
		Set xItemIndex=$o(^CT.IPMR.BT.WorkFlowI("I","IndexItemNo",WorkFlowID,xItemIndex))
		Quit:xItemIndex=""
		Set xSub=0
		For {
			Set xSub=$o(^CT.IPMR.BT.WorkFlowI("I","IndexItemNo",WorkFlowID,xItemIndex,xSub))
			Quit:xSub=""
			
			Set WFItemID=WorkFlowID_"||"_xSub
			Set objWFItem=##class(CT.IPMR.BT.WorkFItem).GetObjById(WFItemID)
			Continue:'$IsObject(objWFItem)
			Continue:objWFItem.BWIsActive'=1
			Continue:'$IsObject(objWFItem.BWItem)
			Set ItemID		= objWFItem.BWItem.%Id()
			Set ItemDesc	= objWFItem.BWItem.BWDesc
			Set tmpItemDesc	= "#"_ItemDesc_"#"
			
			Continue:(aOperaList'="")&&(aOperaList'[tmpItemDesc)
			Set WFItemDesc	= ItemDesc
			Set ItemAlias	= objWFItem.BWAlias
			Set:ItemAlias'="" WFItemDesc=ItemAlias
			Set ItemType	= objWFItem.BWType			; 项目类型, 顺序项O、突发项E
			Set SubFlow		= objWFItem.BWSubFlow		; 操作流程, 顺序O、质控Q、借阅L、复印C、封存S
			Set SysOpera	= objWFItem.BWSysOpera		; 系统操作, 病案回收RC,病案编目FP,病历质控QC,归档上架S...
			Set PreStep		= objWFItem.BWPreStep		; 前置步骤, 在院A、出院D、归档S
			Set PreItems	= objWFItem.BWPreItems		; 前提操作, 指向CT.IPMR.BT.WorkItem
			Set PostStep	= objWFItem.BWPostStep		; 操作步骤, 在院A、出院D、归档S
			Set CheckUser	= objWFItem.BWCheckUser
			Set BeRequest	= objWFItem.BWBeRequest
			Set BatchOper	= objWFItem.BWBatchOper
			Set MRCategory	= objWFItem.BWMRCategory
			Set ItemIndex	= objWFItem.BWIndex
			Set:WFItemDesc'="" WFItemDesc=##class(CT.IPMR.BT.Dictionary).GetTranByDesc("BDDesc",WFItemDesc,langid)
			Set Data=$lb(WFItemID,WFItemDesc,ItemID,ItemType,SubFlow,SysOpera,PreStep,PreItems,PostStep,CheckUser,BeRequest,BatchOper,MRCategory,ItemIndex)
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询工作流
/// Table：       CT.IPMR.BT.WorkFlow
/// Input：       
/// output:       工作流列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.WorkFlowSrv","QryWorkFlow")
Query QryWorkFlow() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Resume:%String")
{
}

ClassMethod QryWorkFlowExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID=$o(^CT.IPMR.BT.WorkFlowD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(CT.IPMR.BT.WorkFlow).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set Code=obj.BWCode
	 	Set Desc=obj.BWDesc
		Set Resume=obj.BWResume
		
		Set Data=$lb(ID,Code,Desc,Resume)
		Set ^CacheTemp(repid,ind)=Data 
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryWorkFlowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkFlowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWorkFlowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkFlowExecute ]
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
/// CreatDate：   2019-10-25
/// Description:  查询工作流配置项目列表
/// Table：       CT.IPMR.BT.WorkFlow
/// Input：       
/// output:       工作流列表
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.WorkFlowSrv","QryWFCfgItem","1")
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
	 	Set xSub = $O(^CT.IPMR.BT.WorkFlowD(aWFlowID,"I",xSub))
	 	Quit:xSub=""
	 	
	 	Set WFItemID=aWFlowID_"||"_xSub
	 	Set obj=##class(CT.IPMR.BT.WorkFItem).GetObjById(WFItemID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ItemID = obj.BWItem.%Id()
	 	Set ItemDesc = obj.BWItem.BWDesc
	 	Set ItemIndex = obj.BWIndex
	 	Set ItemAlias = obj.BWAlias
	 	
	 	Set TypeCode = obj.BWType
	 	Set TypeDesc =""
	 	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("WorkType",TypeCode,"")
	 	If $IsObject(objDic){
		 	Set TypeID=objDic.%Id()
	 		Set TypeDesc=objDic.BDDesc
	 	}
	 	
	 	Set PreStepCode = obj.BWPreStep
	 	Set PreStepDesc=""
	 	For indStep=1:1:$l(PreStepCode,"#") {
		 	Set tmpStepCode=$p(PreStepCode,"#",indStep)
		 	Continue:tmpStepCode=""
		 	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("WorkFlowStep",tmpStepCode,"")
		 	If $IsObject(objDic){
		 		Set PreStepDesc=PreStepDesc_","_objDic.BDDesc
		 	}
		}
		Set PreStepCode=$tr(PreStepCode,"#",",")
		Set:PreStepDesc'="" PreStepDesc=$e(PreStepDesc,2,$l(PreStepDesc))
	 	
	 	Set PostStepCode = obj.BWPostStep
	 	Set PostStepDesc=""
	 	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("WorkFlowStep",PostStepCode,"")
	 	If $IsObject(objDic){
	 		Set PostStepDesc=objDic.BDDesc
	 	}
	 	
	 	Set PreItems = obj.BWPreItems
	 	
	 	Set SysOperaCode = obj.BWSysOpera
	 	Set SysOperaDesc="",SysOperaID=""
	 	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("SysOperation",SysOperaCode,"")
	 	If $IsObject(objDic){
		 	Set SysOperaID=objDic.%Id()
	 		Set SysOperaDesc=objDic.BDDesc
	 	}
	 	
	 	Set CheckUser = obj.BWCheckUser
	 	Set CheckUserDesc=""
	 	Set:CheckUser="1" CheckUserDesc="是"
	 	Set:CheckUser="0" CheckUserDesc="否"
	 	
	 	Set BeRequest = obj.BWBeRequest
	 	Set BeRequestDesc=""
	 	Set:BeRequest="1" BeRequestDesc="是"
	 	Set:BeRequest="0" BeRequestDesc="否"
	 	
	 	Set BatchOper = obj.BWBatchOper
	 	Set BatchOperDesc=""
	 	Set:BatchOper="1" BatchOperDesc="是"
	 	Set:BatchOper="0" BatchOperDesc="否"
	 	
	 	Set MRCategory = obj.BWMRCategory
	 	Set MRCategoryDesc=""
	 	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("MRCategory",MRCategory,"")
	 	If $IsObject(objDic){
	 		Set MRCategoryDesc=objDic.BDDesc
	 	}
	 	
	 	Set SubFlow = obj.BWSubFlow
	 	Set SubFlowID="",SubFlowDesc=""
	 	Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeCode("WorkSubFlow",SubFlow,"")
	 	If $IsObject(objDic){
		 	Set SubFlowID=objDic.%Id()
	 		Set SubFlowDesc=objDic.BDDesc
	 	}
	 	
	 	Set IsActive=obj.BWIsActive
	 	Set IsActive=+IsActive
	 	Set IsActiveDesc=""
	 	Set:IsActive="1" IsActiveDesc="是"
	 	Set:IsActive="0" IsActiveDesc="否"
	 	
	 	Set Resume = obj.BWResume
	 	
	 	Set arrWorkFlowItems(1,ItemIndex)=$lb(ItemID,ItemDesc,ItemIndex,ItemAlias,WFItemID,TypeID,TypeCode,TypeDesc,PreStepCode,PreStepDesc,PostStepCode,PostStepDesc,PreItems,SysOperaID,SysOperaCode,SysOperaDesc,CheckUser,CheckUserDesc,BeRequest,BeRequestDesc,BatchOper,BatchOperDesc,MRCategory,MRCategoryDesc,SubFlowID,SubFlowDesc,IsActive,IsActiveDesc,Resume)
		Set WFItemList=WFItemList_$lb(ItemID)
	}
	
 	Set xID=""
 	For {
	 	Set xID=$o(^CT.IPMR.BT.WorkItemD(xID))
	 	Quit:xID=""
	 	Continue:$listfind(WFItemList,xID)>0
	 	
	 	Set (ItemID,ItemDesc,ItemIndex,ItemAlias,WFItemID,TypeID,TypeCode,TypeDesc,PreStepCode,PreStepDesc)=""
	 	Set (PostStepCode,PostStepDesc,PreItems,SysOperaID,SysOperaCode,SysOperaDesc)=""
	 	Set (CheckUser,CheckUserDesc,BeRequest,BeRequestDesc,BatchOper,BatchOperDesc,MRCategory,MRCategoryDesc,SubFlowID,SubFlowDesc)=""
	 	Set (IsActive,IsActiveDesc,Resume)=""
	 	
	 	Set objWorkItem=##class(CT.IPMR.BT.WorkItem).GetObjById(xID)
	 	Continue:'$IsObject(objWorkItem)
	 	Set ItemID = objWorkItem.%Id()
	 	Set ItemDesc = objWorkItem.BWDesc
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

}
