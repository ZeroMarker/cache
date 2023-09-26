/// Desc:       权限
/// Creator:    Candy
/// CreateDate: 2014-3-15
Class web.DHCCM.EMRservice.Ajax.privilege Extends %CSP.Page
{

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
		s result = ..GetCreatePrivilege(userid,userloc,ssgroupid,admid,patientid,instanceid,templateId,docid)
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
	s privRule = ##class(web.DHCCM.EMRservice.BL.BLPrivRule).ParsePrivRule(privString,"LoadPrivilege")
	q:(privRule = "") result
	s result = result_"{"
	s result = result_"""canView"":"""_$p($p(privRule,"!",8),"^",2)_""""
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
/// Debug:      w ##class(web.DHCCM.EMRservice.Ajax.privilege).GetBrowsePrivilege(2874,306,29,"","","4||132")
ClassMethod GetBrowsePrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||(AInstanceId = "") result
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId
	s privRule = ##class(web.DHCCM.EMRservice.BL.BLPrivRule).ParsePrivRule(privString,"BrowsePrivilege")
	q:(privRule = "") result
	s result = result_"{"
	s result = result_"""canView"":"""_$p($p(privRule,"!",8),"^",2)_""""
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
/// Debug:      w ##class(EMRservice.Ajax.privilege).GetCreatePrivilege(105,6,100,76,48,"1||1","",616)
ClassMethod GetCreatePrivilege(AUserId As %String, AUserLoc As %String, AssgroupId As %String, AadmId As %String, APatientId As %String, AInstanceId As %String, ATempalteID As %String, ADocID As %String) As %String
{
	s result = ""
	q:(AUserId = "")||(AUserLoc = "")||(AssgroupId = "")||(AadmId = "")||(APatientId = "")||((ATempalteID = "")&&(AInstanceId = ""))||((ADocID = "")&&(AInstanceId = "")) result
	s privString = "userid^"_AUserId_"!userloc^"_AUserLoc_"!ssgroupid^"_AssgroupId_"!admid^"_AadmId_"!patientid^"_APatientId_"!instanceid^"_AInstanceId_"!templateid^"_ATempalteID_"!docid^"_ADocID
	s privRule = ##class(web.DHCCM.EMRservice.BL.BLPrivRule).ParsePrivRule(privString,"CreatePrivilege")
	q:(privRule = "") result
	s result = result_"{"
	s result = result_"""canNew"":"""_$p($p(privRule,"!",9),"^",2)_""""
	s result = result_"}"
	q result
}

}
