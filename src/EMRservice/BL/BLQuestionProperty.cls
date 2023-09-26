/// Desc: 		问卷题属性Bl层 
/// Creator:	Donglulu
/// CreatDate:	2020-12-9
Class EMRservice.BL.BLQuestionProperty Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLQuestionProperty).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.QuestionProperty).%BuildIndices()
	
	s code = "title"
	s desc = "题目"
	s seq = "1"
	d ..InsertRule(code, desc, seq)
	
	s code = "code"
	s desc = "代码"
	s seq = "2"
	d ..InsertRule(code, desc, seq)
	
	s code = "required"
	s desc = "必填"
	s seq = "3"
	d ..InsertRule(code, desc, seq)
	
	s code = "scripts"
	s desc = "添加脚本"
	s seq = "4"
	d ..InsertRule(code, desc, seq)
}

/// Debug: d ##Class(EMRservice.BL.BLQuestionProperty).InsertRule("","","")
ClassMethod InsertRule(ACode As %String, ADesc As %String, ASeq As %String) As %String
{
	s id=$O(^DHCEMRM.QuestionPropertyI("IdxCode"," "_$zcvt(ACode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.QuestionProperty).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.QuestionProperty).%OpenId(id)
	}
	
	s obj.Code = ACode
	s obj.Description = ADesc
	s obj.Sequence = ASeq
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

}
