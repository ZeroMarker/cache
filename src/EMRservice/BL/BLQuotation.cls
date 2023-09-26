/// Desc:          病历引用逻辑类
/// Creator:       Candy
/// CreateDate:    2015-1-14
Class EMRservice.BL.BLQuotation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 取引用病历列表
/// Debug: w ##Class(EMRservice.BL.BLQuotation).GetRecordList(76,6,601)
ClassMethod GetRecordList(AEpisodeId As %String, ACTLocId As %String, ADocId As %String) As %String
{
	s json = ""
	s count = 0
	q:((AEpisodeId = "")||(ACTLocId = "")) json
	if (ADocId = "")
	{
		s docId = ""
		for
		{
			s docId = $O(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",ACTLocId,docId))
			q:(docId = "")
			s id = $o(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",ACTLocId,docId,""))
			continue:(id = "")
			s objQuotation = ##Class(EMRmeta.QuotationScheme).%OpenId(id)
			continue:(objQuotation = "")
			continue:(objQuotation.IsActive '= "Y")
			s cjson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save")
		    continue:(cjson = "")
		    s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
		    continue:(objTemplate = "")
		    s:(count '= 0) json = json_","
		    if (objTemplate.ChartItemType = "Single")
		    {
			    s json = json_cjson
			}
			else
			{
				s directoryId = $o(^DHCEMRI.DirectoryInformationI("IdxEpisodeIDDocID"," "_AEpisodeId," "_docId,""))
				continue:(directoryId = "")
		        s objDirectory = ##Class(EMRinstance.DirectoryInformation).%OpenId(directoryId)
		        continue:(objDirectory = "")
			    s json = json_"{"
			    s json = json_"""id"":"""_docId_""""
			    s json = json_",""text"":"""_objDirectory.DocName_""""
			    s json = json_",""children"":["_cjson_"]"
			    s json = json_"}"
			}
		    s count = count + 1		
		}
	}
	else
	{
		s id = $o(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",ACTLocId,ADocId,""))
		q:(id = "") json
		s objQuotation = ##Class(EMRmeta.QuotationScheme).%OpenId(id)
		q:(objQuotation = "") json
		q:(objQuotation.IsActive '= "Y") json
		s json = ..DoInstanceJsonByDocID(ADocId,AEpisodeId,"Save")		
	}
	q json
}

/// Desc:		根据DocId取实例
/// Creator:	Candy
/// CreateDate: 2014-8-29
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// Debug：     w ##Class(EMRservice.BL.BLClientCategory).DoInstanceJsonByDocID(4,616,76,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String) As %String
{
	s $zt = "Error"
	s result = ""
	s count = 0
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") result
	s docId = ADocId
	
	s objEmrTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objEmrTemplateCategoryDoc = "") result

	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	q:(objTemplate = "")
	s publishVersion = objTemplate.PublishVersion
	
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,docId,""))
	q:(ecrecordId = "") result
	
	s objEcrecod =  ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecod = "") result
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time))	
			q:(time = "")
			s subId = ""
			for
			{
				s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date,time,subId))			
				q:(subId = "")
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId,publishVersion)
 				continue:(tempJson = "")
 				s:(count '= 0) result = result_","
				s result = result_tempJson
				s count = count + 1			
			}
		}
	}
	s result = $ZSTRIP(result,"*C")
	q result
Error
	q ""
}

/// Desc: 取实例数据JSon
/// Creator:Candy
/// CreateDate:2014-11-28
/// Input:     AEcrecordID EMRinstance.ECRecord的ID
///            ASubID EMRinstance.InstanceData的subId
/// Debug:     w ##Class(EMRservice.BL.BLClientCategory).GetInstanceJsonByID(1,1)
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String, ATemplateVersion As %String) As %String
{
	s json = ""
	q:((AEcrecordID = "")||(ASubID = "")) json
	s rowId = AEcrecordID_"||"_ASubID
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	//判断是否可以引用不同版本病历 为0时不可以引用不同版本
	s status = ##Class(EMRservice.SystemParameter).GetQuotationStatus()
	q:((status = "0")&&(ATemplateVersion '= objInstance.TemplateVersion)) json
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	s docId = objInstance.TheECRecord.RealChartItemID
	s num = objInstance.ListNo
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	s chartItemType = objTemplate.ChartItemType
	s documentType = objTemplate.DocumentType
	s categoryId = objChapter.ParentCategoryID
	s isLeadframe = objCategoryDoc.IsLeadframe
	s isMutex = objChapter.IsMutex
	//s happendate = $zd(objInstance.HappenDate,3)
	s happendate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objInstance.HappenDate)
	//s happentime = $zt(objInstance.HappenTime)
	s happentime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objInstance.HappenTime)
	s text = objInstance.Title
	s tmeplateId = objInstance.RealTemplateID
	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s status = $p(log,"^",10)
	s creator = $tr($p(log,"^",1)," ","")
	s notes =  objInstance.Memo 
	s json = json_"{"
	s json = json_"""id"":"""_AEcrecordID_"_"_ASubID_""""
	s json = json_",""text"":"""_text_""""
	s json = json_",""chartItemType"":"""_chartItemType_"""" 
	s json = json_",""documentType"":"""_documentType_"""" 
	s json = json_",""categoryId"":"""_categoryId_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""templateId"":"""_tmeplateId_""""
	s json = json_",""isLeadframe"":"""_isLeadframe_"""" 
	s json = json_",""isMutex"":"""_isMutex_"""" 
	s json = json_",""happendate"":"""_happendate_""""
	s json = json_",""happentime"":"""_happentime_""""
	s json = json_",""creator"":"""_creator_""""
	s json = json_",""status"":"""_status_""""
	s json = json_",""summary"":"""_notes_""""
	s json = json_"}"
	q json
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLQuotation","SelectMulTempIDS")
Query SelectMulTempIDS() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_Quotation_SelectMulTempIDS, SqlProc ]
{
	SELECT c.ID FROM EMRmeta.EMRTemplate et, EMRmeta.EMRTemplateCategory c ,EMRmeta.Template t
	where et.CategoryID = c.ID AND et.BindTemplateID = t.ID AND t.ChartItemType = 'Multiple'
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLQuotation","SelectMulTempIDS")
Query SelectDataByLocID(ACTLocID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,CTLocDesc:%String,CTLocID:%String,DocID:%String,DocName:%String,IsActive:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Quotation_SelectDataByLocID, SqlProc ]
{
	SELECT ID,CTLocDesc,CTLocID,DocID,DocName,IsActive FROM EMRmeta.QuotationScheme WHERE CTLocID = :ACTLocID
}

/// 创建方案关联科室
ClassMethod CreateQuotation(aQuotation As EMRservice.entity.EQuotationScheme) As %String
{
	/// b "s"
	s strReslt = "-1"	
	s objQuoScheme = ##Class(EMRmeta.QuotationScheme).%New()
	;s rowid =""
	;s rowid =^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID"," "_aQuotation.CTLocID," "_aQuotation.DocID,rowid)
	;q:(rowid="") strReslt
	s objQuoScheme.DocID = $case(aQuotation.DocID,$c(0):"",:aQuotation.DocID)
	s objQuoScheme.DocName = $case(aQuotation.DocName,$c(0):"",:aQuotation.DocName)
	s objQuoScheme.CTLocID = $case(aQuotation.CTLocID,$c(0):"",:aQuotation.CTLocID)
	s objQuoScheme.CTLocDesc = $case(aQuotation.CTLocDesc,$c(0):"",:aQuotation.CTLocDesc)
	s objQuoScheme.IsActive = $case(aQuotation.IsActive,$c(0):"",:aQuotation.IsActive)
	s sc = objQuoScheme.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objQuoScheme.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 更新方案关联科室
ClassMethod UpdateQuotation(aQuotation As EMRservice.entity.EQuotationScheme) As %String
{
	/// b "s"	
	s strReslt = "-1"
	set objQuoScheme=##class(EMRmeta.QuotationScheme).%OpenId(aQuotation.ID)
	q:(objQuoScheme="") ""	
	s objQuoScheme.IsActive = $case(aQuotation.IsActive,$c(0):"",:aQuotation.IsActive)
	
	s sc = objQuoScheme.%Save()
	if ($$$ISOK(sc))
	{
	   s strReslt = objQuoScheme.%Id()
	}
	else
	{
		s strReslt = "-1"	
	}
	q strReslt
}

/// 删除一个方案关联科室
ClassMethod DeleteQuotationByID(aQuotationId As %String) As %String
{
    q:(aQuotationId ="") "-1"
    b
    s objQuoScheme = ##Class(EMRmeta.QuotationScheme).%OpenId(aQuotationId)
	q:(objQuoScheme="") "-1"
	s sc = ##class(EMRmeta.QuotationScheme).%DeleteId(aQuotationId)
	if ($$$ISOK(sc))
	{	
	   q "0"
    }
    else
    {
		q "-1"
	}
}

/// Desc:       引用病历，生成新病历ID
/// Creator:    Cnady
/// CreateDate: 2015-1-22
/// Input:      AEpisodeID   就诊ID
///            APInstanceID 引用源的实例ID
///            ADataTime    发生日期时间
///            ATitle       标题
///            ATitleCode   标题代码
/// Output:     InstanceID   生成的实例ID
ClassMethod QuotationDocument(AEpisodeID As %String, APInstanceID As %String, ADataTime As %String, ATitle As %String, ATitleCode As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(APInstanceID = "")) result
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(APInstanceID)
	q:(objInstance = "") result
	//生成实例ID
	s objEInstanceData = ##Class(EMRservice.entity.EInstanceData).%New()
	s objEInstanceData.GroupItemID = objInstance.GroupItemID
	s objEInstanceData.GroupItemName = objInstance.GroupItemName
	s objEInstanceData.Status = "UnSave"
	s date = $p(ADataTime," ",1),time = $p(ADataTime," ",2)
	s objEInstanceData.HappenDate = $Case(date,"":"",:$zdh(date,3))
	s objEInstanceData.HappenTime = $Case(time,"":"",:$zth(time))
	s objEInstanceData.Title = $case(ATitle="",1:objInstance.Title,:ATitle)
	s objEInstanceData.TitleCode = $case(ATitleCode="",1:objInstance.TitleCode,:ATitleCode)
	s objEInstanceData.TemplateID = objInstance.RealTemplateID
	s objEInstanceData.TemplateVersion = objInstance.TemplateVersion
	s objEInstanceData.EpisodeID = AEpisodeID
	
	s objEECRecord = ##Class(EMRservice.entity.EECRcord).%New()
	s objEECRecord.PatientID = objInstance.TheECRecord.PatientID
	s objEECRecord.EpisodeID = AEpisodeID
	s objEECRecord.CategoryID = objInstance.TheECRecord.RealCategoryID
	s objEECRecord.CategoryType =  objInstance.TheECRecord.CategoryType
	s objEECRecord.ChartItemType =objInstance.TheECRecord.ChartItemType
	s objEECRecord.DocumentType = objInstance.TheECRecord.DocumentType
	s objEECRecord.EpisodeType = $P($G(^PAADM(AEpisodeID)),"^",2)
	s rowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,objInstance.TheECRecord.RealChartItemID,""))
	if (rowID = "")
	{
		s objEECRecord.ID = ""
		s objEECRecord.InstanceCount = 1
		s objEECRecord.ChartItemID = objInstance.TheECRecord.RealChartItemID
		s objEECRecord.DocumentCharacteristic = objInstance.TheECRecord.DocumentCharacteristic
		s instanceID = ##Class(EMRservice.BL.BLInstanceData).SetECRInstanceData(objEECRecord,objEInstanceData)
	}else
	{
		s objEECRecord.ID = rowID
		s objEECRecord.InstanceCount =  +$li(^DHCEMRI.ECRecordD(rowID),9)+1
		s objEECRecord.ChartItemID = objInstance.TheECRecord.RealChartItemID
		s instanceID = ##Class(EMRservice.BL.BLInstanceData).SetECRInstanceData(objEECRecord,objEInstanceData)
	}
    s result = instanceID
    q result
}

/// Desc:        Doc是否可引用
/// Creator:     Candy
/// CreateDate:  2015-3-13
/// Input:       ALocID 科室ID
///             ADocID 目录展现结构DOCID
/// Output:      flag "0"不引用 "1"引用
ClassMethod GetDocQuationFlag(ALocID As %String, ADocID As %String) As %String
{
	s flag = "0"
	s rowId = $o(^DHCEMRM.QuotationSchemeI("IdxCTLocIDDocID",ALocID,ADocID,""))
	q:(rowId = "") flag
	s objQuotaion = ##Class(EMRmeta.QuotationScheme).%OpenId(rowId)
	q:(objQuotaion = "") flag
	s:(objQuotaion.IsActive = "Y") flag = "1"
	q flag
}

/// Desc: 判断引用的实例和当前docID是否是同一个版本
/// Creator:     duan
/// CreateDate:  2019-11-26
/// Input:       AinstanceID 实例ID
///             ADocID 目录展现结构DOCID
/// Output:
ClassMethod quatationCheck(AInstanceID As %String, ADocId As %String)
{
	s result="0"
	s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(ADocId)
	q:(objTemplate = "") result
	s publishVersion = objTemplate.PublishVersion
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance="") result
	s instanceVersion = objInstance.TemplateVersion
	s:(publishVersion'=instanceVersion) result="1"
	q result
}

}
