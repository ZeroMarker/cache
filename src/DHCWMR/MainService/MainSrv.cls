Class DHCWMR.MainService.MainSrv Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description:  根据安全组Id、产品Id获取有权限的菜单信息
/// Table:        DHCWMR.Main.Menus，DHCWMR.Main.Security
/// Input:        groupId:   安全组Id
///               ProductId: 产品Id
/// Return:       返回json格式的菜单信息，
/// Others:       此方法内部递归调用，构建菜单树
/// Debug: w ##class(DHCWMR.MainService.MainSrv).BuildMenuJson(118,1)
ClassMethod BuildMenuJson(groupId As %String, ProductId As %String) As %String
{
	Set repid=$I(^CacheTemp)
	
	Set parentID=""
	For {
		Set parentID=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,parentID))
		Quit:parentID=""
		Set index=""
		For {
			Set index=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,parentID,index))
			Quit:index=""
			Set menuID=""
			For {
				Set menuID=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,parentID,index,menuID))
				Quit:menuID=""
				set authority=##class(DHCWMR.MainService.MenusSrv).CheckMenusAuthority(groupId,menuID)
				Continue:authority=0 //校验权限
			 	Set ^CacheTemp(repid,"tmp",parentID,index)=menuID
			}
		}
	}
	Set tmp=..WriteJSON(repid,0,1)
	Kill ^CacheTemp(repid)
	Quit 1
}

/// 功能: 向流中写JSON串
/// Input:        repid:   临时数据存放的数据节点
///               ParentId:  父菜单Id
///               isHead:是否只输出根级菜单
/// Return 永远返回1
ClassMethod WriteJSON(repid, parentID, isHead)
{
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
			Set objMenu=##class(DHCWMR.Main.Menus).%OpenId(menuID)
			Continue:'$IsObject(objMenu)
			Do objMenu.%Close()
			set MenuCaption=objMenu.MenuCaption
			set LinkUrl=objMenu.LinkUrl
			set IconClass=objMenu.IconClass
			Set parent=objMenu.ParentMenuDr
			Continue:((isHead=1)&&(parent>0)) //只处理最高级别菜单
			
			Set isLeaf=0
			Set:$d(^CacheTemp(repid,"tmp",menuID))=0 isLeaf=1
			//Set:isLeaf=1 leaf="""leaf"":true"		//20170331 liyi 修复一级菜单没有children节点
			Set:isLeaf=1 leaf="""leaf"":true,""children"":[]"
			Set:isLeaf=0 leaf="""expanded"":true,""leaf"":false,""children"":"
			Write:cnt>0 ","
			Write "{",!
			Write "    "_"""id"":"""_menuID_""",""text"":"""_MenuCaption_""","_"""iconCls"":"""_IconClass_""","_leaf
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

/// Description:  获取菜单的目标链接
/// Table:        DHCWMR.Main.Menus
/// Input:        menuId:  菜单项Id
/// Return:       返回菜单的目标链接
/// Debug: w ##class(DHCWMR.MainService.MainSrv).GetMenuLinkUrl(2)
ClassMethod GetMenuLinkUrl(menuId) As %String [ SqlProc ]
{
	set LinkUrl=""
	set obj=##class(DHCWMR.Main.Menus).%OpenId(+menuId)
	if $IsObject(obj){
		set MenuCaption=obj.MenuCaption
		set LinkUrl=obj.LinkUrl
		set Expression=obj.Expression
		do obj.%Close()
	}
	if (LinkUrl'=""){    //add by wuqk 2010-08-12
		set LinkUrl=LinkUrl_"?1=1"_Expression
	}
	quit LinkUrl
}

/// Description:  根据安全组Id构造产品、菜单、菜单操作的树形结构json串
/// Table:        DHCWMR.Main.Security，DHCWMR.Main.Menus，DHCWMR.Main.MenuOperation
/// Input:        groupId:  安全组Id
/// Return:       返回树形结构json串
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCWMR.MainService.MainSrv).BuildPMOSecurityJson(118)
ClassMethod BuildPMOSecurityJson(groupId As %String) As %String
{
	Set repid=$I(^CacheTemp)
	
	Set ShowIndex=""
	For{
		Set ShowIndex=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",1,0,ShowIndex))
		Quit:ShowIndex=""
		Set menuID=""
		For{
			Set menuID=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",1,0,ShowIndex,menuID))
			Quit:menuID=""
			Set ^CacheTemp(repid,"tmp","MenuShowIndex",ShowIndex)=menuID
		}
	}
	Set tmp=..WritePMOJSON(repid,groupId)
	Kill ^CacheTemp(repid)
	Quit 1
}

