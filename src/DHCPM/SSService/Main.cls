/// 名称: DHCPM.SSService.Main
/// 描述: dhcpm.main.csp页面数据加载方法  
///       dhcpm.main.security.csp页面数据加载及保存方法
/// 编写者：dongzt
/// 编写日期: 2015-01-12
Class DHCPM.SSService.Main Extends (%RegisteredObject, DHCPM.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据安全组Id获取有权限的产品信息列表
/// Table：       DHCPM.SS.Security，DHCPM.SS.Products
/// Input：       groupId：安全组Id
/// Return：      返回产品信息，按照<$C1>分隔行，^分隔字段
/// w ##class(DHCPM.SSService.Main).GeProductsByGroup(370)
ClassMethod GeProductsByGroup(groupId As %String) As %String
{
	s ^dongzt("GeProductsByGroup")=groupId
	n (groupId)
	kill ^CacheTemp($zn,$j)
	set ret=""
	quit:'$d(^DHCPM.SS.SecurityI("IndexOfGPM",groupId)) ret
	set productId=$o(^DHCPM.SS.SecurityI("IndexOfGPM",groupId,0))
	while productId'="" {
		set obj=##class(DHCPM.SS.Products).%OpenId(productId)
		if $IsObject(obj){
			do obj.%Close()
			B ;;
			if obj.ProActive=1 {
				;b ;;001
				set menuId=$o(^DHCPM.SS.SecurityI("IndexOfGPM",groupId,productId,0))
				set flag=0
				while (menuId'="")&&(flag=0){
					//w !,"menuId="_menuId
					set obj=##class(DHCPM.SS.Menus).%OpenId(menuId)
				 	if $IsObject(obj){
					 	do obj.%Close()
						set flag=##class(DHCPM.SS.Security).CheckAuthority(groupId,menuId)
						
				 	}
					set menuId=$o(^DHCPM.SS.SecurityI("IndexOfGPM",groupId,productId,menuId))
				}
				;;b ;;
				if flag>0 {
					set obj=##class(DHCPM.SS.Products).%OpenId(+productId)
					if $IsObject(obj){
						do obj.%Close()
						set ShowIndex=+obj.ShowIndex
						set ProName=obj.ProName
						set IconClass=obj.IconClass
						set ProVersion=obj.ProVersion
						set ^CacheTemp($zn,$j,ShowIndex,productId)=productId_"^"_ProName_"^"_IconClass_"^"_ProVersion
						//set sc=obj.XMLExportToString(.xml)
						//w !,xml
					}
				}
			}
		}
		;B ;01
		set productId=$o(^DHCPM.SS.SecurityI("IndexOfGPM",groupId,productId))
		;B ;;;
	}
	
	set ShowIndex=$o(^CacheTemp($zn,$j,""))
	while ShowIndex'="" {
		set productId=$o(^CacheTemp($zn,$j,ShowIndex,""))
		while productId'=""{
			set ret=ret_$g(^CacheTemp($zn,$j,ShowIndex,productId))_"<$C1>"
			set productId=$o(^CacheTemp($zn,$j,ShowIndex,productId))
		}
		set ShowIndex=$o(^CacheTemp($zn,$j,ShowIndex))
	}
	quit ret
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据安全组Id、产品Id、父菜单Id 获取有权限的菜单信息
/// Table：       DHCPM.SS.Security，DHCPM.SS.Menus
/// Input：       groupId：  安全组Id
///               ProductId: 产品Id
///               ParentId:  父菜单Id
/// Return：      返回json格式的菜单信息，
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCPM.SSService.Main).BuildMenuJson(1,0,5)
ClassMethod BuildMenuJson(groupId As %String, ProductId As %String, ParentId As %String) As %String
{
	new (groupId,ProductId,ParentId)
	set json=""
 	quit:'$d(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId)) "[]"
 	set index=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,""))
 	set menuId=""
 	while (index'="") {
	 	set menuId=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,""))
	 	while (menuId'=""){
		 	set obj=##class(DHCPM.SS.Menus).%OpenId(menuId)
		 	if $IsObject(obj){
			 	do obj.%Close()
			 	set MenuCaption=obj.MenuCaption
			 	set LinkUrl=obj.LinkUrl
			 	set IconClass=obj.IconClass
			 	set authority=##class(DHCPM.SS.Security).CheckAuthority(groupId,menuId)
			 	if authority>0{
		 			set:json'="" json=json_","
					set json=json_"{"
					set json=json_"""id"":"""_menuId_""",""text"":"""_MenuCaption_""","
					set json=json_"""iconCls"":"""_IconClass_""","
		    		//set json=json_"""iconCls"":""icon-forumt"","   ;""linkurl"":"""_LinkUrl_""","
		    		set subjson=##class(DHCPM.SSService.Main).BuildMenuJson(groupId,ProductId,menuId)
		    		if (subjson="[]"){
			    		set json=json_"""leaf"":true" //,""cls"":""forum"",""href"":""http://www.google.com"""
			    	}
			    	else{
				    	set json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
				    }
		    		set json=json_"}"
				}
		 	}
			set menuId=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,menuId))
		 }
		 set index=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index))
	 }
	quit "["_json_"]"
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  获取菜单的目标链接
/// Table：       DHCPM.SS.Menus
/// Input：       menuId：  菜单项Id
/// Return：      返回菜单的目标链接
/// w ##class(DHCPM.SSService.Main).GetMenuLinkUrl(4)
ClassMethod GetMenuLinkUrl(menuId) As %String [ SqlProc ]
{
	new (menuId)
	set LinkUrl=""
	set obj=##class(DHCPM.SS.Menus).%OpenId(+menuId)
	if $IsObject(obj){
		set MenuCaption=obj.MenuCaption
		set LinkUrl=obj.LinkUrl		
		set Expression=obj.Expression
		do obj.%Close()
	}
	if (LinkUrl'=""){    
		set LinkUrl=LinkUrl_"?1=1"_Expression
	}
	quit LinkUrl
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据安全组Id构造产品、菜单、菜单操作的树形结构json串
/// Table：       DHCPM.SS.Security，DHCPM.SS.Products，DHCPM.SS.Menus，DHCPM.SS.MenuOperation
/// Input：       groupId：  安全组Id
/// Return：      返回树形结构json串
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCPM.SSService.Main).BuildPMOSecurityJson(1)
ClassMethod BuildPMOSecurityJson(groupId As %String) As %String
{
	new (groupId)
	set json=""
	//ProShowIndex
	set ShowIndex=$o(^DHCPM.SS.ProductsI("ProShowIndex",""))
	while ShowIndex'=""{	
		set proId=$o(^DHCPM.SS.ProductsI("ProShowIndex",ShowIndex,""))	
		while proId'=""{
			set obj=##class(DHCPM.SS.Products).%OpenId(proId)
			if $IsObject(obj){
				do obj.%Close()
				//w !,ShowIndex_"/"_proId
				if obj.ProActive=1 {
					set:json'="" json=json_","
					set objPro=##class(DHCPM.SS.Products).%OpenId(+proId)
					set proJson="{"_"""id"":"""_proId_"P"",""text"":"""_objPro.ProName_""","
					//,""cls"":""P""
					set IconClass=objPro.IconClass
					if IconClass'="" {
						set proJson=proJson_"""iconCls"":"""_IconClass_""","
					}
					else{ //默认的产品图标
						set proJson=proJson_"""iconCls"":""icon-pro"","
					}
					set proJson=proJson_"""expanded"":true,"
					set secFlag=0,childJson="[]"
					set secFlag=..BuildMSecurityJson(groupId,proId,0,.childJson)
					
					if +secFlag>0 {
						set proJson=proJson_"""checked"":true,"
					}
					else{
						set proJson=proJson_"""checked"":false,"
					}
					set proJson=proJson_"""children"":"_childJson_"}"
					set json=json_proJson
				}
			}
			set proId=$o(^DHCPM.SS.ProductsI("ProShowIndex",ShowIndex,proId))
		}
		set ShowIndex=$o(^DHCPM.SS.ProductsI("ProShowIndex",ShowIndex))
	}
	quit "["_json_"]"
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据安全组Id、产品Id、父菜单Id 获取菜单/菜单操作 jason树信息
/// Table：       DHCPM.SS.Security，DHCPM.SS.Menus
/// Input：       groupId：  安全组Id
///               ProductId: 产品Id
///               ParentId:  父菜单Id
/// Output:       childJson: 菜单/菜单操作 jason树信息
/// Return：      返回是否有授权菜单 1:有   0:无
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCPM.SSService.Main).BuildMSecurityJson(1,1,0,.childJson)
ClassMethod BuildMSecurityJson(groupId As %String, ProductId As %String, ParentId As %String, ByRef childJson As %String) As %String
{
	new (groupId,ProductId,ParentId,childJson)
	set json=""
	set retFlag=0
 	quit:'$d(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId)) "[]"
 	set index=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,""))
 	set menuId=""
 	while (index'="") {
	 	//w !,"index="_index
	 	set menuId=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,""))
	 	while (menuId'=""){
		 	//w "   menuId="_menuId
		 	set obj=##class(DHCPM.SS.Menus).%OpenId(menuId)
		 	if $IsObject(obj){
			 	set MenuCaption=obj.MenuCaption
			 	set LinkUrl=obj.LinkUrl
			 	set IconClass=obj.IconClass
			 	set authority=##class(DHCPM.SS.Security).CheckAuthority(groupId,menuId)
		 		set:json'="" json=json_","
				set json=json_"{"
				set json=json_"""id"":"""_menuId_"M"",""text"":"""_MenuCaption_""","
				//""cls"":""M"",
				set json=json_"""expanded"":true,"
				if IconClass'="" {
					set json=json_"""iconCls"":"""_IconClass_""","
				}
				else{ //默认的菜单图标
					set json=json_"""iconCls"":""icon-menu"","
				}
				
				//菜单权限
				set auFlag=##class(DHCPM.SS.Security).CheckAuthority(groupId,menuId)
				
				set subMenujson="[]"
				//子菜单权限
		    	set subMenuFlag=##class(DHCPM.SSService.Main).BuildMSecurityJson(groupId,ProductId,menuId,.subMenujson)
		    	
				if (auFlag>0||subMenuFlag>0){
					set retFlag=1
					set json=json_"""checked"":true,"
				}
				else{
					set json=json_"""checked"":false,"
					}
		    	//DHCMed.SS.SecurityOpera   CheckAuthority
		    	//子菜单 、子菜单权限、 自己的权限 、操作
		    	if (subMenujson'="[]"){                   //有子菜单，继续处理子菜单
		    		//set json=json_"""expanded"":true,"
			    	set json=json_"""children"":"_subMenujson_""
			    	//set json=json_"""leaf"":true,""cls"":""forum"""
			    }
			    else{                                     //无子菜单，处理菜单操作
			    	//菜单操作
		    		set operaFlag=##class(DHCPM.SSService.Main).BuildOSecurityJson(groupId,menuId,.operaJson)
		    		if (operaJson'="[]"){
			    		set json=json_"""children"":"_operaJson_""
			    	}
			    	else{
				    	set json=json_"""leaf"":true"
				    }
				}
		    	set json=json_"}"
	    	}
			set menuId=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,menuId))
		 }
		 set index=$o(^DHCPM.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index))
	 }
	set childJson="["_json_"]"
	quit retFlag
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据安全组Id、菜单Id 获取菜单操作 jason树信息
/// Table：       DHCPM.SS.SecurityOpera，DHCPM.SS.MenuOperation
/// Input：       groupId：  安全组Id
///               menuId:  菜单Id
/// Output:       operaJson: 菜单操作 jason树信息
/// Return：      返回是否有授权菜单操作 1:有   0:无
/// Others:       构建菜单操作树
/// w ##class(DHCMed.SSService.Main).BuildOSecurityJson(1,1,.operaJson)
ClassMethod BuildOSecurityJson(groupId As %String, menuId As %String, ByRef operaJson As %String) As %String
{
	new (groupId,menuId,operaJson)
	set retFlag=0
	set cnt=0
	set operaJson=""
	//DHCPM.SS.MenuOperation   //IndexOfMenuOpera On (MenuDr, OperaCode)
	set:'$d(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",menuId)) operaJson="[]"
	quit:'$d(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",menuId)) retFlag
	set OperaCode=$o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",menuId,""))
	while OperaCode'=""{
		set operaId=$o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",menuId,OperaCode,""))
		//w !,OperaCode_"--"_operaId
		set obj=##class(DHCPM.SS.MenuOperation).%OpenId(+operaId)
		if $IsObject(obj){
			do obj.%Close()
			set operName=obj.OperaName
			set flag=##class(DHCPM.SS.SecurityOpera).CheckAuthority(groupId,operaId)
			set:operaJson'="" operaJson=operaJson_","
			set operaJson=operaJson_"{"
			set operaJson=operaJson_"""id"":"""_operaId_"O"",""text"":"""_operName_""","
			//""cls"":""O"",
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
		set OperaCode=$o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",menuId,OperaCode))
		//set cnt=cnt+1
	}
	set operaJson="["_operaJson_"]"
	quit retFlag
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据安全组Id为菜单和菜单操作授权
/// Table：       DHCPM.SS.Security,DHCPM.SS.SecurityOpera
/// Input：       groupId：  安全组Id
///               sAuthority:  授权信息
/// Return：      返回是否成功标志 1:成功   0:失败
/// Others:       sAuthority格式为/行分隔，^列分隔。
///               每行格式为 IdString^权限(1 or 0)
///               IdString为Id和一个字母的组合，Id为Product则为Id+"P";Menu则为Id+"M";Oprea则为Id+"O";
/// w ##class(DHCPM.SSService.Main).Authorize(1,"")
ClassMethod Authorize(groupId As %String, sAuthority As %String) As %String
{
	new (groupId , sAuthority)
	set ret=0
	set $ZT="Error"
	TStart
	set rows=$l(sAuthority,"/")
	for row=1:1:rows {
		set rowString=$p(sAuthority,"/",row)
		set IdString=$p(rowString,"^",1)
		set Authority=+$p(rowString,"^",2)
		if IdString["P" {
			set productId=+IdString
		}
		elseif (IdString["M"){
			set menuId=+IdString
			set ret=##class(DHCPM.SS.Security).Update(groupId, productId, menuId, Authority)
		}
		elseif (IdString["O"){
			set menuOperaId=+IdString
			set ret=##class(DHCPM.SS.SecurityOpera).Update(groupId, menuOperaId, Authority)
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
/// w flg=##class(DHCPM.SSService.Main).GetMenuOperSecurity(argMenuID,argGroupID)
ClassMethod GetMenuOperSecurity(argMenuID As %String, argGroupID As %String) As %String
{
	New (argMenuID,argGroupID)
	Set return=0
	Quit:(argMenuID="")||(argGroupID="") return
	
	Set $zt="GetMenuOperSecurityErr"
	
	Set return=1
	Write "<SCRIPT language='javascript' type='text/javascript'>"
	Write !,"    var tDHCMedMenuOper=new Array();"
	Set OperaCode=""
	For {
		Set OperaCode=$o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode))
		Quit:OperaCode=""
		Set OperaID=0
		For {
			Set OperaID=$o(^DHCPM.SS.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode,OperaID))
			Quit:OperaID=""
			Set objOpera=##Class(DHCPM.SS.MenuOperation).%OpenId(OperaID)
			If $IsObject(objOpera) {
				Set OperCode=objOpera.OperaCode
				Set OperName=objOpera.OperaName
				Set flag=##Class(DHCPM.SS.SecurityOpera).CheckAuthority(argGroupID,OperaID)
				Write !,"    tDHCMedMenuOper['"_OperCode_"']="_flag_";  //"_OperName
			}
			If objOpera'="" Do objOpera.%Close()
		}
	}
	Write !,"<"_"/SCRIPT>"
	Quit return
	
GetMenuOperSecurityErr
	Quit return
}

/// Creator：     dongzt
/// CreatDate：   2015-01-12
/// Description:  根据安全组Id构造页签的树形结构json串
/// Table：       DHCMed.SS.SecurityPortlets，DHCMed.SS.Portlets
/// Input：       groupId：  安全组Id
/// Return：      返回树形结构json串
/// Others:       此方法内部递归调用，构建页签树
/// portlet 暂时不用 这块先不做了
/// w ##class(DHCMed.SSService.Main).BuildPorSecurityJson(1)
ClassMethod BuildPorSecurityJson(groupId As %String) As %String
{
	new (groupId)
	set json=""

	set PorIndexCode=$o(^DHCMed.SS.PortletsI("IndexCode",""))
	while PorIndexCode'=""{	
		set porId=$o(^DHCMed.SS.PortletsI("IndexCode",PorIndexCode,""))	
		while porId'=""{
			set obj=##class(DHCMed.SS.Portlets).%OpenId(porId)
			if $IsObject(obj){
				do obj.%Close()
				if obj.IsActive=1 {
					set:json'="" json=json_","
					set objPor=##class(DHCMed.SS.Portlets).%OpenId(+porId)
					set porJson="{"_"""id"":"_porId_",""text"":"""_objPor.Description_""","
					set porJson=porJson_"""expanded"":true,"
					set secFlag=0
					set secFlag=##class(DHCMed.SS.SecurityPortlets).CheckAuthority(groupId,porId)
					;set porJson=porJson_"""Authority"":"_secFlag_""
					set porJson=porJson_"""leaf"":true,"
					if +secFlag>0 {
						set porJson=porJson_"""checked"":true"
					}
					else{
						set porJson=porJson_"""checked"":false"
					}
					set json=json_porJson_"}"
				}
			}
			set porId=$o(^DHCMed.SS.PortletsI("IndexCode",PorIndexCode,porId))
		}
		set PorIndexCode=$o(^DHCMed.SS.PortletsI("IndexCode",PorIndexCode))
	}
	quit "["_json_"]"
}

/// Creator：     mxp
/// CreatDate：   2012-11-12
/// Description:  根据安全组Id为页签授权
/// Table：       DHCMed.SS.SecurityPortlets
/// Input：       groupId：  安全组Id
///               sAuthority:  授权信息
/// Return：      返回是否成功标志 1:成功   0:失败
/// Others:       sAuthority格式为/行分隔，^列分隔。
///               每行格式为 IdString^权限(1 or 0)
///               IdString为Id
/// w ##class(DHCMed.SSService.Main).PorAuthorize(1,"")
ClassMethod PorAuthorize(groupId As %String, sAuthority As %String) As %String
{
	new (groupId , sAuthority)
	set ret=0
	set $ZT="PorError"
	TStart
	set rows=$l(sAuthority,"/")
	for row=1:1:rows {
		set rowString=$p(sAuthority,"/",row)
		set IdString=$p(rowString,"^",1)
		set Authority=+$p(rowString,"^",2)
		set porId=+IdString
		set ret=##class(DHCMed.SS.SecurityPortlets).Update(groupId,porId,Authority)
		if ret<0
		{
				TRollback
			}
		quit:ret<0
	}
	TCommit
	set ret=1
	quit ret
PorError
	set ErrorMsg=$ZE
 	TRollback
 	Quit "-2"_ErrorMsg
}

}
