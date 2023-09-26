/// Desc: 		患者病史信息历史数据Bl层 
/// Creator:	Donglulu
/// CreatDate:	2021-1-22
Class EMRservice.BL.BLMedicalHistoryLog Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-12-26
///  Desc:       添加患者病史信息日志历史数据
///  Input:      AMedHistoryID:表EMRinstance.MedicalHistory的ID
///  			 
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistoryLog).AddData("1")
ClassMethod AddData(AMedHistoryID As %String) As %String
{
	s result = "0"
	q:(AMedHistoryID = "") result
	
	s objOld = ##Class(EMRinstance.MedicalHistory).%OpenId(AMedHistoryID)
	q:(objOld = "") result
	
	s obj = ##Class(EMRinstance.MedicalHistoryLog).%New()
	s obj.ModifyDate = objOld.ModifyDate
	s obj.ModifyTime = objOld.ModifyTime
	s obj.ModifyUser = objOld.ModifyUser
	s obj.PatientID = objOld.PatientID
	s obj.QuestionCode = objOld.QuestionCode
	s obj.QuestionDataID = objOld.QuestionDataID
	s obj.QuestionName = objOld.QuestionName
	s obj.QuestionType = objOld.QuestionType
	s obj.Value = objOld.Value
    
    s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
    
	q result
}

}
