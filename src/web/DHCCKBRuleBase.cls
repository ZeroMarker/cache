/// Creator：      zhouxin
/// CreatDate：    2019-06-15
/// Description:： 规则编辑器
Class web.DHCCKBRuleBase Extends %CSP.Page
{

/// w ##class(web.DHCCKBRuleBase).OnPage(1)
ClassMethod OnPage(flag = "") As %Status
{
	
	i flag=1  d
	.s ruleId = 216000 //98014
	e  d
	.s ruleId = $g(%request.Data("files",1),"")
	s array=##class(%DynamicArray).%New()
	s obj=##class(%DynamicObject).%New()
	s rules=##class(%DynamicArray).%New()
	s rule=##class(%DynamicObject).%New()
	
	d obj.%Set("ruleId",+ruleId)	
	d obj.%Set("alone", 1, "boolean").%Set("rules",rules)
	d array.%Push(obj)
	d rules.%Push(rule)
	i +ruleId'=0 d
	.s lhs={}
	.s ruleName=$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),3)
	.s:ruleName="" ruleName="rule" 
	.d rule.%Set("name",ruleName).%Set("remark",$lg($g(^CT.CKB.PDSS.RuleD(ruleId)),2))
	.d rule.%Set("lhs",lhs)
	.s criterion=##class(web.DHCCKBRuleBase).GetCriterion(ruleId,-100000000000000)
	.d lhs.%Set("criterion",criterion)
	.s rhs={}
	.s actions=##class(web.DHCCKBRuleBase).GetActions(ruleId,"then")
	.d rhs.%Set("actions",actions)
	.d rule.%Set("rhs",rhs)
	.s other={}
	.s actionsOther=##class(web.DHCCKBRuleBase).GetActions(ruleId,"else")
	.d other.%Set("actions",actionsOther)
	.d rule.%Set("other",other)
	
	w array.%ToJSON()
	Quit $$$OK
}

/// w ##class(web.DHCCKBRuleBase).GetCriterion(216003,-100000000000000).%ToJSON()
ClassMethod GetCriterion(ruleId, parent)
{
	
	s criterion={}
	s criterions=[]

	s rootNode=+$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent,""))
	q:rootNode=0 ""
	s junctionType=$lg($g(^CT.CKB.PDSS.RuleNodeD(rootNode)),3)
	s criterions=##class(web.DHCCKBRuleBase).GetCriterions(ruleId,rootNode)
	/*
	s ruleData="" f  s ruleData=$o(^CT.CKB.PDSS.RuleDataI("Node",parent,ruleData)) q:ruleData=""  d
	.s criterion={}
	.s op=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),7)
	.s left=##class(web.DHCCKBRuleBase).GetVariableJson(ruleData,1)
	.s value=##class(web.DHCCKBRuleBase).GetVariableJson(ruleData,2)
	.d criterion.%Set("left",left)
	.d criterion.%Set("value",value)
	.d criterion.%Set("op",op)
	.d criterion.%Set("ruleData",ruleData)
	.d criterions.%Push(criterion)	
	*/	
	d criterion.%Set("junctionType",junctionType)
	d criterion.%Set("criterions",criterions)
	d criterion.%Set("ruleData",rootNode)

	q criterion
}

/// ##class(web.DHCCKBRuleBase).GetCriterions()
ClassMethod GetCriterions(ruleId, parent)
{
	s criterions=[]
	s ruleData="" f  s ruleData=$o(^CT.CKB.PDSS.RuleDataI("Node",parent,ruleData)) q:ruleData=""  d
	.s criterion={}
	.s op=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleData)),7)
	.s left=##class(web.DHCCKBRuleBase).GetVariableJson(ruleData,1)
	.s value=##class(web.DHCCKBRuleBase).GetVariableJson(ruleData,2)
	.d criterion.%Set("left",left)
	.d criterion.%Set("value",value)
	.d criterion.%Set("op",op)
	.d criterion.%Set("ruleData",ruleData)
	.d criterions.%Push(criterion)
	s node="" f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",parent,node)) q:node=""  d
	.s criterion={}
	.s junctionType=$lg($g(^CT.CKB.PDSS.RuleNodeD(node)),3)
	.s subCriterions=##class(web.DHCCKBRuleBase).GetCriterions(ruleId,node)
	.d criterion.%Set("junctionType",junctionType)
	.d criterion.%Set("criterions",subCriterions)
	.d criterion.%Set("ruleData",node)
	.d criterions.%Push(criterion)
	q criterions
}

