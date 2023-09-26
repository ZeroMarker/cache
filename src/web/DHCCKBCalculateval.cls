Import sqluser

Class web.DHCCKBCalculateval Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Descript:取中西药数据
/// Input:flag=1:去中西药字典,flag=2:通用名字典,flag=3:成分字典
/// w ##class(web.DHCCKBCalculateval).QueryDrugList()
ClassMethod QueryDrugList(q = "", flag = 1)
{
	n (q,flag)
	s dicIdList=""
	i flag=1  d											//中西药
	.s medDrugDicId = ##class(web.DHCCKBCommon).GetDrugData()
	.s chnDrugDicId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	.s chinhmId = ##class(web.DHCCKBCommon).GetChineseHMData()
	.s dicIdList = medDrugDicId_"^"_chnDrugDicId_"^"_chinhmId
	i flag=2  d										//通用名
	.s dicIdList=##class(web.DHCCKBCommon).GetGeneralData()
	i flag=3  d										//成分
	.s dicIdList=##class(web.DHCCKBCommon).GetIngreData()
	i flag=4  d										//剂型
	.s dicIdList=##class(web.DHCCKBCommon).GetFormData()
	i flag=5  d										//目录
	.s dicIdList=##class(web.DHCCKBCommon).GetDrugLibaryData()
	.
	s length = $l(dicIdList,"^")
	s count = 0
	w "["
	for i=1:1:length  d
	.s dicId = $p(dicIdList,"^",i)
	.s Id = ""
	.for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicId,Id))  Q:Id=""  d
	..s desc = $lg(^CT.CKB.PDSS.CommonDictionD(+Id),3)
	..Q:(q'="")&&(desc'[q)
	..q:0=##class(web.DHCCKBCommon).IsEnabled(Id)
	..s count = count+1
	..Q:(q="")&&(count>100)
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	w "]"
	q ""
}

/// Descript:取维护的药品单次剂量
/// w ##class(web.DHCCKBCalculateval).GetDrugSingDose(150)
ClassMethod GetDrugSingDose(durgId, ctinVal)
{
	n (durgId,ctinVal)
	s drugDicId = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	k ruleArr
	s retval = ""
	s ruleDicId = ""
	for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",durgId,ruleDicId))  Q:ruleDicId=""  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	.s catRuleId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDicId,""))
	.Q:catRuleId=""
	.s dicId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleId)),3)
	.s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),3)
	.Q:dicDesc'["用法用量"
	.s rightType = ""
	.for  s rightType = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType))  Q:rightType=""  d
	..s rightDic = ""
	..for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic))  Q:rightDic=""  d
	...Q:+rightDic=0
	...s ruleDataId = ""
	...for  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic,ruleId,ruleDataId)) Q:ruleDataId=""  d
	....s nodeId = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),3)
	....s condition = $lg($g(^CT.CKB.PDSS.RuleNodeD(nodeId)),3)
	....Q:condition'="union"
	....s leftDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)	
	....s leftValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),5)	 		
	....s ruleRightDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),8)
	....s ruleRightType = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),10)
	....s rightValue =$lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),9)
	....s RightDicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+ruleRightDic),3)
	....Q:RightDicDesc'="全血"
	....s ruleArr(nodeId) = rightDic_"^"_ruleId
	.s rightExtType = ""
	.for  s rightExtType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType)) Q:rightExtType=""  d
	..s RightExt = ""
	..for  s RightExt = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,+RightExt))  Q:RightExt=""  D
	...Q:RightExt=0
	...s ruleExtDataId = ""
	...for  s ruleExtDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,+RightExt,ruleId,ruleExtDataId))  Q:ruleExtDataId=""  d
	....s nodeId = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),3)
	....s leftDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),4)	
	....s leftDicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDic),3)
	....s leftValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),5)	 		
	....s ruleRightExt = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),11)
	....s rightValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),9)
	....s rightLimit = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),12)
	....s option = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),7)
	....i $d(ruleArr(nodeId))  d
	.....i rightValue'=ctinVal s retval=-1
	.....e  s retval=""
	....Q:retval'=""
}

/// Descript:根据单位取单次剂量
/// w ##class(web.DHCCKBCalculateval).GetOnceDoseByUnit(3246,"mg/m2",2)
ClassMethod GetOnceDoseByUnit(durgId, unit, surArea)
{
	n (durgId,unit,surArea)
	s drugDicId = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	s onceDoseId = ##class(web.DHCCKBCommon).GetOnceDoseProp()
	s dayDoseId = ##class(web.DHCCKBCommon).GetDayDoseProp()
	s unitId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(unit),""))
	s listData = ""
	Q:unitId="" ""
	s ruleDicId = ""
	for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",durgId,ruleDicId))  Q:ruleDicId=""  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	.s catRuleId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDicId,""))
	.Q:catRuleId=""
	.s dicId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleId)),3)
	.s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),3)
	.Q:dicDesc'["用法用量"
	.s rightExtType = ""
	.for  s rightExtType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType)) Q:rightExtType=""  d
	..s ruleExtDataId = ""
	..for  s ruleExtDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,+unitId,ruleId,ruleExtDataId))  Q:ruleExtDataId=""  d
	...s leftDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),4)	
	...s leftDicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDic),3)
	...s leftValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),5)	 		
	...s ruleRightExt = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),11)
	...s rightValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),9)
	...s rightLimit = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),12)
	...s option = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),7)
	...Q:(leftDic'=onceDoseId)&&(leftDic'=dayDoseId)
	...i listData=""  d
	....i rightLimit="" s listData = leftDicDesc_":"_(rightValue*surArea)_unit
	....e  s listData = leftDicDesc_":"_(rightValue*surArea)_"~"_(rightLimit*surArea)_unit
	...e  d
	....i rightLimit="" s listData = listData_"&"_leftDicDesc_":"_(rightValue*surArea)_unit
	....e  s listData = listData_"&"_leftDicDesc_":"_(rightValue*surArea)_"~"_(rightLimit*surArea)_unit
	Q listData
}

/// Descript:根据属性查询规则中引用的数据和药品
/// w ##class(web.DHCCKBCalculateval).QueryDrugByAttr(38,"用法用量")
/// drugDesc_"^"_drugCatDesc_"^"_typeDesc_"^"_attrVal_"^"_ruleNo
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryDrugByAttr",38,"用法用量") 
Query QueryDrugByAttr(attrId, cat) As websys.Query(ROWSPEC = "drugDesc:%String:药品名称,drugCatDesc:%String:目录,typeDesc:%String:属性,attrVal:%String:属性名称,ruleNo:%String:规则序号,parentCat:%String:上级")
{
}

ClassMethod QueryDrugByAttrExecute(ByRef qHandle As %Binary, attrId, cat) As %Status
{
	n (qHandle,attrId,cat)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	s medDicId = ##class(web.DHCCKBCommon).GetDrugData()
	s chnDicId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s drugDictionId = ##class(web.DHCCKBCommon).GetDrugLibaryData()	
	s h = 0,count = 0,num = 0
	k catArr
	s contraId = "0"
	for  s contraId = $o(^CKB.PDSS.ComContrastD(contraId))  Q:contraId=""  d
	.s listData =$g(^CKB.PDSS.ComContrastD(contraId))
	.s libDesc = $lg(listData,3)				//知识库描述
	.s hisCode = $lg(listData,4)	
	.Q:'$d(^CKB.PDSS.ExtDictionI("Code",94,hisCode))
	.s type = $lg(listData,6)						//字典类型
	.Q:(type'="")&&(type'=medDicId)&&(type'=chnDicId)		//过滤非药品
	.s IncId = ..GetDicId(libDesc,type)
	.Q:IncId=""
	.s ruleDicId = ""
	.for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",IncId,ruleDicId))  Q:ruleDicId=""  d
	..s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)										// 规则Id
	..s catRuleId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDictionId,""))		// 目录一级Id 
	..Q:catRuleId=""    																																						//过滤用药教育
	..s catId = $lg($g(^CT.CKB.PDSS.RuleDicD(catRuleId)),3)										// 目录Id
	..s catCode = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),2)
	..s catDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),3)
	..Q:(cat'="")&&(catDesc'[cat)
	..s catIndex = catId _"^"_ catDesc _"^"_ IncId_"^"_ ruleId
	..s num = num+1
	..s catArr(catIndex) = catId _"^"_ catDesc _"^"_ IncId_"^"_ ruleId
	
	Q:num=0 ""
	k ruleDataArr
	
	s index=""
	for  s index = $o(catArr(index)) Q:index=""  d
	.s ruleCatId  =$p(index,"^",1)
	.s ruleCatCode = $lg(^CT.CKB.PDSS.CommonDictionD(+ruleCatId),2)
	.s ruleCatDesc = $p(index,"^",2)
	.s drugId = $p(index,"^",3)
	.s dicRuleId = $p(index,"^",4)
	.s rightType = ""
	.for  s rightType = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType)) Q:rightType=""  d
	..s rightDic = ""
	..for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic)) Q:rightDic=""  d
	...Q:rightDic=0
	...s ruleDataId = ""
	...for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic,dicRuleId,ruleDataId)) Q:ruleDataId=""  d
	....s leftDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)	
	....s leftValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),5)	 		
	....s ruleRightDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),8)
	....s ruleRightType = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),10)
	....s rightValue =$lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),9)
	....Q:leftDic=""
	....Q:leftDic'=attrId					//过滤调非查询的属性
	....s ruleIndex = ruleDataId
	....s h = h+1
	....s ruleDataArr(ruleIndex) = drugId_"^"_ruleCatId_"^"_ruleCatDesc_"^"_leftDic_"^"_leftValue_"^"_ruleRightDic_"^"_rightValue_"^"_rightType_"^"_dicRuleId
	;.s rightExtType = ""
	;.for  s rightExtType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType)) Q:rightExtType=""  d
	;..s rightExt = ""
	;..for  s rightExt = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,rightExt))  Q:rightExt=""  d
	;...Q:rightExt="0"
	;...s ruleExtDataId = ""
	;...for  s ruleExtDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,+rightExt,dicRuleId,ruleExtDataId))  Q:ruleExtDataId=""  d
	;....s leftDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),4)	
	;....s leftValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),5)	 		
	;....s ruleRightExt = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),11)
	;....s rightValue = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),9)
	;....s rightLimit = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),12)
	;....s ruleRightDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),8)
	;....s option = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),7)
	;....Q:leftDic'=attrId
	;....Q:leftDic=""
	;....s ruleIndex = ruleExtDataId
	;....s h = h+1
	;....s ruleDataArr(ruleIndex) = drugId_"^"_ruleCatId_"^"_ruleCatDesc_"^"_leftDic_"^"_leftValue_"^"_ruleRightDic_"^"_rightValue_"^"_rightExtType_"^"_dicRuleId
	
	s outIndex=""
	s listData=""
	for  s outIndex = $o(ruleDataArr(outIndex))  Q:outIndex=""  d
	.s mdata = $g(ruleDataArr(outIndex))
	.s ruelIncId = $p(mdata,"^",1)
	.s drugDesc = ""
	.s:ruelIncId'="" drugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+ruelIncId),3)
	.s drugCatDesc = $p(mdata,"^",3)
	.s tyepId = $p(mdata,"^",4)
	.s typeDesc = ""
	.s:tyepId'="" typeDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+tyepId),3) 
	.s ruleAttrId = $p(mdata,"^",5)
	.s ruleAttrDesc = ""
	.s:ruleAttrId'="" ruleAttrDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+ruleAttrId),3)
	.s attrValId = $p(mdata,"^",6)
	.s attrType = $p(mdata,"^",7)
	.s attrLinkId = $lg(^CT.CKB.PDSS.CommonDictionD(+attrValId),5)
	.s:attrValId'="" attrVal = $lg(^CT.CKB.PDSS.CommonDictionD(+attrValId),3)
	.i (attrVal="")&&(attrLinkId'="") s attrVal = $lg(^CT.CKB.PDSS.CommonDictionD(+attrLinkId),3)
	.s ruleNo = $p(mdata,"^",9)
	.s parentCat = ..GetFirCat(attrValId)
	.set ^CacheTemp(repid,ind)=$lb(drugDesc,drugCatDesc,typeDesc,attrVal,ruleNo,parentCat)
	.set ind=ind+1	
	;.i listData="" d
	;..s listData = drugDesc_"^"_drugCatDesc_"^"_typeDesc_"^"_attrVal_"^"_ruleNo
	;.e  s listData = listData_"&"_drugDesc_"^"_drugCatDesc_"^"_typeDesc_"^"_attrVal_"^"_ruleNo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 取字典id，根据描述和上级
/// w ##class(web.DHCCKBCalculateval).GetDicId("A、C、Y、W135群脑膜炎球菌多糖疫苗",49802)
ClassMethod GetDicId(dicDesc, dictionId)
{
	n (dicDesc,dictionId)
	s ret = ""
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc),dicId))  Q:dicId=""  d
	.s parent = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),4)
	.Q:parent'=dictionId
	.s ret = dicId
	Q ret
}

/// Descript:取第一级分类
/// w ##class(web.DHCCKBCalculateval).GetFirCat(49912)
ClassMethod GetFirCat(catId)
{
	n (catId)
	s cat = ""
	Q:catId="" ""
	s parCatId = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),4)
	s cat = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),3)
	Q:parCatId=106 cat
	s cat = ..GetFirCat(parCatId)
	Q cat
}

/// Descript:his频次系数和知识库频次系数对照(读取txt的方式)
/// Creator:sufan
/// CreateDate:2020-07-18
/// w ##Class(websys.Query).ToExcel("频次匹配数据","web.DHCCKBCalculateval","QueryMatchFreqCoe","C:\Users\Administrator\Desktop\his频次.txt")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryMatchFreqCoe","C:\Users\Administrator\Desktop\his频次.txt") 
Query QueryMatchFreqCoe(filepath) As websys.Query(ROWSPEC = "hisFreq:%String:His频次,hisCoe:%String:His频次系数,libFreq:%String:知识库频次,libCoe:%String:知识库频次系数")
{
}

ClassMethod QueryMatchFreqCoeExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k freqArr
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s freqLsit = $tr(onerow,$c(9),del)
	.s count=count+1
	.s freqArr(count) = freqLsit
	c filepath 
	
	k macthArr
	s index = "",h = 0
	for  s index = $o(freqArr(index))  Q:index=""  d
	.s hisFreq = $p(freqArr(index),"^",2)
	.s hisCoe = $p(freqArr(index),"^",3)
	.i '$d(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisFreq)))   d
	..s ^CacheTemp(repid,ind)=$lb(hisFreq,hisCoe,"","")
	..s ind=ind+1	
	.s contraId = ""
	.for  s contraId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisFreq),contraId)) Q:contraId=""  d
	..s libFreq = $lg(^CKB.PDSS.ComContrastD(contraId),3)
	..s libCoe = ..GetFreqFacUom(libFreq)
	..s libCoe = $list(libCoe,1)
	..Q:libCoe=hisCoe
	..s h = h+1
	..s macthArr(h) = hisFreq_"^"_hisCoe_"^"_libFreq_"^"_libCoe
	..set ^CacheTemp(repid,ind)=$lb(hisFreq,hisCoe,libFreq,libCoe)
	..set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:his给药途径和知识库的匹配情况
/// Creator:sufan
/// CreateDate:2020-07-18
/// w ##Class(websys.Query).ToExcel("给药途径未对照数据","web.DHCCKBCalculateval","QueryMatchRouadm","C:\Users\Administrator\Desktop\his频次.txt")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryMatchRouadm","C:\Users\Administrator\Desktop\his频次.txt") 
Query QueryMatchRouadm(filepath) As websys.Query(ROWSPEC = "hisRou:%String:给药途径")
{
}

ClassMethod QueryMatchRouadmExecute(ByRef qHandle As %Binary, filepath) As %Status
{
	n (qHandle,filepath)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k rouArr
	S count = 0
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s end=0
	d $ZU(68,40,1)
	for  d  q:end'=0
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s rouLsit = $tr(onerow,$c(9),del)
	.s count=count+1
	.s rouArr(count) = rouLsit
	c filepath 
	
	k macthArr
	s index = "",h = 0
	for  s index = $o(rouArr(index))  Q:index=""  d
	.s hisRou = $p(rouArr(index),"^",2)
	.Q:$d(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisRou)))   d
	.s ind=ind+1	
	.s h = h+1
	.set ^CacheTemp(repid,ind)=$lb(hisRou)
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class("web.DHCCKBCalculateval").GetFreqFacUom("3997")
ClassMethod GetFreqFacUom(Freq As %String) As %String
{
	n (Freq)
	q:Freq="" ""
	s FreqID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(Freq),""))
	q:+FreqID=0 ""
	s FreqFacUnitProp=##class(web.DHCCKBCommon).GetFreqFactorUnitProp()   /// 用药频次转换因子单位
	s FreqFacProp=##class(web.DHCCKBCommon).GetFreqFactorProp()		/// 用药频次转换因子
	s Fac=""
	s Group="",FreqUnit="",FreqUnitDesc="",FreqFac="",FreqList=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",FreqID,FreqFacUnitProp,LinkID))  q:LinkID=""  d
	.s FreqUnit=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.s DicLinkDr=$lg(^CT.CKB.PDSS.CommonDictionD(+FreqUnit),5)
	.q:FreqUnit=""
	.s FreqUnitDesc=$case(+DicLinkDr'=0,1:$lg(^CT.CKB.PDSS.CommonDictionD(+DicLinkDr),3),:$lg(^CT.CKB.PDSS.CommonDictionD(+FreqUnit),3))
	.s Group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),6)	
	
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",FreqID,FreqFacProp,LinkID))  q:LinkID=""  d
	.q:Group'=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),6)	
	.s FreqFac=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)
	
	s FreqList=$lb(FreqFac,FreqUnit,FreqUnitDesc)
	q:Freq="" ""
	q:Freq'="" FreqList
}

/// 更新系数
ClassMethod GetCoe(matchArr)
{
	n (matchArr)
	s freqDicId = ##class(web.DHCCKBCommon).GetDrugFreqData()
	s ret = 0
	s index = ""
	for  s index = $o(matchArr(index))  Q:index=""  d
	.s freq = $p(matchArr(index),"^",3)
	.s freqId = ..GetFreDicId(freqDicId,freq)
	.s freCoe = $p(matchArr(index),"^",2)
	.s ret = ..UpdCoe(freqId,freCoe)
}

/// w ##class("web.DHCCKBCalculateval").GetFreDicId(105,"注射用重组人白介素-2(125Ala)10万IU(北京双鹭药业股份有限公司)")
ClassMethod GetFreDicId(freqDicId, freq, drugCode = "")
{
	n (freqDicId,freq,drugCode)
	s ret = "",ClibIdList=""
	s freqId = ""
	for  s freqId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(freq),freqId))  Q:(freqId="")  d
	.s parfreqId = $lg(^CT.CKB.PDSS.CommonDictionD(+freqId),4)
	.Q:freqDicId'=parfreqId
	.s ret = freqId

	
	s codeRet = ""
	i drugCode'=""  d
	.for  s freqId = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(drugCode),freqId))  Q:freqId=""  d
	..s parfreqId = $lg(^CT.CKB.PDSS.CommonDictionD(+freqId),4)
	..Q:freqDicId'=parfreqId
	..s codeRet = freqId
	Q:(codeRet'=ret) ""
	Q ret
}

ClassMethod UpdCoe(freqId, FreCoe)
{
	n (freqId, FreCoe)
	s attrcodeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4("ChangeFactorProp"),""))
	Q:attrcodeId="" ""
	s linkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrcodeId,linkPropId))  d
	.s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",attrcodeId,linkPropId,""))
	.s attrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)
	.s dicId = ""
	.for  s dicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",attrId,dicId))  Q:dicId=""  d
	..s datasource = ##class(web.DHCCKBRangeCat).GetAddAttrSource(dicId,"DataSource")
	..Q:datasource'=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",freqId,dicId))  d
	...s dicAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",freqId,dicId,""))
	...&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Result=:FreCoe where DLA_RowID=:dicAttrId )
	..e  d
	...s fredicId = ""
	...for  s fredicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",attrId,fredicId))  Q:fredicId=""  d
}

/// Descript:查询哈医大药品，通用名，分类，成分，剂型
/// Creator:sufan
/// CreateDate:2020-07-20
/// w ##Class(websys.Query).ToExcel("药品分类数据","web.DHCCKBCalculateval","QueryIncInfo","95")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryIncInfo","142^^^^^0^^") 
Query QueryIncInfo(params) As websys.Query(ROWSPEC = "drugId:%String:drugId,drug:%String:药品名称,hisCode:%String:his药品代码,extDesc:%String:his药品名称,generName:%String:通用名,drugComp:%String:成分,drugDosa:%String:剂型,drugCat:%String:分类,sameGenDrug:%String:相同通用名的药品,type:%String:字典,drugCatId:%String:drugCatId,rule:%String:是否存在规则,generFormName:%String:带剂型的通用名,drugManuf:%String:生产厂家,equunit:%String:等效单位,hisequunit:%String:HIS等效单位,nounitinlib:%String:等效单位中不存在的单位,errruleNum:%String:错误规则序号,usadosRule:%String:用法用量中存在溶媒溶液,diseList:%String:疾病")
{
}

