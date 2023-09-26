/// 名称:	EMR.DOC.BL.GlossaryCategory
/// 描述:	通用文档管理模块 Document(Doc) 术语集目录业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.GlossaryCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       根据用户取术语集目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数{"action":"GET_GLOSSARY_TREE","params":{"userCode":"YS01","getDataType":"CG","type":"BMD","dataID":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
	s action = argInJson.params.action
	s:(action="") action="ALL"
	s type = argInJson.params.type
	s dataID = ..GetIDByKey(argInJson.params.id)
	s strCategoryID = ##class(EMR.DOC.BL.GlossaryCategory).GetCategroyIDByType(type,dataID)
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).GetGlossaryTreeJson(UserCode,action,strCategoryID,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
	
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取模板操作相关数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_GLOSSARY_OPERATION","params":{"parentCode":"MENU_GLOSSARY_GLOSSARY","userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ParentCode = "MENU_GLOSSARY_GLOSSARY"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).GetGlossaryOperationJson(ParentCode,UserCode,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取术语集目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_GLOSSARY_BYDOC","params":{"getDataType":"CG","templateID": "1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryByDocID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s GetDataType = argInJson.params.getDataType
	s TemplateID = argInJson.params.templateID
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).GetGlossaryByDocIDJson(TemplateID,GetDataType,.argOutData)
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

/// Desc:       添加目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"ADD_GLOSSARY_CATEGORY","params":{"id":"1","name":"EMR03门急诊处方","description":"门急诊处方","internalID":"HDSD00.03","templateIDS":[]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddGlossaryCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.GlossaryCategory).%New()
	s argDTO.InternalID = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID =..GetIDByKey(argInJson.params.id)
	s glossaryTems = argInJson.params.templateIDS
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).AddGlossaryCategoryJson(argDTO,glossaryTems)
    //失败:-100 添加失败, -200 目录ID不能为空，-201 内部标识符不能为空， -300 未查到目录，-301 更新术语和模板关联关系失败，-400 内部标识符已存在
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
	elseif (strRes="-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","更新术语和模板关联关系失败",2)	
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
/// Input:      argArray  	命令参数 {"action":"UP_GLOSSARY_CATEGORY","params":{"id":"1","parentId":"1","internalID":"HDSD00.03","name":"EMR03门急诊处方1","description":"门急诊处方1","glossaryTems":"2^3"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpGlossaryCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.GlossaryCategory).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.InternalID = argInJson.params.internalID
	s argDTO.Name = argInJson.params.name
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID =..GetIDByKey(argInJson.params.parentId)
	s GlossaryTems = argInJson.params.templateIDS
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).UpGlossaryCategoryJson(argDTO,GlossaryTems)
    d argOutData.Write(strRes)
    //失败:-100 更新失败, -200 ID不能为空，-201 内部标识符不能为空， -300 未查到目录，-301 更新术语和模板关联关系失败， -400 内部标识符已存在
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
	elseif (strRes = "-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","更新术语和模板关联关系失败",2)	
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
/// Input:      argArray  	命令参数 {"action":"DEL_GLOSSARY_CATEGORY","params":{"id":"380"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelGlossaryCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).DelGlossaryCategoryJson(strID)
    d argOutData.Write(strRes)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到术语目录,-301 删除目录与模板关联关系失败	,-500 包含子节点不能删除
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
	elseif(strRes = "-301")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","删除目录与模板关联关系失败","2")
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

