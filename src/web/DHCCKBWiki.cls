/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 知识库百科界面
Class web.DHCCKBWiki Extends (%RegisteredObject, %CSP.Page, %XML.Adaptor)
{

ClassMethod OnPage() As %Status
{

	s IncId = $g(%request.Data("IncId",1),"")
	s Flag = +$g(%request.Data("Flag",1),"")
	i Flag=0 d
	.d ##class(web.DHCCKBWiki).GetGraph(IncId)
	e  d
	.d ##class(web.DHCCKBWiki).GetKnowGraphLess(IncId)
	Quit $$$OK
}

/// Creator：      zhouxin
/// CreatDate：    2019-08-19
/// Description:： 知识库图谱
/// d ##class(web.DHCCKBWiki).GetGraphLess(160)
ClassMethod GetGraphLess(incId)
{
	
	s incDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(incId)),3)

	
	s obj= ##class(%DynamicObject).%New()
    
    
    s legend=##class(%DynamicArray).%New()
    s categories=##class(%DynamicArray).%New()
    s nodes=##class(%DynamicArray).%New()
    s links=##class(%DynamicArray).%New()
    

    
    s node={}
    s node.id=0
    s node.name=incDesc
	s node.label=incDesc
	d nodes.%Push(node)
    //
    s categoryIndex=0
    s pro="" f  s pro=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,pro)) q:pro=""  d
    .q:'$d(^CT.CKB.PDSS.CommonDictionD(pro))
    .s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(pro)),5)						//sufan 20200514 增加link字段的判断
    .s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(pro)),3)						//属性描述
    .s:(desc="")&&(LinkId'="") desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
    .s categoryIndex=categoryIndex+1
    .
    .s categorie={}.%Set("name",desc)
    .d categories.%Push(categorie)
    .d legend.%Push(desc)									//取导航
    .s attr="" f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,pro,attr)) q:attr=""  d
	..q:'$d(^CT.CKB.PDSS.DicLinkAttrD(attr))
	..s attrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),4)					//sufan20200514取属性Id
	..s attrValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),5)
	..s attrName=""
	..s:attrId'="" attrName=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrId)),3)
	..s attrValue=$replace(attrValue,$c(10),"</br>")
	..s node={}
	..s node.category=categoryIndex
    ..s node.id=pro
    ..s node.name=attrValue
	..s node.label=$e(attrValue,0,5)
	..d nodes.%Push(node)
	..s link={}
    ..s link.source=incDesc
    ..s link.target=attrValue
    ..s link.name=desc
    ..s link.weight=15
	..d links.%Push(link)
	
					
    set obj.nodes = nodes
	set obj.links = links
	set obj.legend = legend
	set obj.categories = categories
	w obj.%ToJSON()
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 知识库图谱
/// d ##class(web.DHCCKBWiki).GetGraph(160)
ClassMethod GetGraph(incId)
{
	
	s incDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(incId)),3)

	
	s obj= ##class(%DynamicObject).%New()
    set obj.data = ##class(%DynamicObject).%New()
    set obj.cat = ##class(%DynamicObject).%New()
    set obj.cat.med="药品名称"
    set obj.cat.attr="属性"
    set obj.cat.attrVal="值"

    
    
    
    s nodes=##class(%DynamicArray).%New()
    s edges=##class(%DynamicArray).%New()
    
    s nodeRoot={}
    s nodeRoot.id=0
    s nodeRoot.label=incDesc
    s nodeRoot.categories=[]
    s nodeRoot.categories."0"="med"
	d nodes.%Push(nodeRoot)
    
    //
    s pro="" f  s pro=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,pro)) q:pro=""  d
    .q:'$d(^CT.CKB.PDSS.CommonDictionD(pro))
    .s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(pro)),3)
    .s node={}
    .s node.id="S"_pro
    .s node.label=desc
    .s node.categories=[]
    .s node.categories."0"="attr"
	.d nodes.%Push(node)
	.s edge={}
    .s edge.from=0
    .s edge.to="S"_pro
    .s edge.label=desc
	.d edges.%Push(edge)
    .s attr="" f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,pro,attr)) q:attr=""  d
	..s attrValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),5)
	..s attrName=$lg($g(^CT.CKB.PDSS.CommonDictionD(attr)),3)
	..
	..s node={}
    ..s node.id="M"_attr
    ..s node.label=attrValue
    ..s node.categories=[]
    ..s node.categories."0"="attrVal"
	..d nodes.%Push(node)
	..s edge={}
    ..s edge.from="S"_pro
    ..s edge.to="M"_attr
    ..s edge.label=attrName
	..d edges.%Push(edge)
	
					
    set obj.data.nodes = nodes
	set obj.data.edges = edges
	w obj.%ToJSON()
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 知识库百科锚点
/// d ##class(web.DHCCKBWiki).AnchorToHtml(451)
ClassMethod AnchorToHtmlN(incId)
{
	
	q:incId="" ""
		
	w "<div id='anchor' style='margin-top:60px;width:220px;height:350px;position:fixed;z-index:1;overflow-y:auto'>"

	w "<ul class='anchor-list'>"
	w "<li style='height:13px'>"
	w " <div class='anchor-circle'></div>"
	w " <span class='anchor-txt'></span>"
	w "</li>"
	s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()	//kml 2020-04-01 是否需要维护属性值
	s LinPropId=##class(web.DHCCKBCommon).GetLinkProp()					//sufan 2020-04-01 属性关联ID
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
	d ..GetIncAttrByOrd(pid,incId)										//sufan 2020-04-07 按顺序存储
	k AnchArray
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index)) Q:Index=""  d
	.// 判断是否需要维护属性值
	.s attrID=+$g(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index))
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	.q:(linkDr'="")&&('$d(^CT.CKB.PDSS.CommonDictionD(linkDr)))
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(attrID))
	.s tmpLinkID="",AddValueId="",AddValueFlag=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID,""))
	.i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	.s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	.q:$g(AddValueFlag)="N"
	.s AttrLinkId=""
	.f  s AttrLinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,attrID,AttrLinkId)) Q:AttrLinkId=""  d
	..Q:$d(AnchArray(attrID))							//sufan 2020-04-01 过滤相同属性
	..s AnchArray(attrID)=attrID
	..s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrLinkId)),6)		//组号
	..Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,LinPropId))&&(GroupFlag'="")
	..i linkDr=""  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	..e  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,attrID) //kml 2020-04-01 过滤值为空的记录
	..q:attrDesc="" //kml
	..w "<li>"
	..w " <div class='circle'></div>"
	..w " <a herf='#' id='"_code_"' class='anchor-point'>"_desc_"</a>"
	..w "</li>"

	w "<li>"
	w " <i class='anchor-circle'></i>"
	w "</li>"
	w "</ul>"
    w "</div>"
    k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
	Q ""
}

