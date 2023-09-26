/// 名称: EMRservice.Ajax.AppointConsultation
/// 描述: 会诊病历浏览授权
/// 编写者: niucaicai
/// 编写日期:2015-12-07
Class EMRservice.Ajax.AppointConsultation Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s episodeID = $g(%request.Data("EpisodeID",1),"")
	s patientID = $g(%request.Data("PatientID",1),"")
	
	s locID = $g(%session.Data("LOGON.CTLOCID"))
	s userID = $g(%session.Data("LOGON.USERID"))
	s ssgroupID =$g(%session.Data("LOGON.GROUPID"))
	
	if (action="authorize")
	{
		s consultID = $g(%request.Data("ConsultID",1),"")
		s requestCateCharpter = $g(%request.Data("RequestCateCharpter",1),"")
		s authorizeUserID = $g(%request.Data("AuthorizeUserID",1),"")
		s authorizeLocID = $g(%request.Data("AuthorizeLocID",1),"")	
		s epraction = $g(%request.Data("EPRAction",1),"")
		s appointUserID = $g(%request.Data("AppointUserID",1),"")
		s consultType = $g(%request.Data("ConsultType",1),"")
		s appointType = $g(%request.Data("AppointType",1),"")
		
		w ..AddAuthorize(episodeID,requestCateCharpter,authorizeUserID,authorizeLocID,epraction,appointUserID,consultID,consultType,appointType)
	}
	ElseIf (action="getJson")
	{
		q:(episodeID="")||(patientID="")
		s parentID = $Get(%request.Data("node",1),"-1")
		s consdocID = $g(%request.Data("consdocID",1),"")
		s consLocID = $g(%request.Data("consLocID",1),"")
		
		s consSSGroupID = ssgroupID
		s consSSGroupID = ..GetSSgroupIDByUserID(consdocID)

		d ..GetJson(parentID, episodeID, consdocID, consLocID, consSSGroupID, locID, userID, ssgroupID)
	}
	
	Quit $$$OK
}

Query SelectByUserID(AconsdocID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
  	from SQLUser.SS_User
	where SSUSR_RowId = :AconsdocID and (SSUSR_Active='Y' or SSUSR_Active='Yes')
	order by SSUSR_name
}

/// w ##Class(EMRservice.Ajax.AppointConsultation).GetSSgroupIDByUserID("105")
ClassMethod GetSSgroupIDByUserID(AconsdocID As %String)
{
	s SSGroupID = ""
	&sql(select SSUSR_Group into:SSGroupID
  	from SQLUser.SS_User
	where SSUSR_RowId = :AconsdocID and (SSUSR_Active='Y' or SSUSR_Active='Yes'))
	
	q SSGroupID
}

ClassMethod AddAuthorize(AEpisodeID As %String, ARequestCateCharpter As %String, ARequestUserID As %String, ARequestDept As %String, AEPRAction As %String, AUserID As %String, AConsultID As %String, AConsultType As %String, AAppointType As %String) As %String
{
	s ret = -1
	
	TSTART
	
	s appoint = ##Class(EMRinstance.EMRActionAppoint).%New()
	q:(appoint = "") ret
	
	s appoint.EpisodeID = AEpisodeID
	
	//取当前系统时间
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	s appoint.AppointDate = date
	s appoint.AppointTime = time
	
	//默认为截止日期增加一个月
	s appoint.AppointEndDate = date + 30
	s appoint.AppointEndTime = time
	
	s appoint.RequestCateCharpter = ARequestCateCharpter
	
	//默认批准的打印ID集合与申请的一样
	s appoint.AppointCateCharpter = ARequestCateCharpter
	
	//授权者
	s appoint.AppointUserID = AUserID
	
	//被授权的会诊医生及其所在科室
	s appoint.RequestUserID = ARequestUserID
	s appoint.RequestDept = ARequestDept
	
	//发出申请的日期和时间默认为当前系统日期时间
	s appoint.RequestDate = date
	s appoint.RequestTime = time
	
	//授权给个人或科室
	s appoint.AppointType = AAppointType
	
	//病历权限
	s appoint.EPRAction = AEPRAction
	
	//授权状态
	//s appoint.AppointStatus = "N"   //会诊申请页面开启权限页面，即直接给会诊医生或者会诊科室权限，不需要再去授权，所以此时状态应该是F
	s appoint.AppointStatus = "F"
	
	if '(appoint.%Save())
 	{
	 	s ret = -2
 		TROLLBACK
 	}
 	else
 	{ 
 		s appointID = appoint.%Id()
 		
 		s appointSub = ##Class(EMRinstance.ActionAppointSub).%New()
 		s appointSub.AppointID = appointID
 		s appointSub.ConsultationID = AConsultID
 		s appointSub.ConsultationType = AConsultType
 		
 		if '(appointSub.%Save())
 		{
	 		s ret = -3
	 		TROLLBACK
	 	}
	 	else
	 	{
			TCOMMIT
			s ret = 1		
		}
 	}
	
	q ret
}

