/// Description:	药品信息匹配及展现类
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
Class web.DHCCKBMatchSearch Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取药品列表信息
/// Creator:		QuNianpeng
/// CreateDate:		2019-03-12
/// Input:			代码^描述
/// return:			药品信息串
/// other:			
/// w ##class(web.DHCCKBMatchSearch).QueryDrugList("20","1","^^^13929")
ClassMethod QueryDrugList(rows As %String = 20, page As %String = 1, params As %String) As %String
{
		
	n (rows,page,params)	
	q:params="" ""
	s end = page*rows
	s start=(page-1)*rows+1
	s queryCode=$p(params,"^",1)
	s queryCode=$zcvt(queryCode,"U")
	s queryDesc=$p(params,"^",2)
	s queryDesc=$zcvt(queryDesc,"U")	
	s pid=$p(params,"^",3)		
	s LgUserID=$p(params,"^",4)
	
	s:pid="" pid=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,""),-1)
	q:(pid="") "" 	

	i +pid=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) // 输出json结尾符
	q:(+pid=0) "" 
	
	s h=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,""),-1) 
	s count=0
	s listTitle="num[next]drugCode[next]drugName[next]generName[next]factory[next]specification[next]DrugForm[next]drugDataType[next]hisPZWH[next]hisDXDW[next]matchFlag[next]libDrugCode[next]libDrugName[next]libDrugParef[next]libDrugDataType[next]DrugForm[next]itmSpecificationype[next]specification[next]iDrugForm[next]libFactory[next]libGenalName[next]libEqFactorProp[next]libPackaging[next]libApproval[next]dicDrugID"   	
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h)	// 输出json前缀串
	s index=""	f  s index=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index))
	.s generName=$p($g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index)),"[next]",4)
	.s pinDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(generName))
	.//q:(queryCode'="")&&($zcvt(dicCode,"U")'[queryCode)
	.q:(queryDesc'="")&&(($zcvt(generName,"U")'[queryDesc)&(pinDesc'[queryDesc))
	.q:index=1
	.s count = count+1
	.q:(count<start)||(count>end)
	.I count=start d
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData,"[next]")
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData,"[next]")
	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	
	//d ..killTmpGlobal(pid)
	q ""
}

/// Description:	获取Pid
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
/// Input:			
/// return:			
/// other:			
/// w ##class(web.DHCCKBMatchSearch).QueryDrugList(20,1,"")
/// w ##class(web.DHCADVFormExport)importForm(1)
ClassMethod MatchDataPid()
{
	k ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser")	
	s pid=##Class(web.DHCCKBCommonUtil).NewPid()
	w pid
	q ""
}

/// Description:	临时存储数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
/// Input:			pid,行,数据
/// return:			
/// other:			
/// w ##class(web.DHCCKBMatchSearch).MatchTmpData(20,1,"")
ClassMethod MatchTmpData(pid, mListData, LgUserID) As %String
{
	n (pid,mListData,LgUserID)
	
	i $CLASSNAME(mListData)="%CSP.CharacterStream" d
	.d ..InsTmpGlobalStream(pid, mListData,LgUserID)
	e  d
	.d ..InsTmpGlobalString(pid, mListData,LgUserID)
	q 0
}

/// Descript: 临时存储数据[流]
/// W ##Class(web.DHCCKBBaseImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobalStream(pid As %String, mListData, LgUserID) As %String
{
	n (pid, mListData,LgUserID)
	d mListData.Rewind()
	while (mListData.AtEnd = 0) {
		s IOStrLen=5000
		s listData=mListData.Read(.IOStrLen)
		f i=1:1:$L(listData,$C(2)) d
	    .s mData=$p(listData,$C(2),i)
		.i mData[$C(1) d
		..s row=$I(^TMP("Num",pid))
		..s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,row)=$REPLACE($p(mData,$C(2)),$C(1),"")
		.e  d
		..s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,row)_""_$p(mData,$C(2))
	}
	q ""
}

/// Descript: 临时存储数据[字符串]
/// W ##Class(web.DHCCKBBaseImport).InsTmpGlobal("1","")
ClassMethod InsTmpGlobalString(pid As %String, mListData, LgUserID) As %String
{
	n (pid, mListData,LgUserID)
	F i=1:1:$L(mListData,$C(2)) D
	.s listData=$p(mListData,$C(2),i)
	.s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,$I(^TMP("Num",pid)))=$REPLACE(listData,$C(1),"")
	.
	Q ""
}

/// Description:	匹配数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-15
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			
/// w ##class(web.DHCCKBMatchSearch).MatchSearch(12415437,"")
ClassMethod MatchSearch(pid, searchModel = "0") As %String
{
	n (pid,searchModel)
	s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,""))
	s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row))_"[next]"_"标注"_"[next]"_"知识库药品代码"_"[next]"_"知识库描述"_"[next]"_"知识库字典ID"_"[next]"_"知识库字典代码"
	//s row=""
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)) q:row=""  d
	.q:row=1
	.s str=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)
	.//s num=$p(str,"[next]",1)			//序号
	.s drugName=$p(str,"[next]",3)		//药品名称
	.s generDesc=$p(str,"[next]",4)		//带剂型通用名
	.q:generDesc=""
	.s factory=$p(str,"[next]",5)		//厂商	
	.s factory=$tr(factory,"（","(")
	.s factory=$tr(factory,"）",")")
	.s type=$p(str,"[next]",6)	// 字典类型
	.s existFlag=0,passFlag=0
	.s libDicID=""
	.//匹配药品名+ 厂家
	.i $d(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(generDesc)))  d			// 匹配名和知识库药品名比较
	..s existFlag=1	
	..s tmpLibDicID=""
	..s DrugData=##class(web.DHCCKBCommon).GetDrugData() //药品
	..s ZHDrugData=##class(web.DHCCKBCommon).GetChineseDrugData() //中成药
	..s ChineseHMData=##class(web.DHCCKBCommon).GetChineseHMData()	// 中药饮片
	..f  s tmpLibDicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(generDesc),tmpLibDicID))  q:(tmpLibDicID="")||(passFlag=1)  d
	...s libData=$lg($g(^CT.CKB.PDSS.CommonDictionD(tmpLibDicID)),4) //药品字典ID
	...q:(libData'=DrugData)&&(libData'=ZHDrugData)&&(libData'=ChineseHMData)
	...//s passFlag=(..CheckFactory(tmpLibDicID,factory,drugName)||searchModel) // qnp 2021/1/13 ？？ 为甚入参多了一个参数？？
	...///s passFlag=(..CheckFactory(tmpLibDicID,factory))	
	...i type="ChineseHerbalMedicineData" s passFlag=1 // 饮片先不匹配厂家
	...e  s passFlag=..CheckFactoryNew(tmpLibDicID,factory)
	...;s passFlag=(passFlag&&..isContainHisEquunit(tmpLibDicID, drugName))  //sufan 2020-11-12  增加等效单位的判断
	...i passFlag=1 s libDicID=tmpLibDicID
	..
	..i passFlag=1 d
	...s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(libDicID)		//判断是否有规则  add sufan 2020-09-25 没有规则的不匹配
	...//Q:ruleFlag'=1
	...s libDrugCode=""
	...s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2) //药品code
	...s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3) //药品描述
	...s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	...s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	...s:ruleFlag=0 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"匹配但无规则"_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode
	...s:ruleFlag=1 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_libDrugCode_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode
	.q:passFlag=1
	.
	.//匹配通用名
	.s attrCodeDr=##class(web.DHCCKBCommon).GetGeneralFromProp() //带剂型通用名属性
	.s attrCodeDrStr=..GetLinkDr(attrCodeDr) //中药、西药的带剂型通用名属性
	.
	.f i=1:1:$l(attrCodeDrStr,"^") q:passFlag=1  d
	..s attrCodeDr=$p(attrCodeDrStr,"^",i)
	..s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",attrCodeDr,linkID))  q:(linkID="")||(passFlag=1)  d
	...s existFlag=0
	...s genName=""
	...s genNameDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4) //kml
	...i +genNameDr'=0 s genName=$lg($g(^CT.CKB.PDSS.CommonDictionD(genNameDr)),3) //kml
	...i generDesc=genName  d
	....s existFlag=1
	....s libDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2) //药品id
	...i existFlag'=1 d
	....s tmpGenName=$tr(genName,"注射液","")
	....s tmpGenName=$tr(genName,"注射用","")
	....s tmpGenerDesc=$tr(generDesc,"针","")	
	....i tmpGenerDesc=tmpGenName d
	.....s existFlag=1
	.....s libDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2) //药品id
	...
	...i existFlag=1 d
	....//s passFlag=(..CheckFactory(libDicID,factory)||searchModel)
	....//s passFlag=(..CheckFactory(libDicID,factory))
	....//s passFlag=(..CheckFactoryNew(libDicID,factory))
	...i type="ChineseHerbalMedicineData" s passFlag=1 // 饮片先不匹配厂家
	...e  s passFlag=..CheckFactoryNew(tmpLibDicID,factory)
	....;s passFlag=(passFlag&&..isContainHisEquunit(libDicID, drugName))  //sufan 2020-11-12  增加等效单位的判断
	....i passFlag=1 d
	.....s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(libDicID)		//判断是否有规则  add sufan 2020-09-25 没有规则的不匹配
	.....//Q:ruleFlag'=1
	.....s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2) //药品code
	.....s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3) //药品描述
	.....s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	.....s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	.....s:ruleFlag=0 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"匹配但无规则"_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode
	.....s:ruleFlag=1 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_libDrugCode_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode
	....
	...
	..
	.q:passFlag=1
	.//匹配商品名 + 厂家
	.s attrCodeDr=##class(web.DHCCKBCommon).GetProNameProp() //kml
	.s attrCodeDrStr=..GetLinkDr(attrCodeDr)
	.
	.f i=1:1:$l(attrCodeDrStr,"^") q:passFlag=1  d
	..s attrCodeDr=$p(attrCodeDrStr,"^",i)
	..s linkID=""  f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",attrCodeDr,linkID))  q:(linkID="")||(passFlag=1)  d
	...s existFlag=0
	...s genName=""
	...s genNameDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4) //kml
	...i +genNameDr'=0 s genName=$lg($g(^CT.CKB.PDSS.CommonDictionD(genNameDr)),3) //kml
	...s tmpGenName=genName
	...s tmpGenerDesc=generDesc
	...i tmpGenName=tmpGenerDesc  d
	....s existFlag=1
	....s libDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2)
	...q:existFlag=1
	...//s tmpGenName=$tr(genName,"注射液","")
	...//s tmpGenName=$tr(genName,"注射用","")
	...//s tmpGenerDesc=$tr(generDesc,"针","")	
	...//i tmpGenName=tmpGenerDesc  d
	...//.s existFlag=1
	...//.s libDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),2)
	...
	..i existFlag=1 d
	...s passFlag=..CheckFactoryNew(libDicID,factory)
	...//s passFlag=(..CheckFactory(libDicID,factory)||searchModel)
	...;s passFlag=(passFlag&&..isContainHisEquunit(libDicID, drugName))  //sufan 2020-11-12  增加等效单位的判断
	...i passFlag=1 d
 	....s ruleFlag=##class(web.DHCCKBCommon).IsExistRule(libDicID)		//判断是否有规则  add sufan 2020-09-25 没有规则的不匹配
 	....b:drugName="乳果糖口服溶液(杜密克)(200ml:133.4g/瓶)" //555
	....//Q:ruleFlag'=1
	....s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2) //药品code
	....s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3) //药品描述
	....s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	....s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	....s:ruleFlag=0 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"匹配但无规则"_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode
	....s:ruleFlag=1 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_libDrugCode_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode

	...
	..
	.
	.i (passFlag=0) s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"
	q pid
}

