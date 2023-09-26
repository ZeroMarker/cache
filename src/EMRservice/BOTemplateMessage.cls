/// 名称:EMRservice.BOTemplateMessage
/// 描述:模板消息提示维护BO
/// 编写者：yejian
/// 编写日期: 2019-9-9
Class EMRservice.BOTemplateMessage Extends %SOAP.WebService
{

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemMessageInfo";

/// 查询
/// Debug: w ##class(EMRservice.BOTemplateMessage).SelectAll()
ClassMethod SelectAll() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLTemplateMessage:SelectAll")
	d result.SetArgs()
	q result
}

/// 根据模板ID获取模板消息
ClassMethod GetTemMessageByID(aTemID As %String) As EMRservice.entity.ETemplateMessage [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateMessage).GetTemMessageByID(aTemID)
}

/// 更新
/// Debug: d ##class(EMRservice.BOTemplateMessage).UpdateData(aTemMessage)
ClassMethod UpdateData(aTemMessage As EMRservice.entity.ETemplateMessage) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateMessage).UpdateData(aTemMessage)
}

/// 增加
/// Debug: d ##class(EMRservice.BOTemplateMessage).AddData(aTemMessage)
ClassMethod AddData(aTemMessage As EMRservice.entity.ETemplateMessage) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateMessage).AddData(aTemMessage)
}

/// 删除
/// Debug: d ##class(EMRservice.BOTemplateMessage).DeleteData("1")
ClassMethod DeleteData(rowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateMessage).DeleteData(rowID)
}

}
