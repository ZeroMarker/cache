/// Desc:       特殊治疗知情同意书事件接口
/// Creator:    wangyu
/// CreateDate: 2021-09-08
Class EMRservice.HISInterface.Event.InformedConsent Extends %RegisteredObject
{

/// Desc:       特殊治疗知情同意书
/// Creator:    王煜
/// CreateDate: 2021-09-07 
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOEordItemID 操作医嘱ID
///             AOEordItemDesc 操作医嘱描述
///             AOEordItemCreator 操作医嘱创建人
///             AOEordItemDate 开医嘱日期(cache内部格式)
///             AOEordItemTime 开医嘱时间(cache内部格式)
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.InformedConsent).SetData("1285","2887","1||3","特殊治疗知情同意书","10209","医生01",63634,36676)
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AOEordItemID As %String, AOEordItemDesc As %String, AOEordItemCreatorID As %String, AOEordItemCreatorName As %String, AOEordItemDate As %String, AOEordItemTime As %String) As %String
{
		s result = ##Class(EMRservice.BL.Event.BLInformedConsent).SetData(APatientID , AEpisodeID , AOEordItemID , AOEordItemDesc , AOEordItemCreatorID , AOEordItemCreatorName, AOEordItemDate , AOEordItemTime )
		q result
}

}