/// Description:	匹配数据
/// Creator:		Sunhuiyong
/// CreateDate:		2020-12-4
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchNew("7404120","74532^44")
ClassMethod MatchSearchNew(pid, searchModel) As %String
{
	n (pid,searchModel)
	;s ^shy("test")=$lb(pid,searchModel)
	k ^Tmp("web.DHCCKBMatchSearch","MatchSearchNew")
	s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,""))
	s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row))_"[next]"_"标注"_"[next]"_"知识库药品代码"_"[next]"_"知识库描述"_"[next]"_"知识库字典ID"_"[next]"_"知识库字典代码"
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)) q:row=""  d
	.q:row=1
	.s str=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)
	.//s num=$p(str,"[next]",1)			//序号
	.s drugName=$p(str,"[next]",3)		//药品名称
	.s generDesc=$p(str,"[next]",4)		//带剂型通用名
	.q:generDesc=""
	.s factory=$p(str,"[next]",5)		//厂商
	.s factory=$tr(factory,"（","(")
	.s factory=$tr(factory,"）",")")
	.s specification=$p(str,"[next]",6) //规格
	.s DrugForm=$p(str,"[next]",7)      //剂型
	.;k ^Tmp("web.DHCCKBMatchSearch","MatchSearchNew")
	.// w ##class(web.DHCCKBCommon).GetDrugForm()  剂型
	.// w ##class(web.DHCCKBCommon).GetGenerNameProp() 通用名
	.// w ##class(web.DHCCKBCommon).GetMedDrugNameProp() 西药名
	.// w ##class(web.DHCCKBCommon).GetChineseDrugNameProp() 中药名
	.// w ##class(web.DHCCKBCommon).GetProNameProp() 商品名
	.// w ##class(web.DHCCKBCommon).GetDrugSpec() 规格
	.// w ##class(web.DHCCKBCommon).GetDrugManf() 厂家
	.// w ##class(web.DHCCKBCommon).GetDicIdByDesc()   //描述获取ID
	.s drugName=##class(web.DHCCKBCommon).GetDicIdByDesc(drugName)  //妥布霉素地塞米松滴眼膏
	.s generDesc=##class(web.DHCCKBCommon).GetDicIdByDesc(generDesc)
	.s factory=##class(web.DHCCKBCommon).GetDicIdByDesc(factory)
	.s DrugForm=##class(web.DHCCKBCommon).GetDicIdByDesc(DrugForm)
	.s length=$l(searchModel,"^")
	.s SelectCount=length
	.s RealCount=0
	.f i=1:1:length  d
	..s ret=""
	..s PropId=$p(searchModel,"^",i)
	..s:PropId="81224" ret=+##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(PropId,drugName) //西药名
	..s:PropId="81842" ret=+##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(PropId,drugName)  //中药名
	..s:PropId="74532" ret=+##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(PropId,generDesc) //通用名
	..s:PropId="44" ret=+##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(PropId,factory)      //厂家
	..s:PropId="40" ret=+##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(PropId,DrugForm)     //剂型
	..s:PropId="77980" ret=+##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(PropId,specification)     //规格
	..q:ret=0
	..s:ret'="" RealCount=RealCount+1
	..s retLength=$l(ret,"^")
	..q:+retLength=0
	..f j=1:1:retLength  d
	...s itmVal = $p(ret,"^",j)
	...q:itmVal=""
	...s:$d(^Tmp("web.DHCCKBMatchSearch","MatchSearchNew",itmVal)) ^Tmp("web.DHCCKBMatchSearch","MatchSearchNew",itmVal)=^Tmp("web.DHCCKBMatchSearch","MatchSearchNew",itmVal)+1
	...s:'$d(^Tmp("web.DHCCKBMatchSearch","MatchSearchNew",itmVal)) ^Tmp("web.DHCCKBMatchSearch","MatchSearchNew",itmVal)=1
	.//判断输出
	.s DicID=""
	.s index="" 
	.f  s index=$o(^Tmp("web.DHCCKBMatchSearch","MatchSearchNew",index))  q:(DicID'="")||(index="")  d
	..s:+^Tmp("web.DHCCKBMatchSearch","MatchSearchNew",index)=+$g(SelectCount) DicID=index
	..s libDicID=DicID
	..i (RealCount=SelectCount)&&(libDicID'="")  d
	...s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2) //药品code
	...s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3) //药品描述
	...s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	...s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_libDrugCode_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"
	.s:'$d(^Tmp("web.DHCCKBMatchSearch","MatchSearchNew")) ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"
	.k ^Tmp("web.DHCCKBMatchSearch","MatchSearchNew")
	q pid
}

