Class EMRservice.HISInterface.CentralizedPrint Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:	    集中打印使用，加载所有备打印项目
/// Creator:    yang
/// CreateDate: 2015-8-10
/// Output:     string
/// debug:      w ##Class(EMRservice.HISInterface.CentralizedPrint).GetEMRDetailAllJson()
ClassMethod GetEMRDetailAllJson(AParentNodeID As %String) As %String
{
	s count = 0
	s cgID = ""
	for {
		s cgID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " 0", cgID))
		q:(cgID = "")

		s ccID = ""
		for {
			s ccID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_cgID, ccID))
			q:(ccID = "")
			
			s docID = ""
			for
			{
				s docID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_ccID,docID))	
				q:(docID = "")
				
				s cgDesc = ..GetTemplateCategoryDesc(cgID)
				s ccDesc = ..GetTemplateCategoryDesc(ccID)
				s docDesc = ..GetTemplateCategoryDesc(docID)
				
				s desc = cgDesc_"."_ccDesc_"."_docDesc
				s catalogID = "CD_"_cgID_"_"_ccID_"_"_docID

				s count = count + 1
				if (count > 1) w ","
				
				w "{"
				w "id:'"_catalogID_"'"
				w ",text:'"_desc_"'"
				w ",leaf:'true'"
				w ",cls:'folder'"
				w ",checked:false"
				w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
				w "}"
			}
		}
	}
}

/// Desc:	    一键打印使用，加载一次就诊的所有可打印项目
/// Creator:    yang
/// CreateDate: 2015-8-10
/// Output:     string
/// debug:      w ##Class(EMRservice.HISInterface.CentralizedPrint).GetCatalogJson()
ClassMethod GetEMRDetailJson(AParentNodeID As %String, AEpisodeID As %String, APatientID As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String) As %String
{
	s count = 0
	s cgID = ""
	for {
		s cgID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " 0", cgID))
		q:(cgID = "")
		
		s ccID = ""
		for {
			s ccID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_cgID, ccID))
			q:(ccID = "")
			
			s docID = ""
			for
			{
				s docID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_ccID,docID))	
				q:(docID = "")
				
				s cgDesc = ..GetTemplateCategoryDesc(cgID)
				s ccDesc = ..GetTemplateCategoryDesc(ccID)
				s docDesc = ..GetTemplateCategoryDesc(docID)
				
				s desc = cgDesc_"."_ccDesc_"."_docDesc
				s catalogID = "CD_"_cgID_"_"_ccID_"_"_docID

				//是否需要打印
				continue:(..CheckCanPrint(AUserID,ACTLocID,ASSGroupID,APatientID,AEpisodeID,catalogID) = "0")

				s info = "CD_"_cgID_"_"_ccID_"_"_docID

				s count = count + 1
				if (count > 1) w ","
				
				w "{"
				w "id:'"_catalogID_"'"
				w ",text:'"_desc_"'"
				w ",leaf:'true'"
				w ",cls:'folder'"
				w ",checked:false"
				w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
				w ",detailInfo:'"_info_"'"
				w "}"
			}
		}	
	}
}

