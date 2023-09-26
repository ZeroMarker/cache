/// 名称:	EMR.IP.BL.BLPatSign
/// 描述:	住院病历 病历标题信息
/// 编写者：lifengbo
/// 编写日期: 2023-03-08
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLTitle Extends EMR.IP.COM.ActionBase
{

/// Desc:       标题信息
/// Creator:    lifengbo
/// CreateDate: 2023-04-03
/// Input:      argArray  命令参数  {"action":"GET_TITLECONFIG","params":{"userLocId":"1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTileConfig(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCode,episodeID) =""
	s docCode=argInJson.params.docCode
	s episodeID=argInJson.params.episodeID
	
    s strRes = ##Class(EMR.IP.BL.BLTitle).GetTileConfigJson(episodeID,docCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes [ "-1^")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$ze,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","GetTileConfig未识别的返回值",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$ze,2)
}

/// Desc:	获取文档标题配置信息
/// Input:	
/// Return:	标题信息JSON
/// Debug:	s argOutData=##class(%GlobalBinaryStream).%New()
/// 		w ##Class(EMR.IP.BL.BLTitle).GetTileConfigJson("1224","EMR100002",.argOutData)
ClassMethod GetTileConfigJson(argEpisodeID As %String = "", argDocCode As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json={}
	
	s $zt="ERROR"
	s tplCategoryID=""
	s tplCategoryID = $o(^CF.EMR.DOC.TemplateCategoryI("IdxCode"," "_argDocCode,tplCategoryID))
	q:(tplCategoryID="") json.%ToJSON()
	
	s objTplCategory = ##class(CF.EMR.DOC.TemplateCategory).%OpenId(tplCategoryID)
	
	s objTitle = objTplCategory.Title
	
	s json.Code = argDocCode
	s json.Title= objTplCategory.Name
	s json.DateTime= $zdt($h,3,2)
	s json.DefaultLoad = objTitle.DefaultCreate
	
	s json.Config = []
	s titleConfig={}
	s datetimeConfig={}
	
	///Title 配置信息
	if (objTitle.TitleFontStyle'="")
	{
		s jsonTitleFontStyle = ##class(%DynamicAbstractObject).%FromJSON(objTitle.TitleFontStyle)
		s titleConfig.FontStyle= jsonTitleFontStyle
	}
	s titleConfig.Params= "DoctorLevel:"_objTitle.DoctorLevel
	s titleConfig.ReadOnly= objTitle.TitleReadonly
	s titleConfig.Type= "Title"
	s titleFormat = $s(objTitle.IncludeDoctorName=1:"DoctorName^",1:"")_$s(objTitle.IncludeDoctorLevel=1:"DoctorLevel^",1:"") _"Title"
	s titleConfig.Format= titleFormat
	s titleConfig.Visible= objTitle.Titlevisible
	
	d json.Config.%Push(titleConfig)
	
	//时间格式
	if (objTitle.DateFontStyle'="")
	{
		s jsonDateFontStyle = ##class(%DynamicAbstractObject).%FromJSON(objTitle.DateFontStyle)
		s datetimeConfig.FontStyle= jsonDateFontStyle
	}
	s datetimeConfig.Params= ""
	s datetimeConfig.ReadOnly=objTitle.DateReadonly
	s datetimeConfig.Type="DateTime"
	s datetimeConfig.Format= objTitle.DateFormat
	s datetimeConfig.Visible=objTitle.Datevisible
	
	d json.Config.%Push(datetimeConfig)
	
	
	s eventType = objTitle.EventCode
	s json.EventType = eventType
	if objTitle.EventCode'=""
	{
		s eventStream=##class(%GlobalBinaryStream).%New()
		s eventConfig = ##class(EMR.DOC.BL.EventUphold).GetEventU(eventType,.eventStream)
		
		s json.EventConfig = [].%FromJSON(eventStream)
	}
	// 事件信息代码需要优化 20230407
	//s eventData = ##Class(EMRservice.BL.Event.BLEvents).GetData(objTitle.EventCode,argEpisodeID)
	//s json.EventData =eventData
	// 20230420 经确认，目前未实现危急值数据的对外接口与数据存储代码。
	s json.EventData =""
	
	d json.%ToJSON(argOutData)
	
	q 1
ERROR
	s $zt=""
	q "-1^"_$ze
}

/// Desc:       标题信息
/// Creator:    lifengbo
/// CreateDate: 2023-04-03
/// Input:      argArray  命令参数  {"action":"GET_TITLECONFIG","params":{"userLocId":"1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CanCreateByEpisodeTime(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCode,episodeID) =""
	s docCode=argInJson.params.docCode
	s episodeID=argInJson.params.episodeID
	s dateTime=argInJson.params.dateTime
	
    s strRes = ##Class(EMR.IP.BL.BLTitle).CanCreateByEpisodeTimeJson(episodeID,docCode,dateTime,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes [ "-1^")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","代码异常:"_$p(strRes,"^",2),2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","CanCreateByEpisodeTime未识别返回值",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常:"_$ze,2)
}

/// Desc:	时间是否在患者就诊期间
/// Input:	
/// Return:	
/// Debug:	w ##Class(EMR.IP.BL.BLTitle).CanCreateByEpisodeTimeJson("100")
ClassMethod CanCreateByEpisodeTimeJson(argEpisodeID As %String = "", argDocCode As %String = "", argDateTime As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json={}
	s json.Flag="1"
	s json.FailInfo=""
	
	s $zt="ERROR"
	
	s date = $zdh($p(argDateTime," ",1),3)
	s time = $zth($p(argDateTime," ",2))
	s admDateTime = ##class(EMR.DOC.HISInterface.PatientInfoAssist).AdmDateTime(argEpisodeID)
	
	s admDate = $p(admDateTime,",",1)
	if (date < admDate) 
	{
		s json.Flag=0
		s json.FailInfo="病历书写日期小于入院日期"
		d json.%ToJSON(argOutData)
		q 1
	}
	s admTime = $p(admDateTime,",",2)
	
	if ((date = admDate)&&(time < admTime)) 
	{
		s json.Flag=0
		s json.FailInfo="病历书写时间小于入院时间"
		d json.%ToJSON(argOutData)
		q 1
	}
	//通过在系统参数中维护病历的titlecode控制医生创建病程记录时，不受出院时间限制
	 
	s flag = ##Class(EMR.IP.BL.BLTitle).IsExistTitleCode(argDocCode)
	if (flag = "1")
	{
		d json.%ToJSON(argOutData)
		q 1
	}
	
	s disDateTime = ##Class(EMR.DOC.HISInterface.PatientInfoAssist).DisDateTime(argEpisodeID)
	if (disDateTime = "")
	{
		d json.%ToJSON(argOutData)
		q 1
	}
	
	s disDate = $p(disDateTime,",",1)
	if (date > disDate ) 
	{
		s json.Flag=0
		s json.FailInfo="病历书写日期大于出院日期"
		d json.%ToJSON(argOutData)
		q 1
	}
	
	s disTime = $p(disDateTime,",",2)	
	if ((date = disDate)&&(time > disTime)) 
	{
		s json.Flag=0
		s json.FailInfo="病历书写时间大于出院时间"
		d json.%ToJSON(argOutData)
		q 1
	}
	
	d json.%ToJSON(argOutData)
	
	q 1
ERROR
	q "-1^"_$ze
}

/// Desc:        通过在系统参数中维护病历的titlecode控制医生创建病程记录时，不受出院时间限制
/// Creator:     wangyu
/// CreateDaate: 2021-11-24
/// Input:       
/// Output:      1 可写   0 不可写 
/// w ##Class(EMRservice.BL.BLTitleConfig).IsExistTitleCode("EMR100020")
ClassMethod IsExistTitleCode(createCode As %String) As %String
{
	s result = "0"
	q:(createCode = "") result
	s DocTitleCode = ##class(EMR.IP.BL.BLSysOption).GetOptionValueByName("openDocCode")
	if (DocTitleCode = "") q result 
	s arr = [].%FromJSON(DocTitleCode) 
	s DocCode = arr.%GetIterator()
	while DocCode.%GetNext(.key, .value)
	{
		if (value = createCode)
		{
			s result = "1"
		}
	}
	q result
}

/// Desc:       标题发生时间与首次病程日期比较
/// Creator:    lifengbo
/// CreateDate: 2023-04-03
/// Input:      argArray  命令参数  {"action":"CAN_CREATEBYFIRSTRECORD","params":{"userLocId":"1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod CanCreateByFirstRecord(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCode,episodeID) =""
	s docCode=argInJson.params.docCode
	s episodeID=argInJson.params.episodeID
	s dateTime=argInJson.params.dateTime
	
    s strRes = ##Class(EMR.IP.BL.BLTitle).CanCreateByFirstRecordJson(episodeID,docCode,dateTime,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入版本ID",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	时间是否在患者就诊期间
/// Input:	
/// Return:	
/// Debug:	w ##Class(EMR.IP.BL.BLTitle).CanCreateByEpisodeTimeJson("100")
ClassMethod CanCreateByFirstRecordJson(argEpisodeID As %String = "", argDocCode As %String = "", argDateTime As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json={}
	s json.Flag="1"
	s json.FailInfo=""
	
	
	s date = $zdh($p(argDateTime," ",1),3)
	s time = $zth($p(argDateTime," ",2))

	q:(argEpisodeID = "")||(argDocCode = "")||(argDateTime = "") result

	s TILDocument = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(argEpisodeID)
	
	s DocCode = $zcvt(argDocCode,"U")
	//首次病程记录 
	s finFirstRecord = $d(@TILDocument@("IdxEpisodeRecordCodeStatus",argEpisodeID," EMR100001", " SAVE"))
	
	//首程未完成且当前病历为首程，可以创建。不做其他验证
	
	if (finFirstRecord'=10) 
	{
		if (DocCode="EMR100001")
		{
			s json.Flag=1
			s json.FailInfo=""
		}
		else
		{
			s json.Flag=0
			s json.FailInfo="请先创建首次病程记录"	
		}
		d json.%ToJSON(argOutData)
		q 1
	}
	
	
	// 获取首次病程记录ID信息
	s documentID=""
	s documentID = $o(@TILDocument@("IdxEpisodeRecordCodeStatus",argEpisodeID," EMR100001", " SAVE",documentID))
	
	s objDocument = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
	s tmpDate = $zdh($p(argDateTime," ",1),3)
	
	if (tmpDate < objDocument.HappenDate)
	{
		s json.Flag=0
		s json.FailInfo="病历书写日期不能早于首次病程书写日期"
		d json.%ToJSON(argOutData)
		q 1
	}
	
	s tmpTime =  $zth($p(argDateTime," ",2))
	if ((tmpDate = objDocument.HappenDate)&&(tmpTime < objDocument.HappenTime)) 
	{
		s json.Flag=0
		s json.FailInfo="病历书写时间不能早于首次病程书写时间"
		d json.%ToJSON(argOutData)
		q 1
	}
	//验证通过
	s json.Flag=1
	s json.FailInfo=""
	d json.%ToJSON(argOutData)
	
	q 1
}

/// Desc:       标题医生信息
/// Creator:    lifengbo
/// CreateDate: 2023-04-03
/// Input:      argArray  命令参数  {"action":"GET_TITLECONFIG","params":{"userLocId":"1"},"product":"GlobalEMR"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTitleDoctors(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s (docCode,episodeID) =""
	s episodeID=argInJson.params.episodeID
	s userID=argInJson.params.userID	
	s userLocID=argInJson.params.userLocID
	s format=argInJson.params.format
	s params=argInJson.params.params
	
    s strRes = ##Class(EMR.IP.BL.BLTitle).GetTitleDoctorsJson(episodeID,userID,userLocID,format,params,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes [ "-1^")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$p(strRes,"^",2),2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未识别的返回值",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:	获取文档标题医生信息
/// Input:	
/// Return:	获取文档标题医生信息JSON
/// Debug:	s argOutData=##class(%GlobalBinaryStream).%New()
/// 		w ##Class(EMR.IP.BL.BLTitle).GetTitleDoctorsJson(285,18881,191,"","",.argOutData)
ClassMethod GetTitleDoctorsJson(argEpisodeID As %String = "", argUserID As %String = "", argUserLocID As %String = "", argFormat As %String = "", argParams As %String = "", ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt="ERROR"
	s json={}
	s jsonArr=[]
	s rowId = 0
	for
	{	
		s rowId = $o(^SSU("SSUSR",rowId))
		q:(rowId = "")
		s tmploc = $p($g(^SSU("SSUSR",rowId)),"^",4)
		continue:(tmploc = "")
		s userName = $p($g(^SSU("SSUSR",rowId)),"^",2) 
		if (tmploc '= argUserLocID)
		{
			s subId = "0"
			for
			{
				s subId = $o(^SSU("SSUSR",rowId,"OTHLL",subId))
				q:(subId = "")
				s tmploc = $p($g(^SSU("SSUSR",rowId,"OTHLL",subId)),"^",1)
				q:(tmploc = argUserLocID)
			}
		}
		continue:(tmploc '= argUserLocID)
		

		//需要在四版病历实现相关代码
		s userLevel = ##class(EMR.DOC.BL.SignRole).GetUserLevel(rowId,argEpisodeID,argUserLocID,..#ProductCode)
		continue:($l(userLevel)=1)
		s doctorCode = $p(userLevel,"^",1)
		s ctparprvtpDesc = $p(userLevel,"^",2)
		if (argParams '= "")
		{
			s containLevel = 0
			s levelRange = $e(argParams,13,$l(argParams))
			s levelCount=$l(levelRange, "^")
			f i=1:1:levelCount 
			{
				s level = $p(levelRange, "^", i)
				q:(level = "")
			    s:(doctorCode = level) containLevel = 1
			    continue:(doctorCode '= level)
			}
			continue:(containLevel '= 1)
		}
		if (argFormat [ "DoctorLevel")
		{
			s ctnameparprvtpDesc = userName_ctparprvtpDesc
		}
		else
		{
			s ctnameparprvtpDesc = userName
		}
		//支持首拼检索
		s ctnameparprvtpCode = ##class(web.DHCINSUPort).GetCNCODE(ctnameparprvtpDesc,4,"")
       
		s jsonsub={}
		s jsonsub.RowID= rowId
		s jsonsub.Code= ctnameparprvtpCode
		s jsonsub.Desc= ctnameparprvtpDesc
		s jsonsub.doctor= userName
		s jsonsub.doctorLevel= $p(userLevel,"^",2)
		s jsonsub.doctorLevelCode= $p(userLevel,"^",1)
		
		d jsonArr.%Push(jsonsub)
	
	}
	
	//需要四版实现代码
	s defaultDoc = ..GetDefaultDoctor(argUserLocID,argParams,argEpisodeID,argUserID) 
	
	s json.DefaultDoc= defaultDoc
	s json.DocData = jsonArr
	d json.%ToJSON(argOutData)
	
	q 1
ERROR
	q "-1^"_$ze
}

/// Desc: 		 获取默认选择的医生
/// Creator:     董璐璐
/// CreateDate:  2020-3-31
/// Input:       ALocID 科室ID
/// 	         AColParams EMRmeta.TitleColConfig的Params字段
/// 	         AEpisodeID 就诊号
/// 	         AUserID 登录用户userID
/// Output:      默认选择的医生userID
/// Debug:       w ##Class(EMRservice.BL.BLPowerUser).GetDefaultDoctor(95,"DoctorLevel:Attending",1,10209) 
ClassMethod GetDefaultDoctor(ALocID As %String, AColParams As %String, AEpisodeID As %String, AUserID As %String) As %String
{
	s result = AUserID
	q:((ALocID = "")||(AColParams = "")||(AEpisodeID = "")) result
	q:((AColParams '= "DoctorLevel:Attending")&&(AColParams '= "DoctorLevel:Chief")&&(AColParams '= "DoctorLevel:ViceChief")&&(AColParams '= "DoctorLevel:ViceChief^Chief")) result
	
	if (AColParams = "DoctorLevel:Attending")
	{
		s userType = "2"
	}
	else
	{
		s userType = "3"
	}
	
	s docs = ##class(DHCDoc.Interface.Inside.Service).GetAdmThreeCheckDoc("",ALocID,AEpisodeID)
	q:(docs = "") result
	
	s stream =##class(%FileBinaryStream).%New()
	d stream.Write(docs)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s arrDocs = objJson.Deserialize(stream)
	s count = arrDocs.Count()
	for i=1:1:count
	{
		s type = arrDocs.GetAt(i).GetAt("Type")
		continue:(type '= userType)
		s result = arrDocs.GetAt(i).GetAt("UserID")
	}
	q result
}

}
