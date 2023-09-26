Class EMRservice.InterfaceService.AdmRecordStatus Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2016-07-18
///  Desc:       添加病历全部完成信息表数据
///  Input:      AEpisodeID:就诊号 AUserID用户ID或者操作来源
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.InterfaceService.AdmRecordStatus).AddAdmRecordStatusData("4","10209","127.0.0.1","QualityDepartment","提交病历")
ClassMethod AddAdmRecordStatusData(AEpisodeID As %String, AUserID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "") As %String
{
	s result = ##Class(EMRservice.BL.BLAdmRecordStatus).ConfirmRecordFinished(AEpisodeID,AUserID,AIPAddress,AProductSource,ARemark)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2016-07-18
///  Desc:       获取病历是否全部完成
///  Input:      AEpisodeID:就诊号
///  return:     result 1：提交，0：撤销 -1：退回 空：未提交   
///  Debug:      w ##Class(EMRservice.InterfaceService.AdmRecordStatus).GetAdmRecordStatus("4")
ClassMethod GetAdmRecordStatus(AEpisodeID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLAdmRecordStatus).GetAdmRecordStatus(AEpisodeID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2018-09-11
///  Desc:       撤销病历全部完成，退回时调用
///  Input:      AEpisodeID:就诊号 AUserID用户ID或者操作来源
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  return:     result 1：成功 
///  Debug:      w ##Class(EMRservice.InterfaceService.AdmRecordStatus).RevokeAdmRecordStatus("4",10209,"127.0.0.1","QualityDepartment","退回病历")
ClassMethod RevokeAdmRecordStatus(AEpisodeID As %String, AUserID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "") As %String
{
	s result = ##Class(EMRservice.BL.BLAdmRecordStatus).RevokeConfirmRecord(AEpisodeID,AUserID,AIPAddress,AProductSource,ARemark,"WithDraw")
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2018-09-11
///  Desc:       撤销病历全部完成，召回时调用
///  Input:      AEpisodeID:就诊号 AUserID用户ID或者操作来源
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  return:     result 1：成功 
///  Debug:      w ##Class(EMRservice.InterfaceService.AdmRecordStatus).RecallAdmRecordStatus("5",10209,"127.0.0.1","DHCEPRFS","病案召回")
ClassMethod RecallAdmRecordStatus(AEpisodeID As %String, AUserID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "") As %String
{
	s result = ##Class(EMRservice.BL.BLAdmRecordStatus).RevokeConfirmRecord(AEpisodeID,AUserID,AIPAddress,AProductSource,ARemark,"Recall")
	q result
}

}
