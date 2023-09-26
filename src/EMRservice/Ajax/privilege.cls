/// Desc:       权限
/// Creator:    Candy
/// CreateDate: 2014-3-15
Class EMRservice.Ajax.privilege Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	//权限
	s userid = %session.Get("LOGON.USERID")
	s userloc = %session.Get("LOGON.CTLOCID")
	s ssgroupid = %session.Get("LOGON.GROUPID")
	s admid = $Get(%request.Data("EpisodeID",1),"")
	s patientid = $Get(%request.Data("PatientID",1),"")
	s instanceid = $Get(%request.Data("InstanceID",1),"")
	s docid = $Get(%request.Data("DocID",1),"")
	s templateId = $Get(%request.Data("TemplateID",1),"")
	s type = $Get(%request.Data("Type",1),"")	
	s titleName = $Get(%request.Data("TitleName",1),"")
	s titleCode = $Get(%request.Data("TitleCode",1),"")
	s createDateTime = $Get(%request.Data("CreateDateTime",1),"")
	
	if (type = "LoadPrivilege")
	{
		s result = ..GetLoadPrivilege(userid,userloc,ssgroupid,admid,patientid,instanceid)
	}
	elseif (type = "BrowsePrivilege")
	{
		s result = ..GetBrowsePrivilege(userid,userloc,ssgroupid,admid,patientid,instanceid)
	}
	elseif (type = "CreatePrivilege")
	{
		s result = ..GetCreatePrivilege(userid,userloc,ssgroupid,admid,patientid,instanceid,templateId,docid,titleName,titleCode,createDateTime)
	}
	elseif (type = "ActionPrivilege")
	{
		s result = ..GetActionPrivilege(userid,userloc,ssgroupid,admid,patientid,instanceid,templateId,docid)
	}
	elseif (type = "ToolbarPrivilege")
	{
		s result = ..GetToolbarPrivilege(userid,userloc,ssgroupid,admid,patientid,instanceid,templateId,docid)
	}
	elseif (type = "AuthPrivilege")
	{
		s requestCateCharpter = $Get(%request.Data("RequestCateCharpter",1),"")
		s actionString = $Get(%request.Data("ActionString",1),"")
		s result = ..GetAuthPrivilege(userid,userloc,ssgroupid,admid,patientid,requestCateCharpter,actionString)
	}
	w result
	Quit $$$OK
}

