/// 名称：		EPRservice.B0GlossaryTemplateItemGroup
/// 描述：		二版章节组合BO层
/// 编写者：	yejian
/// 编写时间：	2016-7-6
Class EPRservice.B0GlossaryTemplateItemGroup Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "GlossaryTemItemGroupInfo";

/// w ##Class(EMRservice.BOEMRNavigationSchemeItem).SelectAllItemGroup("12||1")
ClassMethod SelectAllItemGroup() As EPRservice.dataset.EGlossaryTemplateItemGroupDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EGlossaryTemplateItemGroupDataset).%New()
 	d result.SetArgs()
 	q result
}

/// w ##Class(EMRservice.BOEMRNavigationSchemeItem).SelectAllItemGroup("2")
ClassMethod SelectGroupByTemID(aTemID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EPRservice.BLL.BLGlossaryTemplateItemGroup:SelectGroupByTemID")
	d result.SetArgs(aTemID)
	q result
}

/// 增加一个项目
ClassMethod CreateItemGroup(aOrganItemGroup As EPRservice.entity.EGlossaryTemplateItemGroup) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryTemplateItemGroup).CreateItemGroup(aOrganItemGroup)
}

/// 删除一个项目
ClassMethod DeleteItemGroupByID(aItemGroupId As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryTemplateItemGroup).DeleteItemGroupByID(aItemGroupId)
}

/// 更新一个项目
ClassMethod UpdateItemGroup(aOrganItemGroup As EPRservice.entity.EGlossaryTemplateItemGroup) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryTemplateItemGroup).UpdateItemGroup(aOrganItemGroup)
}

/// 更新项目顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryTemplateItemGroup).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod GetMaxSeq(aGroupCode As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryTemplateItemGroup).GetMaxSeq(aGroupCode)
}

}
