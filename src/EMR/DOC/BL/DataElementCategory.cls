/// 名称:	EMR.DOC.BL.DataElementCategory
/// 描述:	通用文档管理模块 Document(Doc) 术语集数据元目录业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DataElementCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据用户术语集目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数{"action":"GET_GLOSSARY_TREE","params":{"userCode":"YS01","getDataType":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataElementTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s GetDataType = argInJson.params.getDataType
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.DataElementCategory).GetDataElementTreeJson(UserCode,GetDataType,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户code必传,检查参数userCode",2)
	}	
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据类型必须为ALL或CG",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未获取到用户",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户未关联角色",2)
	}
	
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","角色未关联项目标识",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取模板操作相关数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_DATAELEMENT_OPERATION","params":{"parentCode":"MENU_GLOSSARY_DATAELMENT","userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataElementOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ParentCode = "MENU_GLOSSARY_DATAELMENT"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.DataElementCategory).GetDataElementOperationJson(ParentCode,UserCode,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       添加目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"ADD_DATAELEMENT_CATEGORY","params":{"parentId":"0","internalID":"WS363.17-2019","name":"WS363.17-2011卫生管理","description":"卫生信息数据元目录第17部分"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddDataElementCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.DataElementCategory).%New()
	s argDTO.InternalID = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID =argInJson.params.parentId
    s strRes = ##Class(EMR.DOC.BL.DataElementCategory).AddDataElementCategoryJson(argDTO)
    //失败:-100 添加失败, -200 目录ID不能为空，-201 内部标识符不能为空， -300 未查到目录，-400 内部标识符已存在
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内部标识符不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","根据目录ID未查到目录",2)	
	}
	elseif (strRes = "-400")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","内部标识符已存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_DATAELEMENT_CATEGORY","params":{"id":"19","parentId":"0","internalID":"WS363.17-2019","name":"WS363.17-2011卫生管理","description":"卫生信息数据元目录第18部分"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpDataElementCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.DataElementCategory).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.InternalID = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID =..GetIDByKey(argInJson.params.parentId)
    s strRes = ##Class(EMR.DOC.BL.DataElementCategory).UpDataElementCategoryJson(argDTO)
    //失败:-100 更新失败, -200 ID不能为空，-201 内部标识符不能为空， -300 未查到目录，-400 内部标识符已存在
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)	
	}
	elseif (strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","内部标识符不能为空",2)	
	}
	elseif (strRes = "-300")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)	
	}
	elseif (strRes = "-400")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","内部标识符已存在",2)	
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DEL_DATAELEMENT_CATEGORY","params":{"id":"380"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelDataElementCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.DataElementCategory).DelDataElementCategoryJson(strID)
    d argOutData.Write(strRes)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到术语目录,-500 包含子节点不能删除
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败","2")
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空","2")
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到术语目录","2")
	}
	elseif(strRes = "-500")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","包含子节点不能删除","2")
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据用户术语集目录树结构
/// Creator:    yejian
/// CreateDate: 2021-3-25
/// Input:      argUserCode用户编码
/// Input:      DataTypes  授权数据类型
/// OutPut:     成功 1 失败 -200 用户code必传 -201 获取数据类型必须为ALL或CG
/// 						-301 未获取到用户  -302 用户未关联角色  -303 角色未关联项目标识
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DataElementCategory).GetDataElementTreeJson("YS01","CG",.argOutData)
ClassMethod GetDataElementTreeJson(argUserCode As %String, GetDataType As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(roleCode="") "-200"
	q:((GetDataType'="ALL")&&(GetDataType'="CG")) "-201"
#;	s userObj = ##class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(userObj="") "-301"
#;	q:(userObj.RoleID="") "-302"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"

	s jsonArr = ##class(%DynamicArray).%New()
    s jsonRoot  = ##class(%DynamicObject).%New()
    s jsonRoot.key ="0||RT"
    s jsonRoot.title ="电子病历基本数据元"
    s jsonRoot.type = "RT"
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.DataElementCategory).GetJsonCategroyByID(0,GetDataType,.jsonCategory)	
	s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
	d jsonArr.%Push(jsonRoot)
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       获取术语集目录树json
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      TemplateID	模板ID
/// Input:      DataTypes  授权数据类型
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DataElementCategory).GetDataElementByDocIDJson("1","CG",.argOutData)
ClassMethod GetDataElementByDocIDJson(aTemplateID As %String, aGetDataType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    s jsonRoot  = ##class(%DynamicObject).%New()
    s jsonRoot.ID ="0"
    s jsonRoot.Name ="术语集"
    s jsonRoot.InternalID = ""
    s jsonRoot.Type = "RT"
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.DataElementCategory).GetJsonCategroyByID(0,aGetDataType,.jsonCategory)	
	s jsonRoot.Nodes = jsonCategory
	d jsonRoot.%ToJSON(argOutData)

	q strRes
}

