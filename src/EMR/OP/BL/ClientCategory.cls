/// 名称:	EMR.OP.BL.ClientCategory
/// 描述:	门诊病历 病历导航业务逻辑类
/// 编写者：yejian
/// 编写日期: 2022-6-8
/// 产品组：电子病历产品组
Class EMR.OP.BL.ClientCategory Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取门急诊默认模板数据
/// Creator:    yejian
/// CreateDate: 2022-6-8
/// Table:		病历导航相关表，实例表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_DEFAULTTEMPLATE","params":{"userLocID":"6","ssgroupID":"28","episodeID":"713","userID":"10209","docCode":"","docCategoryCode":""}}
/// 								userLocID:科室ID
/// 								ssgroupID:安全组ID
///             					episodeID:就诊号
/// 								userID:用户ID
/// 								DOCCode:业务活动记录编码
/// 								DOCCategoryCode:业务活动记录分类编码
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetFirstTmpl(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.UserID = argInJson.params.userID
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetFirstTmplJson(dtoItem,.argOutData)
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

/// Desc:       获取当前患者已保存的病历
/// Creator:    yejian
/// CreateDate: 2022-7-18
/// Table:		病历导航相关表，实例表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_SAVEDRECORDS","params":{"episodeID":"713","ssgroupID":"28","categoryID":"","userLocID":"6"}}
/// 								userLocID:科室ID
/// 								ssgroupID:安全组ID
///             					episodeID:就诊号
/// 								userID:用户ID
/// 								DOCCategoryCode:业务活动记录分类编码
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSaveRecords(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.Order = $case(argInJson.params.order,"1":"",:argInJson.params.order)
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetSaveRecordsJson(dtoItem,.argOutData)
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

/// Desc:       获取当前患者所有已保存的病历
/// Creator:    yejian
/// CreateDate: 2022-7-18
/// Table:		病历导航相关表，实例表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_ALLSAVEDRECORDS","params":{"episodeID":"713","ssgroupID":"28","categoryID":"","userLocID":"6"}}
/// 								userLocID:科室ID
/// 								ssgroupID:安全组ID
///             					episodeID:就诊号
/// 								userID:用户ID
/// 								DOCCategoryCode:业务活动记录分类编码
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAllSaveRecords(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.EpisodeID = argInJson.params.episodeID
	;s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.Order = $case(argInJson.params.order,"1":"",:argInJson.params.order)
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetAllSaveRecordsJson(dtoItem,.argOutData)
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

/// Desc:       获取当前患者所有已保存的病历
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 默认模板入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetAllSaveRecordsJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组ID不能为空"
	s arrJson = ##class(%DynamicArray).%New()
	s TILDocument = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(dtoItem.EpisodeID)
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID,dtoItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		// 配置门诊病历页面传入业务活动记录分类目录CategoryID用于过滤模板数据
		continue:((dtoItem.DOCCategoryCodeFilter'="")&&(dtoItem.DOCCategoryCodeFilter'=strDOCCategoryCode))
		//设置业务活动记录分类ID，以及分类编码
		s dtoItem.ParentID = strDocCID
		s strDOCCategoryCode =$zcvt(strDOCCategoryCode,"U")
		s hasListNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, ""))
		continue:(""=hasListNo)
		s flag="0"
		s listNo = ""
		for
		{
			if (dtoItem.Order="-1")
			{
				s listNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo),dtoItem.Order)
			}
			else
			{
				s listNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo))
			}
			q:(listNo="")
			s docID = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo,""))
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
			continue:(objDocument="")
			//删除状态排除
			continue:("Save" '= objDocument.Status)
			s objTem = objDocument.TemplateID
			continue:(objTem="")
			s strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
			continue:(strTemCId="")
			s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)			
			s objDocCTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
			//指定病历实例是否有对应患者签名后的PDF文档
			s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(docID, dtoItem.EpisodeID)
			s objJson = ##class(%DynamicObject).%New()
			s objJson.documentID = objDocument.%Id()
			s objJson.docName = objDocument.DOCName
			s objJson.docCode = objDocument.DOCCode
			s objJson.docCategoryCode = objDocument.DOCCategoryCode
			s objJson.docCategoryName = objDocCTem.EMRName
			s objJson.templateCategoryID = objDocument.TemplateCategoryID.%Id()
			s objJson.templateID = objDocument.TemplateID.%Id()
			s objJson.serial = objDocument.Serial
			s objJson.isLeadframe = objTemCat.Title.IsLeadframe
			s objJson.isMutex = objTemCat.Title.IsMutex
			s objJson.chartItemType = objTem.ChartItemType
			s objJson.pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
			s objJson.eventID = ""
			s objJson.eventType = ""
			
			d arrJson.%Push(objJson)
			
		}
	}
	d arrJson.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       根据文档ID获取已保存的病历
