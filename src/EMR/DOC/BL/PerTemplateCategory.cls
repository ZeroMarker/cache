/// 名称:	EMR.DOC.BL.PerTemplateCategory
/// 描述:	个人模板目录业务逻辑(门诊、住院)
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PerTemplateCategory Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取个人模板目录树
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_PERCATEGORYBYID","params":{"userID":"10209","documentID":"60","episodeID":"6"}}
/// 			documentID 文档ID，userID 用户ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPerCategroyByID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.Product = argInJson.product
	s objItem.DocumentID= argInJson.params.documentID
	s objItem.UserID = argInJson.params.userID
	s objItem.EpisodeID = argInJson.params.episodeID
	s objItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.PerTemplateCategory).GetPerCategroyByIDJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取个人模板目录tree
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplateCategory).GetDPTreeJson("YS01")
ClassMethod GetPerCategroyByIDJson(aItem As EMR.DOC.DTO.PerTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aItem.UserID="") "-1^用ID不能为空"
	q:(aItem.DocumentID="") "-1^文档ID不能为空"
	q:(aItem.EpisodeID="") "-1^就诊号不能为空"
	
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^根据文档ID获取文档失败"
	s objUser=##class(User.SSUser).%OpenId(aItem.UserID,0)
	q:(objUser="") "-1^获取用户失败"
	s aItem.TemplateID = objDoc.TemplateID.%Id()
	s jsonArr = ##class(%DynamicArray).%New()
    s jsonCat  = ##class(%DynamicObject).%New()
	s userName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",objUser.SSUSRName,aItem.LangID)
	s baseName = userName_##class(EMRservice.HISInterface.Translation).Get("EMRTrans","个人模板")
    s jsonCat.id = "0"
    s jsonCat.text = baseName
    s jsonCat.nodeID ="0"
    s jsonCat.type = "root"
    s jsonCat.state = "open"
    s hasNode = $o(^CF.EMR.DOC.PerTempCatI("UserParentSequence",aItem.UserID,aItem.TemplateID,"0",""))
    s:(hasNode="") hasNode = $o(^CF.EMR.DOC.PerTemplateI("IdxUserIDSeq",aItem.UserID,aItem.TemplateID,"0",""))
    s isLeaf= $case(hasNode,"":"Y",:"N")
    s jsonCat.isLeaf = isLeaf
    s:(hasNode="") jsonCat.iconCls="tree-folder"
    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(baseName,4,"")
	s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(baseName,3,"")
	s jsonCategory = ##class(%DynamicArray).%New()
	//获取目录节点
	d ##Class(EMR.DOC.BL.PerTemplateCategory).GetJsonCategroyByPID("0",aItem,.jsonCategory)
	//获取个人模板节点
	d ##Class(EMR.DOC.BL.PerTemplate).GetPerTemplateByCID("0",aItem,.jsonCategory)
	s:(jsonCategory.%Size()>0) jsonCat.children = jsonCategory
	d jsonArr.%Push(jsonCat)
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取个人模板目录tree
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     
/// Debug:	q ##Class(EMR.DOC.BL.PerTemplateCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, aItem As EMR.DOC.DTO.PerTemplate, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s treeSeq = ""
	for {
		s treeSeq = $o(^CF.EMR.DOC.PerTempCatI("UserParentSequence",aItem.UserID,aItem.TemplateID,aParentId,treeSeq))
		q:(treeSeq = "")		
		s rowCID = $o(^CF.EMR.DOC.PerTempCatI("UserParentSequence",aItem.UserID,aItem.TemplateID,aParentId,treeSeq,""))		
		s objCat = ##Class(CF.EMR.DOC.PerTemplateCategory).%OpenId(rowCID)
	    continue:(objCat="")||(objCat.Status="-1")
	    s isLeaf= "",state="",iconCls=""
	    s hasNode = $o(^CF.EMR.DOC.PerTempCatI("UserParentSequence",aItem.UserID,aItem.TemplateID,rowCID,""))
	    s:(hasNode="") hasNode = $o(^CF.EMR.DOC.PerTemplateI("IdxUserIDSeq",aItem.UserID,aItem.TemplateID,rowCID,""))
	    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.PerTemplateCategory","Name",objCat.Name,aItem.LangID)
		s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.id ="category-"_rowCID
	    s jsonCat.nodeID = rowCID
	    s jsonCat.text = strName
	    s jsonCat.type = "category"
	    s jsonCat.state = "open"
	    s:(hasNode'="") jsonCat.iconCls="tree-folder"
	    s jsonCat.isLeaf = $case(hasNode,"":"Y",:"N")
	    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
		s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
		
		//递归获取子目录节点
		s jsonCateNew = ##class(%DynamicArray).%New()
		s result = ##Class(EMR.DOC.BL.PerTemplateCategory).GetJsonCategroyByPID(rowCID,aItem,.jsonCateNew)	
		//获取个人模板节点
		d ##Class(EMR.DOC.BL.PerTemplate).GetPerTemplateByCID(rowCID,aItem,.jsonCateNew)
		s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

/// Desc:       创建个人模板目录
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"CREATE_PERCATEGORY","params":{"userID":"10209","parentID":"1","name":"新建个人模板目录","documentID":"35"}}
/// 			parentID 目录ID，userID 用户ID，name 短语名称，type:类型
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CreatePerCategroy(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.ParentID = argInJson.params.parentID
	s objItem.Product = argInJson.product
	s objItem.Name = argInJson.params.name
	s objItem.UserID = argInJson.params.userID
	s objItem.DocumentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.PerTemplateCategory).CreatePerCategroyJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       创建个人模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplateCategory).CreatePerCategroyJson("")