/// Desc:       术语集tree检索
/// Creator:    duan
/// CreateDate: 2021-06-16
/// Input:      argArray  	命令参数 {"action":"SEARCH_GLOSSARY_TREE","params":{"userCode":"YS01",text:""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod SearchTreeValue(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
	s Text = argInJson.params.text
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).SearchTreeValueJson(UserCode,Text,roleCode,argOutData)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到术语目录,-301 删除目录与模板关联关系失败	,-500 包含子节点不能删除
    if (strRes = "1")
	{ 
		q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","查询失败","2")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       术语集目录关联模板ID
/// Creator:    duan
/// CreateDate: 2021-06-17
/// Input:      argArray  	命令参数 {"action":"ADD_GLOSSARY_DOCUMENT","params":{"userCode":"YS01","id":"","documentIDS":[]},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddGlossaryDocumentItem(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s UserCode = argInJson.params.userCode
	s Text = argInJson.params.text
    s strRes = ##Class(EMR.DOC.BL.GlossaryCategory).SearchTreeValueJson(UserCode,Text,argOutData)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到术语目录,-301 删除目录与模板关联关系失败	,-500 包含子节点不能删除
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
	elseif(strRes = "-301")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","删除目录与模板关联关系失败","2")
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
/// 		    DataTypes  授权数据类型
/// 				aCategoryID 根据目录ID查询数据（为空查询所有）
/// OutPut:     成功 1 失败 -200 用户code必传 -201 获取数据类型必须为ALL或CG, -202 目录ID未查到
/// 						-301 未获取到用户  -302 用户未关联角色  -303 角色未关联项目标识
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryCategory).GetGlossaryTreeJson("YS01","CG",.argOutData)
ClassMethod GetGlossaryTreeJson(aUserCode As %String, aAction As %String, aCategoryID As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(roleCode="") "-1^安全组code必传,检查参数safeGroupId"
	q:((aAction'="ALL")&&(aAction'="CG")&&(aAction'="CHILD")&&(aAction'="SUBCHILD")) "-1^数据类型必须为ALL或CG"
#;	s userObj = ##class(EMR.DOC.BL.RBACUser).getUserByUserCode(aUserCode)
#;	q:(userObj="") "-1^未获取到用户"
#;	q:(userObj.RoleID="") "-1^用户未关联角色" 
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-1^未获取到安全组信息"
   
	s jsonCategory = ##class(%DynamicObject).%New()
	if (aCategoryID="")
	{
		s:((aAction="CHILD")||(aAction="SUBCHILD")) aAction="ALL"
		d ##Class(EMR.DOC.BL.GlossaryCategory).GetJsonCategroyByID(0,aAction,.jsonCategory)	
	}
	else
	{
		s objCate = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(aCategoryID)
		q:(objCate="") "-1^目录ID未查到"
		d ##Class(EMR.DOC.BL.GlossaryCategory).GetJsonCategroyByCID(aCategoryID,aAction,.jsonCategory)	
	}
	s jsonRoot = ##class(%DynamicArray).%New()
	if ((aAction="CG") || (aCategoryID="")||(aAction="ALL")){
		s jsonObj  = ##class(%DynamicObject).%New()
		s jsonObj.key ="root||RT"
    	s jsonObj.title ="术语集"
    	s jsonObj.internalId = ""
    	s jsonObj.type = "RT"
		s:(jsonCategory.%Size()>0) jsonObj.children = jsonCategory.children
		d jsonRoot.%Push(jsonObj)
	}
	elseif(aAction="CHILD")
	{
		s:((jsonCategory.children'="")&&(jsonCategory.children.%Size()>0)) jsonRoot = jsonCategory.children
	}
	elseif(aAction="SUBCHILD"){
		d jsonRoot.%Push(jsonCategory)
	}
	
	d jsonRoot.%ToJSON(argOutData)	
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
///             w ##class(EMR.DOC.BL.GlossaryCategory).GetGlossaryByDocIDJson("1","CG",.argOutData)
ClassMethod GetGlossaryByDocIDJson(aTemplateID As %String, aGetDataType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    s jsonRoot  = ##class(%DynamicObject).%New()
    s jsonRoot.ID ="0"
    s jsonRoot.Name ="术语集"
    s jsonRoot.InternalID = ""
    s jsonRoot.Type = "RT"
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.DOC.BL.GlossaryCategory).GetJsonCategroyByID(0,aGetDataType,.jsonCategory)	
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
/// Output:     q ##Class(EMR.DOC.BL.GlossaryCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, aAction As %String, ByRef jsonCategory As %DynamicObject) As %String
{
	s res = "1"
	s rowCID = ""
	s jsonArr = ##class(%DynamicArray).%New()
	for {
		s rowCID = $o(^CF.EMR.DOC.GlossaryCategoryI("IdxParentId"," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.GlossaryCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s json = ##class(%DynamicObject).%New()
	    s json.key = rowCID_"||CG"
	    s json.internalId = objCat.InternalID
	    s json.title = objCat.Name
	    s json.type = "CG"
	    s json.description = objCat.Description
		s json.resChildCount = objCat.ResChildCount
	    s json.templateIDS = ##Class(EMR.DOC.BL.GlossaryTemplate).GetTemIDSByInternalID(objCat.InternalID)
		s jsonCateNew = ##class(%DynamicArray).%New()

		if (+(objCat.ResChildCount)'=0)
		{
			if (aAction'="CG")
			{
				//获取术语集项
				s result = ##Class(EMR.DOC.BL.Glossary).GetGlossaryByPID(rowCID,.jsonCateNew)
			}
		}
		else
		{	
			//根据目录获取模板数据
			s jsonCategoryChild = ##class(%DynamicObject).%New()
			s result = ##Class(EMR.DOC.BL.GlossaryCategory).GetJsonCategroyByID(rowCID,aAction,.jsonCategoryChild)
			s:((jsonCategoryChild.children'="")&&(jsonCategoryChild.children.%Size()>0)) jsonCateNew=jsonCategoryChild.children
		}
		s:(jsonCateNew.%Size()>0) json.children = jsonCateNew
		d jsonArr.%Push(json)
	}
	s jsonCategory.children = jsonArr
	q res
}

/// Desc:       递归获取目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.GlossaryCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByCID(aParentId As %String, aAction As %String, ByRef jsonCategory As %DynamicObject) As %String
{
	s res = "1"
		
	s objCat = ##Class(CF.EMR.DOC.GlossaryCategory).%OpenId(aParentId)
    q:(objCat="") res
    s jsonCategory.key = aParentId
    s jsonCategory.internalId = objCat.InternalID
    s jsonCategory.title = objCat.Name
    s jsonCategory.type = "CG"
    s jsonCategory.description = objCat.Description
	s jsonCategory.resChildCount = objCat.ResChildCount
    s jsonCategory.templateIDS = ##Class(EMR.DOC.BL.GlossaryTemplate).GetTemIDSByInternalID(objCat.InternalID)
	s jsonCateNew = ##class(%DynamicArray).%New()

	if (+(objCat.ResChildCount)'=0)
	{
		if (aAction'="CG")
		{
			//获取术语集项
			s result = ##Class(EMR.DOC.BL.Glossary).GetGlossaryByPID(aParentId,.jsonCateNew)
		}
	}
	else
	{	
		s jsonObj = ##class(%DynamicObject).%New()
		//根据目录获取模板数据
		s result = ##Class(EMR.DOC.BL.GlossaryCategory).GetJsonCategroyByID(aParentId,aAction,.jsonObj)
		s:((jsonObj.children'="")&&(jsonObj.children.%Size()>0)) jsonCateNew = jsonObj.children
	}
	s:(jsonCateNew.%Size()>0) jsonCategory.children = jsonCateNew
	
	q res
}

/// Desc:       获取术语操作
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      ParentCode  功能字典目录编码
/// 			UserCode	用户编码
/// OutPut:     argOutData 	返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryCategory).GetGlossaryOperationJson("MENU_GLOSSARY_GLOSSARY","YS01",.argOutData)
ClassMethod GetGlossaryOperationJson(ParentCode As %String, UserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
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
	        s:(objFunItem.FuncCode="menu_glossaryg_root") jsonFuncMenuNode.root = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_glossaryg_category") jsonFuncMenuNode.category = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_glossaryg_glossary") jsonFuncMenuNode.glossary = jsonFuncMenu
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
/// 						  -300 未查到目录，-301 更新术语和模板关联关系失败， -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.GlossaryCategory).AddGlossaryCategoryJson()
ClassMethod AddGlossaryCategoryJson(argDTO As EMR.DOC.DTO.GlossaryCategory, glossaryTems As %DynamicArray) As %String
{
	s strRes ="-100"
	TSTART
	if (argDTO.ParentID = "")
	{
		TROLLBACK
		q "-200"
	} 
	if (argDTO.InternalID = "")
	{
		TROLLBACK
		q "-201"
	}
	s obj = ##class(CF.EMR.DOC.GlossaryCategory).%New()
	s intParentID = +(argDTO.ParentID)
	s strInternalID = $zcvt(argDTO.InternalID,"U")
	s objParent = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(intParentID)
	if (intParentID'=0)&&(objParent="")
	{
		TROLLBACK
		q "-300"
	}
	s isHas = $o(^CF.EMR.DOC.GlossaryCategoryI("IdxOnInternalID"," "_strInternalID,""))
	if (isHas'="")
	{
		TROLLBACK
		q "-400"
	} 
	s obj.InternalID = argDTO.InternalID
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.ParentID = intParentID
	
	//更新术语目录和模板ID关联关系
	&sql(DELETE FROM CF_EMR_DOC.GlossarysTemplate WHERE InternalID = :strInternalID)
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q "-301"
	}
	s strGTemMark = "1"
	s iter = glossaryTems.%GetIterator()
	while iter.%GetNext(.key , .strTemplateID ) 
	{
		s gtRowID = $o(^CF.EMR.DOC.GlossarysTemplateI("IdxInteIDTemID"," "_strInternalID," "_strTemplateID,""))
		continue:(gtRowID '= "")
		s objGlossaryTem = ##Class(CF.EMR.DOC.GlossarysTemplate).%New()
		s objGlossaryTem.InternalID = strInternalID
		s objGlossaryTem.TemplateID = ..GetIDByKey(strTemplateID)
		s sc =objGlossaryTem.%Save()
		if ('sc)
		{
			s strGTemMark ="-1"
		}
	}
	if (strGTemMark="-1")
	{
		TROLLBACK
		q "-301"
	}
	
	s obj.ResChildCount = 0
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		q obj.%Id()
	}
	else
	{
		TROLLBACK
		 q strRes
	}
}

/// Desc:       更新目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 内部标识符不能为空，-202 目录ID不能为空，
/// 						  -300 未查到目录，-301 更新术语和模板关联关系失败， -400 内部标识符已存在
/// Debug:      w ##Class(EMR.DOC.BL.GlossaryCategory).UpBDMCategoryJson()
ClassMethod UpGlossaryCategoryJson(aDTO As EMR.DOC.DTO.GlossaryCategory, aGlossaryTems As %DynamicArray) As %String
{
	s strRes = "-100"
	TSTART
	if (aDTO.ID="")
	{
		TROLLBACK
		q "-200"
	} 
	if (aDTO.InternalID = "")
	{
		TROLLBACK
		q "-201"
	}
	s obj = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(aDTO.ID)
	s intParentID = +(aDTO.ParentID)
	if ((intParentID>0) && (intParentID'=obj.ParentID)){
		s objParent = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(intParentID)
		if (intParentID'=0)&&(objParent="")
		{
			TROLLBACK
			q "-300"
		}
		s obj.ParentID = intParentID
	}
	s strOldInternalID = $zcvt(obj.InternalID,"U")
	s strInternalID = $zcvt(aDTO.InternalID,"U")
	
	if (aDTO.InternalID'=obj.InternalID)
	{
		s isHas = $o(^CF.EMR.DOC.GlossaryCategoryI("IdxOnInternalID"," "_strInternalID,""))
		if (isHas'="")
		{
			TROLLBACK
			q "-400"
		}
	} 
	s obj.InternalID = aDTO.InternalID
	s obj.Name = aDTO.Name
	s obj.Description = aDTO.Description
	
	
	//更新术语目录和模板ID关联关系
	&sql(DELETE FROM CF_EMR_DOC.GlossarysTemplate WHERE InternalID = :strOldInternalID)
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q "-301"
	}
	s strGTemMark = "1"
	s iter = aGlossaryTems.%GetIterator()
	
	while iter.%GetNext(.key, .strTemplateID)
	{
		s gtRowID = $o(^CF.EMR.DOC.GlossarysTemplateI("IdxInteIDTemID"," "_strInternalID," "_strTemplateID,""))
		continue:(gtRowID '= "")
		s objGlossaryTem = ##Class(CF.EMR.DOC.GlossarysTemplate).%New()
		s objGlossaryTem.InternalID = strInternalID
		s objGlossaryTem.TemplateID = ..GetIDByKey(strTemplateID)
		s sc =objGlossaryTem.%Save()
		if ('sc)
		{
			s strGTemMark ="-1"
		}
	}
	if (strGTemMark="-1")
	{
		TROLLBACK
		q "-301"
	}
	
	;s obj.ResChildCount = 0
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		q obj.%Id()
	}
	else
	{
		TROLLBACK
		 q strRes
	}
}

/// Desc:       删除术语目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到术语目录,-301 删除目录与模板关联关系失败	,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.GlossaryCategory).DelBDMCategoryJson("1")
ClassMethod DelGlossaryCategoryJson(argCategoryID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if (argCategoryID="")
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(argCategoryID)
	if (obj="")  
	{
		TROLLBACK
		q "-300"
	}
	
	s strCNodesCount = 0
	s strNodesCount = 0
	&sql(SELECT count(*) into:strCNodesCount  FROM CF_EMR_DOC.GlossaryCategory c WHERE c.ParentID = :argCategoryID)
	&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.Glossary c WHERE c.GlossaryCategory = :argCategoryID)
	if (strCNodesCount >0)||(strNodesCount>0)
	{
		TROLLBACK
		q "-500"
	}
	s strInternalID = obj.InternalID
	&sql(DELETE FROM CF_EMR_DOC.GlossarysTemplate WHERE InternalID = :strInternalID)
	if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q "-301"
	}
	s sc = ##class(CF.EMR.DOC.GlossaryCategory).%DeleteId(argCategoryID)
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       根据类型和ID获取关联术语目录ID
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aType 类型（BDM 业务数据模型,GLOSSARY 术语集,HFF 板式,DOC 文档,KB 片段）
///             aDataID 数据KEY（ID||类型）
/// Output:     q ##Class(EMR.DOC.BL.GlossaryCategory).GetCategroyIDByType("GLOSSARY","")
ClassMethod GetCategroyIDByType(aType As %String, aDataID As %String) As %String
{
	s strRes = ""
	s rowCID = ""
	q:(aType="") strRes
	s aType = $zcvt(aType,"U")
	//BDM,GLOSSARY,HFF,DOC,KB
	s:(aType="GLOSSARY") strRes=aDataID
	q:(aType="GLOSSARY") strRes
	//获取文档关联术语ID
	if (aType ="DOC")
	{
		//获取为版本ID
		s strID = ..GetIDByKey(aDataID)
		s objVersion = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(strID)
		q:(objVersion="") strRes
		s objHFFormat =$case( objVersion.Template.HFFormat,"":"",:objVersion.Template.HFFormat)
		q:(objHFFormat="") strRes
		s strRes = $case(objVersion.Template.HFFormat.BDMCategory.GlossaryItemIDS,"":"",:objVersion.Template.HFFormat.BDMCategory.GlossaryItemIDS)
	}
	elseif (aType = "HFF")
	{
		//获取为版式版本ID
		s strID = ..GetIDByKey(aDataID)
		s objHFFormatV = ##class(CF.EMR.DOC.HFFormatVersion).%OpenId(strID)
		q:(objHFFormatV="") strRes
		s objHFFormat =$case( objHFFormatV.HFFormat,"":"",:objHFFormatV.HFFormat)
		q:(objHFFormat="") strRes
		s strRes = $case(objHFFormatV.HFFormat.BDMCategory.GlossaryItemIDS,"":"",:objHFFormatV.HFFormat.BDMCategory.GlossaryItemIDS)
	}
	elseif (aType = "KB")
	{
		//获取为片段ID
		s strID = ..GetIDByKey(aDataID)
		s objKBNode = ##class(CF.EMR.DOC.KBNode).%OpenId(strID)
		q:(objKBNode="") strRes
		s strRes = $case(oobjKBNode.KBCategory.BDMCategory.GlossaryItemIDS,"":"",:objKBNode.KBCategory.BDMCategory.GlossaryItemIDS)
	}
	elseif(aType="BDM")
	{
		//获取为业务数据模型ID
		s strNodeType = ..GetTypeByKey(aDataID)
		s strID = ..GetIDByKey(aDataID)
		//简单元素
		if (strNodeType="ET")
		{
			//获取ID
			s objBDMSim = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(strID)
			q:(objBDMSim="") strRes
			s strParenID = $case(objBDMSim.BDMCategory,"":"",:objBDMSim.BDMCategory.ParentID)
			q:(strParenID="") strRes
			s objBDMDoc =##class(CF.EMR.DOC.BDMCategory).%OpenId(strParenID)
			q:(objBDMDoc="")||(objBDMDoc.StructType.Code'="Document") strRes
			s strRes = objBDMDoc.GlossaryItemIDS
		}
		elseif(strNodeType="CT") //复合元素
		{
			//获取ID
			s objBDMCom = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(strID)
			q:(objBDMCom="") strRes
			s strParenID = $case(objBDMCom.BDMCategory,"":"",:objBDMCom.BDMCategory.ParentID)
			q:(strParenID="") strRes
			s objBDMDoc =##class(CF.EMR.DOC.BDMCategory).%OpenId(strParenID)
			q:(objBDMDoc="")||(objBDMDoc.StructType.Code'="Document") strRes
			s strRes = objBDMDoc.GlossaryItemIDS
		}
		elseif(strNodeType = "ST") //章节
		{
			//获取ID
			s objBDMSec = ##class(CF.EMR.DOC.BDMCategory).%OpenId(strID)
			q:(objBDMSec="") strRes
			q:(objBDMSec.ParentID="") strRes
			s objBDMDoc =##class(CF.EMR.DOC.BDMCategory).%OpenId(objBDMSec.ParentID)
			q:(objBDMDoc="")||($ZCVT(objBDMDoc.StructType.Code,"U")'="DOCUMENT") strRes
			s strRes = objBDMDoc.GlossaryItemIDS
		}
	}
	q strRes
}

/// Desc:       术语集tree检索
/// Creator:    duan
/// CreateDate: 2021-06-16
/// Input:    aUserCode 用户code aText 检索内容 
/// output 成功 1 
/// debug q ##Class(EMR.DOC.BL.GlossaryCategory).SearchTreeValueJson("YS01","")
ClassMethod SearchTreeValueJson(aUserCode As %String, aText As %String, roleCode As %String, aOutData As %GlobalBinaryStream)
{
	q:(roleCode="") "-1^安全组编码不能为空"
	s resultArray = ##class(%DynamicArray).%New()
	if (aText="")
	{
		d resultArray.%ToJSON(aOutData)	
		q 1
	}
#;	s userObj = ##class(EMR.DOC.BL.RBACUser).getUserByUserCode(aUserCode)
#;	q:(userObj="") "-1^删除目录与模板关联关系失败"
#;	q:(userObj.RoleID="") "-1^用户未与角色关联" 
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-1^未查询到安全组信息"

	s result = ##class(%ResultSet).%New("EMR.DOC.BL.Glossary:SearchGlossary")
	d result.Execute(aText)
	while result.Next()
	{
		s ID = result.GetDataByName("ID")
		s parentKeyList = ##class(%DynamicArray).%New()
		s obj = ##class(%DynamicObject).%New()
		d ..GetParentKey(ID,"LF",parentKeyList)
		s key = ID_"||LF"
		s obj.key = key
		s obj.parentKey = parentKeyList
		d resultArray.%Push(obj)
	}
	d resultArray.%ToJSON(aOutData)
	q 1
}

/// desc 获取术语集检索到的数据的父级key
ClassMethod GetParentKey(aID As %String, aType As %String, aResult As %DynamicArray)
{
	q:(aID="") -1
	if (aType="LF"){
		s ObjGlossary = ##class(CF.EMR.DOC.Glossary).%OpenId(aID)
		q:ObjGlossary="" -1
		if (ObjGlossary.GlossaryType="KG"){
			//片段术语集节点
			s ParentID = ObjGlossary.ParentID
			s CategoryID = ObjGlossary.GlossaryCategory.%Id()
			d aResult.%Push(ParentID_"||LF")
			d aResult.%Push(CategoryID_"||CG")
			s ParentCategoryID = ..GetParentKey(CategoryID,"CG",aResult)
		}else
		{
			s CategoryID = ObjGlossary.GlossaryCategory.%Id()
			d aResult.%Push(CategoryID_"||CG")
			s ParentCategoryID = ..GetParentKey(CategoryID,"CG",aResult)
		}		
	}
	elseif(aType="CG")
	{
		s ObjCategory = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(aID)
		q:ObjCategory="" -1
		s ObjParentID = ObjCategory.ParentID
		s ObjParent = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(ObjParentID)
		if (ObjParent'=""){
			d aResult.%Push(ObjParentID_"||CG")	
			s ParentCategoryID = ..GetParentKey(ObjParentID,"CG",aResult)
		}	
	}
	q 1
}

}
