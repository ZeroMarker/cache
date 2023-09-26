/// 名称:	EMR.DOC.BL.PerTemplate
/// 描述:	个人模板业务逻辑(门诊、住院)
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PerTemplate Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取个人模板节点
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     
/// Debug:	q ##Class(EMR.DOC.BL.PerTemplate).GetPerTemplateByCID(0,1,1,)
ClassMethod GetPerTemplateByCID(aParentId As %String, aItem As EMR.DOC.DTO.PerTemplate, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s treeSeq = ""
	for {
		s treeSeq = $o(^CF.EMR.DOC.PerTemplateI("IdxUserIDSeq",aItem.UserID,aItem.TemplateID,aParentId,treeSeq))
		q:(treeSeq = "")		
		s rowID = $o(^CF.EMR.DOC.PerTemplateI("IdxUserIDSeq",aItem.UserID,aItem.TemplateID,aParentId,treeSeq,""))		
		s objNode = ##Class(CF.EMR.DOC.PerTemplate).%OpenId(rowID)
	    continue:(objNode="")
	    ;s canCreate = ##Class(EMR.DOC.BL.DocumentData).IsCanCreateJson(aItem.EpisodeID,aItem.TemplateID)
	    ;continue:(canCreate["-1^")
	    s strName = ##Class(EMR.DOC.COM.Translation).GetTranByDesc("CF.EMR.DOC.PerTemplate","Name",objNode.Name,aItem.LangID)
		s strName = ##Class(EMR.DOC.COM.EscapeSpecialWord).JsonEscape(strName)
	    s jsonItem  = ##class(%DynamicObject).%New()
	    s jsonItem.id ="node-"_rowID
	    s jsonItem.nodeID = rowID
	    s jsonItem.text = strName
	    s jsonItem.type = "node"
	    s jsonItem.status = "1"
	    s jsonItem.templateID = aItem.TemplateID
	    s jsonItem.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
		s jsonItem.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
		d jsonCategory.%Push(jsonItem)	
	}
	q res
}

/// Desc:       获取个人模板章节打散
/// Creator:    yejian
/// CreateDate: 2022-11-22
/// Table:		CF.EMR.DOC.LocTemplate 科室模板表，CF.EMR.DOC.LocTemplateSection 科室模板章节打散表
/// Input:      argInJson  命令参数 {"action":"LOAD_PERTEMPLATE","params":{"id":"55"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadPerTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.PerTemplate).LoadPerTemplateJson(id,.argOutData)
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
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取个人模板章节打散
/// Creator:    yejian
/// CreateDate: 2022-11-22
/// Input:      aPerTemID 个人模板ID
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.PerTemplate).LoadPerTemplateJson("55",.argOutData)
ClassMethod LoadPerTemplateJson(aPerTemID As EMR.DOC.DTO.DocumentData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1"
	q:(aPerTemID="") "-1^个人模板ID不能为空"
	s jsonArr=##class(%DynamicArray).%New()
	s rowID=""
	try
	{
		for
		{
			s rowID = $o(^CF.EMR.DOC.PerTemplateSectionI("IdxCode",aPerTemID,rowID))
			q:(rowID="")
	     	s objSection=##class(CF.EMR.DOC.PerTemplateSection).%OpenId(rowID)
	  		s objJson = ##class(%DynamicAbstractObject).%FromJSON(objSection.DocumentData)
	     	d jsonArr.%Push(objJson)
		}
		d jsonArr.%ToJSON(argOutData)
	}
	catch
	{
		s strRes="-1^获取章节数据失败"
	}
	q strRes
OPRecordError
    q "-1^"_aPerTemID_","_$zerror
}

