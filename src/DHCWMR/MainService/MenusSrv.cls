Class DHCWMR.MainService.MenusSrv Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description:  根据ID取菜单信息
/// Table:        DHCWMR.Main.Menus
/// Input:        ID: DHCWMR.Main.Menus.ID
///               separete: 指定的分隔符
/// Return:       返回obj.ToString()
/// w ##class(DHCWMR.MainService.MenusSrv).GetObjMenusById(1)
ClassMethod GetObjMenusById(id As %String) As DHCWMR.Main.Menus
{
	set return=""
	quit:id="" return
	quit:'##class(DHCWMR.Main.Menus).%ExistsId(+id) return
	set obj=##Class(DHCWMR.Main.Menus).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Description:  更新Menus
/// Table:        DHCWMR.Main.Menus
/// Input:        各属性列表 ^分隔
/// Return:       成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
ClassMethod UpdateMenus(InStr) As %String
{
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCWMR.Main.Menus).%New()
	} 
	else {
		set obj=##class(DHCWMR.Main.Menus).%OpenId(ID)
	}
	set obj.MenuCode=$p(InStr,"^",2)
	set obj.MenuCaption=$p(InStr,"^",3)
	set obj.LinkUrl=$p(InStr,"^",4)
	set obj.Expression=$p(InStr,"^",5)
	set obj.ProductDr=+$p(InStr,"^",6)
	set obj.ShowIndex=$p(InStr,"^",7)
	set obj.IconClass=$p(InStr,"^",8)
	set obj.ParentMenuDr=+$p(InStr,"^",9)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
		d $system.OBJ.DisplayError(sc)
		set id=-1
	}
	else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Description:  删除Menu
/// Table:        DHCWMR.Main.Menus
/// Input:        MenuId
/// Return:       成功：返回0，失败：返回<0的代码
ClassMethod DeleteMenusById(Id)
{
	set sc = ##class(DHCWMR.Main.Menus).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
		d $system.OBJ.DisplayError(sc)
		set ret=-1
	}
	else {
		set ret=0
	}
	quit ret
}

/// Description:  更新MenuOperation
/// Table:        DHCWMR.Main.MenuOperation
/// Input:        各属性列表 ^分隔
/// Return:       成功：返回id，失败：返回<0的代码
/// 1:Rowid 2:MenuDr 3:OperaCode 4:OperaName
ClassMethod UpdateMenuOperation(InStr) As %String
{
	set id=0
	set ID=$p(InStr,"^",1)
	if ID="" {
		set obj=##class(DHCWMR.Main.MenuOperation).%New()
	}
	else {
		set obj=##class(DHCWMR.Main.MenuOperation).%OpenId(ID)
	}
	set obj.MenuDr=+$p(InStr,"^",2)
	set obj.OperaCode=$p(InStr,"^",3)
	set obj.OperaName=$p(InStr,"^",4)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
		d $system.OBJ.DisplayError(sc)
		set id=-1
	}
	else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Description:  删除MenuOperation
/// Table:        DHCWMR.Main.MenuOperation
/// Input:        MenuOperationId
/// Return:       成功：返回0，失败：返回<0的代码
ClassMethod DeleteMenuOperationById(Id)
{
	set sc = ##class(DHCWMR.Main.MenuOperation).%DeleteId(+Id)
	if $system.Status.IsError(sc) {            //检查删除是否成功
		d $system.OBJ.DisplayError(sc)
		set ret=-1
	}
	else {
		set ret=0
	}
	quit ret
}

