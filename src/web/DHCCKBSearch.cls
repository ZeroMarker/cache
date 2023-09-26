/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 知识库查询界面
Class web.DHCCKBSearch Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 药品分类树
/// d ##class(web.DHCCKBSearch).IncCatTree()
ClassMethod IncCatTree()
{
	
	s DrugProp=$o(^CT.CKB.PDSS.CommonDictionI("Code","DRUGCAT",""))
	q:+DrugProp=0
	w "["
	s count=0
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI(0,"Type",DrugProp,id)) q:id=""  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
    .i count>0 d
    ..w ","
    .w "{"
    .w """id"":"_id_","
    .w """text"":"""_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_""""
    .d ..IncCatTreeSub(id)
    .s count=count+1
    .w "}"
	w "]"
    q ""
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 递归循环子节点
ClassMethod IncCatTreeSub(parref)
{
	
	n (parref)	
	s i=0
	w ",""children"":["
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI(0,"Type",parref,id)) q:id=""  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.i i>0 d
    ..w ","
	.w "{"
    .w """id"":"_id_","
    .w """text"":"""_$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)_""""
    .d ..IncCatTreeSub(id)
    .w "}"
    .s i=i+1
	w "]"
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 查询药品
/// d ##class(web.DHCCKBSearch).ListInc()
ClassMethod ListInc(page = 1, rows = 10, queryType = "", queryPar = "", queryCat = "")
{
  n (page,rows,queryType,queryPar,queryCat)
  
  s start=(page-1)*rows+1
  s end=page*rows
  s Drug=$o(^CT.CKB.PDSS.CommonDictionI("Code","DRUG",""),-1)
  s TitleStr="id^incDesc^incSpec^incPackage^incManf"
  s queryPar=$ZCVT(queryPar,"U")
  w "{""rows"":["
  s count=0 
  s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI(0,"Type",Drug,id)) q:id=""  d
  .q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
  .s desc=$ZCVT($lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3),"U")
  .s ASCII=$ASCII(queryPar)
  .i (ASCII>=65)&&(ASCII<=90) d
  ..s:(queryType="name") queryType="namePY"
  .s descPY=##class(web.DHCINSUPort).GetCNCODE(desc,4)
  .q:(queryType="name")&&(desc'[queryPar)
  .q:(queryType="namePY")&&(descPY'[queryPar)
  .s incSpec="" //##class(web.DHCCKBSearch).GetAttrContent(id,"Indic")
  .s incPackage="" //##class(web.DHCCKBSearch).GetAttrContent(id,"Taboo")
  .s Indic=##class(web.DHCCKBSearch).GetAttrContent(id,"Indic")
  .s Taboo=##class(web.DHCCKBSearch).GetAttrContent(id,"Taboo")
  .q:(queryType="indication")&&(Indic'[queryPar)
  .q:(queryType="contraindication")&&(Taboo'[queryPar)
  .
  .q:##class(web.DHCCKBSearch).CheckCat(id,queryCat)=0
  .
  .s incManf=##class(web.DHCCKBSearch).GetAttrContent(id,"Factory")
  .s tmp=id_"^"_desc_"^"_incSpec_"^"_incPackage_"^"_incManf
  .s count=count+1
  .q:count<start
  .q:count>end
  .w $case(count,start:"",:",")
  .w ##class(web.DHCAPPJsonCommon).getJsonData(TitleStr,tmp)
  w "],""total"":"_count_"}"
  q ""
}

/// w ##class(web.DHCCKBSearch).GetAttrContent(2869,"factory")
ClassMethod GetAttrContent(incId, code)
{
	n (incId, code)
	s attrContent=""
	s DrugProp=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(code),""))
	q:+DrugProp=0 ""
	
	s attr="" f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",incId,attr)) q:attr=""  d
	.s attrNameId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),3)
	.q:attrNameId'=DrugProp
	.s attrContent=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),5)
	q attrContent
}

/// w ##class(web.DHCCKBSearch).CheckCat(2869,2222)
ClassMethod CheckCat(incId, catId)
{
	n (incId, catId)
	s ret=0
	q:catId="" 1
	s attr="" f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",incId,attr)) q:attr=""  d
	.s attrNameId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),4)
	.q:attrNameId'=catId
	.s ret=1
	q ret
}

}
