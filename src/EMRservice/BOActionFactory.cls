/// 名称:EMRservice.BOActionFactory
/// 描述:交互命令工厂
/// 编写者：Guozongtao
/// 编写日期: 2013-12-25
Class EMRservice.BOActionFactory Extends %RegisteredObject
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
/// Debug:         w ##Class(EMRservice.BOActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInMessageArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//定义错误处理函数
	s $ZT="ERROR"
	s array = argInMessageArray
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
	elseif(strAction = "LOAD_DEFAULT_SECTION")  
	{
		s tmp = array.GetAt("params").GetAt("UserTemplateCode")
		s aType = $p($g(tmp),"^",1)
		if (aType = "LoadExample")
		{
			s exampleInstanceID = $p($g(tmp),"^",2)
			d array.GetAt("params").SetAt(exampleInstanceID,"UserTemplateCode")
			d ..LoadExampleSecionByExampleID(array,argOutMessage,argOutData)
		}else{
			//取关联的章节集合
			d ..LoadDefaultSecion(array,argOutMessage,argOutData)
		}
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
		s aType = array.GetAt("params").GetAt("actionType")
		if (aType = "LoadExample")
		{
			s templateVersionId = ##Class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(array.GetAt("params").GetAt("TemplateVersionId"))
			d array.GetAt("params").SetAt(templateVersionId,"TemplateVersionId")
			d ..LoadTemplate(array,argOutMessage,argOutData)
		}else{
			//加载模板
			d ..LoadTemplate(array,argOutMessage,argOutData)
		}
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
        s aType = array.GetAt("params").GetAt("Type")
        //加载科室短语
        if (aType = "DP")
        {
            d ..LoadDPComposite(array,argOutMessage,argOutData)
        }
        else
        {
            //加载知识库
            d ..LoadComposite(array,argOutMessage,argOutData)
        } 
	}
	elseif (strAction = "LOAD_MODEL_INSTANCE")       
	{
		//加载知识库
		d ..LoadModelInstance(array,argOutMessage,argOutData)
	}	
	elseif (strAction = "SAVE_TEMPLATE")         
	{
		//保存模板
		d ..SaveTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_USER_TEMPLATE")         
	{
		//保存用户模板
		d ..SaveUserTemplate(array,argInData,argOutMessage,argOutData)
	}
	elseif (strAction = "SAVE_COMPOSITE")        
	{
        s aType = array.GetAt("params").GetAt("Type")
        //加载科室短语
        if (aType = "DP")
        {
            d ..SaveDPComposite(array,argInData,argOutMessage,argOutData)
        }
        else
        {
            //保存知识库
            d ..SaveComposite(array,argInData,argOutMessage,argOutData)
        }
	}
	elseif (strAction = "SAVE_SECTION")        
	{
		//保存用户模板章节
		d ..SaveUserSection(array,argInData,argOutMessage,argOutData)
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
		s action = array.GetAt("params").GetAt("CreateMode")
		if (action = "Model")
		{
			//个人模板引用
			d ..QuotationModelDocumnet(array,argOutMessage,argOutData)
		}
		elseif (action = "ReplaceSection")
		{
			//通过范例创建(组合章节模式)
			d ..CreateDocumentByExample(array,argOutMessage,argOutData)
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
	elseif(strAction = "CLOSE_DICTIONARY_SESSION")
	{
		///清理字典后台临时global
		d ..CloseDictionarySession(array,argOutMessage,argOutData)
	}
	elseif(strAction = "REVOKE_SIGNED_ELEMENT")
	{
		///撤销签名
		d ..RevokeSignedElement(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "GET_SERVER_TIME")
	{
		d ..GetServiceDateTime(array,argOutMessage)
	}
	elseif(strAction = "QUERY_FIELD_BY_PARAM")
	{
		//lua脚本
		d ##Class(EMRservice.BL.BLLuaScriptService).DoLuaScript(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_SPECAIL_DOCUMENT")
	{
		d ..SaveSpecailDocument(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_IMG")
	{
		///加载图库
		d ..LoadIMG(array,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_INSTANCE_SECTION")
	{
		d ..SaveExampleSection(array,argInData,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_INSTANCE_SECTION")
	{
		d ..LoadExampleSecion(array,argOutMessage,argOutData)
	}
	elseif (strAction = "REQUEST_EMRCDA_ASSISTDATA")
	{
		//请求电子病历CDA相关辅助数据
		s action = array.GetAt("params").GetAt("execute").GetAt("action")
		
		if (action = "REQUEST_EMRDOC_AUTHOR")
		{
			//请求电子病历CDA相关辅助数据
			d ..GetAuthorMessage(array,argOutMessage,argOutData)
		}
		elseif (action = "REQUEST_EMRDOC_CUSTODIAN")
		{
			//获取文档保管机构信息
			d ..GetCustodianMessage(array,argOutMessage,argOutData)
		}
		elseif (action = "REQUEST_EMRDOC_SIGN")
		{
			//获取对应医师签名时间列表
			d ..GetSignMessage(array,argOutMessage,argOutData)
		}
        elseif (action = "REQUEST_CROSSTOOTH_DISPLAYNAME")
		{
			//获取十字牙位图编码描述信息
			s ToothCode = array.GetAt("params").GetAt("execute").GetAt("ToothCode")
			d ##Class(EMRservice.BL.BLEMRCDAAssistData).GetToothPositionByCode(ToothCode,argOutMessage,argOutData)
		}
	}
	elseif (strAction = "CREATE_PERSONAL_TEMPLATE")
	{
		//门诊个人模板创建
		d ..CreatePersonalTemplate(array,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_DEFAULT_PERSONAL_SECTION")  
	{
		//门诊个人模板获取关联的章节集合
        d ..LoadDefaultPersonalSecion(array,argOutMessage,argOutData)
	}
	elseif(strAction = "LOAD_PERSONAL_TEMPLATE")  
	{
		//门诊个人模板加载文档(用于前端修改个人模板)
		d ..LoadPersonalTemplate(array,argOutMessage,argOutData)
	}
	elseif(strAction = "SAVE_PERSONAL_SECTION")
	{
		//门诊个人模板保存章节数据
		d ..SavePersonalSection(array,argInData,argOutMessage,argOutData)
	}
		elseif(strAction = "LOAD_HEADER_IMG")
	{
		//获取页眉LOGO图片数据
		d ..GetHeaderImage(array,argInData,argOutMessage,argOutData)
	}
	q "1"
	
ERROR			
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
	s type = argArray.GetAt("params").GetAt("LoadType")	
	if (type = "patient")
	{
		s patientId = argArray.GetAt("params").GetAt("PatientID")
		s locId = argArray.GetAt("params").GetAt("LocID")
		d argOutData.CopyFrom(##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndexByPatiendID(patientId,locId))
	}
	elseif (type = "episode")
	{
		s episodeId = argArray.GetAt("params").GetAt("EpisodeID")
		
		d argOutData.CopyFrom(##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndexByEpisodeID(episodeId))
	}elseif (type = "CategoryBrowse")
    {
        s instanceId = argArray.GetAt("params").GetAt("InstanceID")
        s episodeIds = argArray.GetAt("params").GetAt("EpisodeIDs")
        s docId = argArray.GetAt("params").GetAt("DocID")
        d argOutData.CopyFrom(##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndexByEpisodeIDs(instanceId,episodeIds,docId))
    }
	else
	{
		s instanceID = argArray.GetAt("params").GetAt("InstanceID")
		s status = argArray.GetAt("params").GetAt("status")	
        //判断是否单独加载某一病程用以单独打印
        s isloadone = argArray.GetAt("params").GetAt("isLoadOne")
        // LoadDocMode为加载文档模式ALL(全部)/BATCH(分批)/APPEND(追加)
        s loadDocMode = argArray.GetAt("params").GetAt("LoadDocMode")
        // LoadDocMode为APEEND时追加病历的方向UP/DOWN
        s loadDirection = argArray.GetAt("params").GetAt("LoadDirection")
        // DateTime为按病程数量分段加载的标识,若为空则取InstanceID的HappenDate和HappenTime字段
        s dateTime = argArray.GetAt("params").GetAt("DateTime")
        // 用户登录科室ID，病历浏览状态，需要根据根据登录科室判断是否过滤浏览病历
        s UserLocID =argArray.GetAt("params").GetAt("UserLocID")
		d argOutData.CopyFrom(##Class(EMRservice.BL.BLDirectoryInformation).GetDocumentIndex(instanceID,status,isloadone,loadDocMode,loadDirection,dateTime,UserLocID))
	}
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
    s type = argArray.GetAt("params").GetAt("LoadType") 
    if ($zcvt(type,"U") = "PDF")
    {
        s status = ##Class(EMRservice.BL.BLPDFAuditSignLog).LoadDocument(argOutData,instanceIDs,outMessage)
    }
    else
    {
        s status = ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,instanceIDs,outMessage)
    }
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_",""event"":")
		d argOutMessage.CopyFrom(outMessage)
		d argOutMessage.Write("}}")
	} 
	else 
	{
		if ($zcvt(type,"U") = "PDF")
        {
            d argOutMessage.Write(..#ERROR_",""status"":"_status_",""errorInfo"":")
            d argOutMessage.CopyFrom(outMessage)
            d argOutMessage.Write("}}")
        }
        else
        {
            d argOutMessage.Write(..#ERROR_",""status"":"_status_"}}")
        }
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
	    d:(bindType = "Method") objBand.HISMethodData.SetAt(bindCode,code)
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
	s LocID = argArray.GetAt("params").GetAt("UserLocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s count = argArray.GetAt("params").GetAt("items").Count()
	
	//根据关联的KBNODEID加载最新的知识库数据 
	s SectionLoadKBNode = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("SectionLoadKBNode","N")
	if (SectionLoadKBNode="Y")
	{
		s NodeData = ##Class(%GlobalBinaryStream).%New()
		for i=1:1:count
		{
			s BaseNodeID = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("BindKBBaseID")
			//获取KBNodeID
			s NodeID = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("KBNodeID")
			//兼容以前病种方式，如果有KBNodeID走新的替换方式，如果没有走以前病种默认加载第一个有权限知识库
			if (NodeID="")
			{
				s NodeID = ##Class(EMRservice.BL.BLKBNode).GetBindFistNode(BaseNodeID,LocID,DiseaseID,TitleCode,EpisodeID,NodeData)
				if (NodeID '= "")
				{
					d:(i'=1) argOutData.Write("-----------------------------7da4a26140fde")
					d argOutData.Write("{""BindKBBaseID"":"""_BaseNodeID_""",""KBNodeID"":"""_NodeID_"""}$$")
					d argOutData.CopyFrom(NodeData)
					d NodeData.Clear()
				}	
			}
			else
			{
				s res = ##Class(EMRservice.BL.BLKBNode).GetNodeXML(NodeID,NodeData)
				if (res '= "")
				{
					d:(i'=1) argOutData.Write("-----------------------------7da4a26140fde")
					d argOutData.Write("{""BindKBBaseID"":"""_BaseNodeID_""",""KBNodeID"":"""_NodeID_"""}$$")
					d argOutData.CopyFrom(NodeData)
					d NodeData.Clear()
				}
			}
		}
	}
	d argOutMessage.Write(..#OK_"}}")
}

/// Desc:       获取模板章节集合
/// Creator:    yejian
/// CreateDate: 2017-11-30
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod LoadDefaultSecion(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s DiseaseID = argArray.GetAt("params").GetAt("DiseaseID")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s LocID = argArray.GetAt("params").GetAt("UserLocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	;s count = argArray.GetAt("params").GetAt("items").Count()
	s userTemplateCode = argArray.GetAt("params").GetAt("UserTemplateCode")
	if (userTemplateCode '= "")
	{
		d ##Class(EMRservice.BL.BLUserTemplateSection).GetBindSection(userTemplateCode,TitleCode,argOutData)
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
	d ##Class(EMRservice.BL.BLDirectoryInformation).SetDirectoryInformation(instanceID,argInData)
	s status = ##Class(EMRservice.BL.BLDirectoryInformation).SetDocumentIndex(instanceID,argInData)
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
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	s Title = argArray.GetAt("params").GetAt("Title")
	s Title = $zcvt(Title,"I","UTF8")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s DateTime = argArray.GetAt("params").GetAt("HappenDateTime")
	s SourceType = 	 argArray.GetAt("params").GetAt("SourceType")
	s action = $case(SourceType="Document",1:"reference",:"save")
	s patientId = argArray.GetAt("params").GetAt("PatientID") 
	s episodeId = argArray.GetAt("params").GetAt("EpisodeID")
	s SsGroupID = argArray.GetAt("params").GetAt("SsgroupID")
	s userLocId = argArray.GetAt("params").GetAt("UserLocID")
	s LastOperateDate = argArray.GetAt("params").GetAt("POperateDate")
	s LastOperateTime = argArray.GetAt("params").GetAt("POperateTime")
	
	//从其它产品组操作病历
	s productSourceType = argArray.GetAt("params").GetAt("ProductSourceType")
	s:(productSourceType = "") productSourceType = "EMR"
	s productSourceCode = argArray.GetAt("params").GetAt("ProductSourceCode")
		
	d argOutData.Write(..#NONE)
	
	//压缩标记2022-04-19
	s IsCompressDocument = argArray.GetAt("params").GetAt("CompressDocument")
	s IsCompressDocument = $zcvt(IsCompressDocument,"U")
	
	
    //增加串病历校验
    s realEpisodeId = ##class(EMRservice.Ajax.opInterface).getAdmByInstanceID(instanceID)
    //接口获取结核病就诊列表(按照就诊时间升序)就诊号串,以","分隔
    s episodeIDs = ##class(EMRservice.BL.opInterface).getPhthisisRecordAdm(episodeId)
    s flag = "0"
    s length = $l(episodeIDs,",")
    for i=1:1:length
    {
        s tempEpisodeID = $p(episodeIDs,",",i)
        continue:(tempEpisodeID = "")
        s:(realEpisodeId = tempEpisodeID) flag = "1"
        q:(flag = "1")
    }
    q:((flag = "0")&&(realEpisodeId '= episodeId)) argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""EpisodeID"":"""_episodeId_""",""desc"":"""_$ZCONVERT("当前保存病历可能不属于当前患者,会出现病历数据错乱问题，请重新打开病历页面进行编辑保存","O","UTF8")_"""}}")
    
	if (##Class(EMRservice.SystemParameter).IsEnableMultiEditSaveCheck() = "Y")
	{
		s saveStatus = ##Class(EMRservice.BL.BLInstanceData).CheckSaveStatus(instanceID,LastOperateDate,LastOperateTime)
		q:($p(saveStatus,"^",1) '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":"""_$p(saveStatus,"^",1)_""",""desc"":"""_$ZCONVERT($p(saveStatus,"^",2),"O","UTF8")_"""}}")  
	}
	
	s $zt = "SaveDocError"  
	Tstart	
	s status = ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(instanceID,userID,argInData,Title,TitleCode,DateTime,IsCompressDocument)
	if (status '= "1") 
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":"""_$p(status,"^",1)_""",""desc"":"""_$ZCONVERT($p(status,"^",2),"O","UTF8")_"""}}") 
    }
	
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceID,userID,userID,ipAddress,"",userLocId,productSourceType)
    if ($p(logStatus,"^",1) = "0")
	{
		Trollback
		s:($f(logStatus,"IdxForLink")>=0) logStatus = "IdxForLink"
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_""",""status"":""0"",""desc"":"""_$ZCONVERT("患者此病历时间在库中已存在,请修改病历时间","O","UTF8")_"""}}")
	}
	else
	{
		s event = argArray.GetAt("params").GetAt("event")
		if (event '= "")
		{
			s eventType = argArray.GetAt("params").GetAt("event").GetAt("EventType")
			s eventIds = argArray.GetAt("params").GetAt("event").GetAt("EventID") 
			if (eventIds '= ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkEventIDByInstanceID(instanceID,eventType))
			{
				s deleteFlag = ##class(EMRservice.BL.Event.BLLinkDocument).DeleteData(instanceID,userID)
			}
			s result = ##Class(EMRservice.BL.Event.BLEvents).DoEvent(eventType,eventIds,instanceID,userID)
			if (result = "0")
			{
				Trollback
				q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_""",""eventIds"":"""_eventIds_""",""status"":""0"",""desc"":"""_$ZCONVERT("保存失败","O","UTF8")_"""}}")
			}
		}	
		TCOMMIT
		
		s $ztrap = "SavedOtherError"
		
		//是否启用独立保存留痕文档
		if (##Class(EMRservice.SystemParameter).IsSaveRevisionDocument() = "True")
		{
			s revisionLogStatus = ##Class(EMRservice.BL.RevisionLog).SaveRevisionLogNew(instanceID,argInData,IsCompressDocument)
			if ($p(revisionLogStatus,":",1) = "-1")
			{
				//移除到事务外部，不需要回滚代码
				//Trollback
				q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""revisionLogStatus"":"""_$p(revisionLogStatus,":",1)_""",""desc"":"""_$ZCONVERT($p(revisionLogStatus,":",2),"O","UTF8")_"""}}") 
			}
		}
		
		s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,episodeId,instanceID,ipAddress)
 		
 		//注册首页数据推送队列
		d ##Class(EMRservice.BL.BLAdmTaskQueue).RegTaskFP(instanceID)
		
		//提供给医生站接口，返回最新修改过病历的附属账号
		//d ##Class(EMRservice.BL.BLEMRLogs).SetInternToDocStation(SsGroupID,episodeId,userID) 
		
		//调接口，设置门诊初诊复诊类型
		d ##Class(EMRservice.HISInterface.OutPatientType).GetOPType(episodeId,instanceID)

		s aType = argArray.GetAt("params").GetAt("type")
		
		//通过工具批量创建门诊病历
		if (aType = "ISTOOLCREATE")
		{
			s DateTime = argArray.GetAt("params").GetAt("SaveDateTime")
			d ##Class(EMRservice.BL.BLInstanceLinkTool).SetData(DateTime,episodeId,instanceID,userID)
		}
		if ((productSourceType '= "")&&(productSourceType '= "EMR"))
	    {
		    d ##class(EMRservice.BL.Event.BLEvents).SetData(productSourceType,productSourceCode,instanceID,userID)
	    }
		
		s userFrequencyFlag = ##Class(EMRservice.BL.BLInstanceUserTemplate).ChangeStatus(userID,instanceID)
		s personalFrequencyFlag = ##Class(EMRservice.BL.BLInstancePersonalTemplate).ChangeStatus(userID,instanceID)

		// 非就诊当日修改门诊电子病历后，调用科研病历组大数据待数据采集列表接口
		d ##Class(EMRservice.HISInterface.CollectDataInterface).CollectDataBySave(episodeId)

 		q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceID_"""}}")		 	
	}
SaveDocError
   	Trollback
   	q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":""0"",""desc"":"""_$ZCONVERT("保存失败","O","UTF8")_"""}}")

SavedOtherError
	q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":""0"",""desc"":"""_$ZCONVERT("保存后调用其它接口报错","O","UTF8")_"""}}")
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
	s UserTemplateId = argArray.GetAt("params").GetAt("UserTemplateId")
    s TemplateVersionId = argArray.GetAt("params").GetAt("TemplateVersionId")
    s status =""
    if (UserTemplateId="")
    {
	    s status = ##Class(EMRservice.BL.BLTemplateVersion).LoadTemplate(argOutData,TemplateVersionId)
    }
    else
    {
	    s status = ##Class(EMRservice.BL.BLUserTemplate).LoadUserTemplate(argOutData,UserTemplateId)
    }
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
    //章节关联知识库节点时，对知识库内kbnodeid不对的单独处理
    s bReferenceKBNode = argArray.GetAt("params").GetAt("bReferenceKBNode")
    s status ="1"
    if (bReferenceKBNode="True")
    {
	    s status = ##Class(EMRservice.BL.BLKBNode).LoadCompositeReKBNodeID(argOutData,KBNodeID)
    }
    else
    {
    	s status = ##Class(EMRservice.BL.BLKBNode).LoadComposite(argOutData,KBNodeID)
    }
	if (status = "1")
	{ 
		d argOutMessage.Write(..#OK_"}}")
	} 
	else 
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)	
	}
	q
}

/// Desc:       加载病历范例（个人模板）
ClassMethod LoadModelInstance(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s modelID = argArray.GetAt("params").GetAt("ModelID")
    s outMessage = ##Class(%GlobalBinaryStream).%New()
    s status = ##Class(EMRservice.BL.ModelInstanceData).LoadDocument(argOutData,modelID,outMessage) 

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

/// Desc:       保存用户模板
/// Creator:    yejian
/// CreateDate: 2014-3-12
/// Input:      argArray  命令参数
///            argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod SaveUserTemplate(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s UserTemplateId = argArray.GetAt("params").GetAt("UserTemplateId")
	s Author = argArray.GetAt("params").GetAt("Author")
	s status = ##Class(EMRservice.BL.BLUserTemplate).SaveUserTemplate(argInData,UserTemplateId,Author)
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
	s status = 0
	
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

/// Desc:      保存知识库
/// Creator:    yejian
/// CreateDate: 2017-11-30
/// Input:      argArray  命令参数
///            argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod SaveUserSection(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s status = 0
	s UserTemplateID = argArray.GetAt("params").GetAt("UserTemplateID")
	s BindKBBaseID = argArray.GetAt("params").GetAt("BindKBBaseID")	 	  
	s SectionCode = argArray.GetAt("params").GetAt("SectionCode")
	s status = ##Class(EMRservice.BL.BLUserTemplateSection).SaveUserSection(argInData,UserTemplateID,SectionCode,BindKBBaseID)	 
	
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
ClassMethod CreateDocument(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt="Error"
	s DocID = argArray.GetAt("params").GetAt("DocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s PateintID = argArray.GetAt("params").GetAt("PatientID")
	s Title = argArray.GetAt("params").GetAt("Title")
	s Title = $zcvt(Title,"I","UTF8")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s DateTime = argArray.GetAt("params").GetAt("HappenDateTime")
	s isStream = argArray.GetAt("params").GetAt("IsStream")
	//只有病案首页采集页传TemplateID、TemplateVersion
    s templateID = argArray.GetAt("params").GetAt("TemplateID")
    s templateVersion = argArray.GetAt("params").GetAt("TemplateVersion")
    
 
    s printUseLastVersion = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("PrintUseLastVersion","N")
    if (printUseLastVersion = "Y"){
	     s templateID =""
	     s templateVersion = ""
    }
	s InstanceID = ##Class(EMRservice.BL.BLInstanceData).CreateDocument(DocID,EpisodeID,PateintID,Title,TitleCode,DateTime,argOutData,templateID,templateVersion)
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{
		if (isStream = "true")
		{
			s loadmode = argArray.GetAt("params").GetAt("LoadMode") 
			s templateCode = argArray.GetAt("params").GetAt("UserTemplateCode")
			if (loadmode = "UserTemplate")&&(templateCode '= "")
			{
				d argOutData.Clear()
				d argOutData.CopyFrom(##class(EMRservice.BL.BLUserTemplate).GetUserTemplateStream(templateCode))	
			}
		}
		///批量创建
		s spreading = argArray.GetAt("params").GetAt("spreading")
		if (spreading '= "")
		{
			s action = argArray.GetAt("params").GetAt("spreading").GetAt("action")
			if (action = "GroupCreation")
			{
				s groupCode = argArray.GetAt("params").GetAt("spreading").GetAt("groupCode")
				s groupresult = ##Class(EMRservice.BL.BLEMRTemplateGroup).SaveItemDocument(groupCode,InstanceID,EpisodeID)
				if (groupresult = "0")
				{
					q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_InstanceID_""",""groupCode"":"""_groupCode_"""}}")
					q
				}			
			}
		}
		//liuzhongwan 直接令该文档实例继承其模板的权限
		//增加入参UserID、UserLocID add by niucaicai 2017-12-2
		s UserID = argArray.GetAt("params").GetAt("UserID")
		s UserLocID = argArray.GetAt("params").GetAt("UserLocID")
		s InherTempPrivRet = ##Class(EMRservice.Ajax.AuthDirectAppoint).InherTempPriv(DocID,InstanceID,EpisodeID,UserID,UserLocID)
		s loadmode = argArray.GetAt("params").GetAt("LoadMode") 
		s templateCode = argArray.GetAt("params").GetAt("UserTemplateCode")
		if (loadmode = "UserTemplate")&&(templateCode '= "")
		{
			s insUserTemplate = ##Class(EMRservice.BL.BLInstanceUserTemplate).AddData(templateCode,UserID,InstanceID)
		}
		else
		{
			s templateFreq = ##Class(EMRservice.BL.BLTemplateFrequency).AddData(UserID,InstanceID)
		}
		//修改模板使用次数
		s methodQuery = ##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.BL.BLTemplateUseNumber||SetUseNumber")
		if (methodQuery="1")
		{
			s strUseRes=##Class(EMRservice.BL.BLTemplateUseNumber).SetUseNumber(InstanceID)
		}
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
ClassMethod CreateTestDocument(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s TemplateID = argArray.GetAt("params").GetAt("TemplateID")
	s VersionID = argArray.GetAt("params").GetAt("VersionID")
	s InstanceID = ##Class(EMRservice.BL.BLInstanceData).CreateTestDocument(TemplateID,VersionID,argOutData)
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
ClassMethod GetPrivilege(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s userID = argArray.GetAt("params").GetAt("UserID")
	s userLocID = argArray.GetAt("params").GetAt("UserLocID")
	s ssgroupID = argArray.GetAt("params").GetAt("SsgroupID")
	s patientID = argArray.GetAt("params").GetAt("PatientID")
	s episodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s sessionID = argArray.GetAt("params").GetAt("SessionID")
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
		s privString = "userid^"_userID_"!userloc^"_userLocID_"!ssgroupid^"_ssgroupID_"!admid^"_episodeID_"!patientid^"_patientID_"!instanceid^"_instanceID_"!sessionid^"_sessionID
		s privRule = ##Class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"ActionPrivilege")
		continue:(privRule = "")
		s canSave = $p(privRule.GetAt("save"),"|",1)
		s cantSaveReason = $p(privRule.GetAt("save"),"|",2)
		s canPrint = $p(privRule.GetAt("print"),"|",1)
		s cantPrintReason = $p(privRule.GetAt("print"),"|",2)
		s canDelete = $p(privRule.GetAt("delete"),"|",1)
		s cantDeleteReason = $p(privRule.GetAt("delete"),"|",2)
		s canCheck = $p(privRule.GetAt("check"),"|",1)
		s cantCheckReason = $p(privRule.GetAt("check"),"|",2)
		s canReCheck = $p(privRule.GetAt("recheck"),"|",1)
		s cantReCheckReason = $p(privRule.GetAt("recheck"),"|",2)
		s canRevokCheck = $p(privRule.GetAt("revokcheck"),"|",1)
		s cantRevokCheckReason = $p(privRule.GetAt("revokcheck"),"|",2)
		s canReference = $p(privRule.GetAt("reference"),"|",1)
		s cantReferenceReason = $p(privRule.GetAt("reference"),"|",2)
		s canExport = $p(privRule.GetAt("export"),"|",1)
		s cantExportReason = $p(privRule.GetAt("export"),"|",2)
		s canCopyPaste = $p(privRule.GetAt("copypaste"),"|",1)
		s cantCopyPasteReason = $p(privRule.GetAt("copypaste"),"|",2)
		s canRevise = $p(privRule.GetAt("revise"),"|",1)
		s cantReviseReason = $p(privRule.GetAt("revise"),"|",2)
		s canViewRevise = $p(privRule.GetAt("viewrevise"),"|",1)
		s cantViewReviseReason = $p(privRule.GetAt("viewrevise"),"|",2)
		s canCommit = $p(privRule.GetAt("commit"),"|",1)
		s cantCommitReason = $p(privRule.GetAt("commit"),"|",2)
		s canApplyEdit = $p(privRule.GetAt("applyedit"),"|",1)
		s cantApplyEditReason = $p(privRule.GetAt("applyedit"),"|",2)
		s canUnLock = $p(privRule.GetAt("unlock"),"|",1)
		s cantUnLockReason = $p(privRule.GetAt("unlock"),"|",2)
        s canAutoApply = $p(privRule.GetAt("autoapply"),"|",1)
		s cantAutoApplyReason = $p(privRule.GetAt("autoapply"),"|",2)
        s canPatCheck = $p(privRule.GetAt("patcheck"),"|",1)
        s cantPatCheckReason = $p(privRule.GetAt("patcheck"),"|",2)
        s canPatReCheck = $p(privRule.GetAt("patrecheck"),"|",1)
        s cantPatReCheckReason = $p(privRule.GetAt("patrecheck"),"|",2)
		d:(i'=1) json.Write(",")
		d json.Write("{")
		d json.Write("""InstanceID"":"""_instanceID)
		d json.Write(""",""canSave"":"""_$ZCONVERT(canSave,"O","UTF8"))
		d json.Write(""",""cantSaveReason"":"""_$ZCONVERT(cantSaveReason,"O","UTF8"))
		d json.Write(""",""canPrint"":"""_$ZCONVERT(canPrint,"O","UTF8"))
		d json.Write(""",""cantPrintReason"":"""_$ZCONVERT(cantPrintReason,"O","UTF8"))
		d json.Write(""",""canDelete"":"""_$ZCONVERT(canDelete,"O","UTF8"))
		d json.Write(""",""cantDeleteReason"":"""_$ZCONVERT(cantDeleteReason,"O","UTF8"))
		d json.Write(""",""canCheck"":"""_$ZCONVERT(canCheck,"O","UTF8"))
		d json.Write(""",""cantCheckReason"":"""_$ZCONVERT(cantCheckReason,"O","UTF8"))
		d json.Write(""",""canReCheck"":"""_$ZCONVERT(canReCheck,"O","UTF8"))
		d json.Write(""",""cantReCheckReason"":"""_$ZCONVERT(cantReCheckReason,"O","UTF8"))
		d json.Write(""",""canRevokCheck"":"""_$ZCONVERT(canRevokCheck,"O","UTF8"))
		d json.Write(""",""cantRevokCheckReason"":"""_$ZCONVERT(cantRevokCheckReason,"O","UTF8"))
		d json.Write(""",""canReference"":"""_$ZCONVERT(canReference,"O","UTF8"))
		d json.Write(""",""cantReferenceReason"":"""_$ZCONVERT(cantReferenceReason,"O","UTF8"))
		d json.Write(""",""canExport"":"""_$ZCONVERT(canExport,"O","UTF8"))
		d json.Write(""",""cantExportReason"":"""_$ZCONVERT(cantExportReason,"O","UTF8"))
		d json.Write(""",""canCopyPaste"":"""_$ZCONVERT(canCopyPaste,"O","UTF8"))
		d json.Write(""",""cantCopyPasteReason"":"""_$ZCONVERT(cantCopyPasteReason,"O","UTF8"))
		d json.Write(""",""canRevise"":"""_$ZCONVERT(canRevise,"O","UTF8"))
		d json.Write(""",""cantReviseReason"":"""_$ZCONVERT(cantReviseReason,"O","UTF8"))
		d json.Write(""",""canViewRevise"":"""_$ZCONVERT(canViewRevise,"O","UTF8"))
		d json.Write(""",""cantViewReviseReason"":"""_$ZCONVERT(cantViewReviseReason,"O","UTF8"))
		d json.Write(""",""canCommit"":"""_$ZCONVERT(canCommit,"O","UTF8"))
		d json.Write(""",""cantCommitReason"":"""_$ZCONVERT(cantCommitReason,"O","UTF8"))
		d json.Write(""",""canApplyEdit"":"""_$ZCONVERT(canApplyEdit,"O","UTF8"))
		d json.Write(""",""cantApplyEditReason"":"""_$ZCONVERT(cantApplyEditReason,"O","UTF8"))
		d json.Write(""",""canUnLock"":"""_$ZCONVERT(canUnLock,"O","UTF8"))
		d json.Write(""",""cantUnLockReason"":"""_$ZCONVERT(cantUnLockReason,"O","UTF8"))
        d json.Write(""",""canAutoApply"":"""_$ZCONVERT(canAutoApply,"O","UTF8"))
		d json.Write(""",""cantAutoApplyReason"":"""_$ZCONVERT(cantAutoApplyReason,"O","UTF8"))
        d json.Write(""",""canPatCheck"":"""_$ZCONVERT(canPatCheck,"O","UTF8"))
		d json.Write(""",""cantPatCheckReason"":"""_$ZCONVERT(cantPatCheckReason,"O","UTF8"))
        d json.Write(""",""canPatCheck"":"""_$ZCONVERT(canPatCheck,"O","UTF8"))
		d json.Write(""",""cantPatReCheckReason"":"""_$ZCONVERT(cantPatReCheckReason,"O","UTF8"))
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
ClassMethod GetCurrentStatus(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
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
		s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(parentId)
		continue:(objEcrecord = "")
		s docId = objEcrecord.RealChartItemID
		s objEcrecord = ""		
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
		continue:(objInstance = "")
		s POperateDate = objInstance.ModifyDate
		s POperateTime = objInstance.ModifyTime
		s objInstance = ""		
		s result = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(episodeID,docId,emrNum)
		s signStatus = ##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(episodeID,docId,emrNum)
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
		d json.Write(""",""happenDateCache"":"""_$zcvt($p(result,"^",13),"O","UTF8"))
		d json.Write(""",""happenTimeCache"":"""_$zcvt($p(result,"^",14),"O","UTF8"))
		d json.Write(""",""createDateCache"":"""_$zcvt($p(result,"^",15),"O","UTF8"))
		d json.Write(""",""createTimeCache"":"""_$zcvt($p(result,"^",16),"O","UTF8"))
		d json.Write(""",""POperateDate"":"""_POperateDate)
		d json.Write(""",""POperateTime"":"""_POperateTime)
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
ClassMethod LoadDictionary(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
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
	s hospitalID = argArray.GetAt("params").GetAt("HospitalID")
	
	s ConditionCode =##Class(EMRservice.BL.BLStdDictionary).SelectConditionByStdCode(dicCode)
	s Condition = argArray.GetAt("params").GetAt("Condition")
	
	///ConditionType  查询类型 LeftMatch，左匹配；PerfectMatch，精确匹配；FuzzyMatch，模糊匹配
	s ConditionType = argArray.GetAt("params").GetAt("ConditionType")
	
	s ConditionKeyWord =##Class(EMRservice.BL.BLStdDictionary).getConditionByStdCode(dicCode)
 	//如果没有查询条件并且允许带内置默认条件，则检查字典是否设置查询条件关键字
	if ((Condition="") && (defaultFilter="true"))
	{	    
	    //判断是否配置为多个条件
	    if (ConditionKeyWord [ "|")
	    {
		    s length = $l(ConditionKeyWord,"|")
		    for i =1:1:length 
		    {
			    s ConditionKeyWordOne = $p(ConditionKeyWord,"|",i)
			    if (ConditionKeyWordOne="{CTLocID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_userLocID
			    }
			    elseif (ConditionKeyWordOne="{UserID}")
			    {
					s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_userID
			    }
			    elseif (ConditionKeyWordOne="{PatientID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_patientID
				}
			    elseif (ConditionKeyWordOne="{EpisodeID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_episodeID
			    }
			    elseif (ConditionKeyWordOne="{SsgroupID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_ssgroupID
		        }
			    elseif (ConditionKeyWordOne="{HospitalID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_hospitalID
			    }
			}
		}
		else
	    {
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
		    elseif (ConditionKeyWord="{HospitalID}")
		    {
			    s Condition=hospitalID
		    }
		    elseif (ConditionKeyWord '[ "{") {
	            s Condition=ConditionKeyWord
		    }
	    }
	}
	else
	{
		if (ConditionKeyWord [ "|")
		{
		    s length = $l(ConditionKeyWord,"|")
		    for i =1:1:length 
		    {
			    s ConditionKeyWordOne = $p(ConditionKeyWord,"|",i)
			    if (ConditionKeyWordOne="{CTLocID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_userLocID
			    }
			    elseif (ConditionKeyWordOne="{UserID}")
			    {
					s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_userID
			    }
			    elseif (ConditionKeyWordOne="{PatientID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_patientID
				}
			    elseif (ConditionKeyWordOne="{EpisodeID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_episodeID
			    }
			    elseif (ConditionKeyWordOne="{SsgroupID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_ssgroupID
		        }
			    elseif (ConditionKeyWordOne="{HospitalID}")
			    {
				    s:(Condition '= "") Condition = Condition_"|"
					s Condition = Condition_hospitalID
			    }
			}
		}
	}
	s SessionArray = ##class(%ArrayOfDataTypes).%New()
	d SessionArray.SetAt(hospitalID,"HospitalID")
	s tmpData = ##Class(EMRservice.BL.BLStdDictionary).GetStdDicXML(dicCode,queryItem,pageNumber,rowCount,countFlag,pageCount,sessionId,turnPage,ConditionCode,Condition,ConditionType,SessionArray)
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
	s episodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")	
	s signLevel = argArray.GetAt("params").GetAt("SignLevel")
	s signUserID = argArray.GetAt("params").GetAt("SignUserID")
	s signID = argArray.GetAt("params").GetAt("SignID")
	s patientId = argArray.GetAt("params").GetAt("PatientID") 
	s digest = argArray.GetAt("params").GetAt("Digest") 
	s type = argArray.GetAt("params").GetAt("Type") 
	s path = argArray.GetAt("params").GetAt("Path")
	s actionType = argArray.GetAt("params").GetAt("ActionType") 
	s userLocId = argArray.GetAt("params").GetAt("UserLocID")
	s LastOperateDate = argArray.GetAt("params").GetAt("POperateDate")
	s LastOperateTime = argArray.GetAt("params").GetAt("POperateTime")
	//从其它产品组操作病历
	s productSourceType = argArray.GetAt("params").GetAt("ProductSourceType")
	s:(productSourceType = "") productSourceType = "EMR"
	s productSourceCode = argArray.GetAt("params").GetAt("ProductSourceCode")
	d argOutData.Write(..#NONE)
	
	//压缩标记2022-04-19
	s IsCompressDocument = argArray.GetAt("params").GetAt("CompressDocument")
	s IsCompressDocument = $zcvt(IsCompressDocument,"U")
	
	//文档签名类型(cdaxml 签名域/compressxml 压缩整个原文签名/xml 非压缩整个原文签名/layoutxml 展现部分签名)
	s DocSignType = argArray.GetAt("params").GetAt("DocSignType")
	
	if (##Class(EMRservice.SystemParameter).IsEnableMultiEditSaveCheck() = "Y")
	{
		s saveStatus = ##Class(EMRservice.BL.BLInstanceData).CheckSaveStatus(instanceID,LastOperateDate,LastOperateTime)
		q:($p(saveStatus,"^",1) '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":"""_$p(saveStatus,"^",1)_""",""desc"":"""_$ZCONVERT($p(saveStatus,"^",2),"O","UTF8")_"""}}")  
	}
	s templateFlag = ##Class(EMRservice.BL.BLRoleSignRuleList).CheckTemplateSign(signUserID,instanceID,signLevel,userID)
	q:(templateFlag '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""desc"":"""_$ZCONVERT($p(templateFlag,"^",2),"O","UTF8")_"""}}")
	s action = ##Class(EMRservice.BL.BLSignRole).GetSignCode(signLevel)
	q:(action = "") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""action"":"""_action_"""}}")	
	s $zt = "SaveSignDocError"
	Tstart
	s status = ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(instanceID,userID,argInData,"","","",IsCompressDocument)
	if (status '= "1") 
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""status"":"""_status_"""}}")
	}
	s signStatus = ##Class(EMRservice.BL.BLEMRSign).SetMERSign(episodeID,instanceID,signUserID,signID,action,digest,type,argInData,path,actionType,userLocId,IsCompressDocument,DocSignType)
	if ($p(signStatus,"^",1) '= "1")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""signStatus"":"""_signStatus_""",""desc"":"""_$ZCONVERT($p(signStatus,"^",2),"O","UTF8")_"""}}")
	}   
    s EMRSignId = $p(signStatus,"^",2)
    s EMRSignLogId = $p(signStatus,"^",3)
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceID,userID,signUserID,ipAddress,EMRSignId,userLocId,productSourceType,EMRSignLogId)
	if ($p(logStatus,"^",1) = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_"""}}")
	}
	
	
	TCOMMIT
	
	s $zt = "SignedOtherError"
	
	//是否启用独立保存留痕文档
	if (##Class(EMRservice.SystemParameter).IsSaveRevisionDocument() = "True")
	{
	    s revisionLogStatus = ##Class(EMRservice.BL.RevisionLog).SaveRevisionLogNew(instanceID,argInData,IsCompressDocument)
	    if ($p(revisionLogStatus,":",1) = "-1")
	    {
	        //移除到事务外部，不需要回滚代码
			//Trollback
	        q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""revisionLogStatus"":"""_$p(revisionLogStatus,":",1)_""",""desc"":"""_$ZCONVERT($p(revisionLogStatus,":",2),"O","UTF8")_"""}}") 
		}
	}
	
	s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,episodeID,instanceID,ipAddress)
	//添加队列（导出病历CDA文件）
	d ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,episodeID,instanceID,ipAddress,"XML")
	s messageResult = ##Class(EMRservice.BL.BLMessage).SendSignMessage(userID,instanceID,signLevel,userLocId)
	
	///诊断证明书，24小时入出院记录,死亡记录等加入归档对列 生成pdf 加入队列
	d ##Class(EMRservice.HISInterface.DHCEPRFSInfo).SetRunDocQueue(episodeID,instanceID)
	d ##Class(EMRservice.BL.BLMessage).ChangeMessageStatus(signUserID,instanceID)
	//注册首页数据推送队列
	d ##Class(EMRservice.BL.BLAdmTaskQueue).RegTaskFP(instanceID)
	
	//签名后回收自动审批权限
	s withdrawApplyEdit = ##Class(EMRservice.BL.BLApplyEdit).WithdrawApplyEdit(instanceID,userID)

 	q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceID_""",""MessageFlag"":"""_messageResult_"""}}")	
SaveSignDocError
   Trollback
   q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""Err"":"""_$zerror_"""}}")
   
SignedOtherError
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
	s instanceID = argArray.GetAt("params").GetAt("InstanceID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s userLocId = argArray.GetAt("params").GetAt("UserLocID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	//从其它产品组操作病历
	s productSourceType = argArray.GetAt("params").GetAt("ProductSourceType")
	s:(productSourceType = "") productSourceType = "EMR"
	s productSourceCode = argArray.GetAt("params").GetAt("ProductSourceCode")
	s $zt = "DeleteDocError"	
	Tstart
	s indexStatus = ##Class(EMRservice.BL.BLDirectoryInformation).SetDirectoryInformation(instanceID,argInData)
	if (indexStatus '= "1") 
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""indexStatus"":"""_indexStatus_"""}}")
	}
	s docStatus = ##Class(EMRservice.BL.BLInstanceData).DeleteDocument(instanceID,userID)
	if (docStatus '= "1")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""docStatus"":"""_docStatus_"""}}")
	}
	s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog("delete",instanceID,userID,userID,ipAddress,"",userLocId,productSourceType)
	if ($p(logStatus,"^",1) = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""logStatus"":"""_logStatus_"""}}")	
	}
	TCOMMIT
	s $zt = "DeletedError"	
	s deleteFlag = ##class(EMRservice.BL.Event.BLLinkDocument).DeleteData(instanceID,userID)
	d ##class(EMRservice.BL.BLMessage).DeleteChangeMessageStatus(instanceID)
 	q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceID_"""}}")	
DeleteDocError
    Trollback
    q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""Err"":"""_$zerror_"""}}")
DeletedError  
 	q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""Err"":"""_$zerror_"""}}")
}

/// Desc:		插件获取系统参数
/// Creator:    yejian
/// CreateDate: 2014-11-12
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    #NONE
/// 
ClassMethod GetSysOptions(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
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
			continue:((""=strValue)||(strValue = $c(0)))
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
	s date = $zd($p($h,",",1),3)
	s time = $zt($p($h,",",2))
	s dataTime = date_" "_time
	s title = ""
	s titleCode = ""
	s InstanceIds = ##Class(%ListOfDataTypes).%New()
	d InstanceIds.Insert(pInstanceId) 
	s outMessage = ##Class(%GlobalBinaryStream).%New()
	s status = ##Class(EMRservice.BL.BLInstanceData).LoadDocument(argOutData,InstanceIds,outMessage)
	q:(status = "-1") 
	s InstanceID = ##Class(EMRservice.BL.BLQuotation).QuotationDocument(EpisodeID,pInstanceId,dataTime,title,titleCode)	
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{ 
	    q argOutMessage.Write(..#OK_",""InstanceID"":"""_InstanceID_""",""HappenDateTime"":"""_dataTime_"""}}")
	}
	else
	{  
	    q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_InstanceID_""",""HappenDateTime"":"""_dataTime_"""}}")
	}
Error
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
	s userLocId = argArray.GetAt("params").GetAt("UserLocID")
	s ip = argArray.GetAt("params").GetAt("IPAddress")
	s total = argArray.GetAt("params").GetAt("items").Count()
	s printMark =argArray.GetAt("params").GetAt("PrintMark")
	//从其它产品组操作病历
	s productSourceType = argArray.GetAt("params").GetAt("ProductSourceType")
	s:(productSourceType = "") productSourceType = "EMR"
	s productSourceCode = argArray.GetAt("params").GetAt("ProductSourceCode")
	s outStatus = 1
    s PrintInstanceIDs = ""
	s printStatus=""
	
    d argOutData.Write(..#NONE)
    s $zt = "PrintDocError"
	Tstart
    for i=1:1:total
	{	
		s instanceID = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("InstanceID")
		continue:(instanceID = "")
		s StartPageNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("StartPageNum")
		s StartRowNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("StartRowNum")
		s EndPageNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("EndPageNum")
		s EndRowNum = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("EndRowNum")
		//只有病案首页采集页传TemplateID、TemplateVersion
		s templateID = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("TemplateID")
        s templateVersion = argArray.GetAt("params").GetAt("items").GetAt(i).GetAt("TemplateVersion")
		
		s printStatus =  ##Class(EMRservice.BL.PrintRecord).CreatePrintRecord(instanceID,StartPageNum,StartRowNum,EndPageNum,EndRowNum,templateID,templateVersion)
		s:(printStatus = "0") outStatus = 0
		q:(outStatus = 0)
		s logStatus =  ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(actionType,instanceID,userId,userId,ip,"",userLocId,productSourceType)
	   	s:(logStatus = "0") outStatus = 0
	   	q:(outStatus = 0)
	   	if (printMark ="PrintTool")
		{
			s printStatus =  ##Class(EMRservice.BL.BLPrintToolService).CreatePrintRecord(instanceID,StartPageNum,StartRowNum,EndPageNum,EndRowNum)
			s:(printStatus = "0") outStatus = 0
			q:(outStatus = 0)
		}
        s PrintInstanceIDs = $Case(PrintInstanceIDs="",1:instanceID,:PrintInstanceIDs_","_instanceID)
	}
	
	if (outStatus = "0")
	{
		TRollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceID_""",""PrintStatus"":"""_outStatus_"""}}")
	}
	TCommit
	d argOutMessage.Write(..#OK_",""PrintInstanceIDs"":"""_PrintInstanceIDs_"""}}")
	
	s $zt = "PrintedError"
	 
	//注册首页数据推送队列
	d ##Class(EMRservice.BL.BLAdmTaskQueue).RegTaskFP(instanceID)
	//打印病案首页成功后，调用平台接口，对外提供访问出院患者列表
	d ##Class(EMRservice.BL.BLAdmTaskQueue).SendMedicalRecord(instanceID)
	q
	
PrintDocError
   TRollback
   q argOutMessage.Write(..#ERROR_"}}")
   
PrintedError
    q argOutMessage.Write(..#ERROR_",""Status"":""PrintedError""}}")
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

	s status = ##Class(EMRservice.BL.ModelInstanceData).SaveModelDocument(instanceID,userID,argInData,Title, ModelInsCategoryID)
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
	
	s status = ##Class(EMRservice.BL.ModelInstanceData).LoadDocument(argOutData,ModelID,argOutMessage)
	q:(status = "-1") argOutMessage.Write(..#OK_",""status"":""-1""}}")
	s dataTime="",title="",titleCode=""
	s InstanceID = ##Class(EMRservice.BL.ModelInstanceData).QuotationDocument(PatientID, EpisodeID,ModelID,dataTime,title,titleCode)	
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{ 
	    q argOutMessage.Write(..#OK_",""InstanceID"":"""_InstanceID_"""}}")
	}
	else
	{  
	    q argOutMessage.Write(..#ERROR_",""Error"":"""_InstanceID_"""}}")
	}
	
Error
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
	s result = ##class(EMRservice.BL.PrivacyProtection).PrivateDomains(InstanceId,ssgroupId,operation)

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
	s result = ##Class(EMRservice.BL.BLEMRSign).GetSignImage(userId)
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
	s result = "1"
	s episodeId = argArray.GetAt("params").GetAt("EpisodeID")
	s instanceId = argArray.GetAt("params").GetAt("InstanceID")
	s userId = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	s Title = argArray.GetAt("params").GetAt("Title")
	s:(Title '= "") Title = $zcvt(Title,"I","UTF8")	
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s DateTime = argArray.GetAt("params").GetAt("HappenDateTime")
	//s DateTimeFormat = argArray.GetAt("params").GetAt("DateTimeFormat")
	//s DateTime = ##Class(EMRservice.Tools.Tool).DateTimeFormat(DateTime,DateTimeFormat)	
	s LastOperateDate = argArray.GetAt("params").GetAt("POperateDate")
	s LastOperateTime = argArray.GetAt("params").GetAt("POperateTime")
	s OperatorID = ""
	s OperatorID = argArray.GetAt("params").GetAt("POperateTime")
    s:(OperatorID = "") OperatorID = userId	
	s action = "save"
	s userLocId = argArray.GetAt("params").GetAt("UserLocID")
	s count = argArray.GetAt("params").GetAt("Authenticator").Count()
	
	//压缩标记2022-04-19
	s IsCompressDocument = argArray.GetAt("params").GetAt("CompressDocument")
	s IsCompressDocument = $zcvt(IsCompressDocument,"U")
	
	if (##Class(EMRservice.SystemParameter).IsEnableMultiEditSaveCheck() = "Y")
	{
		s saveStatus = ##Class(EMRservice.BL.BLInstanceData).CheckSaveStatus(instanceId,LastOperateDate,LastOperateTime)
		q:($p(saveStatus,"^",1) '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""status"":"""_$p(saveStatus,"^",1)_""",""desc"":"""_$ZCONVERT($p(saveStatus,"^",2),"O","UTF8")_"""}}")  
	} 
	s $zt = "RevokeSignedError" 
	Tstart	
	s status = ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(instanceId,userId,argInData,Title,TitleCode,DateTime,IsCompressDocument)
	if (status '= 1) 
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""SaveStatus"":"""_status_"""}}")
	}
	
	
    s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceId,userId,OperatorID,ipAddress,"",userLocId)
    if ($p(logStatus,"^",1) = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""logStatus"":"""_logStatus_"""}}")
	}
	for i=1:1:count
	{
		s id = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("Id")
		continue:(id = "")
		s name = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("Name")
		s signLevel = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("SignatureLevel")
		s signLevel = ##Class(EMRservice.BL.BLSignRole).GetSignCode(signLevel)
		s path = argArray.GetAt("params").GetAt("Authenticator").GetAt(i).GetAt("Path")	
		s signStatus = ##Class(EMRservice.BL.BLEMRSign).RevokeSign(episodeId,instanceId,id,signLevel,path)
		if ($p(signStatus,"^",1) '= "1")
		{
			s result = "0"
			q
		}   
	}
	if (result ="1")
	{
		d ##Class(EMRservice.BL.AnySignLog).RevokeSign(instanceId)
		TCommit
		
		//是否启用独立保存留痕文档
		if (##Class(EMRservice.SystemParameter).IsSaveRevisionDocument() = "True")
		{
			s revisionLogStatus = ##Class(EMRservice.BL.RevisionLog).SaveRevisionLogNew(instanceId,argInData,IsCompressDocument)
			if ($p(revisionLogStatus,":",1) = "-1")
			{
				//移除到事务外部，不需要回滚代码
				//Trollback
				q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""revisionLogStatus"":"""_$p(revisionLogStatus,":",1)_""",""desc"":"""_$ZCONVERT($p(revisionLogStatus,":",2),"O","UTF8")_"""}}") 
			}
		}
		
		q argOutMessage.Write(..#OK_"}}")
	}
	else
	{
		TRollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""signStatus"":"""_signStatus_"""}}")
	}
	d argOutData.Write(..#NONE)	
	q
RevokeSignedError
    Trollback
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

/// Desc:       清理后台字典临时global
/// Creator:    Donglulu
/// CreateDate: 2016-8-16
ClassMethod CloseDictionarySession(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	d argOutData.Write(..#NONE)	
	s sessionId = argArray.GetAt("params").GetAt("SessionId")
	d ##Class(EMRservice.BL.BLStdDictionary).CleanDictionarySession(sessionId)
	q argOutMessage.Write(..#OK_"}}")
Error
    q argOutMessage.Write(..#ERROR_"}}")
}

/// Desc:		撤销签名
/// Creator:		Candy
/// CreateDate:  2016-8-23
ClassMethod RevokeSignedElement(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	d argOutData.Write(..#NONE)	
	s episodeId = argArray.GetAt("params").GetAt("EpisodeID")
	s instanceId = argArray.GetAt("params").GetAt("InstanceID")
	s userId = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	s id = argArray.GetAt("params").GetAt("Authenticator").GetAt("Id")
	s name = argArray.GetAt("params").GetAt("Authenticator").GetAt("Name")
	s signLevel = argArray.GetAt("params").GetAt("Authenticator").GetAt("SignatureLevel")
	s signLevel = ##Class(EMRservice.BL.BLSignRole).GetSignCode(signLevel)
	s path = argArray.GetAt("params").GetAt("Authenticator").GetAt("Path")
	s userLocId = argArray.GetAt("params").GetAt("UserLocID")	
	s LastOperateDate = argArray.GetAt("params").GetAt("POperateDate")
	s LastOperateTime = argArray.GetAt("params").GetAt("POperateTime")
	s action = "save"
	
	//压缩标记2022-04-19
	s IsCompressDocument = argArray.GetAt("params").GetAt("CompressDocument")
	s IsCompressDocument = $zcvt(IsCompressDocument,"U")
	
	
	if (##Class(EMRservice.SystemParameter).IsEnableMultiEditSaveCheck() = "Y")
	{
		s saveStatus = ##Class(EMRservice.BL.BLInstanceData).CheckSaveStatus(instanceId,LastOperateDate,LastOperateTime)
		q:($p(saveStatus,"^",1) '= "1") argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""status"":"""_$p(saveStatus,"^",1)_""",""desc"":"""_$ZCONVERT($p(saveStatus,"^",2),"O","UTF8")_"""}}")  
	}  
	s $zt="RevokeSignedElementError"
	Tstart
	s status = ##Class(EMRservice.BL.BLInstanceData).SaveDoucment(instanceId,userId,argInData,"","","",IsCompressDocument)
	if (status '= 1) 
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""SaveStatus"":"""_$zcvt(status,"O","UTF8")_"""}}")
	}
	
    s logStatus = ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog(action,instanceId,userId,userId,ipAddress,"",userLocId)
    if ($p(logStatus,"^",1) = "0")
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""logStatus"":"""_logStatus_"""}}")
	}

	s signStatus = ##Class(EMRservice.BL.BLEMRSign).RevokeSign(episodeId,instanceId,id,signLevel,path)
  	if ($p(signStatus,"^",1) '= "1")
  	{
		TRollback
		q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""signStatus"":"""_signStatus_"""}}")
	}
	else
	{
		TCommit
		
		//是否启用独立保存留痕文档
		if (##Class(EMRservice.SystemParameter).IsSaveRevisionDocument() = "True")
		{
			s revisionLogStatus = ##Class(EMRservice.BL.RevisionLog).SaveRevisionLogNew(instanceId,argInData,IsCompressDocument)
			if ($p(revisionLogStatus,":",1) = "-1")
			{
				//移除到事务外部，不需要回滚代码
				//Trollback
				q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""revisionLogStatus"":"""_$p(revisionLogStatus,":",1)_""",""desc"":"""_$ZCONVERT($p(revisionLogStatus,":",2),"O","UTF8")_"""}}") 
			}
		}
		q argOutMessage.Write(..#OK_"}}")
	}
RevokeSignedElementError
	TRollback
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$ZERROR_"""}}")
}

/// Desc:		获取服务器时间
/// Creator:		Candy
/// CreateDate: 	2016-11-23
ClassMethod GetServiceDateTime(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream)
{
	s date = $zd($p($h,",",1),3)
	s time = $zt($p($h,",",2))
	s datetime = date_" "_time
	q argOutMessage.Write(..#OK_",""DateTime"":"""_datetime_"""}}")
}

/// Desc: 		保存特殊病历(如:质控标注)
/// Creator:	Candy
/// CreateDate: 2017-8-24
ClassMethod SaveSpecailDocument(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	d argOutData.Write(..#NONE)	
	s saveType = argArray.GetAt("params").GetAt("SaveType")
	s instanceId = argArray.GetAt("params").GetAt("InstanceID")
	s DocID = argArray.GetAt("params").GetAt("DocID")
	s userID = argArray.GetAt("params").GetAt("UserID")
	s ipAddress = argArray.GetAt("params").GetAt("IPAddress")
	
	//压缩标记2022-04-19
	s IsCompressDocument = argArray.GetAt("params").GetAt("CompressDocument")
	s IsCompressDocument = $zcvt(IsCompressDocument,"U")
	
	
	Tstart
	if (saveType = 1)
	{
		s status = ##Class(EMRservice.BL.BLInstanceData).SaveMarkDocument(instanceId,argInData,IsCompressDocument)
		if (status '= "1") 
		{
			Trollback
			q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""SaveStatus"":"""_status_"""}}")
		}
	    s logStatus = ##Class(EMRservice.BL.BLSpecialLog).SetLog(DocID,instanceId,userID,ipAddress,"MarkDocument")
	    if (logStatus '= "1")
		{
			Trollback
			q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_""",""logStatus"":"""_logStatus_"""}}")
		}
		Tcommit
		q argOutMessage.Write(..#OK_"}}")
	}
	q
}

/// 获取图库功能的图片数据
ClassMethod LoadIMG(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	
	s imageId = argArray.GetAt("params").GetAt("ImageId")
	s objitem = ##Class(EMRmeta.Image.Item).%OpenId(imageId)
	q:(objitem = "") argOutMessage.Write(..#ERROR) 
	d argOutData.CopyFrom(objitem.ImageData)

	q argOutMessage.Write(..#OK_",""ImageId"":"""_imageId_""",""ImageType"":"""_objitem.ImageType_"""}}")
	
Error
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

/// Desc:       使用范例创建病历取最新发布模板(组合章节模式)
/// Creator:    Candyxu
/// CreateDate: 2016-7-26
ClassMethod CreateDocumentByExample(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s exampleInstanceId = argArray.GetAt("params").GetAt("ExampleInstanceID")
	s episodeId = argArray.GetAt("params").GetAt("EpisodeID")
	s instanceId = ##Class(EMRservice.BL.BLExampleInstance).GetInstanceData(episodeId,exampleInstanceId,argOutData)
	if ((instanceId '= "")&&(argOutData.Size > 0))
	{ 
	    q argOutMessage.Write(..#OK_",""InstanceID"":"""_instanceId_"""}}")
	}
	else
	{  
	    q argOutMessage.Write(..#ERROR_",""InstanceID"":"""_instanceId_"""}}")
	}
Error
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

/// Desc:       获取范例章节集合
/// Creator:    Candy
/// CreateDate: 2018-4-12
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod LoadExampleSecion(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s exampleId = argArray.GetAt("params").GetAt("ExampleInstanceID")
	d ##Class(EMRservice.BL.BLExampleInstance).GetExampleSectionXml(exampleId,argArray,argOutData)
	d argOutMessage.Write(..#OK_",""ExampleID"":"""_exampleId_"""}}")
	q
Error
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

ClassMethod LoadExampleSecionByExampleID(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s exampleId = argArray.GetAt("params").GetAt("UserTemplateCode")
	d ##Class(EMRservice.BL.BLExampleInstance).GetExampleSectionXmlByExampleID(exampleId,argArray,argOutData)
	d argOutMessage.Write(..#OK_",""ExampleID"":"""_exampleId_"""}}")
	q
Error
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

/// Desc:       保存范例
/// Creator:    Candy
/// CreateDate: 2018-4-12
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod SaveExampleSection(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s instanceId = argArray.GetAt("params").GetAt("InstanceID")
	s categoryId = argArray.GetAt("params").GetAt("CategoryID")
	s userId = argArray.GetAt("params").GetAt("UserID")
	s name = argArray.GetAt("params").GetAt("Name")
	s name = $zcvt(name,"I","UTF8")
	s isTool = argArray.GetAt("params").GetAt("Tool")
	if (isTool="")
	{
		TStart
		s exampleId = argArray.GetAt("params").GetAt("ExampleInstanceID")
		if (exampleId="")
		{
			s exampleId = ##Class(EMRservice.BL.BLExampleInstance).AddInstanceData(categoryId,name,instanceId,userId)
			q:(exampleId = "") argOutMessage.Write(..#ERROR_",""ExampleID"":"""_exampleId_"""}}")
		}
		s count = argArray.GetAt("params").GetAt("Items").Count()
		s separator = "-----------------------------7da4a26140fde"
		s tmpInData = ##Class(%GlobalBinaryStream).%New()
		d tmpInData.CopyFrom(argInData)
		s flag = 1
	    for i=1:1:count
	    {
		    s sectionCode = argArray.GetAt("params").GetAt("Items").GetAt(i).GetAt("SectionCode")
		    s sectionName = argArray.GetAt("params").GetAt("Items").GetAt(i).GetAt("SectionName")
		    s sectionName = $zcvt(sectionName,"I","UTF8")
		    s tmpData = ##Class(%GlobalBinaryStream).%New()
		    s tmpInData = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(tmpInData,separator,tmpData)
		    s status = ##Class(EMRservice.BL.BLExampleInstance).InsertInstanceData(exampleId,sectionCode,sectionName,tmpData,instanceId)
		    s:(status = "") flag = 0
		    q:(flag = 0)
		}
		if (flag = 0)
		{
			Trollback
			q argOutMessage.Write(..#ERROR_",""InsertStream"":""error""}}")
		}
		Tcommit
	}
	elseif (isTool="T") //通过工具将以前旧范例病历存成新的范例病历
	{
		s ModID = argArray.GetAt("params").GetAt("ModID")
		TStart
		s exampleId = ##Class(EMRservice.BL.BLExampleTool).AddInstanceData(categoryId,name,ModID,userId)
		q:(exampleId = "") argOutMessage.Write(..#ERROR_",""ExampleID"":"""_exampleId_"""}}")
		s count = argArray.GetAt("params").GetAt("Items").Count()
		s separator = "-----------------------------7da4a26140fde"
		s tmpInData = ##Class(%GlobalBinaryStream).%New()
		d tmpInData.CopyFrom(argInData)
		s flag = 1
	    for i=1:1:count
	    {
		    s sectionCode = argArray.GetAt("params").GetAt("Items").GetAt(i).GetAt("SectionCode")
		    s sectionName = argArray.GetAt("params").GetAt("Items").GetAt(i).GetAt("SectionName")
		    s sectionName = $zcvt(sectionName,"I","UTF8")
		    s tmpData = ##Class(%GlobalBinaryStream).%New()
		    s tmpInData = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(tmpInData,separator,tmpData)
		    s status = ##Class(EMRservice.BL.BLExampleTool).InsertInstanceData(exampleId,sectionCode,sectionName,tmpData,ModID)
		    s:(status = "") flag = 0
		    q:(flag = 0)
		}
		if (flag = 0)
		{
			Trollback
			q argOutMessage.Write(..#ERROR_",""InsertStream"":""error""}}")
		}
		Tcommit
	}
	q argOutMessage.Write(..#OK_"}}")	
Error
	Trollback
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

/// Desc:获取病历作者信息 
/// Creator:    Donglulu
/// CreateDate: 2018-10-15
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetAuthorMessage(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s instanceID = argArray.GetAt("params").GetAt("execute").GetAt("InstanceID")
	if (instanceID = "")
	{
		d argOutData.Write(..#NONE)
		d argOutMessage.Write(..#NONE)
		q
	}
	s json = ##Class(%GlobalBinaryStream).%New()
	s result = ##Class(EMRservice.BL.BLEMRLogs).GetAuthorMessage(instanceID)
	d json.Write(",""Time"":"""_$zcvt($p(result,"^",1),"O","UTF8"))
	d json.Write(""",""Code"":"""_$zcvt($p(result,"^",4),"O","UTF8"))
	d json.Write(""",""Name"":"""_$zcvt($p(result,"^",3),"O","UTF8")_"""")
	if (json.Size '= 0)
	{
		d argOutMessage.Write(..#OK)
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("}}")
	}else
	{
		d argOutMessage.Write(..#ERROR)
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("}}")
	}
	d argOutData.Write(..#NONE)
}

/// Desc:获取文档保管机构信息 
/// Creator:    Donglulu
/// CreateDate: 2018-10-15
/// Input:      argArray  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetCustodianMessage(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s instanceID = argArray.GetAt("params").GetAt("execute").GetAt("InstanceID")
	if (instanceID = "")
	{
		d argOutData.Write(..#NONE)
		d argOutMessage.Write(..#NONE)
		q
	}
	s json = ##Class(%GlobalBinaryStream).%New()
	s result = ##Class(EMRservice.BL.BLEMRLogs).GetAuthorMessage(instanceID)
	s code = "DHCCNO1"
	s name = "东华数字化医院"
	d json.Write(",""Time"":"""_$zcvt($p(result,"^",1),"O","UTF8"))
	d json.Write(""",""Code"":"""_$zcvt(code,"O","UTF8"))
	d json.Write(""",""Name"":"""_$zcvt(name,"O","UTF8")_"""")
	if (json.Size '= 0)
	{
		d argOutMessage.Write(..#OK)
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("}}")
	}else
	{
		d argOutMessage.Write(..#ERROR)
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("}}")
	}
	d argOutData.Write(..#NONE)
}

/// Desc:获取病历中对应医师签名时间列表 
/// Creator:    Candy
/// Creator:    Donglulu
/// CreateDate: 2018-10-15 
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod GetSignMessage(argArray As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s instanceID = argArray.GetAt("params").GetAt("execute").GetAt("InstanceID")
	if (instanceID = "")
	{
		d argOutData.Write(..#NONE)
		d argOutMessage.Write(..#NONE)
		q
	}
	if (argArray.GetAt("params").GetAt("execute").GetAt("SignItems") = "") {q}
	s itemCount = argArray.GetAt("params").GetAt("execute").GetAt("SignItems").Count()
	s json = ##Class(%GlobalBinaryStream).%New()
	for i=1:1:itemCount
	{
		s userID = argArray.GetAt("params").GetAt("execute").GetAt("SignItems").GetAt(i).GetAt("Id")
		continue:(userID = "")
		s signMessage = ##Class(EMRservice.BL.BLEMRSign).GetSignMessage(instanceID,userID)
		continue:(signMessage.GetAt("SignDate") = "")
		d:(json.Size '= 0) json.Write(",")
		d json.Write("{")
		d json.Write("""Id"":"""_userID)
		d json.Write(""",""Name"":"""_$zcvt(signMessage.GetAt("UserName"),"O","UTF8"))
		d json.Write(""",""Level"":"""_$zcvt(signMessage.GetAt("Level"),"O","UTF8"))
		d json.Write(""",""Time"":"""_$zcvt(signMessage.GetAt("Time"),"O","UTF8"))
		d json.Write("""}")
	}
	d argOutMessage.Write(..#OK_",""SignItems"":[")
	d argOutMessage.CopyFrom(json)
	d argOutMessage.Write("]")
	d argOutMessage.Write(",""InstanceID"":"""_instanceID_"""")
	d argOutMessage.Write("}}")
	d argOutData.Write(..#NONE)
}

/// Desc:      门诊个人模板创建
/// Input:     ADocID  
/// OutPut:    argOutMessage 返回消息json格式
///            argOutData    返回数据
ClassMethod CreatePersonalTemplate(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt="Error"
	s DocID = argArray.GetAt("params").GetAt("DocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s PateintID = argArray.GetAt("params").GetAt("PatientID")
	s Title = argArray.GetAt("params").GetAt("Title")
	s Title = $zcvt(Title,"I","UTF8")
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s DateTime = argArray.GetAt("params").GetAt("HappenDateTime")
	s PersonalTemplateID = argArray.GetAt("params").GetAt("PersonalTemplateID")
	s InstanceID = ##Class(EMRservice.BL.BLInstanceData).CreateDocument(DocID,EpisodeID,PateintID,Title,TitleCode,DateTime,argOutData)
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{
		//liuzhongwan 直接令该文档实例继承其模板的权限
		//增加入参UserID、UserLocID add by niucaicai 2017-12-2
		s UserID = argArray.GetAt("params").GetAt("UserID")
		s UserLocID = argArray.GetAt("params").GetAt("UserLocID")
		s InherTempPrivRet = ##Class(EMRservice.Ajax.AuthDirectAppoint).InherTempPriv(DocID,InstanceID,EpisodeID,UserID,UserLocID)
		s insPersonalTemplate = ##Class(EMRservice.BL.BLInstancePersonalTemplate).AddData(PersonalTemplateID,UserID,InstanceID)
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

/// Desc:       门诊个人模板获取关联的章节集合
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod LoadDefaultPersonalSecion(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s TitleCode = argArray.GetAt("params").GetAt("TitleCode")
	s LocID = argArray.GetAt("params").GetAt("UserLocID")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s PersonalTemplateID = argArray.GetAt("params").GetAt("PersonalTemplateID")
	s:(PersonalTemplateID= "") PersonalTemplateID = argArray.GetAt("params").GetAt("ExampleInstanceID")
	if (PersonalTemplateID '= "")
	{
		d ##Class(EMRservice.BL.PersonalTemplate).GetBindSection(PersonalTemplateID,TitleCode,argOutData)
	}
	d argOutMessage.Write(..#OK_"}}")
}

/// Desc:       门诊个人模板加载文档(用于前端修改个人模板)
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod LoadPersonalTemplate(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s ExampleInstanceID = argArray.GetAt("params").GetAt("ExampleInstanceID")
    s outMessage = ##Class(%GlobalBinaryStream).%New()
    s status = ##Class(EMRservice.BL.PersonalTemplate).LoadDocument(argOutData,ExampleInstanceID,outMessage)
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

/// Desc:       门诊个人模板保存章节数据
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod SavePersonalSection(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s instanceId = argArray.GetAt("params").GetAt("InstanceID")
	s categoryId = argArray.GetAt("params").GetAt("CategoryID")
	s userId = argArray.GetAt("params").GetAt("UserID")
	s name = argArray.GetAt("params").GetAt("Name")
	s name = $zcvt(name,"I","UTF8")

	TStart
	s exampleId = argArray.GetAt("params").GetAt("ExampleInstanceID")
	if (exampleId="")
	{
		s exampleId = ##Class(EMRservice.BL.BLExampleInstance).AddInstanceData(categoryId,name,instanceId,userId)
		q:(exampleId = "") argOutMessage.Write(..#ERROR_",""ExampleID"":"""_exampleId_"""}}")
	}
	s count = argArray.GetAt("params").GetAt("Items").Count()
	s separator = "-----------------------------7da4a26140fde"
	s tmpInData = ##Class(%GlobalBinaryStream).%New()
	d tmpInData.CopyFrom(argInData)
	s flag = 1
    for i=1:1:count
    {
	    s sectionCode = argArray.GetAt("params").GetAt("Items").GetAt(i).GetAt("SectionCode")
	    s sectionName = argArray.GetAt("params").GetAt("Items").GetAt(i).GetAt("SectionName")
	    s sectionName = $zcvt(sectionName,"I","UTF8")
	    s sectionStatus = argArray.GetAt("params").GetAt("Items").GetAt(i).GetAt("SectionStatus")
	    s:(sectionStatus = "") sectionStatus = "REPLACE"   //默认替换
	    
	    //获取当前实例创建方式(科室模板/个人模板)
	    s InsPersonTempID = $O(^DHCEMRI.InstPersonTemplateI("IdxInstanceID"," "_instanceId,""))
	    s InsUsrTempID = $O(^DHCEMRI.InstanceUserTemplateI("IdxInstanceID"," "_instanceId,""))
	    if (InsUsrTempID '="")&&(argArray.GetAt("params").GetAt("ExampleInstanceID") = "")
	    {
		    //根据科室模板获取继承关系
		    s InsUsrTempObj = ##class(EMRinstance.InstanceUserTemplate).%OpenId(InsUsrTempID)
		    s UsrTempID = InsUsrTempObj.UserTemplateID
		    
		    s UsrTempRelationID = $O(^DHCEMRM.UserTemplateRelationI("IdxCodeSection"," "_UsrTempID," "_sectionCode,""))
			if (UsrTempRelationID'="")
			{
				s UsrTempRelationObj = ##class(EMRmeta.UserTemplateSectionRelation).%OpenId(UsrTempRelationID)
				s:(UsrTempRelationObj'="") sectionStatus = UsrTempRelationObj.Status
			}
		}
        elseif (InsPersonTempID '="")&&(argArray.GetAt("params").GetAt("ExampleInstanceID") = "")
		{
			//根据个人获取继承关系
		    s InsPersonTempObj = ##class(EMRinstance.InstancePersonalTemplate).%OpenId(InsPersonTempID)
		    s PersonTempID = InsPersonTempObj.PersonalTemplateID
		    
		    s PersonTempRelationID = $O(^DHCEMRM.ExampleInsSecRelationI("IdxExampleIDSection"," "_PersonTempID," "_sectionCode,""))
			if (PersonTempRelationID'="")
			{
				s PersonTempRelationObj = ##class(EMRmeta.ExampleInsSecRelation).%OpenId(PersonTempRelationID)
				s:(PersonTempRelationObj'="") sectionStatus = PersonTempRelationObj.Status
			}
		}

	    s tmpData = ##Class(%GlobalBinaryStream).%New()
	    s tmpInData = ##Class(EMRservice.Parser.StreamData).GetFirstParserStream(tmpInData,separator,tmpData)
	    s status = ##Class(EMRservice.BL.BLExampleInstance).InsertInstanceDataForPersonalTmp(exampleId,sectionCode,sectionName,sectionStatus,tmpData,instanceId)
	    s:(status = "") flag = 0
	    q:(flag = 0)
	}
	if (flag = 0)
	{
		Trollback
		q argOutMessage.Write(..#ERROR_",""InsertStream"":""error""}}")
	}
	Tcommit

	q argOutMessage.Write(..#OK_",""ExampleID"":"""_exampleId_"""}}")	
Error
	Trollback
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

/// Desc:       获取页眉图片数据
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod GetHeaderImage(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	

	//判断有没有接口方法 
	if (##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.HISInterface.PatientInfoAssist||HospitalLogo")="0")
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)
		q
	}

	s ImageData =""
	s ImageData = ##Class(EMRservice.HISInterface.PatientInfoAssist).HospitalLogo()
	if (ImageData = "")
	{
		d argOutMessage.Write(..#ERROR_"}}")
		d argOutData.Write(..#NONE)
		q
	}
	d argOutData.Write(ImageData)
	q argOutMessage.Write(..#OK_"}}")
	
Error
	q argOutMessage.Write(..#ERROR_"}}")
}

/// Desc:       加载科室短语
/// CreateDate: 2021-10-13
/// Input:      argArray  命令参数
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod LoadDPComposite(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s DPNodeID = argArray.GetAt("params").GetAt("KBNodeID")
    s status = ##Class(EMRservice.BL.BLDPCategory).LoadDPComposite(argOutData,DPNodeID)
    if (status = "1")
    { 
        d argOutMessage.Write(..#OK_"}}")
    } 
    else 
    {
        d argOutMessage.Write(..#ERROR_"}}")
        d argOutData.Write(..#NONE) 
    }
    q
}

/// Desc:      保存科室短语
/// Creator:   
/// CreateDate: 2021-10-13
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     argOutMessage 返回消息json格式
///             argOutData    返回数据
ClassMethod SaveDPComposite(argArray As %ArrayOfDataTypes, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
    s DPNodeID = argArray.GetAt("params").GetAt("KBNodeID")   
    s status = ##Class(EMRservice.BL.BLDPCategory).SaveDPComposite(argInData,DPNodeID)  
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

}
