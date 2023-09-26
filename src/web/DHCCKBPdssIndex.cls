Class web.DHCCKBPdssIndex Extends %RegisteredObject
{

/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Description:： 药学分类
/// w ##class(web.DHCCKBPdssIndex).queryDrugCat()
ClassMethod queryDrugCat()
{
	// { state:'',msg: '查询成功',data: [{}]}
	
	s resObj = {}
	s resObj.state = "200"
	s resObj.msg = "查询成功"
	
	s $ZT = "ErrQueryDrugCat"
	s dataArr = []
	// 				西药分类 中成药分类	饮片分类
	s typelist = $lb("xy","zcy","yp")
	f i=1:1:$ll(typelist)  d
	.s catObj = ..getCatType($lg(typelist,i)) 
	.d dataArr.%Push(catObj)
	
	s resObj.data = dataArr
	q resObj.%ToJSON()
	
ErrQueryDrugCat
	s resObj.state = "-104"
	s resObj.msg = $ZE
	
	q resObj.%ToJSON()
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Description:： 获取指定类型的药学分类
/// d ##class(web.DHCCKBPdssIndex).QueryDrugCat()
ClassMethod getCatType(type)
{
 
	// {id: 'xiyao',type:'xy',typeName: '西药',data:[{}]}
	// type不能改变，和前台约定
	s typeArr("xy")="NewDrugCat:新编药物学分类:西药"
	s typeArr("zcy")="中成药分类:中成药分类:中成药"
	s typeArr("yp")="饮片分类:饮片分类:饮片"
        
    s typestr = $g(typeArr(type)) 
	s resObj = {}
	s id = ##class(web.DHCCKBCommon).GetDicIDByCodeAndDesc($p(typestr,":",1),$p(typestr,":",2))
	s resObj.id = id
	s resObj.type = type
	s resObj.typeName = $p(typestr,":",3)
	s resObj.data = []
	q:##class(web.DHCCKBCommon).IsEnabled(id)=0 resObj.%ToJSON() // 停用
	s data= ..getCatByNode(id)
	s resObj.data = data
		
	q resObj
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Description:： 获取指定节点下所有的药学分类
/// d ##class(web.DHCCKBPdssIndex).getCatByNode(149).%ToJSON()
ClassMethod getCatByNode(parref)
{
 
	//{id: 1,code: 1,name: '抗感染药物',children[]}

	s resArr = []
	s catID = ""
	f  s catID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:##class(web.DHCCKBCommon).IsEnabled(catID)=0	
	.s resObj = {}
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),2)
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),3)
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+catID)),4)
	.i (linkDr'="")&&(code="") d
	..s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),2)
	..s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	.
	.s resObj.id = catID
	.s resObj.code = code
	.s resObj.name = desc 
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",catID))  d
	..s resObj.children = ..getCatByNode(catID)
	.
	.d resArr.%Push(resObj)
	
	q resArr
}

/// Description:： 通过指定类型,查询药品列表
/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Input:
/// 			page 第几页
/// 			rows 一页多少行
/// 			queryType 查询类型(cat分类,genername通用名,proname化学名,ingr成分)
/// 			queryStr 查询条件(id或录入的文本)
/// 			cattype(xy西药,zcy中成药,cy草药)  --当queryType是分类时，需要区分具体的分类类型
/// w ##class(web.DHCCKBPdssIndex).queryDrugListByType(1,10,"cat","149","11863^8^1^291^2")
/// w ##class(web.DHCCKBPdssIndex).queryDrugListByType("1","12","drug","阿莫西林","11863^8^1^293^2")
/// w ##class(web.DHCCKBPdssIndex).queryDrugListByType("1","12","cat","147","11863^8^1^293^2")
/// w ##class(web.DHCCKBPdssIndex).queryDrugListByType("1","12","cat","122226","11863^8^1^293^2","zcy")
/// w ##class(web.DHCCKBPdssIndex).queryDrugListByType("1","12","cat","147","18175^9^179^383^2","xy")
ClassMethod queryDrugListByType(page = 1, rows = 12, queryType, queryStr, userInfo, cattype = "")
{

	s start=(page-1)*rows+1
  	s end=page*rows
  	s stDate = $p($zts,",",2)
	s resObj = {}
	s resObj.state = 200
    s resObj.msg = "查询成功"
    	
	s $ZT = "ErrQueryDrugListByType"
	k DrugArr
	d ..queryDrugList(.DrugArr,userInfo,queryType,queryStr,cattype)

	s total = $g(DrugArr("count"))
	s dataArr = []
	// DrugArr("data") 所有药品数据 -> $list(id,code,desc,useflag)
	// DrugArr("sortdata")	排序后的数据
	// DrugArr("total") 总数
	s pagecount = 0
	s index = ""	
	f  s index = $o(DrugArr("sortdata",index))  q:index=""  d
	.s count = ""
	.f  s count = $o(DrugArr("sortdata",index,count)) q:count=""  d
	..s drugInfo = $g(DrugArr("sortdata",index,count))
	..s id = $lg(drugInfo,1)
	..s useflag = $lg(drugInfo,4)
	..s pagecount = pagecount + 1
	..q:pagecount<start
	..q:pagecount>end
	..s drugObj = ..queryDrugOverMsgById(id)
	..s drugObj.useflag = useflag
	..//s drugObj.index = count
	..s drugObj.index = pagecount
	..d dataArr.%Push(drugObj)

	s resObj.data = dataArr
    s resObj.total = $g(DrugArr("total"))
    
    s endDate  = $p($zts,",",2)	
    //w endDate-stDate,!
    q resObj.%ToJSON()
   
ErrQueryDrugListByType
    s resObj.state = "-104"
	s resObj.msg = $ZE
	q resObj.%ToJSON()
}