/// Desc:       递归获取目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.DataElementCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, GetDataType As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $O(^CF.EMR.DOC.DECategoryI("IdxParentId"," "_aParentId, rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.DataElementCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.key = rowCID_"||CG"
	    s jsonCat.internalID = objCat.InternalID
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = "CG"
	    s jsonCat.description = objCat.Description
	    	   
		s jsonCateNew = ##class(%DynamicArray).%New()
		if (GetDataType="ALL")
		{
			//获取数据元
			s result = ##Class(EMR.DOC.BL.DataElement).GetDataElementByPID(rowCID,objCat.InternalID,.jsonCateNew)
		}
		if (jsonCateNew.%Size()<=0)
		{
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.DataElementCategory).GetJsonCategroyByID(rowCID,GetDataType,.jsonCateNew)
		}
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取术语操作
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      ParentCode  功能字典目录编码
/// 			UserCode	用户编码
/// OutPut:     argOutData 	返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DataElementCategory).GetDataElementOperationJson("MENU_GLOSSARY_GLOSSARY","YS01",.argOutData)
ClassMethod GetDataElementOperationJson(ParentCode As %String, UserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	
#;	s objUser = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(UserCode)
#;	q:(objUser="") "-101"
#;	q:(objUser.RoleID="") "-102"
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"

	s strRoleID = RoleID
	s jsonObj  = ##class(%DynamicObject).%New()
 	s strRPRowID = ""
 	s strRes = "-301"
	
	//添加右键授权数据
	s jsonFuncMenuNode = ##class(%DynamicObject).%New()
	//添加按钮授权数据
	s arrayFuncBtn = ##class(%DynamicArray).%New()
	s rowFuncItemID = ""
	for {
		s rowFuncItemID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(ParentCode,"U"),rowFuncItemID))
		q:(rowFuncItemID = "")				
		s objFunItem = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFuncItemID)
		continue:(objFunItem="")
		s strRes="1"
        if (objFunItem.Type.Code="funcMenuNode")
        {
			s Permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFuncItemID)
			//添加功能菜单授权数据
			s jsonFuncMenu = ##class(%DynamicArray).%New()
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFunItem.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s menuPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				continue:menuPermission'=2
				d jsonFuncMenu.%Push(jsonMenu)
			}
	        s:($ZCVT(objFunItem.FuncCode,"U")="MENU_GLOSSARY_DATAELMENT_ROOT") jsonFuncMenuNode.root = jsonFuncMenu
	        s:($ZCVT(objFunItem.FuncCode,"U")="MENU_GLOSSARY_DATAELMENT_CATEGORY") jsonFuncMenuNode.category = jsonFuncMenu
	        s:($ZCVT(objFunItem.FuncCode,"U")="MENU_GLOSSARY_DATAELMENT_ELEMENT") jsonFuncMenuNode.element = jsonFuncMenu
	    
        }
        elseif(objFunItem.Type.Code="funcBtnType")
        {
	        
			s permission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFuncItemID)
			s rowFunMenuID = ""
			for {
				s rowFunMenuID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(objFunItem.FuncCode,"U"),rowFunMenuID))
				q:(rowFunMenuID = "")				
				s objFunMenu = ##Class(CT.EMR.DOC.DictFunction).%OpenId(rowFunMenuID)
				s jsonMenu  = ##class(%DynamicObject).%New()
				s jsonMenu.code = objFunMenu.FuncCode
				s jsonMenu.name =objFunMenu.FuncName
				s btnPermission = ##Class(EMR.DOC.BL.RBACOperPermission).GetOperPermission(strRoleID,rowFunMenuID)
				s jsonMenu.permission = btnPermission
				d arrayFuncBtn.%Push(jsonMenu)
			}
        }
	
	}
    
    s jsonObj.tree =jsonFuncMenuNode
    s jsonObj.btn =arrayFuncBtn
	d jsonObj.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:       添加术语目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空，-201 内部标识符不能为空，
