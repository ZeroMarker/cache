/// 名称:EMRservice.BOTemplateContrast
/// 名称: 病历模板对比数据项维护BO层
/// 描述: 病历模板对比数据项维护
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRservice.BOTemplateContrast Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateContrastInfo";

/// 根据模板ID和版本获取配置项
/// Debug: d ##class(EMRservice.BOTemplateContrast).GetContrastItem("1","1")
ClassMethod GetContrastItemByTID(aTemplateID As %String, aVersionID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLTemplateContrast:GetContrastItemByTID")
	d result.SetArgs(aTemplateID,aVersionID)
	q result
}

/// 添加数据项
ClassMethod AddContrastItem(AContrastItem As EMRservice.entity.ETemplateContrast) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateContrast).AddContrastItem(AContrastItem)
}

/// 添加数据项(根据版本)
ClassMethod AddContrastItemByVersion(aTemplateID As %String, aOVersion As %String, aNVersion As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EMRservice.BL.BLTemplateContrast).AddContrastItemByVersion(aTemplateID,aOVersion,aNVersion)	
	Quit result
}

/// 获取数据项
ClassMethod GetTemplateContrast(aID As %String) As EMRservice.entity.ETemplateContrast [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateContrast).GetTemplateContrast(aID)
}

/// 修改数据项
ClassMethod ModContrastItem(AContrastItem As EMRservice.entity.ETemplateContrast) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateContrast).ModContrastItem(AContrastItem)
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateContrast).Delete(RowID)
}

}
