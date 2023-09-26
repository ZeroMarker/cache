/// 描述:		项目管理菜单维护
/// 创建人:		dongzt
/// 创建时间:	2015-01-11 
Class DHCPM.SSService.MenusMain Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  通过菜单代码、菜单Id,产品Id查询菜单信息
/// Table：       DHCPM.SS.Products，DHCPM.SS.Menus，DHCPM.SS.MenuOperation
/// Input：       MenuCode：菜单代码 parentMenuId：父菜单Id ProId:产品Id MenuCaption：菜单名称
/// modify by wuqk 2010-04-26 增加按照菜单名称查询，将菜单Id条件修改为父菜单Id
/// d ##class(%ResultSet).RunQuery("DHCMed.SSService.MenusSrv","FindMenuInfo","","","")
Query FindMenuInfo(MenuCode As %String, parentMenuId As %String, ProId As %String, MenuCaption As %String) As %Query(ROWSPEC = "rowid:%String,MenuCode:%String,MenuCaption:%String,LinkUrl:%String,Expression:%String,ProductDr:%String,ShowIndex:%String,IconClass:%String,ParentMenuDr:%String,Product:%String,ParentMenu:%String")
{
}

ClassMethod FindMenuInfoExecute(ByRef qHandle As %Binary, MenuCode As %String, parentMenuId As %String, ProId, MenuCaption As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid="",PReturn="",MReturn=""
	;q:(MenuCode="")&(MenuId="") $$$OK
 
	f  s rowid=$o(^DHCPM.SS.MenusD(rowid)) q:rowid=""  d
	.s obj=##class(DHCPM.SS.Menus).%OpenId(rowid)
	.q:((MenuCode'="")&(obj.MenuCode'[MenuCode))
	.q:((ProId'="")&(obj.ProductDr'=ProId))
	.q:((parentMenuId'="")&(obj.ParentMenuDr'=parentMenuId))
	.q:((MenuCaption'="")&(obj.MenuCaption'[MenuCaption))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.MenuCode
	.s $li(data,3)=obj.MenuCaption
	.s $li(data,4)=obj.LinkUrl
	.s $li(data,5)=obj.Expression
	.s $li(data,6)=obj.ProductDr
	.s $li(data,7)=obj.ShowIndex
	.s $li(data,8)=obj.IconClass
	.s $li(data,9)=obj.ParentMenuDr
	.s $li(data,10)=""
	.s PReturn=##Class(DHCPM.SS.Products).GetObjById(obj.ProductDr)
	.s:PReturn'="" $li(data,10)=PReturn.ProName
	.s $li(data,11)=""
	.s MReturn=##Class(DHCPM.SS.Menus).GetObjById(obj.ParentMenuDr)
	.s:MReturn'="" $li(data,11)=MReturn.MenuCaption
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod FindMenuInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindMenuInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuInfoExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  通过菜单名称查询菜单Rowid,名称
/// Table：       DHCPM.SS.Menus
/// Input：       cMenuName:菜单名称
/// d ##class(%ResultSet).RunQuery("DHCPM.SSService.MenusMain","QueryMenuInfo","1")
Query QueryMenuInfo(cMenuName As %String) As %Query(ROWSPEC = "rowid:%String,MenuCaption:%String")
{
}

ClassMethod QueryMenuInfoExecute(ByRef qHandle As %Binary, cMenuName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	f  s rowid=$o(^DHCPM.SS.MenusD(rowid)) q:rowid=""  d
	.s obj=##class(DHCPM.SS.Menus).%OpenId(rowid)
	.q:((cMenuName'="")&(obj.MenuCaption'[cMenuName))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.MenuCaption
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod QueryMenuInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMenuInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMenuInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMenuInfoExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  通过菜单指针、操作代码、操作名称查询菜单操作
/// Table：       DHCPM.SS.MenuOperation
/// Input：       MenuDr：菜单指针 OperaCode：操作代码 OperaName：操作名称
/// d ##class(%ResultSet).RunQuery("DHCPM.SSService.MenusMain","FindMenuOperation","1","","")
Query FindMenuOperation(MenuDr As %String, OperaCode As %String, OperaName As %String) As %Query(ROWSPEC = "rowid:%String,OperaCode:%String,OperaName:%String")
{
}

ClassMethod FindMenuOperationExecute(ByRef qHandle As %Binary, MenuDr As %String, OperaCode As %String, OperaName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCPM.SS.MenuOperationD(rowid)) q:rowid=""  d
	.s obj=##class(DHCPM.SS.MenuOperation).%OpenId(rowid)
	.s $li(data,1)=rowid
	.q:((MenuDr="")||(MenuDr'=obj.MenuDr))
	.s $li(data,2)=obj.OperaCode
	.s $li(data,3)=obj.OperaName
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod FindMenuOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindMenuOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuOperationExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  通过菜单名称查询菜单信息
/// Table：       DHCPM.SS.Menus
/// Input：       cMenu：菜单名称
/// d ##class(%ResultSet).RunQuery("DHCPM.SSService.MenusMain","FindMenuInfoFromCaption","1")
Query FindMenuInfoFromCaption(ProductID As %String) As %Query(ROWSPEC = "rowid:%String,MenuCode:%String,MenuCaption:%String")
{
}

ClassMethod FindMenuInfoFromCaptionExecute(ByRef qHandle As %Binary, ProductID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	f  s rowid=$o(^DHCPM.SS.MenusD(rowid)) q:rowid=""  d
	.s obj=##class(DHCPM.SS.Menus).%OpenId(rowid)
	.s ProductDr=obj.ProductDr
	.q:((ProductID'="")&(ProductID'=ProductDr))
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.MenuCode
	.s $li(data,3)=obj.MenuCaption
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    do obj.%Close()
	q $$$OK
}

ClassMethod FindMenuInfoFromCaptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMenuInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindMenuInfoFromCaptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMenuInfoExecute ]
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

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  根据菜单表ID获取菜单信息
/// Table：       DHCPM.SS.Menus
/// Input：       MenuId:菜单信息
/// Return：      返回菜单信息，按照^分隔字段
/// w ##Class(DHCPM.SSService.MenusMain).GetMenusInfoFromId(1)
ClassMethod GetMenusInfoFromId(MenuId As %String) As %String
{
	new (MenuId)
	
	set return="",PReturn="",MReturn=""
	quit:MenuId="" return
	
	quit:'$d(^DHCPM.SS.MenusD(MenuId)) return
	set obj=##class(DHCPM.SS.Menus).%OpenId(MenuId)
	
	set:obj.ProductDr'="" PReturn=##Class(DHCPM.SS.Products).GetObjById(obj.ProductDr)
	set:obj.ParentMenuDr'="" MReturn=##Class(DHCPM.SS.Menus).GetObjById(obj.ParentMenuDr)
	
	set return=MenuId_"^"
	set return=return_obj.MenuCode_"^"
	set return=return_obj.MenuCaption_"^"
	set return=return_obj.LinkUrl_"^"
	set return=return_obj.Expression_"^"
	set return=return_obj.ProductDr_"^"
	set return=return_obj.ShowIndex_"^"
	set return=return_obj.IconClass_"^"
	set return=return_obj.ParentMenuDr_"^"
	set:PReturn'="" return=return_PReturn.ProName_"^"
	set:PReturn="" return=return_"^"
	set:MReturn'="" return=return_MReturn.MenuCaption
	set:MReturn="" return=return_"^"
	do obj.%Close()
	quit return
}

/// Creator：     dongzt
/// CreatDate：   2015-01-11
/// Description:  根据菜单Id删除菜单信息和对应的菜单操作
/// Table：       DHCPM.SS.Menus,DHCPM.SS.MenuOperation
/// Input：       MenuId  菜单Id
///              
/// Return：      返回是否成功标志 1:成功   0:失败
/// w ##class(DHCPM.SSService.MenusMain).DelInfoFromMenuId(1)
ClassMethod DelInfoFromMenuId(MenuId As %String) As %String
{
	new (MenuId)
	set ret=0,OpeCode=0,rowid=""
	set $ZT="Error"
	TStart
	set ret=##class(DHCPM.SS.Menus).DeleteById(MenuId)
	if ret<0 TRollback
	
	set OpeCode=$tr($o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",MenuId," "_OpeCode))," ","")
	while OpeCode'=""
	{
		set rowid=$o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",MenuId," "_OpeCode,""))
		set OpeCode=$tr($o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",MenuId," "_OpeCode))," ","")
		quit:rowid=""
		set ret=##class(DHCPM.SS.MenuOperation).DeleteById(rowid)
		if ret<0 TRollback
	}
	TCommit
	set ret=1
	quit ret
Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// w ##Class(DHCPM.SSService.MenusMain).ImportMenus("","^")
/// Modify by wuqk 
/// aInputStr增加 操作列表,半角逗号分隔,操作的代码和描述以/分隔
ClassMethod ImportMenus(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//序号	代码	名称	连接	表达式	图标	父菜单	产品代码	显示顺序
	Set MenuCode=$p(aInputStr,aSeparate,2)
	Set MenuCaption=$p(aInputStr,aSeparate,3)
	Set LinkUrl=$p(aInputStr,aSeparate,4)
	Set Expression=$p(aInputStr,aSeparate,5)
	Set IconClass=$p(aInputStr,aSeparate,6)
	Set ParentMenuCode=$p(aInputStr,aSeparate,7)
	Set ProductCode=$p(aInputStr,aSeparate,8)
	Set ShowIndex=$p(aInputStr,aSeparate,9)
	Set strOperList=$p(aInputStr,aSeparate,10)
	
	Set ProductDr=""
	If ProductCode'="" {
		Set ProductCode=$ZConvert(ProductCode,"T")
		Set ProductDr=$o(^DHCPM.SS.ProductsI("ProCodeIndex"," "_ProductCode,0))
	}
	Quit:ProductDr="" return
	
	Set ParentMenuDr=""
	If ParentMenuCode'="" {
		Set ParentMenuCode=$ZConvert(ParentMenuCode,"T")
		Set MenuID=0
		For {
			Set MenuID=$o(^DHCPM.SS.MenusI("MenuCodeIndex"," "_ParentMenuCode,MenuID))
			Quit:MenuID=""
			Set objMenu=##class(DHCPM.SS.Menus).GetObjById(MenuID)
			Continue:'$IsObject(objMenu)
			Continue:objMenu.ProductDr'=ProductDr
			Set ParentMenuDr=MenuID
		}
	}
	
	Set MenuRowID=""
	Set MenuID=0
	For {
		Set MenuID=$o(^DHCPM.SS.MenusI("MenuCodeIndex"," "_$ZConvert(MenuCode,"T"),MenuID))
		Quit:MenuID=""
		Set objMenu=##class(DHCPM.SS.Menus).GetObjById(MenuID)
		Continue:'$IsObject(objMenu)
		Continue:objMenu.ProductDr'=ProductDr
		Set MenuRowID=MenuID
	}
	
	Set InputStr=MenuRowID_"^"_MenuCode_"^"_MenuCaption_"^"_LinkUrl_"^"_Expression_"^"_ProductDr_"^"_ShowIndex_"^"_IconClass_"^"_ParentMenuDr
	Set return=##Class(DHCPM.SS.Menus).Update(InputStr)
	
	//add by wuqk 增加导入操作的处理
	if (+return>0)&(strOperList'="") {    
		set len=$l(strOperList,",")
		for i=1:1:len {
			set oper=$p(strOperList,",",i)
			set operCode=$p(oper,"/",1)
			set operDesc=$p(oper,"/",2)
			continue:operCode=""
			continue:operDesc=""
			set oid=##class(DHCPM.SS.MenuOperation).Update("^"_return_"^"_operCode_"^"_operDesc)
		}
	}
	
	Quit return
}

/// w ##Class(DHCPM.SSService.MenusMain).DeleteMenus("EPD")
ClassMethod DeleteMenus(aProductCode As %String) As %String
{
	New (aProductCode)
	Set return=-1
	Quit:aProductCode="" return
	
	Set $ZT="DeleteMenusErr"
	
	Set ProductID=$o(^DHCPM.SS.ProductsI("ProCodeIndex"," "_aProductCode,0))
	Quit:ProductID="" return
	
	Set ParMenu=""
	For {
		Set ParMenu=$o(^DHCPM.SS.MenusI("IndexProParentIndex",ProductID,ParMenu))
		Quit:ParMenu=""
		Set ShowIndex=""
		For {
			Set ShowIndex=$o(^DHCPM.SS.MenusI("IndexProParentIndex",ProductID,ParMenu,ShowIndex))
			Quit:ShowIndex=""
			Set MenuID=0
			For {
				Set MenuID=$o(^DHCPM.SS.MenusI("IndexProParentIndex",ProductID,ParMenu,ShowIndex,MenuID))
				Quit:MenuID=""
				Set flg=##Class(DHCPM.SS.Menus).DeleteById(MenuID)
			}
		}
	}
	
	Set return=1
	Quit return
	
DeleteMenusErr
	Write "Error:"_$ZError,!
	Quit -999
}

}