ClassMethod CreatePerCategroyJson(aItem As EMR.DOC.DTO.PerTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.UserID="") "-1^用ID不能为空"
	s objUser=##class(User.SSUser).%OpenId(aItem.UserID,0)
	q:(objUser="") "-1^获取用户失败"
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s objc = ##class(CF.EMR.DOC.PerTemplateCategory).%New()
    s objc.Name = aItem.Name
    s objc.ParentID = aItem.ParentID
    s objc.UserID = objUser
    s objc.TemplateID = objDoc.TemplateID
    s objc.Status = "1"
    s objc.Sequence = $case($d(^CF.EMR.DOC.PerTempCatD)>0,0:1,:^CF.EMR.DOC.PerTempCatD+1)
    s objc.CreateDate = $p($h,",",1)
	s objc.CreateTime = $p($h,",",2)
    s sc = objc.%Save()
    q:($$$ISERR(sc)) "-1^创建个人模板节点失败"
    s isLeaf= "Y",state="open"
    s strName = ##Class(EMR.DOC.COM.Translation).Get("EMRTrans",aItem.Name)
    s jsonArr = ##class(%DynamicArray).%New()
    s jsonCat  = ##class(%DynamicObject).%New()
    s jsonCat.id = "category-"_objc.%Id()
    s jsonCat.nodeID=objc.%Id()
    s jsonCat.text = strName
    s jsonCat.type = "category"
    s jsonCat.state = "open"
    s jsonCat.iconCls="tree-folder"
    s jsonCat.isLeaf = "Y"
    s jsonCat.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
	s jsonCat.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
	d jsonArr.%Push(jsonCat)
	d jsonArr.%ToJSON(argOutData)
	q strRes
Error
    q -1_"^"_$zerror
}

/// Desc:       更新目录名称
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"UP_PERCATEGORY","params":{"id":"1","name":"短语名称","type":"category"}}
/// 			id 目录ID，name 短语名称
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UpPerCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.Name = argInJson.params.name
	s objItem.Type = argInJson.params.type
    s strRes = ##Class(EMR.DOC.BL.PerTemplateCategory).UpPerCategoryJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新目录名称
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplateCategory).GetDPTreeJson("YS01")
ClassMethod UpPerCategoryJson(aItem As EMR.DOC.DTO.PerTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^节点ID不能为空"
	q:(aItem.Name="") "-1^节点名称不能为空"
	q:(aItem.Type="") "-1^节点类型不能为空"
	if (aItem.Type="category")
	{
		s obj = ##class(CF.EMR.DOC.PerTemplateCategory).%OpenId(aItem.ID)
	}
	elseif(aItem.Type = "node")
	{
		s obj = ##class(CF.EMR.DOC.PerTemplate).%OpenId(aItem.ID)
	}
	s obj.Name = aItem.Name
	s sc = obj.%Save()
	q:($$$ISERR(sc)) "-1^更新名称失败"
	d argOutData.Write("""1""")
	q strRes
Error
    q -1_"^"_$zerror
}

