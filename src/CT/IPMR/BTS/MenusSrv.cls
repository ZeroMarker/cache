/// 名称: CT.IPMR.BTS.MenusSrv
/// 描述: 菜单服务类
/// 创建者：liyi
/// 创建日期: 2019-12-11
Class CT.IPMR.BTS.MenusSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询菜单
/// Table：       CT.IPMR.BT.Menus
/// Input：       
/// output:       菜单
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.MenusSrv","QueryMenus")
Query QueryMenus() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,LinkUrl:%String,Expression:%String,ShowOrder:%String,IconClass:%String,ParentMenuID:%String,ParentMenu:%String,_parentId:%String") [ SqlProc ]
{
}

ClassMethod QueryMenusExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xID = ""
 	For {
		Set xID = $o(^CT.IPMR.BT.MenusD(xID))
		Quit:xID=""
		Set objMenus = ##class(CT.IPMR.BT.Menus).GetObjById(xID)
		Continue:'$IsObject(objMenus)
		
		Set Code = objMenus.BMCode
		Set Desc = objMenus.BMDesc
		Set LinkUrl  = objMenus.BMLinkUrl
		Set Expression = objMenus.BMExpression
		Set ShowOrder = objMenus.BMShowOrder
		Set IconClass = objMenus.BMIconClass
		Set ParentMenuID = objMenus.BMParentMenuID
		Set objParent = ##class(CT.IPMR.BT.Menus).GetObjById(ParentMenuID)
		if $isobject(objParent) {
			Set ParentMenuID = objParent.%Id()
			Set ParentMenu = objParent.BMDesc
		}else{
			Set ParentMenuID = ""
			Set ParentMenu = ""
		}
		
		Set Data=$lb(xID,Code,Desc,LinkUrl,Expression,ShowOrder,IconClass,ParentMenuID,ParentMenu,ParentMenuID)
 		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryMenusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMenusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMenusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMenusExecute ]
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询菜单操作
/// Table：       CT.IPMR.SS.MenuOperation
/// Input：       
/// output:       菜单操作
/// D ##class(%ResultSet).RunQuery("CT.IPMR.BTS.MenusSrv","QueryMenuOper",28)
Query QueryMenuOper(aMenuID As %String = "") As %Query(ROWSPEC = "MenuID:%String,OperID:%String,OperaCode:%String,OperaName:%String,ID:%String,_parentId:%String") [ SqlProc ]
{
}

