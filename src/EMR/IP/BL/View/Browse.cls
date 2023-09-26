/// 名称:	EMR.IP.BL.View.Browse
/// 描述:	病历浏览[2,3,4版]
/// 编写者：yanna
/// 编写日期: 2023-2-28
/// 产品组：电子病历产品组
Class EMR.IP.BL.View.Browse Extends EMR.IP.COM.ActionBase
{

/// Desc:       根据配置名获取配置值
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_OPTION","product":"IP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOptionValue(action As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(action="") "-1^入参不能为空"
    s strMark = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2(action,"")
	d argOutData.Write(strMark)
	q strRes
}

/// Desc:       根据配置名获取配置值
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetOption(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s optionName = argInJson.params.optionName
    s strRes = ..GetOptionValue(optionName,.argOutData)
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

/// Desc:       根据就诊号获取patientID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPtIDByEpisodeID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argInJson.params.episodeID
    s strRes = ..GetPtIDByEpisodeIDValue(episodeID,.argOutData)
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

/// Desc:       根据就诊号获取patientID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetPtIDByEpisodeIDValue(aEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aEpisodeID="") "-1^就诊号不能为空"
    s strMark = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(aEpisodeID)
	d argOutData.Write(strMark)
	q strRes
}

/// Desc:       根据就诊号获取科室ID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDeptIDByEpisodeID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argInJson.params.episodeID
    s strRes = ..GetDeptIDByEpisodeIDValue(episodeID,.argOutData)
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

/// Desc:       根据就诊号获取科室ID
/// Creator:    yanna
/// CreateDate: 2023-02-28
/// Table:		
/// Input:      argInJson  命令参数 {"action":"GET_CLIENTINFO","product":"OP"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDeptIDByEpisodeIDValue(aEpisodeID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aEpisodeID="") "-1^就诊号不能为空"
    s strMark = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(aEpisodeID)
    s strMark=""""_strMark_""""
	d argOutData.Write(strMark)
	q strRes
}

