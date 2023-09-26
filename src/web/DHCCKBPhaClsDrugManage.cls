Import sqluser

Class web.DHCCKBPhaClsDrugManage Extends %RegisteredObject [ ProcedureBlock ]
{

/// Descript:获取新编药物学分类及分类关联的成分-通用名-药品
/// Creator:sufan
/// CreateDate:2022-08-15
/// Input:
/// Output:树形数据
/// w ##class(web.DHCCKBPhaClsDrugManage).QueryClsLinkDrugsTree(81475)
ClassMethod QueryClsLinkDrugsTree(id)
{
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s dataArr = []
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",id,dicId))  Q:dicId=""  d
	.q:0=##class(web.DHCCKBCommon).IsEnabled(dicId)
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.s linkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),5)
	.i (linkId'="")&&(dicDesc="")  d
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)
	.s dicDesc = dicDesc_"<span style='color:red;'>[分类]</span>"
	.s dicObj = {}
	.d dicObj.%Set("id",dicId)
	.d dicObj.%Set("text",dicDesc)
	.d dicObj.%Set("type","DrugCategory")
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",dicId))  d
	..d dicObj.%Set("state","closed")
	..;d dicObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetTreeSubNode(dicId))
	.e  d
	..d dicObj.%Set("state","closed")
	..d ##class(web.DHCCKBPhaClsDrugManage).OrgDrugLinkData(dicId,pid)
	..d dicObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetLinkData(dicId,pid))
	.d dataArr.%Push(dicObj)
	k ^TMP("DHCCKB","OrgDrugLinkData",pid)
	Q dataArr.%ToJSON()
}

/// Descript:获取下级节点
/// Creator:sufan
/// CreateDate:2022-08-15
/// Input:
/// Output:树形数据
/// w ##class(web.DHCCKBPhaClsDrugManage).GetTreeSubNode(67825).%ToJSON()
ClassMethod GetTreeSubNode(dicId)
{
	s subArr = []
	s subId = ""
	for  s subId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicId,subId))  Q:subId=""  d
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),3)
	.s linkId = $lg($g(^CT.CKB.PDSS.CommonDictionD(subId)),5)
	.i (linkId'="")&&(dicDesc="")  d
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)
	.s subObj = {}
	.d subObj.%Set("id",subId)
	.d subObj.%Set("text",dicDesc)
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",subId))  d
	..d subObj.%Set("state","closed")
	..d subObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetTreeSubNode(subId))
	.e   d
	..d subObj.%Set("state","closed")
	..d subObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetCatLinkData(subId))
	.d subArr.%Push(subObj)
	Q subArr
}

/// w ##class(web.DHCCKBPhaClsDrugManage).GetLinkData(67695,1).%ToJSON()
ClassMethod GetLinkData(catId, pid)
{
	s genArr = []
	s genindex = ""
	for  s genindex = $o(^TMP("DHCCKB","OrgDrugLinkData",pid,catId,genindex))  Q:genindex=""  d
	.s genObj = {}
	.i +genindex'=0  d
	..s genDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(genindex)),3)
	..s genDesc = genDesc_"<span style='color:red;'>[化学名]</span>"
	..d genObj.%Set("id",genindex)
	..d genObj.%Set("text",genDesc)
	..d genObj.%Set("type","GenerNameProp")
	..d genObj.%Set("state","closed")
	..d genArr.%Push(genObj)
	.s ingArr = []
	.s ingIndex = ""
	.for  s ingIndex = $o(^TMP("DHCCKB","OrgDrugLinkData",pid,catId,genindex,ingIndex))  Q:ingIndex=""  d
	..s ingObj = {}
	..i +ingIndex'=0  d
	...s ingDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingIndex)),3)
	...s ingDesc = ingDesc_"<span style='color:red;'>[成分]</span>"
	...d ingObj.%Set("id",ingIndex)
	...d ingObj.%Set("text",ingDesc)
	...d ingObj.%Set("type","IngredientCode")
	...d ingObj.%Set("state","closed")
	..s genFormArr = []
	..s genFormIndex = ""
	..for  s genFormIndex = $o(^TMP("DHCCKB","OrgDrugLinkData",pid,catId,genindex,ingIndex,genFormIndex))  Q:genFormIndex=""    d
	...s genFormObj = {}
	...i +genFormIndex'=0  d
	....s genFormDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(genFormIndex)),3)
	....s genFormDesc = genFormDesc_"<span style='color:red;'>[通用名]</span>"
	....d genFormObj.%Set("id",genFormIndex)
	....d genFormObj.%Set("text",genFormDesc)
	....d genFormObj.%Set("type","GenerNameFormProp")
	....d genFormArr.%Push(genFormObj)
	..d ingObj.%Set("children",genFormArr)
	..d ingArr.%Push(ingObj)
	.d genObj.%Set("children",ingArr)
	Q genArr
}