ClassMethod QueryIncInfoExecute(ByRef qHandle As %Binary, params) As %Status
{
	n (qHandle,params)
	s ^temptest("params")=$lb(params)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	//drug,generName,drugCat,drugComp,drugDosa
	s hosp = $p(params,"^",1)
 	s hospCode = ""
	s:hosp'="" hospCode = $p(^CT("HOSP",hosp),"^",1)
	s drugDesc = $p(params,"^",2)
	s geneDesc = $p(params,"^",3)
	s ingrDesc = $p(params,"^",4)
	s isEmpty = $p(params,"^",5)
	s isDefalt = $p(params,"^",7)
	s isCheckbox = $p(params,"^",6)
	s indrugcat = $p(params,"^",8)
	d ##Class(web.DHCCKBCalculateval).reloadHisEqunit(hospCode)
	s drugDictionId = ##class(web.DHCCKBCommon).GetDrugData()			//西药字典
 	s chnDictionId = ##class(web.DHCCKBCommon).GetChineseDrugData() 		//中成药字典
 	s chineseHMId =  ##class(web.DHCCKBCommon).GetChineseHMData() // 中药饮片字典
 	
	i (hosp = "")&&(isDefalt'="")   d  				//院区为空时，查询知识库所有药品
	.s dictionList = drugDictionId_"^"_chnDictionId_"^"_chineseHMId
	.s length = $l(dictionList,"^")
	.for i=1:1:length  d
	..s dictionId = $p(dictionList,"^",i)
	..s drugId = ""
	..s generName = "",drugCat = "",drugComp = "",drugDosa = "",ruleFlag = "N",drugManuf = "",equunit = "",nounitinlib = ""
	..s errruleNum = ""
	..s hisCode = "",desc = ""
	..s type = $lg(^CT.CKB.PDSS.CommonDictionD(+dictionId),2)
	..for  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dictionId,drugId))  Q:drugId=""  d
	...s drug = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	...s generName = ##class(web.DHCCKBDrugVO).GetGenerName(drugId)						//通用名
	...s drugComp = ##class(web.DHCCKBDrugVO).GetIngredient(drugId) 																			//成分
	...s drugDosa = ##class(web.DHCCKBDrugVO).GetFormType(drugId)																						//剂型
	...s drugCatList = ##class(web.DHCCKBDrugVO).GetCat(drugId)	
	...Q:(indrugcat'="")&&(drugCatList'[indrugcat)	
	...s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 			//适应症属性
	...s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,Indic,1) 			//kml																						//分类
	...s drugCat = $p(drugCatList,"$",1)
	...s drugCat = $replace(drugCat,"^","<br>")
	...s sameGenDrugList = ..GetCatWithSameGenname(drugId,generName)
	...s sameGenDrug = $p(sameGenDrugList,"$",1)
	...s drugCatId = $p(sameGenDrugList,"$",2)
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(drugId)		//判断是否有规则
	...s rule = $s(ruleFlag="1":"存在规则",1:"不存在规则")
	...s generFormName = ##class(web.DHCCKBDrugVO).GetGenerFromName(drugId)
	...s drugManuf = ##class(web.DHCCKBDrugVO).GetDrugManuf(drugId)		//生产厂家
	...s equunit = ##class(web.DHCCKBDrugVO).GetEquunit(drugId)									//等效单位
	...s hisequunit = $g(^tempsufan(hospCode,drugId))
	...s nounitinlib = $g(^tempsufan("QueryunitInRule",drugId))		//..QueryunitInRule(drugId)							//规则中存在，等效单位中不存在的单位
	...s errruleNum = $g(^tempAllErrRule(drugId))
	...s usadosRule = $g(^tempmensolrule(drugId))
	...s ruleUsageattr	= ##Class(web.DHCCKBCommon).GetDrugAttrId("RuleUsage")
	...s ruleUsage = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,ruleUsageattr,1) 
	...s phaToxattr	= ##Class(web.DHCCKBCommon).GetDrugAttrId("药理毒理")
	...s phaTox = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,phaToxattr,1) 
	...s pharmacattr = ##Class(web.DHCCKBCommon).GetDrugAttrId("药代动力学")
	...s pharmac = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,pharmacattr,1) 
	...s funIndicatattr = ##Class(web.DHCCKBCommon).GetDrugAttrId("FunIndicat")
	...s FunIndicat = ##Class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,funIndicatattr,1)
	...s phaKinattr = ##Class(web.DHCCKBCommon).GetDrugAttrId("药代动力学")
	...s phaKin = ##Class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,phaKinattr,1)
	...s relFlag = ##class(web.DHCCKBCalculateval).IsRelRules(drugId)
	...s diseList = ""
	...Q:(drugDesc'="")&&(drug'[drugDesc)
	...Q:(geneDesc'="")&&(generName'[geneDesc)
	...Q:(ingrDesc'="")&&(ingrDesc'[drugComp)
	...Q:(isEmpty="Gene")&&(generName'="")
	...Q:(isEmpty="Comp")&&(drugComp'="")
	...Q:(isEmpty="Dosa")&&(drugDosa'="")
	...Q:(isEmpty="Cat")&&(drugCat'="")
	...Q:(isEmpty="Drug")&&(drugId'="")
	...Q:(isEmpty="Rule")&&(ruleFlag="1")
	...Q:(isEmpty="FormGen")&&(generFormName'="")
	...Q:(isEmpty="Manuf")&&(drugManuf'="")
	...Q:(isEmpty="Equunit")&&(equunit'="")
	...Q:(isEmpty="Noninunit")&&(nounitinlib="")
	...Q:(isCheckbox="1")&&(drugManuf'[",")
	...Q:(isEmpty="Verrule")&&(errruleNum="")
	...Q:(isEmpty="UsaDos")&&(usadosRule="")
	...Q:(isEmpty="Indicat")&&(Indication="")
	...Q:(isEmpty="Usage")&&(ruleUsage'="")
	...Q:(isEmpty="PhaTox")&&(phaTox'="")
	...Q:(isEmpty="Indicat")&&(type="DrugData")&&(Indication'="")
	...Q:(isEmpty="Indicat")&&(type="ChineseDrugData")&&(FunIndicat'="")
	...Q:(isEmpty="PhaKin")&&(phaKin'="")
	...Q:(isEmpty="CancelRel")&&(relFlag="0")
	...s drug = $tr(drug,$c(9),"")
	...s extDesc = $tr(desc,"\","")
	...set ^CacheTemp(repid,ind)=$lb(drugId,drug,hisCode,extDesc,generName,drugComp,drugDosa,drugCat,sameGenDrug,type,drugCatId,rule,generFormName,drugManuf,equunit,hisequunit,nounitinlib,errruleNum,usadosRule)
	...set ind=ind+1	
	e  d					//查询已对照数据
	.s typeStr = "DrugData^ChineseDrugData^ChineseHerbalMedicineData"
	.for i=1:1:$l(typeStr,"^")  d
	..s type = $p(typeStr,"^",i)
	..s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	..s extId = "0"
	..for  s extId = $o(^CKB.PDSS.ExtDictionI("Type",hosp,type,extId))  Q:extId=""  d
	...s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	...s hisCode = $lg(extData,2) 
	...s hisDesc = $lg(extData,3)
	...;s type = $lg(extData,4)
	...s conDicId = ""
	...s desc = $p(hisDesc,"||",1)
	...for  s conDicId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(desc),conDicId))  Q:conDicId=""  d
	....s listData =$g(^CKB.PDSS.ComContrastD(conDicId))
	....s drug = $lg(listData,3)
	....s drugCode = $lg(listData,2)
	....s hisCode = $lg(listData,4)
	....s conHosp = $lg(listData,7)
	....q:(hosp'="")&&(conHosp'=hosp)
	....s drugId = ..GetFreDicId(dictionId,drug,drugCode)
	....s generName = "",drugCat = "",drugComp = "",drugDosa = "",ruleFlag = "N",drugManuf = "",equunit = "",nounitinlib = ""
	....s errruleNum = "",relFlag = ""
	....i drugId'=""  d
	.....s generName = ##class(web.DHCCKBDrugVO).GetGenerName(drugId)						//通用名
	.....s drugComp = ##class(web.DHCCKBDrugVO).GetIngredient(drugId) 																			//成分
	.....s drugDosa = ##class(web.DHCCKBDrugVO).GetFormType(drugId)																						//剂型
	.....s drugCatList = ##class(web.DHCCKBDrugVO).GetCat(drugId)																								//分类
	.....s drugCat = $p(drugCatList,"$",1)
	.....s drugCat = $replace(drugCat,"^","<br>")
	.....s sameGenDrugList = ..GetCatWithSameGenname(drugId,generName)
	.....s sameGenDrug = $p(sameGenDrugList,"$",1)
	.....s drugCatId = $p(sameGenDrugList,"$",2)
	.....s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(drugId)		//判断是否有规则
	.....s rule = $s(ruleFlag="1":"存在规则",1:"不存在规则")
	.....s generFormName = ##class(web.DHCCKBDrugVO).GetGenerFromName(drugId)
	.....s drugManuf = ##class(web.DHCCKBDrugVO).GetDrugManuf(drugId)		//生产厂家
	.....s equunit = ##class(web.DHCCKBDrugVO).GetEquunit(drugId)			//等效单位
	.....s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 			//适应症属性
	.....s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,Indic,1) 			//kml
	.....s ruleUsageattr	= ##Class(web.DHCCKBCommon).GetDrugAttrId("RuleUsage")
	.....s ruleUsage = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,ruleUsageattr,1) 
	.....s hisequunit = $g(^tempsufan(hospCode,drugId))
	.....s nounitinlib = $g(^tempsufan("QueryunitInRule",drugId))  //..QueryunitInRule(drugId)	 //规则中存在，等效单位中不存在的单位
	.....s errruleNum = $g(^tempAllErrRule(drugId))
	.....s usadosRule = $g(^tempmensolrule(drugId))
	.....s phaToxattr = ##Class(web.DHCCKBCommon).GetDrugAttrId("PhaToxicology")   //"药理毒理")
	.....s phaTox = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,phaToxattr,1) 
	.....s pharmacattr = ##Class(web.DHCCKBCommon).GetDrugAttrId("药代动力学")
	.....s pharmac = ##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,pharmacattr,1) 
	.....s funIndicatattr = ##Class(web.DHCCKBCommon).GetDrugAttrId("FunIndicat")
	.....s FunIndicat = ##Class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,funIndicatattr,1)
	.....s phaKinattr = ##Class(web.DHCCKBCommon).GetDrugAttrId("Pharmacokinetics")   //药代动力学")
	.....s phaKin = ##Class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,phaKinattr,1)
	.....s relFlag = ##class(web.DHCCKBCalculateval).IsRelRules(drugId)
	.....s diseList = ""
	....Q:(indrugcat'="")&&(drugCat'[indrugcat)	
	....Q:(drugDesc'="")&&(drug'[drugDesc)
	....Q:(geneDesc'="")&&(generName'[geneDesc)
	....Q:(ingrDesc'="")&&(ingrDesc'[drugComp)
	....Q:(isEmpty="Gene")&&(generName'="")
	....Q:(isEmpty="Comp")&&(drugComp'="")
	....Q:(isEmpty="Dosa")&&(drugDosa'="")
	....Q:(isEmpty="Cat")&&(drugCat'="")
	....Q:(isEmpty="Drug")&&(drugId'="")
	....Q:(isEmpty="Rule")&&(ruleFlag="1")
	....Q:(isEmpty="FormGen")&&(generFormName'="")
	....Q:(isEmpty="Manuf")&&(drugManuf'="")
	....Q:(isEmpty="Equunit")&&(equunit'="")
	....Q:(isCheckbox="1")&&(drugManuf'[",")
	....Q:(isEmpty="Noninunit")&&(nounitinlib="")
	....Q:(isEmpty="Verrule")&&(errruleNum="")
	....Q:(isEmpty="UsaDos")&&(usadosRule="")
	....Q:(isEmpty="Indicat")&&(type="DrugData")&&(Indication'="")
	....Q:(isEmpty="Indicat")&&(type="ChineseDrugData")&&(FunIndicat'="")
	....Q:(isEmpty="Usage")&&(ruleUsage'="")
	....Q:(isEmpty="PhaTox")&&(phaTox'="")
	....Q:(isEmpty="PhaKin")&&(phaKin'="")
	....Q:(isEmpty="CancelRel")&&(relFlag="0")
	....s drug = $tr(drug,$c(9),"")
	....s extDesc = $tr(desc,"\","")
	
	....set ^CacheTemp(repid,ind)=$lb(drugId,drug,hisCode,extDesc,generName,drugComp,drugDosa,drugCat,sameGenDrug,type,drugCatId,rule,generFormName,drugManuf,equunit,hisequunit,nounitinlib,errruleNum,usadosRule,diseList)
	....set ind=ind+1	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:取通用名相同的药品的分类
/// w ##class(web.DHCCKBCalculateval).GetCatWithSameGenname("90740","维生素C") 
ClassMethod GetCatWithSameGenname(drugId, generName)
{
	n (drugId,generName)
	Q:generName="" ""
	s catList = ""
	s genDictionId = ##class(web.DHCCKBCommon).GetGeneralData()
	s length = $l(generName,",")
	;Q:length>1 ""
	s num=0
	k drugcatArr
	for i=1:1:length  d
	.s tempDesc = $p(generName,",",i)
	.s generNameId = ..GetDicId(tempDesc, genDictionId)
	.q:generNameId=""
	.s attrId = ""
	.for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",generNameId,attrId))  Q:attrId=""  d
	..s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	..Q:drugId=dicId
	..s lingen = ##class(web.DHCCKBDrugVO).GetGenerName(dicId)
	..Q:$L(lingen,",")>1
	..s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),3)
	..Q:dicDesc=""
	..s dicDesc = $tr(dicDesc,",","")
	..s drugCat = ##class(web.DHCCKBDrugVO).GetCat(dicId)	
	..Q:drugCat=""
	..s num = num+1
	..s drugcatArr(num) =  drugCat
	
	k tmpCarArr
	s index = "",i = 1,catIdList = ""
	for  s index = $o(drugcatArr(index))  q:index=""  d
	.s drugcatList = drugcatArr(index)
	.s cat = $p(drugcatList,"$",1)
	.s catId = $p(drugcatList,"$",2)
	.i catIdList = "" s catIdList = catId
	.e  s catIdList = catIdList_"^"_catId
	.s len = $l(cat,"^")
	.for k=1:1:len   d
	..s tempCat = $p(cat,"^",k)
	..Q:tempCat=""
	..Q:$d(tmpCarArr(tempCat))
	..s tmpCarArr(tempCat) = tempCat
	..s list = i_"."_tempCat_"<br>"
	..i catList = ""  s catList = list
	..e  s catList = catList_"<br>"_list
	..s i = i+1
	Q catList_"$"_catIdList
}

/// Descript:是否存在未发布的规则
/// Creator:sufan
/// CreateDate:2022-01-11
/// w ##class(web.DHCCKBCalculateval).IsRelRules()
ClassMethod IsRelRules(drugId)
{
	n (drugId)
	s existFlag = 1
	s ruleDicId = ""
	for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicId))  Q:(ruleDicId="")||(existFlag=0)  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	.s status = $lg($g(^CT.CKB.PDSS.RuleD(ruleId)),4)
	.Q:status="CancelRelease"
	.s existFlag = 0
	Q existFlag
}

/// Descript:导出对照数据
/// Creator:sufan
/// CreateDate:2020-07-20
/// w ##Class(websys.Query).ToExcel("对照数据","web.DHCCKBCalculateval","QueryContraData","94^DrugData")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryContraData","94") 
Query QueryContraData(params) As websys.Query(ROWSPEC = "libCode:%String:知识库数据代码,libDesc:%String:知识库数据描述,hisCode:%String:项目数据代码,hisDesc:%String:项目数据描述,note:%String:备注,hospDesc:%String:医院,type:%String:字典")
{
}

ClassMethod QueryContraDataExecute(ByRef qHandle As %Binary, params) As %Status
{
	n (qHandle,params)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	//libCode,libDesc,hisCode,hisDesc,note,hospDesc,type
	s hosp = $p(params,"^",1)
	s typeCode = $p(params,"^",2)
	s extId = "0"
	for  s extId = $o(^CKB.PDSS.ExtDictionI("Type",hosp,typeCode,extId))  Q:extId=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	.s hisCode = $lg(extData,2)   				//hiscode
	.s hisCode = $tr(hisCode,",","")
	.s hisDesc = $lg(extData,3)					//hisdesc
	.s hisDesc = $p(hisDesc,"||",1)
	.s type = $lg(extData,4) 					//字典
	.s extHosp = $lg(extData,5)					//医院
	.s hospDesc = $p(^CT("HOSP",extHosp),"^",2)
	.s note = ""
	.s conDicId = ""
	.for  s conDicId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),conDicId))  Q:conDicId=""  d
	..s listData =$g(^CKB.PDSS.ComContrastD(conDicId))
	..s libCode = $lg(listData,2)
	..s libDesc = $lg(listData,3)
	..set ^CacheTemp(repid,ind)=$lb(libCode,libDesc,hisCode,hisDesc,note,hospDesc,type)
	..set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:成分数据导入
/// Creator:2020-07-28
/// w ##Class(web.DHCCKBCalculateval).ImportData("C:\Users\Administrator\Desktop\药品分类数据20200728.txt")
ClassMethod ImportData(filepath)
{
	n (filepath)
	S count = 0
	k catArr
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s listData = $tr(onerow,$c(9),del)
	.Q:$p(listData,"^",6)=""
	.s list = $p(listData,"^",2)_"^"_$p(listData,"^",5)_"^"_$p(listData,"^",6)_"^"_$p(listData,"^",9)
	.s count=count+1
	.Q:count=1
	.s catArr(count)=list
	c filepath

	s ret = ..ImportIngredient(.catArr)
	Q ret
}

ClassMethod ImportIngredient(inArr)
{
	n (inArr)
	TS
	s ret = 0
	s index = ""
	for  s index = $o(inArr(index))  Q:(index="")||(ret'=0)  D
	.Q:ret'=0
	.s drugName = $p(inArr(index),"^",1)					//药品名称
	.s oldIngre = $p(inArr(index),"^",2)					//已维护成分
	.s ingreList = $p(inArr(index),"^",3)				//成分
	.s dictionCode = $p(inArr(index),"^",4)		//字典代码
	.s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(dictionCode)
	.s drugId = ..GetFreDicId(dictionId,drugName)
	.i drugId = "" s ^TMP("ImportIngredient",drugName) = drugName
	.Q:drugId=""
	.i oldIngre'=""  d
	..s ret = ..DelOldData(drugId)
	.Q:ret'=0
	.s ret = ..InsNewIngre(drugId,ingreList)

	i ret'=0 TRO
	TC
	Q ret
}

/// Descript：删除旧的数据
/// w ##class(web.DHCCKBCalculateval).DelOldData(94914)
ClassMethod DelOldData(drugId)
{
	n (drugId)
	s ret=0
	TS
	s ingreProp = ##class(web.DHCCKBCommon).GetIngredientPropTemp()
	s Id = "",list = ""
	for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",ingreProp,Id))  Q:(Id="")||(ret'=0)  d
	.s attrId = ""
	.for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,Id,attrId))   Q:(attrId="")||(ret'=0)  d
	..Q:ret'=0
	..s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	..s result = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5)
	..s groupFlag = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	..s text = ""
	..i dicId="" s text = result
	..e  s text = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),3)
	..i $d(^TMP("DelOldData",drugId,groupFlag))  d
	...s ^TMP("DelOldData",drugId,groupFlag)=^TMP("DelOldData",drugId,groupFlag)_","_attrId_":"_text
	..e  d
	...s ^TMP("DelOldData",drugId,groupFlag)=$lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)_":"_attrId_":"_text
	..s ret =  ##class(web.DHCCKBDicLinkAttr).DelData(attrId)
	
	i ret'=0 TRO
	TC
	Q ret
}

/// Descript：新增成分数据
/// w ##class(web.DHCCKBCalculateval).InsNewIngre(94914,"多肽、核苷酸类物质")
ClassMethod InsNewIngre(drugId, ingreList)
{
	n (drugId,ingreList)
	s ingreCodeId = ##class(web.DHCCKBCommon).GetIngredientCode()
	s ingreMeteId = ##class(web.DHCCKBCommon).GetIngredientMete()
	s ingreUnitId = ##class(web.DHCCKBCommon).GetIngredientUnit()
	s ingreDicionId = ##class(web.DHCCKBCommon).GetIngreData()
	s length = $l(ingreList,"、")
	s ret=0 
	TS
	for i=1:1:length Q:ret'=0  d
	.s ingre = $p(ingreList,"、",i)
	.s ingreId = ..GetFreDicId(ingreDicionId,ingre)
	.s retval = ""
	.i ingreId=""  d
	..s list = "^^^"_ingreDicionId_"^"_ingre
	..s retval = ##class(web.DHCCKBDicLinkAttr).InsDic(list)
	..s ^TMP("UPDATE","InsNewIngre",drugId,retval)=$lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)_":"_ingre
	.s:retval'="" ingreId = retval
	.s pid = ##class(web.DHCCKBCommonUtil).NewPid() 
	.&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_GroupFlag) values(:drugId,:ingreCodeId,:ingreId,:pid))
	.s ret=SQLCODE
	.Q:ret'=0
	.&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_GroupFlag) values(:drugId,:ingreMeteId,:pid))
	.s ret=SQLCODE
	.Q:ret'=0
	.&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_GroupFlag) values(:drugId,:ingreUnitId,:pid))
	.s ret=SQLCODE
	.Q:ret'=0
	.s ^TMP("UPDATE","NewIngre",drugId,ingreId)=$lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)_":"_ingre
	i ret'=0 TRO
	TC
	Q ret
}

/// Descript：query数据转换
/// w ##class(web.DHCCKBCalculateval).QueryIncInfoJson("30","1","142^^^^^0^^")
ClassMethod QueryIncInfoJson(rows, page, params)
{
	 n (rows,page,params)
	 s ^temptest("1357")=$lb(rows,page,params)
	 s End=page*rows
	 s Start=(page-1)*rows+1
	 s result=##class(%Library.ResultSet).%New("web.DHCCKBCalculateval:QueryIncInfo")
	 s sc=result.Execute(params)
	 If $$$ISERR(sc) Quit ""
	 s colNum=result.GetColumnCount() //列数
	 s count = 0
	 s del=""""
	 Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	 While(result.Next())
		{ 
			Set ret=""
			For i=1:1:colNum Do
			.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
			.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
			.
			s count=count+1
			Continue:(count<Start)||(count>End)
			If count=Start Write "{"_ret_"}"
			Else  Write ",{"_ret_"}"
		 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

/// w ##class(web.DHCCKBCalculateval).GetDrugCatHtml("74918^74918^74918^^^^74918")
ClassMethod GetDrugCatHtml(drugCatId)
{
	n (drugCatId)
	s htmlStr = ""
	s:drugCatId="" htmlStr="<span>分类为空</span>"
	Q:drugCatId="" htmlStr
	s length = $l(drugCatId,"^")
	k catArr
	for i=1:1:length  d
	.s tempCatId = $p(drugCatId,"^",i)
	.Q:tempCatId=""
	.Q:$d(catArr(tempCatId))
	.s catArr(tempCatId)=tempCatId
	.;s catDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+tempCatId),3)
	.;s linkId = $lg(^CT.CKB.PDSS.CommonDictionD(+tempCatId),5)
	.;i (catDesc = "")&&(linkId'="") s catDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+linkId),3)
 	.s catDesc = ##class(web.DHCCKBDrugVO).GetCatHier(tempCatId)
	.i htmlStr="" s htmlStr = "<input style='margin-top:5px;' class='hisui-checkbox' type='checkbox' label='"_catDesc_"' name='cat' id='"_tempCatId_"'>"
	.e  s htmlStr = htmlStr_"<br><input style='margin-top:5px;' class='hisui-checkbox' type='checkbox' label='"_catDesc_"' name='cat' id='"_tempCatId_"' >"
	Q htmlStr
}

/// w ##class(web.DHCCKBCalculateval).InsertCat("101349","68755","DrugData")
ClassMethod InsertCat(drugId, listData, type)
{
	n (drugId,listData,type)
	Q:drugId="" "-1"
	s err = 0
	s catPropId = ##class(web.DHCCKBCommon).GetPhCategory()
	i type="ChineseDrugData" s catPropId = $o(^CT.CKB.PDSS.CommonDictionI("Link",catPropId,""))
	ts
	s length = $l(listData,"^")
	for i=1:1:length Q:err'=0  d
	.s catId = $p(listData,"^",i)
	.q:$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",drugId,catPropId,catPropId))
	.s List = ""_"^"_drugId_"^"_catPropId_"^"_catId
	.s err = ##class(web.DHCCKBDicLinkAttr).InsText(List)
	.Q:err'=0
	i err'=0 tro
	tc
	q err
}

/// Descript:导出未匹配数据
/// Creator:sufan
/// CreateDate:2020-07-18
/// w ##Class(websys.Query).ToExcel("未匹配药品据列表品","web.DHCCKBCalculateval","QueryNotMatchDrug","95")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryNotMatchDrug","95") 
Query QueryNotMatchDrug(params) As websys.Query(ROWSPEC = "hisCode:%String:his代码,hisDesc:%String:his名称,type:%String:字典代码")
{
}

ClassMethod QueryNotMatchDrugExecute(ByRef qHandle As %Binary, params) As %Status
{
	n (qHandle,params)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	s hosp = $p(params,"^",1)
	
	s typeCode = "0"
	for  s typeCode = $o(^CKB.PDSS.ExtDictionI("Type",hosp,typeCode))  Q:typeCode=""  d
	.s extId = ""
	.for  s extId = $o(^CKB.PDSS.ExtDictionI("Type",hosp,typeCode,extId))  Q:extId=""   d
	..s extData = $g(^CKB.PDSS.ExtDictionD(extId)) 
	..s hisCode = $lg(extData,2) 
	..s hisDesc = $lg(extData,3) 	//hisdesc
	..s hisDesc = $p(hisDesc,"||",1)
	..s type = $lg(extData,4)      //字典
	..Q:(type'="DrugData")
	..Q:$d(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisDesc)))
	..set ^CacheTemp(repid,ind)=$lb(hisCode,hisDesc,type)
	..set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:核查对照数据 【知识库对HIS一对多的关系数据】
/// Creator:sufan
/// CreateDate:2020-09-28
/// w ##class(web.DHCCKBCalculateval).QueryLibMatchHis(30,1,"2^105")
ClassMethod QueryLibMatchHis(rows, page, params)
{
	n (rows, page,params)
	s ^tempsufan("45678")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s num = 0
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid)
	s hospId = $p(params,"^",1)
	s dictionId = $p(params,"^",2)
	s dictionType = ""
	s:dictionId'="" dictionType = $lg(^CT.CKB.PDSS.CommonDictionD(+dictionId),2)
	Q:(hospId="")||(dictionType="") ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s extDicId = ""
	for  s extDicId = $o(^CKB.PDSS.ExtDictionI("Type",hospId,dictionType,extDicId))  Q:extDicId=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extDicId)) 
	.s hisCode = $lg(extData,2)			//hisCode
	.s hisDesc = $lg(extData,3)			//hisDesc
	.s hisDesc = $p(hisDesc,"||",1)
	.s contraId = ""
	.for  s contraId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisDesc),contraId))  Q:contraId=""  d
	..s libDesc = $lg(^CKB.PDSS.ComContrastD(contraId),3)
	..;s h = h+1
	..d ..GetContraDataList(libDesc,hospId,pid,.num)   //存储异常数据

	i num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(num) //输出json结尾符
	q:num=0 ""

	///转换数据为Json格式
	s count = 0
	S ListTitle="libDesc^hisDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(num) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid,index)) q:index=""  d
	.s consId = ""
	.for  s consId = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid,index,consId))  Q:consId=""  d
	..s hisDesc=$g(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid,index,consId))
	..s ListData = index_"^"_hisDesc
	..s count = count+1
	..q:(count<Start)||(count>End)
	..I count=Start d
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid)
	q ""
}

/// Descript:核查对照数据
/// Creator:wangxin
/// CreateDate:2020-10-27
/// w ##class(web.DHCCKBCalculateval).QueryProMatchHis(30,1,"96^105")
ClassMethod QueryProMatchHis(rows, page, params)
{
	n (rows, page,params)
	s ^tempsufan("45678")=$lb(rows, page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s num = 0
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProMatchHis",pid)
	s hospId = $p(params,"^",1)
	s dictionId = $p(params,"^",2)
	s dictionType = ""
	s:dictionId'="" dictionType = $lg(^CT.CKB.PDSS.CommonDictionD(+dictionId),2)
	Q:(hospId="")||(dictionType="") ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s extDicId = ""
	for  s extDicId = $o(^CKB.PDSS.ExtDictionI("Type",hospId,dictionType,extDicId))  Q:extDicId=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extDicId)) 
	.s hisCode = $lg(extData,2)	//hisCode
	.s hisDesc = $lg(extData,3) //hisDesc
	.s hisDesc = $p(hisDesc,"||",1)
	.s count = 0
	.d ..GetConHisToLibList(hisDesc,hospId,pid,.num)   //存储异常数据*/

	i num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(num) //输出json结尾符
	q:num=0 ""
	///转换数据为Json格式
	s count = 0
	S ListTitle="libDesc^hisDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(num) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProMatchHis",pid,index)) q:index=""  d
	.s consId = ""
	.for  s consId = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProMatchHis",pid,index,consId))  Q:consId=""  d
	..s libDesc=$g(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProMatchHis",pid,index,consId))
	..s ListData = libDesc_"^"_index
	..s count = count+1
	..q:(count<Start)||(count>End)
	..I count=Start d
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProMatchHis",pid)
	q ""
}

/// Descript:核查对照数据 【知识库对HIS一对多的关系数据】
/// Creator:sufan
/// CreateDate:2020-09-28 
/// w ##class(web.DHCCKBCalculateval).GetContraDataList("注射用苯唑西林钠",2,1)
ClassMethod GetContraDataList(libDesc, hospId, pid, num)
{
	n (libDesc,hospId,pid,num)
	s h = 0 
	s hisDesc = ""
	for  s hisDesc = $o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc),hisDesc))  Q:hisDesc=""  d
	.s contraId = ""
	.for  s contraId = $o(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc),hisDesc,contraId)) Q:contraId=""  d
	..s hisCode = $lg(^CKB.PDSS.ComContrastD(contraId),4)
	..Q:'$d(^CKB.PDSS.ExtDictionI("Code",hospId,hisCode))
	..s h = h+1
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid,libDesc,contraId) = hisDesc
	i h<2 k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid,libDesc)
	i h>1 s num = num + h
	//zw ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryLibMatchHis",pid)
	Q ""
}

/// Descript:核查对照数据 【HIS对知识库一对多的关系数据】
/// Creator:sufan
/// CreateDate:2020-09-28 
/// w ##class(web.DHCCKBCalculateval).GetConHisToLibList("静注人免疫球蛋白(5% 50ml:2.5g/瓶)",96,1,1)
ClassMethod GetConHisToLibList(hisDesc, hospId, pid, num)
{
	n (hisDesc,hospId,pid,num)
	s h = 0
	s contraId = ""
	for  s contraId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisDesc),contraId))  Q:contraId=""  d
	.s libDsc = $lg(^CKB.PDSS.ComContrastD(contraId),3)
	.s h = h+1
	.s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProMatchHis",pid,hisDesc,contraId) = libDsc
	i h<2 k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProMatchHis",pid,hisDesc)
	i h>1 s num = num + h
	Q ""
}

/// Descript:查找药品code重复的所有数据
/// Creator:sufan
/// CreateDate:2020-10-12
/// w ##class(web.DHCCKBCalculateval).QueryCodeRepeatDrugs()
ClassMethod QueryCodeRepeatDrugs(pid)
{
	n (pid)
	s drugDictionId = ##class(web.DHCCKBCommon).GetDrugData()
	s chnDictionId = ##class(web.DHCCKBCommon).GetChineseDrugData()

	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryCodeRepeatDrugs",pid)
	k drugArr
	s Id = ""
	for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",drugDictionId,Id)) Q:Id=""  d
	.s code = $lg(^CT.CKB.PDSS.CommonDictionD(+Id),2)
	.s desc = $lg(^CT.CKB.PDSS.CommonDictionD(+Id),3)
	.i $d(drugArr(code))  d
	..s index = Id_","_code
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryCodeRepeatDrugs",pid,index) = Id_"^"_code_"^"_desc_"^"_$lg(^CT.CKB.PDSS.CommonDictionD(+drugDictionId),2)
	..s drugId = $g(drugArr(code))
	..s drugCode = $lg(^CT.CKB.PDSS.CommonDictionD(drugId),"^",1)
	..s drugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(drugId),"^",2)
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryCodeRepeatDrugs",pid,drugId_","_code) = drugId_"^"_drugCode_"^"_drugDesc_"^"_$lg(^CT.CKB.PDSS.CommonDictionD(+drugDictionId),2)
	.s drugArr(code)=Id
	k drugArr
	s Id = ""
	for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",chnDictionId,Id)) Q:Id=""  d
	.s code = $lg(^CT.CKB.PDSS.CommonDictionD(+Id),2)
	.s desc = $lg(^CT.CKB.PDSS.CommonDictionD(+Id),3)
	.i $d(drugArr(code))  d
	..s index = Id_","_code
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryCodeRepeatDrugs",pid,index) = Id_"^"_code_"^"_desc_"^"_$lg(^CT.CKB.PDSS.CommonDictionD(+chnDictionId),2)
	..s drugId = $g(drugArr(code))
	..s drugCode = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),2)
	..s drugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryCodeRepeatDrugs",pid,drugId_","_code) = drugId_"^"_drugCode_"^"_drugDesc_"^"_$lg(^CT.CKB.PDSS.CommonDictionD(+chnDictionId),2)
	.s drugArr(code)=Id
	Q ""
}

/// Descript:导出代码重复数据
/// Creator:sufan
/// CreateDate:2020-10-12
/// w ##Class(websys.Query).ToExcel("代码重复数据","web.DHCCKBCalculateval","ExportRepeatDrugs")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","ExportRepeatDrugs") 
Query ExportRepeatDrugs() As websys.Query(ROWSPEC = "hisCode:%String:代码,hisDesc:%String:名称,type:%String:字典代码")
{
}

ClassMethod ExportRepeatDrugsExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	d ..QueryCodeRepeatDrugs(pid)
	
	
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryCodeRepeatDrugs",pid,index))  Q:index=""  d
	.s data = $g(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryCodeRepeatDrugs",pid,index))
	.s hisCode = $p(data,"^",2)
	.s hisDesc = $p(data,"^",3)
	.s type = $p(data,"^",4)
	.set ^CacheTemp(repid,ind)=$lb(hisCode,hisDesc,type)
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:处方审核结果分析  根据审查日志遍历查询数据
/// Creator:sufan
/// CreateDate:2020-11-06
/// w ##class(web.DHCCKBCalculateval).QueryPrescAuditRes("30","1","2020-10-10","2020-10-10")
ClassMethod QueryPrescAuditRes(rows, page, stDate, endDate)
{
	n (rows, page,stDate,endDate)
	
	s End=page*rows
	s Start=(page-1)*rows+1
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	Q:(stDate="")||(endDate="") ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	
	s h = 0
	s presnum = 0
	s errpresnum = 0
	k monArr
 	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes")
 	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE")
	for date = stDate:1:endDate  d
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s admId = $lg(monData,2)			//就诊
	..s auditDate = $lg(monData,3)		//审查日期
	..s:auditDate'="" auditDate = $zd(auditDate,3)
	..s auditRes = $lg(monData,10)	//审查日期
	..s retObj = ##class(%DynamicArray).%FromJSON(auditRes)
	..s presnum = presnum+1
	..s passFalg = $lg(monData,7)	//通过标记
	..s:passFalg=0 errpresnum = errpresnum+1
	..d getOutMsg
	..s msg = $tr(msg,$c(11),"")
	..s monItmId = ""
	..for  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId))  Q:monItmId=""  d
	...s itemId = $lg(^CKB.PDSS.MonQueListD(monItmId),3) 
	...s monindex = monId_","_itemId
	...Q:$d(monArr(monindex))
	...s monArr(monindex) = monId_"^"_itemId
	...s itemDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+itemId),3)
	...s h = h+1
	...i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",itemId))  d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",itemId) = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",itemId)+1
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",itemId) = 1
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes",pid,h) = itemId_"^"_itemDesc_"^"_admId_"^"_auditDate_"^"_msg
	
	
	Q:h=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	
	s errDrugnum=""
	s errpresrate = 0
	s:errpresnum'=0 errpresrate = $fn((errpresnum/presnum)*100,"",2)
	s errDrugnum = ..getDrugErrNum()
	s listTitile = "itemDesc^auditDate^msg"
	s count = 0
	w "{""rows"":["
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes",pid,index))  Q:index=""  d
	.s data = $g(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes",pid,index))
	.s drugDesc = $p(data,"^",2)
	.s date = $p(data,"^",4)
	.s outmsg = $p(data,"^",5)
	.s listData = drugDesc_"^"_date_"^"_outmsg
	.s count = count+1
	.q:(count<Start)||(count>End)
	.w $case(count,Start:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(listTitile,listData)
	w "],""total"":"_h
	s del=""""
	w ","_del_"errpresnum"_del_":"_errpresnum_","_del_"errpresrate"_del_":"_errpresrate_","_del_"presnum"_del_":"_presnum
	w ","_del_"errDrugnum"_del_":"_errDrugnum
	w "}"
	Q ""
getOutMsg
	set itemsObj=retObj.%Get("items")
	set iterator=itemsObj.%GetIterator()
	while iterator.%GetNext(.key,.val) {
			s msgArr=val.%Get("warns")
			s iterRule=msgArr.%GetIterator()
			s msg=""
			s itmmsg=""		
		 while iterRule.%GetNext(.rulekey,.ruleval) {
			 	s itmArr=ruleval.%Get("itms") //{"key":"成分相互作用测试","keyname":"成分相互作用测试","val":"","manLev                el":"warn","manLev":"警示","itms"
					s labelname=ruleval.%Get("keyname")
					
					s iteritm=itmArr.%GetIterator()					
					s infomsg=""
					while iteritm.%GetNext(.itmkey,.itmval) {
							s infoArr=itmval.%Get("itms")
							continue:infoArr=""
							s iterinfo=infoArr.%GetIterator()	
							while(iterinfo.%GetNext(.infokey,.infoval)){
									s warnMsg=infoval.%Get("val")
									s warnMsg=$tr(warnMsg,$c(10),"")
								 s warnMsg=$tr(warnMsg,$c(10,13),"")
									s warnMsg=$tr(warnMsg,",","、")
									i infomsg= "" d  s infomsg=warnMsg		
									e  d  s infomsg=infomsg_";"_warnMsg	
							}
					}
					i itmmsg= ""  s itmmsg=labelname_":"_infomsg	
					e  s itmmsg=itmmsg_$c(11)_labelname_":"_infomsg	//$c(11)垂直制表符号		
					s itmmsg=$tr(itmmsg,",","、")	
			}
			s msg=itmmsg
			s msg=$tr(msg,",","")
	}
}

/// Descript:药品排行明细
/// Creator:sufan
/// CreateDate:2020-11-06
/// w ##class(web.DHCCKBCalculateval).QueryDrugRankDetails(2,1)
ClassMethod QueryDrugRankDetails(rows, page)
{
	n (rows, page)
	s End=page*rows
	s Start=(page-1)*rows+1
	s totalNum = ..getTotalErrNum()
	s count = 0
	s listTitile = "itemDesc^errNum^rate"
	w "{""rows"":["
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",index)) Q:index=""  d
	.s itemDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+index),3)
	.s errNum = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",index)
	.s rate = $fn((errNum/totalNum)*100,"",2)
	.s listData = itemDesc_"^"_errNum_"^"_rate
	.s count = count+1
	.q:(count<Start)||(count>End)
	.w $case(count,Start:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(listTitile,listData)
	w "],""total"":"_count_"}"
	Q ""
}

/// Descript:取药品错误总数
/// Creator:sufan
/// CreateDate:2020-11-06
ClassMethod getTotalErrNum()
{
	s totalNum = 0
	s index = 0
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",index)) Q:index=""  d
	.s num = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",index)
	.s totalNum = totalNum+num
	Q totalNum
}

/// Descript:取药品错误
/// Creator:sufan
/// CreateDate:2020-11-06
ClassMethod getDrugErrNum()
{
	s totalNum = 0
	s index = 0
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescAuditRes","DRUGRATE",index)) Q:index=""  d
	.s totalNum = totalNum+1
	Q totalNum
}

/// Descript:药品个目录错误数
/// Creator:sufan
/// CreateDate:2020-11-06   
/// w ##class(web.DHCCKBCalculateval).QueryErrRuleCat("30","1","2021-02-01^2021-02-09^^^true^^哈尔滨医科大学第一附属医院202102010209")
/// w ##class(web.DHCCKBCalculateval).QueryErrRuleCat("30","1","2022-06-07^2022-06-09^^^true^^129^")
ClassMethod QueryErrRuleCat(rows, page, params)
{
	n (rows,page,params)

	s End=page*rows
	s Start=(page-1)*rows+1
	s stDate = $p(params,"^",1)
	s endDate = $p(params,"^",2)
	s drugId = $p(params,"^",3)
	s ordcon = $p(params,"^",4)
	s switchs=$p(params,"^",5)
	s queryLoc = $p(params,"^",6)
	s hospId = $p(params,"^",7)
	s manLevel = $p(params,"^",8)
	d ##Class(web.DHCCKBDrugRank).KillTmpGlobal()	// qnp 2020/11/25
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid)
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid)
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCatOrd",pid)
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","ERRPRESC",pid)
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","ERRDRUGCAT",pid)
	
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","ErrorRule",pid)   //yuliping 规则错误标记统计
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","CorrectRule",pid) //yuliping 规则正确标记统计
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","ErrorRuleNum",pid)   //yuliping 规则错误标记统计 数量
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","CorrectRuleNum",pid) //yuliping 规则正确标记统计 数量

	
	/*取药品目录*/
	s comDosageId = ##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")									//用法
	s ruleUsageId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")									//用法用量
	s interEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("InterEach")								 //相互作用
	s tabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("Taboo")																 //配伍禁忌
	s drugIrriId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugIrri")										 //药物过敏
	s ruleIndicId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")									//适应症
	s ruleContrId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")									//禁忌症
	s ruleMatNeAtId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleMatNeAt")				 //注意事项
	s ruleContrTwoId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContrTwo")			//禁忌
	s funIndicatId = ##class(web.DHCCKBCommon).GetDicIdByCode("FunIndicat")						 //功能主治
	s repeatId = ##class(web.DHCCKBCommon).GetDicIdByCode("Repeat")						 //重复用药
	s skinTestRuleId = ##class(web.DHCCKBCommon).GetDicIdByCode("SkinTestRule")						 //皮试用药
	s drugInterEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugInterEach")		//药物相互作用
	s warnId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugNotification")							//警告
	s liquidConfigId = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")					//液体配置
	s translateId = ##class(web.DHCCKBCommon).GetDicIdByCode("片剂给药途径")			//片剂的给药途径
	s repeatIngId = ##class(web.DHCCKBCommon).GetDicIdByCode("RepeatIngr")				//成分重复
	s eighteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("EighteenTaboo")		//十八反
	s nineteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("NineteenTaboo")		//十九畏
	s bsgmId = ##class(web.DHCCKBCommon).GetDicIdByCode("bsgm")							//本品过敏
	
	//存数据
	s h=0,count = 0
	s ret = ..getPrescData(pid,stDate,endDate,drugId,queryLoc,hospId,manLevel)
	s h = $p(ret,"^",1)
	s errRate = 0
	s prescNum = $p(ret,"^",2)
	s errorprescNum = $p(ret,"^",3)
	s:prescNum'=0 errRate = $fn((+errorprescNum/prescNum)*100,"",2)
	s propNum=$p(ret,"^",4)
	s tipsNum=$p(ret,"^",5)
	s warnnNum=$p(ret,"^",6)
	s forbidNum=$p(ret,"^",7)
	s allthisNum=propNum+tipsNum+warnnNum+forbidNum
	
	s:allthisNum'=0 propNum = $fn((+propNum/allthisNum)*100,"",2)
	
	s:allthisNum'=0 tipsNum = $fn((+tipsNum/allthisNum)*100,"",2)
	
	s:allthisNum'=0 warnnNum = $fn((+warnnNum/allthisNum)*100,"",2)
	
	s:allthisNum'=0 forbidNum = $fn((+forbidNum/allthisNum)*100,"",2)
	Q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s listTitle = "pid^drugId^drugDesc^comDosageNum^ruleUsageNum^interEachNum^tabooNum^drugIrriNum^ruleIndicNum"
	s listTitle = listTitle_"^ruleContrNum^ruleMatNeAtNum^ruleContrTwoNum^funIndicatNum^repeatNum^skinTestRuleNum"
	s listTitle = listTitle_"^drugInterEachNum^warnNum^transNum^liquidConfigNum^repeatIngNum^eighteenTabooNum^nineteenTabooNum^bpgmNum^monId"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	//处理排序问题
	
	i ordcon'=""  d
	.s ordConDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+ordcon),3)
	.s ret = ..getCatIdByDesc(ordConDesc,1)
	.s indexItm = ""
	.for  s indexItm = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,indexItm))  Q:indexItm=""  d
	..s numdata = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,indexItm)
	..s indexNum = $p(numdata,"^",ret)
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCatOrd",pid,indexNum,indexItm) = numdata
	
	
	i ordcon="" d
	.s itmId=""
	.for  s itmId = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId))  Q:itmId=""  d
	..s numdata=^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId)
	..s sum=$p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",21)
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCats",pid,sum,itmId) = numdata
	

	
	i ordcon'=""  d
	.s indexCatNum = ""
	.for  s indexCatNum = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCatOrd",pid,indexCatNum),-1) Q:indexCatNum=""  d
	..s indexdrug = ""
	..for  s indexdrug = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCatOrd",pid,indexCatNum,indexdrug),-1)  Q:indexdrug=""  d
	...s data = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCatOrd",pid,indexCatNum,indexdrug)
	...s drugId = indexdrug
	...s drugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	...s count = count+1
	...s sum=0
	...s number=..numberstatis(pid,drugId,comDosageId)
	...s sum=sum+number
	...s comDosageNum = $s(number=0:$p(data,"^",1),1:number_"/"_$p(data,"^",1))
	...s number=..numberstatis(pid,drugId,ruleUsageId)
	...s sum=sum+number
	...s ruleUsageNum= $s(number=0:$p(data,"^",2),1:number_"/"_$p(data,"^",2))
	...s number=..numberstatis(pid,drugId,interEachId)
	...s sum=sum+number
	...s interEachNum=$s(number=0:$p(data,"^",3),1:number_"/"_$p(data,"^",3))
	...s number=..numberstatis(pid,drugId,tabooId)
	...s sum=sum+number
	...s tabooNum=$s(number=0:$p(data,"^",4),1:number_"/"_$p(data,"^",4))
	...s number=..numberstatis(pid,drugId,drugIrriId)
	...s sum=sum+number
	...s drugIrriNum=$s(number=0:$p(data,"^",5),1:number_"/"_$p(data,"^",5))
	...s number=..numberstatis(pid,drugId,ruleIndicId)
	...s sum=sum+number
	...s ruleIndicNum=$s(number=0:$p(data,"^",6),1:number_"/"_$p(data,"^",6))
	...s number=..numberstatis(pid,drugId,ruleContrId)
	...s sum=sum+number
	...s ruleContrNum=$s(number=0:$p(data,"^",7),1:number_"/"_$p(data,"^",7))
	...s number=..numberstatis(pid,drugId,ruleMatNeAtId)
	...s sum=sum+number
	...s ruleMatNeAtNum=$s(number=0:$p(data,"^",8),1:number_"/"_$p(data,"^",8))
	...s number=..numberstatis(pid,drugId,ruleContrTwoId)
	...s sum=sum+number
	...s ruleContrTwoNum=$s(number=0:$p(data,"^",9),1:number_"/"_$p(data,"^",9))
	...s number=..numberstatis(pid,drugId,funIndicatId)
	...s sum=sum+number
	...s funIndicatNum=$s(number=0:$p(data,"^",10),1:number_"/"_$p(data,"^",10))
	...s number=..numberstatis(pid,drugId,repeatId)
	...s sum=sum+number
	...s repeatNum=$s(number=0:$p(data,"^",11),1:number_"/"_$p(data,"^",11))
	...s number=..numberstatis(pid,drugId,skinTestRuleId)
	...s sum=sum+number
	...s skinTestRuleNum=$s(number=0:$p(data,"^",12),1:number_"/"_$p(data,"^",12))
	...s number=..numberstatis(pid,drugId,drugInterEachId)
	...s sum=sum+number
	...s drugInterEachNum=$s(number=0:$p(data,"^",13),1:number_"/"_$p(data,"^",13))
	...s number=..numberstatis(pid,drugId,warnId)
	...s sum=sum+number
	...s warnNum=$s(number=0:$p(data,"^",14),1:number_"/"_$p(data,"^",14))
	...s number=..numberstatis(pid,drugId,translateId)
	...s sum=sum+number
	...s transNum = $s(number=0:$p(data,"^",15),1:number_"/"_$p(data,"^",15))
	...s number=..numberstatis(pid,drugId,liquidConfigId)
	...s sum=sum+number
	...s liquidConfigNum = $s(number=0:$p(data,"^",16),1:number_"/"_$p(data,"^",16))
	...s number=..numberstatis(pid,drugId,repeatIngId)
	...s sum=sum+number
	...s repeatIngNum=$s(number=0:$p(data,"^",17),1:number_"/"_$p(data,"^",17))
	...s number=..numberstatis(pid,drugId,eighteenTabooId)
	...s sum=sum+number
	...s eighteenTabooNum=$s(number=0:$p(data,"^",18),1:number_"/"_$p(data,"^",18))
	...s number=..numberstatis(pid,drugId,nineteenTabooId)
	...s sum=sum+number
	...s nineteenTabooNum=$s(number=0:$p(data,"^",19),1:number_"/"_$p(data,"^",19))
	...s number=..numberstatis(pid,drugId,bsgmId)
	...s sum=sum+number
	...s bpgmNum=$s(number=0:$p(data,"^",20),1:number_"/"_$p(data,"^",20))
	...s numsum=$p(data,"^",21)
	...q:(switchs'="")&&(sum=numsum)&&(switchs="false")  d
	...s monId=$p(data,"^",22)			
	...s datalist=comDosageNum_"^"_ruleUsageNum_"^"_interEachNum_"^"_tabooNum_"^"_drugIrriNum_"^"_ruleIndicNum_"^"_ruleContrNum_"^"_ruleMatNeAtNum
	...s datalist=datalist_"^"_ruleContrTwoNum_"^"_funIndicatNum_"^"_repeatNum_"^"_skinTestRuleNum_"^"_drugInterEachNum_"^"_warnNum_"^"_transNum
	...s datalist=datalist_"^"_liquidConfigNum_"^"_repeatIngNum_"^"_eighteenTabooNum_"^"_nineteenTabooNum_"^"_bpgmNum_"^"_monId
	...s list = pid_"^"_drugId_"^"_drugDesc_"^"_datalist
	...;s list = pid_"^"_drugId_"^"_drugDesc_"^"_data
	...q:(count<Start)||(count>End)
	...i count=Start d
	....w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	...e  d
	....w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCatOrd",pid)
	e  d
	.s drugsNum=""
	.for  s drugsNum = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCats",pid,drugsNum),-1)  Q:drugsNum=""  d
	..s index = ""
	..for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCats",pid,drugsNum,index))  Q:index=""  d
	...s data = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCats",pid,drugsNum,index)	
	...s drugId = index
	...s drugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	...s count = count+1
	...S sum=0
 	...s number=..numberstatis(pid,drugId,comDosageId)
 	...s sum=sum+number
	...s comDosageNum = $s(number=0:$p(data,"^",1),1:number_"/"_$p(data,"^",1))
	...s number=..numberstatis(pid,drugId,ruleUsageId)
	...s sum=sum+number
	...s ruleUsageNum= $s(number=0:$p(data,"^",2),1:number_"/"_$p(data,"^",2))
	...s number=..numberstatis(pid,drugId,interEachId)
	...s sum=sum+number
	...s interEachNum=$s(number=0:$p(data,"^",3),1:number_"/"_$p(data,"^",3))
	...s number=..numberstatis(pid,drugId,tabooId)
	...s sum=sum+number
	...s tabooNum=$s(number=0:$p(data,"^",4),1:number_"/"_$p(data,"^",4))
	...s number=..numberstatis(pid,drugId,drugIrriId)
	...s sum=sum+number
	...s drugIrriNum=$s(number=0:$p(data,"^",5),1:number_"/"_$p(data,"^",5))
	...s number=..numberstatis(pid,drugId,ruleIndicId)
	...s sum=sum+number
	...s ruleIndicNum=$s(number=0:$p(data,"^",6),1:number_"/"_$p(data,"^",6))
	...s number=..numberstatis(pid,drugId,ruleContrId)
	...s sum=sum+number
	...s ruleContrNum=$s(number=0:$p(data,"^",7),1:number_"/"_$p(data,"^",7))
	...s number=..numberstatis(pid,drugId,ruleMatNeAtId)
	...s sum=sum+number
	...s ruleMatNeAtNum=$s(number=0:$p(data,"^",8),1:number_"/"_$p(data,"^",8))
	...s number=..numberstatis(pid,drugId,ruleContrTwoId)
	...s sum=sum+number
	...s ruleContrTwoNum=$s(number=0:$p(data,"^",9),1:number_"/"_$p(data,"^",9))
	...s number=..numberstatis(pid,drugId,funIndicatId)
	...s sum=sum+number
	...s funIndicatNum=$s(number=0:$p(data,"^",10),1:number_"/"_$p(data,"^",10))
	...s number=..numberstatis(pid,drugId,repeatId)
	...s sum=sum+number
	...s repeatNum=$s(number=0:$p(data,"^",11),1:number_"/"_$p(data,"^",11))
	...s number=..numberstatis(pid,drugId,skinTestRuleId)
	...s sum=sum+number
	...s skinTestRuleNum=$s(number=0:$p(data,"^",12),1:number_"/"_$p(data,"^",12))
	...s number=..numberstatis(pid,drugId,drugInterEachId)
	...s sum=sum+number
	...s drugInterEachNum=$s(number=0:$p(data,"^",13),1:number_"/"_$p(data,"^",13))
	...s number=..numberstatis(pid,drugId,warnId)
	...s sum=sum+number
	...s warnNum=$s(number=0:$p(data,"^",14),1:number_"/"_$p(data,"^",14))
	...s number=..numberstatis(pid,drugId,translateId)
	...s sum=sum+number
	...s transNum = $s(number=0:$p(data,"^",15),1:number_"/"_$p(data,"^",15))
	...s number=..numberstatis(pid,drugId,liquidConfigId)
	...s sum=sum+number
	...s liquidConfigNum = $s(number=0:$p(data,"^",16),1:number_"/"_$p(data,"^",16))
	...s number=..numberstatis(pid,drugId,repeatIngId)
	...s sum=sum+number
	...s repeatIngNum=$s(number=0:$p(data,"^",17),1:number_"/"_$p(data,"^",17))
	...s number=..numberstatis(pid,drugId,eighteenTabooId)
	...s sum=sum+number
	...s eighteenTabooNum=$s(number=0:$p(data,"^",18),1:number_"/"_$p(data,"^",18))
	...s number=..numberstatis(pid,drugId,nineteenTabooId)
	...s sum=sum+number
	...s nineteenTabooNum=$s(number=0:$p(data,"^",19),1:number_"/"_$p(data,"^",19))
	...s number=..numberstatis(pid,drugId,bsgmId)
	...s sum=sum+number
	...s bpgmNum=$s(number=0:$p(data,"^",20),1:number_"/"_$p(data,"^",20))
	...s numsum=$p(data,"^",21)
	...q:(switchs'="")&&(sum=numsum)&&(switchs="false")  d
	...s monId=$p(data,"^",22)
	...s datalist=comDosageNum_"^"_ruleUsageNum_"^"_interEachNum_"^"_tabooNum_"^"_drugIrriNum_"^"_ruleIndicNum_"^"_ruleContrNum_"^"_ruleMatNeAtNum
	...s datalist=datalist_"^"_ruleContrTwoNum_"^"_funIndicatNum_"^"_repeatNum_"^"_skinTestRuleNum_"^"_drugInterEachNum_"^"_warnNum_"^"_transNum
	...s datalist=datalist_"^"_liquidConfigNum_"^"_repeatIngNum_"^"_eighteenTabooNum_"^"_nineteenTabooNum_"^"_bpgmNum_"^"_monId
	...s list = pid_"^"_drugId_"^"_drugDesc_"^"_datalist	
	...q:(count<Start)||(count>End)
	...i count=Start d
	....w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	...e  d
	....w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,list)
	.k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCats",pid)
 w "]"
 w ",""prescNum"":"_prescNum_",""errorprescNum"":"_errorprescNum_",""errRate"":"_errRate_",""propNum"":"_propNum_",""tipsNum"":"_tipsNum_",""warnnNum"":"_warnnNum_",""forbidNum"":"_forbidNum_",""prescNum"":"_prescNum
 w "}"
	Q ""
}

/// Descrip:审核完成个数统计
/// Creator:wangxin
/// CreateDate:2020-12-1
/// w ##class(web.DHCCKBCalculateval).numberstatis(61840390,205,74540)
ClassMethod numberstatis(pid, drugId, catId)
{
	n (pid,drugId,catId)
	Q:(drugId = "")||(catId = "") ""
	Q:(+drugId =0)||(+catId=0) ""
	s cat = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),3)
	s drug = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	s h = 0,count = 0
	s monId = ""
	for  s monId = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,drugId,catId,monId)) Q:monId=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,drugId,catId,monId)
	.s monItmId = $p(data,"^",2)
	.s length=$l(monItmId,",")
	.for i=1:1:length d
	..s exasignval = $lg(^CKB.PDSS.MonQueListD($p(monItmId,",",i)),10) //标记
	..;i (exasignval="verifycorrect")||(exasignval="affirmcorrect")||(exasignval="achievecorrect")  d
	..Q:exasignval=""
	..s h=h+1
 	q h
}

