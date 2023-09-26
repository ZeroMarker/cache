Import SQLUser

Class web.DHCCKBDrugAttrRegLev Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	用code查询字典数据
/// w ##class(web.DHCCKBDrugAttrRegLev).QueryDicData("1","30","GeneralFromData")
ClassMethod QueryDicData(page, rows, dicCode)
{
	n (page,rows,dicCode)
	s ^temptest("998")=$lb(page, rows, dicCode)
	s dictionId = ##class(web.DHCCKBCommon).GetDicIdByCode(dicCode)
	s end = page*rows
	s start=(page-1)*rows+1
	s h=0
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s dicId = ""   
	for  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dictionId,dicId))   q:dicId=""  d
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),4)
	.s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),5)
	.s linkDesc = ""
	.i linkDr'="" d
	..s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	..s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	..s linkDesc = dicDesc
	.s data = dicId_"^"_dicCode_"^"_dicDesc_"^"_parref_"^"_linkDr_"^"_linkDesc
	.s h=h+1	
	.s ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDicData",pid,h) = data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="dicId^dicCode^dicDesc^parref^linkDr^linkDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDicData",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDicData",pid,index))
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

/// Descript:	分类		->查询通用名
/// 			分类		->成分
/// 			分类		->带剂型通用名
/// 			分类		->药品
/// 			通用名  	->成分
/// 			通用名  	->带剂型通用名
/// 			通用名  	->药品
/// 			成分		->带剂型通用名
/// 			成分		->药品
/// 			带剂型通用名->药品
/// w ##class(web.DHCCKBDrugAttrRegLev).QueryComnameAttr("1","30","69225")
ClassMethod QueryComnameAttr(page, rows, catId)
{
	n (page, rows,catId)
	s ^temptest("677")=$lb(page, rows,catId)
	s end = page*rows
	s start=(page-1)*rows+1
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s catId="69225"
	k comArr
	s h=0
	s genNameProp = ##class(web.DHCCKBCommon).GetDrugGenerName()
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",catId,attrId))  Q:attrId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,genNameProp))  d
	..s attr = ""
	..for  s attr = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,genNameProp,attr))  Q:attr=""  d
	...s linkDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),4)
	...Q:$d(comArr(linkDr))
	...s comArr(linkDr) = linkDr
	...s dicCode = "",dicDesc = ""
	...i linkDr'="" s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),2)
	...i linkDr'="" s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkDr)),3)
	...Q:dicDesc=""
	...s data = linkDr_"^"_dicCode_"^"_dicDesc_"^"_""_"^"_""_"^"_""
	...s h=h+1	
	...s ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComnameAttr",pid,h) = data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="dicId^dicCode^dicDesc^parref^linkDr^linkDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComnameAttr",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComnameAttr",pid,index))
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

/// Descript:	分类		->查询通用名
/// 			分类		->成分
/// 			分类		->带剂型通用名
/// 			分类		->药品
/// 			通用名  	->成分
/// 			通用名  	->带剂型通用名
/// 			通用名  	->药品
/// 			成分		->带剂型通用名
/// 			成分		->药品
/// 			带剂型通用名->药品
/// w ##class(web.DHCCKBDrugAttrRegLev).QueryCompentAttr("1","30","69225","85329")
ClassMethod QueryCompentAttr(page, rows, catId, comnameId)
{
	n (page, rows,catId,comnameId)
	s ^temptest("6770")=$lb(page, rows,catId,comnameId)
	s end = page*rows
	s start=(page-1)*rows+1
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s catId="69225"
	k comArr
	s h=0
	s genNameProp = ##class(web.DHCCKBCommon).GetDrugGenerName()
	s IngredientId = ##class(web.DHCCKBCommon).GetIngredientCode()
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",catId,attrId))  Q:attrId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,genNameProp))  d
	..s attr = ""
	..for  s attr = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,genNameProp,attr))  Q:attr=""  d
	...s linkDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),4)
	...Q:(comnameId'="")&&(linkDr'=comnameId)
	...s compenAttrId = ""
	...for  s compenAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,IngredientId,compenAttrId))  Q:compenAttrId=""  d
	....s compentId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(compenAttrId)),4)
	....Q:$d(comArr(compentId))
	....s comArr(compentId) = compentId
	....s dicCode = "",dicDesc = ""
	....i compentId'="" s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(compentId)),2)
	....i compentId'="" s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(compentId)),3)
	....Q:dicDesc=""
	....s data = compentId_"^"_dicCode_"^"_dicDesc_"^"_""_"^"_""_"^"_""
	....s h=h+1	
	....s ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryCompentAttr",pid,h) = data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="dicId^dicCode^dicDesc^parref^linkDr^linkDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryCompentAttr",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryCompentAttr",pid,index))
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

