/// 名称:EMR.DOC.BL.LocTemplateCategory
/// 描述:通用文档管理模块 Document(Doc) 公用程序层 LocTemplateCategory维护业务类
/// 编写者：ningyanghong
/// 编写日期: 2020-12-10
/// 产品组：电子病历产品组
Class EMR.DOC.BL.LocTemplateCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取科室模板目录
/// Creator:    ningyanghong
/// CreateDate: 2021-12-21
/// Output:     q ##Class(EMR.DOC.BL.LocTemplateCategory)GetLocTemplateTree()
ClassMethod GetLocTemplateTree(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	// 基础模板ID
	s parentID=..GetIDByKey(argInJson.params.templateId)
	s res=##class(EMR.DOC.BL.LocTemplateCategory).getCategoryByTemplateID(parentID,.argOutData)
	if (res="-101")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","请传入基础模板ID",2)
	}
	elseif (res="-102")
	{
			q ..SetOutMessage(argOutMessage,"ERROR","基础模板ID不存在",2)
	}
	elseif(res="1")
	{
	    q argOutMessage.success = ..#OK
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       添加文档目录
/// Creator:    ningyanghong
/// CreateDate: 2020-12-21
/// Input:      argArray  	命令参数 {"action":"ADD_LOCTEMPLATE_MANAGE","params":{"name":"住院IP添加目录测试","description":"住院IP添加目录测试","disease":"","emrName":"","childType":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddLocTemplateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.LocTemplateCategory).%New()
	s argDTO.Name = argInJson.params.title
	s argDTO.Disease=argInJson.params.disease
	s argDTO.Description = argInJson.params.description
	s parentType=$P(argInJson.params.id,"||",2)
	s argDTO.ParentID= ..GetIDByKey(argInJson.params.id)
	s argDTO.EMRName=argInJson.params.emrName
	s argDTO.StructType = argInJson.params.childType
	s userCode = argInJson.params.userCode
	s safeGroupId=argInJson.params.safeGroupId
	
	s rulesStr=argInJson.params.ruleStr
	s rulesDescription=argInJson.params.ruleDes
	
	
	s strRes = ##Class(EMR.DOC.BL.LocTemplateCategory).AddTemplateCategoryJson(parentType,argDTO,userCode,rulesStr,rulesDescription,safeGroupId,.argOutData)
	if (strRes="1"){
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	elseif (strRes = "-301")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","父目录对象为空,检查参数是否正确",2)	
	}
	elseif (strRes = "-102")
	{
		q ..SetOutMessage(argOutMessage,"ERROR","设置权限失败",2)	
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       删除文档目录
/// Creator:    ningyanghong
/// CreateDate: 2020-12-21
/// Input:      argArray  	命令参数 {"action":"DELETE_LOCTEMPLATE_MANAGE","params":{"id":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod DeleteLocTemplateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type=argInJson.params.type
	s ID= ..GetIDByKey(argInJson.params.id)
	
	if (type="IT")
	{
		// 删除模板
		s res=##class(EMR.DOC.BL.LocTemplate).DeleteLocTemplate(ID)
		
	}
	elseif (type="VT")
	{
		// 删除版本
		s res=##class(EMR.DOC.BL.LocTemplateVersion).DeleteLocTemplateVersion(ID)
	}
	else
	{
		// 删除目录
		s res=##class(EMR.DOC.BL.LocTemplateCategory).DeleteLocCategory(ID)
	}
	
	
	if (res="1"){
	    q argOutMessage
	}
	elseif (res = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	elseif (res = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","节点不存在",2)
	}
	elseif (res = "-300")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","删除失败",2)
	}
	elseif (res = "-301")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有子节点不允许删除",2)
	}elseif (res = "-302")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","已发布版本不可删除",2)
	}
	elseif (res = "-303")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","更新目录失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       更新文档目录
