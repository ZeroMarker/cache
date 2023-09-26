Class web.DHCCKBEditProp Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取实体的属性及属性值
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-27	
/// Input:			实体id^属性关联代码
/// return:			属性及属性值集合
/// other:			w ##class(web.DHCCKBEditProp).GetLinkAttrListData(10,1,"22^LinkProp")
ClassMethod GetLinkAttrListData(rows, page, params) As %String
{
	n (rows, page, params)

	s end = page*rows
	s start=(page-1)*rows+1
	s dicID=$p(params,"^",1)		  	//实体ID
	s extraAttrCode=$p(params,"^",2)    //属性关联代码
	
	i dicID="" 	w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:dicID="" ""			
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时globalD
    
    s h=0,count=0  
   	s h=0,attrID="" 
	for  s attrID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,attrID)) Q:attrID=""  d
	.s linkRowID=""  f  s linkRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,attrID,linkRowID))  q:linkRowID=""  d // 属性关联表id
	..q:linkRowID=""
	..s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)		// 具体属性
	.. 
	..s tmp=##class(web.DHCCKBCommon).GetDicIdByCode("DataTypeProp")
	..s tmpRelateDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrID,tmp,""))
	..s dataTypeDr=""
	..i tmpRelateDr'="" s dataTypeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpRelateDr)),4)
	..s dataType=""
	..i dataTypeDr'="" s dataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataTypeDr)),2)	// 具体属性的数据类型
	..
	..s linkAttrDr=""
	..s linkAttrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),4)	// 属性值	
	..s linkAttrValue=""
	..s:linkAttrDr'="" linkAttrValue=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkAttrDr)),3)		// 属性值指针不空,取描述	
	..s:linkAttrDr="" linkAttrValue=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),5)	// 属性值指针为空,则取内容字段内容
	..s listData=linkRowID_"^"_attrID_"^"_attrDesc_"^"_dataType_"^"_linkAttrDr_"^"_linkAttrValue
	..s h=h+1
	..s ^TMP("DHCCKB","web.DHCCKBEditProp","GetLinkAttrListData",pid,h)=listData

	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S listTitle="linkRowID^attrID^attrDesc^dataType^linkAttrDr^linkAttrValue"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBEditProp","GetLinkAttrListData",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBEditProp","GetLinkAttrListData",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Description:	获取实体的属性（combobox用）
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-27	
/// Input:			实体id^属性关联代码
/// return:			属性及属性值集合
/// other:			w ##class(web.DHCCKBEditProp).GetDicAttrList("","22^LinkProp")
ClassMethod GetDicAttrList(q, params) As %String
{
	n (q,params)

	s input=$zcvt(q,"U")
	s dicID=$p(params,"^",1)		  	//药品id
	s extraAttrCode=$p(params,"^",2)    //属性关联代码
	s dicType=$p(params,"^",3)			//实体id
						
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    i dicType="" w "[]"
    q:dicType="" ""

    // 通过具体药品找到药品字典, 通过药品字典找到被挂载在哪个实体下面,继承实体的属性
    // s dicParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)    
    s extraAttrCodeDr=##class(web.DHCCKBCommon).GetDicIdByCode(extraAttrCode)  
    s relateDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicType,extraAttrCodeDr,""))	  // 属性关联id
  	i relateDr=""  w "[]"		  // 药品->属性关联->药品属性  7 9 5
   	q:relateDr="" ""
  
  	s parref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(relateDr)),4)	// 药品属性集合  
  	i parref="" w "[]"
  	q:parref="" ""  	

	w "["		
	s count=0,attrID=""
 	for  s attrID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,attrID)) Q:attrID=""  d
	.s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),2)
	.s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),3)		// 具体属性	
	.s pinAttrDesc=##class(web.DHCCKBCommonUtil).GetPYCODE(attrDesc)
	.q:input'=""&($zcvt(attrCode,"U")'[input)&(attrDesc'[input)&($zcvt(pinAttrDesc,"U")'[input)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",attrID_"^"_attrDesc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",attrID_"^"_attrDesc)
	
	w "]"
	
	q ""
}