/// Descript:取成分
/// Creator:sufan
/// CreateDate:2022-08-15
/// Input:
/// Output:树形数据
/// w ##class(web.DHCCKBPhaClsDrugManage).GetCatLinkData(49912).%ToJSON()
ClassMethod GetCatLinkData(dicId)
{
	
	s linkArr = []
	s generNameId = ##class(web.DHCCKBCommon).GetDrugGenerName()			//化学名
	s ingredientId = ##class(web.DHCCKBCommon).GetIngredientCode()			//成分
	s generalFromId = ##class(web.DHCCKBCommon).GetGeneralFromProp()		//通用名
	s attrId = ""	
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",dicId,attrId))  Q:attrId=""  d
	.s drugId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generNameId))  d
	..s genAttrId = ""
	..for  s genAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generNameId,genAttrId))  Q:genAttrId=""  d
	...s genId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(genAttrId)),4)
	...s genCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(genId)),2)
	...s genDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(genId)),3)
	...s genDesc = genDesc_"<span style='color:red;'>化学名</span>"
	...s genObj = {}
	...d genObj.%Set("id",genId)
	...d genObj.%Set("text",genDesc)
	...d genObj.%Set("type","GenerNameProp")
	...i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId))  d
	....d genObj.%Set("state","closed")
	....d genObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkIngrData(drugId))
	...e   i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	....d genObj.%Set("state","closed")
	....d genObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkGenFormData(drugId))
	...d linkArr.%Push(genObj)	
	.e  i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId))  d
	..s ingAttrId = ""
	..for  s ingAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId,ingAttrId))  Q:ingAttrId=""   d
	...s ingrId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(ingAttrId)),4)
	...Q:ingrId=""
	...s ingCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingrId)),2)
	...s ingDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingrId)),3)
	...s ingDesc = ingDesc_"<span style='color:red;'>成分</span>"
	...s ingObj = {}
	...d ingObj.%Set("id",ingrId)
	...d ingObj.%Set("text",ingDesc)
	...d ingObj.%Set("type","IngredientCode")
	...i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	....d ingObj.%Set("state","closed")
	....d ingObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkGenFormData(drugId))
	...d linkArr.%Push(ingObj)
	.e  d
	..s linkArr = ##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkGenFormData(drugId)
 	Q linkArr
}

/// Descript:取成分
/// Creator:sufan
/// CreateDate:2022-08-15
/// w ##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkIngrData(261).%ToJSON()
ClassMethod GetDrugLinkIngrData(drugId)
{
	s generNameId = ##class(web.DHCCKBCommon).GetDrugGenerName()			//化学名
	s generalFromId = ##class(web.DHCCKBCommon).GetGeneralFromProp()		//通用名
	s ingredientId = ##class(web.DHCCKBCommon).GetIngredientCode()			//成分
	s ingArr = []
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId))  d
	.s ingAttrId = ""
	.for  s ingAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId,ingAttrId))  Q:ingAttrId=""  d
	..s ingId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(ingAttrId)),4)
	..Q:ingId=""
	..s ingCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingId)),2)
	..s ingDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingId)),3)
	..s ingDesc = ingDesc_"<span style='color:red;'>成分</span>"
	..s ingObj = {}
	..d ingObj.%Set("id",ingId)
	..d ingObj.%Set("text",ingDesc)
	..d ingObj.%Set("type","Ingredient")
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	...d ingObj.%Set("state","closed")
	...d ingObj.%Set("children",##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkGenFormData(drugId))
	..d ingArr.%Push(ingObj)	
	e  d
	.s ingArr =  ##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkGenFormData(drugId)
	Q ingArr
}

