Import sqluser

/// Description:	安全用药码表扩展表操作类
/// Creator:		QuNianpeng 
/// CreateDate:		2023-03-03
Class web.DHCCKBDictionExt Extends %RegisteredObject
{

/// Description:	同步码表数据
/// Creator:		QuNianpeng 
/// CreateDate:		2023-03-03	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDictionExt).SyncDictionData()
ClassMethod SyncDictionData() As %String
{
	// 遍历所有的字典数据(不区分停用字典)
	k ^CKB.PDSS.ResetCode
	s knowType=##class(web.DHCCKBCommon).GetKnowType() 		  // 知识类型
	s dictionFlag=##class(web.DHCCKBCommon).GetDictionFlag()  // 字典类型
	// 这些字典的已有数据,不能重新编码(程序中使用编码进行了判断)
	s ignoreList = $lb("DrugLibaryData","ICDDiagData","ExtraProp","DataTypeData","LevelFlagData","PassFlagData","SexData","DocData","TipsData","GlobalData") //药品目录字典,ICD诊断字典,附加属性字典,数据类型字典,管理级别字典,通过标记字典,性别字典,医生字典,提醒字典,全局规则字典
	s $list(ignoreList,*+1) = "TempData" //模板字典
	s $list(ignoreList,*+1) = "ScopeData" // 授权作用域字典
	s $list(ignoreList,*+1) = "RuleTypeData" //  规则类型字典
	s $list(ignoreList,*+1) = "哺乳期慎用药品给药方式字典" //  哺乳期慎用药品给药方式字典
	s $list(ignoreList,*+1) = "LifeCycleData" //  生命周期字典
	s $list(ignoreList,*+1) = "PositionData" //  职务字典
	s $list(ignoreList,*+1) = "DrugLibary1Data" //  西药药品目录字典
	s $list(ignoreList,*+1) = "ChineseDrugLibaryData" //   中成药药品目录字典
	s $list(ignoreList,*+1) = "ChineseHerbalMedicineDrugLibaryData" //  中药饮片药品目录字典
	s $list(ignoreList,*+1) = "DrugCategoryData" // 药学分类字典
	s linkId = ""
	f  s linkId = $o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dictionFlag,knowType,linkId)) q:linkId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkId)),2)
	.q:+dicId=0
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.q:$lf(ignoreList,dicCode)>0
	.// 对每一个字典循环遍历,生成编码,存在临时global中
	.s sub = ""
	.f  s sub = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dicId,sub)) q:sub=""  d
	..s subCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(sub)),2)
	..s subDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(sub)),3)
	..s newSubCode = ##class(web.DHCCKBDiction).GetSysCodeByType(dicId,subCode) // 重新编码
	..s ^CKB.PDSS.ResetCode(sub) = $lb(sub,subCode,subDesc,dicId,newSubCode)
	.// 树类型的数据的只能编写最外层数据的编码,其余数据需要重新编码,DrugCategoryData药学分类,MedicineOrderData药嘱信息,KnowSourceData知识来源,DefinitionRuleData术语规则

	// 同步修改对照表中的编码和码表中的编码	
	s id = ""
	f  s id=$o(^CKB.PDSS.ResetCode(id))  q:id=""  d
	.s data = $g(^CKB.PDSS.ResetCode(id))
	.s code = $lg(data,2)
	.s desc = $lg(data,3)
	.s parref = $lg(data,4)
	.s newCode = $lg(data,5)
	.//&sql(update CKB_PDSS.ComContrast set CC_LibCode=:newCode where CC_LibCode=:code and CC_LibDesc=:desc and CC_DicType=:parref)
	.&sql(update CT_CKB_PDSS.CommonDiction set CD_Code=:newCode where CD_RowID=:id)
	
	q ""
}

/// Description:	同步对照表数据
/// Creator:		QuNianpeng 
/// CreateDate:		2023-03-03	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDictionExt).SyncContrastData()
ClassMethod SyncContrastData() As %String
{
	// 同步修改对照表中的编码和码表中的编码	

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DISTINCT CC_DicType as dictype FROM CKB_PDSS.ComContrast"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	While(result.Next())
	{	
		s parref = result.Data("dictype")
		continue:parref=""
		s sub = ""
		f  s sub = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,sub)) q:sub=""  d
		.q:'$d(^CKB.PDSS.ResetCode(sub)) 
		.s data = $g(^CKB.PDSS.ResetCode(sub))
		.s code = $lg(data,2)
		.s desc = $lg(data,3)
		.s newparref = $lg(data,4)
		.s newCode = $lg(data,5)
		.&sql(update CKB_PDSS.ComContrast set CC_LibCode=:newCode where CC_LibDesc=:desc and CC_DicType=:parref)		
		.s count = count + 1
		.w count_":"_desc,!
	}
}

