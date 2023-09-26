/// 名称: EPRservice.BOGlossaryClassProperty
/// 描述: 术语扩展BO层
/// 编写者：叶剑
/// 编写日期: 2016-11-24
Class EPRservice.BOGlossaryClassProperty Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "GlossaryClassPropertyInfo";

/// w ##Class(EPRservice.BOGlossaryClassProperty).SelectAllClassProperty("12||1")
ClassMethod SelectAllClassProperty() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EPRservice.BLL.BLGlossaryClassProperty:SelectAllClassProperty")
	d result.SetArgs()
	q result
}

/// w ##Class(EPRservice.BOGlossaryClassProperty).SelectAllItemGroup("2")
ClassMethod SelectClassPropertyID(aID As %String) As EPRservice.entity.EGlossaryClassProperty [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryClassProperty).SelectClassPropertyID(aID)
}

/// 增加一个项目
ClassMethod CreateClassProperty(aOrganItemGroup As EPRservice.entity.EGlossaryClassProperty) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryClassProperty).CreateClassProperty(aOrganItemGroup)
}

/// 删除一个项目
ClassMethod DeletClassPropertyByID(aItemGroupId As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryClassProperty).DeletClassPropertyByID(aItemGroupId)
}

/// 更新一个项目
ClassMethod UpdateClassProperty(aOrganItemGroup As EPRservice.entity.EGlossaryClassProperty) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryClassProperty).UpdateClassProperty(aOrganItemGroup)
}

/// 更新项目顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryClassProperty).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod GetMaxSeq(aGroupCode As %String) As %String [ WebMethod ]
{
	q ##Class(EPRservice.BLL.BLGlossaryClassProperty).GetMaxSeq(aGroupCode)
}

}
