/// Desc:问卷题数据属性BL层
/// Creator:Donglulu
/// CreateDate:2020-12-9
Class EMRservice.BL.BLQuestDataSub Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       添加诊前问诊题库属性数据
///  Input:      AQuestionID:病库ID（EMRmeta.QuestionData的ID）
///  			 AProperty:题属性的json串，例如：{"title":"","required":"","minlength":"","maxlength":"","defaultdata":"","InputBoxSize":""}
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestDataSub).AddData("8","")
ClassMethod AddData(AQuestionID As %String, AProperty As %String) As %String
{
	
	s result = "0"
	q:(AQuestionID = "")||(AProperty = "") result
	
	s objQuest = ##class(EMRmeta.QuestionData).%OpenId(AQuestionID)
	q:(objQuest="") result
	
	s array = ##Class(EMRservice.Util.Json).FromJson(AProperty)
	Tstart
	
	for
	{		
		s value = array.GetNext(.key)
		q:(key = "")
		
		s subID = $o(^DHCEMRM.QuestionDataSubI("IdxQuestIDProperty",AQuestionID," "_$zcvt(key,"U"),""))	
	    if (subID = "")
	    {
		    //插入新数据
		    s objSub = ##Class(EMRmeta.QuestionDataSub).%New()
		    s objSub.ParRef = objQuest
			s objSub.PropertyCode = key
	    }
	    else
	    {
		    s rowID = AQuestionID_"||"_subID
		    //修改全部完成时间
		    s objSub = ##Class(EMRmeta.QuestionDataSub).%OpenId(rowID)
		    q:(objSub = "")
	    }
	    s objSub.PropertyValue = value	
	    s scQuestSub = objSub.%Save() 
        if ($$$ISERR(scQuestSub))
        {
	       Trollback
	       q
	    }
	} 
	
	TCOMMIT
    s result = "1"
    k objSub
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-2-27
///  Desc:       复制诊前问诊题库属性数据
///  Input:      ANewQuestID:新增病库ID（EMRmeta.QuestionData的ID）
///  			 ACopyQuestID:被复制病库ID（EMRmeta.QuestionData的ID）
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLQuestDataSub).CopyData("8","")
ClassMethod CopyData(ANewQuestID As %String, ACopyQuestID As %String) As %String
{
	
	s result = "0"
	q:(ANewQuestID = "")||(ACopyQuestID = "") result
	
	s objQuest = ##class(EMRmeta.QuestionData).%OpenId(ANewQuestID)
	q:(objQuest="") result
	
	Tstart
	
	s subID = ""
	for
	{		
		s subID = $o(^DHCEMRM.QuestionDataSubI("IdxQuestID",ACopyQuestID,subID))	
		q:(subID = "")
		
		s rowID = ACopyQuestID_"||"_subID
	    s objSub = ##Class(EMRmeta.QuestionDataSub).%OpenId(rowID)
	    q:(objSub = "")
	    
	    //插入新数据
	    s objNewSub = ##Class(EMRmeta.QuestionDataSub).%New()
	    s objNewSub.ParRef = objQuest
		s objNewSub.PropertyCode = objSub.PropertyCode
		if (objSub.PropertyCode = "code")
		{
			s objNewSub.PropertyValue = ""
		}
		else
		{
			s objNewSub.PropertyValue = objSub.PropertyValue
		}
		
	    s scQuestSub = objNewSub.%Save() 
        if ($$$ISERR(scQuestSub))
        {
	       Trollback
	       q
	    }
	} 
	
	TCOMMIT
    s result = "1"
    k objSub
	
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-16
///  Desc:       获取题属性
///  Input:      AQuestionID:病库ID（EMRmeta.QuestionData的ID）
///  Output:     题属性json串
///  Debug:      w ##Class(EMRservice.BL.BLQuestDataSub).GetDataSub("28")
ClassMethod GetDataSub(AQuestionID As %String) As %String
{
	s result = ""
	q:(AQuestionID = "") result
	s json = ""
	s count = 0
    
    s rowid = ""
    for
    {
    	s rowid = $o(^DHCEMRM.QuestionDataSubI("IdxQuestID",AQuestionID,rowid))	
    	q:(rowid = "")
    	s subID = AQuestionID_"||"_rowid
    	s objQuest = ##Class(EMRmeta.QuestionDataSub).%OpenId(subID)
	    q:(objQuest = "")
	    
	    s:(json '= "") json = json_"," 
	    s json = json_"{""QuestionID"":"""_AQuestionID_""","
	 	s json = json_"""PropertyCode"":"""_objQuest.PropertyCode_""","
	 	s value = objQuest.PropertyValue
	 	s:(objQuest.PropertyCode = "dataset") value = $replace(objQuest.PropertyValue," ","")
	 	if ((objQuest.PropertyCode = "dataset")||(objQuest.PropertyCode = "addcol")||(objQuest.PropertyCode = "scripts")||(objQuest.PropertyCode = "url"))
	 	{
		 	s:(value = "") value = "[]"
		 	s json = json_"""PropertyValue"":"_value_"}"	
	 	}
	 	else
	 	{
		 	s json = json_"""PropertyValue"":"""_value_"""}"	
	 	}
	 	s count = count + 1
    }
	s json = $ZSTRIP(json,"*C")
	s:(json '= "") result = "["_json_"]"
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2021-1-27
///  Desc:       判断该题是否包含某个属性
///  Input:      AQuestionID:病库ID（EMRmeta.QuestionData的ID）
///  		     APropertyCode:属性Code
///  Output:     1 包含 0 不包含
///  Debug:      w ##Class(EMRservice.BL.BLQuestDataSub).IsQuestHasProperty("132","url")
ClassMethod IsQuestHasProperty(AQuestionID As %String, APropertyCode As %String) As %String
{
	s result = "0"
	q:(AQuestionID = "")||(APropertyCode = "") result
    
	s rowid = $o(^DHCEMRM.QuestionDataSubI("IdxQuestIDProperty",AQuestionID," "_$zcvt(APropertyCode,"U"),""))	
	q:(rowid = "") result
	
	s subID = AQuestionID_"||"_rowid
	s objQuest = ##Class(EMRmeta.QuestionDataSub).%OpenId(subID)
    q:(objQuest = "") result
    q:((objQuest.PropertyValue = "")||(objQuest.PropertyValue = "[]")) result
    	
    s result = "1"
    q result
}

///  Debug:      w ##Class(EMRservice.BL.BLQuestDataSub).test("163")
ClassMethod test(AQuestionID As %String) As %String
{
	s result = "0"
	q:(AQuestionID = "") result
	
	s objQuest = ##class(EMRmeta.QuestionData).%OpenId(AQuestionID)
	q:(objQuest="") result

    //插入新数据
    s objSub = ##Class(EMRmeta.QuestionDataSub).%New()
    s objSub.ParRef = objQuest
    
    s objSub.PropertyCode = "scripts"
	
	s action = "hideThis"
	s Condition = "Sex"
	s CondValue = "Man"
	
	s json = "{""Action"":"""_action_""","
	s json = json_"""Condition"":"""_Condition_""","
	s json = json_"""CondValue"":"""_CondValue_"""}"
    
    /*s objSub.PropertyCode = "url"
	
	s className = "EMRservice.BL.BLQuestDataSub"
	s methodName = "testInpatientHistory"
	
	s json = "{""ClassName"":"""_className_""","
	s json = json_"""MethodName"":"""_methodName_"""}"*/
    
	/*s objSub.PropertyCode = "scripts"
	
	s triAction = ""
	s linkField = "0"
	s action = "setLinkData"
	s className = "EMRservice.BL.BLQuestDataSub"
	s methodName = "testRelationship"
	
	s json = "{""triAction"":"""_AQuestionID_""","
	s json = json_"""LinkField"":"""_linkField_""","
	s json = json_"""Action"":"""_action_""","
	s json = json_"""ClassName"":"""_className_""","
	s json = json_"""MethodName"":"""_methodName_"""}"*/
	
	
	/*s triAction = "select"
	s triCondition = "yes"
	
	s action = "show"
	s value = "146^147^148"
	
	s json = "{""triAction"":"""_AQuestionID_""","
	s json = json_"""TriCondition"":"""_triCondition_""","
	s json = json_"""Action"":"""_action_""","
	s json = json_"""Value"":"""_value_"""}"
	
	s triAction = "select"
	s triCondition = "no"
	
	s action = "hide"
	s value = "146^147^148"
	s json = json_","
	s json = json_"{""triAction"":"""_AQuestionID_""","
	s json = json_"""TriCondition"":"""_triCondition_""","
	s json = json_"""Action"":"""_action_""","
	s json = json_"""Value"":"""_value_"""}"*/
	s ret = "["_json_"]"
		
    s objSub.PropertyValue = ret	
    d objSub.%Save() 
    s result = "1"
    k objSub
	
	q result
}

///  Debug:      w ##Class(EMRservice.BL.BLQuestDataSub).testRelationship("其他")
ClassMethod testRelationship(ACode As %String, ADesc As %String) As %String
{
	s result = "[]"
	q:(ACode = "") result
	
	if (ADesc = "父亲")||(ADesc = "母亲")||(ADesc = "哥哥")||(ADesc = "姐姐")||(ADesc = "弟弟")||(ADesc = "妹妹")||(ADesc = "儿子")||(ADesc = "女儿")
	{
		s code = "0"
		s desc = "一级亲属"
	}
	elseif (ADesc = "表兄妹")||(ADesc = "堂兄妹")
	{
		s code = "2"
		s desc = "三级亲属"
	}
	else
	{
		s code = "1"
		s desc = "二级亲属"
	}
	s json = "{""Code"":"""_code_""","
	s json = json_"""Desc"":"""_desc_"""}"
	s result = "["_json_"]"
	q result
}

///  Debug:      w ##Class(EMRservice.BL.BLQuestDataSub).testInpatientHistory("2",132)
ClassMethod testInpatientHistory(APatientID As %String, AQuestID As %String) As %String
{
	s result = ""
	q:(APatientID = "")||(AQuestID = "") "[]"
	
	s key = $i(^CacheTemp)
	k ^TempEMRMedHistory(key)
	s count = 1
	
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLMedicalHistoryBindData:GetInpatientHistory")
	d ds.Execute(APatientID)
	While (ds.Next())
	{
		d setJson
	}
	
	
	s rowid = $o(^DHCEMRI.MedicalHistoryI("IdxPatientIDQuestID"," "_APatientID,AQuestID,""))
	if (rowid '= "")
	{
		s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowid)
		q:(obj = "") result
		s value = obj.Value
		if (value '= "")
		{
			s array = ##Class(EMRservice.Util.Json).FromJson(value)
			
			s arrcount = array.Count()
			for i=1:1:arrcount
			{  
			    s date = array.GetAt(i).GetAt("field0")
			    s reason = array.GetAt(i).GetAt("field1")
			    s long = array.GetAt(i).GetAt("field2")
			    s isSave = "1"
			    
			    s json = "{"
				s json = json_"""field0"":"""_date_"""," 
				s json = json_"""field1"":"""_reason_"""," 
				s json = json_"""field2"":"""_long_""","
				s json = json_"""isSave"":"""_isSave_""""
				s json = json_"}"
				if (date = "")
				{
					s date = $p($h,",",1)
				}
				else
				{
					s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",date)
				}
				s ^TempEMRMedHistory(key,date,count) = json
				s count = count + 1
			} 
		}
	}

	//倒序排序输出
	s tmpdate="",j=0
	for
	{
		s tmpdate = $o(^TempEMRMedHistory(key,tmpdate),-1)
		q:(tmpdate="")

		s order = ""
		for {
			s order = $o(^TempEMRMedHistory(key,tmpdate,order))
			q:(order = "")
			s:(j'=0) result = result_","
			s result = result_^TempEMRMedHistory(key,tmpdate,order)
			s j = j + 1
		}
	}
	
	k ^TempEMRMedHistory(key)
	s result = "["_result_"]"
	s result = $ZSTRIP(result,"*C")
	q result
	q
setJson
	s json = "{"
	s json = json_"""field0"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("date"))_"""," 
	s json = json_"""field1"":"""_ds.Data("reason")_"""," 
	s json = json_"""field2"":"""_ds.Data("long")_""","
	s json = json_"""isSave"":""0"""
	s json = json_"}"
	if (ds.Data("date") = "")
	{
		s date = $p($h,",",1)
	}
	else
	{
		s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("date"))
	}
	s ^TempEMRMedHistory(key,date,count) = json
	s json = ""
	s count = count + 1
	q
}

}