/// 匹配厂家
/// w ##class(web.DHCCKBMatchSearch).CheckFactory(3002,"安斯泰来制药(中国)有限公司")
ClassMethod CheckFactory(libDicID, factory) As %String
{
	n (libDicID,factory)
	q:libDicID="" 0
	s passFlag=0
	;s tmpAttrCode="factory"
	s tmpAttrCodeDr=##class(web.DHCCKBCommon).GetDrugManf() ;81835 ; //kml 2020-06-09 生产厂家属性
	s tmpAttrCodeDrStr=..GetLinkDr(tmpAttrCodeDr)
	f i=1:1:$l(tmpAttrCodeDrStr,"^") q:passFlag=1  d
	.s tmpAttrCodeDr=$p(tmpAttrCodeDrStr,"^",i)
	.s tmpLinkID=""  f  s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",libDicID,tmpAttrCodeDr,tmpLinkID))  q:(tmpLinkID="")||(passFlag=1)  d
	..s libFactory=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),5) //"获取厂家" 
	..s factoryDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4) //kml
	..i +factoryDr'=0 s libFactory=$lg($g(^CT.CKB.PDSS.CommonDictionD(factoryDr)),3) //kml
	..s libFactory=$tr(libFactory," ","")
	..s libFactory=$tr(libFactory,"(","")
	..s libFactory=$tr(libFactory,")","")
	..s libFactory=$tr(libFactory,"（","")
	..s libFactory=$tr(libFactory,"）","")
	..s factory=$tr(factory," ","")
	..s factory=$tr(factory,"(","")
	..s factory=$tr(factory,")","")
	..s factory=$tr(factory,"（","")
	..s factory=$tr(factory,"）","")
	..i (libFactory[$e(factory,1,4))||(factory[$e(libFactory,1,4)) s passFlag=1

	q passFlag
}

/// Description:	判断知识库的等效单位是否包含his，his的先同步到临时global
/// Creator:		sufan
/// CreateDate:		2020-11-06
/// Input:			知识库药品id,his 药品名称
/// return:			1:存在，0不存在
ClassMethod isContainHisEquunit(libDicID, drugName)
{
	n (libDicID,drugName)
	s libequunitList = ##class(web.DHCCKBDrugVO).GetEquunit(libDicID)
	s hisequunitList = ^TMP("DHCCKB","AutoCompare",drugName) 
	s flag=0
	s len = $l(hisequunitList,"^")
	for i=1:1:len  Q:flag=1  d
	.s equunit = $p(hisequunitList,"^",i)
	.Q:libequunitList'[equunit
	.s flag=1
	Q flag
}

/// Description:	打印数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-05-24
/// Input:			进程号
/// return:			药品信息串
/// other:			
/// w ##class(web.DHCCKBMatchSearch).ExportMatchData(184)
ClassMethod ExportMatchData(pid As %String, LgUserID) As %String
{
		
	n (pid,LgUserID)	

	s ret=""
	i pid="" s pid=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,""),-1)
	q:pid="" ret
	s index=""	f  s index=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index))
	.i ret="" s ret=listData
	.e  s ret=ret_"@@"_listData

	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBMatchSearch","ExportMatchDataNew","6261949")
/// @param: pid 进程号
Query ExportMatchDataNew(pid, LgUserID) As websys.Query(ROWSPEC = "seqNo:%String:序号,drugCode:%String:HIS药品code,drugName:%String:HIS药品名,factory:%String:HIS厂家,genName:%String:HIS通用名,itmSpecificationype:%String:HIS规格,DrugForm:%String:HIS剂型,drugDataType:%String:数据类型,hisPZWH:%String:HIS批准文号,hisDXDW:%String:HIS等效单位,mark:%String:标注,libDrugCode:%String:知识库药品代码,libDrugName:%String:知识库药品名称,specification:%String:知识库规格,iDrugForm:%String:知识库剂型,libFactory:%String:知识库厂家,libGenalName:%String:知识库通用名,libEqFactorProp:%String:知识库等效单位,libPackaging:%String:知识库包装,libApproval:%String:知识库批准文号")
{
}

ClassMethod ExportMatchDataNewExecute(ByRef qHandle As %Binary, pid, LgUserID) As %Status
{
	n (qHandle,pid,LgUserID)

	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=0	
	set ret=""
	if pid="" set pid=$order(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,""),-1)
	quit:pid="" $$$OK
	
	set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index)) quit:index=""  do
	.//quit:index=1
	.set listData=$get(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index))
	.set seqNo=$p(listData,"[next]",1)
	.set drugCode=$p(listData,"[next]",2)
	.set drugName=$p(listData,"[next]",3)
	.set genName=$p(listData,"[next]",4)
	.set factory=$p(listData,"[next]",5)
	.set itmSpecificationype=$p(listData,"[next]",6)
	.set DrugForm=$p(listData,"[next]",7)
	
	.set drugDataType=$p(listData,"[next]",8)
	.set hisPZWH=$p(listData,"[next]",9)
	.set hisDXDW=$p(listData,"[next]",10)
	.set mark=$p(listData,"[next]",11)
	.set mark=$c(28)_mark  //$c(28)文件分隔符 肉眼不可见，为了在Excel中数据开头是0的可以显示
	.set libDrugCode=$p(listData,"[next]",12)
	.set libDrugName=$p(listData,"[next]",13)
	.set specification=$p(listData,"[next]",18)
	.set iDrugForm=$p(listData,"[next]",19)
	.set libFactory=$p(listData,"[next]",20)
	.set libGenalName=$p(listData,"[next]",21)
	.set libEqFactorProp=$p(listData,"[next]",22)
	.set libPackaging=$p(listData,"[next]",23)
	.set libApproval=$p(listData,"[next]",24)
	.set dicDrugID=$p(listData,"[next]",25)
	.set tmpData=$lb(seqNo,drugCode,drugName,factory,genName,itmSpecificationype,DrugForm,drugDataType,hisPZWH,hisDXDW,mark,libDrugCode,libDrugName,specification,iDrugForm,libFactory,libGenalName,libEqFactorProp,libPackaging,libApproval,dicDrugID)
	.set ^CacheTemp(repid,ind)=tmpData //$lb(SubMenuId,$lg(^websys.MenuD(SubMenuId),1),$lg(^websys.MenuD(SubMenuId),4))
	.set ind=ind+1	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	
	k ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid)
	//k ^TMP("DHCCKB","web.DHCCKBMatchSearch","QueryDrugList",pid)
}

ClassMethod ContrastMatchData(loginInfo = "", clientIP = "", LgUserID = "") As %String
{
	n (loginInfo,clientIP,LgUserID)
	s ret=-1,n=0
	s pid=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,""),-1)
	q:pid="" ret
	//listTitle="num[next]generKey[next]dicDesc[next]factory[next]matchFlag"
	s index=""	f  s index=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index)) q:index=""  d
	.q:index=1
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",LgUserID,pid,index))
	.s HisCode=$p(listData,"[next]",2) //code
	.s HisDesc=$p(listData,"[next]",3) //药品名称
	.s libDicCode=$p(listData,"[next]",7) //知识库code
	.q:(libDicCode="")||(libDicCode="未匹配上")
	.s libDicDesc=$p(listData,"[next]",9) //知识库药品描述
	.s libDicParf=$p(listData,"[next]",10) //药品字典
	.s ContrastList=libDicCode_"^"_libDicDesc_"^"_HisCode_"^"_HisDesc_"^"_libDicParf
	.s n=n+1
	.s ^tempkml(n)=ContrastList
	.d ##class(web.DHCCKBComContrast).SaveContrastData(ContrastList,loginInfo,clientIP)
	q 0
}

// Creator	kemaolin

// Date:		2020-06-30

// Description:	获取元素和其关联的link节点

/// w ##class(web.DHCCKBMatchSearch).GetLinkDr(74532)
ClassMethod GetLinkDr(id)
{
	q:id="" ""
	s linkIDStr=id
	q:'$d(^CT.CKB.PDSS.CommonDictionI("Link",id)) linkIDStr
	s rowId="" f  s rowId = $o(^CT.CKB.PDSS.CommonDictionI("Link",id,rowId)) q:rowId=""  d
	.s $p(linkIDStr,"^",$l(linkIDStr,"^")+1)=rowId
	q linkIDStr
}

