/// 规则里的常量
Class web.DHCCKBRuleConstants Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s roots=[]
	s root={}
	s categories=##class(web.DHCCKBRuleConstants).GetCategories()
	s root.categories=categories
	d roots.%Push(root)
	d roots.%ToJSON()
	Quit $$$OK
}

/// w ##class(web.DHCCKBRuleConstants).GetCategories().%ToJSON()
ClassMethod GetCategories()
{
	
	s KnowTypeDr=##class(web.DHCCKBCommon).GetKnowType()       //知识类型
	s DictionFlagDr=##class(web.DHCCKBCommon).GetDictionFlag() //字典标识
	s DrugDataDr=##class(web.DHCCKBCommon).GetDrugData()    
	s Categories=[]
	
	
	s categoryID=""  f   s categoryID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",KnowTypeDr,categoryID))  q:categoryID=""   d
	.s categoryLinkID="" f   s categoryLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",KnowTypeDr,categoryID,categoryLinkID))  q:categoryLinkID=""   d
	..q:$lg($g(^CT.CKB.PDSS.DicLinkAttrD(categoryLinkID)),4)'=DictionFlagDr  
	..s category={}
	..s constants=[]
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(categoryID))
    ..s category.label=$lg($g(^CT.CKB.PDSS.CommonDictionD(categoryID)),3)
    ..s category.name=categoryID
	..s category.constants=constants
	..
	..s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",categoryID,id)) q:id=""  d
	...q:+id=0
	...s constant={}
    ...s constant.name=id
    ...s constant.label=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
    ...d constants.%Push(constant)
    ..d Categories.%Push(category)
    q Categories
}

/// w ##class(web.DHCCKBRuleConstants).Constants().%ToJSON()
/// w ##class(web.DHCCKBRuleConstants).GetConstants("38","5")
ClassMethod GetConstants(variableName, categoryId, input = "")
{
	s Parref=+categoryId
	s:+variableName'=0 Parref=variableName
	q:Parref=0 ""
	s DataSource=##class(web.DHCCKBCommon).GetDataSource()
	k DataArry
	s link=""
	for  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Parref,DataSource,link))  Q:link=""  d
	.q:+link=0
	.s ParentId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),4)
	.q:+Parref=0
	.s id="" 
	.for  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParentId,id)) q:(id="")  d
	..s DataArry(id)=id
	..i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d			//取下级元素 sufan 2020-03-06
 	...d ..QuerySubItm(id,.DataArry)

	s constants=[]
	s num=0
	s index="" f  s index=$o(DataArry(index)) q:(index="")  d
	.q:+index=0
	.Q:##class(web.DHCCKBCommon).IsEnabled(index)=0
	.;q:##class(web.DHCCKBCommon).GetStopDicData(index,%session.Get("LOGON.HOSPID"),%session.Get("LOGON.GROUPID"),%session.Get("LOGON.CTLOCID"),%session.Get("LOGON.USERID"))=1
	.s num=num+1
	.s constant={}
    .s constant.name=index
    .s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(index)),2)
    .s constant.code = code
    .s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(index)),3)
    .s linkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(index)),5)
    .i (desc="")&&(linkId'="") s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)
    .s constant.label=desc
    .d constants.%Push(constant)
   
    d constants.%ToJSON()
    q ""
}

ClassMethod QuerySubItm(Parref, DataArry)
{
	s SubId=""
    for  s SubId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,SubId)) q:(SubId="")  d
    .q:+SubId=0
    .;q:##class(web.DHCCKBCommon).GetStopDicData(SubId,%session.Get("LOGON.HOSPID"),%session.Get("LOGON.GROUPID"),%session.Get("LOGON.CTLOCID"),%session.Get("LOGON.USERID"))=1
   	.s DataArry(SubId)=SubId
   	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",SubId))  d			//取下级元素 sufan 2020-03-06
    ..d ..QuerySubItm(SubId,.DataArry)
}

}