/// Debug: w ##class(DHCWMR.MainService.MenusSrv).ImportMenus("","^")
ClassMethod ImportMenus(aInputStr As %String, aSeparate As %String) As %String
{
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	//序号	代码	名称	连接	表达式	图标	父菜单	产品代码	显示顺序
	Set MenuCode=$p(aInputStr,aSeparate,2)
	Set MenuCaption=$p(aInputStr,aSeparate,3)
	Set LinkUrl=$p(aInputStr,aSeparate,4)
	Set Expression=$p(aInputStr,aSeparate,5)
	Set IconClass=$p(aInputStr,aSeparate,6)
	Set ParentMenuCode=$p(aInputStr,aSeparate,7)
	Set ProductDr=$p(aInputStr,aSeparate,8)
	Set ShowIndex=$p(aInputStr,aSeparate,9)
	Set strOperList=$p(aInputStr,aSeparate,10)
	
	/*Set ProductDr=""
	If ProductCode'="" {
		Set ProductCode=$ZConvert(ProductCode,"T")
		Set ProductDr=$o(^DHCMed.SS.ProductsI("ProCodeIndex"," "_ProductCode,0))
	}
	Quit:ProductDr="" return*/
	
	Set ParentMenuDr=""
	If ParentMenuCode'="" {
		Set ParentMenuCode=$ZConvert(ParentMenuCode,"T")
		Set MenuID=0
		For {
			Set MenuID=$o(^DHCWMR.Main.MenusI("MenuCodeIndex"," "_ParentMenuCode,MenuID))
			Quit:MenuID=""
			Set objMenu=..GetObjMenusById(MenuID)
			Continue:'$IsObject(objMenu)
			Continue:objMenu.ProductDr'=ProductDr
			Set ParentMenuDr=MenuID
		}
	}
	
	Set MenuRowID=""
	Set MenuID=0
	For {
		Set MenuID=$o(^DHCWMR.Main.MenusI("MenuCodeIndex"," "_$ZConvert(MenuCode,"T"),MenuID))
		Quit:MenuID=""
		Set objMenu=..GetObjMenusById(MenuID)
		Continue:'$IsObject(objMenu)
		Continue:objMenu.ProductDr'=ProductDr
		Set MenuRowID=MenuID
	}
	
	Set InputStr=MenuRowID_"^"_MenuCode_"^"_MenuCaption_"^"_LinkUrl_"^"_Expression_"^"_ProductDr_"^"_ShowIndex_"^"_IconClass_"^"_ParentMenuDr
	Set return=..UpdateMenus(InputStr)
	
	//add by wuqk 增加导入操作的处理
	if (+return>0)&(strOperList'="") {
		set len=$l(strOperList,",")
		for i=1:1:len {
			set oper=$p(strOperList,",",i)
			set operCode=$p(oper,"/",1)
			set operDesc=$p(oper,"/",2)
			continue:operCode=""
			continue:operDesc=""
			set oid=..UpdateMenuOperation("^"_return_"^"_operCode_"^"_operDesc)
		}
	}
	
	Quit return
}

/// Description:  更新Security
/// Table:        DHCWMR.Main.Security
/// Input:        groupId    安全组id
///               productId  产品Id
///               menuId     菜单Id
///               authority  是否有权限访问 1：有权限，0：无权限
/// Return:       成功：返回id，失败：返回<0的代码
ClassMethod UpdateSecurity(groupId, productId, menuId, authority) As %String
{
	set id=""
	quit:(groupId="")||(menuId="") return
	
	if $d(^DHCWMR.Main.SecurityI("IndexOfMenu",+groupId,+menuId)) {
		set id=$o(^DHCWMR.Main.SecurityI("IndexOfMenu",+groupId,+menuId,""))
	} else {
		if $d(^DHCWMR.Main.SecurityI("IndexOfGPM",+groupId,+productId,+menuId)) {
			set id=$o(^DHCWMR.Main.SecurityI("IndexOfGPM",+groupId,+productId,+menuId,""))
		}
	}
	
	if id'="" {
		set obj = ##class(DHCWMR.Main.Security).%OpenId(id)
	}else{
		set obj = ##class(DHCWMR.Main.Security).%New()
	}
	set obj.SSGroupDr=+groupId
	set obj.ProductDr=+productId
	set obj.MenuDr=+menuId
	set obj.Authority=$s(+authority=0:0,1:1)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
		d $system.OBJ.DisplayError(sc)
		set id=-1
	}else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Description:  更新SecurityOpera
/// Table:        DHCWMR.Main.SecurityOpera
/// Input:        groupId     安全组id
///               menuOperaId 操作Id
///               authority  是否有权限访问 1：有权限，0：无权限
/// Return:       成功：返回id，失败：返回<0的代码
ClassMethod UpdateSecurityOpera(groupId, menuOperaId, authority) As %String
{
	set id=""
	if $d(^DHCWMR.Main.SecurityOperaI("IndexOfGOpera",groupId, menuOperaId)) {
		set id = $o(^DHCWMR.Main.SecurityOperaI("IndexOfGOpera",groupId, menuOperaId,""))
		set obj = ##class(DHCWMR.Main.SecurityOpera).%OpenId(id)
	}
	else{
		set obj = ##class(DHCWMR.Main.SecurityOpera).%New()
	}
	set obj.SSGroupDr=+groupId
	set obj.MenuOperaDr=+menuOperaId
	set obj.Authority=$s(+authority=0:0,1:1)
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
		d $system.OBJ.DisplayError(sc)
		set id=-1
	}
	else{
		set id=obj.%Id()
	}
	do obj.%Close()
	quit id
}

