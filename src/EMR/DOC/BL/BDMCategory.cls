/// 名称:EMR.DOC.BL.BDMCategory
/// 描述:通用文档管理模块 Document(Doc) 业务数据模型业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BDMCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取业务数据模型目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"action":"GET_BDMDOCTREE_BYDOCID","args":{"DataTypes":"TEMPLATE","TemplateID":"1"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBDMDocTreeByDocID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataTypes = "TEMPLATE"
	s TemplateID = argInJson.params.TemplateID
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).GetBDMDocTreeByDocIDJson(TemplateID,DataTypes,.argOutData)
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
	q ..SetOutMessage(argOutMessage,"ERROR",$zerror)
}

/// Desc:       根据用户获取业务数据模型目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_BDM_DATATREE","params":{"dataTypes":"BDM","userCode":"YS01","getDataType":"","dataID":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBDMDataTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DataTypes = "BDM"
	s UserCode = argInJson.params.userCode
	s GetDataType = $case(argInJson.params.getDataType,"":"ALL",:argInJson.params.getDataType)
	s DataID = ..GetIDByKey(argInJson.params.dataID)
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).GetBDMDataTreeJson(UserCode,DataTypes,GetDataType,DataID,roleCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","用户code必传,检查参数userCode",2)
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
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取模板操作相关数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_BDM_OPERATION","params":{"userCode":"YS01"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetBDMOperation(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ParentCode = "MENU_DOCDATA_BDM"
	s UserCode = argInJson.params.userCode
	s roleCode=argInJson.params.safeGroupId
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).GetBDMOperationJson(ParentCode,UserCode,roleCode,.argOutData)
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
/// Input:      argArray  	命令参数 {"action":"ADD_BDM_CATEGORY","params":{"code":"EMR03","name":"EMR03 门急诊处方","description":"门急诊处方","parentId":"1","glossaryItemIds":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddBDMCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMCategory).%New()
	s argDTO.ParentType=..GetTypeByKey(argInJson.params.id)
	s argDTO.Code = argInJson.params.code
	s argDTO.Name = argInJson.params.title
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID =..GetIDByKey(argInJson.params.id)
	s argDTO.GlossaryItemIDS = argInJson.params.glossaryItemIds
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).AddBDMCategoryJson(argDTO)
    //失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空， -300 未查到目录，-301 未查到项目标识，-302 目录类型未查到， -400 编码已存在
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
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)	
	}
	elseif (strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","名称不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","根据目录ID未查到目录",2)	
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未查到项目标识",2)	
	}
	elseif (strRes = "-302")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录类型未查到",2)	
	}
	elseif (strRes = "-400")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_BDM_CATEGORY","params":{"id":"1","code":"EMR03","name":"EMR03门急诊处方1","description":"门急诊处方1","parentId":"1","glossaryItemIds":""},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpBDMCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMCategory).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.Code = argInJson.params.code
	s argDTO.Name = argInJson.params.title
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID = ..GetIDByKey(argInJson.params.parentId)
	s argDTO.GlossaryItemIDS = argInJson.params.glossaryItemIds
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).UpBDMCategoryJson(argDTO)
    //失败:-100 更新失败, -200 ID不能为空，-201 编码不能为空， -300 未查到目录，-400 编码已存在
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)	
	}
	elseif (strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)	
	}
	elseif (strRes = "-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)	
	}
	elseif (strRes = "-300")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)	
	}
	elseif (strRes = "-400")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)	
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
/// Input:      argArray  	命令参数 {"action":"DEL_BDM_TEMPLATE","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelBDMCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).DelBDMCategoryJson(strID)
    d argOutData.Write(strRes)
    //失败:-100 删除失败, -200 ID不能为空 -300 未查到目录,-500 包含子节点不能删除
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)
	}
	elseif(strRes = "-500")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","包含子节点不能删除",2)
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加模板
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"ADD_BDM_TEMPLATE","params":{"code":"EMR03","name":"EMR03 门急诊处方","description":"门急诊处方","parentId":"1","glossaryItemIds":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddBDMTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMCategory).%New()
	s argDTO.Code = argInJson.params.code
	s argDTO.Name = argInJson.params.title
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID = ..GetIDByKey(argInJson.params.id)
	s argDTO.GlossaryItemIDS = argInJson.params.glossaryItemIds
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).AddBDMTemplateJson(argDTO)
    //失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空， -300 未查到目录，-301 未查到项目标识，-302 目录类型未查到， -400 编码已存在
	if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)	
	}
	elseif (strRes = "-201")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","根据目录ID未查到目录",2)	
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未查到项目标识",2)	
	}
	elseif (strRes = "-302")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","目录类型未查到",2)	
	}
	elseif (strRes = "-400")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)	
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       更新模板
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"UP_BDM_TEMPLATE","params":{"id":"1","code":"EMR03","name":"EMR03门急诊处方1","description":"门急诊处方1","parentId":"1","glossaryItemIds":""},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpBDMTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMCategory).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.Code = argInJson.params.code
	s argDTO.Name = argInJson.params.title
	s argDTO.Description = argInJson.params.description
	s argDTO.ParentID = ..GetIDByKey(argInJson.params.parentId)
	s argDTO.GlossaryItemIDS = argInJson.params.glossaryItemIds
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).UpBDMTemplateJson(argDTO)
    d argOutData.Write(strRes)
    //失败:-100 跟新失败, -200 ID不能为空，-201 编码不能为空， -300 未查到目录，-400 编码已存在
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)	
	}
	elseif (strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)	
	}
	elseif (strRes = "-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)	
	}
	elseif (strRes = "-300")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)	
	}
	elseif (strRes = "-400")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)	
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除模板
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"DEL_BDM_CATEGORY","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelBDMTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).DelBDMTemplateJson(strID)
    d argOutData.Write(strRes)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到模板,-301 未查到模板目录,-500 包含子节点不能删除
    if (strRes = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
	elseif(strRes = "-200")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)
	}
	elseif(strRes = "-300")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到模板",2)
	}
	elseif(strRes = "-301")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到模板目录",2)
	}
	elseif(strRes = "-500")
	{  
	   q ..SetOutMessage(argOutMessage,"ERROR","包含子节点不能删除",2)
	}
	else
	{
		q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加章节
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"ADD_BDM_SECTION","params":{"code":"S004","name":"主诉","description":"门急诊主诉","parentId":"28","isFixedSection":"True","glossaryItemIds":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddBDMSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMCategory).%New()
	s argDTO.Code = argInJson.params.node.attrs.code
	s argDTO.Name = argInJson.params.node.attrs.name
	s argDTO.Description = argInJson.params.node.attrs.description
	s argDTO.ParentID = ..GetIDByKey(argInJson.params.id)
	s argDTO.IsFixedSection = argInJson.params.isFixedSection
	s glossary = argInJson.params.node.attrs.glossary
	TSTART
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).AddBDMSectionJson(argDTO,argInJson,argInData,argOutMessage,argOutData)
    //失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空， -300 未查到目录，-301 未查到项目标识，-302 目录类型未查到， -400 编码已存在 -101 术语集关联失败
	if (strRes>0)
	{
		s argOutMessage.success = ..#OK
		s argOutMessage.data = strRes
	}
	elseif(strRes = "-100")
	{ 
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","添加失败",2)
	}
	elseif (strRes = "-200")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","目录ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)	
	}
	elseif (strRes = "-300")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","根据目录ID未查到目录",2)	
	}
	elseif (strRes = "-301")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","未查到项目标识",2)	
	}
	elseif (strRes = "-302")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","目录类型未查到",2)	
	}
	elseif (strRes = "-400")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)	
	}
	elseif (strRes = "-101")
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录出错",2)
	}
	//添加术语关联
	if (glossary'=""){
		s argInJson.params.id = strRes
		s argInJson.params.glossary = glossary
		s res= ##Class(EMR.DOC.BL.BDMCategory).AddSectionGlossary(argInJson,argInData,argOutMessage,argOutData)	
	}
	if (argOutMessage.errcode=""){
		TCOMMIT
		q argOutMessage
	}else{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","关联术语集失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新章节
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"UP_BDM_SECTION","params":{"id":"1210","code":"S004","name":"主诉1","description":"门急诊主诉1","parentId":"28","isFixedSection":"True","glossaryItemIds":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpBDMSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.BDMCategory).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.Code = argInJson.params.node.attrs.code
	s argDTO.Name = argInJson.params.node.attrs.name
	s argDTO.Description = argInJson.params.node.attrs.description
	s argDTO.ParentID = ..GetIDByKey(argInJson.params.parentId)
	s argDTO.IsFixedSection = argInJson.params.isFixedSection
	s node = argInJson.params.node
	s glossary = argInJson.params.node.attrs.glossary
	TSTART
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).UpBDMSectionJson(argDTO, node)
    //失败:-100 跟新失败, -200 ID不能为空，-201 编码不能为空， -300 未查到目录，-400 编码已存在
    if (strRes=1){
	    s argOutMessage.success = ..#OK
	}
    elseif (strRes = "-100")
	{ 
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)	
	}
	elseif (strRes = "-200")
	{  
		TROLLBACK
	    q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)	
	}
	elseif (strRes = "-201")
	{  
		TROLLBACK
	    q ..SetOutMessage(argOutMessage,"ERROR","编码不能为空",2)	
	}
	elseif (strRes = "-300")
	{  
		TROLLBACK
	    q ..SetOutMessage(argOutMessage,"ERROR","未查到目录",2)	
	}
	elseif (strRes = "-400")
	{  
		TROLLBACK
	    q ..SetOutMessage(argOutMessage,"ERROR","编码已存在",2)	
	}
	else
	{
		TROLLBACK
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)	
	}
	//更新术语关联
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	s argInJson.params.glossary = glossary
	s res = ..UpdateSectionGlossary(argInJson,argInData,argOutMessage,argOutData)
	if (argOutMessage.errcode=""){
		TCOMMIT
		q argOutMessage
	}else{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","更新术语集失败",2)
	}
	
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除章节
/// Creator:    yejian
/// CreateDate: 2021-4-2
/// Input:      argArray  	命令参数 {"action":"DEL_BDM_CATEGORY","params":{"id":1},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelBDMSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	TSTART
	//删除术语关联
	s strID = ..GetIDByKey(argInJson.params.id)
	s strRes = ##class(EMR.DOC.BL.BDMCategory).DeleteGlossaryJson(strID,"ST")
	if (strRes=1){
		s argOutMessage.success = ..#OK 	
	}
	elseif(strRes=-201)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AType不能为空",2)
	}
	elseif(strRes=-200)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AID不能为空",2)
	}
	elseif(strRes=-202)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AGlossary不能为空",2)
	}
	elseif(strRes=-102)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","获取DocumentID失败",2)
	}
	elseif(strRes=-104)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","删除术语关联失败",2)
	}
	elseif(strRes=-301)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","元素对象不存在（ID）",2)
	}
    s strRes = ##Class(EMR.DOC.BL.BDMCategory).DelBDMSectionJson(strID)
    //失败:-100 删除失败, -200 ID不能为空, -300 未查到模板,-301 未查到模板目录,-500 包含子节点不能删除
    if (strRes = "-100")
	{ 
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
	elseif(strRes = "-200")
	{  
		TROLLBACK
	   q ..SetOutMessage(argOutMessage,"ERROR","ID不能为空",2)
	}
	elseif(strRes = "-300")
	{
		TROLLBACK  
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到模板",2)
	}
	elseif(strRes = "-301")
	{
		  TROLLBACK
	   q ..SetOutMessage(argOutMessage,"ERROR","未查到模板目录",2)
	}
	elseif(strRes = "-500")
	{
		TROLLBACK  
	   q ..SetOutMessage(argOutMessage,"ERROR","包含子节点不能删除",2)
	}
	else
	{
		TCOMMIT
		q argOutMessage.success = ..#OK
	}
	q 1
Error
	TROLLBACK  
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// desc 添加章节的时候添加术语集关联
ClassMethod AddSectionGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	if (argInJson.params.%GetTypeOf("glossary")'="array"){
		q ..SetOutMessage(argOutMessage,"ERROR","glossary必须为数组",2)
	}
	// 章节ID
	s SectionID = argInJson.params.id
	s glossary = argInJson.params.glossary
	// output 成功 1  失败 -201 AType不能为空  -200 AID　不能为空 AGlossary 不能为空
	// 						-101 获取术语集关联名失败 -102 获取DocumentID失败 -103 添加术语集关联失败
   	TSTART
   	s strRes = ..AddGlossaryJson(SectionID,glossary,"ST","BDM",..#ST)
   	if (strRes=1){
	   	TCOMMIT
		q argOutMessage.success = ..#OK 	
	}
	elseif(strRes=-201)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AType不能为空",2)
	}
	elseif(strRes=-200)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AID不能为空",2)
	}
	elseif(strRes=-202)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","AGlossary不能为空",2)
	}
	elseif(strRes=-101)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","获取术语集关联名失败",2)
	}
	elseif(strRes=-102)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","获取DocumentID失败",2)
	}
	elseif(strRes=-103)
	{
		TROLLBACK
		q ..SetOutMessage(argOutMessage,"ERROR","添加术语集关联失败",2)
	}
