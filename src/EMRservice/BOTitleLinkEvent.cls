/// Desc:       标题与事件关联逻辑类
/// Creator:    yejian
/// CreateDate: 2021-4-9
Class EMRservice.BOTitleLinkEvent Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TitleLinkEventInfo";

/// Desc:       获取事件信息
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      ADocID 目录展现结构ID
ClassMethod GetEventTypes() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitleLinkEvent:GetEventTypes")
	d result.SetArgs()
	q result
}

/// Desc:       根据标题获取关联关系
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      ADocID 目录展现结构ID
ClassMethod GetTitleEventByCode(aTitleCode As %String) As EMRservice.entity.ETitleLinkEvent [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitleLinkEvent).GetTitleEventByCode(aTitleCode)
}

/// Desc:       更新标题和事件关联
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      ADocID 目录展现结构ID
ClassMethod UpdateTitleLinkEvnet(aETitleLEvent As EMRservice.entity.ETitleLinkEvent) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitleLinkEvent).UpdateTitleLinkEvnet(aETitleLEvent)
}

/// Desc:       删除标题和事件关联
/// Creator:    yejian
/// CreateDate: 2021-4-19
/// Input:      aID 关联ID
ClassMethod DeleteTitleLinkEvnet(aID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitleLinkEvent).DeleteTitleLinkEvnet(aID)
}

}