/// Creator:    ningyanghong
/// CreateDate: 2020-12-21
/// Input:      argArray  	命令参数 {"action":"UPDATE_LOCTEMPLATE_MANAGE","params":{"title":"住院IP添加目录测试","description":"住院IP添加目录测试","disease":"IP","emrName":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod UpdateLocTemplateCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.LocTemplateCategory).%New()
	s argDTO.Name = argInJson.params.title
	s argDTO.Disease=argInJson.params.disease
	s argDTO.Description = argInJson.params.description
	s type=$P(argInJson.params.id,"||",2)
	s ID= ..GetIDByKey(argInJson.params.id)
	s argDTO.EMRName=argInJson.params.emrName
	s userCode = argInJson.params.userCode
	if (type="IT")
	{
		// 更新模板属性
		s res=##class(EMR.DOC.BL.LocTemplate).UpdateLocTemplate(argDTO,ID)
	}
	else
	{
		// 更新目录属性
		s res=##class(EMR.DOC.BL.LocTemplateCategory).UpdateLocCategory(argDTO,ID)
	}
	
	
	if (res="1"){
	    q argOutMessage
	}
	elseif (res = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	elseif (res = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","节点不存在",2)
	}
	elseif (res = "-300")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","更新失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Description:   删除目录
/// Input：        
/// Output         -200 必填参数未填(parentType，obj)
///                -301 父目录ID对象不存在  -302 项目标识不存在
/// 			   -101 添加目录数据失败 -102 设置权限失败
/// 					
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.COM.TemplateCategory).Add()
ClassMethod DeleteLocCategory(ID As %String) As %String
{
	q:(ID="") "-100"
	s objTem=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(ID)
	q:(objTem="") "-200"
	
	
	if (objTem.ResChildCount '=0)
	{
		q "-301"
	}
	else 
	{
		s countCat=""
		&sql(select count(*) from CF_EMR_DOC.LocTemplateCategory where ParentID = :ID)
		if (countCat'="")
		{
			// 有子节点不允许删除
			q "-301"
		}
	}
	
	d ##class(CF.EMR.DOC.LocTemplateCategory).%DeleteId(ID)
	
	
	
	q "1"
}

/// Description:   新增目录
/// Input：        
/// Output         -200 必填参数未填(parentType，obj)
///                -301 父目录ID对象不存在  -302 项目标识不存在
/// 			   -101 添加目录数据失败 -102 设置权限失败
/// 					
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.COM.TemplateCategory).Add()
ClassMethod AddTemplateCategoryJson(parentType As %String, argDTO As EMR.DOC.DTO.LocTemplateCategory, argUserCode As %String = "", rulesStr As %String, rulesDescription As %String, roleCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:((argDTO.ParentID = "")||(argDTO.Name="")||(argDTO.StructType="")) "-200" 
	s roleId=##class(EMR.DOC.BL.RBACRole).GetRoleByCode(roleCode)
	q:roleId="" "-1^安全组信息出错"
	TSTART
	// 根节点新增目录或者模板
	if (parentType="DT")
	{
		// 判断父节点是否存在
		s objTemplate=##class(CF.EMR.DOC.Template).%OpenId(argDTO.ParentID)
		q:(objTemplate="") "-301"
		// 新增目录
		if (argDTO.StructType="LC")
		{
			s obj = ##class(CF.EMR.DOC.LocTemplateCategory).%New()
			s obj.Description=argDTO.Description
			s obj.EMRName=argDTO.EMRName
			s obj.Name=argDTO.Name
			s obj.Product=objTemplate.Product
			s obj.TemplateID=objTemplate
			s obj.ResChildCount=0
			s obj.Sequence=+(^CF.EMR.DOC.LocTemplateCatD)+1
			s sc = obj.%Save()
			if ('$$$ISOK(sc))
			{
				TROLLBACK
				q "-1"
			}
			s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(roleId,obj.%Id(),"TEMPLATE",argDTO.StructType,argDTO.EMRName,objTemplate.Product.%Id())
			if (isOk'=1)
			{
				TROLLBACK
				q "-102"
			}
		}
		else
		{
			// 新增模板
			s objTem=##class(CF.EMR.DOC.LocTemplate).%New()
			s objTem.Description=argDTO.Description
			if (argDTO.Disease'="")
			{
				s ID= ..GetIDByKey(argDTO.Disease)
				s objDis=##class(CF.EMR.DOC.Diagnos).%OpenId(ID)
				if (objDis'="")
				{
					s objTem.Disease=objDis
				}
			}
			s objTem.EMRName=argDTO.EMRName
			s objTem.TemplateID=objTemplate
			s objTem.Name=argDTO.Name
			s objTem.Product=objTemplate.Product
			s objTem.Sequence=+(^CF.EMR.DOC.LocTemplateD)+1
			s sc = objTem.%Save()
			if ('$$$ISOK(sc))
			{
				TROLLBACK
				q "-1"			
			}
			s locTemplateID=objTem.%Id()
			d ##Class(EMR.DOC.BL.LocTemplateVersion).AddTemplateVersionJson(locTemplateID,.argOutData)
			// 新增文档规则
			s idStr=locTemplateID_"||IT"
			s resStr = ##Class(EMR.DOC.BL.TemplateRules).AddRules(idStr,rulesStr,rulesDescription,"")
			if (resStr'=1)
			{
				TROLLBACK
				q "-1"
			}
			s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(roleId,objTem.%Id(),"TEMPLATE",argDTO.StructType,argDTO.EMRName,objTem.Product.%Id())
			if (isOk'=1)
			{
				TROLLBACK
				q "-102"
			}
		}
	}
	// 父目录下添加子目录或者文档
	else
	{
		s objParent=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(argDTO.ParentID)
		q:(objParent="") "-301"
		// 添加目录
		if (argDTO.StructType="LC")
		{
			s obj = ##class(CF.EMR.DOC.LocTemplateCategory).%New()
			s obj.Description=argDTO.Description
			s obj.EMRName=argDTO.EMRName
			s obj.ParentID=+(argDTO.ParentID)
			s obj.Name=argDTO.Name
			s obj.TemplateID=objParent.TemplateID
			s obj.Product=objParent.Product
			s obj.ResChildCount=0
			s obj.Sequence=+(^CF.EMR.DOC.LocTemplateCatD)+1
			s sc = obj.%Save()
			if ('$$$ISOK(sc))
			{
				TROLLBACK
				q "-1"
			}
			s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(roleId,obj.%Id(),"TEMPLATE",argDTO.StructType,argDTO.EMRName,objParent.Product.%Id())
			if (isOk'=1)
			{
				TROLLBACK
				q "-102"
			}
		}
		else
		{
			// 新增模板
			s objTem=##class(CF.EMR.DOC.LocTemplate).%New()
			s objTem.Description=argDTO.Description
			if (argDTO.Disease'="")
			{
				s ID= ..GetIDByKey(argDTO.Disease)
				s objDis=##class(CF.EMR.DOC.Diagnos).%OpenId(ID)
				if (objDis'="")
				{
					s objTem.Disease=objDis
				}
			}
			
			s objTem.EMRName=argDTO.EMRName
			s objTem.TemplateID=objParent.TemplateID
			s objTem.LocTemplateCategory=objParent
			s objTem.Product=objParent.Product
			s objTem.Sequence=+(^CF.EMR.DOC.LocTemplateD)+1
			s objTem.Name=argDTO.Name
			s sc = objTem.%Save()
			
			if ($$$ISOK(sc))
			{
				// 保存成功 目录节点的resChild+1
				s objParent.ResChildCount=objParent.ResChildCount+1
				if '(objParent.%Save())
				{
					q "-304"
				}
				
				// 新增模板 新增历史和版本
				s locTemplateID=objTem.%Id()
				d ##Class(EMR.DOC.BL.LocTemplateVersion).AddTemplateVersionJson(locTemplateID,.argOutData)
				// 新增文档规则
				s idStr=locTemplateID_"||IT"
				s resStr = ##Class(EMR.DOC.BL.TemplateRules).AddRules(idStr,rulesStr,rulesDescription,"")
				
			}
			s isOk = ##class(EMR.DOC.BL.RBACDataPermission).AddPermissionData(roleId,objTem.%Id(),"TEMPLATE",argDTO.StructType,argDTO.EMRName,objParent.Product.%Id())
			if (isOk'=1)
			{
				TROLLBACK
				q "-102"
			}
		}
	}
	TCOMMIT
	q "1"
}

/// Desc:       获取模板树结构
/// Creator:    ningyanghong
/// CreateDate: 2021-12-21
/// Input:      templateID基础模板ID
/// OutPut:     -101 ID未输入  -102 模板不存在 
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
ClassMethod UpdateLocCategory(argDTO As EMR.DOC.DTO.LocTemplateCategory, ID As %String) As %String
{
	q:(ID="") "-100"
	s objCat=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(ID)
	q:(objCat="") "-200"
	s objCat.Description=argDTO.Description
	s objCat.EMRName=argDTO.EMRName
	s objCat.Name=argDTO.Name
	
	s sc = objCat.%Save()
	if ('$$$ISOK(sc))
	{
		q "-300"
	}
	q "1"
}

/// Desc:       获取模板树结构
/// Creator:    ningyanghong
/// CreateDate: 2021-12-21
/// Input:      templateID基础模板ID
/// OutPut:     -101 ID未输入  -102 模板不存在 
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.LocTemplateCategory)getCategoryByTemplateID("147||DT",.argOutData)
ClassMethod getCategoryByTemplateID(templateID As %String, category As %DynamicArray, aProductid As %String, aRoleID As %String, DataTypes As %String) As %String
{
	// 未传入ID
	s res="-101"
	q:(templateID="") res
	s res="-102"
	s count=""
	&sql(select count(*) into :count from CF_EMR_DOC.Template where ID=:templateID)
	q:(count=0) res	
	s result=##class(%ResultSet).%New("EMR.DOC.BL.LocTemplateCategory:GetCategoryDataByTemplateID")
	d result.Execute(templateID)
	While result.Next() 
	{
		s jsonItem = ##class(%DynamicObject).%New()
		s rowID=result.GetDataByName("ID")
     	s jsonItem.key =rowID_"||LC"
     	s jsonItem.type="LC"
     	s childCount=result.GetDataByName("ResChildCount")
     	s jsonItem.description=result.GetDataByName("Description")
     	s jsonItem.title=result.GetDataByName("Name")
     	s jsonItem.emrName=result.GetDataByName("EMRName")
     	s jsonItem.product=result.GetDataByName("ProductCode")
     	
     	s jsonCategory = ##class(%DynamicArray).%New()
    	if (childCount=0)
    	{
			d ##Class(EMR.DOC.BL.LocTemplateCategory).GetJsonCategroyByID(rowID,.jsonCategory,aProductid,aRoleID,DataTypes)
			
		}else
		{
			// 获取模板节点
			d ##Class(EMR.DOC.BL.LocTemplate).GetJsonTemplateByID(aProductid,aRoleID,DataTypes,templateID,rowID,.jsonCategory)
			
		}
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductid,aRoleID,DataTypes,"LC",rowID)
		s jsonItem.permission=Permission
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductid,aRoleID,DataTypes,"LC",rowID)
		s jsonItem.checked=checkStatus
		s:(jsonCategory.%Size()>0) jsonItem.children = jsonCategory
		
		
		// 除去子节点
     	s parentID =result.GetDataByName("ParentID") 
     	continue:(parentID'="")
     	d category.%Push(jsonItem)
	}
	
	// 没有目录子节点 获取模板数据
	;if (category.%Size()=0)
	;{
		s resultTem=##class(%ResultSet).%New("EMR.DOC.BL.LocTemplateCategory:GetTemplateDataByTemplateID")
		d resultTem.Execute(templateID)
		
		While resultTem.Next() 
		{
			s jsonItem = ##class(%DynamicObject).%New()
			s rowID=resultTem.GetDataByName("ID")
			s objLocTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(rowID)
			s jsonItem.key =rowID_"||IT"
     		s jsonItem.type="IT"
     		s parent=resultTem.GetDataByName("LocTemplateCategory")
     		
     		S jsonItem.description=resultTem.GetDataByName("Description")
     		s jsonItem.title=resultTem.GetDataByName("Name")
     		s jsonItem.template=objLocTem.TemplateID.%Id()_"||DT"
     		
     		s jsonItem.emrName=resultTem.GetDataByName("EMRName")
     		s jsonItem.disease=resultTem.GetDataByName("Disease")
     		s jsonItem.product=resultTem.GetDataByName("ProductCode")
     		s versionNumber=resultTem.GetDataByName("TempLastVersion")
     		
     		s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductid,aRoleID,DataTypes,"IT",rowID)
			s jsonItem.permission=Permission
			
			s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductid,aRoleID,DataTypes,"IT",rowID)
			s jsonItem.checked=checkStatus

     		s status=""
			&sql(select Status into :status from CF_EMR_DOC.LocTemplateVersion where TepmplateVersionNumber = :versionNumber and Template =:rowID)
			s jsonItem.lastStatus=status
			continue:(parent'="")
     		d category.%Push(jsonItem)
		}
	;}
	;d category.%Push(jsonArr)
	;d jsonArr.%ToJSON(argOutData)
	q "1"
}

/// Desc:       递归获取模板目录数据
/// Creator:    ningyanghong
/// CreateDate: 2020-12-21
/// Input:      aParentId 目录ID
/// Output:     q ##Class(EMR.DOC.BL.LocTemplateCategory)GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aParentId As %String, ByRef jsonCategory As %DynamicArray, aProductid As %String, aRoleID As %String, DataTypes As %String) As %String
{
	q:(aParentId="") jsonCategory
	s rowID=""
	for
	{
		s rowID = $o(^CF.EMR.DOC.LocTemplateCatI("IdxParentId"," "_$zcvt(aParentId,"u"),rowID))
		q:(rowID="")
		s jsonRoot  = ##class(%DynamicObject).%New()
		s objCategory=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(rowID)
		s jsonRoot.key=rowID_"||LC"
		s jsonRoot.title=objCategory.Name
		s jsonRoot.emrName=objCategory.EMRName
		s jsonRoot.type="LC" 
		s jsonRoot.description=objCategory.Description
		s jsonRoot.product=objCategory.Product.ProductCode
		//如果子节点为模板则ResChildCount不为0
		s category = ##class(%DynamicArray).%New()
		if (objCategory.ResChildCount=0)
		{
			d ##Class(EMR.DOC.BL.LocTemplateCategory).GetJsonCategroyByID(rowID,.category,aProductid,aRoleID,DataTypes)
		}else
		{
			// 获取模板
			d ##Class(EMR.DOC.BL.LocTemplate).GetJsonTemplateByID(aProductid,aRoleID,DataTypes,objCategory.TemplateID.%Id(),rowID,.category)

		}
	    s Permission = ##Class(EMR.DOC.BL.RBACDataPermission).GetDataPermission(aProductid,aRoleID,DataTypes,"LC",rowID)
		s jsonRoot.permission=Permission
		
		s checkStatus=##class(EMR.DOC.BL.RBACDataPermission).GetEditViewType(aProductid,aRoleID,DataTypes,"LC",rowID)
		s jsonRoot.checked=checkStatus

		s:(category.%Size()>0) jsonRoot.children = category
		d jsonCategory.%Push(jsonRoot)
	}
}

/// Desc:       科室模板目录排序
/// Creator:    huhao
/// CreateDate: 2022/11/22
/// Table:		CF.EMR.DOC.LocTemplateCategory
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod LocCatgorySort(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s option=argInJson.params.operation
	s id=..GetIDByKey(argInJson.params.id)
	s strRes = ##class(EMR.DOC.BL.LocTemplateCategory).sort(option,id)
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

/// Desc:       科室模板目录排序
/// Creator:    huhao
/// CreateDate: 2022/11/22
/// Table:		CF.EMR.DOC.LocTemplateCategory
/// Input:      id:科室模板id
/// 				operation：操作编码  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod sort(option As %String, id As %String) As %String
{
	q:option="" "-1^无操作"
	q:id="" "-1^id不能为空"
	if (option="mi_up")
	{
		s seq="",rowId=""
		s objCat=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(id)
		s oldSeq=objCat.Sequence
		s seq=$o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",objCat.TemplateID.%Id()," "_objCat.ParentID,oldSeq),-1)
		q:seq="" "-1^无法上移"
		s rowId=$o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",objCat.TemplateID.%Id()," "_objCat.ParentID,seq,rowId))
		s obj=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(rowId)
		s objCat.Sequence=obj.Sequence
		s obj.Sequence=oldSeq
		d obj.%Save()
		d objCat.%Save()
		q "1"
				
	}
	elseif (option="mi_down")
	{
		s seq="",rowId=""
		s objCat=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(id)
		s oldSeq=objCat.Sequence
		s seq=$o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",objCat.TemplateID.%Id()," "_objCat.ParentID,oldSeq))
		q:seq="" "-1^无法下移"
		s rowId=$o(^CF.EMR.DOC.LocTemplateCatI("IdxPidSeq",objCat.TemplateID.%Id()," "_objCat.ParentID,seq,rowId))
		s obj=##class(CF.EMR.DOC.LocTemplateCategory).%OpenId(rowId)
		s objCat.Sequence=obj.Sequence
		s obj.Sequence=oldSeq
		d obj.%Save()
		d objCat.%Save()
		q "1"
	}
	else
	{
		 q "-1^操作不明确"
	}
}

Query GetCategoryDataByTemplateID(id As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,EMRName:%String,ParentID:%String,ResChildCount:%Integer,Description:%String,ProductCode:%String", SELECTMODE = "RUNTIME") [ SqlName = GetCategoryDataByTemplateID, SqlProc ]
{
	select ID,Name,EMRName,ParentID,ResChildCount,Description,Product->ProductCode from CF_EMR_DOC.LocTemplateCategory where TemplateID = :id  order by Sequence
}

Query GetTemplateDataByTemplateID(id As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,EMRName:%String,Description:%String,Disease:%String,LocTemplateCategory:%String,TempLastVersion:%String,ProductCode:%String", SELECTMODE = "RUNTIME") [ SqlName = GetTemplateDataByTemplateID, SqlProc ]
{
	select ID,Name,EMRName,Description,Disease,LocTemplateCategory,TempLastVersion,Product->ProductCode from CF_EMR_DOC.LocTemplate where TemplateID = :id order by Sequence
}

}