/// Descript:取成分
/// Creator:sufan
/// CreateDate:2022-08-15
/// w ##class(web.DHCCKBPhaClsDrugManage).GetDrugLinkGenFormData(150).%ToJSON()
ClassMethod GetDrugLinkGenFormData(drugId)
{
	s generalFromId = ##class(web.DHCCKBCommon).GetGeneralFromProp()		//通用名
	s genFormArr = []
	s genFormAttrId = ""
	for  s genFormAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId,genFormAttrId))  Q:genFormAttrId=""  d
	.s genFormId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(genFormAttrId)),4)
	.s genFormCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(genFormId)),2)
	.s genFormDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(genFormId)),3)
	.s genFormDesc = genFormDesc_"<span style='color:red;'>通用名</span>"
	.s genFormObj = {}
	.d genFormObj.%Set("id",genFormId)
	.d genFormObj.%Set("text",genFormDesc)
	.d genFormObj.%Set("type","GenerNameFormProp")
	.d genFormArr.%Push(genFormObj)
	Q genFormArr
}

/// Descript:根据属性值获取药品列表
/// w ##class(web.DHCCKBPhaClsDrugManage).QueryDrugList("30","1","25980","","^^^DrugCategory")
ClassMethod QueryDrugList(rows, page, Id, params, catstr = "")
{
	
	q:Id="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) 
	
	S end = page*rows
	S start=(page-1)*rows+1
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	s drugname = $p(params,"^",1)
	s gename = $p(params,"^",2)
	s manfname = $p(params,"^",3)
	
	s ingreId = $p(catstr,"^",1)
	s geneId = $p(catstr,"^",2)
	s cateId = $p(catstr,"^",3)
	s type = $p(catstr,"^",4)
	k drugArr
	s count=0
	
	/*药学分类需要展示所有子分类关联药品*/
	s idList = $lb(Id)
	i type="DrugCategory" d 
	.d ##Class(web.DHCCKBCommon).GetChildCat(.idList,Id,1)
	
	w "{""rows"":["
	f i=1:1:$ll(idList)  d
	.s tmpId = $lg(idList,i)	
	.s attrId = ""	
	.for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",tmpId,attrId))  Q:attrId=""  d
	..s drugId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	..q:drugId=""
	..Q:$d(drugArr(drugId))
	..s drugArr(drugId) = drugId
	..s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),2)
	..s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),3)
	..s parentId = $lg($g(^CT.CKB.PDSS.CommonDictionD(drugId)),4)
	..s generFromName = ##class(web.DHCCKBDrugVO).GetGenerFromName(drugId) 			//通用名带剂型
	..s generName=##class(web.DHCCKBDrugVO).GetGenerName(drugId)			//通用名
	..s proName=##class(web.DHCCKBDrugVO).GetProName(drugId)				//商品名
	..s prop =##class(web.DHCCKBDrugVO).GetSpecificationProp(drugId)     //规格
	..s facturer=##class(web.DHCCKBDrugVO).GetManufacturer(drugId)
	..s formType=##class(web.DHCCKBDrugVO).GetFormType(drugId)
	..s ingCatePropId = ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientCateProp")
	..s ingCateIdList = ##class(web.DHCCKBPhaClsDrugManage).GetAppointAttrVal(drugId,ingCatePropId)
	..s genCatePropId = ##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameCateProp")
	..s genCateIdList = ##class(web.DHCCKBPhaClsDrugManage).GetAppointAttrVal(drugId,genCatePropId)
	..s appCatePropId = ##class(web.DHCCKBCommon).GetDicIdByCode("AppointCateProp")
	..s appCateIdList = ##class(web.DHCCKBPhaClsDrugManage).GetAppointAttrVal(drugId,appCatePropId)
	..s ingreNum = ##class(web.DHCCKBPhaClsDrugManage).GetIngreNum(drugId)
	..Q:(type="GenerNameFormProp")&&(ingreNum>1)&&(ingCateIdList'="")&&(ingCateIdList'[ingreId)
	..Q:(type="GenerNameFormProp")&&(ingreNum>1)&&(genCateIdList'="")&&(genCateIdList'[geneId)
	..Q:(type="GenerNameFormProp")&&(ingreNum>1)&&(appCateIdList'="")&&(appCateIdList'[cateId)
	..Q:(type="IngredientCode")&&(ingreNum>1)&&(genCateIdList'="")&&(genCateIdList'[geneId)
	..Q:(type="IngredientCode")&&(ingreNum>1)&&(appCateIdList'="")&&(appCateIdList'[cateId)
	..Q:(type="GenerNameProp")&&(ingreNum>1)&&(appCateIdList'="")&&(appCateIdList'[cateId)
	..Q:(drugname'="")&&(drugDesc'[drugname)
	..Q:(gename'="")&&(generFromName'[gename)
	..Q:(manfname'="")&&(facturer'[manfname)
	..s count=count+1
	..q:count<start
	..q:count>end
	..w $case(count,start:"",:",")
	..s tmpObj={}
	..s tmpObj.drugId = drugId
	..s tmpObj.drugCode = drugCode
	..s tmpObj.drugDesc = drugDesc
	..s tmpObj.prop = prop
	..s tmpObj.formType = formType
	..s tmpObj.proName = proName
	..s tmpObj.generFromName = generFromName
	..s tmpObj.generName = generName
	..s tmpObj.facturer = facturer
	..s tmpObj.parentId = parentId
	..w tmpObj.%ToJSON()
	w "],""total"":"_count_"}"
	Q ""
}

/// Descript:将某分类下的数据按照化学名、成分、通用名存储
/// w ##class(web.DHCCKBPhaClsDrugManage).OrgDrugLinkData(260199,1)
ClassMethod OrgDrugLinkData(catId, pid)
{
	s generNameId = ##class(web.DHCCKBCommon).GetDrugGenerName()			//化学名
	s ingredientId = ##class(web.DHCCKBCommon).GetIngredientCode()			//成分
	s generalFromId = ##class(web.DHCCKBCommon).GetGeneralFromProp()		//通用名
	s ingCatePropId = ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientCateProp")
	s appCatePropId = ##class(web.DHCCKBCommon).GetDicIdByCode("AppointCateProp")
	s genCatePropId = ##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameCateProp")
	s attrId = ""	
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",catId,attrId))  Q:attrId=""  d
	.s drugId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	.s levId = ##class(web.DHCCKBPhaClsDrugManage).GetAppointAttrVal(drugId,appCatePropId)
	.s ingreNum = ##class(web.DHCCKBPhaClsDrugManage).GetIngreNum(drugId)
	.Q:(ingreNum>1)&&(levId'="")&&(levId'[catId)
	.i ingreNum>1   d
	..s aptgenId = "A",aptingId = "B"
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,genCatePropId))  d
	...s genCatAttrId = ""
	...for  s genCatAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,genCatePropId,genCatAttrId))  Q:genCatAttrId=""  d
	....s genCatId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(genCatAttrId)),4)
	....q:0=##class(web.DHCCKBCommon).IsEnabled(genCatId)
	....s genCatCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(genCatId)),2)
	....s genCatDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(genCatId)),3)
	....s genCatDesc = genCatDesc_"<span style='color:red;'>化学名</span>"
	....i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingCatePropId))  d
	.....d ##class(web.DHCCKBPhaClsDrugManage).OrgIngData(drugId,catId,genCatId,pid)
	....e  d
	.....d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,"A","B",pid)	
	..e  i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingCatePropId))  d
	...s ingCatAttrId = ""
	...for  s ingCatAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingCatePropId,ingCatAttrId))  Q:ingCatAttrId=""   d
	....s ingrCatId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(ingCatAttrId)),4)
	....Q:ingrCatId=""
	....q:0=##class(web.DHCCKBCommon).IsEnabled(ingrCatId)
	....s ingCatCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingrCatId)),2)
	....s ingCatDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingrCatId)),3)
	....s ingCatDesc = ingCatDesc_"<span style='color:red;'>成分</span>"
	....i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	.....d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,"A",ingrCatId,pid)
	..e  d
	...d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,"A","B",pid)	
	.e  d
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generNameId))  d
	...s genAttrId = ""
	...for  s genAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generNameId,genAttrId))  Q:genAttrId=""  d
	....s genId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(genAttrId)),4)
	....q:0=##class(web.DHCCKBCommon).IsEnabled(genId)
	....s genCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(genId)),2)
	....s genDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(genId)),3)
	....s genDesc = genDesc_"<span style='color:red;'>化学名</span>"
	....i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId))  d
	.....d ##class(web.DHCCKBPhaClsDrugManage).OrgIngData(drugId,catId,genId,pid)
	....e  d
	.....d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,"A","B",pid)	
	..e  i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId))  d
	...s ingAttrId = ""
	...for  s ingAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId,ingAttrId))  Q:ingAttrId=""   d
	....s ingrId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(ingAttrId)),4)
	....Q:ingrId=""
	....q:0=##class(web.DHCCKBCommon).IsEnabled(ingrId)
	....s ingCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingrId)),2)
	....s ingDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingrId)),3)
	....s ingDesc = ingDesc_"<span style='color:red;'>成分</span>"
	....i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	.....d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,"A",ingrId,pid)
	..e  d
	...d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,"A","B",pid)
 	Q ""
}

