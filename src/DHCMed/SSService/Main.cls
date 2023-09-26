/// 名称: DHCMed.SSService.Main
/// 描述: dhcmed.main.csp页面数据加载方法  
///       dhcmed.security.csp页面数据加载及保存方法
/// 编写者：wuqk
/// 编写日期: 2010-03-30
Class DHCMed.SSService.Main Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     wuqk
/// CreatDate：   2010-03-30
/// Description:  根据安全组Id获取有权限的产品信息列表
/// Table：       DHCMed.SS.Security，DHCMed.SS.Products
/// Input：       groupId：安全组Id
/// Return：      返回产品信息，按照<$C1>分隔行，^分隔字段
/// w ##class(DHCMed.SSService.Main).GeProductsByGroup(12)
ClassMethod GeProductsByGroup(groupId As %String) As %String
{
	n (groupId)
	kill ^CacheTemp($zn,$j)
	set ret=""
	quit:'$d(^DHCMed.SS.SecurityI("IndexOfGPM",groupId)) ret
	set productId=$o(^DHCMed.SS.SecurityI("IndexOfGPM",groupId,0))
	while productId'="" {
		set obj=##class(DHCMed.SS.Products).%OpenId(productId)
		if $IsObject(obj){
			do obj.%Close()
			if obj.ProActive=1 {
				set menuId=$o(^DHCMed.SS.SecurityI("IndexOfGPM",groupId,productId,0))
				set flag=0
				while (menuId'="")&&(flag=0){
					//w !,"menuId="_menuId
					set obj=##class(DHCMed.SS.Menus).%OpenId(menuId)
				 	if $IsObject(obj){
					 	do obj.%Close()
						set flag=##class(DHCMed.SS.Security).CheckAuthority(groupId,menuId)
						//w " flag="_flag  //add by wuqk 2010-08-03
				 	}
					set menuId=$o(^DHCMed.SS.SecurityI("IndexOfGPM",groupId,productId,menuId))
				}
				if flag>0 {
					set obj=##class(DHCMed.SS.Products).%OpenId(+productId)
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
		set productId=$o(^DHCMed.SS.SecurityI("IndexOfGPM",groupId,productId))
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

/*
ClassMethod BuildMenuJson(groupId As %String, ProductId As %String, ParentId As %String) As %String
{
	new (groupId,ProductId,ParentId)
	set json=""
 	quit:'$d(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId)) "[]"
 	set index=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,""))
 	set menuId=""
 	while (index'="") {
	 	set menuId=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,""))
	 	while (menuId'=""){
		 	set obj=##class(DHCMed.SS.Menus).%OpenId(menuId)
		 	if $IsObject(obj){
			 	do obj.%Close()
			 	set MenuCaption=obj.MenuCaption
			 	set LinkUrl=obj.LinkUrl
			 	set IconClass=obj.IconClass
			 	set authority=##class(DHCMed.SS.Security).CheckAuthority(groupId,menuId)
			 	if authority>0{
		 			set:json'="" json=json_","
					set json=json_"{"
					set json=json_"""id"":"""_menuId_""",""text"":"""_MenuCaption_""","
					set json=json_"""iconCls"":"""_IconClass_""","
		    		//set json=json_"""iconCls"":""icon-forumt"","   ;""linkurl"":"""_LinkUrl_""","
		    		set subjson=##class(DHCMed.SSService.Main).BuildMenuJson(groupId,ProductId,menuId)
		    		if (subjson="[]"){
			    		set json=json_"""leaf"":true" //,""cls"":""forum"",""href"":""http://www.google.com"""
			    	}
			    	else{
				    	set json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
				    }
		    		set json=json_"}"
				}
		 	}
			set menuId=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,menuId))
		 }
		 set index=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index))
	 }
	quit "["_json_"]"
}
*/
/// Creator：     wuqk
/// CreatDate：   2010-03-30
/// Description:  根据安全组Id、产品Id、父菜单Id 获取有权限的菜单信息
/// Table：       DHCMed.SS.Security，DHCMed.SS.Menus
/// Input：       groupId：  安全组Id
///               ProductId: 产品Id
///               ParentId:  父菜单Id
/// Return：      返回json格式的菜单信息，
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCMed.SSService.Main).BuildMenuJson(1,1,0)
/// 创建日期：2015-11-09
/// 创建者：李阳
/// 功能：生成Base2.0菜单，此程序是流式输出，不会引起字符串超长问题。
/// 注意：该程序在执行过程中会不断输出JSON字符串，所以返回值始终为1
/// Table：       DHCMed.SS.Security，DHCMed.SS.Menus
/// Input：       groupId：  安全组Id
///               ProductId: 产品Id
///               ParentId:  父菜单Id
/// Return：      1
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCMed.SSService.Main).BuildMenuJson(1,1,0)
ClassMethod BuildMenuJson(groupId As %String, ProductId As %String) As %String
{
	new (groupId,ProductId)
	Set repid=$I(^CacheTemp)
	
	Set parentID=""
	For {
		Set parentID=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,parentID))
		Quit:parentID=""
		Set index=""
		For {
			Set index=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,parentID,index))
			Quit:index=""
			Set menuID=""
			For {
				Set menuID=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,parentID,index,menuID))
				Quit:menuID=""
				set authority=##class(DHCMed.SS.Security).CheckAuthority(groupId,menuID)
				Continue:authority=0 //校验权限
			 	Set ^CacheTemp(repid,"tmp",parentID,index)=menuID
			}
		}
	}
	Set tmp=..WriteJSON(repid,0,1)
	Kill ^CacheTemp(repid)
	Quit 1
}