/// Descript:存处方数据临时存储
/// Creator:sufan
/// CreateDate:2020-11-06
/// w ##class(web.DHCCKBCalculateval).getPrescData(1,66276,66276,"235622","","北海合浦卫校")
ClassMethod getPrescData(pid, stDate, endDate, drugId, queryLoc, hospDesc, queryLevel = "")
{
	n (pid,stDate,endDate,drugId,queryLoc,hospDesc,queryLevel)
	s searchHospId = ""
	i +hospDesc'=0 s searchHospId = $p(^CT("HOSP",+hospDesc),"^",2) 
	s queryLevelCode = ""
	s queryLevelCode = $lg(^CT.CKB.PDSS.CommonDictionD(+queryLevel),2)
	/*取药品目录*/
	s comDosageId = ##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")									//用法
	s ruleUsageId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")									//用法用量
	s interEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("InterEach")								 //相互作用
	s tabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("Taboo")										 //配伍禁忌
	s drugIrriId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugIrri")										 //药物过敏
	s ruleIndicId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")									//适应症
	s ruleContrId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")									//禁忌症
	s ruleMatNeAtId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleMatNeAt")				 //注意事项
	s ruleContrTwoId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContrTwo")			//禁忌
	s funIndicatId = ##class(web.DHCCKBCommon).GetDicIdByCode("FunIndicat")						 //功能主治
	s repeatId = ##class(web.DHCCKBCommon).GetDicIdByCode("Repeat")						 //重复用药
	s skinTestRuleId = ##class(web.DHCCKBCommon).GetDicIdByCode("SkinTestRule")			//皮试用药
	s drugInterEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugInterEach")		//药物相互作用
	s warnId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugNotification")				//警告
	s liquidConfigId = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")			//液体配置
	s translateId = ##class(web.DHCCKBCommon).GetDicIdByCode("片剂给药途径")			//片剂的给药途径
	s repeatIngId = ##class(web.DHCCKBCommon).GetDicIdByCode("RepeatIngr")				//成分重复
	s eighteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("EighteenTaboo")		//十八反
	s nineteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("NineteenTaboo")		//十九畏
	s bsgmId = ##class(web.DHCCKBCommon).GetDicIdByCode("bsgm")							//本品过敏
	
	s catList = ruleUsageId_"^"_ruleIndicId_"^"_ruleContrId_"^"_ruleMatNeAtId_"^"_ruleContrTwoId
	s catList = catList_"^"_funIndicatId_"^"_interEachId_"^"_tabooId_"^"_drugIrriId_"^"_translateId
	s prescNum = 0
	s errorprescNum = 0
	s propNum=0,tipsNum=0,warnnNum=0,forbidNum=0
	s h = 0,tmpCount=0,count=0
	for date = stDate:1:endDate  d
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s manLevel= $lg(monData,8) // qnp 2021/3/15 增加级别过滤
	..q:(queryLevelCode'="")&(queryLevelCode'=manLevel)
	..s loc = $lg(monData,6)
	..q:(queryLoc'="")&(loc'=queryLoc)	//qnp 2020/12/2 增加科室过滤
	..s hosp = $lg(monData,12)
	..//b:hosp=129 ;12
	..s hosp = $$ALPHAUP^SSUTIL4(hosp)
	..q:(hospDesc'="")&((hospDesc'=hosp)&&(hosp'=searchHospId)) //wangxin 2020/12/7  增加院区过滤
	..s exaParam = $lg(monData,9) //入参
	..q:exaParam["UNDEFINED"
	..s exaParamObj = ##class(web.DHCCKBCalculateval).FromJSON(exaParam)
	..q:exaParamObj="-1"
	..s passFlag = $lg(monData,7)
	..s prescNum = prescNum + 1
	..s:passFlag=0 errorprescNum = errorprescNum+1
	..s drugArr = exaParamObj.%Get("Drug")	
	..s length = drugArr.%Size()
	..s extFlag = 0 // 可以将st判断这部分取消掉 2020/12/16 qnp 用于统计哈医大前后两次的变化情况
	..f len=0:1:length-1  d
	...s drugObj = drugArr.%Get(len)
	...i (drugObj.DrugDrugFreq="st")||(drugObj.DrugDrugFreq="St") s extFlag=extFlag+1
	...
	..//q:(extFlag=1)&(length=1)
	..q:(extFlag=length)
	..s drugsNum = 0
	..s monItmId = ""	
	..for  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId)) Q:monItmId=""  d
	...s count=count+1
	...s comDosageNum = 0					//用法
	...s ruleUsageNum = 0					//用法用量
	...s interEachNum = 0 				//相互作用
	...s tabooNum = 0 								//配伍禁忌
	...s drugIrriNum = 0 					//药物过敏
	...s ruleIndicNum = 0  			//适应症
	...s ruleContrNum = 0  			//禁忌症
	...s ruleMatNeAtNum = 0 		//注意事项
	...s ruleContrTwoNum = 0  //禁忌
	...s funIndicatNum = 0    //功能主治
	...s repeatNum = 0		  //重复用药
	...s skinTestRuleNum = 0  //皮试用药
	...s drugInterEachNum = 0 //药物相互作用
	...s warnNum = 0	  	  //警告
	...s liquidConfigNum = 0  //液体配置
	...s transNum = 0		  //片剂给药途径  全局规则
	...s repeatIngNum = 0	  //成分重复	  全局规则
	...s eighteenTabooNum = 0	//十八反
	...s nineteenTabooNum = 0	//十九畏
	...s bpgmNum = 0			//本品过敏
	...s sum=0                //总数
	...s monData = $g(^CKB.PDSS.MonQueListD($p(monItmId,",",1)))
	...s itmId = $lg(monData,3)			//药品名称
	...Q:'$d(^CT.CKB.PDSS.CommonDictionD(+itmId))
	...Q:(drugId'="")&&(drugId'=itmId)
	...s catId = $lg(monData,4)		//目录id
	...s catCode = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),2)
	...Q:catCode="HighDangerDrug"
	...s exasignval = $lg(monData,10) // yuliping 2021-07-27  标记
	...s exasign = $s(exasignval="complet":"1",exasignval="uwcomplet":"规则错误，未完成",exasignval="partcomp":"规则错误，部分完成",exasignval="partcompcon":"规则错误，部分完成，需用户确认",exasignval="partcompproame":"规则错误，部分完成，需修正程序",exasignval="partcompruleimp":"规则错误，部分完成，需完善规则",exasignval="partcompdicimp":"规则错误，部分完成，需完善字典",exasignval="verifycorrect":"规则正确，需验证",exasignval="affirmcorrect":"规则正确，需用户确认",exasignval="achievecorrect":"规则正确，已完成",1:"")
	...d ##Class(web.DHCCKBDrugRank).SetMonTrendNum(date,catId,pid)	// 记录问题曲线 qnp 2020/11/25
	...s projectId = $lg(monData,5)		//目录项目Id
	...;b:catId=75
	...s:catId=comDosageId comDosageNum = comDosageNum+1
	...s:catId=ruleUsageId ruleUsageNum = ruleUsageNum+1
	...s:catId=interEachId interEachNum = interEachNum+1
	...s:catId=tabooId tabooNum = tabooNum+1
	...s:catId=drugIrriId drugIrriNum = drugIrriNum+1
	...s:catId=ruleIndicId ruleIndicNum = ruleIndicNum+1
	...s:catId=ruleContrId ruleContrNum = ruleContrNum+1
	...s:catId=ruleMatNeAtId ruleMatNeAtNum = ruleMatNeAtNum+1
	...s:catId=ruleContrTwoId ruleContrTwoNum = ruleContrTwoNum+1
	...s:catId=funIndicatId funIndicatNum = funIndicatNum+1
	...s:catId=repeatId repeatNum = repeatNum+1
	...s:catId=skinTestRuleId skinTestRuleNum = skinTestRuleNum+1
	...s:catId=drugInterEachId drugInterEachNum = drugInterEachNum+1
	...s:catId=warnId warnNum = warnNum+1
	...s:catId=liquidConfigId liquidConfigNum = liquidConfigNum+1
	...s:catId=translateId transNum = transNum+1
	...s:catId=repeatIngId repeatIngNum = repeatIngNum+1
	...s:catId=eighteenTabooId eighteenTabooNum = eighteenTabooNum+1
	...s:catId=nineteenTabooId nineteenTabooNum = nineteenTabooNum+1
	...s:catId=bsgmId bpgmNum = bpgmNum+1
	...;统计错误处方数量，同一个药品错误一次，算一个错误处方数
	...i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","ERRPRESC",pid,monId,itmId)) d
	....
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","ERRPRESC",pid,monId,itmId) = ""
	...i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","ERRDRUGCAT",pid,monId,itmId,catId))   d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","ERRDRUGCAT",pid,monId,itmId,catId) = ^TMP("DHCCKB","web.DHCCKBCalculateval","ERRDRUGCAT",pid,monId,itmId,catId)_","_monItmId
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","ERRDRUGCAT",pid,monId,itmId,catId) = monItmId
	...//计算各个级别数量：
	...s warnLevDesc=""
	...s warnLevDr=$lg(monData,7)	
	...s:warnLevDr'="" warnLevDesc=$lg(^CT.CKB.PDSS.CommonDictionD(+warnLevDr),3)
	...s:warnLevDesc="提示" propNum=propNum+1
	...s:warnLevDesc="提醒" tipsNum=tipsNum+1
	...s:warnLevDesc="警示" warnnNum=warnnNum+1
	...s:warnLevDesc="禁止" forbidNum=forbidNum+1
	...//计算总数
	...//s sum=comDosageNum+ruleUsageNum+interEachNum+tabooNum+drugIrriNum+ruleIndicNum+ruleContrNum+ruleMatNeAtNum+ruleContrTwoNum+funIndicatNum+bpgmNum   //+repeatNum+skinTestRuleNum+drugInterEachNum
	...s sum=comDosageNum+ruleUsageNum+interEachNum+tabooNum+drugIrriNum+ruleIndicNum+ruleContrNum+ruleMatNeAtNum+ruleContrTwoNum+funIndicatNum
	...s sum=sum+repeatNum+skinTestRuleNum+drugInterEachNum+warnNum+transNum+liquidConfigNum+eighteenTabooNum+repeatIngNum+nineteenTabooNum+bpgmNum   //+repeatNum+skinTestRuleNum+drugInterEachNum
	...
	...s listData = comDosageNum_"^"_ruleUsageNum_"^"_interEachNum_"^"_tabooNum_"^"_drugIrriNum_"^"_ruleIndicNum
	...s listData = listData_"^"_ruleContrNum_"^"_ruleMatNeAtNum_"^"_ruleContrTwoNum_"^"_funIndicatNum_"^"_repeatNum
	...s listData = listData_"^"_skinTestRuleNum_"^"_drugInterEachNum_"^"_warnNum_"^"_transNum_"^"_liquidConfigNum_"^"_repeatIngNum
	...s listData = listData_"^"_eighteenTabooNum_"^"_nineteenTabooNum_"^"_bpgmNum_"^"_sum
	...//存储药品目录数量
	...i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,itmId,catId,monId)) d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,itmId,catId,monId) = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,itmId,catId,monId)_","_monItmId
	...e  d  
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,itmId,catId,monId)=monId_"^"_monItmId
	...i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId))  d
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",1) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",1) + $p(listData,"^",1)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",2) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",2) + $p(listData,"^",2)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",3) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",3) + $p(listData,"^",3)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",4) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",4) + $p(listData,"^",4)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",5) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",5) + $p(listData,"^",5)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",6) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",6) + $p(listData,"^",6)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",7) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",7) + $p(listData,"^",7)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",8) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",8) + $p(listData,"^",8)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",9) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",9) + $p(listData,"^",9)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",10) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",10) + $p(listData,"^",10)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",11) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",11)+ $p(listData,"^",11)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",12) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",12)+ $p(listData,"^",12)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",13) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",13)+ $p(listData,"^",13)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",14) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",14)+ $p(listData,"^",14)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",15) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",15)+ $p(listData,"^",15)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",16) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",16)+ $p(listData,"^",16)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",17) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",17)+ $p(listData,"^",17)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",18) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",18)+ $p(listData,"^",18)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",19) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",19)+ $p(listData,"^",19)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",20) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",20)+ $p(listData,"^",20)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",21) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",21)+ $p(listData,"^",21)
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",22) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId),"^",22)_","_monId
	...e  d
	....s h = h+1
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryErrRuleCat",pid,itmId) = listData_"^"_monId
	
	q h_"^"_prescNum_"^"_errorprescNum_"^"_propNum_"^"_tipsNum_"^"_warnnNum_"^"_forbidNum
}