/// w ##class(web.DHCCKBRuleBase).GetVariableJson()
ClassMethod GetVariableJson(ruleDataId, type = 1)
{
	
	s variableName=""
	s variableLabel=""
	s variableCategory=""
	s variableCategoryId=""
	s datatype="String"
	s content=""
	s valueType=""
	s uom=""
	s uomDesc=""
	s limit=""
	s extconst = ""
	s extconstName = ""
	s extconstvar = ""
	s extconstvarName = ""	
	
	i type="1" d
	.s variableName=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)
	.s content=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),5)
	.s valueType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),6)
	e  d
	.s variableName=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)
	.s content=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),9)
	.s valueType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),10)
	.s uom=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),11)
	.s limit=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),12)
	.s:+uom'=0 uomDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(uom)),3)
	.s manLevel=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),13)
	.s extconstvar = manLevel
	.s extconstvarName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+manLevel)),3)			// 管理级别数据集 2022-04-21 qnp
	.s:+manLevel'=0 extconst = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")
	.s:+extconst'=0 extconstName = $lg($g(^CT.CKB.PDSS.CommonDictionD(+extconst)),3)	// 管理级别属性

	s isVariable=##class(web.DHCCKBRuleBase).CheckVariable(valueType)
	s isRule=##class(web.DHCCKBRuleBase).CheckRule(valueType)
   	s isConstant=##class(web.DHCCKBRuleBase).CheckConstant(valueType)
   	
	s retJson={}
	i isVariable=1 d
	.q:+variableName=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(variableName))
	.
	.//只选择了实体，没有选择实体属性的情况
	.//判断该字典是否是实体
	.i ##class(web.DHCCKBCommon).CheckIsModel(variableName)>0 d
	..s variableCategory=$lg($g(^CT.CKB.PDSS.CommonDictionD(variableName)),3)
	.e  d
	..s variableLabel=$lg($g(^CT.CKB.PDSS.CommonDictionD(variableName)),3)
	..s variableCategoryId=content
	..s:+content'=0 variableCategory=$lg($g(^CT.CKB.PDSS.CommonDictionD(content)),3)
	.i type=1 d
	..s leftPart={}
	..d leftPart.%Set("datatype",datatype)
	..d leftPart.%Set("variableCategoryId",variableCategoryId)
	..d leftPart.%Set("variableCategory",variableCategory)
	..d leftPart.%Set("variableLabel",variableLabel)
	..d leftPart.%Set("variableName",variableName)
	..d leftPart.%Set("ruleData",ruleDataId)
	..d retJson.%Set("leftPart",leftPart)
	.d retJson.%Set("type",valueType)
	.e  d
	..d retJson.%Set("datatype",datatype)
	..d retJson.%Set("variableLabel",variableLabel)
	..d retJson.%Set("variableName",variableName)
	e  i isConstant=1 d
	.//数据集
	.d retJson.%Set("constantCategory",variableName)
	.d retJson.%Set("constantName",variableName)
	.s:$lg($g(^CT.CKB.PDSS.CommonDictionD(+variableName)),5)="" DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+variableName)),3)
	.s:$lg($g(^CT.CKB.PDSS.CommonDictionD(+variableName)),5)'="" DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD($lg($g(^CT.CKB.PDSS.CommonDictionD(+variableName)),5))),3)
	.d retJson.%Set("constantLabel",DicDesc)     ;;.d retJson.%Set("constantLabel",$lg($g(^CT.CKB.PDSS.CommonDictionD(variableName)),3))   Sunhuiyong 2020-03-16 linkdr不为空取值判断
	.d retJson.%Set("valueType",valueType)
	.b:DicDesc=""  ;err1
	e  i isRule=1 d
	.//规则
	.d retJson.%Set("variableName",variableName)
	.d retJson.%Set("variableLabel",$lg($g(^CT.CKB.PDSS.RuleD(variableName)),8))
	.d retJson.%Set("valueType",valueType)
	e  d
	.d retJson.%Set("content",content)
	.d retJson.%Set("contentUom",uom)
	.d retJson.%Set("contentUomDesc",uomDesc)
	.d retJson.%Set("contentLimit",limit)
	.d retJson.%Set("valueType",valueType)
	i $d(^CKB.PDSS.RuleComplexArithI("RuleDataSeqParref",ruleDataId)) d
	.s arith=##class(web.DHCCKBRuleBase).GetComplexArith(ruleDataId,type,0)
	.d retJson.%Set("arithmetic",arith)
	
	i type=2 d
	.d retJson.%Set("extconst",extconst)	// 管理级别属性 2022-04-21 qnp
	.d retJson.%Set("extconstName",extconstName)
	.d retJson.%Set("extconstvar",extconstvar)
	.d retJson.%Set("extconstvarName",extconstvarName)
	
	d retJson.%Set("ruleData",ruleDataId)
	q retJson
}