/// Description:	匹配厂家(使用厂家名称和厂家别名比较)
/// Creator:		QuNianpeng
/// CreateDate:		2021/1/14
/// Input:			知识库药品名称,厂家名称
/// return:			1匹配上 0 未匹配上
/// w ##class(web.DHCCKBMatchSearch).CheckFactoryNew(2877,"AstraZenecaUKLimited")
ClassMethod CheckFactoryNew(libDicID, factory) As %String
{
	n (libDicID,factory)
	q:libDicID="" 0
	s passFlag=0
	s tmpAttrCodeDr=##class(web.DHCCKBCommon).GetDrugManf() // 生产厂家属性	

	s tmpAttrCodeDrStr=..GetLinkDr(tmpAttrCodeDr)
	f i=1:1:$l(tmpAttrCodeDrStr,"^") q:passFlag=1  d
	.s tmpAttrCodeDr=$p(tmpAttrCodeDrStr,"^",i)
	.s tmpLinkID=""  f  s tmpLinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",libDicID,tmpAttrCodeDr,tmpLinkID))  q:(tmpLinkID="")||(passFlag=1)  d
	..//s libFactory=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),5) //"获取厂家" 
	..s libFactoryList = ""
	..s factoryDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(tmpLinkID)),4) // 厂家都是通过属性关联的形式维护
	..s libFactoryOtherName = ""	// 厂家别名
	..s libFactory = ""
	..i +factoryDr'=0 s libFactoryOtherName=##class(web.DHCCKBCommon).GetDicSecondName(factoryDr)
	..i +factoryDr'=0 s libFactory=$lg($g(^CT.CKB.PDSS.CommonDictionD(factoryDr)),3) //kml
	..q:libFactory=""
	..s libFactory=$tr(libFactory," ","")
	..s libFactory=$tr(libFactory,"(","")
	..s libFactory=$tr(libFactory,")","")
	..s libFactory=$tr(libFactory,"（","")
	..s libFactory=$tr(libFactory,"）","")
	..i libFactory'="" s $list(libFactoryList,*+1)=libFactory
	..i libFactoryOtherName'="" s libFactoryList=##Class(web.DHCCKBCommonUtil).GetUnionList(libFactoryList,libFactoryOtherName)	
	..s factory=$tr(factory," ","")
	..s factory=$tr(factory,"(","")
	..s factory=$tr(factory,")","")
	..s factory=$tr(factory,"（","")
	..s factory=$tr(factory,"）","")
	..f k=1:1:$listlength(libFactoryList) q:passFlag=1   d
	...s tmpLibFac=$list(libFactoryList,k)
	...i (tmpLibFac[$e(factory,1,4))||(factory[$e(tmpLibFac,1,4)) s passFlag=1

	..//i $listfind(libFactoryList,factory)>0 s passFlag=1
	
	q passFlag
}

/// Description:	匹配数据-遍历药品列表
/// Creator:		Sunhuiyong
/// CreateDate:		2021-3-9
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchByDataList("12534721","74532^44")
ClassMethod MatchSearchByDataListJob(pid, searchModel, lgUserID) As %String
{
	n (pid,searchModel,lgUserID)
	
	job ##class(web.DHCCKBMatchSearch).MatchSearchByDataList(pid,searchModel,lgUserID)
	
	q pid
}

/// Description:	匹配数据-遍历药品列表
/// Creator:		Sunhuiyong
/// CreateDate:		2021-3-9
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchByDataList("12534721","74532^44")
ClassMethod MatchSearchByDataListJobNew(pid, searchModel, searchModelTwice, lgUserID) As %String
{
	n (pid,searchModel,searchModelTwice,lgUserID)
	
	job ##class(web.DHCCKBMatchSearch).MatchSearchByDataListNew(pid,searchModel,searchModelTwice,lgUserID)
	
	q pid
}

/// Description:	匹配数据-通用名->属性
/// Creator:		Sunhuiyong
/// CreateDate:		2020-03-09
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchNew("7404120","74532^44")
ClassMethod MatchSearchNewB(pid, searchModel, searchImport) As %String
{
	n (pid,searchModel,searchImport)
	s ^shy("MatchSearchNewB")=$lb(pid,searchModel,searchImport)
	b ;shy
	s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,""))
	s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row))_"[next]"_"标注"_"[next]"_"知识库药品代码"_"[next]"_"知识库描述"_"[next]"_"知识库字典ID"_"[next]"_"知识库字典代码"
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)) q:row=""  d
	.q:row=1
	.s str=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)
	.//s num=$p(str,"[next]",1)			//序号
	.s drugName=$p(str,"[next]",3)		//药品名称
	.s generDesc=$p(str,"[next]",4)		//带剂型通用名
	.q:generDesc=""
	.s factory=$p(str,"[next]",5)		//厂商
	.s factory=$tr(factory,"（","(")
	.s factory=$tr(factory,"）",")")
	.s specification=$p(str,"[next]",6) //规格
	.s DrugForm=$p(str,"[next]",7)      //剂型
	.s drugName=##class(web.DHCCKBCommon).GetDicIdByDesc(drugName)  //妥布霉素地塞米松滴眼膏
	.s generDesc=##class(web.DHCCKBCommon).GetDicIdByDesc(generDesc)
	.;s DrugForm=##class(web.DHCCKBCommon).GetDicIdByDesc(DrugForm)
	.b ;shyerr
	.s ret=""
	.s ret=##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr("74532",generDesc) //通用名 s:PropId="74532"
	.s:ret="" ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"
	.q:ret=""
	.b ;shy2
	.s length=$l(ret,"^")
	.f i=1:1:length  d
	..s DicDr=$p(ret,"^",i)
	..s DrugProName="" //商品名   
	..s DrugManf=""    //生产企业
	..s DrugFormDic=""    //剂型
	..s GenalName=""   //通用名
	..s passFlag1=1    //厂家 - 通过
	..s passFlag2=1    //商品名 - 通过
	..s passFlag3=1    //剂型 - 通过
	..s passFlag4=1    //通用名 - 通过
	..s DLARowID="" f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",DicDr,DLARowID))  q:DLARowID=""  d
	...s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),3)
	...s:AttrCode=43 DrugProName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)    //商品名
	...s:AttrCode=44 DrugManf=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)       //生产企业
	...s:AttrCode=40 DrugFormDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)       //剂型
	...s:AttrCode=74532 GenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)    //通用名
	..;--判断厂家
	..i (searchModel["44")&&(..CheckFactoryNew(DicDr,factory)) d
	...s passFlag1=1
	..e  d
	...s passFlag1=0
	..;--判断剂型
	..i (searchModel["40")&&(DrugFormDic=DrugForm) d
	...s passFlag3=1
	..e  d
	...s passFlag3=0
	..;--判断商品名
	..i (searchModel["43")&&(DrugProName=drugName) d
	...s passFlag2=1
	..e  d
	...s passFlag2=0
	..q:(passFlag1=1)&&(passFlag3=1)&&(passFlag2=1)
	.;--统一规避没选匹配项的情况--
  	.s:searchModel'["40" passFlag3=1
    .s:searchModel'["44" passFlag1=1
    .s:searchModel'["43" passFlag2=1
    .i (passFlag1=1)&&(passFlag3=1)&&(passFlag2=1) d 
	..s libDicID=DicDr
	..i libDicID'=""  d
	...s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2) //药品code
	...s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3) //药品描述
	...s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	...s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_libDrugCode_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"
	.e  d
	..s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"
	q pid
}

/// Description:	匹配数据-商品名->属性
/// Creator:		Sunhuiyong
/// CreateDate:		2020-03-09
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchNew("7404120","74532^44")
ClassMethod MatchSearchNewA(pid, searchModel, searchImport) As %String
{
	n (pid,searchModel,searchImport)
	k ^Tmp("web.DHCCKBMatchSearch","MatchSearchNew")
	s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,""))
	s proNamePropCom=##class(web.DHCCKBCommon).GetDicIdByCode("DrugProNameData")      //商品名字典-107
	s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row))_"[next]"_"标注"_"[next]"_"知识库药品代码"_"[next]"_"知识库描述"_"[next]"_"知识库字典ID"_"[next]"_"知识库字典代码"
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)) q:row=""  d
	.q:row=1
	.s str=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)
	.//s num=$p(str,"[next]",1)			//序号
	.s drugName=$p(str,"[next]",3)		//药品名称
	.s generDesc=$p(str,"[next]",4)		//带剂型通用名
	.q:generDesc=""
	.s factory=$p(str,"[next]",5)		//厂商
	.s factory=$tr(factory,"（","(")
	.s factory=$tr(factory,"）",")")
	.s specification=$p(str,"[next]",6) //规格
	.s DrugForm=$p(str,"[next]",7)      //剂型
	.s drugName=##class(web.DHCCKBCommon).GetDicIdByDesc(drugName)  //妥布霉素地塞米松滴眼膏
	.;s generDesc=##class(web.DHCCKBCommon).GetDicIdByDesc(generDesc)
	.;s factory=##class(web.DHCCKBCommon).GetDicIdByDesc(factory)
	.s DrugForm=##class(web.DHCCKBCommon).GetDicIdByDesc(DrugForm)
	.s ret=""
	.s ret=##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(proNamePropCom,drugName) //商品名
	.s:ret="" ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"
	.q:ret=""
	.s length=$l(ret,"^")
	.f i=1:1:length  d
	..s DicDr=$p(ret,"^",i)
	..s DrugProName="" //商品名   
	..s DrugManf=""    //生产企业
	..s DrugFormDic=""    //剂型
	..s GenalName=""   //通用名
	..s passFlag1=1    //厂家 - 通过
	..s passFlag2=1    //商品名 - 通过
	..s passFlag3=1    //剂型 - 通过
	..s passFlag4=1    //通用名 - 通过
	..s DLARowID="" f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",DicDr,DLARowID))  q:DLARowID=""  d
	...s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),3)
	...s:AttrCode=43 DrugProName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),"^",3)    //商品名
	...s:AttrCode=44 DrugManf=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),"^",3)       //生产企业
	...s:AttrCode=40 DrugFormDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),"^",3)       //剂型
	...s:AttrCode=74532 GenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),"^",3)    //通用名
	..;--判断厂家--
	..i (searchModel["44")&&(..CheckFactoryNew(DicDr,factory)) d
	...s passFlag1=1
	..e  d
	...s passFlag1=0 
	..;--判断剂型
	..i (searchModel["40")&&(DrugFormDic=DrugForm) d
	...s passFlag3=1
	..e  d
	...s passFlag3=0
	..;--判断通用名
	..i (searchModel["74532")&&(GenalName=generDesc) d
	...s passFlag4=1
	..e  d
	...s passFlag4=0
    ..q:(passFlag1=1)&&(passFlag3=1)&&(passFlag4=1)
	.;--统一规避没选匹配项的情况--
  	.s:searchModel'["40" passFlag3=1
    .s:searchModel'["44" passFlag1=1
    .s:searchModel'["74532" passFlag4=1
    .i (passFlag1=1)&&(passFlag3=1)&&(passFlag4=1) d 
	..s libDicID=DicDr
	..i libDicID'=""  d
	...s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2) //药品code
	...s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3) //药品描述
	...s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	...s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	...s DrugForm=""
	...s itmSpecificationype=""
	...s DLA="" f  s DLA=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",libDicID,DLA))  q:DLA=""  d
	....s:AttrCode=40 DrugForm=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //剂型
	....s:AttrCode=77980 itmSpecificationype=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)    //规格
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_libDrugCode_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode_"[next]"_DrugForm_"[next]"_itmSpecificationype
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	.e  d
	..s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearch",pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	q pid
}

