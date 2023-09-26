Class DHCEPRFS.BL.HISInfo.BLEMRInfo Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:  取页数
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetEMRPages("11142137","CD_3_52_53")
ClassMethod GetEMRPages(AEpisodeID As %String, ATypeParam As %String) As %String
{
	s AEPRDocID = $p(ATypeParam,"_",4)
	q:(AEpisodeID = "")||(AEPRDocID = "") "0"
	
	s indexPrefix = " "
	s:(##class(%Dictionary.CompiledProperty).%ExistsId("EMRinstance.ECRecord||RealEpisodeID")) indexPrefix = ""
	s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",indexPrefix_AEpisodeID,indexPrefix_AEPRDocID,""))
	q:(ecRecordID = "") "0"
	
	s dt = $O(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID," SAVE",""),-1)
	q:(dt = "") "0"
	
	s tm = $O(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID," SAVE",dt,""),-1)
	q:(tm = "") "0"
	
	s childSub = $O(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecRecordID," SAVE",dt,tm,""))
	q:(childSub = "") "0"
	
	s instanceID = ecRecordID_"||"_childSub
	
	s obj = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
	q:(obj="") "0"
	
	q obj.EndPageNum
}

/// Desc:       取目录描述
/// Creator：   Candy
/// CreateDate: 2015-8-3
/// Input:      ID 目录ID
/// Output:     Desc 描述
ClassMethod GetTemplateCategoryDesc(AID As %String) As %String
{
	s ccDesc = ""
	s obj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(AID)
	q:(obj = "") ccDesc
	s ccDesc = $ZSTRIP(obj.CategoryName,"*C")
	q ccDesc
}

/// Desc:       判断目录展现结构下是否有可打印病历
/// Creator:    Candy
/// CreateDate: 2015-8-3
/// Input:      AUserID 当前用户ID
///             ACTLocID 当前科室ID
///             ASSGroupID 当前科室组ID
///             APatientID 患者ID
///             AEpisodeID 就诊号
///             ACatalogID 打印方案配置项
/// Output       result 1可以打印，0不可以打印
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrint("105","6","100","48","76","103")
ClassMethod CheckCanPrint(AUserID, ACTLocID, ASSGroupID, APatientID, AEpisodeID, ACatalogID) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(ACatalogID = "") result
	s docId = ACatalogID
	s indexPrefix = " "
	s:(##class(%Dictionary.CompiledProperty).%ExistsId("EMRinstance.ECRecord||RealEpisodeID")) indexPrefix = ""
	s recordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",indexPrefix_AEpisodeID,indexPrefix_docId,""))
	q:(recordId = "") result
	q:($d(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE"))<=0) result
	s privString = "userid^"_AUserID_"!userloc^"_ACTLocID_"!ssgroupid^"_ASSGroupID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!instanceid^"
	s privRule = ##class(EMRservice.BL.BLPrivRule).ParsePrivRule(privString,"ActionPrivilege")
	q:($p($p(privRule,"!",2),"^",2) = "0") result
	s result = "1"
	q result
}

/// Desc:       判断指定ID是否可打印
/// Creator:    yang
/// CreateDate: 2015-10-9
/// Input:      AEpisodeID 就诊号
///             ACatalogID 打印方案配置项
/// Output       result 1可以打印，0不可以打印
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv("815","106")
ClassMethod CheckCanPrintWOPriv(AEpisodeID As %String, ACatalogID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(ACatalogID = "") result
	s docId = ACatalogID
	/* 电子病历启用回写编目首页的功能时,再开启 yangpeng 2017.3.9
	s FPDocID=##Class(EMRservice.SystemParameter).GetDHCEMRFPDocID() 
	q:(docId=FPDocID) "1"
	*/
	s indexPrefix = " "
	s:(##class(%Dictionary.CompiledProperty).%ExistsId("EMRinstance.ECRecord||RealEpisodeID")) indexPrefix = ""
	s recordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",indexPrefix_AEpisodeID,indexPrefix_docId,""))
	q:(recordId = "") result
	q:($d(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE"))<=0) result
	s result = "1"
	q result
}

/// Desc:       返回加载病历相关参数 
/// CreateDate: 2015-8-3
/// Creator:    Candy
/// Input:      AEpisodeID 就诊号
///             ACatalogID 打印方案项ID 格式：CD#1#27  CD为标识号表示是电子病历目录,1 categoryID,27 chapterID
/// OutPut:     加载病历所需参数
/// Debug:      w ##class(DHCEPRFS.BL.HISInfo.BLEMRInfo).GetLoadRecordParam(826,"50")
ClassMethod GetLoadRecordParam(AEpisodeID As %String, ACatalogID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(ACatalogID = "") result
	s chapterId = ACatalogID
	s indexPrefix = " "
	s:(##class(%Dictionary.CompiledProperty).%ExistsId("EMRinstance.ECRecord||RealEpisodeID")) indexPrefix = ""
	s docId = ""
	for {
		s docId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_chapterId, docId))
		q:(docId = "")
		s recordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",indexPrefix_AEpisodeID,indexPrefix_docId,""))
		continue:(recordId = "")
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE",""))
		continue:(date = "")
		s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE",date,""))
		continue:(time = "")
		s childId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE",date,time,""))
		continue:(childId = "")
		s instanceId = recordId_"||"_childId
		s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(recordId)
		continue:(objRecord = "")
		s chartItemType = objRecord.ChartItemType
		s documentType = objRecord.DocumentType
		s docId = objRecord.ChartItemID
		s:$IsObject(objRecord.ChartItemID) docId = objRecord.RealChartItemID
		k objRecord
		s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
		continue:(objInstanceData = "")
		s text = objInstanceData.Title
		k objInstanceData
		s result = "{"
		s result = result_"""id"":"""_instanceId_""""
		s result = result_",""text"":"""_text_""""
		s result = result_",""chartItemType"":"""_chartItemType_""""
		s result = result_",""pluginType"":"""_documentType_""""
		s result = result_",""emrDocId"":"""_docId_""""
		s result = result_"}"
		q
	}
	q result
}

}
