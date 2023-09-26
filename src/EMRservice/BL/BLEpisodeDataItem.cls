/// 名称:EMRservice.BL.BLEpisodeDataItem
/// 描述:就诊数据项BL
/// 编写者：yejian
/// 编写日期: 2014-2-12
Class EMRservice.BL.BLEpisodeDataItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// Index IdxForFieldName On FieldName [ Unique ];
Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String, FieldName:%String,DataType:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SPM_EpisodeDataItem_SELECTALL, SqlProc ]
{
 SELECT ID, Name,  FieldName ,DataType, Description
 FROM EMRmeta.EpisodeDataItem
 ORDER BY ID
}

/// TODO: add arguments and implementation.
/// 
ClassMethod CreateEpisodeDataItem(AEEpisodeDataItem As EMRservice.entity.EEpisodeDataItem) As %String [ WebMethod ]
{
 set objEpisodeDataItem = ##class(EMRmeta.EpisodeDataItem).%New()
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
	set objEpisodeDataItem = ##class(EMRmeta.EpisodeDataItem).%OpenId(AID)
	if (objEpisodeDataItem="")
	{Quit ""}
	Quit objEpisodeDataItem.%DeleteId(AID)
}

ClassMethod UpdateEpisodeDataItem(AEEpisodeDataItem As EMRservice.entity.EEpisodeDataItem) As %Boolean [ WebMethod ]
{
 set objEpisodeDataItem = ##class(EMRmeta.EpisodeDataItem).%OpenId(AEEpisodeDataItem.ID)
 set objEpisodeDataItem.Name = AEEpisodeDataItem.Name
 set objEpisodeDataItem.FieldName = AEEpisodeDataItem.FieldName
 set objEpisodeDataItem.DataType = AEEpisodeDataItem.DataType
 set objEpisodeDataItem.Description = AEEpisodeDataItem.Description
 Quit objEpisodeDataItem.%Save()
}

ClassMethod SelectALLEpisodeDataItem() As EMRservice.dataset.EEpisodeDataItemDataset [ WebMethod ]
{
 
 Set result=##class(EMRservice.dataset.EEpisodeDataItemDataset).%New()
 Do result.Execute()
 Quit result
}

ClassMethod SelectEpisodeDataItemByID(AID As %String) As EMRservice.entity.EEpisodeDataItem [ WebMethod ]
{
 set Result = ##class(EMRservice.entity.EEpisodeDataItem).%New()
 q:(Result="") "" 
 set objEpisodeDataItem = ##class(EMRmeta.EpisodeDataItem).%OpenId(AID)
 q:(objEpisodeDataItem="") "" 
 set Result.Name = objEpisodeDataItem.Name
 set Result.FieldName = objEpisodeDataItem.FieldName
 set Result.DataType = objEpisodeDataItem.DataType
 set Result.Description = objEpisodeDataItem.Description
 set Result.ID = objEpisodeDataItem.%Id()
 Quit Result
}

}
