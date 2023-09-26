///  名称：		EMRservice.BOUserTemplate
///  描述：		用户模板BO层
///  编写者：	yejian
///  编写时间：	2017-11-9
Class EMRservice.BOUserTemplate Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "UserTemplateInfo";

/// 获取该模板下用户模板
/// Debug: ##class(EMRservice.BOUserTemplate).GetAllLoc()
ClassMethod GetAllLoc() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLHospitals:SelectAllLoc")

	d result.SetArgs()
	Quit result
}

/// 获取所有用户模板
/// Debug: d ##class(EMRservice.BOUserTemplate).GetAllUserTemplate()
ClassMethod GetAllUserTemplate(aCTLocName As %String = "") As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplate:GetAllUserTemplate")
	d result.SetArgs(aCTLocName)
	q result
}

/// 根据Code获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplate).GetUserTemplateJson("6","58","")
ClassMethod GetUserTemplateJson(pLocID As %String, pDocID As %String, pEpisodeID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplate")
	d result.SetArgs(pLocID,pDocID,pEpisodeID)
	q result
}

/// 根据科室ID获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplate).GetUserTemplateByTemID("1")
ClassMethod GetUserTemplateByTemID(aTemID As %String, aCTLocName As %String = "") As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplateByTemID")
	d result.SetArgs(aTemID,aCTLocName)
	q result
}

/// 根据ID获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplate).GetUserTemplateByID(1)
ClassMethod GetUserTemplateByID(AID As %String) As EMRservice.entity.EUserTemplate [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByID(AID)
}

/// 根据Code获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplate).GetUserTemplateByCode("1")
ClassMethod GetUserTemplateByCode(ACode As %String) As EMRservice.entity.EUserTemplate [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).GetUserTemplateByCode(ACode)
}

/// 检查用户模板
ClassMethod CheckUserTemplate(Code As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).CheckUserTemplate(Code)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).GetMaxCode()
}

/// 添加用户模板
ClassMethod AddUserTemplate(AUserTemplate As EMRservice.entity.EUserTemplate, aCTLocID As %String, aCTLocName As %String, aTitleCode As %String, aTitleName As %String, aDiagnosCode As %String, aDiagnosName As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).AddUserTemplate(AUserTemplate,aCTLocID,aCTLocName,aTitleCode,aTitleName,aDiagnosCode,aDiagnosName)
}

/// 修改用户模板
ClassMethod ModUserTemplate(AUserTemplate As EMRservice.entity.EUserTemplate, aUserTemLoc As EMRservice.entity.EUserTemplateCTLoc, aUserTemTitle As EMRservice.entity.EUserTemplateTitle, aUserTemDisease As EMRservice.entity.EUserTemplateDisease) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).ModUserTemplate(AUserTemplate,aUserTemLoc,aUserTemTitle,aUserTemDisease)
}

///  creator:yejian
///  CreatDate:2016-8-9
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BOUserTemplate).SwapSequence("1","2")
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).UpdateSequences(argStr)
}

/// 修改用户模板状态
ClassMethod ModUserTemplateStatus(AUserTemIDS As %String, Atatus As %String, aAuditID As %String, Remark As %String = "") As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).ModUserTemplateStatus(AUserTemIDS,Atatus,aAuditID,Remark)
}

/// yejian by 2019-7-29
/// 修改用户模板状态(逻辑删除调用)
ClassMethod ModUserTemplateStatusNew(AUserTemIDS As %String, AUserTemplate As EMRservice.entity.EUserTemplate) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).ModUserTemplateStatusNew(AUserTemIDS,AUserTemplate)
}

/// 根据科室ID获取用户模板
/// 用户模板科室/// /// /// 
ClassMethod GetUserTemplateByCtLocIDOrCode(ACtLocID As %String, aGroupCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplateByCtLocIDOrCode")
	d result.SetArgs(ACtLocID,aGroupCode)
	q result
}

/// 检查用户模板诊断
ClassMethod CheckUserTemplateCTLocCode(GroupCode As %String, CTLocID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).CheckUserTemplateCTLocCode(GroupCode,CTLocID)
}

/// 添加用户模板科室关联
ClassMethod AddUserTemplateCTLoc(UserTemplateDisease As EMRservice.entity.EUserTemplateCTLoc) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).AddUserTemplateCTLoc(UserTemplateDisease)
}

/// 删除用户模板诊断
ClassMethod DelUserTemplateCTLoc(AID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).DelUserTemplateCTLoc(AID)
}

/// 根据用户模板ID获取用户模板关联
/// 用户模板诊断/// /// /// /
ClassMethod GetUserTemplateByICDIDOrUserTemplateCode(aUserTemplateCode As %String, aICDID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplate:GetUserTemplateByICDIDOrUserTemplateCode")
	d result.SetArgs(aUserTemplateCode,aICDID)
	q result
}

/// 检查用户模板诊断
ClassMethod CheckUserTemplateDiseaseCode(UserTemplateCode As %String, ICDCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).CheckUserTemplateDiseaseCode(UserTemplateCode,ICDCode)
}

/// 添加用户模板诊断
ClassMethod AddUserTemplateDisease(UserTemplateDisease As EMRservice.entity.EUserTemplateDisease) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).AddUserTemplateDisease(UserTemplateDisease)
}

/// 删除用户模板诊断
ClassMethod DelUserTemplateDisease(AID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplate).DelUserTemplateDisease(AID)
}

/// 删除用户模板诊断
/// debug  w ##Class(EMRservice.BOUserTemplate).TestGetDiseasesList("112","6")
ClassMethod TestGetDiseasesList(AEpisodeID As %String, ACtLocID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiseases).GetDiseasesList(AEpisodeID,ACtLocID)
}

/// 获取模板标题信息
ClassMethod SelectALLTitleS(AtemplateID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplate:SELECTALLTITLES")
	d result.SetArgs(AtemplateID)
	q result
}

ClassMethod Test()
{
    s obj = ##class(EMRservice.entity.EUserTemplate).%New()
	s obj.CTLocID="106"
	s obj.Description="1"
	s obj.ID="91"
	s obj.UserTemplate="aaa"
	s obj.GroupName="sdfsdaf"
	s obj.Name="sdfsdaf"
	s obj.GroupDescription="sdfsdaf"
	
	s objre = ##class(EMRservice.entity.EUserTemplateDisease).%New()
	;w ..ModKBUserTemplate(obj,objre)
	q 1
}

}