ClassMethod QueryMenuOperExecute(ByRef qHandle As %Binary, aMenuID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	if aMenuID'="" {
	 	Set xOperID = ""
	 	For {
			Set xOperID = $o(^CT.IPMR.BT.MenusD(aMenuID,"MenuOper",xOperID))
			Quit:xOperID=""
			Set objMenuOper = ##class(CT.IPMR.BT.MenuOper).GetObjById(aMenuID_"||"_xOperID)
			Continue:'$IsObject(objMenuOper)
			
			Set OperaCode = objMenuOper.BMOperaCode
			Set OperaName = objMenuOper.BMOperaName
			
			Set Data=$lb(aMenuID,xOperID,OperaCode,OperaName,aMenuID_"-"_xOperID)
	 		Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
 	}else{
	 	Set xMenuID = 0
	 	For {
			Set xMenuID = $o(^CT.IPMR.BT.MenusD(xMenuID))
		 	Quit:xMenuID=""
		 	Set objMenu = ##class(CT.IPMR.BT.Menus).GetObjById(xMenuID)
		 	Continue:'$IsObject(objMenu)
		 	
			Set OutFlag = 0
		 	Set xOperID = ""
		 	For {
				Set xOperID = $o(^CT.IPMR.BT.MenusD(xMenuID,"MenuOper",xOperID))
				Quit:xOperID=""
				Set objMenuOper = ##class(CT.IPMR.BT.MenuOper).GetObjById(xMenuID_"||"_xOperID)
				Continue:'$IsObject(objMenuOper)
				if OutFlag = 0 {
					Set Data=$lb(xMenuID,"","",objMenu.BMDesc_"【菜单】",xMenuID,"")
		 			Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
					Set OutFlag = 1
				}
				Set OperaCode = objMenuOper.BMOperaCode
				Set OperaName = objMenuOper.BMOperaName
				
				Set Data=$lb(xMenuID,xOperID,OperaCode,OperaName,xMenuID_"-"_xOperID,xMenuID)
		 		Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		 
	}
	Quit $$$OK
}

ClassMethod QueryMenuOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMenuOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMenuOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMenuOperExecute ]
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

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  生成菜单
/// Table：       CT.IPMR.BT.Menus
/// Input：       aGroupId ：安全组id
/// Return：      
/// d ##class(CT.IPMR.BTS.MenusSrv).BuildMenuJson(289)
ClassMethod BuildMenuJson(aGroupId As %String) As %String
{
	New (aGroupId)
	
	Set repid=$I(^CacheTemp)
	Set xParentID=""
	For {
		Set xParentID=$o(^CT.IPMR.BT.MenusI("IndexShowOrder",xParentID))
		Quit:xParentID=""
		Set xShowOrder=""
		For {
			Set xShowOrder=$o(^CT.IPMR.BT.MenusI("IndexShowOrder",xParentID,xShowOrder))
			Quit:xShowOrder=""
			
			Set xID=""
			For {
				Set xID=$o(^CT.IPMR.BT.MenusI("IndexShowOrder",xParentID,xShowOrder,xID))
				Quit:xID=""
				set Authority=##class(MA.IPMR.BTS.SecritySrv).CheckAuthority(aGroupId,xID)
				Continue:Authority=0 //校验权限
			 	Set ^CacheTemp(repid,"tmp",xParentID,xShowOrder)=xID
			}
		}
	}
	Set tmp=..WriteJSON(repid,0,1)
	Kill ^CacheTemp(repid)
	Quit ""
}

/// Creator：     liyi
/// CreatDate：   2020-01-06
/// Description:  生成菜单
/// Input：       repid：  临时数据存放的数据节点
///               ParentId:  父菜单Id
///               isHead:是否只输出根级菜单
/// Return：      
/// w ##class(CT.IPMR.BTS.MenusSrv).WriteJSON(1)
ClassMethod WriteJSON(repid, parentID, isHead)
{
	n (repid,parentID,isHead)
	Set cnt=0
	Write "[",!
	Set tParent=""
	For {
		Set tParent=$o(^CacheTemp(repid,"tmp",tParent))
		Quit:tParent=""
		Continue:((parentID'=0)&&(tParent'=parentID))
		Set index=""
		For {
			Set index=$o(^CacheTemp(repid,"tmp",tParent,index))
			Quit:index=""
			Set menuID=$g(^CacheTemp(repid,"tmp",tParent,index))
			Set objMenu=##class(CT.IPMR.BT.Menus).%OpenId(menuID)
			Continue:'$IsObject(objMenu)
			Do objMenu.%Close()
			set Desc=objMenu.BMDesc
			set LinkUrl=objMenu.BMLinkUrl
			set IconClass=objMenu.BMIconClass
			Set parent=objMenu.BMParentMenuID
			Continue:((isHead=1)&&(parent>0)) //只处理最高级别菜单
			
			Set isLeaf=0
			Set:$d(^CacheTemp(repid,"tmp",menuID))=0 isLeaf=1
			Set:isLeaf=1 leaf="""leaf"":true,""children"":[]"
			Set:isLeaf=0 leaf="""expanded"":true,""leaf"":false,""children"":"
			Set LinkUrl = ##class(CT.IPMR.BT.Menus).GetLinkUrl(menuID)
			Write:cnt>0 ","
			Write "{",!
			Write "    "_"""id"":"""_menuID_""",""url"":"""_LinkUrl_""",""text"":"""_Desc_""","_"""iconCls"":"""_IconClass_""","_leaf
			if (isLeaf=0) {
				Set tmp=..WriteJSON(repid,menuID,0)
				Write "",!
			}
			Write !,"}"
			Set cnt=cnt+1
		}
	}
	Write "]",!
	
	Quit 1
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  导入菜单
/// Table：       CT.IPMR.BT.Menus
/// Input：       菜单数据
/// w ##class("CT.IPMR.BTS.MenusSrv").ImportMenus("^ct.ipmr.config^基础配置^^^1^^")
ClassMethod ImportMenus(aInput As %String) As %String
{
	New (aInput)
	Set return = 0
	//Set ^TMP("ImportMenus")=aInput
	Quit:aInput="" return
	
	tstart
	
	// 导入菜单
	Set ParentMenuCode = $p(aInput,"^",8)
	Set ParentMenuID = $o(^CT.IPMR.BT.MenusI("IndexCode"," "_$ZCVT(ParentMenuCode,"U"),0))
	Set $p(aInput,"^",8)=ParentMenuID
	Set ret = ##class(CT.IPMR.BT.Menus).Update(aInput,"^")
	if ret<0 {
		trollback
		Quit return
	}
	Set MenuID = +ret
	
	// 导入菜单操作权限列表
	Set MenuOperLists = $p(aInput,"^",9)
	if MenuOperLists'="" {
		Set ErrFlag = 0
		For ind = 1:1:$length(MenuOperLists,"#") {
			Set MenuOper = $p(MenuOperLists,"#",ind)
			Continue:MenuOper=""
			Quit:ErrFlag=1
			Set Input = ""
			Set Input = Input_"^"_MenuID
			Set Input = Input_"^"_MenuOper
			Set Input = Input_"^"_MenuOper
			Set ret = ##class(CT.IPMR.BT.MenuOper).Update(Input,"^")
			if (+ret)<0 {
				Set ErrFlag = 1
			}
		}
		if ErrFlag=1{
			trollback
			Quit return
		}
	}
	tcommit
	Set return = MenuID
	
	Quit return
}

}