/// d ##Class(EMRservice.Ajax.AppointConsultation).GetJson("-1","43","105","6","100")
ClassMethod GetJson(parentID, episodeID, consdocID, consLocID, consSSGroupID, userLoc, userID, workGroupID)
{
	//s ^CaheTempDHCEPRDebug("actionappointchapter","input") = parentID_"^"_episodeID_"^"_userID_"^"_userLoc_"^"_workGroupID
	s type = $E(parentID,1,2)
	s id = $E(parentID,3,$l(parentID))
	
	w "["
	if type = "RT"
	// liuzhongwan 此处应当按照登录用户的权限加载病历树
	//{	d ..GetCategoryJason(episodeID, consdocID, consLocID, consSSGroupID)}
	{	d ..GetCategoryJason(episodeID, userID, userLoc, workGroupID)}
	elseif type = "CG"
	{	d ..GetCateChapterJason(id,episodeID, consdocID, consLocID)}
	
	w "]"
}

/// w ##class(EMRservice.Ajax.AppointConsultation).GetCategoryJason("9","743","9","29")
ClassMethod GetCategoryJason(episodeID, userID, userLoc, workGroupID)
{
	//s parentId = "RT0"
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))	
	//s parentId = " "_parentId
	
	s json = "",count = 0
	q:(userLoc = "") json
	//由于EMRservice.BL.BLClientCategory.cls中改变了GetCategory这个Query，所以跟随改变，获取病历树
	/*
	s disDateTime = ##class(EMRservice.HISInterface.PatientInfoAssist).DisDateTime(episodeID)
	s schemType = $case(disDateTime,"":"Running",:"Archiving")
	q:(schemType = "") json
	*/
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLClientCategory:GetCategory")
	d result.Execute(userLoc,workGroupID,episodeID)
	while result.%Next()
	{
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""id"":""CG"_result.Data("ItemCategoryID")_""""
		s json = json_",""text"":"""_result.Data("ItemTitle")_""""
		s json = json_",cls:'folder'"
		s json = json_",checked:false"
		/*
		s json = json_ ",""attributes"":{" 
		s json = json_ """image"":"""_result.Data("ItemImagePath")_"""" 
		s json = json_ ",""categoryId"":"""_result.Data("ItemCategoryID")_""""
		s json = json_ ",""type"":"""_result.Data("ItemType")_"""" 		
		s json = json_ ",""itemUrl"":"""_result.Data("ItemURL")_"?"_result.Data("ItemParas")_""""
		s json = json_ "}"
		*/
		s json = json_ "}"
		s count = count + 1
	}	
	s json = $ZSTRIP(json,"*C")
	w json
}

/// d ##class(EMRservice.Ajax.AppointConsultation).GetCateChapterJason("CG3","9","743","9","29")
ClassMethod GetCateChapterJason(parentId, episodeID, consdocID, consLocID)
{
	
	//s parentType = $e(parentId,1,2)
	//s parentId = $e(parentId, 3, $l(parentId))
	
	s result = ..GetInstanceJsonByCategoryID(parentId,episodeID, consdocID, consLocID)
	w result
}

/// Desc: 		按CategoryID取实例数据
/// Input: 		AParentId CategoryID
///       		AEpisodeId 就诊号
/// Output:     Json
/// Debug:  	w ##Class(EMRservice.Ajax.AppointConsultation).GetInstanceJsonByCategoryID(3,43)
ClassMethod GetInstanceJsonByCategoryID(AParentId As %String, AEpisodeId As %String, AconsdocID As %String, AconsLocID As %String) As %String
{
	s json = ""
	q:(AEpisodeId = "")||(AParentId = "") json
	s docIds = ..GetDocIdsByParent(AParentId)
	s length = $l(docIds,",")
	
	for I=1:1:length
	{
		s docId = $p(docIds,",",I)
		s docJson = ..DoInstanceJsonByDocID(docId,AEpisodeId,"Save",AconsdocID,AconsLocID)
		s:(json '= "")&&(docJson '= "") json = json_","
		s json = json_docJson
	}
	q json
}

/// Desc:       根据目录展现结构取DocID
/// Input:      AParentId 目录展现结构ID,取所有的为0
///             AEpisodeId 就诊ID
/// OutPut:     以","分隔的DOCID集合         
/// Debug       d ##Class(EMRservice.Ajax.AppointConsultation).GetDocIdsByParent(3)
ClassMethod GetDocIdsByParent(AParentId As %String) As %String
{
	s docIds = ""
	q:(AParentId = "") docIds
	s seq = ""
	for
	{
		s seq = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq))
		q:(seq = "")
		s curCategoryId	= ""
		for
		{
			s curCategoryId = $o(^DHCEMRM.EMRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AParentId,seq,curCategoryId))
			q:(curCategoryId = "")
			s objCatergory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(curCategoryId)
			continue:(objCatergory = "")
			s result = curCategoryId
			if (objCatergory.CategoryType '= "TempCate")
			{
				s result = ..GetDocIdsByParent(curCategoryId)
				q:(result = "")
			}
			s:(docIds '= "") docIds = docIds_","
            s docIds = docIds_result
		}
	}
	q docIds
}

/// Desc:		根据DocId取实例
/// Input: 		AParentId 目录categoryID
/// 			AEpisodeId 就诊号
/// 			AUniqueKey 唯一标示
/// 			OutPut result 1成功，0错误
/// Debug：     w ##Class(EMRservice.Ajax.AppointConsultation).DoInstanceJsonByDocID(100,43,"Save")
ClassMethod DoInstanceJsonByDocID(ADocId As %String, AEpisodeId As %String, AStauts As %String, AconsdocID As %String, AconsLocID As %String) As %String
{
	s $zt = "Error"
	s json = ""
	s count = 0
	q:(ADocId = "")||(AEpisodeId = "")||(AStauts = "") json
	s docId = ADocId
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,docId,""))
	q:(ecrecordId = "") json
	
	s objEcrecod =  ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecod = "") json
	s docId = objEcrecod.RealChartItemID
	s chartItemType = objEcrecod.ChartItemType
	s documentType = objEcrecod.DocumentType
	s objEmrTemplateCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docId)
	q:(objEmrTemplateCategoryDoc = "") json
	s isLeadframe = objEmrTemplateCategoryDoc.IsLeadframe
	s objEmrTemplateCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrTemplateCategoryDoc.ParentCategoryID)
	q:(objEmrTemplateCategoryChapter = "") json
	s isMutex = objEmrTemplateCategoryChapter.IsMutex
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ecrecordId," "_$zcvt(AStauts,"U"),date))
		b
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
 				s tempJson = ..GetInstanceJsonByID(ecrecordId,subId,AEpisodeId,AconsdocID,AconsLocID)
 				continue:(tempJson = "")
 				s:(count '= 0) json = json_","
				s json = json_tempJson
				s count = count + 1			
			}
		}
	}
	s json = $ZSTRIP(json,"*C")
	q json
Error
	q ""
}

/// Desc: 取实例数据JSon
/// Input:     AEcrecordID EMRinstance.ECRecord的ID
///            ASubID EMRinstance.InstanceData的subId
/// Debug:     w ##Class(EMRservice.Ajax.AppointConsultation).GetInstanceJsonByID(1,1)
ClassMethod GetInstanceJsonByID(AEcrecordID As %String, ASubID As %String, AEpisodeId As %String, AconsdocID As %String, AconsLocID As %String) As %String
{
	s json = ""
	q:((AEcrecordID = "")||(ASubID = "")) json
	s rowId = AEcrecordID_"||"_ASubID
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
	q:(objInstance = "") json
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(AEcrecordID)
	q:(objRecord = "") json
	s epsiodeId = objRecord.RealEpisodeID
	s docId = objRecord.RealChartItemID
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
	s happendate = $zd(objInstance.HappenDate,3)
	s happentime = $zt(objInstance.HappenTime)
	s title = objInstance.Title
	s tmeplateId = objInstance.RealTemplateID
	s createdate = $zd(objInstance.CreateDate,3)
	s createtime = $zt(objInstance.CreateTime)
	s createuserID = objInstance.CreateUser
	s createuserCode = $p($g(^SSU("SSUSR",createuserID)),"^",14)
	s createuserName=$p($g(^CTPCP(createuserCode,1)),"^",2)
	//重构所有模板的显示text，以防丢失Title或者用以区分不同的日常病程记录等；
	s text = title_" "_createdate_" "_createtime_" "_createuserName
	/*
	//重构可重复模板的显示text
	if (objRecord.ChartItemType = "Multiple")
	{
		s text = title_" "_createdate_" "_createtime_" "_createuserName
	}
	else
	{
		s text = title
	}
	
	
	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s status = $p(log,"^",2)
	s creator = $tr($p($p($p($p(log,"^",1),"|",2),":",2)," ",1)," ","")
	s notes =  objInstance.Memo //..GetInstanceSummery(rowId,epsiodeId)	
	*/
	//判断被授权人是否已经拥有该病历的浏览权限
	s IsHaveFlag = ..IsHaveAuthorization(rowId,AEpisodeId,AconsdocID,AconsLocID,"view")
	
	/*
	s json = json_"{"
	s json = json_"""id"":""CC"_rowId_""""
	s json = json_",""text"":"""_text_""""
	s json = json_",leaf:'ture'"
	s json = json_",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
	s json = json_",cls:'folder'"
	s json = json_",checked:false"
	s json = json_",hasImage:true"
	s json = json_",""attributes"":{" 
	s json = json_"""chartItemType"":"""_chartItemType_"""" 
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
	s json = json_"}"
	*/
	s Disabled = "false"
	if (IsHaveFlag = 1)
	{
		s text = "<font color=_""""_FF0000_"""">"_text_"  (已有权限)</font>"
		s Disabled = "true"
	} 
	
	s json = json_"{"
	s json = json_"id:'CC"_rowId_"'"
	s json = json_",text:'"_text_"'"
	s json = json_",leaf:'ture'"
	s json = json_",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
	s json = json_",cls:'folder'"
	if (IsHaveFlag '= 1)
	{
		s json = json_",checked:false"
	}
	s json = json_",disabled:"_Disabled
	s json = json_",hasImage:true"
	s json = json_"}"	
	
	q json
}

/// Desc: 取实例数据JSon
/// Input: rowId 实例数据ID，AEpisodeId 就诊指针，AconsdocID 被授权医生ID，AconsLocID被授权科室ID，Aaction 进行判断的操作权限
/// Debug: w ##Class(EMRservice.Ajax.AppointConsultation).IsHaveAuthorization("15||4","52","388","8","view")
ClassMethod IsHaveAuthorization(rowId As %String, AEpisodeId As %String, AconsdocID As %String, AconsLocID As %String, Aaction As %String) As %String
{
	s flag = 0
	s AppointID = ""
	for
	{
		s AppointID = $O(^DHCEMRI.EMRActionAppointI("IdxEpisode"," "_AEpisodeId,AppointID))
		q:(AppointID = "")
		
		//首先判断该条授权是否已过期
		s IsValid = ..CheckAppointIsActive(AppointID)
		continue:(IsValid = 0)
		
		s ObjAppoint = ##Class(EMRinstance.EMRActionAppoint).%OpenId(AppointID)
		
		//判断该条授权中的操作类型
		continue:(ObjAppoint.EPRAction '= Aaction)
		
		if (ObjAppoint.AppointType="0")
		{	
			continue:(ObjAppoint.RequestUserID '= AconsdocID)
		}
		elseif (ObjAppoint.AppointType="1")
		{	
			continue:(ObjAppoint.RequestDept '= AconsLocID)
		}
		else
		{	
			continue
		}
		
		continue:($find("^"_ObjAppoint.AppointCateCharpter_"^","^"_rowId_"^")=0)
		s flag = 1
	}
	q flag
}

/// Input:AID-申请记录RowID
/// Output:
/// Return::1-已授权且授权有效, 0-无授权或者授权已失效
/// Others: w ##Class(EMRservice.Ajax.AppointConsultation).CheckAppointIsActive("1")
ClassMethod CheckAppointIsActive(AID As %String) As %String
{
	s appoint = ##class(EMRinstance.EMRActionAppoint).%OpenId(AID)
	q:(appoint = "") "0"
	
	///授权日期或者授权时间为空,即没有授权
	q:(appoint.AppointDate = "" || appoint.AppointTime = "") "0"
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	///授权截止日期小于当前日期,授权已过期
	q:(appoint.AppointEndDate<date) "0"
	
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(appoint.AppointEndDate=date)&&(appoint.AppointEndTime<time) "0"
	
	q "1"
}

}
