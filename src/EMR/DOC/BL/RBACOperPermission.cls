/// 名称:	EMR.DOC.BL.RBACOperPermission
/// 描述:	通用文档管理模块 Document(Doc) 操作授权逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-14
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.RBACOperPermission Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据角色获取关联的功能权限
/// Creator:    yejian
/// CreateDate: 2021-3-9
/// Input:      argArray  命令参数 {"params":{"action":"GET_RBAC_ROLEOPERPERMISSION","args":{"RoleID":"1"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRBACRoleOperPermission(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s RoleID = argInJson.params.roleId
    s strRes = ##Class(EMR.DOC.BL.RBACOperPermission).GetRBACRoleOperPermissionJson(RoleID,.argOutData)
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

/// Desc:       批量更新角色功能权限
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// Input:      argArray  命令参数 {"params":{"action":"UP_RBAC_ROLEOPERPERMISSION","args":{"RoleID":"1","OperPIDS":["1","2"]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息 成功<string> 1 失败 <string> -1
///            	argOutData    返回数据
ClassMethod UpRBACRoleOperPermission(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s RoleID = argInJson.params.safeGroupId
	s OperPIDS = argInJson.params.operationIDS
	if (argInJson.params.%GetTypeOf("operationIDS")'="array")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","operationIDS参数必须是数组",2)
	}
	/// OutPut:     成功 1 失败：-200 角色ID 不能为空 -101 授权失败
    s strRes = ##Class(EMR.DOC.BL.RBACOperPermission).UpRBACRoleOperPermissionJson(RoleID,OperPIDS,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","角色ID 不能为空",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","授权失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据角色获取已经关联项目标识
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.RBACOperPermission).GetRBACRoleOperPermissionJson("1",.argOutData)
ClassMethod GetRBACRoleOperPermissionJson(strRoleID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s roleObj = ##class(CF.EMR.DOC.RBACRole).%OpenId(strRoleID)
	q:(roleObj="") "-1"
	s jArrRProduc = ##class(%DynamicArray).%New()
	if (roleObj.RoleCode = "SuperAdmin"){
		//超级管理员
		s result =  ##class(%ResultSet).%New("EMR.DOC.BL.RBACOperPermission:GetFuncIDAll")
		d result.Execute()
		q:result=""
		While result.Next() 
		{
	   		s funcId = result.GetDataByName("ID")
	   		d jArrRProduc.%Push(funcId)
		}
	}else{
		s strRowID = ""
		for {
			s strRowID = $o(^CF.EMR.DOC.RBACOperPermissionI("IdxRole",strRoleID,strRowID))
			q:(strRowID = "")			
			s objOperPer = ##Class(CF.EMR.DOC.RBACOperPermission).%OpenId(strRowID)
        	continue:(objOperPer="")
        	s funcCode = objOperPer.DicFunc.FuncCode
    		s count = 0
    		&SQL(select count(*) into :count from CT_EMR_DOC.DictFunction where ParentCode = :funcCode)
    		continue:count>0
    		s funcID = objOperPer.DicFunc.%Id()
        	d jArrRProduc.%Push(funcID)
		}
	}
	
	d jArrRProduc.%ToJSON(argOutData)

	q strRes
}

/// Desc:       获取所有的功能数据ID
/// Creator:    duan
/// CreateDate: 2021-04-07
/// debug d ##class(%ResultSet).RunQuery("EMR.DOC.BL.RBACOperPermission","GetFuncIDAll")
Query GetFuncIDAll() As %SQLQuery
{
	select ID from CT_EMR_DOC.DictFunction
}

/// Desc:       批量更新角色关联项目标识
/// Creator:    yejian
/// CreateDate: 2021-03-08
/// OutPut:     成功 1 失败：-200 角色ID 不能为空 -101 授权失败 -301 角色数据不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			s strJson = "[""1"",""2""]"
///   			set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
///             w ##class(EMR.DOC.BL.RBACOperPermission).UpRBACRoleOperPermissionJson("1",objJson,argOutData)
ClassMethod UpRBACRoleOperPermissionJson(strRoleID As %String, jOperPIDS As %DynamicArray, ByRef argOutData As %GlobalBinaryStream)
{
	s strRes = "-101"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(strRoleID)
	q:((RoleID = "")) "-200"
	TSTART
	&sql(DELETE  FROM CF_EMR_DOC.RBACOperPermission WHERE RoleID = :RoleID )
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q "-101"
	}
	s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(RoleID)
	if (objRole = "") 
	{
		TROLLBACK
		q "-301"
	}
	s strMark = "1"
	s intOperSize = jOperPIDS.%Size()
	for i=0:1:(intOperSize-1)
	{
		s jItem = jOperPIDS.%Get(i)
		s strDicFID = jItem
		if (strDicFID = "") 
		{
			s strMark="-1"
			q
		}
		s objOperPer = ##class(CF.EMR.DOC.RBACOperPermission).%New()
		
		s objDicFunc = ##class(CT.EMR.DOC.DictFunction).%OpenId(strDicFID)
		if (objDicFunc = "") 
		{
			s strMark="-1"
			q
		}
		s objOperPer.RoleID = objRole
		s objOperPer.DicFunc = objDicFunc
		s sc = objOperPer.%Save()
		if ('$$$ISOK(sc))
		{
			s strMark="-1"
			q
		}
	}
	if (strMark ="-1")
	{
		TROLLBACK
	}
	else
	{
		TCOMMIT
		s strRes = "1"
	}
	q strRes
}

/// Desc:       获取操作授权
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aProduct 项目标识
///             aRoleID 角色ID
///             DicFuncID 功能字典表(CT.EMR.DOC.DictFunction)的rowID
/// OutPut:     Permission 	返回数据授权（1：只读/2：可操作）
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(1,1,1)
ClassMethod GetOperPermission(aRoleID As %String, DicFuncID As %String) As %String
{
	//判断是否有授权数据
	s Permission = "1"
	q:aRoleID="" Permission
	s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(aRoleID)
	q:(objRole="") Permission
	q:(objRole.RoleCode="SuperAdmin") "2"
	s strOperRowID = $o(^CF.EMR.DOC.RBACOperPermissionI("IdxRoleFunction",aRoleID,DicFuncID,""))
	q:(strOperRowID ="") Permission
	//如果有授权，则可操作
	s Permission = "2"
	q Permission
}

/// Desc:       获取操作授权
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aProduct 项目标识
///             aRoleID 角色ID
///             DicFuncID 功能字典表(CT.EMR.DOC.DictFunction)的rowID
/// OutPut:     Permission 	返回数据授权（1：只读/2：可操作）
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(1,1,1)
ClassMethod GetRoutingOperPermission(aRoleID As %String, DicFuncID As %String) As %String
{
	//判断是否有授权数据
	s Permission = "1"
	q:aRoleID="" Permission
	s objRole = ##class(CF.EMR.DOC.RBACRole).%OpenId(aRoleID)
	q:(objRole="") Permission
	q:(objRole.RoleCode="SuperAdmin") "2"
	s strOperRowID = $o(^CF.EMR.DOC.RBACOperPermissionI("IdxRoleFunction",aRoleID,DicFuncID,""))
	q:(strOperRowID ="") Permission
	//如果有授权，则可操作
	s Permission = "2"
	q Permission
}

}
