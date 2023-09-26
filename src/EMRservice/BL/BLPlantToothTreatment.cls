/// 名称:EMRservice.BL.BLPlantToothTreatment
/// 描述:种植牙疗程--BL层
/// 编写者：liuyunfei
/// 编写日期: 2020-08-03
Class EMRservice.BL.BLPlantToothTreatment Extends %RegisteredObject
{

/// desc：	插入数据
/// debug：	d ##class(EMRservice.BL.BLPlantToothTreatment).insertRecord("202083100930","你是第一个","第一个描述","","718","20","10209")
ClassMethod insertRecord(TreatmentID As %String, Name As %String, Desc As %String, InstanceId As %String, EpisodeId As %String, PatientId As %String, UserID As %String)
{
	s result = 0
	s obj = ##Class(EMRinstance.PlantToothTreatment).%New()
	s obj.TreatmentID = TreatmentID
	s obj.Name = Name
	s obj.Description = Desc
	s obj.InstanceId = InstanceId
	s obj.EpisodeId = EpisodeId
	s obj.PatientId = PatientId
	s data = $zd($p($h,",",1),3)
	s time = $zt($p($h,",",2),1)
	s DataTime = data_" "_time
	s obj.DataTime = DataTime
	s obj.UserID = UserID
	s obj.IsActive = 1
	TSTART
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		d obj.%Close()
		s result = 1
		w result
	}
	else
	{
		TROLLBACK
		s result = 0
		w result
	}
}

/// desc:	更新数据
/// debug：	w ##class(EMRservice.BL.BLPlantToothTreatment).updateRecord("20","2020810164927","727","356||7")
ClassMethod updateRecord(PatientId As %String, TreatmentId As %String, EpisodeId As %String, InstanceId As %String) As %String
{
	s result = 0
	q:(TreatmentId="") result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		continue:(obj.TreatmentID '= TreatmentId)
		s instanceIdObj = ##Class(EMRinstance.PlantToothTreatmentInstanceId).%New()
		if ((EpisodeId '= "")&&'(obj.EpisodeId[EpisodeId))
		{
			if (obj.EpisodeId="")
			{
				s obj.EpisodeId = EpisodeId
			}
			else
			{
				s obj.EpisodeId = obj.EpisodeId_"^"_EpisodeId
			}
		}
		if ((InstanceId '= "")&&'(obj.InstanceId[InstanceId))
		{
			if (obj.InstanceId="")
			{
				s obj.InstanceId = InstanceId
			}
			else
			{
				s obj.InstanceId = obj.InstanceId_"^"_InstanceId
			}
			s instanceIdObj.InstanceId = InstanceId
			s instanceIdObj.IsActive = 1
			s instanceIdObj.TreatmengId = TreatmentId
		}
		TSTART
		s sc = obj.%Save()
		s scInstance = instanceIdObj.%Save()
		if (($$$ISOK(sc))&&($$$ISOK(scInstance)))
		{
			TCOMMIT
			s result = 1
		}
		else
		{
			TROLLBACK
		}
	}
	q result
}

/// desc:	修改疗程名称和描述
/// debug：	w ##class(EMRservice.BL.BLPlantToothTreatment).modifyNameDescById("36","2020916134257","疗程2","疗程2的描述修改")
ClassMethod modifyNameDescById(PatientId As %String, TreatmentId As %String, Name As %String, Desc As %String) As %String
{
	s rs = 0
	q:(TreatmentId="")||(PatientId="") re
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		continue:(obj.TreatmentID'=TreatmentId)
		s obj.Name = Name
		s obj.Description = Desc
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			s rs = 1
		}
		q
	}
	q rs
}

/// desc:	删除疗程对应的instanceId
/// debug：	w ##class(EMRservice.BL.BLPlantToothTreatment).deleteRecordInstanceId("347||1")
ClassMethod deleteRecordInstanceId(InstanceId As %String) As %String
{
	s result = 0
	q:(InstanceId="") result
	s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_InstanceId,""))
	q:(rowId="") result
	s obj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
	q:(obj="") result
	s obj.IsActive = 0
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = 1
	}
	q result
}

/// desc:	删除疗程(修改疗程是否展示字段)
/// debug：	w ##class(EMRservice.BL.BLPlantToothTreatment).deleteRecord()
ClassMethod deleteRecord(PatientId As %String, TreatmentId As %String) As %String
{
	s result = 0
	q:(TreatmentId="") result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		continue:(obj.TreatmentID'=TreatmentId)
		s obj.IsActive = 0
		s sc = obj.%Save()
		if ($$$ISOK(sc)) 
		{
			s result = 1
		}
	}
	q result
}