/// Description:	通过实体id获取实例数据
/// Creator:		QuNianpeng 
/// CreateDate:		2019-06-28	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBEditProp).GetDicInstanceByParref("30","1","DataSource","","","","","drugType")
/// other:			w ##class(web.DHCCKBEditProp).GetDicInstanceByParref("30","1","DataSource","78200","^78200","","","dictionType")
ClassMethod GetDicInstanceByParref(rows, page, extraAttr, parref, params As %String = "", drugType = "", hospId As %String = "", queryType = "drugType") As %String
{
	n (rows, page,extraAttr,parref, params,drugType,hospId,queryType) 
	;s ^temptest("s1") = $lb(rows, page,extraAttr,parref, params,drugType,hospId,queryType)
	s end = page*rows
	s start=(page-1)*rows+1

	s pid=##class(web.DHCCKBCommonUtil).NewPid()	
	s queryCode = $p(params,"^",1)
	s attrId = $p(params,"^",2)
	s geneName = $p(params,"^",3)
	s dictionId = $p(params,"^",4)
	s queryactionLib = $p(params,"^",5)   //检索条件
	s queryCode = $replace(queryCode,"(","")
	s queryCode = $replace(queryCode,")","")
	s queryCode = $replace(queryCode,"（","")
	s queryCode = $replace(queryCode,"）","")
	s queryCode = $zcvt(queryCode,"U")									  
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)	//附加属性
	s drugDataList = ..GetDrugDataList()
	i (drugType = "Herbal")&(parref="") s parref=##class(web.DHCCKBCommon).GetChineseHerbalMedicine()	
	i queryType = "drugType"  d	
	.i parref="" s parref=##class(web.DHCCKBCommon).GetDrug()	 // 默认显示药品字典数据
	.i (extraAttrDr="")||(parref="") w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	.q:(extraAttrDr="")||(parref="")
	.s linkID = "",attrDr=""
	.// 先通过实体找到关联的数据集合
	.// 对集合列表中的数据进行属性维护
	.s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",parref,extraAttrDr,""))
	.i linkID="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	.q:linkID=""
	.s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	.i attrDr="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	.q:attrDr="" 
	i queryType = "dictionType"  d	
	.s attrDr = parref
	i attrDr = "" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	Q:attrDr="" ""
	s idList = ""
	s h=0
	s dicID=""  f   s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",attrDr,dicID))  q:dicID=""   d
	.q:##class(web.DHCCKBCommon).IsEnabled(dicID)=0     //sufan 20200415  过滤停用数据
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	.s parrefDesc=""
	.s:parref'="" parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.s linkDesc=""
	.s:linkDr'="" linkDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s pinDicDesc = $replace(pinDicDesc," ","")
	.s pinDicDesc = $replace(pinDicDesc," ","")
	.s pinDicDesc = $replace(pinDicDesc,"(","")
	.s pinDicDesc = $replace(pinDicDesc,")","")
	.s pinDicDesc = $replace(pinDicDesc,"（","")
	.s pinDicDesc = $replace(pinDicDesc,"）","")
	.s dicCodeq = $replace(dicCode,"（","")
	.s dicCodeq = $replace(dicCodeq,"）","")
	.s dicCodeq = $replace(dicCodeq,")","")
	.s dicCodeq = $replace(dicCodeq,"(","")
	.s dicCodeq = $replace(dicCodeq," ","")
	.s dicCodeq = $replace(dicCodeq," ","")
	.s dicDescq = $replace(dicDesc,"（","")
	.s dicDescq = $replace(dicDescq,"）","")
	.s dicDescq = $replace(dicDescq,")","")
	.s dicDescq = $replace(dicDescq,"(","")
	.s dicDescq = $replace(dicDescq," ","")
	.s generNameList=""
	.i geneName'="" s generNameList = ##class(web.DHCCKBDrugVO).GetDrugGenerName(dicID)
	.Q:(geneName'="")&&(generNameList'[geneName)
	.q:(queryactionLib="")&&((queryCode'="")&($zcvt(dicCodeq,"U")'[queryCode)&($zcvt(dicDescq,"U")'[queryCode)&(pinDicDesc'[queryCode))
	.//商品名、化学名、成分、厂家、剂型等属性
	.s:queryactionLib'="" queryActionName=##class(web.DHCCKBEditProp).QueryAttrValue(dicID,queryactionLib) 
	.Q:(queryactionLib'="")&&((queryCode'="")&(queryActionName'[queryCode))
	.q:(hospId'="")&($listfind(drugDataList,attrDr)>0)&(0=##class(web.DHCCKBComContrast).IsSysContrast(dicID,hospId))	// 2021/7/3 增加医院过滤 qnp
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(dicID)		//判断是否有规则
	.s img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	.s ruleImg=$s(ruleFlag=1:img,1:"")
	.;s drugConfirmFlag = +$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm"))	// 药品核实 2021/1/30 qnp
	.s drugConfirmFlag=##class(web.DHCCKBCommon).GetConfirmFlag(dicID)   //sunhuiyong 2021-8-19
	.s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	.s confirmImg=$case(drugConfirmFlag=1,1:confirmImg,:"")
	.s attrValue = ##class(web.DHCCKBEditProp).QueryAttrValue(dicID,attrId)
	.Q:(attrId'="")&&(attrValue'="")			//过滤属性不为空的药品 sufan 2021-12-17
	.i idList = "" s idList = dicID
	.e  s idList = idList_","_dicID
	.s h=h+1
	.s ^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid,h)=dicID_"^"_dicCode_"^"_ruleImg_confirmImg_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_$g(linkDesc)
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	B   //S1
	s count=0	
	s listTitle="dicID^dicCode^dicDesc^parref^parrefDesc^linkDr^linkDesc^idList"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid,index))_"^"_idList
	.s count=count+1
	.q:(count<start)||(count>end)
	.i count=start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() 	// 输出json结尾符	
	d ..killTmpGlobal(pid)
	
	q ""
}

/// Description:	通过实体id获取实例数据
/// Creator:		Sunhuiyong
/// CreateDate:		2022-08-24	
/// Input:			代码^描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBEditProp).GetDicInstanceByParrefNew("30","1","DataSource","7","^^^^","","","drugType","")
ClassMethod GetDicInstanceByParrefNew(rows, page, extraAttr, parref, params As %String = "", drugType = "", hospId As %String = "", queryType = "drugType", hospID) As %String
{
	n (rows, page,extraAttr,parref, params,drugType,hospId,queryType,hospID) 
	s end = page*rows
	s start=(page-1)*rows+1
	
	s queryCode = $p(params,"^",1)
	s attrId = $p(params,"^",2)
	s geneName = $p(params,"^",3)
	s dictionId = $p(params,"^",4)
	s queryactionLib = $p(params,"^",5)   //检索条件
	s queryCode = $replace(queryCode,"(","")
	s queryCode = $replace(queryCode,")","")
	s queryCode = $replace(queryCode,"（","")
	s queryCode = $replace(queryCode,"）","")
	s queryCode = $zcvt(queryCode,"U")									  
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode(extraAttr)	//附加属性
	s drugDataList = ..GetDrugDataList()
	s attrDr=""
	i (drugType = "Herbal")&(parref="") s parref=##class(web.DHCCKBCommon).GetChineseHerbalMedicine()	
	i queryType = "drugType"  d	
	.i parref="" s parref=##class(web.DHCCKBCommon).GetDrug()	 // 默认显示药品字典数据
	.i (extraAttrDr="")||(parref="") w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	.q:(extraAttrDr="")||(parref="")
	.s linkID = ""
	.s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",parref,extraAttrDr,""))
	.i linkID="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	.q:linkID=""
	.s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	.i attrDr="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	.q:attrDr="" 
	i queryType = "dictionType"  d	
	.s attrDr = parref
	.i attrDr = "" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:attrDr="" ""

	s listTitle="dicID^dicCode^dicDesc^parref^parrefDesc^linkDr^linkDesc^idList^ruleStatus"
	s h=0
	w "{"
	w """"_"rows"_""""_":"_"["
	s dicID="",contrastFlag=1  f   s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",attrDr,dicID))  q:dicID=""   d
	.q:dicID=""
	.q:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+dicID,"stop")) // 过滤停用数据
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),4)
	.s parrefDesc=""
	.s:parref'="" parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),3)
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),5)
	.s linkDesc=""
	.s:linkDr'="" linkDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	.s pinDicDesc = ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.s pinDicDesc = $replace(pinDicDesc," ","")
	.s pinDicDesc = $replace(pinDicDesc,"(","")
	.s pinDicDesc = $replace(pinDicDesc,")","")
	.s pinDicDesc = $replace(pinDicDesc,"（","")
	.s pinDicDesc = $replace(pinDicDesc,"）","")
	.s dicCodeq = $replace(dicCode,"（","")
	.s dicCodeq = $replace(dicCodeq,"）","")
	.s dicCodeq = $replace(dicCodeq,")","")
	.s dicCodeq = $replace(dicCodeq,"(","")
	.s dicCodeq = $replace(dicCodeq," ","")
	.s dicDescq = $replace(dicDesc,"（","")
	.s dicDescq = $replace(dicDescq,"）","")
	.s dicDescq = $replace(dicDescq,")","")
	.s dicDescq = $replace(dicDescq,"(","")
	.s dicDescq = $replace(dicDescq," ","")
	.q:(queryactionLib="")&&((queryCode'="")&($zcvt(dicCodeq,"U")'[queryCode)&($zcvt(dicDescq,"U")'[queryCode)&(pinDicDesc'[queryCode))
	.s generNameList=""
	.s:geneName'="" generNameList = ##class(web.DHCCKBDrugVO).GetDrugGenerName(dicID)
	.q:(geneName'="")&&(generNameList'[geneName)
	.//商品名、化学名、成分、厂家、剂型等属性
	.s:queryactionLib'="" queryActionName=##class(web.DHCCKBEditProp).QueryAttrValue(dicID,queryactionLib) 
	.q:(queryactionLib'="")&&((queryCode'="")&(queryActionName'[queryCode))
	.s ruleFlag=$case($d(^CT.CKB.PDSS.RuleDicI("Dic",dicID))>0,1:1,:0)	//判断是否有规则
	.s img="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png' border=0/>"
	.s ruleImg=$s(ruleFlag=1:img,1:"")
	.s ruleStatus = $s(ruleFlag=1:"是",1:"否")
	.s drugConfirmFlag = $case($d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm"))>0,1:1,:0) 	// 药品核实 
	.;s drugConfirmFlag=##class(web.DHCCKBCommon).GetConfirmFlag(dicID)   //sunhuiyong 2021-8-19
	.s confirmImg="<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png' border=0/>"
	.s confirmImg=$case(drugConfirmFlag=1,1:confirmImg,:"")
	
	.i hospID'=""  d
	..s contrastFlag = ##class(web.DHCCKBComContrast).IsSysContrast(dicID,hospID) //ld  2022-9-5 添加院区查询
	.q:contrastFlag'=1
	.s listData=dicID_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_$g(linkDesc)_"^"_"^"_ruleStatus
	.//s listData=dicID_"^"_dicCode_"^"_ruleImg_confirmImg_dicDesc_"^"_parref_"^"_$g(parrefDesc)_"^"_linkDr_"^"_$g(linkDesc)
	.s h = h+1
	.q:(h<start)||(h>end)
	.i h=start D
	..w ##class(web.DHCAPPJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(listTitle,listData)
	w "]"
	w ","
	w """"_"total"_""""_":"_h
	w "}"
	q ""
}

/// Description:	获取实体的属性列表
/// Creator:		QuNianpeng 
/// CreateDate:		2019-07-10	
/// Input:			实体id
/// return:			属性集合
/// other:			w ##class(web.DHCCKBEditProp).GetAttrListData("30","1","^150^^false","")
ClassMethod GetAttrListData(rows, page, params, drugType = "") As %String
{
	n (rows, page, params,drugType)
	s ^temptest("3335")=$lb(rows, page, params,drugType)
	s end = page*rows
	s start=(page-1)*rows+1
	s dicID=$p(params,"^",1)		  	//实体ID
	s EntyId=$p(params,"^",2)
	s property=$p(params,"^",3)
	s isempty = $p(params,"^",4)
	if (drugType="Herbal")&(dicID="")  s dicID=##class(web.DHCCKBCommon).GetChineseHerbalMedicine()		// 默认显示药品字典数据
	if dicID=""  s dicID=##class(web.DHCCKBCommon).GetDrug()		// 默认显示药品字典数据
	i dicID="" 	w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:dicID="" ""
			
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
    d ..killTmpGlobal(pid) //k掉临时globalD
    
    s linkPropID=##class(web.DHCCKBRangeCat).GetAttrLink(dicID,"LinkProp")  //##class(web.DHCCKBCommon).GetLinkProp()	// 属性关联id
   
    s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()		// 是否需要维护属性值
    s dataTypeID=##class(web.DHCCKBCommon).GetDataType()					// 数据展现类型
	Q:linkPropID="" ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
   	s h=0,linkRowID="" 
	for  s linkRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,linkPropID,linkRowID)) Q:linkRowID=""  d
	.s attrparref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),4)		// 属性集合
	.b:attrparref=""
	.d ##class(web.DHCCKBDiction).SortAttrByOrd(attrparref,pid,0)			//sufan 2020-04-08 排序
	.s Index=""
	.f  s Index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))  q:Index=""  d
	..s attrID=+$g(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))
	..s tmpAttrID=attrID
	..s attrLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(attrID)),5)
	..i attrLinkDr'="" s tmpAttrID=attrLinkDr	// 没有属性值，属性值link其他属性 
	..// 判断是否需要维护属性值
	..s tmpLinkID="",AddValueId="",AddValueFlag=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID,""))
	..i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	..s:AddValueId'="" AddValueFlag=$lg($g(^CT.CKB.PDSS.CommonDictionD(AddValueId)),3)
	..q:$g(AddValueFlag)="N"
	..//数据展现形式
	..s tmpLinkID=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID))  s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID,""))
	..s dataTypeDr=""
	..i tmpLinkID'="" s dataTypeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	..s dataType=""
	..i dataTypeDr'="" s dataType=$lg($g(^CT.CKB.PDSS.CommonDictionD(dataTypeDr)),2)	// 具体属性的数据类型
	..s attrCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrID)),2)
	..q:(property'="")&&(property'=attrCode)
	..s attrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpAttrID)),3)
	..//取维护的属性值
	..//q:(attrID=3920) //||(attrID=3934) //$lb(3934,)
	..b:attrID=78009  ///333
	..s AttrValue=..QueryAttrValue(EntyId,attrID)
	..s AttrValue = $Replace(AttrValue,$c(2),"")
	..Q:(isempty="true")&&(AttrValue'="")
	..///取值结束
	..s h=h+1
	..s data=attrID_"^"_attrCode_"^"_attrDesc_"^"_dataType_"^"_AttrValue
	..s ^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,h)=data

	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S listTitle="attrID^attrCode^attrDesc^dataType^AttrValue"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s count=0,index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBEditProp).QueryAttrValue(49950,236611)