/// 创建日期：2015-11-09
/// 创建者：李阳
/// 功能：向流中写JSON串
/// Input：       repid：  临时数据存放的数据节点
///               ParentId:  父菜单Id
///               isHead:是否只输出根级菜单
/// Return 永远返回1
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
			Set objMenu=##class(DHCMed.SS.Menus).%OpenId(menuID)
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

/// Creator：     wuqk
/// CreatDate：   2010-03-30
/// Description:  获取菜单的目标链接
/// Table：       DHCMed.SS.Menus
/// Input：       menuId：  菜单项Id
/// Return：      返回菜单的目标链接
/// w ##class(DHCMed.SSService.Main).GetMenuLinkUrl(2)
ClassMethod GetMenuLinkUrl(menuId) As %String [ SqlProc ]
{
	new (menuId)
	set LinkUrl=""
	set obj=##class(DHCMed.SS.Menus).%OpenId(+menuId)
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

/*
/// Creator：     wuqk
/// CreatDate：   2010-04-01
/// Description:  根据安全组Id构造产品、菜单、菜单操作的树形结构json串
/// Table：       DHCMed.SS.Security，DHCMed.SS.Products，DHCMed.SS.Menus，DHCMed.SS.MenuOperation
/// Input：       groupId：  安全组Id
/// Return：      返回树形结构json串
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCMed.SSService.Main).BuildPMOSecurityJson(1)
ClassMethod BuildPMOSecurityJson(groupId As %String) As %String
{
	new (groupId)
	set json=""
	//ProShowIndex
	set ShowIndex=$o(^DHCMed.SS.ProductsI("ProShowIndex",""))
	while ShowIndex'=""{	
		set proId=$o(^DHCMed.SS.ProductsI("ProShowIndex",ShowIndex,""))	
		while proId'=""{
			set obj=##class(DHCMed.SS.Products).%OpenId(proId)
			if $IsObject(obj){
				do obj.%Close()
				//w !,ShowIndex_"/"_proId
				if obj.ProActive=1 {
					set:json'="" json=json_","
					set objPro=##class(DHCMed.SS.Products).%OpenId(+proId)
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
			set proId=$o(^DHCMed.SS.ProductsI("ProShowIndex",ShowIndex,proId))
		}
		set ShowIndex=$o(^DHCMed.SS.ProductsI("ProShowIndex",ShowIndex))
	}
	quit "["_json_"]"
}
*/
/// Creator：     wuqk
/// CreatDate：   2010-04-01
/// Description:  根据安全组Id构造产品、菜单、菜单操作的树形结构json串
/// Table：       DHCMed.SS.Security，DHCMed.SS.Products，DHCMed.SS.Menus，DHCMed.SS.MenuOperation
/// Input：       groupId：  安全组Id
/// Return：      返回树形结构json串
/// Others:       此方法内部递归调用，构建菜单树
/// Creator：     pylian
/// CreatDate：   2016-01-04
/// Description:  fix bug 162832 流式输出，解决字符串超长问题
/// w ##class(DHCMed.SSService.Main).BuildPMOSecurityJson(118)
ClassMethod BuildPMOSecurityJson(groupId As %String) As %String
{
	new (groupId)
	Set repid=$I(^CacheTemp)

	Set ShowIndex=""
	For{
		Set ShowIndex=$o(^DHCMed.SS.ProductsI("ProShowIndex",ShowIndex))
		Quit:ShowIndex=""
		Set proId=""
		For{
			Set proId=$o(^DHCMed.SS.ProductsI("ProShowIndex",ShowIndex,proId))
			Quit:proId=""
			Set ^CacheTemp(repid,"tmp","ProShowIndex",ShowIndex)=proId
		}
	}
	Set tmp=..WritePMOJSON(repid,groupId)
	Kill ^CacheTemp(repid)
	Quit 1
}

/// Creator：     pylian
/// CreatDate：   2016-01-04
/// 功能：向流中写JSON串
/// Input：       repid：  临时数据存放的数据节点
/// Return 永远返回1
ClassMethod WritePMOJSON(repid, groupId)
{
	n (repid,groupId)
	Set cnt=0
	Write "[",!
	Set ShowIndex=""
	For {
		Set ShowIndex=$o(^CacheTemp(repid,"tmp","ProShowIndex",ShowIndex))
		Quit:ShowIndex=""
		Set productId=$g(^CacheTemp(repid,"tmp","ProShowIndex",ShowIndex))
		Set objPro=##class(DHCMed.SS.Products).%OpenId(productId)
		Continue:'$IsObject(objPro)
		Do objPro.%Close()
		// 产品代码ProCode/产品名称 ProName/版本号 ProVersion/图标样式IconClass/显示顺序ShowIndex /是否有效ProActive 
		Set ProCode=objPro.ProCode
		Set ProName=objPro.ProName
		Set ProVersion=objPro.ProVersion
		Set IconClass=objPro.IconClass
		set:IconClass="" IconClass="icon-pro"
			
		Set Index=objPro.ShowIndex
		Set ProActive=objPro.ProActive 
		Continue:ProActive'=1
			
		set secFlag=0,children="[]",childJson="[]"
		Set secFlag=##class(DHCMed.SSService.Main).BuildMSecurityJson(groupId,productId,0,.childJson)
		if +secFlag>0 {
			set checked="""expanded"":true,""checked"":true,"
		}
		else{
			set checked="""expanded"":true,""checked"":false,"
		}
		set children="""children"":"_childJson //每个产品的Jason放在一个串中,减少字符串超长概率
	    ;w !,$l(children)
 		Write:cnt>0 ","
		Write "{",!
		Write "  "_"""id"":"""_productId_"P"",""text"":"""_ProName_""","_"""iconCls"":"""_IconClass_""","_checked_children
		Write !,"}"
		Set cnt=cnt+1
	}
	Write "]",!

	Quit 1
}

/// Creator：     wuqk
/// CreatDate：   2010-03-30
/// Description:  根据安全组Id、产品Id、父菜单Id 获取菜单/菜单操作 jason树信息
/// Table：       DHCMed.SS.Security，DHCMed.SS.Menus
/// Input：       groupId：  安全组Id
///               ProductId: 产品Id
///               ParentId:  父菜单Id
/// Output:       childJson: 菜单/菜单操作 jason树信息
/// Return：      返回是否有授权菜单 1:有   0:无
/// Others:       此方法内部递归调用，构建菜单树
/// w ##class(DHCMed.SSService.Main).BuildMSecurityJson(1,1,0,.childJson)
ClassMethod BuildMSecurityJson(groupId As %String, ProductId As %String, ParentId As %String, ByRef childJson As %String) As %String
{
	new (groupId,ProductId,ParentId,childJson)
	set json=""
	set retFlag=0
 	quit:'$d(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId)) "[]"
 	set index=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,""))
 	set menuId=""
 	while (index'="") {
	 	//w !,"index="_index
	 	set menuId=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,""))
	 	while (menuId'=""){
		 	//w "   menuId="_menuId
		 	set obj=##class(DHCMed.SS.Menus).%OpenId(menuId)
		 	if $IsObject(obj){
			 	set MenuCaption=obj.MenuCaption
			 	set LinkUrl=obj.LinkUrl
			 	set IconClass=obj.IconClass
			 	set authority=##class(DHCMed.SS.Security).CheckAuthority(groupId,menuId)
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
				set auFlag=##class(DHCMed.SS.Security).CheckAuthority(groupId,menuId)
				
				set subMenujson="[]"
				//子菜单权限
		    	set subMenuFlag=##class(DHCMed.SSService.Main).BuildMSecurityJson(groupId,ProductId,menuId,.subMenujson)
		    	
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
		    		set operaFlag=##class(DHCMed.SSService.Main).BuildOSecurityJson(groupId,menuId,.operaJson)
		    		if (operaJson'="[]"){
			    		set json=json_"""children"":"_operaJson_""
			    	}
			    	else{
				    	set json=json_"""leaf"":true"
				    }
				}
		    	set json=json_"}"
	    	}
			set menuId=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,menuId))
		 }
		 set index=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index))
	 }
	set childJson="["_json_"]"
	quit retFlag
}

