/// 名称:	EMR.DOC.BL.KBCategory
/// 描述:	通用文档管理模块 Document(Doc) 文档片段目录业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.KBCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取文档片段目录树
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"GET_KB_TREE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKBTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s DataTypes = "KB"
	s role=argInJson.params.safeGroupId
 	s scene=argInJson.params.scene			
    s strRes = ##Class(EMR.DOC.BL.KBCategory).GetKBTreeJson(UserCode,DataTypes,role,scene,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户没有关联角色",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户关联角色没有维护项目标识",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","userCode参数未传",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取文档片段操作数据
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"GET_KB_OPERATION","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKBOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s UserCode = argInJson.params.userCode
	s ParentCode = "MENU_DOC_KB"
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.KBCategory).GetOperationJson(ParentCode,UserCode,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户不存在",2)
	}
	elseif(strRes="-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","用户没有关联角色，请先授权",2)	
	}
	elseif(strRes="-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档管理操作数据为空,检查数据源",2)	
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:      添加目录
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_MANAGE","params":{"id": "12||CG","childType":"CG","name":"","description":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DTOCategory = ##class(EMR.DOC.DTO.KBCategory).%New()
	s DTOCategory.ParentType=..GetTypeByKey(argInJson.params.id)
	s ID = ..GetIDByKey(argInJson.params.id)
	s DTOCategory.Description = argInJson.params.description
	s DTOCategory.Name = argInJson.params.name
	s DTOCategory.ParentID = ID
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
	s DTOCategory.KBCategoryTypes=argInJson.params.childType
    s strRes = ##Class(EMR.DOC.BL.KBCategory).AddCategoryJson(DTOCategory,UserCode,roleCode)
    /// Output:     成功：1 失败：     -101 数据操作失败 -102目录下为文档节点不允许建目录
	///             				   -200 必填项校验失败 -201 id未传  -202 名称未传
	/// 							   -301 文档片段目录数据不存在，检查参数id -302 项目标识数据不存在，检查参数id
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","-102目录下为文档节点不允许建目录",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加权限失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","参数id未传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","参数name未传",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段目录数据不存在，检查参数id",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","项目标识数据不存在，检查参数id",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:      添加文档
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_MANAGE","params":{"id": "12||CG","childType":"DT","name":"","description":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DTOCategory = ##class(EMR.DOC.DTO.KBCategory).%New()
	s ID = ..GetIDByKey(argInJson.params.id)
	s BDMCategory = ..GetIDByKey(argInJson.params.BDMCategory)
	s DTOCategory.Description = argInJson.params.description
	s DTOCategory.Name = argInJson.params.name
	s DTOCategory.ParentID = ID
	s DTOCategory.BDMCategory = BDMCategory
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.KBCategory).AddDocumentJson(DTOCategory,UserCode,roleCode)
    /// Output:     成功：1 失败：     -101 数据操作失败 -102目录下为目录节点不允许建文档
	///             				   -200 必填项校验失败 -201 id未传  -202 名称未传
	/// 							   -301 文档片段目录数据不存在，检查参数id -302 业务数据模型文档目录不存在  -303 文档类型记录不存在，检查数据源
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","目录下为目录节点不允许建文档",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加权限失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","参数id未传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","参数name未传",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段目录数据不存在，检查参数id",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","业务数据模型文档目录不存在，检查参数BDMCategory",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档类型记录不存在，检查数据源",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       文档节点上添加章节
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_MANAGE","params":{"id": "12||DT","childType":"ST","name":"","description":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s SectionObj = ##class(EMR.DOC.DTO.KBCategory).%New()
	s ParentID = ..GetIDByKey(argInJson.params.id)
	s SectionObj.Description = argInJson.params.description
	s SectionObj.Name = argInJson.params.name
	s SectionObj.ParentID = ParentID
	s UserCode = argInJson.params.userCode 
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.KBCategory).AddSectionJson(SectionObj,"DT", UserCode,roleCode)
    /// 成功：1 失败：-101 数据操作失败 -102章节下有分类节点不允许建子章节 -103 不支持的AType类型
	///               -200 必填项校验失败 -201 ParentID -202 Name -203 AType
	/// 			  -301 业务数据文档节点不存在，检查参数id -302 文档片段章节类型数据不存在，检查数据源 -303 章节节点数据不存在
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节下有分类节点不允许建子章节",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","服务器错误: 不支持的AType节点类型",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加权限失败",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数未传",2)
	}
	elseif(strRes="-202")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","name参数未传",2)
	}
	elseif(strRes="-203")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","服务器错误: AType类型未传",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","业务数据模型文档节点不存在，检查参数id",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段SECTION类型数据不存在，检查数据源",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段章节节点数据不存在，检查参数id",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       章节节点上添加子章节
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_SUBSECTION","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddSubSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s SectionObj = ##class(EMR.DOC.DTO.KBCategory).%New()
	s SectionID = ..GetIDByKey(argInJson.params.id)
	s SectionObj.Description = argInJson.params.description
	s SectionObj.Name = argInJson.params.name
	s SectionObj.ParentID = SectionID
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId

    s strRes = ##Class(EMR.DOC.BL.KBCategory).AddSectionJson(SectionObj,"ST",UserCode,roleCode)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节下有分类节点不允许建子章节",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","服务器错误: 不支持的AType节点类型",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段SECTION类型数据不存在，检查数据源",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       章节节点上添加分类
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_KBTREE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddKBTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s KBTreeObj = ##class(EMR.DOC.DTO.KBCategory).%New()
	s SectionID = ..GetIDByKey(argInJson.params.id)
	s KBTreeObj.Description = argInJson.params.description
	s KBTreeObj.Name = argInJson.params.name
	s KBTreeObj.ParentID = SectionID
	s KBTreeObj.CTLoc=argInJson.params.ctLoc
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.KBCategory).AddKBTreeJson(KBTreeObj,"ST",UserCode,roleCode)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","服务器错误: 不支持的AType节点类型",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","添加权限失败",2)
	}
	elseif(strRes="-105")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节下有分类节点时不允许新建分类",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段KBTREE类型数据不存在，检查数据源",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点数据不存在，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       分类节点上添加子分类
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_SUBKBTREE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddSubKBTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s KBTreeObj = ##class(EMR.DOC.DTO.KBCategory).%New()
	s SectionID = ..GetIDByKey(argInJson.params.id)
	s KBTreeObj.Description = argInJson.params.description
	s KBTreeObj.Name = argInJson.params.name
	s KBTreeObj.ParentID = SectionID
	s KBTreeObj.CTLoc=argInJson.params.ctLoc
	s KBTreeObj.Disease=argInJson.params.disease
	
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId

    s strRes = ##Class(EMR.DOC.BL.KBCategory).AddKBTreeJson(KBTreeObj,"KT",UserCode,roleCode)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","服务器错误: 不支持的AType节点类型",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","文档片段KBTREE类型数据不存在，检查数据源",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点数据不存在，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新目录
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"UPDATE_KB_MANAGE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DTOCategory = ##class(EMR.DOC.DTO.KBCategory).%New()
	s CategoryID = ..GetIDByKey(argInJson.params.id)
	s DTOCategory.ID = CategoryID
	s DTOCategory.Description = argInJson.params.description
	s DTOCategory.Name = argInJson.params.name
	s DTOCategory.ParentID = argInJson.params.parentId
	
    s strRes = ##Class(EMR.DOC.BL.KBCategory).UpdateCategoryJson(DTOCategory,"CG")
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","只能在文档节点下添加章节，检查parentId参数",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","业务数据文档节点数据不存在，检查BDMCategory参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新文档
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"UPDATE_KB_MANAGE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DTOCategory = ##class(EMR.DOC.DTO.KBCategory).%New()
	s CategoryID = ..GetIDByKey(argInJson.params.id)
	s DTOCategory.ID = CategoryID
	s DTOCategory.Description = argInJson.params.description
	s DTOCategory.Name = argInJson.params.name
	s DTOCategory.ParentID = argInJson.params.parentId
	s DTOCategory.BDMCategory = ..GetIDByKey(argInJson.params.BDMCategory)
    s strRes = ##Class(EMR.DOC.BL.KBCategory).UpdateCategoryJson(DTOCategory,"DT")
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","只能在文档节点下添加章节，检查parentId参数",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","业务数据文档节点数据不存在，检查BDMCategory参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新章节
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"UPDATE_KB_SECTION","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ObjSection = ##class(EMR.DOC.DTO.KBCategory).%New()
	s SectionID = ..GetIDByKey(argInJson.params.id)
	s ObjSection.ID = SectionID
	s ObjSection.Description = argInJson.params.description
	s ObjSection.Name = argInJson.params.name
	s ObjSection.ParentID = argInJson.params.parentId
	
    s strRes = ##Class(EMR.DOC.BL.KBCategory).UpdateCategoryJson(ObjSection,"ST")
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","只能在文档节点下添加章节，检查parentId参数",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","业务数据文档节点数据不存在，检查parentId参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新分类
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"UPDATE_KB_KBTREE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpdateKBTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ObjKBTree = ##class(EMR.DOC.DTO.KBCategory).%New()
	s KBTreeID = ..GetIDByKey(argInJson.params.id)
	s ObjKBTree.ID = KBTreeID
	s ObjKBTree.Description = argInJson.params.description
	s ObjKBTree.Name = argInJson.params.name
	s ObjKBTree.ParentID = argInJson.params.parentId
	s LocID=argInJson.params.ctLoc
	s Disease=argInJson.params.disease
    s strRes = ##Class(EMR.DOC.BL.KBCategory).UpdateCategoryJson(ObjKBTree,"KT",LocID,Disease)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","只能在文档节点下添加章节，检查parentId参数",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","只能在章节节点下添加分类,检查parentId参数",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点下有子章节时不允许新建分类节点",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","业务数据文档节点数据不存在，检查parentId参数",2)
	}
	elseif(strRes="-303")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据不存在，检查parentId参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除目录
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"DELETE_KB_SECTION","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s SectionID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.KBCategory).DeleteCategoryJson(SectionID,"CG")
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","AType为空",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点下有子数据不允许删除",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点下有子数据不允许删除",2)
	}
	elseif(strRes="-105")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","不支持的AType类型",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数为空",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据为空，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点数据为空，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除文档
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"DELETE_KB_SECTION","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s SectionID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.KBCategory).DeleteCategoryJson(SectionID,"DT")
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","AType为空",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点下有子数据不允许删除",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点下有子数据不允许删除",2)
	}
	elseif(strRes="-105")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","不支持的AType类型",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数为空",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据为空，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点数据为空，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除章节
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"DELETE_KB_SECTION","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s SectionID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.KBCategory).DeleteCategoryJson(SectionID,"ST")
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","AType为空",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点下有子数据不允许删除",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点下有子数据不允许删除",2)
	}
	elseif(strRes="-105")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","不支持的AType类型",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数为空",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据为空，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点数据为空，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除分类
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"DELETE_KB_KBTREE","params":{"userCode": "YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteKBTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s KBTreeID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.KBCategory).DeleteCategoryJson(KBTreeID,"KT")
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-101")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录失败",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","AType为空",2)
	}
	elseif(strRes="-103")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点下有子数据不允许删除",2)
	}
	elseif(strRes="-104")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点下有子数据不允许删除",2)
	}
	elseif(strRes="-105")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","不支持的AType类型",2)
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","id参数为空",2)
	}
	elseif(strRes="-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","章节节点数据为空，检查id参数",2)
	}
	elseif(strRes="-302")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","分类节点数据为空，检查id参数",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据TemplateID获取文档片段目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_KBTREE_BYDOC","args":{"ProductCode":"DOC","TemplateID": "1"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKBTreeByDocID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode = argInJson.params.args.ProductCode
	s TemplateID = argInJson.params.args.TemplateID
    s strRes = ##Class(EMR.DOC.BL.KBCategory).GetKBTreeByDocIDJson(TemplateID,ProductCode,.argOutData)
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

/// Desc:       获取文档片段目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_KBNODE_BYSECTION","args":{"SECTIONID": "1"}},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKBNodeBySectionID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strSectionID = argInJson.params.args.SECTIONID
    s strRes = ##Class(EMR.DOC.BL.KBCategory).GetKBNodeBySectionIDJson(strSectionID,.argOutData)
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

/// Desc:       获取文档片段目录树JSON
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      TemplateID	模板ID
/// Input:      aProductCode  项目标识
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.KBCategory).GetKBTreeByDocIDJson("1","TEMPLATE",.argOutData)
ClassMethod GetKBTreeByDocIDJson(aTemplateID As %String, aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	q:(aTemplateID="") strRes

	s objTempalte = ##Class(CF.EMR.DOC.Template).%OpenId(aTemplateID)
    q:(objTempalte="") strRes
    
    s objProduct = objTempalte.Product
    s strProductID = objTempalte.Product.%Id()
    s jsonRoot  = ##class(%DynamicObject).%New()
    s jsonRoot.ID =objProduct.ProductCode
    s jsonRoot.ProductID = strProductID
    s jsonRoot.Name ="文档片段管理("_objProduct.ProductName_")"
    s jsonRoot.Sequence = 0
    s jsonRoot.Type = "RT"
	
	s jsonCategory = ##class(%DynamicArray).%New()
	//如果关联业务数据模型，获取对应关联文档，否则获取所有
	//s strBDMDocID = ##Class(EMR.DOC.BL.Template).GetBDMDocIDbyTemID(aTemplateID)
	//s strBDMDocID = "57"
	
	//if (strBDMDocID '="-1")
	//{
		//d ##Class(EMR.DOC.BL.KBCategory).GetJsonDocmentByID(strBDMDocID,strProductID,.jsonCategory)
	//}
	//else
	//{
		d ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(0,strProductID,.jsonCategory)	
	//}
	s jsonRoot.Nodes = jsonCategory
	d jsonArr.%Push(jsonRoot)
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       获取文档数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonDocmentByID(aDocmentId As %String, aProductID As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
			
	s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(aDocmentId)
    q:(objCat="") res
    s jsonCat  = ##class(%DynamicObject).%New()
    s jsonCat.ID = aDocmentId
    s jsonCat.Name = objCat.Name
    s jsonCat.Type = objCat.KBCategoryTypes.Code
    s jsonCat.Description = objCat.Description
	s jsonCat.ResChildCount = objCat.ResChildCount
	s jsonCat.Permission = "2"
    s jsonCat.Sequence = objCat.CategorySeq
	s jsonCateNew = ##class(%DynamicArray).%New()
	
	s result = ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(aDocmentId,aProductID,.jsonCateNew)
	s jsonCat.Nodes = jsonCateNew
	d jsonCategory.%Push(jsonCat)	
	
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
/// Output:     q ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, aProductID As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxProParentId",aProductID," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.ID = rowCID
	    s jsonCat.Name = objCat.Name
	    s jsonCat.Type = objCat.KBCategoryTypes.Code
	    s jsonCat.Description = objCat.Description
		s jsonCat.ResChildCount = objCat.ResChildCount
		s jsonCat.Permission = "2"
	    s jsonCat.Sequence = objCat.CategorySeq
	    
		s jsonCateNew = ##class(%DynamicArray).%New()

		//根据目录获取模板数据
		s result = ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(rowCID,aProductID,.jsonCateNew)
		
		s jsonCat.Nodes = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       根据章节ID获取片段节点
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aSectionId 章节ID
///             jsonCategory 目录json对象
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.KBCategory).GetKBNodeBySectionIDJson("198",.argOutData)
ClassMethod GetKBNodeBySectionIDJson(aSectionId As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s res = "1"
			
	s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(aSectionId)
    q:(objCat="") res
    s jsonCat  = ##class(%DynamicObject).%New()
    s jsonCat.ID = aSectionId
    s jsonCat.Name = objCat.Name
    s jsonCat.Type = "RT"
    s jsonCat.Sequence = "0"
	s jsonCateNew = ##class(%DynamicArray).%New()
	s strNRes = ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(aSectionId,.jsonCateNew)
	//返回-1:没有片段节点，如果1：有片段节点
	if (strNRes="-1")
	{
		s result = ##Class(EMR.DOC.BL.KBCategory).GetKBTreeNodeBySectionID(aSectionId,.jsonCateNew)
	}
	s jsonCat.Nodes = jsonCateNew
	d jsonCat.%ToJSON(argOutData)
	q res
}

/// Desc:       根据章节ID获取片段目录和片段
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetKBTreeNodeBySectionID(aParentId As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxParentId"," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.ID = rowCID
	    s jsonCat.Name = objCat.Name
	    s jsonCat.Type = objCat.KBCategoryTypes.Code
	    s jsonCat.Description = objCat.Description
		s jsonCat.ResChildCount = objCat.ResChildCount
	    s jsonCat.Sequence = objCat.CategorySeq
	    
		s jsonCateNew = ##class(%DynamicArray).%New()
		s strNRes = ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(rowCID,.jsonCateNew)
		//返回-1:没有片段节点，如果1：有片段节点
		if (strNRes="-1")
		{
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.KBCategory).GetKBTreeNodeBySectionID(rowCID,.jsonCateNew)
		}
		s jsonCat.Nodes = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取文档片段目录tree
/// Creator:    duan
/// CreateDate: 2021-05-06
/// Input:      argUserCode 用户Code
/// Output:     成功：1 失败：-101 用户不存在  -102 用户没有关联角色 -103 角色没有维护项目标识
/// 							  -200 userCode参数未传
/// debug:  q ##Class(EMR.DOC.BL.KBCategory).GetKBTreeJson("YS01")
ClassMethod GetKBTreeJson(argUserCode As %String, argDataTypes As %String, Arole As %String, scene As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(Arole="") "-1^安全组code不能为空"
	//根据角色编码获取角色ID，成功返回角色ID，失败返回-1^失败信息
	s RoleID =##Class(EMR.DOC.BL.RBACRole).GetRoleByCode(Arole)
	q:(RoleID["-1^") "-102" 

	if (scene="permission")
	{
		s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode("SuperAdmin")
		q:(productArray.%Size()=0) "-103"
	}
	else
	{
		s productArray =  ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(Arole)
		q:(productArray.%Size()=0) "-103"
	}
	s jsonArr = ##class(%DynamicArray).%New()
	s strRes = "1"
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.KBCategoryTypes where Code = "Root")
	q:(rootID="") strRes
	set iter = productArray.%GetIterator()
	while iter.%GetNext(.key , .objProduct ) {
		s ProductID = objProduct.%Id()
        s jsonRoot  = ##class(%DynamicObject).%New()
        s cateID=""
	    &sql(select ID into :cateID from CF_EMR_DOC.KBCategory where Product = :ProductID and KBCategoryTypes = :rootID)
	    continue:(cateID="")
	    s objRoot=##class(CF.EMR.DOC.KBCategory).%OpenId(cateID)
        s jsonRoot.key =cateID_"||RT"
        s jsonRoot.title =objRoot.Name
        s jsonRoot.code ="root"
        s jsonRoot.permission = 1
        s jsonRoot.type = "RT"
        s jsonRoot.description = objRoot.Description
    	s jsonRoot.product=objRoot.Product.ProductCode
		s jsonCategory = ##class(%DynamicArray).%New()
		s argDataTypes = $ZCVT(argDataTypes,"U")
	    
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(ProductID,RoleID,argDataTypes,"RT",cateID)
		S jsonRoot.permission=Permission
		//判断节点勾选状态
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(ProductID,RoleID,argDataTypes,"RT",cateID)
		s jsonRoot.checked=checkStatus

		d ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByPID(cateID,ProductID,RoleID,argDataTypes,"RT",.jsonCategory)
		s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
		d jsonArr.%Push(jsonRoot)
	}
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取业务模型目录数据
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, aProductID As %String, aRoleID As %String, aDataTypes As %String, flag As %String, ByRef jsonCategory As %DynamicArray, aKey As %String = "", level As %String)
{
	s res = "1"
	s rowCID = "",Sequence=""
	for 
	{
		s Sequence=$o(^CF.EMR.DOC.KBCategoryI("IdxProParentSeqId",aProductID," "_aParentId,Sequence))
		q:Sequence=""
		for
		{
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxProParentSeqId",aProductID," "_aParentId,Sequence,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s type=""
	    if (objCat.KBCategoryTypes.Code="Category")
	    {
		    s type="CG"
		}
		elseif (objCat.KBCategoryTypes.Code="Document")
		{
			s type="DT"
		}
		elseif (objCat.KBCategoryTypes.Code="Section")
		{
			s type="ST"
		}
		elseif (objCat.KBCategoryTypes.Code="KBTree")
		{
			s type="KT"
		}
		s flag=##class(CF.EMR.DOC.KBCategory).%OpenId(objCat.ParentID).KBCategoryTypes.Code
		
	    s jsonCat  = ##class(%DynamicObject).%New()
	    if ((flag="Section")&&(type="KT"))
	    {
		    s jsonCat.level=1
		}
	    elseif ((flag="KBTree")&&(type="KT")&&(level=1))
	    {
		    s jsonCat.level=2
		}
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    if (type="DT")
	    {
		    s BDMCategory = ""
		    s:(objCat.BDMCategory'="") BDMCategory =objCat.BDMCategory.%Id()_"||DT"
			s jsonCat.BDMCategory = BDMCategory  
		}
		if (type="KT")
		{
			s jsonCat.ctLoc=objCat.CTLoc
			s jsonCat.disease=objCat.Disease
		}
	    s jsonCat.description = objCat.Description
	    s jsonCat.product=objCat.Product.ProductCode
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductID,aRoleID,aDataTypes,type,rowCID)
		s jsonCat.permission = Permission
	    continue:Permission<=0
		
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductID,aRoleID,aDataTypes,type,rowCID)
		s jsonCat.checked=checkStatus

		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if ((type="KT")&&(objCat.ResChildCount'=0))
		{
			// 通过KBTRee获取node节点
			s result = ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(rowCID,aProductID,aRoleID,aDataTypes,.jsonCateNew,jsonCat.key)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		else
		{
			s result = ##Class(EMR.DOC.BL.KBCategory).GetJsonCategroyByPID(rowCID,aProductID,aRoleID,aDataTypes,flag,.jsonCateNew,jsonCat.key,jsonCat.level)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		d jsonCategory.%Push(jsonCat)	

		}
	}
	q res
}

/// Desc:       获取文档片段章节数据
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.KBCategory).GetSectionByPID()
ClassMethod GetSectionByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray, aKey As %String = "")
{
	s strRes="1"
	s rowID = ""
	for
	{
		s rowID = $O(^CF.EMR.DOC.KBCategoryI("IdxParentId"," "_aParentId,rowID))
		q:rowID=""
		s objCategory = ##class(CF.EMR.DOC.KBCategory).%OpenId(rowID)
		continue:objCategory=""
		s jsonCat  = ##class(%DynamicObject).%New()
		s type = ..FormatType(objCategory.KBCategoryTypes.Code)
	    s jsonCat.key = rowID_"||"_type
	    s jsonCat.title = objCategory.Name
	    s jsonCat.type = type
	    s jsonCat.description = objCategory.Description
	    s jsonCat.parentKey= aKey
	    s resChildCount = objCategory.ResChildCount
	    s jsonCateNew = ##class(%DynamicArray).%New()
	    if ((resChildCount>0) && (type="KT")){
			//取片段数据
			s result = ##Class(EMR.DOC.BL.KBNode).GetKBNodeJsonByPID(rowID,.jsonCateNew,jsonCat.key)
	    }
	    else
	    {
			s result  = ##Class(EMR.DOC.BL.KBCategory).GetSectionByPID(rowID,.jsonCateNew,jsonCat.key)
		}
	    s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q strRes
}

/// Desc:       获取文档片段操作数据
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argUserCode 用户Code
/// Output:     成功：1 失败：     -101 用户不存在  -102 用户未维护角色 
///             				   -301 文档管理操作数据为空
ClassMethod GetOperationJson(argParentCode As %String, argUserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
#;	s objUser = ##Class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(objUser="") "-101"
#;	q:(objUser.RoleID="") "-102"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-102"

	s strRoleID = RoleID
	s jsonObj  = ##class(%DynamicObject).%New()
 	s strRPRowID = ""

	//添加右键授权数据
	s jsonFuncMenuNode = ##class(%DynamicObject).%New()
	//添加按钮授权数据
	s arrayFuncBtn = ##class(%DynamicArray).%New()
	s rowFuncItemID = ""
	for {
		s rowFuncItemID = $o(^CT.EMR.DOC.DictFunctionI("IdxParentCode"," "_$zcvt(argParentCode,"U"),rowFuncItemID))
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
	        s:(objFunItem.FuncCode="menu_doc_kb_root") jsonFuncMenuNode.root = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_doc_kb_category") jsonFuncMenuNode.category = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_doc_kb_document") jsonFuncMenuNode.document = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_doc_kb_section") jsonFuncMenuNode.section = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_doc_kb_kbtree") jsonFuncMenuNode.kbtree = jsonFuncMenu
	        s:(objFunItem.FuncCode="menu_doc_kb_node") jsonFuncMenuNode.node = jsonFuncMenu
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
	q strRes
}

/// Desc:       添加目录
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:   DTOCategory 文档片段DTO对象
/// Output:     成功：1 失败：     -101 数据操作失败 -102章节下有分类节点不允许建子章节
///             				   -200 必填项校验失败 -201 id未传  -202 名称未传
/// 							   -301 文档片段目录数据不存在，检查参数id -302 项目标识数据不存在，检查参数id
ClassMethod AddCategoryJson(DTOCategory As EMR.DOC.DTO.KBCategory, UserCode As %String, roleCode As %String) As %String
{
	q:(DTOCategory="") "-200"
	q:(DTOCategory.ParentID="") "-201"
	q:(DTOCategory.Name="") "-202"
	TSTART
	s obj = ##class(CF.EMR.DOC.KBCategory).%New()
	s ChildCount = 0

	
		//目录下有文档节点不允许添加目录
		s count = 0
			&SQL(select Count(*) into :count from CF_EMR_DOC.KBCategory WHERE ParentID = :DTOCategory.ParentID  AND KBCategoryTypes in (SELECT b.ID FROM CF_EMR_DOC.KBCategoryTypes b WHERE b.Code = 'DOCUMENT'  ) )
		if (count>0)
		{
			TROLLBACK
			q "-102"
		}
		//目录上添加目录
		s ObjCategory = ##class(CF.EMR.DOC.KBCategory).%OpenId(DTOCategory.ParentID)
		if (ObjCategory="")
		{
			TROLLBACK
			q "-301"
		}	
		s obj.ParentID = DTOCategory.ParentID
		s obj.Product = ObjCategory.Product
		//检查节点下有几个子节点
	
		&SQL(select Count(*) into:SectionCount from CF_EMR_DOC.KBCategory where ParentID = :DTOCategory.ParentID)
	
	s CategoryTypesID = $O(^CF.EMR.DOC.KBCategoryTypesI("IdxCode"," CATEGORY",""))
	if (CategoryTypesID="") {
		TROLLBACK
		q "-303"
	}
	s CategoryTypes = ##class(CF.EMR.DOC.KBCategoryTypes).%OpenId(CategoryTypesID)
	if (CategoryTypes=""){
		TROLLBACK
		q "-303"
	}
	
	
	s obj.Name = DTOCategory.Name
	s obj.Description = DTOCategory.Description
	s obj.KBCategoryTypes = CategoryTypes
	s obj.CategorySeq = ChildCount+1
	if ('(obj.%Save()=1))
	{
		TROLLBACK
		q "-101"	
	}
	//添加片段目录成功 设置角色的数据权限
	s role = ##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	s RoleID =""
	s:(role'="") RoleID=role
	if (RoleID=""){
		TROLLBACK
		s strRes = "-104"
		q strRes
	}
	s DataID = obj.%Id()
	s ProductID = ""
	s:obj.Product'="" ProductID = obj.Product.%Id()
	s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(RoleID,DataID,"KB",DTOCategory.KBCategoryTypes,obj.Name,ProductID)
	if (isOk'="1"){
		TROLLBACK
		s strRes = "-103"
		q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:      添加根节点目录
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_MANAGE","params":{"id": "12||CG","childType":"CG","name":"","description":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddRootCategoryJson(product As %String, name As %String, desc As %String)
{
	s objCate=##class(CF.EMR.DOC.KBCategory).%New()
	s objCate.Description=desc
	s objCate.Name=name
	s objProcudt=##class(CT.EMR.DOC.Products).%OpenId(product)
	s objCate.Product=objProcudt
	s objCate.ParentID=0
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.KBCategoryTypes where Code = "Root")
	s objType=##class(CF.EMR.DOC.KBCategoryTypes).%OpenId(rootID)
	s objCate.KBCategoryTypes=objType
	s sc=objCate.%Save()
}

/// Desc:       添加文档
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:   DTOCategory 文档片段DTO对象
/// Output:     成功：1 失败：     -101 数据操作失败 -102 目录下有目录节点不允许建文档
///             				   -200 必填项校验失败 -201 id未传  -202 名称未传
/// 							   -301 文档片段目录数据不存在，检查参数id -302 业务数据模型文档目录不存在 -303 文档类型记录不存在，检查数据源
ClassMethod AddDocumentJson(DTOCategory As EMR.DOC.DTO.KBCategory, UserCode As %String, roleCode As %String) As %String
{
	q:(DTOCategory="") "-200"
	q:(DTOCategory.ParentID="") "-201"
	q:(DTOCategory.Name="") "-202"
	q:(UserCode="") "-203"
	TSTART
	s obj = ##class(CF.EMR.DOC.KBCategory).%New()
	//目录下有目录节点不允许添加文档
	s count = 0
	&SQL(select Count(*) into :count from CF_EMR_DOC.KBCategory WHERE ParentID = :DTOCategory.ParentID  AND KBCategoryTypes in (SELECT b.ID FROM CF_EMR_DOC.KBCategoryTypes b WHERE b.Code = 'CATEGORY'  ) )
	if (count>0)
	{
		TROLLBACK
		q "-102"
	}
	//目录上添加文档
	s ObjCategory = ##class(CF.EMR.DOC.KBCategory).%OpenId(DTOCategory.ParentID)
	if (ObjCategory="")
	{
		TROLLBACK
		q "-301"
	}	
	s ResChildCount = ObjCategory.ResChildCount
	s:ResChildCount="" ResChildCount=0
	s ObjCategory.ResChildCount = ResChildCount+1
	if ('(ObjCategory.%Save()=1))
	{
		TROLLBACK
		q "-101"	
	}
	if (DTOCategory.BDMCategory'="")
	{
		s ObjBDMCategory = ##class(CF.EMR.DOC.BDMCategory).%OpenId(DTOCategory.BDMCategory)
		if ((ObjBDMCategory="")||($ZCVT(ObjBDMCategory.StructType.Code,"U")'="DOCUMENT"))
		{
			TROLLBACK
			q "-302"	
		}
		s obj.BDMCategory = ObjBDMCategory
	}
	s CategoryTypesID = $O(^CF.EMR.DOC.KBCategoryTypesI("IdxCode"," DOCUMENT",""))
	if (CategoryTypesID="") {
		TROLLBACK
		q "-303"
	}
	s CategoryTypes = ##class(CF.EMR.DOC.KBCategoryTypes).%OpenId(CategoryTypesID)
	if (CategoryTypes=""){
		TROLLBACK
		q "-303"
	}
	//检查节点下有几个子节点
	s ChildCount = 0
	&SQL(select Count(*) into:SectionCount from CF_EMR_DOC.KBCategory where ParentID = :DTOCategory.ParentID)
	
	s obj.KBCategoryTypes = CategoryTypes
	s obj.ParentID = DTOCategory.ParentID
	s obj.Product = ObjCategory.Product
	s obj.Name = DTOCategory.Name
	s obj.Description = DTOCategory.Description
	s obj.ResChildCount = 0
	s obj.CategorySeq = ChildCount+1
	if ('(obj.%Save()=1))
	{
		TROLLBACK
		q "-101"	
	}
	//添加片段文档成功 设置角色的数据权限
	s role = ##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	s RoleID =""
	s:(role'="") RoleID=role
	if (RoleID=""){
		TROLLBACK
		s strRes = "-104"
		q strRes
	}
	s DataID = obj.%Id()
	s ProductID = ""
	s:obj.Product'="" ProductID = obj.Product.%Id()
	s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(RoleID,DataID,"KB","DT",obj.Name,ProductID)
	if (isOk'="1"){
		TROLLBACK
		s strRes = "-103"
		q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       添加章节(子章节)
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      SectionDTO 章节DTO对象
/// Output:     成功：1 失败：     -101 数据操作失败 -102章节下有分类节点不允许建子章节 -103 不支持的AType类型 -104 添加权限失败
///             				   -200 必填项校验失败 -201 ParentID -202 Name -203 AType
/// 							   -301 业务数据文档节点不存在，检查参数id -302 文档片段章节类型数据不存在，检查数据源 -303 章节节点数据不存在
ClassMethod AddSectionJson(SectionDTO As EMR.DOC.DTO.KBCategory, AType As %String = "", AUserCode = "", roleCode As %String) As %String
{
	q:(SectionDTO="") "-200"
	q:(SectionDTO.ParentID="") "-201"
	q:(SectionDTO.Name="") "-202"
	q:(AType="") "-203"
	TSTART
	s Product=""
	s SectionObj = ##class(CF.EMR.DOC.KBCategory).%New()
	if (AType="DT")
	{
		s ObjParent = ##class(CF.EMR.DOC.KBCategory).%OpenId(SectionDTO.ParentID)
		if ((ObjParent="")||($ZCVT(ObjParent.KBCategoryTypes.Code,"U")'="DOCUMENT")) {
			TROLLBACK
			q "-301"
		}
		s ResChildCount = ObjParent.ResChildCount
		s:ResChildCount="" ResChildCount=0
		s ObjParent.ResChildCount = ResChildCount+1
		if '(ObjParent.%Save())
		{
	 		TROLLBACK 
			q "-101"
		}
		s Product = ObjParent.Product
		s SectionObj.ParentID = SectionDTO.ParentID
	}
	elseif(AType="ST")
	{		
		s ObjParent = ##class(CF.EMR.DOC.KBCategory).%OpenId(SectionDTO.ParentID)
		if ((ObjParent="")||($ZCVT(ObjParent.KBCategoryTypes.Code,"U")'="SECTION")){
			TROLLBACK
			q "-303"	
		}
		if (ObjParent.ResChildCount>0)
		{
			//章节下有分类节点不允许建子章节
			TROLLBACK
			q "-102"	
		}
		s SectionObj.ParentID = SectionDTO.ParentID
		s Product = ObjParent.Product
	}else{
			//不支持的节点类型
			TROLLBACK
			q "-103"	
	}
	//检查节点下有几个章节
	s SectionCount = 0
	&SQL(select Count(*) into:SectionCount from CF_EMR_DOC.KBCategory where ParentID = :SectionDTO.ParentID)
	
	s CategoryTypesID = $O(^CF.EMR.DOC.KBCategoryTypesI("IdxCode"," SECTION",""))
	if (CategoryTypesID="") {
		TROLLBACK
		q "-302"
	}
	s CategoryTypes = ##class(CF.EMR.DOC.KBCategoryTypes).%OpenId(CategoryTypesID)
	if (CategoryTypes=""){
		TROLLBACK
		q "-302"
	}
	s SectionObj.KBCategoryTypes = CategoryTypes
	s SectionObj.Name = SectionDTO.Name
	s SectionObj.Description = SectionDTO.Description
	s SectionObj.Product = Product
	s SectionObj.ResChildCount = 0
	s SectionObj.CategorySeq = SectionCount+1
	if '(SectionObj.%Save())
	{
	 	TROLLBACK 
		q "-101"
	}
	//添加片段章节成功 设置角色的数据权限
	s role = ##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	s RoleID =""
	s:(role'="") RoleID=role
	if (RoleID=""){
		TROLLBACK
		s strRes = "-104"
		q strRes
	}
	s DataID = SectionObj.%Id()
	s ProductID = ""
	s:SectionObj.Product'="" ProductID = SectionObj.Product.%Id()
	s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(RoleID,DataID,"KB","ST",SectionObj.Name,ProductID)
	if (isOk'="1"){
		TROLLBACK
		s strRes = "-104"
		q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       章节节点上添加分类
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      SectionDTO 章节DTO对象
/// Output:     成功：1 失败：     -101 数据操作失败 -103 没有匹配的AType -104 添加权限失败
///             				   -200 必填项校验失败
/// 								-301 章节节点数据有误，检查参数id -302 分类节点KBTREE类型不存在 -303 分类节点数据有误，检查参数id
ClassMethod AddKBTreeJson(KBTreeDTO As EMR.DOC.DTO.KBCategory, AType As %String = "", AUserCode As %String, roleCode As %String) As %String
{
	q:((KBTreeDTO="")||(KBTreeDTO.ParentID="")||(KBTreeDTO.Name="")||(AType="")) "-200"	
	TSTART
	s KBTreeObj = ##class(CF.EMR.DOC.KBCategory).%New()
	s ParentObj = ##class(CF.EMR.DOC.KBCategory).%OpenId(KBTreeDTO.ParentID)
	if ((AType="ST"))
	{
		if (((ParentObj="")||($ZCVT(ParentObj.KBCategoryTypes.Code,"U")'="SECTION"))){
			//章节下添加分类
			TROLLBACK
			q "-301"
		}
		//章节下有非分类节点不能添加分类
		s sectionCount = 0
		&SQL(select count(*) into :sectionCount from CF_EMR_DOC.KBCategory where ParentID = :KBTreeDTO.ParentID and KBCategoryTypes !="4")
		if (sectionCount>0)
		{
			TROLLBACK
			q "-105"
		}
		
	}
	elseif ((AType="KT"))
	{
		if (((ParentObj="")||($ZCVT(ParentObj.KBCategoryTypes.Code,"U")'="KBTREE"))){
			//分类下添加分类
			TROLLBACK
			q "-303"
		}	
	}
	else
	{
		TROLLBACK
		q "-103"
	}
	/*检查节点下有几个分类*/
	s KBTreeCount = 0
	&SQL(select Count(*) into:KBTreeCount from CF_EMR_DOC.KBCategory where ParentID = :KBTreeDTO.ParentID)
	
	s CategoryTypesID = $O(^CF.EMR.DOC.KBCategoryTypesI("IdxCode"," KBTREE",""))
	if (CategoryTypesID="") {
		TROLLBACK
		q "-302"
	}
	s CategoryTypes = ##class(CF.EMR.DOC.KBCategoryTypes).%OpenId(CategoryTypesID)
	if (CategoryTypes=""){
		TROLLBACK
		q "-302"
	}
	s KBTreeObj.KBCategoryTypes = CategoryTypes
	s KBTreeObj.Name = KBTreeDTO.Name
	s KBTreeObj.Description = KBTreeDTO.Description
	s KBTreeObj.ParentID = KBTreeDTO.ParentID
	s KBTreeObj.Product = ParentObj.Product
	s KBTreeObj.ResChildCount = 0
	s KBTreeObj.CTLoc=KBTreeDTO.CTLoc
	s KBTreeObj.Disease=KBTreeDTO.Disease
	s KBTreeObj.CategorySeq = KBTreeCount+1
	if (AType="ST"){
		s ReschildCount = 0
		s:(ParentObj.ResChildCount>0) ReschildCount=ParentObj.ResChildCount
		s ParentObj.ResChildCount = ReschildCount+1
		if '(ParentObj.%Save())
		{
	 		TROLLBACK 
			q "-101"
		}
	}
	if '(KBTreeObj.%Save())
	{
	 	TROLLBACK 
		q "-101"
	}
	//添加片段章节成功 设置角色的数据权限
	s role = ##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	s RoleID =""
	s:(role'="") RoleID=role
	if (RoleID=""){
		TROLLBACK
		s strRes = "-104"
		q strRes
	}
	s DataID = KBTreeObj.%Id()
	s ProductID = ""
	s:KBTreeObj.Product'="" ProductID = KBTreeObj.Product.%Id()
	s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(RoleID,DataID,"KB","KT",KBTreeObj.Name,ProductID)
	if (isOk'="1"){
		TROLLBACK
		s strRes = "-104"
		q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       更新章节节点和分类节点
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      KBCategoryDTO CategoryDTO对象 Atype: "ST" 章节节点更新  KT: 分类节点更新  
/// Output:     成功：1 失败：     -101 数据操作失败 -102 只能在文档节点下添加章节 -103 只能在章节节点下添加分类 -104 章节下有子章节时不允许添加分类
/// 								   -200 必填项校验
///    							   -301 章节数据不存在 -302 业务模型文档数据不存在 -303 parentId 对应章节数据不存在
ClassMethod UpdateCategoryJson(KBCategoryDTO As EMR.DOC.DTO.KBCategory, AType As %String = "", Loc As %String = "", Disease As %String = "")
{
	q:(KBCategoryDTO="") "-200"
	q:(KBCategoryDTO.ID="") "-201"
	q:(KBCategoryDTO.Name="") "-202"
	q:(AType="") "-203"
	Tstart
	s ObjCategory = ##class(CF.EMR.DOC.KBCategory).%OpenId(KBCategoryDTO.ID)
	q:(ObjCategory="") "-301"
	if (AType="CG"){
		//剪切
	}
	elseif (AType="DT")
	{
		if (KBCategoryDTO.BDMCategory'="")
		{
			s ObjBDMCategory = ##class(CF.EMR.DOC.BDMCategory).%OpenId(KBCategoryDTO.BDMCategory)
			q:(ObjBDMCategory="") "-302"
			q:($ZCVT(ObjBDMCategory.StructType.Code,"U") '="DOCUMENT") "-302"
			s ObjCategory.BDMCategory = ObjBDMCategory
		}
		
	}
	elseif (AType="ST")
	{
		//剪切
		if ((KBCategoryDTO.ParentID'="")&&(KBCategoryDTO.ParentID'=ObjCategory.ParentID)){
			s ObjParent = ##class(CF.EMR.DOC.KBCategory).%OpenId(KBCategoryDTO.ParentID)
			q:ObjParent="" "-302"
			q:($ZCVT(ObjParent.KBCategoryTypes.Code,"U")'="DOCUMENT") "-102"
			s ObjCategory.ParentID = KBCategoryDTO.ParentID
			s ObjCategory.Product = ObjParent.Product
		}
	}elseif(AType="KT")
	{
		//剪切
		if ((KBCategoryDTO.ParentID'="")&&(KBCategoryDTO.ParentID'=ObjCategory.ParentID)){
			s ObjParent = ##class(CF.EMR.DOC.KBCategory).%OpenId(KBCategoryDTO.ParentID)
			q:ObjParent="" "-303"
			q:($ZCVT(ObjParent.KBCategoryTypes.Code,"U")'="SECTION") "-103"
			/*检查章节节点下是否有子章节*/
			s count = 0
			&SQL(select Count(*) from CF_EMR_DOC.KBCategory where ParentID = :KBCategoryDTO.ParentID)
			q:(count>0) "-104"
			
			s ObjOldParent = ##class(CF.EMR.DOC.KBCategory).%OpenId(ObjCategory.ParentID)
			if (Loc="ALL")
			{
				s ObjParent.CTLoc=null
			}
			
			s ObjOldParent.ResChildCount = ObjOldParent.ResChildCount-1
			if ('(ObjOldParent.%Save())){
				TROLLBACK
				q "-101"	
			}
			s ObjCategory.ParentID = KBCategoryDTO.ParentID
			s resChildCount = 0
			s:(ObjParent.ResChildCount>0) resChildCount=ObjParent.ResChildCount
			s ObjParent.ResChildCount = resChildCount+1
			if ('(ObjParent.%Save())){
				TROLLBACK
				q "-101"	
			}
		}	
	}
	if (Loc="ALL")
	{
		s ObjCategory.CTLoc=""
	}else{
		s ObjCategory.CTLoc=Loc
	}
	s ObjCategory.Name = KBCategoryDTO.Name
	s ObjCategory.Disease=Disease
	s ObjCategory.Description = KBCategoryDTO.Description
	if '(ObjCategory.%Save()) {
		TROLLBACK
		q "-101"	
	}
	TCOMMIT
	q "1"
}

/// Desc:       删除章节节点和分类节点
/// Creator:    duan
/// CreateDate: 2021-05-10
/// Input:      ACategoryID 节点ID  AType ST 删除章节 KT 删除分类
/// Output:     成功：1 失败：-101 数据操作失败 -102 AType为空 -103 章节节点下有子数据不允许删除 -104 分类节点下有子数据不允许删除  -105 不支持的AType
/// 						  -200 id参数未传
/// 						  -301 章节节点数据为空 -302 分类节点数据为空
ClassMethod DeleteCategoryJson(ACategoryID As %String, AType As %String = "")
{
	q:(ACategoryID="") "-200"
	q:(AType="") "-102"
	TSTART
	if (AType="CG")
	{
		s ObjCategory = ##class(CF.EMR.DOC.KBCategory).%OpenId(ACategoryID)
		if (ObjCategory="") 
		{
			TROLLBACK
			q "-301"
		}
		//节点下有子节点时不允许删除
		s childCount = 0
		&SQL(select Count(*) into:childCount from CF_EMR_DOC.KBCategory where ParentID = :ACategoryID)
		if (childCount>0) 
		{
			TROLLBACK
			q "-103"
		}
		if ('(ObjCategory.%DeleteId(ACategoryID))){
			TROLLBACK 
			q "-101"	
		}
		TCOMMIT
		q "1"
	}
	elseif (AType="DT")
	{
		s ObjDocument= ##class(CF.EMR.DOC.KBCategory).%OpenId(ACategoryID)
		if (ObjDocument="") 
		{
			TROLLBACK
			q "-301"
		}
		//节点下有子节点时不允许删除
		s childCount = 0
		&SQL(select Count(*) into:childCount from CF_EMR_DOC.KBCategory where ParentID = :ACategoryID)
		if (childCount>0) 
		{
			TROLLBACK
			q "-103"
		}
		//修改目录的resChildCount
		s ObjParent = ##class(CF.EMR.DOC.KBCategory).%OpenId(ObjDocument.ParentID)
		s ParResChildCount = 0
		s:(ObjParent.ResChildCount="") ParResChildCount = 0
		s:(ObjParent.ResChildCount>0) ParResChildCount = ObjParent.ResChildCount-1
		s ObjParent.ResChildCount = ParResChildCount
		if '(ObjParent.%Save())
		{
			TROLLBACK 
			q "-101"	
		}
		if ('(ObjDocument.%DeleteId(ACategoryID))){
			TROLLBACK 
			q "-101"	
		}
		TCOMMIT
		q "1"
	}
	elseif (AType="ST")
	{
		s ObjSection = ##class(CF.EMR.DOC.KBCategory).%OpenId(ACategoryID)
		if (ObjSection="") 
		{
			TROLLBACK
			q "-301"
		}
		//章节下有数据时不允许删除
		s childCount = 0
		&SQL(select Count(*) into:childCount from CF_EMR_DOC.KBCategory where ParentID = :ACategoryID)
		if (childCount>0) 
		{
			TROLLBACK
			q "-103"
		}
		//如果章节的父节点是文档，需要修改文档的resChildCount
		s ObjParent = ##class(CF.EMR.DOC.KBCategory).%OpenId(ObjSection.ParentID)
		if (ObjParent="")
		{
			TROLLBACK 
			q "-302"
		}
		s ParResChildCount = ObjParent.ResChildCount
		s:ParResChildCount="" ParResChildCount=0
		s:ParResChildCount>0 ParResChildCount = ParResChildCount-1
		s ObjParent.ResChildCount = ParResChildCount
		if '(ObjParent.%Save())
		{
			TROLLBACK 
			q "-101"	
		}
		if ('(ObjSection.%DeleteId(ACategoryID))){
			TROLLBACK 
			q "-101"	
		}
		TCOMMIT
		q "1"
	}
	elseif(AType="KT")
	{
		s ObjKBTree = ##class(CF.EMR.DOC.KBCategory).%OpenId(ACategoryID)
		if (ObjKBTree="") 
		{
			TROLLBACK
			q "-302"
		}
		//分类下有子分类时不允许删除
		s childCount = 0
		&SQL(select Count(*) into:childCount from CF_EMR_DOC.KBCategory where ParentID = :ACategoryID)
		if (childCount>0) 
		{
			TROLLBACK
			q "-104"
		}
		//分类下有片段时不允许删除
		s childNodeCount = 0
		&SQL(select Count(*) into:childNodeCount from CF_EMR_DOC.KBNode where KBCategory = :ACategoryID)
		if (childNodeCount>0) 
		{
			TROLLBACK
			q "-104"
		}
		s ObjParent = ##Class(CF.EMR.DOC.KBCategory).%OpenId(ObjKBTree.ParentID)
		if ($ZCVT(ObjParent.KBCategoryTypes.Code,"U")="SECTION")
		{
			s ObjParent.ResChildCount = ObjParent.ResChildCount-1
			if '(ObjParent.%Save())
			{
				TROLLBACK 
				q "-101"	
			}
		}
		if ('(ObjKBTree.%DeleteId(ACategoryID)))
		{
			TROLLBACK
			q "-101"	
		}
		TCOMMIT 
		q "1"
	}
	else
	{
		TROLLBACK
		q "-105"
	}
}

}