/// Desc:       创建个人模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"ADD_PERTEMPLATE","params":{"parentID":"1","userID":"10209","name":"个人模板名称","status":"2","documentID":"35"}}
/// 			parentID 目录ID，userID 用户ID，name 个人模板名称，documentID:文档ID，status：状态
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddPerTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.DocumentID = argInJson.params.documentID
	s objItem.ParentID = argInJson.params.parentID
	s objItem.Product = argInJson.product
	s objItem.Name = argInJson.params.name
	s objItem.UserID = argInJson.params.userID
	s objItem.Status = argInJson.params.status
	
    s strRes = ##Class(EMR.DOC.BL.PerTemplate).AddPerTemplateJson(objItem,argInData,.argOutData)
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
		q ..SetOutMessage(argOutMessage,"ERROR","保存数据失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       创建个人模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplate).GetDPTreeJson("YS01")
ClassMethod AddPerTemplateJson(aItem As EMR.DOC.DTO.PerTemplate, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.UserID="") "-1^用户ID不能为空"
	q:(aItem.DocumentID="") "-1^文档ID不能为空"
	q:(aItem.ParentID="") "-1^目录ID不能为空"
	q:(argInData.Size<=1) "-1^章节流不能为空"
	s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(aItem.DocumentID)
	q:(objDoc="") "-1^获取文档对象失败"
	s objUser=##class(User.SSUser).%OpenId(aItem.UserID,0)
	q:(objUser="") "-1^获取用户失败"
	Tstart
	s obj = ##class(CF.EMR.DOC.PerTemplate).%New()
    s obj.CategoryID = aItem.ParentID
    s obj.UserID = objUser
    s obj.DocumentID = aItem.DocumentID
    s obj.TemplateID = objDoc.TemplateID
    s obj.Name = aItem.Name
    s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
    s obj.Sequence = $case($d(^CF.EMR.DOC.PerTemplateD)>0,0:1,:^CF.EMR.DOC.PerTemplateD+1)
    s obj.Status = "2"
    s sc = obj.%Save()
    if ($$$ISERR(sc))
	{
		Trollback
		q "-1^保存个人模板失败"
	}
	s outStream = ##class(%GlobalBinaryStream).%New()
	while (argInData.AtEnd = 0)
	{
		s tmpOut = argInData.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d outStream.Write(tmpUtf8)
  	} 
	s arrSections = ##class(%DynamicArray).%FromJSON(outStream)
	s iter=arrSections.%GetIterator()
	while iter.%GetNext(.key,.val)
	{
		continue:(val="")
		s str=val.%ToJSON()
		s code=val.attrs.code
		// 新增
		s objNewSection=##class(CF.EMR.DOC.PerTemplateSection).%New()
		d objNewSection.DocumentData.Write(str)
		s objNewSection.SectionCode=code
		s objNewSection.PerTemplate=obj
		s sc= objNewSection.%Save()
		if ($$$ISERR(sc))
		{
			s strRes="-1^保存个人模板章节数据失败"
			q
		}
	}
	if (strRes["-1^")
	{
		Trollback
		q strRes
	}
	TCOMMIT
    s strName = ##Class(EMR.DOC.COM.Translation).Get("EMRTrans",aItem.Name)
    s jsonArr = ##class(%DynamicArray).%New()
    s jsonItem  = ##class(%DynamicObject).%New()
    s jsonItem.id = "node-"_obj.%Id()
    s jsonItem.text = strName
    s jsonItem.type = "node"
    s jsonItem.status = "1"
	s jsonItem.nodeID = obj.%Id()
	s jsonItem.templateID = obj.TemplateID.%Id()
    s jsonItem.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,4,"")
	s jsonItem.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(strName,3,"")
	d jsonArr.%Push(jsonItem)
	d jsonArr.%ToJSON(argOutData)
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       保存个人模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"SAVE_PERTEMPLATE","params":{"id":"1","status":"2"}}
/// 			id id, name 名称，description 描述，isValid 是否生效
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SavePerTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.Status = argInJson.params.status
    s strRes = ##Class(EMR.DOC.BL.PerTemplate).SavePerTemplateJson(objItem,argInData,.argOutData)
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

