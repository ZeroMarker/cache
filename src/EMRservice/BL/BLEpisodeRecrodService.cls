/// Desc:患者病历服务
/// Creator:Candy
/// CreateDate:2018-6-14
Class EMRservice.BL.BLEpisodeRecrodService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/biservice";

/// Name of the WebService.
Parameter SERVICENAME = "BLEpisodeRecrodService";

/// Desc:       取病历数据服务,先取患者所写病历目录,再根据获得病历目录，使用术语代码取其值
/// Creator:    Candy
/// CreateDate: 2018-6-4
/// Input:      argInMessage  入参 例：
///             取目录
///             {"action":"GetRecordCategory","params":{"EpisodeID":"315","InternalCategoryID":""}}
///             "action":"GetRecordCategory" 取所写病历目录
///             "EpisodeID":"315"  就诊号
///             "InternalCategoryID":"HDSD00.11"  取某指定病历,为空时取所有病历,多个以"^"分隔
///             取内容（术语内容）
///             {"action":"GetDataByGlossaryCategory","params":{"EpisodeID":"315","InternalCategoryID":"HDSD00.11"}} 
///             "action":"GetDataByGlossaryCategory" 根据术语目录代码取病历内容
///             "EpisodeID":"315"  就诊号
///             "InternalCategoryID":"HDSD00.11^HDSD00.13"  取病案首页和入院记录的数据内容 
///             取病历文档内容
///             {"action":"GetDocContent","InstanceID":"168||1"}  
/// Output:     病历目录
///             <Categorys><Category><Name>病案首页</Name><InstanceID>168||1</InstanceID><InternalID>HDSD00.11</InternalID></Category>……<Categorys>
///             病历内容
///             <Contents><Content><InternalID>HDSD00.11.003</InternalID><Value>A</Value></Content>……</Contents>  
///             病历文件 
///             <Content><Section><Name></Name><Value></Value><Section><Name></Name><Value></Value>……<Section></Section></Content>                
ClassMethod GetEpisodeRecrod(argInMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInMessage)
	s action = array.GetAt("action")
	if (action = "GetRecordCategory")
	{
		s episodeId = array.GetAt("params").GetAt("EpisodeID")
		s internalCategoryId = array.GetAt("params").GetAt("InternalCategoryID")
		d argOutData.CopyFrom(..GetRecordCategory(episodeId,internalCategoryId))
	}
	elseif (action = "GetDataByGlossaryCategory")
	{
		s episodeId = array.GetAt("params").GetAt("EpisodeID")
		s internalId = array.GetAt("params").GetAt("InternalID")
		s instanceId = array.GetAt("params").GetAt("InstanceID")
		d argOutData.CopyFrom(..GetDataByGlossaryCategory(episodeId,internalId,instanceId))
	}
	elseif(action = "GetDocContent")
	{
		s instanceId = array.GetAt("params").GetAt("InstanceID")
		d argOutData.CopyFrom(..GetDocumentContent(instanceId))
	}
	q "1"
}

/// Desc:       取病历目录
/// Creator:    Candy
/// CreateDate: 2018-6-4
/// Input:      argEpisodeID 就诊号
///             argInternalCategoryID  病历术语目前ID 例如：住院病案首页 HDSD00.11 多个以"^"分隔
/// Output:     <Categorys><Category><Name>病案首页</Name><InstanceID>168||1</InstanceID><InternalID>HDSD00.11</InternalID></Category>……<Categorys>
/// Debug:      w ##Class(EMRservice.BL.BLEpisodeRecrodService).GetRecordCategory(315)
ClassMethod GetRecordCategory(argEpisodeID As %String, argInternalCategoryID As %String = "") As %GlobalBinaryStream [ WebMethod ]
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(argEpisodeID = "") result
	d result.Write("<Categorys>")
	if (argInternalCategoryID '= "")
	{
		for I=1:1:$l(argInternalCategoryID,"^")
		{
			s tmpInternalCategoryID = $p(argInternalCategoryID,"^",I)
			
			s glCategoryId = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_tmpInternalCategoryID,""))
			continue:(glCategoryId = "")
			
			s docId = $o(^DHCEMRM.EMRTemplateI("IdxInternalID"," "_tmpInternalCategoryID,""))
			s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",argEpisodeID,docId,""))
			d GetJson
		}
	}
	else
	{
		s docId = ""
		for
		{
			s docId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",argEpisodeID,docId))
			q:(docId = "")
			s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",argEpisodeID,docId,""))
			continue:(ecrecordId = "")
			d GetJson
		}
	}
	d result.Write("</Categorys>")
	q result
