Class web.DHCCM.EMRservice.BL.BLInstanceData Extends %RegisteredObject
{

/// Creator：      Candy
/// CreatDate：    2014-4-16
/// Description:   判断目录展现结构下，模板有没有实例化
/// Table：        
/// Input: 	       EpisodeId 就诊rowid
/// 		       TemplateId 界面模板id
///                DocID 目录展现结构id
/// Output         
/// Return：       函数返回值的说明
/// Others：       其它说明
/// w ##Class(EMRservice.BL.BLInstanceData).IsHasInstance("76",50,616)
ClassMethod IsHasInstance(EpisodeId As %String, TemplateId As %String, DocID As %String)
{
	s result = "0"
	q:(EpisodeId="")||(DocID="") result 
	s ChartItemID = DocID
	s ECRecordID = $o(^DHCPHI.ECRecordI("IdxEpisodeIDChartItemID"," "_EpisodeId," "_ChartItemID,""))
    q:(ECRecordID = "") result
    
    s data = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",""))
    q:(data = "") result
    s time = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",data,""))
    q:(time = "") result
    s instanceSubId = $o(^DHCPHI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",data,time,""))  
    q:(instanceSubId = "") result
    s result = ECRecordID_"||"_instanceSubId
	q result
}

/// CreateTime: 2014-04-3
/// Creator:    candy
/// Desc:		创建病历文档
/// Input:		ADocID: 电子病历界面模板的目录ID
/// 			AEpisodeID:就诊号
/// 			APatientID:APatientID
/// OutPut:     objDoc:新建文档流数据
///             InstanceID 实例数据ID
/// debug:   w ##Class(EMRservice.BL.BLInstanceData).CreateDocument(601,76,48,"","","")
ClassMethod CreateDocument(ADocID As %String, AEpisodeID As %String, APatientID As %String, ATitle As %String, ATitleCode As %String, ADataTime As %String, ByRef objDoc As %GlobalBinaryStream) As %String
{
 	s instanceID = ""
	q:((ADocID = "")||(AEpisodeID = "")) instanceID
	s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEMRTemplateCategoryDoc = "") instanceID
	s leadFrame = objEMRTemplateCategoryDoc.IsLeadframe
	
	s objEMRTemplateCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEMRTemplateCategoryDoc.ParentCategoryID)
	q:(objEMRTemplateCategoryChapter = "")
	s chapterName = objEMRTemplateCategoryChapter.CategoryName
	s EMRTemplateID = ""
	s:(ATitleCode '= "") EMRTemplateID = $tr($o(^DHCEMRM.TitleConfigI("IdxCategoryTitleCodeTemplate"," "_objEMRTemplateCategoryDoc.ParentCategoryID," "_ATitleCode,""))," ","")
	if (EMRTemplateID = "")
	{
		s EMRTemplateID = $o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_ADocID,""))
		q:(EMRTemplateID = "") instanceID
	}
	
	s objEMRTemplate = ##Class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
	q:(objEMRTemplate = "") instanceID
	
	s templateCategoryID = objEMRTemplate.BindTemplateCategoryID           //模板目录ID
	s objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(templateCategoryID)
	q:(objTemplateCategory = "") instanceID
	
	s templateID = objEMRTemplate.BindTemplateID                          //模板ID	
	s objTemplate = ##class(EMRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") instanceID
	//生成实例ID
	s objEInstanceData = ##Class(EMRservice.entity.EInstanceData).%New()
	s objEInstanceData.GroupItemID = templateCategoryID
	s objEInstanceData.GroupItemName = objTemplateCategory.Name
	s objEInstanceData.Status = "UnSave"
	s date = $p(ADataTime," ",1),time = $p(ADataTime," ",2)
	s objEInstanceData.HappenDate = $Case(date,"":"",:$zdh(date,3))
	s objEInstanceData.HappenTime = $Case(time,"":"",:$zth(time))
	s objEInstanceData.Title = $case(objTemplate.ChartItemType="Single",1:chapterName,:ATitle)
	s objEInstanceData.TitleCode = $case(objTemplate.ChartItemType="Single",1:"",:ATitleCode)
	s objEInstanceData.TemplateID = templateID
	s objEInstanceData.TemplateVersion = objTemplate.PublishVersion
	s objEInstanceData.EpisodeID = AEpisodeID
	
	s objEECRecord = ##Class(EMRservice.entity.EECRcord).%New()
	s objEECRecord.PatientID = APatientID
	s objEECRecord.EpisodeID = AEpisodeID
	s objEECRecord.CategoryID = templateCategoryID
	s objEECRecord.CategoryType = "Normal"
	s objEECRecord.ChartItemType = objTemplate.ChartItemType
	s objEECRecord.DocumentType = objTemplate.DocumentType
	s objEECRecord.DocumentCharacteristic = $case(leadFrame,"1":1,:0)
	//s objEECRecord.GroupCategoryID = ADocID

	s objEECRecord.EpisodeType = $P($G(^PAADM(AEpisodeID)),"^",2)
	s rowID = $o(^DHCPHI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ADocID,""))
	if (rowID = "")
	{
		s objEECRecord.ID = ""
		s objEECRecord.InstanceCount = 1
		s objEECRecord.ChartItemID = ADocID
		s instanceID = ""
		s instanceID = ..SetECRInstanceData(objEECRecord,objEInstanceData)
		
	}else
	{
		s objEECRecord.ID = rowID
		s objEECRecord.InstanceCount =  +$li(^DHCPHI.ECRecordD(rowID),9)+1
		s objEECRecord.ChartItemID = ADocID
		s instanceID = ""
		s instanceID = ..SetECRInstanceData(objEECRecord,objEInstanceData)
		
	}
	if ((instanceID '= "")&&(objDoc '= ""))
	{

		d objDoc.CopyFrom(..GetNewDocByTemplateID(templateID,objTemplate.PublishVersion))
		
	}
	d objTemplateCategory.%Close(),objTemplate.%Close()
	k objTemplateCategory,objTemplate
	q instanceID
}