/// Description:： 通过属性和属性值获取药品列表
/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Input:
/// d ##class(web.DHCCKBPdssIndex).queryDrugOverMsgById(149).%ToJSON()
ClassMethod queryDrugList(DrugArr, userInfo, queryType, queryStr, cattype = "")
{
		
	k attrValueArr
	s attrId = "" ,outFlag = 0
	i queryType="cat"  d
	.s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugCategory")	// 药学分类属性	
	.s catList = ""
	.d ##Class(web.DHCCKBCommon).GetChildCat(.catList,queryStr,1)		//	获取子分类
	.d ##class(web.DHCCKBCommonUtil).ListToArr(.catList,.attrValueArr)	// 分类转数组
	.i cattype="zcy" d	// 中成药需要通过分类找到通用名,在通过通用名找到药品
	..s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameFormProp")
	..k attrValueArr
	..d ..GetGenerIdByCat(.catList,.attrValueArr)	
	e  i queryType="drug"  d
	.d ..QueryAllDrugList(.DrugArr,queryStr)
	.//i $o(DrugArr("data",""))'="" d ..SortDrugByClick(.DrugArr,userInfo)	// 药品排序
	.q:$o(DrugArr("data",""))'=""
	.// 通过药品没有直接找到的情况下，使用通用名>商品名>化学名查找
	.s attrId = ..GetDrugAttrList(.attrValueArr,queryStr)
	.s outFlag = 1
	e  i (queryType="indic")||(queryType="contr")  d
	.d ..QueryDrugListByIndic(.DrugArr, queryStr, queryType)
	.//i $o(DrugArr("data",""))'="" d ..SortDrugByClick(.DrugArr,userInfo)	// 药品排序
	i $o(DrugArr("data",""))'="" d ..SortDrugByClick(.DrugArr,userInfo)	// 药品排序	
	q:(attrId=0)||(attrId="") ""

	// 使用属性,属性值找到药品(使用属性找到药品时,attrValueArr("data",count)=$lb(id,code,desc)),分类找到药品时，attrValueArr(id)=id	
	i outFlag=1  d
	.s count = ""
	.f  s count = $o(attrValueArr("data",count))  q:count=""  d
	..s listdata = $g(attrValueArr("data",count))
	..s valueId = $lg(listdata,1)
	..q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",valueId,attrId))
	..d ..GetDrugListByAttr(.DrugArr,userInfo,attrId,valueId)	
	e  d
	.s valueId = ""
	.f  s valueId = $o(attrValueArr(valueId))  q:valueId=""  d
	..q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",valueId,attrId))
	..d ..GetDrugListByAttr(.DrugArr,userInfo,attrId,valueId)	

	d ..SortDrugByClick(.DrugArr,userInfo)	// 药品排序	

	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-22
/// Description:： 在西药字典、中成药字典、饮片字典中查找所有药品
/// w ##class(web.DHCCKBPdssIndex).QueryAllDrugList(.TmpArr,"阿")
ClassMethod QueryAllDrugList(TmpArr, input) As %String
{

	s drugParrefList =$lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")	
	s count = 0
	k DrugArr
	f i=1:1:$ll(drugParrefList)  d
	.s parref = $lg(drugParrefList,i)
	.s parrefId = ##class(web.DHCCKBCommon).GetDicIdByCode(parref)
	.d ..QueryKeyList(.TmpArr,.DrugArr,input,parrefId)
		
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-22
/// Description:： 通过属性找到属性值id(药品使用固定的模式进行检索)
/// w ##class(web.DHCCKBPdssIndex).GetDrugAttrList(.TmpArr,"阿")
ClassMethod GetDrugAttrList(TmpArr, input) As %String
{
	// 药品使用 名称->通用名->商品名->化学名 检索	
	s parrefList = $lb("GeneralFromData:GenerNameFormProp","DrugProNameData:ProNameProp","GeneralData:GenerNameProp")
	
	k DrugArr	
	s attrCode="",attrId="",existFlag=0
	f i=1:1:$ll(parrefList) q:existFlag=1  d
	.s parrefStr = $lg(parrefList,i)
	.s parref = $p(parrefStr,":",1)
	.s parrefId = ##class(web.DHCCKBCommon).GetDicIdByCode(parref)
	.d ..QueryKeyList(.TmpArr,.DrugArr,input,parrefId)
	.i $d(TmpArr("data")) s existFlag=1
	.i existFlag=1  d
	..s attrCode = $p(parrefStr,":",2)
	..s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode(attrCode)
	.q:existFlag=1
	
	q attrId
}

/// Description:： 根据属性和属性值获取关联药品
/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Input:		   attrId:属性id,attrValueId:属性值
/// d ##class(web.DHCCKBPdssIndex).SortDrugByClick()
ClassMethod GetDrugListByAttr(DrugArr, userInfo, attrId, valueId)
{
	s hospId = $p(userInfo,"^",5)
	s count = +$g(DrugArr("total"))
	s drugData = ##class(web.DHCCKBCommon).GetDrugData()
	s chinaData = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s herbalData = ##class(web.DHCCKBCommon).GetChineseHMData()
	s drugTypeList = $lb(drugData,chinaData,herbalData)

	// attrId存在使用link的方式存值
	k attrIdArr
	i $d(^CT.CKB.PDSS.CommonDictionI("Link",attrId))  d
	.s attrIdArr(attrId)=""
	.s tmpId = ""
	.f  s tmpId = $o(^CT.CKB.PDSS.CommonDictionI("Link",attrId,tmpId))  q:tmpId=""  d
	..s attrIdArr(tmpId)=""

	s tmpAttrId = ""
	f  s tmpAttrId = $o(attrIdArr(tmpAttrId))  q:tmpAttrId=""  d  
	.s linkId="" 
 	.f  s linkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",valueId,tmpAttrId,linkId)) q:linkId=""  d
	..q:+linkId=0
	..s drugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkId)),2)
	..q:+drugId=0
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(+drugId))
	..s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	..s name = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	..q:(code="")||(name="")
	..q:##class(web.DHCCKBCommon).IsEnabled(drugId)=0	
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	..q:$lf(drugTypeList,parref)=0
	..s count = count + 1
	..s DrugArr("data",count) = $lb(drugId,code,name)
	..s DrugArr("total") = count

	q ""
}

