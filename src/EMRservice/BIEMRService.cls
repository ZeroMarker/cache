/// 名称:EMRservice.BOMessageServer
/// 描述:编辑器插件交互服务
/// 编写者：Guozongtao
/// 编写日期: 2016-2-2
Class EMRservice.BIEMRService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/biservice";

/// Name of the WebService.
Parameter SERVICENAME = "BIEMRService";

/// Description:   图片访问接口函数
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式 { \"action\": \"GetPatientCategoryList\", "args": {\"adm\":\"1\"},\"OutType\": \"XML\"} 
/// 注OutType为输出类型 IMAGE：图片，XML:cdaXML文件
///      s argInMessage = ##Class(%GlobalBinaryStream).%New()
///   	 s deel = """"
/// 获取图片 s tmp="{"_deel_"action"_deel_":"_deel_"GetFtpServerConfig"_deel_","_deel_"args"_deel_":"_deel_deel_"}"
///   	 ;s tmp="{"_deel_"action"_deel_":"_deel_"GetPatientCategoryList"_deel_","_deel_"args"_deel_":{"_deel_"adm"_deel_":"_deel_"92837"_deel_"}}"
/// 	 ;s tmp="{"_deel_"action"_deel_":"_deel_"GetEMRImageList"_deel_","_deel_"args"_deel_":{"_deel_"adm"_deel_":"_deel_"92837"_deel_","_deel_"InternalID"_deel_":"_deel_"HDSD00.13.01"_deel_"}}"
/// 获取XML ;s tmp="{"_deel_"action"_deel_":"_deel_"GetFtpServerConfig"_deel_","_deel_"args"_deel_":"_deel_deel_","_deel_"OutType"_deel_":"_deel_"XML"_deel_"}"
/// 	 ;s tmp="{"_deel_"action"_deel_":"_deel_"GetEMRCDAXmlList"_deel_","_deel_"args"_deel_":{"_deel_"adm"_deel_":"_deel_"92837"_deel_","_deel_"InternalID"_deel_":"_deel_"HDSD00.13.01"_deel_"}}"
///   	 d argInMessage.Write(tmp)
///  	 s obj = ##Class(EMRservice.BIEMRService).EMRDocumentImageServer(argInMessage)
///   	 d obj.OutputToDevice()
/// Return：       XML数据流
/// Debug:         w ##Class(EMRservice.BIEMRService).EMRDocumentImageServer(argInMessage)	
ClassMethod EMRDocumentImageServer(argInMessage As %GlobalBinaryStream) As %GlobalBinaryStream [ WebMethod ]
{
      
	s argOutData=##Class(%GlobalBinaryStream).%New()
	d ##Class(EMRservice.BL.BLEMRDocumentImageServer).AcitonProxy(argInMessage,argOutData)
	q argOutData
}

/// Description:   根据术语集目录代码取电子病历数据接口
/// Creator:       Candy
/// CreateDate:    2016-02-03        
/// Input：        AEpisodeID:就诊号 
///                AGlossaryCategory:术语集标识符
/// Output         术语集对应该电子病历单元值
///                类型：数组
///                格式：[{"术语代码1":[{"实例ID","值"},{"实例ID","值"},...]},{"术语代码2":[{"实例ID","值"},...]}]
/// Debug:         w ##Class(EMRservice.BIEMRService).GetDataByGlossaryCategory(76,"HDSD00.13.03")	
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, AGlossaryCategory As %String) As %ArrayOfDataTypes
{
	q ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryCategory(AEpisodeID,AGlossaryCategory)
}

/// Description:   根据术语集代码取电子病历数据接口
/// Creator:       Candy
/// CreateDate:    2016-02-03        
/// Input：        AEpisodeID:就诊号 
///                AGlossary:术语集标识符
/// Output         术语集对应该电子病历单元值
///                类型：数组 
///                格式：[{"实例ID","值"},{"实例ID","值"},...]
///                唯一模板为单值，可重复模板可能有多值
/// Debug:         w ##Class(EMRservice.BIEMRService).GetDataByGlossary(76,"HDSD00.13.03")	
ClassMethod GetDataByGlossary(AEpisodeID As %String, AGlossary As %String) As %ArrayOfDataTypes
{
	q ##Class(EMRservice.BL.BLGlossary).GetDataByGlossary(AEpisodeID,AGlossary)
}

