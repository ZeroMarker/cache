/// 名称:	EMR.DOC.BL.RouteUserManage
/// 描述:	用户菜单管理（NEW）
/// 编写者:	zhangzheyi
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RouteUserManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       加载用户信息
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_USER_MANU", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetUserManu(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s userDataJson = ##class(%DynamicObject).%New()
    s outData = ##class(%DynamicObject).%New()
   ; s strRes = ##Class(EMR.DOC.BL.RBACUser).GetUserJson(UserCode,userDataJson)
	;if (strRes = "1")
	;{ 
	;    s argOutMessage.success = ..#OK
	;}
	;elseif(strRes = "-1")
	;{  
	 ;   q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	;}else{
	;	q ..SetOutMessage(argOutMessage,"ERROR","获取用户信息失败",2)	
	;}
	/*拼接菜单信息*/
	s jArrMeun = ##class(%DynamicArray).%New()
    s strRes = ##Class(EMR.DOC.BL.RouteTemplateManage).GetEMRSystemMenuJson(UserCode,0,roleCode,.jArrMeun)
	if (strRes = "1")
	{ 
		;s outData.user = userDataJson
		s outData.list = jArrMeun
		d outData.%ToJSON(argOutData)
	    q ..SetOutMessage(argOutMessage,"OK")
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","该用户没有功能授权",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取导航栏数据
/// Creator:    huhao
/// CreateDate: 20221012
/// Table:		CT.EMR.DOC.DICFUNCTION
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetNavTab(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
	s jArrMeun = ##class(%DynamicArray).%New()
	s strRes = ##class(EMR.DOC.BL.RouteUserManage).getTab(UserCode,0,roleCode,.jArrMeun)
	if (strRes = "1")
	{ 
		d jArrMeun.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod getTab(useCode As %String, parentId As %String, roleCode As %String, ByRef jsonArr As %DynamicArray)
{
	s strRes = ""
	q:(roleCode="") "-1^没有安全组信息"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	;s objUser = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(useCode)
    ;q:(objUser="") "-101"
    ;q:(objUser.RoleID="") "-102"
    s strRoleID = RoleID
	s seq = "",count=""
	s strRes = "-301"
	for {
		s seq = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",parentId,seq))
		q:(seq = "")	
		s rowID = ""		
			for {
				s rowID = $o(^CT.EMR.DOC.DictFunctionI("IdxRowId",parentId,seq,rowID))
				q:(rowID = "")		

				
				s obj = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowID)
		        continue:(obj="") 
		        s strRes = "1"	
		        s jsonMenuDoc  = ##class(%DynamicObject).%New()
		       	
		       	
		        s jsonMenuDoc.name =obj.FuncName
		        s jsonMenuDoc.icon =obj.Icon
		        q:obj.Path=""
		        s jsonMenuDoc.path = obj.Path
		        s jsonMenuDoc.component = obj.Component
		        s jsonMenuDoc.Perms=obj.Perms
		        s jsonMenuDoc.ParentId=obj.ParentID
		        
		        s key =obj.%Id()
				
				//添加操作授权数据
				if (roleCode '="SuperAdmin"){
					/*非超级管理员权限校验*/
					s Permission =##Class(EMR.DOC.BL.RBACOperPermission).GetRoutingOperPermission(strRoleID,rowID)
					continue:(Permission="1")
				}
				s arrItem = ##class(%DynamicArray).%New()
				s result =  ##Class(EMR.DOC.BL.RouteUserManage).getTab(useCode,key,roleCode,.arrItem)
				if (arrItem.%Size() >0) {
					s jsonMenuDoc.routes = arrItem
				}
					
				d jsonArr.%Push(jsonMenuDoc)
			}
	}
	q strRes
}

}
