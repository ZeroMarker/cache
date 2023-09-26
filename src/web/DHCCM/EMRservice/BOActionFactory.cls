/// Creator:  	bianshuai
/// CreateDate: 2016-09-21
/// Descript: 	交互命令工厂
Class web.DHCCM.EMRservice.BOActionFactory Extends %RegisteredObject
{

Parameter OK = "{""params"":{""result"":""OK""";

Parameter ERROR = "{""params"":{""result"":""ERROR""";

Parameter NONE = "NONE";

/// Creator：      guozongtao
/// CreatDate：    2013-12-25
/// Description:   编辑器的命令工厂,解析argInMessage参数，进行分支处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"params":"{\"docId\":\"160202\", \"actionUrl\":\"/editor/diseasedoc/load.cmd\"}","type":"action"}。
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(web.DHCCM.EMRservice.BOActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInMessage As %GlobalBinaryStream, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//定义错误处理函数
	s $ZT="ERROR"
	//解析json参数		       
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInMessage)
	s strAction = array.GetAt("params").GetAt("action")
	//命令分发
	if (strAction = "LOAD_DOCUMENT_INDEX")  
	{
		//加载文档索引
    	d ..LoadDocumentIndex(array,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DOCUMENT")  
	{
		//加载文档
		d ..LoadDocument(array,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DEFAULT_FIELD")
	{
		//取数据绑定值
		d ..LoadDefaultField(array,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DEFAULT_COMPOSITE")  
	{
		//取绑定知识库集合
        d ..LoadDefaultComposite(array,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_DOCUMENT_INDEX")  
	{
		//保存索引
		d ..SaveDocumentIndex(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_DOCUMENT")         
	{
		d ..SaveDocument(array,argInData,argOutMessage,argOutData) 	  
	}
	elseif (strAction = "SAVE_DOCUMENT_AS")         
	{
		d ..SaveModelDocument(array,argInData,argOutMessage,argOutData) 
	}	
	elseif (strAction = "LOAD_TEMPLATE")         
	{
		//加载模板
		d ..LoadTemplate(array,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_META_TEMPLATE")         
	{
		//加载母板
		d ..GetmetaTemplateByID(array,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_META_TEMPLATE")         
	{
		//保存母板
		d ..SavemetaTemplateByID(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_COMPOSITE")       
	{
		//加载知识库
		d ..LoadComposite(array,argOutMessage,argOutData)	
	}
	elseif (strAction = "LOAD_MODEL_INSTANCE")       
	{
		//加载范例病历
		d ..LoadModelInstance(array,argOutMessage,argOutData)
	}	
	elseif (strAction = "SAVE_TEMPLATE")         
	{
		//保存模板
		d ..SaveTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_COMPOSITE")        
	{
		//保存知识库
		d ..SaveComposite(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "UPDATE_MODEL_INSTANCE")        
	{
		//保存病历范例
		d ..UpdateModelInstance(array,argInData,argOutMessage,argOutData)
	}	
	elseif (strAction = "LOAD_TITLE_CONFIG")
	{
		//加载引导框标题及配置
		d ..LoadTitleConfig(array,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_DOCUMENT")
	{
		s aType = array.GetAt("params").GetAt("type")
		//新建文档
		if (aType = "BANDTEST")
		{
			d ..CreateTestDocument(array,argOutMessage,argOutData)
		}
		else
		{
			d ..CreateDocument(array,argOutMessage,argOutData)
		}
	}
	elseif (strAction = "GET_PRIVILEGE")
	{
		//权限
		d ..GetPrivilege(array,argOutMessage,argOutData)
	}
	elseif (strAction = "GET_CURRENT_STATUS")
	{
		//文档状态
		d ..GetCurrentStatus(array,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_DICTIONARY")
	{
		//加载字典查询
		d ..LoadDictionary(array,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_SIGNED_DOCUMENT")
	{
		d ..SaveSignDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "DELETE_DOCUMENT")
	{
		d ..DeleteDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_GLOBAL_PARAMETERS")
	{
		//插件获取系统参数
		d ..GetSysOptions(array,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_DOCUMENT_BY_INSTANCE")
	{
		if (array.GetAt("params").GetAt("SaveType") = "Model")
		{
			//个人模板引用
			d ..QuotationModelDocumnet(array,argOutMessage,argOutData)
		}
		else
		{
			//病历引用
			d ..QuotationDocumnet(array,argOutMessage,argOutData)
		}
	}
	elseif (strAction = "PRINT_DOCUMENT")
	{
		///打印文档
		d ..PrintDocument(array,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_CONCEPT")
	{
		///打印文档
		d ..LoadConcept(array,argOutMessage,argOutData)
	}
	elseif (strAction = "LOAD_PRIVACY_ELEMENTS")
	{
        ///隐私保护
		d ..GetPrivacyElements(array,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SIGNIMAGE")
	{
		d ..GetSignImage(array,argOutMessage,argOutData)	
	}
	elseif(strAction = "REVOKE_SIGNED_DOCUMENT")
	{
		///失效签名
		d ..RevokeSignedDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_SIGNATURE_LEVELS")
	{
		///获取签名级别信息列表
		d ..GetSignLevels(argOutMessage,argOutData)
	}
	q "1"
	
ERROR			
	//s ^CacheTemp("ERROR")=$zerror 
	d argOutMessage.Write(..#ERROR_",""Err"":"""_$zerror_"""}}")
	d argOutData.Write(..#NONE)	 	        
	q "0"
}

/// Desc:加载索引
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod LoadDocumentIndex(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s status = argArray.GetAt("params").GetAt("status")	
	//d argOutData.CopyFrom(##Class(EMRservice.BL.BLDirectoryInformation).GetDirectoryInformation(instanceID))
	d argOutData.CopyFrom(##Class(web.DHCCM.EMRservice.BL.BLDirectoryInformation).GetDocumentIndex(instanceID,status))
	if (argOutData.Size > 0) 
	{
		d argOutMessage.Write(..#OK_"}}")
	}else
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)			
	}
}

/// d ##Class(EMRservice.BOActionFactory).testLoadDoc1()
ClassMethod testLoadDoc1()
{
	s $zt="err"
    s instanceIDs = ##Class(%ListOfDataTypes).%New()
    d instanceIDs.Insert("30||168")
    s argOutData = ##Class(%GlobalBinaryStream).%New()
    s outMessage = ##Class(%GlobalBinaryStream).%New()
    s status = ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage) 
    w status,!	
    s newstream=##class(%FileCharacterStream).%New()
    s newstream.Filename = "D:\garbage\output.xml"
    //d newstream.TranslateTableSet("UTF8")
	d newstream.CopyFrom(argOutData)
	w newstream.Size
		
	s status = newstream.SaveStream()
	If $$$ISERR(status) Do DecomposeStatus^%apiOBJ(status,.err,"-d") For i=1:1:err Write err(i),! 
	d newstream.%Close()
	w "close",!
	q
err
	w "err:"_$zerror
}

/// Desc:       加载文档
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod LoadDocument(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s instanceIDs = argArray.GetAt("params").GetAt("InstanceID")
    s outMessage = ##Class(%GlobalBinaryStream).%New()
    s status = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage)
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_",""event"":")
		d argOutMessage.CopyFrom(outMessage)
		d argOutMessage.Write("}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_",""status"":"_status_"}}")
		d argOutData.Write(..#NONE)	
	}
}

/// Desc:       取绑定数据
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod LoadDefaultField(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s outMessage = ##Class(%GlobalBinaryStream).%New()
	s listParam = ##Class(%ArrayOfDataTypes).%New()
	s key = ""
	for 
	{
		s ID = argArray.GetAt("params").GetAt("bindparams").GetNext(.key)
		q:(key = "")
	    d listParam.SetAt(ID,key)
	} 
	s objBand = ##Class(EMRservice.BL.BLGetDataBind).%New()
	s count = argArray.GetAt("params").GetAt("items").Count()
    for i=1:1:count
    {
	    s code = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("Code")
	    s bindType = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("BindType")
	    s bindCode = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("BindCode")
	    d:(bindType = "DataBase") objBand.HISBindData.SetAt(bindCode,code)
	    d:(bindType = "EPR") objBand.EPRBindData.SetAt(bindCode,code)
	}
	s result = ##Class(EMRservice.BL.BLGetDataBind).GetDefaultDataBind(objBand,listParam,outMessage)
	s okCount = $p(result,"@",1)
	s failCount = count - okCount
	if (failCount = 0) 
	{
		d argOutMessage.Write("{""params"":{""result"":""OK""},")
	}
	else
	{
		s failure = $p(result,"@",2)
		d argOutMessage.Write("{""params"":{""result"":""OK"",""failCount"":"""_failCount_""",""failure"":"""_failure_"""},")
	}
	d argOutMessage.CopyFrom(outMessage)
	d argOutMessage.Write("}")
	d argOutData.Write(..#NONE)
}

/// Desc:       根据病重加载默认知识库
/// Creator:    Candy
/// CreateDate: 2014-4-25
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod LoadDefaultComposite(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s DiseaseID = argArray.GetAt("params").GetAt("DiseaseID")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	q:((TitleCode ="")&&(DiseaseID = 0)||(DiseaseID = ""))
	s LocID = argArray.GetAt("params").GetAt("UserLocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s count = argArray.GetAt("params").GetAt("items").Count()
	
	s NodeData = ##Class(%GlobalBinaryStream).%New()
	for i=1:1:count
	{
		s BaseNodeID = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("BindKBBaseID")
		s NodeID = ##Class(EMRservice.BL.BLKBNode).GetBindFistNode(BaseNodeID,LocID,DiseaseID,TitleCode,EpisodeID,NodeData)
		if (NodeID '= "")
		{
			d:(i'=1) argOutData.Write("-----------------------------7da4a26140fde")
			d argOutData.Write("{""BindKBBaseID"":"""_BaseNodeID_""",""KBNodeID"":"""_NodeID_"""}$$")
			d argOutData.CopyFrom(NodeData)
			d NodeData.Clear()
		}
	}
	d argOutMessage.Write(..#OK_"}}")
}

/// Desc:       保存索引
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
///            argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod SaveDocumentIndex(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	d ##Class(web.DHCCM.EMRservice.BL.BLDirectoryInformation).SetDirectoryInformation(instanceID,argInData)
	s status = ##Class(web.DHCCM.EMRservice.BL.BLDirectoryInformation).SetDocumentIndex(argInData)
	if (status = "1")
	{ 
	    d argOutMessage.Write(..#OK_"}}")
	}
	else
	{  
	    d argOutMessage.Write(..#ERROR_"}}")
	}
	d argOutData.Write(..#NONE)
}

/// Desc:       保存文档
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
///            argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod SaveDocument(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	s Title = argArray.GetAt("params").GetAt("Title")
	s Title = $zcvt(Title,"I","UTF8")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s DateTime = argArray.GetAt("params").GetAt("HappenDateTime")
	s DateTimeFormat = argArray.GetAt("params").GetAt("DateTimeFormat")
	s DateTime = ##Class(EMRservice.Tools.Tool).DateTimeFormat(DateTime,DateTimeFormat)	
	s SourceType = 	 argArray.GetAt("params").GetAt("SourceType")
	s action = $case(SourceType="Document",1:"reference",:"save")
	s patientId = argArray.GetAt("params").GetAt("PatientID") 
	s episodeId = argArray.GetAt("params").GetAt("EpisodeID")
	s pluginType = argArray.GetAt("params").GetAt("PluginType")
	s chartItemType = argArray.GetAt("params").GetAt("ChartItemType")
	d argOutData.Write(..#NONE)
	Tstart
	s status = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).SaveDoucment(instanceID,userID,argInData,Title,TitleCode,DateTime)
	q:(status '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":"""_status_"""}}") 

	s logStatus = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceID,userID,userID,ipAddress)

    if (logStatus = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_"""}}")
	}
	else
	{	/*
		s event = argArray.GetAt("params").GetAt("event")
		if (event '= "")
		{
			s eventType = argArray.GetAt("params").GetAt("event").GetAt("EventType")
			s eventIds = argArray.GetAt("params").GetAt("event").GetAt("EventID") 
			s result = ##Class(EMRservice.BL.Event.BLEvents).DoEvent(eventType,eventIds,instanceID)
			if (result = "0")
			{
				q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_""",""eventIds"":"""_eventIds_"""}}")
				Trollback
				q
			}
		}
		*/	
		TCOMMIT
		/*
		s instance = ##Class(User.DHCPHInstanceData).%OpenId(instanceID)
		if (instance'="") {
			s template = ##Class(EMRmeta.Template).%OpenId(instance.TemplateID)
			s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,episodeId,instanceID,template.DocumentType,template.ChartItemType,ipAddress)
 	 		q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceID_"""}}")	
 	 	}
 	 	*/ // 生成图片用  注释qunianpeng 2018/3/14
 	 	q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceID_"""}}")	 	
	}
Error
   Trollback
   q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_"""}}")
}

ClassMethod UpdateModelInstance(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s modelID = argArray.GetAt("params").GetAt("ModelID")
	s userID = argArray.GetAt("params").GetAt("UserID")

	d argOutData.Write(..#NONE)
	
	s status = ##Class(EMRservice.BL.ModelInstanceData).UpdateModelDocument(modelID,userID,argInData)
	q:(status '= "1") argOutMessage.Write(..#ERROR_",""ModelID"":"""_modelID_""",""status"":"""_status_"""}}") 
 
 	q argOutMessage.Write(..#OK_",""ModelID"":"""_modelID_"""}}")		 	
	
Error
 	//s ^CacheTemp("UpdateModelInstance")=$zerror
	q argOutMessage.Write(..#ERROR_",""ModelID"":"""_modelID_"""}}")
}

/// Desc:       加载模板
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod LoadTemplate(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s TemplateVersionId = argArray.GetAt("params").GetAt("TemplateVersionId")
    s status = ##Class(EMRservice.BL.BLTemplateVersion).LoadTemplate(argOutData,TemplateVersionId)
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_"}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)	
	}
}

/// Desc:       加载模板
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetmetaTemplateByID(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s TemplateStructureId = argArray.GetAt("params").GetAt("ATemplateStructureId")
    s status = ##Class(EMRservice.BOTemplateStructure).GetmetaTemplateByID(argOutData,TemplateStructureId)
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_"}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)	
	}
}

/// Desc:       保存母板
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod SavemetaTemplateByID(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s TemplateStructureId = argArray.GetAt("params").GetAt("ATemplateStructureId")
    s status = ##Class(EMRservice.BOTemplateStructure).SavemetaTemplateByID(argInData,TemplateStructureId)
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_"}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)	
	}
}

/// Desc:       加载知识库
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod LoadComposite(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s KBNodeID = argArray.GetAt("params").GetAt("KBNodeID")
    s status = ##Class(EMRservice.BL.BLKBNode).LoadComposite(argOutData,KBNodeID)
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_"}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)	
	}
}

/// Desc:       加载病历范例（个人模板）
ClassMethod LoadModelInstance(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s modelID = argArray.GetAt("params").GetAt("ModelID")
    s outMessage = ##Class(%GlobalBinaryStream).%New()
    s status = ##Class(EMRservice.BL.ModelInstanceData).LoadDocument(argOutData,modelID,outMessage) 
	//s ^CacheTemp("LoadModelInstance")=modelID
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_",""event"":")
		d argOutMessage.CopyFrom(outMessage)
		d argOutMessage.Write("}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)	
	}
}

/// Desc:       保存模板
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
///            argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod SaveTemplate(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s TemplateVersionId = argArray.GetAt("params").GetAt("TemplateVersionId")
	s Author = argArray.GetAt("params").GetAt("Author")
	s status = ##Class(EMRservice.BL.BLTemplateVersion).SaveTemplate(argInData,TemplateVersionId,Author)
	if (status = "1")
	{ 
	    d argOutMessage.Write(..#OK_"}}")
	}
	else
	{  
	    d argOutMessage.Write(..#ERROR_"}}")
	}
	d argOutData.Write(..#NONE)
}

/// Desc:      保存知识库
/// Creator:    Candy
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
///            argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod SaveComposite(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s KBNodeID = argArray.GetAt("params").GetAt("KBNodeID")	
	s userID = argArray.GetAt("params").GetAt("Author")	    
	s status = ##Class(EMRservice.BL.BLKBNode).SaveComposite(argInData,KBNodeID,userID)	    
	if (status = "1")
	{ 
	    d argOutMessage.Write(..#OK_"}}")
	}
	else
	{  
	    d argOutMessage.Write(..#ERROR_"}}")
	}
	d argOutData.Write(..#NONE)
}

/// Desc:取标题及配置信息
/// Creator:    Candy
/// CreateDate: 2014-4-1
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod LoadTitleConfig(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s DocID = argArray.GetAt("params").GetAt("DocID")
	s LocID = argArray.GetAt("params").GetAt("UserLocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s SsGroupID = argArray.GetAt("params").GetAt("SsgroupID")
	d argOutData.CopyFrom(##Class(EMRservice.BL.BLTitleConfig).GetTitleConfig(DocID,LocID,EpisodeID,SsGroupID))	    
	if (argOutData.Size > 0)
	{ 
	    d argOutMessage.Write(..#OK_"}}")
	}
	else
	{  
	    d argOutMessage.Write(..#ERROR_"}}")
	}
}

/// Desc:取模板数据
/// Creator:    Candy
/// CreateDate: 2014-4-3
/// Input:      ADocID  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod CreateDocument(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt="Error"
	s DocID = argArray.GetAt("params").GetAt("DocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s PateintID = argArray.GetAt("params").GetAt("PatientID")
	s Title = argArray.GetAt("params").GetAt("Title")
	s Title = $zcvt(Title,"I","UTF8")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s DateTime = argArray.GetAt("params").GetAt("HappenDateTime")
	s DateTimeFormat = argArray.GetAt("params").GetAt("DateTimeFormat")
	s DateTime = ##Class(EMRservice.Tools.Tool).DateTimeFormat(DateTime,DateTimeFormat)
	s InstanceID = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).CreateDocument(DocID,EpisodeID,PateintID,Title,TitleCode,DateTime,argOutData)
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{
		//liuzhongwan 直接令该文档实例继承其模板的权限
		d ##Class(web.DHCCM.EMRservice.Ajax.DirectAppoint).InherTempPriv(InstanceID,EpisodeID)
	    d argOutMessage.Write(..#OK_",""InstanceID"":"""_InstanceID_"""}}")
	}
	else
	{  
	    d argOutMessage.Write(..#ERROR_",""InstanceID"":"""_InstanceID_"""}}")
	}
	q
Error	 
	d argOutMessage.Write(..#ERROR_",""Err"":"""_$zerror_"""}}")
}

/// Desc:取模板数据(绑定测试)
/// Creator:    yejian
/// CreateDate: 2016-1-6
/// Input:      ADocID  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod CreateTestDocument(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s DocID = argArray.GetAt("params").GetAt("DocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s PateintID = argArray.GetAt("params").GetAt("PatientID")
	s Title = argArray.GetAt("params").GetAt("Title")
	s Title = $zcvt(Title,"I","UTF8")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s DateTime = argArray.GetAt("params").GetAt("HappenDateTime")
	s DateTimeFormat = argArray.GetAt("params").GetAt("DateTimeFormat")
	s DateTime = ##Class(EMRservice.Tools.Tool).DateTimeFormat(DateTime,DateTimeFormat)
	s InstanceID = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).CreateTestDocument(DocID,EpisodeID,PateintID,Title,TitleCode,DateTime,argOutData)
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{ 
	    d argOutMessage.Write(..#OK_",""InstanceID"":"""_InstanceID_"""}}")
	}
	else
	{  
	    d argOutMessage.Write(..#ERROR_",""InstanceID"":"""_InstanceID_"""}}")
	}
}

/// Desc:权限信息
/// Creator:    Candy
/// CreateDate: 2014-4-7
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetPrivilege(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s userID = argArray.GetAt("params").GetAt("UserID")
	s userLocID = argArray.GetAt("params").GetAt("UserLocID")
	s ssgroupID = argArray.GetAt("params").GetAt("SsgroupID")
	s patientID = argArray.GetAt("params").GetAt("PatientID")
	s episodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s instanceCount = argArray.GetAt("params").GetAt("InstanceID").Count()
	if (episodeID = "")
	{
		d argOutData.Write(..#NONE)
		d argOutMessage.Write(..#NONE)
		q
	}
	s json = ##Class(%GlobalBinaryStream).%New()
	for i=1:1:instanceCount
	{
		s instanceID = argArray.GetAt("params").GetAt("InstanceID").GetAt(i)
		s privString = "userid^"_userID_"!userloc^"_userLocID_"!ssgroupid^"_ssgroupID_"!admid^"_episodeID_"!patientid^"_patientID_"!instanceid^"_instanceID
		s privRule = ##Class(web.DHCCM.EMRservice.BL.BLPrivRule).ParsePrivRule(privString,"ActionPrivilege")
		continue:(privRule = "")
		d:(i'=1) json.Write(",")
		d json.Write("{")
		d json.Write("""InstanceID"":"""_instanceID)
		d json.Write(""",""canSave"":"""_$p($p(privRule,"!",1),"^",2))
		d json.Write(""",""canPrint"":"""_$p($p(privRule,"!",2),"^",2))
		d json.Write(""",""canDelete"":"""_$p($p(privRule,"!",3),"^",2))
		d json.Write(""",""canCheck"":"""_$p($p(privRule,"!",4),"^",2))
		d json.Write(""",""canReCheck"":"""_$p($p(privRule,"!",5),"^",2))
		d json.Write(""",""canReference"":"""_$p($p(privRule,"!",6),"^",2))
		d json.Write(""",""canExport"":"""_$p($p(privRule,"!",7),"^",2))
		d json.Write(""",""canCopyPaste"":"""_$p($p(privRule,"!",10),"^",2))
		d json.Write(""",""canRevise"":"""_$p($p(privRule,"!",11),"^",2))
		d json.Write(""",""canViewRevise"":"""_$p($p(privRule,"!",12),"^",2))
		d json.Write("""}")
	}

	if (json.Size '= 0)
	{
		d argOutMessage.Write(..#OK_",""privelege"":[")
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("]}}")
	}else
	{
		d argOutMessage.Write(..#ERROR_",""privelege"":[")
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("]}}")
	}
	d argOutData.Write(..#NONE)
}

/// Desc:当前状态
/// Creator:    Candy
/// CreateDate: 2014-4-7
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetCurrentStatus(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s episodeID = argArray.GetAt("params").GetAt("EpisodeID")
	if (episodeID = "")
	{
		d argOutData.Write(..#NONE)
		d argOutMessage.Write(..#NONE)
		q
	}
	s instanceCount = argArray.GetAt("params").GetAt("InstanceID").Count()
	s json = ##Class(%GlobalBinaryStream).%New()
	for i=1:1:instanceCount
	{
		s instanceID = argArray.GetAt("params").GetAt("InstanceID").GetAt(i)
		continue:(instanceID = "")
		s parentId = $p(instanceID,"||",1)
		s emrNum = $p(instanceID,"||",2) 
		s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(parentId)
		continue:(objEcrecord = "")
		s docId = objEcrecord.ChartItemID
		s objEcrecord = ""
		s result = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).GetLogStatus(episodeID,docId,emrNum)
		s signStatus = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).HasRecordSign(episodeID,docId,emrNum)
		d:(i'=1) json.Write(",")
		d json.Write("{")
		d json.Write("""InstanceID"":"""_instanceID)
		d json.Write(""",""Creator"":"""_$zcvt($p(result,"^",1),"O","UTF8"))
		d json.Write(""",""HappenDate"":"""_$zcvt($p(result,"^",2),"O","UTF8"))
		d json.Write(""",""HappenTime"":"""_$zcvt($p(result,"^",3),"O","UTF8"))
		d json.Write(""",""Operator"":"""_$zcvt($p(result,"^",4),"O","UTF8"))
		d json.Write(""",""OperateDate"":"""_$zcvt($p(result,"^",5),"O","UTF8"))
		d json.Write(""",""OperateTime"":"""_$zcvt($p(result,"^",6),"O","UTF8"))
		d json.Write(""",""curIp"":"""_$zcvt($p(result,"^",7),"O","UTF8"))
		d json.Write(""",""curAction"":"""_$zcvt($p(result,"^",8),"O","UTF8"))
		d json.Write(""",""curActionDesc"":"""_$zcvt($p(result,"^",9),"O","UTF8"))
		d json.Write(""",""curStatus"":"""_$zcvt($p(result,"^",10),"O","UTF8"))
		d json.Write(""",""curStatusDesc"":"""_$zcvt($p(result,"^",11),"O","UTF8"))
		d json.Write(""",""signName"":"""_$zcvt($p(result,"^",12),"O","UTF8"))	
		d json.Write(""",""signStatus"":"""_signStatus)
		d json.Write("""}")
	}
	if (json.Size '= 0)
	{
		d argOutMessage.Write(..#OK_",""status"":[")
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("]}}")
	}else
	{
		d argOutMessage.Write(..#ERROR_",""status"":[")
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("]}}")
	}
	d argOutData.Write(..#NONE)
}

/// Desc:       加载字典内容
/// Creator:    Candy
/// CreateDate: 2014-4-28
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod LoadDictionary(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s dicCode = argArray.GetAt("params").GetAt("CodeSystem")
	s queryItem = argArray.GetAt("params").GetAt("QueryItem")
	s queryItem = $zcvt(queryItem,"I","UTF8")
	s pageNumber = argArray.GetAt("params").GetAt("PageNumber")
	s rowCount = argArray.GetAt("params").GetAt("RowCount")
	s countFlag = argArray.GetAt("params").GetAt("CountFlag")
	s pageCount = argArray.GetAt("params").GetAt("PageCount")
	s sessionId = argArray.GetAt("params").GetAt("SessionId")
	s turnPage = argArray.GetAt("params").GetAt("TurnPage")
	
	s defaultFilter = argArray.GetAt("params").GetAt("DefaultFilter")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s userLocID = argArray.GetAt("params").GetAt("UserLocID")
	s ssgroupID = argArray.GetAt("params").GetAt("SsgroupID")
	s patientID = argArray.GetAt("params").GetAt("PatientID")
	s episodeID = argArray.GetAt("params").GetAt("EpisodeID")
	
	s ConditionCode =##Class(EMRservice.BL.BLStdDictionary).SelectConditionByStdCode(dicCode)
	s Condition = argArray.GetAt("params").GetAt("Condition")
	//如果没有查询条件并且允许带内置默认条件，则检查字典是否设置查询条件关键字
	if ((Condition="") && (defaultFilter="true"))
	{	    
	    s ConditionKeyWord =##Class(EMRservice.BL.BLStdDictionary).getConditionByStdCode(dicCode)
	    if (ConditionKeyWord="{CTLocID}")
	    {
		    s Condition=userLocID
	    }
	    elseif (ConditionKeyWord="{UserID}")
	    {
		    s Condition=userID
	    }
	    elseif (ConditionKeyWord="{PatientID}")
	    {
		    s Condition=patientID
	    }
	    elseif (ConditionKeyWord="{EpisodeID}")
	    {
		    s Condition=episodeID
	    }
	    elseif (ConditionKeyWord="{SsgroupID}")
	    {
		    s Condition=ssgroupID
	    }
	}
	
	
	s tmpData = ##Class(EMRservice.BL.BLStdDictionary).GetStdDicXML(dicCode,queryItem,pageNumber,rowCount,countFlag,pageCount,sessionId,turnPage,ConditionCode,Condition)
	d argOutData.CopyFrom(tmpData)
	d argOutMessage.Write(..#OK_"}}")
}

/// Desc:       病历签名
/// Creator:    Candy
/// CreateDate: 2014-7-16
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod SaveSignDocument(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")	
	s signLevel = argArray.GetAt("params").GetAt("SignLevel")
	s signUserID = argArray.GetAt("params").GetAt("SignUserID")
	s signID = argArray.GetAt("params").GetAt("SignID")
	s patientId = argArray.GetAt("params").GetAt("PatientID") 
	s pluginType = argArray.GetAt("params").GetAt("PluginType")
	s chartItemType = argArray.GetAt("params").GetAt("ChartItemType")
	s digest = argArray.GetAt("params").GetAt("Digest") 
	s type = argArray.GetAt("params").GetAt("Type") 
	s path = argArray.GetAt("params").GetAt("Path")
	s actionType = argArray.GetAt("params").GetAt("ActionType") 
	d argOutData.Write(..#NONE)
	Tstart	
	s status = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).SaveDoucment(instanceID,userID,argInData,"","","")
	q:(status '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":"""_status_"""}}")
	s action = ##Class(EMRservice.BL.BLSignRole).GetSignCode(signLevel)
	q:(action = "") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""action"":"""_action_"""}}")	
	s signStatus = ##Class(web.DHCCM.EMRservice.BL.BLEMRSign).SetMERSign(episodeID,instanceID,signUserID,signID,action,digest,type,argInData,path,actionType)
	if ($p(signStatus,"^",1) '= "1")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""signStatus"":"""_signStatus_"""}}")
	}   
    s EMRSignId = $p(signStatus,"^",2)
	s logStatus = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceID,userID,signUserID,ipAddress,EMRSignId)
	if (logStatus = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_"""}}")
	}
	TCOMMIT
	//s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,episodeID,instanceID,pluginType,chartItemType,ipAddress)
	// qunianpeng 2018/3/29 报错  解决办法:复制EMRservice.BL.BLExportQueue,处理 ?? 注释???
 	q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceID_"""}}")
 	
Error
	
   Trollback
   q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""Err"":"""_$zerror_"""}}")
}

/// Desc:       将删除的文档放进回收站
/// Creator:    Candy
/// CreateDate: 2014-8-15
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据     
ClassMethod DeleteDocument(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"	
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	Tstart
	s indexStatus = ##Class(web.DHCCM.EMRservice.BL.BLDirectoryInformation).SetDirectoryInformation(instanceID,argInData)
	q:(indexStatus '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""indexStatus"":"""_indexStatus_"""}}")
	s docStatus = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).DeleteDocument(instanceID,userID)
	if (docStatus '= "1")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""docStatus"":"""_docStatus_"""}}")
	}
	s logStatus = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).AddOperateLog("delete",instanceID,userID,userID,ipAddress)
	if (logStatus = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_"""}}")	
	}
	TCOMMIT
 	q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceID_"""}}")	
Error
   Trollback
   q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""Err"":"""_$zerror_"""}}")
}

/// Desc:		插件获取系统参数
/// Creator:    yejian
/// CreateDate: 2014-11-12
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    #NONE
/// 
ClassMethod GetSysOptions(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s jsons = ""
	s json = ""

	d argOutData.Write(..#NONE)
	s strkey = ""
	for
	{
		s strkey = $o(^DHCEMRM.SysOptionI("NameIndex",strkey))
		q:(strkey = "")	
		s id = ""
		s id=$o(^DHCEMRM.SysOptionI("NameIndex",strkey,id))
		continue:(""=id)
		s obj=##Class(EMRmeta.SysOption).%OpenId(id)
		if ((obj.IsEditor="True")||(obj.IsEditor="TRUE"))
		{
			s strValue = obj.OptionValue
			continue:(""=strValue)
			s strkeys = $REPLACE(strkey," ","")
			s strValue = $zcvt(strValue,"O","UTF8")
			if ($l(json)>0)
			{	
				s json = json_","
			}
			s json = json_""""_strkeys_""":"""_strValue_""""
		}
	}
	s jsons = "{"_json_"}"
	
	d argOutMessage.Write(jsons)
}

/// Desc:       引用既往病历创建新病历
/// Creator:    Candy
/// CreateDate: 2015-1-20
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据  
ClassMethod QuotationDocumnet(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s pInstanceId = argArray.GetAt("params").GetAt("InstanceID")
	s dataTime = ""
	s title = ""
	s titleCode = ""
	s InstanceIds = ##Class(%ListOfDataTypes).%New()
	d InstanceIds.Insert(pInstanceId) 
	s outMessage = ##Class(%GlobalBinaryStream).%New()
	s status = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).LoadDocument(argOutData,InstanceIds,outMessage)
	q:(status = "-1") 
	s InstanceID = ##Class(web.DHCCM.EMRservice.BL.BLQuotation).QuotationDocument(EpisodeID,pInstanceId,dataTime,title,titleCode)	
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{ 
	    q argOutMessage.Write(..#OK_",""InstanceID"":"""_InstanceID_"""}}")
	}
	else
	{  
	    q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_InstanceID_"""}}")
	}
Error
   Trollback
   q argOutMessage.Write(..#ERROR_"}}")
}

/// Desc:打印文档    
/// CreateDate: 2015-4-29
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod PrintDocument(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s actionType = "print"
	s userId = argArray.GetAt("params").GetAt("UserID")
	s ip = argArray.GetAt("params").GetAt("IPAddress")
	d argOutData.Write(..#NONE)
	s total = argArray.GetAt("params").GetAt("items").Count()
	s outStatus = 1
	s outContent = ""
    for i=1:1:total
	{	
		s instanceID = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("InstanceID")
		continue:(instanceID = "")
		s StartPageNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("StartPageNum")
		s StartRowNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("StartRowNum")
		s EndPageNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("EndPageNum")
		s EndRowNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("EndRowNum")
		s $zt = "Error"
		Tstart
		s printStatus =  ##Class(web.DHCCM.EMRservice.BL.PrintRecord).CreatePrintRecord(instanceID,StartPageNum,StartRowNum,EndPageNum,EndRowNum)
		s:(printStatus = "0") outStatus = 0
		q:(printStatus = "0")
		s logStatus =  ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).AddOperateLog(actionType,instanceID,userId,userId,ip)
	    if (logStatus = "0")
	    {
		    Trollback
		    s outStatus = 0
		    q
		}else
		{
			TCOMMIT
			s:(i '= 1) outContent = outContent_","
			s outContent = outContent_instanceID
		}
	}
	if (outStatus = 1)
	{
		d argOutMessage.Write(..#OK_",""InstanceID"":"""_outContent_"""}}")
	}
	else
	{
		d argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_"""}}")
	}
	q
Error
   Trollback
   q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_"""}}")
}

/// 保存个人模板
ClassMethod SaveModelDocument(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s Title = argArray.GetAt("params").GetAt("newTitle")
	s ModelInsCategoryID = argArray.GetAt("params").GetAt("ModelInsCategoryID")
	s Title = $zcvt(Title,"I","UTF8")
	d argOutData.Write(..#NONE)

	s status = ##Class(web.DHCCM.EMRservice.BL.ModelInstanceData).SaveModelDocument(instanceID,userID,argInData,Title, ModelInsCategoryID)
	q:(status '= "1") argOutMessage.Write(..#ERROR_",""status"":"""_status_"""}}") 
	q argOutMessage.Write(..#OK_"}}")
	
Error
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

/// 个人模板引用
ClassMethod QuotationModelDocumnet(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"	
	s PatientID = argArray.GetAt("params").GetAt("PatientID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s ModelID = argArray.GetAt("params").GetAt("ModelID")
	
	s status = ##Class(web.DHCCM.EMRservice.BL.ModelInstanceData).LoadDocument(argOutData,ModelID,argOutMessage)
	//s ^CacheTemp("QuotationModelDocumnet")=argOutData
	q:(status = "-1") argOutMessage.Write(..#OK_",""status"":""-1""}}")
	s dataTime="",title="",titleCode=""
	s InstanceID = ##Class(web.DHCCM.EMRservice.BL.ModelInstanceData).QuotationDocument(PatientID, EpisodeID,ModelID,dataTime,title,titleCode)	
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{ 
	    q argOutMessage.Write(..#OK_",""InstanceID"":"""_InstanceID_"""}}")
	}
	else
	{  
	    q argOutMessage.Write(..#ERROR_",""Error"":"""_InstanceID_"""}}")
	}
	
Error
   Trollback
   q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

/// Desc:       通过ID获取医学概念xml结构流
/// Creator:    yejian
/// CreateDate: 2015-8-13
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod LoadConcept(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s strConceptID = argArray.GetAt("params").GetAt("ConceptID")
    s strMedCode = argArray.GetAt("params").GetAt("MedCode")
    s status =##Class(EMRservice.BOMedicalConceptValues).GetStreamByID(strConceptID,strMedCode,.argOutData)
	
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_"}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)	
	}
}

/// Desc:隐私项集合
/// Creator: candy
/// CreateDate: 2015-10-26
ClassMethod GetPrivacyElements(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s InstanceId = argArray.GetAt("params").GetAt("InstanceID")
	s ssgroupId = argArray.GetAt("params").GetAt("SSgroupID")
	s operation = argArray.GetAt("params").GetAt("Operation")
	s result = ##class(web.DHCCM.EMRservice.BL.PrivacyProtection).PrivateDomains(InstanceId,ssgroupId,operation)

	d argOutMessage.Write(..#OK_"},""items"":[")
	d argOutMessage.CopyFrom(result)
    d argOutMessage.Write("]}")
	d argOutData.Write(..#NONE)	
	q
Error
    q argOutMessage.Write(..#ERROR_"}}")
}

/// Desc：      取签名图片
/// Creator:    Candyxu
/// CreateDate: 2016-4-7
ClassMethod GetSignImage(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s userId = argArray.GetAt("params").GetAt("UserID")
	s result = ##Class(web.DHCCM.EMRservice.BL.BLEMRSign).GetSignImage(userId)
	d argOutMessage.Write(..#OK_"},""Image"":"""_result_"""}")
	d argOutData.Write(..#NONE)	
	q
Error
    q argOutMessage.Write(..#ERROR_"}}")
}

/// Desc:失效签名
/// Creator:    Candyxu
/// CreateDate: 2016-7-26
ClassMethod RevokeSignedDocument(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s result = "1"
	s episodeId = argArray.GetAt("params").GetAt("EpisodeID")
	s instanceId = argArray.GetAt("params").GetAt("InstanceID")
	s userId = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	s action = "save"
	s count = argArray.GetAt("params").GetAt("Authenticator").Count()
	Tstart
	s status = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).SaveDoucment(instanceId,userId,argInData,"","","")
	q:(status '= 1) argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""SaveStatus"":"""_status_"""}}")
	
    s logStatus = ##Class(web.DHCCM.EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceId,userId,userId,ipAddress)
    if (logStatus = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""logStatus"":"""_logStatus_"""}}")
	}
	for i=1:1:count
	{
		s id = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("Id")
		s name = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("Name")
		s signLevel = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("SignatureLevel")
		s signLevel = ##Class(EMRservice.BL.BLSignRole).GetSignCode(signLevel)
		s path = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("Path")	
		s signStatus = ##Class(web.DHCCM.EMRservice.BL.BLEMRSign).RevokeSign(episodeId,instanceId,id,signLevel,path)
		if ($p(signStatus,"^",1) '= "1")
		{
			s result = "0"
			q
		}   
	}
	if (result ="1")
	{
		TCommit
		q argOutMessage.Write(..#OK_"}}")
	}
	else
	{
		TRollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""signStatus"":"""_signStatus_"""}}")
	}
	d argOutData.Write(..#NONE)	
	q
Error
    q argOutMessage.Write(..#ERROR_"}}")
}

/// Desc:取签名级别
ClassMethod GetSignLevels(ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	d argOutData.Write(..#NONE)	
	s result = ##Class(EMRservice.BL.BLSignRole).GetAllSignRole()
	q argOutMessage.Write(..#OK_"},""items"":"_result_"}")
Error
    q argOutMessage.Write(..#ERROR_"}}")
}

/// debugger:  d ##Class(web.DHCCM.EMRservice.BOActionFactory).test()
ClassMethod test()
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "d:\22.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    //s argInData.Filename="d:\33.xml"
	s argOutMessage = ##class(%FileBinaryStream).%New() 
	s argOutData = ##class(%FileBinaryStream).%New()
	d ..AcitonProxy(Stream,argInData,argOutMessage,argOutData)

	//d argOutData.OutputToDevice()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\SAVE_DOCUMENT1.xml"
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

Storage Default
{
<Data name="BOActionFactoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCMC271.BOActionFac5FD3D</DataLocation>
<DefaultData>BOActionFactoryDefaultData</DefaultData>
<IdLocation>^web.DHCCMC271.BOActionFac5FD3D</IdLocation>
<IndexLocation>^web.DHCCMC271.BOActionFac5FD3I</IndexLocation>
<StreamLocation>^web.DHCCMC271.BOActionFac5FD3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
