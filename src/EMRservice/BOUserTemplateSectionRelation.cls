/// 名称：		EMRservice.BOUserTemplateSectionRelation
/// 描述：		用户模板章节继承关系BO层
/// 编写者：	yejian
/// 编写时间：	2020-3-10
Class EMRservice.BOUserTemplateSectionRelation Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "UserTemSecRelationInfo";

/// 根据科室ID获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplateSection).GetSectionSByTemplateID("1")
ClassMethod GetSectionSByTemplateID(aTemplateID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateSectionRelation:GetSectionSByTemplateID")
	d result.SetArgs(aTemplateID)
	q result
}

/// 根据模板ID获取个人模板
/// Debug: d ##class(EMRservice.BOUserTemplateSection).GetPersonSectionSByTemplateID("1")
ClassMethod GetPersonSectionSByTemplateID(aTemplateID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateSectionRelation:GetPersonSectionSByTemplateID")
	d result.SetArgs(aTemplateID)
	q result
}

/// 根据科室ID获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplateSection).GetSectionSByUserTempCode("1")
ClassMethod GetSectionSByUserTempCode(aCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateSectionRelation:GetSectionSByUserTempCode")
	d result.SetArgs(aCode)
	q result
}

/// 添加用户模板章节
ClassMethod AddUserTemplateSection(AUserTemplateKB As EMRservice.entity.EUserTemplateSectionRelation) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).AddUserTemplateSection(AUserTemplateKB)
}

/// 新增用户模板章节关系根据科室模板编码
ClassMethod AddUserTSectionCodeByUCode(aTemplateID As %String, aUserTemCode As %String, aSectionCodes As %String, AStatus As %String = "REFERENCE") As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).AddUserTSectionCodeByUCode(aTemplateID,aUserTemCode, aSectionCodes, AStatus)
}

/// 发布更新用户模板章节关系根据模板ID（添加新章节，删除删除章节）
ClassMethod SetUserTSectionCodeByTemID(aTemplateID As %String, aSectionCodeNames As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).SetUserTSectionCodeByTemID(aTemplateID, aSectionCodeNames)
}

/// 修改用户模板章节
ClassMethod ModUserTemplateSection(AUserTemplateKB As EMRservice.entity.EUserTemplateSectionRelation) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).ModUserTemplateSection(AUserTemplateKB)
}

/// 把不包含在SectionCodeList章节节点和关系设为不可用
ClassMethod ModUserTemSecStatusByUCode(strUserCode As %String, SectionCodeList As %String, AStatus As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).ModUserTemSecStatusByUCode(strUserCode,SectionCodeList,AStatus)
}

/// Desc:       模板修改批量更新科室模板章节关系信息你
/// Creator:    yejian
/// Createdate: 2019-2-19
/// Input:      aTemplateID 模板ID
///             aSectionKBs 章节知识信息（sectionCode^kbbaseid或""|sectionCode^kbbaseid或""...）
/// Output:     result 1成功,-1失败 
ClassMethod ModUserTSectionStatusByTemID(aTemplateID As %String, aSectionKBs As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).ModUserTSectionStatusByTemID(aTemplateID,aSectionKBs)
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).Delete(RowID)
}

/// 根据模板ID删除
ClassMethod DelUserTSectionCodeByTemID(aTemplateID As %String, aSectionCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateSectionRelation).DelUserTSectionCodeByTemID(aTemplateID,aSectionCode)
}

}
