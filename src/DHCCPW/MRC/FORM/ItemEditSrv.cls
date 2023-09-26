/// 名称: DHCCPW.MRC.FORM.ItemEditSrv
/// 描述: 临床路径表单项目编辑相关服务
/// 编写者：zhufei
/// 编写日期: 2015-06-11
Class DHCCPW.MRC.FORM.ItemEditSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 删除表单项目
/// w ##Class(DHCCPW.MRC.FORM.ItemEditSrv).DeleteFormItem("")
ClassMethod DeleteFormItem(aItemID As %String) As %String
{
	New (aItemID)
	Set return=##class(User.DHCMRCClinPathWaysEpStepItem).DeleteById(aItemID)
	Quit return
}

/// 删除表单项目
/// w ##Class(DHCCPW.MRC.FORM.ItemEditSrv).UpdateIsOptional("")
ClassMethod UpdateIsOptional(aItemID As %String, aValue As %String) As %String
{
	New (aItemID, aValue)
	Set return=##class(User.DHCMRCClinPathWaysEpStepItem).UpdateIsOptional(aItemID, aValue)
	Quit return
}

/// 保存表单项目
/// w ##Class(DHCCPW.MRC.FORM.ItemEditSrv).SaveFormItem("79||1||1^^测试测试^2||2^1^")
ClassMethod SaveFormItem(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set IsOptional=+$p(aInputStr,"^",5)
	Set $p(aInputStr,"^",5)=$s(IsOptional=1:"Y",1:"N")
	
	Set return=##class(User.DHCMRCClinPathWaysEpStepItem).Update(aInputStr)
	Quit return
}

/// Creator      : zhufei
/// CreatDate    : 2015-06-11
/// Description  : 查询表单项目列表
/// Table        : User.DHCMRCClinPathWaysEpStepItem
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.ItemEditSrv","QryItemByStep","16||1||1","27")
Query QryItemByStep(aStepID As %String, aCatID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemDesc:%String,GroupNo:%String,SubCatID:%String,SubCatDesc:%String,CatID:%String,CatDesc:%String,IsOptional:%String")
{
}

ClassMethod QryItemByStepExecute(ByRef qHandle As %Binary, aStepID As %String, aCatID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Kill arrItemList
	
	Set FormID=$p(aStepID,"||",1)
	Set EpSub=$p(aStepID,"||",2)
	Set StepSub=$p(aStepID,"||",3)
	Set xItemSub=0
	For {
		Set xItemSub=$o(^DHCMRC("CPW",FormID,"EP",EpSub,"STEP",StepSub,"ITEM",xItemSub))
		Quit:xItemSub=""
		
		Set ItemID=FormID_"||"_EpSub_"||"_StepSub_"||"_xItemSub
		Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(ItemID)
		Continue:'$IsObject(objItem)
		
		Set (SubCatID,SubCatDesc,CatID,CatDesc)=""
		If $IsObject(objItem.CPWSISubCategory){
			Set SubCatID=objItem.CPWSISubCategory.%Id()
			Set SubCatDesc=objItem.CPWSISubCategory.SISCDesc
			If $IsObject(objItem.CPWSISubCategory.SISCParRef){
				Set CatID=objItem.CPWSISubCategory.SISCParRef.%Id()
				Set CatDesc=objItem.CPWSISubCategory.SISCParRef.SICDesc
			}
		}
		Continue:(aCatID'="")&&(aCatID'=CatID)
		
		Set GroupNo=objItem.CPWSIGroupNo           //项目分组
		Set ItemDesc=objItem.CPWSIDesc             //项目描述
		Set IsOptional=objItem.CPWSIIsMust         //是否可选
		Set IsOptional=$s(IsOptional["Y":"1",1:"0")
		
		Set Data=$lb(ItemID,ItemDesc,GroupNo,SubCatID,SubCatDesc,CatID,CatDesc,IsOptional)
		
		Set arrItemList(CatID,GroupNo,ItemID)=Data
	}
	
	Set xCatID=0
	For {
		Set xCatID=$o(arrItemList(xCatID))
		Quit:xCatID=""
		Set xGroupNo=0
		For {
			Set xGroupNo=$o(arrItemList(xCatID,xGroupNo))
			Quit:xGroupNo=""
			Set xItemID=0
			For {
				Set xItemID=$o(arrItemList(xCatID,xGroupNo,xItemID))
				Quit:xItemID=""
				Set ^CacheTemp(repid,ind)=$g(arrItemList(xCatID,xGroupNo,xItemID))
				Set ind=ind+1
			}
		}
	}
	Kill arrItemList
	
	Quit $$$OK
}

ClassMethod QryItemByStepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemByStepExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryItemByStepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemByStepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				    // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