GetJson
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceDataI("IdxECRecord",ecrecordId,subId))
		q:(subId = "")
		s instanceId = ecrecordId_"||"_subId
		s obj = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
		continue:(obj = "")
		continue:(obj.Status '= "Save")
		s emrtemplateId = $o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_obj.TheECRecord.RealChartItemID,""))
		continue:(emrtemplateId = "")
		s objEmrTemplate = ##Class(EMRmeta.EMRTemplate).%OpenId(emrtemplateId)
		d result.Write("<Category>")
		d result.Write("<Name>"_obj.Title_"</Name>")
		d result.Write("<InstanceID>"_instanceId_"</InstanceID>")
		d result.Write("<InternalID>"_objEmrTemplate.InternalID_"</InternalID>")
		d result.Write("</Category>")
	}
	q
}

/// Desc:       取病历数据内容
/// Creator:    Candy
/// CreateDate: 2018-6-4
/// Input:      argEpisodeID 就诊号
///             argInternalID  病历术语ID
///             
/// Output:     <Contents><Content><InternalID>HDSD00.11.003</InternalID><Value>A</Value></Content>……</Contents>
/// Debug:      w ##Class(EMRservice.BL.BLEpisodeRecrodService).GetDataByGlossaryCategory(315,"HDSD00.11")
ClassMethod GetDataByGlossaryCategory(argEpisodeID As %String, argInternalCategoryID As %String, argInstanceID As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(argEpisodeID = "")||(argInternalCategoryID = "") result
	s dataList =  ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(argEpisodeID,argInternalCategoryID,argInstanceID)
	q:(dataList = "") result
	d result.Write("<Contents>")
	s inernalId = ""
	for
	{
		s value = dataList.GetNext(.inernalId)
		q:(inernalId = "")
		d result.Write("<Content>")
		d result.Write("<InternalID>"_inernalId_"</InternalID>")
		d result.Write("<Value>"_value_"</Value>")
		d result.Write("</Content>")
    }
    d result.Write("</Contents>")
    q result
}

/// Desc: 取病历内容
/// Creator:Candy
/// CreateDate:2019-1-21
/// Input: argInstanceID 病历ID
/// Debug: w ##Class(EMRservice.BL.BLEpisodeRecrodService).GetDocumentContent("105||5")
ClassMethod GetDocumentContent(argInstanceID As %String) As %GlobalBinaryStream
{
	s streamContent = ##class(%GlobalBinaryStream).%New()
	q:(argInstanceID = "") streamContent
	
	/*
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(argInstanceID)
	q:(objInstance = "") streamContent
	q:(objInstance.Status '= "Save") streamContent
	s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(objInstance.InstanceData,"<ScatterData","</ScatterData>","14")
	s sc =##class(%XML.XPATH.Document).CreateFromStream(streamScatterData,.scatterData)
	q:($$$ERROR(sc)) streamContent
	s sc = scatterData.EvaluateExpression("/ScatterData/Component","count(Section)",.sections)
	q:($$$ERROR(sc)||(sections.GetAt(1)="")) streamContent
	s count = sections.GetAt(1).Value
	d streamContent.Write("<Content>")
	for i=1:1:count
	{
		set sc=scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Code","@DisplayName",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))	
		d streamContent.Write("<Section>")	
		s sectionName = result.GetAt(1).Value	
		d streamContent.Write("<Name>"_sectionName_"</Name>")
		s sc = scatterData.EvaluateExpression("/ScatterData/Component/Section["_i_"]/Text","text()",.result)
		continue:($$$ERROR(sc)||(result.GetAt(1)=""))
		s value = result.GetAt(1).Value
		d streamContent.Write("<Value>"_value_"</Value>")	
		d streamContent.Write("</Section>")	
	}
	d streamContent.Write("</Content>")
	q streamContent
	*/
	d streamContent.CopyFrom(##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent(argInstanceID))
	
	q streamContent
}

}