/// 功能: 向流中写JSON串
/// Input:       repid:  临时数据存放的数据节点
/// Return 永远返回1
ClassMethod WritePMOJSON(repid, groupId)
{
	Set cnt=0
	Write "[",!
	Set ShowIndex=""
	For {
		Set ShowIndex=$o(^CacheTemp(repid,"tmp","MenuShowIndex",ShowIndex))
		Quit:ShowIndex=""
		Set menuID=$g(^CacheTemp(repid,"tmp","MenuShowIndex",ShowIndex))
		Set objMenu=##class(DHCWMR.Main.Menus).%OpenId(menuID)
		Continue:'$IsObject(objMenu)
		Do objMenu.%Close()
		set MenuCaption=objMenu.MenuCaption
		set LinkUrl=objMenu.LinkUrl
		set IconClass=objMenu.IconClass
		set:IconClass="" IconClass="icon-pro"
		
		//菜单权限
		set auFlag=##class(DHCWMR.MainService.MenusSrv).CheckMenusAuthority(groupId,menuID)
		set secFlag=0,children="[]",childJson="[]"
		Set secFlag=..BuildMSecurityJson(groupId,1,menuID,.childJson)
		if (auFlag>0||secFlag>0){
			set checked="""expanded"":true,""checked"":true,"
		}
		else{
			set checked="""expanded"":true,""checked"":false,"
		}
		set children="""children"":"_childJson
		Write:cnt>0 ","
		Write "{",!
		Write "  "_"""id"":"""_menuID_"M"",""text"":"""_MenuCaption_""","_"""iconCls"":"""_IconClass_""","_checked_children
		Write !,"}"
		Set cnt=cnt+1
	}
	Write "]",!

	Quit 1
}

/// Description:  根据安全组Id、产品Id、父菜单Id 获取菜单/菜单操作 json树信息
/// Table:        DHCWMR.Main.Security，DHCWMR.Main.Menus
/// Input:        groupId:   安全组Id
///               ProductId: 产品Id
///               ParentId:  父菜单Id
/// Output:       childJson: 菜单/菜单操作 jason树信息
/// Return:       返回是否有授权菜单 1:有   0:无
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCWMR.MainService.MainSrv).BuildMSecurityJson(1,1,1,.childJson)
ClassMethod BuildMSecurityJson(groupId As %String, ProductId As %String, ParentId As %String, ByRef childJson As %String) As %String
{
	set json=""
	set retFlag=0
	quit:'$d(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,+ParentId)) "[]"
	set index=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,+ParentId,""))
	set menuId=""
	while (index'="") {
		set menuId=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,""))
		while (menuId'=""){
			set obj=##class(DHCWMR.Main.Menus).%OpenId(menuId)
			if $IsObject(obj){
				set MenuCaption=obj.MenuCaption
				set LinkUrl=obj.LinkUrl
				set IconClass=obj.IconClass
				set:json'="" json=json_","
				set json=json_"{"
				set json=json_"""id"":"""_menuId_"M"",""text"":"""_MenuCaption_""","
				set json=json_"""expanded"":true,"
				if IconClass'="" {
					set json=json_"""iconCls"":"""_IconClass_""","
				}
				else{ //默认的菜单图标
					set json=json_"""iconCls"":""icon-menu"","
				}
				
				//菜单权限
				set auFlag=##class(DHCWMR.MainService.MenusSrv).CheckMenusAuthority(groupId,menuId)
				set subMenujson="[]"
				//子菜单权限
				set subMenuFlag=..BuildMSecurityJson(groupId,ProductId,menuId,.subMenujson)
				
				if (auFlag>0||subMenuFlag>0){
					set retFlag=1
					set json=json_"""checked"":true,"
				}
				else{
					set json=json_"""checked"":false,"
				}
				//子菜单、子菜单权限、自己的权限、操作
				if (subMenujson'="[]"){                   //有子菜单，继续处理子菜单
					set json=json_"""children"":"_subMenujson_""
				}
				else{                                     //无子菜单，处理菜单操作
					//菜单操作
					set operaFlag=..BuildOSecurityJson(groupId,menuId,.operaJson)
					if (operaJson'="[]"){
						set json=json_"""children"":"_operaJson_""
					}
					else{
						set json=json_"""leaf"":true"
					}
				}
				set json=json_"}"
			}
			set menuId=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,menuId))
		}
		set index=$o(^DHCWMR.Main.MenusI("IndexProParentIndex",+ProductId,+ParentId,index))
	}
	set childJson="["_json_"]"
	quit retFlag
}

/// Description:  根据安全组Id、菜单Id 获取菜单操作 json树信息
/// Table:        DHCWMR.Main.SecurityOpera，DHCWMR.Main.MenuOperation
/// Input:        groupId:  安全组Id
///               menuId:  菜单Id
/// Output:       operaJson: 菜单操作 jason树信息
/// Return:       返回是否有授权菜单操作 1:有   0:无
/// Others:       构建菜单操作树
/// w ##class(DHCWMR.MainService.MainSrv).BuildOSecurityJson(118,23,.operaJson)
ClassMethod BuildOSecurityJson(groupId As %String, menuId As %String, ByRef operaJson As %String) As %String
{
	set retFlag=0
	set cnt=0
	set operaJson=""
	set:'$d(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",menuId)) operaJson="[]"
	quit:'$d(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",menuId)) retFlag
	set OperaCode=$o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",menuId,""))
	while OperaCode'=""{
		set operaId=$o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",menuId,OperaCode,""))
		set obj=##class(DHCWMR.Main.MenuOperation).%OpenId(+operaId)
		if $IsObject(obj){
			do obj.%Close()
			set operName=obj.OperaName
			set flag=##class(DHCWMR.MainService.MenusSrv).CheckOperaAuthority(groupId,operaId)
			set:operaJson'="" operaJson=operaJson_","
			set operaJson=operaJson_"{"
			set operaJson=operaJson_"""id"":"""_operaId_"O"",""text"":"""_operName_""","
			//默认的菜单图标
			set operaJson=operaJson_"""iconCls"":""icon-menuopera"",""leaf"":true,"
			if (flag>0){
				set operaJson=operaJson_"""checked"":true"
			}
			else{
				set operaJson=operaJson_"""checked"":false"
			}
			set operaJson=operaJson_"}"
		}
		set OperaCode=$o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",menuId,OperaCode))
		//set cnt=cnt+1
	}
	set operaJson="["_operaJson_"]"
	quit retFlag
}

