Class EMRservice.PrintActionFactory Extends %RegisteredObject
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
/// Debug:         w ##Class(EMR.ART.DAL.EMRActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInMessage As %GlobalBinaryStream, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
		//定义错误处理函数
	s $ZT="ERROR"
	//解析json参数		       
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInMessage)
	s strAction = array.GetAt("params").GetAt("action")

	if (strAction = "LOAD_DEFAULT_FIELD")
	{
		//取数据绑定值
		d ##Class(EMR.ART.DAL.EMRActionFactory).LoadDefaultField(array,argOutMessage,argOutData)
	}
	elseif (strAction = "CREATE_DOCUMENT")
	{
		d ..CreateTestDocument(array,argOutMessage,argOutData)
	}
	elseif (strAction = "PRINT_DOCUMENT")
	{
		///打印文档
		d ..PrintDocument(array,argOutMessage,argOutData)
		if (array.GetAt("params").GetAt("ProductTeam")="ART"){
			s paramsStream =##class(%FileBinaryStream).%New() 
    		s paramsStream = ##Class(EMR.ART.COM.Stream).StreamConvertUTF8(argInMessage)
    		s type = array.GetAt("params").GetAt("contentType")
    		s actionStr = ""
    		if (type="OVURECORD"){
    			s actionStr = "PRINT_OVURECORD"
    		}elseif (type="TRANSPLANTRECORD"){
    			s actionStr = "PRINT_TRANSPLANTRECORD"
    		}
			s logResult = ##Class(EMR.ART.BL.Logs).SaveLogsEntrance(actionStr,paramsStream)
		}
	}
	q "1"
	
ERROR			
	d argOutMessage.Write(..#ERROR_",""Err"":"""_$zerror_"""}}")
	d argOutData.Write(..#NONE)	 	        
	q "0"
}

/// Desc:取模板数据(绑定测试)
/// Creator:    yejian
/// CreateDate: 2016-1-6
/// Input:      ADocID  
/// OutPut:     argOutMessage 返回消息json格式
///            argOutData    返回数据 ##Class(EMRservice.PrintActionFactory).CreateTestDocument()
ClassMethod CreateTestDocument(argArray As %ArrayOfDataTypes, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream)
{
	s TemplateID = argArray.GetAt("params").GetAt("TemplateID")
	s TemplateVersion = argArray.GetAt("params").GetAt("TemplateVersion")
	s InstanceID = ..CreateTemplateDocument(TemplateID,TemplateVersion,argOutData)
	if ((InstanceID '= "")&&(argOutData.Size > 0))
	{ 
	    d argOutMessage.Write(..#OK_",""InstanceID"":"""_InstanceID_"""}}")
	}
	else
	{  
	    d argOutMessage.Write(..#ERROR_",""InstanceID"":"""_InstanceID_"""}}")
	}
}

/// CreateTime: 2016-1-6
/// Creator:    yejian
/// Desc:		创建模板绑定测试文档
/// Input:		ADocID: 电子病历界面模板的目录ID
/// 			AEpisodeID:就诊号
/// 			APatientID:APatientID
/// OutPut:     objDoc:新建文档流数据
///             InstanceID 实例数据ID
/// debug:   w ##Class(EMR.ART.BL.EMR.InstanceData).CreateDocument(601,76,48,"","","")
ClassMethod CreateTemplateDocument(aTemplateID As %String, aTemplateVersion As %String, ByRef objDoc As %GlobalBinaryStream) As %String
{
 	s instanceID = ""
	q:((aTemplateID = ""||aTemplateVersion="")) instanceID
	s templateID =  aTemplateID
	
	s objTemplate = ##class(EMRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") instanceID

	s instanceID = "-1"
	if ((instanceID '= "")&&(objDoc '= ""))
	{
		////打印时从前端传来打印的模板version
		d objDoc.CopyFrom(##Class(EMRservice.BL.BLInstanceData).GetNewDocByTemplateID(templateID,aTemplateVersion))	
	}
	d objTemplate.%Close()
	k objTemplate
	q instanceID
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
	s TemplateVersion = argArray.GetAt("params").GetAt("TemplateVersion")
	s EpisodeID = argArray.GetAt("params").GetAt("EpisodeID")
	s TemplateID = argArray.GetAt("params").GetAt("TemplateID")
	s productTeam = argArray.GetAt("params").GetAt("ProductTeam")
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
		if (productTeam="ART"){
			s printStatus =  ##Class(EMR.ART.BL.EMR.PrintTemplate).CreateTemplatePrintRecord(EpisodeID,TemplateID,TemplateVersion,userId,StartPageNum,StartRowNum,EndPageNum,EndRowNum)
			s:(printStatus = "0") outStatus = 0
			q:(printStatus = "0")
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

}