/// Desc:		获取病历浏览目录
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetBrowseCategory(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ..GetBrowseCategoryJSON(argInJson,argOutData)
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

/// Desc:		获取病历浏览目录
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetBrowseCategoryJSON(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s episodeID = argInJson.params.episodeID
	s resultType = argInJson.params.resultType
	s docIDs = argInJson.params.docIDs
	s userLocID = argInJson.params.userLocID
	s ssgroupID = argInJson.params.ssgroupID
	s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
	s version = ##Class(EMR.DOC.BL.GlobalData).GetEMRVersionID(episodeID)
	s res = "1"
	if (version'=3&&(version'=4)){
		d argOutData.Write("{""type"":"""",""data"":""""}")
		q res
		} 
	if (version=3){
		d argOutData.Write("{""type"":""emr3"",")
		s strMark = ##Class(EMRservice.BL.BLClientCategory).GetBrowseCategory(episodeID,resultType,docIDs,userLocID,"browse")
		d argOutData.Write("""data"":")
		d strMark.Rewind()
		while (strMark.AtEnd=0){
			s tmpOut = strMark.Read(32000)
			d argOutData.Write(tmpOut)
			}
		d argOutData.Write("}")
	}elseif (version=4){
		s dtoItem =##Class(EMR.IP.DTO.View.DocCategory).%New()
		s dtoItem.CTLocID = userLocID
		s dtoItem.EpisodeID = episodeID
		s dtoItem.SSGroupID = ssgroupID
		s dtoItem.LangID = langID
		d argOutData.Write("{""type"":""emr4"",")
		d argOutData.Write("""data"":")
		s res = ..GetAllRecordsBrowse(dtoItem,.argOutData)
		d argOutData.Write("}")
	}
	q res
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetRecordHtml(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ..GetRecordHtmlJSON(argInJson,argOutData)
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

/// Desc:		获取病历浏览数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetRecordHtmlJSON(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s res = "1"
	s recordID = argInJson.params.recordID
	s emrVersion = argInJson.params.emrVersion
	s episodeID = argInJson.params.episodeID
	if ((emrVersion="")&&(episodeID'="")){
		s emrVersion =  ##Class(EMR.DOC.BL.GlobalData).GetEMRVersionID(episodeID)
		s emrVersion = "emr"_emrVersion
		}
	s htmlResArry = ##Class(%ArrayOfDataTypes).%New()
	if (emrVersion="emr3"){
		s strMark = ##Class(EMRservice.BLBSParseXML).GetEMRHtmlData(recordID,"bsbrowse",htmlResArry)
		}else{
		//根据docID取json数据
		s jsonData = ##Class(%GlobalBinaryStream).%New()
		s dtoItem = ##class(EMR.DOC.DTO.DocumentData).%New()
		s arrJson = ##Class(%DynamicArray).%New()
		d arrJson.%Push(recordID)
		s dtoItem.DocumentIds = arrJson
		s dtoItem.DocType = "WORD"
		s loadjsonRes = ##Class(EMR.DOC.BL.DocumentData).LoadDocumentJson(dtoItem,.jsonData)
		if (loadjsonRes'["-1"){
			s strMark = ##Class(EMRservice.BLBSParseJSON).GetEMRHtmlData(jsonData,htmlResArry)
			}else{
			d htmlResArry.SetAt(loadjsonRes,"resDesc")
			}
		}
	if (htmlResArry.GetAt("resDesc")=""){
		s resData = ##class(%DynamicObject).%New()
		s count = 0
		while (strMark.AtEnd = 0)
		{
			s tmpOut = strMark.Read(32000)
			s count = count+1
			s resData.value = resData.value_tmpOut
		}
		d resData.%ToJSON(argOutData)
		q res
	}else{
		q htmlResArry.GetAt("resDesc")
		}
Error
	q "-1^获取病历数据发生异常"
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetRecordPrivilege(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ..GetRecordPrivilegeJSON(argInJson,argOutData)
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
		q ..SetOutMessage(argOutMessage,"ERROR","获取权限失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:		获取病历脚本权限
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetRecordPrivilegeJSON(argInJson As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s res = "1"
	s emrVersion = argInJson.params.emrVersion
	s recordID = argInJson.params.recordID 
	
	s userid = argInJson.params.userid
	s userloc = argInJson.params.userloc
	s ssgroupid = argInJson.params.ssgroupid

	s patientid =  argInJson.params.patientID
	s admid =  argInJson.params.episodeID
	s sessionid =  argInJson.params.sessionID
	s documentids =  recordID
	s productcode = argInJson.product
	if (emrVersion="emr3"){
		s strMark = ##class(EMRservice.Ajax.privilege).GetBrowsePrivilege(userid,userloc,ssgroupid,admid,patientid,documentids)
		if (strMark=""){
			d argOutData.Write("""""")
			}else{
			d argOutData.Write(strMark)
			}
	}else{	
		s arrJson = ##class(%DynamicArray).%New()
		d arrJson.%Push(documentids)
		s objItem = ##class(EMR.DOC.DTO.PrivRuleData).%New()
		s objItem.userid = userid
		s objItem.userloc =  userloc
		s objItem.ssgroupid =  ssgroupid
		s objItem.patientid =  patientid
		s objItem.admid =  admid
		s objItem.sessionid =  sessionid
		s objItem.documentids =  arrJson
		s objItem.productcode = productcode
		d ##Class(EMR.DOC.BL.PrivRuleData).GetBrowsePrivilegeJson(objItem,argOutData)
	}
	q res
Error
	q "-1^发生异常：获取权限失败"
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetDetaillogPart(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product=argInJson.product
    s documentID=argInJson.params.documentID
    s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
	s strRes = ##Class(EMR.DOC.BL.EMRLogsView).GetDetailLogJson(product,documentID,langID,.argOutData)
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
		q ..SetOutMessage(argOutMessage,"ERROR","获取权限失败",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:		获取病历html数据
/// Creator:	yanna
/// CreateDate: 2014-8-28
/// Input: 		ACTLocId 科室
///       		AEpisodeId 就诊号
/// Output: 	json
/// Debug 		w ##Class(EMR.IP.BL.View.Browse).GetBrowseCategory(76)
ClassMethod GetDetaillogAll(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s product=argInJson.product
    s episodeID=argInJson.params.episodeID
	s langID = $case(argInJson.params.langID,"":"20",:argInJson.params.langID)
    s strRes = ##Class(EMR.DOC.BL.EMRLogsView).GetAllLogJson(product,episodeID,langID,.argOutData)
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
		q ..SetOutMessage(argOutMessage,"ERROR","获取权限失败",2)
	}
Error
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
ClassMethod GetAllRecordsBrowse(dtoItem As EMR.IP.DTO.View.DocCategory, ByRef argOutData As %GlobalBinaryStream) As %String
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
			s strTemCId = ..GetTemplateRecord(objTem.TemplateCategory)
			continue:(strTemCId="")
			s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)			
			s objDocCTem = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
			//指定病历实例是否有对应患者签名后的PDF文档
			s pdfStatus = ##Class(EMR.DOC.BL.PDFAuditSignLog).GetPDFStatus(docID, dtoItem.EpisodeID)
			s objJson = ##class(%DynamicObject).%New()
			s objJson.id = objDocument.%Id()
			s objJson.name = objDocument.DOCName
			s objJson.text = objDocument.DOCName
			s objJson.emrDocId = objDocument.DOCCode
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

/// Desc:       获取业务活动记录类型文档目录
/// Creator:    yejian
/// CreateDate: 2022-4-19
/// Input:      objCategory 模板目录对象
/// Output:    成功 目录ID，失败 "-1"
/// 	Debug:	q ##Class(EMR.OP.BL.TemplateCategory).GetTemplateRecord()
ClassMethod GetTemplateRecord(objCategory As CF.EMR.DOC.TemplateCategory) As %String
{
	s res = "-1"
	q:(objCategory="") res
	q:(objCategory.StructType.Code ="Record") objCategory.%Id()
	if (objCategory.ParentID'="")
	{
		s objPCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objCategory.ParentID)
		s res= ..GetTemplateRecord(objPCategory)
	}
	q res
}

}