/// Description:  根据安全组Id为菜单和菜单操作授权
/// Table:        DHCWMR.Main.Security,DHCWMR.Main.SecurityOpera
/// Input:        groupId:  安全组Id
///               sAuthority:  授权信息
/// Return:       返回是否成功标志 1:成功   0:失败
/// Others:       sAuthority格式为/行分隔，^列分隔。
///               每行格式为 IdString^权限(1 or 0)
///               IdString为Id和一个字母的组合，Id为Product则为Id+"P";Menu则为Id+"M";Oprea则为Id+"O";
/// w ##class(DHCWMR.MainService.MenusSrv).Authorize(1,"")
ClassMethod Authorize(groupId As %String, sAuthority As %String) As %String
{
	set ret=0
	set $ZT="Error"
	TStart
	set rows=$l(sAuthority,"/")
	for row=1:1:rows {
		set rowString=$p(sAuthority,"/",row)
		set IdString=$p(rowString,"^",1)
		set Authority=+$p(rowString,"^",2)
		/*if IdString["P" {
			set productId=+IdString
		}*/
		set productId="1"
		if (IdString["M"){
			set menuId=+IdString
			set ret=##class(DHCWMR.MainService.MenusSrv).UpdateSecurity(groupId, productId, menuId, Authority)
		}
		elseif (IdString["O"){
			set menuOperaId=+IdString
			set ret=##class(DHCWMR.MainService.MenusSrv).UpdateSecurityOpera(groupId, menuOperaId, Authority)
		}
		if ret<0{
			TRollback
		}
		quit:ret<0
	}
	TCommit
	set ret=1
	quit ret
Error
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-1"_ErrorMsg
}

/// 取当前menu的操作权限信息
/// w flg=##class(DHCWMR.MainService.MenusSrv).GetMenuOperSecurity(argMenuID,argGroupID)
ClassMethod GetMenuOperSecurity(argMenuID As %String, argGroupID As %String) As %String
{
	Set return=0
	
	//Set $zt="GetMenuOperSecurityErr"
	
	Write "<SCRIPT language='javascript' type='text/javascript'>"
	Set MethodEncrypt=##class(websys.Page).Encrypt($LB("DHCWMR.ClassMethodService.RunClassMethod"))
	Write !,"    var RunClassMethodEncrypt="""_MethodEncrypt_""";"
	
	If (argMenuID'="")&&(argGroupID'="") {
		Set return=1
		Write !,"    var tDHCWMRMenuOper=new Array();"
		Set OperaCode=""
		For {
			Set OperaCode=$o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode))
			Quit:OperaCode=""
			Set OperaID=0
			For {
				Set OperaID=$o(^DHCWMR.Main.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode,OperaID))
				Quit:OperaID=""
				Set objOpera=##Class(DHCWMR.Main.MenuOperation).%OpenId(OperaID)
				If $IsObject(objOpera) {
					Set OperCode=objOpera.OperaCode
					Set OperName=objOpera.OperaName
					Set flag=##class(DHCWMR.MainService.MenusSrv).CheckOperaAuthority(argGroupID,OperaID)
					Write !,"    tDHCWMRMenuOper['"_OperCode_"']="_flag_";  //"_OperName
				}
				If objOpera'="" Do objOpera.%Close()
			}
		}
	}
	Write !,"<"_"/SCRIPT>"
	Quit return
	
GetMenuOperSecurityErr
	Quit return
}

}