/// Desc:	    所有病历展现结构目录
/// Creator:    Candy
/// CreateDate: 2015-8-3
/// Output:     jsonStream
/// debug:      d ##Class(EMRservice.HISInterface.CentralizedPrint).GetCatalogJson()
ClassMethod GetCatalogJson()
{
	w "["
 	s count = 0
	s cgID = ""
	for {
		s cgID = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " 0", cgID))
		q:(cgID = "")
		s ccID = ""
		for {
			s ccID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_cgID, ccID))
			q:(ccID = "")
			s docID = ""
			for
			{
				s docID = $O(^DHCEMRM.EMRTemplateCategoryI("IdxParentCategoryID", " "_ccID,docID))	
				q:(docID = "")
				s count = count + 1
				s cgDesc = ..GetTemplateCategoryDesc(cgID)
				s ccDesc = ..GetTemplateCategoryDesc(ccID)
				s docDesc = ..GetTemplateCategoryDesc(docID)
				s desc = cgDesc_"."_ccDesc_"."_docDesc
				s allID = "CD_"_cgID_"_"_ccID_"_"_docID

				w:(count > 1) ","
				w "{"
				w """id"":"""_allID_""""
				w ",""text"":"""_desc_""""
				w ",""leaf"":""true"""
				w ",""cls"":""folder"""
				w ",""checked"":""false"""
				w ",""icon"":""../scripts/epr/ExtJS/resources/images/default/tree/folder.gif"""
				w "}"			
			}

		}
	}
	w "]"
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
/// Debug: w ##class(EMRservice.HISInterface.CentralizedPrint).CheckCanPrint("105","6","100","48","76","CD_1_50_53")
ClassMethod CheckCanPrint(AUserID, ACTLocID, ASSGroupID, APatientID, AEpisodeID, ACatalogID) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(ACatalogID = "") result
	s docId = $p(ACatalogID,"_",4)
	s recordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId,""))
	q:(recordId = "") result
	q:($d(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE"))<=0) result
	//检查病历是否有打印权限，可重复模板的每个实例必须都有权限，才能打印——由病历操作权限脚本控制
	s printFlag = "1"
	s date = ""
	for
	{
		s date = $O(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE",date))
		q:(date = "")
		
		s time = ""
		for
		{
			s time = $O(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE",date,time))
			q:(time = "")
		
			s ListNo = ""
			for
			{
				s ListNo = $O(^DHCEMRI.InstanceDataI("IdxHappenDateTime",recordId," SAVE",date,time,ListNo))
				q:(ListNo = "")
		
				s InstanceID = recordId_"||"_ListNo
				//检查是否有打印病历的权限,由权限脚本控制
				s privString = "userid^"_AUserID_"!userloc^"_ACTLocID_"!ssgroupid^"_ASSGroupID_"!admid^"_AEpisodeID_"!patientid^"_APatientID_"!instanceid^"_InstanceID_"!docid^"_docId
				s privRule = ##class(EMRservice.BL.BLPrivRule).ParsePrivRule(privString,"ActionPrivilege")
				s privRuleArr = ##class(EMRservice.BL.BLPrivRule).PrivStringToArray(privRule)
				
				if (privRuleArr.GetAt("print") = "0")
				{
					s printFlag = "0"
				}
			}
		}
	}
	if (printFlag = "1")
	{
		s result = "1"
	}
	
	q result
}

/// Desc:       返回加载病历相关参数 
/// CreateDate: 2015-8-3
/// Creator:    Candy
/// Input:      AEpisodeID 就诊号
///             ACatalogID 打印方案项ID 格式：CD#1#27  CD为标识号表示是电子病历目录,1 categoryID,27 chapterID
/// OutPut:     加载病历所需参数[当是唯一模板或像病程在一个编辑打开的病历，取一个病历ID便可以，其它情况返回所有实例ID]
/// Debug:      w ##class(EMRservice.HISInterface.CentralizedPrint).GetLoadRecordParam(112,"CD_3_52_53")
ClassMethod GetLoadRecordParam(AEpisodeID As %String, ACatalogID As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(AEpisodeID = "")||(ACatalogID = "") result
	s docId = $p(ACatalogID,"_",4)
	s recordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,docId,""))
	q:(recordId = "") result
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(recordId)
    q:(objRecord = "") result
    d result.Write("[")
    if ((objRecord.DocumentCharacteristic = "1") || (objRecord.ChartItemType = "Single"))
    {
	    d result.Write(..GetOneInstanceID(recordId))
    } 
    else
    {
	    d result.CopyFrom(..GetAllInstanceID(recordId))
	}
	d result.Write("]")
	q result
}

/// Desc:       当病历是唯一模板或可重复模板连续显示时，取第一个病历ID
/// Creator:    Candy
/// CreateDate: 2017-1-20
/// Input:      AEcrecordId 实例父表ID
ClassMethod GetOneInstanceID(AEcrecordId As %String) As %String
{
	s result = ""
    s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AEcrecordId," SAVE",""))
    q:(date = "") result
    s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AEcrecordId," SAVE",date,""))
    q:(time = "") result
    s childId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AEcrecordId," SAVE",date,time,""))
    q:(childId = "") result
    s instanceId = AEcrecordId_"||"_childId
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
    q:(objInstanceData = "") result
    
    s episodeID = objInstanceData.EpisodeID
    s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(instanceId, episodeID)
    s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")
    
    
    s result = "{"
    s result = result_"""id"":"""_instanceId_""""
    s result = result_",""text"":"""_objInstanceData.Title_""""
    s result = result_",""chartItemType"":"""_objInstanceData.TheECRecord.ChartItemType_""""
    s result = result_",""pluginType"":"""_objInstanceData.TheECRecord.DocumentType_""""
    s result = result_",""emrDocId"":"""_objInstanceData.TheECRecord.RealChartItemID_""""
	s result = result_",""pdfDocType"":"""_pdfDocType_""""
    s result = result_"}"
    q result
}

/// Desc:当病历是可重复模板，且单独显示时，取所有实例
/// Creator:    Candy
/// CreateDate: 2017-1-20
/// Input:      AEcrecordId 实例父表ID
ClassMethod GetAllInstanceID(AEcrecordId As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(AEcrecordId = "") result
	s count = 0
	s date = ""
	for
	{
	    s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AEcrecordId," SAVE",date))
	    q:(date = "") 
	    s time = ""
	    for
	    {
		    s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AEcrecordId," SAVE",date,time))
		    q:(time = "") 
		    s childId = ""
		    for
		    {
			    s childId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AEcrecordId," SAVE",date,time,childId))
			    q:(childId = "") 
			    s instanceId = AEcrecordId_"||"_childId
			    s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
			    q:(objInstanceData = "") 
			    
			    s episodeID = objInstanceData.EpisodeID
    			s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(instanceId, episodeID)
    			s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")
			    
			    s tmp = "{"
			    s tmp = tmp_"""id"":"""_instanceId_""""
			    s tmp = tmp_",""text"":"""_objInstanceData.Title_""""
			    s tmp = tmp_",""chartItemType"":"""_objInstanceData.TheECRecord.ChartItemType_""""
			    s tmp = tmp_",""pluginType"":"""_objInstanceData.TheECRecord.DocumentType_""""
			    s tmp = tmp_",""emrDocId"":"""_objInstanceData.TheECRecord.RealChartItemID_""""
				s tmp = tmp_",""pdfDocType"":"""_pdfDocType_""""
			    s tmp = tmp_"}"
			    d:(count '= 0) result.Write(",")
			    d result.Write(tmp)
			    s count = count + 1
		    }
	    }
	}
	q result
}

/// Desc:       通过InstanceID获取相应信息，供单独打印某一病程使用
/// Debug:      w ##class(EMRservice.HISInterface.CentralizedPrint).GetInsInfoByInstanceID("4142||8")
ClassMethod GetInsInfoByInstanceID(instanceId As %String) As %String
{
    s result = ""
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
    q:(objInstanceData = "") result
    
    s episodeID = objInstanceData.EpisodeID
    s pdfStatus = ##Class(EMRservice.BL.BLPDFAuditSignLog).GetPDFStatus(instanceId, episodeID)
    s pdfDocType = $Case($zcvt(pdfStatus,"U"),"SIGNED":"PDF",:"XML")
    
    s result = "{"
    s result = result_"""id"":"""_instanceId_""""
    s result = result_",""text"":"""_objInstanceData.Title_""""
    s result = result_",""chartItemType"":"""_objInstanceData.TheECRecord.ChartItemType_""""
    s result = result_",""pluginType"":"""_objInstanceData.TheECRecord.DocumentType_""""
    s result = result_",""emrDocId"":"""_objInstanceData.TheECRecord.RealChartItemID_""""
	s result = result_",""pdfDocType"":"""_pdfDocType_""""
    s result = result_"}"
    s result = "["_result_"]"
    q result
}

/// Desc:       返回病历页数 
/// CreateDate: 2016-6-1
/// Creator:    Candy
/// Input:      AEpisodeID 就诊号
///             ADocID 病历DocID，目录展现结构的和三层ID
/// OutPut:     页数
/// Debug:      w ##class(EMRservice.HISInterface.CentralizedPrint).GetEpisodePage(76,"53")
ClassMethod GetEpisodePage(AEpisodeID As %String, ADocID As %String) As %String
{
	s page = 0
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,""))
	q:(ecrecordId = "") page
	s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date),-1)
	q:(date = "") page
	s time = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time),-1)
	q:(time = "") page
	s subId = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," SAVE",date,time,""))
	q:(subId = "") page
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(ecrecordId_"||"_subId)
	q:(objInstance = "") page
	s page = objInstance.EndPageNum
	q page
}

}
