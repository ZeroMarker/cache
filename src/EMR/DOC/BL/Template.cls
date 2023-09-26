/// 名称:EMR.DOC.COM.Template
/// 描述:通用文档管理模块 Document(Doc) 公用程序层 Template维护业务类
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-08
/// 产品组：电子病历产品组
Class EMR.DOC.BL.Template Extends EMR.DOC.COM.ActionBase
{

/// Desc:       添加文档
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"ADD_TEMPLATE","params":{"name":"入院记录内科新增文档测试","description":"入院记录内科","GUID":"lsjdflklsjdfljslg234234lj112","HFFormat":2,"chartItemType":"Single","documentType":"DOC","templateCategory":168,"userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s argDTO = ##class(EMR.DOC.DTO.Template).%New()
	s argDTO.Name = argInJson.params.title
	s argDTO.Description =  argInJson.params.description
	s argDTO.HFFormat = ..GetIDByKey(argInJson.params.HFFormat)
	s argDTO.ChartItemType = argInJson.params.chartItemType
	s argDTO.DocumentType = argInJson.params.documentType
	s argDTO.EMRName=argInJson.params.emrName
	s argDTO.TemplateCategory = ..GetIDByKey(argInJson.params.id)
	s rulesStr=argInJson.params.ruleStr
	s rulesDescription=argInJson.params.ruleDes
	
	s argDTOVersion = ##class(EMR.DOC.DTO.TemplateVersion).%New()
	s argDTOVersion.HFVersion = ..GetIDByKey(argInJson.params.HFFormat)
	s argDTOMLog = ##class(EMR.DOC.DTO.TemplateStatusMLog).%New()
	s userCode = argInJson.params.userCode
	s argDTOMLog.CreateID = userCode
	s argDTOMLog.ModifyID = userCode
	s argDTOMLog.OperateMachineIP = argInJson.params.IP
	s argDTOMLog.Remark = argInJson.remark
	s roleCode=argInJson.params.safeGroupId
	Tstart
	//添加文档
    s strTemID = ##Class(EMR.DOC.BL.Template).AddTemplateJson(argDTO,userCode,rulesStr,rulesDescription,roleCode)
    if (strTemID = "-101")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","添加文档出错",2) 
	}
	elseif (strTemID = "-102")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","更新目录出错",2) 
	}
	elseif (strTemID = "-103")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","设置权限出错",2) 
	}
	elseif (strTemID = "-200")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","必填项校验失败",2) 
	}
	elseif (strTemID = "-301")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","目录记录为空,检查参数id",2) 
	}
	elseif (strTemID = "-302")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","文档类型记录为空，检查参数documentType",2) 
	}
	elseif (strTemID = "-303")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","文档版式记录为空，检查参数HFFormat",2) 
	}
    s argDTOVersion.Template = strTemID
    //新增版本
    if (argInData.IsNull()'=1){
	    d argDTOVersion.DocumentData.CopyFrom(argInData)
	}
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersionJson(argDTOVersion,argDTOMLog,.argOutData)
	if (strRes = "-201")
	{ 
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","必须关联文档ID",2)
	}elseif(strRes = "-202")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","必须关联文档版式",2)	
	}elseif(strRes = "-101")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","文档下有未发布的版本，不允许新建",2)	
	}elseif(strRes = "-301")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","文档记录不存在，新建失败",2)	
	}elseif(strRes = "-102")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","版式没有已发布的版本，新建失败",2)	
	}elseif(strRes = "-302")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","版式版本数据记录不存在，新建失败",2)	
	}elseif(strRes = "-103")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据出错",2)	
	}elseif(strRes = "-104")
	{
		Trollback
		q ..SetOutMessage(argOutMessage,"ERROR","添加日志出错，新建失败",2)	
	}
	else
	{  
		TCOMMIT
	    q argOutMessage.success = ..#OK
	}