/// w ##class(web.DHCCKBPhaClsDrugManage).OrgIngData(205,67695,67696,2)
ClassMethod OrgIngData(drugId, catId, genId, pid)
{
	s generNameId = ##class(web.DHCCKBCommon).GetDrugGenerName()			//化学名
	s generalFromId = ##class(web.DHCCKBCommon).GetGeneralFromProp()		//通用名
	s ingredientId = ##class(web.DHCCKBCommon).GetIngredientCode()			//成分
	s ingCatePropId = ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientCateProp")
	s ingreNum = ##class(web.DHCCKBPhaClsDrugManage).GetIngreNum(drugId)
	i ingreNum<2  d
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId))  d
	..s ingAttrId = ""
	..for  s ingAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId,ingAttrId))  Q:ingAttrId=""  d
	...s ingId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(ingAttrId)),4)
	...Q:ingId=""
	...s ingCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingId)),2)
	...s ingDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingId)),3)
	...s ingDesc = ingDesc_"<span style='color:red;'>成分</span>"
	...i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	....d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,genId,ingId,pid)
	.e  d
	..d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,genId,"B",pid)
	e  d
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingCatePropId))  d
	..s ingAttrId = ""
	..for  s ingAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingCatePropId,ingAttrId))  Q:ingAttrId=""  d
	...s ingId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(ingAttrId)),4)
	...Q:ingId=""
	...s ingCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingId)),2)
	...s ingDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(ingId)),3)
	...s ingDesc = ingDesc_"<span style='color:red;'>成分</span>"
	...i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	....d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,genId,ingId,pid)
	.e  d
	..d ##class(web.DHCCKBPhaClsDrugManage).OrgFormGenData(drugId,catId,genId,"B",pid)
	Q ""
}