/// CreateTime: 2016-1-6
/// Creator:    yejian
/// Desc:		创建模板绑定测试文档
/// Input:		ADocID: 电子病历界面模板的目录ID
/// 			AEpisodeID:就诊号
/// 			APatientID:APatientID
/// OutPut:     objDoc:新建文档流数据
///             InstanceID 实例数据ID
/// debug:   w ##Class(EMRservice.BL.BLInstanceData).CreateDocument(601,76,48,"","","")
ClassMethod CreateTestDocument(ADocID As %String, AEpisodeID As %String, APatientID As %String, ATitle As %String, ATitleCode As %String, ADataTime As %String, ByRef objDoc As %GlobalBinaryStream) As %String
{
 	s instanceID = ""
	q:((ADocID = "")||(AEpisodeID = "")) instanceID
	s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEMRTemplateCategoryDoc = "") instanceID
	s leadFrame = objEMRTemplateCategoryDoc.IsLeadframe
	
	s objEMRTemplateCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEMRTemplateCategoryDoc.ParentCategoryID)
	q:(objEMRTemplateCategoryChapter = "")
	s chapterName = objEMRTemplateCategoryChapter.CategoryName
	s EMRTemplateID = ""
	s:(ATitleCode '= "") EMRTemplateID = $tr($o(^DHCEMRM.TitleConfigI("IdxCategoryTitleCodeTemplate"," "_objEMRTemplateCategoryDoc.ParentCategoryID," "_ATitleCode,""))," ","")
	if (EMRTemplateID = "")
	{
		s EMRTemplateID = $o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_ADocID,""))
		q:(EMRTemplateID = "") instanceID
	}
	
	s objEMRTemplate = ##Class(EMRmeta.EMRTemplate).%OpenId(EMRTemplateID)
	q:(objEMRTemplate = "") instanceID
	
	s templateCategoryID = objEMRTemplate.BindTemplateCategoryID           //模板目录ID
	s objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(templateCategoryID)
	q:(objTemplateCategory = "") instanceID
	
	s templateID = objEMRTemplate.BindTemplateID                          //模板ID	
	s objTemplate = ##class(EMRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") instanceID

	s instanceID = "-1"
	if ((instanceID '= "")&&(objDoc '= ""))
	{
		////模板绑定测试时，取最新的版本的数据
		d objDoc.CopyFrom(..GetNewDocByTemplateID(templateID,objTemplate.LastVersion))
		
	}
	d objTemplateCategory.%Close(),objTemplate.%Close()
	k objTemplateCategory,objTemplate
	q instanceID
}