/// Description:  检查安全组对指定菜单是否有权限访问
/// Table:        DHCWMR.Main.Security
/// Input:        groupId  安全组Id
///               menuId   菜单Id
/// Return:       1：有权限，0：无权限
ClassMethod CheckMenusAuthority(groupId As %String, menuId As %String)
{
	set authority=0
	if $d(^DHCWMR.Main.SecurityI("IndexOfMenu",groupId,menuId)){
		set securityId=$o(^DHCWMR.Main.SecurityI("IndexOfMenu",groupId,menuId,""))
		set obj=##class(DHCWMR.Main.Security).%OpenId(securityId)
		set authority=obj.Authority
		do obj.%Close()
	}
	quit +authority
}

/// Description:  检查安全组对指定菜单操作是否有权限访问
/// Table:        DHCWMR.Main.SecurityOpera
/// Input:        groupId  安全组Id
///               menuOperaId   菜单操作Id
/// Return:       1：有权限，0：无权限
ClassMethod CheckOperaAuthority(groupId As %String, menuOperaId As %String)
{
	set authority=0
	if $d(^DHCWMR.Main.SecurityOperaI("IndexOfGOpera",groupId,menuOperaId)){
		set securityId=$o(^DHCWMR.Main.SecurityOperaI("IndexOfGOpera",groupId,menuOperaId,""))
		set obj=##class(DHCWMR.Main.SecurityOpera).%OpenId(securityId)
		set authority=obj.Authority
		do obj.%Close()
	}
	quit +authority
}

/// Description:  通过菜单代码、菜单名称、父菜单Id、产品Id查询菜单信息
/// Table:        DHCWMR.Main.Menus
/// Input:        MenuCode:菜单代码 MenuCaption:菜单名称 ParentMenuId:父菜单Id ProId:产品Id
/// Debug: d ##class(%ResultSet).RunQuery("DHCWMR.MainService.MenusSrv","FindMenuInfo","","","","1")
Query FindMenuInfo(MenuCode As %String, MenuCaption As %String, ParentMenuId As %String, ProId As %String) As %Query(ROWSPEC = "rowid:%String,MenuCode:%String,MenuCaption:%String,LinkUrl:%String,Expression:%String,ProductDr:%String,ShowIndex:%String,IconClass:%String,ParentMenuDr:%String,ParentMenu:%String")
{
}

