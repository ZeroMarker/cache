Import sqluser

/// Creator：      zhouxin
/// CreatDate：    2019-07-3
/// Description:： 获取药品属性值的类
Class web.DHCCKBDrugVO Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// 获取适应症
/// w ##class(web.DHCCKBDrugVO).GetIndication()
ClassMethod GetIndication(inc)
{
	n (inc)
	s Indic=##class(web.DHCCKBCommon).GetDrugIndic()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,Indic)
}

/// 获取禁忌症
/// w ##class(web.DHCCKBDrugVO).GetContraindication()
ClassMethod GetContraindication(inc)
{
	n (inc)
	s Contr=##class(web.DHCCKBCommon).GetDrugContr()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,Contr)
}

/// 获取药品的成分
/// w ##class(web.DHCCKBDrugVO).GetIngredient("3805")
ClassMethod GetIngredient(inc)
{
	n (inc)
	s Ingredient=##class(web.DHCCKBCommon).GetDrugIngredient()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,Ingredient)
}

/// 获取药品的化学名
/// w ##class(web.DHCCKBDrugVO).GetGenerName(150)
ClassMethod GetGenerName(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetDrugGenerName()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的通用名
/// w ##class(web.DHCCKBDrugVO).GetDrugGenerName(150)
ClassMethod GetDrugGenerName(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetGeneralFromProp()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的规格
/// w ##class(web.DHCCKBDrugVO).GetSpecificationProp(122703)
ClassMethod GetSpecificationProp(inc)
{
	
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetSpecificationProp()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的批准文号
/// w ##class(web.DHCCKBDrugVO).GetAproNum(122703)
ClassMethod GetAproNum(inc)
{
	
	n (inc)
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,78015)
}

/// 获取药品的商品名
/// w ##class(web.DHCCKBDrugVO).GetProName(81486)
ClassMethod GetProName(inc)
{
	n (inc)
	s proName=##class(web.DHCCKBCommon).GetProNameProp()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,proName)
}

/// w ##class(web.DHCCKBDrugVO).GetDicValueByPro(50018,3909)
/// w ##class(web.DHCCKBDrugVO).GetDicValueByPro(109560,72)
ClassMethod GetDicValueByPro(incId, pro, flag = "")
{
	n (incId,pro,flag)
	q:+pro=0 ""
	s ret="",LinkRet=""
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",pro,LinkPropId))  d		//属性关联
	.s LinkRet=..GetPropTempData(incId, pro)

	s ret=..GetPropLinkData(incId, pro)							//取属性值
	
	s linkPro = ""	
	i ($d(^CT.CKB.PDSS.CommonDictionI("Link",pro)))&&(ret="")  d				//sufan 2020-07-09取link的属性
	.for  s linkPro = $o(^CT.CKB.PDSS.CommonDictionI("Link",pro,linkPro)) 	Q:(linkPro="")||(ret'="")  d
	..s ret=..GetPropLinkData(incId, linkPro)	
    
	i LinkRet'=""  d
	.i ret="" s ret=LinkRet
	.e  s ret=ret_","_LinkRet
	i (flag=1){			//sufan 2020-05-11 导航去掉换行符
		s ret=$replace(ret,"<br/>","")
		s Len=$l(ret)
		i (Len>90) d
		.s ret=$e(ret,0,90)_"..."
	}
	
	//s oldret=..GetPropLinkData(incId, pro)  //兼容处理
	//s:(ret="")&&(oldret'="") ret=..GetPropLinkData(incId, pro)
	Q ret
}

/// 取直接与属性关联的数据
/// w ##class(web.DHCCKBDrugVO).GetPropLinkData(50018,3909)
ClassMethod GetPropLinkData(incId, pro)
{
	n (incId, pro)
	q:(+incId=0)||(+pro=0) ""
	s ret="",count=0,attrDesc=""  ;Shy 2020-01-09 知识浏览器界面bug
	s attr="" f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,pro,attr)) q:attr=""  d
	.s linkDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),4)
	.i linkDr'="" s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	.i $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),5)'="" s attrDesc=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),5)
	.Q:attrDesc=""
	.s count=count+1
	.s $p(ret,",",count)=attrDesc
	q ret
}

