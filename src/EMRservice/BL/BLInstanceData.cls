Class EMRservice.BL.BLInstanceData Extends %RegisteredObject
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
ClassMethod IsHasInstance(EpisodeId As %String, TemplateId As %String, DocID As %String, StartDate As %String = "", EndDate As %String = "") As %String
{
	s result = "0"
	q:(EpisodeId="")||(DocID="") result 
	s ChartItemID = DocID
	s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeId,ChartItemID,""))
    q:(ECRecordID = "") result
    s date = ""
    s:(StartDate '= "") date = StartDate
    s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date),-1)
    q:(date = "") result
    q:((EndDate '= "")&&(date > EndDate))
    s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date,""),-1)
    q:(time = "") result 
    s instanceSubId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",date,time,""),-1)  
    q:(instanceSubId = "") result
    s result = ECRecordID_"||"_instanceSubId	    
	q result
}

/// Desc:      判断doc下病历是否书写
/// Creator：  Candy
/// CreatDate：2016-11-26
/// Input:     EpisodeId 就诊号 
///            DocIDs 目录串以"^"分隔
ClassMethod IsHasInstanceByDocIDs(EpisodeId As %String, DocIDs As %String) As %String
{
	s result = "0"
	for i=1:1:$l(DocIDs,"^")
	{
		s docId = $p(DocIDs,"^",i)
		s tmpresult = ..IsHasInstance(EpisodeId,"",docId)
		s:(tmpresult '= "0") result = "1"
		q:(result = "1")
	}
	q result
}

/// Desc:  获取病历是否保存
/// Input: AEpisodeID 就诊号
///       ADocID 病历目录展现结构第三层ID
///       ATitleCode 标题Code
ClassMethod GetDocumentStatus(AEpisodeID As %String, ADocID As %String, ATitleCode As %String) As %String
{
	s result = ""
	q:(AEpisodeID="")||(ADocID="") result
	s result = "UnSave" 
	s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,""))
    q:(ECRecordID = "") result
    s data = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",""))
    q:(data = "") result
    s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",data,""))
    q:(time = "") result
    s instanceSubId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",data,time,""))  
    q:(instanceSubId = "") result  
    if (ATitleCode '= "") 
    {
	   q:($d(^DHCEMRI.InstanceDataI("IdxEpisodeTitleCodeStatus",AEpisodeID," "_ATitleCode," SAVE"))<=0) result
	}
	s result = "Save"_"^"_ECRecordID_"||"_instanceSubId
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
/// debug:      w ##Class(EMRservice.BL.BLInstanceData).CreateDocument(601,76,48,"","","")
ClassMethod CreateDocument(ADocID As %String, AEpisodeID As %String, APatientID As %String, ATitle As %String, ATitleCode As %String, ADataTime As %String, ByRef objDoc As %GlobalBinaryStream, ATemplateID As %String = "", ATemplateVersion As %String = "") As %String
{
	s $zt = "ECRecordErrorHandler"
 	s instanceID = ""
	q:((ADocID = "")||(AEpisodeID = "")) instanceID
	s objEMRTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	q:(objEMRTemplateCategoryDoc = "") instanceID
	s leadFrame = objEMRTemplateCategoryDoc.IsLeadframe
	
	s objEMRTemplateCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEMRTemplateCategoryDoc.ParentCategoryID)
	q:(objEMRTemplateCategoryChapter = "")
	s chapterName = objEMRTemplateCategoryChapter.CategoryName
	s EMRTemplateID = ""
	s titleCode = $p(ATitleCode,"^",1)
	s:(titleCode '= "") EMRTemplateID = $tr($o(^DHCEMRM.TitleConfigI("IdxCategoryTitleCodeTemplate"," "_objEMRTemplateCategoryDoc.ParentCategoryID," "_titleCode,""))," ","")
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
	
	s rowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,""))
	if (rowID = "")
	{
	    s objECRecord = ##class(EMRinstance.ECRecord).%New() 
	    s objECRecord.PatientID = APatientID
	    s objECRecord.EpisodeID = ##class(User.PAAdm).%OpenId(AEpisodeID)
	    s objECRecord.EpisodeType = $P($G(^PAADM(AEpisodeID)),"^",2)
	    s objECRecord.CategoryID = ##class(EMRmeta.TemplateCategory).%OpenId(templateCategoryID)
	    s objECRecord.CategoryType = "Normal"
	    s objECRecord.ChartItemID = ##class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
	    s objECRecord.ChartItemType = objTemplate.ChartItemType
	    s objECRecord.DocumentType = objTemplate.DocumentType
	    s objECRecord.DocumentCharacteristic = $case(leadFrame,"1":1,:0)
	    s objECRecord.InstanceCount = 1
	    s objInstanceData = ##class(EMRinstance.InstanceData).%New()		
	}
	else
	{
		s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(rowID)
		q:(objECRecord = "") instanceID
		s subId = $o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",rowID,templateID," UNSAVE",""),-1)
		if ((objTemplate.ChartItemType = "Single")&&(subId = objECRecord.InstanceCount))
		{
			s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(rowID_"||"_subId)
			q:(objInstanceData = "") result
		}
		else
		{
			s objInstanceData = ##class(EMRinstance.InstanceData).%New()
			s objECRecord.InstanceCount = objECRecord.InstanceCount + 1
		}	
	}
	//保存Instance表初始化数据	
	s objInstanceData.CreateDate = $p($h,",",1)
	s objInstanceData.CreateTime = $p($h,",",2)
	s objInstanceData.GroupItemID = templateCategoryID
	s objInstanceData.GroupItemName = objTemplateCategory.Name
	S objInstanceData.TheECRecord = objECRecord
	s objInstanceData.Status = "UnSave"
	s objInstanceData.TemplateID = $Case(ATemplateID,"":##class(EMRmeta.Template).%OpenId(templateID),:##class(EMRmeta.Template).%OpenId(ATemplateID))
	
	set EMRChartItemType = ##class(EMRservice.EMRDoc.DocCategoryFunSet).GetChapterDocType(objEMRTemplateCategoryDoc.ParentCategoryID)
	
	if (EMRChartItemType="Single")
	{
		s objInstanceData.Title =chapterName
	}
	else
	{
		if (ATitle'="")
		{
			s objInstanceData.Title =ATitle
		}
		else
		{
			s objInstanceData.Title = objEMRTemplateCategoryDoc.CategoryName
		}
	}
	
	s objInstanceData.TitleCode = titleCode
    s objInstanceData.TemplateVersion = $Case(ATemplateVersion,"":objTemplate.PublishVersion,:ATemplateVersion)
	s objInstanceData.EpisodeID = ##class(User.PAAdm).%OpenId(AEpisodeID)
	s objInstanceData.ListNo = objECRecord.InstanceCount
	
	//如果标题为空获取关联的业务域编码设置为TitleCode
	s StructureCode = ##Class(EMRservice.BL.BLInstanceData).getStructureCode(objECRecord.RealChartItemID)
	if ((StructureCode'="")&&(StructureCode'=$c(0)))
	{
		s objInstanceData.TitleCode =$case(objInstanceData.TitleCode,"":StructureCode,:objInstanceData.TitleCode)
	}
	
	Tstart
	s scECRecord = objECRecord.%Save() 
	if ($$$ISOK(scECRecord))
	{
       s scInstanceData = objInstanceData.%Save() 
       if ($$$ISERR(scInstanceData))
       {
	       Trollback
	       q 
	   }
	   else
	   {
		   s resTitleCode = ##Class(EMRservice.BL.BLInstanceCode).SetInstanceCode(objInstanceData.%Id(),ATitleCode)
	       if (resTitleCode = 0) 
	       {
		       Trollback
		       q 		       
		   }
	   }

	   TCOMMIT
	   s instanceID = objInstanceData.%Id()
	   
	   d objECRecord.%Close(),objInstanceData.%Close()
	   k objECRecord, objInstanceData
	}
	else
	{
		Trollback
		q
	}
	if ((instanceID '= "")&&(objDoc '= ""))
	{
        d objDoc.CopyFrom(..GetNewDocByTemplateID($Case(ATemplateID,"":templateID,:ATemplateID),$Case(ATemplateVersion,"":objTemplate.PublishVersion,:ATemplateVersion)))
	}
	d objTemplateCategory.%Close(),objTemplate.%Close()
	k objTemplateCategory,objTemplate
	q instanceID
ECRecordErrorHandler
    Trollback
    q instanceID_"^"_$zerror
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
ClassMethod CreateTestDocument(aTemplateID As %String, aVersionID As %String, ByRef objDoc As %GlobalBinaryStream) As %String
{
 	s instanceID = ""
	q:((aTemplateID = "")||(aVersionID="")) instanceID
	s templateID =  aTemplateID
	s objTemplate = ##class(EMRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") instanceID

	s instanceID = "-1"
	if ((instanceID '= "")&&(objDoc '= ""))
	{
		////模板绑定测试时，取最新的版本的数据
		d objDoc.CopyFrom(..GetNewDocByTemplateID(templateID,aVersionID))
		
	}
	d objTemplate.%Close()
	k objTemplate
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
	    s objECRecord = ##class(EMRinstance.ECRecord).%New() 
	    s objECRecord.PatientID = AEECRecord.PatientID
	    s objECRecord.EpisodeID = ##class(User.PAAdm).%OpenId(AEECRecord.EpisodeID)
	    s objECRecord.EpisodeType = AEECRecord.EpisodeType
	    s objECRecord.CategoryID = ##class(EMRmeta.TemplateCategory).%OpenId(AEECRecord.CategoryID)
	    s objECRecord.CategoryType = AEECRecord.CategoryType
        s objECRecord.ChartItemID = ##class(EMRmeta.EMRTemplateCategory).%OpenId(AEECRecord.ChartItemID)
	    s objECRecord.ChartItemType = AEECRecord.ChartItemType
	    s objECRecord.DocumentType = AEECRecord.DocumentType
	    s documentCharacteristic = "1"
	    s:AEECRecord.DocumentCharacteristic'="1" documentCharacteristic="0"
	    s objECRecord.DocumentCharacteristic = documentCharacteristic
	    
	    s objInstanceData = ##class(EMRinstance.InstanceData).%New()
		s objECRecord.InstanceCount = 1
		
	}
	else
	{
		s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(AEECRecord.ID)
		q:(objECRecord = "") result
		s subId = $o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",AEECRecord.ID,AEInstanceData.TemplateID," UNSAVE",""),-1)
		if ((objECRecord.ChartItemType = "Single")&&(subId = objECRecord.InstanceCount))
		{
			s objInstanceData = ##class(EMRinstance.InstanceData).%OpenId(AEECRecord.ID_"||"_subId)
			q:(objInstanceData = "") result
		}
		else
		{
			s objInstanceData = ##class(EMRinstance.InstanceData).%New()
			s objECRecord.InstanceCount = objECRecord.InstanceCount + 1
		}
	}
	//保存Instance表初始化数据	
	s objInstanceData.GroupItemID = AEInstanceData.GroupItemID
	s objInstanceData.GroupItemName = AEInstanceData.GroupItemName
	S objInstanceData.TheECRecord = objECRecord
	s objInstanceData.Status = AEInstanceData.Status
	s objInstanceData.TemplateID = ##class(EMRmeta.Template).%OpenId(AEInstanceData.TemplateID)
	s objInstanceData.Title =  AEInstanceData.Title
	s objInstanceData.TitleCode = AEInstanceData.TitleCode
	s objInstanceData.TemplateVersion = AEInstanceData.TemplateVersion
	s objInstanceData.EpisodeID = ##class(User.PAAdm).%OpenId(AEInstanceData.EpisodeID)
	s objInstanceData.ListNo = objECRecord.InstanceCount	
	s objInstanceData.CreateDate = $p($h,",",1)
	s objInstanceData.CreateTime = $p($h,",",2)
	//如果标题为空获取关联的业务域编码设置为TitleCode
	s StructureCode = ##Class(EMRservice.BL.BLInstanceData).getStructureCode(objECRecord.RealChartItemID)
	if ((StructureCode'="")&&(StructureCode'=$c(0)))
	{
		s objInstanceData.TitleCode =$case(objInstanceData.TitleCode,"":StructureCode,:objInstanceData.TitleCode)
	}
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
   s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceData.ID)
   q:(objInstance = "") result
   if ($zcvt(objInstance.Status,"U") = "UNSAVE")
   {
	  s ecrecordId = $p(AInstanceData.ID,"||",1)
	  s flag = $d(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE"))
	  q:((objInstance.TheECRecord.ChartItemType = "Single")&&(flag>0)) "0"
	  //s objInstance.CreateDate = $p($h,",",1)
	  //s objInstance.CreateTime = $p($h,",",2)
	  s objInstance.CreateUser = AInstanceData.CreateUser
	  s objInstance.HappenDate = $case(AInstanceData.HappenDate="",1:$p($h,",",1),:AInstanceData.HappenDate)
	  s objInstance.HappenTime = $case(AInstanceData.HappenTime="",1:$p($h,",",2),:AInstanceData.HappenTime)
	  s objInstance.Status = "Save"
   }
   else
   {
	  s:(AInstanceData.HappenDate '= "") objInstance.HappenDate = AInstanceData.HappenDate
	  s:(AInstanceData.HappenTime '= "") objInstance.HappenTime = AInstanceData.HappenTime
   }
   s:(AInstanceData.Title '="") objInstance.Title = AInstanceData.Title
   s:(AInstanceData.TitleCode '="") objInstance.TitleCode = $p(AInstanceData.TitleCode,"^",1)
   d objInstance.InstanceData.Clear()
   d objInstance.InstanceMetaData.Clear()
   d objInstance.InstanceScriptData.Clear()
   d objInstance.InstanceMetaData.Clear()
   d objInstance.InstanceInitialData.Clear()
   
   d objInstance.InstanceData.CopyFrom(AInstanceData.InstanceData)
   //d objInstance.InstanceMetaData.CopyFrom(AInstanceData.InstanceMetaData)
   //d objInstance.InstanceScriptData.CopyFrom(AInstanceData.InstanceScriptData)
   //d objInstance.InstanceMedia.CopyFrom(AInstanceData.InstanceMedia)
   //d objInstance.InstanceInitialData.CopyFrom(AInstanceData.InstanceInitialData)
   s objInstance.ModifyDate = $p($h,",",1)
   s objInstance.ModifyTime = $p($h,",",2)
   s objInstance.ModifyUser = AInstanceData.ModifyUser
   s objInstance.Remark = AInstanceData.Remark
   s objInstance.IsEncrypt = AInstanceData.IsEncrypt
   Tstart
   s sc = objInstance.%Save()
   if ($$$ISERR(sc))
   {
		q result
   }
   else
   {
	   s sccode = ##Class(EMRservice.BL.BLInstanceCode).SetInstanceCode(AInstanceData.ID,AInstanceData.TitleCode)
	   if (sccode = 0)
	   {
		   Trollback
		   q result
	   }	   
   }
   TCOMMIT
   s result = 1
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
	    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID) 
		continue:(objInstance = "")
		d:(i '= 1) AOutRecords.Write("-----------------------------7da4a26140fde")
		s titleCode = ##Class(EMRservice.BL.BLInstanceCode).GetInstanceCode(InstanceID)
		s:(titleCode = "") titleCode = objInstance.TitleCode
		s streamMetaData=##Class(%GlobalBinaryStream).%New()
		s streamScriptData=##Class(%GlobalBinaryStream).%New()
		s streamMediasData=##Class(%GlobalBinaryStream).%New()
		s streamInstanceData=##Class(%GlobalBinaryStream).%New()
		
		if (objInstance.IsEncrypt = 1)
		{
			d:(objInstance.InstanceMetaData.Size>0) ##class(%SYSTEM.Encryption).AESCBCDecryptStream(objInstance.InstanceMetaData,streamMetaData,"GlobalEMREncKeyX","")
			d:(objInstance.InstanceScriptData.Size>0) ##class(%SYSTEM.Encryption).AESCBCDecryptStream(objInstance.InstanceScriptData,streamScriptData,"GlobalEMREncKeyX","")
			d:(objInstance.InstanceMedia.Size>0) ##class(%SYSTEM.Encryption).AESCBCDecryptStream(objInstance.InstanceMedia,streamMediasData,"GlobalEMREncKeyX","")
			d ##class(%SYSTEM.Encryption).AESCBCDecryptStream(objInstance.InstanceData,streamInstanceData,"GlobalEMREncKeyX","")
		}
		else
		{
			d streamMetaData.CopyFrom(objInstance.InstanceMetaData)
			d streamScriptData.CopyFrom(objInstance.InstanceScriptData)
			d streamMediasData.CopyFrom(objInstance.InstanceMedia)
			d streamInstanceData.CopyFrom(objInstance.InstanceData)
		}
		
		//压缩代码优化20220419
		if (##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(InstanceID)="TRUE")
		{
			d AOutRecords.CopyFrom(streamInstanceData)
		}
		else
		{
			//后台压缩，先解压
			if (##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsBKCompressByInstanceID(InstanceID)="1")
			{
				s tempInstanceData = ##class(EMRservice.Parser.StreamData).DeCompressStream(streamInstanceData)
				d AOutRecords.CopyFrom(tempInstanceData)
			}
			else
			{
				d AOutRecords.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.RealTemplateID,"Document",objInstance.Title,titleCode,streamMetaData,streamScriptData,streamInstanceData,streamMediasData,""))
			}
		}
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
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
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
ClassMethod SaveDoucment(AInstanceID As %String, AUserID As %String, AStream As %GlobalBinaryStream, ATitle As %String, ATitleCode As %String, ADataTime As %String, AIsCompressDocument As %String = "") As %String
{
	s $zt = "Error"
	s result = "-1^病历已存在"
	q:((AInstanceID ="") || (AStream = "")) result	

	s streamInstanceData = ##Class(%GlobalBinaryStream).%New()
	s streamScatterData = ##Class(%GlobalBinaryStream).%New()
	s isBKCompress = "0"
	
	if (AIsCompressDocument = "TRUE")
	{	
		s streamInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"","-----------------------------7da4a26140fde","") 
	    s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"<ScatterData","</ScatterData>","14")	
	
	}
	else
	{
		//签名域通过分隔符拆分，返回实例数据
		s intFind = AStream.FindAt("-1","-----------------------------7da4a26140fde")
		if (intFind>1)
		{
			s streamInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"","-----------------------------7da4a26140fde","")
		}
		else
		{
			s streamInstanceData = AStream
		}
		s check = ##Class(EMRservice.BL.BLInstanceData).CheckXml(AInstanceID,streamInstanceData)
		q:(check '= "") result
	    s streamScatterData = ##Class(EMRservice.Parser.StreamData).ParserStream(streamInstanceData,"<ScatterData","</ScatterData>","14")
		//增加后台压缩
		s streamInstanceData = ##Class(EMRservice.Parser.StreamData).CompressStream(streamInstanceData)
		s isBKCompress= "1"
	}
	s instanceEncrypt=##Class(%GlobalBinaryStream).%New()
	d ##class(%SYSTEM.Encryption).AESCBCEncryptStream(streamInstanceData,instanceEncrypt,"GlobalEMREncKeyX","")
	
    s EInstanceData = ##Class(EMRservice.entity.EInstanceData).%New()
    s EInstanceData.ID = AInstanceID
    s EInstanceData.CreateUser = AUserID
    s EInstanceData.ModifyUser = AUserID
    s date = $p(ADataTime," ",1),time = $p(ADataTime," ",2)    
    s EInstanceData.HappenDate = $Case(date,"":"",:$zdh(date,3))
    s EInstanceData.HappenTime = $Case(time,"":"",:$zth(time))
    
    s:(ATitle '= "") EInstanceData.Title = ATitle
    s:(ATitleCode '= "") EInstanceData.TitleCode = ATitleCode
    s EInstanceData.ModifyTime = $p($h,",",2)
    s EInstanceData.ModifyDate = $p($h,",",1)
    s EInstanceData.Remark = ""
    d EInstanceData.InstanceData.CopyFrom(instanceEncrypt)
    s EInstanceData.IsEncrypt = 1
  
	s $zt = "SaveError"
    Tstart
    s idResult = ..SaveRecord(EInstanceData)
    if (idResult '= "1") 
    {
	    Trollback
    	q idResult
    }
    s sdResult = ##Class(EMRservice.BL.BLInstanceData).SaveScatterData(AInstanceID,streamScatterData)
    if (sdResult '= "1")
    {
	    Trollback
	    q result
	}
	//压缩扩展信息存储 2022-04-19,暂不需要回滚数据
	s intCompressResult = ##class(EMRservice.BL.BLInstanceDataCompressInfo).SaveData(AInstanceID,AIsCompressDocument,isBKCompress)
	if (intCompressResult '= "1")
	{
	    Trollback
	    q "-1^病历压缩信息存储异常"
	}
	
	TCOMMIT 
	s result = "1"			
	q result
Error
   q "-1^保存异常"_$zerror
SaveError
   Trollback
   q "-1^保存异常"_$zerror
}

/// Desc:       打散数据
/// Creator:    Candy
/// CreateDate: 2014-6-27
/// Input:      AInstanceID 实例数据ID
///            ScatterData 的数据流
/// Return:     Result:1 成功  -1:失败     
/// Debug: d ##Class(EMRservice.BL.BLInstanceData).SaveScatterData("1||1","")
ClassMethod SaveScatterData(AInstanceID As %String, AStream As %GlobalBinaryStream) As %String
{
	s result = -1	
	s sc = ##class(%XML.TextReader).ParseStream(AStream,.reader)
    q:($$$ISERR(sc)) result
    s ScatterData = ##Class(EMRservice.Parser.NIScatterData).%New()
    d ScatterData.XMLDeserialize(reader)
    s Key = $i(^CacheTempEMRScatterData)
    
    k ^CacheTempEMRScatterData(Key)

    d ##Class(EMRservice.BL.BLScatterData).BuildIndexData(ScatterData,AInstanceID,Key)
    s result = ##Class(EMRservice.BL.BLScatterData).Save(AInstanceID,Key)
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s objInstance.Memo = AMemoText
	s sc = objInstance.%Save()
	s:($$$ISOK(sc)) result = "1"
	q result
}

/// Desc:       获取文档备注
/// Creator:    niucaicai
/// CreateDate: 2019-08-21
/// Input:      AInstanceID 病历ID
/// Output:     %GlobalCharacterStream类型的String字符串
/// Debug:      w ##Class(EMRservice.BL.BLInstanceData).GetDocumentMemo("2||1")
ClassMethod GetDocumentMemo(AInstanceID As %String) As %GlobalCharacterStream
{
	s result = ##class(%GlobalCharacterStream).%New()
	q:(AInstanceID = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s MemoText = objInstance.Memo
	d result.Write(MemoText)
	
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
    s extraInfo = ##Class(EMRservice.BL.BLInstanceDataExtraInfo).GetDocumentExtraInfo(AInstanceID)
	s result = result_"<InstanceIndex>"
	s result = result_"<ID>"_AInstanceID_"</ID>"
    s:(extraInfo '= "") result = result_extraInfo
	s result = result_"<StartPageNum>"_objInstance.StartPageNum_"</StartPageNum>"
	s result = result_"<StartRowNum>"_objInstance.StartRowNum_"</StartRowNum>"
    s result = result_"<EndRowNum>"_objInstance.EndRowNum_"</EndRowNum>"
	s result = result_"<EndPageNum>"_objInstance.EndPageNum_"</EndPageNum>"
	
	//增加压缩相关代码 20220419
	s result = result_"<CompressDocument>"_##class(EMRservice.BL.BLInstanceDataCompressInfo).GetIsCompressByInstanceID(AInstanceID)_"</CompressDocument>"
	
	s result = result_"</InstanceIndex>"
	q result
}

/// Desc:       取病历日期下病历
/// Creator:    Candy
/// CreateDate: 2016-12-19
/// Input:      AEpisodeID 就诊号
///            ADocID 所查病历目录展现结构ID
///            ADate 日期
/// Output:     result
/// Debug:      w ##Class(EMRservice.BL.BLInstanceData).GetInstanceByDate(112,56,"2016-12-15")
ClassMethod GetInstanceByDate(AEpisodeID As %String, ADocID As %String, ADate As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ADocID = "")||(ADate = "") result
	s date = $zdh(ADate,3)
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,""))
	q:(ecrecordId = "") result
	s time = ""
	for
	{
		s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time))
		q:(time = "")
		s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time,""))
        continue:(subId = "")
        s instanceId = ecrecordId_"||"_subId
       	s obj = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
	    s result = "{"
	    s result = result_"""id"":"""_instanceId_""""
	    s result = result_",""text"":"""_obj.Title_""""
	    s result = result_",""chartItemType"":"""_obj.TheECRecord.ChartItemType_""""
	    s result = result_",""pluginType"":"""_obj.TheECRecord.DocumentType_""""
	    s result = result_",""emrDocId"":"""_ADocID_""""
	    s result = result_"}"
       q
	}
	q result
}

/// Desc:      保存标注病历
/// Creator:   Candy 
/// CreateDate:2017-8-24
/// Input:     AInstanceID 病历ID
/// 
ClassMethod SaveMarkDocument(AInstanceID As %String, AStream As %GlobalBinaryStream, AIsCompressDocument As %String = "") As %String
{
	s $zt = "Error"
	s result = ""
	q:(AInstanceID = "")||(AStream.Size <= 0) result
    s obj = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(obj = "") result

	s tempInstanceData = ##Class(%GlobalBinaryStream).%New()
	s isBKCompress = "0"
	if (AIsCompressDocument="TRUE")
	{	
		s streamInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"","-----------------------------7da4a26140fde","") 
	
	}
	else
	{
		s intFind = AStream.FindAt("-1","-----------------------------7da4a26140fde")
		if (intFind>1)
		{
			s streamInstanceData = ##Class(EMRservice.Parser.StreamData).ParserStream(AStream,"","-----------------------------7da4a26140fde","")
		}
		else
		{
			s streamInstanceData = AStream
		}
		s check = ##Class(EMRservice.BL.BLInstanceData).CheckXml(AInstanceID,streamInstanceData)
		q:(check '= "") result
		//增加后台压缩
		s streamInstanceData = ##Class(EMRservice.Parser.StreamData).CompressStream(streamInstanceData)
		s isBKCompress= "1"
	}
	
	s instanceEncrypt=##Class(%GlobalBinaryStream).%New()
	d ##class(%SYSTEM.Encryption).AESCBCEncryptStream(streamInstanceData,instanceEncrypt,"GlobalEMREncKeyX","")
	d obj.InstanceData.Clear(), obj.InstanceData.CopyFrom(instanceEncrypt)
	s obj.IsEncrypt = 1
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	
	//压缩扩展信息存储 2022-04-19,暂不需要回滚数据
	s intCompressResult = ##class(EMRservice.BL.BLInstanceDataCompressInfo).SaveData(AInstanceID,AIsCompressDocument,isBKCompress)
	if (intCompressResult '= "1")
	{
	    s result = "-1^病历压缩信息存储异常"
	}
	
	q result
Error
   q $zerror
}

/// Desc:      判断一组病历是否在某一事件完成
/// Creator:   Candy
/// CreateDate:2018-1-10
/// Input:     AEpisodeID 就诊号
///           AStartDate 开始日期
///           AEndDate 结束日期
///           AOneRecordGroup docID组 M3^56^术前讨论|M3^57^术前讨论
/// Output:    0 , 1
ClassMethod IsOneGroupComplished(AEpisodeID As %String, AStartDate As %String, AEndDate As %String, AOneRecordGroup As %String)
{
	s isComplished = 0
	q:(AEpisodeID = "")||(AOneRecordGroup = "") isComplished
	s tmpEmr = $e(AOneRecordGroup,$f(AOneRecordGroup,"M3")-2,$l(AOneRecordGroup))
	for i = 1:1:$length(tmpEmr,"|")
	{
		s docId = $p($p(tmpEmr,"|",i),"^",2)
		s type = $e($p(tmpEmr,"|",i),1,1)
		if (type = "M")
		{
			s result = ..IsHasInstance(AEpisodeID,"",docId,AStartDate,AEndDate)
		}
		else
		{
			s result = ..IsHasInstance(AEpisodeID,"",docId)
		}
		s:(result '= 0) isComplished = "1"
		q:(isComplished = 1)
	}
	q isComplished
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

/// Desc:       获取病历ID数据生成二维码
/// Creator:    Lina
/// CreateDate: 2017-11-3
/// Input:      AInstanceID 病历ID
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLInstanceData","GetInstanceData","105||1")
Query GetInstanceData(InstanceID As %String) As %Query(ROWSPEC = "InstanceID:%String")
{
}

ClassMethod GetInstanceDataExecute(ByRef qHandle As %Binary, InstanceID As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind = 1
	set qHandle = $lb(0,repid,0)
	
	set ^CacheTemp(repid,ind) = $LB(InstanceID)
	set ind = ind + 1
	Quit $$$OK
}

ClassMethod GetInstanceDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstanceDataExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstanceDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstanceDataExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       检查是否打开后，保存前有其他人保存（防止覆盖）
/// Creator:    Donglulu
/// Createdate: 2018-08-17
/// Input:      AInstanceID 实例数据ID
///             POperateDate 打开时实例最后的操作日期
///             POperateTime 打开时实例最后的操作时间
/// Output:     result 1成功,0失败 
ClassMethod CheckSaveStatus(AInstanceID As %String, APOperateDate As %String, APOperateTime As %String) As %String
{
	s result = "1"
	q:(AInstanceID ="") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s POperateDate = objInstance.ModifyDate
	s POperateTime = objInstance.ModifyTime
	if ((POperateDate '= APOperateDate) || (POperateTime '= APOperateTime))
	{
		s userID = objInstance.ModifyUser
		s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(userID)
		s ip = ##Class(EMRservice.BL.BLEMRLogs).GetOperateIPByInstanceId(AInstanceID)	
		s result = "0^保存失败，因当前文档已在IP【"_ip_"】的电脑上被医生【"_userName_"】编辑保存，直接保存会覆盖其修改内容"
		q result
	}
	s result = 1
	q result
}

/// Desc:检测xml是否合法
ClassMethod CheckXml(InstanceId As %String, argInData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s result = ""
	q:(InstanceId = "")||(argInData.Size<=0) result
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(InstanceId)
	q:(obj = "") result
	/*if (obj.TheECRecord.DocumentType = "GRID")
	{
		s sc = ##class(%XML.TextReader).ParseStream(argInData,.reader)
    	if ($$$ISERR(sc))
    	{
	    	d saveData
	    	q "xml Error"
	    }
	}*/
	s sc = ##class(%XML.TextReader).ParseStream(argInData,.reader)
      if ($$$ISERR(sc))
    	{
	    	d saveData
	    	q "xml Error"
	    }
	q result
saveData
	s objCheck = ##Class(EMRinstance.CheckXMLStream).%New()
	s objCheck.InstanceID = InstanceId
	d objCheck.CheckXMLStream.CopyFrom(argInData)
	d objCheck.%Save()
	q
Error
	d saveData
    q "Error xml"
}

/// Desc:        判断入参病历是否为相同DocID在后台保存的最后一份病历
/// CreateDate:  2019-10-16
/// Input:       AInstanceID 实例ID
/// Return:      入参病历为相同DocID在后台保存的最后一份病历,返回病历数据,否则返回空
///              若为UnSave状态病历则返回"UNSAVE";若非连续显示的病历则返回空;
/// Debug：      w ##Class(EMRservice.BL.BLInstanceData).getLastInstanceData("98||10","UnSave")
ClassMethod getLastInstanceData(AInstanceID As %String, AType As %String = "Save") As %String
{
    s json = ""
    q:(AInstanceID = "") json
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") json
    q:($zcvt(objInstance.Status,"U") = "UNSAVE") json_"UNSAVE"
    s ecrecordID = $p(AInstanceID,"||",1)
    q:(objInstance.TheECRecord.DocumentCharacteristic = "0") json

    s rowId = "", date = ""
    for
    {
        s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordID," "_$zcvt(AType,"U"),date),-1)
        q:(date = "")
        s time = ""
        for
        {
            s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordID," "_$zcvt(AType,"U"),date,time),-1)
            q:(time = "")
            s subId = ""
            for
            {
                s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordID," "_$zcvt(AType,"U"),date,time,subId),-1)         
                q:(subId = "")
                s rowId = ecrecordID_"||"_subId
                q:(rowId '= AInstanceID)
                d LastInstanceData
            }
            q:(rowId '= "")
        }
        q:(rowId '= "")
    }

    k objInstance
    s json = $ZSTRIP(json,"*C")
    q json
LastInstanceData
    s docId = objInstance.TheECRecord.RealChartItemID
    s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
    q:(objCategoryDoc = "")
    s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
    q:(objChapter = "")
    s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
    s documentType = objInstance.TheECRecord.DocumentType
    s chartItemType = objInstance.TheECRecord.ChartItemType
    s templateId = objInstance.RealTemplateID
    s isLeadframe = objCategoryDoc.IsLeadframe
    s isMutex = objChapter.IsMutex
    s categoryId = objChapter.ParentCategoryID
    s characteristic = objInstance.TheECRecord.DocumentCharacteristic
    s json = "{""id"":"""_AInstanceID_""","
    s json = json_"""text"":"""_title_""","
    s json = json_"""pluginType"":"""_documentType_""","
    s json = json_"""chartItemType"":"""_chartItemType_""","
    s json = json_"""emrDocId"":"""_docId_""","
    s json = json_"""templateId"":"""_templateId_""","
    s json = json_"""isLeadframe"":"""_isLeadframe_""","
    s json = json_"""isMutex"":"""_isMutex_""","
    s json = json_"""categoryId"":"""_categoryId_""","
    s json = json_"""characteristic"":"""_characteristic_""","
    s json = json_"""actionType"":""LOAD"","
    s json = json_"""status"":""NORMAL"","
    s json = json_"""closable"":true}"
    k objCategoryDoc,objChapter
    q
}

/// Desc:        根据实例ID获取病历数据
/// CreateDate:  2020-10-23
/// Input:       AInstanceID 实例ID
/// Return:      成功返回病历数据,否则返回空
/// Debug：      w ##Class(EMRservice.BL.BLInstanceData).getInstanceDataByInsID("3901915||26")
ClassMethod getInstanceDataByInsID(AInstanceID As %String) As %String
{
    s json = ""
    q:(AInstanceID = "") json
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") json
    q:($zcvt(objInstance.Status,"U") = "UNSAVE") json
    s ecrecordID = $p(AInstanceID,"||",1)
    s docId = objInstance.TheECRecord.RealChartItemID
    s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
    q:(objCategoryDoc = "")
    s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
    q:(objChapter = "")
    s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
    s documentType = objInstance.TheECRecord.DocumentType
    s chartItemType = objInstance.TheECRecord.ChartItemType
    s templateId = objInstance.RealTemplateID
    s isLeadframe = objCategoryDoc.IsLeadframe
    s isMutex = objChapter.IsMutex
    s categoryId = objChapter.ParentCategoryID
    s characteristic = objInstance.TheECRecord.DocumentCharacteristic
    s json = "{""id"":"""_AInstanceID_""","
    s json = json_"""text"":"""_title_""","
    s json = json_"""pluginType"":"""_documentType_""","
    s json = json_"""chartItemType"":"""_chartItemType_""","
    s json = json_"""emrDocId"":"""_docId_""","
    s json = json_"""templateId"":"""_templateId_""","
    s json = json_"""isLeadframe"":"""_isLeadframe_""","
    s json = json_"""isMutex"":"""_isMutex_""","
    s json = json_"""categoryId"":"""_categoryId_""","
    s json = json_"""characteristic"":"""_characteristic_""","
    s json = json_"""actionType"":""LOAD"","
    s json = json_"""status"":""NORMAL"","
    s json = json_"""closable"":true}"
    k objCategoryDoc,objChapter,objInstance
    s json = $ZSTRIP(json,"*C")
    q json
}

/// Desc:        获取与入参AInstanceID相同DocID在后台AStatus状态下存储的病历数量
/// CreateDate:  2019-10-23
/// Input:       AInstanceID 实例ID
/// Return:      返回病历数量
/// Debug：      w ##Class(EMRservice.BL.BLInstanceData).getInstanceCount("98||10","UnSave")
ClassMethod getInstanceCount(AInstanceID As %String, AStatus As %String = "SAVE") As %Integer
{
    s count = 0
    q:(AInstanceID = "") count
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
    q:(objInstance = "") count
    s key = ""
    Do
    {
        s objInstanceData = objInstance.TheECRecord.Instances.GetNext(.key)
        if (objInstanceData '= "")
            {
            if ($zcvt(objInstanceData.Status,"U") = AStatus)
            {
                s count = count + 1
            }
        }
    }
    While (key '="" )
    k objInstance
    q count
}

/// Debug： w ##Class(EMRservice.BL.BLInstanceData).getScriptResult("98||10","if ($$getInstanceCount$$>30) { s TitleCode = ""EMR100007""}","TitleCode")
ClassMethod getScriptResult(AInstanceID As %String, AExeCode As %String, AKey As %String) As %String
{
    s result = ""
    q:(AInstanceID = "")||($ZSTRIP(AExeCode,"*C") = "")||(AKey = "") result
    s @AKey
    s key = $p(AKey,"=",1)
    s finalCode = ""
    s exeCodeCount = $l(AExeCode,"$$")        
    if (exeCodeCount<2) 
    {
        s finalCode = AExeCode
    }
    else 
    {
        for j=1:1:exeCodeCount 
        {
            if ((j#2)'=0) 
            {
                s finalCode = finalCode_$p(AExeCode,"$$",j)
            }
            else 
            {
                s argFunc = "returnValue=##Class(EMRservice.BL.BLInstanceData)."_$p(AExeCode,"$$",j)_"("""_AInstanceID_""")"
                s @argFunc
                s finalCode = finalCode_""_@"returnValue"_""
            }
        }
    }
    x finalCode
    s result = @key
    q result
}

/// Desc:        根据docid获取关联的业务域编码
/// CreateDate:  2020-6-10
/// Input:       aDocID EMRmeta.EMRTemplateCategory表类型为TempCate的rowid 
/// Return:      StructureCode 关联的业务域编码
/// Debug：      w ##Class(EMRservice.BL.BLInstanceData).getStructureCode("58")
ClassMethod getStructureCode(aDocID As %String) As %String
{
    s StructureCode = ""
   	s objEMRTemCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(aDocID)
	q:(objEMRTemCategoryDoc = "") StructureCode
	s StructureCode = objEMRTemCategoryDoc.InternalID
	//如果关联的项目是一个^分隔，表示关联多个业务域编码（病程记录），返回业务域编码为空
	if (StructureCode ["^")
	{
		s StructureCode = ""
	}
    q StructureCode
}

}
