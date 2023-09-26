/// 名称:	EMR.DOC.BL.DocumentData
/// 描述:	文档实例业务逻辑类
/// 编写者：yejian
/// 编写日期: 2021-7-29
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DocumentData Extends EMR.DOC.COM.ActionBase
{

/// Desc:       创建门诊病历
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR_DB.DocumentData 实例表,EMR_DB.DocLog日志表
/// Input:      argArray  命令参数 {"action":"CREATE_DOCUMENT","params":{"templateId":"68","episodeId":"660","userCode":"10209","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CreateDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoItem.TemplateID=argInJson.params.templateID
	s dtoItem.EpisodeID=argInJson.params.episodeID
	;s dtoItem.HospitalID = argInJson.params.hospitalID
	s dtoItem.EventID = argInJson.params.eventID
	s dtoItem.EventType = argInJson.params.eventType
	s userId = argInJson.params.userID
	s dtoItem.CreateUser = userId
	s HappenDateTime = argInJson.params.happenDateTime //需要处理时间格式
	s:(HappenDateTime'="") dtoItem.HappenDate =$ZDH(HappenDateTime,3)
 	s:(HappenDateTime'="") dtoItem.HappenTime =$ZTH($P(HappenDateTime," ",2),1)
	s dtoItem.DOCName = argInJson.params.docName
	s dtoItem.DOCCode = argInJson.params.docCode
	s dtoItem.SourceID = argInJson.params.sourceID
	s dtoItem.SourceType = argInJson.params.sourceType
	s dtoItem.DoctorName= argInJson.params.doctor
	s dtoItem.DoctorID = argInJson.params.doctorID
	s dtoItem.DoctorLevel = argInJson.params.doctorLevel
	s dtoItem.DoctorLevelCode = argInJson.params.doctorLevelCode
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.Action = $case($zcvt(argInJson.params.sourceType,"U")="REFERENCE",1:"reference",:"create") 
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = userId
	s dtoItemLog.OperateUserID = userId
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = argInJson.params.pmdType
	
    s strRes = ##Class(EMR.DOC.BL.DocumentData).CreateDocumentJson(dtoItem,dtoItemLog,argInJson.params,.argOutData)
	//-100 模板ID不能为空  -101 就诊号不能为空  -102 用户ID不能为空 -103 操作地址不能为空 -104 模板未关联业务活动记录 -105 发布版本为空
	if (strRes '[ "-1")
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
	w $zerror
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       保存门诊病历
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR_DB.DocumentData 实例表,EMR_DB.DocLog日志表
/// Input:      argInJson  命令参数 {"action":"SAVE_DOCUMENT","params":{"documentID":"1||1","templateId":"68","episodeId":"4","userCode":"ys01","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"2021-07-2209:41:26","pOperateDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod SaveDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoItem.ID = argInJson.params.documentID
	;s dtoItem.TemplateID = argInJson.params.templateId
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s userId = argInJson.params.userID
	;s dtoItem.HospitalID = argInJson.params.hospitalID
	s dtoItem.CreateUser = userId
	s dtoItem.ModifyUser = userId
	s HappenDateTime = argInJson.params.happenDateTime //需要处理时间格式
	s dtoItem.HappenDate =$case(HappenDateTime,"":$ZDH($ZD($h)),:$ZDH(HappenDateTime,3))
 	s dtoItem.HappenTime =$case(HappenDateTime,"":$ZTH($ZT($P($h,",",2),1)),:$ZTH($P(HappenDateTime," ",2),1)) 
 	s pModiyDate =argInJson.params.pOperateDateTime
 	s:(pModiyDate'="") dtoItem.PModifyDate = $ZDH(pModiyDate,3)
	s:(pModiyDate'="") dtoItem.PModifyTime = $ZTH($P(pModiyDate," ",2),1)
    s dtoItem.ModifyTime = $p($h,",",2)
    s dtoItem.ModifyDate = $p($h,",",1)
	s dtoItem.DOCName = argInJson.params.docName
	//增加事件
	s dtoItem.EventID = argInJson.params.eventID
	s dtoItem.EventType = argInJson.params.eventType
	//标题相关数据
	s dtoItem.DoctorID = argInJson.params.doctorID
	s dtoItem.DoctorName = argInJson.params.doctor
	s dtoItem.DoctorLevelCode = argInJson.params.doctorLevelCode
	s dtoItem.DoctorLevel = argInJson.params.doctorLevel
	
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.Action = "save"
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = userId
	s dtoItemLog.OperateUserID = userId
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = argInJson.params.pmdType
    s strRes = ##Class(EMR.DOC.BL.DocumentData).SaveDocumentJson(dtoItem,dtoItemLog,argInData,.argOutData)
	if (strRes '[ "-1")
	{ 
		d argOutData.Write(""""_strRes_"""")
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
		s strErr=dtoItem.ID_" "_strErr
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

/// Desc:       删除门诊病历
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR_DB.DocumentData 实例表,EMR_DB.DocLog日志表
/// Input:      argInJson  命令参数 {"action":"SAVE_DOCUMENT","params":{"documentID":"1||1","templateId":"68","episodeId":"4","userCode":"ys01","ip":"192.168.101.37","patientId":"27","loadMode":"baseTem","userLocId":"6","happenDateTime":"2021-07-2209:41:26","pOperateDateTime":"","title":"","titleCode":"","userTemplateCode":""},"product":"GlobalEMR"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod DeleteDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoItem.ID = argInJson.params.documentID
	s dtoItem.EpisodeID = argInJson.params.episodeID
	s userId = argInJson.params.userID
	s dtoItem.CreateUser = userId
	s dtoItem.ModifyUser = userId
    s dtoItem.ModifyTime = $p($h,",",2)
    s dtoItem.ModifyDate = $p($h,",",1)
	s dtoItem.DOCName = argInJson.params.docName
	s dtoItemLog = ##class(EMR.DOC.DTO.DocLog).%New()
	s dtoItemLog.Action = "delete"
	s dtoItemLog.OperateMachineIP = argInJson.params.ipAddress
	s dtoItemLog.LoginUserID = userId
	s dtoItemLog.OperateUserID = userId
	s dtoItemLog.UserLoginLocID = argInJson.params.userLocID
	s dtoItemLog.ProductSource = argInJson.params.pmdType
    s strRes = ##Class(EMR.DOC.BL.DocumentData).DeleteDocumentJson(dtoItem,dtoItemLog,argInData,.argOutData)
	if (strRes '[ "-1")
	{ 
	  	q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
		s strErr=dtoItem.ID_" "_strErr
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

/// Desc:       获取文档实例
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.DocumentData 实例表
/// Input:      argInJson  命令参数 {"action":"LOAD_DOCUMENT","params":{"documentID":["17||2","17||3","17||4","17||1"],"pluginType": "WORD"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoItem.DocumentIds = argInJson.params.documentID
	s dtoItem.DocType = argInJson.params.pluginType
    s strRes = ##Class(EMR.DOC.BL.DocumentData).LoadDocumentJson(dtoItem,.argOutData)
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

/// Desc:       判断是否已经创建保存病历文档
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.DocumentData 实例表
/// Input:      argInJson  命令参数 {"action":"GET_SAVEDOCUMENTID","params":{"templateID":"11","episodeID":"4"},"product":"GlobalEMR"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetSaveDocumentID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s templateID = argInJson.params.templateID
	s episodeID = argInJson.params.episodeID
    s strRes = ##Class(EMR.DOC.BL.DocumentData).GetSaveDocumentIDJson(templateID,episodeID)
    //成功 有实例返回实例ID，无返回空值 
    //失败 -100 模板ID不能为空  -101 就诊号不能为空 
	if (strRes="")||(strRes["||")
	{  
		s strRes = $case(strRes,"":..#NONE,:""""_strRes_"""")
	    d argOutData.Write(strRes)
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

/// Desc:       创建门诊病历
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoInData 实例对象
/// 				dtoLog 日志对象
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).CreateDocumentJson("YS01","TEMPLATE",.argOutData)
ClassMethod CreateDocumentJson(dtoInData As EMR.DOC.DTO.DocumentData, dtoLog As EMR.DOC.DTO.DocLog, argParams As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPError"
	s strRes = "1",documentID = "",bdmCode="",bdmCCode="",hasDateTime="",hasDateDocumentID=""
	q:(dtoInData.TemplateID = "") "-1^模板ID不能为空"
	q:(dtoInData.EpisodeID = "") "-1^就诊号不能为空"
	q:(dtoInData.CreateUser = "") "-1^用户ID不能为空"
	q:(dtoLog.OperateMachineIP = "") "-1^操作地址不能为空"
	s AEpisodeID = dtoInData.EpisodeID.%Id()
	s objTemplate =dtoInData.TemplateID
	q:(objTemplate.TempPublishVersion="") "-1^发布版本不能为空"
	//根据模板目录获取该模板的业务活动记录
	s strTemCId = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objTemplate.TemplateCategory)
	q:(strTemCId="-1") "-1^查找模板业务活动记录失败"
 	s objTemCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(strTemCId)
 	//获取业务活动记录分类
 	s objTemPCat = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objTemCat.ParentID)
 	q:(objTemPCat="")||(objTemPCat.Code="") "-1^业务活动记录分类编码不能为空"
 	
	q:(objTemCat.Title="") "-1^获取业务活动记录标题失败"

	//业务活动记录编码
	s:(dtoInData.DOCCode="") dtoInData.DOCCode =  $case(objTemCat.Code,"":objTemCat.BDMCategory.Code,:objTemCat.Code)
	s:(dtoInData.Serial="") dtoInData.Serial = $case(objTemCat.Title.Serial,"":0,:objTemCat.Title.Serial)
	//业务活动记录分类编码
	s dtoInData.DOCCategoryCode = objTemPCat.Code
	s:(dtoInData.DOCName ="") dtoInData.DOCName = objTemCat.EMRName
	//获取住院号
	s objPatient = dtoInData.EpisodeID.PAADMPAPMIDR
	s objGlobalData =##class(EMR.GB.GlobalData).%New()
	// 判断并创建全局图表数据
	s strRes = ##class(EMR.DAO.GlobalData).GetGlobalData(AEpisodeID,dtoInData.DOCCategoryCode,dtoInData.DOCCode,dtoInData.TemplateID.%Id(),dtoInData.HappenDate,.objGlobalData)
	q:(strRes [ "-1^") strRes
	q:(objGlobalData="")||(objGlobalData.ListNo="") "-1^创建全局图表失败"

	//判断是否已经存在唯一模板状态UNSAVE的文档ID
	s TILDocumentData = ##Class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
	s TILDocumentStream = ##Class(EMR.DAO.DocumentStream).GetTureIndexLocation(AEpisodeID)
	s hasDocumentID = $O(@TILDocumentData@("IdxEpisodeTemplateStatus",AEpisodeID,objTemplate.%Id()," UNSAVE",""),-1)
	//重复模板ID根据日期回收
	if (dtoInData.HappenDate'="")
	{
		s hasDateTime = $O(@TILDocumentData@("IdxEpisodeTemplateStatusHDT",AEpisodeID,objTemplate.%Id()," UNSAVE",dtoInData.HappenDate,""),-1)
		s:(hasDateTime'="") hasDateDocumentID = $O(@TILDocumentData@("IdxEpisodeTemplateStatusHDT",AEpisodeID,objTemplate.%Id()," UNSAVE",dtoInData.HappenDate,hasDateTime,""),-1)
		s:(hasDateDocumentID'="") hasDocumentID = hasDateDocumentID
	}
	if (hasDocumentID'="")&&(objTemplate.ChartItemType="SINGLE") //唯一模板
	{
		s objDocumentData = ##class(EMR.DAO.DocumentData).doOpenByID(hasDocumentID)
		q:(objDocumentData="") "-1^回收文档ID失败"  
		s docSID = $o(@TILDocumentStream@("IdxMain"," "_hasDocumentID,""))
		q:(docSID="") "-1^回收文档流对象失败"
		s objDocumentStream = ##class(EMR.DAO.DocumentStream).doOpenByID(AEpisodeID,docSID) 	
	}
	elseif (hasDocumentID'="")&&(objTemplate.ChartItemType="MULTIPLE") //重复模板
	{
		s objTemDocumentData = ##class(EMR.DAO.DocumentData).doOpenByID(hasDocumentID)
		q:(objTemDocumentData="") "-1^回收文档ID失败"  
		//重复模板发生时间日期相同，回收ID
		if (objTemDocumentData.HappenDate=dtoInData.HappenDate) 
		{
			s objDocumentData = objTemDocumentData
			s docSID = $o(@TILDocumentStream@("IdxMain"," "_hasDocumentID,""))
			q:(docSID="") "-1^回收文档流对象失败"
			s objDocumentStream = ##class(EMR.DAO.DocumentStream).doOpenByID(AEpisodeID,docSID)
		}
		else
		{
			s objDocumentData = ##class(EMR.DAO.DocumentData).doCreateInstance(AEpisodeID) 
			s objDocumentStream = ##class(EMR.DAO.DocumentStream).doCreateInstance(AEpisodeID)  
		}
 	
	}
	else
	{
		s objDocumentData = ##class(EMR.DAO.DocumentData).doCreateInstance(AEpisodeID) 
		s objDocumentStream = ##class(EMR.DAO.DocumentStream).doCreateInstance(AEpisodeID)  	
	}
	;s objDocumentData = ##class(EMR.DB.DocumentData).%New()
	//保存Instance表初始化数据	
	s objDocumentData.CreateDate = $p($h,",",1)
	s objDocumentData.CreateTime = $p($h,",",2)
	s objDocumentData.HappenDate = $case(dtoInData.HappenDate="",1:$p($h,",",1),:dtoInData.HappenDate)
	s objDocumentData.HappenTime = $case(dtoInData.HappenDate="",1:$p($h,",",2),:dtoInData.HappenTime)
	s objDocumentData.CreateUser = dtoInData.CreateUser
	s objDocumentData.TemplateCategoryID = objTemplate.TemplateCategory
	s objDocumentData.TemplateCategoryName = objTemplate.TemplateCategory.Name
	s objDocumentData.Status = "UnSave"
	s objDocumentData.TemplateID = objTemplate
	s objDocumentData.DOCCategoryCode = dtoInData.DOCCategoryCode
	s objDocumentData.DOCName = dtoInData.DOCName
	s objDocumentData.DOCCode = dtoInData.DOCCode
	s objDocumentData.SourceID = dtoInData.SourceID
	s objDocumentData.SourceType = dtoInData.SourceType
	s objDocumentData.TemplateVersion = objTemplate.TempPublishVersion
	s objDocumentData.EpisodeID =dtoInData.EpisodeID
	s objDocumentData.PatientID = objPatient
	s objDocumentData.ListNo = objGlobalData.ListNo
	s objDocumentData.Serial = dtoInData.Serial
	
	//如果标题为空获取关联的业务域编码设置为TitleCode
	s objStream = ##Class(%GlobalBinaryStream).%New()
	s $zt = "OPRecordError"
	Tstart
    s scGloablData = objGlobalData.%Save()
    if ($$$ISERR(scGloablData))
	{
		Trollback
		q "-1^创建全局图表失败"
	}
	s objDocumentData.GlobalDataID = objGlobalData.%Id() 
	s scDocumentData = objDocumentData.%Save() 
	if ($$$ISERR(scDocumentData))
	{
		Trollback
		q "-1^创建实例表失败"
	}
	s documentID = objDocumentData.%Id()
	if ((documentID '= "")&&(argOutData '= "")&&(objDocumentStream'=""))
	{
		s dtoInData.ID = documentID
		s objDocumentStream.DocumentID = documentID
		;d objStream.CopyFrom(##class(EMR.DOC.BL.DocumentData).GetNewDocByTemplateID(dtoInData,objTemplate,argParams))
		;d objDocumentStream.DocumentData.CopyFrom(objStream)
		s scInStream = objDocumentStream.%Save() 
		s objDocumentData.DocumentStream = objDocumentStream
		s scIn = objDocumentData.%Save() 
		if ($$$ISERR(scIn)||$$$ISERR(scInStream))
		{
			Trollback
			q "-1^创建实例保存流数据失败"
		}
	}
	//添加日志
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoLog,objDocumentData)
    if (logStatus [ "-1^")
	{
		Trollback
		q "-1^添加日志失败"
	}
    TCOMMIT
    d objDocumentData.%Close(),objDocumentStream.%Close()
    k objDocumentData,objDocumentStream
    
	//创建成功后，获取文档数据
	d objStream.CopyFrom(##class(EMR.DOC.BL.DocumentData).GetNewDocByTemplateID(dtoInData,objTemplate,argParams))
	if (objStream.Size>0)
	{
		d objStream.Rewind()
		while (objStream.AtEnd = 0)
		{
			s tmpOut = objStream.Read(30000)
			s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
			d argOutData.Write(tmpUtf8)
		} 
	}
    
	d objTemplate.%Close()
	k objTemplate
	q documentID
OPRecordError
	Trollback
    q -1_"^"_$zerror
OPError
    q -1_"^"_$zerror
}

/// Desc:       根据模板获取实例数据或引用实例
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:		ATemplateVersionID:版本ID,
/// 			adocumentID:实例ID，
/// 			argParams:json入参
/// OutPut:     成功 模板文档流
/// 			失败 -1^失败信息
/// 				argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).GetNewDocByTemplateID("90","TEMPLATE",.argOutData)
ClassMethod GetNewDocByTemplateID(dtoInData As EMR.DOC.DTO.DocumentData, objTemplate As CF.EMR.DOC.Template, argParams As %DynamicAbstractObject) As %GlobalBinaryStream
{
	s $zt = "OPDataBindError"
	s obj = ##Class(%GlobalBinaryStream).%New()
	s objRes = ##Class(%GlobalBinaryStream).%New()
	//病历引用获取，获取文档数据
	if (($zcvt(dtoInData.SourceType,"U")="REFERENCE")&&(dtoInData.SourceID'=""))
    {
	     s documentID = dtoInData.SourceID
		s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
		if (objDocument.DocumentStream ="")||(objDocument.DocumentStream.DocumentData.Size=0)
		{
			s strRes ="-1^"_documentID_"获取实例失败"	
			q objRes
		}
		s objStream = ##Class(%GlobalBinaryStream).%New()
		//数据解压缩
		s temStream = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objDocument.DocumentStream.DocumentData)
		d objStream.CopyFrom(temStream)
		s jsonDocData = ##class(%DynamicAbstractObject).%FromJSON(objStream)
		//增加标题数据
		s jsonTitle = ##Class(EMR.DOC.BL.TemplateCategory).GetTitleDatas(objTemplate.%Id(),dtoInData)
		s jsonDocData.title = jsonTitle
		d jsonDocData.%ToJSON(objRes)
    }
    else	//根据模板获取实例数据
    {
		q:((dtoInData.ID = "")||(objTemplate.TempPublishVersion=""))
		s objTemplateVersion = ##Class(CF.EMR.DOC.TemplateVersion).%OpenId(objTemplate.TempPublishVersion)
		q:(objTemplateVersion = "") obj	
		//新建文档取模板版本信息表数据
		d obj.CopyFrom(objTemplateVersion.DocumentData)	
		s jsonDocData = ##class(%DynamicAbstractObject).%FromJSON(obj)
		//增加标题数据
		s jsonTitle = ##Class(EMR.DOC.BL.TemplateCategory).GetTitleDatas(objTemplate.%Id(),dtoInData)
		s jsonDocData.title = jsonTitle
		
		d jsonDocData.%ToJSON(objRes)
    }
    q objRes
OPDataBindError
   q objTemplate.TempPublishVersion_"^"_$zerror
}

/// Desc:       根据模板获取实例数据(测试)
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:		ATemplateVersionID:版本ID
/// 				argParams 参数
/// OutPut:     成功 模板文档流
/// 			失败 失败 -1^失败提示信息
/// 				argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             s objRes = ##class(EMR.DOC.BL.DocumentData).GetNewDocByTemplateIDTest("90")
ClassMethod GetNewDocByTemplateIDTest(ATemplateVersionID As %String, argParams As %DynamicAbstractObject) As %GlobalBinaryStream
{
	s $zt = "OPDataBindError"
	s obj = ##Class(%GlobalBinaryStream).%New()
	q:(ATemplateVersionID = "")
	s objTemplateVersion = ##Class(CF.EMR.DOC.TemplateVersion).%OpenId(ATemplateVersionID)
	q:(objTemplateVersion = "") obj	
	//新建文档取模板版本信息表数据
	d obj.CopyFrom(objTemplateVersion.DocumentData)	
	s jsonDocData = ##class(%DynamicAbstractObject).%FromJSON(obj)
	s objRes = ##Class(%GlobalBinaryStream).%New()
	s jsonDocData = ##class(EMR.DOC.TOOL.JsonDataBinds).SetDataBind(jsonDocData,argParams,.objRes)
	d objRes.Rewind()
	while (objRes.AtEnd = 0)
	{
		s tmpOut = objRes.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		w tmpUtf8
  	} 
    q objRes
OPDataBindError
    q ATemplateVersionID_"^"_$zerror
}

/// Desc:       保存门诊病历
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      dtoInData 实例对象，
/// 			dtoLog 日志对象
/// 			argInData 病历流数据
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^错误提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).SaveDocumentJson("","",.argOutData)
ClassMethod SaveDocumentJson(dtoInData As EMR.DOC.DTO.DocumentData, dtoILog As EMR.DOC.DTO.DocLog, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1"
	q:(dtoInData.ID = "") "-1^实例ID不能为空"
	q:(argInData = "") "-1^病历内容不能为空"		
	s documentID = dtoInData.ID
	q:(dtoInData.EpisodeID = "") "-1^就诊号不能为空"
	q:(dtoInData.ModifyUser = "") "-1^用户ID不能为空"
	q:(dtoILog.OperateMachineIP = "") "-1^操作IP地址不能为空"
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(documentID)
	q:(objDocument = "") "-1^获取实例对象失败"
	s templateID = objDocument.TemplateID.%Id()
	s objTemplate = ##Class(CF.EMR.DOC.Template).%OpenId(templateID)
	q:(objTemplate = "") "-1^获取模板数据失败"
	q:(objTemplate.TempPublishVersion="") "-1^发布版本不能为空"
	
	//检查是否打开后，保存前有其他人保存（防止覆盖）
	s saveStatus=""
	s:(dtoInData.PModifyDate'="") saveStatus = ##Class(EMR.DOC.BL.DocumentData).CheckSaveStatus(documentID,dtoInData.PModifyDate,dtoInData.PModifyTime)
	q:(saveStatus["-1^") "-1^DocumentID:"_documentID_","_$p(saveStatus,"^",2)
	
	Tstart	
    //保存实例数据(成功 1,病历保存失败 -1,病历已经被其他用户保存 -2)
	s status = ##Class(EMR.DOC.BL.DocumentData).SaveDoucmentData(dtoInData,argInData)
	if (status '= "1")
	{
		Trollback
		q status
	}
	//添加日志
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoILog,objDocument)
    if ($p(logStatus,"^",1) = "-1")
	{
		Trollback
		q "-1^添加日志失败"
	}
	//添加事件关联
	s eventStatus = ##Class(EMR.DOC.BL.Event.LinkDocument).LinkDocumentEvent(dtoInData)
    if ($p(eventStatus,"^",1) = "-1")
	{
		Trollback
		q "-1^添加事件关联失败:"_$p(eventStatus,"^",2)
	}
	//更新标题关联信息
	if (dtoInData.ID'="")&&((dtoInData.DoctorID'="")||(dtoInData.DoctorLevel'=""))
	{
		s resTitleData = ##class(EMR.DOC.BL.DocumentTitleDoctor).UpTitleDatas(dtoInData.EpisodeID,dtoInData.ID,dtoInData.DoctorID,dtoInData.DoctorName,dtoInData.DoctorLevel,dtoInData.DoctorLevelCode)
		if (resTitleData["-1^")
		{
			Trollback
			q resTitleData
		}
	}
	TCOMMIT
	// 更新该文档，活动记录中最新的打印记录的modifyDocumentID
	s strPrintRes = ##class(EMR.DOC.BL.DocumentPrintRecord).SaveLastModifyDocument(documentID,dtoInData.EpisodeID)
	q documentID
OPRecordError
	Trollback
    q "-1^"_documentID_"^"_$zerror
}

/// Desc:       保存门诊病历
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      dtoInData 实例对象,
/// 			argInData 病历流数据
/// OutPut:     成功 1,	病历保存失败 
/// 			失败 -1
/// 			argOutData json数据
/// Output:     result 1成功,-1失败 
ClassMethod SaveDoucmentData(dtoInData As EMR.DOC.DTO.DocumentData, argInData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s result = "1"	
	s objRecordData = ##Class(%GlobalBinaryStream).%New()
	d objRecordData.CopyFrom(argInData)		
	d dtoInData.DocumentData.CopyFrom(objRecordData)
    Tstart
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(dtoInData.ID)
	;s objDocument = ##Class(EMR.DB.DocumentData).%OpenId(dtoInData.ID)
	q:(objDocument = "") "-1^根据文档ID获取文档失败"
	s AEpisodeID = dtoInData.EpisodeID.%Id()
	s TILDocumentData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
	//修改状态为Save状态
	if ($zcvt(objDocument.Status,"U") = "UNSAVE")
	{
		s flag = $d(@TILDocumentData@("IdxEpisodeTemplateStatusHDT",AEpisodeID,objDocument.TemplateID.%Id()," SAVE"))
		q:((objDocument.TemplateID.ChartItemType = "Single")&&(flag>0)) "-1"
		s objDocument.Status = "Save"
		s objDocument.CreateUser = dtoInData.CreateUser
		s objDocument.HappenDate = $case(dtoInData.HappenDate="",1:$p($h,",",1),:dtoInData.HappenDate)
	  	s objDocument.HappenTime = $case(dtoInData.HappenDate="",1:$p($h,",",2),:dtoInData.HappenTime)
	  	;s initStatus = $case(objDocument.EMRStatus,"":" ",:objDocument.EMRStatus.Code) //初始状态	
		;s objFStatus = ##class(EMR.DOC.BL.DocLog).GetFinaStatus(initStatus,"save")
		;s objDocument.EMRStatus = objFStatus
	}
	else
	{
		s:(dtoInData.HappenDate '= "") objDocument.HappenDate = dtoInData.HappenDate
		s:(dtoInData.HappenTime '= "") objDocument.HappenTime = dtoInData.HappenTime
	}
	s:(dtoInData.DOCName '="") objDocument.DOCName = dtoInData.DOCName
	d objDocument.DocumentStream.DocumentData.Clear()
	//数据压缩存储
	s temStream = ##class(EMR.DOC.COM.Parser.StreamData).CompressStream(dtoInData.DocumentData)
	d objDocument.DocumentStream.DocumentData.CopyFrom(temStream)
	s scStream =  objDocument.DocumentStream.%Save()
	if ($$$ISERR(scStream))
	{
		Trollback
		q "-1^保存文档流数据失败"
	}
	s objDocument.ModifyDate = $p($h,",",1)
	s objDocument.ModifyTime = $p($h,",",2)
	s objDocument.ModifyUser = dtoInData.ModifyUser
	//保存实例
	s sc = objDocument.%Save()
	if ($$$ISERR(sc))
	{
		Trollback
		q "-1^保存文档失败"
	}
	//数据打散
	s outStream = ##Class(%GlobalBinaryStream).%New()
	s obj = ##Class(%GlobalBinaryStream).%New()
	d obj.CopyFrom(dtoInData.DocumentData)	
	d obj.Rewind()
	while (obj.AtEnd = 0)
	{
		s tmpOut = obj.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d outStream.Write(tmpUtf8)
  	} 
	s jsonDocData = ##class(%DynamicAbstractObject).%FromJSON(outStream)
	s sdResult = ##Class(EMR.DOC.BL.ScattetData).SaveScatterData(dtoInData.ID,jsonDocData)
	if (sdResult [ "-1")
	{
		Trollback
		q sdResult
	}

	TCOMMIT 			
	q result
Error
   Trollback
   q "-1^"_dtoInData.ID_"^"_$zerror
}

/// Desc:       删除门诊病历
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      dtoInData 实例对象，
/// 			dtoLog 日志对象
/// 			argInData 病历流数据
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^错误提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).SaveDocumentJson("","",.argOutData)
ClassMethod DeleteDocumentJson(dtoInData As EMR.DOC.DTO.DocumentData, dtoILog As EMR.DOC.DTO.DocLog, argInData As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1"
	q:(dtoInData.ID = "") "-1^实例ID不能为空"		
	q:(dtoInData.EpisodeID = "") "-1^就诊号不能为空"
	q:(dtoInData.ModifyUser = "") "-1^用户ID不能为空"
	q:(dtoILog.OperateMachineIP = "") "-1^操作IP地址不能为空"
	s documentID = dtoInData.ID
	s AEpisodeID = dtoInData.EpisodeID.%Id()
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(documentID)
	q:(objDocument = "") "-1^获取实例对象失败"
	
	s objDocument.Status = "Delete"
	s objDocument.ModifyDate = dtoInData.ModifyDate
	s objDocument.ModifyTime = dtoInData.ModifyTime
	s objDocument.ModifyUser = dtoInData.ModifyUser
	Tstart	

    //保存实例数据(成功 1,病历保存失败 -1,病历已经被其他用户保存 -2)
	s sc = objDocument.%Save()
	if ($$$ISERR(sc))
	{
		Trollback
		q "-1^删除实例失败"
	}
	//添加日志
	s logStatus = ##Class(EMR.DOC.BL.DocLog).AddOperateLog(dtoILog,objDocument)
    if ($p(logStatus,"^",1) = "-1")
	{
		Trollback
		q "-1^添加日志失败"
	}
	
	s eventStatus = ##Class(EMR.DOC.BL.Event.LinkDocument).DeleteData(AEpisodeID,documentID,dtoInData.ModifyUser.%Id())
    if ($p(eventStatus,"^",1) = "-1")
	{
		Trollback
		q "-1^删除事件关联失败"
	}
	TCOMMIT
	s objJson = ##class(%DynamicObject).%New()
	s objJson.documentID = objDocument.%Id()
	s objJson.docName = objDocument.DOCName
	s objJson.docCode = objDocument.DOCCode
	s objJson.docCategoryCode = objDocument.DOCCategoryCode
	s objJson.templateCategoryID = objDocument.TemplateCategoryID.%Id()
	s objJson.templateID = objDocument.TemplateID.%Id()
	s objJson.serial = objDocument.Serial
	s objJson.eventID = ""
	s objJson.eventType = ""
	d objJson.%ToJSON(argOutData)
	q strRes
OPRecordError
	Trollback
    q "-1^"_documentID_"^"_$zerror
}

/// Desc:       根据实例ID获取就诊号
/// Creator:    yejian
/// CreateDate: 2021-8-5
/// Input:      insId 实例ID
/// OutPut:     有实例返回就诊号，无返回空
/// Debug:      w ##class(EMR.DOC.BL.DocumentData).getAdmBydocumentID("1||1")
ClassMethod getAdmBydocumentID(insId As %String) As %String
{
	s result = ""
	q:(insId = "") result
	s ins=##Class(EMR.DAO.DocumentData).doOpenByID(insId)
	q:(ins = "") result
	s result = ins.EpisodeID
	q result
}

/// Desc:       获取文档病历
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoInData 实例对象
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).LoadDocumentJson("YS01","TEMPLATE",.argOutData)
ClassMethod LoadDocumentJson(dtoInData As EMR.DOC.DTO.DocumentData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1",documentID=""
	q:((dtoInData.DocumentIds="")||(dtoInData.DocumentIds.%Size()=0)) "-1^实例ID不能为空"
	q:(dtoInData.DocType="") "-1^文档类型不能为空"
	//PDF获取PDF文档
	if ($zcvt(dtoInData.DocType,"U")="PDF")
	{
		s strRes = ##Class(EMR.DOC.BL.PDFAuditSignLog).LoadDocument(dtoInData,.argOutData)
		q strRes
	}
	else //WORD获取文档实例
	{
		s strFid = dtoInData.DocumentIds.%Get(0)
		s objFData = ##class(EMR.DAO.DocumentData).doOpenByID(strFid)
		q:(objFData="") "-1^"_strFid_"获取实例失败"	
		//连续显示文档，返回JSON数组，非连续显示，返回文档对象
		d:(objFData.Serial =1) argOutData.Write("[")
		s DocumentIds = dtoInData.DocumentIds
		set iter = DocumentIds.%GetIterator()
		while iter.%GetNext(.key , .item ) {
	        s documentID = item
	        continue:(documentID = "")
	        d:(key>0) argOutData.Write(",")
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
			if (objDocument.DocumentStream ="")||(objDocument.DocumentStream.DocumentData.Size=0)
			{
				s strRes ="-1^"_documentID_"获取实例失败"	
				q
			}
			s objStream = ##Class(%GlobalBinaryStream).%New()
			//数据解压缩
			s temStream = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objDocument.DocumentStream.DocumentData)
			d objStream.CopyFrom(temStream)
			d objStream.Rewind()
			while (objStream.AtEnd = 0)
			{
				s tmpOut = objStream.Read(30000)
				s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
				d argOutData.Write(tmpUtf8)
		  	} 
			d objDocument.%Close()
			k objDocument
		}
		d:(objFData.Serial =1) argOutData.Write("]")
	}
	q strRes
OPRecordError
    q "-1^"_documentID_","_$zerror
}

/// Desc:       判断是否已经创建保存病历文档
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      templateID 模板ID
/// 			episodeID 就诊号
/// OutPut:     成功 有实例返回实例ID，无返回空值
/// 			失败 -1^失败提示信息
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).GetSaveDocumentIDJson("68","603")
ClassMethod GetSaveDocumentIDJson(templateID As %String, episodeID As %String) As %String
{
	s $zt = "Error"
	s strRes = ""
	s date = ""
	q:(templateID="") "-1^模板ID不能为空"
	q:(episodeID="") "-1^就诊号不能为空"
	s TILInstaneData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(episodeID)
    s date = $o(@TILInstaneData@("IdxEpisodeTemplateStatusHDT",templateID," SAVE",date),-1)
    q:(date = "") strRes
    s time = $o(@TILInstaneData@("IdxEpisodeTemplateStatusHDT",templateID," SAVE",date,""),-1)
    q:(time = "") strRes 
    s instanceSubId = $o(@TILInstaneData@("IdxEpisodeTemplateStatusHDT",templateID," SAVE",date,time,""),-1)  
    q:(instanceSubId = "") strRes
    s strRes = instanceSubId	    
	q strRes
Error
    q strRes_"^"_$zerror
}

/// Desc:      判断模板有没有实例化
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Input:      aDocCode 业务活动记录编码
/// 			EpisodeId 就诊号
/// OutPut:     存在 1，不存在 0
/// 			失败 -1^失败提示信息
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).IsHasInstanceByBDMCode("68","603")
ClassMethod IsHasInstanceByBDMCode(EpisodeId As %String, aDocCode As %String) As %String
{
	s result = "0"
	q:(EpisodeId="")||(aDocCode="") "-1^就诊号和业务活动记录编码不能为空" 
	s aBdmCode = $zcvt(aDocCode,"U")
	s TILInstaneData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(EpisodeId)
	s strInSID = $o(@TILInstaneData@("IdxEpisodeRecordCodeStatus",EpisodeId," "_aBdmCode," SAVE",""))
    q:(strInSID = "") "0"
	q 1
}

/// Desc:      判断就诊是否写过病历
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Input:      aDocCode 业务活动记录编码
/// 			EpisodeId 就诊号
/// OutPut:     存在 1，不存在 0
/// 			失败 -1^失败提示信息
/// Debug:      w ##class(EMR.DOC.BL.DocumentData).IsHasInstance("68")
ClassMethod IsHasInstance(EpisodeId As %String) As %String
{
	s result = "0"
	q:(EpisodeId="") "-1^就诊号不能为空" 
	s TILInstaneData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(EpisodeId)
	s strInSID = $o(@TILInstaneData@("IdxEpisodeStatusHDT",EpisodeId," SAVE",""))
    q:(strInSID = "") "0"
	q 1
}

/// Desc:       判断患者是否可以创建模板病历
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"ISCAN_CREATE","params":{"templateID":"47","episodeID":"4"}}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod IsCanCreate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strTemplateID = argInJson.params.templateID
	s strEpisodeID = argInJson.params.episodeID
    s strRes = ##Class(EMR.DOC.BL.DocumentData).IsCanCreateJson(strEpisodeID,strTemplateID)
    s objJson = ##class(%DynamicObject).%New()
	if (strRes="1")
	{ 
		s objJson.canCreate = "1"
		s objJson.reason = ""
		d objJson.%ToJSON(argOutData)
	  	;q argOutMessage.success = ..#OK
	}
	elseif(strRes["-1^")
	{  
		s strErr = $p(strRes,"^",2)
		s objJson.canCreate = "-1"
		s objJson.reason = strErr
		d objJson.%ToJSON(argOutData)
	    ;q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	q argOutMessage.success = ..#OK
	;else
	;{
	;	q ..SetOutMessage(argOutMessage,"ERROR","获取数据失败",2)
	;}
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:      判断患者是否可以创建模板病历
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Input:      aEpisodeID 就诊号
/// 			aTemplateID 模板ID
/// OutPut:     能创建 1，不能创建 -1^失败提示信息
/// Debug:      w ##class(EMR.DOC.BL.DocumentData).IsCanCreateJson("4","47")
ClassMethod IsCanCreateJson(aEpisodeID As %String, aTemplateID As %String) As %String
{
	s strRes = "1"
	q:(aEpisodeID="")||(aTemplateID="") "-1^就诊号和模板ID不能为空" 
	s objTem = ##class(CF.EMR.DOC.Template).%OpenId(aTemplateID)
	s objEpisode = ##class(User.PAAdm).%OpenId(aEpisodeID,0)
	q:(objTem="")||(objEpisode="") "-1^就诊号、模板ID不能为空"
	s recordID = ##Class(EMR.DOC.BL.TemplateCategory).GetTemplateRecord(objTem.TemplateCategory)
	q:(recordID="") "-1^获取业务活动记录失败"
	s objDoc = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(recordID)
	q:(objDoc="") "-1^获取业务活动记录失败"
	s objDocCateory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(objDoc.ParentID)
	q:(objDocCateory = "") "-1^获取业务活动记录分类失败"
	q:(objDoc.Code="")||(objDocCateory.Code="") "-1^获取业务活动记录、分类编码失败"
	s strRes = ##Class(EMR.DAO.GlobalData).GetGlobalData(aEpisodeID,objDocCateory.Code,objDoc.Code,aTemplateID)
	q strRes
}

/// Desc:       根据文档ID获取就诊号（判断是否串患者）
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		
/// Input:      argInJson  命令参数 {"product":"OP","action":"GET_ADMBYDOCUMENTID","params":{"documentID":"33"}}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetAdmByDocID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strDocumentID = argInJson.params.documentID
    s strRes = ##Class(EMR.DOC.BL.DocumentData).GetAdmByDocIDJson(strDocumentID,.argOutData)
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
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:      判断患者是否可以创建模板病历
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Input:      aDocumentID 文档ID
/// 			aTemplateID 模板ID
/// OutPut:     能创建 1，不能创建 -1^失败提示信息
/// Debug:      w ##class(EMR.DOC.BL.DocumentData).IsCanCreateJson("4","47")
ClassMethod GetAdmByDocIDJson(aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	q:(aDocumentID ="") "-1^文档ID不能为空"
	
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDocument = "") "-1^根据文档ID获取文档失败"
	s EpisodeID = """"_objDocument.EpisodeID.%Id()_""""
	d argOutData.Write(EpisodeID)
	q strRes
}

/// Desc:       检查是否打开后，保存前有其他人保存（防止覆盖）
/// Creator:    yejian
/// Createdate: 2022-9-21
/// Input:      aDocumentID 实例数据ID
///             aPOperateDate 打开时实例最后的操作日期
///             aPOperateTime 打开时实例最后的操作时间
/// Output:     result 1成功,-1^失败信息 
/// Debug: 		w ##class(EMR.DOC.BL.DocumentData).CheckSaveStatus("33","66373","52842")
ClassMethod CheckSaveStatus(aDocumentID As %String, aPOperateDate As %String, aPOperateTime As %String) As %String
{
	s strRes = "1"
	q:(aDocumentID ="") "-1^文档ID不能为空"
	
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	q:(objDocument = "") "-1^根据文档ID获取文档失败"
	if ((objDocument.ModifyDate '= aPOperateDate) || (objDocument.ModifyTime '= aPOperateTime))
	{
		q "-1^保存失败，因其他人已修改该病历，保存会将其覆盖"
	}
	q strRes
}

/// Desc:       获取文档实例(ID加密)
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		EMR_OP.ECRecord 实例主表，EMR_OP.DocumentData 实例表
/// Input:      argInJson  命令参数 {"action":"BROWSE_DOCUMENT","params":{"documentID":["5233B76FBCB64E4B9B538DE060B49D94464290CA3D4E9AC42FA996A837AC50B614CE0AB10539DDE5F6B4E3574BB2FA4C"],"pluginType":"WORD"},"product":"OP"}
/// 			argInData 病历流数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod LoadEncDocument(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s dtoItem = ##class(EMR.DOC.DTO.DocumentData).%New()
	s dtoItem.DocumentIds = argInJson.params.documentID
	s dtoItem.DocType = argInJson.params.pluginType
	s dtoItem.IsEncry = "Y"
    s strRes = ##Class(EMR.DOC.BL.DocumentData).LoadEncDocumentJson(dtoItem,.argOutData)
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

/// Desc:       获取文档病历(ID加密)
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoInData 实例对象
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).LoadDocumentJson("YS01","TEMPLATE",.argOutData)
ClassMethod LoadEncDocumentJson(dtoInData As EMR.DOC.DTO.DocumentData, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1",documentID=""
	q:((dtoInData.DocumentIds="")||(dtoInData.DocumentIds.%Size()=0)) "-1^实例ID不能为空"
	q:(dtoInData.DocType="") "-1^文档类型不能为空"
	if ($zcvt(dtoInData.DocType,"U")="PDF")
	{
		s strRes = ##Class(EMR.DOC.BL.PDFAuditSignLog).LoadDocument(dtoInData,.argOutData)
		q strRes
	}
	else //WORD获取文档实例
	{
		s strFid = dtoInData.DocumentIds.%Get(0)
		s strFid = ##class(EMR.DOC.COM.EncryptionTool).GetUnEncDocId(strFid)
		s objFData = ##class(EMR.DAO.DocumentData).doOpenByID(strFid)
		q:(objFData="") "-1^"_strFid_"获取实例失败"	
		//连续显示文档，返回JSON数组，非连续显示，返回文档对象
		d:(objFData.Serial =1) argOutData.Write("[")
		s DocumentIds = dtoInData.DocumentIds
		set iter = DocumentIds.%GetIterator()
		while iter.%GetNext(.key , .item ) {
	        s documentID = item
	        continue:(documentID = "")
	        s documentID = ##class(EMR.DOC.COM.EncryptionTool).GetUnEncDocId(documentID)
	        d:(key>0) argOutData.Write(",")
			s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
			if (objDocument.DocumentStream ="")||(objDocument.DocumentStream.DocumentData.Size=0)
			{
				s strRes ="-1^"_documentID_"获取实例失败"	
				q
			}
			s objStream = ##Class(%GlobalBinaryStream).%New()
			//数据解压缩
			s temStream = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objDocument.DocumentStream.DocumentData)
			d objStream.CopyFrom(temStream)
			d objStream.Rewind()
			while (objStream.AtEnd = 0)
			{
				s tmpOut = objStream.Read(30000)
				s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
				d argOutData.Write(tmpUtf8)
		  	} 
			d objDocument.%Close()
			k objDocument
		}
		d:(objFData.Serial =1) argOutData.Write("]")
	}
	q strRes
OPRecordError
    q "-1^"_documentID_","_$zerror
}

/// Desc:       根据文档ID获取文档病历
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      dtoInData 实例对象
/// OutPut:     成功 返回实例ID，
/// 			失败 -1^失败提示信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocumentData).LoadDocumentByID("218")
ClassMethod LoadDocumentByID(aDocumentID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "OPRecordError"
	s strRes = "1",documentID=""
	q:(aDocumentID="") "-1^实例ID不能为空"
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
	if (objDocument.DocumentStream ="")||(objDocument.DocumentStream.DocumentData.Size=0)
	{
		s strRes ="-1^"_documentID_"获取实例失败"	
		q
	}
	s objStream = ##Class(%GlobalBinaryStream).%New()
	//数据解压缩
	s temStream = ##class(EMR.DOC.COM.Parser.StreamData).DeCompressStream(objDocument.DocumentStream.DocumentData)
	d objStream.CopyFrom(temStream)
	d objStream.Rewind()
	while (objStream.AtEnd = 0)
	{
		s tmpOut = objStream.Read(30000)
		s tmpUtf8 = $zcvt(tmpOut,"I","UTF8")
		d argOutData.Write(tmpUtf8)
  	} 
	d objDocument.%Close()
	k objDocument
	q strRes
OPRecordError
    q "-1^"_aDocumentID_","_$zerror
}

/// Desc:      根据分类编码获取文档份数
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Input:      aDocCode 业务活动记录编码
/// 			EpisodeId 就诊号
/// OutPut:     返回文档份数
/// Debug:      w ##class(EMR.DOC.BL.DocumentData).GetDocumentCount("68","603")
ClassMethod GetDocumentCount(ADocCategoryCode As %String, AEpisodeID As %String) As %String
{
	s strRes = 0
	q:(AEpisodeID="")||(ADocCategoryCode="") strRes
	s ADocCategoryCode = $zcvt(ADocCategoryCode,"U")
	s TILInstaneData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
	s docID = ""
	for
	{
		s docID = $o(@TILInstaneData@("IdxEpisodeDOCCCodeStatus",AEpisodeID," "_ADocCategoryCode," SAVE",docID))
	    q:(docID = "") 
    	s strRes=strRes+1
	}
	q strRes
}

}