/// Description:： 药品按照本院再用在前+点击次数排序
/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Input:		   attrId:属性id,attrValueId:属性值
/// d ##class(web.DHCCKBPdssIndex).SortDrugByClick()
ClassMethod SortDrugByClick(DrugArr, userInfo)
{
	s hospId = $p(userInfo,"^",5)
	
	s stopnum = 0
	s count = ""
	f  s count = $o(DrugArr("data",count))  q:count=""  d
	.s druglist = $g(DrugArr("data",count))
	.s drugId = $lg(druglist,1)
	.s exitFlag = ##class(web.DHCCKBCommon).IsEnabled(drugId)
	.i exitFlag=0  s stopnum=stopnum+1
	.q:exitFlag=0	
	.s clickNum = ##class(web.DHCCKBDrugSearchLog).GetDrugClick(drugId,hospId)	// 点击次数
	.s clickNum = +clickNum
	.s useFlag = "N" // 本院在用标记
	.s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(drugId,hospId)
	.s:contrastFlag=1 useFlag="Y"
	.// 按照点击次数和本院再用标记排序
	.s useSort = $case(useFlag="Y",1:"0",:"1")	/// 本院再用在前
	.//s clickNum = "" // 按照10位数字前补零
	.s clickNum = ..AddZero("prev",10,clickNum)
	.s $list(druglist,4) = useFlag
	.s DrugArr("sortdata",useSort_","_clickNum,count) = druglist
	
	s DrugArr("total") = $g(DrugArr("total")) - stopnum
	q ""
}

/// Description:： 字符串补零
/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Input:		   model: prev前补零,after后补零
/// 	               len:补零位数
/// 				   需要补零的字符串
/// w ##class(web.DHCCKBPdssIndex).AddZero()
ClassMethod AddZero(model, len, str)
{
	s strlen = $l(str)
	q:strlen>len str
	
	s cur = len - strlen
	
	s zero = ""
	f i=1:1:cur  d
	.s zero = zero_"0"
	
	s str = $select(model="prev":zero_str,model="after":str_zero,1:str)
	q str
}

