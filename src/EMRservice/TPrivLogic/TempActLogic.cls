Class EMRservice.TPrivLogic.TempActLogic Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CanTempAct(parTemplateId As %String, parAction As %String, parMsgList As %Library.List) As %Status
{
	q:(($d(parTemplateId)=0) || (parTemplateId = "")) 0
 	q:(($d(parAction)=0) || (parAction = "")) 0
 	q:(($d(parMsgList)=0) || (parMsgList = "")) 0

 	//取出规则信息
 	s ruleNote = ..GetRuleNote(parTemplateId, parAction)
 	q:(($d(ruleNote)=0) || (ruleNote = "")) 0
 	s ruleId = $p(ruleNote,"/",1)
 	s actionTypes = $p(ruleNote,"/",2)
 	
 	//判断权限的有效性
 	s privResult = ..CheckPriv(ruleId,actionTypes,parMsgList)
 	q privResult
}

//根据规则判断权限的有效性

ClassMethod CheckPriv(parRuleId As %String, parActionType As %String, parMsgList As %Library.List) As %Status
{
	q:(($d(parRuleId)=0) || (parRuleId = "")) 0
 	q:(($d(parActionType)=0) || (parActionType = "")) 0
 	q:(($d(parMsgList)=0) || (parMsgList = "")) 0
 	
 	s privResult = 1
 	//根据规则的类型组合数据去判断权限的有效性
 	for i=1:1:$l(parActionType,"^")
 	{
		s curType = $p(parActionType,"^",i)
		s cutTypeValue = ..GetTypeValue(curType,parMsgList)
		s privActivity = ..CheckPrivTypeValue(parRuleId,curType,cutTypeValue)
		if (privActivity = 0)
		{
		  s privResult = 0
		}
	}
	
	q privResult
}

//根据数据判断权限的有效性

ClassMethod CheckPrivTypeValue(parRuleId As %String, parCurType As %String, parCurTypeValue As %String) As %Status
{
 	q:(($d(parCurTypeValue)=0) || (parCurTypeValue = "")) 0
 	
 	/*
 	s groupId = $p(parRuleId,"||",1)
 	s ruleChildId = $p(parRuleId,"||",2)
 	q:(($d(groupId)=0) || (groupId = "")) 0
 	q:(($d(ruleChildId)=0) || (ruleChildId = "")) 0
 	
 	s curType = " "_parCurType
 	s curTypeValue = " "_parCurTypeValue
 	
 	s privActivity = $o(^EMRmeta.Templat799.RuleDetailsI("PrivRuleIdTypeValue",groupId,ruleChildId,curType,curTypeValue,0))
 	*/
 	s privActivity = 0
 	&SQL(select Count(*) into :privActivity from EMRmeta_TemplatePriv.RuleDetails where Rules =:parRuleId and Type=:parCurType and ConditionValue=:parCurTypeValue)
 	q:(($d(privActivity)=0) || (privActivity = 0) || (privActivity = "")) 0
 	q 1
}

//取出当前模板所对应的行为的规则ID及规则类型

ClassMethod GetRuleNote(parTemplateId As %String, parAction As %String) As %String
{
 	q:(($d(parTemplateId)=0) || (parTemplateId = "")) ""
 	q:(($d(parAction)=0) || (parAction = "")) ""
 	s curAction = " "_parAction
 
 	//取出模板所在的模板组中对应Action的规则ID
 	/*
 	s groupID = $o(^EMRmeta.Tem799.TemplatesInG673I("PrivTempIdGroupId",parTemplateId,""))
 	*/
 	s groupID = ""
 	&SQL(select TemplateGroup into :groupID from EMRmeta_TemplatePriv.TemplatesInGroup where Template=:parTemplateId)
 	q:(groupID="") ""
 	
 	/*
 	s ruleChildId = $o(^EMRmeta.Templ799.TemplatesRuleI("PrivGroupIdAction",groupID,curAction,0))
 	q:(ruleChildId="") ""
 	
 	//取出规则所采用的Type
 	s ruleList = $g(^EMRmeta.Templ799.TemplatesRuleD(groupID,ruleChildId))
 	q:(ruleList="") ""
 	
 	s ruleType = $lg(ruleList,4)
 	
 	s ruleId = groupID_"||"_ruleChildId
 	q ruleId_"/"_ruleType
 	*/
 	
 	s ruleChildId = ""
 	s ruleType = ""
 	&SQL(select ID,AllConditionType into :ruleChildId,:ruleType from EMRmeta_TemplatePriv.TemplatesRule where TemplateGroup=:groupID and AvailAction=:parAction)
 	
 	q ruleChildId_"/"_ruleType
}

//取出病历信息列表中某一项的内容

ClassMethod GetTypeValue(parType As %String, parMsgList As %Library.List) As %String
{
	q:(($d(parType)=0) || (parType = "")) ""
	
	s data = ""
	
	for j=1:1:$ll(parMsgList) 
	{
		s PIItem=$li(parMsgList,j)
		if ($p(PIItem,$c(2),1)=parType) 
		{
			s data=$p(PIItem,$c(2),2)
			quit
		}
	}
	
	q data
}

}