/// Creator：     wuqk
/// CreatDate：   2010-03-30
/// Description:  根据安全组Id、菜单Id 获取菜单操作 jason树信息
/// Table：       DHCMed.SS.SecurityOpera，DHCMed.SS.MenuOperation
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
	//DHCMed.SS.MenuOperation   //IndexOfMenuOpera On (MenuDr, OperaCode)
	set:'$d(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",menuId)) operaJson="[]"
	quit:'$d(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",menuId)) retFlag
	set OperaCode=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",menuId,""))
	while OperaCode'=""{
		set operaId=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",menuId,OperaCode,""))
		//w !,OperaCode_"--"_operaId
		set obj=##class(DHCMed.SS.MenuOperation).%OpenId(+operaId)
		if $IsObject(obj){
			do obj.%Close()
			set operName=obj.OperaName
			set flag=##class(DHCMed.SS.SecurityOpera).CheckAuthority(groupId,operaId)
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
		set OperaCode=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",menuId,OperaCode))
		//set cnt=cnt+1
	}
	set operaJson="["_operaJson_"]"
	quit retFlag
}

/// Creator：     wuqk
/// CreatDate：   2010-04-01
/// Description:  根据安全组Id为菜单和菜单操作授权
/// Table：       DHCMed.SS.Security,DHCMed.SS.SecurityOpera
/// Input：       groupId：  安全组Id
///               sAuthority:  授权信息
/// Return：      返回是否成功标志 1:成功   0:失败
/// Others:       sAuthority格式为/行分隔，^列分隔。
///               每行格式为 IdString^权限(1 or 0)
///               IdString为Id和一个字母的组合，Id为Product则为Id+"P";Menu则为Id+"M";Oprea则为Id+"O";
/// w ##class(DHCMed.SSService.Main).Authorize(1,"")
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
			set ret=##class(DHCMed.SS.Security).Update(groupId, productId, menuId, Authority)
		}
		elseif (IdString["O"){
			set menuOperaId=+IdString
			set ret=##class(DHCMed.SS.SecurityOpera).Update(groupId, menuOperaId, Authority)
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
/// w ##class(DHCMed.SSService.Main).GetMenuOperSecurity(188,118)
ClassMethod GetMenuOperSecurity(argMenuID As %String, argGroupID As %String) As %String
{
	New (%session,argMenuID,argGroupID)
	Set return=0
	
	Write "<SCRIPT language='javascript' type='text/javascript'>"
	Set MethodEncrypt=##class(websys.Page).Encrypt($LB("DHCMed.ClassMethodService.RunClassMethod"))
	Write !,"    var RunClassMethodEncrypt="""_MethodEncrypt_""";"
	
	If (argMenuID'="")&&(argGroupID'="") {
		If $d(^DHCMed.SS.MenusI("MenuCodeIndex"," "_$zcvt(argMenuID,"U"))) {
			Set argMenuID=$o(^DHCMed.SS.MenusI("MenuCodeIndex"," "_$zcvt(argMenuID,"U"),0))
		}
		Set return=1
		Write !,"    var tDHCMedMenuOper=new Array();"
		Set OperaCode=""
		For {
			Set OperaCode=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode))
			Quit:OperaCode=""
			Set OperaID=0
			For {
				Set OperaID=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode,OperaID))
				Quit:OperaID=""
				Set objOpera=##Class(DHCMed.SS.MenuOperation).%OpenId(OperaID)
				If $IsObject(objOpera) {
					Set OperCode=objOpera.OperaCode
					Set OperName=objOpera.OperaName
					Set flag=##Class(DHCMed.SS.SecurityOpera).CheckAuthority(argGroupID,OperaID)
					Write !,"    tDHCMedMenuOper['"_OperCode_"']="_flag_";  //"_OperName
				}
				If objOpera'="" Do objOpera.%Close()
			}
		}
	}
	Write !,"<"_"/SCRIPT>"
	Quit return
}

/// 取模块角色授权信息
/// w ##class(DHCMed.SSService.Main).GetMenuOperSecurity2("DTHReportList",118)
ClassMethod GetMenuOperSecurity2(argMenuID As %String, argMenuCode As %String, argGroupID As %String) As %String
{
	New (%session,%request,argMenuID,argMenuCode,argGroupID)
	Set return=0
	
	Write "<SCRIPT language='javascript' type='text/javascript'>"
	Set MethodEncrypt=##class(websys.Page).Encrypt($LB("DHCMed.ClassMethodService.RunClassMethod"))
	Write !,"    var RunClassMethodEncrypt="""_MethodEncrypt_""";"
	
	If (argGroupID'="") {
		Set IsMedUseHisMenu=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSMedUseHISMenu")
		If IsMedUseHisMenu=1 {
			Set return=1
			Write !,"    if(tDHCMedMenuOper==undefined){var tDHCMedMenuOper=new Array();}"
			Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
			Set SSGroupID=argGroupID_"!!"_SYSDr
			Set objModule=##class(DHCMA.Util.BT.MdlDef).GetObjByCode(argMenuCode)
			If $IsObject(objModule) {
				Set MdlDefDr=objModule.%Id()
				Set xID=0
				For {
					Set xID=$o(^DHCMA.Util.BT.MdlPowerI("IdxOfMdlGrp",MdlDefDr," "_$zcvt(SSGroupID,"U"),xID))
					Quit:xID=""
					
					Set objMdlPower=##class(DHCMA.Util.BT.MdlPower).GetObjById(xID)
					Continue:'$IsObject(objMdlPower)
					Continue:'$IsObject(objMdlPower.BTMdlRoleDr)
					Set RoleCode=objMdlPower.BTMdlRoleDr.BTCode
					Set RoleDesc=objMdlPower.BTMdlRoleDr.BTDesc
					Continue:RoleCode=""
					Set IsActive=objMdlPower.BTIsActive
					Set IsActive=+IsActive
					Write !,"    if(tDHCMedMenuOper['"_RoleCode_"']==undefined){tDHCMedMenuOper['"_RoleCode_"']="_IsActive_"; } //"_RoleDesc
				}
			}
		} Else {
			If (argMenuID'="") {
				If $d(^DHCMed.SS.MenusI("MenuCodeIndex"," "_$zcvt(argMenuID,"U"))) {
					Set argMenuID=$o(^DHCMed.SS.MenusI("MenuCodeIndex"," "_$zcvt(argMenuID,"U"),0))
				}
				Set return=1
				Write !,"    if(tDHCMedMenuOper==undefined){var tDHCMedMenuOper=new Array();}"
				Set OperaCode=""
				For {
					Set OperaCode=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode))
					Quit:OperaCode=""
					Set OperaID=0
					For {
						Set OperaID=$o(^DHCMed.SS.MenuOperationI("IndexOfMenuOpera",argMenuID,OperaCode,OperaID))
						Quit:OperaID=""
						Set objOpera=##Class(DHCMed.SS.MenuOperation).%OpenId(OperaID)
						If $IsObject(objOpera) {
							Set OperCode=objOpera.OperaCode
							Set OperName=objOpera.OperaName
							Set flag=##Class(DHCMed.SS.SecurityOpera).CheckAuthority(argGroupID,OperaID)
							Write !,"    if(tDHCMedMenuOper['"_OperCode_"']==undefined){tDHCMedMenuOper['"_OperCode_"']="_flag_"; } //"_OperName
						}
						If objOpera'="" Do objOpera.%Close()
					}
				}
			}
		}
	}
	Write !,"<"_"/SCRIPT>"
	Quit return
}

/// Creator：     maxp
/// CreatDate：   2012-11-07
/// Description:  根据安全组Id构造页签的树形结构json串
/// Table：       DHCMed.SS.SecurityPortlets，DHCMed.SS.Portlets
/// Input：       groupId：  安全组Id
/// Return：      返回树形结构json串
/// Others:       此方法内部递归调用，构建页签树
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

Storage Default
{
}

}