/// Descript:JSON串转换为JSON对象
/// w ##class(web.DHCCKBCalculateval).FromJSON()
ClassMethod FromJSON(jsonStr)
{
	n (jsonStr)
	s $ZT="jsonErr"
	s jsonObj = ##class(%DynamicArray).%FromJSON(jsonStr)
	Q jsonObj
jsonErr
 	Q "-1"
}

/// Descript:多项目审核明细
/// Creator:wangxin
/// CreateDate:2020-12-3
/// w ##class(web.DHCCKBCalculateval).QueryProComplist("30","1","202^WHSDYYY^46^")
ClassMethod QueryProComplist(rows, page, params)
{
	n (rows,page,params)
	s ^tmp("ss")=$lb(params)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s End=page*rows
	s Start=(page-1)*rows+1
	s drugId = $p(params,"^",1)      //药品id
	s hospcode = $p(params,"^",2)      //医院code
	s itmId = $p(params,"^",3)       //项目id
	s sign = $p(params,"^",4)
	Q:(drugId = "")||(itmId = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
 	s drug = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)   //药品名称
 	s itmdesc = $lg(^CT.CKB.PDSS.CommonDictionD(+itmId),3)   //项目名称  
	s h = 0,count = 0
	s monitd = ""        
	for  s monitd=$o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProComplist",monitd))  q:monitd=""  d
	.s data=^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProComplist",monitd)
	.s monItmId=$p(data,"^",1)
	.s monId=$p(data,"^",2)
	.s Hosp = $lg(^CKB.PDSS.MonMasterD(monId),12)     //医院
	.s:Hosp="" Hosp="东华标准版数字化医院[总院]"
	.s HospCodes=##class(web.DHCCKBCommonUtil).GetPYCODE(Hosp)
	.s HospCodes=$$ALPHAUP^SSUTIL4(HospCodes)
	.Q:(hospcode'=HospCodes)  
	.s drugIds = $lg(^CKB.PDSS.MonQueListD(monItmId),3)	 //药品Id
	.Q:(drugId'=drugIds)    
	.s itmIds = $lg(^CKB.PDSS.MonQueListD(monItmId),5)   //项目Id
	.Q:(itmId'=itmIds)      
	.d ..QueryData(monItmId,monId,sign,"",pid,.h,itmdesc,"QueryProCompdata","",drugId)


	Q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	s listTitle = "monId^monItmId^patName^sex^age^weight^hisAllergyList^diagList^drugNum^groupiden^drugName^onceDose"
	s listTitle = listTitle_"^unit^formProp^drugPreMet^drugFreq^treatment^drugOutParam^remarks^exasignval^exasign"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProCompdata",pid,index))  Q:index=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProCompdata",pid,index)
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProCompdata",pid)
	Q ""
}

/// Descript:处方审核明细
/// Creator:sufan
/// CreateDate:2020-11-06            
/// w ##class(web.DHCCKBCalculateval).QueryPrescDetails("30","1","287654835","623^74^^")
ClassMethod QueryPrescDetails(rows, page, pid, params)
{
	n (rows, page,pid,params)
	s ^temptest("555")=$lb(rows, page,pid,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s drugId = $p(params,"^",1)
	s catId = $p(params,"^",2)
	s sign = $p(params,"^",3)
	s exaResc = $p(params,"^",4)
	b
	Q:(drugId = "")||(catId = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
 	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetailsOut",pid)
 	k ^TMP("DHCCKB","web.DHCCKBCalculateval","GetCheckRes",pid)				//输出信息
 	s cat = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),3)
 	s drug = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
 	s h = 0,count = 0
 	s dataList=""
 
 	s monId = ""
	for  s monId = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,drugId,catId,monId)) Q:monId=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetails",pid,drugId,catId,monId)
	.s monItmId = $p(data,"^",2)
	.d ..QueryData(catId,monId,sign,cat,pid,.h,"","QueryPrescDetailsOut",exaResc,drugId)
 	
 	Q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	
	s listTitle = "monId^monItmId^patName^sex^age^weight^hisAllergyList^diagList^drugNum^groupiden^drugName^onceDose"
	s listTitle = listTitle_"^unit^formProp^drugPreMet^drugFreq^treatment^drugOutParam^remarks^exasignval^exasign^patNo"
	s listTitle = listTitle_"^funId"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) //输出json前缀串
	
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetailsOut",pid,index))  Q:index=""  d
	.s data = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetailsOut",pid,index)
	.s count = count+1
	.q:(count<Start)||(count>End)
	.i count=Start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,data)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryPrescDetailsOut",pid)
	//k ^TMP("DHCCKB","web.DHCCKBCalculateval","GetCheckRes",pid)				//输出信息
	Q ""
}

ClassMethod QueryData(catId, monId, sign, cat, pid, h, itemDesc, node, exaResc = "", drugId = "")
{
	n (catId,monId,sign,cat,pid,h,itemDesc,node,exaResc,drugId)
	s dataList=""
	s drug = ""
	s:drugId'="" drug = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	s monData = $g(^CKB.PDSS.MonMasterD(monId))
	s exaParam = $lg(monData,9)	//入参
	s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	s outParam =  $lg(monData,10) //出参
	//取患者信息
	s patName = exaParamObj.PatName
	s:patName="" patName="门诊"
	s episodeID = exaParamObj.EpisodeID
	s patientID = $p($g(^PAADM(+episodeID)),"^",1)
	s patNo = $p($g(^PAPER(+patientID,"PAT",1)),"^",1)  /// 登记号
	s sex = exaParamObj.SexProp
	s age = exaParamObj.AgeProp
	s weight = exaParamObj.Weight
	s patInfo = patName_"^"_sex_"^"_age_"^"_weight
	s hospital = exaParamObj.Hospital
	s hospId = ""
	i hospital'="" s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospital),""))
	//取过敏信息
	s hisAllergyList = ""
	s hisAllergyArr = exaParamObj.%Get("HisAllergy")
	s lenaller = hisAllergyArr.%Size()
	for i=0:1:lenaller-1  d
	.s allergyObj = hisAllergyArr.%Get(i)
	.s allergy = allergyObj.item
	.i hisAllergyList="" s hisAllergyList = allergy
	.e  s hisAllergyList = hisAllergyList_";"_allergy
	//取诊断信息
	s diagList = ""
	s diagArr = exaParamObj.%Get("Disease")
	s diagLen = diagArr.%Size()
	for j=0:1:diagLen-1  d
	.s diagObj = diagArr.%Get(j)
	.s diag = diagObj.item
	.i diagList="" s diagList = diag
	.e  s diagList = diagList_";"_diag
	//取药品信息
	s drugArr = exaParamObj.%Get("Drug")
	s length = drugArr.%Size()
	
	for k=0:1:length-1  d
	.s drugObj = drugArr.%Get(k)
	.s drugName = drugObj.item
	.q:drugName=""
	.s onceDose = drugObj.OnceDose
	.s unit = drugObj.Unit
	.s formProp = drugObj.FormProp
	.s drugPreMet = drugObj.DrugPreMet
	.s drugFreq = drugObj.DrugFreq
	.i drugFreq="" s drugFreq=drugObj.DrugDrugFreq
	.s treatment = drugObj.Treatment
	.s seqNo = drugObj.SeqNo // 序号 qnp 2020/12/18
	.Q:(exaResc'="")&&(drugOutParam'[exaResc)
	.s libDrugId = ##Class(web.DHCCKBPassNew).GetComDicIdNew(drugName,"Drug",hospId)
	.s libDrugDesc = ""
	.s:libDrugId'="" libDrugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+$list(libDrugId,1)),3)
	.Q:(cat'="相互作用")&&(cat'="重复用药")&&(cat'="配伍禁忌")&&(cat'="十八反")&&(libDrugDesc'=drug)
	.s remarks = "",exasignval = "" , exasign = ""   
	.s monItmId = ""
	.s:libDrugId'="" monItmId = $g(^TMP("DHCCKB","web.DHCCKBCalculateval","ERRDRUGCAT",pid,monId,$list(libDrugId,1),catId))
	.s monData=$g(^CKB.PDSS.MonQueListD($p(monItmId,",",1)))	
	.s:monItmId'="" remarks = $lg(monData,9)		 		//备注
	.s:monItmId'="" exasignval = $lg(monData,10)			//标记
	.s exasign = $s(exasignval="complet":"规则错误，已完成",exasignval="uwcomplet":"规则错误，未完成",exasignval="partcomp":"规则错误，部分完成",exasignval="partcompcon":"规则错误，部分完成，需用户确认",exasignval="partcompproame":"规则错误，部分完成，需修正程序",exasignval="partcompruleimp":"规则错误，部分完成，需完善规则",exasignval="partcompdicimp":"规则错误，部分完成，需完善字典",exasignval="verifycorrect":"规则正确，需验证",exasignval="affirmcorrect":"规则正确，需用户确认",exasignval="achievecorrect":"规则正确，已完成",1:"")
	.Q:(sign'="未处理")&&(sign'="")&&(exasignval'[sign)
	.Q:(sign="未处理")&&(..IsDealInPresc(monId,drugId,catId)'="0")
	.s h = h+1
	.s groupiden = ""
	.i ((k=0)&&(length>1)) s groupiden = "<div style='margin-top:5px'><span style='color:#509DE1;font-size:20px;'>┎</span></div>"
	.i ((k>0)&&(k<(length-1))) s groupiden = "<div><span style='color:#509DE1;font-size:35px;'>│</span></div>"
	.i ((k=(length-1))&&(k>0)) s groupiden = "<div style='margin-top:2px;'><span style='color:#509DE1;font-size:20px;'>┖</span></div>"
	.s drugList = length_"^"_groupiden_"^"_drugName_"^"_onceDose_"^"_unit_"^"_formProp_"^"_drugPreMet_"^"_drugFreq_"^"_treatment
	.;s dataList = monId_"^"_monItmId_"^"_patInfo_"^"_hisAllergyList_"^"_diagList_"^"_drugList_"^"_drugOutParam
	.;s dataList = dataList_"^"_remarks_"^"_exasignval_"^"_exasign_"^"_patNo
	.;s ^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,h) = dataList
	.;Q
	.//存储输出信息，不重复
	.s itmLen = $l(monItmId,",")
	.for m = 1:1:itmLen   d
	..s itmId = $p(monItmId,",",m)
	..Q:itmId=""
	..s monData = $g(^CKB.PDSS.MonQueListD(itmId))
	..s funId = $lg(monData,5)
	..s funDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+funId),3)
	..s drugOutParam = ..getExeOutParam(outParam, drugName, cat,funDesc,seqNo)    //获取审查结果
	..b:(drugId=623)&&(cat="禁忌证")
	..q:drugOutParam=""
	..i drugOutParam'=""  d
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","GetCheckRes",pid,h) = drugOutParam
	..s len = $l(drugOutParam,"&") 
	..s remarks = $lg(monData,9)	//备注
	..s exasignval = $lg(monData,10)	//备注
	..s exasign = $s(exasignval="complet":"规则错误，已完成",exasignval="uwcomplet":"规则错误，未完成",exasignval="partcomp":"规则错误，部分完成",exasignval="partcompcon":"规则错误，部分完成，需用户确认",exasignval="partcompproame":"规则错误，部分完成，需修正程序",exasignval="partcompruleimp":"规则错误，部分完成，需完善规则",exasignval="partcompdicimp":"规则错误，部分完成，需完善字典",exasignval="verifycorrect":"规则正确，需验证",exasignval="affirmcorrect":"规则正确，需用户确认",exasignval="achievecorrect":"规则正确，已完成",1:"")
	..for n=1:1:len    d
	...s outParams = $p(drugOutParam,"&",n)
	...s paraLen = $l(outParams)
	...s paNode = 0
	...s paNode = $s(paraLen>150:$e(outParams,1,150),paraLen=0:0,1:outParams) 
	...s dataList = monId_"^"_itmId_"^"_patInfo_"^"_hisAllergyList_"^"_diagList_"^"_drugList_"^"_outParams
	...s dataList = dataList_"^"_remarks_"^"_exasignval_"^"_exasign_"^"_patNo_"^"_funId
	...i $d(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode))  d
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",1) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",1)_","_monId
	....s $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",2) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",2)_","_itmId
	....;s $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",12) = funId
	...e  d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode) = dataList
	.;s paNode = 0
	.;s paNode = $s(len>150:$e(drugOutParam,1,150),len=0:0,1:drugOutParam) 
	.;i $d(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode))  d
	.;s $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",1) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",1)_","_monId
	.;s $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",2) = $p(^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode),"^",2)_","_monItmId
	.;e  d
	.;s ^TMP("DHCCKB","web.DHCCKBCalculateval",node,pid,paNode) = dataList
	
	Q ""
}

/// Descript:判断某个药品在该目录下的处方是否已处理
/// Creator:sufan
/// CreateDate:2020-12-13
ClassMethod IsDealInPresc(monId, drugId, catId)
{
	n (monId,drugId,catId)
	s isComplet = 1
	Q:drugId="" isComplet
	s monItmId = ""
	for  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId))	Q:monItmId=""  d
	.s monData = $g(^CKB.PDSS.MonQueListD(monItmId))
	.s itemId = $lg(monData,3)
	.Q:itemId'=drugId
	.s itemCatId = $lg(monData,4) 
	.Q:catId'=itemCatId
	.s signs = $lg(monData,10)
	.Q:signs'=""
	.s isComplet = 0
	Q isComplet
}