ClassMethod FindMenuInfoExecute(ByRef qHandle As %Binary, MenuCode As %String, MenuCaption As %String, ParentMenuId As %String, ProId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s rowID = ""
	f {
		s rowID = $o(^DHCWMR.Main.MenusD(rowID))
		q:(rowID="")
		s objMenus = ##class(DHCWMR.Main.Menus).%OpenId(rowID)
		continue:((MenuCode'="")&(objMenus.MenuCode'[MenuCode))
		continue:((MenuCaption'="")&(objMenus.MenuCaption'[MenuCaption))
		continue:((ParentMenuId'="")&(objMenus.ParentMenuDr'=ParentMenuId))
		continue:((ProId'="")&(objMenus.ProductDr'=ProId))
		s menuCode = objMenus.MenuCode
		s menuCaption = objMenus.MenuCaption
		s linkUrl = objMenus.LinkUrl
		s expression = objMenus.Expression
		s productDr = objMenus.ProductDr
		s showIndex = objMenus.ShowIndex
		s iconClass = objMenus.IconClass
		s parentMenuDr = objMenus.ParentMenuDr
		s parentMenu = ""
		s objParentMenu = ..GetObjMenusById(parentMenuDr)
		s:($IsObject(objParentMenu)) parentMenu=objParentMenu.MenuCaption
		d objMenus.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,menuCode,menuCaption,linkUrl,expression,productDr,showIndex,iconClass,parentMenuDr,parentMenu)
		s ind = ind + 1
	}
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

/// Description:  通过菜单名称查询菜单信息
/// Table:        DHCWMR.Main.Menus
/// Input:        cMenu: 菜单名称
/// Debug: d ##class(%ResultSet).RunQuery("DHCWMR.MainService.MenusSrv","FindMenuInfoFromCaption","1")
Query FindMenuInfoFromCaption(ProductID As %String, ProductDesc As %String = "") As %Query(ROWSPEC = "rowid:%String,MenuCode:%String,MenuCaption:%String")
{
}

ClassMethod FindMenuInfoFromCaptionExecute(ByRef qHandle As %Binary, ProductID As %String, ProductDesc As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s rowID = ""
	f {
		s rowID = $o(^DHCWMR.Main.MenusD(rowID))
		q:(rowID="")
		s objMenus = ##class(DHCWMR.Main.Menus).%OpenId(rowID)
		s productDr = objMenus.ProductDr
		continue:((ProductID'="")&(ProductID'=productDr))
		continue:((ProductDesc'="")&(objMenus.MenuCaption'[ProductDesc))
		s menuCode = objMenus.MenuCode
		s menuCaption = objMenus.MenuCaption
		d objMenus.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,menuCode,menuCaption)
		s ind = ind + 1
	}
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

/// Description:  通过菜单指针、操作代码、操作名称查询菜单操作
/// Table:        DHCWMR.Main.MenuOperation
/// Input:        MenuDr:菜单指针 OperaCode:操作代码 OperaName:操作名称
/// Debug: d ##class(%ResultSet).RunQuery("DHCWMR.MainService.MenusSrv","FindMenuOperation","25","","")
Query FindMenuOperation(MenuDr As %String, OperaCode As %String, OperaName As %String) As %Query(ROWSPEC = "rowid:%String,OperaCode:%String,OperaName:%String")
{
}

ClassMethod FindMenuOperationExecute(ByRef qHandle As %Binary, MenuDr As %String, OperaCode As %String, OperaName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s rowID = ""
	f {
		s rowID = $o(^DHCWMR.Main.MenuOperationD(rowID))
		q:(rowID="")
		s objOpera = ##class(DHCWMR.Main.MenuOperation).%OpenId(rowID)
		continue:((MenuDr="")||(MenuDr'=objOpera.MenuDr))
		s operaCode = objOpera.OperaCode
		s operaName = objOpera.OperaName
		d objOpera.%Close()
		s ^CacheTemp(repid,ind) = $lb(rowID,operaCode,operaName)
		s ind = ind + 1
	}
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

/// Description:  根据菜单表ID获取菜单信息
/// Table:        DHCWMR.Main.Menus
/// Input:        MenuId:菜单信息
/// Return:       返回菜单信息，按照^分隔字段
/// Debug: w ##Class(DHCWMR.MainService.MenusSrv).GetMenusInfoFromId(1)
ClassMethod GetMenusInfoFromId(MenuId As %String) As %String
{
	set return="",PReturn="",MReturn=""
	quit:MenuId="" return
	
	quit:'$d(^DHCMed.SS.MenusD(MenuId)) return
	set obj=##class(DHCWMR.Main.Menus).%OpenId(MenuId)
	
	//set:obj.ProductDr'="" PReturn=##Class(DHCMed.SS.Products).GetObjById(obj.ProductDr)
	set:obj.ParentMenuDr'="" MReturn=..GetObjMenusById(obj.ParentMenuDr)
	
	set return=MenuId_"^"
	set return=return_obj.MenuCode_"^"
	set return=return_obj.MenuCaption_"^"
	set return=return_obj.LinkUrl_"^"
	set return=return_obj.Expression_"^"
	set return=return_obj.ProductDr_"^"
	set return=return_obj.ShowIndex_"^"
	set return=return_obj.IconClass_"^"
	set return=return_obj.ParentMenuDr_"^"
	//set:PReturn'="" return=return_PReturn.ProName_"^"
	//set:PReturn="" return=return_"^"
	set:MReturn'="" return=return_MReturn.MenuCaption
	set:MReturn="" return=return_"^"
	do obj.%Close()
	quit return
}

/// Description:  根据菜单Id删除菜单信息和对应的菜单操作
/// Table:        DHCWMR.Main.Menus,DHCWMR.Main.MenuOperation
/// Input:        MenuId  菜单Id            
/// Return:       返回是否成功标志 1:成功   0:失败
/// Debug: w ##class(DHCWMR.MainService.MenusSrv).DelInfoFromMenuId(1)
ClassMethod DelInfoFromMenuId(MenuId As %String) As %String
{
	set ret=0,OpeCode=0,rowid=""
	set $ZT="Error"
	TStart
	set ret=..DeleteMenusById(MenuId)
	if ret<0 TRollback
	
	set OpeCode=$tr($o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",MenuId," "_OpeCode))," ","")
	while OpeCode'=""
	{
		set rowid=$o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",MenuId," "_OpeCode,""))
		set OpeCode=$tr($o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",MenuId," "_OpeCode))," ","")
		quit:rowid=""
		set ret=..DeleteMenuOperationById(rowid)
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

}
