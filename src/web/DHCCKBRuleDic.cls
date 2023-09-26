Import sqluser

/// Creator：      zhouxin
/// CreatDate：    2019-07-08
/// Description:： 规则索引
Class web.DHCCKBRuleDic Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 保存规则索引
/// zhouxin
/// ##class(web.DHCCKBRuleDic).SaveRuleDic()
ClassMethod SaveRuleDic(ruleId, dicStr)
{
	n (ruleId,dicStr)
	s ret=0,SQLCODE=0
	&sql(delete from CT_CKB_PDSS.RuleDic where RD_Rule=:ruleId)
	q:(SQLCODE'=0)&&(SQLCODE'=100) SQLCODE
	f i=1:1:$l(dicStr,"^") d
	.q:ret'=0
	.q:+$p(dicStr,"^",i)=0
	.s obj=##class(CT.CKB.PDSS.RuleDic).%New()
	.d obj.RDRuleSetObjectId(ruleId)
	.d obj.RDDicSetObjectId(+$p(dicStr,"^",i))
	.s parentDic=+$lg($g(^CT.CKB.PDSS.CommonDictionD(+$p(dicStr,"^",i))),4)
	.i parentDic'=0 d obj.RDDicParentSetObjectId(parentDic)
	.
	.s sc=obj.%Save()
	.s:$SYSTEM.Status.IsError(sc) ret=-2
	q 0
}

/// 查询规则索引
/// / w ##class(web.DHCCKBRuleDic).FindRuleKeyWord(13192)
ClassMethod FindRuleKeyWord(ruleId)
{
	n (ruleId)
	s retArr=[]
	s dic="" f  s dic=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,dic)) q:dic=""  d
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dic)),3)
	.s rowId=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,dic,"")) //hxy 2021-03-26 st 修复一条规则保存后显示于两个目录
	.s dicParent=$lg($g(^CT.CKB.PDSS.RuleDicD(+rowId)),4) 
	.s dicParentDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicParent)),3)
	.s type=""
	.s:dicParentDesc="药品目录字典" type="cat" //ed
	.s keyWord={}
	.d keyWord.%Set("id",dic)
	.d keyWord.%Set("text",dicDesc)
	.d keyWord.%Set("cat",type) //hxy 2021-03-26
	.d retArr.%Push(keyWord)
	d retArr.%ToJSON()
	q ""
}

/// 将数据从旧索引迁移到新索引
/// w ##class(web.DHCCKBRuleDic).updateOldData()
ClassMethod updateOldData()
{
	
	s file=""  f  s file=$o(^CT.CKB.PDSS.RuleD(file)) q:file=""  d
	.q:+file=0
	.s dic=+$lg($g(^CT.CKB.PDSS.RuleD(file)),2)
	.s rel=+$lg($g(^CT.CKB.PDSS.RuleD(file)),6)
	.q:(dic=0)&&(rel=0)
	.
	.s ret=##class(web.DHCCKBRuleDic).SaveRuleDic(file,dic_"^"_rel)
	.w "ret:"_ret,!
	q ""
}

}