/// ##class(web.DHCCKBRuleBase).GetComplexArith()
ClassMethod GetComplexArith(ruleDataId, type, parrefId)
{
	s ComplexArith={}
	s arith="" f  s arith=$o(^CKB.PDSS.RuleComplexArithI("RuleDataSeqParref",ruleDataId,type,parrefId,arith)) q:arith=""  d
	.s listData = $g(^CKB.PDSS.RuleComplexArithD(arith))
	.s Symbol=$lg(listData,2)
	.s RCAQuote=$lg(listData,6)
	.s RCAType=$lg(listData,3)
	.s RCADic=$lg(listData,5)
	.s RCAValue=$lg(listData,4) 
	.s value={}
	.
	.s isVariable=##class(web.DHCCKBRuleBase).CheckVariable(RCAType)
   	.s isConstant=##class(web.DHCCKBRuleBase).CheckConstant(RCAType)
   	.
	.i isVariable=1 d
	..q:+RCADic=0
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(RCADic))
	..d value.%Set("datatype","String")
	..d value.%Set("variableCategory","药品")
	..d value.%Set("variableLabel",$lg($g(^CT.CKB.PDSS.CommonDictionD(RCADic)),3))
	..d value.%Set("variableName",RCADic)
	.e  i isConstant=1 d
	..s:$lg($g(^CT.CKB.PDSS.CommonDictionD(RCADic)),5)="" DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RCADic)),3)
	..s:$lg($g(^CT.CKB.PDSS.CommonDictionD(RCADic)),5)'="" DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD($lg($g(^CT.CKB.PDSS.CommonDictionD(RCADic)),5))),3)
	..d value.%Set("constantLabel",DicDesc) ;;..d value.%Set("constantLabel",$lg($g(^CT.CKB.PDSS.CommonDictionD(RCADic),"^",2))  Sunhuiyong 2020-03-16 linkdr不为空取值判断
	..d value.%Set("constantName",RCADic)
	..b:DicDesc=""  ;err2
	.e  d
	..d value.%Set("content",RCAValue)
	.d value.%Set("valueType",RCAType)
	.
	.
	.d ComplexArith.%Set("type",Symbol)
	.i RCAQuote=1 d
	..s parenValue={}
	..d ComplexArith.%Set("value",parenValue)
	..d parenValue.%Set("valueType","Paren")
	..d parenValue.%Set("value",value)
	..i $d(^CKB.PDSS.RuleComplexArithI("RuleDataSeqParref",ruleDataId,type,arith)) d
	...s arith=##class(web.DHCCKBRuleBase).GetComplexArith(ruleDataId,type,arith)
	...d value.%Set("arithmetic",arith)
	.e  d
	..d ComplexArith.%Set("value",value)
	..i $d(^CKB.PDSS.RuleComplexArithI("RuleDataSeqParref",ruleDataId,type,arith)) d
	...s arith=##class(web.DHCCKBRuleBase).GetComplexArith(ruleDataId,type,arith)
	...d ComplexArith.%Set("arithmetic",arith)
	q ComplexArith
}