/// Description:	同步树形码表数据
/// Creator:		QuNianpeng 
/// CreateDate:		2023-05-10
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDictionExt).SyncTreeDictionData()
ClassMethod SyncTreeDictionData() As %String
{
	k ^CKB.PDSS.ResetTreeCode
	d ##class(web.DHCCKBDictionExt).SetTreeDataCode()

	// 同步修改和码表中的编码	
	s id = ""
	f  s id=$o(^CKB.PDSS.ResetTreeCode(id))  q:id=""  d
	.s data = $g(^CKB.PDSS.ResetTreeCode(id))
	.s code = $lg(data,2)
	.s desc = $lg(data,3)
	.s parref = $lg(data,4)
	.s newCode = $lg(data,5)
	.&sql(update CT_CKB_PDSS.CommonDiction set CD_Code=:newCode where CD_RowID=:id)
	
	q ""
}

/// Description:	树形数据自动生成编码
/// Creator:		QuNianpeng 
/// CreateDate:		2023-03-03	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDictionExt).SetTreeDataCode()
ClassMethod SetTreeDataCode() As %String
{
	// 树类型的数据的只能编写最外层数据的编码,其余数据需要重新编码,MedicineOrderData药嘱信息,KnowSourceData知识来源,DefinitionRuleData术语规则
	s treeCodeList = $lb("MedicineOrderData","KnowSourceData","DefinitionRuleData")
	//s treeCodeList = $lb("MedicineOrderData")

	f k=1:1:$ll(treeCodeList)  d
	.s code = $lg(treeCodeList,k)
	.s id = ##class(web.DHCCKBCommon).GetDicIdByCode(code)
	.s sub = ""
	.f  s sub = $o(^CT.CKB.PDSS.CommonDictionI("Parref",id,sub)) q:sub=""  d	// 第一层
	..s sonsub = "",count = 0
	..f  s sonsub = $o(^CT.CKB.PDSS.CommonDictionI("Parref",sub,sonsub)) q:sonsub=""  d
	...s count = count + 1
	...d ..SetTreeCode(sub,sonsub,count)
	...
	
	q ""
}

/// Description:	树形字典数据生成编码
/// Creator:		QuNianpeng 
/// CreateDate:		2023-05-10	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBDictionExt).SetTreeCode()
ClassMethod SetTreeCode(parref, id, num) As %String
{
	// 生成新规则
	s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(parref)),2)
	i $d(^CKB.PDSS.ResetTreeCode(parref))  d
	.s data = $g(^CKB.PDSS.ResetTreeCode(parref))
	.s parrefCode = $lg(data,5)

	s newSubCode = parrefCode_"."_##class(web.DHCCKBCommonUtil).AddZero("prev",5,num)
	s subCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),2)
	s subDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(id)),3)
	s ^CKB.PDSS.ResetTreeCode(id) = $lb(id,subCode,subDesc,parref,newSubCode)	
	
	s HasChildFlag=$d(^CT.CKB.PDSS.CommonDictionI("Parref",+id))		
	q:HasChildFlag<=0 1
	
	s sub="",count = 0
	f  s sub=$o(^CT.CKB.PDSS.CommonDictionI("Parref",+id,sub))	q:sub=""  d
	.s count = count + 1
	.d ..SetTreeCode(id,sub,count)
	
	q ""
}

/// Description:	自动生成编码
/// Creator:		QuNianpeng 
/// CreateDate:		2023-03-03	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDictionExt).SetCode()
ClassMethod SetCode(typeCode, typeDesc) As %String
{
	// ExtCode 编码生成规则
	// 药品字典:西药: XY0000000001(8位数) 中成药: CY000000001(8位数) 中药饮片:YP000000001(8位数),中药方剂:FJ000000001(8位数)
	// 其他字典级别: 字典首拼+0000001(8位数)
	// 先判断是不是字典
	
	s preFlag = "SYS"
	s num = 0
	s typePin = ##class(web.DHCCKBCommonUtil).GetFullPYCODE(typeDesc)
	s typeFirstPin = ##class(web.DHCCKBCommonUtil).GetPYCODE(typeDesc)
	i typeCode="DrugData" s num = $I(^CKB.PDSS.Util("XY")),preFlag = "XY"
	e  i typeCode="ChineseDrugData" s num = $I(^CKB.PDSS.Util("CY")),preFlag = "CY"
	e  i typeCode="ChineseHerbalMedicineData" s num = $I(^CKB.PDSS.Util("YP")),preFlag = "YP"
	e  i typeCode="ChinaMedPrescData" s num = $I(^CKB.PDSS.Util("FJ")),preFlag = "FJ"
	e  i typeCode="DrugCategoryData" s num = $I(^CKB.PDSS.Util("DXFL")),preFlag = "DXFL"
	e  s num = $I(^CKB.PDSS.Util(typePin)),preFlag = typeFirstPin				
	
			
	s newCode = preFlag_##class(web.DHCCKBCommonUtil).AddZero("prev",8,num)
	
	q newCode
}

/// Description:	存储药品扩展编码
/// Creator:		QuNianpeng 
/// CreateDate:		2023-03-29	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDictionExt).SaveDataExtCode()
ClassMethod SaveDataExtCode(dicId, newCode) As %String
{
	// ExtCode 编码生成规则
	
	s obj=##class(CT.CKB.PDSS.ComDictionExt).%New()
	s obj.ExtCode = newCode
	s obj.ExtPin = ""
	s obj.ExtFirstPin = ""
	s obj.ExtCDDr = dicId
	s sc=obj.%Save()
	d obj.%Close()

	q ""
}

