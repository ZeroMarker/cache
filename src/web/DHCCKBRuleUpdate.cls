Import SQLUser

Class web.DHCCKBRuleUpdate Extends %Library.RegisteredObject [ ClassType = "", Not Final, Not ProcedureBlock ]
{

/// Descript:导出药品规则
/// w ##class(web.DHCCKBRuleUpdate).ExportRulesByDrug(97665)
ClassMethod ExportRulesByDrug(drugId)
{
	n (drugId)
	k ruleArr
	s h = 0
	s catParId = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s ruledicId = ""
	for  s ruledicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruledicId))  Q:ruledicId=""  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruledicId)),2)				//规则Id
	.s catRuleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,catParId,"")) 		//目录对应的规则表Id
	.s catId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleDicId)),3)			//目录Id
	.s uniqeIdNo = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),5)				//唯一标识
	.s catDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),3)
	.s ruleDataId = ""
	.for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Rule",ruleId,ruleDataId))  Q:ruleDataId=""  d
	..s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)				//左侧属性
	..s leftDesc = ""
	..s:leftDic'="" leftDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
	..s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),5)				//左侧值
	..s leftValDec = ""
	..s:leftValue'="" leftValDec = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftValue)),3)
	..s leftType = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),6)				//左侧类型
	..s Operate = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),7)				//计算符
	..s OperateDesc = ""
	..s OperateDesc = $s(Operate="Equals":"等于",Operate="LessThen":"小于等于",Operate="Between":"Between",Operate="Between":"Between",1:"")
	..s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)				//右侧属性
	..s rightDesc = ""
	..s:rightDic'="" rightDesc =  $lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	..s rightValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),9)			//右侧属性
	..s rightType = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),10)				//右侧类型
	..s rightExt = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),11)				//右侧单位
	..s rightExtDesc = ""
	..s:rightExt'="" rightExtDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(rightExt)),3)
	..s rightLimit = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),12)			//区间值
	..s listData = leftDic_"^"_leftDesc_"^"_leftValue_"^"_leftValDec_"^"_leftType_"^"_Operate_"^"_OperateDesc_"^"_rightDic
	..s listData = listData_"^"_rightDesc_"^"_rightValue_"^"_rightType_"^"_rightExt_"^"_rightExtDesc_"^"_rightLimit_"^"_uniqeIdNo_"^"_catDesc
	..s h = h+1
	..s index = drugId_"^"_catId_"^"_ruleId
	..i $d(ruleArr(index))  d
	...s ruleArr(index) = ruleArr(index)_"@"_listData
	..e  d
	...s ruleArr(index) = listData
	b   //111
	Q ""
}

/// Descript:  本地规则输出
/// w ##class(web.DHCCKBRuleUpdate).ExportRulesByDrug(97665)
ClassMethod LocalRule(drugId)
{
	n (drugId)
	k ruleArr
	s h = 0
	s catParId = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s ruledicId = ""
	F  s ruledicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruledicId))  Q:ruledicId=""  D
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruledicId)),2)				//规则Id
	.s catRuleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,catParId,"")) 		//目录对应的规则表Id
	.s catId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleDicId)),3)			//目录Id
	.s uniqeIdNo = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),5)				//唯一标识
	.s catDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),3)
	.s ruleDataId = ""
	.F  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Rule",ruleId,ruleDataId))  Q:ruleDataId=""  D
	..s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)				//左侧属性
	..s leftDesc = ""
	..s:leftDic'="" leftDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
	..s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),5)				//左侧值
	..s leftValDec = ""
	..s:leftValue'="" leftValDec = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftValue)),3)
	..s leftType = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),6)				//左侧类型
	..s Operate = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),7)				//计算符
	..s OperateDesc = ""
	..s OperateDesc = $s(Operate="Equals":"等于",Operate="LessThen":"小于等于",Operate="Between":"Between",Operate="Between":"Between",1:"")
	..s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)				//右侧属性
	..s rightDesc = ""
	..s:rightDic'="" rightDesc =  $lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	..s rightValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),9)			//右侧属性
	..s rightType = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),10)				//右侧类型
	..s rightExt = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),11)				//右侧单位
	..s rightExtDesc = ""
	..s:rightExt'="" rightExtDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(rightExt)),3)
	..s rightLimit = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),12)			//区间值
	..s listData = leftDic_"^"_leftDesc_"^"_leftValue_"^"_leftValDec_"^"_leftType_"^"_Operate_"^"_OperateDesc_"^"_rightDic
	..s listData = listData_"^"_rightDesc_"^"_rightValue_"^"_rightType_"^"_rightExt_"^"_rightExtDesc_"^"_rightLimit_"^"_uniqeIdNo_"^"_catDesc
	..s h = h+1
	..s index = drugId_"^"_catId_"^"_ruleId
	..i $d(ruleArr(index))  d
	...s ruleArr(index) = ruleArr(index)_"@"_listData
	..e  d
	...s ruleArr(index) = listData
	b   //111
	Q ""
}

