/// 名称:EMR.DOC.BL.LocTemplateSection
/// 描述:科室文档章节管理模块 业务逻辑
/// 编写者：ningyanghong
/// 编写日期: 2020-12-23
/// 产品组：电子病历产品组
Class EMR.DOC.BL.LocTemplateSection Extends EMR.DOC.COM.ActionBase
{

/// Desc:       保存文档章节
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"SAVE_TEMPLATE_SECTION","params":{"id":"文档ID"//固定值"userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod SaveTemplateSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID= ..GetIDByKey(argInJson.params.id)
	s res=##class(EMR.DOC.BL.LocTemplateSection).saveSection(ID,.argInData)
	
	
	if (res="1"){
	    q argOutMessage
	}
	elseif (res = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	elseif (res = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","版本不存在",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取文档最新版本的章节
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"GET_TEMPLATE_SECTION","params":{"templateId":"文档ID"//固定值"userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod GetTemplateSection(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID= ..GetIDByKey(argInJson.params.templateId)
	
	s res=##class(EMR.DOC.BL.LocTemplateSection).getSectionByID(ID,.argOutData)
	
	if (res="1"){
	    q argOutMessage
	}
	elseif (res = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	elseif (res = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","文档ID不存在",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       保存文档章节
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod saveSection(templateID As %String, argInData As %GlobalBinaryStream) As %String
{
	q:(templateID="") "-100"
	s objVersion=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(templateID)
	s temId=objVersion.Template.%Id()
	s version=objVersion.TepmplateVersionNumber
	q:(objVersion="") "-200"
	
	s totalLen=argInData.Size
	s begLocation = 0
	s endLocation=totalLen
	
	d argInData.MoveTo(begLocation)
	s splitStr=""
	
	if (totalLen > 32000) 
	{
		s count = totalLen\32000
		for i=1:1:count
		{	
			s splitStr=splitStr_argInData.Read(32000)
		}
		s lastLen = totalLen - (count*32000)
		s splitStr=splitStr_argInData.Read(lastLen)
	}
	else
	{
		s splitStr = argInData.Read(totalLen)
	}
	
	s strJson = $zcvt(splitStr,"I","UTF8") 
	
	set arrJson = ##class(%DynamicArray).%FromJSON(strJson)
	s iter=arrJson.%GetIterator()
	&sql(delete from CF_EMR_DOC.LocTemplateSection where  VersionNumber = :version and Template = :temId)
	while iter.%GetNext(.key,.val)
	{
		s str=val.%ToJSON()
		s stream=##class(%GlobalBinaryStream).%New()
			
		d stream.Write(str)
		s code=val.attrs.code
	
		// 新增
		
			s objNewSection=##class(CF.EMR.DOC.LocTemplateSection).%New()
			if (stream.IsNull()'=1)
			{
				d objNewSection.DocumentData.CopyFrom(stream)
			}
			s objNewSection.SectionCode=code
			s objNewSection.Template=objVersion.Template
			s objNewSection.VersionNumber=version
			d objNewSection.%Save()
		
		
	}
	q "1"
}

/// Desc:       获取文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod getSectionByID(templateID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(templateID="") "-100"
	s objVersion=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(templateID)
	q:(objVersion="") "-200"
	s versionNumber=objVersion.TepmplateVersionNumber
	
	
	s jsonArr=##class(%DynamicArray).%New()
	
	s rowID=""
	for
	{
		s rowID = $o(^CF.EMR.DOC.LocTemplateSectionI("IdxCode",objVersion.Template.%Id(),rowID))
		q:(rowID="")
		
		s jsonItem = ##class(%DynamicObject).%New()
     	s objSection=##class(CF.EMR.DOC.LocTemplateSection).%OpenId(rowID)
     	continue:(objSection.VersionNumber'=versionNumber)
		d objSection.DocumentData.Rewind()
		while (objSection.DocumentData.AtEnd = 0)
		{
			s tmpOut = objSection.DocumentData.Read(32000)
		    // 转换为json对象
			;s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
			s objJson = ##class(%DynamicAbstractObject).%FromJSON(tmpOut)
			s jsonItem.document=objJson
  		} 
  		s jsonItem.id=rowID
  		s jsonItem.code=objSection.SectionCode
     	d jsonArr.%Push(jsonItem)
			
	}
	

	d jsonArr.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取文档id最新版本的章节
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"GET_TEMPLATE_SECTION","params":{"id":"文档ID"//固定值"userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetSectionData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID= ..GetIDByKey(argInJson.params.id)
	
	s res=##class(EMR.DOC.BL.LocTemplateSection).getSectionByDocID(ID,.argOutData)
	
	if (res="1"){
	    q argOutMessage
	}
	elseif (res = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	
	elseif (res = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","文档ID不存在",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod getSectionByDocID(templateID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(templateID="") "-100"
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(templateID)
	q:(objTem="") "-200"
	
	s jsonArr=##class(%DynamicArray).%New()
	// 最新versionnumber
	s lastVersionNumber=objTem.TempPublishVersion
	q:lastVersionNumber="" "1"
	s objLocVer = ##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(lastVersionNumber)
	q:objLocVer="" "1"
	s rowID=""
	for
	{
		s rowID = $o(^CF.EMR.DOC.LocTemplateSectionI("IdxCode",templateID,rowID))
		q:(rowID="")
		s jsonItem = ##class(%DynamicObject).%New()
     	
     	s objSection=##class(CF.EMR.DOC.LocTemplateSection).%OpenId(rowID)
     	continue:(objSection.VersionNumber'=objLocVer.TepmplateVersionNumber)
     	s jsonItem.sectionCode=objSection.SectionCode
		d objSection.DocumentData.Rewind()
		while (objSection.DocumentData.AtEnd = 0)
		{
			s tmpOut = objSection.DocumentData.Read(30000)
			s objJson = ##class(%DynamicAbstractObject).%FromJSON(tmpOut)
			s jsonItem.document=objJson
  		} 
  		s jsonItem.id=rowID
     	d jsonArr.%Push(jsonItem)
	}
	d jsonArr.%ToJSON(argOutData)
	q "1"
}

/// Desc:       医生端获取科室模板章节打散数据
/// Creator:    yejian
/// CreateDate: 2022-11-22
/// Table:		CF.EMR.DOC.LocTemplate 科室模板表，CF.EMR.DOC.LocTemplateSection 科室模板章节打散表
/// Input:      argInJson  命令参数 {"action":"LOAD_LOCTEMPLATE","params":{"id":"55"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadLocTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s id = argInJson.params.id
    s strRes = ##Class(EMR.DOC.BL.LocTemplateSection).LoadLocTemplateJson(id,.argOutData)
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

/// Desc:       医生端获取科室模板章节打散数据
/// Creator:    yejian
/// CreateDate: 2022-11-22
/// Input:      aLocTemID 科室模板ID
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.LocTemplateSection).LoadLocTemplateJson("55",.argOutData)
ClassMethod LoadLocTemplateJson(aLocTemID As EMR.DOC.DTO.DocumentData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1"
	q:(aLocTemID="") "-1^科室模板ID不能为空"
	
	s objLocTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(aLocTemID)
	q:(objLocTem="") "-1^科室模板ID获取科室模板失败"
	s jsonArr=##class(%DynamicArray).%New()
	s TempPublishVersion=objLocTem.TempPublishVersion
	q:TempPublishVersion="" "-1^科室模板未发布"
	s objLocVer = ##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(TempPublishVersion)
	q:objLocVer="" "-1^科室模板获取发布版本失败"
	s rowID=""
	try
	{
		for
		{
			s rowID = $o(^CF.EMR.DOC.LocTemplateSectionI("IdxCode",aLocTemID,rowID))
			q:(rowID="")
	     	s objSection=##class(CF.EMR.DOC.LocTemplateSection).%OpenId(rowID)
	     	continue:(objSection.VersionNumber'=objLocVer.TepmplateVersionNumber)
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
    q "-1^"_aLocTemID_","_$zerror
}

}