/// Description:： 通过药品id获取药品概要信息
/// Creator：      qunianpeng
/// CreatDate：    2022-08-18
/// Input:
/// OutPut: 	  {id:'',code:'',name:'',genername:'',proname:'',chemicalname:'',ingr:'',spec:'',form:'',manf:'',approvalnum:'',useflag:''}	
/// d ##class(web.DHCCKBPdssIndex).queryDrugOverMsgById(152).%ToJSON()
ClassMethod queryDrugOverMsgById(drugId)
{
	s resObj = {}
	s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	s resObj.id = drugId
	s resObj.code = code
	s resObj.name = desc

	q:(code="")||(desc="") resObj
	
	k proArr
	d ..GetOverViewProp(.proArr)
	
	s index = ""
	f  s index = $o(proArr(index))  q:index=""  d
	.s key = $g(proArr(index))
	.s proId =##class(web.DHCCKBCommon).GetDicIdByCode(index)
	.s value = ##class(web.DHCCKBEditProp).QueryAttrValue(drugId,+proId)
	.i (key="genername")&&(value="") s value = desc  // 通用名为空时,用药品名称代替
	.d resObj.%Set(key,value) // = value
	
	q resObj
}

/// Description:： 获取概要信息属性list(用于浏览器的药品列表和药品详情中的数据展示,model=instru表示详情中需要的概要属性,略有差异)
/// Creator：      qunianpeng
/// CreatDate：    2022-08-19
/// Input:		   
/// OutPut: 	  
/// d ##class(web.DHCCKBPdssIndex).GetOverViewProp(149)
ClassMethod GetOverViewProp(propArr, model = "")
{
	// 固定取这几项的概要信息
	s propArr("GenerNameFormProp") = "genername"	// 通用名
	s propArr("ProNameProp") = "proname"			// 商品名
	s propArr("SpecificationProp") = "spec"			// 规格
	s propArr("FormProp") = "form"					// 剂型
	s propArr("ManufacturerProp") = "manf"			// 厂家
	s propArr("ApprovalNumberProp") = "approvalnum"		// 批准文号
	
	i model="" d
	.s propArr("GenerNameProp") = "chemicalname"		// 化学名
	.s propArr("Ingredient") = "ingr"					// 成分
	
	// 中药饮片
	s propArr("PrescriptionCopeProp") = "genername"	// 处方应付
	s propArr("NationalSICode") = "nationalSICode"  // 国家医保编码
	s propArr("LatinNameProp") = "latinname"	// 拉丁名
	s propArr("OtherNameProp") = "othername"    // 别名
	
	q ""
}

/// Description:： 通过药品id获取药品详细信息
/// Creator：      qunianpeng
/// CreatDate：    2022-08-19
/// Input:
/// OutPut: 	  {state:"",msg:"",data{id:"",code:"",name:"",title:{id:"id",code:"编码",name:"药品名称"..},overview:["genername","proname","spec","form","manf","approvalnum"]},instru:{id:"",code:"",name:""},origin:[{id: "1",code:"",name:"",genername: "",proname: "",spec:""}],linkbooks:[{id: "",name: ""}]}
/// w ##class(web.DHCCKBPdssIndex).queryDrugDetail(66405,"11863^8^1^293^2")
ClassMethod queryDrugDetail(drugId, userInfo = "")
{

	s resObj = {}

	s resObj.state = 200
	s resObj.msg = "查询成功"
	i +drugId=0 s resObj.state = -104	
	q:+drugId=0 resObj.%ToJSON()
	
	s dataObj = {}
	s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4) // 药品类型
	s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	s dataObj.id = drugId
	s dataObj.code = code
	s dataObj.name = desc
	s dataObj.type = $case(parrefCode,"DrugData":"xy","ChineseDrugData":"zcy","ChineseHerbalMedicineData":"yp","ChinaMedPrescData":"zyfj",:"xy")
	q:(code="")||(desc="") resObj.%ToJSON()	

	// 通过药品id获取本药药品id
	s orginDrugId = ##Class(web.DHCCKBCommon).GetComOriginDrug(drugId) // 返回值：若有本源药品id则返回本源id,否则返回自身id. 有本源则展示本药药品的说明书,若没有则展示自己的说明书
	s orginPropList= $lb("SpecificationProp","ApprovalNumberProp")
	
	s $ZT = "ErrQueryDrugDetail"
	k overViewArr 
	d ..GetOverViewProp(.overViewArr,"instru")	// s overview("GenerNameFormProp") = "genername"	// 通用名
	s overviewObj = []
	s index = ""
	f  s index = $o(overViewArr(index))  q:index=""  d
	.s key = $g(overViewArr(index))
	.d overviewObj.%Push(key)
	
	// 通过 知识浏览附加属性, 获取到只需要在浏览器中展示的属性,按照序号排序
	k propArr	// s porpArr(1) = "id^code^desc"	
	s instruPorpList = ..GetInstruPropList(.propArr,orginDrugId)		
	
	s instruObj = {},titleObj = {}
	s index = ""
	f  s index = $o(propArr(index))  q:index=""  d
	.s str = $g(propArr(index))
	.s propId = $p(str,"^",1)
	.s propCode = $p(str,"^",2)
	.s propDesc = $p(str,"^",3)
	.q:(+propId=0)||(propDesc="")
	.s value=""
	.i $lf(orginPropList,propCode)'=0 s value = ##class(web.DHCCKBEditProp).QueryAttrValue(drugId,+propId)	// 药品的规格、批准文号按照自己的展示
	.e  s value = ##class(web.DHCCKBEditProp).QueryAttrValue(orginDrugId,+propId)
	.q:value=""
	.i $d(overViewArr(propCode)) s propCode = $g(overViewArr(propCode)) // 将概要属性的code转换为前台约定的code
	.d instruObj.%Set(propCode,value)
	.d titleObj.%Set(propCode,propDesc)
	
	d dataObj.%Set("overview",overviewObj)
	d dataObj.%Set("instru",instruObj)
	d dataObj.%Set("title",titleObj)	

	d ..verifyTitle(titleObj,overviewObj)

	// 相关文献
	s dataObj.linkbooks = ..GetLinkBooks(drugId) //[{id: "",name: ""}]
	
	// 同源药品
	s dataObj.origin = ..GetOriginDrugList(drugId)
		
	s resObj.data = dataObj
	q resObj.%ToJSON()