/// 						  -300 未查到目录 -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.DataElementCategory).AddDataElementCategoryJson()
ClassMethod AddDataElementCategoryJson(argDTO As EMR.DOC.DTO.DataElementCategory) As %String
{
	s strRes ="-100"
	if (argDTO.ParentID = "")
	{
		q "-200"
	} 
	if (argDTO.InternalID = "")
	{
		q "-201"
	}
	s obj = ##class(CF.EMR.DOC.DataElementCategory).%New()
	s intParentID = +(argDTO.ParentID)
	s strInternalID = $zcvt(argDTO.InternalID,"U")
	s objParent = ##class(CF.EMR.DOC.DataElementCategory).%OpenId(intParentID)
	if (intParentID'=0)&&(objParent="")
	{
		q "-300"
	}
	s isHas = $o(^CF.EMR.DOC.DECategoryI("IdxInternalID"," "_strInternalID,""))
	if (isHas'="")
	{
		q "-400"
	} 
	s obj.InternalID = argDTO.InternalID
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.ParentID = intParentID
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		 q strRes
	}
}

/// Desc:       更新目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 内部标识符不能为空，-202 目录ID不能为空，
/// 						  -300 未查到目录， -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.DataElementCategory).UpBDMCategoryJson()
ClassMethod UpDataElementCategoryJson(argDTO As EMR.DOC.DTO.DataElementCategory) As %String
{
	s strRes = "-100"
	if (argDTO.ID="")
	{
		q "-200"
	} 
	if (argDTO.InternalID = "")
	{
		q "-201"
	}
	s obj = ##class(CF.EMR.DOC.DataElementCategory).%OpenId(argDTO.ID)
	s intParentID = +(argDTO.ParentID)
	s strOldInternalID = $zcvt(obj.InternalID,"U")
	s strInternalID = $zcvt(argDTO.InternalID,"U")
	if ((intParentID'=0)&&(intParentID'=obj.ParentID)){
		s objParent = ##class(CF.EMR.DOC.DataElementCategory).%OpenId(intParentID)
		if (objParent="")
		{
			q "-300"
		}
		s obj.ParentID = intParentID
	}else{
		s intParentID = obj.ParentID	
	}
	
	if (argDTO.InternalID'=obj.InternalID)
	{
		s isHas = $o(^CF.EMR.DOC.DECategoryI("IdxInternalID"," "_strInternalID,""))
		if (isHas'="")
		{
			q "-400"
		}
	} 
	s obj.InternalID = argDTO.InternalID
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		 q strRes
	}
}

/// Desc:       删除术语目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到术语目录,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.DataElementCategory).DelBDMCategoryJson("1")
ClassMethod DelDataElementCategoryJson(argCategoryID As %String) As %String
{
	s strRes = "-100"
	if (argCategoryID="")
	{
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.DataElementCategory).%OpenId(argCategoryID)
	if (obj="")  
	{
		q "-300"
	}
	
	s strNodesCount = 0
	&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.DataElement c WHERE c.Category = :argCategoryID)
	if (strNodesCount>0)
	{
		q "-500"
	}
	s sc = ##class(CF.EMR.DOC.DataElementCategory).%DeleteId(argCategoryID)
	if '(sc)
	{
		q strRes
	}
	q "1"
}

}