/// Creator:sufan
/// CreateDate:2020-03-05
/// Descript:取直接与属性模板关联数据
/// w ##class(web.DHCCKBDrugVO).GetPropTempData(390,39)
ClassMethod GetPropTempData(incId, pro)
{
	n (incId,pro)
	s LinkFlag=##class(web.DHCCKBCommon).GetDicIdByCode("EqFromUnitProp")  //从单位
	q:+pro=0 ""
	k GroupArr
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",pro,LinkPropId,""))
	s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	s subId=""
	for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId),-1)  Q:subId=""  d	//取模板数据
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,subId,AttrId),-1)  Q:AttrId=""  d
	..s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),3)
	..s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	..s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)
	..s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)
	..s Desc=""
	..s:dicAttrId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	..s:dicAttrCode=LinkFlag Desc="/"_Desc
	..i dicAttrId'="" s ListData=Desc
	..e  s ListData=dicRes
	..q:GroupFlag=""
	..i $d(GroupArr(GroupFlag))  d
	...s GroupArr(GroupFlag)=GroupArr(GroupFlag)_ListData
	..e  d
	...s GroupArr(GroupFlag)=ListData
	
	s QuitList=""
	s PropDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(pro)),3)
	s Index=""
	for  s Index=$o(GroupArr(Index))  Q:Index=""  d
	.s data=GroupArr(Index)
	.i QuitList=""  s QuitList=data
	.e  s QuitList=QuitList_","_data
	k GroupArr
	Q QuitList
}

/// 清除药品的关联属性值
/// w ##class(web.DHCCKBDrugVO).CleanDrugPropValue(301,69)
ClassMethod CleanDrugPropValue(incId, pro)
{
	n (incId,pro)
	
	&sql(delete CT_CKB_PDSS.DicLinkAttr where DLA_Dic_Dr=:incId And DLA_AttrCode=:pro)
	
	q SQLCODE
	
	s attr=""
	f  s attr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",incId,pro,attr))  q:attr=""  d
	.q:attr=0
	.&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_RowID=:attr)
}

/// 获取药品的剂型
/// w ##class(web.DHCCKBDrugVO).GetFormType(179)
ClassMethod GetFormType(inc)
{
	n (inc)
	s FormType=##class(web.DHCCKBCommon).GetDrugForm()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,FormType)
}

/// 获取药品的生产企业
/// w ##class(web.DHCCKBDrugVO).GetManufacturer()
ClassMethod GetManufacturer(inc)
{
	n (inc)
	s Manufacturer=##class(web.DHCCKBCommon).GetDrugManf()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,Manufacturer)
}

/// Descript:取功能主治
/// CreateDate:2020-07-09
/// Creator:sufan
ClassMethod GetFunIndicat(inc)
{
	n (inc)
	s FunIndicat = ##class(web.DHCCKBCommon).GetFunIndicat()
	Q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,FunIndicat,1)
}

/// Descript:取禁忌
/// CreateDate:2020-07-09
/// Creator:sufan
/// w ##class(web.DHCCKBDrugVO).GetDrugContra(3805)
ClassMethod GetDrugContra(inc)
{
	n (inc)
	s DrugContra = ##class(web.DHCCKBCommon).GetDrugContra()
	Q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,DrugContra,1)
}