ErrQueryDrugDetail

	s resObj.state = -104
	s resObj.msg = $ze
	q resObj.%ToJSON()
}

/// Description:： 	通过 知识浏览附加属性, 获取到只需要在浏览器中展示的属性,按照序号排序
/// Creator：      qunianpeng
/// CreatDate：    2022-08-19
/// Input:
/// OutPut: 	  
/// d ##class(web.DHCCKBPdssIndex).GetInstruPropList(152)
ClassMethod GetInstruPropList(propArr, drugId)
{
	
	// 判断药品
	s drugTypeId = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	s drugType = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugTypeId)),2)
	
	s entityId = ""	
	if drugType="ChineseDrugData" d
	.s entityId = ##class(web.DHCCKBCommon).GetChineseDrug()
	e  if drugType="ChineseHerbalMedicineData" d
	.s entityId = ##class(web.DHCCKBCommon).GetChineseHerbalMedicine()
	e  d
	.s entityId = ##class(web.DHCCKBCommon).GetDrug()	
	q:+entityId=0 ""
	
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s linkPropID = ##class(web.DHCCKBRangeCat).GetAttrLink(entityId,"LinkProp")	// 属性关联id
	s linkRowID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",entityId,linkPropID,""),-1) 
   	s propType = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),4)		// 属性集合
  	d ##class(web.DHCCKBDiction).SortAttrByOrd(propType,pid,0)			//sufan 2020-04-08 属性排序
  	q:+propType=0 ""
  	
  	s instruPropId = ##class(web.DHCCKBCommon).GetDicIdByCode("InstruProp")	// 说明书属性

  	s count = 0
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,propType,index))  q:index=""  d
	.s attrID=+$g(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,propType,index))
	.s tmpAttrID=attrID
	.q:##class(web.DHCCKBCommon).IsEnabled(attrID)=0	
	.s attrLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrID)),5)
	.i attrLinkDr'="" s tmpAttrID=attrLinkDr	// 没有属性值，属性值link其他属性 
	.// 判断是否是说明书属性
	.s tmpLinkID="",instruValueId="",instruValueFlag=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,instruPropId)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,instruPropId,""),-1)
	.i tmpLinkID'="" s instruValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+tmpLinkID)),4)
	.s:+instruValueId'=0 instruValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(+instruValueId)),3)
	.q:instruValueFlag'="Y"	
	.s attrCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+attrID)),2)
	.s attrDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+attrID)),3)
	.i (attrCode="")&&(attrLinkDr'="") s attrCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+attrLinkDr)),2) 
	.i (attrDesc="")&&(attrLinkDr'="") s attrDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+attrLinkDr)),3) 
	.s proplist = attrID_"^"_attrCode_"^"_attrDesc
	.s count = count + 1
	.s propArr(count) = proplist
	
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid)
	q ""
}

