/// Desc: 		题型Bl层 
/// Creator:	Donglulu
/// CreatDate:	2020-12-9
Class EMRservice.BL.BLQuestionType Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLQuestionType).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.QuestionType).%BuildIndices()
	
	s code = "text"
	s desc = "单行文本"
	d ..InsertRule(code, desc)
	
	s code = "textarea"
	s desc = "多行文本"
	d ..InsertRule(code, desc)
	
	s code = "radio"
	s desc = "单选框"
	d ..InsertRule(code, desc)
	
	s code = "checkbox"
	s desc = "多选框"
	d ..InsertRule(code, desc)
	
	s code = "combobox"
	s desc = "下拉框(单选)"
	d ..InsertRule(code, desc)
	
	s code = "comboboxMult"
	s desc = "下拉框(多选)"
	d ..InsertRule(code, desc)
	
	s code = "datagrid"
	s desc = "表格"
	d ..InsertRule(code, desc)
	
	s code = "number"
	s desc = "数字"
	d ..InsertRule(code, desc)
	
	s code = "date"
	s desc = "日期"
	d ..InsertRule(code, desc)
	
	s code = "time"
	s desc = "时间"
	d ..InsertRule(code, desc)
}

/// Debug: d ##Class(EMRservice.BL.BLQuestionType).InsertRule("","")
ClassMethod InsertRule(ACode As %String, ADesc As %String) As %String
{
	s id=$O(^DHCEMRM.QuestionTypeI("IdxCode"," "_$zcvt(ACode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.QuestionType).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.QuestionType).%OpenId(id)
	}
	
	s obj.Code = ACode
	s obj.Description = ADesc
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

/// Desc:       取诊前问诊题库病史类型
/// Creator:    Donglulu
/// CreateDate: 2020-12-3
/// Input:      
/// OutPut:     json 诊前问诊题库病史类型数据集
/// Debug:      w ##Class(EMRservice.BL.BLQuestionType).GetTypeList()
ClassMethod GetTypeList() As %String
{
	s json = ""
	s count = 0
	
	s code = ""
	for
	{
		s code = $O(^DHCEMRM.QuestionTypeI("IdxCode",code))
		q:(code = "")
		s rowID = $O(^DHCEMRM.QuestionTypeI("IdxCode",code,""))
		q:(rowID = "")
		
		s obj = ##Class(EMRmeta.QuestionType).%OpenId(rowID)
		
		s json = json_"{"
		s json = json_"""Code"":"""_obj.Code_""","
		s json = json_"""Desc"":"""_obj.Description_""""
		s json = json_"}"
		s json = json_","
		
		s count = count + 1
	}
	
	
	s json = $e(json,1,$l(json)-1)
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