/// CreateTime: 2014-04-03
/// Creator:    candy
/// Desc:		保存ECRecord
/// Input:		AEECRecord:APatientID
/// 			AEInstanceData:就诊号
/// OutPut:     result: 返回InstanceData表ID
ClassMethod SetECRInstanceData(AEECRecord As EMRservice.entity.EECRcord, AEInstanceData As EMRservice.entity.EInstanceData) As %String
{
	s result = ""
	//保存ECRecord表初始化数据
	if (AEECRecord.ID = "")
	{
	    s objECRecord = ##class(User.DHCPHECRecord).%New() 
	    s objECRecord.PatientID = AEECRecord.PatientID
	    s objECRecord.EpisodeID = AEECRecord.EpisodeID
	    s objECRecord.EpisodeType = AEECRecord.EpisodeType
	    s objECRecord.CategoryID = AEECRecord.CategoryID
	    s objECRecord.CategoryType = AEECRecord.CategoryType
	    s objECRecord.ChartItemID = AEECRecord.ChartItemID
	    s objECRecord.ChartItemType = AEECRecord.ChartItemType
	    s objECRecord.DocumentType = AEECRecord.DocumentType
	    s objECRecord.DocumentCharacteristic = AEECRecord.DocumentCharacteristic
	}
	else
	{
		s objECRecord = ##class(User.DHCPHECRecord).%OpenId(AEECRecord.ID)
	}
	s objECRecord.InstanceCount = AEECRecord.InstanceCount
	//保存Instance表初始化数据	
	s objInstanceData = ##class(User.DHCPHInstanceData).%New()
	s objInstanceData.GroupItemID = AEInstanceData.GroupItemID
	s objInstanceData.GroupItemName = AEInstanceData.GroupItemName
	S objInstanceData.TheECRecord = objECRecord
	s objInstanceData.Status = AEInstanceData.Status
	s objInstanceData.ListNo = AEECRecord.InstanceCount
	s objInstanceData.TemplateID = AEInstanceData.TemplateID
	s objInstanceData.Title =  AEInstanceData.Title
	s objInstanceData.TitleCode = AEInstanceData.TitleCode
	s objInstanceData.TemplateVersion = AEInstanceData.TemplateVersion
	s objInstanceData.EpisodeID = AEInstanceData.EpisodeID
	s $zt = "ECRecordErrorHandler"
	Tstart
	s scECRecord = objECRecord.%Save() 
	if ($$$ISOK(scECRecord))
	{
       s scInstanceData = objInstanceData.%Save() 
       if ($$$ISERR(scInstanceData))
       {
	       Trollback
	       q result
	   }
	   TCOMMIT
	   s result = objInstanceData.%Id()
	   d objECRecord.%Close()
	   d objInstanceData.%Close()
	   k objECRecord
	   k objInstanceData
	}
	quit result
	 
ECRecordErrorHandler
    quit:result
}