/// Descript:取输出信息
/// Creator:sufan
/// CreateDate:2020-12-13
/// Input:pid
/// w ##class(web.DHCCKBCalculateval).GetCheckRes(2956394)
ClassMethod GetCheckRes(pid, q = "")
{
	 n (pid,q)
	 s ^TMPPPPPP=pid
	 s count = 0
	 s listval = ""
	 k resArr
	 w "["
	 s index = ""
	 for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","GetCheckRes",pid,index))  Q:index=""  d
	 .s value = $g(^TMP("DHCCKB","web.DHCCKBCalculateval","GetCheckRes",pid,index))
	 .q:value=""
	 .Q:$lf(listval,value)'=0
	 .s $list(listval,*+1) = value
	 .Q:(q'="")&(value'[q)
	 .s count = count+1
	 .i count=1 d
	 ..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",count_"^"_value)
	 .e  d
	 ..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",count_"^"_value)
	 w "]"
	 Q ""
}

/// Descript:取各项目对比表头信息
/// Creator:wangxin
/// CreateDate:2020-11-17
/// Input:开始日期,结束日期
/// w ##class(web.DHCCKBCalculateval).GetColumns("2020-11-16","2020-11-18")
ClassMethod GetColumns(stDate, endDate)
{
	n (stDate,endDate)

	s obj= ##class(%DynamicObject).%New()
	s columns=[]
	s column={}
	s column.field="drugId" 
	s column.title="药品id" 
	s column.width="200"
	s column.hidden="true"
	d columns.%Push(column)
	s column={}
	s column.field="drugDesc" 
	s column.title="药品名称" 
	s column.width="200"
	d columns.%Push(column)
	s column={}
	s column.field="itmId" 
	s column.title="项目id" 
	s column.width="200"
	s column.hidden="true"
	d columns.%Push(column)
	s column={}
	s column.field="itmDesc" 
	s column.title="项目名称" 
	s column.width="140"
	d columns.%Push(column)
	set obj.columns = columns
	set obj.pid = ""
	set obj.ret = ""
	Q:(stDate="")||(stDate="") obj.%ToJSON()
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s ret = ..getMultProData(stDate,endDate,pid)

	s hosp = ""
	for  s hosp = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp",hosp))  Q:hosp=""  d
	.s column={}
	.s filed = ##class(web.DHCCKBCommonUtil).GetPYCODE(hosp)
	.s title = hosp
	.s column.field=$$ALPHAUP^SSUTIL4(filed)
	.s column.title=title 
	.s column.width="200"
	.s column.Formatter="linkPrescde"
	.d columns.%Push(column)

	set obj.columns = columns
	set obj.pid = pid
	set obj.ret = ret
	w obj.%ToJSON()
	q ""
}

/// Descript:多项目融合取值
/// Creator:wangxin
/// CreateDate:2020-11-17
/// Input:开始日期,结束日期
/// w ##class(web.DHCCKBCalculateval).QueryProCompData("30","1","61726951","894","2020-11-16","2020-11-18")
ClassMethod QueryProCompData(rows, page, pid, num, stDate, endDate)
{
	n (rows, page,pid,num,stDate,endDate)
	s End=page*rows
	s Start=(page-1)*rows+1

	Q:num=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)

	k ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData","HOSPDATE",pid)

	s ret = ..getMultProData(stDate,endDate,pid)
	Q:ret=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)

	w ##class(web.DHCEMJsonCommon).getJsonStartSign(num) //输出json前缀串
	s count=0
	s titlelist = ""
	s hosp = ""
	for  s hosp = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp",hosp))  Q:hosp=""  d
	.s title = ##class(web.DHCCKBCommonUtil).GetPYCODE(hosp)
	.s title=$$ALPHAUP^SSUTIL4(title)
	.i titlelist="" s titlelist = title
	.e  s titlelist = titlelist_"^"_title
	s listTitle = "drugId^drugDesc^itmId^itmDesc^"_titlelist

	s drugId = ""
	for  s drugId = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData",pid,drugId))  Q:drugId=""  d
	.s itmId = ""
	.for  s itmId = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData",pid,drugId,itmId))  Q:itmId=""  d
	..s drugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)	
	..s itmDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+itmId),3)
	..s count = count+1
	..s hospDataList = ..GetHospItmData(drugId,itmId,pid)
	..s listData = drugId_"^"_drugDesc_"^"_itmId_"^"_itmDesc_"^"_hospDataList
	..q:(count<Start)||(count>End)
	..i count=Start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp")
	k ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData","HOSPDATE",pid)
	Q ""
}

/// w ##class(web.DHCCKBCalculateval).GetHospItmData(1,150,1)
ClassMethod GetHospItmData(drugId, itmId, pid)
{
	n (drugId,itmId,pid)
	s list = ""
	s hosp = ""
	for  s hosp = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp",hosp))  Q:hosp=""  d
	.s hospData = $g(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData","HOSPDATE",pid,drugId,itmId,hosp))
	.if (hospData="") s hospData=0
	.i list = "" s list = hospData
	.e  s list = list_"^"_hospData
	Q list
}

/// Descript:多项目融合取数据方法
/// Creator:sufan
/// CreateDate:2020-11-13
/// Input:开始日期,结束日期
/// w ##class(web.DHCCKBCalculateval).getMultProData("2020-11-01","2020-11-18",1)
ClassMethod getMultProData(stDate, endDate, pid)
{
	n (stDate,endDate,pid)
	K ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProComplist")
	Q:(stDate = "")||(endDate = "") ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s h = 0,count=0
	for date = stDate:1:endDate  d
	.s monId = "" 
	.for  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s Hosp = $lg(monData,12)	//医院
	..s:Hosp="" Hosp="东华标准版数字化医院[总院]"
	..s ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp",Hosp) = Hosp
	..i '$d(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp",Hosp))  d
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp",Hosp) = ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProDataHosp",Hosp) _"^"_Hosp
	..s exaParam = $lg(monData,9)	//入参
	..s monItmId = ""
	..for  s monItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monItmId)) Q:monItmId=""  d
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryProComplist",monItmId)=monItmId_"^"_monId
	...s drugId = $lg(^CKB.PDSS.MonQueListD(monItmId),3) //药品Id
	...s itmId = $lg(^CKB.PDSS.MonQueListD(monItmId),5)  //项目Id
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData",pid,drugId,itmId)=""
	...i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData","HOSPDATE",pid,drugId,itmId,Hosp))  d
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData","HOSPDATE",pid,drugId,itmId,Hosp) = ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData","HOSPDATE",pid,drugId,itmId,Hosp)+1
	...e  d
	....s h = h+1
	....s ^TMP("DHCCKB","web.DHCCKBCalculateval","getMultProData","HOSPDATE",pid,drugId,itmId,Hosp) = 1
	
	Q h
}

/// Descript:flag="":根据描述返回目录Id,flag="1",返回目录顺序
/// Creator:sufan
/// CreateDate:2020-11-06
/// w ##class(web.DHCCKBCalculateval).getCatIdByDesc("禁忌证","")
ClassMethod getCatIdByDesc(desc, flag = "")
{
	n (desc,flag)
	Q:desc="" ""
	s comDosageId = ##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")									//用法
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+comDosageId),3)=desc)&&(flag="") comDosageId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+comDosageId),3)=desc)&&(flag="1") 1
	s ruleUsageId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")									//用法用量
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleUsageId),3)=desc)&&(flag="") ruleUsageId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleUsageId),3)=desc)&&(flag="1") 2
	s interEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("InterEach")								 //相互作用
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+interEachId),3)=desc)&&(flag="") interEachId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+interEachId),3)=desc)&&(flag="1") 3
	s tabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("Taboo")																 //配伍禁忌
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+tabooId),3)=desc)&&(flag="") tabooId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+tabooId),3)=desc)&&(flag="1") 4
	s drugIrriId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugIrri")										 //药物过敏
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugIrriId),3)=desc)&&(flag="") drugIrriId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugIrriId),3)=desc)&&(flag="1") 5
	s ruleIndicId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")									//适应症
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleIndicId),3)=desc)&&(flag="") ruleIndicId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleIndicId),3)=desc)&&(flag="1") 6
	s ruleContrId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")									//禁忌症
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrId),3)=desc)&&(flag="") ruleContrId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrId),3)=desc)&&(flag="1") 7
	s ruleMatNeAtId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleMatNeAt")				 //注意事项
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleMatNeAtId),3)=desc)&&(flag="") ruleMatNeAtId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleMatNeAtId),3)=desc)&&(flag="1") 8
	s ruleContrTwoId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContrTwo")			//禁忌
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrTwoId),3)=desc)&&(flag="") ruleContrTwoId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrTwoId),3)=desc)&&(flag="1") 9
	s funIndicatId = ##class(web.DHCCKBCommon).GetDicIdByCode("FunIndicat")						 //功能主治
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+funIndicatId),3)=desc)&&(flag="") funIndicatId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+funIndicatId),3)=desc)&&(flag="1") 10
	s repeatId = ##class(web.DHCCKBCommon).GetDicIdByCode("Repeat")						 //重复用药
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatId),3)=desc)&&(flag="") repeatId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatId),3)=desc)&&(flag="1") 11
	s skinTestRuleId = ##class(web.DHCCKBCommon).GetDicIdByCode("SkinTestRule")						 //皮试用药
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+skinTestRuleId),3)=desc)&&(flag="") skinTestRuleId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+skinTestRuleId),3)=desc)&&(flag="1") 12
	s drugInterEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugInterEach")		//药物相互作用
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugInterEachId),3)=desc)&&(flag="") drugInterEachId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugInterEachId),3)=desc)&&(flag="1") 13
	s warnId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugNotification")					//警告
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+warnId),3)=desc)&&(flag="") warnId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+warnId),3)=desc)&&(flag="1") 14
	s translateId = ##class(web.DHCCKBCommon).GetDicIdByCode("片剂给药途径")					//片剂给药途径
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+translateId),3)=desc)&&(flag="") translateId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+translateId),3)=desc)&&(flag="1") 15
	s liquidConfigId = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")					//片剂给药途径
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+liquidConfigId),3)=desc)&&(flag="") liquidConfigId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+liquidConfigId),3)=desc)&&(flag="1") 16
	s repeatIngId = ##class(web.DHCCKBCommon).GetDicIdByCode("RepeatIngr")					//成分重复
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatIngId),3)=desc)&&(flag="") repeatIngId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatIngId),3)=desc)&&(flag="1") 17
	s eighteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("EighteenTaboo")					//十八反
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+eighteenTabooId),3)=desc)&&(flag="") eighteenTabooId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+eighteenTabooId),3)=desc)&&(flag="1") 18
	s nineteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("NineteenTaboo")					//十九反
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+nineteenTabooId),3)=desc)&&(flag="") nineteenTabooId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+nineteenTabooId),3)=desc)&&(flag="1") 19
	s bpgmId = ##class(web.DHCCKBCommon).GetDicIdByCode("bsgm")							//本品过敏
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+bpgmId),3)=desc)&&(flag="") bpgmId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD+(bpgmId),3)=desc)&&(flag="1") 20
	Q ""
}

/// Descript:flag="":根据描述返回目录Id,flag="1",返回目录顺序
/// Creator:sufan
/// CreateDate:2020-11-06
/// w ##class(web.DHCCKBCalculateval).getCatIdByDesc("禁忌证","")
ClassMethod getCatIdByCode(desc, flag = "")
{
	n (desc,flag)
	Q:desc="" ""
	s comDosageId = ##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")									//用法
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+comDosageId),2)=desc)&&(flag="") comDosageId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+comDosageId),2)=desc)&&(flag="1") 1
	s ruleUsageId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage")									//用法用量
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleUsageId),2)=desc)&&(flag="") ruleUsageId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleUsageId),2)=desc)&&(flag="1") 2
	s interEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("InterEach")								 //相互作用
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+interEachId),2)=desc)&&(flag="") interEachId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+interEachId),2)=desc)&&(flag="1") 3
	s tabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("Taboo")																 //配伍禁忌
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+tabooId),2)=desc)&&(flag="") tabooId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+tabooId),2)=desc)&&(flag="1") 4
	s drugIrriId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugIrri")										 //药物过敏
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugIrriId),2)=desc)&&(flag="") drugIrriId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugIrriId),2)=desc)&&(flag="1") 5
	s ruleIndicId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")									//适应症
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleIndicId),2)=desc)&&(flag="") ruleIndicId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleIndicId),2)=desc)&&(flag="1") 6
	s ruleContrId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")									//禁忌症
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrId),2)=desc)&&(flag="") ruleContrId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrId),2)=desc)&&(flag="1") 7
	s ruleMatNeAtId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleMatNeAt")				 //注意事项
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleMatNeAtId),2)=desc)&&(flag="") ruleMatNeAtId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleMatNeAtId),2)=desc)&&(flag="1") 8
	s ruleContrTwoId = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContrTwo")			//禁忌
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrTwoId),2)=desc)&&(flag="") ruleContrTwoId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+ruleContrTwoId),2)=desc)&&(flag="1") 9
	s funIndicatId = ##class(web.DHCCKBCommon).GetDicIdByCode("FunIndicat")						 //功能主治
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+funIndicatId),2)=desc)&&(flag="") funIndicatId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+funIndicatId),2)=desc)&&(flag="1") 10
	s repeatId = ##class(web.DHCCKBCommon).GetDicIdByCode("Repeat")						 //重复用药
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatId),2)=desc)&&(flag="") repeatId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatId),2)=desc)&&(flag="1") 11
	s skinTestRuleId = ##class(web.DHCCKBCommon).GetDicIdByCode("SkinTestRule")						 //皮试用药
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+skinTestRuleId),2)=desc)&&(flag="") skinTestRuleId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+skinTestRuleId),2)=desc)&&(flag="1") 12
	s drugInterEachId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugInterEach")		//药物相互作用
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugInterEachId),2)=desc)&&(flag="") drugInterEachId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+drugInterEachId),2)=desc)&&(flag="1") 13
	s warnId = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugNotification")					//警告
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+warnId),2)=desc)&&(flag="") warnId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+warnId),2)=desc)&&(flag="1") 14
	s translateId = ##class(web.DHCCKBCommon).GetDicIdByCode("片剂给药途径")					//片剂给药途径
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+translateId),2)=desc)&&(flag="") translateId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+translateId),2)=desc)&&(flag="1") 15
	s liquidConfigId = ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig")					//片剂给药途径
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+liquidConfigId),2)=desc)&&(flag="") liquidConfigId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+liquidConfigId),2)=desc)&&(flag="1") 16
	s repeatIngId = ##class(web.DHCCKBCommon).GetDicIdByCode("RepeatIngr")					//成分重复
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatIngId),2)=desc)&&(flag="") repeatIngId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+repeatIngId),2)=desc)&&(flag="1") 17
	s eighteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("EighteenTaboo")					//十八反
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+eighteenTabooId),2)=desc)&&(flag="") eighteenTabooId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+eighteenTabooId),2)=desc)&&(flag="1") 18
	s nineteenTabooId = ##class(web.DHCCKBCommon).GetDicIdByCode("NineteenTaboo")					//十九反
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+nineteenTabooId),2)=desc)&&(flag="") nineteenTabooId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+nineteenTabooId),2)=desc)&&(flag="1") 19
	s bpgmId = ##class(web.DHCCKBCommon).GetDicIdByCode("bsgm")							//本品过敏
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+bpgmId),2)=desc)&&(flag="") bpgmId
	Q:($lg(^CT.CKB.PDSS.CommonDictionD(+bpgmId),2)=desc)&&(flag="1") 20
	Q ""
}

/// Descript:获取审核结果
/// Creator:sufan
/// CreateDate:2020-11-06
/// w ##class(web.DHCCKBCalculateval).getExeOutParam("30","1","2020-10-01^2020-10-31^^72")
ClassMethod getExeOutParam(outParam, hisDrug, cat, itmDesc = "", seqNo = "")
{
	n (outParam,hisDrug,cat,itmDesc,seqNo)
	s outParamObj = ##class(%DynamicArray).%FromJSON(outParam)
	s itemsArr = outParamObj.items
	s length = itemsArr.%Size()
	s msg = ""
	for i=0:1:length-1  d
	.s itmsObj = itemsArr.%Get(i)
	.s libItem = itmsObj.libitem
	.s hisItem = itmsObj.item
	.Q:(hisDrug'=hisItem)
	.Q:(hisDrug=hisItem)&(seqNo'=itmsObj.seqno) // 增加过滤条件 qnp 2020/12/18
	.s warnArr = itmsObj.warns
	.s warnLen = warnArr.%Size()
	.for j=0:1:warnLen-1  d
	..s warnObj = warnArr.%Get(j)
	..s keyName = warnObj.keyname
	..Q:(cat'="")&&(cat'="禁忌症")&&(cat'="禁忌证")&&(keyName'[cat)		//禁忌症描述一直变，导致跑的日志和字典描述不一致
	..Q:(cat'="")&&(cat["禁忌")&&(keyName'["禁忌")
	..s warnItmsArr = warnObj.itms
	..s ManLev=warnObj.manLev
	..s warnItmLen = warnItmsArr.%Size()
	..for k=0:1:warnItmLen-1  d
	...s warnItmObj = warnItmsArr.%Get(k)
	...s itmsArr = warnItmObj.itms
	...s itmsLen = itmsArr.%Size()
	...for l=0:1:itmsLen-1  d
	....s itmsObj = itmsArr.%Get(l)
	....s itmkeyName = itmsObj.keyname
	....;b   //44
	....Q:(itmDesc'="")&&(itmDesc'=itmkeyName)
	....s itmmsg = ManLev_":"_itmsObj.val
	....;i msg="" s msg = (l+1)_":"_itmmsg
	....;e  s msg = msg_"&"_(l+1)_":"_itmmsg
	....i msg="" s msg = itmmsg
	....e  s msg = msg_"&"_itmmsg
	Q msg
}

/// Creator:sufan
/// CreateDate:2020-11-06
/// w ##class(web.DHCCKBCalculateval).saveRemark("4793724^测试^uwcomplet$$4793725^测试^uwcomplet")
ClassMethod saveRemark(dataList)
{
	n (dataList)
	s ^temptest("222")=$lb(dataList)
	TS
	s err = 0
	s len = $l(dataList,"$$")
	for i=1:1:len Q:err'=0   d
	.Q:err'=0
	.s tmpList = $p(dataList,"$$",i)
	.s monItmIdList = $p(tmpList,"^",1)
	.s remarks = $p(tmpList,"^",2)
	.s exasignval = $p(tmpList,"^",3)
	.s length = $l(monItmIdList,",")
	.for j=1:1:length Q:err'=0  d
	..Q:err'=0
	..s monItmId = $p(monItmIdList,",",j)
	..&sql(update CKB_PDSS.MonQueList set CM_Remarks=:remarks,CM_Sings=:exasignval where CM_RowID=:monItmId)
	..s err=SQLCODE
	..Q:err'=0
	i err'=0 tro
	Q:err'=0 err
	TC
	Q err
}

/// Descript:his升级后，医嘱名称和老系统不一致，按照老系统拆的药和做了对照关系后，更新对照关系的方法
/// Creator:sufan
/// CreateDate:2020-10-15
/// w ##Class(web.DHCCKBCalculateval).UpdCossRefRelat("C:\Users\Administrator\Desktop\武汉一院新对照数据.txt")
ClassMethod UpdCossRefRelat(filepath)
{
	n (filepath)
	S count = 0
	k drugConArr
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s listData = $tr(onerow,$c(9),del)
	.;Q:$p(listData,"^",6)=""
	.s count=count+1
	.Q:count=1
	.s drugConArr(count)=listData
	c filepath

	s ret = ..UpdDrugRelation(.drugConArr)
	Q ret
}

/// Descript:his升级后，医嘱名称和老系统不一致，按照老系统拆的药和做了对照关系后，更新对照关系的方法
/// Creator:sufan
/// CreateDate:2020-10-15
/// 
ClassMethod UpdDrugRelation(drugConArr)
{
	n (drugConArr)
	s err = 0,num = 0
	s index = ""
	for  s index = $o(drugConArr(index))  Q:(index="")||(err'=0)  d
	.s list = drugConArr(index)
	.s hisCode = $p(list,"^",1) 		//新HIS代码
	.s hisDesc = $p(list,"^",2) 		//新HIS描述
	.s hisCom = $p(list,"^",3) 		 //新HIS厂家
	.s hisHosp = $p(list,"^",4) 		//新HIS医院
	.s hisHospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hisHosp),""))
	.s num = num+1
	.s:hisHospId="" err="-100"_"&"_num
	.s extDesc = hisDesc
	.s:hisCom'="" extDesc = hisDesc_"||"_hisCom
	.Q:err'=0
	.s extDicId = $o(^CKB.PDSS.ExtDictionI("Desc",hisHospId,extDesc,""))
	.i extDicId = ""  d
	..s err = ..InsDicData(list)													//新增外部代码
	.e  d
	..s err = ..UpdDicData(extDicId,list)				//更新外部代码
	.i err'=0 s err = err_"&"_num
	.Q:err'=0
	Q err
}

/// Descript:新增外部代码表
/// Creator:sufan
/// CreateDate:2020-10-15
/// 
ClassMethod InsDicData(listData)
{
	n (listData)
	TS
	s err = 0
	///保存外部表
	s err = ..InsExtDic(listData)
	i err'=0 tro
	Q:err'=0 err

	///保存对照信息
	s err = ..SaveConData(listData)
	i err'=0 tro
	Q:err'=0 err
	TC
	Q err
}

ClassMethod UpdDicData(extDicId, listData)
{
	n (extDicId,listData)

	s err = 0
	TS
	///更新外部表

	s err = ..UpdExtDic(extDicId,listData)
	i err'=0 tro
	Q:err'=0 err

	///保存对照信息
	s err = ..SaveConData(listData)
	i err'=0 tro
	Q:err'=0 err
	TC
	Q err
}

/// Descript:新增外部代码表
/// Creator:sufan
/// CreateDate:2020-10-15
/// 
ClassMethod InsExtDic(lisData)
{
	n (lisData)
	s hisCode = $p(lisData,"^",1)								//代码
	s hisDesc = $p(lisData,"^",2)								//描述
	s note = $p(lisData,"^",3)											//备注
	s:note'="" hisDesc = hisDesc_"||"_note
	s hosp = $p(lisData,"^",4)											//医院				
	s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))	
	s type = $p(lisData,"^",5)											//字典类型
	&sql(insert into CKB_PDSS.ExtDiction (ED_Code,ED_Desc,ED_Type,ED_Hospital) values(
		:hisCode,:hisDesc,:type,:hospId
	))
	Q SQLCODE
}

/// Descript:更新外部代码表
/// Creator:sufan
/// CreateDate:2020-10-15
/// 
ClassMethod UpdExtDic(extDicId, lisData)
{
	n (extDicId,lisData)
	s hisCode = $p(lisData,"^",1)								//代码
	s hisDesc = $p(lisData,"^",2)								//描述
	s note = $p(lisData,"^",3)											//备注
	s:note'="" hisDesc = hisDesc_"||"_note
	s hosp = $p(lisData,"^",4)											//医院				
	s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))	
	s type = $p(lisData,"^",5)											//字典类型
	&sql(update CKB_PDSS.ExtDiction set ED_Code=:hisCode,ED_Desc=:hisDesc,ED_Type=:type,ED_Hospital=:hospId where ED_RowID=:extDicId )
	Q SQLCODE
}

/// Descript:新增对照信息
/// Creator:sufan
/// CreateDate:2020-10-15
/// 
ClassMethod SaveConData(lisData)
{
	n (lisData)
	s hisCode = $p(lisData,"^",6)			//已对照his代码
	s hisDesc = $p(lisData,"^",7)			//已对照his描述
	Q:(hisCode="")||(hisDesc="") ""
	s codeId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),""))
	s descId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisDesc),""))
	i descId = ""  s ^||tempsufan(hisCode)=hisCode_hisDesc 
	Q:codeId="" 0
	Q:codeId'=descId "-101"_hisCode_hisDesc
	s libCode = $lg(^CKB.PDSS.ComContrastD(codeId),2) 	//知识库代码
	s libDesc = $lg(^CKB.PDSS.ComContrastD(codeId),3)	//知识库描述
	s hisCode = $p(lisData,"^",1)														//HIS新代码
	s hisDesc = $p(lisData,"^",2)														//HIS新描述
	s type = $p(lisData,"^",5)
	s typeId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	Q:$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(libDesc),$$UPPER^SSUTIL4(hisDesc))) 0
	&sql(insert into CKB_PDSS.ComContrast (CC_LibCode,CC_LibDesc,CC_HisCode,CC_HisDesc,CC_DicType) values(
	:libCode,:libDesc,:hisCode,:hisDesc,:typeId
	))
	Q SQLCODE
}

/// Descript:查找西药和中成药同时存在的情况
/// Creator:sufan
/// CreateDate:2020-10-19
/// w ##class(web.DHCCKBCalculateval).getRepeatDrug()
ClassMethod getRepeatDrug()
{
	k ^TMPrepArr
	s drugDictionId = ##class(web.DHCCKBCommon).GetDrugData()			//西药字典
	s chnDictionId = ##class(web.DHCCKBCommon).GetChineseDrugData() 		//中成药字典
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",chnDictionId,dicId))  Q:dicId=""  d
	.s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),3)
	.s dicCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),2)
	.b:dicCode="碳酸钙D3片( 惠氏制药有限公司)"
	.Q:..isExistDrugDiction(dicCode,dicDesc,drugDictionId)'=1
	.s ^TMPrepArr(dicId) = dicDesc
	zw ^TMPrepArr
	q ""
}

/// Descript:查找知识库中是否存在碳酸钙D3片(惠氏制药有限公司)
/// w ##class(web.DHCCKBCalculateval).isExistDrugDiction("碳酸钙D3片( 惠氏制药有限公司)","碳酸钙D3片( 惠氏制药有限公司)",105)
ClassMethod isExistDrugDiction(dicCode, dicDesc, drugDictionId)
{
	n (dicCode,dicDesc,drugDictionId)
	s existFlag = 0
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(dicDesc),dicId)) Q:dicId=""  d
	.s parent = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),4)
	.Q:drugDictionId'=parent
	.s existFlag = 1
	Q:existFlag=1 existFlag

	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(dicCode),dicId)) Q:dicId=""  d
	.s parent = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),4)
	.Q:drugDictionId'=parent
	.s existFlag = 1
	Q existFlag
}

/// d ##Class(web.DHCCKBCalculateval).reloadHisEqunit("YNSDDBQYZXYY")
ClassMethod reloadHisEqunit(hospCode)
{
	 d ##Class(web.DHCCKBCalculateval).CheckEquiUnits(hospCode)
}

/// Descript:等效单位核对
/// w ##Class(web.DHCCKBCalculateval).CheckEquiUnits("WHSDYYY")
ClassMethod CheckEquiUnits(hospCode)
{
	n (hospCode)

	s drugDataId = ##class(web.DHCCKBCommon).GetDrugData()
	s zcyDataId = ##class(web.DHCCKBCommon).GetChineseDrugData()
	s zyypDataId = ##class(web.DHCCKBCommon).GetChineseHMData()
	Q:hospCode="" ""
	k ^TMP("DHCCKB","NOCONSDATA")
	k ^TMP("DHCCKB","CONSERRDATA")
	k ^TMP("DHCCKB","CheckEquiUnits")
	k ^TMP("DHCCKB","AutoCompare")    //k掉核对等效单位的临时global
	k ^tempsufan(hospCode)
	S count = 0
	s ret = 0
	s index = ""
	for  s index = $o(^TMP("DHCCKB","SaveEqunitTemp",hospCode,index))  Q:index=""  d
	.s listData = ^TMP("DHCCKB","SaveEqunitTemp",hospCode,index)
	.s hisDrug = $p(listData,"^",2)
	.s equnitlist = $p(listData,"^",3,5)
	.;b ;01
	.i $d(^TMP("DHCCKB","AutoCompare",hisDrug))  d
	..s ^TMP("DHCCKB","AutoCompare",hisDrug) = ^TMP("DHCCKB","AutoCompare",hisDrug)_"^"_$tr(equnitlist,"^","")
	.e  s ^TMP("DHCCKB","AutoCompare",hisDrug) = $tr(equnitlist,"^","")
	.s count = count+1
	.s conId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(hisDrug),""))
	.i conId = "" s ^TMP("DHCCKB","NOCONSDATA",count,hisDrug)=hisDrug_"："_count			//存储未对照数据
	.Q:conId=""
	.s libDesc = $lg(^CKB.PDSS.ComContrastD(conId),3)
	.//s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(libDesc),""))
	.s dicId = ##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,drugDataId)
	.i dicId=0 s dicId=##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,zcyDataId)
	.i dicId=0 s dicId=##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,zyypDataId)
	.s:dicId="" ^TMP("DHCCKB","CONSERRDATA",count,hisDrug)=libDesc_"："_count										//存贮对照错误药品
	.Q:dicId=""
	.s unit = $p(listData,"^",3)_$p(listData,"^",4)_$p(listData,"^",5)
	.s unitExt = $p(listData,"^",3)_"-"_$p(listData,"^",4)_"-"_$p(listData,"^",5) // 增加分隔符,用于同步 2022-06-01 qnp
	.s divunit = $p(listData,"^",3)_"@"_$p(listData,"^",4)_"@"_$p(listData,"^",5)
	.s dicindex = dicId_"^"_libDesc
	.i $d(^tempsufan(hospCode,dicId))  d
	..s ^tempsufan(hospCode,dicId) = ^tempsufan(hospCode,dicId)_","_unitExt
	.e  d
	..s ^tempsufan(hospCode,dicId) = unitExt
	.i $d(^TMP("DHCCKB","CheckEquiUnits",hospCode,dicindex))  d
	..s ^TMP("DHCCKB","CheckEquiUnits",hospCode,dicindex) = ^TMP("DHCCKB","CheckEquiUnits",hospCode,dicindex)_","_unit_"^"_divunit
	.e  s ^TMP("DHCCKB","CheckEquiUnits",hospCode,dicindex) = unit_"^"_divunit

	s uindex = ""
	for  s uindex = $o(^TMP("DHCCKB","CheckEquiUnits",hospCode,uindex))  Q:uindex=""  d
	.s hisEqunit = ^TMP("DHCCKB","CheckEquiUnits",hospCode,uindex)
	.s libDicId = $p(uindex,"^",1)
	.s libEqunit = ##class(web.DHCCKBDrugVO).GetEquunit(libDicId)	
	.s length = $l(hisEqunit,",")
	.for i=1:1:length   d
	..s tempList = $p(hisEqunit,",",i)
	..s histempunit = $p(tempList,"^",1)
	..s hisDivunit = $p(tempList,"^",2)
	..Q:libEqunit[histempunit
	..i $d(^tempsufan("hisEqunit",uindex))  d
	...s ^tempsufan("hisEqunit",uindex) = ^tempsufan("hisEqunit",uindex)_"$$"_hisDivunit
	..e  d
	...s ^tempsufan("hisEqunit",uindex) = hisDivunit
	Q ret
}

