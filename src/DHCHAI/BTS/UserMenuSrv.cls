/// 名称: DHCHAI.BTS.UserMenuSrv
/// 描述: 相关服务
/// 编写者：chenjb
/// 编写日期: 2021-11-11
Class DHCHAI.BTS.UserMenuSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2021-11-11
/// Description:  根据类型查询
/// Table：       DHCHAI.BT.UserMenu
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.UserMenuSrv","QryUserMenu","ys","809")
Query QryUserMenu(aUserGrpCode As %String, aMenuTypeID As %String) As %Query(ROWSPEC = "MenuID:%String,MenuCode:%String,MenuDesc:%String,MenuUrl:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryUserMenuExecute(ByRef qHandle As %Binary, aUserGrpCode As %String, aMenuTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aUserGrpCode="")||(aMenuTypeID="") $$$OK
	
	Set xObj = ##class(DHCHAI.BT.UserGroup).GetObjByCode(aUserGrpCode)
	Quit:'$IsObject(xObj) $$$OK
	
	Kill ^TMP($zn,$j,"QryUserMenu")
	Set xUserGrpID = xObj.%Id()
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.UserMenuI("IndexBTUserGroupDr",xUserGrpID,xID))
		Quit:xID=""
	
		Set objUserMenu  = ##class(DHCHAI.BT.UserMenu).GetObjById(xID)
		Continue:'$Isobject(objUserMenu)
		
		Set objSysMenu= objUserMenu.BTSysMenuDr
		Set xTypeDr = objSysMenu.BTTypeDr.%Id()
		Continue:xTypeDr'=aMenuTypeID
		//临时global 排序
		Set xidxNo = +objSysMenu.BTIndNo	
		Set xSysMenuID =objSysMenu.%Id()
		Set ^TMP($zn,$j,"QryUserMenu",xidxNo,xSysMenuID)=$lb(xSysMenuID,objSysMenu.BTCode,objSysMenu.BTDesc,objSysMenu.BTUrl,xidxNo)
        //Set IsActDesc=$s(IsActive=1:"是",1:"否")
		
	}
	Set tmpIdxNo = ""
	For {
		Set tmpIdxNo = $o(^TMP($zn,$j,"QryUserMenu",tmpIdxNo))
		Quit:tmpIdxNo=""
		
		Set tmpSysMenuID=""
		For {
			Set tmpSysMenuID =$o(^TMP($zn,$j,"QryUserMenu",tmpIdxNo,tmpSysMenuID))
			Quit:tmpSysMenuID=""
			Set Data = $g(^TMP($zn,$j,"QryUserMenu",tmpIdxNo,tmpSysMenuID))
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	//Set ind=ind+1
	}
	//Set Data=$lb(xID,DicCode,DicDesc,TypeCode,TypeDesc,IndNo,IsActive,IsActDesc)
	//Set ^CacheTemp(repid,ind)=Data
	//Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryUserMenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserMenuExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserMenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserMenuExecute ]
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
/// CreatDate：   2021-11-11
/// Description:  根据类型查询
/// Table：       DHCHAI.BT.UserMenu
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.UserMenuSrv","QrySysMenu")
Query QrySysMenu() As %Query(ROWSPEC = "ID:%String,TypeID:%String,TypeDesc:%String,BTCode:%String,BTDesc:%String,MenuUrl:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QrySysMenuExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.SysMenuD(xID))
		Quit:xID=""
	
		Set objSysMenu  = ##class(DHCHAI.BT.SysMenu).GetObjById(xID)
		Continue:'$Isobject(objSysMenu)
		
		//临时global 排序
		Set xidxNo = +objSysMenu.BTIndNo	
		Set xSysMenuID =objSysMenu.%Id()
		Set Data=$lb(xSysMenuID,objSysMenu.BTTypeDr.%Id(),objSysMenu.BTTypeDr.BTDesc,objSysMenu.BTCode,objSysMenu.BTDesc,objSysMenu.BTUrl,xidxNo)
        Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
	}
	
	Quit $$$OK
}

ClassMethod QrySysMenuClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySysMenuExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySysMenuFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySysMenuExecute ]
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
/// CreatDate：   2021-11-11
/// Description:  根据类型查询
/// Table：       DHCHAI.BT.UserMenu
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.UserMenuSrv","QryUserGroup")
Query QryUserGroup() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTMainDesc:%String,BTMainUrl:%String") [ SqlProc ]
{
}

ClassMethod QryUserGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.UserGroupD(xID))
		Quit:xID=""
	
		Set obj  = ##class(DHCHAI.BT.UserGroup).GetObjById(xID)
		Continue:'$Isobject(obj)
		
		//临时global 排序
		Set Data=$lb(xID,obj.BTCode,obj.BTDesc,obj.BTMainDesc,obj.BTMainUrl)
        Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1		
	}
	
	Quit $$$OK
}

ClassMethod QryUserGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserGroupExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserGroupExecute ]
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
/// CreatDate：   2021-11-11
/// Description:  根据类型查询
/// Table：       DHCHAI.BT.UserMenu
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.UserMenuSrv","QryUserMenuByGroup","1")
Query QryUserMenuByGroup(aUserGrpID As %String) As %Query(ROWSPEC = "ID:%String,MenuID:%String,TypeID:%String,TypeDesc:%String,MenuCode:%String,MenuDesc:%String,MenuUrl:%String,IndNo:%String") [ SqlProc ]
{
}

ClassMethod QryUserMenuByGroupExecute(ByRef qHandle As %Binary, aUserGrpID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aUserGrpID="") $$$OK
	
	Set xUserGrpID = aUserGrpID
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.UserMenuI("IndexBTUserGroupDr",xUserGrpID,xID))
		Quit:xID=""
	
		Set objUserMenu  = ##class(DHCHAI.BT.UserMenu).GetObjById(xID)
		Continue:'$Isobject(objUserMenu)
		
		Set objSysMenu= objUserMenu.BTSysMenuDr
		Set xTypeDr = objSysMenu.BTTypeDr.%Id()
		Set xTypeDesc =objSysMenu.BTTypeDr.BTDesc
		//临时global 排序
		Set xidxNo = +objSysMenu.BTIndNo	
		Set xSysMenuID =objSysMenu.%Id()
		Set Data=$lb(xID,xSysMenuID,xTypeDr,xTypeDesc,objSysMenu.BTCode,objSysMenu.BTDesc,objSysMenu.BTUrl,xidxNo)
        Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	Set tmpIdxNo = ""
	For {
		Set tmpIdxNo = $o(^TMP($zn,$j,"QryUserMenu",tmpIdxNo))
		Quit:tmpIdxNo=""
		
		Set tmpSysMenuID=""
		For {
			Set tmpSysMenuID =$o(^TMP($zn,$j,"QryUserMenu",tmpIdxNo,tmpSysMenuID))
			Quit:tmpSysMenuID=""
			Set Data = $g(^TMP($zn,$j,"QryUserMenu",tmpIdxNo,tmpSysMenuID))
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryUserMenuByGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUserMenuByGroupExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryUserMenuByGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUserMenuByGroupExecute ]
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

}
