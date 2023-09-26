/// 名称:	EMR.IP.BL.BLClientCategory
/// 描述:	住院病历 病历导航业务逻辑类
/// 编写者：lifengbo
/// 编写日期: 2023-03-08
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLClientCategory Extends EMR.IP.COM.ActionBase
{

/// Desc:       保存文档
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      argArray  命令参数  {"action":"GET_NAVPARAM","params":{"templateVersionId":"1","status":"1","userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetNavParam(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCategoryCode,userID,userLocID)=""
	
	s docCategoryCode = argInJson.params.docCategoryCode
	s userID = argInJson.params.userID
	s userLocID = argInJson.params.userLocID
	s prdouct = argInJson.product
	
    s strRes = ##Class(EMR.IP.BL.BLClientCategory).GetNavParamJson(docCategoryCode,userID,userLocID,prdouct,.argOutData)
    
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","缺少关键参数",2)
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入版本ID",2)
	}
	elseif(strRes = "-300")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","数据对象缺失",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:取加载导航参数
/// Creator:    lifengbo
/// CreateDate: 2023-03-08
/// Input:      ACategoryID 目录ID
///             AUserID 用户ID
///             ALocID 科室ID
/// Debug: s argOutData = ##class(%GlobalBinaryStream).%New()
///        w ##Class(EMR.IP.BL.BLClientCategory).GetNavParamJson("EMR090001",18881,191,"IP",.argOutData)
/// 		   w argOutData.Read()
ClassMethod GetNavParamJson(argDocCategoryCode As %String, argUserID As %String, argUserLocID As %String, argProduct As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes=-100
	s json = {}
	if (argDocCategoryCode = "") 
	{
		d json.%ToJSON(argOutData)
		q strRes
	}
	s strRes=-300
	
	s DataID= ""
	s DataID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxCode"," "_argDocCategoryCode,DataID))
	q:(DataID="") strRes
	
	s EMRTSchemeItemID=""
	s EMRTSchemeItemID = $o(^CF.EMR.DOC.EMRTSchemeItemI("IdxDataID",DataID,EMRTSchemeItemID))
	q:(EMRTSchemeItemID = "") strRes
	
	s objEMRTSchemeItem=""
	s objEMRTSchemeItem = ##Class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(EMRTSchemeItemID)
	q:(objEMRTSchemeItem = "") strRes
	
	s ItemURL = objEMRTSchemeItem.HISURL
	
	s sequence ="DESC"
	s defaultSequence = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("RecordSequence")
	if (defaultSequence'="")
	{
		d jsonRecordSeq.%FromJSON(defaultSequence)
		s sequence = jsonRecordSeq.%Get("NavRecord")
	}
	s recordSequence=""
	s recordSequence = ##Class(EMR.DOC.BL.UserConfig).GetUserConfigValue(argUserID,argUserLocID,"NAVRECORDSEQ",argProduct)
	s:(recordSequence = "") recordSequence = sequence
	
	s defaultDisplayType="LIST"
	s DisplayType = ""
	s DisplayType = ##Class(EMR.DOC.BL.UserConfig).GetUserConfigValue(argUserID,argUserLocID,"DISPLAYTYPE",argProduct) 
	s:(DisplayType = "") DisplayType = defaultDisplayType
	
	
	d json.%Set("ItemURL",ItemURL)
	d json.%Set("Sequence",recordSequence)
	d json.%Set("DisplayType",DisplayType)
	d json.%ToJSON(argOutData)
	
	q 1
}

/// Desc:       获取模板导航数据
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
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
	s dtoItem = ##class(EMR.IP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.UserID = argInJson.params.userID
	s dtoItem.ResultType = argInJson.params.resultType
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.OtherCTLocID = argInJson.params.otherCTLocID
	s dtoItem.Text = argInJson.params.text
	s dtoItem.DiseaseCodeAndName = argInJson.params.diseaseCodeAndName
	s dtoItem.isCollapse = argInJson.params.isCollapse
	s dtoItem.isCollect = argInJson.params.isCollect
	
	s dtoItem.EventType = argInJson.params.eventType
	s dtoItem.EventID = argInJson.params.eventID
	
    s strRes = ##Class(EMR.IP.BL.BLClientCategory).GetDocCategoryDataJson(dtoItem,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetDocCategoryDataJson(dtoItem As EMR.IP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",operativeTemIds=""
	
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组不能为空"
	
	s jsonData = ##class(%DynamicArray).%New()
	
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID)
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
		s arrRecordIds = ##class(EMR.IP.BL.BLTemplateCategory).GetRecordsByPid(dtoItem)
		continue:(arrRecordIds.%Size()=0)
		//获取无关联手术的相关模板IDs "^70^68^80^76^"
		s:((dtoItem.EventType= "Operation")&&(dtoItem.EventID="")) operativeTemIds = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("OperativeTemIds",dtoItem.ProductCode,"")
		//获取发布状态文档ID集合(和目录信息)
		s arrTemIds = ##class(EMR.IP.BL.BLTemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
		continue:(arrTemIds.%Size()=0)
		//过滤文本
		s pText = dtoItem.Text
		s arrData = ##class(%ArrayOfDataTypes).%New()
		set iter = arrTemIds.%GetIterator()
		while iter.%GetNext(.key , .item ) {
	        s jsonTem = item
	        continue:(jsonTem = "")||(jsonTem.templateID="")
	        //判断是否保存个实例（失败-1、未保存0、保存 实例ID）
	        s documentID = ..GetFirstSavedID(dtoItem.EpisodeID,jsonTem.templateID)
	        s isHasSavedSingleTemplate = ..GetStatusSavedeSingleTemplate(jsonTem.templateID,documentID)
	        continue:(isHasSavedSingleTemplate=1)
	        
	        //判断模板是否符合规则(如果不开启权限，不过滤规则)
	        s strStatue = ##class(EMR.OP.BL.TemplateRules).CanTempAct(jsonTem.templateID,listPatInfo)
	        continue:(strStatue=0)
	        //无关联手术不包含跳过
			continue:(operativeTemIds'="")&&($f("^"_operativeTemIds_"^", "^"_jsonTem.templateID_"^") = 0)
	        
			//条件过滤
			continue:(($find(jsonTem.text,pText) = 0)&&($find(jsonTem.janeSpell,pText) = 0)&&($find(jsonTem.fullFight,pText) = 0)) 
			
			//过滤常用模板
			continue:((dtoItem.isCollect="Y")&&(1'=##class(EMR.IP.BL.BLCollectTemplate).CheckCollectTemplate(dtoItem.UserID,"Template",jsonTem.templateID)))
			
			//满足条件的对象返回
			d jsonData.%Push(jsonTem)
			
		}	
	}
	d jsonData.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获取科室模板导航数据
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Table:		
/// Input:      argInJson  
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetLocCategoryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.IP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.UserID = argInJson.params.userID
	s dtoItem.ResultType = argInJson.params.resultType
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.OtherCTLocID = argInJson.params.otherCTLocID
	s dtoItem.Text = argInJson.params.text
	s dtoItem.DiseaseCodeAndName = argInJson.params.diseaseCodeAndName
	s dtoItem.isCollapse = argInJson.params.isCollapse
	s dtoItem.isCollect = argInJson.params.isCollect
	
	s dtoItem.EventType = argInJson.params.eventType
	s dtoItem.EventID = argInJson.params.eventID
	
    s strRes = ##Class(EMR.IP.BL.BLClientCategory).GetLocCategoryDataJson(dtoItem,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetDocCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetLocCategoryDataJson(dtoItem As EMR.IP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"

	s strRes = "1",operativeTemIds=""
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组不能为空"
	s jsonData = ##class(%DynamicArray).%New()
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID)
	
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
		s queryLocID = $s($zcvt(dtoItem.OtherCTLocID,"U")="ALL":"",1:dtoItem.OtherCTLocID)
		s listPatInfo = ##class(EMR.DOC.BL.PrivLogic).GetPatInfo(dtoItem.EpisodeID,dtoItem.UserID,queryLocID,..#ProductCode)
		//获取业务活动记录ID集合(互斥写过病历排除)
		s arrRecordIds = ##class(EMR.IP.BL.BLTemplateCategory).GetRecordsByPid(dtoItem)
		continue:(arrRecordIds.%Size()=0)
		//获取无关联手术的相关模板IDs "^70^68^80^76^"
		s:((dtoItem.EventType= "Operation")&&(dtoItem.EventID="")) operativeTemIds = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("OperativeTemIds",dtoItem.ProductCode,"")
		//获取发布状态文档ID集合(和目录信息)
		s arrTemIds = ##class(EMR.IP.BL.BLTemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
		//获取科室模板ID集合（和目录信息）
		s arrLocTemIds = ##class(EMR.IP.BL.BLLocTemplate).GetLocTemIDByRecordID(dtoItem,arrTemIds)
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
	        s documentID = ..GetFirstSavedID(dtoItem.EpisodeID,jsonTem.templateID)
	        s isHasSavedSingleTemplate = ..GetStatusSavedeSingleTemplate(jsonTem.templateID,documentID)
	        continue:(isHasSavedSingleTemplate=1)
	        
	        //判断模板是否符合规则(如果不开启权限，不过滤规则)
	        s strStatue = ##class(EMR.IP.BL.BLLocTemplate).CanTempAct(jsonTem.sourceID,listPatInfo)
	        continue:(strStatue=0)
	        
	        
	        //无关联手术不包含跳过
			continue:(operativeTemIds'="")&&($f("^"_operativeTemIds_"^", "^"_jsonTem.templateID_"^") = 0)
	        
	        
			//条件过滤
			continue:(($find(jsonTem.text,pText) = 0)&&($find(jsonTem.janeSpell,pText) = 0)&&($find(jsonTem.fullFight,pText) = 0)) 
			
			//病种过滤
			continue:(($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)) 
			
			s jsonTem.isCollect = ##class(EMR.IP.BL.BLCollectTemplate).CheckCollectTemplate(dtoItem.UserID,"LocTemplate",jsonTem.id)
			
			//过滤常用模板
			continue:((dtoItem.isCollect="Y")&&(1'=##class(EMR.IP.BL.BLCollectTemplate).CheckCollectTemplate(dtoItem.UserID,"LocTemplate",jsonTem.id)))
			
			//满足条件的对象返回
			d jsonData.%Push(jsonTem)
		}
	}
	d jsonData.%ToJSON(argOutData)
	q strRes
Error
	q "-1^"_$zerror
}

/// Desc:       获取个人模板导航数据
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.InstanceData 实例表,
/// Input:      argInJson  
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPerCategoryData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.IP.DTO.DocCategory).%New()
	s dtoItem.ProductCode = argInJson.product
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.UserID = argInJson.params.userID
	s dtoItem.ResultType = argInJson.params.resultType
	s dtoItem.CTLocID = argInJson.params.userLocID
	s dtoItem.SSGroupID = argInJson.params.ssgroupID
	s dtoItem.DOCCategoryCodeFilter = argInJson.params.docCategoryCode
	s dtoItem.OtherCTLocID = argInJson.params.otherCTLocID
	s dtoItem.Text = argInJson.params.text
	s dtoItem.DiseaseCodeAndName = argInJson.params.diseaseCodeAndName
	s dtoItem.isCollapse = argInJson.params.isCollapse
	s dtoItem.isCollect = argInJson.params.isCollect
	
	s dtoItem.EventType = argInJson.params.eventType
	s dtoItem.EventID = argInJson.params.eventID
    s strRes = ##Class(EMR.IP.BL.BLClientCategory).GetPerCategoryDataJson(dtoItem,.argOutData)
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
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Input:      dtoItem 病历导航入参对象
/// OutPut:     成功 返回1，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.ClientCategory).GetPerCategoryDataJson("YS01","TEMPLATE",.argOutData)
ClassMethod GetPerCategoryDataJson(dtoItem As EMR.IP.DTO.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1",operativeTemIds=""
	q:(dtoItem.CTLocID="") "-1^科室ID不能为空"
	q:(dtoItem.EpisodeID="") "-1^就诊号不能为空"
	q:(dtoItem.UserID="") "-1^用户ID不能为空"
	q:(dtoItem.SSGroupID="") "-1^安全组不能为空"
	s jsonData = ##class(%DynamicArray).%New()
	s result = ##class(%ResultSet).%New("EMR.DOC.BL.EMRCategory:GetCategory")
	d result.Execute(dtoItem.CTLocID, dtoItem.SSGroupID, dtoItem.EpisodeID)
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
		s arrRecordIds = ##class(EMR.IP.BL.BLTemplateCategory).GetRecordsByPid(dtoItem)
		continue:(arrRecordIds.%Size()=0)
		
		//获取无关联手术的相关模板IDs "^70^68^80^76^"
		s:((dtoItem.EventType= "Operation")&&(dtoItem.EventID="")) operativeTemIds = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("OperativeTemIds",dtoItem.ProductCode,"")
		
		//获取发布状态文档ID集合(和目录信息)
		s arrTemIds = ##class(EMR.IP.BL.BLTemplateCategory).GetTemIDByRecordID(dtoItem,arrRecordIds)
		
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
	        s documentID = ..GetFirstSavedID(dtoItem.EpisodeID,jsonTem.templateID)
	        s isHasSavedSingleTemplate = ..GetStatusSavedeSingleTemplate(jsonTem.templateID,documentID)
	        continue:(isHasSavedSingleTemplate=1)
	        
	        //判断模板是否符合规则(如果不开启权限，不过滤规则)
	        s strStatue = ##class(EMR.OP.BL.TemplateRules).CanTempAct(jsonTem.templateID,listPatInfo)
	        continue:(strStatue=0)
	        //无关联手术不包含跳过
			continue:(operativeTemIds'="")&&($f("^"_operativeTemIds_"^", "^"_jsonTem.templateID_"^") = 0)
	        
			//条件过滤
			continue:(($find(jsonTem.text,pText) = 0)&&($find(jsonTem.janeSpell,pText) = 0)&&($find(jsonTem.fullFight,pText) = 0)) 
			
			//病种过滤
			;continue:(($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)&&($find(jsonTem.disease,DiseaseCodeAndName) = 0)) 
			
			//过滤常用模板
			continue:((dtoItem.isCollect="Y")&&(1'=##class(EMR.IP.BL.BLCollectTemplate).CheckCollectTemplate(dtoItem.UserID,"PerTemplate",jsonTem.templateID)))
			
			
			d jsonData.%Push(item)
		}

	}
	d jsonData.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       获得当前目录状态
/// Creator:    Candy
/// CreateDate: 2017-10-10
/// Input:      ACTLocID 科室ID
///            ASSGroupID 安全组ID
///            AEpisodeID 就诊号
///            ACategoryID 目录分类ID(目录展现结构第一层ID)
/// Output:     {"Visible":"1","Sequence":"0"} Visible 为1可见0不可见  Sequence 目录的所在顺序
/// Debug:      w ##Class(EMRservice.BL.BLClientCategory).GetCategoryStatus(6,100,112,3)
ClassMethod GetCategoryStatus(ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String, ACategoryID As %String) As %String
{
	s result = "{""Visible"":""0"",""Sequence"":""0"",""Num"":""0""}"
	s result = "{""Visible"":""1"",""Sequence"":""1""}" 
	q result
	
	/*
	q:(ACategoryID = "EPR") result
	q:(ACTLocID = "")||(ASSGroupID = "")||(AEpisodeID = "")||(ACategoryID = "") result
	s itemDr = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_ACategoryID,""))
	q:(itemDr = "") result
	s objCTOrgScheme = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(itemDr)
	q:(objCTOrgScheme = "") result
	s itemCode = objCTOrgScheme.ItemCode
	s episodeType = $p(^PAADM(AEpisodeID),"^",2)
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(AEpisodeID)
		s schemCode = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemCode = "OUTPATIENT"
	}
	s rowId = $o(^DHCEMRM.EMRNavSchemeItemI("IdxSchemeItemCode"," "_schemCode," "_$zcvt(itemCode,"U"),""))
	q:(rowId = "") result
	s objNav = ##Class(EMRmeta.EMRNavigationSchemeItem).%OpenId(rowId)
	q:(objNav = "") result
	
	
	s strItemSeq = objNav.ItemSeq
	//如果该科室设置病例导航科室项目顺序，通过科室项目顺序获取
	s rowSeqID = $o(^DHCEMRM.EMRNavSchemeItemSeqLocI("IdxLocGID"," "_ACTLocID,""))
	if (rowSeqID'="")
	{
		s objItemSeqLoc = ##class(EMRmeta.EMRNavigationSchemeItemSeqLoc).%OpenId(rowSeqID)
		s strCTLocGroupID = objItemSeqLoc.CTLocGroupID
		s rowSeqID = $o(^DHCEMRM.EMRNavSchemeItemSeqI("IdxLocGItemID"," "_strCTLocGroupID," "_rowId,""))
		if (rowSeqID'="")
		{
			s objNavSeq = ##Class(EMRmeta.EMRNavigationSchemeItemSeq).%OpenId(rowSeqID)
			s:(objNavSeq '= "") strItemSeq = objNavSeq.ItemSeq
		}
	}
	
	q:($d(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," "_schemCode," "_itemCode," "_ASSGroupID))<=0) result			
	s locFlag = $d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," "_schemCode," "_itemCode," "_ACTLocID))
	s recordFlag = ..CheckHasRecord(ACategoryID,AEpisodeID)
	q:((locFlag <=0)&&(recordFlag<=0)) result
	s num = ##Class(EMRservice.BL.BLClientCategory).GetRecordCount(ACategoryID,AEpisodeID)
    s printNum = ##Class(EMRservice.BL.BLClientCategory).GetPrintedRecordCount(ACategoryID,AEpisodeID)
    s result = "{""Visible"":""1"",""Sequence"":"""_strItemSeq_""",""Num"":"""_num_""",""PrintNum"":"""_printNum_"""}"
	q result
	*/
}

/// Desc:       获取category信息
/// Creator:    lifengbo
/// CreateDate: 2023-03-24
/// Table:		
/// Input:      argArray  命令参数 {"action":"GET_CATEGORYJSON","params":{"docCategoryCodes":"EMR0900,EMR01000"},"product":"IP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetCategoryJson(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCategoryCodes)=""
	s docCategoryCodes=argInJson.params.docCategoryCodes
	s episodeID = argInJson.params.episodeID
    s strRes = ##Class(EMR.IP.BL.BLClientCategory).GetCategoryJsonData(episodeID,docCategoryCodes,.argOutData)
	
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-100")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","关键入参缺失",2)
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","备注信息添加后实例保存失败",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000:"_$p(strRes,"^",2),2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	获取病历实例备注信息
/// Input:	
/// Return:	设置状态
/// Debug:	s argOutData=##class(%GlobalBinaryStream).%New()
/// 			d ##Class(EMR.IP.BL.BLClientCategory).GetCategoryJsonData(285,"EMR0900",.argOutData)
/// 			w argOutData.Read()
ClassMethod GetCategoryJsonData(argEpisodeID As %String = "", argDocCategoryCodes As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = "1"
	
	s jsonArr = []
	if ((argDocCategoryCodes="")||(argEpisodeID=""))
	{
		d jsonArr.%ToJSON(argOutData)
		q strRes
	}
	
	s episodeType= $p(^PAADM(argEpisodeID),"^",2)
	
	if (episodeType = "I")
	{
		s disDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
		s schemType = $case(disDateTime,"":"RUNNING",:"ARCHIVING")
	}
	else
	{
		s schemType = "OUTPATIENT"
	}
	
	s EMRTSchemeTypeID=""
	s EMRTSchemeTypeID = $o(^CF.EMR.DOC.EMRTSchemeTypeI("IdxCode"," "_schemType,EMRTSchemeTypeID))
	
	s EMRTSchemeID=""
	s EMRTSchemeID=$o(^CF.EMR.DOC.EMRTSchemeI("IdxSchemeType",EMRTSchemeTypeID,EMRTSchemeID))
	
	
	for i=1:1:$l(argDocCategoryCodes,",")
	{
		s DocCategoryCode=$p(argDocCategoryCodes,",",i)
		
		s DataID=""
		s DataID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxCode"," "_DocCategoryCode,DataID))
		s isCategoryInLoc=0
		s rowId = ""
		for
		{
			s rowId = $o(^CF.EMR.DOC.EMRTSchemeItemI("IdxDataID",DataID,rowId))
			q:(rowId="")
			s objOrgItem = ##Class(CF.EMR.DOC.EMRTSchemeItem).%OpenId(rowId)
			continue:(objOrgItem="")
			
			continue:(objOrgItem.EMRTScheme.%Id()'=EMRTSchemeID)
			s jsonSub={}
			s jsonSub.docCategoryCode=DocCategoryCode
			//默认 emr.bs.ip.navigation.list.csp
			s jsonSub.ItemURL=$s(objOrgItem.HISURL'="":objOrgItem.HISURL,1:"emr.bs.ip.navigation.list.csp")
			
			s jsonSub.ItemTitle= objOrgItem.DataID.Name
			//是否是知情告知，Y/N
			s isInformed= $s(DocCategoryCode["EMR07":"Y",1:"N")
			s jsonSub.IsInformed=isInformed
			
			//是否可跨科搜索（不检查权限规则），Y/N
			s isCanAcrossLoc="N"
			s CanAcrossLocOptionValue = ##class(EMR.DOC.BL.SysOption).GetOptionValueByName("SearchAcrossDepartment")
			s jsonCanAcrossLoc = [].%FromJSON(CanAcrossLocOptionValue)
			set iter = jsonCanAcrossLoc.%GetIterator()
			while iter.%GetNext(.key , .item ) {
		        s:(item.code = DocCategoryCode) isCanAcrossLoc="Y"
		        q:(isCanAcrossLoc="Y")
			}

			s jsonSub.CanAcrossLoc= isCanAcrossLoc
			
			d jsonArr.%Push(jsonSub)
		}
	}

	d jsonArr.%ToJSON(argOutData)
	
	q 1
Error
	s $zt =""
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
    s strRes = ##Class(EMR.IP.BL.BLClientCategory).GetSaveRecordByDocumentIDJson(DocumentID,.argOutData)
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
	s strTemCId = ##Class(EMR.IP.BL.BLTemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
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
	s objJson.eventID = ""
	s objJson.eventType = ""	
	d objJson.%ToJSON(argOutData)
	q strRes
Error
    q "-1^"_$zerror
}

/// Desc:       判断模板是否保存过
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      aEpisodeID:病人就诊号
/// 			aTemplateID 模板ID
/// OutPut:     -1 失败, 0 没有保存，保存返回实例id
/// Debug: 		w ##class(EMR.IP.BL.BLLocTemplate).GetFirstSavedID("285","262")   
ClassMethod GetFirstSavedID(aEpisodeID As %String, aTemplateID As %String) As %String
{
	s ReturnValue = "0"
	q:(aEpisodeID="")||(aTemplateID="") "-1"
	
	s curseq = ""
	s TILDocumentData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(aEpisodeID)
	//判断日志是否已保存过,修改增加状态判断，如果有日志，切不为删除状态。
	s RowID = ""
	for
	{
		s RowID = $o(@TILDocumentData@("IdxEpisodeTemplateStatus",aEpisodeID,aTemplateID," SAVE",RowID))
		q:(RowID="")
		s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(RowID)
		continue:(objDocument="")
	 	s ReturnValue = RowID
	 	q
	}
	q ReturnValue
}

/// Desc:       校验唯一模板是否已经书写病历
/// Creator:    lifengbo
/// CreateDate: 2023-04-21
/// Input:      argTemplateID 模板ID argDocumentID文档ID
/// OutPut:     已经书写 返回1，
/// 			未书写 0
/// 			argOutData json数据
/// Debug:      w ##class(EMR.IP.BL.BLClientCategory).GetStatusSavedeSingleTemplate("","")
ClassMethod GetStatusSavedeSingleTemplate(argTemplateID As %String, argDocumentID As %String)
{
	s ret=0
	s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(argTemplateID)
	q:(objTemplate="") ret
	s type = objTemplate.ChartItemType
	//唯一模板，存在实例判定为已写
	if (($zcvt(type,"U")="SINGLE")&&(argDocumentID>0))
	{
		s ret=1
	}
	//唯一模板，存在实例判定为已写
	if (($zcvt(type,"U")'="SINGLE")&&(argDocumentID>0))
	{
		s UniqueCreate = objTemplate.TemplateCategory.Title.UniqueCreate
		s:(UniqueCreate=1) ret=1
	}
	q ret
}

}
