/// Desc:       抢救事件接口
/// Creator:    Candy
/// CreateDate: 2015-4-13
Class EMRservice.HISInterface.Event.Rescue Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       写入抢救事件数据(数据推送接口)
/// Creator:    Candy
/// CreateDate: 2015-4-13
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOEordItemID 抢救医嘱
///             ARescueDate (cache内部格式) 抢救日期
///             ARescueTime (cache内部格式) 抢救时间
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.Rescue).SetData(48,76,"2||1","身体检查",63634,36676)
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AOEordItemID As %String, AOEordItemDesc As %String, ARescueDate As %String, ARescueTime As %String) As %String
{
	s result = ##Class(EMRservice.BL.Event.BLRescue).SetData(APatientID, AEpisodeID, AOEordItemID, AOEordItemDesc, ARescueDate, ARescueTime)
	q result
}

}