/// Description:	判断当前保存的数据是否是字典数据,是则自动生成编码(保存具体字典数据时调用)
/// Creator:		QuNianpeng 
/// CreateDate:		2023-05-09
/// Input:			字典编码,字典描述
/// return:			具体数据的编码
/// other:			w ##class(web.DHCCKBDictionExt).GetSysCodeByType("CS字典","")
ClassMethod GetSysCodeByType(dicCode, dicDesc) As %String
{
	//q:dicCode="DrugLibaryData" dicCode //药品目录暂时先不修改编码,程序中多处用到了判断
	s sysCode = ..SetAutoCode(dicCode)
	
	s maxNo = $p(sysCode,":",1)
	s prevCode = $p(sysCode,":",2)
	s newCode = ""
	i (maxNo="")||(prevCode="") d	
	.s num = $I(^CKB.PDSS.Util("SYSCODE"))
	.s newCode = "SYS"_##class(web.DHCCKBCommonUtil).AddZero("prev",8,num)
	q:newCode'="" newCode
	
	i dicCode="DrugCategoryData" d	// 药学分类使用5位编码,其他字典使用8位编码
	.s newCode = prevCode_##class(web.DHCCKBCommonUtil).AddZero("prev",5,maxNo)
	e  d
	.s newCode = prevCode_##class(web.DHCCKBCommonUtil).AddZero("prev",8,maxNo)
	
	q:newCode="" dicCode
	q newCode
}

/// Description:	生成字典明细数据的编码
/// Creator:		QuNianpeng 
/// CreateDate:		2023-05-09
/// Input:			字典类型Code
/// return:			字典数据编码
/// other:			w ##class(web.DHCCKBDictionExt).SetAutoCode()
ClassMethod SetAutoCode(dicCode) As %String
{
	L +^CKB.PDSS.DictionaryMaxNoD("DHCCKB",dicCode):10 E  Q ""
	s sysCode = ""
	s maxNo = $o(^CKB.PDSS.DictionaryMaxNoI("Type",dicCode,""))
	q:maxNo="" ""	
	s maxNoId = $o(^CKB.PDSS.DictionaryMaxNoI("Type",dicCode,maxNo,""))	
	q:maxNoId="" ""	
	s prevCode = $lg(^CKB.PDSS.DictionaryMaxNoD(maxNoId),4)
	s newNaxNo = maxNo + 1	
	s obj=##class(CKB.PDSS.DictionaryMaxNo).%OpenId(maxNoId)
	s obj.DMNMaxNo=newNaxNo
	s sc=obj.%Save()
	d obj.%Close()
	L -^CKB.PDSS.DictionaryMaxNoD("DHCCKB",dicCode)
	q newNaxNo_":"_prevCode
}

/// Description:	初始化所有的字典,生成编码(用于对旧字典数据的编码改造)
/// Creator:		QuNianpeng 
/// CreateDate:		2023-05-09
/// Input:			字典编码,字典描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDictionExt).InitDictionMaxNo()
ClassMethod InitDictionMaxNo() As %String
{
	// 遍历所有的字典,自动生成最大码
	
	s knowType=##class(web.DHCCKBCommon).GetKnowType() 		  // 知识类型
	s dictionFlag=##class(web.DHCCKBCommon).GetDictionFlag()  // 字典类型

	s linkId = ""
	f  s linkId = $o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",dictionFlag,knowType,linkId)) q:linkId=""  d
	.s dicId = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkId)),2)
	.q:+dicId=0
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicId)),3)
	.d ..SetMaxNoByDiction(dicCode, dicDesc)
	
	q "字典最大码初始化成功"
}

/// Description:	新增字典时,同步生成字典的最大码(新增字典时,调用)
/// Creator:		QuNianpeng 
/// CreateDate:		2023-05-09
/// Input:			字典编码,字典描述
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBDictionExt).SetMaxNoByDiction()
ClassMethod SetMaxNoByDiction(dicCode, dicDesc) As %String
{
	q:dicCode="" ""
	s firstPin = ##class(web.DHCCKBCommonUtil).GetPYCODE(dicDesc)	// 首拼
	s firstPin = $select(dicCode="DrugData":"XY",dicCode="ChineseDrugData":"CY",dicCode="ChineseHerbalMedicineData":"YP",
					dicCode="ChinaMedPrescData":"FJ",dicCode="DrugCategoryData":"DC",1:firstPin)
	// 首拼重复,则使用asc码做前缀
	i $d(^CKB.PDSS.DictionaryMaxNoI("PrevCode",firstPin)) s firstPin=##class(web.DHCCKBCommonUtil).GetCNCODE(dicCode,1,"")
	
	s obj=##class(CKB.PDSS.DictionaryMaxNo).%New()
	s obj.DMNMaxNo=0
	s obj.DMNDicType=dicCode
	s obj.DMNPrevCode=firstPin
	s sc=obj.%Save()
	d obj.%Close()

	q obj.%Id()
}

}