/// Desc:       删除个人模板目录
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"DEL_PERCATEGORY","params":{"id":"1","type":"category"}}
/// 			id 目录ID，name 短语名称
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DelPerCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.Type = argInJson.params.type
    s strRes = ##Class(EMR.DOC.BL.PerTemplateCategory).DelPerCategoryJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       删除个人模板目录
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplateCategory).GetDPTreeJson("YS01")
ClassMethod DelPerCategoryJson(aItem As EMR.DOC.DTO.PerTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^节点ID不能为空"
	q:(aItem.Type="") "-1^节点类型不能为空"
	TStart
    if (aItem.Type = "category")
	{
		s isChild =$o(^CF.EMR.DOC.PerTempCatI("ParentSequence",aItem.ID,""))
		q:(isChild'="") "-1^包含子节点不能删除"
		s isChild =$o(^CF.EMR.DOC.PerTemplateI("CategorySeqence",aItem.ID,""))
		q:(isChild'="") "-1^包含子节点不能删除"
		s sc = ##Class(CF.EMR.DOC.PerTemplateCategory).%DeleteId(aItem.ID)
		if ($$$ERROR(sc))
		{
			Trollback
			q "-1^删除目录失败"
		}
	}
	elseif(aItem.Type="node")
	{
		s rowId = "",flag = 1
		for
		{
			s rowId = $o(^CF.EMR.DOC.PerTemplateSectionI("IdxCode",aItem.ID,rowId))
			q:(rowId = "")
			s sesc =  ##Class(CF.EMR.DOC.PerTemplateSection).%DeleteId(rowId)
			s:($$$ISERR(sesc)) flag = 0
			q:(flag = 0)
		}
		if (flag = 0)
		{
			Trollback
			q "-1^删除个人模板失败"
		}
		s sc = ##Class(CF.EMR.DOC.PerTemplate).%DeleteId(aItem.ID)
		if ($$$ERROR(sc))
		{
			Trollback
			q "-1^删除个人模板失败"
		}
		
	}
	Tcommit
	d argOutData.Write("""1""")
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       个人模板排序
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"SWAP_PERSEQUENCE","params":{"id1":"1","id2":"2","type":"category"}}
/// 			id1 ID1，id2 ID2
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SwapPerSequence(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id1 = argInJson.params.id1
	s id2 = argInJson.params.id2
	s strType = argInJson.params.type
    s strRes = ##Class(EMR.DOC.BL.PerTemplateCategory).SwapPerSequenceJson(id1,id2,strType,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       个人模板排序
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      id1 节点ID1
/// 			id2 节点ID2
/// 			aType 类型 category(目录)/node(个人模板)
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplateCategory).SwapPerSequenceJson("YS01")
ClassMethod SwapPerSequenceJson(id1 As %String, id2 As %String, aType As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(id1="")||(id2="") "-1^ID不能为空"
	q:(aType="") "-1^节点类型不能为空"
	if (aType = "category") 
 	{
		s objNextCategory = ##class(CF.EMR.DOC.PerTemplateCategory).%OpenId(id1)
		s objSelectCategory = ##class(CF.EMR.DOC.PerTemplateCategory).%OpenId(id2)		
	}
	elseif(aType="node")
 	{
		s objNextCategory = ##class(CF.EMR.DOC.PerTemplate).%OpenId(id1)
		s objSelectCategory = ##class(CF.EMR.DOC.PerTemplate).%OpenId(id2)	 	
	}
    q:((objNextCategory = "")||(objSelectCategory = "")) "-1^通过ID获取节点失败"
    s TempSequence = objNextCategory.Sequence
    s objNextCategory.Sequence = objSelectCategory.Sequence
    s objSelectCategory.Sequence = TempSequence
    Tstart
    s scResult = objNextCategory.%Save() 
    s scResultSele = objSelectCategory.%Save() 
    if $$$ISERR(scResult)
    {
        Trollback
        q "-1^更新个人模板顺序失败"
    }
    if $$$ISERR(objSelectCategory)
    {
        Trollback
        q "-1^更新个人模板顺序失败"
    }
    TCOMMIT
    d argOutData.Write("""1""")
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       更新短语节点目录
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"UP_PerTemplateCategoryID","params":{"id":"1","categoryID":"2","type":"category"}}
/// 			id 目录ID，name 短语名称
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod UPPerCategoryID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.ParentID = argInJson.params.categoryID
	s objItem.Type = argInJson.params.type
    s strRes = ##Class(EMR.DOC.BL.PerTemplateCategory).UPPerCategoryIDJson(objItem,.argOutData)
	//1 获取成功
	if (strRes="1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       更新短语节点目录
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplateCategory).GetDPTreeJson("YS01")
ClassMethod UPPerCategoryIDJson(aItem As EMR.DOC.DTO.PerTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^节点ID不能为空"
	q:(aItem.ParentID="") "-1^节点目录ID不能为空"
	q:(aItem.Type="") "-1^节点类型不能为空"
	if (aItem.Type="category")
	{
		s obj = ##class(CF.EMR.DOC.PerTemplateCategory).%OpenId(aItem.ID)
    	s obj.ParentID = aItem.ParentID
	}
	elseif(aItem.Type = "node")
	{
		s obj = ##class(CF.EMR.DOC.PerTemplate).%OpenId(aItem.ID)
    	s obj.CategoryID = aItem.ParentID
	}
    s sc = obj.%Save()
    q:($$$ISERR(sc)) "-1^更新节点目录失败"
	d argOutData.Write("""1""")
	q strRes
Error
    q -1_"^"_$zerror
}

/// Desc:       根据模板ID获取个人模板ID集合
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// 			arrTemIds 模板JSON数组
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.PerTemplateCategory).GetTemIDByRecordID("YS01","TEMPLATE",.argOutData)
ClassMethod GetPerTemIDByRecordID(dtoItem As EMR.OP.DTO.DocCategory, arrTemIds As %DynamicArray) As %DynamicArray
{
	s jsonLocTemp = ##class(%DynamicArray).%New()
	s parentid="0"
	set iter = arrTemIds.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonTem = item
        continue:(jsonTem = "")||(jsonTem.templateID="")
		s objTem = ##Class(CF.EMR.DOC.Template).%OpenId(jsonTem.templateID)
	    continue:(objTem="")
	    //如果子节点为模板则ResChildCount不为0
		s strRes = ##class(EMR.DOC.BL.PerTemplateCategory).GetJsonCategroyByID(dtoItem.UserID,jsonTem.templateID,parentid,jsonTem,"",.jsonLocTemp)
		s strRes = ##Class(EMR.DOC.BL.PerTemplate).GetJsonPerTempalteByCID(dtoItem.UserID,jsonTem.templateID,parentid,jsonTem,"",.jsonLocTemp)
	    
	}
	
	q jsonLocTemp
}