/// 获取actions
ClassMethod GetActions(ruleId, action)
{
	
	s ret=[]
	s node="" f  s node=$o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,action,-100000000000000,node),-1) q:node=""  d
	.s id="" f  s id=$o(^CT.CKB.PDSS.RuleDataI("Node",node,id)) q:id=""  d
	..s leftDic=+$lg($g(^CT.CKB.PDSS.RuleDataD(id)),4)
	..s leftValue=+$lg($g(^CT.CKB.PDSS.RuleDataD(id)),5)
	..s leftType=$lg($g(^CT.CKB.PDSS.RuleDataD(id)),6)
	..s rightDic=+$lg($g(^CT.CKB.PDSS.RuleDataD(id)),8)
	..s rightValue=$lg($g(^CT.CKB.PDSS.RuleDataD(id)),9)
	..s rightType=$lg($g(^CT.CKB.PDSS.RuleDataD(id)),10)
	..s uom=$lg($g(^CT.CKB.PDSS.RuleDataD(id)),11)
	..s limit=$lg($g(^CT.CKB.PDSS.RuleDataD(id)),12)
	..s:+uom'=0 uomDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(uom)),3)
	..s actionJson={}
	..s actionType=$lg($g(^CT.CKB.PDSS.RuleNodeD(node)),3)
	..s actionType=$CASE(actionType,"var-assign":"VariableAssign","console-print":"ConsolePrint",:"ConsolePrint")
	..
	..d actionJson.%Set("actionType",actionType)
	..d actionJson.%Set("type",leftType)
	..
	..i leftDic'=0 d
	...d actionJson.%Set("variableName",leftDic)
	...d actionJson.%Set("variableLabel",$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3))
	...i leftValue'=0 d
	....d actionJson.%Set("variableCategory",$lg($g(^CT.CKB.PDSS.CommonDictionD(leftValue)),3))
	....d actionJson.%Set("variableCategoryId",leftValue)
	..
	..
	..s valueJson={}
	..d valueJson.%Set("valueType",rightType)
	..i rightValue'="" d
	...d valueJson.%Set("content",rightValue)
	..i rightDic'=0 d
	...d valueJson.%Set("constantName",rightDic)
	...s:$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),5)="" DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3)
	...s:$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),5)'="" DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD($lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),5))),3)
	...d valueJson.%Set("constantLabel",DicDesc)  ;;...d valueJson.%Set("constantLabel",$lg($g(^CT.CKB.PDSS.CommonDictionD(rightDic)),3))   Sunhuiyong 2020-03-16 添加linkdr不为空取值判断
	...d valueJson.%Set("ruleData",id)
	...b:DicDesc=""  ;err3
	..d actionJson.%Set("value",valueJson)
	..d actionJson.%Set("ruleData",id)
	..d ret.%Push(actionJson)
	
	q ret
}

/// 判断是否是常量
/// w ##class(web.DHCCKBRuleBase).CheckConstant("CONSTANT")
ClassMethod CheckConstant(RCAType)
{
	q $SYSTEM.Util.Collation(RCAType,5)="CONSTANT"
}

/// 判断是否是变量
/// w ##class(web.DHCCKBRuleBase).CheckVariable("variable")
ClassMethod CheckVariable(RCAType)
{
	q $SYSTEM.Util.Collation(RCAType,5)="VARIABLE"
}

/// 判断是否是规则
/// w ##class(web.DHCCKBRuleBase).CheckRule("Parameter")
ClassMethod CheckRule(RCAType)
{
	q $SYSTEM.Util.Collation(RCAType,5)=$SYSTEM.Util.Collation("Parameter",5)
}

/// 判断是否是规则
/// w ##class(web.DHCCKBRuleBase).CheckRuleType("Parameter")
ClassMethod CheckRuleType(RCAType)
{
	q:##class(web.DHCCKBRuleBase).CheckRule(RCAType)=1 1
	q:##class(web.DHCCKBRuleBase).CheckVariable(RCAType)=1 1
	q 0
}

}