/// w ##Class(web.DHCCKBCalculateval).dealEqunit()
ClassMethod dealEqunit()
{
	k ^tempsufan("dealEqunit")
	s count = 0
	s index = ""
	for  s index = $o(^tempsufan("hisEqunit",index)) Q:index=""  d
	.s dicId = $p(index,"^",1)
	.;Q:(dicId=108100)||(dicId=10816)||(dicId=2514)&&(dicId=2791)||(dicId=3081)||(dicId=81356)
	.;Q:(dicId=81934)||(dicId=86078)||(dicId=87288)||(dicId=93228)||(dicId=93642)||(dicId=94300)
	.;Q:(dicId=94702)||(dicId=95453)||(dicId=95499)||(dicId=95849)||(dicId=96370)||(dicId=96508)
	.;Q:(dicId=96718)||(dicId=97233)||(dicId=97396)||(dicId=99138)
	.s count = count+1
	.s unitList = ^tempsufan("hisEqunit",index)
	.s length = $l(unitList,"$$")
	.for i=1:1:length  d
	..s unitgroup = $p(unitList,"$$",i)
	..s exchangeunit = ..getConsunit(unitgroup)
	..i $d(^tempsufan("dealEqunit",index))  d
	...s ^tempsufan("dealEqunit",index) = ^tempsufan("dealEqunit",index)_"$$"_exchangeunit
	..e  d
	...s ^tempsufan("dealEqunit",index) = exchangeunit

	Q ""
}

ClassMethod getConsunit(unitgroup)
{
	n (unitgroup)
	s UnitData=##class(web.DHCCKBCommon).GetUnitData() //单位字典
	s excUnitList = ""
	for j=1:1:3  d
	.s unit = $p(unitgroup,"@",j)
	.i j<3 d
	..s ^temptest("sufan",unit)=unit
	..s conId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(unit),""))
	..Q:conId=""
	..s libDesc = $lg(^CKB.PDSS.ComContrastD(conId),3)
	..s libId = ##class(web.DHCCKBCommon).GetDicIdByDesc(libDesc,UnitData)
	..s unit = libId
	.i excUnitList = "" s excUnitList = unit
	.e  s excUnitList = excUnitList_"@"_unit
	Q excUnitList
}

/// w ##Class(web.DHCCKBCalculateval).insEquit()
ClassMethod insEquit()
{
	s UnitData=##class(web.DHCCKBCommon).GetUnitData() //单位字典
	s EqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp() //等效单位属性
	s EqFromUnitProp=##class(web.DHCCKBCommon).GetEqFromUnitProp() //从单位属性
	s EqToUnitProp=##class(web.DHCCKBCommon).GetEqToUnitProp() //到单位属性
	s EqFactorProp=##class(web.DHCCKBCommon).GetEqFactorProp() //转换系数
	s ret =0
	s count = 0
	s index = ""
	for  s index = $o(^tempsufan("dealEqunit",index)) Q:(index="")||(ret'=0)  d
	.s unitList = ^tempsufan("dealEqunit",index)
	.s length = $l(unitList,"$$")
	.s count = count+1
	.;Q:count>2
	.for i=1:1:length q:ret'=0  d
	..s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	..s list = $p(unitList,"$$",i)
	..s inslist = $p(index,"^",1)_"^"_EqFromUnitProp_"^"_$p(list,"@",1)_"^"_""_"^"_pid
	..s inslist = inslist_"$$"_$p(index,"^",1)_"^"_EqToUnitProp_"^"_$p(list,"@",2)_"^"_""_"^"_pid
	..s inslist = inslist_"$$"_$p(index,"^",1)_"^"_EqFactorProp_"^"_""_"^"_$p(list,"@",3)_"^"_pid
	..s firstlist = $p(index,"^",1)_"^"_EqUnitProp_"^"_""_"^"_""_"^"_""
	..i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",$p(index,"^",1),EqUnitProp))  d
	...s ret = ..insdicequnit(firstlist)
	...Q:ret'=0
	...s ret = ..insdicequnit(inslist)
	..e  d
	...s ret = ..insdicequnit(inslist)
	Q ret
}

ClassMethod insdicequnit(inslist)
{
	n (inslist)
	s ret = 0
	s length = $l(inslist,"$$")
	for i=1:1:length  Q:ret'=0  d
	.s list = $p(inslist,"$$",i)
	.s dicId = $p(list,"^",1)
	.s attrId = $p(list,"^",2)
	.s unitId = $p(list,"^",3)
	.s result = $p(list,"^",4)
	.s group = $p(list,"^",5)
	.&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Attr_Dr,DLA_Result,DLA_GroupFlag) values (:dicId,:attrId,:unitId,:result,:group))
	.s ret=SQLCODE
	Q ret
}

/// Descript:查找某个药品规则中用到的所有单位
/// w ##Class(web.DHCCKBCalculateval).QueryunitInRule(158)
ClassMethod QueryunitInRule(drugId)
{
	n (drugId)
	k ^TMP("DHCCKB","QueryunitInRule")
	s equunit = ##class(web.DHCCKBDrugVO).GetEquunit(drugId)									//等效单位
	s ruleDicId = ""
	for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicId))  Q:ruleDicId=""  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)				//规则Id
	.Q:..isUseDosRule(ruleId)'=1
	.s rightType = ""
	.for  s rightType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType))  Q:rightType=""  d
	..s rightExt = 0
	..for  s rightExt = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,rightExt)) Q:rightExt=""  d
	...s drugruleId = ""
	...for  s drugruleId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,rightExt,drugruleId)) Q:drugruleId=""  d
	....Q:drugruleId'=ruleId
	....s ruleDataId = ""
	....for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,rightExt,drugruleId,ruleDataId))  Q:ruleDataId=""  d
	.....s leftDicId = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	.....s linkId = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDicId),5)
	.....s leftCode = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDicId),2)
	.....i (leftCode="")&&(linkId'="") s leftCode = $lg(^CT.CKB.PDSS.CommonDictionD(linkId),2)
	.....Q:(leftCode'="OnceDose")&&(leftCode'="DayDose")&&(leftCode'="OnceDoseMax")&&(leftCode'="OnceDoseLimit")&&(leftCode'="DayDoseMax")&&(leftCode'="DayDoseLimit")&&(leftCode'="TogetherOnceDose")&&(leftCode'="TogetherDayDose")
	.....s unit = $lg(^CT.CKB.PDSS.CommonDictionD(+rightExt),3)
	.....s index = drugId_"^"_unit
	.....Q:unit=""
	.....Q:equunit[unit
	.....s ^TMP("DHCCKB","QueryunitInRule",index) = unit_"^"_ruleId
	
	s unitlist = ""
	s rindex = ""
	for  s rindex = $o(^TMP("DHCCKB","QueryunitInRule",rindex))  Q:rindex=""  d
	.s ruleunitlist = $g(^TMP("DHCCKB","QueryunitInRule",rindex))
	.s ruleunit = $p(ruleunitlist,"^",1)
	.s rulenum = $p(ruleunitlist,"^",2)
	.s list = "规则"_rulenum_"中的单位是:"_ruleunit
	.i unitlist = ""  s unitlist = list
	.e  s unitlist = unitlist_"<br>"_list
	s ^tempsufan("QueryunitInRule",drugId)=unitlist
	Q unitlist
}

/// Descript:判断是否是用法用量的规则
ClassMethod isUseDosRule(ruleId)
{
	n (ruleId)
	s flag = 0
	s dicId = ""
	for  s dicId = $o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,dicId))  Q:(dicId="")||(flag=1)  d
	.Q:dicId'=72
	.s flag=1
	Q flag
}

/// DescriptL:将项目等效单位存入临时global
/// w ##Class(web.DHCCKBCalculateval).SaveEqunitTemp("SXXFYBJY","D:\temp\始兴妇幼保健所等效单位.txt")
/// w ##Class(web.DHCCKBCalculateval).SaveEqunitTemp("YNSDDBQYZXYY","D:\temp\等效单位滇东北.txt")
/// w ##Class(web.DHCCKBCalculateval).SaveEqunitTemp("SXYY","D:\temp\涉县等效单位.txt")
/// d ##Class(web.DHCCKBCalculateval).reloadHisEqunit("SXYY")
ClassMethod SaveEqunitTemp(hospCode, filepath)
{
	n (hospCode,filepath)
	S count = 0
	k eunitArr
	q:filepath="" $$$OK
	s del = "^"
	o filepath:"RS":2
	u filepath
	s ret=0
	s end=0
	k ^TMP("DHCCKB","CheckEquiUnits",hospCode)
	d $ZU(68,40,1)
	for  d  q:(end'=0)||(ret'=0)
	.R onerow
	.s end = $ZEOF
	.q:end'=0
	.q:onerow=""
	.s count=count+1
	.Q:count=1
	.s listData = $tr(onerow,$c(9),del)
	.s ^TMP("DHCCKB","SaveEqunitTemp",hospCode,count) = listData
	c filepath
	q ""
}

/// Descript:自动执行程序，同步临时global中的数据
/// w ##Class(web.DHCCKBCalculateval).SynchTempData("DrugData")
ClassMethod SynchTempData(dictionCode)
{
	n (dictionCode)
	s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(dictionCode)
	s drugId = ""
	for  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dictionId,drugId))  Q:drugId=""  d
	.d ##Class(web.DHCCKBCalculateval).QueryunitInRule(drugId)
	Q ""
}

/// Descript:查找规则中的单位已停用的数据
/// w ##Class(web.DHCCKBCalculateval).CheckStopunitInrule("DrugData")
/// w ##Class(web.DHCCKBCalculateval).CheckStopunitInrule("ChineseDrugData")
ClassMethod CheckStopunitInrule(dictionCode)
{
	n (dictionCode)
	s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(dictionCode)
	s drugId = ""
	for  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dictionId,drugId))  Q:drugId=""  d
	.s ruleDicId = ""
	.for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruleDicId))  Q:ruleDicId=""  d
	..s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)				//规则Id
	..Q:..isUseDosRule(ruleId)'=1
	..s rightType = ""
	..for  s rightType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType))  Q:rightType=""  d
	...s rightExt = 0
	...for  s rightExt = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,rightExt)) Q:rightExt=""  d
	....s drugruleId = ""
	....for  s drugruleId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,rightExt,drugruleId)) Q:drugruleId=""  d
	.....Q:drugruleId'=ruleId
	.....s ruleDataId = ""
	.....for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightType,rightExt,drugruleId,ruleDataId))  Q:ruleDataId=""  d
	......s leftDicId = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	......s linkId = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDicId),5)
	......s leftCode = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDicId),6)
	......i (leftCode="")&&(linkId'="") s leftCode = $lg(^CT.CKB.PDSS.CommonDictionD(+linkId),3)
	......s existFlag = ##class(web.DHCCKBCommon).IsEnabled(rightExt)
	......s parr = $lg(^CT.CKB.PDSS.CommonDictionD(+rightExt),4)
	......Q:(existFlag=1)&&(parr=127)&&($d(^CT.CKB.PDSS.CommonDictionD(rightExt)))
	......s unit = $lg(^CT.CKB.PDSS.CommonDictionD(+rightExt),3)
	......s index = drugId_"^"_ruleId
	......i $d(^TMP("DHCCKB","CheckStopunitInrule",index))  d
	.......s ^TMP("DHCCKB","CheckStopunitInrule",index) = ^TMP("DHCCKB","CheckStopunitInrule",index)_","_unit
	......e  d
	.......s ^TMP("DHCCKB","CheckStopunitInrule",index) = unit
	Q ""
}

/// w ##Class(web.DHCCKBCalculateval).getDuryErrule()
ClassMethod getDuryErrule()
{
	s index = ""
	for  s index = $o(^TMP("DHCCKB","CheckStopunitInrule",index)) q:index=""  d
	.s drugId = $p(index,"^",1)
	.s drug = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	.s ruleId = $p(index,"^",2)
	.s ruleindex = drug_"^"_ruleId
	.s unit = ^TMP("DHCCKB","CheckStopunitInrule",index)
	.i $d(^TMP("DHCCKB","getDuryErrule",ruleindex))  d
	..s ^TMP("DHCCKB","getDuryErrule",ruleindex) = ^TMP("DHCCKB","getDuryErrule",ruleindex)_","_unit
	.e  d
	..s ^TMP("DHCCKB","getDuryErrule",ruleindex) = unit
	Q ""
}

/// w ##Class(web.DHCCKBCalculateval).QueryEntyAttr()
/// 104913
ClassMethod QueryEntyAttr()
{
	
	s index = ""
	s EqUnitProp=##class(web.DHCCKBCommon).GetEqUnitProp() //等效单位属性
	s EqFromUnitProp=##class(web.DHCCKBCommon).GetEqFromUnitProp() //从单位属性
	s EqToUnitProp=##class(web.DHCCKBCommon).GetEqToUnitProp() //到单位属性
	s EqFactorProp=##class(web.DHCCKBCommon).GetEqFactorProp() //转换系数
	K ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr")
	for  s index = $o(^tempsufan("dealEqunit",index))  Q:index=""  d
	.s drugId = $p(index,"^",1)
	.s equitunit = ##class(web.DHCCKBDrugVO).GetEquunit(drugId)	
	.s length = $l(equitunit,",")
	.for i=1:1:length  d
	..s libunit = $p(equitunit,",",i)  
	..i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",index,libunit))  d
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",index,libunit)=^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",index,libunit)_"^"_libunit
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",index,libunit)=libunit

	s ruleIndex = ""
	for  s ruleIndex = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",ruleIndex)) Q:ruleIndex=""  d
	.s unit = ""
	.for  s unit = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",ruleIndex,unit))  Q:unit=""  d
	..s unitlist = ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",ruleIndex,unit)
	..s len = $l(unitlist,"^")
	..i len = 1 k ^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",ruleIndex,unit)
	
	Q ""
}

/// w ##Class(web.DHCCKBCalculateval).dealRepeeat()
ClassMethod dealRepeeat()
{
	s index = ""
	s ret=0,count=0
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",index)) Q:index=""  d
	.s unitindex = ""
	.for  s unitindex = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","QueryEntyAttr",index,unitindex))  Q:unitindex=""  d
	..s durgId=$p(index,"^",1)
	..s count=count+1
	..Q:count>50
	..s groupId = ..retrununitId(durgId,unitindex)
	..q:groupId=""
	..s ret=..DelData(groupId)
	q ret
}

/// w ##Class(web.DHCCKBCalculateval).retrununitId(108881,"支支1")
ClassMethod retrununitId(durgId, unitlist)
{
	n (durgId,unitlist)
	s UnitData=##class(web.DHCCKBCommon).GetUnitData() //单位字典
	s EqFromUnitProp=##class(web.DHCCKBCommon).GetEqFromUnitProp() //从单位属性
	s EqToUnitProp=##class(web.DHCCKBCommon).GetEqToUnitProp() //到单位属性
	s EqFactorProp=##class(web.DHCCKBCommon).GetEqFactorProp() //转换系数
	s exchList = EqFromUnitProp_"^"_EqToUnitProp_"^"_EqFactorProp
	K ^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId")
	s unitform = $p(unitlist,"",1)
	s unitformId = ##class(web.DHCCKBCommon).GetDicIdByDesc(unitform,UnitData)
	s unitto = $p(unitlist,"",2)
	s unittoId = ##class(web.DHCCKBCommon).GetDicIdByDesc(unitto,UnitData)
	s res = $p(unitlist,"",3)
	s list = ""
	for i=1:1:3  d
	.s extpropId = $p(exchList,"^",i)
	.s attrId = ""
	.for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",durgId,extpropId,attrId))  Q:attrId=""  d
	..s groupFlag = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	..s unit = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	..s res = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),3)
	..i unit'="" s unnitDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+unit),3)
	..e  s unnitDesc = res
	..i $d(^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId",durgId,groupFlag))   d
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId",durgId,groupFlag) = ^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId",durgId,groupFlag)_""_unnitDesc
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId",durgId,groupFlag)=unnitDesc
	
	s count=0,groupId = ""
	s index = ""
	for  s index = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId",index))  q:index=""  d
	.s unitindex = ""
	.for  s unitindex = $o(^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId",index,unitindex))  Q:unitindex=""  D
	..s drugunit = ^TMP("DHCCKB","web.DHCCKBCalculateval","retrununitId",index,unitindex)
	..Q:drugunit'=unitlist
	..s count=count+1
	..i count>1 s groupId = unitindex
	Q groupId
}

ClassMethod DelData(groupId)
{
	n (groupId)
	Q:+groupId="0" "-1"
	&sql(delete from CT_CKB_PDSS.DicLinkAttr where DLA_GroupFlag=:groupId)
	Q SQLCODE
}

/// Descript:找出规则中存在【单次最大量/单次极量/每日最大量/每日极量】
/// w ##class(web.DHCCKBCalculateval).QueryErrRules("72^74540")
ClassMethod QueryErrRules(catList)
{
	n (catList)
	k ^tempAllErrRule
 	s drugDictionId = ##class(web.DHCCKBCommon).GetDrugData()			//西药字典
 	s chnDictionId = ##class(web.DHCCKBCommon).GetChineseDrugData() 		//中成药字典
	s ruleId=""
	for  s ruleId = $o(^CT.CKB.PDSS.RuleD(ruleId))	 q:ruleId=""  d
	.q:..isExistThisCat(ruleId,catList)'=1     			//判断规则是否在目录下
	.s dicId = ""
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDictionId))  d //西药
	..s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugDictionId,""))
	..s dicId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),3)
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,chnDictionId))  d //中成药
	..s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,chnDictionId,""))
	..s dicId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),3)
	.q:+dicId=0
	.;Q:$d(^tempErrRule(dicId))
	.s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),3)
	.s dicCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicId),2)
	.//找规则的关系
	.s ruleNodeId = "",ruleParent = ""
	.for  s ruleNodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",0,ruleNodeId)) q:ruleNodeId=""  d
	..i $d(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId))  d
	...s ruleNodeIdsub = "" 
	...for  s ruleNodeIdsub = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId,ruleNodeIdsub)) q:ruleNodeIdsub=""  d
	....q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeIdsub)),3)'="and"
	....;w dicDesc,!
	....s ruleDataId="" ,count=0
	....f  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeIdsub,ruleDataId)) q:ruleDataId=""  d
	.....s dicType  =$lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	.....s typeCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicType),2)
	.....//单次给药剂量,单次最大量,单次极量,每日用药量,每日最大量,每日极量
	.....s:(typeCode="OnceDose")||(typeCode="OnceDoseMax")||(typeCode="OnceDoseLimit")||(typeCode="DayDose")||(typeCode="DayDoseMax")||(typeCode="DayDoseLimit") count=count+1 //通用名 成分 分类
	....i count>1  d
	.....i $d(^tempAllErrRule(dicId)) d
	......s ^tempAllErrRule(dicId)= ^tempAllErrRule(dicId)_","_ruleId
	.....e  d
	......s ^tempAllErrRule(dicId)= "需核查规则序号为:"_ruleId
	..
	..q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeId)),3)'="and"
	..s ruleDataId="" ,count=0
	..f  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeId,ruleDataId)) q:ruleDataId=""  d
	...s dicType=$lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	...s typeCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicType),2)
	...//单次给药剂量,单次最大量,单次极量,每日用药量,每日最大量,每日极量
	...s:(typeCode="OnceDose")||(typeCode="OnceDoseMax")||(typeCode="OnceDoseLimit")||(typeCode="DayDose")||(typeCode="DayDoseMax")||(typeCode="DayDoseLimit") count=count+1 //通用名 成分 分类
	..i count>1  d
	...i $d(^tempAllErrRule(dicId)) d
	....s ^tempAllErrRule(dicId)= ^tempAllErrRule(dicId)_","_ruleId
	...e  d
	....s ^tempAllErrRule(dicId)= "需核查规则序号为:"_ruleId
	Q ""
}

/// Descript:判断是否在对应目录的规则
/// w ##class(web.DHCCKBComImport).isExistThisCat(137758,73)
ClassMethod isExistThisCat(ruleId, catList)
{
	n (ruleId,catList)
	s existFlag = 0
	s length = $l(catList,"^")
	for i = 1:1:length  d
	.s catId = $p(catList,"^",i)
	.Q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,catId))
	.s existFlag = 1
	Q existFlag
}

/// Descript:找某个项目的矛盾规则
/// w ##class(web.DHCCKBCalculateval).QueryErrRuleByHos("HEBYKDXDYFSYY","72^74540")
ClassMethod QueryErrRuleByHos(hospCode, catList)
{
	n (hospCode,catList)
	k ^tempErrRule
	s hospId = $o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(hospCode),""))
	s Code = ""
	for  s Code = $o(^CKB.PDSS.ExtDictionI("Code",hospId,Code)) Q:Code=""  d
	.s extId = ""
	.for  s extId = $o(^CKB.PDSS.ExtDictionI("Code",hospId,Code,extId))  Q:extId=""  d
	..s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	..s type = $lg(extData,4)
	..Q:(type'="DrugData")&&(type'="ChineseDrugData")
	..s hisHosp =  $lg(extData,5)
	..Q:hospId'=hisHosp
	..s hisCode =  $lg(extData,2)
	..s conId = ""
	..for  s conId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),conId))  Q:conId=""  d
	...s listData =$g(^CKB.PDSS.ComContrastD(conId))
	...s libCode =  $lg(listData,2)
	...s libDesc =  $lg(listData,3)
	...s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(libCode),""))
	...Q:dicId=""
	...s ruleDicId = ""
	...for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicId,ruleDicId))  Q:ruleDicId=""  d
	....s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	....q:..isExistThisCat(ruleId,catList)'=1     			//判断规则是否在目录下
	....//找规则的关系
	....s ruleNodeId = "",ruleParent = ""
	....for  s ruleNodeId = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",0,ruleNodeId)) q:ruleNodeId=""  d
	.....i $d(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId))  d
	.....s ruleNodeIdsub = "" 
	.....for  s ruleNodeIdsub = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleId,"if",ruleNodeId,ruleNodeIdsub)) q:ruleNodeIdsub=""  d
	......q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeIdsub)),3)'="and"
	......;w dicDesc,!
	......s ruleDataId="" ,count=0
	......f  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeIdsub,ruleDataId)) q:ruleDataId=""  d
	.......s dicType  =$lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	.......s typeCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicType),2)
	.......//单次给药剂量,单次最大量,单次极量,每日用药量,每日最大量,每日极量
	.......s:(typeCode="OnceDose")||(typeCode="OnceDoseMax")||(typeCode="OnceDoseLimit")||(typeCode="DayDose")||(typeCode="DayDoseMax")||(typeCode="DayDoseLimit") count=count+1 //通用名 成分 分类
	......i count>1  d
	.......i $d(^tempErrRule(dicId)) d
	........s ^tempErrRule(dicId)= ^tempErrRule(dicId)_","_ruleId
	.......e  d
	........s ^tempErrRule(dicId)= libDesc_"：需核查规则序号为:"_ruleId
	.....q:$lg($g(^CT.CKB.PDSS.RuleNodeD(ruleNodeId)),3)'="and"
	.....s ruleDataId="" ,count=0
	.....f  s ruleDataId=$o(^CT.CKB.PDSS.RuleDataI("Node",ruleNodeId,ruleDataId)) q:ruleDataId=""  d
	......s dicType=$lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	......s typeCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicType),2)
	......//单次给药剂量,单次最大量,单次极量,每日用药量,每日最大量,每日极量
	......s:(typeCode="OnceDose")||(typeCode="OnceDoseMax")||(typeCode="OnceDoseLimit")||(typeCode="DayDose")||(typeCode="DayDoseMax")||(typeCode="DayDoseLimit") count=count+1 //通用名 成分 分类
	.....i count>1  d
	......i $d(^tempErrRule(dicId)) d
	.......s ^tempErrRule(dicId)= ^tempErrRule(dicId)_","_ruleId
	......e  d
	.......s ^tempErrRule(dicId)= libDesc_"：需核查规则序号为:"_ruleId
	Q ""
}

/// Descript:按照单个药品更新同步项目数据
/// Creator:sufan
/// CreateDate:2020-11-23
/// Input:stDate,endDate
ClassMethod QueryDicLog(stDate, endDate)
{
	n (stDate,endDate)
}

ClassMethod QueryAttrByincId(incId)
{
	n (incId)
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",incId,attrId))  Q:attrId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)						//药品id
	.
}

