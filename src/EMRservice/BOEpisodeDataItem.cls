/// 名称:EMRservice.BOEpisodeDataItem
/// 描述:就诊数据项BO
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.BOEpisodeDataItem Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "EpisodeDataItemInfo";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// TODO: add arguments and implementation.
/// 
ClassMethod CreateEpisodeDataItem(AEEpisodeDataItem As EMRservice.entity.EEpisodeDataItem) As %String [ WebMethod ]
{
 q ##class(EMRservice.BL.BLEpisodeDataItem).CreateEpisodeDataItem(AEEpisodeDataItem)
}

ClassMethod DeleteEpisodeDataItem(AID As %String) As %Boolean [ WebMethod ]
{
	q ##class(EMRservice.BL.BLEpisodeDataItem).DeleteEpisodeDataItem(AID)
}

ClassMethod UpdateEpisodeDataItem(AEEpisodeDataItem As EMRservice.entity.EEpisodeDataItem) As %Boolean [ WebMethod ]
{
	q ##class(EMRservice.BL.BLEpisodeDataItem).UpdateEpisodeDataItem(AEEpisodeDataItem)
}

ClassMethod SelectALLEpisodeDataItem() As EMRservice.dataset.EEpisodeDataItemDataset [ WebMethod ]
{
	q ##class(EMRservice.BL.BLEpisodeDataItem).SelectALLEpisodeDataItem()
}

ClassMethod SelectEpisodeDataItemByID(AID As %String) As EMRservice.entity.EEpisodeDataItem [ WebMethod ]
{
 	q ##class(EMRservice.BL.BLEpisodeDataItem).SelectEpisodeDataItemByID(AID)
}

}