ClassMethod OrgFormGenData(drugId, catId, genId, ingId, pid)
{
	s generalFromId = ##class(web.DHCCKBCommon).GetGeneralFromProp()		//通用名
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId))  d
	.s genFormAttrId = ""
	.for  s genFormAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,generalFromId,genFormAttrId))  Q:genFormAttrId=""  d
	..s genFormId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(genFormAttrId)),4)
	..s genFormCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(genFormId)),2)
	..s genFormDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(genFormId)),3)
	..s genFormDesc = genFormDesc_"<span style='color:red;'>通用名</span>"
	..s ^TMP("DHCCKB","OrgDrugLinkData",pid,catId,genId,ingId,genFormId)=""
	e  d
	.s ^TMP("DHCCKB","OrgDrugLinkData",pid,catId,genId,ingId,"C")=""
	Q ""
}

/// Descript:判断成分数量，复方制剂显示成分分类
/// w ##class(web.DHCCKBPhaClsDrugManage).GetIngreNum(49912)
ClassMethod GetIngreNum(drugId)
{
	s ingredientId = ##class(web.DHCCKBCommon).GetIngredientCode()			//成分
	s count = 0
	s index = ""
	for  s index = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,ingredientId,index))  Q:index=""  d
	.s count = count+1
	Q count
}

/// 获取维护的分类数据
ClassMethod GetAppointAttrVal(drugId, proId)
{
	s ret = ""
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,proId,attrId))  Q:attrId=""  d
	.s provalId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	.i ret = provalId
	.e  s ret = ret_","_provalId
	Q ret
}

}