Error
	TROLLBACK
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// desc 业务数据模型更新元素的术语关联 
ClassMethod UpdateSectionGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	if (argInJson.params.%GetTypeOf("glossary")'="array"){
		q ..SetOutMessage(argOutMessage,"ERROR","glossary必须为数组",2)
	}
	
	s SectionID = argInJson.params.id
	s glossary = argInJson.params.glossary
	// output 成功 1  失败 -201 AType不能为空  -200 AID　不能为空  -202AGlossary 不能为空
	// 						-301 元素对象不存在（ID）
	// 					-101 获取关联术语显示名称失败  -102 获取DocumentID失败 -103 添加术语关联失败 -104 删除术语关联失败
	s strRes = ..UpdateGlossaryJson(SectionID,glossary,"ST","BDM",..#ST)
	if (strRes=1){
		q argOutMessage.success = ..#OK 	
	}
	elseif(strRes=-201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AType不能为空",2)
	}
	elseif(strRes=-200)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AID不能为空",2)
	}
	elseif(strRes=-202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AGlossary不能为空",2)
	}
	elseif(strRes=-101)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取术语集关联名失败",2)
	}
	elseif(strRes=-102)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取DocumentID失败",2)
	}
	elseif(strRes=-103)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","添加术语集关联失败",2)
	}
	elseif(strRes=-104)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","删除术语关联失败",2)
	}
	elseif(strRes=-301)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素对象不存在（ID）",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// desc: 删除章节（元素）的时候删除术语集关联
ClassMethod DeleteSectionGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s SectionID = ..GetIDByKey(argInJson.params.id)
	// output 成功 1  失败  -201 AType不能为空  -200 AID　不能为空 AGlossary 不能为空
	// 						-301 元素对象不存在（ID）
	// 				   		-102 获取DocumentID失败 -104 删除术语关联失败
	s strRes = ..DeleteGlossaryJson(SectionID,"ST")
	if (strRes=1){
		q argOutMessage.success = ..#OK 	
	}
	elseif(strRes=-201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AType不能为空",2)
	}
	elseif(strRes=-200)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AID不能为空",2)
	}
	elseif(strRes=-202)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","AGlossary不能为空",2)
	}
	elseif(strRes=-102)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取DocumentID失败",2)
	}
	elseif(strRes=-104)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","删除术语关联失败",2)
	}
	elseif(strRes=-301)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","元素对象不存在（ID）",2)
	}
}