/// Creator:    yejian
/// CreateDate: 2022-7-18
/// Table:		病历导航相关表，实例表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_SAVEDRECORDBYDOCUMENTID","params":{"documentID":"5"}}
/// 								documentID:文档ID
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSaveRecordByDocumentID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DocumentID = argInJson.params.documentID
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetSaveRecordByDocumentIDJson(DocumentID,.argOutData)
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

/// Desc:       获取门急诊默认模板数据
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 默认模板入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetFirstTmplJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",operativeTemIds=""
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID,dtoItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		// 配置门诊病历页面传入业务活动记录分类目录CategoryID用于过滤模板数据
		continue:((dtoItem.DOCCategoryCodeFilter'="")&&(dtoItem.DOCCategoryCodeFilter'=strDOCCategoryCode))
		//设置业务活动记录分类ID，以及分类编码
		s dtoItem.ParentID = strDocCID
		s dtoItem.DOCCategoryCode = strDOCCategoryCode
		//获取系统配置默认加载模板，还是科室模板
		s OPDefaultCreateTempType = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("OPDefaultCreateTempType",..#ProductCode,"UserTemplate")	
		//获取默认科室模板
		if (OPDefaultCreateTempType="UserTemplate")
		{
			s strRes = ##class(EMR.OP.BL.ClientCategory).GetFirstLocTmplData(dtoItem,.argOutData)
			//有数据则退出循环
			q:(argOutData.Size>0)
		}
		//获取默认基础模板
		s strRes = ##class(EMR.OP.BL.ClientCategory).GetFirstTmplData(dtoItem,.argOutData)
		q:(argOutData.Size>0) 
	}
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获取门急诊默认模板数据
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetFirstTmplData(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(dtoItem.ParentID="") "-1^目录ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.DOCCategoryCode = "") "-1^业务活动记录分类编码不能为空"
	//是否开启权限控制
	//s priActivity  = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("PrivControl",..#ProductCode,"N") 
	//获取病人信息
	s listPatInfo = ##class(EMR.DOC.BL.PrivLogic).GetPatInfo(dtoItem.EpisodeID,dtoItem.UserID,dtoItem.CTLocID)
	//获取业务活动记录ID集合(互斥写过病历排除)
	s arrRecordIds = ##class(EMR.OP.BL.TemplateCategory).GetRecordsByPid(dtoItem)
	q:(arrRecordIds.%Size()=0) strRes
	//获取发布状态文档ID集合(和目录信息)
	s arrTemIds = ##class(EMR.OP.BL.TemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
	q:(arrTemIds.%Size()=0) strRes
	//过滤文本
	s pText = dtoItem.Text
	s arrData = ##class(%ArrayOfDataTypes).%New()
	set iter = arrTemIds.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonTem = item
        continue:(jsonTem = "")||(jsonTem.templateID="")
        continue:((dtoItem.DOCCode'="")&&(dtoItem.DOCCode '= jsonTem.DOCCode))
        //判断模板是否符合规则(如果不开启权限，不过滤规则)
        s strStatue = ##class(EMR.OP.BL.TemplateRules).CanTempAct(jsonTem.templateID,listPatInfo)
        continue:(strStatue=0)
		d jsonTem.%ToJSON(argOutData)
		q
	}
	//根据数组输出JSON数据
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获取门诊默认科室模板导航数据
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetFirstLocTmplData(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",operativeTemIds=""
	q:(dtoItem.ParentID="") "-1^目录ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.DOCCategoryCode = "") "-1^业务活动记录分类编码不能为空"
	//是否开启权限控制
	//s priActivity  = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("PrivControl",..#ProductCode,"N") 
	//获取病人信息
	s listPatInfo = ##class(EMR.DOC.BL.PrivLogic).GetPatInfo(dtoItem.EpisodeID,dtoItem.UserID,dtoItem.CTLocID)
	//获取业务活动记录ID集合(互斥写过病历排除)
	s arrRecordIds = ##class(EMR.OP.BL.TemplateCategory).GetRecordsByPid(dtoItem)
	q:(arrRecordIds.%Size()=0) strRes
	//获取发布状态文档ID集合(和目录信息)
	s arrTemIds = ##class(EMR.OP.BL.TemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
	//获取科室模板ID集合（和目录信息）
	s arrLocTemIds = ##class(EMR.OP.BL.LocTemplateCategory).GetLocTemIDByRecordID(dtoItem,arrTemIds)
	q:(arrLocTemIds.%Size()=0) strRes
	//过滤文本
	s pText = dtoItem.Text
	s DiseaseCodeAndName = dtoItem.DiseaseCodeAndName
	s arrData = ##class(%ArrayOfDataTypes).%New()
	set iter = arrLocTemIds.%GetIterator()
	while iter.%GetNext(.key , .item ) {
        s jsonTem = item
        continue:(jsonTem = "")||(jsonTem.templateID="")||(jsonTem.locTemID = "")
        continue:((dtoItem.DOCCode'="")&&(dtoItem.DOCCode '= jsonTem.DOCCode))
        //判断模板是否符合规则(如果不开启权限，不过滤规则)
        s strStatue = ##class(EMR.OP.BL.LocTemplateRules).CanTempAct(jsonTem.locTemID,listPatInfo)
        continue:(strStatue=0)
       	d jsonTem.%ToJSON(argOutData)
		q
	}
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获取当前患者已保存的病历
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 默认模板入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetSaveRecordsJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组ID不能为空"
	s arrJson = ##class(%DynamicArray).%New()
	s TILDocument = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(dtoItem.EpisodeID)
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID,dtoItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		// 配置门诊病历页面传入业务活动记录分类目录CategoryID用于过滤模板数据
		continue:((dtoItem.DOCCategoryCodeFilter'="")&&(dtoItem.DOCCategoryCodeFilter'=strDOCCategoryCode))
		//设置业务活动记录分类ID，以及分类编码
		s dtoItem.ParentID = strDocCID
		s strDOCCategoryCode =$zcvt(strDOCCategoryCode,"U")
		s hasListNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, ""))
		continue:(""=hasListNo)
		s flag="0"
		s listNo = ""
		for
		{
			if (dtoItem.Order="-1")
			{
				s listNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo),dtoItem.Order)
			}
			else
			{
				s listNo = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo))
			}
			q:(listNo="")
			s docID = $O(@TILDocument@("IdxMain",dtoItem.EpisodeID," "_strDOCCategoryCode, listNo,""))
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(docID)
			continue:(objDocument="")
			//删除状态排除
			continue:("Save" '= objDocument.Status)
			s objTem = objDocument.TemplateID
			continue:(objTem="")
			s strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
			continue:(strTemCId="")
			s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
						
			s objDocCTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
			//指定病历实例是否有对应患者签名后的PDF文档
			s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(docID, dtoItem.EpisodeID)			
			s objJson = ##class(%DynamicObject).%New()
			s objJson.documentID = objDocument.%Id()
			s objJson.docName = objDocument.DOCName
			s objJson.docCode = objDocument.DOCCode
			s objJson.docCategoryCode = objDocument.DOCCategoryCode
			s objJson.docCategoryName = objDocCTem.EMRName
			s objJson.templateCategoryID = objDocument.TemplateCategoryID.%Id()
			s objJson.templateID = objDocument.TemplateID.%Id()
			s objJson.serial = objDocument.Serial
			s objJson.isLeadframe = objTemCat.Title.IsLeadframe
			s objJson.isMutex = objTemCat.Title.IsMutex
			s objJson.chartItemType = objTem.ChartItemType
			s objJson.pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
			s objJson.eventID = ""
			s objJson.status = objDocument.Status
			s objJson.eventType = ""
			
			//如果是连续加载文档，只需要JSON数组增加一个实例ID
			if (("MULTIPLE"=objTem.ChartItemType) && ("1"=objTemCat.Title.IsLeadframe))
			{
				d:(flag'="1") arrJson.%Push(objJson)
				s flag ="1"
			}
			else
			{
				d arrJson.%Push(objJson)
			}
		}
	}
	d arrJson.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       根据ID获取已保存的病历
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      aDocumentID 文档ID
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetSaveRecordByDocumentIDJson(aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aDocumentID="") "-1^文档ID不能为空"
	s arrJson = ##class(%DynamicArray).%New()
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDocument="") "-1^文档ID获取文档对象失败"
	//删除状态排除
	q:("Save" '= objDocument.Status) "-1^文档状态不是Save"
	s objTem = objDocument.TemplateID
	q:(objTem="") "-1^文档ID获取模板Id失败"
	s strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
	q:(strTemCId="")
	s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
	s objDocCTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
	//指定病历实例是否有对应患者签名后的PDF文档
	s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(aDocumentID, objDocument.EpisodeID.%Id())
	s objJson = ##class(%DynamicObject).%New()
	s objJson.documentID = objDocument.%Id()
	s objJson.docName = objDocument.DOCName
	s objJson.docCode = objDocument.DOCCode
	s objJson.docCategoryCode = objDocument.DOCCategoryCode
	s objJson.docCategoryName = objDocCTem.EMRName
	s objJson.templateCategoryID = objDocument.TemplateCategoryID.%Id()
	s objJson.templateID = objDocument.TemplateID.%Id()
	s objJson.serial = objDocument.Serial
	s objJson.isLeadframe = objTemCat.Title.IsLeadframe
	s objJson.isMutex = objTemCat.Title.IsMutex
	s objJson.chartItemType = objTem.ChartItemType
	s objJson.pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
	s objJson.status = objDocument.Status
	s objJson.eventID = ""
	s objJson.eventType = ""	
	d objJson.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获取模板导航数据
/// Creator:    yejian
/// CreateDate: 2022-6-8
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.InstanceData 实例表,
/// Input:      argInJson  命令参数 {"action":"GET_DOCCATEGORY_DATA","product":"OP","params":{"episodeID":"41","eventType":"Operation","eventID":"","parentID":"3","userID":"10209","resultType":"List","ctLocID":"95","DOCCategoryCode":"EMR09","otherCTLocID":"95","text":"","diseaseCodeAndName":""}}
/// 								parentID:业务活动记录分类ID
///             					episodeID:就诊号
/// 								userID:用户ID
/// 								resultType:展现类型，卡片 "Card",列表 "List"
/// 								eventType:事件类型
/// 								eventID:事件ID
/// 								cTLocID:本科ID
/// 								DOCCategoryCode:业务活动记录分类编码
/// 								otherCTLocID:其他科室ID，所有 "ALL"
/// 								text:搜索条件
/// 								diseaseCodeAndName:诊断
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDocCategoryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.UserID = argInJson.params.userID
	s dtoItem.ResultType = argInJson.params.resultType
	s dtoItem.EventType = argInJson.params.eventType
	s dtoItem.EventID = argInJson.params.eventID
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.OtherCTLocID = argInJson.params.otherCTLocID
	s dtoItem.Text = argInJson.params.text
	s dtoItem.DiseaseCodeAndName = argInJson.params.diseaseCodeAndName
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson(dtoItem,.argOutData)
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

/// Desc:       获取模板导航数据JSON
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetDocCategoryDataJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",operativeTemIds=""
	
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组不能为空"
	s jsonRoot = ##class(%DynamicArray).%New()
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID,dtoItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		// 配置门诊病历页面传入业务活动记录分类目录CategoryID用于过滤模板数据
		continue:((dtoItem.DOCCategoryCodeFilter'="")&&(dtoItem.DOCCategoryCodeFilter'=strDOCCategoryCode))
		//设置业务活动记录分类ID，以及分类编码
		s dtoItem.ParentID = strDocCID
		s dtoItem.DOCCategoryCode = strDOCCategoryCode
	
		s objDocCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(dtoItem.ParentID)
		//是否开启权限控制
		//s priActivity  = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("PrivControl",..#ProductCode,"N") 
		//获取病人信息
		s listPatInfo = ##class(EMR.DOC.BL.PrivLogic).GetPatInfo(dtoItem.EpisodeID,dtoItem.UserID,dtoItem.CTLocID)
		
		//获取业务活动记录ID集合(互斥写过病历排除)
		s arrRecordIds = ##class(EMR.OP.BL.TemplateCategory).GetRecordsByPid(dtoItem)
		continue:(arrRecordIds.%Size()=0)
		//获取无关联手术的相关模板IDs "^70^68^80^76^"
		s:((dtoItem.EventType= "Operation")&&(dtoItem.EventID="")) operativeTemIds = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("OperativeTemIds",dtoItem.ProductCode,"")
		//获取发布状态文档ID集合(和目录信息)
		s arrTemIds = ##class(EMR.OP.BL.TemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
		continue:(arrTemIds.%Size()=0)
		//过滤文本
		s pText = dtoItem.Text
		s arrData = ##class(%ArrayOfDataTypes).%New()
		set iter = arrTemIds.%GetIterator()
		while iter.%GetNext(.key , .item ) {
	        s jsonTem = item
	        continue:(jsonTem = "")||(jsonTem.templateID="")
	        //判断是否保存个实例（失败-1、未保存0、保存 实例ID）
	        //s instanceID = ##class(EMR.OP.BL.TemplateRules).GetFirstSavedID(dtoItem.EpisodeID,jsonTem.templateId)
	        //判断模板是否符合规则(如果不开启权限，不过滤规则)
	        s strStatue = ##class(EMR.OP.BL.TemplateRules).CanTempAct(jsonTem.templateID,listPatInfo)
	        continue:(strStatue=0)
	        //无关联手术不包含跳过
			continue:(operativeTemIds'="")&&($f("^"_operativeTemIds_"^", "^"_jsonTem.templateID_"^") = 0)
	        
			//条件过滤
			continue:(($find(jsonTem.text,pText) = 0)&&($find(jsonTem.janeSpell,pText) = 0)&&($find(jsonTem.fullFight,pText) = 0)) 
			//构建目录数组 
			s arrTemIds = ##class(EMR.OP.BL.Template).GetJsonDataByTemJosn(item,.arrData)
		}
		continue:(arrData.Count()=0)
		//根据数组输出JSON数据
		s jsonData = ##class(%DynamicObject).%New()
		s strRes = ##class(EMR.OP.BL.Template).GetJsonData("0",arrData,.jsonData)
		s jsonCat = ##class(%DynamicObject).%New()
		s jsonCat.id="flod-"_dtoItem.ParentID
		s jsonCat.type="flod"
		s jsonCat.text=objDocCat.EMRName
		s jsonCat.state="closed"
		s jsonCat.icon=""
		s jsonCat.children = jsonData.children
		d jsonRoot.%Push(jsonCat)
	}
	d jsonRoot.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获取科室模板导航数据
/// Creator:    yejian
/// CreateDate: 2022-6-8
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.InstanceData 实例表,
/// Input:      argInJson  命令参数 {"action":"GET_LOCCATEGORY_DATA","product":"OP","params":{"episodeID":"41","eventType":"Operation","eventID":"","parentID":"3","userID":"10209","resultType":"List","userLocID":"95","DOCCategoryCode":"EMR09","otherCTLocID":"95","text":"","diseaseCodeAndName":""}}
/// 								parentID:业务活动记录分类ID
///             					episodeID:就诊号
/// 								userID:用户ID
/// 								resultType:展现类型，卡片 "Card",列表 "List"
/// 								eventType:事件类型
/// 								eventID:事件ID
/// 								cTLocID:本科ID
/// 								DOCCategoryCode:业务活动记录分类编码
/// 								otherCTLocID:其他科室ID，所有 "ALL"
/// 								text:搜索条件
/// 								diseaseCodeAndName:诊断
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetLocCategoryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.UserID = argInJson.params.userID
	s dtoItem.ResultType = argInJson.params.resultType
	s dtoItem.EventType = argInJson.params.eventType
	s dtoItem.EventID = argInJson.params.eventID
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.OtherCTLocID = argInJson.params.otherCTLocID
	s dtoItem.Text = argInJson.params.text
	s dtoItem.DiseaseCodeAndName = argInJson.params.diseaseCodeAndName
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetLocCategoryDataJson(dtoItem,.argOutData)
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

/// Desc:       获取科室模板导航数据JSON
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetLocCategoryDataJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",operativeTemIds=""
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组不能为空"
	s jsonRoot = ##class(%DynamicArray).%New()
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID,dtoItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		// 配置门诊病历页面传入业务活动记录分类目录CategoryID用于过滤模板数据
		continue:((dtoItem.DOCCategoryCodeFilter'="")&&(dtoItem.DOCCategoryCodeFilter'=strDOCCategoryCode))
		//设置业务活动记录分类ID，以及分类编码
		s dtoItem.ParentID = strDocCID
		s dtoItem.DOCCategoryCode = strDOCCategoryCode
		s objDocCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(dtoItem.ParentID)
		//是否开启权限控制
		//s priActivity  = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("PrivControl",..#ProductCode,"N") 
		//获取病人信息
		s listPatInfo = ##class(EMR.DOC.BL.PrivLogic).GetPatInfo(dtoItem.EpisodeID,dtoItem.UserID,dtoItem.CTLocID)
		//获取业务活动记录ID集合(互斥写过病历排除)
		s arrRecordIds = ##class(EMR.OP.BL.TemplateCategory).GetRecordsByPid(dtoItem)
		continue:(arrRecordIds.%Size()=0)
		//获取无关联手术的相关模板IDs "^70^68^80^76^"
		s:((dtoItem.EventType= "Operation")&&(dtoItem.EventID="")) operativeTemIds = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("OperativeTemIds",dtoItem.ProductCode,"")
		//获取发布状态文档ID集合(和目录信息)
		s arrTemIds = ##class(EMR.OP.BL.TemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
		//获取科室模板ID集合（和目录信息）
		s arrLocTemIds = ##class(EMR.OP.BL.LocTemplateCategory).GetLocTemIDByRecordID(dtoItem,arrTemIds)
		continue:(arrLocTemIds.%Size()=0)
		//过滤文本
		s pText = dtoItem.Text
		s DiseaseCodeAndName = dtoItem.DiseaseCodeAndName
		s arrData = ##class(%ArrayOfDataTypes).%New()
		set iter = arrLocTemIds.%GetIterator()
		while iter.%GetNext(.key , .item ) {
	        s jsonTem = item
	        continue:(jsonTem = "")||(jsonTem.templateID="")
	        //判断是否保存个实例（失败-1、未保存0、保存 实例ID）
	        //s instanceID = ##class(EMR.OP.BL.LocTemplateRules).GetFirstSavedID(dtoItem.EpisodeID,jsonTem.templateId)
	        //判断模板是否符合规则(如果不开启权限，不过滤规则)
	        s strStatue = ##class(EMR.OP.BL.LocTemplateRules).CanTempAct(jsonTem.sourceID,listPatInfo)
	        continue:(strStatue=0)
	        //无关联手术不包含跳过
			continue:(operativeTemIds'="")&&($f("^"_operativeTemIds_"^", "^"_jsonTem.templateID_"^") = 0)
	        
			//条件过滤
			continue:(($find(jsonTem.text,pText) = 0)&&($find(jsonTem.janeSpell,pText) = 0)&&($find(jsonTem.fullFight,pText) = 0)) 
			
			//病种过滤
			continue:(($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)) 
			//构建目录数组 
			s arrTemIds = ##class(EMR.OP.BL.LocTemplate).GetJsonDataByTemJosn(item,.arrData)
		}
		continue:(arrData.Count()=0)
		//根据数组输出JSON数据
		s jsonData = ##class(%DynamicObject).%New()
		s strRes = ##class(EMR.OP.BL.LocTemplate).GetJsonData("0",arrData,.jsonData)
		s jsonCat = ##class(%DynamicObject).%New()
		s jsonCat.id="flod-"_dtoItem.ParentID
		s jsonCat.type="flod"
		s jsonCat.text=objDocCat.EMRName
		s jsonCat.state="closed"
		s jsonCat.icon=""
		s jsonCat.children = jsonData.children
		d jsonRoot.%Push(jsonCat)
	}
	d jsonRoot.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获取个人模板导航数据
/// Creator:    yejian
/// CreateDate: 2022-6-8
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.InstanceData 实例表,
/// Input:      argInJson  命令参数 {"action":"GET_LOCCATEGORY_DATA","product":"OP","params":{"episodeID":"41","eventType":"Operation","eventID":"","parentID":"3","userID":"10209","resultType":"List","userLocID":"95","DOCCategoryCode":"EMR09","otherCTLocID":"95","text":"","diseaseCodeAndName":""}}
/// 								parentID:业务活动记录分类ID
///             					episodeID:就诊号
/// 								userID:用户ID
/// 								resultType:展现类型，卡片 "Card",列表 "List"
/// 								eventType:事件类型
/// 								eventID:事件ID
/// 								cTLocID:本科ID
/// 								DOCCategoryCode:业务活动记录分类编码
/// 								otherCTLocID:其他科室ID，所有 "ALL"
/// 								text:搜索条件
/// 								diseaseCodeAndName:诊断
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPerCategoryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.UserID = argInJson.params.userID
	s dtoItem.ResultType = argInJson.params.resultType
	s dtoItem.EventType = argInJson.params.eventType
	s dtoItem.EventID = argInJson.params.eventID
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.OtherCTLocID = argInJson.params.otherCTLocID
	s dtoItem.Text = argInJson.params.text
	s dtoItem.DiseaseCodeAndName = argInJson.params.diseaseCodeAndName
	s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetPerCategoryDataJson(dtoItem,.argOutData)
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

/// Desc:       获取个人模板导航数据JSON
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetPerCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetPerCategoryDataJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",operativeTemIds=""
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组不能为空"
	s jsonRoot = ##class(%DynamicArray).%New()
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID,dtoItem.LangID)
	while result.%Next()
	{
		s strDocCID = result.Data("ID")
		s strDOCCategoryCode = result.Data("DOCCategoryCode")
		// 配置门诊病历页面传入业务活动记录分类目录CategoryID用于过滤模板数据
		continue:((dtoItem.DOCCategoryCodeFilter'="")&&(dtoItem.DOCCategoryCodeFilter'=strDOCCategoryCode))
		//设置业务活动记录分类ID，以及分类编码
		s dtoItem.ParentID = strDocCID
		s dtoItem.DOCCategoryCode = strDOCCategoryCode
		s objDocCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(dtoItem.ParentID)
		//是否开启权限控制
		//s priActivity  = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("PrivControl",..#ProductCode,"N") 
		//获取病人信息
		s listPatInfo = ##class(EMR.DOC.BL.PrivLogic).GetPatInfo(dtoItem.EpisodeID,dtoItem.UserID,dtoItem.CTLocID)
		//获取业务活动记录ID集合(互斥写过病历排除)
		s arrRecordIds = ##class(EMR.OP.BL.TemplateCategory).GetRecordsByPid(dtoItem)
		continue:(arrRecordIds.%Size()=0)
		//获取无关联手术的相关模板IDs "^70^68^80^76^"
		s:((dtoItem.EventType= "Operation")&&(dtoItem.EventID="")) operativeTemIds = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("OperativeTemIds",dtoItem.ProductCode,"")
		//获取发布状态文档ID集合(和目录信息)
		s arrTemIds = ##class(EMR.OP.BL.TemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
		//获取个人模板ID集合（和目录信息）
		s arrLocTemIds = ##class(EMR.DOC.BL.PerTemplateCategory).GetPerTemIDByRecordID(dtoItem,arrTemIds)
		continue:(arrLocTemIds.%Size()=0)
		//过滤文本
		s pText = dtoItem.Text
		s DiseaseCodeAndName = dtoItem.DiseaseCodeAndName
		s arrData = ##class(%ArrayOfDataTypes).%New()
		set iter = arrLocTemIds.%GetIterator()
		while iter.%GetNext(.key , .item ) {
	        s jsonTem = item
	        continue:(jsonTem = "")||(jsonTem.templateID="")
	        //判断是否保存个实例（失败-1、未保存0、保存 实例ID）
	        //s instanceID = ##class(EMR.OP.BL.LocTemplateRules).GetFirstSavedID(dtoItem.EpisodeID,jsonTem.templateId)
	        //判断模板是否符合规则(如果不开启权限，不过滤规则)
	        s strStatue = ##class(EMR.OP.BL.TemplateRules).CanTempAct(jsonTem.templateID,listPatInfo)
	        continue:(strStatue=0)
	        //无关联手术不包含跳过
			continue:(operativeTemIds'="")&&($f("^"_operativeTemIds_"^", "^"_jsonTem.templateID_"^") = 0)
	        
			//条件过滤
			continue:(($find(jsonTem.text,pText) = 0)&&($find(jsonTem.janeSpell,pText) = 0)&&($find(jsonTem.fullFight,pText) = 0)) 
			
			//病种过滤
			;continue:(($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)) 
			//构建目录数组 
			s arrTemIds = ##class(EMR.DOC.BL.PerTemplate).GetJsonDataByTemJosn(item,.arrData)
		}
		continue:(arrData.Count()=0)
		//根据数组输出JSON数据
		s jsonData = ##class(%DynamicObject).%New()
		s strRes = ##class(EMR.DOC.BL.PerTemplate).GetJsonData("0",arrData,.jsonData)
		s jsonCat = ##class(%DynamicObject).%New()
		s jsonCat.id="flod-"_dtoItem.ParentID
		s jsonCat.type="flod"
		s jsonCat.text=objDocCat.EMRName
		s jsonCat.state="closed"
		s jsonCat.icon=""
		s jsonCat.children = jsonData.children
		d jsonRoot.%Push(jsonCat)
	}
	d jsonRoot.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       根据文档ID获取门诊病历实例的数据
/// Creator:    yejian
/// CreateDate: 2022-7-18
/// Table:		病历导航相关表，实例表
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_RECORDBYDOCUMENTID","params":{"documentID":"713"}}
/// 								documentID:文档ID
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetRecordByDocumentID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.OP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.DocumentID = argInJson.params.documentID
	;s dtoItem.LangID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.OP.BL.ClientCategory).GetRecordByDocumentIDJson(dtoItem,.argOutData)
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