/// Description:： 	验证title中必需属性是否存在
/// Creator：      qunianpeng
/// CreatDate：    2022-08-19
/// Input:
/// OutPut: 	  
/// d ##class(web.DHCCKBPdssIndex).verifyTitle
ClassMethod verifyTitle(titleObj, overviewArr)
{
		
	s tmpOverObj = {}.%Set("approvalnum","批准文号").%Set("form","剂型").%Set("genername","通用名").%Set("manf","生产厂家").%Set("proname","商品名").%Set("spec","规格").%Set("latinname","拉丁名").%Set("nationalSICode","国家医保编码").%Set("othername","别名")        

	s iter = overviewArr.%GetIterator()
 	while iter.%GetNext(.key, .value) { 
		if (titleObj.%IsDefined(value)=0){
			d titleObj.%Set(value,tmpOverObj.%Get(value))
		}		
 	} 	
 	q titleObj
}

/// Description:： 药品首页检索框下拉数据
/// Creator：      qunianpeng
/// CreatDate：    2022-08-19
/// Input:
/// OutPut: 	  
/// w ##class(web.DHCCKBPdssIndex).SearchKeyList("阿莫")
ClassMethod SearchKeyList(input, userInfo = "")
{
		
	k TmpArr
	d ..queryDrugList(.TmpArr,userInfo,"drug",input)

	s resArr = []
	s htmstr = ""
	s index = ""
	f  s index = $o(TmpArr("data",index)) q:index=""  d
	.s dataList = $g(TmpArr("data",index))
	.s id = $lg(dataList,1)
	.s value = $lg(dataList,3)
	.//q:value'[input
	.s retObj = {}
	.s text = ""
	.s retObj.id = id
	.s retObj.name = value
	.d resArr.%Push(retObj)
	
	q resArr.%ToJSON()
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-22
/// Description:： 使用parref检索字典数据
/// Input:		   TotalArr:接受一个数组，当此方法被多次调用时，返回所有的数据
/// 				   TmpArr：接收一个数组，返回当前调用时的记录数据
///                input: 查询条件
///                parref: 指定字典的id
/// w ##class(web.DHCCKBPdssIndex).QueryKeyList()
ClassMethod QueryKeyList(TotalArr, TmpArr, input, parref) As %String
{
	
	s stDate  = $p($zts,",",2)
	
	s total = $g(TotalArr("total"))
	i total="" s total=0
	s resArr = []	
	s id="",count=0 
	f   s id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id)) q:id=""  d
	.s name = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	.s idObj = "" //##class(CT.CKB.PDSS.CommonDiction).%OpenId(id)
	.s pinName = ##class(web.DHCCKBCommonUtil).GetPYCODE(name) //idObj.CDFirstWord 
	.//d idObj.%Close()
	.q:(input'="")&&(name'[input)&&(pinName'[$zcvt(input,"U"))
	.// 暂不支持首拼检索,需要增加字段，存储首拼音(已经通过计算属性实现首拼查询)
	.q:##class(web.DHCCKBCommon).IsEnabled(id)=0	
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),2)
	.s name = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)
	.q:(name="")||(name["停用")||(name["作废")
	.s dataObj = {}
	.s dataObj.id = id
	.s dataObj.code = code
	.s dataObj.name = name
	.d resArr.%Push(dataObj)
	.s count = count + 1
	.s TmpArr("data",count) = $lb(id,code,name)
	.s total = total + 1
	.s TotalArr("data",total) = $lb(id,code,name)
	
	s TmpArr("total") = count
	s TotalArr("total") = total	
	s endDate = $p($zts,",",2)
	
	//w endDate-stDate,!
	q resArr.%ToJSON()
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-22
/// Description:： 使用适应症/禁忌症文本查询药品
/// Input:		   检索的文本
/// 				   TmpArr：接收一个数组，返回当前调用时的记录数据
///                input: 查询条件
///                parref: 指定字典的id
/// w ##class(web.DHCCKBPdssIndex).QueryDrugListByIndic(.TmpArr,"青霉素","indic")
ClassMethod QueryDrugListByIndic(TmpArr, input, key) As %String
{
	
	s stDate  = $p($zts,",",2)
	
	s drugTypeList = $lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	s count = 0
	s propId=0
	i key = "indic" s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")
	e  i key = "contr" s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")
	
	k propArr
	i +propId'=0 s propArr(propId)=""
	d ..GetLinkProp(.propArr,propId)
	q:$o(propArr(""))="" ""	
	
	s count = 0
	s subPropId = ""
	f  s subPropId = $o(propArr(subPropId))  q:subPropId=""  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(+subPropId))
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",subPropId))
	.s drugId = ""
	.f  s drugId = $o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",subPropId,drugId))  q:drugId=""  d
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(+drugId))
	..s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	..s name = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	..//q:##class(web.DHCCKBCommon).IsEnabled(drugId)=0 //此方法放到药品输出处
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	..s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	..q:$lf(drugTypeList,parrefCode)=0
	..s existFlag = 0
	..s linkDr = ""
	..f  s linkDr = $o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",subPropId,drugId,linkDr)) q:(linkDr="")||(existFlag=1)  d
	...s text = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkDr)),5)
	...q:text=""
	...i text[input s existFlag=1
	..
	..i existFlag=1 d
	...s count = count + 1
	...s TmpArr("data",count)=$lb(drugId,code,name)
	
	s TmpArr("total") = count

	//s endDate = $p($zts,",",2)
	//w endDate-stDate,!
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-22
/// Description:： 使用适应症/禁忌症文本查询药品
/// Input:		   检索的文本
/// 				   TmpArr：接收一个数组，返回当前调用时的记录数据
///                input: 查询条件
///                parref: 指定字典的id
/// w ##class(web.DHCCKBPdssIndex).GetLinkProp()
ClassMethod GetLinkProp(TmpArr, propId) As %String
{
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Link",+propId)) ""
	
	s linkId = ""
	f  s linkId = $o(^CT.CKB.PDSS.CommonDictionI("Link",+propId,linkId)) q:linkId=""  d
	.q:##class(web.DHCCKBCommon).IsEnabled(linkId)=0
	.s TmpArr(linkId)=""	
	
	q ""
}

/// Creator：      qunianpeng
/// CreatDate：    2022-08-22
/// Description:： 获取药品的文献链接
/// Input:		   检索的文本
/// 				   TmpArr：接收一个数组，返回当前调用时的记录数据
///                input: 查询条件
///                parref: 指定字典的id
/// w ##class(web.DHCCKBPdssIndex).GetLinkProp()
ClassMethod GetLinkBooks(drugId) As %String
{

	s retArr = []
	
	//s bookObj = {"id":"1","name":"百度一下","href":"https://www.runoob.com"}
	//d retArr.%Push(bookObj)
	q retArr
}

/// Creator：      qunianpeng
/// CreatDate：    2022-09-02
/// Description:： 获取药品的同源药品
/// Input:		   drugId：药品id
/// w ##class(web.DHCCKBPdssIndex).GetOriginDrugList(108095)
ClassMethod GetOriginDrugList(drugId) As %String
{
	// 同源药品
	s retArr = []
	// 通过药品id,获取本源药品id
	s orginDrugId = ##Class(web.DHCCKBCommon).GetComOriginDrug(drugId)
	q:orginDrugId=drugId retArr	// 没有本源id
	
	// 找到所有同源药品属性id(含linkdr)
	k orginArr	
	s orginPropId = "",tmpPropId=""
	f  s tmpPropId = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("ComOriginDrug"),tmpPropId))  q:tmpPropId=""  d
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+tmpPropId)),5)
	.q:linkDr'=""  
	.s orginPropId=tmpPropId
	q:+orginPropId=0 retArr
	s orginArr(orginPropId)=orginPropId	
	s linkDr = ""
	f  s linkDr = $o(^CT.CKB.PDSS.CommonDictionI("Link",orginPropId,linkDr)) q:linkDr=""  d
	.s orginArr(linkDr)=linkDr  

	// 获取同源药品列表
	s manf = ""
	s orginProp = ""
	f  s orginProp = $o(orginArr(orginProp))  q:(orginProp="")||(retArr.%Size()>0)  d
	.s likeDrugId = ""
	.f  s likeDrugId = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",orginDrugId,orginProp,likeDrugId)) q:likeDrugId=""  d
	..q:likeDrugId=drugId
	..s likeObj = {}
	..s likeObj.id = likeDrugId
	..s likeObj.spec = ##class(web.DHCCKBEditProp).QueryAttrValue(likeDrugId,##class(web.DHCCKBCommon).GetDicIdByCode("SpecificationProp"))	//规格
	..i manf="" s manf=##class(web.DHCCKBCommon).GetDicIdByCode("ManufacturerProp")
	..s likeObj.manf = ##class(web.DHCCKBEditProp).QueryAttrValue(likeDrugId,manf)	//厂家
	..s likeObj.approvalnum = ##class(web.DHCCKBEditProp).QueryAttrValue(likeDrugId,##class(web.DHCCKBCommon).GetDicIdByCode("ApprovalNumberProp"))	//批准文号
	..d retArr.%Push(likeObj)

	q retArr
}

