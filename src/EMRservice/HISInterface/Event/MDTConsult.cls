/// Desc:       MDT会诊事件接口
/// Creator:    Donglulu
/// CreateDate: 2021-7-21
Class EMRservice.HISInterface.Event.MDTConsult Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       推送MDT会诊数据接口
/// Creator:    Donglulu
/// CreateDate: 2021-7-21
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AConsultID 会诊ID
///             AApplyDate (cache内部格式) 会诊申请日期
///             AApplyTime (cache内部格式) 会诊申请时间
///             AApplyDoctor 会诊申请医生名称
///             AFinishDate (cache内部格式) 会诊完成日期
///             AFinishTime (cache内部格式) 会诊完成时间
///             AConsultDoctor 会诊医生名称
///             AConsultType 疑难病种描述
///             AConsultLoc 会诊科室描述
///             AApplyLoc 会诊申请科室描述
///             AConDestination 会诊目的
///             AAttitude 会诊意见
///             AConsultStatus 会诊状态(完成/取消完成)，可不传，默认为完成
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.MDTConsult).SetData(8,4,"1","65841",52477,"10209","65842","52477","医生01，医生02","单科","内分泌科，肝脏内科","内分泌科","病情复杂","住院观察")
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AConsultID As %String, AApplyDate As %String, AApplyTime As %String, AApplyDoctor As %String, AFinishDate As %String, AFinishTime As %String, AConsultDoctor As %String, AConsultType As %String, AConsultLoc As %String, AApplyLoc As %String, AConDestination As %String, AAttitude As %String, AConsultStatus As %String = "完成") As %String
{
	s result = ##Class(EMRservice.BL.Event.BLMDTConsult).SetData(APatientID, AEpisodeID, AConsultID, AApplyDate, AApplyTime, AApplyDoctor, AFinishDate, AFinishTime, AConsultDoctor, AConsultType, AConsultLoc, AApplyLoc, AConDestination, AAttitude, AConsultStatus)
	q result
}

/// Desc:       将MDT会诊记录状态改为取消完成
/// Creator:    Donglulu
/// CreateDate: 2021-6-3
/// Input:      AConsultID 会诊ID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.MDTConsult).CancelCompletion(8)
ClassMethod CancelCompletion(AConsultID As %String) As %String
{
	s result = ##Class(EMRservice.BL.Event.BLMDTConsult).CancelCompletion(AConsultID)
	q result
}

}