ClassMethod QueryAttrValue(EntyId, AttrCodeId)
{
	n (EntyId,AttrCodeId)
	s Ret=""
	Q:AttrCodeId="" Ret
	s Ret=..GetAttrValue(EntyId,AttrCodeId)						//取关联属性
	s LinkId=""
	i Ret="" s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)		
	i LinkId'="" s Ret=..GetAttrValue(EntyId,LinkId)			//取本身
	i Ret=""  d
	.s linkDicId = ""
	.for  s linkDicId = $o(^CT.CKB.PDSS.CommonDictionI("Link",AttrCodeId,linkDicId))  Q:(linkDicId="")||(Ret'="")  d
	..s Ret = ..GetAttrValue(EntyId,linkDicId)
	Q Ret
}

/// Descript：	取维护的属性值
/// Creator:  	sufan
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBEditProp).GetAttrValue(49950,236611)
ClassMethod GetAttrValue(EntyId, AttrCodeId)
{
	s LinkFlag=##class(web.DHCCKBCommon).GetDicIdByCode("EqFromUnitProp")  //从单位
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	k GroupArr
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s h=0
	
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId))  d		//属性关联
	.s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId,""))
	.s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.Q:ParrPorpId=""
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId),-1)  Q:subId=""  d
	..s AttrId=""
	..for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,subId,AttrId),-1)  Q:AttrId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),3)
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)
	...s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)
	...s Desc=""
	...i dicAttrId'="" d
	....s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	....s DicLinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:DicLinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),3)
	....s:dicAttrCode=LinkFlag Desc="/"_Desc
	...i dicAttrId'="" s ListData=Desc
	...e  s ListData=dicRes
	...q:GroupFlag=""
	...i $d(GroupArr(GroupFlag))  d
	....s GroupArr(GroupFlag)=GroupArr(GroupFlag)_ListData
	...e  d
	....s GroupArr(GroupFlag)=ListData
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,AttrId))  Q:AttrId=""  d
	..s LinkAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)	
	..s Res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)	
	..s Desc=""
	..i LinkAttrId'=""   d
	...s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),3)
	...s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),5)
	...s:LinkId'="" Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)
	..i LinkAttrId'="" s ListData=Desc
	..e  s ListData=Res
	..s GroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)			//成组标识
	..q:GroupFlag=""
	..i $d(GroupArr(GroupFlag))  d
	...s GroupArr(GroupFlag)=GroupArr(GroupFlag)_","_ListData
	..e  d
	...s GroupArr(GroupFlag)=ListData
	s QuitList=""
	s Index=""
	for  s Index=$o(GroupArr(Index))  Q:Index=""  d
	.s data=GroupArr(Index)
	.i QuitList=""  s QuitList=data
	.e  s QuitList=QuitList_","_data
	k GroupArr
	Q QuitList
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)	

	k ^TMP("DHCCKB","web.DHCCKBEditProp","GetLinkAttrListData",pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetDicInstanceByParref",pid)
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetAttrListData",pid)
}

