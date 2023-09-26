/// 名称:	EMR.DOC.COM.ActionFactory
/// 描述:	通用文档管理模块 Document(Doc) 公用程序层 Request数据请求代理工厂
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.ActionFactory Extends EMR.DOC.COM.ActionBase
{

/// Creator：      yejian
/// CreatDate：    2020-12-7
/// Description:   编辑器的命令工厂,解析argInMessage参数，进行分支处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"action":"LOAD_TEMPLATE","params":{"TemplateCode":"EMR090001","TepmplateVersionNumber":"1","variables":"TemplateVersionData"},"product":"GlobalEMR"}
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.COM.ActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//定义错误处理函数
	s $ZT="ERROR"
	s array = argInJson
	s strAction = array.action
	d ..DefaultOutMessage(.argOutMessage)
	//命令分发
	
	
	if (strAction = "GET_USER")         
	{	
		//获取用户信息
		d ##Class(EMR.DOC.BL.RBACUser).GetUser(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_DOC_LIST")
	{
		//获取文档列表
		d ##Class(EMR.DOC.BL.TemplateRules).GetDocRulesList(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "ADD_DOC_RULES")
	{
		//新增文档规则
		d ##Class(EMR.DOC.BL.TemplateRules).AddDocRules(array,argInData,argOutMessage,argOutData)
	}	elseif(strAction = "GET_DOC_RULES")
	{
		//获取文档规则列表
		d ##Class(EMR.DOC.BL.TemplateRules).GetDocRules(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_DOC_RULES")
	{
		//删除文档规则
		d ##Class(EMR.DOC.BL.TemplateRules).DeleteDocRules(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_DOC_RULES")
	{
		//修改文档规则
		d ##Class(EMR.DOC.BL.TemplateRules).UpdateDocRules(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "ADD_LOCTEMPLATE_MANAGE")
	{
		//科室模板统一新增目录
		d ##Class(EMR.DOC.BL.LocTemplateCategory).AddLocTemplateCategory(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "UPDATE_LOCTEMPLATE_MANAGE")
	{
		//科室模板统一更新
		d ##Class(EMR.DOC.BL.LocTemplateCategory).UpdateLocTemplateCategory(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "DELETE_LOCTEMPLATE_MANAGE")
	{
		//科室模板统一删除
		d ##Class(EMR.DOC.BL.LocTemplateCategory).DeleteLocTemplateCategory(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_LOCTEMPLATE_VERSION")
	{
		//获取科室模板版本
		d ##Class(EMR.DOC.BL.LocTemplateVersion).GetTemplateVersion(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "ADD_LOCTEMPLATE_VERSION")
	{
		//新增科室模板版本
		d ##Class(EMR.DOC.BL.LocTemplateVersion).AddLocTemplateVersion(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_LOCTEMPLATEVERSION_DATA")
	{
		//获取科室模板版本
		d ##Class(EMR.DOC.BL.LocTemplateVersion).GetTemplateVersionData(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_LOCTEMPLATE_SECTION")
	{
		//获取科室模板章节
		d ##Class(EMR.DOC.BL.LocTemplateSection).GetTemplateSection(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_LOCLATEST_VERSION")
	{
		//根据文档ID获取最新版本章节
		d ##class(EMR.DOC.BL.LocTemplateSection).GetSectionData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_LOCTEMPLATE_SECTION")
	{
		//保存科室模板章节
		d ##Class(EMR.DOC.BL.LocTemplateSection).SaveTemplateSection(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOCTEMPLATE_AUDIT")
	{
		//科室文档审核
		d ##Class(EMR.DOC.BL.LocTemplate).AuditTempalte(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_LOCTEMPLATE_TREE")
	{
		//获取科室模板TREE
		d ##Class(EMR.DOC.BL.LocTemplateCategory).GetLocTemplateTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "TEMPLATE_AUDIT")
	{
		//文档审核
		d ##Class(EMR.DOC.BL.Template).AuditTempalte(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_RECORD_TITLE")
	{
		//更新标题信息
		d ##Class(EMR.DOC.BL.Titles).UpdateTitle(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RECORD_TITLE")
	{
		//获取标题信息
		d ##Class(EMR.DOC.BL.Titles).GetTitle(array,argInData,argOutMessage,argOutData)
	}
	
	elseif(strAction = "CHEACK_USERID_LOGIC")
	{
		//用户ID验证
		d ##Class(EMR.DOC.BL.UserLogin).UserIdLogic(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CHEACK_USER_LOGIN")
	{
		//用户登录验证
		d ##Class(EMR.DOC.BL.UserLogin).Login(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_LOGININFO")
	{
		// 加载登录信息
		d ##Class(EMR.DOC.BL.UserLogin).GetEMRLoginInfo(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_PRODUCT_DATA")
	{
		//获取所有项目标识
		d ##Class(EMR.DOC.BL.Products).GetProductDatas(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_PRODUCT_DATA")
	{
		//更新项目标识
		d ##class(EMR.DOC.BL.Products).UpProductData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_PRODUCT_DATA")
	{
		//新增项目标识
		d ##Class(EMR.DOC.BL.Products).AddProductData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_PRODUCT_DATA")
	{
		//删除项目标识
		d ##class(EMR.DOC.BL.Products).DelProductData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_EMRSYSTEM_MENU")
	{
		//根据用户获取菜单权限
		d ##Class(EMR.DOC.BL.TemplateManage).GetEMRSystemMenu(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_MENU_DOC")
	{
		//获取文档管理模块tab页签
		d ##Class(EMR.DOC.BL.TemplateManage).GetMenuDoc(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEMPLATE_TREE")
	{
		//获取文档管理目录树
		d ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEMPLATE_OPERATION")
	{
		//获取文档管理操作数据
		d ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_DOC_TEMPLATE")
	{
		//文档目录管理统一添加入口
		d ##Class(EMR.DOC.BL.TemplateManage).Add(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_DOC_TEMPLATE")
	{
		//文档目录管理统一更新入口
		d ##Class(EMR.DOC.BL.TemplateManage).Update(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_DOC_TEMPLATE")	{
		//文档目录管理统一删除入口
		d ##Class(EMR.DOC.BL.TemplateManage).Delete(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "PUBLISH_DOCUMENT_VERSION")
	{
		//文档版本发布
		d ##Class(EMR.DOC.BL.TemplateVersion).PublishVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_TEMPLATE_CATEGORY")
	{
		//更新文档目录
		d ##Class(EMR.DOC.BL.TemplateCategory).UpTemplateCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_TEMPLATE_CATEGORY")
	{
		//删除文档目录
		d ##Class(EMR.DOC.BL.TemplateCategory).DelTemplateCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_TEMPLATE")
	{
		//根据文档ID加载最新模板
		d ##Class(EMR.DOC.BL.TemplateVersion).LoadTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_TEMPLATE_VERSION")
	{
		//根据版本ID加载模板
		d ##Class(EMR.DOC.BL.TemplateVersion).LoadTemplateVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEMPLATE_VERSIONS")
	{
		//根据文档ID获取历史版本信息
		d ##Class(EMR.DOC.BL.TemplateVersion).GetTemplateVersions(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_TEMPLATEBYTID")
	{
		//根据模板ID获取发布模板
		d ##Class(EMR.DOC.BL.TemplateVersion).LoadTemplateByTID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_DOCUMENT")
	{
		//创建门诊病历文档实例
		d ##class(EMR.DOC.BL.DocumentData).CreateDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DEFAULT_FIELD")
	{
		//取数据绑定值
		d ##Class(EMR.DOC.BL.BindDataSelect).LoadDefaultField(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DICTIONARY")
	{
		//获取字典数据
		d ##Class(EMR.DOC.BL.StdDictionary).LoadDictionary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CLOSE_DICTIONARY")
	{
		//清除字典数据
		d ##Class(EMR.DOC.BL.StdDictionary).CloseDictionnary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_TEMPLATE")
	{
		//创建文档
		d ##Class(EMR.DOC.BL.Template).AddTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_TEMPLATE")
	{
		//更新文档
		d ##Class(EMR.DOC.BL.Template).UpTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_TEMPLATE")
	{
		//删除文档
		d ##Class(EMR.DOC.BL.Template).DelTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_TEMPLATE_VERSION")
	{
		//创建文档版本
		d ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_TEMPLATE_VERSION")
	{
		//保存文档
		d ##Class(EMR.DOC.BL.TemplateVersion).SaveTemplateVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_TEMPLATE_VERSION")
	{
		//删除文档版本
		d ##Class(EMR.DOC.BL.TemplateVersion).DelTemplateVersion(array,argInData,argOutMessage,argOutData)
	}
	
	elseif(strAction= "GET_TEMPLATE_MLOG")
	{
		//获取文档版本修改历史
		d ##Class(EMR.DOC.BL.TemplateStatusMLog).GetTemplateStatusMLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEMTOOLBUTTONS")
	{
		//获取工具栏数据
		d ##Class(EMR.DOC.BL.TemplateDesign).GetTemToolButtons(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ELEMENTTOOLS")
	{
		//获取元素工具栏数据
		d ##Class(EMR.DOC.BL.TemplateDesign).GetElementTools(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ELEMENTPROPERTYS")
	{
		//获取元素属性栏数据
		d ##Class(EMR.DOC.BL.TemplateDesign).GetElementPropertys(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BDMDOCTREE_BYDOCID")
	{
		//获取元素工具栏中业务数据模型数据
		d ##Class(EMR.DOC.BL.BDMCategory).GetBDMDocTreeByDocID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BINDTREE_DATA")
	{
		//获取数据绑定树
		d ##Class(EMR.DOC.BL.BindQuery).GetBindTreeData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATA_TREE")
	{
		//获取数据绑定中数据集数据
		d ##Class(EMR.DOC.BL.BindQuery).GetBindDataTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATA_FIELD")
	{
		//获取数据绑定中数据元数据
		d ##Class(EMR.DOC.BL.BindField).GetDataFieldByID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_KBTREE_BYDOC")
	{
		//获取数据绑定中文档片段目录数据
		d ##Class(EMR.DOC.BL.KBCategory).GetKBTreeByDocID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_KBNODE_BYSECTION")
	{
		//获取数据绑定中文档片段数据
		d ##Class(EMR.DOC.BL.KBCategory).GetKBNodeBySectionID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GLOSSARY_BYDOC")
	{
		//获取数据绑定中术语集数据
		d ##Class(EMR.DOC.BL.GlossaryCategory).GetGlossaryByDocID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GLOSSARY_BINDVTYPES")
	{
		//获取元素值类型选项集
		d ##Class(EMR.DOC.BL.GlossaryItemValues).GetGlossaryBindVTypes(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GLOSSARYITEMS_BYGLOSSARYID")
	{
		//获取模板下所有已经关联术语的数据
		d ##Class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByGID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GLOSSARYITEM_BYELEMENT")
	{
		//获取元素关联术语
		d ##Class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemByElement(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GLOSSARYITEMS_BYID")
	{
		//获取模板下所有已经关联术语的数据
		d ##Class(EMR.DOC.BL.GlossaryItem).GetGlossaryItemsByID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARYITEM")
	{
		//添加模板元素关联术语--ADD_GLOSSARY_DOCUMENT
		d ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARYITEM_BYBDM")
	{
		//业务数据模型插入文档时关联术语
		d ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItemByBDM(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_GLOSSARYITEM")
	{
		//删除模板元素关联术语
		d ##Class(EMR.DOC.BL.GlossaryItem).DelGlossaryItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_GLOSSARYITEM_BYCODE")
	{
		//删除模板元素关联术语
		d ##Class(EMR.DOC.BL.GlossaryItem).DelGlossaryItemByCode(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BINDQUERY_DATA")
	{
		//获取数据集tree
		d ##Class(EMR.DOC.BL.BindQuery).GetBindQueryData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BINDQUERY_OPERATION")
	{
		//获取数据集操作数据
		d ##Class(EMR.DOC.BL.BindQuery).GetBindQueryOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BINDQUERY_TABLE")
	{
		//获取数据集table
		d ##Class(EMR.DOC.BL.BindQuery).GetBindQueryDataByProduct(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_BINDQUERY_DATA")
	{
		//添加数据集
		d ##Class(EMR.DOC.BL.BindQuery).AddBindQueryData(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction = "UP_BINDQUERY_DATA")
	{
		//更新数据集
		d ##Class(EMR.DOC.BL.BindQuery).UpBindQueryData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_BINDQUERY_DATA")
	{
		//删除数据集
		d ##Class(EMR.DOC.BL.BindQuery).DelBindQueryData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATA_BINDVALUES")
	{
		//获取数据集属性关联字段
		d ##Class(EMR.DOC.BL.BindQuery).GetDataBindValues(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATA_BINDQUERYTYPES")
	{
		//获取数据集查询类型
		d ##Class(EMR.DOC.BL.BindTypes).GetDataBindQueryTypes(array,argInData,argOutMessage,argOutData)
	}elseif(strAction = "GET_DATA_BINDTYPES_TABLE")
	{
		//获取数据集查询类型Table
		d ##Class(EMR.DOC.BL.BindTypes).GetBindTypesTable(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DEL_DATA_BINDTYPES")
	{
		//删除数据集查询类型
		d ##Class(EMR.DOC.BL.BindTypes).DelBindType(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UP_DATA_BINDTYPES")
	{
		//更新数据集查询类型
		d ##Class(EMR.DOC.BL.BindTypes).UpDataBindTypes(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATA_BINDVALUETYPES")
	{
		//获取数据集选项类型
		d ##Class(EMR.DOC.BL.BindValueTypes).GetDataBindValueTypes(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_DATA_BINDTYPES")
	{
		//新增数据集查询类型
		d ##class(EMR.DOC.BL.BindTypes).AddDataBindTypes(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATA_PARAMETERVALUES")
	{
		//获取数据集参数
		d ##Class(EMR.DOC.BL.BindParameterValues).GetDataParameterValues(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATA_PARAMETERVALUES_TABLE")
	{
		//获取数据集参数Table
		d ##Class(EMR.DOC.BL.BindParameterValues).GetDataParameterValuesTable(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_DATA_PARAMETERVALUE")
	{
		//添加数据集参数
		d ##Class(EMR.DOC.BL.BindParameterValues).AddDataParameterValue(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction = "UP_DATA_PARAMETERVALUE")
	{
		//更新数据集参数
		d ##Class(EMR.DOC.BL.BindParameterValues).UpDataParameterValue(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_DATA_PARAMETERVALUE")
	{
		//删除数据集参数
		d ##Class(EMR.DOC.BL.BindParameterValues).DelDataParameterValue(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BINDFIELD_DATA")
	{
		//获取数据元(表格)
		d ##Class(EMR.DOC.BL.BindField).GetDataFieldTableByID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_DATA_FIELD")
	{
		//添加数据元
		d ##Class(EMR.DOC.BL.BindField).AddDataField(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction = "UP_DATA_FIELD")
	{
		//更新数据元
		d ##Class(EMR.DOC.BL.BindField).UpDataField(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_DATA_FIELD")
	{
		//删除数据元
		d ##Class(EMR.DOC.BL.BindField).DelDataField(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BINDCODE_ISEXIST")
	{
		//判断数据集、数据元编码是否唯一
		d ##Class(EMR.DOC.BL.BindQuery).GetBindCodeIsExist(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEST_BINDVALUES")
	{
		//数据集测试
		d ##Class(EMR.DOC.BL.BindQueryTest).GetTestBindValues(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_CTLOCS")
	{
		//获取所有科室数据
		d ##Class(EMR.DOC.BL.RBACUser).GetRBACCTLocs(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_CTLOCUSERS")
	{
		//根据科室获取用户数据
		d ##Class(EMR.DOC.BL.RBACUser).GetRBACCTLocUsers(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_USERS")
	{
		//获取本系统用户数据
		d ##Class(EMR.DOC.BL.RBACUser).GetRBACUsers(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_RBAC_USER")
	{
		//添加用户
		d ##Class(EMR.DOC.BL.RBACUser).AddRBACUsers(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_RBAC_USER")
	{
		//更新用户
		d ##Class(EMR.DOC.BL.RBACUser).UpRBACUsers(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_RBAC_USER")
	{
		//删除用户
		d ##Class(EMR.DOC.BL.RBACUser).DelRBACUsers(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_ROLES")
	{
		//获取角色数据
		d ##Class(EMR.DOC.BL.RBACRole).GetRoleValues(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_ROLELIST")
	{
		//获取角色信息表，过滤掉状态为不可用的
		d ##Class(EMR.DOC.BL.RBACRole).GetRolelist(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_RBAC_ROLE")
	{
		//新增角色数据
		d ##Class(EMR.DOC.BL.RBACRole).AddRBACRole(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_RBAC_ROLE")
	{
		//更新角色数据
		d ##Class(EMR.DOC.BL.RBACRole).UpdateRBACRole(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_RBAC_ROLE")
	{
		//删除角色数据
		d ##Class(EMR.DOC.BL.RBACRole).DeleteRBACRole(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_ROLEPRODUCT")
	{
		//根据角色获取已经关联项目标识
		d ##Class(EMR.DOC.BL.RBACRoleProduct).GetRBACRoleProduct(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_RBAC_ROLEPRODUCT")
	{
		//批量更新角色项目标识
		d ##Class(EMR.DOC.BL.RBACRoleProduct).UpRBACRoleProduct(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_DICFUNCTION")
	{
		//获取所有功能操作
		d ##Class(EMR.DOC.BL.DicFunction).GetRBACDicFunction(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_ROLEOPERPERMISSION")
	{
		//根据角色获取关联的功能权限
		d ##Class(EMR.DOC.BL.RBACOperPermission).GetRBACRoleOperPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_RBAC_ROLEOPERPERMISSION")
	{
		//批量更新角色功能权限
		d ##Class(EMR.DOC.BL.RBACOperPermission).UpRBACRoleOperPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_TEMPLATEDATA")
	{
		//根据角色获取数据授权中文档管理树
		d ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACTemplateData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_KBDATA")
	{
		//根据角色获取数据授权中文档片段树目录
		d ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACKBData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_KBNODEBYSID")
	{
		//数据授权中根据章节ID获取文档片段节点
		d ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACKBNodeBYSID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_ROLEDATAPERMISSION")	
	{
		//根据角色获取关联的数据权限
		d ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACRoleDataPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_RBAC_ROLEDATAPERMISSION")	
	{
		//批量更新角色数据授权
		d ##Class(EMR.DOC.BL.RBACDataPermission).UpRBACDataPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_HFFORMAT_OPERATION")
	{
		
		//获取文档版式操作数据
		d ##class(EMR.DOC.BL.HFFormat).GetHFFormatOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_HFF_DATATREE")
	{
		
		//获取文档版式数据
		d ##class(EMR.DOC.BL.HFFormat).GetHFFormatTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_HFF_MANAGE")
	{
		//文档版式统一添加入口
		d ##class(EMR.DOC.BL.HFFormatManage).Add(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_HFF_MANAGE")
	{
		//文档版式统一更新入口
		d ##class(EMR.DOC.BL.HFFormatManage).Update(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_HFF_MANAGE")
	{
		//文档版式统一删除入口
		d ##class(EMR.DOC.BL.HFFormatManage).Delete(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "PUBLISH_HFFORMAT_VERSION")
	{
		//版式版本发布
		d ##class(EMR.DOC.BL.HFFormatVersion).PublishVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_HFFORMAT")
	{
		//更新版式
		d ##class(EMR.DOC.BL.HFFormat).UpdateHFFormat(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_HFFORMAT")
	{
		//删除版式
		d ##class(EMR.DOC.BL.HFFormat).DeleteHFFormat(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_HFFORMAT_VERSION")
	{
		//新建版本
		d ##class(EMR.DOC.BL.HFFormatVersion).AddHFVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_HFFORMAT_VERSION")
	{
		//删除版本
		d ##class(EMR.DOC.BL.HFFormatVersion).DeleteHFVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_HFFORMAT_VERSION")
	{
		//保存版式（保存版本）
		d ##class(EMR.DOC.BL.HFFormatVersion).SaveHFVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_HFFORMAT")
	{
		//加载版式（加载版本）
		d ##class(EMR.DOC.BL.HFFormatVersion).LoadHFVersion(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_HFFORMAT_MLOG")
	{
		//获取板式操作历史
		d ##Class(EMR.DOC.BL.HFFormatStatusMLog).GetHFFormatStatusMLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_BDM_DATATREE")
	{
		//获取业务数据模型数据
		d ##class(EMR.DOC.BL.BDMCategory).GetBDMDataTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BDM_OPERATION")
	{
		//获取业务数据模型操作数据
		d ##Class(EMR.DOC.BL.BDMCategory).GetBDMOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_BDM_MANAGE")
	{
		//业务数据模型统一添加
		d ##Class(EMR.DOC.BL.BDMManage).Add(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_BDM_MANAGE")
	{
		//业务数据模型统一更新
		d ##Class(EMR.DOC.BL.BDMManage).Update(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_BDM_MANAGE")
	{
		//业务数据模型统一删除
		d ##Class(EMR.DOC.BL.BDMManage).Delete(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_BDM_CATEGORY")
	{
		//添加业务数据模型目录
		d ##Class(EMR.DOC.BL.BDMCategory).AddBDMCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_BDM_CATEGORY")
	{
		//更新业务数据模型目录
		d ##Class(EMR.DOC.BL.BDMCategory).UpBDMCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_BDM_CATEGORY")
	{
		//删除业务数据模型目录
		d ##Class(EMR.DOC.BL.BDMCategory).DelBDMCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_BDM_TEMPLATE")
	{
		//添加业务数据模板
		d ##Class(EMR.DOC.BL.BDMCategory).AddBDMTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_BDM_TEMPLATE")
	{
		//更新业务数据模板
		d ##Class(EMR.DOC.BL.BDMCategory).UpBDMTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_BDM_TEMPLATE")
	{
		//删除业务数据模板
		d ##Class(EMR.DOC.BL.BDMCategory).DelBDMTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_BDM_SECTION")
	{
		//添加业务数据章节
		d ##Class(EMR.DOC.BL.BDMCategory).AddBDMSection(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_BDM_SECTION")
	{
		//更新业务数据章节
		d ##Class(EMR.DOC.BL.BDMCategory).UpBDMSection(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_BDM_SECTION")
	{
		//删除业务数据章节
		d ##Class(EMR.DOC.BL.BDMCategory).DelBDMSection(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_BDM_SIMELEMENTS")
	{
		//添加业务数据简单元素
		d ##Class(EMR.DOC.BL.BDMSimpleElements).AddBDMSimElements(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_BDM_SIMELEMENTS")
	{
		//更新业务数据简单元素
		d ##Class(EMR.DOC.BL.BDMSimpleElements).UpBDMSimElements(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_BDM_SIMELEMENTS")
	{
		//删除业务数据简单元素
		d ##Class(EMR.DOC.BL.BDMSimpleElements).DelBDMSimElements(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_BDM_COMELEMENTS")
	{
		//添加业务数据复杂元素
		d ##Class(EMR.DOC.BL.BDMCompositeElements).AddBDMComElements(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_BDM_COMELEMENTS")
	{
		//更新业务数据复杂元素
		d ##Class(EMR.DOC.BL.BDMCompositeElements).UpBDMComElements(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_BDM_COMELEMENTS")
	{
		//删除业务数据复杂元素
		d ##Class(EMR.DOC.BL.BDMCompositeElements).DelBDMComElements(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_KB_TREE")
	{
		//获取文档片段tree数据
		d ##Class(EMR.DOC.BL.KBCategory).GetKBTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_KB_OPERATION")
	{
		//获取文档片段管理操作数据
		d ##Class(EMR.DOC.BL.KBCategory).GetKBOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_KB_MANAGE")
	{
		//文档片段管理-统一添加入口
		d ##Class(EMR.DOC.BL.KBManage).Add(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_KB_MANAGE")
	{
		//文档片段管理-统一更新入口
		d ##Class(EMR.DOC.BL.KBManage).Update(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_KB_MANAGE")
	{
		//文档片段管理-统一删除入口
		d ##Class(EMR.DOC.BL.KBManage).Delete(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_KB_DOCUMENT")
	{
		//加载片段数据
		d ##Class(EMR.DOC.BL.KBNode).LoadDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_KB_DOCUMENT")
	{
		//保存片段数据
		d ##Class(EMR.DOC.BL.KBNode).SaveDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_KB_MLOG")
	{
		//获取片段修改历史
		d ##Class(EMR.DOC.BL.KBNodeStatusMLog).GetKBNodeStatusMLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_GLOSSARY_TREE")
	{
		//术语集管理-获取术语集树数据
		d ##class(EMR.DOC.BL.GlossaryCategory).GetGlossaryTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GLOSSARY_OPERATION")
	{
		//术语集管理-获取术语集树操作数据
		d ##Class(EMR.DOC.BL.GlossaryCategory).GetGlossaryOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SEARCH_GLOSSARY_TREE")
	{
		//术语集管理-术语集检索接口
		d ##Class(EMR.DOC.BL.GlossaryCategory).SearchTreeValue(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARY_DOCUMENT")
	{
		//术语集管理-术语集目录关联文档ID
		d ##Class(EMR.DOC.BL.GlossaryCategory).AddGlossaryDocumentItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARY_MANAGE")
	{
		//术语集管理-添加统一入口
		d ##Class(EMR.DOC.BL.GlossaryManage).Add(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_GLOSSARY_MANAGE")
	{
		//术语集管理-更新统一入口
		d ##Class(EMR.DOC.BL.GlossaryManage).Update(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_GLOSSARY_MANAGE")
	{
		//术语集管理-删除统一入口
		d ##Class(EMR.DOC.BL.GlossaryManage).Delete(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARYITEM_DOCUMENT")
	{
		//术语集管理-病历模板(文档元素)添加术语关联
		d ##Class(EMR.DOC.BL.Template).AddGlossaryMap(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARYITEM_BDM")
	{
		//术语集管理-病历模板(文档元素)添加术语关联
		d ##Class(EMR.DOC.BL.BDMManage).AddGlossary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARY_CATEGORY")
	{
		//术语集管理-添加目录
		d ##Class(EMR.DOC.BL.GlossaryCategory).AddGlossaryCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_GLOSSARY_CATEGORY")
	{
		//术语集管理-更新目录
		d ##Class(EMR.DOC.BL.GlossaryCategory).UpGlossaryCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_GLOSSARY_CATEGORY")
	{
		//术语集管理-删除目录
		d ##Class(EMR.DOC.BL.GlossaryCategory).DelGlossaryCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_GLOSSARY_GLOSSARY")
	{
		//术语集管理-添加术语
		d ##Class(EMR.DOC.BL.Glossary).AddGlossary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_GLOSSARY_GLOSSARY")
	{
		//术语集管理-更新术语
		d ##Class(EMR.DOC.BL.Glossary).UpGlossary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_GLOSSARY_GLOSSARY")
	{
		//术语集管理-删除术语
		d ##Class(EMR.DOC.BL.Glossary).DelGlossary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_DATAELEMENT_ITEMVALUES")
	{
		//术语集管理-获取数据元允许值选项集合
		d ##class(EMR.DOC.BL.DataElementValuesCategory).GetDataElementItemValues(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_DATAELEMENT_FORMATVAVALUES")
	{
		//术语集管理-获取数据元值数据类型
		d ##class(EMR.DOC.BL.DataElementValuesCategory).GetDataElementFormatValues(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction ="GET_DATAELEMENT_TREE")
	{
		//术语集管理-获取术语集数据元树
		d ##class(EMR.DOC.BL.DataElementCategory).GetDataElementTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATAELEMENT_OPERATION")
	{
		//术语集管理-获取术语集数据元操作相关数据
		d ##Class(EMR.DOC.BL.DataElementCategory).GetDataElementOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_DATAELEMENT_MANAGE")
	{
		//数据元管理-添加数据元目录
		d ##Class(EMR.DOC.BL.DataElementManage).Update(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_DATAELEMENT_CATEGORY")
	{
		//数据元管理-添加数据元目录
		d ##Class(EMR.DOC.BL.DataElementCategory).AddDataElementCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_DATAELEMENT_CATEGORY")
	{
		//数据元管理-更新数据元目录
		d ##Class(EMR.DOC.BL.DataElementCategory).UpDataElementCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_DATAELEMENT_CATEGORY")
	{
		//数据元管理-删除数据元目录
		d ##Class(EMR.DOC.BL.DataElementCategory).DelDataElementCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_DATAELEMENT_ITEM")
	{
		//数据元管理-添加数据元
		d ##Class(EMR.DOC.BL.DataElement).AddDataElement(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_DATAELEMENT_ITEM")
	{
		//数据元管理-更新数据元
		d ##Class(EMR.DOC.BL.DataElement).UpDataElement(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_DATAELEMENT_ITEM")
	{
		//数据元管理-删除数据元
		d ##Class(EMR.DOC.BL.DataElement).DelDataElement(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_VALUECHOICES_BYGITEMID")
	{
		//术语集管理根据元素术语关系ID获取文档元素选项值列表
		//元素值域关联数据元值域表格数据
		d ##Class(EMR.DOC.BL.GlossaryItemMap).GetValueChoicesByGItemID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATAELEMENT_DEVVALUES")
	{
		//术语集管理-获取数据元允许值域列表集合
		d ##Class(EMR.DOC.BL.DataElementValues).GetDataElementDEVValues(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DATAELEMENTMAP_BYGLOSSARYITEM")
	{
		//术语集管理-根据gossaryitemID取已经关联值域列表
		d ##Class(EMR.DOC.BL.GlossaryItemMap).GetDataElementMapByGIID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_DATAELEMENT_MAP")
	{
		//术语集管理-文档元素与数据元值域添加映射
		d ##Class(EMR.DOC.BL.GlossaryItemMap).AddDataElementMap(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_DATAELEMENT_MAP")
	{
		//术语集管理-文档元素与数据元值域删除映射
		d ##Class(EMR.DOC.BL.GlossaryItemMap).DeleteDataElementMap(array,argInData,argOutMessage,argOutData)
	}
	
	elseif(strAction = "ADD_MAPBYVALUE")
	{
		//术语集管理-文档元素与数据元值域相同映射
		d ##Class(EMR.DOC.BL.GlossaryItemMap).AddMapByValue(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_INSTANCEGLOSSARY_TEST")
	{
		//术语集测试-获取测试表格数据
		d ##Class(EMR.DOC.BL.Glossary).GetGlossaryInstanceData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_INSTANCEIDS_TEST")
	{
		//术语集测试-获取下拉实例数据
		d ##Class(EMR.DOC.BL.Glossary).GetInstanceIDS(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GLOSSARY_VALUES")
	{
		// 数据集绑定下拉取值类型
		d ##Class(EMR.DOC.BL.GlossaryItemValues).GetGlossaryValueTypes(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEXTKB_CATEGORY")
	{
		//专科知识库-获取目录类别
		d ##Class(EMR.DOC.BL.TextKBCategory).GetTextKBCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_TEXTKB_CATEGORY")
	{
		//专科知识库-添加类别
		d ##Class(EMR.DOC.BL.TextKBCategory).AddTextKBCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_TEXTKB_CATEGORY")
	{
		//专科知识库-删除类别
		d ##Class(EMR.DOC.BL.TextKBCategory).DelTextKBCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEXTKB_TREE")
	{
		//专科知识库-获取类别对应树结构
		d ##Class(EMR.DOC.BL.TextKBCategory).GetTextKBTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_KNOWLEDGE_TREE")
	{
		//专科知识库-获取类别对应树结构
		d ##Class(EMR.DOC.BL.TextKBCategory).GetKnowledgeTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEXTKB_OPERATION")
	{
		//专科知识库操作数据
		d ##Class(EMR.DOC.BL.TextKBCategory).GetTextKBOperation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_TEXTKB_CATALOG")
	{
		//专科知识库-添加目录
		d ##Class(EMR.DOC.BL.TextKB).AddTextKBCatalog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_TEXTKB_ITEM")
	{
		//专科知识库-添加节点
		d ##Class(EMR.DOC.BL.TextKB).AddTextKBItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DEL_TEXTKB")
	{
		//专科知识库-删除目录、节点
		d ##Class(EMR.DOC.BL.TextKB).DelTextKB(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_TEXTKB")
	{
		//专科知识库-更新目录、节点
		d ##Class(EMR.DOC.BL.TextKB).UpdateTextKB(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEXTKB_CONTENT")
	{
		//专科知识库-获取知识库内容
		d ##Class(EMR.DOC.BL.TextKBContent).GetTextKBContent(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_TEXTKB_CONTENT")
	{
		//专科知识库-更新知识库内容
		d ##Class(EMR.DOC.BL.TextKBContent).UpTextKBContent(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALLLOC")
	{
		//专科知识库-获取所有科室数据列表
		d ##Class(EMR.DOC.BL.TextKBLoc).GetAllLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_BINDLOC")
	{
		//专科知识库-更新绑定节点的科室列表
		d ##Class(EMR.DOC.BL.TextKBLoc).SaveBindLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_BINDLOC_BYID")
	{
		//专科知识库-获取绑定节点的科室列表
		d ##Class(EMR.DOC.BL.TextKBLoc).GetBindLocByID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SUBMIT_TEXTKB_CONTENT")
	{
		//专科知识库-提交审核
		d ##Class(EMR.DOC.BL.TextKBContent).SubmitTexKBContent(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "AUDIT_TEXTKB_CONTENT")
	{
		//专科知识库-审核
		d ##Class(EMR.DOC.BL.TextKBContent).AuditTextKBContent(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_AUDIT_STATE")
	{
		//获取审核状态与审核说明
		d ##Class(EMR.DOC.BL.TextKBContent).GetAuditState(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_AUDIT_KBCONTENT")
	{
		//根据审核状态获取相应的知识库
		d ##Class(EMR.DOC.BL.TextKBContent).GetAuditKBContent(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_KBCONTENT")
	{
		//获取所有审核知识库
		d ##Class(EMR.DOC.BL.TextKBContent).GetAllContent(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DOCUMENT_VERSION_LIST")
	{
		//根据文档获取文档版本列表数据
		d ##Class(EMR.DOC.BL.Template).GetDocumentVersionList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "Add_DYNAMIC_CONFIG"){
		//公用字典-添加表格到配置表中
		d ##Class(EMR.DOC.BL.DynamicConfigTable).AddDynamicConfig(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction = "GET_DYNAMIC_CONFIGTABLE"){
		//公用字典-获取数据表表名 
		d ##Class(EMR.DOC.BL.DynamicConfigTable).GetDynamicConfigTable(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_DYNAMIC_CONFIGNAME"){
		//公用字典-根据数据表表名获取配置表 
		d ##Class(EMR.DOC.BL.DynamicConfigTable).GetDynamicConfigName(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CLASS_PROPERTIES"){
		//公用字典-根据数据表表名和配置名获取获取配置表属性 
		d ##Class(EMR.DOC.BL.DynamicConfigTable).GetClassProperties(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_CLASS_PROPERTIES"){
		//公用字典-更新配置表字段属性 
		d ##Class(EMR.DOC.BL.DynamicConfigTable).UpdateClassProperties(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALLCLASS_PROPERTIES"){
		//公用字典-更新配置表字段属性 
		d ##Class(EMR.DOC.BL.DynamicConfigTable).GetAllClassProperties(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_CLASS_PROPERTIESDATA"){
		//公用字典-根据配置表名获取数据表数据
		d ##Class(EMR.DOC.BL.DynamicConfigTable).GetClassPropertiesData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_CLASS_PROPERTIESDATA"){
		//公用字典-更新配置表所属数据表的数据
		d ##Class(EMR.DOC.BL.DynamicConfigTable).UpdateClassPropertiesData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_CLASS_PROPERTIESDATA"){
		//公用字典-更新配置表所属数据表的数据
		d ##Class(EMR.DOC.BL.DynamicConfigTable).DeleteClassPropertiesData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_CLASS_PROPERTIESDATA"){
		//公用字典-删除配置表所属数据表的数据
		d ##Class(EMR.DOC.BL.DynamicConfigTable).AddClassPropertiesData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CREATE_SPECHARS")
	{
		//特殊字符类-创建字符
		d ##Class(EMR.DOC.BL.Spechars).CreateSpechars(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_SPECHARS")
	{
		//特殊字符类-更新字符
		d ##Class(EMR.DOC.BL.Spechars).UpdateSpechars(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_SPECHARS")
	{
		//特殊字符类-删除字符
		d ##Class(EMR.DOC.BL.Spechars).DeleteSpechars(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CREATE_SPECHARS_CATEGORY")
	{
		//特殊字符分组类-创建分组
		d ##Class(EMR.DOC.BL.SpecharsCategory).CreateSpecharsCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_SPECHARS_CATEGORY")
	{
		//特殊字符分组类-更新分组
		d ##Class(EMR.DOC.BL.SpecharsCategory).UpdateSpecharsCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_SPECHARS_CATEGORY")
	{
		//特殊字符分组类-删除分组
		d ##Class(EMR.DOC.BL.SpecharsCategory).DeleteSpecharsCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_CATEGORY")
	{
		//特殊字符分组类-获取所有分组
		d ##Class(EMR.DOC.BL.SpecharsCategory).GetAllCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SPECHARS_BYCATEGORY")
	{
		//特殊字符分组类-获取分组下的所有字符
		d ##Class(EMR.DOC.BL.SpecharsCategory).GetSpecharsByCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SCHEMETYPE_DATA")
	{
		//病历导航-获取导航分类方案类型
		d ##Class(EMR.DOC.BL.EMRTSchemeType).GetSchemeTypeData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="ADD_SCHEME_DATA")
	{
		//病历导航-新增病历导航分类
		d ##Class(EMR.DOC.BL.EMRTScheme).AddSchemeData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="DELETE_SCHEME_DATA")
	{
		//病历导航-删除病历导航分类
		d ##Class(EMR.DOC.BL.EMRTScheme).DeleteSchemeData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_SCHEME_DATA")
	{
		//病历导航-获取病历导航分类
		d ##Class(EMR.DOC.BL.EMRTScheme).GetSchemeData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_SCHEME_DATA")
	{
		//病历导航-更新病历导航分类
		d ##Class(EMR.DOC.BL.EMRTScheme).UpDateSchemeData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_SCHEME_SEQUENCE")
	{
		//病历导航-更新病历导航分类
		d ##Class(EMR.DOC.BL.EMRTScheme).UpDateSchemeSeqData(array,argInData,argOutMessage,argOutData)
	}elseif(strAction ="GET_SSGROUP_LIST")
	{
		//获取安全组列表
		d ##class(EMR.DOC.BL.EMRTSchemeItemRes).GetSSGroupData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_NAVTEST_RESULT")
	{
		//病历导航测试
		d ##class(EMR.DOC.BL.EMRTSchemeNavTest).GetNavTestData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SIGNROLE")
	{
		//获取全部签名角色
		d ##Class(EMR.DOC.BL.SignRole).SelectSignRole(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_ROLE_ROOT")
	{
		//更新签名角色
		d ##Class(EMR.DOC.BL.SignRole).UpdateRoleRoot(array,argInData,argOutMessage,argOutData)
	}
#;	elseif(strAction = "SELECT_SIGNROLE")
#;	{
#;		//查询签名角色
#;		d ##Class(EMR.OP.BL.BLSignRole).SelectSignRole(array,argInData,argOutMessage,argOutData)
#;	}
	elseif(strAction = "GET_SCHEMEITEM_DATA")
	{
		//获取全部业务活动记录分类
		d ##Class(EMR.DOC.BL.EMRTSchemeItem).GetSchemeItemsData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SECHEME_ITEM")
	{
		//获取导航分类项目
		d ##Class(EMR.DOC.BL.EMRTSchemeItem).GetSchemeItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_SECHEME_ITEM")
	{
		//新增导航分类项目
		d ##Class(EMR.DOC.BL.EMRTSchemeItem).AddSchemeItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_SECHEME_ITEM")
	{
		//删除导航分类项目
		d ##Class(EMR.DOC.BL.EMRTSchemeItem).DelSchemeItem(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "UPDATE_SECHEME_ITEM")
	{
		//修改导航分类项目his配置
		d ##Class(EMR.DOC.BL.EMRTSchemeItem).UpdateSchemeItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_SCHEMEITEM_LOC")
	{
		//保存导航分类项目科室配置
		d ##Class(EMR.DOC.BL.EMRTSchemeItemRes).SaveSchemeItemLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SCHEMEITEM_LOC")
	{
		//获取导航分类项目科室配置
		d ##Class(EMR.DOC.BL.EMRTSchemeItemRes).GetSchemeItemLoc(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_SCHEMEITEMS_SAMELOC")
	{
		//获取导航分类项目共同科室配置
		d ##Class(EMR.DOC.BL.EMRTSchemeItemRes).GetSchemeItemSameLoc(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "SAVE_SCHEMEITEM_SSGROUP")
	{
		//保存导航分类项目安全组配置
		d ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).SaveSchemeItemSSGroup(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SCHEMEITEM_SSGROUP")
	{
		//获取导航分类项目安全组配置
		d ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).GetSchemeItemSSGroup(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_SCHEMEITEMS_SAMESSGROUP")
	{
		//获取导航分类项目共同科室配置
		d ##Class(EMR.DOC.BL.EMRTSchemeItemSSGroup).GetSchemeItemSameSSGroup(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_SCHEMEITEM_SEQUENCE")
	{
		//更新导航分类项目排序
		d ##Class(EMR.DOC.BL.EMRTSchemeItem).UpDateSchemeItemSeq(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_SECHEME_GROUPSEQ")
	{
		//新增导航分类科室排序分组
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).AddSchemeGroupSeq(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_SECHEME_GROUPSEQ")
	{
		//删除导航分类科室排序分组
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).DelSchemeGroupSeq(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SCHEMEGROUP_DATA")
	{
		//获取导航分类科室排序分组
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).GetSchemeGroupData(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "UPDATE_SCHEME_GROUP")
	{
		//修改科室排序分组信息
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).UpdateSchemeGroupData(array,argInData,argOutMessage,argOutData)
	}
	
	elseif(strAction = "GET_SCHEMEGROUP_ITEMS")
	{
		//获取导航分类科室排序分组项目
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).GetSchemeGroupItemsData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_SCHEMEGROUPITEM_SEQUENCE")
	{
		//导航分类科室排序分组项目排序
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupSeq).UpDateSchemeGroupItemSeq(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_SECHEMEGROUP_LOC")
	{
		//导航分类科室排序分组科室关联
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupCT).AddSchemeGroupCT(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_SECHEMEGROUP_LOC")
	{
		//导航分类科室排序分组科室关联
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupCT).SaveSchemeGroupLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SECHEMEGROUP_LOC")
	{
		//导航分类科室排序分组科室列表
		d ##Class(EMR.DOC.BL.EMRTSchemeGroupCT).GetSchemeGroupCT(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_MENU")
	{
		//获取所有菜单配置信息
		d ##Class(EMR.DOC.BL.RouteManage).GetAllMenu(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_MENU_DATA")
	{
		//添加菜单
		d ##Class(EMR.DOC.BL.RouteManage).AddMenuData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_MENU_DATA")
	{
		//删除菜单
		d ##Class(EMR.DOC.BL.RouteManage).DeleMenuData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_MENU_DATA")
	{
		//更新菜单
		d ##Class(EMR.DOC.BL.RouteManage).UpdateMenuData(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "GET_SEARCH_BUTTON")
	{
		//获取按钮
		d ##Class(EMR.DOC.BL.RouteManage).GetSearchButton(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_USER_MANU")
	{
		//根据用户获取路由信息
		d ##Class(EMR.DOC.BL.RouteUserManage).GetUserManu(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ROUTING_MENU")
	{
		//获取操作权限数据
		d ##Class(EMR.DOC.BL.RoutingMenu).GetRoutingMenu(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ROUTE_ROLEOPERPERMISSION")
	{
		//根据角色ID获取操作权限数据Key
		d ##Class(EMR.DOC.BL.RouteOperPermission).GetRouteRoleOperPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_ROUTE_ROLE")
	{
		//删除角色数据（NEW）
		d ##Class(EMR.DOC.BL.RBACRole).DeleteRouteRole(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "STOPUSING_ROUTE_ROLE")
	{
		//停用角色（NEW）
		d ##Class(EMR.DOC.BL.RBACRole).StopUseingRouteRole(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UP_ROUTE_ROLEOPERPERMISSION")
	{
		//批量授权操作功能数据（NEW）
		d ##Class(EMR.DOC.BL.RouteOperPermission).UpRouteRoleOperPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_RBAC_TEMPLATEDATAKEY")
	{
		//获取数据权限文档管理的Key（NEW）
		d ##Class(EMR.DOC.BL.RBACDataPermission).GetRBACTemplateKey(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_STDDIC")
	{
		//获取所有基础字典数据
		d ##Class(EMR.DOC.BL.BLStdDictionary).GetALLStdDic(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_STDDIC_DATA")
	{
		//添加基础字典数据
		d ##Class(EMR.DOC.BL.BLStdDictionary).AddStdDicData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_STDDIC_DATA")
	{
		//删除基础字典数据
		d ##Class(EMR.DOC.BL.BLStdDictionary).DeleteStdDicData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_STDDIC_DATA")
	{
		//更新基础字典数据
		d ##Class(EMR.DOC.BL.BLStdDictionary).UpdateStdDicData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "EXCHANGE_STDDIC_ORDER")
	{
		//交换基础字典数据顺序
		d ##Class(EMR.DOC.BL.BLStdDictionary).ExchangeStdDicOrder(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TS_RULETYPE")
	{
		//获取所有规则类别
		d ##Class(EMR.DOC.BL.BLStdDictionary).GetTSRuleType(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TMPMSGLIST")
	{
		//获取模板提示信息列表
		d ##Class(EMR.DOC.BL.TemplateMessage).GetTmpMsg(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_TMPMSGLIST")
	{
		//新建模板提示信息
		d ##Class(EMR.DOC.BL.TemplateMessage).AddTmpMsg(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_TMPMSGLIST")
	{
		//更新模板提示信息
		d ##Class(EMR.DOC.BL.TemplateMessage).UpdateTmpMsg(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_TMPMSGLIST")
	{
		//删除模板提示信息
		d ##Class(EMR.DOC.BL.TemplateMessage).DeleteTmpMsg(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_LOCS")
	{
		// 病历文档分组-获取所有科室列表数据
		d ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetAllLocs(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_GROUP_LOC")
	{
		// 病历文档分组-获取指定分组下的关联科室
		d ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).GetTemplateGroupLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_GROUP_LOC")
	{
		// 病历文档分组-保存分组的科室配置信息
		d ##Class(EMR.DOC.BL.EMRTemplateGroupLoc).SaveGroupLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "CREATE_TEMPLATE_GROUP")
	{
		// 病历文档分组-创建分组
		d ##Class(EMR.DOC.BL.EMRTemplateGroup).CreateTemplateGroup(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_TEMPLATE_GROUP")
	{
		// 病历文档分组-删除分组
		d ##Class(EMR.DOC.BL.EMRTemplateGroup).DeleteTemplateGroup(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_BATCH_ITEMS")
	{
		// 病历文档分组-删除文档模板
		d ##Class(EMR.DOC.BL.EMRTemplateItem).DeleteBatchItems(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_TEMPLATE_GROUP")
	{
		// 病历文档分组-更新分组
		d ##Class(EMR.DOC.BL.EMRTemplateGroup).UpdateTemplateGroup(array,argInData,argOutMessage,argOutData)
	}
    elseif(strAction = "GET_ALL_GROUPS")
	{
		// 病历文档分组-获取所有分组列表
		d ##Class(EMR.DOC.BL.EMRTemplateGroup).GetAllGroups(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_TEMPLATE_ITEM")
	{
		// 病历文档分组-添加文档模板
		d ##Class(EMR.DOC.BL.EMRTemplateItem).SaveTemplateItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_TEMPLATE_ITEM")
	{
		// 病历文档分组-批量添加文档模板
		d ##Class(EMR.DOC.BL.EMRTemplateItem).AddTemplateItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_TEMPLATE_ITEM")
	{
		// 病历文档分组-删除文档模板
		d ##Class(EMR.DOC.BL.EMRTemplateItem).DeleteTemplateItem(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TEMPLATE_ITEM_BYID")
	{
		// 病历文档分组-获取分组下的所有文档
		d ##Class(EMR.DOC.BL.EMRTemplateItem).GetTemplateItemById(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_TOOTH_REPRESENTATION")
	{
		// 牙位图-获取当前牙位表示法
		d ##Class(EMR.DOC.BL.ToothPosition).GetToothRepresentation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_TOOTH_REPRESENTATION")
	{
		// 牙位图-更新牙位表示法
		d ##Class(EMR.DOC.BL.ToothPosition).UpdateToothRepresentation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "AUDIT_TEMPLATE")
	{
		// 文档审核-审核
		d ##Class(EMR.DOC.BL.TemplateAudit).AuditTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="CANCEL_AUIT_TEMPLATE")
	{
		//取消文档审核申请
		d ##class(EMR.DOC.BL.TemplateAudit).CancelTemplateAudit(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_AUDIT_TEMPLATE")
	{
		// 文档审核-根据审核状态获取相应的文档数据
		d ##Class(EMR.DOC.BL.TemplateAudit).GetAuditTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_TEMPLATE")
	{
		// 文档审核-获取所有文档审核数据
		d ##Class(EMR.DOC.BL.TemplateAudit).GetAllTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_LOCDATA")
	{
		// 科室文档审核-获取所有科室
		d ##Class(EMR.DOC.BL.LocTemplateAudit).GetAllLocData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "AUDIT_LOCTEMPLATE")
	{
		// 科室文档审核-审核
		d ##Class(EMR.DOC.BL.LocTemplateAudit).AuditLocTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_AUDIT_LOCTEMPLATE")
	{
		// 科室文档审核-根据审核状态获取相应的科室文档数据
		d ##Class(EMR.DOC.BL.LocTemplateAudit).GetAuditLocTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_ALL_LOCTEMPLATE")
	{
		// 科室文档审核-获取所有科室文档审核数据
		d ##Class(EMR.DOC.BL.LocTemplateAudit).GetAllLocTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SYSOPTIONS")
	{
		// 获取系统参数
		d ##Class(EMR.DOC.BL.SysOption).GetSystemOptionList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_SYSOPTIONS")
	{
		// 新增系统参数
		d ##Class(EMR.DOC.BL.SysOption).AddSysOptionValue(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_SYSOPTIONS")
	{
		// 更新系统参数
		d ##Class(EMR.DOC.BL.SysOption).UpdateSysOptionValue(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "DELETE_SYSOPTIONS")
	{
		// 删除系统参数
		d ##Class(EMR.DOC.BL.SysOption).DeleteSysOptionValue(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SYSOPTIONSLOG")
	{
		// 获取系统参数设置日志
		d ##Class(EMR.DOC.BL.SysOptionLog).GetSystemOptionLog(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_PRODUCTMSG")
	{
		// 获取已上线产品列表信息
		d ##Class(EMR.DOC.BL.OnlineProduct).GetPrcMsg(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "ADD_PRODUCTMSG")
	{
		// 新增已上线产品列表信息
		d ##Class(EMR.DOC.BL.OnlineProduct).AddProduct(array,argInData,argOutMessage,argOutData)
	}
	
	elseif(strAction = "GET_PRODUCTNAME")
	{
		// 获取产品名称
		d ##Class(EMR.DOC.BL.OnlineProduct).GetProductName(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "UPDATE_PRODUCTMSG")
	{
		// 更新已上线产品列表信息
		d ##Class(EMR.DOC.BL.OnlineProduct).UpdateProduct(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_PRODUCT_LIST")
	{
		// 获取上线产品列表
		d ##Class(EMR.DOC.BL.OnlineProduct).GetProductList(array,argInData,argOutMessage,argOutData)
	}
	
	elseif(strAction = "DELETE_PRODUCTMSG")
	{
		// 删除已上线产品列表信息
		d ##Class(EMR.DOC.BL.OnlineProduct).DeleteProduct(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_EVENT_TYPE")
	{
		//获取事件类型
		d ##class(EMR.DOC.BL.EventType).GetEventType(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_EVENTLIST")
	{
		//获取事件详情
		d ##class(EMR.DOC.BL.EventUphold).GetEventList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_EVENT")
	{
		//更新事件信息
		d ##class(EMR.DOC.BL.EventUphold).UpdateEventList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_RBAC_QUOTATION")
	{
		//获取所有科室数据
		d ##class(EMR.DOC.BL.BLQuotation).GetRBACQuotation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_RBAC_QUOTATIONBYDOCID")
	{
		//获取所有科室数据
		d ##class(EMR.DOC.BL.BLQuotation).GetRBACQuotationByDocID(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "CHANGE_STDDIC_DATA")
	{
		//获取所有科室数据
		d ##class(EMR.DOC.BL.BLQuotation).ChangeQuotationData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_RBAC_QUOTATIONTEMPLATE")
	{
		//获取引用科室所有模板数据
		d ##class(EMR.DOC.BL.BLQuotation).GetRBACQuotationTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_QUOTATION_DATA")
	{
		//添加科室关联模板数据
		d ##class(EMR.DOC.BL.BLQuotation).AddQuotationData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_QUOTATION_DATA")
	{
		//删除科室已关联模板
		d ##class(EMR.DOC.BL.BLQuotation).DeleteQuotationData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_SEARCH_IMAGECATEGORY")
	{
		//获取图库目录
		d ##class(EMR.DOC.BL.ImageBLCategory).GetSearchImageCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_IMAGE_CATEGORY")
	{
		//添加图库目录
		d ##class(EMR.DOC.BL.ImageBLCategory).AddImageCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_IMAGE_CATEGORY")
	{
		//添加图库目录
		d ##class(EMR.DOC.BL.ImageBLCategory).DeleteImageCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_IMAGE_CATEGORY")
	{
		//更新图库目录
		d ##class(EMR.DOC.BL.ImageBLCategory).UpdateImagCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_IMAGE_ENTITY")
	{
		//获取图片实例
		d ##class(EMR.DOC.BL.ImageItem).GetImageEntity(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_IMAGE_ENTITY")
	{
		//添加图片实例
		d ##class(EMR.DOC.BL.ImageItem).AddImageEntity(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_IMAGE_ENTITY")
	{
		//修改图片实例
		d ##class(EMR.DOC.BL.ImageItem).UpdateImageEntity(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_IMAGE_ENTITY")
	{
		//删除图片实例
		d ##class(EMR.DOC.BL.ImageItem).DeleteImageEntity(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_SEARCH_DIAGNOSCATEGORY")
	{
		// 获取病种目录
		d ##class(EMR.DOC.BL.BLDiagonsConfig).GetSearchDiagnosCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_DIAGNOS_CATEGORY")
	{
		// 添加病种目录
		d ##class(EMR.DOC.BL.BLDiagonsConfig).AddDiagnosCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_DIAGNOS_CATEGORY")
	{
		// 添加病种目录
		d ##class(EMR.DOC.BL.BLDiagonsConfig).DeleteDiagnosCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_DIAGNOS_CATEGORY")
	{
		// 修改病种目录
		d ##class(EMR.DOC.BL.BLDiagonsConfig).UpdateDiagnosCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_DIAGNOS")
	{
		// 添加病种
		d ##class(EMR.DOC.BL.BLDiagonsConfig).AddDiagnos(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_DIAGNOS")
	{
		// 删除病种
		d ##class(EMR.DOC.BL.BLDiagonsConfig).DeleteDiagnos(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_DIAGNOS")
	{
		// 修改病种
		d ##class(EMR.DOC.BL.BLDiagonsConfig).UpdateDiagnos(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_DISEASE_BYPAGESIZE")
	{
		// 获取所有诊断数据
		d ##class(EMR.DOC.BL.BLDiagonsConfig).GetDiseaseByPagesize(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_SEARCH_DISEASEBYDIAGNOS")
	{
		// 根据Code获取病种关联诊断数据
		d ##class(EMR.DOC.BL.BLDiagonsConfig).GetSearchDiseaseByDiagnos(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_DIAGNOS_ANDDISEASE")
	{
		// 添加病种关联诊断数据
		d ##class(EMR.DOC.BL.BLDiagonsConfig).AddDiagnosAndDisease(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_DIAGNOS_ANDDISEASE")
	{
		// 删除病种关联诊断数据
		d ##class(EMR.DOC.BL.BLDiagonsConfig).DeleteDiagnosAndDisease(array,argInData,argOutMessage,argOutData)
	}		
	elseif(strAction= "GET_CTLOCLIST")
	{
		//获取科室字典列表
		d ##class(EMR.OP.BL.BLDocumentRule).GetBLQuotation(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_PACWARDLIST")
	{
		//获取病区字典列表
		d ##class(EMR.OP.BL.BLDocumentRule).GetBLPACWARD(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_STCATEGORY")
	{
		//获取字典目录
		d ##class(EMR.DOC.BL.TemplateRules).GetStCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_PRIVRULELIST")
	{
		//获取引用参数列表
		d ##class(EMR.DOC.BL.PrivRuleList).GetPrivRuleList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_PRIVRULELIST")
	{
		//更新引用参数
		d ##class(EMR.DOC.BL.PrivRuleList).UpdatePrivRuleList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_PRIVRULELIST")
	{
		//删除引用参数
		d ##class(EMR.DOC.BL.PrivRuleList).DeletePrivRuleList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_PRIVRULELIST")
	{
		//新增引用参数
		d ##class(EMR.DOC.BL.PrivRuleList).AddPrivRuleList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_RULETYPELIST")
	{
		//获取权限类型列表
		d ##class(EMR.DOC.BL.PrivRuleType).GetRuleTypeList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_RULETYPELIST")
	{
		//新增权限类型列表
		d ##class(EMR.DOC.BL.PrivRuleType).AddRuleTypeList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_RULETYPELIST")
	{
		//更新权限类型列表
		d ##class(EMR.DOC.BL.PrivRuleType).UpdateRuleTypeList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_RULETYPELIST")
	{
		//删除权限类型列表
		d ##class(EMR.DOC.BL.PrivRuleType).DeletePrivRuleType(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_RULESTORELIST")
	{
		//获取脚本仓库列表
		d ##class(EMR.DOC.BL.PrivRuleStore).GetRuleStore(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_RULESTORELIST")
	{
		//新增脚本
		d ##class(EMR.DOC.BL.PrivRuleStore).AddRuleStore(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_RULESTORELIST")
	{
		//更新脚本
		d ##class(EMR.DOC.BL.PrivRuleStore).UpdateRuleStore(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_RULESTORELIST")
	{
		//删除脚本
		d ##class(EMR.DOC.BL.PrivRuleStore).DeleteRuleStore(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "SIGLECODE_CHECK")
	{
		//删除脚本
		d ##class(EMR.DOC.BL.PrivRuleStore).TestCode(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_PRIVRULE")
	{
		//获取权限规则列表
		d ##class(EMR.DOC.BL.PrivRule).GetPrivRule(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "ADD_PRIVRULE")
	{
		//新增权限规则
		d ##class(EMR.DOC.BL.PrivRule).AddPrivRule(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_PRIVRULE")
	{
		//更新权限规则属性
		d ##class(EMR.DOC.BL.PrivRule).UpdatePrivRule(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_PRIVRULECODE")
	{
		//更新权限规则脚本代码
		d ##class(EMR.DOC.BL.PrivRule).UpdatePrivRuleCode(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_PRIVRULE")
	{
		//删除权限规则
		d ##class(EMR.DOC.BL.PrivRule).DeletePrivRule(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="CHECK_SCRIPT")
	{
		//脚本校验
		d ##class(EMR.DOC.BL.PrivRuleRun).TestRuleCode(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_HOSPITALGROUPLIST")
	{
		//获取院区列表
		d ##class(EMR.DOC.BL.HospGroup).GetPrivGroupList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_HOSPITALGROUP")
	{
		//获取院区分组列表
		d ##class(EMR.DOC.BL.HospGroup).GetHospitalGroup(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_RULEDETAIL")
	{
		//获取脚本详情
		d ##class(EMR.DOC.BL.PrivRuleDetail).GetRuleDetail(array,argInData,argOutMessage,argOutData)
	}		
	elseif(strAction= "ADD_RULEDETAIL")
	{
		//新增脚本条目
		d ##class(EMR.DOC.BL.PrivRuleDetail).AddRuleDetail(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_RULEDETAIL")
	{
		//更新脚本内容
		d ##class(EMR.DOC.BL.PrivRuleDetail).UpdateRuleDetail(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "DELETE_RULEDETAIL")
	{
		//删除脚本
		d ##class(EMR.DOC.BL.PrivRuleDetail).DeleteRuleDetail(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "SORT_RULECONTENT")
	{
		//脚本详情排序
		d ##class(EMR.DOC.BL.PrivRuleDetail).SortSequence(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_SCRIPTCODE")
	{
		//获取脚本详情
		d ##class(EMR.DOC.BL.PrivRuleDetail).GetScript(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_TEMPLATEAUDIT_TREE")
	{
		//获取通用文档审核树目录
		d ##class(EMR.DOC.BL.TemplateAudit).GetAuditTemplateTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_LOCTEMPLATEAUDIT_TREE")
	{
		//获取科室文档审核树目录
		d ##class(EMR.DOC.BL.LocTemplateAudit).GetAuditTemplateTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_DOCDESIGNCG_SEQUENCE")
	{
		//文档设计目录排序
		d ##class(EMR.DOC.BL.TemplateManage).SortCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_KBCATEGORY_SEQUENCE")
	{
		//文档片段目录排序
		d ##class(EMR.DOC.BL.KBManage).SortCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "UPDATE_KBNODE_AUDITSTATUS")
	{
		//文档片段审核
		d ##class(EMR.DOC.BL.KBNodeAudit).UpdateKBNodeAudit(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction= "GET_SIGN_LIST")
	{
		//获取模板代签列表
		d ##class(EMR.DOC.BL.TemplateSign).GetSignList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_VERSION_SIGN")
	{
		//获取版本签名属性
		d ##class(EMR.DOC.BL.TemplateSign).GetVersionSign(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_SIGN_ROLE")
	{
		//获取角色规则属性
		d ##class(EMR.DOC.BL.TemplateSign).GetSignRuleList(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_AUDIT_KBTREE")
	{
		//获取文档片段审核目录树
		d ##class(EMR.DOC.BL.KBNodeAudit).GetAuditKBNodeTree(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_VERSION_SIGN")
	{
		//更新版本签名
		d ##class(EMR.DOC.BL.TemplateSign).UpdateTemplateSignAttribute(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction="GET_PATIENT_SIGNLIST")
	{
		//获取患者签名排序列表
		d ##class(EMR.DOC.BL.PaitSign).GetPaitSignOrder(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction="GET_SIGNER_TYPE")
	{
		//获取签名者类型
		d ##class(EMR.DOC.BL.PaitSign).GetPaitSignerType(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction="GET_PATIENT_SIGNTYPE")
	{
		//获取签名者类型
		d ##class(EMR.DOC.BL.PaitSign).GetPaitSignContent(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction="UPDATE_PATIENT_DATA")
	{
		//更新待签列表排序
		d ##class(EMR.DOC.BL.PaitSign).UpdatePaitData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_NAVTAB_MENU")
	{
		//获取导航栏菜单
		d ##class(EMR.DOC.BL.RouteUserManage).GetNavTab(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_RESOURCE_CONFIG")
	{
		//获取资源区配置项列表
		d ##class(EMR.DOC.BL.ResourceConfig).GetResourceData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="ADD_RESOURCE_CONFIG")
	{
		//新增资源区配置项
		d ##class(EMR.DOC.BL.ResourceConfig).AddResourceData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_RESOURCE_CONFIG")
	{
		//更新资源区配置项
		d ##class(EMR.DOC.BL.ResourceConfig).UpdateResourceData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="DELETE_RESOURCE_CONFIG")
	{
		//删除资源区配置项
		d ##class(EMR.DOC.BL.ResourceConfig).DeleteResourceData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="SEARCH_BDM_TREE")
	{
		//根据版本id查询业务数据模型目录
		d ##class(EMR.DOC.BL.BDMCategory).VersionIdBDMCategory(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_LINKCONFIG_DATA")
	{
		//获取链接单元配置项列表
		d ##class(EMR.DOC.BL.LinkConfig).GetLinkConfig(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="ADD_LINKCONFIG_DATA")
	{
		//新增链接单元配置项
		d ##class(EMR.DOC.BL.LinkConfig).AddLinkConfig(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_LINKCONFIG_DATA")
	{
		//更新链接单元配置项
		d ##class(EMR.DOC.BL.LinkConfig).UpdateLinkConfig(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="DELETE_LINKCONFIG_DATA")
	{
		//删除链接单元配置项
		d ##class(EMR.DOC.BL.LinkConfig).DeleteLinkConfig(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="SAVE_TEMPLATESIGN_DATA")
	{
		//保存模板待签数据
		d ##class(EMR.DOC.BL.TemplateSign).SaveSignData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_GLOSSARY_DATA")
	{
		//获取术语
		d ##class(EMR.DOC.BL.Glossary).GetGloassary(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_PICTURECG_SEQUENCE")
	{
		//图库目录排序
		d ##class(EMR.DOC.BL.ImageBLCategory).ImagCGSort(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_PICTURE_SEQUENCE")
	{
		//图库图片排序
		d ##class(EMR.DOC.BL.ImageItem).ImagCGSort(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="LOCCATEGORY_SORT")
	{
		//科室文档目录排序
		d ##class(EMR.DOC.BL.LocTemplateCategory).LocCatgorySort(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="LOCTEMPLATE_SORT")
	{
		//科室文档排序
		d ##class(EMR.DOC.BL.LocTemplate).LocTemplateSort(array,argInData,argOutMessage,argOutData)
	}	
	elseif(strAction="GET_DEFAULTFONTSET")
	{
		//返回默认字体设置
		d ##class(EMR.DOC.BL.SysOption).ReturnDefaultFontSet(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_SINGLE_IMGENTITY")
	{
		//获取单个图片实例
		d ##class(EMR.DOC.BL.ImageItem).GetSignImgEntity(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="ADD_DATAPERMISSION")
	{
		//添加角色数据授权
		d ##class(EMR.DOC.BL.RouteOperPermission).AddDataPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="GET_DATAPERMISSION")
	{
		//获取角色数据授权
		d ##class(EMR.DOC.BL.RouteOperPermission).GetDataPermission(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="UPDATE_PATSIGN_DATA")
	{
		//保存患者待签数据
		d ##class(EMR.DOC.BL.PaitSign).AddSignData(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction="LOAD_SSGROUPINFO")
	{
		//加载安全组信息
		d ##class(EMR.DOC.BL.SSGroup).GetSSGroup(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction="CANCEL_PUBLISH")
	{
		//取消发布
		d ##class(EMR.DOC.BL.TemplateAudit).CancelPublish(array,argInData,argOutMessage,argOutData)
	}
	
	elseif (strAction="DELETE_SCHEMEITEM_LOC")
	{
		//批量取消科室关联
		d ##class(EMR.DOC.BL.EMRTSchemeItemRes).DeleteSchemeItemLoc(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction="DELETE_SCHEMEITEM_SSGROUP")
	{
		//批量取消安全组关联
		d ##class(EMR.DOC.BL.EMRTSchemeItemSSGroup).DeleteSchemeItemSSGroup(array,argInData,argOutMessage,argOutData)
	}
	
	elseif (strAction="GET_TOUTHPROP_DATA")
	{
		//获取牙位扩展表数据
		d ##class(EMR.DOC.BL.TouthPropertys).GetTouthJsonData(array,argInData,argOutMessage,argOutData)
	}

	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","action操作不存在",2)
	}
	q "1"
	
ERROR			
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000",2)
}

}
