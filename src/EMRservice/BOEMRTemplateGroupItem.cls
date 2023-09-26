/// 名称：		EMRservice.BOEMRTemplateGroupItem
/// 描述：		病历分组BO层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.BOEMRTemplateGroupItem Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRTemGroupItemInfo";

/// d ##Class(EMRservice.BOEMRTemplateGroupItem).SelectALL()
ClassMethod SelectALLGroup() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRTemplateGroupItem:SelectALLGroup")
	d result.SetArgs()
	q result
}

/// 增加一个项目
/// w ##Class(EMRservice.BOEMRNavigationSchemeItem).SelectAllDetails("12||1")
ClassMethod SelectAllItem(aTemplateGroupCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRTemplateGroupItem:SelectAllItem")
	d result.SetArgs(aTemplateGroupCode)
	q result
}

/// 增加一个项目
ClassMethod CreateTemplateGroup(aTemplateGroup As EMRservice.entity.EEMRTemplateGroup) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).CreateTemplateGroup(aTemplateGroup)
}

/// 删除一个项目
ClassMethod DeleteTemplateGroupByID(aTemplateGroupId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).DeleteTemplateGroupByID(aTemplateGroupId)
}

/// 更新一个项目
ClassMethod UpdateTemplateGroup(aTemplateGroup As EMRservice.entity.EEMRTemplateGroup) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).UpdateTemplateGroup(aTemplateGroup)
}

/// 更新标题顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod CheckCode(aCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).CheckCode(aCode)
}

/// 增加一个项目
ClassMethod CreateTemplateItem(aTemplateItem As EMRservice.entity.EEMRTemplateItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).CreateTemplateItem(aTemplateItem)
}

/// 删除一个项目
ClassMethod DeleteTemplateItemByID(aTemplateItemId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).DeleteTemplateItemByID(aTemplateItemId)
}

/// 更新一个项目
ClassMethod UpdateTemplateItem(aTemplateItem As EMRservice.entity.EEMRTemplateItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).UpdateTemplateItem(aTemplateItem)
}

/// 更新标题顺序
ClassMethod UpdateTemplateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRTemplateGroupItem).UpdateTemplateSequences(argStr)
}

}