/// w ##class(web.DHCCKBDrugAttrRegLev).QueryComDosAttr("1","30","69225","85329","5533")
ClassMethod QueryComDosAttr(page, rows, catId, comnameId, component)
{
	n (page, rows,catId,comnameId,component)
	s ^temptest("67709")=$lb(page, rows,catId,comnameId,component)
	s end = page*rows
	s start=(page-1)*rows+1
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s catId="69225"
	k comArr
	s h=0
	s genNameProp = ##class(web.DHCCKBCommon).GetDrugGenerName()
	s IngredientId = ##class(web.DHCCKBCommon).GetIngredientCode()
	s genNameDosId = ##class(web.DHCCKBCommon).GetGeneralFromProp()
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",catId,attrId))  Q:attrId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,genNameProp))  d
	..s attr = ""
	..for  s attr = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,genNameProp,attr))  Q:attr=""  d
	...s linkDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attr)),4)
	...Q:(comnameId'="")&&(linkDr'=comnameId)
	...s compenAttrId = ""
	...for  s compenAttrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,IngredientId,compenAttrId))  Q:compenAttrId=""  d
	....s compentId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(compenAttrId)),4)
	....Q:(component'="")&&(component'=compentId)
	....s comdosattrId = ""
	....for  s comdosattrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,genNameDosId,comdosattrId))  Q:comdosattrId=""  d
	.....s comdosId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(comdosattrId)),4)
	.....Q:$d(comArr(comdosId))
	.....s comArr(comdosId) = comdosId
	.....s dicCode = "",dicDesc = ""
	.....i comdosId'="" s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(comdosId)),2)
	.....i comdosId'="" s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(comdosId)),3)
	.....Q:dicDesc=""
	.....s data = comdosId_"^"_dicCode_"^"_dicDesc_"^"_""_"^"_""_"^"_""
	.....s h=h+1	
	.....s ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComDosAttr",pid,h) = data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="dicId^dicCode^dicDesc^parref^linkDr^linkDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComDosAttr",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComDosAttr",pid,index))
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

/// Descript:取药品数据
/// w ##class(web.DHCCKBDrugAttrRegLev).QueryDrugList("1","30","49912","74569","9295","78331")
ClassMethod QueryDrugList(page, rows, catId, comnameId, component, comnameDos)
{
	n (page, rows,catId,comnameId,component,comnameDos)
	s ^temptest("67710")=$lb(page, rows,catId,comnameId,component,comnameDos)
	s end = page*rows
	s start=(page-1)*rows+1
	s catId="69225"
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	k comArr
	s h=0
	s genNameProp = ##class(web.DHCCKBCommon).GetDrugGenerName()
	s IngredientId = ##class(web.DHCCKBCommon).GetIngredientCode()
	s genNameDosId = ##class(web.DHCCKBCommon).GetGeneralFromProp()
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",catId,attrId))  Q:attrId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	.s genList = ..GetDrugComname(dicId)
	.s compentList = ..GetDrugCompent(dicId)
	.s comDosList = ..GetDrugComDos(dicId)
	.Q:(comnameId'="")&&(genList'[comnameId)
	.Q:(compentList'="")&&(compentList'[component)
	.Q:(comDosList'="")&&(comDosList'[comnameDos)
	.s dicCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s dicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.s data = dicId_"^"_dicCode_"^"_dicDesc_"^"_""_"^"_""_"^"_""
	.s h=h+1	
	.s ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDrugList",pid,h) = data
	
	q:h=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(h)	
	q:h=0 ""
	
	s count=0	
	s listTitle="dicId^dicCode^dicDesc^parref^linkDr^linkDesc"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(h) // 输出json前缀串
	s index=""	  
	f  s index=$o(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDrugList",pid,index)) q:index=""  d
	.s listData=$g(^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDrugList",pid,index))
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

/// Descript:取药品通用名
ClassMethod GetDrugComname(drugId)
{
	n (drugId)
	s genNameProp = ##class(web.DHCCKBCommon).GetDrugGenerName()
	s genList = ""
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,genNameProp,attrId))  Q:attrId=""  d
	.s linkDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	.i genList="" s genList = linkDr
	.e  s genList = genList_"^"_linkDr
	Q genList
}

/// Descript:取药品成分
ClassMethod GetDrugCompent(drugId)
{
	n (drugId)
	s IngredientId = ##class(web.DHCCKBCommon).GetIngredientCode()
	s compentList = ""
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,IngredientId,attrId))  Q:attrId=""  d
	.s linkDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	.i compentList="" s compentList = linkDr
	.e  s compentList = compentList_"^"_linkDr
	Q compentList
}

/// Descript:取药带剂型的通用名
ClassMethod GetDrugComDos(drugId)
{
	n (drugId)
	s genNameDosId = ##class(web.DHCCKBCommon).GetGeneralFromProp()
	s comDosList = ""
	s attrId = ""
	for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,genNameDosId,attrId))  Q:attrId=""  d
	.s linkDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	.i comDosList="" s comDosList = linkDr
	.e  s comDosList = comDosList_"^"_linkDr
	Q comDosList
}

ClassMethod killTmpGlobal(pid)
{
	n (pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDicData",pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComnameAttr",pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryCompentAttr",pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryComDosAttr",pid)
	k ^TMP("DHCCKB","web.DHCCKBDrugAttrRegLev","QueryDrugList",pid)
}

}