/// desc:	取折叠版信息
/// debug：	w ##class(EMRservice.BL.BLPlantToothTreatment).getAccordionInfo("20")
ClassMethod getAccordionInfo(PatientId As %String) As %String
{
	q:(PatientId="")
	s count = 0
	s json = ""
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		q:(obj="")
		if (obj.IsActive = 1)
		{
			s title = obj.Name_"-"_obj.Description
			s:(count'=0) json = json_","
			s json = json_"{""id"":"""_obj.TreatmentID_""","
			s json = json_"""title"":""<a onclick=modifyTitle('"_obj.Name_"','"_obj.Description_"','"_obj.TreatmentID_"','"_count_"')>"_title_"</a>""}"
			s count = count + 1
		}
	}
	q json
}

/// Desc:       病历模板目录
/// Modify:     Candyxu
/// DateTime:   2016-11-28
/// Input:      AParentId:目录CategoryId
///             AEpisodeID:就诊号
/// OutPut:     json   
/// Debug:      w ##Class(EMRservice.BL.BLPlantToothTreatment).GetTempCateJsonByCategoryID(50,725,10209,"",2020810164927,20)
ClassMethod GetTempCateJsonByCategoryID(AParentID As %String, AEpisodeID As %String, AUserID As %String, ADocId As %String = "", ATreatmentID As %String = "", PatientId As %String) As %GlobalCharacterStream
{
	s json = ##Class(%GlobalCharacterStream).%New()
	s priActivity = ##Class(EMRservice.BL.BLClientCategory).CheckTPrivActivity()  //权限控制	
	s curPatInfo = ##class(EMRservice.DocRestLogic.PrivLogic).GetPatInfo(AEpisodeID,AUserID)
	s patDept = $p($li(curPatInfo,2),$c(2),2)
	s strdocIds = ##Class(EMRservice.BL.BLClientCategory).GetDocByCategoryID(AParentID,AEpisodeID,AUserID,priActivity,curPatInfo)
	q:((AParentID = "")||(AEpisodeID = "")) json
	s mutexdoc = $p(strdocIds,"&",1)
	s nomutexdoc = $p(strdocIds,"&",2)
	s iswrited = ##class(EMRservice.BL.BLInstanceData).IsHasInstanceByDocIDs(AEpisodeID,mutexdoc)
	if (iswrited = "1")
	{
	 	s strdocIds = nomutexdoc
	}
	else
	{
		s strdocIds = mutexdoc_"^"_nomutexdoc
	}
	s key = $i(^CacheTemp("GetTempCateJsonByCategoryID"))
	for i=1:1:$l(strdocIds,"^")
	{
		s docId = $p(strdocIds,"^",i)
		continue:(docId = "")
		continue:((ADocId '= "")&&(ADocId '= docId))
		s objdoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
        continue:(objdoc = "")
		s objchapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objdoc.ParentCategoryID)
		continue:(objchapter = "")
		s objcategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objchapter.ParentCategoryID)
		continue:(objcategory = "")
		
		s JaneSpell = objchapter.JaneSpell
	    s FullFight = objchapter.FullFight
		
		s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(docId)
	    continue:(objTemplate = "")
	    
	    s existFlag = "0"
	    s episodeIds = ..getEpisodeIdById(PatientId,ATreatmentID)
	    for j=1:1:$l(episodeIds,"^")
	    {
			s episodeId = $p(episodeIds,"^",j)
			s result = ##class(EMRservice.BL.BLInstanceData).IsHasInstance(episodeId, objTemplate.ID,docId)
			if (result '= 0)
			{
				s existFlag = ..isExistById(PatientId,ATreatmentID,result)
			}
			q:(existFlag = 1)
		}
		continue:((result '= 0) && (objTemplate.ChartItemType = "Single") && (existFlag))	
		s quotationFlag = ##Class(EMRservice.BL.BLQuotation).GetDocQuationFlag(patDept,docId) 
		s displayFlag = ##Class(EMRservice.SystemParameter).SetNavQuoteDisplay(AEpisodeID)
		s:(displayFlag = "N") quotationFlag = "0"
		
		d DisPlayInTree
		
		s cjson = $ZSTRIP(cjson,"*C")
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,i)= cjson
		s ^CacheTemp("GetTempCateJsonByCategoryID",key,"Flag",docId) = i
	}
	s seq = ""
	for
	{
		s seq = $o(^CacheTemp("GetTempCateJsonByCategoryID",key,seq))
		q:(seq = "")||(seq = "Flag")
		d:(json.Size >0) json.Write(",")
		d json.Write(^CacheTemp("GetTempCateJsonByCategoryID",key,seq))
	}
	k ^CacheTemp("GetTempCateJsonByCategoryID",key)
    q json
DisPlayInTree  
	s cjson = "{"
	s cjson = cjson_ """id"":"""_docId_""""
	s cjson = cjson_ ",""text"":"""_objchapter.CategoryName_""""
	s cjson = cjson_ ",""attributes"":{" 
	s cjson = cjson_ """type"":""TempCate""" 
	s cjson = cjson_ ",""chartItemType"":"""_objTemplate.ChartItemType_"""" 
	s cjson = cjson_ ",""documentType"":"""_objTemplate.DocumentType_"""" 
	s cjson = cjson_ ",""isLeadframe"":"""_objdoc.IsLeadframe_""""
	s cjson = cjson_ ",""isMutex"":"""_objchapter.IsMutex_""""
	s cjson = cjson_",""templateId"":"""_objTemplate.ID_""""
	s cjson = cjson_",""categoryId"":"""_AParentID_""""
	s cjson = cjson_",""quotation"":"""_$case(quotationFlag>0,1:1,:0)_""""
	s cjson = cjson_ ",""JaneSpell"":"""_JaneSpell_"""" 
	s cjson = cjson_ ",""FullFight"":"""_FullFight_"""" 
	s cjson = cjson_ "}"
	s cjson = cjson_ "}"
	q
}

/// desc：	InstanceId在这个疗程下并且在子表中该InstanceId的IsActive字段值为1，则返回1
/// debug:	w ##class(EMRservice.BL.BLPlantToothTreatment).isExistById(20,2020810164927,347||1)
ClassMethod isExistById(PatientId As %String, TreatmentId As %String, InstanceId As %String) As %String
{
	s result = "0"
	q:(InstanceId="")||(TreatmentId="") result
	s instanceIds = ""
	s rowId = ""
	for 
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		q:(obj="")
		continue:(obj.TreatmentID '= TreatmentId)
		s instanceIds = obj.InstanceId
	}
	if (instanceIds[InstanceId)
	{
		s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_InstanceId,""))
		q:(rowId="") result
		s instanceIdObj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
		q:(instanceIdObj="") result
		s:(instanceIdObj.IsActive=1) result = 1
	}
	q result
}

/// desc：	根绝疗程id和patientId获取episodeId
/// debug:	w ##class(EMRservice.BL.BLPlantToothTreatment).getEpisodeIdById(20,202083112633)
ClassMethod getEpisodeIdById(PatientId As %String, TreatmentId As %String) As %String
{
	q:(PatientId = "") ""
	s rowId = ""
	s episodeIds = ""
	for 
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		q:(obj="")
		continue:(obj.TreatmentID '= TreatmentId)
		s episodeIds = obj.EpisodeId
	}
	q episodeIds
}

/// Desc: 取实例数据JSon
/// Creator:Candy
/// CreateDate:2014-11-28
/// Input:     AEcrecordID EMRinstance.ECRecord的ID
///            ASubID EMRinstance.InstanceData的subId
/// Debug:     w ##Class(EMRservice.BL.BLPlantToothTreatment).GetInstanceJsonByID("340||1")
ClassMethod GetInstanceJsonByID(InstanceId As %String) As %String
{
	s json = ""
	q:(InstanceId = "") json
	s rowId = InstanceId
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	s docId = objInstance.TheECRecord.RealChartItemID
	s num = objInstance.ListNo
	s title = ##Class(EMRservice.Util.EscapeSpecialWord).HtmlEscape(objInstance.Title)
	s templateId = objInstance.RealTemplateID
	s summary = objInstance.Memo
	s objCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objCategoryDoc = "") json
	s objChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objCategoryDoc.ParentCategoryID)
	q:(objChapter = "") json
	s categoryId = objChapter.ParentCategoryID
	s categoryName = objChapter.CategoryName
	s isLeadframe = objCategoryDoc.IsLeadframe
	s isMutex = objChapter.IsMutex
	s isWaitsign = objCategoryDoc.IsWaitsign
	s characteristic = objInstance.TheECRecord.DocumentCharacteristic
	s chartItemType = objInstance.TheECRecord.ChartItemType
	s documentType = objInstance.TheECRecord.DocumentType
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	//add by lifb 2017-08-21
	s HISFormatHappenDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",happendate)
	s HISFormatHappenTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",happentime)


	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s statusCode = $p(log,"^",10)
	s status = $p(log,"^",11)
	s revokeSign = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsRevokeSign","Y")
	s hasSign = ##Class(EMRservice.BL.BLTemplateSign).HasRecordSign(epsiodeId,docId,num)
	s waitTitleCode = objInstance.TitleCode
	s:(waitTitleCode = "") waitTitleCode = $zcvt(chartItemType,"U")
	if (isWaitsign '= "1")
	{
		s doctorwait = ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(templateId,objInstance.TemplateVersion,waitTitleCode,"MEDICAL",hasSign,epsiodeId,docId,num,revokeSign)
	}
	else
	{
		s doctorwait = "0"
	}
	s patientwait = ##Class(EMRservice.BL.BLTemplateSign).GetSignWaitStatus(templateId,objInstance.TemplateVersion,waitTitleCode,"PATIENT",hasSign,epsiodeId,docId,num,revokeSign)
	s creator = $tr($p(log,"^",1)," ","")
	//获取病历日志明细最后一次操作的Action名字
	s action = $p(log,"^",8)
	s:(action '= "print") action = ""
	//产品来源名称
	s productSource = $p(log,"^",17)
	if (action '= "") 
	{
		s action = ##Class(EMRservice.BL.BLOperationNameBasedProduct).GetOperationName(action,productSource)
		s:(action = "") action = "已打印"
	}
	//病历目前最新状态status的操作者operator
	s operator = ##Class(EMRservice.BL.BLEMRLogs).GetOperatorByInstanceId(epsiodeId,rowId)
	s startPage = objInstance.StartPageNum
	s endPage = objInstance.EndPageNum
	//修改了记录时间的标志
	s modifyTimeFlag = 0
	if ((objInstance.CreateDate '= objInstance.HappenDate)||($zabs(objInstance.CreateTime - objInstance.HappenTime) > 120))
	{
		s modifyTimeFlag = 1
	}
	
	s isModifyColorChangeColor = ##Class(EMRservice.SystemParameter).IsModifyRecordChangeColor()
	
	/*s orgItemId = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_categoryId,""))
	q:(orgItemId = "") json
	s objOrgItem = ##Class(EMRmeta.CTOrganizationSchemeItem).%OpenId(orgItemId)
	q:(objOrgItem = "") json*/
	
	s itemTitle ="测试" //objOrgItem.ItemTitle

	d RecordListType

	k objInstance,objCategoryDoc,objChapter
	s json = $ZSTRIP(json,"*C")
	q json
RecordListType
	s json = json_"{"
	s json = json_"""id"":"""_rowId_""""
	s json = json_",""text"":"""_title_""""
	s json = json_",""chartItemType"":"""_chartItemType_"""" 
	s json = json_",""documentType"":"""_documentType_"""" 
	s json = json_",""categoryId"":"""_ categoryId_""""
	s json = json_",""emrDocId"":"""_docId_""""
	s json = json_",""emrNum"":"""_num_""""
	s json = json_",""templateId"":"""_templateId_""""
	s json = json_",""isLeadframe"":"""_isLeadframe_"""" 
	s json = json_",""isMutex"":"""_isMutex_"""" 
	s json = json_",""characteristic"":"""_characteristic_""""
	s json = json_",""happendate"":"""_HISFormatHappenDate_""""
	s json = json_",""happentime"":"""_HISFormatHappenTime_""""
	s json = json_",""creator"":"""_creator_""""
	s json = json_",""operator"":"""_operator_""""
	s json = json_",""statusCode"":"""_statusCode_""""
	s json = json_",""status"":"""_status_""""
	s json = json_",""printstatus"":"""_action_""""
	s json = json_",""summary"":"""_summary_""""
	s json = json_",""JaneSpell"":"""_objChapter.JaneSpell_""""
	s json = json_",""FullFight"":"""_objChapter.FullFight_""""
	s json = json_",""startPage"":"""_startPage_""""
	s json = json_",""endPage"":"""_endPage_""""
	s json = json_",""hasSign"":"""_hasSign_""""
	s json = json_",""modifyTimeFlag"":"""_modifyTimeFlag_""""
	s json = json_",""isWaitsign"":"""_isWaitsign_""""
	s json = json_",""createdate"":"""_HISFormatHappenDate_""""
	s json = json_",""createtime"":"""_HISFormatHappenTime_""""
	s json = json_",""itemTitle"":"""_itemTitle_""""
	s json = json_",""nodeType"":""instance"""
	s json = json_",""doctorwait"":"""_doctorwait_""""
	s json = json_",""patientwait"":"""_patientwait_""""
    s json = json_",""epsiodeId"":"""_epsiodeId_""""
    s json = json_",""instanceId"":"""_InstanceId_""""
	s json = json_"}"
	q
}

/// desc：	根绝patientId和疗程Id获取该疗程下所有可用的实例卡片信息
/// debug:	w ##class(EMRservice.BL.BLPlantToothTreatment).getInstanceIdById(20,202083112633)
ClassMethod getInstancesJsonById(PatientId As %String, TreatmentId As %String) As %String
{
	s json = ##Class(%GlobalCharacterStream).%New()
	q:(PatientId = "") json
	s count = 0
	s rowId = ""
	for 
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		q:(obj="")
		continue:(obj.TreatmentID '= TreatmentId)
		s instanceIds = obj.InstanceId
	}
	q:(instanceIds="") json
	for i=1:1:$l(instanceIds,"^")
	{
		s instanceId = $p(instanceIds,"^",i)
		s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_instanceId,""))
		q:(rowId="")
		s instanceIdObj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
		q:(instanceIdObj="")
		continue:(instanceIdObj.IsActive=0)
		s tempJson = ..GetInstanceJsonByID(instanceId)
		continue:(tempJson = "")
		d:(count '= 0) json.Write(",")
		d json.Write($ZSTRIP(tempJson,"*C"))
		s count = count + 1	
	}
	q json
}

/// desc：	判断该科室是否可加载疗程页签，如果可以会返回配置类中的categoryId；如果不可以返回空
/// debug:	w ##class(EMRservice.BL.BLPlantToothTreatment).GetLoadedFlag(28,6)
ClassMethod GetLoadedFlag(SSGroupID As %String, CTLocID As %String) As %String
{
	s result = ""
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.SystemParameter||getPlantToothTreatmentCategoryId") = "0") result
	s categoryId = ##Class(EMRservice.SystemParameter).getPlantToothTreatmentCategoryId()
	q:(categoryId="") result
	s CTORowId = $o(^DHCEMRM.CTOrgSchemeItemI("IdxEMRTemplateCategoryID"," "_categoryId,""))
	q:(CTORowId="") result
	s CTOObj = ##class(EMRmeta.CTOrganizationSchemeItem).%OpenId(CTORowId)
	q:(CTOObj="") result
	
	q:($d(^DHCEMRM.EMRNavItemSSGroupI("IdxCodeSSGroup"," OUTPATIENT"," "_CTOObj.ItemCode," "_SSGroupID))<=0) result			
	q:($d(^DHCEMRM.EMRNavItemLocI("IdxCodeCTLocID"," OUTPATIENT"," "_CTOObj.ItemCode," "_CTLocID))<=0) result
	
	s EMRRowId = $o(^DHCEMRM.EMRNavSchemeItemI("IdxSchemeItemCode"," OUTPATIENT"," "_CTOObj.ItemCode,""))
	q:(EMRRowId="") result
	s result = categoryId
	q result
}

/// desc：	根据patientId和疗程Id获取所有可用的instanceId
/// debug:	w ##class(EMRservice.BL.BLPlantToothTreatment).getInstanceIdByTreatId(20,2020810164927)
ClassMethod getInstanceIdByTreatId(PatientId As %String, TreatmentId As %String) As %String
{
	s result=""
	q:(PatientId="")||(TreatmentId="") result
	s instanceIds = ""
	s rowId = ""
	for 
	{
		s rowId = $o(^DHCEMRI.PlantToothTI("IdxPatientId"," "_PatientId,rowId))
		q:(rowId="")
		s obj = ##class(EMRinstance.PlantToothTreatment).%OpenId(rowId)
		q:(obj="")
		continue:(obj.TreatmentID '= TreatmentId)
		s instanceIds = obj.InstanceId
	}
	for i=1:1:$l(instanceIds,"^")
	{
		s InstanceId = $p(instanceIds,"^",i)
		s rowId = $o(^DHCEMRI.PlantToothTInsI("IdxInstanceId"," "_InstanceId,""))
		q:(rowId="")
		s instanceIdObj = ##class(EMRinstance.PlantToothTreatmentInstanceId).%OpenId(rowId)
		q:(instanceIdObj="")
		if (instanceIdObj.IsActive=1)
		{
			s:(result'="") result = result_"^"_InstanceId
			s:(result="") result = InstanceId
		}
	}
	q result
}

}