/// Description:： 通过分类找到分类关联的通用名
/// Creator：      qunianpeng
/// CreatDate：    2022-09-13
/// Input:
/// d ##class(web.DHCCKBPdssIndex).GetGenerIdByCat(149)
ClassMethod GetGenerIdByCat(catList, attrValueArr)
{
	s attrId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugCategory")	// 药学分类属性	
	s drugTypeList = $lb(##class(web.DHCCKBCommon).GetGeneralFromData())
	k TmpGenerArr
	f i=1:1:$ll(catList) d
	.s valueId = $lg(catList,i)	
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",valueId,attrId))
	.s linkId="" 
 	.f  s linkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",valueId,attrId,linkId)) q:linkId=""  d
	..q:+linkId=0
	..s drugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkId)),2)
	..q:+drugId=0
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(+drugId))
	..s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	..s name = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	..q:(code="")||(name="")
	..q:##class(web.DHCCKBCommon).IsEnabled(drugId)=0	
	..s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	..q:$lf(drugTypeList,parref)=0
	..s attrValueArr(drugId) = drugId

	q ""
}

/// Description:： 获取用药指导单内容
/// Creator：      qunianpeng
/// CreatDate：    2022-10-20
/// Input:
/// w ##class(web.DHCCKBPdssIndex).GetEduInfo(261219)
/// w ##class(web.DHCCKBPdssIndex).GetEduInfo(108449)
ClassMethod GetEduInfo(drugId)
{

	s guideId = ##class(web.DHCCKBCommon).GetDrugEduProp()	// 用药指导目录id
	
	k TmpArr
	d ..GetAllGuideStr(.TmpArr,drugId,guideId)
	
	s resObj = {}
	s resObj.state = "200"
	s resObj.msg = "查询成功"
	
	s guideArr = []
	s num = 0
	s index = ""
	f  s index = $o(TmpArr(index)) q:index=""  d
	.s num = num + 1
	.s guideCode = "guide"_num	
	.s guideObj = {},bookArr=[],outBookArr=[]	
	.s count =""
	.f  s count = $o(TmpArr(index,count)) q:count=""  d
	..s str = $g(TmpArr(index,count))
	..s guideName = $p(str,"$$",1)
	..s type = $p(str,"$$",2)
	..s msg = $p(str,"$$",3)
	..q:msg=""
	..s guideObj.name=guideName
	..s msgObj = {}
	..s msgObj.msg = msg
	..i type="book" d bookArr.%Push(msgObj)
	..i type="outbook" d outBookArr.%Push(msgObj)
	..k msgObj
	.
	.s guideObj.book = bookArr
	.s guideObj.outBook = outBookArr
	.s guideObj.name = guideName
	.i (bookArr.%Size()=0)&&(outBookArr.%Size()=0) k gudieObj
	.q:(bookArr.%Size()=0)&&(outBookArr.%Size()=0)
	.d guideArr.%Push(guideObj)
	.k guideObj,bookArr,outBookArr
	.
	.
	i guideArr.%Size()=0 d
	.s resObj.state = "104"
	.s resObj.msg = "查询失败"
	e  d
	s resObj.data = guideArr
	
	q resObj.%ToJSON()
}

