/// Desc: 		题型属性关联Bl层 
/// Creator:	Donglulu
/// CreatDate:	2020-12-9
Class EMRservice.BL.BLQuestTypeProperty Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLQuestTypeProperty).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.QuestionTypeProperty).%BuildIndices()
	
	s type = "text"
	s property = "minlength"
	s propertyDesc = "最小长度"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "text"
	s property = "maxlength"
	s propertyDesc = "最大长度"
	s seq = "2"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "text"
	s property = "defaultdata"
	s propertyDesc = "默认值"
	s seq = "3"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "text"
	s property = "inputBoxSize"
	s propertyDesc = "输入框大小"
	s seq = "4"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "textarea"
	s property = "minlength"
	s propertyDesc = "最小长度"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "textarea"
	s property = "maxlength"
	s propertyDesc = "最大长度"
	s seq = "2"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "textarea"
	s property = "defaultdata"
	s propertyDesc = "默认值"
	s seq = "3"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "textarea"
	s property = "inputBoxSize"
	s propertyDesc = "输入框大小"
	s seq = "4"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "radio"
	s property = "dataset"
	s propertyDesc = "选项集合"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "radio"
	s property = "arrangeType"
	s propertyDesc = "横竖排显示"
	s seq = "2"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "checkbox"
	s property = "dataset"
	s propertyDesc = "选项集合"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "checkbox"
	s property = "arrangeType"
	s propertyDesc = "横竖排显示"
	s seq = "2"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "combobox"
	s property = "dataset"
	s propertyDesc = "选项集合"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "comboboxMult"
	s property = "dataset"
	s propertyDesc = "选项集合"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "datagrid"
	s property = "addcol"
	s propertyDesc = "列属性"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "datagrid"
	s property = "url"
	s propertyDesc = "数据源"
	s seq = "2"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "number"
	s property = "minValue"
	s propertyDesc = "最小值"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "number"
	s property = "maxValue"
	s propertyDesc = "最大值"
	s seq = "2"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "number"
	s property = "includeMax"
	s propertyDesc = "是否大于等于"
	s seq = "3"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "number"
	s property = "includeMin"
	s propertyDesc = "是否小于等于"
	s seq = "4"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "number"
	s property = "decimalDigits"
	s propertyDesc = "小数点位数"
	s seq = "5"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "date"
	s property = "dateFormat"
	s propertyDesc = "日期格式"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
	
	s type = "time"
	s property = "timeFormat"
	s propertyDesc = "时间格式"
	s seq = "1"
	d ..InsertRule(type, property,propertyDesc, seq)
}

/// Debug: d ##Class(EMRservice.BL.BLQuestTypeProperty).InsertRule("","","")
ClassMethod InsertRule(AType As %String, AProperty As %String, APropertyDesc As %String, ASeq As %String) As %String
{
	s id=$O(^DHCEMRM.QuestTypePropertyI("IdxTypeProperty"," "_$zcvt(AType,"U")," "_$zcvt(AProperty,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.QuestionTypeProperty).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.QuestionTypeProperty).%OpenId(id)
	}
	
	s obj.QuestTypeCode = AType
	s obj.PropertyCode = AProperty
	s obj.PropertyDesc = APropertyDesc
	s obj.Sequence = ASeq
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

/// Desc:       取题型包含属性
/// Creator:    Donglulu
/// CreateDate: 2020-12-11
/// Input:      
/// OutPut:     json 题型属性集合
/// Debug:      w ##Class(EMRservice.BL.BLQuestTypeProperty).GetPropertyByType("text")
ClassMethod GetPropertyByType(AType As %String) As %String
{
	s json = ""
	s count = 0
	
	//取公共属性
	s seq = ""
	for
	{
		s seq = $O(^DHCEMRM.QuestionPropertyI("IdxSequence",seq))
		q:(seq = "")
		
		s rowID = ""
		for
		{
			s rowID = $O(^DHCEMRM.QuestionPropertyI("IdxSequence",seq,rowID))
			q:(rowID = "")
			
			s obj = ##Class(EMRmeta.QuestionProperty).%OpenId(rowID)
			
			s json = json_"{"
			s json = json_"""Code"":"""_obj.Code_""","
			s json = json_"""Seq"":"""_count_""","
			s json = json_"""Desc"":"""_obj.Description_""""
			s json = json_"}"
			s json = json_","
			
			s count = count + 1
		}
	}
	
	//取公共属性
	s seq = ""
	for
	{
		s seq = $O(^DHCEMRM.QuestTypePropertyI("IdxQuestTypeSeq"," "_$zcvt(AType,"U"),seq))
		q:(seq = "")
		
		s rowID = ""
		for
		{
			s rowID = $O(^DHCEMRM.QuestTypePropertyI("IdxQuestTypeSeq"," "_$zcvt(AType,"U"),seq,rowID))
			q:(rowID = "")
			
			s objProp = ##Class(EMRmeta.QuestionTypeProperty).%OpenId(rowID)
			
			s json = json_"{"
			s json = json_"""Seq"":"""_count_""","
			s json = json_"""Code"":"""_objProp.PropertyCode_""","
			s json = json_"""Desc"":"""_objProp.PropertyDesc_""""
			s json = json_"}"
			s json = json_","
			
			s count = count + 1
		}
	}
	
	s json = $e(json,1,$l(json)-1)
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