/// Desc:       加载病历操作操作权限
/// Creator:    Candy
/// Createdate: 2015-3-9
/// Input:      AUserId 用户ID
///             AUserLoc 用户科室
///             AssgroupId 用户安全组
///             AadmId 就诊号
///             APatientId 病人id
///             AInstanceId 病历实例ID
///             AType 脚本类型
/// OutPut:      result json
/// debug:      w ##class(EMRservice.Ajax.privilege).GetLoadPrivilege(105,6,100,76,48,"1||1")
ClassMethod GetLoadPrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||(AInstanceId = "") result
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId
	s privRule = ##class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"LoadPrivilege")
	q:(privRule = "") result
	s canView = $p(privRule.GetAt("view"),"|",1)
	s cantViewReason = $p(privRule.GetAt("view"),"|",2)
	s result = result_"{"
	s result = result_"""canView"":"""_canView_""""
	s result = result_",""cantViewReason"":"""_cantViewReason_""""
	s result = result_"}"
	q result
}

/// Desc:       病历浏览操作权限
/// Creator:    Candy
/// Createdate: 2015-3-10
/// Input:      AUserId 用户ID
///             AUserLoc 用户科室
///             AssgroupId 用户安全组
///             AadmId 就诊号
///             APatientId 病人id
///             AInstanceId 病历实例ID
///             AType 脚本类型
/// OutPut:     result json
/// Debug:      w ##class(EMRservice.Ajax.privilege).GetBrowsePrivilege(105,6,100,76,48,"1||1")
ClassMethod GetBrowsePrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||(AInstanceId = "") result
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId
	s privRule = ##class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"BrowsePrivilege")
	q:(privRule = "") result
	s canView = $p(privRule.GetAt("view"),"|",1)
	s cantViewReason = $p(privRule.GetAt("view"),"|",2)
	s result = result_"{"
	s result = result_"""canView"":"""_canView_""""
	s result = result_",""cantViewReason"":"""_cantViewReason_""""
	s result = result_"}"
	q result
}

/// Desc:       创建病历操作权限
/// Creator:    Candy
/// Createdate: 2015-3-10
/// Input:      AUserId 用户ID
///             AUserLoc 用户科室
///             AssgroupId 用户安全组
///             AadmId 就诊号
///             APatientId 病人id
///             AInstanceId 病历实例ID
///             ATemplateID 模板ID
///             ADocID  目录展现结构DOCID
/// OutPut:     result json
/// Debug:      w ##class(EMRservice.Ajax.privilege).GetCreatePrivilege(105,6,100,76,48,"3||2",20,56)
ClassMethod GetCreatePrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String, ATempalteID As %String, ADocID As %String, ATitleName As %String, ATitleCode As %String, ACreateDateTime As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||((ATempalteID = "")&&(AInstanceId = ""))||((ADocID = "")&&(AInstanceId = "")) result
	//如果是连续性重复模板，获取的模板ID是挂靠的第一个模板ID,根据DOCID和模板名称获取挂靠的模板ID
	if ((ATitleName'="")&&(ADocID'=""))
	{
		s objEmrTemplate = ##class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
		if (objEmrTemplate'="")&&(objEmrTemplate.IsLeadframe="1")
		{
			s emrTemRowID = ""
			for {
				s emrTemRowID=$o(^DHCEMRM.EMRTemplateI("IdxCategoryID"," "_ADocID,emrTemRowID))
				q:(emrTemRowID="")
				s objEmrTemplate = ##class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
				if (objEmrTemplate.TemplateName =ATitleName)
				{
					s ATempalteID = objEmrTemplate.BindTemplateID
					q
				}
			}
		}
	}
	s currentDataTime = $H
	s:(ACreateDateTime = "") ACreateDateTime = $zd($P(currentDataTime,",",1),3)_" "_$zt($P(currentDataTime,",",2),1)
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^!templateid^"_ATempalteID_"!docid^"_ADocID_"!titlename^"_ATitleName_"!titleCode^"_ATitleCode_"!createDateTime^"_ACreateDateTime

	s privRule = ##class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"CreatePrivilege")
	q:(privRule = "") result
	s canNew = $p(privRule.GetAt("new"),"|",1)
	s cantNewReason = $p(privRule.GetAt("new"),"|",2)
	s result = result_"{"
	s result = result_"""canNew"":"""_canNew_""""
	s result = result_",""cantNewReason"":"""_cantNewReason_""""
	s result = result_"}"
	q result
}

/// Desc:       获取病历操作权限ActionPrivilege
/// Creator:    Donglulu
/// Createdate: 2016-12-19
/// Input:      AUserId 用户ID
///             AUserLoc 用户科室
///             AssgroupId 用户安全组
///             AadmId 就诊号
///             APatientId 病人id
///             AInstanceId 病历实例ID
///             ATemplateID 模板ID
///             ADocID  目录展现结构DOCID
/// OutPut:     result json
/// Debug:      w ##class(EMRservice.Ajax.privilege).GetActionPrivilege(359,6,29,230,170,"1||1","",616)
ClassMethod GetActionPrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String, ATempalteID As %String, ADocID As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||((ATempalteID = "")&&(AInstanceId = ""))||((ADocID = "")&&(AInstanceId = "")) result
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId_"!templateid^"_ATempalteID_"!docid^"_ADocID
	s privRule = ##class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"ActionPrivilege")
	q:(privRule = "") result
	s canSave = $p(privRule.GetAt("save"),"|",1)
	s cantSaveReason = $p(privRule.GetAt("save"),"|",2)
	s canPrint = $p(privRule.GetAt("print"),"|",1)
	s cantPrintReason = $p(privRule.GetAt("print"),"|",2)
	s canDelete = $p(privRule.GetAt("delete"),"|",1)
	s cantDeleteReason = $p(privRule.GetAt("delete"),"|",2)
	s canCheck = $p(privRule.GetAt("check"),"|",1)
	s cantCheckReason = $p(privRule.GetAt("check"),"|",2)
	s canReCheck = $p(privRule.GetAt("recheck"),"|",1)
	s cantReCheckReason = $p(privRule.GetAt("recheck"),"|",2)
	s canRevokCheck = $p(privRule.GetAt("revokcheck"),"|",1)
	s cantRevokCheckReason = $p(privRule.GetAt("revokcheck"),"|",2)
    s canPatCheck = $p(privRule.GetAt("patcheck"),"|",1)
	s cantPatCheckReason = $p(privRule.GetAt("patcheck"),"|",2)
    s canPatReCheck = $p(privRule.GetAt("patrecheck"),"|",1)
	s cantPatReCheckReason = $p(privRule.GetAt("patrecheck"),"|",2)
	s canReference = $p(privRule.GetAt("reference"),"|",1)
	s cantReferenceReason = $p(privRule.GetAt("reference"),"|",2)
	s canExport = $p(privRule.GetAt("export"),"|",1)
	s cantExportReason = $p(privRule.GetAt("export"),"|",2)
	s canCopyPaste = $p(privRule.GetAt("copypaste"),"|",1)
	s cantCopyPasteReason = $p(privRule.GetAt("copypaste"),"|",2)
	s canRevise = $p(privRule.GetAt("revise"),"|",1)
	s cantReviseReason = $p(privRule.GetAt("revise"),"|",2)
	s canViewRevise = $p(privRule.GetAt("viewrevise"),"|",1)
	s cantViewReviseReason = $p(privRule.GetAt("viewrevise"),"|",2)
	s canApplyEdit = $p(privRule.GetAt("applyedit"),"|",1)
	s cantApplyEditReason = $p(privRule.GetAt("applyedit"),"|",2)
	s canUnLock = $p(privRule.GetAt("unlock"),"|",1)
	s cantUnLockReason = $p(privRule.GetAt("unlock"),"|",2)
    s canAutoApply = $p(privRule.GetAt("autoapply"),"|",1)
	s cantAutoApplyReason = $p(privRule.GetAt("autoapply"),"|",2)
	s result = result_"{"
	s result = result_"""canSave"":"""_canSave_""""
	s result = result_",""cantSaveReason"":"""_cantSaveReason_""""
	s result = result_",""canPrint"":"""_canPrint_""""
	s result = result_",""cantPrintReason"":"""_cantPrintReason_""""
	s result = result_",""canDelete"":"""_canDelete_""""
	s result = result_",""cantDeleteReason"":"""_cantDeleteReason_""""
	s result = result_",""canCheck"":"""_canCheck_""""
	s result = result_",""cantCheckReason"":"""_cantCheckReason_""""
	s result = result_",""canReCheck"":"""_canReCheck_""""
	s result = result_",""cantReCheckReason"":"""_cantReCheckReason_""""
	s result = result_",""canRevokCheck"":"""_canRevokCheck_""""
	s result = result_",""cantRevokCheckReason"":"""_cantRevokCheckReason_""""
    s result = result_",""canPatCheck"":"""_canPatCheck_""""
	s result = result_",""cantPatCheckReason"":"""_cantPatCheckReason_""""
    s result = result_",""canPatReCheck"":"""_canPatReCheck_""""
	s result = result_",""cantPatReCheckReason"":"""_cantPatReCheckReason_""""
	s result = result_",""canReference"":"""_canReference_""""
	s result = result_",""cantReferenceReason"":"""_cantReferenceReason_""""
	s result = result_",""canExport"":"""_canExport_""""
	s result = result_",""cantExportReason"":"""_cantExportReason_""""
	s result = result_",""canCopyPaste"":"""_canCopyPaste_""""
	s result = result_",""cantCopyPasteReason"":"""_cantCopyPasteReason_""""
	s result = result_",""canRevise"":"""_canRevise_""""
	s result = result_",""cantReviseReason"":"""_cantReviseReason_""""
	s result = result_",""canViewRevise"":"""_canViewRevise_""""
	s result = result_",""cantViewReviseReason"":"""_cantViewReviseReason_""""
	s result = result_",""canApplyEdit"":"""_canApplyEdit_""""
	s result = result_",""cantApplyEditReason"":"""_cantApplyEditReason_""""
	s result = result_",""canUnLock"":"""_canUnLock_""""
	s result = result_",""cantUnLockReason"":"""_cantUnLockReason_""""
    s result = result_",""canAutoApply"":"""_canAutoApply_""""
	s result = result_",""cantAutoApplyReason"":"""_cantAutoApplyReason_""""
	s result = result_"}"
	q result
}

/// Desc:       获取工具栏操作权限ToolbarPrivilege
/// Creator:    Donglulu
/// Createdate: 2017-3-23
/// Input:      AUserId 用户ID
///             AUserLoc 用户科室
///             AssgroupId 用户安全组
///             AadmId 就诊号
///             APatientId 病人id
///             AInstanceId 病历实例ID
///             ATemplateID 模板ID
///             ADocID  目录展现结构DOCID
/// OutPut:     result json
/// Debug:      w ##class(EMRservice.Ajax.privilege).GetToolbarPrivilege(359,6,29,230,170,"1||1","",616)
ClassMethod GetToolbarPrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String, ATempalteID As %String, ADocID As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "") result
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId_"!templateid^"_ATempalteID_"!docid^"_ADocID
	s privRule = ##class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"ToolbarPrivilege")
	q:(privRule = "") result
	s canCommit = $p(privRule.GetAt("commit"),"|",1)
	s cantCommitReason = $p(privRule.GetAt("commit"),"|",2)
	s canTransfer = $p(privRule.GetAt("transfer"),"|",1)
	s cantTransferReason = $p(privRule.GetAt("transfer"),"|",2)
	s result = result_"{"
	s result = result_"""canCommit"":"""_canCommit_""""
	s result = result_",""cantCommitReason"":"""_cantCommitReason_""""
	s result = result_",""canTransfer"":"""_canTransfer_""""
	s result = result_",""cantTransferReason"":"""_cantTransferReason_""""
	s result = result_"}"
	q result
}

/// Desc:       门诊历史病历引用权限
/// Creator:    
/// Createdate: 2019-3-27
/// Input:      AUserId 用户ID
///             AUserLoc 用户科室
///             AssgroupId 用户安全组
///             AadmId 就诊号
///             APatientId 病人id
///             AInstanceId 打开的历史病历实例ID
/// OutPut:     result json
/// Debug:      w ##class(EMRservice.Ajax.privilege).GetQuotePrivilege(105,6,100,76,48,"3||2")
ClassMethod GetQuotePrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||(AInstanceId = "") result
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId
	s privRule = ##class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"ActionPrivilege")
	q:(privRule = "") result
	s canquote = $p(privRule.GetAt("quote"),"|",1)
	s cantquoteReason = $p(privRule.GetAt("quote"),"|",2)
	s result = result_"{"
	s result = result_"""canquote"":"""_canquote_""""
	s result = result_",""cantquoteReason"":"""_cantquoteReason_""""
	s result = result_"}"
	q result
}

/// Desc:       获取申请权限权限AuthPrivilege
/// Creator:    Donglulu
/// Createdate: 2016-12-19
/// Input:      AUserId 用户ID
///             AUserLoc 用户科室
///             AssgroupId 用户安全组
///             AadmId 就诊号
///             APatientId 病人id
///             ARequestCateCharpter 申请的instanceID和docid
///             AActionString 申请的动作
/// OutPut:     result json
/// Debug:      w ##class(EMRservice.Ajax.privilege).GetAuthPrivilege(359,6,29,230,170,"1||1","",616)
ClassMethod GetAuthPrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, ARequestCateCharpter As %String, AActionString As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||(ARequestCateCharpter = "")||(AActionString = "") result
	
	s cateCharpter = $p(ARequestCateCharpter, "^", 1)
    q:(cateCharpter = "")
    s cateCharpterCount=$l(ARequestCateCharpter, "^")
	f i=1:1:cateCharpterCount 
	{
		s cateCharpter = $p(ARequestCateCharpter, "^", i)
		q:(cateCharpter = "")
		
		s name = ""
		
		if (cateCharpter [ "||")
		{
			s AInstanceId = cateCharpter
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
			q:(objInstance = "")
			s ADocID = objInstance.TheECRecord.RealChartItemID
			s ATempalteID = objInstance.RealTemplateID
			s name = objInstance.Title
		}
		else
		{
			s AInstanceId = ""
			s ADocID = cateCharpter
			s ATempalteID = $o(^DHCEMRM.EMRTemplateI("IdxCategoryTemplate"," "_ADocID,""))
			s objDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(ADocID)
			q:(objDoc = "")
			s name = objDoc.CategoryName
		}
		
		s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId_"!templateid^"_ATempalteID_"!docid^"_ADocID
		s privRule = ##class(EMRservice.BL.BLPrivRule).GetPrivRuleByType(privString,"AuthPrivilege")
		q:(privRule = "")
		
		s save = "0"
		
		if (AActionString [ "new")
		{
			if (cateCharpter [ "||")
			{
				s new = "1"
			}
			else
			{
				s new = privRule.GetAt("new")
				s:((new '= "")&&(new '= "1")) result = result_name_"不能申请新建权限 "_$p(privRule.GetAt("new"),"|",2)_"\n"
				//可以申请创建的权限，则可以申请保存的权限
				s:(new = "1") save = "1"
			}
		}
		
		if (AActionString [ "save")
		{
			if (save '= "1")
			{
				s save = privRule.GetAt("save")
				s:((save '= "")&&(save '= "1")) result = result_name_"不能申请保存权限 "_$p(privRule.GetAt("save"),"|",2)_"\n"
			}
		}
		
		if (AActionString [ "view")
		{
			s view = privRule.GetAt("view")
			s:((view '= "")&&(view '= "1")) result = result_name_"不能申请浏览权限 "_$p(privRule.GetAt("view"),"|",2)_"\n"
		}
		
		if (AActionString [ "print")
		{
			s print = privRule.GetAt("print")
			s:((print '= "")&&(print '= "1")) result = result_name_"不能申请打印权限 "_$p(privRule.GetAt("print"),"|",2)_"\n"
		}
		
		if (AActionString [ "delete")
		{
			s delete = privRule.GetAt("delete")
			s:((delete '= "")&&(delete '= "1")) result = result_name_"不能申请删除权限 "_$p(privRule.GetAt("delete"),"|",2)_"\n"
		}
		
		if (AActionString [ "export")
		{
			s export = privRule.GetAt("export")
			s:((export '= "")&&(export '= "1")) result = result_name_"不能申请导出文档权限 "_$p(privRule.GetAt("export"),"|",2)_"\n"
		}
		
		if (AActionString [ "copypaste")
		{
			s copypaste = privRule.GetAt("copypaste")
			s:((copypaste '= "")&&(copypaste '= "1")) result = result_name_"不能申请复制粘贴文档权限 "_$p(privRule.GetAt("copypaste"),"|",2)_"\n"
		}
	}
	
	q result
}

}