/// Desc:       获取业务数据模型目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      TemplateID	模板ID
/// Input:      DataTypes  授权数据类型
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BDMCategory).GetBDMDocTreeByDocIDJson("1","TEMPLATE",.argOutData)
ClassMethod GetBDMDocTreeByDocIDJson(aTemplateID As %String, DataTypes As %String, ByRef argOutData As %GlobalBinaryStream) As %String
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
    s jsonRoot.Name ="文档结构("_objProduct.ProductName_")"
    s jsonRoot.Sequence = 0
    s jsonRoot.Type = "RT"
	
	s jsonCategory = ##class(%DynamicArray).%New()
	//如果关联业务数据模型，获取对应关联文档，否则获取所有
	s strBDMDocID = ##Class(EMR.DOC.BL.Template).GetBDMDocIDbyTemID(aTemplateID)
	s strBDMDocID = "57"
	if (strBDMDocID '="-1")
	{
		d ##Class(EMR.DOC.BL.BDMCategory).GetJsonDocmentByID(strBDMDocID,strProductID,.jsonCategory)
	}
	else
	{
		d ##Class(EMR.DOC.BL.BDMCategory).GetJsonCategroyByID(0,strProductID,.jsonCategory)	
	}
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
/// Output:     q ##Class(EMR.DOC.BL.BDMCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonDocmentByID(aDocmentId As %String, aProductID As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
			
	s objCat = ##Class(CF.EMR.DOC.BDMCategory).%OpenId(aDocmentId)
    q:(objCat="") res
    s jsonCat  = ##class(%DynamicObject).%New()
    s jsonCat.ID = aDocmentId
    s jsonCat.Code = objCat.Code
    s jsonCat.Name = objCat.Name
    s jsonCat.Type = objCat.StructType.Code
    s jsonCat.Description = objCat.Description
	s jsonCat.ResChildCount = objCat.ResChildCount
    s jsonCat.Sequence = aDocmentId
	s jsonCateNew = ##class(%DynamicArray).%New()
	
	s result = ##Class(EMR.DOC.BL.BDMCategory).GetJsonCategroyByID(aDocmentId,aProductID,.jsonCateNew)
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
/// Output:     q ##Class(EMR.DOC.BL.BDMCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, aProductID As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.BDMCategoryI("IdxProParentId",aProductID," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.BDMCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.ID = rowCID
	    s jsonCat.Code = objCat.Code
	    s jsonCat.Name = objCat.Name
	    s jsonCat.Type = objCat.StructType.Code
	    s jsonCat.Description = objCat.Description
		s jsonCat.ResChildCount = objCat.ResChildCount
	    s jsonCat.Sequence = rowCID
	    
		s jsonCateNew = ##class(%DynamicArray).%New()

		if (rowCID =199)
		{
			s str = ""
		}
		if ((objCat.ResChildCount'=0)&&(objCat.StructType.Code="Section"))
		{
			//获取简单元素
			s result = ##Class(EMR.DOC.BL.BDMSimpleElements).GetSimpleJsonByPID(rowCID,.jsonCateNew)
			//获取复合元素
			s result = ##Class(EMR.DOC.BL.BDMCompositeElements).GetCompositeJsonByPID(rowCID,.jsonCateNew)
		}
		else
		{	
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.BDMCategory).GetJsonCategroyByID(rowCID,aProductID,.jsonCateNew)
		}
		s jsonCat.Nodes = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       获取业务数据模型树结构
/// Creator:    yejian
/// CreateDate: 2021-3-25
/// Input:      argUserCode 用户编码
/// 		    DataTypes  授权数据类型
/// 		    GetDataType：ALL 获取所有数据，CG 获取数据到目录，DT 获取数据到文档节点
/// 		    aDataID 文档节点ID或目录节点ID
/// OutPut:     成功 1 失败 -200 用户code必传
/// 						-301 未获取到用户  -302 用户未关联角色  -303 角色未关联项目标识
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BDMCategory).GetBDMDataTreeJson("YS01","BDM",.argOutData)
ClassMethod GetBDMDataTreeJson(argUserCode As %String, DataTypes As %String, GetDataType As %String, aDataID As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(roleCode="") 
	s jsonArr = ##class(%DynamicArray).%New()
#;	s userObj = ##class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(userObj="") "-301"
#;	q:(userObj.RoleID="") "-302"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-302"

	s products = ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(roleCode)
	q:(products.%Size()=0) "-303"
	if (aDataID="")
	{
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.BDMTypes where Code = "Root")
	q:(rootID="") strRes
		set iter = products.%GetIterator()
		while iter.%GetNext(.key , .objProduct) {
			s ProductID = objProduct.%Id()
	        s jsonRoot  = ##class(%DynamicObject).%New()
	        s cateID=""
	    	&sql(select ID into :cateID from CF_EMR_DOC.BDMCategory where Product = :ProductID and StructType = :rootID)
	    	continue:(cateID="")
	    	s objRoot=##class(CF.EMR.DOC.BDMCategory).%OpenId(cateID)
	        s jsonRoot.code =objRoot.Code
	        s jsonRoot.key=cateID_"||RT"
	        s jsonRoot.value=objRoot.Code_"||RT"
	        s jsonRoot.title =objRoot.Name
	        s jsonRoot.sequence = 0
	        s jsonRoot.description=objRoot.Description
	        s jsonRoot.type = "RT"
			s jsonCategory = ##class(%DynamicArray).%New()
			s DataTypes = $zcvt(DataTypes,"U")
			d ##Class(EMR.DOC.BL.BDMCategory).GetBDMCategroyByID(cateID,ProductID,GetDataType,.jsonCategory)
			s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
			d jsonArr.%Push(jsonRoot)	
		}
	}else
	{
		s objCate = ##class(CF.EMR.DOC.BDMCategory).%OpenId(aDataID)
		q:(objCate="")
		s GetDataType="ALL"
		s jsonCategory = ##class(%DynamicArray).%New()
		s ProductID= objCate.Product.%Id()
		d ##Class(EMR.DOC.BL.BDMCategory).GetBDMCategroyByCID(aDataID,ProductID,GetDataType,.jsonCategory)	
		s:jsonCategory.%Size()>0 jsonArr=jsonCategory
	}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// Desc:      添加根节点目录
/// Creator:    duan
/// CreateDate: 2021-05-07
/// Input:      argArray  命令参数 {"action":"ADD_KB_MANAGE","params":{"id": "12||CG","childType":"CG","name":"","description":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddRootCategoryJson(product As %String, name As %String, desc As %String)
{
	s objCate=##class(CF.EMR.DOC.BDMCategory).%New()
	s objCate.Description=desc
	s objCate.Name=name
	
	s objProcudt=##class(CT.EMR.DOC.Products).%OpenId(product)
	s objCate.Product=objProcudt
	s objCate.Code=objProcudt.ProductCode
	s objCate.ParentID=0
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.BDMTypes where Code = "Root")
	s objType=##class(CF.EMR.DOC.BDMTypes).%OpenId(rootID)
	s objCate.StructType=objType
	s sc=objCate.%Save()
}

