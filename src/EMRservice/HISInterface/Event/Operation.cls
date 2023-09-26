/// Desc:       手术事件接口
/// Creator:    Candy
/// CreateDate: 2015-4-13
Class EMRservice.HISInterface.Event.Operation Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       写手术事件数据(数据推送接口)
/// Creator:    Candy
/// CreateDate: 2015-3-23
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOperID 手术代码表ID
///             AOperCode 手术代码表Code
///             AOperDesc 手术手术名称
///             OperLevel  手术等级
///             OperDocID  术者
///             AOperAssistFirstID 一助ID
///             AOperAssistFirstDesc 一助 
///             AOperAssistSecondID 二助ID
///             AOperAssistSecondDesc 二助
///             AOperAssistThirdID 三助ID
///             AOperAssistThirdDesc 三助
///             AOperDate (cache内部格式) 手术日期
///             AOperTime (cache内部格式) 手术时间
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.HISInterface.Event.Operation).SetData(48,76,2,"01","身体检查",1,63634,36676,105,"王芳",1,"n1",2,"n2",3,"n3")
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AOperID As %String, AOperCode As %String, AOperDesc As %String, AOperLevel As %String, AOperDate As %String, AOperTime As %String, AOperDocID As %String, AOperDocName As %String, AOperAssistFirstID As %String, AOperAssistFirstDesc As %String, AOperAssistSecondID As %String, AOperAssistSecondDesc As %String, AOperAssistThirdID As %String, AOperAssistThirdDesc As %String) As %String
{
	s result = ##Class(EMRservice.BL.Event.BLOperation).SetData(APatientID, AEpisodeID, AOperID, AOperCode, AOperDesc, AOperLevel, AOperDate, AOperTime, AOperDocID, AOperDocName, AOperAssistFirstID,AOperAssistFirstDesc, AOperAssistSecondID,AOperAssistSecondDesc, AOperAssistThirdID, AOperAssistThirdDesc)
	q result
}

}
