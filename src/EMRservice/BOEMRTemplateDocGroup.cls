///  名称：		EMRservice.BOEMRTemplateDocGroup
///  描述：		病历模板分组BO层
///  编写者：	yejian
///  编写时间：	2018-3-22
Class EMRservice.BOEMRTemplateDocGroup Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "EMRTemplateGroupInfo";

/// 获取病历模板分组
/// Debug: d ##class(EMRservice.BOEMRTemplateGroup).GetEMRTemplateGroup("50")
ClassMethod GetEMRTemplateGroup(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRTemplateDocGroup:GetEMRTemplateGroup")
	d result.SetArgs(ACtLocID)
	q result
}

/// 获取病历模板分组明细
/// Debug: d ##class(EMRservice.BOEMRTemplateGroup).GetEMRTemplateGroupItem("50")
ClassMethod GetEMRTemplateGroupItem(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRTemplateDocGroup:GetEMRTemplateGroupItem")
	d result.SetArgs(ACtLocID)
	q result
}

/// 得到最大code编号
/// w ##class(EMRservice.BOEMRTemplateGroup).GetMaxID()
ClassMethod GetMaxID() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetMaxID()
}

/// 根据ID获取病历模板
ClassMethod GetEMRTemplateGroupByID(ARowID As %String) As EMRservice.entity.EEMRTemplateDocGroup [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetEMRTemplateGroupByID(ARowID)
}

/// 检查病历模板分组
ClassMethod CheckEMRTemplateGroup(GroupCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).CheckEMRTemplateGroup(GroupCode)
}

/// 添加病历模板分组
ClassMethod AddEMRTemplateGroup(AEMRTemplateC As EMRservice.entity.EEMRTemplateDocGroup) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).AddEMRTemplateGroup(AEMRTemplateC)
}

/// 修改病历模板分组
ClassMethod ModEMRTemplateGroup(AEMRTemplateC As EMRservice.entity.EEMRTemplateDocGroup) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).ModEMRTemplateGroup(AEMRTemplateC)
}

/// 根据ID获取病历模板分组子项
ClassMethod GetEMRTemplateGroupItemByCode(AGroupID As %String, ADocID As %String) As EMRservice.entity.EEMRTemplateDocGroupItem [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).GetEMRTemplateGroupItemByCode(AGroupID,ADocID)
}

/// 修改病历模板分组
/// debug d ##Class(EMRservice.BOEMRTemplateGroup).UpEMRTemplateGroupItem("m05","0","56")
ClassMethod UpEMRTemplateGroupItem(aEMRTemplateCode As %String, oldGroupID As %String, newGroupID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).UpEMRTemplateGroupItem(aEMRTemplateCode,oldGroupID,newGroupID)
}

///  creator:yejian
///  CreatDate:2018-3-22
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BOEMRTemplateGroup).SwapSequence("1","2")
ClassMethod SwapEMRTemplateCatSeq(EMRTemplateCID1 As %String, EMRTemplateCID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).SwapEMRTemplateCatSeq(EMRTemplateCID1,EMRTemplateCID2)
}

///  creator:yejian
///  CreatDate:2018-3-22
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BOEMRTemplateGroup).SwapSequence("1","2")
ClassMethod SwapEMRTemplateItemSeq(EMRTemplateCID1 As %String, EMRTemplateCID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).SwapEMRTemplateItemSeq(EMRTemplateCID1,EMRTemplateCID2)
}

/// 删除病历模板分组
ClassMethod DelEMRTemplateGroup(AEMRTemplateCID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateDocGroup).DelEMRTemplateGroup(AEMRTemplateCID)
}

}
