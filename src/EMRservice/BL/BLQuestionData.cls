/// Desc:问卷题数据BL层
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRservice.BL.BLQuestionData Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       添加诊前问诊题库数据
///  Input:      AMedHistoryType:病史类型
///  			 AQuestionType:题型
///  			 AProperty:题目属性json串
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).AddData("HDSD00.13.037","number","")
ClassMethod AddData(AMedHistoryType As %String, AQuestionType As %String, AProperty As %String) As %String
{
	s result = ""
	q:(AMedHistoryType = "")||(AQuestionType = "")||(AProperty = "") result
	
    //插入新数据
	s obj = ##Class(EMRmeta.QuestionData).%New()
	s obj.MedHistoryType = AMedHistoryType
	s obj.QuestionType = AQuestionType
	s obj.IsPublish = "0"
	s obj.Sequence = ""
	
	s array = ##Class(EMRservice.Util.Json).FromJson(AProperty)
	
	s obj.QuestionTitle = array.GetAt("title")
	s obj.QuestionCode = array.GetAt("code")
	
	TStart
	
	s sc = obj.%Save()
	s questID = ""
	s:($$$ISOK(sc)) questID = obj.%Id()
	
	s subResult = ##Class(EMRservice.BL.BLQuestDataSub).AddData(questID,AProperty)
	
	if (($$$ISOK(sc))&&(subResult = "1"))
    {
	    TCommit	 
	    d ..SaveSequence(obj.%Id())   
		s result = "1"
    }
    else
    {
	    TRollback
    }
	d obj.%Close()	
	k obj
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       获取题库数据
///  Input:      AMedHistoryType 病史类型
///  Output:     题json串
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).GetQuestionData("HDSD00.13.037")
ClassMethod GetQuestionData(AMedHistoryType As %String) As %String
{
	s result = ""
	q:(AMedHistoryType = "") result
	s json = ""
	s count = 0
    
    s rowid = ""
    for
    {
    	s rowid = $o(^DHCEMRM.QuestionDataI("IdxMedHistoryType"," "_$zcvt(AMedHistoryType,"U"),rowid))	
    	q:(rowid = "")
    	s objQuest = ##Class(EMRmeta.QuestionData).%OpenId(rowid)
	    q:(objQuest = "")
	    
	    s questionType = objQuest.QuestionType
		s typeName = ""
		if (questionType '= "")
		{
			s typeID = $O(^DHCEMRM.QuestionTypeI("IdxCode"," "_$zcvt(questionType,"U"),""))
			continue:(typeID = "")
			s objType = ##Class(EMRmeta.QuestionType).%OpenId(typeID)
			continue:(objType = "")
			s typeName = objType.Description
		}
	    
	    s:(json '= "") json = json_"," 
	    s json = json_"{""MedHistoryType"":"""_objQuest.MedHistoryType_""","
	 	s json = json_"""QuestionTitle"":"""_objQuest.QuestionTitle_""","
	 	s json = json_"""QuestionCode"":"""_objQuest.QuestionCode_""","
	 	s json = json_"""QuestionTypeCode"":"""_objQuest.QuestionType_""","
	 	s json = json_"""QuestionType"":"""_typeName_"""}"	
	 	s count = count + 1
    }
	s json = $ZSTRIP(json,"*C")
	s:(json '= "") result = "["_json_"]"
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       添加诊前问诊题库数据
///  Input:      AMedHistoryType:病史类型
///  			 AQuestionType:题型
///  			 AAction:动作 add:增加 update:更新
///  			 AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  			 AProperty:题目属性json串
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).ChangeData("HDSD00.13.037","number","","","")
ClassMethod ChangeData(AMedHistoryType As %String, AQuestionType As %String, AAction As %String, AQuestID As %String, AProperty As %String) As %String
{
	s result = ""
	//s ^tempdong1 = AMedHistoryType_"^"_AQuestionType_"^"_AAction_"^"_AQuestID_"^"_AProperty
	q:(AMedHistoryType = "")||(AQuestionType = "")||(AAction = "")||(AProperty = "") result
	
    if (AAction = "add")
    {
	    s result = ##Class(EMRservice.BL.BLQuestionData).AddData(AMedHistoryType,AQuestionType,AProperty)
    }
    elseif(AAction = "update")
    {
	    s result = ##Class(EMRservice.BL.BLQuestionData).UpdateData(AQuestID,AProperty)
    }	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       添加诊前问诊题库数据
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  			 AProperty:题目属性json串
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).UpdateData("","")
ClassMethod UpdateData(AQuestID As %String, AProperty As %String) As %String
{
	s result = ""
	q:(AQuestID = "")||(AProperty = "") result
	
	s obj = ##Class(EMRmeta.QuestionData).%OpenId(AQuestID)
	q:(obj = "")
	
	s array = ##Class(EMRservice.Util.Json).FromJson(AProperty)
	
	s obj.QuestionTitle = array.GetAt("title")
	s obj.QuestionCode = array.GetAt("code")
	
	TStart
	
	s sc = obj.%Save()
	
	s subResult = ##Class(EMRservice.BL.BLQuestDataSub).AddData(AQuestID,AProperty)
	
	if (($$$ISOK(sc))&&(subResult = "1"))
    {
	    TCommit	    
		s result = "1"
    }
    else
    {
	    TRollback
    }
	d obj.%Close()	
	k obj
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-2-27
///  Desc:       上移诊前问诊题库数据
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
/// 				 AAction "UP":上移 "DOWN":下移
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).MoveSequence("172","UP")
ClassMethod MoveSequence(AQuestID As %String, AAction As %String) As %String
{
	s result = 0
	q:(AQuestID = "") result
	
	s objQuest = ##Class(EMRmeta.QuestionData).%OpenId(AQuestID)
	q:(objQuest = "") result
	s seq = objQuest.Sequence
	s medType = objQuest.MedHistoryType
	
	if (AAction = "UP")
	{
		s type = "-1"
	}
	else
	{
		s type = "1"
	}
	s tmpSeq = seq
	s swapRowid = ""
	for
	{
		s tmpSeq = $o(^DHCEMRM.QuestionDataI("IdxMedHistoryTypeSeq"," "_$zcvt(medType,"U"),tmpSeq),type)	
    	q:(tmpSeq = "")
    	
    	s rowid = $o(^DHCEMRM.QuestionDataI("IdxMedHistoryTypeSeq"," "_$zcvt(medType,"U"),tmpSeq,""))
    	q:(rowid = "")
    	
    	s objQuestTmp = ##Class(EMRmeta.QuestionData).%OpenId(rowid)
		q:(objQuestTmp = "")
		continue:(objQuestTmp.IsPublish = "-1")
		s swapRowid = rowid
		q
	}
    q:(swapRowid = "") result
    
    s result = ##class(EMRservice.BL.BLQuestionData).SwapSequence(AQuestID,rowid)
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       获取题库数据
///  Input:      AMedHistoryType 病史类型
///  		     APatientID 患者ID
///  Output:     题json串
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).GetAllQuestData("HDSD00.13.037","1")
ClassMethod GetAllQuestData(AMedHistoryType As %String, APatientID As %String) As %GlobalCharacterStream
{
	s result = ##Class(%GlobalCharacterStream).%New()
	q:(AMedHistoryType = "")||(APatientID = "") result
	
	s count = 0
    
    s seq = ""
    for
    {
    	s seq = $o(^DHCEMRM.QuestionDataI("IdxMedHistoryTypeSeq"," "_$zcvt(AMedHistoryType,"U"),seq))	
    	q:(seq = "")
    	s rowid = $o(^DHCEMRM.QuestionDataI("IdxMedHistoryTypeSeq"," "_$zcvt(AMedHistoryType,"U"),seq,""))	
    	q:(rowid = "")
    	s objQuest = ##Class(EMRmeta.QuestionData).%OpenId(rowid)
	    q:(objQuest = "")
	    
	    continue:((objQuest.IsPublish = "")||(objQuest.IsPublish = "0"))
	    if (objQuest.IsPublish = "-1")
	    {
		    s isSave = ##Class(EMRservice.BL.BLQuestionData).IsPatientSaveQuest(rowid,APatientID)
		    continue:(isSave = "0")
	    }
	    
	    s questionType = objQuest.QuestionType
		s typeName = ""
		if (questionType '= "")
		{
			s typeID = $O(^DHCEMRM.QuestionTypeI("IdxCode"," "_$zcvt(questionType,"U"),""))
			continue:(typeID = "")
			s objType = ##Class(EMRmeta.QuestionType).%OpenId(typeID)
			continue:(objType = "")
			s typeName = objType.Description
		}
		
		s property = ##Class(EMRservice.BL.BLQuestDataSub).GetDataSub(rowid)
		s:(property = "") property = "[]"
		
		s num = count + 1
		//s title = num_"、"_objQuest.QuestionTitle
		s title = objQuest.QuestionTitle
		
		s hasUrl = ##Class(EMRservice.BL.BLQuestDataSub).IsQuestHasProperty(rowid,"url")
		if (hasUrl = "0")
		{
			s value = ##Class(EMRservice.BL.BLMedicalHistory).GetQuestValue(APatientID,rowid)
		}
		else
		{
			s value = ##Class(EMRservice.BL.BLMedicalHistory).GetQuestURLValue(APatientID,rowid)
		}
		
	    s json = ""
	    s json = json_"{""MedHistoryType"":"""_objQuest.MedHistoryType_""","
	    s json = json_"""QuestionID"":"""_rowid_""","
	    s json = json_"""QuestionTypeCode"":"""_objQuest.QuestionType_""","
	 	s json = json_"""QuestionTitle"":"""_title_""","
	 	s json = json_"""QuestionCode"":"""_objQuest.QuestionCode_""","
	 	s json = json_"""Property"":"_property_","
	 	if (objQuest.QuestionType = "datagrid")
	 	{
	 		s:(value = "") value = "[]" 
	 		s json = json_"""QuestValue"":"_value_","
	 	}
	 	else
	 	{
		 	s json = json_"""QuestValue"":"""_value_""","
	 	}
	 	
	 	s json = json_"""QuestionType"":"""_typeName_"""}"
	 	s json = $ZSTRIP(json,"*C")
	 	if (count = 0)
		{
			d result.Write("[")
		}
		else
		{
			d result.Write(",")
		}
		d result.Write(json)
	 	
	 	s count = count + 1 	
    }
	d:(result.Size = 0) result.Write("[")
	d result.Write("]")
	q result
}

/// creator:     donglulu
/// CreatDate:   2021-2-27
/// Description: 存储顺序号
/// Input:       AQuestID:题目ID(EMRmeta.QuestionData表的ID)
/// debug        do ##class(EMRservice.BL.BLQuestionData).SaveSequence("56")
ClassMethod SaveSequence(RowID As %String)
{
	s TempObj= ##class(EMRmeta.QuestionData).%OpenId(RowID)
	q:(TempObj = "")
	s TempObj.Sequence=TempObj.%Id()
	d TempObj.%Save()
	d TempObj.%Close()	
	k TempObj
}

/// creator:     donglulu
/// CreatDate:   2021-2-27
/// Description:修改题库数据排序顺序号
/// Table:EMRmeta.QuestionData
/// Input:questID1树节点1，questID2树节点2
/// Output:无
/// Return: result是否操作成功
/// others: w ##class(EMRservice.BL.BLQuestionData).SwapSequence("171","172")
ClassMethod SwapSequence(questID1, questID2 As %String) As %Boolean
{
	set result=0
	
	set objQuest = ##class(EMRmeta.QuestionData).%OpenId(questID1)
	set objQuestSele = ##class(EMRmeta.QuestionData).%OpenId(questID2)
	q:((objQuest = "")||(objQuestSele = "")) result
	 
	set TempSequence = objQuest.Sequence
	set objQuest.Sequence = objQuestSele.Sequence
	set objQuestSele.Sequence = TempSequence
	
	set $zt = "SwapErrorHandler"
	
	Tstart
	
	set scResult = objQuest.%Save()
	if $$$ISERR(scResult)
	{
		Trollback
		q result
	}
	
	set scResultSele = objQuestSele.%Save() 
	if $$$ISERR(scResultSele)
	{
		Trollback
		q Ruslut
	}
	
	TCOMMIT
			    
	do objQuestSele.%Close()
	do objQuest.%Close()
	set objQuestSele = ""
	set objQuest = ""
	
	set Ruslut = 1
	q Ruslut

SwapErrorHandler
	Trollback
	q "0"
}

///  Creator:    Donglulu
///  CreateDate: 2021-2-27
///  Desc:       初始化题库数据顺序
///  Input:      
///  Output:     
///  Debug:      d ##Class(EMRservice.BL.BLQuestionData).InitSeq()
ClassMethod InitSeq()
{
	s medType = ""
	for
    {
    	s medType = $o(^DHCEMRM.QuestionDataI("IdxMedHistoryType",medType))	
    	q:(medType = "")
	
		s rowid = ""
	    for
	    {
	    	s rowid = $o(^DHCEMRM.QuestionDataI("IdxMedHistoryType",medType,rowid))	
	    	q:(rowid = "")
	    	s objQuest = ##Class(EMRmeta.QuestionData).%OpenId(rowid)
		    q:(objQuest = "")
		    s objQuest.Sequence = rowid
		    d objQuest.%Save()
	    }
    }
}

///  Creator:    Donglulu
///  CreateDate: 2021-2-27
///  Desc:       复制诊前问诊题库数据
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).CopyData("162")
ClassMethod CopyData(AQuestionID As %String) As %String
{
	s result = ""
	q:(AQuestionID = "") result
	
	s objQuest = ##Class(EMRmeta.QuestionData).%OpenId(AQuestionID)
	q:(objQuest = "") result
	
    //插入新数据
	s obj = ##Class(EMRmeta.QuestionData).%New()
	s obj.MedHistoryType = objQuest.MedHistoryType
	s obj.QuestionType = objQuest.QuestionType
	s obj.IsPublish = "0"
	s obj.Sequence = ""
	s obj.QuestionTitle = objQuest.QuestionTitle
	s obj.QuestionCode = ""
	
	TStart
	
	s sc = obj.%Save()
	s questID = ""
	s:($$$ISOK(sc)) questID = obj.%Id()
	
	s subResult = ##Class(EMRservice.BL.BLQuestDataSub).CopyData(questID,AQuestionID)
	
	if (($$$ISOK(sc))&&(subResult = "1"))
    {
	    TCommit	 
	    d ..SaveSequence(obj.%Id())   
		s result = "1"
    }
    else
    {
	    TRollback
    }
	d obj.%Close()	
	k obj
	q questID
}

///  Creator:    Donglulu
///  CreateDate: 2021-3-1
///  Desc:       发布诊前问诊题库数据
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).PublishQuestion("")
ClassMethod PublishQuestion(AQuestID As %String) As %String
{
	s result = "0"
	q:(AQuestID = "") result
	
	s obj = ##Class(EMRmeta.QuestionData).%OpenId(AQuestID)
	q:(obj = "") result
	
	s obj.IsPublish = "1"
	
	s sc = obj.%Save()
	
	if ($$$ISOK(sc))
    {  
		s result = "1"
    }
	d obj.%Close()	
	k obj
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-3-1
///  Desc:       取消发布诊前问诊题库数据
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).CancelPublishQuestion("")
ClassMethod CancelPublishQuestion(AQuestID As %String) As %String
{
	s result = "0"
	q:(AQuestID = "") result
	
	s hasInstance = ##Class(EMRservice.BL.BLQuestionData).IsQuestionHasInstance(AQuestID)
	q:(hasInstance = "1") "-1"
	
	s obj = ##Class(EMRmeta.QuestionData).%OpenId(AQuestID)
	q:(obj = "") result
	
	s obj.IsPublish = "0"
	
	s sc = obj.%Save()
	
	if ($$$ISOK(sc))
    {  
		s result = "1"
    }
	d obj.%Close()	
	k obj
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-3-1
///  Desc:       作废诊前问诊题库数据
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).RemoveQuestion("")
ClassMethod RemoveQuestion(AQuestID As %String) As %String
{
	s result = "0"
	q:(AQuestID = "") result
	
	s obj = ##Class(EMRmeta.QuestionData).%OpenId(AQuestID)
	q:(obj = "") result
	
	s obj.IsPublish = "-1"
	
	s sc = obj.%Save()
	
	if ($$$ISOK(sc))
    {  
		s result = "1"
    }
	d obj.%Close()	
	k obj
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-3-1
///  Desc:       判断诊前问诊题库数据该题是否有保存过实例数据
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  return:     result 1：保存过  0：未保存过
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).IsQuestionHasInstance("171")
ClassMethod IsQuestionHasInstance(AQuestID As %String) As %String
{
	s result = "0"
	q:(AQuestID = "") result
	
	s rowid = ""
	for
	{
		s rowid = $o(^DHCEMRI.MedicalHistoryI("IdxQuestionDataID",AQuestID,rowid))	
		q:(rowid = "")
		
		s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowid)
		q:(obj = "")
		
		if ((obj.Value '= "")&&(obj.Value '= "[]"))
		{
			s result = "1"
			q 
		}
	}
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-3-1
///  Desc:       判断该作废的题患者有没有填写过
///  Input:      AQuestID:题目ID(EMRmeta.QuestionData表的ID)
///  		     APatientID:患者ID
///  return:     result 1：保存过  0：未保存过
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).IsPatientSaveQuest("170","1")
ClassMethod IsPatientSaveQuest(AQuestID As %String, APatientID As %String) As %String
{
	s result = "0"
	q:(AQuestID = "")||(APatientID = "") result
	
	s rowid = $o(^DHCEMRI.MedicalHistoryI("IdxPatientIDQuestID"," "_$zcvt(APatientID,"U"),AQuestID,""))	
	q:(rowid = "") result
	
	s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowid)
	q:(obj = "") result
	
	if ((obj.Value '= "")&&(obj.Value '= "[]"))
	{
		s result = "1"
	}
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-3-1
///  Desc:       判断库中该代码是否存在
///  Input:      AQuestCode:题目Code(EMRmeta.QuestionData表的QuestionCode)
///  return:     result 1：存在  0：不存在
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).IsCodeExist("testdatagrid")
ClassMethod IsCodeExist(AQuestionCode As %String) As %String
{
	s result = "0"
	q:(AQuestionCode = "") result
	
	s rowid = ""
	for
	{
		s rowid = $o(^DHCEMRM.QuestionDataI("IdxQuestionCode"," "_$zcvt(AQuestionCode,"U"),rowid))	
		q:(rowid = "")
		
		s obj = ##Class(EMRmeta.QuestionData).%OpenId(rowid)
		q:(obj = "")
		continue:(obj.IsPublish = "-1")
		s result = "1"
		q
	}
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2022-6-14
///  Desc:       过滤库中作废的题目
///  Input:      AQuestIDs:题目ID，以^分隔(EMRmeta.QuestionData表的ID)
///  return:     AQuestIDs:题目ID，以^分隔(EMRmeta.QuestionData表的ID)
///  Debug:      w ##Class(EMRservice.BL.BLQuestionData).GetQuestIDsNotDelete("194^195^196^198^197^199")
ClassMethod GetQuestIDsNotDelete(AQuestIDs As %String) As %String
{
	s result = ""
	q:(AQuestIDs = "") result
	
	s length = $l(AQuestIDs,"^")
	for i=1:1:length
	{
		s questID = $P(AQuestIDs,"^",i)
		q:(questID = "")
		s obj = ##Class(EMRmeta.QuestionData).%OpenId(questID)
		continue:(obj = "")
		continue:(obj.IsPublish = "-1")
		s:(result '= "") result = result_"^"
		s result = result_questID
	}
	
	q result
}

}
