Class EMRservice.InterfaceService.DischargedWaitingToSubmit Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-08-25
///  Desc:       根据出院时间计算超过多长时间(系统参数AutoConfirmTime)，自动送病案室(无需出院时其他组调接口)
///  Input:      
///  return:     
///  Debug:      d ##Class(EMRservice.InterfaceService.DischargedWaitingToSubmit).AutomaticTaskSubmit()
ClassMethod AutomaticTaskSubmit()
{
	d ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).AutomaticTaskSubmit()
}

///  Creator:    Donglulu
///  CreateDate: 2020-08-25
///  Desc:       添加患者出院待送病案室表数据
///  Input:      AEpisodeID:就诊号
///  		     ANurseDate:护士结算日期
///  		     ANurseTime:护士结算时间
///  		     AOrderDate:医生下出院医嘱日期
///  		     AOrderTime:医生下出院医嘱时间
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.InterfaceService.DischargedWaitingToSubmit).AddData("230","","","","")
ClassMethod AddData(AEpisodeID As %String, ANurseDate As %Date, ANurseTime As %Time, AOrderDate As %Date, AOrderTime As %Time) As %String
{
	s result = ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).AddData(AEpisodeID,ANurseDate,ANurseTime,AOrderDate,AOrderTime)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-08-25
///  Desc:       根据出院时间计算超过多长时间(系统参数AutoConfirmTime)，自动送病案室，删除患者出院待送病案室表数据
///  Input:      
///  return:     
///  Debug:      d ##Class(EMRservice.InterfaceService.DischargedWaitingToSubmit).AutomaticTaskConirm()
ClassMethod AutomaticTaskConirm()
{
	d ##Class(EMRservice.BL.BLDischargedWaitingToSubmit).AutomaticTaskConirm()
}

}
