Class EMRservice.Ajax.QuestionData Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s medHistoryType = $Get(%request.Data("MedHistoryType",1),"")
 	//s page = $g(%request.Data("page",1),"-1")
	//s rows = $g(%request.Data("rows",1),"-1")
	//s idxStart = rows * (page -1) + 1
	//s idxLast = idxStart + rows -1	
	s action = $Get(%request.Data("Action",1),"")

	if (action = "GetQuestionData")
	{
 		w ..GetQuestionData(medHistoryType)
	}
	elseif(action = "GetQuestionDataNoPage")
	{
 		w ..GetQuestionDataNoPage(medHistoryType)
	}
	Quit $$$OK
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       获取题库数据
///  Input:      AMedHistoryType 病史类型
///  Output:     题json串
///  Debug:      w ##Class(EMRservice.Ajax.QuestionData).GetQuestionData("HDSD00.13.037")
ClassMethod GetQuestionData(AMedHistoryType As %String) As %String
{
	s result = ""
	q:(AMedHistoryType = "") "{""total"":""0"",""rows"":[]}"
	s json = ""
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
	    
	    continue:(objQuest.IsPublish = "-1")
	    
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
	    s json = json_"""QuestionID"":"""_rowid_""","
	    s json = json_"""QuestionTypeCode"":"""_objQuest.QuestionType_""","
	 	s json = json_"""QuestionTitle"":"""_objQuest.QuestionTitle_""","
	 	s json = json_"""IsPublish"":"""_objQuest.IsPublish_""","
	 	s json = json_"""QuestionType"":"""_typeName_"""}"
	
	 	s count = count + 1 	
    }
	s json = $ZSTRIP(json,"*C")
	s result = "{""total"":"_count_",""rows"":["_json_"]}"
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-12-10
///  Desc:       获取题库数据不分页
///  Input:      AMedHistoryType 病史类型
///  Output:     题json串
///  Debug:      w ##Class(EMRservice.Ajax.QuestionData).GetQuestionData("HDSD00.13.037")
ClassMethod GetQuestionDataNoPage(AMedHistoryType As %String) As %String
{
	s result = ""
	q:(AMedHistoryType = "") "{""total"":""0"",""rows"":[]}"
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
	    s json = json_"""QuestionID"":"""_rowid_""","
	    s json = json_"""QuestionTypeCode"":"""_objQuest.QuestionType_""","
	 	s json = json_"""QuestionTitle"":"""_objQuest.QuestionTitle_""","
	 	s json = json_"""QuestionType"":"""_typeName_"""}"	
	 	s count = count + 1 	
    }
	s json = $ZSTRIP(json,"*C")
	s result = "{""total"":"_count_",""rows"":["_json_"]}"
	q result
}

}