/// Description:	匹配数据-商品名/通用名->属性
/// Creator:		Sunhuiyong
/// CreateDate:		2020-03-09
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchNewData("12627650","44","74532")
ClassMethod MatchSearchNewData(pid, searchModel, searchImport) As %String
{
	n (pid,searchModel,searchImport)
	s result =""
	s proNamePropCom=##class(web.DHCCKBCommon).GetDicIdByCode("DrugProNameData")      //商品名字典-107
	s generalFromPropCom=##class(web.DHCCKBCommon).GetGeneralFromProp()      		  //通用名(带剂型)-74532
	i searchModel=""   d
	.s result=..MatchSearchNew(pid,searchImport)
	i (searchImport=proNamePropCom)&&(searchModel'="")  d       //商品名
	.s result=..MatchSearchNewA(pid,searchModel,searchImport)
	i (searchImport=generalFromPropCom)&&(searchModel'="")  d    //通用名
	.s result=..MatchSearchNewB(pid,searchModel,searchImport)
	q result
}

/// shy
/// d ##class(web.DHCCKBMatchSearch).getCKBColumn(0,"DefaultSee")
ClassMethod getCKBColumn(showitem = "", selectitem = "") As %String
{
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "["
    s obj=##class(web.DHCEMColumn).%New()
    s obj.title="序号"
    s obj.field="num"
    w jsonObj.ObjToJson(obj)
	w ","
    s obj.title="药品代码"
    s obj.field="drugCode"
    w jsonObj.ObjToJson(obj)
	w ","
    s obj.title="药品名称"
    s obj.field="drugName"
    w jsonObj.ObjToJson(obj)
	w ","
    s obj.title="知识库药品代码"
    s obj.field="libDrugCode"
    w jsonObj.ObjToJson(obj)
	w ","
    s obj.title="知识库药品名称"
    s obj.field="libDrugName"
    w jsonObj.ObjToJson(obj)
	w ","
	s obj.title="标注"
    s obj.field="matchFlag"
    w jsonObj.ObjToJson(obj)
	i showitem'="" d
	.s showLength=$l(showitem,"^")
	.f i=1:1:showLength  d
	..i $p(showitem,"^",i)=44  d
	...w ","
	...s obj.title="HIS厂家"
    ...s obj.field="factory"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="知识库厂家"
    ...s obj.field="libFactory"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(showitem,"^",i)=74532  d
    ...w ","
	...s obj.title="HIS带剂型通用名"
    ...s obj.field="generName"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="带剂型通用名"
    ...s obj.field="libGenalName"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(showitem,"^",i)=77980  d
    ...w ","
	...s obj.title="知识库规格"
    ...s obj.field="itmSpecificationype"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="HIS规格"
    ...s obj.field="specification"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(showitem,"^",i)=40  d
    ...w ","
	...s obj.title="知识库剂型"
    ...s obj.field="DrugForm"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="HIS剂型"
    ...s obj.field="iDrugForm"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(showitem,"^",i)=74531  d
    ...w ","
	...s obj.title="知识库等效单位"
    ...s obj.field="libEqFactorProp"
    ...w jsonObj.ObjToJson(obj)
     ...w ","
	...s obj.title="HIS等效单位"
    ...s obj.field="hisDXDW"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(showitem,"^",i)=78012  d
    ...w ","
	...s obj.title="知识库包装"
    ...s obj.field="libPackaging"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(showitem,"^",i)=78015  d
    ...w ","
	...s obj.title="知识库批准文号"
    ...s obj.field="libApproval"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="HIS批准文号"
    ...s obj.field="hisPZWH"
    ...w jsonObj.ObjToJson(obj)
	e  d
	.s selectLength=$l(selectitem,"^")
	.f i=1:1:selectLength  d
	..i $p(selectitem,"^",i)=44  d
	...w ","
	...s obj.title="HIS厂家"
    ...s obj.field="factory"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="知识库厂家"
    ...s obj.field="libFactory"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(selectitem,"^",i)=74532  d
    ...w ","
	...s obj.title="HIS带剂型通用名"
    ...s obj.field="generName"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="知识库带剂型通用名"
    ...s obj.field="libGenalName"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(selectitem,"^",i)=77980  d
    ...w ","
	...s obj.title="知识库规格"
    ...s obj.field="itmSpecificationype"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="HIS规格"
    ...s obj.field="specification"
    ...w jsonObj.ObjToJson(obj)
    ..i $p(selectitem,"^",i)=40  d
    ...w ","
	...s obj.title="知识库剂型"
    ...s obj.field="DrugForm"
    ...w jsonObj.ObjToJson(obj)
    ...w ","
	...s obj.title="HIS剂型"
    ...s obj.field="iDrugForm"
    ...w jsonObj.ObjToJson(obj)
	w "]"
    q ""
    //"[next]"_specification_"[next]"_DrugForm_"[next]"_hisFactory
}

/// Description:	匹配数据-遍历药品列表
/// Creator:		Sunhuiyong
/// CreateDate:		2021-3-9
/// Input:			pid
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchByDataList("12534721","74532^44")
ClassMethod MatchSearchByDataListJobDic(pid, searchModel, lgUserID) As %String
{
	n (pid,searchModel,lgUserID)
	
	job ##class(web.DHCCKBMatchSearch).MatchSearchByDataListDic(pid,searchModel,lgUserID)
	
	q pid
}

/// Description:	匹配数据-遍历药品列表
/// Creator:		Sunhuiyong
/// CreateDate:		2021-3-9
/// Input:			pid searchModel
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchByDataList("5860297","114554")
ClassMethod MatchSearchByDataListDic(pid, searchModel, lgUserID) As %String
{
	n (pid,searchModel,lgUserID)
	s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,""))
	s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row))_"[next]"_"标注"_"[next]"_"知识库药品代码"_"[next]"_"知识库描述"_"[next]"_"知识库字典ID"_"[next]"_"知识库字典代码"
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)) q:row=""  d
	.q:row=1
	.s str=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)
	.s iCode=$p(str,"[next]",2)			//代码
	.s iDesc=$p(str,"[next]",3)		    //名称
	.q:iDesc=""
	.s id="110^111"             
	.s Diclength=$l(id,"^")
	.s DicDr=""
	.s passFlag1=0    //- 通过
	.s passFlag2=0    //- 通过
	.f i=1:1:Diclength  q:(passFlag1=1)&&(passFlag2=1)  d
	..s DataId=$p(id,"^",i)
	..s dicID="" f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DataId,dicID))   q:(dicID="")||((passFlag1=1)&&(passFlag2=1))  d   
	...s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	...s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	...;--判断Code
	...i dicCode=iCode  d
	....s passFlag1=1
	...e  d
	....s passFlag1=0
	...;--判断Desc
	...i dicDesc=iDesc d
	....s passFlag2=1
	...e  d
	....s passFlag2=0
	...s:(passFlag1=1)&&(passFlag2=1) DicDr=dicID
	.i (passFlag1=1)&&(passFlag2=1) d 
	..s libDicID=DicDr
	..i libDicID'=""  d
	...s ^shy("7")=libDicID
	...s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2) //药品code
	...s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3) //药品描述
	...s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	...s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	...s DrugForm="",itmSpecificationype="",libFactory="",libGenalName="",libEqFactorProp="",libPackaging="",libApproval=""
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_libDrugCode_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode_"[next]"_DrugForm_"[next]"_itmSpecificationype_"[next]"_""_"[next]"_""_"[next]"_""_"[next]"_""_"[next]"_""_"[next]"_""_"[next]"_""
	..e  d
	...s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	.e  d
	..s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	q pid
}