Error
	Trollback
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新文档
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"UP_TEMPLATE", "params":{"id":15, "name":"入院记录内科更新文档接口测试", "description":"入院记录内科","HFFormat":2,"templateCategory":168},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.Template).%New()
	s argDTO.ID = ..GetIDByKey(argInJson.params.id)
	s argDTO.Name = argInJson.params.title
	s argDTO.EMRName=argInJson.params.emrName
	s argDTO.ChartItemType = argInJson.params.chartItemType
	s argDTO.DocumentType = argInJson.params.documentType
	s argDTO.Description = argInJson.params.description
	s argDTO.HFFormat = ..GetIDByKey(argInJson.params.HFFormat)
	s argDTO.TemplateCategory = ..GetIDByKey(argInJson.params.templateCategory)
	
    s strRes = ##Class(EMR.DOC.BL.Template).UpTemplateJson(argDTO)
    if (strRes="1"){
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","请传入要修改的文档ID",2)
	}
	elseif(strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","没有找到要修改的文档记录",2)	
	}
	elseif(strRes = "-302")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档类型不存在",2)	
	}
	elseif(strRes = "-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","修改文档出错",2)	
	}
	else
	{  
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)	
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       删除文档目录
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DEL_TEMPLATE","params":{"id":15},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod DelTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.Template).DelTemplateJson(strID)
	if (strRes = "1")
	{
	    q argOutMessage.success = ..#OK
	}elseif(strRes = "-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","请传入要删除的文档ID",2)	
	}
	elseif(strRes = "-202")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","版本记录不存在",2)	
	}
	elseif(strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","没有找到要删除的文档记录",2)	
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","删除文档出错",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Desc:       根据文档ID获取文档版本下拉列表
/// Creator:    duan
/// CreateDate: 2021-06-15
/// Input:      argArray  	命令参数 {"action":"GET_DOCUMENT_VERSION_LIST","params":{"id":15},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetDocumentVersionList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s TemplateID = ..GetIDByKey(argInJson.params.id)
	/// output:     成功：１　失败： -201 文档ID不能为空
	s strRes = ##class(EMR.DOC.BL.Template).GetVersionListJson(TemplateID, argOutData)
	if (strRes=1)
	{
		q argOutMessage.success = ..#OK	
	}
	elseif(strRes =-201)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档ID不能为空",2)	
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误",2)
	}	
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// desc: 文档元素关联术语集 
/// Creator:    duan
/// CreateDate: 2021-06-17
/// Input:       argArray  	命令参数 {"action":"ADD_GLOSSARYITEM_DOCUMENT","product":"GlobalEMR","params":{"id":"",//文档ID"glossary":[{"CCode":"",//段落编码没有不传"SCode":"",//章节编码"CSCode":"",//简单元素编码"MACode":"",//复合元素编码"CCodeName":"",//编码名称"SCodeName":"","CSCodeName":"","MACodeName":"","itemType":"ISECTIONDESC",//关联类型（ISECTIONDESC（章节)，ICOMPOSITEDESC(复合元素)，ICOMPOSITESAMPLE(结构化元素)，ICONCEPTDESC(医学概念)，ICONCEPTSAMPLE(医学概念子元素),IMACRODESC(宏对象(存储部分医学公式，月经生育史，眼科前房深度公式))，IMACROSAMPLE(宏对象子元素)）"glossaryID":"3||LF",//术语集ID（key）"valueType":"S",//术语集选项值类型"valueText":"样式"//术语集选项值}],"type":"GLOSSARY"}}
/// Output:    
ClassMethod AddGlossaryMap(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s List = argInJson.params.list
	s deleteFlag=argInJson.params.flag
	if (deleteFlag'="")
	{
		&sql(delete from CF_EMR_DOC.GlossaryItem where GlossaryID=:deleteFlag)
		q
	}
    if (argInJson.params.%GetTypeOf("list")'="array")
    {
		q ..SetOutMessage(argOutMessage,"ERROR","list必须为数组",2)
	}
	s strMark= 1
	set iter =List.%GetIterator()
	s glossaryID=argInJson.params.glossaryID
	TSTART
	&sql(delete from CF_EMR_DOC.GlossaryItem where GlossaryID=:glossaryID)
	while iter.%GetNext(.key , .listItem ) 
	{
	    s flag = ..AddGlossary(listItem,argInData,argOutMessage,argOutData) 
	    if (flag'= 1)
	    {
		  	s strMark=flag
		  	TROLLBACK
		  	q    
		}
	}
	TCOMMIT
	q strMark
Error
	d argOutData.Clear()
	TROLLBACK
	q ..SetOutMessage(argOutMessage,"ERROR",flag, 2)
}

/// desc: 文档元素关联术语集 
/// Creator:    duan
/// CreateDate: 2021-06-17
/// Input:       argArray  	命令参数 {"action":"ADD_GLOSSARYITEM_DOCUMENT","product":"GlobalEMR","params":{"id":"",//文档ID"glossary":[{"CCode":"",//段落编码没有不传"SCode":"",//章节编码"CSCode":"",//简单元素编码"MACode":"",//复合元素编码"CCodeName":"",//编码名称"SCodeName":"","CSCodeName":"","MACodeName":"","itemType":"ISECTIONDESC",//关联类型（ISECTIONDESC（章节)，ICOMPOSITEDESC(复合元素)，ICOMPOSITESAMPLE(结构化元素)，ICONCEPTDESC(医学概念)，ICONCEPTSAMPLE(医学概念子元素),IMACRODESC(宏对象(存储部分医学公式，月经生育史，眼科前房深度公式))，IMACROSAMPLE(宏对象子元素)）"glossaryID":"3||LF",//术语集ID（key）"valueType":"S",//术语集选项值类型"valueText":"样式"//术语集选项值}],"type":"GLOSSARY"}}
/// Output:    
ClassMethod AddGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s TemplateID = argInJson.id
	s Glossary = argInJson.glossary
    if (argInJson.%GetTypeOf("glossary")'="array")
    {
		q ..SetOutMessage(argOutMessage,"ERROR","glossary必须为数组",2)
	}
	s temType = argInJson.temType
	if (temType = "EMRDOC")||(temType="EMRINSTANCE")
	{
		s Name = ..GetNameByID(..GetIDByKey(TemplateID),"DT")
	} 
	elseif (temType = "BDM") 
	{
		s Name = ..GetNameByID(..GetIDByKey(TemplateID),"BDM")
	}
	elseif(temType="KB")
	{
		s Name=..GetNameByID(..GetIDByKey(TemplateID),"KB")
	}
	
	if (Name=""){
		q ..SetOutMessage(argOutMessage,"ERROR","获取文档结构名称描述失败，检查id参数",2)
	}
	s strMark= 1
	set iter =Glossary.%GetIterator()
	s InObject=##class(%DynamicObject).%New()

	while iter.%GetNext(.key , .glossaryItem ) {
	    s InObject.params=glossaryItem
	    s CCode = glossaryItem.CCode
		s SCode = glossaryItem.SCode
		s CSCode = glossaryItem.CSCode
		s MACode = glossaryItem.MACode
		s CCodeName = glossaryItem.CCodeName
		s SCodeName = glossaryItem.SCodeName
		s CSCodeName = glossaryItem.CSCodeName
		s MACodeName = glossaryItem.MACodeName
		if ((glossaryItem.className'="")||(glossaryItem.propertys'=""))
		{
			s ItemName=glossaryItem.pathTitle_glossaryItem.propertys_" "_glossaryItem.propertyName
		}
		else
		{
			s ItemName = glossaryItem.pathTitle_$case(SCode,"":"",:SCode_" "_SCodeName)
		    s ItemName = ItemName_$case(CCode,"":"",:"."_CCode_" "_CCodeName)
		    s ItemName = ItemName_$case(MACode,"":"",:"."_MACode_" "_MACodeName)
		    if (temType="KB")
		    {
			   s ItemName = ItemName_$case(CSCode,"":"",:CSCode_" "_CSCodeName)
			}
			else
			{
				s ItemName = ItemName_$case(CSCode,"":"",:"."_CSCode_" "_CSCodeName)
			}
		}
	    s ItemName = ItemName_"."_glossaryItem.valueText
	    s ItemName = Name_"."_ItemName
	    s InObject.params.itemName = ItemName
	    s InObject.params.id = TemplateID
	    s InObject.params.TemType = temType
	    d ##Class(EMR.DOC.BL.GlossaryItem).AddGlossaryItem(InObject,argInData,argOutMessage,argOutData) 
	    if (argOutMessage.errorMessage'=""){
		  	s strMark=argOutMessage.errorMessage
		  	q    
		}
	}
	q strMark
Error
	d argOutData.Clear()
	TROLLBACK
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// desc: 文档元素关联术语集 
/// Creator:    duan
/// CreateDate: 2021-06-17
/// Input:       argArray  	命令参数 {"action":"ADD_GLOSSARYITEM_DOCUMENT","product":"GlobalEMR","params":{"id":"",//文档ID"glossary":[{"CCode":"",//段落编码没有不传"SCode":"",//章节编码"CSCode":"",//简单元素编码"MACode":"",//复合元素编码"CCodeName":"",//编码名称"SCodeName":"","CSCodeName":"","MACodeName":"","itemType":"ISECTIONDESC",//关联类型（ISECTIONDESC（章节)，ICOMPOSITEDESC(复合元素)，ICOMPOSITESAMPLE(结构化元素)，ICONCEPTDESC(医学概念)，ICONCEPTSAMPLE(医学概念子元素),IMACRODESC(宏对象(存储部分医学公式，月经生育史，眼科前房深度公式))，IMACROSAMPLE(宏对象子元素)）"glossaryID":"3||LF",//术语集ID（key）"valueType":"S",//术语集选项值类型"valueText":"样式"//术语集选项值}],"type":"GLOSSARY"}}
/// Output:    
/// Desc:       获取模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aParentId 目录ID
///             aProduct 项目标识
///             aRoleID 角色ID
///             DataTypes 授权数据类型
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.Template).GetJsonTempalteByCID(0,1,1,)
ClassMethod GetJsonTempalteByCID(aParentId As %String, aProductid As %String, aRoleID As %String, DataTypes As %String, Type As %String, ByRef jsonCategory As %DynamicArray) As %String
{
	s res = "1"
	s rowTemID = "",sequence=""
	for 
	{
		s sequence = $o(^CF.EMR.DOC.TemplateI("IdxProCatSeq",aProductid,aParentId,sequence))
		q:sequence=""
		for
		{
		s rowTemID = $o(^CF.EMR.DOC.TemplateI("IdxProCatSeq",aProductid,aParentId,sequence,rowTemID))
		q:(rowTemID = "")				
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(rowTemID)
	    continue:(objTem="")
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s productObj = ##class(CT.EMR.DOC.Products).%OpenId(aProductid)
	    s jsonTem.key = rowTemID_"||DT"
	    s jsonTem.title = objTem.Name
	    s jsonTem.GUID = objTem.GUID
	    s jsonTem.type = "DT"
	    s jsonTem.emrName=objTem.EMRName
	    s jsonTem.description = objTem.Description
	    s jsonTem.chartItemType = objTem.ChartItemType
	    s jsonTem.documentType = objTem.DocumentType.Code
	    s jsonTem.lastVersion = objTem.TempLastVersion
	    s jsonTem.product=objTem.Product.ProductCode
	    
	    // 获取最新版本的状态
	   	s jsonTem.InstanceData=##class(EMR.DOC.BL.Template).GetInitData(objTem.TempLastVersion,rowTemID)

	    s status=""
	    &sql(select Status into status from CF_EMR_DOC.TemplateVersion where Template =:rowTemID and TepmplateVersionNumber =:objTem.TempLastVersion)
	    ;s objVersion=##class(CF.EMR.DOC.TemplateVersion).%OpenId(objTem.TempLastVersion)
	    s jsonTem.lastStatus=status
	    //获取版式信息
	    if (objTem.HFFormat'=""){
			s jsonTem.HFFormat =  objTem.HFFormat.%Id()_"||LF"
			s jsonTem.HFFormatName = objTem.HFFormat.Name    
		}
		
		
	    
	    
	    //判断是否有授权数据
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductid,aRoleID,DataTypes,"DT",rowTemID)
	    ;continue:(Permission<="0")
		s jsonTem.permission = Permission
		
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductid,aRoleID,DataTypes,"DT",rowTemID)
		s jsonTem.checked=checkStatus

	    s jsonTem.sequence = rowTemID
	    
	    s category = ##class(%DynamicArray).%New()
	    if (Type="DT") 
	    {
		    s jsonTem.children=""
		}
	    else
	    {
			d ##Class(EMR.DOC.BL.LocTemplateCategory).getCategoryByTemplateID(rowTemID,.category,aProductid,aRoleID,DataTypes)
			s jsonTem.children = category
	    }
		d jsonCategory.%Push(jsonTem)	
		}	
	}

	q res
}

/// Desc:       文档审核
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"TEMPLATE_AUDIT", "params":{"id":15, "name":"入院记录内科更新文档接口测试", "description":"入院记录内科","HFFormat":2,"templateCategory":168},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AuditTempalte(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type=argInJson.params.type
	s ID=..GetIDByKey(argInJson.params.id)
	
	if (type="DT")
	{
		// 审核基础文档
		;s res=##class(EMR.DOC.BL.Template).auditTemplate(ID)
		s rowID=..GetIDByKey(ID)
		s res= ##class(EMR.DOC.BL.TemplateAudit).AuditTemplateJson("3","申请审核",rowID)

	}
	else
	{
		// 审核科室文档
		;s res=##class(EMR.DOC.BL.LocTemplate).auditTemplate(ID)
		s rowID=..GetIDByKey(ID)
		s res= ##class(EMR.DOC.BL.LocTemplateAudit).AuditLocTemplateJsonp("3","申请审核",rowID)	

	}
	
	
	if (res="-100")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未传入文档ID",2)
	}
	elseif (res="-200")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","文档不存在",2)
	}else
	{
		q argOutMessage.success = ..#OK
	}	
