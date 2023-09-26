///  Desc: 病史管理接口类
Class EMRservice.InterfaceService.MedicalHistory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      获取患者病史问卷中填写的某一题数据
/// Input:     APatientID 患者ID
/// 		   AQuestCode 题目的code（EMRmeta.QuestionData表的QuestionCode）
/// Output:    result 患者病史问卷中填写的某一题数据
/// Debug:     w ##Class(EMRservice.InterfaceService.MedicalHistory).GetQuestValue(1,"MedicalHistory")
ClassMethod GetQuestValue(APatientID As %String, AQuestCode As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetQuestValue(APatientID,AQuestCode)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人既往病史数据
///  Input:      APatientID 患者ID
///  return:     病人既往病史数据
///  Debug:      w ##Class(EMRservice.InterfaceService.MedicalHistory).GetMedicalHistory("4")
ClassMethod GetMedicalHistory(APatientID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetMedicalHistory(APatientID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人传染病史
///  Input:      APatientID 患者ID
///  return:     病人传染病史数据
///  Debug:      w ##Class(EMRservice.InterfaceService.MedicalHistory).GetInfectionDiseaseHistory("4")
ClassMethod GetInfectionDiseaseHistory(APatientID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetInfectionDiseaseHistory(APatientID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人手术史数据
///  Input:      APatientID 患者ID
///  return:     病人手术史数据数据
///  Debug:      w ##Class(EMRservice.InterfaceService.MedicalHistory).GetSurgicalHistory("4")
ClassMethod GetSurgicalHistory(APatientID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetSurgicalHistory(APatientID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人住院史数据
///  Input:      APatientID 患者ID
///  return:     病人住院史数据
///  Debug:      w ##Class(EMRservice.InterfaceService.MedicalHistory).GetHospitalization("4")
ClassMethod GetHospitalization(APatientID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetHospitalization(APatientID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取婚育史数据
///  Input:      APatientID 患者ID
///  return:     婚育史数据
///  Debug:      w ##Class(EMRservice.InterfaceService.MedicalHistory).GetMarriageHistory("4")
ClassMethod GetMarriageHistory(APatientID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetMarriageHistory(APatientID)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-03-17
///  Desc:       获取病人家族史数据
///  Input:      APatientID 患者ID
///  return:     病人家族史数据
///  Debug:      w ##Class(EMRservice.InterfaceService.MedicalHistory).GetFamilyMedicalHistory("4")
ClassMethod GetFamilyMedicalHistory(APatientID As %String) As %String
{
	s result = ##Class(EMRservice.BL.BLMedicalHistoryBindData).GetFamilyMedicalHistory(APatientID)
	q result
}

}