/// Description:	匹配数据-匹配率
/// Creator:		Sunhuiyong
/// CreateDate:		2021-7-8
/// w ##class(web.DHCCKBMatchSearch).GetSuccessData(11871)
ClassMethod GetSuccessData(lgUserID = "") As %String
{
	n (lgUserID)
	
	s ListTitle="matchItem^marchAll^onMatch^matchLv"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(3) //输出json前缀串
	s pid=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,""),-1)
	q:(pid="") "" 
	s allCount=0
	s successCount=0
	s success2Count=0
	s success3Count=0
	s successCountPv=0
	s:$d(^TMP("DHCCKB","MatchSearchByDataList","rowendcount",pid)) allCount=^TMP("DHCCKB","MatchSearchByDataList","rowendcount",pid)-^TMP("DHCCKB","MatchSearchByDataList","rowstartcount",pid)
	s:$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)) successCount=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)
	s:$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)) success2Count=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)
	s:allCount'=0 successCountPv=(successCount/allCount)*100
	s:successCountPv'="" successCountPv=$e(successCountPv,1,5)
	;总数-allCount
	;匹配数-successCount
	;总匹配率-successCountPv
	;二次匹配数-success2Count
	;匹配项一-matchitem
	;匹配项二-matchitem2
	;二次匹配率-successCountPv2
	;一次匹配率-successCountPv1
	;一次匹配数-success1Count
	s matchitem=""
	s matchitem2=""
	s matchitem3=""
	s successCountPv2=0
	s successCountPv3=0
	s:$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem",pid)) matchitem=^TMP("DHCCKB","MatchSearchByDataList","matchitem",pid)
	s:$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem2",pid)) matchitem2=^TMP("DHCCKB","MatchSearchByDataList","matchitem2",pid)
	s:allCount'=0 successCountPv2=(success2Count/allCount)*100
	s:successCountPv2'="" successCountPv2=$e(successCountPv2,1,5)
	s success1Count=0
	s success1Count=successCount-success2Count
	s:allCount'=0 successCountPv1=(success1Count/allCount)*100
	s:successCountPv1'="" successCountPv1=$e(successCountPv1,1,5)
	
	s:$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem3",pid)) matchitem3=^TMP("DHCCKB","MatchSearchByDataList","matchitem3",pid)
	s:$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount3",pid)) success3Count=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount3",pid)
	s:allCount'=0 successCountPv3=(success3Count/allCount)*100
	s:successCountPv3'="" successCountPv3=$e(successCountPv3,1,5)
	
	;s:matchitem2="别名" matchitem2="别名、处方应付"
	;i $d(^TMP("DHCCKB","MatchSearchByDataList","matchitem3",pid))  d
	
	s ListData=matchitem_"^"_allCount_"^"_success1Count_"^"_successCountPv1_"%"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData=matchitem2_"^"_allCount_"^"_success2Count_"^"_successCountPv2_"%"
	w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	i $d(^TMP("DHCCKB","MatchSearchByDataList","matchitem3",pid))  d
	.s ListData=matchitem3_"^"_allCount_"^"_success3Count_"^"_successCountPv3_"%"
	.w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData="总体"_"^"_allCount_"^"_successCount_"^"_successCountPv_"%"
	w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Description:	匹配数据-遍历药品列表