/// Creator：      zhouxin
/// CreatDate：    2019-05-19
/// Description:： 知识库百科明细
/// d ##class(web.DHCCKBWiki).WikiToHtml(129424)
ClassMethod WikiToHtml(incId)
{
	q:incId="" ""
	s drugCat=##class(web.DHCCKBCommon).GetPhCategory() 				//药学分类 2020-03-31 kml 
	s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()	//kml 2020-04-01 是否需要维护属性值
	s LinPropId=##class(web.DHCCKBCommon).GetLinkProp()					//sufan 2020-04-01 属性关联ID
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
	d ..GetIncAttrByOrd(pid,incId)										//sufan 2020-04-07 按顺序存储								
	k AttrArray
	k TmpArrGroup
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index)) Q:Index=""  d
	.// 判断是否需要维护属性值
	.s attrID=+$g(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index))
	.s tmpLinkID="",AddValueId="",AddValueFlag=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID,""))
	.i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	.s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	.q:$g(AddValueFlag)="N"
	.s AttrLinkId=""
	.f  s AttrLinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,attrID,AttrLinkId)) Q:AttrLinkId=""  d
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(attrID))
	..Q:$d(AttrArray(attrID))							//sufan 2020-04-01 过滤相同属性
	..s AttrArray(attrID)=attrID
	..s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrLinkId)),6)		//组号	
	..Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,LinPropId))&&(GroupFlag'="")
	..s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	..i linkDr=""  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	..e  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..
	..i linkDr="" d
	...s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,attrID) //kml 2020-04-01 过滤值为空的记录
	..e  d
	...s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,linkDr) //kml 2020-04-01 过滤值为空的记录
	..q:attrDesc="无内容" // qnp 2021/12/20 药师团队写上了无内容的标记 需要过滤
	..q:attrDesc="" //kml
	..w "<div class='para-title level-2' id='"_code_"-List'>"
	..w "	<h2 class='title-text'><span class='title-prefix'></span>"_desc_"</h2>"
	..;w "	<a class='edit-icon j-edit-link' data-edit-dl='3' href='javascript:window.open(""dhcckb.editrule.hisui.csp?typeID="_incId_"&dicID="_incId_""");' style='display: block;'><em class='cmn-icon wiki-lemma-icons wiki-lemma-icons_edit-lemma'></em>编辑</a>"
	..w "</div>"
	..i attrID=drugCat d ..WikiCatItmToHtml(incId, attrID) //药学分类五级显示 2020-03-31 kml
	..q:attrID=drugCat //kml
	..i linkDr="" d
	...d ##class(web.DHCCKBWiki).WikiItmToHtml(incId,attrID)
	..e  d
	...d ##class(web.DHCCKBWiki).WikiItmToHtml(incId,linkDr)
	k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
		

	Q ""
}

/// Descript:按顺序存储属性
/// Creator:sufan
/// CreateDate:2020-04-07
/// Input：药品Id
/// w ##class(web.DHCCKBWiki).GetIncAttrByOrd(1,451)
ClassMethod GetIncAttrByOrd(pid, incId)
{
	s LinPropId=##class(web.DHCCKBCommon).GetLinkProp()	
	k TempArr
	s OrdNumAttrId=##class(web.DHCCKBCommon).GetOrdNumId()				//顺序号属性
	s count=0
	s attrID=""
	for  s attrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,attrID)) Q:attrID=""  d
	.Q:'$d(^CT.CKB.PDSS.CommonDictionD(attrID))
	.;Q:##class(web.DHCCKBWiki).IsShowAttr(attrID)=0   //判断属性是否显示
	.s Text=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	.s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	.s:LinkId'="" Text=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	.s OrdNum=""
	.s count=count+1
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,OrdNumAttrId))  d				//取顺序号
	..s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,OrdNumAttrId,""))
	..s OrdNum=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)
	..s OrdNum=OrdNum*10000+count
	..s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.e  d
	..s DicId=""
	..i $d(^CT.CKB.PDSS.CommonDictionI("Link",attrID))	d										//处理之前属性值保存在目录的问题
	...s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Link",attrID,""))
	...s DicAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicId,OrdNumAttrId,""))
	...i DicAttrId=""  d
	....s OrdNum=90000000
	....s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)+count
	...e  d
	....s OrdNum=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DicAttrId)),5)
	....s OrdNum=OrdNum*10000+count
	...s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	..e  d
	...s OrdNum=90000000
	...s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)+count
	...s OrdNum=##class(web.DHCCKBDiction).GetOrdNum(OrdNum)
	.s ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,OrdNum)=attrID_"^"_Text

	Q ""
}

/// Descript:判断是否显示，药品属性的不显示
/// Creator:sufan
/// CreateDate:2020-04-14
/// Input：属性ID
/// w ##class(web.DHCCKBWiki).IsShowAttr(81885)
ClassMethod IsShowAttr(AttrId)
{
	s IsFlag=1
	;s DrugpropId=##class(web.DHCCKBCommon).GetDrugProp()
	;s Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrId)),4)
	;Q:DrugpropId=Parref IsFlag
	;;i (Parref'=DrugpropId)&&('$d(^CT.CKB.PDSS.CommonDictionI("Link",AttrId))) s IsFlag=0
	;Q:IsFlag=0 IsFlag
	i $d(^CT.CKB.PDSS.CommonDictionI("Link",AttrId))  d
	.s DicId=$o(^CT.CKB.PDSS.CommonDictionI("Link",AttrId,""))
	.s Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicId)),4)
	.i (Parref'=DrugpropId) s IsFlag=0
	Q IsFlag
}

/// d ##class(web.DHCCKBWiki).WikiItmToHtml(87396,3909)
ClassMethod WikiItmToHtml(incId, itmId)
{
	
	s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,itmId)
	s Len=$l(attrDesc,$c(10))
	s Title=""
	i Len>1 d			//sufan 2020-04-04 按格式输出
	.for i=1:1:Len  d
	..s TitDesc=$p(attrDesc,$c(10),i)
	..i Title="" s Title="<span>"_TitDesc_"</span><br/>"
	..e  s Title=Title_"<span class='wikis'>"_TitDesc_"</span><br/>"
	e  s Title=attrDesc
	w "<div class='para' ><b>"_"</b>"_Title_"</div>"
}

/// Creator：      kemaolin
/// CreatDate：    2020-02-26
/// Description:	药学分类五级展示
/// d ##class(web.DHCCKBWiki).WikiToHtml(246)
ClassMethod WikiCatItmToHtml(incId, itmId)
{
	s drugCatData=##class(web.DHCCKBCommon).GetDrugCategoryData()
	s attr="" f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",incId,attr)) q:attr=""  d
	.s id=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),3)
	.q:itmId'=id
	.s attrDesc=""
	.s linkDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),4)
	.i linkDicID'="" d
	..;s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDicID)),3)
	..s attrDesc=..getDrugCat(linkDicID,drugCatData)
	.i $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),5)'="" d
	..s attrDesc=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),5)
	.w "<div class='para' ><b>"_"</b>"_attrDesc_"</div>"
}

/// Debug w ##class(web.DHCCKBWiki).getDrugCat(148)
ClassMethod getDrugCat(catID, drugCatData)
{

	q:catID="" ""
	s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(catID)),3)
	s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(catID)),4)
	s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(catID)),5)
	i (desc="")&&(linkDr'="") s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	
	q:parref=drugCatData desc
	q ..getDrugCat(parref,drugCatData)_"->"_desc
}

/// d ##class(web.DHCCKBWiki).CheckAttr()
ClassMethod CheckAttr(incId, itmId)
{
	s ret=0
	q:+incId=0 ret
	s attr="" f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",incId,attr)) q:(attr="")||(ret'=0)  d
	.s id=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),3)
	.q:itmId'=id
	.s ret=1
	q ret
}

/// Descript:知识图谱取数据
/// Creator:sufan
/// Creator:2020-06-02
/// Input:药品ID
/// Output:图数据串
/// w ##class(web.DHCCKBWiki).GetKnowGraphLess(321)
ClassMethod GetKnowGraphLess(IncId)
{
	///根据药品取有规则的目录
	s obj= ##class(%DynamicObject).%New()
    s legend=##class(%DynamicArray).%New()
    s categories=##class(%DynamicArray).%New()
    s nodes=##class(%DynamicArray).%New()
    s links=##class(%DynamicArray).%New()
    k catArr
    s drug = $lg($g(^CT.CKB.PDSS.CommonDictionD(IncId)),3)
    s node = {}
    s node.id = 0
    s node.name = drug
    s node.label = drug
    d nodes.%Push(node)
    
	s drugDictionId = ##class(web.DHCCKBCommon).GetDrugLibaryData()						// 目录字典Id
	s outPropId = ##class(web.DHCCKBCommon).GetDrugPrint()    //输出属性

	s nodeCount = 0
	s ruleDicId = ""
	for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",IncId,ruleDicId))  Q:ruleDicId=""  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)										// 规则Id
	.s catRuleId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDictionId,""))		// 目录一级Id 
	.Q:catRuleId=""    																																						//过滤用药教育
	.s catId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleId)),3)											// 目录Id
	.s catCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),2)
	.s catDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),3)
	.s catIndex = catId _"^"_ catDesc _"^"_ IncId
	.i '$d(catArr(catIndex))  d																														// 存界面导航
	..d legend.%Push(catDesc)
	..s nodeCount = nodeCount+1
	..s node = {}
	..s node.category = nodeCount
   	..s node.id = catId
   	..s node.name = catCode
	..s node.label = catDesc
	..d nodes.%Push(node)
	..s link = {}
	..s link.source = drug
	..s link.target = catCode
   	..s link.name = catDesc
   	..s link.weight = 15
	..d links.%Push(link)
	..s categorie = {}
	..s categorie.name =catDesc
    ..d categories.%Push(categorie)
	..s catArr(catIndex)=ruleId
	.e  d
	..s $p(catArr(catIndex),"^",1)=$p(catArr(catIndex),"^",1)_"^"_ruleId				//存储各目录规则
	s index=""
	for  s index = $o(catArr(index)) Q:index=""  d
	.s ruleCatId  =$p(index,"^",1)
	.s ruleCatCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ruleCatId)),2)
	.s ruleCatDesc  =$p(index,"^",2)
	.s Len = $l(catArr(index),"^")
	.for i=1:1:Len  d
	..s dicRuleId = $p(catArr(index),"^",i)
	..s rightType = ""
	..for  s rightType = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType)) Q:rightType=""  d
	...s rightDic = ""
	...for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic)) Q:rightDic=""  d
	....Q:rightDic=0
	....s ruleDataId = ""
	....for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic,dicRuleId,ruleDataId)) Q:ruleDataId=""  d
	.....s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)	
	.....s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),5)	 		
	.....s ruleRightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)
	.....s ruleRightType = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),10)
	.....s rightValue =$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),9)
	.....Q:leftValue=outPropId
	.....Q:leftDic=""
	.....s nodeCount = nodeCount+1
	.....s node = {}
	.....s node.category = nodeCount
    .....s node.id = leftDic
    .....s node.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightDic)),3)_"&"_ruleCatId
	.....s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightDic)),3)
	.....d nodes.%Push(node)
	.....s link = {}
	.....s link.source = ruleCatCode
	.....s link.target = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightDic)),3)_"&"_ruleCatId
    .....s link.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightDic)),3)
    .....s link.weight = 15
	.....d links.%Push(link)
	..s rightExtType = ""
	..for  s rightExtType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType)) Q:rightExtType=""  d
	...s rightExt = ""
	...for  s rightExt = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,rightExt))  Q:rightExt=""  d
	....Q:rightExt="0"
	....s ruleExtDataId = ""
	....for  s ruleExtDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,+rightExt,dicRuleId,ruleExtDataId))  Q:ruleExtDataId=""  d
	.....s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),4)	
	.....s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),5)	 		
	.....s ruleRightExt = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),11)
	.....s rightValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),9)
	.....s rightLimit = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),12)
	.....s option = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),7)
	.....Q:leftValue=outPropId
	.....Q:leftDic=""
	.....s nodeCount = nodeCount+1
	.....s node = {}
	.....s node.category = nodeCount
    .....s node.id = leftDic
    .....s node.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_"&"_ruleCatId
   	.....i (option = "Equals")||(option = "LessThenEquals")  d
	......s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_rightValue_$lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightExt)),3)
	.....e  i option = "Between"  d
	......s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_rightValue_"~"_rightLimit_$lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightExt)),3)
	.....e  d
	......s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightExt)),3)
	.....d nodes.%Push(node)
	.....s link = {}
	.....s link.source = ruleCatCode
	.....s link.target = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_"&"_ruleCatId
    .....s link.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(+ruleRightExt)),3)
    .....s link.weight = 15
	.....d links.%Push(link)
	
	set obj.nodes = nodes
	set obj.links = links
	set obj.legend = legend
	set obj.categories = categories
	w obj.%ToJSON()
	q ""
}

/// Descript:取各目录规则分支
/// Creator:sufan
/// CreateDate:2020-06-03
/// Input:目录Id^目录^药品，规则列表
/// Output:
/// w ##class(web.DHCCKBWiki).GetRuleBranch("74540^用法^81260","64967")
ClassMethod GetRuleBranch(catList, ruleList)
{
	s obj= ##class(%DynamicObject).%New()
	s nodes=##class(%DynamicArray).%New()
    s links=##class(%DynamicArray).%New()
	s ruleCatId  =$p(catList,"^",1)
	s ruleCatCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ruleCatId)),2)
	s ruleCatDesc  =$p(catList,"^",2)
	s outPropId = ##class(web.DHCCKBCommon).GetDrugPrint()    //输出属性
	s Len = $l(ruleList,"^")
	s nodeCount = 0
	for i=1:1:Len  d
	.s dicRuleId = $p(ruleList,"^",i)
	.s rightType = ""
	.for  s rightType = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType)) Q:rightType=""  d
	..s rightDic = ""
	..for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic)) Q:rightDic=""  d
	...Q:rightDic=0
	...s ruleDataId = ""
	...for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic,dicRuleId,ruleDataId)) Q:ruleDataId=""  d
	....s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),4)	
	....s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),5)	 		
	....s ruleRightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),8)
	....s ruleRightType = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),10)
	....s rightValue =$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataId)),9)
	....Q:leftValue=outPropId
	....Q:leftDic=""
	....s nodeCount = nodeCount+1
	....s node = {}
	....s node.category = nodeCount
    ....s node.id = leftDic
    ....s node.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
	....s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleRightDic)),3)
	....d nodes.%Push(node)
	....s link = {}
	....s link.source = ruleCatCode
	....s link.target = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
    ....s link.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(ruleRightDic)),3)
    ....s link.weight = 15
	....d links.%Push(link)
	.s rightExtType = ""
	.for  s rightExtType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType)) Q:rightExtType=""  d
	..s rightExt = ""
	..for  s rightExt = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,rightExt))  Q:rightExt=""  d
	...Q:rightExt="0"
	...s ruleExtDataId = ""
	...for  s ruleExtDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,+rightExt,dicRuleId,ruleExtDataId))  Q:ruleExtDataId=""  d
	....s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),4)	
	....s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),5)	 		
	....s ruleRightExt = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),11)
	....s rightValue = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),9)
	....s rightLimit = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),12)
	....s option = $lg($g(^CT.CKB.PDSS.RuleDataD(ruleExtDataId)),7)
	....Q:leftValue=outPropId
	....Q:leftDic=""
	....s nodeCount = nodeCount+1
	....s node = {}
	....s node.category = nodeCount
    ....s node.id = leftDic
    ....s node.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
    ....i (option = "Equals")||(option = "LessThenEquals")  d
	.....s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_rightValue_$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleRightExt)),3)
	....e  i option = "Between"  d
	.....s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_rightValue_"~"_rightLimit_$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleRightExt)),3)
	....e  d
	.....s node.label = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)_":"_$lg($g(^CT.CKB.PDSS.CommonDictionD(ruleRightExt)),3)
	....d nodes.%Push(node)
	....s link = {}
	....s link.source = ruleCatCode
	....s link.target = $lg($g(^CT.CKB.PDSS.CommonDictionD(leftDic)),3)
    ....s link.name = $lg($g(^CT.CKB.PDSS.CommonDictionD(ruleRightExt)),3)
    ....s link.weight = 15
	....d links.%Push(link)


	set obj.nodes = nodes
	set obj.links = links
	w obj.%ToJSON()
	q ""
}

/// Creator：      yuliping
/// CreatDate：    2021-06-17
/// Description:： 知识库百科锚点新
/// d ##class(web.DHCCKBWiki).AnchorToHtml(451)
ClassMethod AnchorToHtml(incId)
{
	
	q:incId="" ""
		
	w "<div id='anchor' style='margin-top:20px;width:900px;min-height:100px;'>"
	w "<table>"
	w "<tr>"
	w " <td style='width: 60;padding-left: 20;border-right: 1px solid #f2f2f2;'>目录</td>"
	s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()	//kml 2020-04-01 是否需要维护属性值
	s LinPropId=##class(web.DHCCKBCommon).GetLinkProp()					//sufan 2020-04-01 属性关联ID
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
	d ..GetIncAttrByOrd(pid,incId)										//sufan 2020-04-07 按顺序存储
	k AnchArray
	k AnchNumArray
	s count =0
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index)) Q:Index=""  d
	.// 判断是否需要维护属性值
	.s attrID=+$g(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index))
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	.q:(linkDr'="")&&('$d(^CT.CKB.PDSS.CommonDictionD(linkDr)))
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(attrID))
	.s tmpLinkID="",AddValueId="",AddValueFlag=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID,""))
	.i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	.s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	.q:$g(AddValueFlag)="N"
	.s AttrLinkId=""
	.f  s AttrLinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,attrID,AttrLinkId)) Q:AttrLinkId=""  d
	..Q:$d(AnchArray(attrID))							//sufan 2020-04-01 过滤相同属性
	..s AnchArray(attrID)=attrID
	..s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrLinkId)),6)		//组号
	..Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,LinPropId))&&(GroupFlag'="")
	..i linkDr=""  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	..e  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..i linkDr=""  d
	...s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,attrID) //kml 2020-04-01 过滤值为空的记录
	..e  d
	...s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,linkDr) //kml 2020-04-01 过滤值为空的记录
	..q:attrDesc="" //kml
	..;w " <a herf='#' id='"_code_"' class='anchor-point'>"_desc_"</a>"
	..s count = count+1
	..s AnchNumArray(count) = code_"^"_desc
	
	d ..getArr(count, pid)
	
	//将数据存入每列对应的序号上
	s row = ""
	f  s row = $o(^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,row)) q:row=""  d
	.s coun = ""
	.f  s coun = $o(^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,row,coun)) q:coun=""  d 
	..s ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,row,coun) = AnchNumArray(coun)
	
	
	s index = ""
	f  s index = $o(^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,index)) q:index=""  d
	.s coun = ""
	.w "<td valign='top' style='width:180px;border-right: 1px solid #f2f2f2;padding-left: 20px;'>"
	.f  s coun = $o(^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,index,coun)) q:coun=""  d 
	..s data = ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,index,coun)
	..s code = $p(data,"^",1)
	..s desc = $p(data,"^",2)
	..w " <a herf='#' id='"_code_"' class='anchor-point'>"_coun_"."_desc_"</a></br>"
	.w "</td>"
	w "</table>"
	w "</div>"
    k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
    k ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid)
	Q ""
}

/// 输出4列，计算每列显示多少个
/// w ##class(web.DHCCKBWiki).getArr(22,1)
ClassMethod getArr(count, pid)
{

	s rows = count\4
	s remainder = count#4
	s ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,1)=rows
	s ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,2)=rows
	s ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,3)=rows
	s ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,4)=rows
	f i = 1:1:remainder d
	.s ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,i) =^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,i)+1
	
	s row = "",start =1
	f  s row = $o(^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,row)) q:row=""  d
	.s thisNum = ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,row)
	.i row>1 s start = start+^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,row-1)
	.d ..getRowNumbers(row,pid,thisNum,start)
	q ""
}

/// 输出每列的具体序号
ClassMethod getRowNumbers(row, pid, num, starts)
{
	
	f i=1:1:num  d
	.s ^TMP("DHCCKB","web.DHCCKBWiki","rows",pid,row,i+starts-1) =""
	
	q ""
}

/// Creator：      yuliping
/// CreatDate：    2021-06-18
/// Description:： 相关药品   通用名相同
/// d ##class(web.DHCCKBWiki).writeRelateddrugs(175,2)
ClassMethod writeRelateddrugs(IncId, userInfo = "")
{
  s IncDesc=##class(web.DHCCKBDrugVO).GetGenerName(IncId)_","			//通用名
  s pid=##class(web.DHCCKBCommonUtil).NewPid()
  s version=""
  k DrugDataArr(pid)
  s count=0 
  s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
  d GetDrugInfo
  s DrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药
  d GetDrugInfo
  s DrugData=##class(web.DHCCKBCommon).GetChineseHMData() //中药饮片 kml 2020-04-22
  d GetDrugInfo
  s DrugData=##class(web.DHCCKBCommon).GetChinaMedPrescData() //中药经方 qnp 2021-05-19
  d GetDrugInfo
  w "<div style='height:200px;'><div style='color: #4F9CEE; border-bottom: 1px solid #4f9cee;padding-bottom: 10px;margin-bottom:5px;'> 相关药品"
  i count>8 w "<a style='float:right;font-size: 12px;margin-top: 5;' onclick='window.parent.search()'>更多</a>"
  w "</div>"
  w "<table >"
  b
  s consFlag = 0
  s num = 0
  s consFlag = ""
  f  s consFlag=$o(DrugDataArr(pid,consFlag),-1) q:consFlag=""  d
  .s chkTimes = ""
  .f  s chkTimes = $o(DrugDataArr(pid,consFlag,chkTimes),-1) q:chkTimes=""  d
  ..s dicId = ""
  ..f  s dicId = $o(DrugDataArr(pid,consFlag,chkTimes,dicId)) q:dicId=""  d
  ...s tmp=DrugDataArr(pid,consFlag,chkTimes,dicId)
  ...s num = num+1
  ...q:num>count
  ...q:num>8
  ...s id = $p(tmp,"^",1)
  ...s ProName = $p(tmp,"^",2)
  ...s GenerName= $p(tmp,"^",3)
  ...i GenerName'="" s GenerName="["_GenerName_"]"
  ...s data = ProName_" "_GenerName
  ...s data = $e(data,1,13)
  ...w "<tr><td><div class='dot'></div></td>"
  ...w "<td><a style='color:#333;padding-left:5px;' herf='#' onclick=goCrumb('"_id_"','"_userInfo_"') class='anchor-point'>"_data_"</a></td></tr>"
  
  w "</table></div>"
  q ""
  
GetDrugInfo
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DrugData,id)) q:id=""  d
	.q:+id=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(id))
	.q:IncId=id
	.s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	.q:(version'="Dev")&&('##class(web.DHCCKKBIndex).LimitByContrast(desc, DrugData,userInfo))	// qnp 2021/5/19 增加版本控制，Dev可不过滤对照
	.s contrastFlag = 0  //是否对照
	.s contrastFlag = ##class(web.DHCCKBComContrast).CheckFlag(code,desc,userInfo)
	.s clickTimes = 0  //点击次数
	.s clickTimes = ##class(web.DHCCKBDrugSearchLog).GetDrugClick(id,userInfo)
	.s GenerName=##class(web.DHCCKBDrugVO).GetGenerName(id)			//通用名
	.q:GenerName=""
	.s GenerName=GenerName_","
	.q:IncDesc'[GenerName
	.s ProName=##class(web.DHCCKBDrugVO).GetProName(id)				//商品名
	.s GenerFromName = ##class(web.DHCCKBDrugVO).GetGenerFromName(id) //通用名带剂型
	.s tmp=id_"^"_ProName_"^"_GenerFromName
	.s count=count+1
	.s DrugDataArr(pid,contrastFlag,clickTimes,id)=tmp
	q ""
}

/// Creator：      yuliping
/// CreatDate：    2021-06-18
/// Description:： 相关文献
/// d ##class(web.DHCCKBWiki).writeLiterData(1392)
ClassMethod writeLiterData(IncId)
{
  s liter= ##class(web.DHCCKBDrugVO).GetLiterSupData(IncId)
  i liter="" d
  .w "<div style='color: #4F9CEE; border-bottom: 1px solid #4f9cee;padding-bottom: 10px;margin-bottom:5px;margin-top:50px;'> 相关文献</div>"
  q:liter=""
  s length = $l(liter,",")
	;^CT.CKB.PDSS.CommonDictionI("Code","2007APA强迫性障碍患者治疗的临床实践指南")
  w "<div style='color: #4F9CEE; border-bottom: 1px solid #4f9cee;padding-bottom: 10px;margin-bottom:5px;margin-top:50px;'> 相关文献</div>"
  w "<table>"
  f i=1:1:length d
  .q:i>8
  .s desc = $p(liter,",",i)
  .s descs = $e(desc,1,13)
  .s desc = $$ALPHAUP^SSUTIL4(desc)
  .s bookId = $o(^CT.CKB.PDSS.CommonDictionI("Code",desc,""))   //说明书id
  .s url = ""
  .i bookId'="" s url = ##class(web.DHCCKBDrugVO).GetUrlData(bookId) //说明书url
  .w "<tr><td><div class='dot'></div></td>"
  .w "<td><a style='color:#333;padding-left:5px;' herf='#' onclick=openLiter('"_url_"')>"_i_"."_descs_"</a></td></tr>"
  w "</table>"
  q ""
}

/// Author ：shy
/// Desc   ：获取同源药品列表
/// Input  ：药品ID：DicID
/// Debuger：d ##class(web.DHCCKBWiki).GetLikeDrug(175)
ClassMethod GetLikeDrug(DicID)
{
	q:(DicID="")||(DicID="undefined") ""
	//属性ID数据准备
	s ProNameProp=##class(web.DHCCKBCommon).GetProNameProp()                //商品名
	s GeneralFromProp= ##class(web.DHCCKBCommon).GetGeneralFromProp()       //通用名(带剂型)
	s ChineseGeneralFromProp=##class(web.DHCCKBCommon).GetChineseGeneralFromProp() //Chinese通用名(带剂型)
	s ApprovalNumberProp=##class(web.DHCCKBCommon).GetApprovalNumberProp()  //批准文号
	s DrugManfCom=##class(web.DHCCKBCommon).GetDrugManf()                   //生产厂家
	s ChineseDrugManfCom=##class(web.DHCCKBCommon).GetChineseDrugManf()     //Chinese生产厂家
	s FormPropCom=##class(web.DHCCKBCommon).GetFormProp()                   //剂型
	s SpecificationPropCom=##class(web.DHCCKBCommon).GetSpecificationProp() //规格
	s ComOrignDrugDataCom=##class(web.DHCCKBCommon).GetComOrignDrugData()   //同源药品
	//数据初始化
	s DrugProName=""  
	s DrugManf=""    
	s DrugManfZ=""    
	s DrugFormDic=""    
	s GenalName=""   
	s GenalNameZ=""   
	s MatchSPWH=""  
	s ItmSpecificationype="" 
	//匹配属性
	s DLARowID="" f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",DicID,DLARowID))  q:DLARowID=""  d
	.s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),3)
	.s:AttrCode=ProNameProp DrugProName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)    //商品名
	.s:(AttrCode=GeneralFromProp) GenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)  //通用名（带剂型）
	.s:(AttrCode=ChineseGeneralFromProp) GenalNameZ=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)  //通用名（中成药）
	.s:(AttrCode=ApprovalNumberProp) MatchSPWH=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)      //批准文号
	.s:(AttrCode=DrugManfCom) DrugManf=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)       //生产企业（西药）
	.s:(AttrCode=ChineseDrugManfCom) DrugManfZ=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)       //生产企业（中成药）
	.s:AttrCode=FormPropCom DrugFormDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)       //剂型
	.s:AttrCode=SpecificationPropCom ItmSpecificationype=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)    //规格
	s:GenalName="" GenalName=GenalNameZ
	s:DrugManf="" DrugManf=DrugManfZ
	q:GenalName="" ""   //通用名没数据 不显示表格
	w "<table class='hisui-datagrid' style='width:880px;height:auto' data-options='fitColumns:true'>"
	w "<thead style='width:880px;'> <tr>"
	w "<th  data-options=""field:'code',width:100"">通用名称</th>"   
	w "<th  data-options=""field:'name',width:60"">商品名称</th>"   
	w "<th  data-options=""field:'loc',width:40"">剂型</th>"
	w "<th  data-options=""field:'zd',width:140"">规格</th>"
	w "<th  data-options=""field:'mc',width:140"">批准文号</th>"
	w "<th  data-options=""field:'date',width:150"">生产厂家</th>" 
	w "</tr></thead>"
	w "<tbody>"
	w "<tr><td>"_GenalName_"</td><td>"_DrugProName_"</td><td>"_DrugFormDic_"</td><td>"_ItmSpecificationype_"</td><td>"_MatchSPWH_"</td><td>"_DrugManf_"</td></tr>"  	
	s DLABLRowID="" f  s DLABLRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",DicID,DLABLRowID))  q:DLABLRowID=""  d
	.s AttrCodeBl=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLABLRowID)),3)
	.s ComOriginDrugID=""
	.s:AttrCodeBl=ComOrignDrugDataCom ComOriginDrugID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLABLRowID)),4)
	.i ComOriginDrugID'=""  d 
	..s ItmSpecificationypeBl=""
	..s MatchSPWHBl=""
	..s DLABLComRowID="" f  s DLABLComRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",ComOriginDrugID,DLABLComRowID))  q:DLABLComRowID=""  d
	...s AttrCodeComBl=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLABLComRowID)),3)
	...s:AttrCodeComBl=ApprovalNumberProp MatchSPWHBl=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLABLComRowID)),5)      //批准文号
	...s:AttrCodeComBl=SpecificationPropCom ItmSpecificationypeBl=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLABLComRowID)),5)    //规格
	..w "<tr><td>"_GenalName_"</td><td>"_DrugProName_"</td><td>"_DrugFormDic_"</td><td>"_ItmSpecificationypeBl_"</td><td>"_MatchSPWHBl_"</td><td>"_DrugManf_"</td></tr>"  
	
	w "</tbody></table>"
}

/// Author：shy
/// Desc  ：文献链接获取
/// Input ：url
/// d ##class(web.DHCCKBWiki).GetBookData(84013)
ClassMethod GetBookData(url)
{
	i url=""  d
	.w "<span>请在文献处维护链接！</span>"
	e  d
	.w "<iframe id=""urlpage"" src="_url_" frameBorder=""0"" width=""100%"" scrolling=""no"" height=""100%""></iframe>"
	q ""
}

/// Creator：      Shy
/// CreatDate：    2021-7-27
/// Description:： 知识库百科锚点-右侧动态游标版
/// d ##class(web.DHCCKBWiki).AnchorToHtmlS(451)
ClassMethod AnchorToHtmlS(incId)
{
	
	q:incId="" ""
		
	w "<div id='anchor' style='margin-top:60px;width:220px;height:350px;position:fixed;z-index:1;overflow-y:auto'>"

	w "<ul class='anchor-list'>"
	w "<li style='height:13px'>"
	w " <div class='anchor-circle'></div>"
	w " <span class='anchor-txt'></span>"
	w "</li>"
	s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()	//kml 2020-04-01 是否需要维护属性值
	s LinPropId=##class(web.DHCCKBCommon).GetLinkProp()					//sufan 2020-04-01 属性关联ID
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
	d ..GetIncAttrByOrd(pid,incId)										//sufan 2020-04-07 按顺序存储
	k AnchArray
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index)) Q:Index=""  d
	.// 判断是否需要维护属性值
	.s attrID=+$g(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index))
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	.q:(linkDr'="")&&('$d(^CT.CKB.PDSS.CommonDictionD(linkDr)))
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(attrID))
	.s tmpLinkID="",AddValueId="",AddValueFlag=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID,""))
	.i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	.s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	.q:$g(AddValueFlag)="N"
	.s AttrLinkId=""
	.f  s AttrLinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,attrID,AttrLinkId)) Q:AttrLinkId=""  d
	..Q:$d(AnchArray(attrID))							//sufan 2020-04-01 过滤相同属性
	..s AnchArray(attrID)=attrID
	..s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrLinkId)),6)		//组号
	..Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,LinPropId))&&(GroupFlag'="")
	..i linkDr=""  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	..e  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..i linkDr=""  d
	...s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,attrID) //kml 2020-04-01 过滤值为空的记录
	..e  d
	...s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,linkDr) 
	..q:attrDesc="" //kml
	..w "<li>"
	..w " <div class='circle'></div>"
	..w " <a herf='#' id='"_code_"' class='anchor-point'>"_desc_"</a>"
	..w "</li>"

	w "<li>"
	w " <i class='anchor-circle'></i>"
	w "</li>"
	w "</ul>"
    w "</div>"
    k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
	Q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2021-11-12
/// Description:： 知识库百科明细
/// d ##class(web.DHCCKBWiki).WikiToJson(81885)
ClassMethod WikiToJson(incId)
{
	s wikiJson = ##class(DHCNewPro.COM.Object).%New()
	q:incId="" wikiJson.ToJSON()
	
	s drugCat=##class(web.DHCCKBCommon).GetPhCategory() 				//药学分类 2020-03-31 kml 
	s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()	//kml 2020-04-01 是否需要维护属性值
	s LinPropId=##class(web.DHCCKBCommon).GetLinkProp()					//sufan 2020-04-01 属性关联ID
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
	d ..GetIncAttrByOrd(pid,incId)										//sufan 2020-04-07 按顺序存储								
	k AttrArray
	s Index=""
	for  s Index=$o(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index)) Q:Index=""  d
	.// 判断是否需要维护属性值
	.s attrID=+$g(^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid,incId,Index))
	.s tmpLinkID="",AddValueId="",AddValueFlag=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,IsAddValuePropID,""))
	.i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	.s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	.q:$g(AddValueFlag)="N"
	.
	.s AttrLinkId=""
	.f  s AttrLinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,attrID,AttrLinkId)) Q:AttrLinkId=""  d
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(attrID))
	..Q:$d(AttrArray(attrID))							//sufan 2020-04-01 过滤相同属性
	..s AttrArray(attrID)=attrID
	..s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrLinkId)),6)		//组号
	..Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,LinPropId))&&(GroupFlag'="")
	..s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	..i linkDr=""  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)
	..e  d
	...s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..q:code=""
	..s attrDesc=##class(web.DHCCKBDrugVO).GetDicValueByPro(incId,attrID) //kml 2020-04-01 过滤值为空的记录
	..q:attrDesc=""
	..d wikiJson.Set(code,attrDesc) 
	
	k ^TMP("DHCCKB","web.DHCCKBWiki","GetIncAttrByOrd",pid)
		

	Q wikiJson.ToJSON()
}

}