/// Description:   根据术语集代码取电子病历数据接口
/// Creator:       Candy
/// CreateDate:    2019-01-07        
/// Input：        1.取目录 
///                {"action":"GetRecordCategory","params":{"EpisodeID":"","InternalCategoryID":""}}
///                2.取内容
///                {"action":"GetDataByGlossaryCategory","params":{"EpisodeID":"","InternalCategoryID":""}}
///                AGlossary:术语集标识符
/// Output         
///                1.病历目录
///                <Categorys><Category><Name>病历名称</Name><InstanceID>病历ID</InstanceID><InternalID>病历术语代码</InternalID></Category>……<Categorys>
///                2.病历内容
///                <Contents><Content><InternalID>单元术语代码</InternalID><Value>单元内容</Value></Content>……</Contents> 
/// Debug:         w ##Class(EMRservice.BIEMRService).GetRecordDataByGlossaryCategory(76,"HDSD00.13")	
ClassMethod GetRecordDataByGlossaryCategory(argInMessage As %String) As %GlobalBinaryStream [ WebMethod ]
{
	s inStream = ##Class(%GlobalBinaryStream).%New()
	d inStream.Write(argInMessage)
	s outStream = ##Class(%GlobalBinaryStream).%New()
	d ##class(EMRservice.BL.BLEpisodeRecrodService).GetEpisodeRecrod(inStream,outStream)
	q outStream
}

/// Debug:         w ##Class(EMRservice.BIEMRService).GetImage(76)	
ClassMethod GetImage(AEpisodeID As %String) As %String
{
	q ##Class(EMRservice.BL.ImageMedicalRecords).GetImage(AEpisodeID)
}

/// Description:   手术记录数据接口
/// Creator:       Candy
/// CreateDate:    2016-06-13        
/// Input：        AEpisodeID 就诊ID
///                AOparID 手术ID
/// Output         result 1成功 0失败
/// Debug:         w ##Class(EMRservice.BIEMRService).SetOperation(76,13)
ClassMethod SetOperation(AEpisodeID As %String, AOparID As %String) As %String
{
 
	s result = "0"
	q:((AEpisodeID = "")||(AOparID = "")) result
	s data = ##Class(web.DHCANAdaptor).GetANOperation("","","","","","",AOparID)
	s result = ##Class(EMRservice.BL.Event.BLOperation).SetOperationData(AEpisodeID,data)
	q result
}

/// Description:   取标准手术记录数据XML接口
/// Creator:       Donglulu
/// CreateDate:    2016-10-11        
/// Input：        AEpisodeID 就诊ID 
///                AOparID 手术ID
/// Output         result 1成功 0失败
/// Debug:         w ##Class(EMRservice.BIEMRService).GetStandardOperationData("","")
ClassMethod GetStandardOperationData(AEpisodeID As %String, AOparID As %String) As %String
{
	s methodResult = 0
	q:((AEpisodeID = "")||(AOparID = "")) methodResult
	s methodResult = ##Class(EMRservice.BL.Event.BLOperation).SetStandardOperationData(AEpisodeID,AOparID)
	q methodResult
}

/// Description:   根据术语集代码取电子病历数据接口
/// Creator:       yejian
/// CreateDate:    2016-7-14        
/// Input：        AEpisodeID:就诊号 
///                ATemplateID:模板ID
/// 				   AGlossaryInternalID:术语集标识符
/// Output         术语集对应该电子病历单元值
///                类型：数组 
///                格式：[{"术语代码1":"实例ID[]值&实例ID[]值&实例ID[]值"},{"术语代码2":"实例ID[]值&实例ID[]值&实例ID[]值"},...}]
/// debug	d ##Class(EMRservice.BIEMRService).GetDataByGlossaryTemplateID("112","5","HDSD00.14.02")
ClassMethod GetDatasByGlossaryTemplateID(AEpisodeID As %String, ATemplateID As %String, AGlossaryInternalID As %String) As %ArrayOfDataTypes
{
	q ##Class(EMRservice.BL.BLGlossary).GetDatasByGlossaryTemplateID(AEpisodeID,ATemplateID,AGlossaryInternalID)
}

