/// EPRservice.BOEpisodeDataItem
Class EPRservice.BOEpisodeDataItem Extends %SOAP.WebService [ ProcedureBlock ]
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
ClassMethod CreateEpisodeDataItem(AEEpisodeDataItem As EPRservice.entity.EEpisodeDataItem) As %String [ WebMethod ]
{
 set objEpisodeDataItem = ##class(EPRmeta.EpisodeDataItem).%New()
 Quit:(objEpisodeDataItem ="") "" 
 set objEpisodeDataItem.Name = AEEpisodeDataItem.Name
 set objEpisodeDataItem.FieldName = AEEpisodeDataItem.FieldName
 set objEpisodeDataItem.DataType = AEEpisodeDataItem.DataType
 set objEpisodeDataItem.Description = AEEpisodeDataItem.Description
 Do objEpisodeDataItem.%Save()
 Quit objEpisodeDataItem.%Id()
}

ClassMethod DeleteEpisodeDataItem(AID As %String) As %Boolean [ WebMethod ]
{
	set objEpisodeDataItem = ##class(EPRmeta.EpisodeDataItem).%OpenId(AID)
	if (objEpisodeDataItem="")
	{Quit ""}
	Quit objEpisodeDataItem.%DeleteId(AID)
}

ClassMethod UpdateEpisodeDataItem(AEEpisodeDataItem As EPRservice.entity.EEpisodeDataItem) As %Boolean [ WebMethod ]
{
 set objEpisodeDataItem = ##class(EPRmeta.EpisodeDataItem).%OpenId(AEEpisodeDataItem.ID)
 set objEpisodeDataItem.Name = AEEpisodeDataItem.Name
 set objEpisodeDataItem.FieldName = AEEpisodeDataItem.FieldName
 set objEpisodeDataItem.DataType = AEEpisodeDataItem.DataType
 set objEpisodeDataItem.Description = AEEpisodeDataItem.Description
 Quit objEpisodeDataItem.%Save()
}

ClassMethod SelectALLEpisodeDataItem() As EPRservice.dataset.EEpisodeDataItemDataset [ WebMethod ]
{
 
 Set result=##class(EPRservice.dataset.EEpisodeDataItemDataset).%New()
 Do result.Execute()
 Quit result
}

ClassMethod SelectEpisodeDataItemByID(AID As %String) As EPRservice.entity.EEpisodeDataItem [ WebMethod ]
{
 set Result = ##class(EPRservice.entity.EEpisodeDataItem).%New()
 q:(Result="") "" 
 set objEpisodeDataItem = ##class(EPRmeta.EpisodeDataItem).%OpenId(AID)
 q:(objEpisodeDataItem="") "" 
 set Result.Name = objEpisodeDataItem.Name
 set Result.FieldName = objEpisodeDataItem.FieldName
 set Result.DataType = objEpisodeDataItem.DataType
 set Result.Description = objEpisodeDataItem.Description
 set Result.ID = objEpisodeDataItem.%Id()
 Quit Result
}

}
