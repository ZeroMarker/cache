/// Desc:       危机值事件接口
/// Creator:    Candy
/// CreateDate: 2015-4-13
Class EMRservice.HISInterface.Event.CriticalValue Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       写入危机值事件数据(数据推送接口)
/// Creator:    Candy
/// CreateDate: 2015-4-13
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             ALabNo 标本号
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.CriticalValue).SetData(48,76,"6||1",110,"高血糖1",63634,36676,"1||1","身体检查","1-2")
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, ALabNo As %String) As %String
{
	s result = "0"
	q:(AEpisodeID="")||(ALabNo="") result
	s ds = ##Class(%Library.ResultSet).%New("DHCLabToEPR.DHCLabTestSetQuery:SelectLISItemListByLabNo")
	d ds.Execute(ALabNo,"Panic")
	s result = "1"
	TStart
	While (ds.Next())
	{
		s itemResult = ds.Data("ItemResult")
		s itemDesc = ds.Data("ItemDesc")
		s itemRanges = ds.Data("ItemRanges")
		s itemUnit = ds.Data("ItemUnit")
		s oEordItemRowID = ds.Data("OEordItemRowID")
		s oEordItemDesc = ds.Data("OEordItemDesc")
		s authorDate = ds.Data("AuthorDate")
		s authorTime = ds.Data("AuthorTime")
		s result = ##Class(EMRservice.BL.Event.BLCriticalValue).SetData(APatientID,AEpisodeID,ALabNo,itemResult,itemDesc,authorDate,authorTime,oEordItemRowID,oEordItemDesc,itemRanges,itemUnit)
		q:(result '= "1")
	}
	if (result = "1")
	{
		TCommit
	}
	else
	{
		TRollback
	}
	q result
}

/// Desc:       写入危机值事件数据(数据推送接口，按危急值报告推送)
/// Creator:    Donglulu
/// CreateDate: 2021-4-12
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AFromCode 危急值ID
///             AContent 危急值内容
///             AReportDate 发布危急值日期（cache内部日期格式）
///             AReportTime 发布危急值时间（cache内部时间格式）
///             AOEordItemDesc 医嘱名称
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.CriticalValue).SetDataByReport(8,4,"1","危急值1","","")
ClassMethod SetDataByReport(APatientID As %String, AEpisodeID As %String, AFromCode As %String, AContent As %String, AReportDate As %String, AReportTime As %String, AOEordItemDesc As %String) As %String
{
	s result = "0"
	q:(APatientID="")||(AEpisodeID="")||(AFromCode="") result	
	s result = ##Class(EMRservice.BL.Event.BLCriticalValue).SetData(APatientID,AEpisodeID,"","","",AReportDate,AReportTime,"",AOEordItemDesc,"","",AFromCode,AContent)
	q result
}

}