/// Descript：	取维护的属性值
/// Creator:  	sunhuiyong
/// CreateDate:	2021-6-7
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBEditProp).QueryAttrValue(150,38)
ClassMethod QueryAttrValueNew(EntyId, AttrCodeId)
{
	n (EntyId,AttrCodeId)
	s Ret=""
	s Ret=..GetAttrValueNew(EntyId,AttrCodeId)						//取关联属性
	s LinkId=""
	i Ret="" s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(AttrCodeId)),5)		
	i LinkId'="" s Ret=..GetAttrValueNew(EntyId,LinkId)			//取本身
	Q Ret
}

/// Descript：	取维护的属性值-Desc+Code
/// Creator:  	sunhuiyong
/// CreateDate:	2020-03-12
/// Input:		药品ID,属性ID
/// Output:		属性值串
/// w ##class(web.DHCCKBEditProp).GetAttrValue(81486,74527)
ClassMethod GetAttrValueNew(EntyId, AttrCodeId)
{
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()	
	k GroupArr
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s h=0
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId))  d		//属性关联
	.s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",AttrCodeId,LinkPropId,""))
	.s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	..s AttrId=""
	..for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,subId,AttrId))  Q:AttrId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),3)
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)
	...s GroupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)
	...s Desc=""
	...i dicAttrId'="" d
	....s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),2)   //添加code   shy
	....s DicLinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:Desc="^" Desc=""
	....s:(Desc="")&&(DicLinkId'="") Desc=dicAttrId_"^"_dicAttrId
	....//s:(Desc="")&&(DicLinkId'="") Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),"^",2)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkId)),"^",1)   //添加code   shy
	...i dicAttrId'="" s ListData=Desc
	...e  s ListData=dicRes
	...q:GroupFlag=""
	...i $d(GroupArr(GroupFlag))  d
	....s GroupArr(GroupFlag)=GroupArr(GroupFlag)_ListData
	...e  d
	....s GroupArr(GroupFlag)=ListData
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,AttrId))  Q:AttrId=""  d
	..s LinkAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)	
	..s Res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)	
	..s Desc=""
	..i LinkAttrId'=""   d
	...s Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),3)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),2)   //添加code   shy   2021-6-7
	...s:Desc="^" Desc=""
	...s LinkId=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),5)
	...s:(Desc="")&&(LinkId'="") Desc=LinkAttrId_"^"_LinkAttrId   //添加code   shy 2021-6-7
	...//s:(Desc="")&&(LinkId'="") Desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),3)_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkId)),2)   //添加code   shy 2021-6-7
	..
	..i LinkAttrId'="" s ListData=Desc
	..e  s ListData=Res
	..s GroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)			//成组标识
	..q:GroupFlag=""
	..i $d(GroupArr(GroupFlag))  d
	...s GroupArr(GroupFlag)=GroupArr(GroupFlag)_","_ListData
	..e  d
	...s GroupArr(GroupFlag)=ListData
	s QuitList=""
	s Index=""
	for  s Index=$o(GroupArr(Index))  Q:Index=""  d
	.s data=GroupArr(Index)
	.i QuitList=""  s QuitList=data
	.e  s QuitList=QuitList_","_data
	k GroupArr
	Q QuitList
}

