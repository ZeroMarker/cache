/// 名称:EMR.DOC.BL.LocTemplateVersion
/// 描述:科室文档管理模块 Document(Doc) 公用程序层 LocTemplateVersion维护业务类
/// 产品组：电子病历产品组
Class EMR.DOC.BL.LocTemplateVersion Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-23
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod GetTemplateVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID= ..GetIDByKey(argInJson.params.id)
	
	s res=##class(EMR.DOC.BL.LocTemplateVersion).getVersionsByID(ID,.argOutData)
	
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

/// Desc:       删除文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DEL_TEMPLATE_VERSION","params":{"id":"14"},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod DeleteLocTemplateVersion(id As %String)
{
	s strRes="-100"
	q:(id="") strRes
	s strRes="-200"
	s objVersion=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(id)
	q:(objVersion="") strRes
	s strRes="-302"
	q:(objVersion.Status=2) strRes
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(objVersion.Template.%Id())
	
	s objTem.TempLastVersion=objTem.TempLastVersion-1
	
	if '(objTem.%Save())
	{
		TROLLBACK
		q "-303"
	}
	if '(objVersion.%DeleteId(id))
	{
	    TROLLBACK
 	    q "-300"
 	}
 	// 删除对应章节
 	q "1"
}

/// Desc:       获取文档版本数据
/// Creator:    yejian
/// CreateDate: 2020-12-23
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod GetTemplateVersionData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID= ..GetIDByKey(argInJson.params.versionId)
	
	s res=##class(EMR.DOC.BL.LocTemplateVersion).getVersionsByVersionId(ID,.argOutData)
	
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
ClassMethod getVersionsByVersionId(versionID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(versionID="") "-100"
	s objVersion=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(versionID)
	q:(objVersion="") "-200"
	s versionNumber=objVersion.TepmplateVersionNumber
	s templateID=objVersion.Template.%Id()
	
	s jsonArr=##class(%DynamicArray).%New()
	s rowID=""
	for
	{
		s rowID = $o(^CF.EMR.DOC.LocTemplateSectionI("IdxCode",templateID,rowID))
		q:(rowID="")
		
		s jsonItem = ##class(%DynamicObject).%New()
     	
     	s objSection=##class(CF.EMR.DOC.LocTemplateSection).%OpenId(rowID)
     	continue:(objSection.VersionNumber'=versionNumber)
     	s jsonItem.code=objSection.SectionCode
		d objSection.DocumentData.Rewind()
		while (objSection.DocumentData.AtEnd = 0)
		{
		s tmpOut = objSection.DocumentData.Read(32000)
		// 转换为json对象
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		s objJson = ##class(%DynamicAbstractObject).%FromJSON(tmpUtf8)
		
		
		
		s jsonItem.document=objJson

  		} 
  		s jsonItem.id=rowID
		

     	d jsonArr.%Push(jsonItem)
			
	}
	

	d jsonArr.%ToJSON(argOutData)
	q "1"
}

/// Desc:       获取文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod getVersionsByID(templateID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(templateID="") "-100"
	s objTem=##class(CF.EMR.DOC.LocTemplate).%OpenId(templateID)
	q:(objTem="") "-200"
	
	s jsonArr=##class(%DynamicArray).%New()
	s maxVersion=""
	&sql(select max(TepmplateVersionNumber) into :maxVersion from CF_EMR_DOC.LocTemplateVersion where Template =:templateID)
	
	for i=1:1:maxVersion
	{
		s rowID=""
		&sql(select ID into :rowID from CF_EMR_DOC.LocTemplateVersion where Template =:templateID and TepmplateVersionNumber = :i)
		s jsonItem = ##class(%DynamicObject).%New()
		s jsonItem.id =rowID
		s jsonItem.key=rowID_"||IT"
		s jsonItem.parentTitle=objTem.Name
		s jsonItem.parentType="IT"
		s jsonItem.version="V"_i_".0 "
		s objItem=##class(CF.EMR.DOC.LocTemplateVersion).%OpenId(rowID)
		s jsonItem.status=objItem.Status
		s jsonItem.title="V"_i_".0 "_$ZD(objItem.EffectiveDate,3)
		s jsonItem.template=objTem.TemplateID.%Id()_"||DT"
		d jsonArr.%Push(jsonItem)
	}
	d jsonArr.%ToJSON(argOutData)
	q "1"
}

