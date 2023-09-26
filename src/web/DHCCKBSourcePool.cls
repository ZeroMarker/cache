Import sqluser

/// Creator:	qunianpeng
/// CreatDate:	2022-11-22
/// Description:： 知识来源优先级数据池配置类
Class web.DHCCKBSourcePool Extends %RegisteredObject
{

/// Creator:	qunianpeng
/// CreatDate:	2022-11-22
/// Description:： 读取知识来源优先级配置,初始化规则优先级数据
/// Input:
/// Other:	w ##class(web.DHCCKBSourcePool).InitData()
ClassMethod InitData()
{
	s drugId = ##class(web.DHCCKBCommon).GetDrugData()			// 西药
	s chinaId = ##class(web.DHCCKBCommon).GetChineseDrugData()  //中成药
	s drugList = $lb(drugId,chinaId)	
	s liquidId = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")	// 液体配置目录id
	
	k TmpArr
	f i=1:1:$ll(drugList)  d
	.s parref = $lg(drugList,i)
	.s id = ""
	.f  s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id)) q:id=""  d
	..q:id'="150"
	..d ..GetLimitLibRule(id,"",liquidId,.TmpArr)
	..d ..GetDrugLinkPropRule(id,liquidId,.TmpArr)
	b //
	//s TmpArr(dicId,source,rule)=""
	
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-11-22
/// Description:： 通过dicId获取指定目录的规则
/// Input:	drugId(药品id),linkId:(药品相关联数据id,如药品通用名数据),limitLibId:(指定目录id)
/// Other:	w ##class(web.DHCCKBSourcePool).GetRuleSource(630796)
ClassMethod GetLimitLibRule(dicId, linkId, limitLibId, TmpArr)
{
	s markId = $case(linkId="",1:dicId,:linkId) // 通用名id不为空时，使用通用名获取规则
	q:(limitLibId'="")&&('$d(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",markId,limitLibId))) ""
	
	s libDr =  ""
	f  s libDr = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",markId,libDr)) 	q:libDr=""  d
	.q:(limitLibId'="")&&(libDr'=limitLibId) // 暂时只处理液体配置目录的规则
	.s rule = ""
	.f  s rule = $o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",markId,libDr,rule))  q:rule=""  d
	..s source = ..GetRuleSource(rule) // 获取知识来源
	..s sourceName = $case(source'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(source)),3),:"")
	..s TmpArr(dicId,source,rule,markId)=$lb(sourceName)
	
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-11-22
/// Description:： 获取规则的知识来源
/// Input:	rule:规则id
/// Other:	w ##class(web.DHCCKBSourcePool).GetRuleSource(630796)
ClassMethod GetRuleSource(rule)
{
	q:rule="" ""
	
	s source = ""
	s knowSourceId = ##class(web.DHCCKBCommon).GetKnowSource()
	s ruleDataId = ""
	f  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataId))  q:(ruleDataId="")||(source'="")  d
	.s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	.q:leftDic'=knowSourceId
	.s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)
	.s source=rightDic	
	
	s instrId = ##class(web.DHCCKBCommon).GetDicIdByCode("药品说明书") 
	q:source="" instrId  //为空时默认说明书
	
	q source
}

/// Creator:	qunianpeng
/// CreatDate:	2022-11-22
/// Description:： 获取药品关联的其他属性的规则的及知识来源(如通用名规则,成分规则等)
/// Input:	rule:规则id
/// Other:	w ##class(web.DHCCKBSourcePool).GetRuleSource(630796)
ClassMethod GetDrugLinkPropRule(drugId, liquidId, TmpArr)
{
	// 目前只取了通用名的规则
	
	s propList = $lb("gener")
	
	f i=1:1:$ll(propList)  d
	.s prop = $lg(propList,i)
	.s propDataList = ""
	.i prop = "gener" d
	..s propDataList = ##class(web.DHCCKBCommon).GetGeneralFrom(drugId)
	.q:propDataList=""  
	.f k=1:1:$ll(propDataList)  d
	..s itmId = $lg(propDataList,k) // 通用名id
	..d ..GetLimitLibRule(drugId,itmId,liquidId,.TmpArr)
}

}