/// Creator:		Sunhuiyong
/// CreateDate:		2021-7-15
/// Input:			pid searchModel searchModelTwice lgUserID
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchByDataListNew("143477162","114554","","11871")
ClassMethod MatchSearchByDataListNew(pid, searchModel, searchModelTwice, lgUserID) As %String
{
	n (pid,searchModel,searchModelTwice,lgUserID)
	//进程号存临时glb记录表头信息
	s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,""))
	s ^TMP("DHCCKB","MatchSearchByDataList","rowstartcount",pid)=row
	s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=$g(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row))_"[next]"_"标注"_"[next]"_"知识库药品代码"_"[next]"_"知识库描述"_"[next]"_"知识库字典ID"_"[next]"_"知识库字典代码"
	//逐行遍历读入文件信息进行匹配
	f  s row=$o(^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)) q:row=""  d
	.q:row=1
	.s forstMatch=""
	.i searchModel["114554"   d //中药饮片匹配
	..s forstMatch=..MatchHerbalMedicine(pid,searchModel,lgUserID,1,searchModelTwice)
	.e  d
	..s:searchModel'="" forstMatch=..Match(pid,searchModel,lgUserID,1,searchModelTwice) //第一次匹配
	..i (forstMatch=-1)&&(searchModelTwice'="")||(searchModel="") d
	...s secondMatch=..Match(pid,searchModelTwice,lgUserID,2,searchModelTwice)          //第二次匹配
	q pid
}

/// Description:	匹配数据-遍历药品列表
/// Creator:		Sunhuiyong
/// CreateDate:		2021-7-15
/// Input:			pid searchModel searchModelTwice LgUserID
/// return:			药品信息串
/// table:			CT.CKB.PDSS.CommonDiction,CT.CKB.PDSS.DicLinkAttr
/// other:			匹配项：药品名称、通用名、厂家、规格、剂型 （可扩展）
/// w ##class(web.DHCCKBMatchSearch).MatchSearchByDataListNew("5860297","114554")
ClassMethod Match(pid, searchModel, lgUserID, secondFlag, searchModelTwice) As %String
{
	//数据准备
	s drugDataId=##class(web.DHCCKBCommon).GetDrugData()                              //西药
	s chineseDrugId=##class(web.DHCCKBCommon).GetChineseDrugData()                    //中成药
	s chineseHMData=##class(web.DHCCKBCommon).GetChineseHMData()   				      //中药饮片
	s proNamePropCom=##class(web.DHCCKBCommon).GetProNameProp()              	      //商品名-43
	s generalFromPropCom=##class(web.DHCCKBCommon).GetGeneralFromProp()      		  //通用名(带剂型)-74532
	s chineseGeneralFromPropCom=##class(web.DHCCKBCommon).GetChineseGeneralFromProp() //Chinese通用名(带剂型)-81818
	s approvalNumberPropCom=##class(web.DHCCKBCommon).GetApprovalNumberProp()  	      //批准文号-78015
	s drugManfCom=##class(web.DHCCKBCommon).GetDrugManf()                   	      //生产厂家-44
	s chineseDrugManfCom=##class(web.DHCCKBCommon).GetChineseDrugManf()    			  //Chinese生产厂家-81835
	s formPropCom=##class(web.DHCCKBCommon).GetFormProp()                   		  //剂型-40
	s specificationPropCom=##class(web.DHCCKBCommon).GetSpecificationProp() 		  //规格-77980
	s prescriptionCopePropCom=##class(web.DHCCKBCommon).GetPrescriptionCopeProp()     //处方应付-114554
	s chineseAppDataCom=##class(web.DHCCKBCommon).GetChineseAppData()				  //批准文号-81832
	s eqFactorPropCom=##class(web.DHCCKBCommon).GetEqFactorProp()                     //等效单位-74531
	s drugBzCom=##class(web.DHCCKBCommon).GetDicIdByCode("包装") 					  //包装-78012
	//获取匹配项
	s searchModelStr=""
	s searchModelDesc=""
	s searchModelLen=$l(searchModel,"^")
	f i=1:1:searchModelLen  d
	.s linkId=$lg($g(^CT.CKB.PDSS.CommonDictionD($p(searchModel,"^",i))),5)
	.s searchModelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD($p(searchModel,"^",i))),3)
	.s:$lg($g(^CT.CKB.PDSS.CommonDictionD($p(searchModel,"^",i))),3)="" searchModelDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkId)),3)
	.s:searchModelStr'="" searchModelStr=searchModelStr_"，"_searchModelDesc
	.s:searchModelStr="" searchModelStr=searchModelDesc
	s success=0
	s str=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)
	s drugName=$p(str,"[next]",3)		//药品名称
	s generDesc=$p(str,"[next]",4)		//带剂型通用名
	q:generDesc="" -1					//通用名不允许不存在不匹配
	s factory=$p(str,"[next]",5)		//厂商
	s factory=$tr(factory,"（","(")
	s factory=$tr(factory,"）",")")
	s specification=$p(str,"[next]",6)  //规格
	s iDrugForm=$p(str,"[next]",7)      //剂型
	s hisPZWH=$p(str,"[next]",9)        //批准文号    shy 2021/6/17
	s hisDXDW=$p(str,"[next]",10)       //等效单位
	s id=drugDataId_"^"_chineseDrugId_"^"_chineseHMData  //遍历西药/中成药字典数据
	s Diclength=$l(id,"^")
	s DicDr=""
	s factoryPass=0,drugNamePass=0,iDrugFormPass=0,genalNamePass=0,genalNameZPass=0,factoryZPass=0,genalNameCPass=0,matchSPWHPass=0,matchDXDWPass=0,specificationPass=0,matchSPWHZPass=0    
	f i=1:1:Diclength  q:(factoryPass=1)&&(iDrugFormPass=1)&&(drugNamePass=1)&&(genalNamePass=1)&&(genalNameZPass=1)&&(factoryZPass=1)&&(genalNameCPass=1)&&(matchSPWHPass=1)&&(matchDXDWPass=1)&&(specificationPass=1)&&(matchSPWHZPass=1)  d
	.s DataId=$p(id,"^",i)
	.s dicID="" f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DataId,dicID))   q:(dicID="")||((factoryPass=1)&&(iDrugFormPass=1)&&(drugNamePass=1)&&(genalNamePass=1)&&(genalNameZPass=1)&&(factoryZPass=1)&&(genalNameCPass=1)&&(matchSPWHPass=1)&&(matchDXDWPass=1)&&(specificationPass=1)&&(matchSPWHZPass=1))  d   
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..;---遍历该药所有属性---
	..s DrugProName=""   //商品名   
	..s DrugManf=""      //生产企业(西药)
	..s DrugManfZ=""     //生产企业(中成药)
	..s DrugFormDic=""   //剂型
	..s GenalName=""     //通用名（西药）
	..s GenalNameZ=""    //通用名（中成药）
	..s GenalNameC=""    //处方应付（中药饮片）
	..s MatchSPWH=""     //审批文号
	..s MatchDXDW=""     //等效单位
	..s MatchSPWHZ=""    //审批文号（中成药）
	..s MatchSpecification="" //规格
	..s DLARowID="" f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID,DLARowID))  q:DLARowID=""  d
	...s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),3)
	...s:AttrCode=proNamePropCom DrugProName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)      //商品名
	...s:(AttrCode=generalFromPropCom) GenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)   //通用名（西药）
	...s:(AttrCode=chineseGeneralFromPropCom) GenalNameZ=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)  //通用名（中成药）
	...s:(AttrCode=prescriptionCopePropCom) GenalNameC=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3) //通用名（处方应付）
	...s:(AttrCode=approvalNumberPropCom) MatchSPWH=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)      					   //批准文号(西药)
	...s:(AttrCode=chineseAppDataCom) MatchSPWHZ=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)      				       //批准文号(中成药)
	...s:(AttrCode=eqFactorPropCom) MatchDXDW=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)      					   //等效单位
	...s:(AttrCode=drugManfCom) DrugManf=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)       //生产企业（西药）
	...s:(AttrCode=chineseDrugManfCom) DrugManfZ=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)   //生产企业（中成药）
	...s:AttrCode=formPropCom DrugFormDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)      //剂型
	...s:AttrCode=specificationPropCom MatchSpecification=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)       			   //规格
	..;--判断批准文号（中成药）
	..i (searchModel[chineseAppDataCom)&&($ZSTRIP(MatchSPWHZ,"*E","","ABCDEFGHIGKLMNOPQRESTUVWXYZ0123456789")'="")&&($ZSTRIP($$ALPHAUP^SSUTIL4(MatchSPWHZ),"*E","","ABCDEFGHIGKLMNOPQRESTUVWXYZ0123456789")=$ZSTRIP($$ALPHAUP^SSUTIL4(hisPZWH),"*E","","ABCDEFGHIGKLMNOPQRESTUVWXYZ0123456789")) d
	...s matchSPWHZPass=1
	..e  d
	...s matchSPWHZPass=0
	..;--判断规格
	..i (searchModel[specificationPropCom)&&(MatchSpecification=specification) d
	...s specificationPass=1
	..e  d
	...s specificationPass=0
	..;--判断厂家
	..i (searchModel[drugManfCom)&&(..CheckFactoryNew(dicID,factory)) d
	...s factoryPass=1
	..e  d
	...s factoryPass=0
	..;--判断厂家(中)
	..i (searchModel[chineseDrugManfCom)&&(..CheckFactoryNew(dicID,factory)) d
	...s factoryZPass=1
	..e  d
	...s factoryZPass=0
	..;--判断处方应付(中药饮片)
	..i (searchModel[prescriptionCopePropCom)&&(GenalNameC=generDesc) d
	...s genalNameCPass=1
	..e  d
	...s genalNameCPass=0
	..;--判断批准文号
	..i (searchModel[approvalNumberPropCom)&&($ZSTRIP(MatchSPWH,"*E","","ABCDEFGHIGKLMNOPQRESTUVWXYZ0123456789")'="")&&($ZSTRIP($$ALPHAUP^SSUTIL4(MatchSPWH),"*E","","ABCDEFGHIGKLMNOPQRESTUVWXYZ0123456789")=$ZSTRIP($$ALPHAUP^SSUTIL4(hisPZWH),"*E","","ABCDEFGHIGKLMNOPQRESTUVWXYZ0123456789")) d
	...s matchSPWHPass=1
	..e  d
	...s matchSPWHPass=0
	..;--判断等效单位
	..i (searchModel[eqFactorPropCom)&&(MatchDXDW=hisDXDW) d
	...s matchDXDWPass=1
	..e  d
	...s matchDXDWPass=0
	..;--判断通用名
	..i (searchModel[generalFromPropCom)&&(GenalName=generDesc) d
	...s genalNamePass=1
	..e  d
	...s genalNamePass=0
	..;--判断通用名（中）
	..i (searchModel[chineseGeneralFromPropCom)&&(GenalNameZ=generDesc) d
	...s genalNameZPass=1
	..e  d
	...s genalNameZPass=0
	..;--判断剂型
	..i (searchModel[formPropCom)&&(DrugFormDic=iDrugForm) d
	...s iDrugFormPass=1
	..e  d
	...s iDrugFormPass=0
	..;--判断商品名
	..i (searchModel[proNamePropCom)&&(DrugProName=drugName) d
	...s drugNamePass=1
	..e  d
	...s drugNamePass=0
	..;--统一规避没选匹配项的情况1--
  	..s:searchModel'[formPropCom iDrugFormPass=1
    ..s:searchModel'[drugManfCom factoryPass=1
    ..s:searchModel'[proNamePropCom drugNamePass=1
    ..s:searchModel'[generalFromPropCom genalNamePass=1
    ..s:searchModel'[chineseGeneralFromPropCom genalNameZPass=1
    ..s:searchModel'[chineseDrugManfCom factoryZPass=1
    ..s:searchModel'[prescriptionCopePropCom genalNameCPass=1
    ..s:searchModel'[approvalNumberPropCom matchSPWHPass=1
    ..s:searchModel'[eqFactorPropCom matchDXDWPass=1
    ..s:searchModel'[specificationPropCom specificationPass=1
    ..s:searchModel'[chineseAppDataCom matchSPWHZPass=1
	..s:(factoryPass=1)&&(iDrugFormPass=1)&&(drugNamePass=1)&&(genalNamePass=1)&&(genalNameZPass=1)&&(factoryZPass=1)&&(genalNameCPass=1)&&(matchSPWHPass=1)&&(matchDXDWPass=1)&&(specificationPass=1)&&(matchSPWHZPass=1) DicDr=dicID
	;--统一规避没选匹配项的情况2--
  	s:searchModel'[formPropCom iDrugFormPass=1
    s:searchModel'[drugManfCom factoryPass=1
    s:searchModel'[proNamePropCom drugNamePass=1
    s:searchModel'[generalFromPropCom genalNamePass=1
    s:searchModel'[chineseGeneralFromPropCom genalNameZPass=1
    s:searchModel'[chineseDrugManfCom factoryZPass=1
    s:searchModel'[prescriptionCopePropCom genalNameCPass=1
    s:searchModel'[approvalNumberPropCom matchSPWHPass=1
    s:searchModel'[eqFactorPropCom matchDXDWPass=1
    s:searchModel'[specificationPropCom specificationPass=1
    s:searchModel'[chineseAppDataCom matchSPWHZPass=1
	i (factoryPass=1)&&(iDrugFormPass=1)&&(drugNamePass=1)&&(genalNamePass=1)&&(genalNameZPass=1)&&(factoryZPass=1)&&(genalNameCPass=1)&&(matchSPWHPass=1)&&(matchDXDWPass=1)&&(specificationPass=1)&&(matchSPWHZPass=1) d 
	.s libDicID=DicDr
	.s dicDrugID=DicDr
	.i libDicID'=""  d
	..s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2)  //药品code
	..s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3)  //药品描述
	..s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	..s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	..s DrugForm="",itmSpecificationype="",libFactory="",libGenalName="",libEqFactorProp="",libPackaging="",libApproval=""
	..s DLA="" f  s DLA=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",libDicID,DLA))  q:DLA=""  d
	...s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),3)
	...s:AttrCode=formPropCom DrugForm=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //剂型
	...s:AttrCode=specificationPropCom itmSpecificationype=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),5)    //规格
	...s:(AttrCode=drugManfCom) libFactory=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //厂家
	...s:(libDrugParef'=drugDataId)&&(AttrCode=chineseDrugManfCom) libFactory=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //厂家
	...s:(AttrCode=generalFromPropCom) libGenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //通用名
	...s:(libDrugParef'=drugDataId)&&(AttrCode=chineseGeneralFromPropCom) libGenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //通用名
	...s:(libDrugParef'=drugDataId)&&(AttrCode=prescriptionCopePropCom) libGenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //处方应付
	...s:AttrCode=eqFactorPropCom libEqFactorProp=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),5)       //等效单位-等效数量
	...s:AttrCode=drugBzCom libPackaging=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),5)       //包装
	...s:AttrCode=approvalNumberPropCom libApproval=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),5)       //批准文号（西药）
	...s:(libDrugParef'=drugDataId)&&(AttrCode=chineseAppDataCom) libApproval=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),5)       //批准文号（中成药）
	..s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_searchModelStr_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode_"[next]"_DrugForm_"[next]"_itmSpecificationype_"[next]"_specification_"[next]"_iDrugForm_"[next]"_libFactory_"[next]"_libGenalName_"[next]"_libEqFactorProp_"[next]"_libPackaging_"[next]"_libApproval_"[next]"_dicDrugID
	..s:$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)) ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)+1
	..s:'$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)) ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)=1
	..s:'$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem",pid))&&(secondFlag=1) ^TMP("DHCCKB","MatchSearchByDataList","matchitem",pid)=searchModelStr
	..s:($d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)))&&(secondFlag=2) ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)+1
	..s:('$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)))&&(secondFlag=2) ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)=1
	..s:('$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem2",pid)))&&(secondFlag=2) ^TMP("DHCCKB","MatchSearchByDataList","matchitem2",pid)=searchModelStr
	.e  d
	..s:searchModelTwice="" ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	..s:secondFlag=2 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	..s success=-1
	e  d
	.s:searchModelTwice="" ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	.s:secondFlag=2 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	.s success=-1
	s ^TMP("DHCCKB","MatchSearchByDataList","rowendcount",pid)=row
	q success
}

/// Description:	中药饮片匹配
/// Creator:		Sunhuiyong
/// CreateDate:		2021-9-16
/// Input:			pid searchModel searchModelTwice LgUserID
/// return:			药品信息串
/// w ##class(web.DHCCKBMatchSearch).MatchHerbalMedicine("159926602","114554","11871","","")
ClassMethod MatchHerbalMedicine(pid, searchModel, lgUserID, secondFlag, searchModelTwice) As %String
{
	//数据准备

	s chineseHMData="81862" ;##class(web.DHCCKBCommon).GetChineseHMData()   				      //中药饮片
	s prescriptionCopePropCom=##class(web.DHCCKBCommon).GetPrescriptionCopeProp()     //处方应付-114554
	s otherName="114555"                                                              //别名 -测试

	//获取匹配项
	s searchModelStr=""
	s success=0
	s str=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)
	s drugName=$p(str,"[next]",3)		//药品名称
	s generDesc=$p(str,"[next]",4)		//带剂型通用名
	q:generDesc="" -1					//通用名不允许不存在不匹配
	s factory=$p(str,"[next]",5)		//厂商
	s factory=$tr(factory,"（","(")
	s factory=$tr(factory,"）",")")
	s specification=$p(str,"[next]",6)  //规格
	s iDrugForm=$p(str,"[next]",7)      //剂型
	s hisPZWH=$p(str,"[next]",9)        //批准文号    
	s hisDXDW=$p(str,"[next]",10)       //等效单位
	s id=chineseHMData                  //遍历中药饮片字典数据
	s Diclength=$l(id,"^")
	s passFlag=0
	s namePassFlag=0
	s yfPassFlag=0
	s bmPassFlag=0
	s nameDicDr=""
	s bmDicDr=""
	s yfDicDr=""
	s DicDr=""
	s bmsearchModelStr=""
	s yfsearchModelStr=""
	f i=1:1:Diclength   d
	.s DataId=$p(id,"^",i)
	.s dicID="" f  s dicID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",DataId,dicID))    q:dicID=""  d 
	..q:0=##class(web.DHCCKBCommon).IsEnabled(dicID)	// 过滤停用  
	..s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),2)
	..s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicID)),3)
	..s HisOtherNameList=""
	..;---遍历该药所有属性---
	..s GenalNameC=""    //处方应付
	..s DLARowID="" f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",dicID,DLARowID))  q:DLARowID=""  d
	...s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),3)
	...s:(AttrCode=prescriptionCopePropCom) GenalNameC=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3) //通用名（处方应付）
	...s:AttrCode=otherName HisOtherNameList=HisOtherNameList_"^"_$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4))),3)    //规格
	..i generDesc=dicDesc  d
	...s namePassFlag=1
	...s nameSearchModelStr="名称"
	...s nameDicDr=dicID
	..i GenalNameC=generDesc  d
	...s yfPassFlag=1
	...s yfsearchModelStr="处方应付"
	...s yfDicDr=dicID
	..;-------------------------
	..;i HisOtherNameList[generDesc  d
	..;.s bmPassFlag=1
	..;.s bmsearchModelStr="别名"
	..;.s bmDicDr=dicID
	..;-------------------------
	..s hisOtherNameListLen=$l(HisOtherNameList,"^")
	..f j=1:1:hisOtherNameListLen  d
	...s HisOtherName=$p(HisOtherNameList,"^",j)
	...i HisOtherName=generDesc  d
	....s bmPassFlag=1
	....s bmsearchModelStr="别名"
	....s bmDicDr=dicID
	
	
	i namePassFlag=1  d
	.s passFlag=1
	.s DicDr=nameDicDr
	.s searchModelStr=nameSearchModelStr
	i (namePassFlag=0)&&(yfPassFlag=1)  d
	.s passFlag=1
	.s DicDr=yfDicDr
	.s searchModelStr=yfsearchModelStr
	i (namePassFlag=0)&&(yfPassFlag=0)&&(bmPassFlag=1)  d
	.s passFlag=1
	.s DicDr=bmDicDr
	.s searchModelStr=bmsearchModelStr
	i passFlag=1 d 
	.s libDicID=DicDr
	.s dicDrugID=DicDr
	.i libDicID'=""  d
	..s libDrugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),2)  //药品code
	..s libDrugName=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),3)  //药品描述
	..s libDrugParef=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDicID)),4) //药品字典ID
	..s libDrugParefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(libDrugParef)),2) //药品字典code
	..s DrugForm="",itmSpecificationype="",libFactory="",libGenalName="",libEqFactorProp="",libPackaging="",libApproval=""
	..s DLA="" f  s DLA=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDic",libDicID,DLA))  q:DLA=""  d
	...s AttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),3)
	...s:(AttrCode=prescriptionCopePropCom) libGenalName=$lg($g(^CT.CKB.PDSS.CommonDictionD(+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLA)),4))),3)       //处方应付
	..s ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_searchModelStr_"[next]"_libDrugCode_"[next]"_libDrugName_"[next]"_libDrugParef_"[next]"_libDrugParefCode_"[next]"_DrugForm_"[next]"_itmSpecificationype_"[next]"_specification_"[next]"_iDrugForm_"[next]"_libFactory_"[next]"_libGenalName_"[next]"_libEqFactorProp_"[next]"_libPackaging_"[next]"_libApproval_"[next]"_dicDrugID
	..s:$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)) ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)+1
	..s:'$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)) ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount",pid)=1
	..s:'$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem",pid))&&(searchModelStr="名称") ^TMP("DHCCKB","MatchSearchByDataList","matchitem",pid)=searchModelStr
	..s:($d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)))&&(searchModelStr="别名") ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)+1
	..s:('$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)))&&(searchModelStr="别名") ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount2",pid)=1
	..s:('$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem2",pid)))&&(searchModelStr="别名") ^TMP("DHCCKB","MatchSearchByDataList","matchitem2",pid)=searchModelStr
	..
	..s:($d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount3",pid)))&&(searchModelStr="处方应付") ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount3",pid)=^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount3",pid)+1
	..s:('$d(^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount3",pid)))&&(searchModelStr="处方应付") ^TMP("DHCCKB","MatchSearchByDataList","rowsuccesscount3",pid)=1
	..s:('$d(^TMP("DHCCKB","MatchSearchByDataList","matchitem3",pid)))&&(searchModelStr="处方应付") ^TMP("DHCCKB","MatchSearchByDataList","matchitem3",pid)=searchModelStr
	.
	.e  d
	..s:searchModelTwice="" ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	..s:secondFlag=2 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	..s success=-1
	e  d
	.s:searchModelTwice="" ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	.s:secondFlag=2 ^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)=^TMP("DHCCKB","web.DHCCKBMatchSearch","MatchSearchByUser",lgUserID,pid,row)_"[next]"_"未匹配上"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"_"[next]"
	.s success=-1
	s ^TMP("DHCCKB","MatchSearchByDataList","rowendcount",pid)=row
	q success
}

}