/// CreateDate:2020-11-24
/// Creator:sufan
/// Descript:查找用法用量中存在溶媒溶液的规则
/// w ##class(web.DHCCKBCalculateval).QueryMenSolInUsaDos("72")
ClassMethod QueryMenSolInUsaDos(catList)
{
	n (catList)
	k ^tempmensolrule
	k mensolArr
	s extId = "0"
	for  s extId = $o(^CKB.PDSS.ExtDictionD(extId))  Q:extId=""  d
	.s extData = $g(^CKB.PDSS.ExtDictionD(extId)) 
	.s type = $lg(extData,4)
	.Q:(type'="DrugData")&&(type'="ChineseDrugData")
	.s hisHosp = $lg(extData,5)
	.s hisCode = $lg(extData,2)
	.s conId = ""
	.for  s conId = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(hisCode),conId))  Q:conId=""  d
	..s listData =$g(^CKB.PDSS.ComContrastD(conId))
	..s libCode = $lg(listData,2)
	..s libDesc = $lg(listData,3)
	..s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(libCode),""))
	..Q:dicId=""
	..s ruleDicId = ""
	..for  s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicId,ruleDicId))  Q:ruleDicId=""  d
	...s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruleDicId)),2)
	...q:..isExistThisCat(ruleId,catList)'=1     			//判断规则是否在目录下
	...//找规则的关系
	...s rightType = ""
	...for  s rightType = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType))  Q:rightType=""  d
	....s rightDic = ""
	....for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic))  Q:rightDic=""  d
	.....s ruleDataId = ""
	.....for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightDic",rightType,rightDic,ruleId,ruleDataId))  Q:ruleDataId=""  d
	......s dicattrId = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	......s dicattrCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicattrId),2)
	......Q:(dicattrCode'="SolventProp")&&(dicattrCode'="SolutionProp")
	......s index = dicId_""_ruleId
	......Q:$d(mensolArr(index))
	......s mensolArr(index) = index
	......i $d(^tempmensolrule(dicId))  d
	.......s ^tempmensolrule(dicId) = ^tempmensolrule(dicId)_","_ruleId
	......e  d
	.......s ^tempmensolrule(dicId) = ruleId
	...s rightExtType = ""
	...for  s rightExtType = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType))  Q:rightExtType=""  d
	....s rightExtDic = ""
	....for  s rightExtDic = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,rightExtDic))  Q:rightExtDic=""  d
	.....s ruleExtDataId = ""
	.....for  s ruleExtDataId = $o(^CT.CKB.PDSS.RuleDataI("RightExt",rightExtType,rightExtDic,ruleId,ruleExtDataId))  Q:ruleExtDataId=""  d
	......s dicattrId = $lg(^CT.CKB.PDSS.RuleDataD(ruleExtDataId),4)
	......s dicattrCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicattrId),2)
	......Q:(dicattrCode'="SolventProp")&&(dicattrCode'="SolutionProp")
	......s index = dicId_""_ruleId
	......Q:$d(mensolArr(index))
	......s mensolArr(index) = index
	......i $d(^tempmensolrule(dicId))  d
	.......s ^tempmensolrule(dicId) = ^tempmensolrule(dicId)_","_ruleId
	......e  d
	.......s ^tempmensolrule(dicId) = ruleId
	Q ""
}

/// CreateDate:2020-12-02
/// Creator:sufan
/// Descript:导出项目日志方法
/// w ##class(web.DHCCKBCalculateval).ExportHisJournal("2020-10-01","2020-11-25")
ClassMethod ExportHisJournal(stDate, endDate)
{
	n (stDate,endDate)
	Q:(stDate="")||(endDate="") ""
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s count = 0
	s listData = ""
	for date=stDate:1:endDate  d
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("CreateDate",date,monId))  Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s adm = $lg(monData,2) 		//就诊id
	..s createDate = $lg(monData,3)	//创建日期
	..s createTime = $lg(monData,4) //创建时间
	..s createUser = $lg(monData,5)	//创建人
	..s locDesc = $lg(monData,6)	//科室
	..s passFlag = $lg(monData,7) 	//通过标识
	..s manLev = $lg(monData,8) 	//提示级别
	..s exaParam = $lg(monData,9) 	//入参
	..s exaRes = $lg(monData,10) 	//结果
	..s ipAdress = $lg(monData,11)  //ip地址
	..s hosp = $lg(monData,12) 		//医院
	..s mainList = adm_"^"_createDate_"^"_createTime_"^"_createUser_"^"_locDesc_"^"_passFlag_"^"_manLev_"^"_exaParam_"^"_exaRes_"^"_ipAdress_"^"_hosp
	..s queList = ""
	..s monQueId = ""
	..for  s monQueId = $o(^CKB.PDSS.MonQueListI("Parref",monId,monQueId))  Q:monQueId=""  d
	...s monData = $g(^CKB.PDSS.MonQueListD(monQueId))
	...s parrId = ""
	...s itemId = $lg(monData,3)	//药品Id
	...s proId = $lg(monData,4)	//属性Id
	...s funId = $lg(monData,5)	//项目Id
	...s tipsMsg = ""						
	...s queManLev = $lg(monData,7)	//级别
	...s order = $lg(monData,8)		//医嘱
	...s remark = $lg(monData,9)	//备注
	...s signs = $lg(monData,10)	//标记
	...s subList = parrId_"^"_itemId_"^"_proId_"^"_funId_"^"_tipsMsg_"^"_queManLev_"^"_order_"^"_remark_"^"_signs
	...i queList = "" s queList = subList
	...e  s queList = queList_"&&"_subList
	..s ruleList = ""
	..s monRuleId = ""
	..for  s monRuleId = $o(^CKB.PDSS.MonRuleListI("Parref",monId,monRuleId))  Q:monRuleId=""  d
	...s parRuleId = ""
	...s ruleId = $lg(^CKB.PDSS.MonRuleListD(monRuleId),3)  	     	//规则id
	...s ruleLev = $lg(^CKB.PDSS.MonRuleListD(monRuleId),4)  	     	//规则id
	...s rulesubList = parRuleId_"^"_ruleId_"^"_ruleLev
	...i ruleList=""  s ruleList = rulesubList
	...e  s ruleList = ruleList_"!!"_rulesubList
	..s listData = mainList_"#"_queList_"#"_ruleList
	..s count = count+1
	..s ^TMPExportHisJournal(pid,count) = listData
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2020-12-02
/// Descript:		
/// Input:          GlobalName - global名字, FilePath - D:\\EEEE.gbl 
/// W ##Class(web.DHCCKBCalculateval).ImportGlobal("TMPExportHisJournal", "D:\temp\TMPExportHisJournal.gof")
ClassMethod ImportGlobal(Global As %String, FilePath As %String) As %String
{
	n (Global, FilePath)
	D ##Class(%Library.Global).Import("", Global, FilePath)
	Q 0
}

/// CreateDate:2020-12-02
/// Creator:sufan
/// Descript:导入项目日志方法
/// w ##class(web.DHCCKBCalculateval).ImportHisJournal()
ClassMethod ImportHisJournal()
{
	
	s $ZT="ErrMsg"
	
	s err = 0
	s pid = 2628897,count = 0,trueCount = 0, errCount = 0
	s index = ""
	for  s index = $o(^TMPExportHisJournal(pid,index))  Q:(index="")  d
	.s listData = ^TMPExportHisJournal(pid,index)
	.s err = ..InsJoural(listData)
	.s count =count+1
	.//Q:err<0
	.i err<0  d
	..s ^TMPExportHisJournalErr(pid,index)=$g(^TMPExportHisJournal(pid,index))_"#"_"err"
	..s errCount=errCount+1
	.e  d
	..s ^TMPExportHisJournalTru(pid,index)=$g(^TMPExportHisJournal(pid,index))_"#"_"true"
	..s trueCount=trueCount+1
	
	//Q:err<0 err
	//TC
	//Q err
	q "总数:"_count_"失败:"_errCount_"成功:"_trueCount
ErrMsg
	tro
	Q index
}

ClassMethod InsJoural(listData)
{
	n (listData)
	s mainList = $p(listData,"#",1)     //主表
	s queList = $p(listData,"#",2)      //药品属性子表
	s ruleList = $p(listData,"#",3)     //规则子表
	
	s err = 0
	TS
	/// 监测主表
	s ID=..InsMonMaster(mainList)
	i ID<0 tro
	q:ID<0 ID
	
	s queLen = $l(queList,"&&")
	for i=1:1:queLen  Q:err'=0  d
	.s tmpQueList = $p(queList,"&&",i)
	.Q:tmpQueList=""
	.s err = ..InsMonQueList(ID,tmpQueList)
	
	i err'=0 tro
	q:err'=0 err
	
	s ruleLen = $l(ruleList,"!!")
	for j=1:1:ruleLen  Q:err'=0  d
	.s tmpRuleList = $p(ruleList,"!!",j)
	.Q:tmpRuleList=""
	.s err = ..InsMonRuleList(ID,tmpRuleList)

	i err'=0 tro
	q:err'=0 err
	TC
	Q err
}

/// Descript:   插入智能决策系统监测主表
ClassMethod InsMonMaster(mainList) As %String
{
	

	n (mainList)
	s AdmNo = $p(mainList,"^",1)     	 /// 就诊标识
	s CreateUser = "BYEY" ;$p(mainList,"^",4)    /// 创建人
	s LocDesc = $p(mainList,"^",5)       /// 科室
	s PassFlag = $p(mainList,"^",6)    	 /// 审查结果
	s ManLevID = $p(mainList,"^",7)    	 /// 管理级别
	s ExaParam = $p(mainList,"^",8)    	 /// 审查内容
	s ExaRes = $p(mainList,"^",9)      	 /// 审查结果
	s ClientIP = $p(mainList,"^",10)     /// 客户端IP
	s HospDesc = "包医二附院"   ;$p(mainList,"^",11)  	 /// 院区
	s CreateDate = +$H 	//$p(mainList,"^",2)    /// 创建日期
	s CreateTime = $p($h,",",2) //$p(mainList,"^",3)    /// 创建时间
	&SQL(Insert into CKB_PDSS.MonMaster(CM_Adm_Dr, CM_CreateDate, CM_CreateTime, CM_CreateUser, CM_PassFlag, CM_ManLev_Dr, CM_ExaParam, CM_ExaRes, CM_LocDesc, CM_Ip, CM_Hosp)
		Values(:AdmNo, :CreateDate, :CreateTime, :CreateUser, :PassFlag, :ManLevID, :ExaParam, :ExaRes, :LocDesc,:ClientIP,:HospDesc))
	Q +%ROWID
}

/// Descript:   插入智能决策系统监测问题表
ClassMethod InsMonQueList(Parrf As %String, queList As %String) As %String
{
	n (Parrf, queList)
	s itemId = $p(queList,"^",2)    	/// 药品id
	s proId = $p(queList,"^",3)     	/// 属性id
	s funId = $p(queList,"^",4)     	/// 项目id
	s tipsMsg = $p(queList,"^",5)   	/// 项目id
	s queManLev = $p(queList,"^",6)     /// 级别
	s order = $p(queList,"^",7)     
	s remark = $p(queList,"^",8)     
	s signs = $p(queList,"^",9)    
	
	&SQL(Insert into CKB_PDSS.MonQueList(CM_Parrf_Dr, CM_Item_Dr, CM_Pro_Dr, CM_Fun_Dr, CM_TipsMsg, CM_ManLev_Dr, CM_Order_Dr)
		Values(:Parrf, :itemId, :proId, :funId, :tipsMsg, :queManLev, :order))
	
	Q SQLCODE
}

/// Descript:   插入智能决策系统监测问题表
ClassMethod InsMonRuleList(Parrf As %String, ruleList As %String) As %String
{
	n (Parrf, ruleList)
	s ruleId = $p(ruleList,"^",2)    /// 管理级别
	s ruleLev=$p(ruleList,"^",3)     /// 提示内容
	s OrderID=""
	&SQL(Insert into CKB_PDSS.MonRuleList(CM_Parrf_Dr, CM_Rule_Dr, CM_ManLev_Dr, CM_Item_Dr)
		Values(:Parrf, :ruleId, :ruleLev, :OrderID))
	Q SQLCODE
}

/// d ##class(web.DHCCKBCalculateval).ExportGlobal()
/// d $SYSTEM.OBJ.ImportDir("D:\impglobal","CKBGlobal20211220rt01.gof")
ClassMethod ExportGlobal()
{
	k CList
	k myIdx
	
	//字典表
	s CList($i(CList))="DHCCKBMM.GBL" // 数据对照表
 
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = "D:\CKBGlobal"_time_"new"_".gof"
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// Descritp:	院区 
/// w ##Class(web.DHCCKBCalculateval).JsonHosp()
ClassMethod JsonHosp() As %String
{
	s count=0
	w "["
	s HospId=""
	F  s HospId=$o(^CT("HOSP",HospId)) Q:HospId=""  D
	.q:HospId=0
	.s HospData=^CT("HOSP",HospId)
	.s HospDesc=$p(HospData,"^",2)
	.s tmp=HospId_"^"_HospDesc
	.s count = count+1
	.i count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("Id^Desc",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("Id^Desc",tmp)
	w "]"
	q ""
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-03-15
/// Descript:		获取管理级别
/// Input:          GlobalName - global名字, FilePath - D:\\EEEE.gbl 
/// W ##Class(web.DHCCKBCalculateval).GetManLevel()
ClassMethod GetManLevel(q = "") As %String
{
	
	n (q )
	
	s input = q
	s input = $zcvt(input,"U") 
	
	s parref = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlagData")
	w "["
	s dicID = "", count = 0
	f  s dicID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicID))  q:dicID=""  d
	.q:dicID=0
	.q:0=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction","")
	.s dicCode = $lg(^CT.CKB.PDSS.CommonDictionD(+dicID),2)
	.s dicCode = $zcvt(dicCode,"U")
	.s dicDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+dicID),3)
	.s pinDicDesc = ##class(web.DHCCKBCommonUtil).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(input'="")&(dicCode'[input)&(dicDesc'[input)&(pinDicDesc'[input)
	.s listData=dicID_"^"_dicDesc
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",listData)
	w "]"

	q ""
}

/// Creator: 		yuliping
/// CreateDate: 	2021-07-22
/// Descript:		根据字典类型，获取药品列表
/// Input:          
/// W ##Class(web.DHCCKBCalculateval).QueryDrugListNew("",105)
ClassMethod QueryDrugListNew(flag, q = "")
{
	n (q,flag)
	s dicId=flag
	s count = 0
	w "["
	s Id = ""
	for  s Id = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicId,Id))  Q:Id=""  d
	.s desc = $lg(^CT.CKB.PDSS.CommonDictionD(+Id),3)
	.Q:(q'="")&&(desc'[q)
	.s count = count+1
	.Q:(q="")&&(count>100)
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Id_"^"_desc)
	w "]"
	q ""
}

/// Creator: 		yuliping
/// CreateDate: 	2021-07-22
/// Descript:		根据字典类型，获取药品属性列表
/// Input:          
/// W ##Class(web.DHCCKBCalculateval).listLinkProp(81816)
ClassMethod listLinkProp(dicID, q = "")
{
	
	n (dicID,q)
	s linkPropID=##class(web.DHCCKBRangeCat).GetAttrLink(dicID,"LinkProp")   // 属性关联id
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s IsAddValuePropID=##class(web.DHCCKBCommon).GetIsAddValueProp()		// 是否需要维护属性值
    s dataTypeID=##class(web.DHCCKBCommon).GetDataType()					// 数据展现类型

	k ^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid)
	
	s count = 0
	w "["

	s linkRowID="" 
	for  s linkRowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,linkPropID,linkRowID)) Q:linkRowID=""  d
	.s attrparref=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkRowID)),4)		// 属性集合
	.q:attrparref=""
	.d ##class(web.DHCCKBDiction).SortAttrByOrd(attrparref,pid,0)			//sufan 2020-04-08 排序
	.s Index=""
	.f  s Index=$o(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))  q:Index=""  d
	..s attrID=+$g(^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid,attrparref,Index))
	..s tmpAttrID=attrID
	..s attrLinkDr=$lg(^CT.CKB.PDSS.CommonDictionD(+attrID),5)
	..i attrLinkDr'="" s tmpAttrID=attrLinkDr	// 没有属性值，属性值link其他属性 
	..// 判断是否需要维护属性值
	..s tmpLinkID="",AddValueId="",AddValueFlag=""
	..i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID)) s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,IsAddValuePropID,""))
	..i tmpLinkID'="" s AddValueId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	..s:AddValueId'="" AddValueFlag=$lg(^CT.CKB.PDSS.CommonDictionD(+AddValueId),3)
	..q:$g(AddValueFlag)="N"
	..s value=$list(^CT.CKB.PDSS.CommonDictionD(+tmpAttrID),2,3)
	..s value = $lts(value,"")
	..i value="" d
	...s tmpLinkID=""
	...i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID))  s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",tmpAttrID,dataTypeID,""))
	...s dataTypeDr=""
	...i tmpLinkID'="" s dataTypeDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4)
	...s dataType=""
	...i dataTypeDr'="" s dataType=$lg(^CT.CKB.PDSS.CommonDictionD(+dataTypeDr),2)	// 具体属性的数据类型
	...s value=$list(^CT.CKB.PDSS.CommonDictionD(+tmpAttrID),2,3)
	...s value=$lts(value,"")
	..q:value=""
	..q:(q'="")&&(desc'[q)
	..s count = count+1
	..q:(q="")&&(count>100)
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",value)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",value)
	w "]"
	
	k ^TMP("DHCCKB","web.DHCCKBDiction","GetSortAttrData",pid)

	q ""
}

/// Descript:按分类查询药品属性为空的
/// Creator:yuliping
/// CreateDate:2021-07-22
/// w ##Class(websys.Query).ToExcel("药品分类数据","web.DHCCKBCalculateval","QueryIncInfoNew","105^^^^GenerNameFormProp^0")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryIncInfoNew","5^^^^警告,GenerNameFormProp,ProNameProp^0") 
Query QueryIncInfoNew(params) As websys.Query(ROWSPEC = "drugId:%String:drugId,drug:%String:药品名称,hisCode:%String:his药品代码,desc:%String:his药品名称,generName:%String:通用名,drugComp:%String:成分,drugDosa:%String:剂型,drugCat:%String:分类,sameGenDrug:%String:相同通用名的药品,type:%String:字典,drugCatId:%String:drugCatId,rule:%String:是否存在规则,generFormName:%String:带剂型的通用名,drugManuf:%String:生产厂家,equunit:%String:等效单位,hisequunit:%String:HIS等效单位,nounitinlib:%String:等效单位中不存在的单位,errruleNum:%String:错误规则序号,usadosRule:%String:用法用量中存在溶媒溶液,num")
{
}

ClassMethod QueryIncInfoNewExecute(ByRef qHandle As %Binary, params) As %Status
{
	n (qHandle,params)
	s ^temptest("params")=$lb(params)
	Set repid=$I(^CacheTemp)	
	Set ind=1

	s dictionId = $p(params,"^",1)
	s drugDesc = $p(params,"^",2)
	s geneDesc = $p(params,"^",3)
	s ingrDesc = $p(params,"^",4)
	s isEmpty = $p(params,"^",5)
	s isDefalt = $p(params,"^",7)
	s isCheckbox = $p(params,"^",6)
	s extraAttrDr = ##class(web.DHCCKBCommon).GetDicIdByCode("DataSource")	//附加属性
 	
 	s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dictionId,extraAttrDr,""))
	i linkID="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:linkID="" ""

	s dictionId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 附加属性值
	i dictionId="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	q:dictionId="" ""

 	k IncInfoNewArr
	s drugId = ""
	s generName = "",drugCat = "",drugComp = "",drugDosa = "",ruleFlag = "N",drugManuf = "",equunit = "",nounitinlib = ""
	s errruleNum = ""
	s hisCode = "",desc = ""
	s count = 0,num = 0
	s type = $lg(^CT.CKB.PDSS.CommonDictionD(+dictionId),2)
	for  s drugId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dictionId,drugId))  Q:drugId=""  d
	.q:##class(web.DHCCKBCommon).IsEnabled(drugId)=0     //  过滤停用数据
	.s count=count+1
	.s flag = ..getEmptyAtt(isEmpty,drugId)
	.q:flag=0
	.s num=num+1
	.s drug = $lg(^CT.CKB.PDSS.CommonDictionD(+drugId),3)
	.s generName = ##class(web.DHCCKBDrugVO).GetGenerName(drugId)						//通用名
	.s drugComp = ##class(web.DHCCKBDrugVO).GetIngredient(drugId) 																			//成分
	.s drugDosa = ##class(web.DHCCKBDrugVO).GetFormType(drugId)																						//剂型
	.s drugCatList = ##class(web.DHCCKBDrugVO).GetCat(drugId)		
	.s Indic=##class(web.DHCCKBCommon).GetDrugIndicNew() 				 			//适应症属性
	.s Indication=##class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,Indic,1) 			//kml																						//分类
	.s drugCat = $p(drugCatList,"$",1)
	.s drugCat = $replace(drugCat,"^","<br>")
	.s sameGenDrugList = ..GetCatWithSameGenname(drugId,generName)
	.s sameGenDrug = $p(sameGenDrugList,"$",1)
	.s drugCatId = $p(sameGenDrugList,"$",2)
	.s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(drugId)		//判断是否有规则
	.s rule = $s(ruleFlag="1":"存在规则",1:"不存在规则")
	.s generFormName = ##class(web.DHCCKBDrugVO).GetGenerFromName(drugId)
	.s drugManuf = ##class(web.DHCCKBDrugVO).GetDrugManuf(drugId)		//生产厂家
	.s equunit = ##class(web.DHCCKBDrugVO).GetEquunit(drugId)									//等效单位
	.s hisequunit = ""
	.s nounitinlib = ""		//..QueryunitInRule(drugId)							//规则中存在，等效单位中不存在的单位
	.s errruleNum = $g(^tempAllErrRule(drugId))
	.s usadosRule = $g(^tempmensolrule(drugId))
	.s drug = $tr(drug,$c(9),"")
	.s IncInfoNewArr(num) = $lb(drugId,drug,hisCode,desc,generName,drugComp,drugDosa,drugCat,sameGenDrug,type,drugCatId,rule,generFormName,drugManuf,equunit,hisequunit,nounitinlib,errruleNum,usadosRule)
	
	s rate =$justify((num*100)/count,6,4)
	s rateNext = 100-rate
	s str = "属性为空药品数："_num_"，药品总数："_count_"，为空占比："_rate_"%，完整率："_rateNext_"%"
	s nums = 0
	f  s nums = $o(IncInfoNewArr(nums)) q:nums=""  d
	.s IncInfoNewArr(nums) = $LISTUPDATE(IncInfoNewArr(nums),20,str)
	.b
	.set ^CacheTemp(repid,ind)=IncInfoNewArr(nums)
	.set ind=ind+1	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Descript:	根据药品判断某些属性是否为空
/// Creator:	yuliping
/// CreateDate:	2021-07-22
/// input:		isEmpty:属性，drugId：药品id
/// return:  	多个属性全为空:1 
/// w ##class(web.DHCCKBCalculateval).getEmptyAtt("GenerNameFormProp,ProNameProp",150)
ClassMethod getEmptyAtt(isEmpty, drugId)
{
	n (isEmpty,drugId)
	
	s flag=0
	s rtn=0
	s length = $l(isEmpty,",")   //属性个数
	s thisFlag = 0
	f i=1:1:length q:thisFlag=1  d
	.s phaKinattr = ##Class(web.DHCCKBCommon).GetDrugAttrId($p(isEmpty,",",i))
	.s phaKin = ##Class(web.DHCCKBDrugVO).GetDicValueByPro(drugId,phaKinattr,1)
	.i phaKin'="" s thisFlag=1   //只要存在一个不是空，就退出循环，避免浪费资源
	.i phaKin="" s rtn=rtn+1

	i rtn=length s flag =1  //属性空的个数和属性个数一样，就是全部为空
	
	q flag
}