/// CreateTime: 2014-04-03
/// Creator:    candy
/// Desc:		根据模板ID,和发布版本号取模板文档
/// Input:		ATemplateID:模板ID
/// 			AVersionNumer:发布版本号
/// OutPut:     obj: 模板文档流
ClassMethod GetNewDocByTemplateID(ATemplateID As %String, AVersionNumer As %String) As %GlobalBinaryStream
{
	s obj = ##Class(%GlobalBinaryStream).%New()
	q:(ATemplateID = "")||(AVersionNumer = "")
	s TemplateVersionID = $o(^DHCEMRM.TemplateVersionI("IndexTemplateVersion"," "_ATemplateID,AVersionNumer,""))  //打开版本信息表
	q:(TemplateVersionID = "") obj
	s objTemplateVersion = ##Class(EMRmeta.TemplateVersion).%OpenId(TemplateVersionID)
	q:(objTemplateVersion = "") obj	
	//新建文档取模板版本信息表数据
	d obj.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(ATemplateID,"Template","","",objTemplateVersion.MetaData,objTemplateVersion.ScriptData,objTemplateVersion.PresentationData,objTemplateVersion.MediasData,objTemplateVersion.InitialData))	
    q obj
}

/// CreateTime: 2014-01-13
/// Creator:    candy
/// Desc:		保存InstanceData (需要知道InstanceID,编辑人,日常病历记录的填写创建时间,备注,文档标题)
/// Input:		AInstanceData: 实例数据的属性实体 
/// OutPut:     result: 返回1保存成功, -1保存失败
ClassMethod SaveRecord(AInstanceData As EMRservice.entity.EInstanceData) As %String
{
   s result = "-1"
   q:((AInstanceData.ID = "")||(AInstanceData.InstanceData = "")) result
   s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceData.ID)
   q:(objInstance = "") result
   if ($zcvt(objInstance.Status,"U") = "UNSAVE")
   {
	  s objInstance.CreateDate = $p($h,",",1)
	  s objInstance.CreateTime = $p($h,",",2)
	  s objInstance.CreateUser = AInstanceData.CreateUser
	  s objInstance.HappenDate = $case(AInstanceData.HappenDate="",1:$p($h,",",1),:AInstanceData.HappenDate)
	  s objInstance.HappenTime = $case(AInstanceData.HappenTime="",1:$p($h,",",2),:AInstanceData.HappenTime)
	  s:(AInstanceData.Title '="") objInstance.Title = AInstanceData.Title
	  s:(AInstanceData.TitleCode '="") objInstance.TitleCode = AInstanceData.TitleCode
	  s objInstance.Status = "Save"
   }
   else
   {
	  s:(AInstanceData.HappenDate '= "") objInstance.HappenDate = AInstanceData.HappenDate
	  s:(AInstanceData.HappenTime '= "") objInstance.HappenTime = AInstanceData.HappenTime
   }
   d objInstance.InstanceData.Clear()
   d objInstance.InstanceMetaData.Clear()
   d objInstance.InstanceScriptData.Clear()
   d objInstance.InstanceMetaData.Clear()
   d objInstance.InstanceData.CopyFrom(AInstanceData.InstanceData)
   d objInstance.InstanceMetaData.CopyFrom(AInstanceData.InstanceMetaData)
   d objInstance.InstanceScriptData.CopyFrom(AInstanceData.InstanceScriptData)
   d objInstance.InstanceMedia.CopyFrom(AInstanceData.InstanceMedia)
   s objInstance.ModifyDate = $p($h,",",1)
   s objInstance.ModifyTime = $p($h,",",2)
   s objInstance.ModifyUser = AInstanceData.ModifyUser
   s objInstance.Remark = AInstanceData.Remark
   s sc = objInstance.%Save()
   s:($$$ISOK(sc)) result = 1
   q result
}

/// CreateTime: 2014-01-13
/// Creator:    candy
/// Desc:		得到xml文档
/// Input:		AInstanceIDs: 实例数据ID,多个以"#"分隔
///             {"params":{"action":"LOAD_DOCUMENT", "InstanceID":"160202"},"type":"action"}
///             AOutRecords: 返回xml 
/// OutPut:     result: 返回1保存成功, -1保存失败
/// Debug:      d ##Class(EMRservice.BL.BLInstanceData).LoadDocument()
ClassMethod LoadDocument(ByRef AOutRecords As %GlobalBinaryStream, AInstanceIDs As %ListOfDataTypes, AOutMessage As %GlobalBinaryStream) As %String
{
    s result = "-1"		
    q:(AInstanceIDs = "") result
    d AOutMessage.Write("[")
    s total = AInstanceIDs.Count()
    for i=1:1:total
    {
	    s InstanceID = AInstanceIDs.GetAt(i)
	    s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(InstanceID) 
		continue:(objInstance = "")
		d:(i '= 1) AOutRecords.Write("-----------------------------7da4a26140fde")
		d AOutRecords.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.TemplateID,"Document",objInstance.Title,objInstance.TitleCode,objInstance.InstanceMetaData,objInstance.InstanceScriptData,objInstance.InstanceData,objInstance.InstanceMedia,objInstance.InstanceInitialData))
		s outMessage = ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkDocInfo(InstanceID)
		d:((AOutMessage.Size > 1)&&(outMessage '= "")) AOutMessage.Write(",")
    	d AOutMessage.Write(outMessage)
    }
    d AOutMessage.Write("]")
	s result = "1"
	q result
}

/// Description： 设置模板发布版本(当创建完病历没有保存，再次打开，使用当前发布的版本）
/// Creator:      Candy
/// CreateDate:   2014-04-2
/// Input:        ATemplateID 模板ID 
///               APreVersion emrinstance.instanceData中TemplateVersion
///               AInstanceID emrinstance.instanceData  RowID
/// OutPut:       publicVersion 当前发布的版本
ClassMethod setNewestPublicVersion(ATemplateID As %String, APreVersion As %String, AInstanceID As %String) As %String
{
	s newVersion = APreVersion
	q:(ATemplateID = "") newVersion
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(ATemplateID)
	q:(objTemplate = "") newVersion
	s newVersion = objTemplate.PublishVersion
	q:(newVersion = APreVersion) newVersion
	q:(AInstanceID = "") newVersion
	s objInstanceData = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstanceData = "") newVersion
	s objInstanceData.TemplateVersion = newVersion
	s sc = objInstanceData.%Save()
	s:($$$ISERR(sc)) newVersion = APreVersion
	q newVersion
}

/// Desc:       保存文档
/// Creator:    candy
/// Createdate: 2014-01-22
/// Input:      AInstanceID 实例数据ID
///             AUserID 当前用户ID
///             AStream 实例数据文件
/// Output:     result 1成功,-1失败 
ClassMethod SaveDoucment(AInstanceID As %String, AUserID As %String, AStream As %GlobalBinaryStream, ATitle As %String, ATitleCode As %String, ADataTime As %String) As %String
{
	s $zt = "Error"
	s result = "-1"
	q:((AInstanceID ="") || (AStream = "")) result	
    s streamMetaData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<MetaData","</MetaData>","11")
    s streamScriptData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<Scripts>","</Scripts>","10")
    s streamMediasData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<Medias>","</Medias>","9")
    s streamInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<NInstanceData","</NInstanceData>","16") 
    s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamInstanceData,"<ScatterData","</ScatterData>","14")
    s EInstanceData = ##Class(EMRservice.entity.EInstanceData).%New()
    s EInstanceData.ID = AInstanceID
    s EInstanceData.CreateUser = AUserID
    s EInstanceData.ModifyUser = AUserID
    s date = $p(ADataTime," ",1),time = $p(ADataTime," ",2)    
    s EInstanceData.HappenDate = $Case(date,"":"",:$zdh(date,3))
    s EInstanceData.HappenTime = $Case(time,"":"",:$zth(time))
    s EInstanceData.Title = ATitle
    s EInstanceData.TitleCode = ATitleCode
    s EInstanceData.ModifyTime = $p($h,",",2)
    s EInstanceData.ModifyDate = $p($h,",",1)
    s EInstanceData.Remark = ""
    d EInstanceData.InstanceMetaData.CopyFrom(streamMetaData)
    d EInstanceData.InstanceScriptData.CopyFrom(streamScriptData)
   	d EInstanceData.InstanceMedia.CopyFrom(streamMediasData)
    d EInstanceData.InstanceData.CopyFrom(streamInstanceData)  
    Tstart
    s idResult = ..SaveRecord(EInstanceData)
    q:(idResult '= "1") result

    s sdResult = ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).SaveScatterData(AInstanceID,streamScatterData)
    if (sdResult '= "1")
    {
	    Trollback
	    q result
	}
	TCOMMIT 
	s result = "1"			
	q result
Error
   Trollback
   q "-1"
}

/// Desc:       打散数据
/// Creator:    Candy
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///            ScatterData 的数据流
/// Return:     Result:1 成功  -1:失败     
/// Debug: d ##Class(web.DHCCM.EMRservice.BL.BLInstanceData).SaveScatterData("1||1","")
ClassMethod SaveScatterData(AInstanceID As %String, AStream As %GlobalBinaryStream) As %String
{
	s result = -1	
	s sc = ##class(%XML.TextReader).ParseStream(AStream,.reader)
    q:($$$ISERR(sc)) result
    s ScatterData = ##Class(EMRservice.Parser.NIScatterData).%New()
    d ScatterData.XMLDeserialize(reader)
    s Key = $i(^CacheTemp)
    
    k ^tmpNewSection(Key,AInstanceID)
   	k ^tmpNewComposite(Key,AInstanceID)
   	k ^tmpNewSimple(Key,AInstanceID)
   	k ^tmpNewCompositeConcept(Key,AInstanceID)
   	k ^tmpNewConceptSimple(Key,AInstanceID)

    d ##Class(web.DHCCM.EMRservice.BL.BLScatterData).BuildIndexData(ScatterData,AInstanceID,Key)
    s result = ##Class(web.DHCCM.EMRservice.BL.BLScatterData).Save(AInstanceID,Key)
    q result
}

/// Desc:       删除病程记录
/// Creator:    Candy
/// CreateDate: 2014-8-11
/// Input:      AInstanceID 病历ID
///             AUserID  操作者
///             AIpAddress 操作IP
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.BLInstanceData).DeleteDocument("2||10",105)
ClassMethod DeleteDocument(AInstanceID As %String, AUserID As %String) As %String
{
	s result = -1
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s objInstance.Status = "Delete"
	s objInstance.ModifyDate = $p($h,",",1)
	s objInstance.ModifyTime = $p($h,",",2)
	s objInstance.ModifyUser = AUserID
	s sc = objInstance.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       给文档添加备注
/// Creator:    Candy
/// CreateDate: 2014-12-26
/// Input:      AInstanceID 病历ID
///             AMemoText 备注内容
/// Output:     result 成功1 失败0
/// Debug:      w ##Class(EMRservice.BL.BLInstanceData).SetDocumentMemo("2||1","[主要的症状和特点]，[病因与诱因]，[病情的发展与演变]，[伴随症状]，[诊疗经过]。自发病以来，精神尚可，食欲尚可，睡眠尚可，大小便正常，体重无明显变化。 既往史:既往体质健康，否认高血压、否认糖尿病、否认冠心病、否认消化道疾病等慢性疾病病史。否认乙肝、否认伤寒、否认结核病等传染病病史。否认外伤史，否认")
ClassMethod SetDocumentMemo(AInstanceID As %String, AMemoText As %String)
{
	s result = "0"
	q:(AInstanceID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s objInstance.Memo = AMemoText
	s sc = objInstance.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       保存病历页码
/// Creator:    Candy
/// CreateDate: 2015-05-21
/// Input:      AInstanceID 病历ID
///             AStartPageNum 起始页码
///             AStartRowNum 起始行号
///             AEndPageNum 结束页码
///             AEndRowNum 结束行号
/// Output:     result 成功1 失败0
/// Debug:      w ##Class(EMRservice.BL.BLInstanceData).SetDocumentPageNum("2||1",1,1,2,1)
ClassMethod SetDocumentPageNum(AInstanceID As %String, AStartPageNum As %Integer, AStartRowNum As %Integer, AEndPageNum As %Integer, AEndRowNum As %Integer) As %String
{
	s result = "0"
	q:(AInstanceID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s objInstance.StartPageNum = AStartPageNum
	s objInstance.StartRowNum = AStartRowNum
	s objInstance.EndPageNum = AEndPageNum
	s objInstance.EndRowNum = AEndRowNum
	s sc = objInstance.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       取实例索引页码信息
/// Creator:    Candy
/// CreateDate: 2015-5-22
/// Input:      AInstanceID 病历ID
/// Output:     result 病历页码信息 
ClassMethod GetDocumentPageNum(AInstanceID As %String) As %String
{
	s result = ""
	q:(AInstanceID = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s result = result_"<InstanceIndex>"
	s result = result_"<ID>"_AInstanceID_"</ID>"
	s result = result_"<StartPageNum>"_objInstance.StartPageNum_"</StartPageNum>"
	s result = result_"<StartRowNum>"_objInstance.StartRowNum_"</StartRowNum>"
	s result = result_"<EndPageNum>"_objInstance.EndPageNum_"</EndPageNum>"
	s result = result_"<EndPageNum>"_objInstance.EndPageNum_"</EndPageNum>"
	s result = result_"</InstanceIndex>"
	q result
}

/// Desc:测试打散
/// d ##Class(EMRservice.BL.BLInstanceData).TestParse()
ClassMethod TestParse()
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "d:\test.xml"
	s sc = ##class(%XML.TextReader).ParseStream(Stream,.reader)
    if ($$$ISOK(sc))
    {
	    s ScatterData = ##Class(EMRservice.Parser.NIScatterData).%New()
	    d ScatterData.XMLDeserialize(reader)
	    s count = ScatterData.Sections.Count()
	    for i=1:1:count
	    {
		   w !,count, ScatterData.Sections.GetAt(i).Code,ScatterData.Sections.GetAt(i).Text
		   s scount = ScatterData.Sections.GetAt(i).Sections.Count()
		   s ccount =ScatterData.Sections.GetAt(i).Composites.Count()
		   for k=1:1:ccount
		   {
			   w !, ccount, ScatterData.Sections.GetAt(i).Composites.GetAt(k).Code
			   w ScatterData.Sections.GetAt(i).Composites.GetAt(k).Text
			   s subcount = ScatterData.Sections.GetAt(i).Composites.GetAt(k).SubItems.Count()
			   for l=1:1:subcount
			   {
				 w !, subcount, ScatterData.Sections.GetAt(i).Composites.GetAt(k).SubItems.GetAt(l).Code
				 w ScatterData.Sections.GetAt(i).Composites.GetAt(k).SubItems.GetAt(l).DataValue
			   }
		   }
		   for j=1:1:scount
		   {
			   w !, scount,ScatterData.Sections.GetAt(i).Sections.GetAt(j).Code
			   s sscount = ScatterData.Sections.GetAt(i).Sections.GetAt(j).Composites.Count()
			   for m=1:1:sscount
			   {
				   w !,sscount, ScatterData.Sections.GetAt(i).Sections.GetAt(j).Composites.GetAt(m).Code,ScatterData.Sections.GetAt(i).Sections.GetAt(j).Composites.GetAt(m).Text
				   s sscsubcount = ScatterData.Sections.GetAt(i).Sections.GetAt(j).Composites.GetAt(m).SubItems.Count()
				   for n=1:1:sscsubcount
				   {
					   w !,sscount, ScatterData.Sections.GetAt(i).Sections.GetAt(j).Composites.GetAt(m).SubItems.GetAt(n).Code, ScatterData.Sections.GetAt(i).Sections.GetAt(j).Composites.GetAt(m).SubItems.GetAt(n).DataValue				   
				   }
			   }
		   } 
		}
	}
}

}
