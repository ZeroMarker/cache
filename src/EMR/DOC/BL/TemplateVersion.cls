/// 名称:EMR.DOC.BL.TemplateVersion
/// 描述:通用文档管理模块 Document(Doc) 文档模板版本管理业务逻辑
/// 编写者：yejian
/// 编写日期: 2020-12-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.TemplateVersion Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取文档版本信息
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"GET_TEMPLATE_VERSIONS","params":{"id":"文档ID"//固定值"userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetTemplateVersions(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s templateID=..GetIDByKey(argInJson.params.id)
	
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).GetTemplateVersionsJson(templateID,.argOutData)
    
	if (strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       添加文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"ADD_TEMPLATE_VERSION","params":{"templateId":"文档ID","HFFormat":2,//固定值"userCode":"YS01","operateMachineIP":"127.0.0.1","remark":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod AddTemplateVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTOVersion = ##class(EMR.DOC.DTO.TemplateVersion).%New()
	s argDTOVersion.Template = ..GetIDByKey(argInJson.params.id)
	s argDTOVersion.HFVersion = argInJson.params.HFFormat
	// 如果没有数据
	if (argInData.IsNull()'=1){
		d argDTOVersion.DocumentData.CopyFrom(argInData)
	}
	s argDTOMLog = ##class(EMR.DOC.DTO.TemplateStatusMLog).%New()
	s argDTOMLog.CreateID = argInJson.params.userCode
	s argDTOMLog.ModifyID = argInJson.params.userCode
	s argDTOMLog.OperateMachineIP = argInJson.params.IP
	s argDTOMLog.Remark = argInJson.params.remark
	
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersionJson(argDTOVersion,argDTOMLog,.argOutData)
	if (strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       删除文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  	命令参数 {"action":"DEL_TEMPLATE_VERSION","params":{"id":"14"},"product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod DelTemplateVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s strID = ..GetIDByKey(argInJson.params.id)
	s argDTOMLog = ##Class(EMR.DOC.BL.TemplateStatusMLog).GetMaxLog(strID)
	s argDTOMLog.ModifyID = argInJson.params.userCode
	s argDTOMLog.Status = "-1"
	s argDTOMLog.OperateMachineIP = argInJson.params.IP
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).DelTemplateVersionJson(strID,argDTOMLog)
    if (strRes="1")
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
		q ..SetOutMessage(argOutMessage,"ERROR","操作数据记录出错",2)
	}	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       保存文档
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数  {"action":"SAVE_TEMPLATEVERSION","params":{"templateVersionId":"1","status":"1","userCode":"YS01","operateMachineIP":"127.0.0.1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveTemplateVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
    s objDTO  = ##class(EMR.DOC.DTO.TemplateVersion).%New()

	s TemplateVersionID = ..GetIDByKey(argInJson.params.id)
	s objDTO.ID = TemplateVersionID
	s objDTO.Status = "1"
	d objDTO.DocumentData.CopyFrom(argInData)
	s argDTOMLog = ##Class(EMR.DOC.BL.TemplateStatusMLog).GetMaxLog(TemplateVersionID)
	s argDTOMLog.ModifyID = argInJson.params.userCode
	s argDTOMLog.Status = "1"
	s argDTOMLog.OperateMachineIP = argInJson.params.IP
	s argDTOMLog.Remark = argInJson.params.remark
	
  	s strRes = ##Class(EMR.DOC.BL.TemplateVersion).SaveTemplateVersionJson(objDTO,argDTOMLog)
	
	if (strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       根据文档ID加载最新模板
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"LOAD_TEMPLATE","params":{"templateVersionId":"12"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s TemplateID = ..GetIDByKey(argInJson.params.templateId)
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).LoadTemlateVersionData(TemplateID,.argOutData)
	if (strRes = "1")
	{ 
	 	q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	   d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR","请传入文档ID",2)
	}
	elseif(strRes="-301")
	{
		d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR","文档对象不存在，检查参数",2)	
	}
	elseif(strRes="-302")
	{
		d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR","版本对象不存在，检查参数",2)	
	}
	else
	{
		d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据版本ID加载模板
/// Creator:    ningyanghong
/// CreateDate: 2021-12-15
/// Input:      argArray  命令参数 {"action":"LOAD_TEMPLATE_VERSION","params":{"id":"12||IT"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadTemplateVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s temID = ..GetIDByKey(argInJson.params.id)
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).LoadTemlateByVersionID(temID,.argOutData)
	if (strRes = "1")
	{ 
	 	q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	   d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR","请传入文档ID",2)
	}
	elseif(strRes="-301")
	{
		d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR","文档对象不存在，检查参数",2)	
	}
	else
	{
		d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       发布版本
/// Creator:    duan
/// CreateDate: 2021-03-22
/// Input:      argArray  命令参数 {"params":{"action":"PUBLISH_DOCUMENT_VERSION","args":{"id":"2"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod PublishVersion(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ID =..GetIDByKey(argInJson.params.id)
	s status = "2"
	s argDTOMLog = ##Class(EMR.DOC.BL.TemplateStatusMLog).GetMaxLog(ID)
	s argDTOMLog.ModifyID = argInJson.params.userCode
	s argDTOMLog.Status = status
	s argDTOMLog.OperateMachineIP = argInJson.params.IP
	s argDTOMLog.Remark = argInJson.params.remark
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).SetPublishVersion(ID,argDTOMLog)
	if (strRes="1")
	{
		q argOutMessage.success = ..#OK
	}
	elseif (strRes = "-201")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","参数id必传",2)
	}
	elseif (strRes = "-301")
	{ 
		q ..SetOutMessage(argOutMessage,"ERROR","数据记录不存在，检查id",2)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       根据模板ID获取最新发布版本
/// Creator:    yejian
/// CreateDate: 2021-1-20
/// Input:      argArray  命令参数 {"params":{"action":"LOAD_TEMPLATEBYTID","args":{"templateID":"1"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadTemplateByTID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s TemplateID = ..GetIDByKey(argInJson.params.templateID)
    s status ="" 
    s strRes = ##Class(EMR.DOC.BL.TemplateVersion).LoadTemlateVersionDataByTID(TemplateID,.argOutData)
	if (strRes = "-1")
	{ 
		d argOutData.Write(..#NONE)
		q ..SetOutMessage(argOutMessage,"ERROR")
	}
	elseif (strRes = "0")
	{ 
		d argOutData.Write(..#NONE)
		q argOutMessage.success = ..#OK
	}
	else
	{  
	    q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取模板数据
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aTempalteId 目录ID
///             jsonCategory 目录json对象
/// Output:     q ##Class(EMR.DOC.BL.Template).GetJsonTempalteByCID(0,1,1,)
ClassMethod GetJsonTemVersionByTID(aTempalteId As %String, ByRef jsonCategory As %DynamicArray, aProductId As %String) As %String
{
	s res = "1"
	s rowTemVNum = ""
	for {
		s rowTemVNum = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",aTempalteId,rowTemVNum))
		q:(rowTemVNum = "")	
		s rowVerID = ""
		for {
			s rowVerID = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",aTempalteId,rowTemVNum,rowVerID))
			q:(rowVerID = "")						
			s objVersion = ##Class(CF.EMR.DOC.TemplateVersion).%OpenId(rowVerID)
		    continue:(objVersion="")
		    s rowVerStatusID = $o(^CF.EMR.DOC.TemplateStatusMLogI("IdxTemplateVersion",rowVerID,""))
		    continue:(rowVerStatusID="")
		    s objVersionStatus = ##Class(CF.EMR.DOC.TemplateStatusMLog).%OpenId(rowVerStatusID)
		    s jsonVersion  = ##class(%DynamicObject).%New()
		    s productObj = ##class(CT.EMR.DOC.Products).%OpenId(aProductId)
		    s jsonVersion.key = rowVerID_"||DT"
		    s jsonVersion.title = "V"_objVersion.TepmplateVersionNumber_".0 "_$ZD(objVersionStatus.CreateDate,3)
		    s jsonVersion.type = "DT"
		    s jsonVersion.templateVersionNumber = objVersion.TepmplateVersionNumber
		    s jsonVersion.remark = objVersionStatus.Remark
		    s jsonVersion.createUser = objVersionStatus.CreateID 
		    s jsonVersion.status = objVersion.Status_""
		    continue:(jsonVersion.status="-1")
		    s jsonVersion.createName =  ##class(EMR.DOC.HISInterface.PatientInfoAssist).GetUserNameByCode(objVersionStatus.CreateID)
		    s jsonVersion.permission = 2
		    s jsonVersion.createDate = $ZD(objVersionStatus.CreateDate,3)
		    s jsonVersion.modifyDate = $ZD(objVersionStatus.ModifyDate,3)
		    
			d jsonCategory.%Push(jsonVersion)	
		}
	}
	q res
}

/// Desc:       获取文档版本信息
/// Creator:    ningyanghong
/// CreateDate: 2021-12-14
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion)GetTemplateVersionsJson()
ClassMethod GetTemplateVersionsJson(template As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="-1^文档ID未传"
	q:(template="") strRes
	
	s objTemplate=##class(CF.EMR.DOC.Template).%OpenId(template)
	q:(objTemplate="") "-1^文档ID不存在"
	
	// 获取文档的所有版本信息
	
	s jsonArr = ##class(%DynamicArray).%New()
	
	s maxVersion=""
	&sql(select max(TepmplateVersionNumber) into :maxVersion from CF_EMR_DOC.TemplateVersion where Template =:template)
	
	for i=1:1:maxVersion
	{
		s rowID=""
		&sql(select ID into :rowID from CF_EMR_DOC.TemplateVersion where Template =:template and TepmplateVersionNumber = :i)
		s jsonItem = ##class(%DynamicObject).%New()
		s jsonItem.id =rowID
		s jsonItem.key=rowID_"||IT"
		s jsonItem.parentTitle=objTemplate.Name
		s jsonItem.parentType="DT"
		s jsonItem.version="V"_i_".0 "
		s objItem=##class(CF.EMR.DOC.TemplateVersion).%OpenId(rowID)
		continue:objItem=""
		s jsonItem.status=objItem.Status
		s jsonItem.InstanceData=##class(EMR.DOC.BL.Template).GetInitData(i,template)
		s jsonItem.title="V"_i_".0 "_$ZD(objItem.EffectiveDate,3)
		d jsonArr.%Push(jsonItem)
	}
	
				
	d jsonArr.%ToJSON(argOutData)
	q 1
}

/// Desc:       根据模板ID获取模板数据
/// Creator:    ningyanghong
/// CreateDate: 2021-12-15
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion)GetTemplateVersionsJson()
ClassMethod LoadTemlateByVersionID(aTemplateID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes="-200"
	q:(aTemplateID="") strRes
	s strRes="-301"
	
	;s objTemplate=##class(CF.EMR.DOC.Template).%OpenId(aTemplateID)
	;q:(objTemplate="") strRes
	;s lastVersion=objTemplate.TempLastVersion
	s maxID=""
	&sql(select max(ID) into :maxID from CF_EMR_DOC.TemplateVersion where Template = :aTemplateID  and Status=2)
	q:(maxID="") "1"

	s orRefTempVer  = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(maxID)
	
	q:(orRefTempVer="") strRes
	
 	d orRefTempVer.DocumentData.Rewind()
	while (orRefTempVer.DocumentData.AtEnd = 0)
	{
		s tmpOut = orRefTempVer.DocumentData.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d argOutData.Write(tmpUtf8)
  	} 
	
	q "1"
}

/// Desc:       添加文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      AVersion 文档版本对象
/// output:     
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod AddTemplateVersionJson(AVersion As EMR.DOC.DTO.TemplateVersion, AMLog As EMR.DOC.DTO.TemplateStatusMLog, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1^必须关联文档ID"
	q:((AVersion="")||(AVersion.Template="")) strRes
	s strRes= "-1^必须关联文档版式"
	q:(AVersion.HFVersion="") strRes
	s strRes = "-1^文档下有未发布的版本，不允许新建"
	s NewMaxVersion = ""
	s strTemplateID = AVersion.Template
	/*文档下有未发布的版本（0：新建，1：保存）的版本时，不允许新建版本*/
	s count=0
	&sql(SELECT count(*) into :count FROM CF_EMR_DOC.TemplateVersion WHERE Template = :strTemplateID and (Status != "2"))
 	q:(count>0) strRes
 	&sql(SELECT MAX(TepmplateVersionNumber) into :NewMaxVersion  FROM CF_EMR_DOC.TemplateVersion WHERE Template = :strTemplateID)
	
	TSTART
	s objVersion = ##class(CF.EMR.DOC.TemplateVersion).%New()
	
	s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(strTemplateID)
	if (objTemplate ="")
	{
		TROLLBACK
		q "-1^文档记录不存在，新建失败"
	}
	s objVersion.Template =objTemplate
	//版式最新发布的版本
	if (AVersion.HFVersion'="")
	{
		s strPublishID = ""
		s strHFVersionID =$p(AVersion.HFVersion,"||",1)  
		&sql(SELECT MAX(ID) into :strPublishID  FROM CF_EMR_DOC.HFFormatVersion WHERE HFFormat = :strHFVersionID and Status="2")
		if (strPublishID ="")
		{
			TROLLBACK
			q "-1^版式没有已发布的版本，新建失败"
		}
		s objPublishVersion = ##class(CF.EMR.DOC.HFFormatVersion).%OpenId(strPublishID)
		if (objPublishVersion ="")
		{
			TROLLBACK
			q "-1^版式版本数据记录不存在，新建失败"
		}
		s objVersion.HFVersion = objPublishVersion
	}
	if (NewMaxVersion= "")
	{
		s objVersion.TepmplateVersionNumber = 1
	} 
	elseif '(NewMaxVersion="")
	{
		s objVersion.TepmplateVersionNumber =NewMaxVersion + 1
	} 	
	s objVersion.Status = 0
	s objVersion.EffectiveDate=$ZDATEH($ZDATE($h))
	s objVersion.EffectiveTime=$ZTIMEH($ZTIME($PIECE($h,",",2),1))
	//d objVersion.DocumentData.CopyFrom(AVersion.DocumentData)
	//更新模板最新版本号
	s objTemplate.TempLastVersion = objTemplate.TempLastVersion + 1
	if (AVersion.DocumentData.IsNull()'=1){
		d objVersion.DocumentData.CopyFrom(AVersion.DocumentData)	
	}
	s strRes="-1^操作数据出错"
	if '(objTemplate.%Save())
	{
		TROLLBACK
		q strRes
	}
	if '(objVersion.%Save())
	{
	 	TROLLBACK 
		q strRes
	}
	
	s AMLog.TemplateVersion = objVersion.%Id()
	s AMLog.Status = objVersion.Status
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	
	s strMRes = ##Class(EMR.DOC.BL.TemplateStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-1^添加日志出错，新建失败"
	}
	if (objTemplate.TempPublishVersion'="")
	{
		//继承模板待签数据方法
		s addTpmSignId=""
		s latestVersionNum=""
		&sql(select TempPublishVersion into :latestVersionNum from CF_EMR_DOC.Template where ID=:strTemplateID)
		for
		{
			s addTpmSignId=$o(^CF.EMR.DOC.TemplateSignI("IndexTIDVersion",strTemplateID,latestVersionNum,addTpmSignId))
			q:addTpmSignId=""
			s latestTpmSignObj=##class(CF.EMR.DOC.TemplateSign).%OpenId(addTpmSignId)
			s TpmSignObj=##class(CF.EMR.DOC.TemplateSign).%New()
			s TpmSignObj.DOCCode=latestTpmSignObj.DOCCode
			s TpmSignObj.DOCName=latestTpmSignObj.DOCName
			s TpmSignObj.HasSign=latestTpmSignObj.HasSign
			s TpmSignObj.HasSignLevel=latestTpmSignObj.HasSignLevel
			s TpmSignObj.SignCode=latestTpmSignObj.SignCode
			s TpmSignObj.SignRole=latestTpmSignObj.SignRole
			s TpmSignObj.TemplateID=latestTpmSignObj.TemplateID
			s TpmSignObj.TemplateVersion=objVersion
			s sc=TpmSignObj.%Save()
			if ($$$ISOK(sc))
			{
				s tmpSignRId=""
				for
				{
					s tmpSignRId=$o(^CF.EMR.DOC.TemplateSignSRTI("IndexSignUnit",addTpmSignId,tmpSignRId))
					q:tmpSignRId=""
					s tmpSignRuleObj=##class(CF.EMR.DOC.TemplateSignRuleSet).%OpenId(tmpSignRId)
					s addTmpSignRuleObj=##class(CF.EMR.DOC.TemplateSignRuleSet).%New()
					s addTmpSignRuleObj.IsForce=tmpSignRuleObj.IsForce
					s addTmpSignRuleObj.RoleLevel=tmpSignRuleObj.RoleLevel
					s addTmpSignRuleObj.RoleRuleCode=tmpSignRuleObj.RoleRuleCode
					s addTmpSignRuleObj.SignCode=tmpSignRuleObj.SignCode
					s addTmpSignRuleObj.SignRole=tmpSignRuleObj.SignRole
					s addTmpSignRuleObj.SignType=tmpSignRuleObj.SignType
					s addTmpSignRuleObj.SignUnit=TpmSignObj
					s se=addTmpSignRuleObj.%Save()
					if ($$$ISOK(se))
					{
						continue
					}
					else
					{
						TROLLBACK
						q
					}
				}
			}
			else
			{
				TROLLBACK
				q
			}
			
		}
		
		//继承患者待签数据方法
		s patId=""
		for
		{
			s patId=$o(^CF.EMR.DOC.PatSignOrderI("idxMain",strTemplateID,latestVersionNum,patId))
			q:patId=""
			s patObj=##class(CF.EMR.DOC.PatSignOrder).%OpenId(patId)
			s addPatObj=##class(CF.EMR.DOC.PatSignOrder).%New()
			s addPatObj.SignData=patObj.SignData
			s addPatObj.Template=patObj.Template
			s addPatObj.TemplateVersion=objVersion
			s sw=addPatObj.%Save()
			if ($$$ISOK(sw))
			{
				continue
			}
			else
			{
				TROLLBACK
				q
			}
		}
	}
	TCOMMIT
	s obj=##class(%DynamicObject).%New()
	s obj.key=objVersion.%Id()_"||IT"
	s obj.id=objVersion.%Id()
	s obj.status="0"
	s obj.type="IT"
	s obj.parentType="DT"
	s obj.parentTitle=objTemplate.Name
	s obj.templateId=objVersion.Template.%Id()_"||DT"
	s obj.version="V"_objVersion.TepmplateVersionNumber_".0"

	d obj.%ToJSON(.argOutData)
	s strRes = objVersion.%Id()
	q strRes
}

/// Creator：      yejian
/// CreatDate：    2021-1-11
/// Description:   Template 修改
/// Table：        CF_EMR_DOC.TemplateVersion
/// Input：        objVersion 版本对象，AMLog 状态对象
/// Output         成功：1 失败： -101 操作数据失败 -102 保存日志失败
/// 								  -200 版本ID未传
/// Return：       函数返回值的说明
/// Others：       
/// Debug:         w ##Class(EMR.DOC.COM.TemplateVersion).Update()
ClassMethod SaveTemplateVersionJson(objVersion As EMR.DOC.DTO.TemplateVersion, AMLog As EMR.DOC.DTO.TemplateStatusMLog) As %String
{
	
	//^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion"," EMR090001",1,1)
	TSTART
	s strRes = "-1"
	if (objVersion.ID="")
	{
		TROLLBACK
		q "-1^版本ID未传"	
	}

	s obj = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(objVersion.ID)
	;s obj.EffectiveDate = objVersion.EffectiveDate
	;s obj.EffectiveTime = objVersion.EffectiveTime
	;s obj.HFVersion = objVersion.HFVersion
	q:obj.Status="2" "-1^文档下有未发布的版本，不允许新建"
	s obj.Status = objVersion.Status  //使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
	
	d obj.DocumentData.Clear()
	d obj.DocumentData.CopyFrom(objVersion.DocumentData)
	
	s sc = obj.%Save()
	if '($$$ISOK(sc))
	{
		TROLLBACK
		q "-1^保存失败"
	}
	
	//需要增加TemplateVersion的状态管理逻辑
	s AMLog.TemplateVersion = objVersion.ID
	s AMLog.Status = objVersion.Status
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))

	s strMRes = ##Class(EMR.DOC.BL.TemplateStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-1^添加日志出错，保存失败"
	}
	TCOMMIT
	s strRes = "1"
	q strRes
}

/// Desc:       删除文档版本
/// Creator:    yejian
/// CreateDate: 2020-12-17
/// Input:      aID 文档版本对象
/// output:     成功：1 失败：-200 未传版本ID
///                           -101 版本已发布，不能删除 -102 操作数据记录错误
/// Debug:      w ##Class(EMR.DOC.BL.TemplateVersion).AddTemplateVersion()
ClassMethod DelTemplateVersionJson(aID As %String, AMLog As EMR.DOC.DTO.TemplateStatusMLog) As %String
{
	s strRes = "-1^版本ID必传"
	q:(aID="") strRes
	TSTART
	s objTemplateVersion = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(aID)
	q:(objTemplateVersion.Status=2) "-1^已发布的版本不允许删除"
	q:(objTemplateVersion.Status=3) "-1^审核状态下不允许删除"
	q:(objTemplateVersion.Status=-1) "-1^该版本已为删除状态"
	s strRes = "-1^添加删除日志失败"
	s strTemplateID = objTemplateVersion.Template.%Id()
	s objTemplate = ##class(CF.EMR.DOC.Template).%OpenId(strTemplateID)

	s objTemplate.TempLastVersion = objTemplateVersion.TepmplateVersionNumber - 1
	if '(objTemplate.%Save())
	{
		TROLLBACK
		q strRes
	} 
	if '(objTemplateVersion.%DeleteId(aID))
	{
	    TROLLBACK
 	    q strRes
 	}
 	//增加删除日志
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))

	s strMRes = ##Class(EMR.DOC.BL.TemplateStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q strRes
	}
	
	s resArr=##class(%DynamicArray).%New()
	s result=##class(%ResultSet).%New("EMR.DOC.BL.TemplateVersion:GetDeleteSignData")
	d result.Execute(aID)
	While result.Next()
	{
		s signId=result.GetDataByName("ID")
		&sql(delete from CF_EMR_DOC.TemplateSign where ID=:signId)
		if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			TROLLBACK
			q 
		}

		&sql(delete from CF_EMR_DOC.TemplateSignRuleSet where SignUnit=:signId)
		if ((SQLCODE'=0)&&(SQLCODE'=100)&&(SQLCODE'=-106)) 
		{
			TROLLBACK
			q 
		}

	}
	
	TCOMMIT
	s strRes= "1"
	q strRes
}

/// Creator：      Guozongtao@mediway.cn
/// CreatDate：    2020-07-14
/// Description:   根据文档模板编码获取文档模板发布版本的数据
/// Table：        CF_EMR_DOC.HeaderAndFooterVersion
/// Input：        argTemplateCode 文档模板编号
/// Output         对输出参数的说明
/// Return：       CF.EMR.DOC.TemplateVersion.DocumentData 
/// Others：       其它说明
/// Debug:         s argOutData = ##Class(%GlobalBinaryStream).%New()
///                w ##class(EMR.DOC.BL.TemplateVersion).LoadLastTemlatePublishVersion(argOutData,"EMR090001")
ClassMethod LoadLastTemlatePublishVersion(argTemplateCode As %String) As %GlobalBinaryStream
{
	///^CF.EMR.DOC.TemplateI("IdxCode"
	s ReturnValue = ##class(%GlobalBinaryStream).%New()
	
	s templateId = ""
	s templateId = $o(^CF.EMR.DOC.TemplateI("IdxCode"," "_argTemplateCode,templateId))
	q:templateId=""
	
	s orRefTemplate = ##class(CF.EMR.DOC.Template).%OpenId(templateId)
	s publishVersion = orRefTemplate.TempPublishVersion
	
	d ReturnValue.CopyFrom(..GetTemlateVersion(argTemplateCode,publishVersion))
	
	q ReturnValue
}

/// Creator：      Guozongtao@mediway.cn
/// CreatDate：    2020-07-14
/// Description:   根据文档模板编码和发布版本号,获取文档模板的数据
/// Table：        CF_EMR_DOC.HeaderAndFooterVersion
/// Input：        argTemplateCode 文档模板编号
///                argVersionNumber 文档模板版本号
/// Output         对输出参数的说明
/// Return：       CF.EMR.DOC.TemplateVersion.DocumentData 
/// Others：       其它说明
/// Debug:         s argOutData = ##Class(%GlobalBinaryStream).%New() 
///                w ##class(EMR.DOC.BL.TemplateVersion).GetTemlateVersion("EMR090001",1)
ClassMethod GetTemlateVersion(argTemplate As %String, argVersionNumber As %String) As %GlobalBinaryStream
{
	//^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion"," EMR090001",1,1)
	s ReturnValue = ##class(%GlobalBinaryStream).%New()
	s templateVerId = ""
	s templateVerId = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",argTemplate,argVersionNumber,templateVerId))
	q:templateVerId=""
	
	s orRefTempVer  = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(templateVerId)
	
	d ReturnValue.CopyFrom(orRefTempVer.DocumentData)
	
	q ReturnValue
}

/// Creator：      Guozongtao@mediway.cn
/// CreatDate：    2020-07-14
/// Description:   根据文档模板编码获取文档模板发布版本的数据
/// Table：        CF_EMR_DOC.HeaderAndFooterVersion
/// Input：        argTemplateCode 文档模板编号
///                argTepmplateVersionNumber  文档模板版本号
/// Output         对输出参数的说明
/// Return：       CF.EMR.DOC.TemplateVersion.DocumentData 
/// Others：       其它说明
/// Debug:         s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			   w ##class(EMR.DOC.BL.TemplateVersion).LoadTemlateVersionData("1","1",argOutData)
ClassMethod LoadTemlateVersionData(aTemplateVID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion"," EMR090001",1,1)
	q:(aTemplateVID="") "-200"
	// 获取最新版本
	s orRefTempVer  = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(aTemplateVID)

	
 	d orRefTempVer.DocumentData.Rewind()
	while (orRefTempVer.DocumentData.AtEnd = 0)
	{
		s tmpOut = orRefTempVer.DocumentData.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d argOutData.Write(tmpUtf8)
  	} 
	s strRes ="1"
	q strRes
}

/// Creator：      yejian
/// CreatDate：    2021-1-20
/// Description:   根据文档模板ID获取文档模板发布版本的数据
/// Input：        aTemplateID 文档模板ID
/// Output         对输出参数的说明
/// Return：       CF.EMR.DOC.TemplateVersion.DocumentData 
/// Others：       其它说明
/// Debug:         s argOutData = ##Class(%GlobalBinaryStream).%New() 
/// 			   w ##class(EMR.DOC.BL.TemplateVersion).LoadTemlateVersionDataByTID("1",argOutData)
ClassMethod LoadTemlateVersionDataByTID(aTemplateID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "-1^获取模板数据失败"
	q:(aTemplateID="") strRes
	s objTempalte = ##class(CF.EMR.DOC.Template).%OpenId(aTemplateID)
	q:((objTempalte="")||(objTempalte.TempPublishVersion="")) strRes
	
	s orRefTempVer  = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(objTempalte.TempPublishVersion)
	q:(orRefTempVer="") strRes
	
 	d orRefTempVer.DocumentData.Rewind()
	while (orRefTempVer.DocumentData.AtEnd = 0)
	{
		s tmpOut = orRefTempVer.DocumentData.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d argOutData.Write(tmpUtf8)
  	} 
	s strRes ="1"
	q strRes
}

/// w ##Class(EMR.DOC.BL.TemplateVersion).Test()
ClassMethod Test() As %String
{
	s ReturnValue = ""
	
	s objDTO  = ##class(EMR.DOC.DTO.TemplateVersion).%New()
	s stream=##class(%FileBinaryStream).%New()
	s stream.Filename="d:\hf.xml"
	s documentxml = ##Class(EMRservice.Parser.StreamData).ParserStream(stream,"<w:document","</w:document>","13")
	
	s objDTO.EffectiveDate = +$h
	s objDTO.EffectiveTime = $p($h,",",2)
	s objDTO.Status = 2
	s objDTO.Template = 7
	s objDTO.TepmplateVersionNumber = 1
	;s objDTO.HFVersion = "1"
	d objDTO.DocumentData.CopyFrom(documentxml)
	
	
	s templateVerId = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion",objDTO.Template,objDTO.TepmplateVersionNumber,""))
	
	if (templateVerId = "" )
	{
		
		s ReturnValue =  ..AddTemplateVersionJson(objDTO)
	}
	else
	{
		s ReturnValue =  ..SaveTemplateVersionJson(objDTO)
	}
	q ReturnValue
}

/// Creator：      Guozongtao@mediway.cn
/// CreatDate：    2020-07-14
/// Description:   根据文档模板编码和版本号，保存文档模板版本的数据
/// Table：        CF_EMR_DOC.HeaderAndFooterVersion
/// Input：        argTemplateCode 文档模板编号
///                argTepmplateVersionNumber  文档模板版本号
/// Output         对输出参数的说明
/// Return：       CF.EMR.DOC.TemplateVersion.DocumentData 
/// Others：       其它说明
/// Debug:         w ##class(EMR.DOC.BL.TemplateVersion).SaveTemlatePublishVersion("EMR090001","1",)
ClassMethod SaveTemlatePublishVersion(argTemplateCode As %String, argTepmplateVersionNumber As %String, argDocumentData As %GlobalBinaryStream) As %String
{

	s templateVerId = ""
	s templateVerId = $o(^CF.EMR.DOC.TemplateVersionI("IdxTemplateVersion"," "_argTemplateCode,argTepmplateVersionNumber,templateVerId))
	q:templateVerId=""
	
	s orRefTempVer  = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(templateVerId)
	
	d orRefTempVer.DocumentData.Clear()
	d orRefTempVer.DocumentData.CopyFrom(argDocumentData)
	
	s sc = orRefTempVer.%Save()
	if ($$$ISOK(sc))
	{
		q (orRefTempVer.%Id())
	}
	else
	{
		 quit "-1"
	}
}

/// desc 文档版本发布 （测试用：修改数据）
/// input aID 文档版本ID 55
/// output -201
/// debug w ##Class(EMR.DOC.BL.HFFormatVersion).SetPublishVersion()
ClassMethod SetPublishVersion(aID As %String, AMLog As EMR.DOC.DTO.TemplateStatusMLog)
{
	q:aID="" -201
	TSTART
	s ObjVersion = ##class(CF.EMR.DOC.TemplateVersion).%OpenId(aID)
	q:(ObjVersion="") -301
	s ObjVersion.Status = 2
	s ObjTemplate = ObjVersion.Template
	s ObjTemplate.TempPublishVersion = aID
	s sc = ObjVersion.%Save()
	if '($$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}
	s sc = ObjTemplate.%Save()
	if '($$$ISOK(sc))
	{
		TROLLBACK
		q -101
	}
		//需要增加TemplateVersion的状态管理逻辑
	s AMLog.TemplateVersion = aID
	s AMLog.CreateDate = $ZDATEH($ZDATE($h))
 	s AMLog.CreateTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))
	s AMLog.ModifyDate = $ZDATEH($ZDATE($h))
	s AMLog.ModifyTime = $ZTIMEH($ZTIME($PIECE($h,",",2),1))

	s strMRes = ##Class(EMR.DOC.BL.TemplateStatusMLog).AddMLog(AMLog)
	if (strMRes ="-1")
	{
		TROLLBACK
		q "-102"
	}
	TCOMMIT
	q 1
}

Query GetVersions(tempalte As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,number:%String", SELECTMODE = "RUNTIME") [ SqlName = GetVersions, SqlProc ]
{
	select ID,TepmplateVersionNumber from CF_EMR_DOC.Templateversion where Template = :template
}

Query GetDeleteSignData(TemplateVersion As %String) As %SQLQuery
{
	select ID from CF_EMR_DOC.TemplateSign where TemplateVersion=:TemplateVersion
}

}
