/// 提交病历调用其他组接口类
Class EMRservice.HISInterface.AdmRecordStatus Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-10-19
///  Desc:       提交病历成功后调用的第三方接口
///  Input:      AEpisodeID:就诊号
/// 		     AUserID:提交用户userID
///  return:     
///  Debug:      d ##Class(EMRservice.HISInterface.AdmRecordStatus).AfterConfirmAction("","")
ClassMethod AfterConfirmAction(AEpisodeID As %String, AUserID As %String)
{
	//推送第三方首页数据，用以编目
	s firstPageFlag = ##Class(EMRservice.HISInterface.AdmRecordStatus).SendAdmFirstPage("")
	//调用病案组提供的新接口
	if (##class(%Dictionary.CompiledClass).%ExistsId("MA.IPMR.IO.OutService") '= "0")
	{
		if (##class(%Dictionary.CompiledMethod).%ExistsId("MA.IPMR.IO.OutService||handleMrBusiness") '= "0")
		{
			
			d ##class(MA.IPMR.IO.OutService).handleMrBusiness(AEpisodeID, AUserID)
		}
	}
}

///  Creator:    Donglulu
///  CreateDate: 2020-10-19
///  Desc:       撤销提交病历成功后调用的第三方接口
///  Input:      AEpisodeID:就诊号
/// 		     AUserID:提交用户userID
///  return:     
///  Debug:      d ##Class(EMRservice.HISInterface.AdmRecordStatus).AfterRevokeAction("","")
ClassMethod AfterRevokeAction(AEpisodeID As %String, AUserID As %String)
{
}

///  Creator:    Donglulu
///  CreateDate: 2020-10-19
///  Desc:       推送第三方首页数据，用以编目
///  Input:      
///  return:     result 1：成功  0：失败 -1:其他组接口未部署
///  Debug:      w ##Class(EMRservice.HISInterface.AdmRecordStatus).SendAdmFirstPage("")
ClassMethod SendAdmFirstPage(AEpisodeID As %String) As %String
{
	s result = "-1"
	q:(##class(%Dictionary.CompiledClass).%ExistsId("EMRservice.HISInterface.Ens.FPInfo") = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("EMRservice.HISInterface.Ens.FPInfo||SendAdmFirstPage") = "0") result
	d ##Class(EMRservice.HISInterface.Ens.FPInfo).SendAdmFirstPage("")
	s result = "1"
	q result
}

/// Desc:  		点击“送病案室”按钮之后，判断该科室是否有关联门诊功能，是true，反之是false。
/// Creator:    董璐璐
/// CreateDate: 2020-10-19
/// Input:      无
/// Output:     true/false
/// Debug:      w ##Class(EMRservice.HISInterface.AdmRecordStatus).CheckOutCorrelation("")
ClassMethod CheckOutCorrelation(AUserLocID As %String) As %String
{
	s result = "false"
	q:(AUserLocID = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCEPRFS.BL.BLDeptList") = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCEPRFS.BL.BLDeptList||CheckOutCorrelation") = "0") result
	s result = ##Class(DHCEPRFS.BL.BLDeptList).CheckOutCorrelation(AUserLocID)
	q result
}

/// Desc:  		改变医师提交状态
/// Creator:    董璐璐
/// CreateDate: 2020-10-19
/// Input:      AEpisodeID:就诊号
/// 		    AUserID:提交用户userID
/// 		    AModifiedDocIDs:上次提交病历后修改病历的docid，以^分隔
/// Output:     result 1：成功  0：失败 -1:其他组接口未部署
/// Debug:      w ##Class(EMRservice.HISInterface.AdmRecordStatus).RegMRCompletionDHC("","","")
ClassMethod RegMRCompletionDHC(AEpisodeID As %String, AUserID As %String, AModifiedDocIDs As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCEPRFS.BL.BLAdmMRStatus") = "0") "-1"
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCEPRFS.BL.BLAdmMRStatus||RegMRCompletionDHC") = "0") "-1"
	s result = ##Class(DHCEPRFS.BL.BLAdmMRStatus).RegMRCompletionDHC(AEpisodeID,AUserID,"Y","Y","",AModifiedDocIDs)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-10-19
///  Desc:       归档组撤销医生提交状态接口
///  Input:      AEpisodeID:就诊号
/// 		     AUserID:提交用户userID
///  return:     result 1：成功  0：失败 -1:其他组接口未部署
///  Debug:      d ##Class(EMRservice.HISInterface.AdmRecordStatus).SetCheckFailFlag("","")
ClassMethod SetCheckFailFlag(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "")||(AUserID = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId("DHCEPRFS.BI.BIToWMR") = "0") "-1"
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("DHCEPRFS.BI.BIToWMR||SetCheckFailFlag") = "0") "-1"
	s result = ##Class(DHCEPRFS.BI.BIToWMR).SetCheckFailFlag(AEpisodeID, "0", "1", "",AUserID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-10-19
///  Desc:       判断病历是否已被病案室回收
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功  0：失败 -1:其他组接口未部署
///  Debug:      d ##Class(EMRservice.HISInterface.AdmRecordStatus).IGetMrRetrieveStatus("")
ClassMethod IGetMrRetrieveStatus(AEpisodeID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId("MA.IPMR.IO.OutService") = "0") "-1"
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("MA.IPMR.IO.OutService||GetFinishStatus") = "0") "-1"
	s result =##class(MA.IPMR.IO.OutService).GetFinishStatus(AEpisodeID,"RC")
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-10-19
///  Desc:       判断病历是否已被科室质控员签收
///  Input:      AEpisodeID:就诊号
///  return:     result 1：成功  0：失败 -1:其他组接口未部署
///  Debug:      d ##Class(EMRservice.HISInterface.AdmRecordStatus).GetDepDisReciveState("")
ClassMethod GetDepDisReciveState(AEpisodeID As %String) As %String
{
	s result = "0"
	q:(AEpisodeID = "") result
	q:(##class(%Dictionary.CompiledClass).%ExistsId("EPRservice.Quality.SetDepDisFlag") = "0") "-1"
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("EPRservice.Quality.SetDepDisFlag||GetDepDisReciveState") = "0") "-1"
	s result = ##class(EPRservice.Quality.SetDepDisFlag).GetDepDisReciveState(AEpisodeID)
	q result
}

///  Creator:    yejian
///  CreateDate: 2021-12-31
///  Desc:       判断是否提示"请确认已打印心电图、CT报告单、会诊记录单",辽宁沈阳胸科医院，需要调用第三方接口
///  Input:      AEpisodeID:就诊号
/// 				 AUserID:用户ID
///  return:     result 不提示：0 ，提示：返回提示信息
///  Debug:      d ##Class(EMRservice.HISInterface.AdmRecordStatus).GetPrintTipsState("")
ClassMethod GetPrintTipsState(AEpisodeID As %String, AUserID As %String) As %String
{
	s result = "0"
	q:((AEpisodeID = "")||(AUserID="")) result
	s result = ##class(EMRservice.BL.BLPrintTips).GetPrintTipsState(AEpisodeID,AUserID)
	//需要提示，调用第三方接口判断是否已经打印心电图和CT报告单
	if (result="1")
	{
		//q:(##class(%Dictionary.CompiledClass).%ExistsId("EPRservice.Quality.SetDepDisFlag") = "0") "-1"
		//q:(##class(%Dictionary.CompiledMethod).%ExistsId("EPRservice.Quality.SetDepDisFlag||GetDepDisReciveState") = "0") "-1"
		s result = "请确认已打印心电图、CT报告单、会诊记录单"
	}
	q result
}

}