/// Desc:       递归获取模板目录数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aUserId 用户ID
/// 				aTemplateId 模板ID
/// 			aParentId 目录ID
///             aProduct 项目标识
///             aPids 目录id串1^2^3
/// Output:    成功 1，失败 -1 
/// 	Debug:	q ##Class(EMR.DOC.BL.PerTemplateCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByID(aUserId As %String, aTemplateId As %String, aParentId As %String, jsonTem As %DynamicAbstractObject, ByRef aPids As %String, ByRef jsonLocTemp As %DynamicAbstractObject) As %String
{
	s res = "1"
	s arrCategory = ##CLASS(%DynamicArray).%New()

	s strSeq= ""	
	for {
		s strSeq = $o(^CF.EMR.DOC.PerTempCatI("UserParentSequence",aUserId,aTemplateId,aParentId,strSeq))
		q:(strSeq = "")	
		s strCId = $o(^CF.EMR.DOC.PerTempCatI("UserParentSequence",aUserId,aTemplateId,aParentId,strSeq,""))
		q:(strCId = "")		
		s objLocTemCat = ##Class(CF.EMR.DOC.PerTemplateCategory).%OpenId(strCId)
	    continue:(objLocTemCat="")
	    
		s aPids = $case(aPids,"":strCId,:(aPids_"^"_strCId))
		s result = ##Class(EMR.DOC.BL.PerTemplateCategory).GetJsonCategroyByID(aUserId,aTemplateId,strCId,jsonTem,aPids,.jsonLocTemp)
		s result = ##Class(EMR.DOC.BL.PerTemplate).GetJsonPerTempalteByCID(aUserId,aTemplateId,strCId,jsonTem,aPids,.jsonLocTemp)
		
	}
	q res
}

}