/// 获取药品的带剂型的通用名
/// w ##class(web.DHCCKBDrugVO).GetGenerFromName(74569)
ClassMethod GetGenerFromName(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetGeneralFromProp()
	
	q ##class(web.DHCCKBEditProp).QueryAttrValue(inc,GenerName)   //shy
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的分类(显示层级)
/// w ##class(web.DHCCKBDrugVO).GetCat(1584)
/// Creator:sufan
ClassMethod GetCat(inc)
{
	n (inc)
	s catPropId = ##class(web.DHCCKBCommon).GetPhCategory()
	s linkId = $o(^CT.CKB.PDSS.CommonDictionI("Link",catPropId,""))
	s ret = ""
	s ret = ##class(web.DHCCKBDrugVO).GetDrugCat(inc,catPropId)
	i ret=""  d
	.s ret = ##class(web.DHCCKBDrugVO).GetDrugCat(inc,linkId)
	q ret
}

/// w ##class(web.DHCCKBDrugVO).GetDrugCat(158,38)
ClassMethod GetDrugCat(inc, catPropId)
{
	n (inc,catPropId)
	s attrId = "",ret = "",catIdList = ""
	
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",inc,catPropId,attrId))  Q:attrId=""  d
	.s catId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	.s catDesc = ..GetCatHier(catId)
	.Q:catDesc=""
	.i ret = "" s ret = catDesc
	.e  s ret = ret _"^"_catDesc
	.i catIdList = "" s catIdList = catId
	.e  s catIdList = catIdList _"^"_catId
	Q ret_"$"_catIdList
}

/// w ##class(web.DHCCKBDrugVO).GetCatHier(147)
ClassMethod GetCatHier(catId, list = "")
{
	n (catId,list)
	Q:catId="" ""
	s linkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),5)
	s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),3)
	i (desc="")&&(linkId'="")  d
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)
	i list = "" s list = desc
	e  s list = desc_"/"_list
	s parrId = $lg($g(^CT.CKB.PDSS.CommonDictionD(catId)),4)
	Q:parrId=106 list
	s list = ..GetCatHier(parrId,.list)
	Q list
}

/// Descript：取药品厂家信息
/// Creator:sufan
/// CreateDate:2020-10-09
/// w ##class(web.DHCCKBDrugVO).GetDrugManuf(104070)
ClassMethod GetDrugManuf(inc)
{
	n (inc)
	s manPropId = ##class(web.DHCCKBCommon).GetDrugManf()			//厂家属性
	s ret = ""
	s ret = ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,manPropId)
	
	i ret=""  d
	.s linkId = $o(^CT.CKB.PDSS.CommonDictionI("Link",manPropId,""))
	.s ret = ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,linkId)
	q ret
}

/// Descript:获取药品的等效单位
/// Creator:sufan
/// CreateDate:2020-10-09
/// w ##class(web.DHCCKBDrugVO).GetEquunit(1392)
ClassMethod GetEquunit(inc)
{
	n (inc)
	s EquunitProp = ##class(web.DHCCKBCommon).GetEqUnitProp()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,EquunitProp)
}

/// 获取药品的饮片名称
/// w ##class(web.DHCCKBDrugVO).GetHerbalMedName(112807)
ClassMethod GetHerbalMedName(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetchHerbalMedName()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的功能主治
/// w ##class(web.DHCCKBDrugVO).GetFunIndicatNew(112807)
ClassMethod GetFunIndicatNew(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetFunIndicatNew()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的拉丁名
/// w ##class(web.DHCCKBDrugVO).getLatinNameProp(112807)
ClassMethod getLatinNameProp(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetLatinNameProp()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的功效
/// w ##class(web.DHCCKBDrugVO).GetEfficacyProp(112807)
ClassMethod GetEfficacyProp(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetEfficacyProp()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的方剂组成
/// w ##class(web.DHCCKBDrugVO).GetPrescContent(112807)
ClassMethod GetPrescContent(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetPrescContent()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的主治病证
/// w ##class(web.DHCCKBDrugVO).GetPrescTreatDisease(112807)
ClassMethod GetPrescTreatDisease(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetPrescTreatDisease()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取药品的通用名
/// w ##class(web.DHCCKBDrugVO).GetLiterSupData(1392)
ClassMethod GetLiterSupData(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetLiterSupData()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

/// 获取文献url
/// w ##class(web.DHCCKBDrugVO).GetUrlData(122924)
ClassMethod GetUrlData(inc)
{
	n (inc)
	s GenerName=##class(web.DHCCKBCommon).GetUrlData()
	q ##class(web.DHCCKBDrugVO).GetDicValueByPro(inc,GenerName)
}

}