/// Description:： 获取用药指导单内容
/// Creator：      qunianpeng
/// CreatDate：    2022-10-20
/// Input:
/// d ##class(web.DHCCKBPdssIndex).GetAllGuideStr(261219)
ClassMethod GetAllGuideStr(TmpArr, drugId, guideId)
{
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Parref",guideId)) ""
	
	s msgPropId = ##class(web.DHCCKBCommon).GetWarnMessageProp()
	s sourcePropId = ##class(web.DHCCKBCommon).GetSourceMsgProp()	// 提示依据
	s knowSourceId = ##class(web.DHCCKBCommon).GetKnowSource()		// 知识来源
	
	s subGuideId = ""
	f  s subGuideId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",guideId,subGuideId))  q:subGuideId=""  d
	.q:'$d(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId,subGuideId))
	.s count = 0,bookCount=0,outbookCount=0
	.s ruleId=""
	.f  s ruleId =$o(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",drugId,subGuideId,ruleId))  q:ruleId=""  d
	..s ruleDataId = "", msg = "",guideType="",knowSource = "",sourceMsg = ""
	..f  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Rule",ruleId,ruleDataId))  q:ruleDataId=""  d
	...s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataId)),4)
	...i leftDic=msgPropId s msg = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataId)),9)
	...i (leftDic=sourcePropId)&(guideType="") s guideType = "outbook",sourceMsg = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataId)),9)
	...i (leftDic=knowSourceId)&(knowSource="") s knowSource = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataId)),9)
	..q:msg=""
	..i guideType="" s guideType="book"
	..i guideType="book" s bookCount = bookCount + 1,msg = bookCount_")"_msg
	..i guideType="outbook" s outbookCount = outbookCount + 1,msg = outbookCount_")"_msg
	..s count = count + 1	
	..i (sourceMsg'="") s msg=msg_"【"_sourceMsg_"】"
	..i (sourceMsg="")&&(knowSource'="") s msg=msg_"【"_knowSource_"】"
	..s TmpArr(subGuideId,count)=$lg($g(^CT.CKB.PDSS.CommonDictionD(+subGuideId)),3)_"$$"_guideType_"$$"_msg
	..
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",subGuideId))  d
	..d ..GetAllGuideStr(.TmpArr,drugId,subGuideId)
	
	q ""
}

}
