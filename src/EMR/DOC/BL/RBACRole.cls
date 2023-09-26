/// 名称:	EMR.DOC.BL.RBACRole
/// 描述:	通用文档管理模块 Document(Doc) 角色逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RBACRole Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取角色列表
/// Creator:    duan
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {'params':{'action':'GET_RBAC_ROLES",'args':{}},'product':'GlobalEMR'}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRoleValues(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s name = argInJson.params.name
    s code = argInJson.params.code
    s current = argInJson.params.current
    s pageSize = argInJson.params.pageSize 
    s:current="" current=..#DECURRENT
    s:pageSize="" pageSize=..#DEPAGESIZE
    s strRes = ##Class(EMR.DOC.BL.RBACRole).GetRoleJson(name,code,current,pageSize,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       新增角色
/// Creator:    duan
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {'params':{'action':'ADD_RBAC_ROLE",'args':{"Name":"角色名称","Code":"角色编码","Desc":"角色描述","Type":"角色类型id"}},'product':'GlobalEMR'}
/// OutPut:     argOutMessage 返回消息 成功<string> 角色id 失败 <string> -1
///            	argOutData    返回数据
ClassMethod AddRBACRole(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objRole = ##class(EMR.DOC.DTO.RBACRole).%New()
	s objRole.RoleName = argInJson.params.name
	s objRole.RoleCode= argInJson.params.safeGroupId
	s objRole.RoleDesc = argInJson.params.desc
	s objRole.RoleId=argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.RBACRole).AddRole(objRole,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-1")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","检查必填项",2)
	}elseif(strRes="-2")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","角色编码code已存在，不能重复添加",2)
	}elseif(strRes="-3")
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","无效的角色类型",2)
	}else
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","添加角色出错",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除角色
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {"params":{"action":"DELETE_RBAC_ROLE","args":{"ID":""}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息 
///            	argOutData    返回数据 返回1，失败：返回-1，0：已有用户关联角色不允许删除
ClassMethod DeleteRBACRole(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRoleID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.RBACRole).DeleteRBACRoleJson(strRoleID)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}elseif(strRes="-1")
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","无效的角色ID",2)
	}elseif(strRes="-2")
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","角色有关联用户，不允许删除",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除角色失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取角色列表信息
/// Creator:    duan
/// CreateDate: 2021-03-08
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACRole).GetRoleJson(argOutData)
ClassMethod GetRoleJson(argName As %String, argCode As %String, argCurrent As %String, argPageSize As %String, ByRef argOutData As %GlobalBinaryStream)
{
	s strRes = "-1"
	s jsonArr = ##class(%DynamicArray).%New()
	s resultObj = ##class(%DynamicObject).%New()
	if ((argName'="")&(argCode'="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACRole:SelectRoleByCodeAndName")
		d result.Execute(argName,argCode)
	}elseif((argName="")&(argCode="")){
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACRole:SelectRoleAll")
		d result.Execute()
	}else{
		s result = ##class(%ResultSet).%New("EMR.DOC.BL.RBACRole:SelectRoleByCodeOrName")
		d result.Execute(argName,argCode)
	}
	q:(result = "") strRes
	s count = 0
	s step = 0
	s startIndex = (argCurrent-1)*argPageSize+1
	s endIndex = startIndex+argPageSize-1
	While result.Next() 
	{
		s jsonRole  = ##class(%DynamicObject).%New()
	 	s jsonRole.id = result.GetDataByName("ID")
	 	s jsonRole.roleName = result.GetDataByName("RoleName")
	 	s jsonRole.roleCode = result.GetDataByName("RoleCode")
	 	s jsonRole.roleDesc = result.GetDataByName("RoleDesc")
	 	s jsonRole.roleId = result.GetDataByName("RoleId")
	 	s IsExist = result.GetDataByName("IsExist")
	 	continue:(IsExist = "0")
	 	s count = count+1
		continue:((count<startIndex)||(count>endIndex))	
	 	s step = step + 1
        d jsonArr.%Push(jsonRole)
	}
	s resultObj.list = jsonArr
	s resultObj.current = argCurrent
	s resultObj.pageSize = argPageSize
	s resultObj.total = step
	d resultObj.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取所有角色数据
/// Creator:    duan
/// CreateDate: 2021-04-06
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.RBACRole","SelectRoleAll")
Query SelectRoleAll() As %SQLQuery
{
	select a.ID,a.RoleCode,a.RoleDesc,a.RoleName,a.IsExist,a.RoleId from CF_EMR_DOC.RBACRole AS a
}

/// Desc:       通过角色名称和角色Code共同过滤角色数据
/// Creator:    duan
/// CreateDate: 2021-04-06
Query SelectRoleByCodeAndName(aName As %String = "", aCode As %String = "") As %SQLQuery
{
	select a.ID,a.RoleCode,a.RoleDesc,a.RoleName,a.IsExist,a.RoleId from CF_EMR_DOC.RBACRole AS a where a.RoleCode like "%"_:aCode_"%" and a.RoleName like "%"_:aName_"%"
}

/// Desc:       通过角色Code或者角色名称过滤角色数据
/// Creator:    duan
/// CreateDate: 2021-04-06
Query SelectRoleByCodeOrName(aName As %String = "", aCode As %String = "") As %SQLQuery
{
	select a.ID,a.RoleCode,a.RoleDesc,a.RoleName,a.IsExist,a.RoleId from CF_EMR_DOC.RBACRole AS a where a.RoleCode like "%"_:aCode_"%" or a.RoleName like "%"_:aName_"%"
}

/// Desc:       添加角色
/// Creator:    duan
/// CreateDate: 2021-03-08
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACRole).AddRole("超级管理员","SuperManager","超级管理员",1,argOutData)
ClassMethod AddRole(objRole As EMR.DOC.DTO.RBACRole, ByRef argOutData As %GlobalBinaryStream)
{
	s strRes = "-1"
	q:((objRole.RoleCode="")||(objRole.RoleName="")) strRes
	s strRes= "-2"
	s isHas = $o(^CF.EMR.DOC.RBACRoleI("IdxRoleCode"," "_$zcvt(objRole.RoleCode,"U"),""))
	if (isHas'="")
	{
		s roleObj=##class(CF.EMR.DOC.RBACRole).%OpenId(isHas)
		q:roleObj.IsExist=1 "-2"
		s roleObj.RoleCode=objRole.RoleCode
		s roleObj.RoleName=objRole.RoleName
		s roleObj.RoleDesc=objRole.RoleDesc
		s roleObj.RoleId=objRole.RoleId
		s roleObj.IsExist="1"
		s sc=roleObj.%Save()
		if ($$$ISOK(sc))
		{
			q "1"
		}

	}
	s roleObject = ##class(CF.EMR.DOC.RBACRole).%New()
	s strRes = "-3"
	s strRes = "-4"
	s roleObject.RoleCode = objRole.RoleCode
	s roleObject.RoleName = objRole.RoleName
	s roleObject.RoleDesc = objRole.RoleDesc
	s roleObject.RoleId = objRole.RoleId
	s roleObject.IsExist = "1"
	s sc = roleObject.%Save()
	if ('$$$ISOK(sc))
	{
		q strRes
	}
	s strRes = roleObject.%Id()
	d argOutData.Write(strRes)
	q 1
}

/// Desc:       删除角色
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      ATemplate 模板对象
/// output:     模板ID
/// Debug:      w ##Class(EMR.DOC.BL.RBACRole).DeleteRBACRoleJson(2)
ClassMethod DeleteRBACRoleJson(aID As %String) As %String
{
	s strRes ="-1"
	s intCount = 0
	TSTART
	s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(aID)
	if (objRole ="")
	{
		TROLLBACK
		q strRes
	}
	s strRes = "-3"
	&sql(DELETE  FROM CF_EMR_DOC.RBACOperPermission WHERE RoleID = :aID )
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q strRes
	}
	&sql(DELETE  FROM CF_EMR_DOC.RBACDataPermission WHERE RoleID = :aID )
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q strRes
	}
	if '(objRole.%DeleteId(aID))
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	s strRes ="1"
	q strRes
}