///  Creator:    Donglulu
///  CreateDate: 2016-07-25
///  Desc:       根据就诊号获取病历全部完成日期和时间接口
///  Input:      AEpisodeID:就诊号
///  return:     result：全部完成日期和时间，以"^"分隔，没全部完成返回空  
///  Debug:      w ##Class(EMRservice.BIEMRService).GetAdmRecordCompletedDateTime("230")
ClassMethod GetAdmRecordCompletedDateTime(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s AdmRecordStatusID = ""
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,AdmRecordStatusID))	
    q:(AdmRecordStatusID = "") result
	s AdmRecordStatus = ##Class(EMRinstance.AdmRecordStatus).%OpenId(AdmRecordStatusID)
	q:(AdmRecordStatus = "") result
	s result = AdmRecordStatus.CompletedStatus
	q:(result '= 1) result
	s result = AdmRecordStatus.FinishDate_"^"_AdmRecordStatus.FinishTime
    d AdmRecordStatus.%Close()	
	k AdmRecordStatus
	q result
}

/// Desc:	获取指定日期内病案首页有院内感染诊断的患者List
/// Input：	AStartDisDate 开始日期，Cache内部格式，整数值
/// 		AEndDisDate   结束日期，Cache内部格式，整数值
/// 			ADateType	  日期类型，D 出院日期，A 入院日期
/// Debug:	w ##Class(EMRservice.BIEMRService).GetNosocomialInfectionList("64200","64211","D")
/// 			w ##Class(EMRservice.BIEMRService).GetNosocomialInfectionList("64200","64211","A")
ClassMethod GetNosocomialInfectionList(AStartDisDate As %String, AEndDisDate As %String, ADateType As %String = "D") As %List
{
	q ##Class(EMRservice.Record.FP).GetNosocomialInfectionList(AStartDisDate, AEndDisDate, ADateType)
}

///  Creator:      guozongtao
/// Description:   共享文档访问接口函数
/// Input：        argInMessage :命令信息 JSON格式  {"params":{"EisodeID":"1","InternalID":"HDSD00.03","InstanceID":"1||16"},"Products":"GlobalEMR"}
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BIEMRService).EMRDocumentSDServer(argInMessage,argOutMessage,argOutMessage)	
ClassMethod EMRDocumentSDServer(ByRef argInMessage As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String [ WebMethod ]
{
    s ReturnValue=""
	s argOutData=##Class(%GlobalCharacterStream).%New()
	s argOutMessage=##Class(%GlobalCharacterStream).%New()
	
	//解析json参数		       
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInMessage)
	s strProducts = array.GetAt("Products")

	if (strProducts="GlobalEMR")
	{
		s ReturnValue=##Class(EMRservice.BL.BLEMRDocumentSDServer).AcitonProxy(argInMessage,argOutMessage,argOutData)
	}
	
	q ReturnValue
}