/// Descript：query数据转换
/// w ##class(web.DHCCKBCalculateval).QueryIncInfoJson("30","1","95^^^^^0")
ClassMethod QueryIncInfoJsonNew(rows, page, params)
{
	n (rows,page,params)
	s End=page*rows
	s Start=(page-1)*rows+1
	s result=##class(%Library.ResultSet).%New("web.DHCCKBCalculateval:QueryIncInfoNew")
 s sc=result.Execute(params)
 If $$$ISERR(sc) Quit ""
 s colNum=result.GetColumnCount() //列数
 s count = 0
 s del=""""
 Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
 While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.
		s count=count+1
		Continue:(count<Start)||(count>End)
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

/// Descript:获取药品适应症和禁忌症规则里的疾病信息
/// Creator:sufan
/// CreateDate:2021-12-16
/// Input:药品id
/// w ##class(web.DHCCKBCalculateval).QueryDisease(96737)
ClassMethod QueryDisease(drugId)
{
	n (drugId)
	s ruleIndicId = ##class(web.DHCCKBCommon).GetDrugIndicNew()			//适应症
	s ruleContrId = ##class(web.DHCCKBCommon).GetDrugContrNew()			//禁忌症
	s diseList = ""
	k tmpDisArr
	s ruledicId = ""
	for  s ruledicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruledicId)) Q:ruledicId=""  d
	.s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruledicId)),2)
	.s disindex = ""
	.s:$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleIndicId)) disindex = "适应症"
	.s:$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleContrId)) disindex = "禁忌症"
	.Q:('$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleIndicId)))&&('$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleContrId)))
	.s rightDic = ""
	.for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",rightDic)) Q:rightDic=""  d
	..s ruleDataId = ""
	..for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",rightDic,ruleId,ruleDataId))  Q:ruleDataId=""  d
	...s leftDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	...Q:leftDic=""
	...s leftDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDic),3)
	...q:leftDesc'="西医疾病"
	...s rigDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),8)
	...s rigDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+rigDic),3)
	...i $d(tmpDisArr(disindex))  d
	....s tmpDisArr(disindex) = tmpDisArr(disindex)_";&nbsp;&nbsp;&nbsp;"_rigDesc
	...e  d
	....s tmpDisArr(disindex) = rigDesc
	
	s index = ""
	for  s index = $o(tmpDisArr(index))   Q:index=""  d
	.s dise = tmpDisArr(index)
	.i diseList = "" s diseList = index_":<br><br>"_dise_"<br>"
	.e  s diseList = diseList_"<br><br>"_index_":<br><br>"_dise
	Q diseList
}

/// Descript:统计禁忌症，适应症总数
/// CreateDate:2021-12-16
/// Creator:sufan
/// Input:医院，分类
/// w ##class(web.DHCCKBCalculateval).QueryCatDisNum("118^皮肤科用药")
/// w ##class(web.DHCCKBCalculateval).QueryCatDisNum("142^")
ClassMethod QueryCatDisNum(params)
{
	n (params)

	s ruleIndnum = "",ruleContnum = "",allcatnum = ""
	s ruleIndicId = ##class(web.DHCCKBCommon).GetDrugIndicNew()			//适应症
	s ruleContrId = ##class(web.DHCCKBCommon).GetDrugContrNew()			//禁忌症
	s ruleInList = "",ruleconList = "",allList = ""
	k tmpAllArr
	k tmpinArr
	k tmpconArr
	s hosp = $p(params,"^",1)
	s drugCat = $p(params,"^",2)
	s typeStr = "DrugData^ChineseDrugData"
	for i=1:1:2  d
	.s type = $p(typeStr,"^",i)
	.s extId = "0"
	.for  s extId = $o(^CKB.PDSS.ExtDictionI("Type",hosp,type,extId))  Q:extId=""  d
	..s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	..s hisCode = $lg(extData,2) 
	..s hisDesc = $lg(extData,3)
	..s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	..s conDicId = ""
	..s desc = $p(hisDesc,"||",1)
	..for  s conDicId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(desc),conDicId))  Q:conDicId=""  d
	...s listData =$g(^CKB.PDSS.ComContrastD(conDicId))
	...s drug = $lg(listData,3)
	...s drugCode = $lg(listData,2)
	...s hisCode = $lg(listData,4)
	...s drugId = ..GetFreDicId(dictionId,drug,drugCode)
	...Q:drugId=""
	...s drugCatList = ##class(web.DHCCKBDrugVO).GetCat(drugId)	
	...Q:(drugCat'="")&&(drugCatList'="")&&(drugCatList'[drugCat)
	...s ruledicId = ""
	...for  s ruledicId = $o(^CT.CKB.PDSS.RuleDicI("Dic",drugId,ruledicId)) Q:ruledicId=""  d
	....s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(ruledicId)),2)
	....s disindex = ""
	....s:$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleIndicId)) disindex = "适应症"
	....s:$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleContrId)) disindex = "禁忌症"
	....Q:('$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleIndicId)))&&('$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,ruleContrId)))
	....s rightDic = ""
	....for  s rightDic = $o(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",rightDic)) Q:rightDic=""  d
	.....s ruleDataId = ""
	.....for  s ruleDataId = $o(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",rightDic,ruleId,ruleDataId))  Q:ruleDataId=""  d
	......s leftDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),4)
	......Q:leftDic=""
	......s leftDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+leftDic),3)
	......q:leftDesc'="西医疾病"
	......s rigDic = $lg(^CT.CKB.PDSS.RuleDataD(ruleDataId),8)
	......s rigDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+rigDic),3)
	......i (disindex="适应症")&&('$d(tmpinArr(rigDesc))) d
	.......s tmpinArr(rigDesc) = rigDesc
	.......s ruleIndnum = ruleIndnum+1
	.......i ruleInList=""  s ruleInList = rigDesc
	.......e  s ruleInList = ruleInList_"<br><br>"_rigDesc
	......i (disindex="禁忌症")&&('$d(tmpconArr(rigDesc)))  d
	.......s tmpconArr(rigDesc) = rigDesc
	.......s ruleContnum = ruleContnum+1
	.......i ruleconList = ""  s ruleconList = rigDesc
	.......e  s ruleconList = ruleconList_"<br><br>"_rigDesc
	......i '$d(tmpAllArr(rigDesc))  d
	.......s allcatnum = allcatnum+1
	.......i allList="" s allList = rigDesc
	.......e  s allList = allList_"<br><br>"_rigDesc
	......s tmpAllArr(rigDesc) = rigDesc
	
	Q ruleIndnum_"^"_ruleContnum_"^"_allcatnum_"^"_ruleInList_"^"_ruleconList_"^"_allList
}

/// Descript:查询用药方式和妊娠期分级(停用)
/// CreateDate:2022-04-25
/// Creator:xww
/// Input:
/// Output:
/// w ##class(web.DHCCKBCalculateval).QueryFDADrug(10,1,"")
ClassMethod QueryFDADrugOld(rows As %String = 10, page As %String = 1, params)
{
	n (rows,page,params)
	k GroupArr
	s GenerName=$p(params,"^",1)		// 通用名
	s DrugPreMet=$p(params,"^",2)		// 用药方式
	s PregnancyDrugLevel=$p(params,"^",3)	// 妊娠期分级
	s end=page*rows
	s start=(page-1)*rows+1
	s count=0	
	s ListTitle="dicID^GenerName^DrugPreMet^PregnancyDrugLevel"
	s GeneralID=##class(web.DHCCKBCommon).GetGeneralData()   // 化学名字典 49802
	s GenerNameFDAProp=##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameFDAProp")  //化学名妊娠分级 236611
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp() //77954
	
	s medriskpregId=##class(web.DHCCKBCommon).GetDicIdByCode("medriskpreg") //用药方式id
	s FDAPregnancyDrugLevel=##class(web.DHCCKBCommon).GetDicIdByCode("FDAPregnancyDrugLevel") //妊娠期分级id
	w "{""rows"":["
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",GeneralID,dicID))   q:dicID=""  d
	.s dicCode=$lg(^CT.CKB.PDSS.CommonDictionD(+dicID),2)
	.s dicDesc=$lg(^CT.CKB.PDSS.CommonDictionD(+dicID),3)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	.q:(GenerName'="")&($zcvt(dicCode,"U")'[$zcvt(GenerName,"U"))&(dicDesc'[GenerName)&(pinDesc'[$zcvt(GenerName,"U"))
	.;q:(parDesc'="")&($zcvt(dicCode,"U")'[$zcvt(parDesc,"U"))&(dicDesc'[parDesc)&(pinDesc'[$zcvt(parDesc,"U"))
	.;d ..GetAttrValueNew(dicID,medriskpregId,.GroupArr)
	.;d ..GetAttrValueNew(dicID,FDAPregnancyDrugLevel,.GroupArr)
	.if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",GenerNameFDAProp,LinkPropId)) d
	..s LinkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",GenerNameFDAProp,LinkPropId,""))  //^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",236611,77954
	..s ParrPorpId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkAttrId)),4)	
	..s subId=""	
	..for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",ParrPorpId,subId))  Q:subId=""  d
	...s FdaLevelData="",medriskpregData=""
	...s dlaRowId=""
	...for  s dlaRowId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,subId,dlaRowId))  Q:dlaRowId=""  d
	....s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),3)		//知识类别 
	....q:dicAttrCode="" 
	....s dicAttrLonkCode=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrCode),2)
	....s:dicAttrLonkCode="" dicAttrLonkCode=$lg(^CT.CKB.PDSS.CommonDictionD(+($lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrCode),5))),2)
	
	....s dicAttrLonkParref=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrCode),5)
	....s dicAttrLonkParrfCode=""
	....s:dicAttrLonkParref'="" dicAttrLonkParrfCode=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrLonkParref),2) //FDAPregnancyDrugLevel^FDA妊娠药物分级
	....s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),4)			//属性ID
	....s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),5)				//备注
	....s dicGroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowId)),6)		//成组标识
	....i dicAttrLonkCode="medriskpreg" d
	.....;s:medriskpregData'="" medriskpregData=medriskpregData_","_$lg(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),2)
	.....;s:medriskpregData="" medriskpregData=$lg(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),2)
	.....s medriskpregData=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId),3)
	....i dicAttrLonkCode="FDAPregnancyDrugLevel" d
	.....q:$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId),3)=""
	.....;s:FdaLevelData'="" FdaLevelData=FdaLevelData_","_$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId)),2)
	.....;s:FdaLevelData="" FdaLevelData=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId)),2)
	.....s FdaLevelData=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId),3)
	....i dicAttrLonkParrfCode="FDAPregnancyDrugLevel" d
	.....q:dicRes=""
	.....s:FdaLevelData'="" FdaLevelData=FdaLevelData_","_dicRes
	.....s:FdaLevelData="" FdaLevelData=dicRes
	.....s FdaLevelData=dicRes
	...q:(DrugPreMet'="")&&(medriskpregData'[DrugPreMet)
	...q:(PregnancyDrugLevel'="")&&(FdaLevelData'[PregnancyDrugLevel)
	...s count = count+1
	...s ListData=dicID_"^"_dicDesc_"^"_medriskpregData_"^"_FdaLevelData
	...q:(count<start)||(count>end)
	...i count=start d
	....w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	...e  d
	....w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	w "],""total"":"_count_"}"
	q ""
}

// w ##class(web.DHCCKBCalculateval).GetAttrValueNew(49916,236613,.GroupArr)

/// Descript:查询化学名妊娠分级模板属性值
/// CreateDate:2022-04-25
/// Creator:xww
/// Input:
/// Output:GroupArr(EntyId,GroupFlag,AttrCodeId) 
/// w ##class(web.DHCCKBCalculateval).QueryFDADrug(10,1,"")
ClassMethod GetAttrValueArr(EntyId, AttrCodeId, GroupArr)
{
	n (EntyId, AttrCodeId,GroupArr)
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
	....s Desc=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId),3)_"^"_$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId),2)   //添加code   shy
	....s DicLinkId=$lg(^CT.CKB.PDSS.CommonDictionD(+dicAttrId),5)
	....s:Desc="^" Desc=""
	....s:(Desc="")&&(DicLinkId'="") Desc=dicAttrId_"^"_dicAttrId
	...i dicAttrId'="" s ListData=Desc
	...e  s ListData=dicRes
	...q:GroupFlag=""
	...i $d(GroupArr(EntyId,GroupFlag,AttrCodeId))  d
	....s GroupArr(EntyId,GroupFlag,AttrCodeId)=GroupArr(EntyId,GroupFlag,AttrCodeId)_ListData
	...e  d
	....s GroupArr(EntyId,GroupFlag,AttrCodeId)=ListData
	e  d
	.s AttrId=""
	.for  s AttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",EntyId,AttrCodeId,AttrId))  Q:AttrId=""  d
	..s LinkAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),4)	
	..s Res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),5)	
	..s Desc=""
	..i LinkAttrId'=""   d
	...s Desc=$lg(^CT.CKB.PDSS.CommonDictionD(+LinkAttrId),3)  //_"^"_$lg(^CT.CKB.PDSS.CommonDictionD(LinkAttrId)),"^",1)   //添加code   shy   2021-6-7
	...s:Desc="^" Desc=""
	...s LinkId=$lg(^CT.CKB.PDSS.CommonDictionD(+LinkAttrId),5)
	...s:(Desc="")&&(LinkId'="") Desc=LinkAttrId  //_"^"_LinkAttrId   //添加code   shy 2021-6-7
	..
	..i LinkAttrId'="" s ListData=Desc
	..e  s ListData=Res
	..s GroupFlag=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(AttrId)),6)			//成组标识
	..q:GroupFlag=""

	..i $d(GroupArr(EntyId,GroupFlag,AttrCodeId))  d
	...s GroupArr(EntyId,GroupFlag,AttrCodeId)=GroupArr(EntyId,GroupFlag,AttrCodeId)_","_ListData
	..e  d
	...s GroupArr(EntyId,GroupFlag,AttrCodeId)=ListData
	Q ""
}

/// Descript:查询用药方式和妊娠期分级
/// CreateDate:2022-04-25
/// Creator:xww
/// Input:
/// Output:
/// w ##class(web.DHCCKBCalculateval).QueryFDADrug(10,1,"")
ClassMethod QueryFDADrug(rows As %String = 10, page As %String = 1, params)
{
	n (rows,page,params)
	k GroupArr
	s GenerName=$p(params,"^",1)		// 通用名
	s DrugPreMet=$p(params,"^",2)		// 用药方式
	s PregnancyDrugLevel=$p(params,"^",3)	// 妊娠期分级
	s Note=$p(params,"^",4)	// 备注
	s end=page*rows
	s start=(page-1)*rows+1
	s count=0	
	s ListTitle="dicID^GenerName^DrugPreMet^PregnancyDrugLevel"
	s GeneralID=##class(web.DHCCKBCommon).GetGeneralData()   // 化学名字典 49802
	s GenerNameFDAProp=##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameFDAProp")  //化学名妊娠分级 236611
	s LinkPropId=##class(web.DHCCKBCommon).GetLinkProp() //77954
	;s medriskpregId=##class(web.DHCCKBCommon).GetDicIdByCode("medriskpreg") //用药方式id
	;s FDAPregnancyDrugLevelId=##class(web.DHCCKBCommon).GetDicIdByCode("FDAPregnancyDrugLevel") //妊娠期分级id
	s GenerNameFDATempID=##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameFDATemp") // 化学名妊娠分级模板
	s dicID=""   f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",GeneralID,dicID))   q:dicID=""  d
	.s subId=""	
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",GenerNameFDATempID,subId))  q:subId=""  d
	..d ..GetAttrValueArr(dicID,subId,.GroupArr)
	w "{""rows"":["
	s EntyId=""
	f  s EntyId=$o(GroupArr(EntyId)) q:EntyId=""  d
	.s Group=""
	.f  s Group=$o(GroupArr(EntyId,Group)) q:Group=""  d
	..s dicCode=$lg(^CT.CKB.PDSS.CommonDictionD(+EntyId),2)
	..s dicDesc=$lg(^CT.CKB.PDSS.CommonDictionD(+EntyId),3)
	..s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(dicDesc))
	..q:(GenerName'="")&($zcvt(dicCode,"U")'[$zcvt(GenerName,"U"))&(dicDesc'[GenerName)&(pinDesc'[$zcvt(GenerName,"U"))
	..s attrcodeId="",medriskpregData="",FdaLevelData=""
	..f  s attrcodeId=$o(GroupArr(EntyId,Group,attrcodeId)) q:attrcodeId=""  d
	...s LinkAttrCode=$lg(^CT.CKB.PDSS.CommonDictionD(+attrcodeId),2)	
	...s Res=$lg(^CT.CKB.PDSS.CommonDictionD(+attrcodeId),5)	
	...s Code=""
	...i Res'=""   d
	....s Code=$lg(^CT.CKB.PDSS.CommonDictionD(+Res),2)
	...e  d
	....s Code=LinkAttrCode
	...s:Code="medriskpreg" medriskpregData=GroupArr(EntyId,Group,attrcodeId)  		 // 用药方式
	...s:Code="FDAPregnancyDrugLevel" FdaLevelData=GroupArr(EntyId,Group,attrcodeId) // 妊娠期分级
	..q:(DrugPreMet'="")&&(medriskpregData'[DrugPreMet)
	..q:(PregnancyDrugLevel'="")&&(FdaLevelData'[PregnancyDrugLevel)
	..;q:(Note'="")&&(medriskpregData'[DrugPreMet)
	..s count = count+1
	..s ListData=EntyId_"^"_dicDesc_"^"_medriskpregData_"^"_FdaLevelData
	..q:(count<start)||(count>end)
	..i count=start d
	...w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	w "],""total"":"_count_"}"
	q ""
}

/// Creator:	qunianpeng
/// CreatDate:	2022-06-01
/// Description: 存储his的等效单位到系统中
/// Input:  	 药品id,his等效单位串(格式: 瓶-g-0.5,瓶-ml-100),系统等效单位串(格式: 0.25g/片,250mg/片)
/// w ##class(web.DHCCKBCalculateval).AddHisEqUnit(81646,"g-mg-1000,l-ml-1000","1000ml/l","1^^1^1^2","113.140.81.66")
ClassMethod AddHisEqUnit(drugId, hisEqUnit, sysEqUnit, loginInfo, clientIP)
{
	n (drugId, hisEqUnit, sysEqUnit,loginInfo,clientIP)

	// 比较his单位和系统单位,去掉已经存在的部分
	k TmpArr
	s eqstr = ..CompareEqUnit(drugId,hisEqUnit,sysEqUnit)
	q:eqstr="" "-1"

	s ret = ##class(web.DHCCKBDicLinkAttr).saveDicAttrByType(eqstr,"datagrid",loginInfo,clientIP)
	
	q ret
}

/// Creator:	qunianpeng
/// CreatDate:	2022-06-01
/// Description: 比较his单位和系统单位,去掉已经存在的部分,并组织成保存的串
/// Input:  	 药品id,his等效单位串(格式: 瓶-g-0.5,瓶-ml-100),系统等效单位串(格式: 0.25g/片,250mg/片)
/// w ##class(web.DHCCKBCalculateval).CompareEqUnit(81646,"g-mg-1000,l-ml-1000","1000ml/l")
ClassMethod CompareEqUnit(drugId, hisEqUnit, sysEqUnit)
{
	n (drugId,hisEqUnit,sysEqUnit)
	
	s eqUnitProp = ##class(web.DHCCKBCommon).GetEqUnitProp() // 等效单位属性id
	s eqstr = ""
	
	s drugstr = "0^"_drugId_"^"_eqUnitProp_"^^"
	k TmpArr
	f i=1:1:$length(sysEqUnit,",")  d
	.s sysEqStr = $p(sysEqUnit,",",i)  // 0.25g/片,250mg/片
	.s left = $p(sysEqStr,"/",1)
	.s right = $p(sysEqStr,"/",2)
	.q:(left="")||(right="")
	.s fUnit = $p(left,+left,2)
	.s tUnit = right
	.s TmpArr(fUnit,tUnit) = ""
	.s TmpArr(tUnit,fUnit) = ""
	
	s eqlist = ""
	f i=1:1:$length(hisEqUnit,",")  d // 瓶-g-0.5,瓶-ml-100
	.s hisEqStr = $p(hisEqUnit,",",i) 
	.s fUnit = $p(hisEqStr,"-",1)
	.s tUnit = $p(hisEqStr,"-",2)
	.s factor = $p(hisEqStr,"-",3)
	.q:(fUnit="")||(tUnit="")
	.// 如果单位不存在,需要新增单位
	.s parref = ##class(web.DHCCKBCommon).GetUnitData()
	.q:+parref=0 
	.s fUnitId = ..SaveCommonDic(fUnit,fUnit,parref)
	.s tUnitId = ..SaveCommonDic(tUnit,tUnit,parref)
	.q:$d(TmpArr(fUnit,tUnit))
	.q:$d(TmpArr(tUnit,fUnit))
	.s dataList = "^"_drugId_"^"_eqUnitProp_"^"_fUnitId_"^"_"EqFromUnitPropId"_"^"_(i-1)_"^"
	.s dataList = dataList_"&&"_"^"_drugId_"^"_eqUnitProp_"^"_tUnitId_"^"_"EqToUnitPropId"_"^"_(i-1)_"^"
	.s dataList = dataList_"&&"_"^"_drugId_"^"_eqUnitProp_"^"_factor_"^"_"EqFactorProp"_"^"_(i-1)_"^"
	.i eqlist="" s eqlist = dataList
	.e  s eqlist = eqlist_"&&"_dataList 
	
	q:eqlist="" ""
	s eqstr = drugstr_"&&"_eqlist	
	
	q eqstr
}

/// Creator:	qunianpeng
/// CreatDate:	2022-06-01
/// Description: 保存字典数据,存在则取id,不存在,则新增,返回新增id
/// Input:  	代码,描述,字典id
/// w ##class(web.DHCCKBCalculateval).SaveCommonDic("mg","mg","127")
ClassMethod SaveCommonDic(code, desc, parref)
{
	n (code,desc,parref)
	
	q:(code="")&(desc="") 0
	
	s dicID=##class(web.DHCCKBRuleImport).CheckDictionExist(code,desc,parref)

	q:+dicID'=0 dicID
	s dicID=0	
	s code = ##class(web.DHCCKBDiction).GetSysCodeByType(parref,code)  // 根据parref判断是否需要自动生成编码(字典数据需要生成编码) qnp 20230509
	s dicID=##class(web.DHCCKBDiction).SaveDic("^"_code_"^"_desc_"^"_parref)	//保存

	q dicID
}

/// Creator: 	sufan
/// CreateDate: 2020-07-16
/// Descript: 	查询医院列表
/// w ##class(web.DHCCKBCalculateval).QueryHospList()
ClassMethod QueryHospList(q = "") As %String
{
	n (q)
  	s count=0
  	s HospId=0
  	w "["
  	for  s HospId=$o(^CT("HOSP",HospId) ) q:(HospId="")||(+HospId=0)  d
  	.s Code=$p(^CT("HOSP",HospId),"^",1)
  	.s Desc=$p(^CT("HOSP",HospId),"^",2)
  	.s QuitStr = Code_Desc
  	.Q:(q'="")&&(QuitStr'[q)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",HospId_"^"_Desc)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",HospId_"^"_Desc)
 	w "]"
	q ""
}

/// Creator: 	xww
/// CreateDate: 2022-08-29
/// Descript: 	获取对照数据中知识库描述或代码修改得数据
/// w ##Class(websys.Query).ToExcel("对照后修改过代码或描述的药品","web.DHCCKBCalculateval","QueryModifyDrug","106")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","QueryModifyDrug","106") 
Query QueryModifyDrug(hosp) As websys.Query(ROWSPEC = "drug:%String:药品名称,drugCode:%String:药品代码,hisCode:%String:his药品代码,desc:%String:his药品名称")
{
}

ClassMethod QueryModifyDrugExecute(ByRef qHandle As %Binary, hosp) As %Status
{
	n (qHandle,hosp)
	Set repid=$I(^CacheTemp)
	k TmpArr	
	Set ind=1
	s count=0
	s typeStr = "DrugData^ChineseDrugData"
	for i=1:1:$l(typeStr,"^")  d
	.s type = $p(typeStr,"^",i)
	.s extId = "0"
	.for  s extId = $o(^CKB.PDSS.ExtDictionI("Type",hosp,type,extId))  Q:extId=""  d
	..s extData = $g(^CKB.PDSS.ExtDictionD(extId)) 
	..s hisCode = $lg(extData,2)
	..s hisDesc = $lg(extData,3)
	..;s type = $lg(extData,4)
	..s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	..s conDicId = ""
	..s desc = $p(hisDesc,"||",1)
	..for  s conDicId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(desc),conDicId))  Q:conDicId=""  d
	...s listData =$g(^CKB.PDSS.ComContrastD(conDicId))
	...s drug = $lg(listData,3)
	...s drugCode = $lg(listData,2)
	...s hisCode = $lg(listData,4)
	...s hisHosp = $lg(listData,7)
	...s count=count+1
	...q:hosp'=hisHosp
	...s modifyFlag = ..IsConsDrugModify(dictionId,drug,drugCode)
	...i modifyFlag'=0 d
	....s drugNew = $replace(drug,$c(9),"")   // 转换空格
	....s drugNew = $replace(drugNew,"（","(")   // 转换括号
	....s drugNew = $replace(drugNew,"）",")")
	....s drugCodeNew = $replace(drugCode,$c(9),"")   // 转换空格
	....s drugCodeNew = $replace(drugCodeNew,"（","(")
	....s drugCodeNew = $replace(drugCodeNew,"）",")")
	....s modifyFlagNew=..IsConsDrugModify(dictionId,drugNew,drugCodeNew)  //有无括号引起的没匹配上
	....s:modifyFlagNew=1 TmpArr(count,conDicId)=$lb(drug,drugCode,desc,hisCode)   //记录下因为中英文括号或空格导致的药品
	...;b:drug["谷红注射液"
	...q:modifyFlag'=0 
	...;s TmpArr(count,conDicId)=$lb(drug,drugCode,desc,hisCode)
	...set ^CacheTemp(repid,ind)=$lb(drug,drugCode,desc,hisCode)
	...set ind=ind+1	
	b ;34
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator: 	xww
/// CreateDate: 2022-08-29
/// Descript: 	获取对照数据中知识库描述或代码修改得数据
/// w ##class("web.DHCCKBCalculateval").IsConsDrugModify(105,"注射用重组人白介素-2(125Ala)10万IU(北京双鹭药业股份有限公司)")
ClassMethod IsConsDrugModify(freqDicId, freq, drugCode = "")
{
	n (freqDicId,freq,drugCode)
	s ret = "",ClibIdList=""
	s freqId = ""
	for  s freqId = $o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(freq),freqId))  Q:(freqId="")  d
	.s parfreqId = $lg(^CT.CKB.PDSS.CommonDictionD(+freqId),4)
	.Q:freqDicId'=parfreqId
	.q:$lf(ClibIdList,freqId)'=0
	.s $list(ClibIdList,*+1)=freqId	
	s CCodeList=""
	s codeRet = ""
	i drugCode'=""  d
	.for  s freqId = $o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(drugCode),freqId))  Q:freqId=""  d
	..s parfreqId = $lg(^CT.CKB.PDSS.CommonDictionD(+freqId),4)
	..Q:freqDicId'=parfreqId
	..q:$lf(CCodeList,freqId)'=0
	..s $list(CCodeList,*+1)=freqId	
	
	Q:(ClibIdList="")||(CCodeList="") 0
	Q:##Class(web.DHCCKBCommonUtil).GetMixList(ClibIdList,CCodeList)="" 0
	q $list(##Class(web.DHCCKBCommonUtil).GetMixList(ClibIdList,CCodeList))
}

/// Creator: 	xww
/// CreateDate: 2022-09-05
/// Descript: 	导出药品信息数据（知识库药品名称、通用名称、化学名称、剂型）
/// w ##Class(websys.Query).ToExcel("对照后修改过代码或描述的药品","web.DHCCKBCalculateval","ExportHospDrug","106")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBCalculateval","ExportHospDrug","106") 
Query ExportHospDrug(hosp) As websys.Query(ROWSPEC = "drug:%String:知识库药品名称,drugCode:%String:药品代码,hisCode:%String:his药品代码,desc:%String:his药品名称,DrugGenerName:%String:通用名,GenerName:%String:化学名,FormType:%String:剂型")
{
}

ClassMethod ExportHospDrugExecute(ByRef qHandle As %Binary, hosp) As %Status
{
	n (qHandle,hosp)
	Set repid=$I(^CacheTemp)
	k TmpArr	
	Set ind=1
	s count=0
	s typeStr = "DrugData^ChineseDrugData"
	for i=1:1:$l(typeStr,"^")  d
	.s type = $p(typeStr,"^",i)
	.s extId = "0"
	.for  s extId = $o(^CKB.PDSS.ExtDictionI("Type",hosp,type,extId))  Q:extId=""  d
	..s extData = $g(^CKB.PDSS.ExtDictionD(extId))
	..s hisCode = $lg(extData,2) 
	..s hisDesc = $lg(extData,3)
	..;s type = $lg(extData,4) 
	..s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(type)
	..s conDicId = ""
	..s desc = $p(hisDesc,"||",1)
	..for  s conDicId = $o(^CKB.PDSS.ComContrastI("HisDesc",$$UPPER^SSUTIL4(desc),conDicId))  Q:conDicId=""  d
	...s listData = $g(^CKB.PDSS.ComContrastD(conDicId))
	...s drug = $lg(listData,3)
	...s drugCode = $lg(listData,2)
	...s hisCode = $lg(listData,4)
	...s hisHosp = $lg(listData,7)
	...q:hosp'=hisHosp
	...s drugId=..IsConsDrugModify(dictionId,drug,drugCode)
	...b:drug="复方盐酸阿替卡因注射液1.7ml(马鞍山丰原制药有限公司)" ;12
	...q:drugId=0
	...;s drugId=$list(modifyFlag)
	...s FormType=##class(web.DHCCKBDrugVO).GetFormType(drugId) //剂型
	...s DrugGenerName=$replace(##class(web.DHCCKBDrugVO).GetDrugGenerName(drugId),",","，")   //通用名
	...s GenerName=$replace(##class(web.DHCCKBDrugVO).GetGenerName(drugId),",","，")  //化学名
	...set ^CacheTemp(repid,ind)=$lb(drug,drugCode,desc,hisCode,DrugGenerName,GenerName,FormType)
	...set ind=ind+1	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
