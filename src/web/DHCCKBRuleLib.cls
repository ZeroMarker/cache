/// Creator：      zhouxin
/// CreatDate：    2019-06-15
/// Description:： 规则编辑器中的字典
Class web.DHCCKBRuleLib Extends %CSP.Page [ Not ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{


	s Libraries=##class(%DynamicArray).%New()
	s varEntitys=##class(web.DHCCKBRuleLib).GetModelProperty()
	d Libraries.%Push(varEntitys)
	w Libraries.%ToJSON()
	
	Quit $$$OK
}

/// w ##class(web.DHCCKBRuleLib).GetModelProperty().%ToJSON()
ClassMethod GetModelProperty()
{
	s KnowTypeDr=##class(web.DHCCKBCommon).GetKnowType()    //知识类型
	s ModelFlagDr=##class(web.DHCCKBCommon).GetModelFlag()  //模型
	s LinkPropDr=##class(web.DHCCKBCommon).GetLinkProp()    //关联属性
	
	s entitys=[]
	s entityID=""  f   s entityID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",KnowTypeDr,entityID))  q:entityID=""   d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(entityID))
	.s entityLinkID="" f   s entityLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",KnowTypeDr,entityID,entityLinkID))  q:entityLinkID=""   d
	..q:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(entityLinkID)),4)'=ModelFlagDr  //过滤知识类型 不是实体的
	..s entity={}
	..s variables=[]
    ..s entity.name=$lg($g(^CT.CKB.PDSS.CommonDictionD(entityID)),3)
    ..s entity.type="Custom"
    ..s entity.clazz=entityID
	..s entity.variables=variables
	..
	..s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",LinkPropDr,entityID,linkID))  q:linkID=""   d
	...s linkAttrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4) 
	...q:linkAttrDr=""
	...s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",linkAttrDr,id)) q:id=""  d
	....q:+id=0
	....s variable={}
    ....s dicDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),5)
    ....s variable.name=$case(dicDr="",1:id,:dicDr)
 	....s label = $case(dicDr="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicDr)),3))
 	....s variable.label=label 
    ....//s variable.label=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    ....s variable.type="String"
    ....s variable.act="InOut"
    ....d variables.%Push(variable)
    ..d entitys.%Push(entity)
    q entitys
}

}
