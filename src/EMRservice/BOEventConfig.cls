/// Desc:       事件助手web服务
/// Creator:    Candy
/// CreateDate: 2015-4-3
Class EMRservice.BOEventConfig Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOEventConfig";

/// Desc:       取事件配置数据web服务
/// Creator:    Candy
/// CreateDate: 2015-4-3
ClassMethod GetEventConfigData() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.Event.BLEventConfig:GetEventConfigData")
	d result.SetArgs()
	q result
}

/// Desc:       取事件类型数据web服务
/// Creator:    Candy
/// CreateDate: 2015-4-3
ClassMethod GetEventType() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.Event.BLEventConfig:GetEventType")
	d result.SetArgs()
	q result
}

/// Desc:        保存配置
/// Creator:     Candy
/// CreateDate:  2015-4-8
/// Input:       AEventType 事件类型
///             ALinkDocID 所写模板的目录展现结构DOCID
///             ALinkTitleCode 所写模板标题
///             ALocation  插入位置
///             APromptMessage 提示内容
///             AScheme  显示及插入格式
/// Output:      result 1成功 0失败
ClassMethod SetEventConfig(AEventType As %String, ALinkDocID As %String, ALinkTitleCode As %String, ALocation As %String, APromptMessage As %String, AScheme As %String) As %String [ WebMethod ]
{
	s:(AEventType = $c(0)) AEventType = ""
	s:(ALinkDocID = $c(0)) ALinkDocID = ""
	s:(ALinkTitleCode = $c(0)) ALinkTitleCode = ""
	s:(ALocation = $c(0)) ALocation = ""
	s:(APromptMessage = $c(0)) APromptMessage = ""
	s:(AScheme = $c(0)) AScheme = ""
	s result = ##Class(EMRservice.BL.Event.BLEventConfig).SetEventConfig(AEventType,ALinkDocID,ALinkTitleCode,ALocation,APromptMessage,AScheme)
	q result
}

}
