/// 名称：		EMRservice.BOUserTemplateSection
/// 描述：		用户模板章节关联章节BO层
/// 编写者：	yejian
/// 编写时间：	2017-11-9
Class EMRservice.BOUserTemplateSection Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "UserTemSectionInfo";

/// 根据科室ID获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplateSection).GetSectionSByUserTempCode("1")
ClassMethod GetSectionSByUserTempCode(aCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateSection:GetSectionSByUserTempCode")
	d result.SetArgs(aCode)
	q result
}

/// 添加用户模板章节
ClassMethod AddUserTemplateSection(AUserTemplateKB As EMRservice.entity.EUserTemplateSection) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSection).AddUserTemplateSection(AUserTemplateKB)
}

/// 修改用户模板章节
ClassMethod ModUserTemplateSection(AUserTemplateKB As EMRservice.entity.EUserTemplateSection) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSection).ModUserTemplateSection(AUserTemplateKB)
}

/// 把不包含在SectionCodeList章节节点和关系设为不可用
ClassMethod SetUserTemSecStatus(strUserTemID As %String, SectionCodeList As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSection).SetUserTemSecStatus(strUserTemID,SectionCodeList)
}

/// 删除章节模板数据
ClassMethod DelUserTemSecStatus(strUserTemCode As %String, SectionCodeList As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSection).DelUserTemSecStatus(strUserTemCode,SectionCodeList)
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSection).Delete(RowID)
}

/// 清理临时global
ClassMethod ClearUserTemKBGlobal(aUserTemID As %String, aUserTKey As %String) [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSection).ClearUserTemKBGlobal(aUserTemID,aUserTKey)
}

/// Desc:       模板修改批量更新科室模板章节关系信息你
/// Creator:    yejian
/// Createdate: 2019-2-19
/// Input:      aTemplateID 模板ID
///             aSectionKBs 章节知识信息（sectionCode^kbbaseid或""|sectionCode^kbbaseid或""...）
/// Output:     result 1成功,-1失败 
ClassMethod UpdateUserTSectionByTemID(aTemplateID As %String, aSectionKBs As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSection).UpdateUserTSectionByTemID(aTemplateID,aSectionKBs)
}

}