/// Desc:       添加文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod AddTemplateVersionJson(templateID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(templateID="") "-201"
	s NewMaxVersion = ""
	&sql(SELECT MAX(TepmplateVersionNumber) into :NewMaxVersion  FROM CF_EMR_DOC.LocTemplateVersion WHERE Template = :templateID)
	s objVersion = ##class(CF.EMR.DOC.LocTemplateVersion).%New()
	if (NewMaxVersion= "")
	{
		s objVersion.TepmplateVersionNumber = 1
	} 
	elseif '(NewMaxVersion="")
	{
		s objVersion.TepmplateVersionNumber =NewMaxVersion + 1
	} 
	s objTemplate=##class(CF.EMR.DOC.LocTemplate).%OpenId(templateID)
	s objVersion.Template=objTemplate
	s objVersion.Status = 0
	s objVersion.EffectiveDate=$ZDATEH($ZDATE($h))
	s objVersion.EffectiveTime=$ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s objTemplate.TempLastVersion = objTemplate.TempLastVersion+1
	s strRes="-103"
	if '(objTemplate.%Save())
	{
		q strRes
	}
	if '(objVersion.%Save())
	{
		q strRes
	}
	
	s objLoc=##class(%DynamicObject).%New()
	s objLoc.id=objVersion.%Id()
	s objLoc.key=objVersion.%Id()_"||IT"
	s objLoc.status="0"
	s objLoc.type="IT"
	s objLoc.parentType="IT"
	s objLoc.locTemplateId=objVersion.Template.%Id()_"||IT"
	s objLoc.parentTitle=objTemplate.Name
	s objLoc.version="V"_objVersion.TepmplateVersionNumber_".0"
	s objLoc.template=objTemplate.TemplateID.%Id()_"||DT"
	d objLoc.%ToJSON(.argOutData)
	q "1"
}

/// Desc:       新增科室文档版本
/// Creator:    huhao
/// CreateDate: 2022-8-11
/// output:     
/// Debug:      
ClassMethod AddLocTemplateVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID= ..GetIDByKey(argInJson.params.id)
	
	s res=##class(EMR.DOC.BL.LocTemplateVersion).AddLocVersion(ID,.argInData,.argOutData)
	
	if (res="1"){
	    q argOutMessage
	}
	elseif (res = "-100")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","有必填项为空",2)
	}
	elseif(strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	elseif (res = "-200")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","文档ID不存在",2)
	}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       新增科室文档版本
/// Creator:    huhao
/// CreateDate: 2022-8-11
/// Input:      
/// output:     
/// Debug:     
ClassMethod AddLocVersion(Id As %String, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:Id="" "-1^科室文档Id不能为空"
	s count=""
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.LocTemplateVersion WHERE template = :Id AND Status!=2)
	q:count'="0" "-1^当前科室文档有未发布版本"
	TSTART
	s locVersionObj=##class(CF.EMR.DOC.LocTemplateVersion).%New()
	
	//新增一条科室版本记录
	s locTempObj=##class(CF.EMR.DOC.LocTemplate).%OpenId(Id)
	if (locTempObj="")
	{
		TROLLBACK
		q "-1^科室文档不存在"
	}
	s locVersionObj.EffectiveDate=$ZDATEH($ZDATE($h))
	s locVersionObj.EffectiveTime=$ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s locVersionObj.Status=0
	s locVersionObj.Template=##class(CF.EMR.DOC.LocTemplate).%OpenId(Id)
	s versionnumber=""
	&sql(SELECT Max(TepmplateVersionNumber) into :versionnumber FROM CF_EMR_DOC.LocTemplateVersion WHERE template = :Id)
	s addVersionNum=versionnumber+1
	s locVersionObj.TepmplateVersionNumber=addVersionNum
	if '(locVersionObj.%Save())
	{
		TROLLBACK
		q "-1^科室文档版本保存失败"
	}
	s locTempObj.TempLastVersion=locVersionObj.TepmplateVersionNumber
	if '(locTempObj.%Save())
	{
		TROLLBACK
		q "-1^科室文档保存失败"
	}
	
	//返回版本数据
	s resObj=##class(%DynamicObject).%New()
	s resObj.id=locVersionObj.%Id()
	s resObj.key=locVersionObj.%Id()_"||IT"
	s resObj.locTemplateId=locVersionObj.Template.%Id()_"||IT"
	s resObj.status="0"
	s resObj.type="IT"
	s resObj.parentType="IT"
	s resObj.parentTitle=locTempObj.Name
	s resObj.version="V"_locVersionObj.TepmplateVersionNumber_".0"
	s resObj.template=locTempObj.TemplateID.%Id()_"||DT"
	
	
	//新增科室章节记录
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
	while iter.%GetNext(.key,.val)
	{
		s str=val.%ToJSON()
		s stream=##class(%GlobalBinaryStream).%New()
			
		d stream.Write(str)
		// 修改章节
		s code=val.code
		s objNewSection=##class(CF.EMR.DOC.LocTemplateSection).%New()
		if (stream.IsNull()'=1)
		{
			d objNewSection.DocumentData.CopyFrom(stream)
		}
		s objNewSection.SectionCode=code
		s objNewSection.Template=##class(CF.EMR.DOC.LocTemplate).%OpenId(Id)
		s objNewSection.VersionNumber=addVersionNum
		d objNewSection.%Save()		
	}
	TCOMMIT
	d resObj.%ToJSON(.argOutData)
	q "1"
}

}