/// w ##class(web.DHCCKBRuleUpdate).findRemoveRule()
ClassMethod findRemoveRule()
{
	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	s chndrugDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	k ^temptest("findRemoveRule")
	s drugId = ""
	s h=0
	for  s drugId = $o(	^CT.CKB.PDSS.CommonDictionI("Parref",drugDataId,drugId)) Q:drugId=""  d
	.s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	.s ruleDicId = ""
	.for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicId))  Q:ruleDicId=""  d
	..s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	..s nodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",0,""))
	..s h=h+1
	..;Q:h>100
	..s index = drugId_"^"_ruleId
	..s ^temptest("findRemoveRule",index)=drugDesc_"%%"_ruleId
	Q ""
}

/// w ##class(web.DHCCKBRuleUpdate).findNullRule()
ClassMethod findNullRule()
{
	
	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	s chineseDrugDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	k ^temptest("findNullRule")
	s h = 0
	s rule = ""
	f  s rule = $o(^CT.CKB.PDSS.RuleD(rule))  q:rule=""  d
	.q:$d(^CT.CKB.PDSS.RuleDataI("Rule",rule))
	.s ruleDicId=""
	.//i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,drugDataId))  d
	.//.s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,drugDataId,"")) 
	.//i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,chineseDrugDataId))  d
	.//.s ruleDicId=$o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rule,chineseDrugDataId,"")) 
	.////q:ruleDicId=""
	.//s drugId=$lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),3)
	.//s drugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	.//s index = drugId_"^"_rule
	.s index = rule
	.//s ^temptest("findNullRule",index)=drugName_"%%"_rule
	.s ^temptest("findNullRule",index)=rule
	.s h = h +1
	
	Q h
}

/// Creator: 		wangxin
/// CreateDate: 	2021-02-24
/// Descript:  根据id导出药品规则
/// w ##class(web.DHCCKBRuleUpdate).ExportRulesById("2")
ClassMethod ExportRulesById(rlRule)
{
	n (rlRule)
	
	
	s h = 0
	s catParId = ##class(web.DHCCKBCommon).GetDrugData()                            //取药品字典
	s catRuleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rlRule,catParId,"")) 		
	q:catRuleDicId=""
	s drugId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleDicId)),3)		   //目录Id 
	s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),2)
	s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	s parrefdr=$lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	q:parrefdr=""
	s dictionCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(parrefdr)),2)
	q:drugCode=""
	q:drugDesc=""
	//取药品属性部分
	s manufacProp = ##class(web.DHCCKBCommon).GetDrugManf()
	s manufac = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,manufacProp)
	s formProp = ##class(web.DHCCKBCommon).GetFormProp()
	s form = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,formProp)
	s ^TMPExportDrugRule("web.DHCCKBRuleUpdate","Drug",drugDesc) = "1^"_drugId_"^"_drugCode_"^"_drugDesc_"^"_manufac_"^"_form_"^^" 
	
	
	s catParId = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s catRuleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",rlRule,catParId,"")) 		//目录对应的规则表Id
	q:catRuleDicId=""
	s catId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleDicId)),3)		   //目录Id  drugId

	//取药品规则---------------
	s uniqeIdNo = $lg($g(^CT.CKB.PDSS.RuleD(rlRule)),5)			  //唯一描述
	s RulCode=$lg($g(^CT.CKB.PDSS.RuleD(rlRule)),3)               //唯一标识
	s catDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),3)
	Q:$lg($g(^CT.CKB.PDSS.RuleD(rlRule)),4)'="Release"            /// 未发布不加算在内
	
	s TmpArr("RulID") = rlRule, TmpArr("RuleLev") = 0,TmpArr("drug") = drugDesc
	s TmpArr("cat") = catDesc,TmpArr("uniqeIdNo") = uniqeIdNo,TmpArr("RulCode")=RulCode,TmpArr("catId") = catId
	s nodeId = ""
	
	for  s nodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",rlRule,"if",0,nodeId)) Q:nodeId=""  d
	.s relType=$lg($g(^CT.CKB.PDSS.RuleNodeD(nodeId)),3)       			/// 关系类型
	.s TmpArr("RuleLev") = 0
	.d ..ErgRule(nodeId, relType, .TmpArr,"if")
	
	for  s nodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",rlRule,"then",0,nodeId)) Q:nodeId=""  d
	.s relType=$lg($g(^CT.CKB.PDSS.RuleNodeD(nodeId)),3)       			/// 关系类型
	.s TmpArr("RuleLev") = 0
	.d ..ErgRule(nodeId, relType, .TmpArr,"then")
	
	for  s nodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",rlRule,"else",0,nodeId)) Q:nodeId=""  d
	.s relType=$lg($g(^CT.CKB.PDSS.RuleNodeD(nodeId)),3)       			/// 关系类型
	.s TmpArr("RuleLev") = 0
	.d ..ErgRule(nodeId, relType, .TmpArr,"else")
	
	
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-17
/// Descript:		遍历规则
///  Input:         ParentID - , ParRelType - 关系类型(and,or)
/// w ##Class(web.DHCCKBRuleUpdCompare).ErgRule("", "", .TmpArr)
ClassMethod ErgRule(ParentID As %String, ParRelType As %String, TmpArr, Type) As %String
{
	n (ParentID, ParRelType, TmpArr,Type)
	
	
	
	s RulID=$g(TmpArr("RulID"))       /// 规则ID
	s RuleLev=+$i(TmpArr("RuleLev"))  /// 层级
	
	s TmpArr(RulID, RuleLev, 0) = ParRelType
	//s ^DHCCKBRULEDIC111("web.DHCCKBRuleUpdate","GetRuleNode",$g(TmpArr("drug")),TmpArr("uniqeIdNo"))=ParRelType_"^"_$g(TmpArr("RelAction"))
	
	
	/// 组规则
	s ID=""
	F  s ID=$o(^CT.CKB.PDSS.RuleDataI("Node",ParentID,ID)) Q:ID=""  D
	.Q:'$d(^CT.CKB.PDSS.RuleDataD(ID))
	.D ..GetRuleExp(ID, .TmpArr,Type)
	.

	/// 关联关系
	s ID="", isGrpTrue=""
	F  s ID=$o(^CT.CKB.PDSS.RuleNodeI("Parent",RulID,Type,ParentID,ID)) Q:ID=""  D
	.s RelType=$lg($g(^CT.CKB.PDSS.RuleNodeD(ID)),3) /// 关系类型
	.s TmpArr("RelAction")=$lg($g(^CT.CKB.PDSS.RuleNodeD(ID)),4)
	.D ..ErgRule(ID, RelType, .TmpArr,Type)	
	.
	
	Q ""
}