/// Desc:       删除角色
/// Creator:    zhangzheyi
/// CreateDate: 2021-11-16
/// Input:      argArray  命令参数 {"params":{"action":"DELETE_ROUTE_ROLE","args":{"ID":""}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息 
///            	argOutData    返回数据 返回1，失败：返回-1，0：已有用户关联角色不允许删除
ClassMethod DeleteRouteRole(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRoleID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.RBACRole).DeleteRouteRoleJson(strRoleID)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}elseif(strRes="-1")
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","无效的角色ID",2)
	}elseif(strRes="-2")
	{
	    q ..SetOutMessage(argOutMessage,"ERROR","角色有关联用户，不允许删除",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除角色失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除角色
/// Creator:    zhangzheyi
/// CreateDate: 2021-11-16
/// Input:      ATemplate 模板对象
/// output:     模板ID
/// Debug:      w ##Class(EMR.DOC.BL.RBACRole).DeleteRBACRoleJson(2)
ClassMethod DeleteRouteRoleJson(aID As %String) As %String
{
	s strRes ="-1"
	s intCount = 0
	TSTART
	s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(aID)
	if (objRole ="")
	{
		TROLLBACK
		q strRes
	}
	s strRes = "-3"
	&sql(DELETE  FROM CF_EMR_DOC.RBACOperPermission WHERE RoleID = :aID )
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q strRes
	}
	&sql(DELETE  FROM CF_EMR_DOC.RBACDataPermission WHERE RoleID = :aID )
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q strRes
	}

	s objRole.IsExist = "0"
	s sc = objRole.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}	
	TCOMMIT
	s strRes ="1"
	q strRes
}

