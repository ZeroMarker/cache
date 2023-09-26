/// Desc: 		患者病史信息Bl层 
/// Creator:	Donglulu
/// CreatDate:	2020-12-26
Class EMRservice.BL.BLMedicalHistory Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-12-26
///  Desc:       添加患者病史信息
///  Input:      APatientID:患者ID
///  			 AQuestDataID:EMRmeta.QuestionData表ID
///  			 AQuestionName:问题名称
///  			 AQuestionType:问题类型
///  			 AValue:问题值
///  			 AUserID:修改人
///  			 AModifyDate:修改日期
///  			 AModifyTime:修改时间
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistory).AddData("1","1","1","1","1")
ClassMethod AddData(APatientID As %String, AQuestDataID As %String, AQuestionName As %String, AQuestionType As %String, AValue As %String, AUserID As %String, AModifyDate As %String, AModifyTime As %String) As %String
{
	s result = "0"
	q:(APatientID = "")||(AQuestDataID = "")||(AQuestionType = "")||(AUserID = "") result
    
    s rowid = $o(^DHCEMRI.MedicalHistoryI("IdxPatientIDQuestID"," "_APatientID,AQuestDataID,""))	
    
    if (rowid = "")
    {
	    s obj = ##Class(EMRinstance.MedicalHistory).%New()
	    s obj.PatientID = APatientID
	    //d obj.QuestionDataIDSetObjectId(AQuestDataID)
	    s obj.QuestionDataID = AQuestDataID
	    
	    s objQuest = ##Class(EMRmeta.QuestionData).%OpenId(AQuestDataID)
	    q:(objQuest = "") result
	    s obj.QuestionCode = objQuest.QuestionCode
    }
    else
    {
	    s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowid)
	    q:(obj = "") result
	    
	    s isSaveLog = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsSaveMedHistoryLog","N")
	    if (isSaveLog = "Y")
	    {
	    	s saveLog = ##Class(EMRservice.BL.BLMedicalHistoryLog).AddData(rowid)
	    }
    }
    s obj.QuestionName = AQuestionName
    s obj.QuestionType = AQuestionType
    s obj.Value = AValue
    s obj.ModifyDate = AModifyDate
    s obj.ModifyTime = AModifyTime
    s obj.ModifyUser = AUserID
    
    s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s result = "1"
	}
    
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-26
///  Desc:       添加患者病史信息
///  Input:      APatientID:患者ID
///  			 AQuestDatas:问卷值
///  			 AUserID:问卷值
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistory).ChangeData("","")
ClassMethod ChangeData(APatientID As %String, AQuestDatas As %String, AUserID As %String) As %String
{
	s result = "0"
	q:(APatientID = "")||(AQuestDatas = "") result
	s array = ##Class(EMRservice.Util.Json).FromJson(AQuestDatas)
	Tstart
	
	s modifyDate = $p($h,",",1)
    s modifyTime = $p($h,",",2)
	
	s count = array.Count()
	for i=1:1:count
	{  
	    s questID = array.GetAt(i).GetAt("QuestID")
	    s questName = array.GetAt(i).GetAt("QuestName")
	    s questType = array.GetAt(i).GetAt("QuestType")
	    s value = array.GetAt(i).GetAt("Value")
	    
	    s saveResult = ##Class(EMRservice.BL.BLMedicalHistory).AddData(APatientID,questID,questName,questType,value,AUserID,modifyDate,modifyTime)
	    if (saveResult = "0")
	    {
		    Trollback
	    }
	} 
	
	TCOMMIT
    s result = "1"
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-28
///  Desc:       获取患者病史信息
///  Input:      APatientID:患者ID
///  			 AQuestID:EMRmeta.QuestionData表ID
///  return:     result 病史信息
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistory).GetQuestValue("1","109")
ClassMethod GetQuestValue(APatientID As %String, AQuestID As %String) As %String
{
	s result = ""
	q:(APatientID = "")||(AQuestID = "") result
	s rowid = $o(^DHCEMRI.MedicalHistoryI("IdxPatientIDQuestID"," "_APatientID,AQuestID,""))
	q:(rowid = "") result
	s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowid)
	q:(obj = "") result
	s result = obj.Value
	q result
}

/// Desc:       取诊前问诊所有病史类型题库
/// Creator:    Donglulu
/// CreateDate: 2020-12-29
/// Input:      
/// OutPut:     json 诊前问诊题库病史类型数据集
/// Debug:      w ##Class(EMRservice.BL.BLMedicalHistory).GetMedHistoryQuesData("1")
ClassMethod GetMedHistoryQuesData(APatientID As %String) As %GlobalCharacterStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	q:(APatientID = "") result
	s json = ""
	s count = 0
	s ret = ##Class(%GlobalCharacterStream).%New()
	s seq = ""
	for
	{
		s seq = $O(^DHCEMRM.MedHistoryTypeI("IdxSeqCode",seq))
		q:(seq = "")
		s code = ""
		for
		{
			s code = $O(^DHCEMRM.MedHistoryTypeI("IdxSeqCode",seq,code))
			q:(code = "")
			s rowID = $O(^DHCEMRM.MedHistoryTypeI("IdxSeqCode",seq,code,""))
			q:(rowID = "")
			
			s obj = ##Class(EMRmeta.MedicalHistoryType).%OpenId(rowID)
			q:(obj = "")
			//s ret = ##Class(EMRservice.BL.BLQuestionData).GetAllQuestData(obj.Code,APatientID)
			//d:(ret.Size = 0) ret.Write("[]")
			
			if (count = 0)
			{
				d result.Write("[")
			}
			else
			{
				d result.Write(",")
			}
			
			d result.Write("{")
			d result.Write("""Code"":"""_obj.Code_""",")
			d result.Write("""Id"":"""_rowID_""",")
			//d result.Write("""Quest"":")
			//d result.CopyFrom(ret)
			//d result.Write(",")
			d result.Write("""Desc"":"""_$ZSTRIP(obj.Description,"*C")_"""")
			d result.Write("}")
			
			s count = count + 1
		}
	}
	
	d:(result.Size = 0) result.Write("[")
	d result.Write("]")
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-1-27
///  Desc:       获取患者病史信息(带有数据源)
///  Input:      APatientID:患者ID
///  			 AQuestID:EMRmeta.QuestionData表ID
///  return:     result 病史信息
///  Debug:      w ##Class(EMRservice.BL.BLMedicalHistory).GetQuestURLValue("1","162")
ClassMethod GetQuestURLValue(APatientID As %String, AQuestID As %String) As %String
{
	s result = "[]"
	q:(APatientID = "")||(AQuestID = "") result
	
	s subid = $o(^DHCEMRM.QuestionDataSubI("IdxQuestIDProperty",AQuestID," URL",""))	
	q:(subid = "") result
	s qsubid = AQuestID_"||"_subid
	s objSub = ##Class(EMRmeta.QuestionDataSub).%OpenId(qsubid)
	q:(objSub = "") result
	q:(objSub.PropertyValue = "") result
	s array = ##Class(EMRservice.Util.Json).FromJson(objSub.PropertyValue)
	
	s className = array.GetAt("ClassName")
	s methodName = array.GetAt("MethodName")
	
	q:(##class(%Dictionary.CompiledClass).%ExistsId(className) = "0") result
	q:(##class(%Dictionary.CompiledMethod).%ExistsId(className_"||"_methodName) = "0") result
	
	s execCode = "result=##class("_className_")."_methodName_"("""_APatientID_""","""_AQuestID_""")"
    s @execCode
    s result = @"result" 
	q result
}

}