/// Desc:       保存个人模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplate).GetDPTreeJson("YS01")
ClassMethod SavePerTemplateJson(aItem As EMR.DOC.DTO.PerTemplate, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^ID不能为空"
	q:(argInData.Size<=1) "-1^章节流不能为空"
    s obj= ##class(CF.EMR.DOC.PerTemplate).%OpenId(aItem.ID)
    q:(obj = "") "-1^根据ID获取对象失败"
    s perTemID = aItem.ID
    TStart
    &sql(delete from CF_EMR_DOC.PerTemplateSection where PerTemplate = :perTemID)
    if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
	{
		TROLLBACK
		q "-1^更新个人模板章节数据失败"
	}
	s outStream = ##class(%GlobalBinaryStream).%New()
	while (argInData.AtEnd = 0)
	{
		s tmpOut = argInData.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d outStream.Write(tmpUtf8)
  	} 
	s arrSections = ##class(%DynamicArray).%FromJSON(outStream)
	s iter=arrSections.%GetIterator()
	while iter.%GetNext(.key,.val)
	{
		continue:(val="")
		s str=val.%ToJSON()
		s code=val.attrs.code
		// 新增
		s objNewSection=##class(CF.EMR.DOC.PerTemplateSection).%New()
		d objNewSection.DocumentData.Write(str)
		s objNewSection.SectionCode=code
		s objNewSection.PerTemplate=obj
		s sc= objNewSection.%Save()
		if ($$$ISERR(sc))
		{
			s strRes="-1^保存个人模板章节数据失败"
			q
		}
	}
	if (strRes["-1^")
	{
		Trollback
		q strRes
	}
	TCOMMIT            
    k objContent
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       判断是否已分享过当前科室的科室模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"PERIS_SHARETOLOC","params":{"id":"1","userLocID":"6"}}
/// 			id id, userLocID 科室ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PerIsShareToLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.UserLocID = argInJson.params.userLocID
    s strRes = ##Class(EMR.DOC.BL.PerTemplate).PerIsShareToLocJson(objItem,.argOutData)
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

/// Desc:       判断是否已分享过当前科室的科室模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 已分享，0 未分享， -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplate).GetDPTreeJson("YS01")
ClassMethod PerIsShareToLocJson(aItem As EMR.DOC.DTO.PerTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^ID不能为空"
	q:(aItem.UserLocID="") "-1^科室ID不能为空"
    s obj= ##class(CF.EMR.DOC.PerTemplate).%OpenId(aItem.ID)
    q:(obj = "") "-1^根据ID获取对象失败"
    
    s isShareLocID = 0
    if ($f("^"_obj.ShareLocID_"^","^"_aItem.UserLocID_"^")>0)
	{
		s isShareLocID = 1
	}
   	d argOutData.Write(isShareLocID)
	q strRes
Error
    q -1_"^"_$zerror
}

/// Desc:       分享为科室模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Table:		CF_EMR_DOC.PerTemplateCategory 个人模板目录表,CF.EMR.DOC.PerTemplate 个人模板表
/// Input:      argInJson  命令参数 {"product":"OP","action":"PER_SHARETOLOC","params":{"id":"1","userLocID":"6"}}
/// 			id id, name 名称，description 描述，isValid 是否生效
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PerShareToLoc(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s objItem = ##class(EMR.DOC.DTO.PerTemplate).%New()
	s objItem.ID = argInJson.params.id
	s objItem.Product = argInJson.product
	s objItem.UserLocID = argInJson.params.userLocID
    s strRes = ##Class(EMR.DOC.BL.PerTemplate).PerShareToLocJson(objItem,argInData,.argOutData)
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

/// Desc:       分享为科室模板
/// Creator:    yejian
/// CreateDate: 2022-11-1
/// Input:      aItem 个人模板对象
/// Output:     成功：1 失败  -1^失败信息
/// debug:  q ##Class(EMR.DOC.BL.PerTemplate).PerShareToLocJson()
ClassMethod PerShareToLocJson(aItem As EMR.DOC.DTO.PerTemplate, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aItem.ID="") "-1^ID不能为空"
	q:(aItem.UserLocID="") "-1^科室ID不能为空"
    s obj= ##class(CF.EMR.DOC.PerTemplate).%OpenId(aItem.ID)
    q:(obj = "") "-1^根据ID获取对象失败"
    s objTemplate = obj.TemplateID
	q:(objTemplate = "") "-1^获取基础模板信息失败"
	s publishVersion = objTemplate.TempPublishVersion
	q:(publishVersion="") "-1^获取基础模板已发布版本号失败"
	
	Tstart
	// 新增科室模板
	s objTem=##class(CF.EMR.DOC.LocTemplate).%New()
	s objTem.Description=obj.Name
	s objTem.EMRName=obj.Name
	s objTem.TemplateID=obj.TemplateID
	s objTem.Name=obj.Name
	s objTem.Sequence = $case($d(^CF.EMR.DOC.LocTemplateD)>0,0:1,:^CF.EMR.DOC.LocTemplateD+1)
	s objTem.TempLastVersion = 1
	;s objTem.TempPublishVersion = 1
	s sc = objTem.%Save()
	if ($$$ISERR(sc))
	{
		Trollback
		q "-1^新建科室模板数据失败"
	}
	s locTemplateID=objTem.%Id()
	s objVersion = ##class(CF.EMR.DOC.LocTemplateVersion).%New()
	s objVersion.TepmplateVersionNumber = 1
	s objVersion.Template=objTem
	s objVersion.Status =3
	s objVersion.EffectiveDate=$ZDATEH($ZDATE($h))
	s objVersion.EffectiveTime=$ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s sc = objVersion.%Save()
	if ($$$ISERR(sc))
	{
		Trollback
		q "-1^新建科室模板版本失败"
	}
	// 新增科室模板规则
	s newRule=##class(CF.EMR.DOC.LocTemplateRules).%New()
	s newRule.TemplateID=objTem
	s newRule.RuleItemIDs="PATDEPT:"_aItem.UserLocID
	s newRule.RuleItemDesc=$p($g(^CTLOC(aItem.UserLocID)),"^",2)
	s sc = newRule.%Save()
	if ($$$ISERR(sc))
	{
		Trollback
		q "-1^新建科室模规则失败"
	}
	
	//循环创建科室模板章节信息表数据
	s perSecID = ""
    s strSectionResult = "1"
	for
	{
		s perSecID = $o(^CF.EMR.DOC.PerTemplateSectionI("IdxCode",aItem.ID,perSecID))
		q:(perSecID = "")
		s objPerS = ##class(CF.EMR.DOC.PerTemplateSection).%OpenId(perSecID)
		
		s objLocS = ##class(CF.EMR.DOC.LocTemplateSection).%New()
		s objLocS.Template=objTem
		s objLocS.VersionNumber = 1
		s objLocS.SectionCode = objPerS.SectionCode
		d objLocS.DocumentData.CopyFrom(objPerS.DocumentData)
		s scLoc = objLocS.%Save()
		if ($$$ISERR(scLoc))
		{
			s strSectionResult = "-1^保存科室模板章节数据失败"
			q
		}
	}
	if (strSectionResult ["-1^")
	{
		Trollback
		q strSectionResult
	}
	s obj.ShareLocID = $case(obj.ShareLocID,"": aItem.UserLocID,:obj.ShareLocID_"^"_aItem.UserLocID)
	s sharesc = obj.%Save()
	if $$$ISERR(sharesc)
	{
		Trollback
		q "-1^存储分享到科室ID(shareLocID)数据失败"
	}
	TCOMMIT
	d argOutData.Write(1)      
	q strRes
Error
	Trollback
    q -1_"^"_$zerror
}

/// Desc:       获取科室模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aUserId 用户ID
/// 			aTemplateId 模板ID
/// 	        aParentId 目录ID
///             aProductid 项目标识
///             aPids 目录id串1^2^3
/// Output:     q ##Class(EMR.DOC.BL.PerTemplate).GetJsonLocTempalteByCID(0,1,1,)
ClassMethod GetJsonPerTempalteByCID(aUserId As %String, aTemplateId As %String, aParentId As %String, jsonRecord As %DynamicAbstractObject, ByRef aPids As %String, ByRef jsonTemplate As %DynamicAbstractObject) As %String
{
	s res = "1"
	s strSeq = ""
	for {
		s strSeq = $o(^CF.EMR.DOC.PerTemplateI("IdxUserIDSeq",aUserId,aTemplateId,aParentId,strSeq))
		q:(strSeq = "")			
		s strRowID = $o(^CF.EMR.DOC.PerTemplateI("IdxUserIDSeq",aUserId,aTemplateId,aParentId,strSeq,""))
		s objLocTem = ##Class(CF.EMR.DOC.PerTemplate).%OpenId(strRowID)
	    continue:(objLocTem="")
	    s objTem = objLocTem.TemplateID
	    s jsonTem  = ##class(%DynamicObject).%New()
	    s jsonTem.id = "PerTemplate-"_strRowID
	    s jsonTem.text = objLocTem.Name
	    s jsonTem.type = "PerTemplate"
	    s jsonTem.docCode = jsonRecord.docCode
	    s jsonTem.docName = jsonRecord.docName
	    s jsonTem.docCategoryCode = jsonRecord.docCategoryCode
	    s jsonTem.docCategoryName = jsonRecord.docCategoryName
	    s jsonTem.chartItemType = objTem.ChartItemType
	    s jsonTem.documentType = objTem.DocumentType.Code
	    s jsonTem.isLeadframe = $case(jsonRecord.isLeadframe,"":"0",:jsonRecord.isLeadframe) 
	    s jsonTem.serial = $case(jsonRecord.serial,"":"0",:jsonRecord.serial) 
	    s jsonTem.isMutex = $case(jsonRecord.isMutex,"":"0",:jsonRecord.isMutex) 
	    s jsonTem.templateID = aTemplateId
	    s jsonTem.quotation = jsonRecord.quotation
	    s jsonTem.templateCategoryID = aParentId
	    //记录目录ID串1^2^3
	    s jsonTem.pids=aPids
	    s jsonTem.janeSpell = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objLocTem.Name,4,"")
	    s jsonTem.fullFight = ##class(EMR.DOC.COM.CodeTool).GetCNCODE(objLocTem.Name,3,"")
	    s jsonTem.iconCls = ""
	    s jsonTem.documentID = ""
	    s jsonTem.sourceID = strRowID
	    s jsonTem.sourceType = "PerTemplate"
	    s jsonTem.eventID = ""
	    s jsonTem.eventType = ""
	    s jsonTem.pluginType = "WORD"
		d jsonTemplate.%Push(jsonTem)	
	}
	q res
}

/// Desc:       根据模板目录信息组合为二位数组(主键父ID，值为第一层子节点ID数组)
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      jsonTem 模板json对象
/// 			arrData 需要构建的JSON数据
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.PerTemplate).GetJsonDataByIds("YS01","TEMPLATE",.argOutData)
ClassMethod GetJsonDataByTemJosn(jsonTem As %DynamicAbstractObject, ByRef arrGroup As %ArrayOfDataTypes) As %String
{
	
	s strPids = jsonTem.pids
	s strFid = 0
	//为空表示没有目录
	if (strPids'="")
	{
		s countCat =$l(strPids,"^")
		for i=1:1:countCat
		{
			s strPid = $p(strPids,"^",i)
			continue:(strPid = "")
			s arrids =  arrGroup.GetAt(strFid)
			//如果为空，创建JSON数组
			if (arrids="") 
			{
				s arrids = ##class(%DynamicArray).%New()
				d arrids.%Push(strPid)
			}
			else
			{
				s strJson = arrids.%ToJSON()
				d:(strJson '[ (""""_strPid_"""")) arrids.%Push(strPid)
			}
			d arrGroup.SetAt(arrids,strFid)
			s strFid = strPid
		}
		s arrTems =  arrGroup.GetAt(strPid)
		s:(arrTems="") arrTems = ##class(%DynamicArray).%New()
		d arrTems.%Push(jsonTem)
		d arrGroup.SetAt(arrTems,strPid)
	}
	else
	{
		s arrTems =  arrGroup.GetAt(strFid)
		s:(arrTems="") arrTems = ##class(%DynamicArray).%New()
		d arrTems.%Push(jsonTem)
		d arrGroup.SetAt(arrTems,strFid)
	}
	q 1
}

/// Desc:		递归获取模板JSON数据
/// Creator:	yejian 
/// CreateDate:	2021-8-11
/// Input:      jsonData 文档json数据
///             argOutData 转换后的流数据
/// Output:    	成功1、失败-1
/// Debug: 		d ##class(EMR.DOC.BL.PerTemplate).GetJsonData(0,"","")
ClassMethod GetJsonData(aKey As %String, arrData As %ArrayOfDataTypes, ByRef ajsonP As %DynamicAbstractObject) As %String
{
	s result = "1"
	s ids = arrData.GetAt(aKey)
	q:(ids="")
	set iter = ids.%GetIterator()
	s jsonArr = ##class(%DynamicArray).%New()
	while iter.%GetNext(.index , .jitem ) {
        s strValue = jitem
        q:(strValue="")
        s strType = ids.%GetTypeOf(index)
        //模板数据为json对象
		if (strType="object")||(strType="array")
		{
			d jsonArr.%Push(strValue)
		}
		else //数字为目录
		{
			s objCat = ##class(CF.EMR.DOC.PerTemplateCategory).%OpenId(strValue)
			continue:(objCat="")
			s jsonCat = ##class(%DynamicObject).%New()
			s jsonCat.id="flod-"_strValue
			s jsonCat.type="flod"
			s jsonCat.text=objCat.Name
			s jsonCat.state="closed"
			s jsonCat.pid=strValue
			s jsonCat.icon=""
			d jsonArr.%Push(jsonCat)			
			d ##class(EMR.DOC.BL.PerTemplate).GetJsonData(strValue,arrData,.jsonCat)
		}
	}
	s ajsonP.children =jsonArr
	q result
}

}