///  Creator: 		bianshuai
///  CreateDate: 	2020-12-17
///  Descript:		规则描述
///  w ##Class(web.DHCCKBRuleUpdCompare).GetRuleExp("", .TmpArr)
ClassMethod GetRuleExp(ruleDataId As %String, TmpArr, Type) As %String
{
	
	n (ruleDataId, TmpArr,Type)
	s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)				   //左侧属性
	s leftDesc=""
	s:leftDic'="" leftDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
	s leftValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),5)				//左侧值
	s leftValDec=""
	s:leftValue'="" leftValDec=$lg($g(^CT.CKB.PDSS.CommonDictionD(leftValue)),3)
	s leftType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),6)				//左侧类型
	s Operate=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),7)				    //计算符
	s OperateDesc=$s(Operate="Equals":"=",Operate="LessThen":"《=",Operate="Between":"Between",1:"")
	s rightDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)				//右侧属性
	s rightDesc=""
	s:rightDic'="" rightDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	s rightValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),9)			    //右侧属性
	s rightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),10)				//右侧类型
	s rightExt=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),11)				//右侧单位
	s rdOp=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),7)
	s rightExtDesc=""
	s:rightExt'="" rightExtDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(rightExt)),3)
	s rightLimit=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),12)			    //区间值
	s listData=leftDic_"^"_leftDesc_"^"_leftValue_"^"_leftValDec_"^"_leftType_"^"_Operate_"^"_OperateDesc_"^"_rightDic
	s listData=listData_"^"_rightDesc_"^"_rightValue_"^"_rightType_"^"_rightExt_"^"_rightExtDesc_"^"_rightLimit_"^"_rdOp
	;i OperateDesc="Between" s OperateDesc="在 ("_rightValue_" - "_rightLimit_")"_rightExtDesc_" 之间"
	s TmpArr($g(TmpArr("RulID")),$g(TmpArr("RuleLev")), ruleDataId) = listData  ;leftValDec_""_leftDesc_" "_OperateDesc_" "_rightValue_" "_rightDesc_" "_rightExtDesc
	//s ^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",$g(TmpArr("drug")),TmpArr("RulCode"),TmpArr("catId"),TmpArr("uniqeIdNo"),$g(TmpArr("RuleLev")),ruleDataId) = listData_"^"_Type    
    s ^TMPExportDrugRule("web.DHCCKBRuleUpdate","GetRuleExp",$g(TmpArr("drug")),TmpArr("RulCode"),TmpArr("catId"),TmpArr("uniqeIdNo"),ruleDataId,$g(TmpArr("RuleLev"))) = listData_"^"_Type_"^"_$g(TmpArr("RuleLev"))   //修改节点顺序,将层级提前到ruleDataId之后
	                                                   
	Q ""
}

}