Error
	d argOutData.Clear()
	TROLLBACK
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

/// Creator:    yejian
/// Desc:       审核文档
/// CreateDate: 2020-12-17
/// Input:      ATemplate 文档对象
/// output:     成功： 模板ID 失败：-101 保存文档失败  -102 "更新目录失败"
/// 									-200 必填项校验失败
/// 									-301 目录对象为空 -302 文档类型为空 -303 文档版式不存在							 
/// Debug:      w ##Class(EMR.DOC.COM.Template).AddTemplate()
ClassMethod auditTemplate(ATemplate As %String) As %String
{
	q:(ATemplate="") "-100"
	s objTem=##class(CF.EMR.DOC.Template).%OpenId(ATemplate)
	q:(objTem="" ) "-200"
	// 获取最新版本
	s lastVersion=objTem.TempLastVersion
	s rowID=""
	&sql(select ID into :rowID from CF_EMR_DOC.TemplateVersion where Template =:ATemplate and TepmplateVersionNumber =:lastVersion)
	s res= ##class(EMR.DOC.BL.TemplateAudit).AuditTemplateJson("3","申请审核",rowID)
	q "1"
}

/// Creator:    yejian
/// Desc:       添加文档
/// CreateDate: 2020-12-17
/// Input:      ATemplate 文档对象
/// output:     成功： 模板ID 失败：-101 保存文档失败  -102 "更新目录失败"
/// 									-200 必填项校验失败
/// 									-301 目录对象为空 -302 文档类型为空 -303 文档版式不存在							 
/// Debug:      w ##Class(EMR.DOC.COM.Template).AddTemplate()
ClassMethod AddTemplateJson(ATemplate As EMR.DOC.DTO.Template, AUserCode As %String, rulesStr As %String, rulesDescription As %String, roleCode As %String) As %String
{
	s strRes = "-101"
	q:((ATemplate.HFFormat="")||(ATemplate.DocumentType="")||(ATemplate.ChartItemType="")||(ATemplate.Name="")||(ATemplate.TemplateCategory="")) "-200"
	TSTART
	s GUID = ##class(%SYSTEM.Util).CreateGUID()
	s objTemplate = ##class(CF.EMR.DOC.Template).%New()
	s objTemplate.Name = ATemplate.Name
 	s objTemplate.Description = ATemplate.Description
 	s objTemplate.EMRName= ATemplate.Name
 	if (ATemplate.EMRName'="")
 	{
	 	s objTemplate.EMRName=ATemplate.EMRName
	}
 	s objTemplate.GUID = GUID
 	s objTemplateCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(ATemplate.TemplateCategory)
 	if (objTemplateCategory="")
 	{
	 	TROLLBACK
		q "-301"
 	}
 	s objTemplate.Product = objTemplateCategory.Product
 	s strProductID = objTemplateCategory.Product.%Id()
 	s objTemplate.ChartItemType = ATemplate.ChartItemType
 	
 	s rowDocTypeID = $o(^CT.EMR.DOC.TemplateTypesI("IdxCode"," "_$zcvt(ATemplate.DocumentType,"U"),""))
 	if (rowDocTypeID'="")
 	{
	 	s objDocumentType = ##class(CT.EMR.DOC.TemplateTypes).%OpenId(rowDocTypeID)
	 	if (objDocumentType="")
	 	{
		 	TROLLBACK
			q "-302"
	 	}
	 	s objTemplate.DocumentType = objDocumentType
 	}else{
	 	TROLLBACK
		q "-302"
	}
 
	s objHFFormat = ##class(CF.EMR.DOC.HFFormat).%OpenId(ATemplate.HFFormat)
	if (objHFFormat="")
	{
		TROLLBACK
		q "-303"
	}
 	s objTemplate.HFFormat = objHFFormat	
 	
 
 	s objTemplate.TempLastVersion = 0
	
	s objTemplate.TemplateCategory = objTemplateCategory
	s objTemplateCategory.ResChildCount = objTemplateCategory.ResChildCount + 1
	if '(objTemplateCategory.%Save())
	{
		TROLLBACK
		q "-102"
	} 
	if '(objTemplate.%Save())
 	{
		TROLLBACK
		q strRes
	} 
	//添加文档目录成功 设置目录权限为可编辑
	s roleId = ##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:roleId=""
	s strRes = objTemplate.%Id()
	s objTemplate.Sequence=strRes
	d objTemplate.%Save()
	s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(roleId,strRes,"TEMPLATE","DT",objTemplate.Name,strProductID)
	if (isOk'="1"){
		TROLLBACK
		s strRes = "-103"
		q strRes
	}
	s idStr=strRes_"||DT"
	//添加文档目录成功 设置文档规则
	s res = ##Class(EMR.DOC.BL.TemplateRules).AddRules(idStr,rulesStr,rulesDescription,"")
	if (res'="1"){
		TROLLBACK
		s strRes = "-103"
		q strRes
	}
	TCOMMIT
	
	
	q strRes
}

/// Desc:       更新文档
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      ATemplate 模板对象
/// output:     模板ID
/// Debug:      w ##Class(EMR.DOC.COM.Template).UpTemplate()
ClassMethod UpTemplateJson(ATemplate As EMR.DOC.DTO.Template) As %String
{
	s strRes = "-200"
	TSTART
	q:(ATemplate="")||(ATemplate.ID="") strRes
	s strRes = "-301"
	s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(ATemplate.ID)
	if (objTemplate="")
	{
		TROLLBACK
		q strRes
	}
	s strRes = "-101"
	s strCategoryID = objTemplate.TemplateCategory.%Id()
	//剪切：目录ID不一致
 	if ((ATemplate.TemplateCategory'="")&&(strCategoryID'=ATemplate.TemplateCategory))
 	{
		s objTemplateCategoryNew = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(ATemplate.TemplateCategory)
		if ((objTemplate.TemplateCategory="")||(objTemplateCategoryNew=""))
		{
	 		TROLLBACK
			q strRes
		}
		
		s objTemplateCategoryNew.ResChildCount = objTemplateCategoryNew.ResChildCount +1
		s objTemplate.TemplateCategory.ResChildCount = objTemplate.TemplateCategory.ResChildCount-1
		if '(objTemplateCategoryNew.%Save())
	 	{
		 	TROLLBACK
			q strRes
		} 
		if '(objTemplate.TemplateCategory.%Save())
	 	{
		 	TROLLBACK
			q strRes
		} 
		s objTemplate.TemplateCategory = objTemplateCategoryNew
 	}
 	else //更新，目录ID不变
 	{
		s objTemplate.Name = ATemplate.Name
	 	s objTemplate.Description = ATemplate.Description
	 	s objTemplate.EMRName=ATemplate.EMRName
	 	s objTemplate.ChartItemType=ATemplate.ChartItemType
	 	
	 	s rowDocTypeID = $o(^CT.EMR.DOC.TemplateTypesI("IdxCode"," "_$zcvt(ATemplate.DocumentType,"U"),""))
 		if (rowDocTypeID'="")
 		{
	 		s objDocumentType = ##class(CT.EMR.DOC.TemplateTypes).%OpenId(rowDocTypeID)
	 		if (objDocumentType="")
	 		{
		 		TROLLBACK
				q "-302"
	 		}
	 	s objTemplate.DocumentType = objDocumentType
 		}
	 	if (ATemplate.HFFormat'="")
	 	{
		 	s objHFFormat = ##class(CF.EMR.DOC.HFFormat).%OpenId(ATemplate.HFFormat)
		 	if (objHFFormat="") 
		 	{
			 	TROLLBACK
				q strRes
		 	}
	 		s objTemplate.HFFormat = objHFFormat	
	 	}
	 	//s objTemplate.LastVersion = 0
	 	//s objTemplate.PublishVersion = 0
 	}
	if '(objTemplate.%Save())
 	{
	 	TROLLBACK
		q strRes
	} 
	
	// 修改最新version的版式
	TCOMMIT
	s strRes = "1"
	q strRes
}

/// Desc:       删除文档
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      ATemplate 模板对象
/// output:     模板ID
/// Debug:      w ##Class(EMR.DOC.BL.Template).DelTemplate()
ClassMethod DelTemplateJson(aID As %String) As %String
{
	s strRes ="-200"
	q:aID="" strRes
	s strRes = "-301"
	TSTART
	s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(aID)
	if (objTemplate ="")
	{
		TROLLBACK
		q strRes
	}
#;	s strRes = "-101"
#;	s tempVersionCount = 0
#;	&SQL(select count(*) into:tempVersionCount from CF_EMR_DOC.TemplateVersion where Template = :aID)
#;	q:tempVersionCount>0 strRes
	s strRes = "-4"
	s objTemplateCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemplate.TemplateCategory.%Id())
	if (objTemplateCategory ="")
	{
		TROLLBACK
		q strRes
	}	
	s objTemplateCategory.ResChildCount = objTemplateCategory.ResChildCount - 1
	
	// 获取最新version 状态改变
	s maxID=""
	&sql(select max(ID) into:maxID from CF_EMR_DOC.TemplateVersion where Template = :aID)
	if (maxID'="")
	{
		s objVersion=##class(CF.EMR.DOC.TemplateVersion).%OpenId(maxID)
		s objVersion.Status= -1
		if '(objVersion.%Save())
		{
			TROLLBACK
			q strRes
		}
	}
	
	if '(objTemplateCategory.%Save())
	{
		TROLLBACK
		q strRes
	}	
	 
	if '(objTemplate.%DeleteId(aID))
	{
		TROLLBACK
		q strRes
	}
	
	TCOMMIT
	s strRes ="1"
	q strRes
}

/// Desc:       获取模板关联的业务数据模型
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      ATemplate 模板对象
/// output:     模板ID
/// Debug:      w ##Class(EMR.DOC.BL.Template).GetBDMDocIDbyTemID(1)
ClassMethod GetBDMDocIDbyTemID(aID As %String) As %String
{
	s strRes ="-1"

	s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(aID)
	q:((objTemplate ="")||(objTemplate.HFFormat="")||(objTemplate.HFFormat.BDMCategory="")) strRes
	s strRes =objTemplate.HFFormat.BDMCategory.%Id()
	q strRes
}

/// w ##Class(EMR.DOC.BL.Template).Test()
ClassMethod Test() As %String
{
	s ReturnValue = ""
	
	s objDTO  = ##class(EMR.DOC.DTO.Template).%New()
	
	//s objDTO.Code = "EMR090001"
	s objDTO.Name = "入院记录"
	s objDTO.Description = " 入院记录"
	s objDTO.GUID = "831650e5-21ce-4ddc-bb62-092fe3d92517"
	s objDTO.DocumentType = "DOC"
	s objDTO.TempLastVersion = 1
	s objDTO.TempPublishVersion = 1
	s objDTO.TemplateCategoryCode = "EMR090001"
	
	s ReturnValue =  ..AddTemplate(objDTO)
	
	q ReturnValue
}

/// Desc:       根据文档获取文档下的版本列表数据
/// Creator:    duan
/// CreateDate: 2021-06-15
/// Input:      TemplateID 文档ID
/// output:     成功：１　失败： -201 文档ID不能为空
/// Debug:      w ##Class(EMR.DOC.BL.Template).GetBDMDocIDbyTemID(1)
ClassMethod GetVersionListJson(TemplateID As %String, ByRef argOutData As %GlobalBinaryStream)
{
	q:TemplateID="" -201
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.Template:GetVersionList")
	d result.Execute(TemplateID)
	s jsonArr = ##class(%DynamicArray).%New()
	While result.Next() 
	{
		s jsonObj  = ##class(%DynamicObject).%New()
	 	s jsonObj.id = result.GetDataByName("ID")
	 	s jsonObj.number = result.GetDataByName("Number")

        d jsonArr.%Push(jsonObj)
	}
	d jsonArr.%ToJSON(argOutData)
	q 1
}

/// d ##class(%ResultSet).RunQuery("EMR.DOC.BL.Template","GetVersionList","","")
/// desc 根据userCode或userName做模糊查找
Query GetVersionList(aTemplateID As %String = "") As %SQLQuery
{
	SELECT a.ID, a.TepmplateVersionNumber AS Number FROM CF_EMR_DOC.TemplateVersion a WHERE Template = :aTemplateID AND Status !="-1" Order by Number
}

/// desc 根据文档ID获取文档关联术语时的层次名称描述
/// creator duan
/// debug w ##class(EMR.DOC.BL.Template).GetNameByID()
ClassMethod GetNameByID(aID As %String, aType As %String)
{
	s result = ""
	q:((aID="")||(aType="")) result
	if ((aType="DT")||(aType="EMRINSTANCE")){
		s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(aID)
		q:objTemplate="" result	
		s result = objTemplate.Name
		s objCategoryID = objTemplate.TemplateCategory.%Id()
		s res = ..GetNameByID(objCategoryID,"CG")
		;s result=objTemplate.TemplateCategory.Code_result
		s:res'="" result = res_"."_result
	}
	elseif(aType="CG")
	{
		s objCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(aID)
		q:objCategory="" result
		s result = objCategory.Name
		s parentID = objCategory.ParentID
		if (parentID>0){
			s res = ..GetNameByID(parentID,"CG")
			s result=objCategory.Code_" "_result
			s:res'="" result = res_"."_result	
		}
		
	}
	elseif(aType="BDM"){
		s objBdm = ##class(CF.EMR.DOC.BDMCategory).%OpenId(aID)
		q:objBdm="" result	
		s result = objBdm.Name
		s objCategoryID = objBdm.ParentID
		s res = ..GetNameByID(objCategoryID,"BDM_CG")
		s result=objBdm.Code_" "_result
		s:res'="" result = res_"."_result
	}
	elseif(aType="BDM_CG")
	{
		s objCategory = ##class(CF.EMR.DOC.BDMCategory).%OpenId(aID)
		q:objCategory="" result
		s result = objCategory.Name
		s parentID = objCategory.ParentID
		if (parentID>0){
			s res = ..GetNameByID(parentID,"BDM_CG")
			s result=objCategory.Code_" "_result
			s:res'="" result = res_"."_result	
		}
	}
	elseif(aType="KB")
	{
		s objTemplate=##class(CF.EMR.DOC.KBNode).%OpenId(aID)
		q:objTemplate="" result
		s result=objTemplate.Name
		s objCategoryID=objTemplate.KBCategory.%Id()
		s res=..GetNameByID(objCategoryID,"KB_CG")
		s:res'="" result = res_"."_result
	}
	elseif(aType="KB_CG")
	{
		s objCategory = ##class(CF.EMR.DOC.KBCategory).%OpenId(aID)
		q:objCategory="" result
		s result = objCategory.Name
		s parentID = objCategory.ParentID
		if (parentID'=0){
			s res = ..GetNameByID(parentID,"KB_CG")
			s:res'="" result = res_"."_result	
		}
	}
	q result
}

/// Desc:       根据模板版本是否有实例数据
/// Creator:    huhao
/// CreateDate: 2022-9-8
/// Input:      TemplateID 文档ID
/// 				TemplateVersion  版本ID
/// output:     已创建实例：１　未创建实例： 0
/// Debug:      d ##class(EMR.DOC.BL.Template).GetInitData(659,165)
ClassMethod GetInitData(versionId As %String, tmpId As %String) As %String
{
	s strRes=""
	s result=##Class(%ResultSet).%New("EMR.DOC.BL.Template:SelectNode")
	d result.%Execute()
	while(result.%Next())
	{
		s node=result.Data("NodeID")
		s status=""
		for
		{
			s value="status=$o(^EMR."_node_".DocumentDataI(""IdxTemplateVStatus"","_tmpId_","_versionId_",""""))"
			s @value
			if (status'="")
			{
				s strRes=strRes_"实例已创建"
			}
			else
			{
				s strRes=strRes_"实例未创建"
			}
			q:strRes'=""
		}
		
	}
	if (strRes["实例已创建") 
	{	q 1	}
	else
	{	q 0	}
}

/// Desc:       获取分库列表
/// Creator:    huhao
/// CreateDate: 2022-9-8
Query SelectNode() As %SQLQuery
{
	SELECT NodeID FROM CF_EMR_DOC.NodeConfig
}

}