/// Desc:       递归获取目录数据
/// Creator:    yejian
/// CreateDate: 2021-3-25
/// Input:      aParentId 目录ID
///             aProduct 项目标识
/// 		    GetDataType：ALL 获取所有数据，CG 获取数据到目录，DT 获取数据到文档节点
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.BDMCategory).GetBDMCategroyByID(0,1,1,)
ClassMethod GetBDMCategroyByID(aParentId As %String, aProductID As %String, GetDataType As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.BDMCategoryI("IdxProParentId",aProductID," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.BDMCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    ;s type = ..FormatType(objCat.StructType.Code)
	    s type=""
	    if (objCat.StructType.Code="Category")
	    {
		    s type="CG"
		}
		elseif (objCat.StructType.Code="Document")
		{
			s type="DT"
		}elseif (objCat.StructType.Code="Section")
		{
			s type="ST"
		}
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.value=rowCID_"||"_type
	    s jsonCat.code = objCat.Code
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    s jsonCat.description = objCat.Description
		s jsonCat.resChildCount = objCat.ResChildCount
	    s jsonCat.sequence = objCat.Sequence
	    if (type="ST"){
		    s jsonCat.node = ""
			s:objCat.DataAttributes'="" jsonCat.node = ##class(%DynamicAbstractObject).%FromJSON(objCat.DataAttributes)   
		}
	    //获取数据到目录
	    q:(GetDataType="CG")&&(objCat.StructType.Code="Document")
	    //获取数据到文档
	    q:(GetDataType="DT")&&(objCat.StructType.Code="Section")
	    if (type="DT")
		{
			s ID = objCat.GlossaryItemIDS
			if (ID'=""){
				s jsonCat.glossaryItemIDS = ""
				s jsonCat.glossaryItemTitle = ""
				s GlossaryCategory = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(..GetIDByKey(ID))
				s:GlossaryCategory'="" jsonCat.glossaryItemIDS = ID
				s:GlossaryCategory'="" jsonCat.glossaryItemTitle = GlossaryCategory.Name	
			}else{
				s jsonCat.glossaryItemIDS = ""
				s jsonCat.glossaryItemTitle = ""
			}
			
		}
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if ((objCat.ResChildCount'=0)&&(objCat.StructType.Code="Section"))
		{
			//获取简单元素
			s result = ##Class(EMR.DOC.BL.BDMSimpleElements).GetSimpleJsonByPID(rowCID,.jsonCateNew)
			//获取复合元素
			s result = ##Class(EMR.DOC.BL.BDMCompositeElements).GetCompositeJsonByPID(rowCID,.jsonCateNew)
		}
		else
		{
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.BDMCategory).GetBDMCategroyByID(rowCID,aProductID,GetDataType,.jsonCateNew)
		}
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       根据ID获取数据
/// Creator:    yejian
/// CreateDate: 2021-3-25
/// Input:      aParentId 目录ID
///             aProductID 项目标识
/// 		    GetDataType：ALL 获取所有数据，CG 获取数据到目录，DT 获取数据到文档节点
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.BDMCategory).GetBDMCategroyByID(0,1,1,)
ClassMethod GetBDMCategroyByCID(aParentId As %String, aProductID As %String, GetDataType As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = aParentId			
	s objCat = ##Class(CF.EMR.DOC.BDMCategory).%OpenId(rowCID)
    q:(objCat="")
    q:(objCat.Product.%Id()'=aProductID)
    s jsonCat  = ##class(%DynamicObject).%New()
    s type = ..FormatType(objCat.StructType.Code)
    s jsonCat.key = rowCID_"||"_type
    s jsonCat.code = objCat.Code
    s jsonCat.title = objCat.Name
    s jsonCat.type = type
    s jsonCat.description = objCat.Description
	s jsonCat.resChildCount = objCat.ResChildCount
    s jsonCat.sequence = objCat.Sequence
    if (type="ST"){
	    s jsonCat.node = ""
		s:objCat.DataAttributes'="" jsonCat.node = ##class(%DynamicAbstractObject).%FromJSON(objCat.DataAttributes)    
	}
    if (type="DT")
		{
			s ID = objCat.GlossaryItemIDS
			if (ID'=""){
				s jsonCat.glossaryItemIDS = ""
				s jsonCat.glossaryItemTitle = ""
				s GlossaryCategory = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(ID)
				s:GlossaryCategory'="" jsonCat.glossaryItemIDS = ID
				s:GlossaryCategory'="" jsonCat.glossaryItemTitle = GlossaryCategory.Name	
			}else{
				s jsonCat.glossaryItemIDS = ""
				s jsonCat.glossaryItemTitle = ""
			}
			
		}
	s jsonCateNew = ##class(%DynamicArray).%New()

	if ((objCat.ResChildCount'=0)&&(objCat.StructType.Code="Section"))
	{
		//获取简单元素
		s result = ##Class(EMR.DOC.BL.BDMSimpleElements).GetSimpleJsonByPID(rowCID,.jsonCateNew)
		//获取复合元素
		s result = ##Class(EMR.DOC.BL.BDMCompositeElements).GetCompositeJsonByPID(rowCID,.jsonCateNew)
	}
	else
	{	
		//根据目录获取模板数据
		s result = ##Class(EMR.DOC.BL.BDMCategory).GetBDMCategroyByID(rowCID,aProductID,GetDataType,.jsonCateNew)
	}
	s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
	d jsonCategory.%Push(jsonCat)	
	
	q res
}

/// Desc:       获取模板操作
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      ParentCode  功能字典目录编码
/// 			UserCode	用户编码
/// OutPut:     argOutData 	返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BDMCategory).GetBDMOperationJson("MENU_DOCDATA_BDM","YS01",.argOutData)
ClassMethod GetBDMOperationJson(ParentCode As %String, UserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
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
	        s:(objFunItem.FuncCode="MENU_DOCDATA_BDM_root") jsonFuncMenuNode.root = jsonFuncMenu
	        s:(objFunItem.FuncCode="MENU_DOCDATA_BDM_category") jsonFuncMenuNode.category = jsonFuncMenu
	        s:(objFunItem.FuncCode="MENU_DOCDATA_BDM_document") jsonFuncMenuNode.document = jsonFuncMenu
	        s:(objFunItem.FuncCode="MENU_DOCDATA_BDM_section") jsonFuncMenuNode.section = jsonFuncMenu
	        s:(objFunItem.FuncCode="MENU_DOCDATA_BDM_element") jsonFuncMenuNode.element = jsonFuncMenu
	        s:(objFunItem.FuncCode="MENU_DOCDATA_BDM_complex") jsonFuncMenuNode.complex = jsonFuncMenu
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

/// Desc:       添加目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空， -300 未查到目录，-301 未查到项目标识，
/// 						  -302 目录类型未查到， -400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).AddBDMCategoryJson()
ClassMethod AddBDMCategoryJson(argDTO As EMR.DOC.DTO.BDMCategory) As %String
{
	s strRes ="-100"
	q:(argDTO.ParentID = "") "-200"
	q:(argDTO.Code = "") "-201"
	q:(argDTO.Name="") "-202" 
	s obj = ##class(CF.EMR.DOC.BDMCategory).%New()
	s intParentID = +(argDTO.ParentID)

		//在父目录下添加子目录
		s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ParentID)
		q:(objParent="") "-300"
		s obj.Product = objParent.Product
		s obj.ParentCode = objParent.Code
		s obj.ParentID = intParentID
	
	s strBDMTypeID = $o(^CF.EMR.DOC.BDMTypesI("IdxCode"," "_$zcvt("Category","U"),""))
	q:(strBDMTypeID="") "-302"
	s objBDMTypes = ##Class(CF.EMR.DOC.BDMTypes).%OpenId(strBDMTypeID)
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCategoryI("IdxProPCode",intProductID," "_intParentID," "_$zcvt(argDTO.Code,"U"),""))
	q:(isHas'="") "-400"

	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s obj.StructType = objBDMTypes
	s obj.ResChildCount = 0
	s sequence=0
	&sql(select max(Sequence)into :sequence from CF_EMR_DOC.BDMCategory)
	s obj.Sequence = sequence +1
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
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 编码不能为空， -300 未查到目录，-400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).UpBDMCategoryJson()
ClassMethod UpBDMCategoryJson(argDTO As EMR.DOC.DTO.TemplateCategory) As %String
{
	s strRes = "-100"
	q:((argDTO.Name="")||(argDTO.ID="")) "-200"
	q:(argDTO.Code = "") "-201" 
	s obj = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ID)
	q:(obj="") "-200"
	s intParentID = +(argDTO.ParentID)
	if ((intParentID>0)&&(intParentID'=obj.ParentID)){
		//在父目录下添加子目录
		s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ParentID)
		q:(objParent="") "-300"
		s obj.ParentID = intParentID
		s obj.Product = objParent.Product
		s obj.ParentCode = objParent.Code
	}else{
		s intParentID = obj.ParentID	
	}
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCategoryI("IdxProPCode",intProductID," "_intParentID," "_$zcvt(argDTO.Code,"U"),""))
	q:((isHas'="")&&(isHas'=argDTO.ID)) "-400"
	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		 q strRes
	}
}

/// Desc:       删除文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空 -300 未查到目录,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).DelBDMCategoryJson("1")
ClassMethod DelBDMCategoryJson(argCategoryID As %String) As %String
{
	s strRes = "-100"
	q:(argCategoryID="") "-200"
	if (##class(CF.EMR.DOC.BDMCategory).%ExistsId(argCategoryID))	
	{
		s strNodesCount = 0
		&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.BDMCategory c WHERE c.ParentID = :argCategoryID)
		q:(strNodesCount >0) "-500"
		s sc = ##class(CF.EMR.DOC.BDMCategory).%DeleteId(argCategoryID)
		if '(sc)
		{
			q strRes
		}
		else
		{
			q "1"	
		}
	}
	else	  
	{
		q "-300"
	}
}

/// Desc:       添加模板
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  模板对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空， -300 未查到目录
/// 						  -301 模板类型未查到， -400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).AddBDMCategoryJson()
ClassMethod AddBDMTemplateJson(argDTO As EMR.DOC.DTO.BDMCategory) As %String
{
	s strRes ="-100"
	TSTART
	if ((argDTO.Code = "")|| (argDTO.Name = "")||(argDTO.GlossaryItemIDS = "") )
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.BDMCategory).%New()
	s intParentID = +(argDTO.ParentID)
	//在父目录下添加子目录
	s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ParentID)
	if (objParent="")
	{
		TROLLBACK
		q "-300"
	}
	s obj.Product = objParent.Product
	s obj.ParentCode = objParent.Code
		
	s strBDMTypeID = $o(^CF.EMR.DOC.BDMTypesI("IdxCode"," "_$zcvt("Document","U"),""))
	if (strBDMTypeID="") 
	{
		TROLLBACK
		q "-300"
	}
	s objBDMTypes = ##Class(CF.EMR.DOC.BDMTypes).%OpenId(strBDMTypeID)
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCategoryI("IdxProPCode",intProductID," "_intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if (isHas'="")
	{
		TROLLBACK
		q "-400"
	}
	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.ParentID = intParentID
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s obj.StructType = objBDMTypes
	s obj.ResChildCount = 0
	s obj.Sequence = +(^CF.EMR.DOC.BDMCategoryD)+1
	s objParent.ResChildCount=objParent.ResChildCount+1
	s sc = objParent.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	
	TCOMMIT
	q obj.%Id()
}

/// Desc:       更新模板
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 编码不能为空， -300 未查到目录，-400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).UpBDMCategoryJson()
ClassMethod UpBDMTemplateJson(argDTO As EMR.DOC.DTO.TemplateCategory) As %String
{
	s strRes = "-100"
	TSTART
	if ((argDTO.Code = "")|| (argDTO.Name = "")||(argDTO.GlossaryItemIDS = "")) 
	{
		TROLLBACK
		q "-200"
	}
	if (argDTO.Code = "") 
	{
		TROLLBACK
		q "-201"
	}
	s obj = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ID)
	if (obj="") 
	{
		TROLLBACK
		q "-200"
	}
	s intParentID = +(argDTO.ParentID)
	//在父目录下添加子目录
	;s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ParentID)
	;if (objParent="")
	;{
		;TROLLBACK
		;q "-300"
	;}
	;s obj.Product = objParent.Product
	;s obj.ParentCode = objParent.Code
	

	if ((intParentID>0)&&(intParentID'=obj.ParentID)){
		//在父目录下添加子目录
		s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ParentID)
		q:(objParent="") "-300"
		s obj.ParentID = intParentID
		s obj.Product = objParent.Product
		s obj.ParentCode = objParent.Code
	}else{
		s intParentID = obj.ParentID	
	}
	
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCategoryI("IdxProPCode",intProductID," "_intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if ((isHas'="")&&(isHas'=argDTO.ID))
	{
		TROLLBACK
		q "-400"
	}

	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.ParentID = intParentID
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       删除模板
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到模板,-301 未查到模板目录,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).DelBDMCategoryJson("1")
ClassMethod DelBDMTemplateJson(argTemplateID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if (argTemplateID="")
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argTemplateID)
	if (obj="")  
	{
		TROLLBACK
		q "-300"
	}
	s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(obj.ParentID)
	if (objParent="")  
	{
		TROLLBACK
		q "-301"
	}
	s strNodesCount = 0
	&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.BDMCategory c WHERE c.ParentID = :argTemplateID)
	if (strNodesCount >0) 
	{
		TROLLBACK
		q "-500"
	}
	s objParent.ResChildCount = objParent.ResChildCount-1
	s sc = objParent.%Save()
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	s sc = ##class(CF.EMR.DOC.BDMCategory).%DeleteId(argTemplateID)
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       添加模板
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  模板对象
/// OutPut:     返回数据 成功：ID,
/// 					 失败:-100 添加失败, -200 目录ID不能为空，-201 编码不能为空， -300 未查到目录
/// 						  -301 模板类型未查到， -400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).AddBDMCategoryJson()
ClassMethod AddBDMSectionJson(argDTO As EMR.DOC.DTO.BDMCategory, argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes ="-100"
	TSTART
	if (argDTO.ParentID = "") 
	{
		TROLLBACK
		q "-200"
	}
	if (argDTO.Code = "") 
	{
		TROLLBACK
		q "-201"
	}
	s obj = ##class(CF.EMR.DOC.BDMCategory).%New()
	s intParentID = +(argDTO.ParentID)
	//在父目录下添加子目录
	s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ParentID)
	if (objParent="")
	{
		TROLLBACK
		q "-300"
	}
	s obj.Product = objParent.Product
	s obj.ParentCode = objParent.Code
	
	s strBDMTypeID = $o(^CF.EMR.DOC.BDMTypesI("IdxCode"," "_$zcvt("section","U"),""))
	if (strBDMTypeID="") 
	{
		TROLLBACK
		q "-300"
	}
	s objBDMTypes = ##Class(CF.EMR.DOC.BDMTypes).%OpenId(strBDMTypeID)
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCategoryI("IdxProPCode",intProductID," "_intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if (isHas'="")
	{
		TROLLBACK
		q "-400"
	}
	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.ParentID = intParentID
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s obj.IsFixedSection = argDTO.IsFixedSection
	s obj.StructType = objBDMTypes
	s obj.ResChildCount = 0
	s sequence=0
	&sql(select max(Sequence) into :sequence from CF_EMR_DOC.BDMCategory)
	s obj.Sequence = sequence+1
	s objParent.ResChildCount=objParent.ResChildCount+1
	s obj.DataAttributes = argInJson.params.node.%ToJSON()
	s sc = objParent.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	TCOMMIT
	q obj.%Id()
}

/// Desc:       更新模板
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argDTO  目录对象
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 跟新失败, -200 ID不能为空，-201 编码不能为空， -300 未查到目录，-400 编码已存在
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).UpBDMCategoryJson()
ClassMethod UpBDMSectionJson(argDTO As EMR.DOC.DTO.TemplateCategory, argNode As %DynamicObject) As %String
{
	s strRes = "-100"
	TSTART
	if (argDTO.ID="") 
	{
		TROLLBACK
		q "-200"
	}
	if (argDTO.Code = "") 
	{
		TROLLBACK
		q "-201"
	}
	s obj = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argDTO.ID)
	if (obj="") 
	{
		TROLLBACK
		q "-200"
	}
	s intParentID = argDTO.ParentID
	//在父目录下添加子目录
	if ((intParentID'="")&&(intParentID'=obj.ParentID)){
		s intParentID = +(intParentID)
		s objNewParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(intParentID)
		if (objNewParent="")
		{
			TROLLBACK
			q "-300"
		}
		s objOldParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(obj.ParentID)
		if (objOldParent="")
		{
			TROLLBACK
			q "-300"
		}
		s objOldParent.ResChildCount = objOldParent.ResChildCount-1
		s scOld = objOldParent.%Save()
		if ('$$$ISOK(scOld))
		{
			 TROLLBACK
			 q "-300"
		}
		s resChildCount = 0
		s:(objNewParent.ResChildCount'="") resChildCount=objNewParent.ResChildCount
		
		s objNewParent.ResChildCount = resChildCount+1
		s scNew = objNewParent.%Save()
		if ('$$$ISOK(scNew))
		{
			 TROLLBACK
			 q "-300"
		}
		s obj.Product = objNewParent.Product
		s obj.ParentCode = objNewParent.Code
	}else{
		s intParentID = obj.ParentID	
	}
	
	
	s intProductID = obj.Product.%Id()
	s isHas = $o(^CF.EMR.DOC.BDMCategoryI("IdxProPCode",intProductID," "_intParentID," "_$zcvt(argDTO.Code,"U"),""))
	if ((isHas'="")&&(isHas'=argDTO.ID))
	{
		TROLLBACK
		q "-400"
	}

	s obj.Code = argDTO.Code
	s obj.Name = argDTO.Name
	s obj.Description = argDTO.Description
	s obj.ParentID = intParentID
	s obj.IsFixedSection = argDTO.IsFixedSection
	s obj.GlossaryItemIDS = argDTO.GlossaryItemIDS
	s obj.DataAttributes = argNode.%ToJSON()
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		 TROLLBACK
		 q strRes
	}
	TCOMMIT
	q "1"
}

/// Desc:       删除模板
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argCategoryID  文档目录ID
/// OutPut:     返回数据 成功：1,
/// 					 失败:-100 删除失败, -200 ID不能为空, -300 未查到模板,-301 未查到模板目录,-500 包含子节点不能删除
/// Debug:      w ##Class(EMR.DOC.BL.BDMCategory).DelBDMCategoryJson("1")
ClassMethod DelBDMSectionJson(argTemplateID As %String) As %String
{
	s strRes = "-100"
	TSTART
	if (argTemplateID="")
	{
		TROLLBACK
		q "-200"
	}
	s obj = ##class(CF.EMR.DOC.BDMCategory).%OpenId(argTemplateID)
	if (obj="")  
	{
		TROLLBACK
		q "-300"
	}
	s objParent = ##class(CF.EMR.DOC.BDMCategory).%OpenId(obj.ParentID)
	if (objParent="")  
	{
		TROLLBACK
		q "-301"
	}
	s strNodesCount = 0
	&sql(SELECT count(*) into:strNodesCount  FROM CF_EMR_DOC.BDMCategory c WHERE c.ParentID = :argTemplateID)
	if (strNodesCount >0) 
	{
		TROLLBACK
		q "-500"
	}
	s objParent.ResChildCount = objParent.ResChildCount-1
	s sc = objParent.%Save()
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	s sc = ##class(CF.EMR.DOC.BDMCategory).%DeleteId(argTemplateID)
	if '(sc)
	{
		TROLLBACK
		q strRes
	}
	TCOMMIT
	q "1"
}

/// desc 根据ID获取术语集关联的业务数据模型的名称
/// debug ##class(EMR.DOC.BL.BDMCategory).GetNameById()
ClassMethod GetNameById(ID As %String, AType As %String)
{
	s strRes = -1
	q:((ID="")||(AType="")) strRes
	if (AType="ST")
	{
		//取章节的结构名称
		s ObjCategory = ##class(CF.EMR.DOC.BDMCategory).%OpenId(ID)
		q:(ObjCategory="") strRes
		s Code = ObjCategory.Code
		s Name = ObjCategory.Name
		if ((ObjCategory.ParentID'="")&&(ObjCategory.ParentID>0))
		{
			s res = ..GetNameById(ObjCategory.ParentID,"ST")
			q:(res=-1) strRes
			s strRes = res_"."_Code_" "_Name
		}else{
			s strRes = Code_" "_Name
		}
	}
	elseif((AType="ET")||(AType="CT"))
	{
		// 取简单元素的结构名称
		s:AType="ET" ObjSimple = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(ID)
		s:AType="CT" ObjSimple = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(ID)
		q:(ObjSimple="") strRes
		s Code = ObjSimple.Code
		s Name = ObjSimple.Name
		s res = ..GetNameById(ObjSimple.BDMCategory.%Id(),"ST")
		q:res=-1 strRes
		s strRes = res_"."_Code_" "_Name
	}
	q strRes
}

/// desc 获取节点父级的document 层的节点ID
ClassMethod GetDocumentIDByID(ID As %String, AType As %String)
{
	s strRes = -1
	q:((ID="")||(AType="")) strRes
	if (AType="ST")
	{
		//取章节的结构名称
		s ObjCategory = ##class(CF.EMR.DOC.BDMCategory).%OpenId(ID)
		q:(ObjCategory="") strRes
		if ($ZCVT(ObjCategory.StructType.Code,"U")="DOCUMENT"){
			s strRes = ID
			q strRes	
		}
		if (ObjCategory.ParentID'=""){
			s strRes = ..GetDocumentIDByID(ObjCategory.ParentID,"ST")
		}else{
			q strRes	
		}
	}
	elseif(AType="ET")
	{
		// 取简单元素的结构名称
		s ObjSimple = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(ID)
		q:(ObjSimple="") strRes
		s strRes = ..GetDocumentIDByID(ObjSimple.BDMCategory.%Id(),"ST")
	}
	elseif(AType="CT")
	{
		// 取复杂元素的结构名称	
		s ObjComplex = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(ID)
		q:(ObjComplex="") strRes
		s strRes = ..GetDocumentIDByID(ObjComplex.BDMCategory.%Id(),"ST")
		
	}
	q strRes
}

/// desc 业务数据模型 添加术语集关联
/// input AID 章节（元素）ID AGlossary 关联的术语集数组  AType 关联元素类型 ATemType EMRDOC 文档, HFF 板式,KB 片段,BDM 业务数据模型
///       AItemType ISECTIONDESC(章节),ICOMPOSITEDESC(复合元素),ICOMPOSITESAMPLE(结构化元素) ICONCEPTDESC(医学概念),ICONCEPTSAMPLE(医学概念子元素) IMACRODESC(宏对象(存储部分医学公式,月经生育史,眼科前房深度公式)),IMACROSAMPLE(宏对象子元素)
/// output 成功 1  失败 -201 AType不能为空  -200 AID　不能为空 AGlossary 不能为空
/// 						-101 获取术语集关联名失败 -102 获取DocumentID失败 -103 添加术语集关联失败
///                     -301 数据记录不存在
ClassMethod AddGlossaryJson(AID As %String, AGlossary As %DynamicArray, AType As %String, ATemType As %String, AItemType As %String = "")
{
	q:AType="" -201
	q:AID="" -200
	q:AGlossary="" -202
	s argInJson = ##class(%DynamicObject).%New()
	s argInData = ##class(%GlobalBinaryStream).%New()
	s argOutMessage = ##class(%DynamicObject).%New()
	d ..DefaultOutMessage(argOutMessage)
	s argOutData = ##class(%GlobalBinaryStream).%New()
	s strMark = 1
	if (AType="ST"){
		s ObjSection = ##class(CF.EMR.DOC.BDMCategory).%OpenId(AID)
		q:(ObjSection="") -301
		s sectionCode = ObjSection.Code
		s Name = ..GetNameById(AID,AType)
		q:Name=-1 -101
		s DocumentID = ..GetDocumentIDByID(AID,AType)
		q:DocumentID=-1 -102
		
		set iter =AGlossary.%GetIterator()
		while iter.%GetNext(.key , .glossaryItem ) {
	      s argInJson.params=glossaryItem
	      s argInJson.params.id = DocumentID
	      s argInJson.params.glossaryID=glossaryItem.glossaryID
	      S argInJson.params.SCode = sectionCode
	      s argInJson.params.temType = ATemType
	      s:(argInJson.params.itemType="") argInJson.params.itemType= AItemType 
	      s argInJson.params.itemName = Name_"."_glossaryItem.valueText
	      d ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItem(argInJson,argInData,argOutMessage,argOutData) 
	      if (argOutMessage.errorCode'=""){
		  	s strMark=-103
		  	q    
		  }
	   	}
	}
	if ((AType="ET")||(AType="CT")){
		//简单元素术语关联
		s:AType="ET" ObjSim = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(AID)
		s:AType="CT" ObjSim = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(AID)
		q:(ObjSim="") -301
		s CSCode = ObjSim.Code
		s SCode = ..GetSectionCode(AID,AType)
		s Name = ..GetNameById(AID,AType)
		s DocumentID = ..GetDocumentIDByID(AID,AType)
		
		set iter =AGlossary.%GetIterator()
		while iter.%GetNext(.key , .glossaryItem ) {
	      s argInJson.params=glossaryItem
	      s argInJson.params.id = DocumentID
	      S argInJson.params.SCode = SCode
	      s argInJson.params.CSCode = CSCode
	      s argInJson.params.temType = ATemType
	      s:(argInJson.params.itemType="") argInJson.params.itemType= AItemType
	      s argInJson.params.itemName = Name_"."_glossaryItem.valueText
	      d ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItem(argInJson,argInData,argOutMessage,argOutData) 
	      if (argOutMessage.errorCode'=""){
		  	s strMark=-103
		  	q    
		  }
	   	}
	}
	q strMark
}

/// desc 业务数据模型 更新术语集关联
/// input AID 章节（元素）ID AGlossary 关联的术语集数组  AType 关联元素类型
/// output 成功 1  失败 -201 AType不能为空  -200 AID　不能为空 AGlossary 不能为空
/// 						-301 元素对象不存在（ID）
/// 					-101 获取关联术语显示名称失败  -102 获取DocumentID失败 -103 添加术语关联失败 -104 删除术语关联失败 -105 章节Code为空 -106 简单元素Code为空
ClassMethod UpdateGlossaryJson(AID As %String, AGlossary As %DynamicArray, AType As %String, ATemType As %String, AItemType As %String = "")
{
	q:AType="" -201
	q:AID="" -200
	q:AGlossary="" -202
	s argInJson = ##class(%DynamicObject).%New()
	s argInData = ##class(%GlobalBinaryStream).%New()
	s argOutMessage = ##class(%DynamicObject).%New()
	d ..DefaultOutMessage(argOutMessage)
	s argOutData = ##class(%GlobalBinaryStream).%New()
	s strMark = 1
	if (AType="ST"){
		s ObjSection = ##class(CF.EMR.DOC.BDMCategory).%OpenId(AID)
		q:ObjSection="" -301
		s SCode = ObjSection.Code
		q:(SCode="") -105
		s DocumentID = ..GetDocumentIDByID(AID,AType)
		q:DocumentID=-1 -102
		//删除元素的关联术语
		s CodePath = $ZCVT(SCode,"U")
	    &SQL(delete from CF_EMR_DOC.GlossaryItem where CodePath =:CodePath and DataID = :DocumentID)
	    if ((SQLCODE'=100)&&(SQLCODE'=0)&&(SQLCODE'=-106))
	    {
		    q -104
	    }
		s Name = ..GetNameById(AID,"ST")
		q:Name=-1 -101
		set iter =AGlossary.%GetIterator()
		while iter.%GetNext(.key , .glossaryItem ) {
	      s argInJson.params=glossaryItem
	      s argInJson.params.id = DocumentID
	      S argInJson.params.SCode = SCode
	      s argInJson.params.temType = ATemType
	      s:(argInJson.params.itemType="") argInJson.params.itemType = AItemType
	      s argInJson.params.itemName = Name_"."_glossaryItem.valueText
	      d ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItem(argInJson,argInData,argOutMessage,argOutData) 
	   	  if (argOutMessage.errorCode'=""){
		  	s strMark=-103
		  	q    
		  }
	   	}
	}
	elseif ((AType="ET")||(AType="CT")){
		s:AType="ET" ObjSim = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(AID)
		s:AType="CT" ObjSim = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(AID)
		q:(ObjSim="")
		q:(ObjSim="")
		s CSCode = ObjSim.Code
		q:(CSCode="") -106
		s SCode = ..GetSectionCode(AID,AType)
		q:(SCode="") -105
		s Name = ..GetNameById(AID,AType)
		q:Name=-1 -101
		s DocumentID = ..GetDocumentIDByID(AID,AType)
		q:DocumentID=-1 -102
		//删除元素的关联术语
		s CodePath = $ZCVT(SCode_"_"_CSCode,"U")
	    &SQL(delete from CF_EMR_DOC.GlossaryItem where CodePath =:CodePath and DataID = :DocumentID)
	    if ((SQLCODE'=100)&&(SQLCODE'=0)&&(SQLCODE'=-106))
	    {
		    q -104
	    }
	
		set iter =AGlossary.%GetIterator()
		while iter.%GetNext(.key , .glossaryItem ) {
	      s argInJson.params=glossaryItem
	      s argInJson.params.id = DocumentID
	      s argInJson.params.SCode = SCode
	      s argInJson.params.CSCode = CSCode
	      s argInJson.params.temType = ATemType
	      s:(argInJson.params.itemType="") argInJson.params.itemType = AItemType
	      s argInJson.params.itemName = Name_"."_glossaryItem.valueText
	      d ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItem(argInJson,argInData,argOutMessage,argOutData) 
	   	  if (argOutMessage.errorCode'=""){
		  	s strMark=-103
		  	q    
		  }
	   	}	
	}
	q:(strMark'=1) strMark
	q strMark
}

/// desc 业务数据模型 删除术语集关联
/// input AID 章节（元素）ID   AType 关联元素类型
/// output 成功 1  失败 -201 AType不能为空  -200 AID　不能为空 AGlossary 不能为空
/// 						-301 元素对象不存在（ID）
/// 				   -102 获取DocumentID失败 -104 删除术语关联失败
/// debug w ##class(EMR.DOC.BL.BDMCategory).DeleteGlossaryJson(AID,AType)
ClassMethod DeleteGlossaryJson(AID As %String, AType As %String)
{
	q:AType="" -201
	q:AID="" -200
	s res = 1
	if (AType="ST"){
		s ObjSection = ##class(CF.EMR.DOC.BDMCategory).%OpenId(AID)
		Q:ObjSection="" -301
		s DocumentID = ..GetDocumentIDByID(AID,AType)
		q:DocumentID=-1 -102
		//删除元素的关联术语
		s CodePath = ObjSection.Code
	    &SQL(delete from CF_EMR_DOC.GlossaryItem where CodePath =:CodePath and DataID = :DocumentID)
	    if ((SQLCODE'=100)&&(SQLCODE'=0)&&(SQLCODE'=-106))
	    {
		    q -104
	    }
	}
	elseif((AType="ET")||(AType="CT"))
	{
		s:AType="ET" ObjSim = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(AID)
		s:AType="CT" ObjSim = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(AID)
		q:(ObjSim="") -301
		s CSCode = ObjSim.Code
		q:(CSCode="") -106
		s SCode = ..GetSectionCode(AID,AType)
		q:(SCode="") -105
		s DocumentID = ..GetDocumentIDByID(AID,AType)
		q:DocumentID=-1 -102
		//删除元素的关联术语
		s CodePath = $ZCVT(SCode_"_"_CSCode,"U")
	    &SQL(delete from CF_EMR_DOC.GlossaryItem where CodePath =:CodePath and DataID = :DocumentID)
	    if ((SQLCODE'=100)&&(SQLCODE'=0)&&(SQLCODE'=-106))
	    {
		    q -104
	    }
	}
	q res
}

/// 获取简单元素的章节Code
ClassMethod GetSectionCode(AID As %String, AType As %String)
{
	s strRes = -1
	q:(AID="") strRes
	s:AType="ET" Obj = ##class(CF.EMR.DOC.BDMSimpleElements).%OpenId(AID)
	s:AType="CT" Obj = ##class(CF.EMR.DOC.BDMCompositeElements).%OpenId(AID)
	q:Obj="" strRes
	s ObjSection = Obj.BDMCategory
	s SectionCode = ObjSection.Code
	q SectionCode
}

/// Desc:       根据模板版本查询模板绑定的业务数据模型目录树
/// Creator:    huhao
/// CreateDate: 2022/10/24
/// Table:		
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod VersionIdBDMCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s tempversionId=argInJson.params.templateVersionId
	s UserCode=argInJson.params.userCode
	s type=argInJson.params.type
	s roleCode=argInJson.params.safeGroupId
	s strRes = ##class(EMR.DOC.BL.BDMCategory).searchBdmCG(tempversionId,type,UserCode,roleCode,.argOutData)
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
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod searchBdmCG(ID As %String, Type As %String, UserCode As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=""
	s VersionId=..GetIDByKey(ID)
	s type=Type
	if (type="design")
	{
		S BDMObj=..GetRecordId(ID)
		if (BDMObj="")
		{
			s BdmId=""
		}
		else
		{
			s BdmId=BDMObj.%Id()
			s BdmParId=BDMObj.ParentID
			q:BDMObj.Product="" "-1^业务数据模型对应项目标识不存在"
			s prcId=BDMObj.Product.%Id()
		}
	}
	elseif (type="layout")
	{
		s HFVersionObj=##class(CF.EMR.DOC.HFFormatVersion).%OpenId(VersionId)
		q:HFVersionObj="" "-1^版本号不存在"
		if (HFVersionObj.HFFormat.BDMCategory="")
		{
			s BdmId=""
		}
		else
		{
			s BdmId=HFVersionObj.HFFormat.BDMCategory.%Id()
			s BdmParId=HFVersionObj.HFFormat.BDMCategory.ParentID
			q:HFVersionObj.HFFormat.BDMCategory.Product="" "-1^业务数据模型对应项目标识不存在"
			s prcId=HFVersionObj.HFFormat.BDMCategory.Product.%Id()
		}
	}
	else{ q "-1^入参有误"}
	if (BdmId="")
	{
    	s strRes = ##Class(EMR.DOC.BL.BDMCategory).GetBDMDataTreeJson(UserCode,"BDM","ALL","",roleCode,.argOutData)
    	q "1"
	}
	else 
	{
		s strRes = ##Class(EMR.DOC.BL.BDMCategory).GetSearchBDMDataTreeJson(UserCode,prcId,BdmId,BdmParId,roleCode,.argOutData)
   		q "1"
    }
}

// 取业务活动记录id

ClassMethod GetRecordId(Id As %String) As %String
{
	s res=##class(CF.EMR.DOC.BDMCategory).%New()
	s type=..GetTypeByKey(Id)
	s id=..GetIDByKey(Id)
	if (type="IT")
	{
		s Objtemplate=..GetTmpId(id)
		q:Objtemplate=""
		s res=Objtemplate.TemplateCategory.BDMCategory
	}
	elseif (type="DT")
	{
		s res=##class(CF.EMR.DOC.Template).%OpenId(id).TemplateCategory.BDMCategory
	}
	q res
}

// 科室模板id获取模板对象

ClassMethod GetTmpId(Id As %String) As CF.EMR.DOC.Template
{
	s locTmpObj=##class(CF.EMR.DOC.LocTemplate).%OpenId(Id)
	q:locTmpObj="" ""
	if (locTmpObj.LocTemplateCategory="")
	{
		 q locTmpObj.TemplateID
	}
	elseif(locTmpObj.LocTemplateCategory'="")
	{
		 q locTmpObj.LocTemplateCategory.TemplateID
	}
}

// 获取业务数据模型关联树

ClassMethod GetSearchBDMDataTreeJson(argUserCode As %String, productId As %Integer, argID As %String, BdmParId As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(argUserCode="") "-1^userCode不能为空"
	s jsonArr = ##class(%DynamicArray).%New()
#;	s userObj = ##class(EMR.DOC.BL.RBACUser).getUserByUserCode(argUserCode)
#;	q:(userObj="") "-1^该用户没有角色授权"
#;	q:(userObj.RoleID="") "-1^授权角色不存在"
	
	s RoleID=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:(RoleID="") "-1^授权安全组不存在"

	s products = ##Class(EMR.DOC.BL.RBACRoleProduct).GetProductArrayByRoleCode(roleCode)
	q:(products.%Size()=0) "-1^该用户无可用产品标识"
	s rootID=""
	&sql(select ID into :rootID from CF_EMR_DOC.BDMTypes where Code = "Root")
	q:(rootID="") strRes
		set iter = products.%GetIterator()
		while iter.%GetNext(.key , .objProduct) {
			s ProductID = objProduct.%Id()
			continue:ProductID'=productId
	        s jsonRoot  = ##class(%DynamicObject).%New()
	        s cateID=""
	    	&sql(select ID into :cateID from CF_EMR_DOC.BDMCategory where Product = :ProductID and StructType = :rootID)
	    	continue:(cateID="")
	    	
	    	s objRoot=##class(CF.EMR.DOC.BDMCategory).%OpenId(cateID)
	        s jsonRoot.code =objRoot.Code
	        s jsonRoot.key=cateID_"||RT"
	        s jsonRoot.value=objRoot.Code_"||RT"
	        s jsonRoot.title =objRoot.Name
	        s jsonRoot.sequence = 0
	        s jsonRoot.description=objRoot.Description
	        s jsonRoot.type = "RT"
			s jsonCategory = ##class(%DynamicArray).%New()
			d ##Class(EMR.DOC.BL.BDMCategory).GetSearchBDMCategroyByID(BdmParId,ProductID,argID,.jsonCategory)
			s:(jsonCategory.%Size()>0) jsonRoot.children = jsonCategory
			d jsonArr.%Push(jsonRoot)	
		}
	d jsonArr.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

ClassMethod GetSearchBDMCategroyByID(aParentId As %String, aProductID As %String, argID As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.BDMCategoryI("IdxProParentId",aProductID," "_aParentId,rowCID))
		q:(rowCID = "")	
		s objCat = ##Class(CF.EMR.DOC.BDMCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s jsonCat  = ##class(%DynamicObject).%New()
	    ;s type = ..FormatType(objCat.StructType.Code)
	    s type=""
	    if (objCat.StructType.Code="Category")
	    {
		    s type="CG"
		}
		elseif (objCat.StructType.Code="Document")
		{
			s type="DT"
		}elseif (objCat.StructType.Code="Section")
		{
			s type="ST"
		}
		continue:((rowCID'=argID)&&(type="DT"))			
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.value=rowCID_"||"_type
	    s jsonCat.code = objCat.Code
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    s jsonCat.description = objCat.Description
		s jsonCat.resChildCount = objCat.ResChildCount
	    s jsonCat.sequence = objCat.Sequence
	    if (type="ST"){
		    s jsonCat.node = ""
			s:objCat.DataAttributes'="" jsonCat.node = ##class(%DynamicAbstractObject).%FromJSON(objCat.DataAttributes)   
		}
	    //获取数据到目录
	    if (type="DT")
		{
			s ID = objCat.GlossaryItemIDS
			if (ID'=""){
				s jsonCat.glossaryItemIDS = ""
				s jsonCat.glossaryItemTitle = ""
				s GlossaryCategory = ##class(CF.EMR.DOC.GlossaryCategory).%OpenId(..GetIDByKey(ID))
				s:GlossaryCategory'="" jsonCat.glossaryItemIDS = ID
				s:GlossaryCategory'="" jsonCat.glossaryItemTitle = GlossaryCategory.Name	
			}else{
				s jsonCat.glossaryItemIDS = ""
				s jsonCat.glossaryItemTitle = ""
			}
			
		}
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if ((objCat.ResChildCount'=0)&&(objCat.StructType.Code="Section"))
		{
			//获取简单元素
			s result = ##Class(EMR.DOC.BL.BDMSimpleElements).GetSimpleJsonByPID(rowCID,.jsonCateNew)
			//获取复合元素
			s result = ##Class(EMR.DOC.BL.BDMCompositeElements).GetCompositeJsonByPID(rowCID,.jsonCateNew)
		}
		else
		{
			//根据目录获取模板数据
			s result = ##Class(EMR.DOC.BL.BDMCategory).GetSearchBDMCategroyByID(rowCID,aProductID,argID,.jsonCateNew)
		}
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

}