/// Desc:       获取角色信息表，过滤掉状态为不可用的
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_RBAC_ROLELIST", "params":{"userCode":"YS01" },"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRolelist(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s jArryMeun = ##class(%DynamicArray).%New()
	s strRes = ##Class(EMR.DOC.BL.RBACRole).GetRolelistJson(.jArryMeun)
	if (strRes = "1")
	{ 
	    d jArryMeun.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取角色信息表，过滤掉状态为不可用的
/// Creator:    zhangzheyi
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      
///             
ClassMethod GetRolelistJson(ByRef jsonArr As %DynamicArray) As %String
{
	s strRes = "1"
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.RBACRoleD(rowID))
		q:(rowID = "")		
		s obj = ##Class(CF.EMR.DOC.RBACRole).%OpenId(rowID)
		continue:((obj="") || (obj.IsExist = "0"))			
		s jsonItem  = ##class(%DynamicObject).%New()
		s jsonItem.id = obj.%Id()	
       	s jsonItem.roleName = obj.RoleName
		d jsonArr.%Push(jsonItem)
		
	}
	q strRes
}

/// Desc:       根据编码获取角色
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:    	成功 roleID,失败 -1^失败原因
/// Debug:     w ##Class(EMR.DOC.BL.RBACRole).GetRoleByCode("PersonalTemplate")  
ClassMethod GetRoleByCode(aRoleCode As %String) As %String
{
	s strRes = "1"
	s rowID = $o(^CF.EMR.DOC.RBACRoleI("IdxRoleCode"," "_$ZCVT(aRoleCode,"U"),""))	
	q:(rowID="") "-1^未找到可用的角色ID"	
	s obj = ##Class(CF.EMR.DOC.RBACRole).%OpenId(rowID)
	q:((obj="") || (obj.IsExist = "0") ) "-1^未找到可用的角色ID"
	q rowID
}

}
