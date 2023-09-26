/// Desc: 		题型脚本关联Bl层 
/// Creator:	Donglulu
/// CreatDate:	2021-2-25
Class EMRservice.BL.BLQuestTypeScript Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLQuestTypeScript).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.QuestionTypeScript).%BuildIndices()
	
	s type = "text"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "textarea"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "radio"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "radio"
	s scriptCode = "selectShowHide"
	s scriptDesc = "选中后显示隐藏其他题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "checkbox"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "combobox"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "combobox"
	s scriptCode = "selectShowHide"
	s scriptDesc = "选中后显示隐藏其他题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "comboboxMult"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "datagrid"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "datagrid"
	s scriptCode = "setLinkData"
	s scriptDesc = "下拉框选择级联"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "number"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "number"
	s scriptCode = "inputShowHide"
	s scriptDesc = "输入后显示隐藏其他题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "datetime"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "date"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
	
	s type = "time"
	s scriptCode = "hideThis"
	s scriptDesc = "根据性别隐藏本题"
	d ..InsertRule(type, scriptCode,scriptDesc)
}

/// Debug: d ##Class(EMRservice.BL.BLQuestTypeScript).InsertRule("","","")
ClassMethod InsertRule(AType As %String, AScriptCode As %String, AScriptDesc As %String) As %String
{
	s id=$O(^DHCEMRM.QuestTypeScriptI("IdxQuestTypeScriptCode"," "_$zcvt(AType,"U")," "_$zcvt(AScriptCode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.QuestionTypeScript).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.QuestionTypeScript).%OpenId(id)
	}
	
	s obj.QuestTypeCode = AType
	s obj.ScriptCode = AScriptCode
	s obj.ScriptDesc = AScriptDesc
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1
	q result
}

/// Desc:       取题型包含脚本
/// Creator:    Donglulu
/// CreateDate: 2021-2-25
/// Input:      
/// OutPut:     json 题型脚本集合
/// Debug:      w ##Class(EMRservice.BL.BLQuestTypeScript).GetScriptByType("datagrid")
ClassMethod GetScriptByType(AType As %String) As %String
{
	s json = ""
	s count = 0
	
	//取公共属性
	s rowID = ""
	for
	{
		s rowID = $O(^DHCEMRM.QuestTypeScriptI("IdxQuestType"," "_$zcvt(AType,"U"),rowID))
		q:(rowID = "")
		
		s obj = ##Class(EMRmeta.QuestionTypeScript).%OpenId(rowID)
		
		s json = json_"{"
		s json = json_"""Code"":"""_obj.ScriptCode_""","
		s json = json_"""Desc"":"""_obj.ScriptDesc_""""
		s json = json_"}"
		s json = json_","
		
		s count = count + 1
	}
	
	s json = $e(json,1,$l(json)-1)
	s json = "["_json_"]"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       取脚本描述
/// Creator:    Donglulu
/// CreateDate: 2021-2-25
/// Input:      脚本代码
/// OutPut:     脚本描述
/// Debug:      w ##Class(EMRservice.BL.BLQuestTypeScript).GetScriptDesc("selectShowHide")
ClassMethod GetScriptDesc(AScriptCode As %String) As %String
{
	s result = ""
	q:(AScriptCode = "") result 
	s rowID = $O(^DHCEMRM.QuestTypeScriptI("IdxScriptCode"," "_$zcvt(AScriptCode,"U"),""))
	q:(rowID = "")
	s obj = ##Class(EMRmeta.QuestionTypeScript).%OpenId(rowID)
	s result = obj.ScriptDesc
	q result
}

}