/// Desc:       根据文档ID获取门诊病历实例的数据
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoItem 默认模板入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetRecordByDocumentIDJson(dtoItem As EMR.OP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(dtoItem.DocumentID="") "-1^文档ID不能为空"
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(dtoItem.DocumentID)
	q:(objDocument="") "-1^获取文档实例失败"
	s dtoItem.EpisodeID = objDocument.EpisodeID.%Id()
	s objTem = objDocument.TemplateID
	q:(objTem="") "-1^获取模板对象失败"
	s strTemCId = ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
	q:(strTemCId="") "-1^获取业务活动记录失败"
	s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
	s objDocCTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
	//指定病历实例是否有对应患者签名后的PDF文档
	s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(dtoItem.DocumentID, dtoItem.EpisodeID)			
	s objJson = ##class(%DynamicObject).%New()
	s objJson.documentID = objDocument.%Id()
	s objJson.docName = objDocument.DOCName
	s objJson.docCode = objDocument.DOCCode
	s objJson.docCategoryCode = objDocument.DOCCategoryCode
	s objJson.docCategoryName = objDocCTem.EMRName
	s objJson.templateCategoryID = objDocument.TemplateCategoryID.%Id()
	s objJson.templateID = objDocument.TemplateID.%Id()
	s objJson.serial = objDocument.Serial
	s objJson.isLeadframe = objTemCat.Title.IsLeadframe
	s objJson.isMutex = objTemCat.Title.IsMutex
	s objJson.chartItemType = objTem.ChartItemType
	s objJson.pluginType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"WORD")
	s objJson.status = objDocument.Status
	s objJson.eventID = ""
	s objJson.eventType = ""

	d objJson.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

}