///  Creator:      guozongtao
/// Description:   更新数据组中心的电子病历共享文档队列
/// Input：        argInstnceID :病历实例数据ID
/// Return：       队列插入是否成功^队列数据ID  (0^%Id) 成功
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BIEMRService).UpdateEMRDocumentQueue("12||2")	
ClassMethod UpdateEMRDocumentQueue(argInstnceID As %String, argAction As %String) As %String
{
	//根据传入的InstanceID构造数据中心的队列更新方法的入参 格式：{"params":{"EisodeID":"1","InternalID":"HDSD00.03","InstanceID":"1||16"},"Action":"Save","Products":"GlobalEMR"}
	//调用数据中心的队列更新方法
	
	s InputMessage=""
	s objInstance=##Class(EMRinstance.InstanceData).%OpenId(argInstnceID)
	s InternalID=##class(EMRservice.BL.BLTempGloCateMap).GetGloCateInternalID(objInstance.RealTemplateID,objInstance.TitleCode)
	
	s InputMessage="{""params"":{""EpisodeID"":"""_objInstance.RealEpisodeID_""",""InternalID"":"""_InternalID_""",""InstanceID"":"""_argInstnceID_"""},""Action"":"""_argAction_""",""Products"":"""_"GlobalEMR"_"""}"
	s ret= ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000053",InputMessage)
	q ret
}

/// Desc:  获取病历是否保存
/// Input: argAdmID 就诊号
///        DocInfo 病历目录展现结构第三层ID,如果需要取某标题，需要将标题Code一起传过来,ID与标题Code 用"｜"分隔 如下:53｜1 
/// Output:result Save 已保存, UnSave 未保存, ""为空是参数有问题
/// Debug: w ##class(EMRservice.BIEMRService).GetDocumentStatus(argAdmID,DocInfo)         
ClassMethod GetDocumentStatus(argAdmID As %String, DocInfo As %String) As %String
{
	s result = ""
	q:(argAdmID = "")||(DocInfo = "") result
	s DocID = $p(DocInfo,"|",1)
	s TitleCode = $p(DocInfo,"|",2)
	s result =  ##Class(EMRservice.BL.BLInstanceData).GetDocumentStatus(argAdmID,DocID,TitleCode)
	q $p(result,"^",1)
}

/// Desc:  获取给医保组接口页的CSP地址
/// Input: argAdmID 就诊号
///        strDocInfo 病历目录展现结构第三层docId串,DocID串以"^"分隔 
/// 		   defaultCollapse  值为CREATLIST:默认展开左侧新建目录 值为RECORDLIST:默认展开左侧病历目录
/// Output:CSP地址， 例：http://127.0.0.1/dthealth/web/csp/emr.interface.record.edit.forinsu.csp?argAdmID=230&strDocInfo=52&defaultCollapse=RECORDLIST
/// Debug: w ##class(EMRservice.BIEMRService).InterfaceRecordeditForInsu(230,53,"RECORDLIST")         
ClassMethod InterfaceRecordeditForInsu(argAdmID As %String, strDocInfo As %String, defaultCollapse As %String = "") As %String
{
	s result = ""
	q:(argAdmID = "")||(strDocInfo = "") result
	s result = "emr.interface.record.edit.forinsu.csp?argAdmID="_argAdmID_"&strDocInfo="_strDocInfo_"&defaultCollapse="_$zcvt(defaultCollapse,"U")
	q result
}

/// Desc:       取病历日期下病历
/// Creator:    Candy
/// CreateDate: 2016-12-19 日期格式 yyyy-mm-dd
/// Input:      AEpisodeID 就诊号
///             ADocID 所查病历目录展现结构ID(目录展现结构第三层)
///             ADate 日期
/// Output:     result
/// Debug: 	   w ##class(EMRservice.BIEMRService).GetInstanceInfoByDate(112,56,"2016-12-19")
ClassMethod GetInstanceInfoByDate(AEpisodeID As %String, ADocID As %String, ADate As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLInstanceData).GetInstanceByDate(AEpisodeID,ADocID,ADate)
	q result
}

/// Desc:       患者就诊是否已书写病历
/// Creator:    Candy
/// CreateDate: 2017-1-11
/// Input:      AEpisodeID 就诊号
/// Output:     result  1 写, 0 未写, "" 出错
/// Debug:      w ##Class(EMRservice.BIEMRService).HasRecord("76")
ClassMethod HasRecord(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s result = "0"
	s id = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID, ""))
	s:(id '= "") result = "1"
	q:(result = "1") result
	s id = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID, ""))
	q:(id = "") result 
	s:($d(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE"))>0) result = "1"
	q result
}

/// Creator:    Lina
/// Description:病历模板目录树
/// OutPut:		CategoryId   目录CategoryId
/// 			CategoryName 目录名称
///             CategoryType 目录节点类型
/// Debug:      w ##Class(EMRservice.BIEMRService).GetAllCategory()	
ClassMethod GetAllCategory() As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	s resultJson = ##Class(EMRservice.BL.BLEMRTemplateCategory).GetAllCategory()
	q:(resultJson.Size = 0) json
	d json.CopyFrom(resultJson)
	q json
}

/// Desc:       按DocID取标题信息
/// Creator:    Lina
/// CreateDate: 2016-12-15
/// Input:      ADocId 目录展现结构挂模板一层的目录Id
/// Output:     json 标题信息Json  
/// Debug:      w ##Class(EMRservice.BIEMRService).GetTitleByDocID(66)
ClassMethod GetTitleByDocID(ADocId As %String) As %String
{
	s json = ""
	q:(ADocId = "") json
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLTitleConfig:GetTitleByDocID")
	d ds.Execute(ADocId,"")
	While (ds.Next())
	{
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""TitleCode"":"""_ds.Data("ACode")_""""
		s json = json_",""TitleDesc"":"""_ds.Data("ADesc")_"""" 
		s json = json_"}"
		s count = count + 1
	}
	q json
}

/// Creator:    Lina
/// Description:根据AType类型以及查询时间返回病历目录列表
/// Input:      ADocId     目录展现结构挂模板一层的目录Id
/// 			ATitleCode 标题Code
///             AStartDate 开始查询日期
///             AEndDate   结束查询日期
///             AType      查询时间类型,目前只有CreateDateTime一种类型
/// Output:     病历目录列表Json
/// Debug:      w ##Class(EMRservice.BIEMRService).GetRecordCatalogByDate(66,"EMR100001","2016-1-01","2016-12-15","CreateDateTime")	
ClassMethod GetRecordCatalogByDate(ADocId As %String, ATitleCode As %String = "", AStartDate As %String, AEndDate As %String, AType As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(ADocId = "")||(AStartDate = "")||(AEndDate = "")||(AType = "") json
	s resultJson = ##Class(EMRservice.BL.BLEMRTemplateCategory).GetRecordCatalogByDate(ADocId,ATitleCode,AStartDate,AEndDate,AType)
	q:(resultJson.Size = 0) json
	d json.CopyFrom(resultJson)
	q json
}

/// Desc:       导出CDRxml
/// Creator:    Candy
/// CreateDate: 2017-2-23
/// Input:      artInMessage 输入信息
/// Output:     stream CDR xml
/// Debug:      w ##Class(EMRservice.BIEMRService).EMRForCDRService("{""InstanceID"":""2||1"",""Action"":""GetDocXml""}")
ClassMethod EMRForCDRService(argInMessage As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s result = ##Class(%GlobalCharacterStream).%New()
	q:(argInMessage = "") result
	s globInMessage = ##Class(%GlobalCharacterStream).%New()
	d globInMessage.Write(argInMessage)
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(globInMessage)
	s action = array.GetAt("Action")
	if (action = "GetCategoryList")
	{
		s episodeId = array.GetAt("EpisodeID")
		d result.CopyFrom(##Class(EMRservice.Export.CDRXml).GetInstanceIDs(episodeId))
	}
	elseif (action = "GetDocXml")
	{
		s instanceId = array.GetAt("InstanceID")
		d result.CopyFrom(##Class(EMRservice.Export.CDRXml).GetCDRXml(instanceId))
	}
	q result
}

/// Desc:  导出cdrxml
/// Input: argTemplateID 模板ID
///       argVersion    模板版本
///       argCount      导出数目
ClassMethod TestGetCDRXML(argTemplateID As %String, argVersion As %String, argCount As %String) As %String
{
	q:(argTemplateID="")||(argVersion="")||(argCount="") "0"
	s num = ""
	s count = 0
	for
	{
		s num = $o(^DHCEMRI.InstanceDataI("IdxListNoTemplateIDVersion",argTemplateID,argVersion,num))
		q:(num = "")
		s ecrecordId = ""
		for
		{
			q:(argCount >= count)
			s ecrecordId = $o(^DHCEMRI.InstanceDataI("IdxListNoTemplateIDVersion",argTemplateID,argVersion,num,ecrecordId))
			q:(ecrecordId = "")
			s sub = $tr(num," ","")
			s instanceId = ecrecordId_"||"_sub
			s argMessage = "{""InstanceID"":"""_instanceId_""",""Action"":""GetDocXml""}"
			s result = ##Class(EMRservice.BIEMRService).EMRForCDRService(argMessage)
			s AStream=##Class(%FileCharacterStream).%New()
			s filename = "d:\cdrdoc"_ecrecordId_"_"_sub_".xml"
			s AStream.Filename = filename
			d AStream.CopyFrom(result)
			d AStream.SaveStream()
			d AStream.%Close()
			s count = count + 1
		}
	}
	q "1"
}

/// Debug:   w ##Class(EMRservice.BIEMRService).GetUnFinishedDocuments(105,112)
ClassMethod GetUnFinishedDocuments(argUserID As %String, argEpisodeID As %String) As %Library.ResultSet
{
	s result = ##class(%ResultSet).%New("EMRservice.HISInterface.QueryInterface:GetUnfinishedInstance")
	d result.Execute(argUserID,argEpisodeID)
	q result
}

/// Debug:         w ##Class(EMRservice.BIEMRService).PushInstance()	
ClassMethod PushInstance(AdmStartDate As %String, AdmEndDate As %String) As %String
{
	//s AdmEndDate=AdmStartDate
	s adm=1,count=0,InstanceID=""
	for i=AdmStartDate:1:AdmEndDate
	{
		for
		{
			s adm=$o(^PAADMi("AdmDateCurr",i,adm))
			
			q:adm=""
			&sql(select ID INTO :InstanceID from EMRinstance.InstanceData WHERE Status="Save" and TemplateID=1104 and EpisodeID=:adm)
			
			q:InstanceID=""
			d ##Class(EMRservice.BIEMRService).UpdateEMRDocumentQueue(InstanceID,"EMR.Save")
			s count=count+1
			//q:(count>10)
		}
	}
	q "共发送"_count_"份病历"
}

/// edit   : yan 2017-10-11
/// Desc   : 判断全部病历是否存在有效签名
/// input  : 就诊号
/// output : 1:所有病历均签名；0:存在未签名病历
/// debug: : w ##Class(EMRservice.BIEMRService).GetAllInsHasSign(239)
ClassMethod GetAllInsHasSign(AEpisodeId As %String) As %String
{
    s result = "" ,issign = "" ,flag = ""
    q:(AEpisodeId = "") result
    s date = ""
    for
    {
        s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date))
        q:(date = "")
        s time = ""
        for
        {
            s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date,time))
            q:(time = "")
            s parentId = ""
            for
            {
                s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date,time,parentId))
                q:(parentId = "")
                s subId = ""
                for
                {
                    s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId," SAVE",date,time,parentId,subId))
                    q:(subId = "")
                    s tmpinstanceID=parentId_"||"_subId
                    s flag = ##class(EMRservice.BOPrivAssist).HasValidSign(tmpinstanceID)
                    if (flag = "0") {s issign=0}
                }
            }
        }
    }
    s result = 1
    //无病历 返回0
    s:(flag = "") result = 0
    //存在病历未签名 返回0
    s:(issign = 0) result = 0
    q result
}

/// Description:   提供外部设置电子病历医生级别接口接口
/// Creator:       yejian
/// CreateDate:    2017-12-13        
/// Input：        aSSGroupID:安全组ID
///                aUserID:用户id
/// 				   aUserLevel:医生级别 (住院医师:Resident,主治医师:Attending,主任/副主任医师:Chief,实习医师:intern,未分配:"")
/// 				   aUserPos:用户职务 (科主任:Chairman,质控医师:QCDoc,质控护士:QCNurse,责任护士:ChargeNurse,未分配:"")
/// Output         设置结果
///                类型：字符
///                格式：成功 1，失败 -1
/// Debug:         w ##Class(EMRservice.BIEMRService).SetPowerUserInter("29","359","Attending","")	
ClassMethod SetPowerUserInter(aSSGroupID As %String, aUserID As %String, aUserLevel As %String, aUserPos As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPowerUser).SetPowerUserInter(aSSGroupID,aUserID,aUserLevel,aUserPos)
}

/// Desc:       获得当前目录状态
/// Creator:    Candy
/// CreateDate: 2017-10-10
/// Input:      ACTLocID 科室ID
///             ASSGroupID 安全组ID
///             AEpisodeID 就诊号
///             ACategoryID 目录分类ID(目录展现结构第一层ID)
/// Output:     {"Visible":"1","Sequence":"0"} Visible 为1可见0不可见  Sequence 目录的所在顺序
/// Debug:      w ##Class(EMRservice.BIEMRService).GetCategoryStatus(190,29,456392,3)
ClassMethod GetCategoryStatus(ACTLocID As %String, ASSGroupID As %String, AEpisodeID As %String, ACategoryID As %String) As %String
{
	q ##Class(EMRservice.BL.BLClientCategory).GetCategoryStatus(ACTLocID,ASSGroupID,AEpisodeID,ACategoryID)
}

///  Creator:    Donglulu
///  CreateDate: 2018-01-08
///  Desc:       获取该次就诊某位医生有哪些检验项没有引用
///  Input:      AEpisodeID:就诊号   AUserID：用户ID
///  return:     result 未引用过的检验项ID   
///  Debug:      w ##Class(EMRservice.BIEMRService).GetNotReferenceLisID("230","")
ClassMethod GetNotReferenceLisID(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLLisdataReference).GetNotReferenceLisID(AEpisodeID,AUserID)
	q result
}

/// Desc:	根据术语集代码取电子病历数据接口(返回所有关联模板值)
/// Creator:       yejian
/// CreateDate:    2016-7-14        
/// Input：        AEpisodeID:就诊号 
///                ATemplateID:模板ID
/// 				   AGlossaryInternalID:术语集标识符
/// Output         术语集对应该电子病历单元值
///                类型：数组 
///                格式：[{"术语代码1":"实例ID[]值&实例ID[]值&实例ID[]值##实例ID[]值&实例ID[]值&实例ID[]值"},{"术语代码2":"实例ID[]值&实例ID[]值&实例ID[]值##实例ID[]值&实例ID[]值&实例ID[]值"},...}]/// Debug:
/// debug	d ##Class(EMRservice.BIEMRService).GetNewDataByGlossaryCategory("112",,"HDSD00.11")
ClassMethod GetNewDataByGlossaryCategory(AEpisodeID As %String, AGlossaryInternalID As %String) As %ArrayOfDataTypes
{
	q ##Class(EMRservice.BL.BLGlossary).GetNewDataByGlossaryCategory(AEpisodeID,AGlossaryInternalID)
}

/// Desc:       取病历签名信息
/// Creator:    Candy
/// CreateDate: 2018-2-9
/// Input:      AInstanceID 病历ID
///             ACheckLevel 签名级别 如:viceChiefCheck
/// Output:     签名信息
ClassMethod GetDocumentSignInfo(AInstanceID As %String, ACheckLevel As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRSign).GetDocumentSign(AInstanceID,ACheckLevel)
}

/// Desc: 		更改医师级别
/// Creaotr:    董璐璐
/// CreateDate: 2018-2-27
/// Input:      AUserID
///             AUserLevel：医师级别  Resident（住院医师） Attending（主治医师）
///             					  Chief（主任医师） ViceChief（副主任医师）intern（实习医师）
/// Output      result 1成功 0失败
/// Debug: 		w ##Class(EMRservice.BIEMRService).UpdateUserLevel(180,"Resident")
ClassMethod UpdateUserLevel(AUserID As %String, AUserLevel As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLPowerUser).UpdateUserLevel(AUserID,AUserLevel)
	q result
}

/// creator:yhy  
/// Create Date:	2017-06-12
/// Description:获取最新的病程记录
/// Return:    创建时间_标题
/// debug: w ##Class(EMRservice.BIEMRService).GetEMRRecordInfo()
ClassMethod GetEMRRecordInfo(AEpsoidID As %String) As %String
{
	s ret = ""
	q:(AEpsoidID="") ret
	s ChartItemID = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("DailyRecordDocID")
	s ECRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpsoidID, ChartItemID, ""))
	q:(ECRecordID="") ret
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ECRecordID)
	s count = objECRecord.InstanceCount
	for 
	{
		q:(0=count)
		s objInstance = objECRecord.Instances.GetAt(count)
		if (objInstance.Status="Save")
		{
			s HISFormatHappenDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objInstance.HappenDate)
			s HISFormatHappenTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objInstance.HappenTime)
			s createDT = HISFormatHappenDate_" "_HISFormatHappenTime
			s title = objInstance.Title
			s ret = createDT_" "_title
			q
		}
		s count = count -1
	}
	q ret
}

/// Desc:获取上及医师
/// Creator:Candy
/// CreateDate:2019-1-15
/// Input:  AEpisodeID  就诊号
///         AUserID 用户ID
///         ALocID 科室ID
/// Output: superiorDoc 上级医师ID 
/// Debug:  w ##Class(EMRservice.BIEMRService).GetSuperiorDoc(EpisodeID,UserID,LodID)
ClassMethod GetSuperiorDoc(AEpisodeID As %String, AUserID As %String, ALocID As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLMessage).GetSuperiorDoc(AEpisodeID,AUserID,ALocID)
}

/// Creator:    DongLulu
/// Description:根据就诊号返回病历目录列表
/// Input:      AEpisodeId     就诊号
/// Output:     病历目录列表Json
/// Debug:      w ##Class(EMRservice.BIEMRService).GetRecordCategory(4)	
ClassMethod GetRecordCategory(AEpisodeId As %String) As %GlobalBinaryStream
{
	s json = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeId = "") json
	s resultJson = ##Class(EMRservice.BL.BLClientCategory).GetBrowseCategory(AEpisodeId)
	q:(resultJson.Size = 0) json
	d json.CopyFrom(resultJson)
	q json
}

}