/// Description:	获取实体的属性combox
/// Creator:		sunhuiyong 
/// CreateDate:		2021-5-25	
/// Input:			实体id
/// return:			属性集合
/// other:			w ##class(web.DHCCKBEditProp).GetAttrComboxData()
ClassMethod GetAttrComboxData(q As %String = "") As %String
{
	n (q)

	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	///转换数据为Json格式
	S listTitle="attrCode^attrDesc"
	s pid=""
	s pid=$o(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid)) 
	s count=0,index=""
	w "["
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)) q:index=""  d
	.s listData=$p($g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)),"^",2,3)
	.s dicCode=$p($g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)),"^",2)
	.s dicDesc=$p($g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)),"^",3)
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(queryCode'="")&($zcvt(dicCode,"U")'[queryCode)&(dicDesc'[queryCode)&(pinDicDesc'[queryCode)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
 	w "]"
 	d ..killTmpGlobal(pid)
	q ""
}

/// Descript：	取药品相关的字典列表
/// Creator:  	quninapeng
/// CreateDate:	2021-07-13
/// Input:		
/// Output:		
/// w ##class(web.DHCCKBEditProp).GetDrugDataList()
ClassMethod GetDrugDataList()
{
	s drugData = ##class(web.DHCCKBCommon).GetDrugData()		// 西药
	s chinaData = ##class(web.DHCCKBCommon).GetChineseDrugData()	// 中药
	s chHMData = ##class(web.DHCCKBCommon).GetChineseHMData()		// 草药
	s drugDataList = $lb(drugData,chinaData,chHMData)
	
	q drugDataList
}

/// Description:	获取实体的属性combox
/// Creator:		sunhuiyong 
/// CreateDate:		2021-5-25	
/// Input:			实体id
/// return:			属性集合
/// other:			w ##class(web.DHCCKBEditProp).GetAttrComboxIdData()
ClassMethod GetAttrComboxIdData(q As %String = "") As %String
{
	n (q)

	s queryCode = q
	s queryCode = $zcvt(queryCode,"U")
	///转换数据为Json格式
	s pid=""
	s pid=$o(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid)) 
	s count=0,index=""
	w "["
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)) q:index=""  d
	.s dicCode=$p($g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)),"^",2)
	.s dicDesc=$p($g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)),"^",3)
	.s listData=$p($g(^TMP("DHCCKB","web.DHCCKBEditProp","GetAttrListData",pid,index)),"^",1)_"^"_dicDesc
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(queryCode'="")&($zcvt(dicCode,"U")'[queryCode)&(dicDesc'[queryCode)&(pinDicDesc'[queryCode)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
 	w "]"
 	d ..killTmpGlobal(pid)
	q ""
}

}
