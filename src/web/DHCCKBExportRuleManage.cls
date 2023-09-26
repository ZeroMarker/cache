/// Description:	规则导出管理类
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05
Class web.DHCCKBExportRuleManage Extends %RegisteredObject [ ClassType = "", Not Final, Not ProcedureBlock ]
{

/// Description:	导出规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			开始日期,结束日期,用户id, 医院描述, 选择的药品列表, 字典id
/// return:		
/// other:			w ##class(web.DHCCKBExportRuleManage).ExportRule("","","11871","","","108")
ClassMethod ExportRule(stDate As %String, endDate As %String, userId As %String, hospDesc As %String, drugList As %String = "", dataId As %String = "", nodeList) As %String
{
	n (stDate, endDate, userId, hospDesc, drugList, dataId,nodeList)
	
	k ^TMPExportDrugRule
	s stDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(stDate)	
	s endDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(endDate)
	s:endDate="" endDate = +$h
	s curDate = endDate-stDate	
	s filter = $case(hospDesc'="",1:"Y",:"N") // 是否需要根据医院已经对照的药品进行过滤
	
	/* 选择药品更新 */	 // 日期、药品列表、字典 单选模式
	if (drugList'="")  d		
	.d ..GetRuleBySelectDrug(hospDesc,drugList,filter,nodeList)
	./* 直接更新某个字典的规则,如中药饮片,成分的规则 */
	
	else  if (dataId'="")  d
	.d ##class(web.DHCCKBExportRuleManage).GetRuleByDataId(stDate,endDate,hospDesc,dataId)
	./* 查询的时间差大于180天(3个月),优先使用遍历医院药品列表方式更新 */
	
	else  if (curDate>180)||(hospDesc'="") d
	.d ##class(web.DHCCKBExportRuleManage).GetRuleByHisDrugList(stDate, endDate, hospDesc,"N",dataId)
	
	else  d // 使用时间遍历规则
	.d ##class(web.DHCCKBExportRuleManage).GetRuleByDate(stDate, endDate, hospDesc, filter,dataId)

	/* 获取版本 */
	s version = ..GetVersion("rule",hospDesc)
	
	/* 获取路径 */
	s pathDir = ..GetUpdatePath()
	s path = pathDir_version_".gof"

	/* 导入global文件 */
	d ##Class(web.DHCCKB.Util.UtilService).ExportGlobal("TMPExportDrugRule", path)  //导出global文件

	/* 存储日志 */	
	d ##Class(web.DHCCKBUpdateManage).SaveUpdateLog(stDate, endDate, userId, path, "rule", "out", hospDesc, version)	

	q "dhctt.file.csp?act=download&filename="_version_"&dirname="_path
}

/// Description:	通过选择的药品id,获取该医院的更新规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			开始时间, 结束时间, 医院描述, 药品列表
/// return:		
/// other:			w ##class(web.DHCCKBExportRuleManage).GetRuleByHisDrugList(stDate, endDate, hospDesc, drugList)
ClassMethod GetRuleBySelectDrug(hospDesc As %String, drugList As %String, filter As %String, nodeList = "") As %String
{
	n (hospDesc, drugList, filter,nodeList)			

	k TmpDrugArr	
	s drugList = $listfromstring(drugList,"^")
	d ##class(web.DHCCKBCommonUtil).ListToArr(drugList,.TmpDrugArr)

	d ..GetRuleByDrug(.TmpDrugArr, hospDesc, filter,nodeList)
	
	q ""
}

/// Description:	通过字典直接更新某个字典的规则，如中药饮片,成分规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			开始日期, 结束日期,字典id
/// return:		
/// other:			w ##class(web.DHCCKBExportRuleManage).GetRuleByDataId(stDate, endDate, hospDesc, drugList)
ClassMethod GetRuleByDataId(stDate, endDate, hospDesc, dataId As %String) As %String
{
	n (stDate, endDate, hospDesc,dataId)			
	q:dataId="" ""
	
	s dicId = ""
	f  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dataId,dicId))		q:dicId=""  d
	.q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",dicId))	// 不存在规则
	.s ruleDicRowID = ""
	.f  s ruleDicRowID = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicId,ruleDicRowID)) q:ruleDicRowID=""  d
	..s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicRowID)),2)
	..s ruleLog = $o(^CKB.PDSS.RuleLogI("Rule",+ruleId,""))
	..s ruleDate = $lg(^CKB.PDSS.RuleLogD(ruleLog),4) 
	..q:(stDate'="")&(ruleDate<stDate)	// 日期过滤
	..q:(endDate'="")&(ruleDate>endDate)
	..s ruleInfo = ..GetRuleInfo(ruleId)	// 获取规则的信息
	..s drugInfo = ..GetDrugInfo(dicId)	// 通过药品id获取药品信息
	..s libaryInfo = ..GetLibaryByRule(ruleId)	// 通过规则id获取药品目录
	..s libaryId =  $lg(libaryInfo,1)
	..q:(libaryId="")	
	../* 过滤不属于当前医院的药品 */
	..q:(hospDesc'="")&&("N"=..IsContrastFlag($lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),2),$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),3),hospDesc))	
	../* 没有处理全局规则和子规则 */
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId) = drugInfo
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId,libaryId) = libaryInfo
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId,libaryId,ruleId) = ruleInfo
	..s ruleObj = ..GetRuleObj("add",ruleId,"Y") 
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId,libaryId,ruleId,"value") = ruleObj
	
	
	q ""
}

/// Description:	通过该医院的药品列表,获取该医院的更新规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			开始时间, 结束时间, 医院描述, 药品列表
/// return:		
/// other:			w ##class(web.DHCCKBExportRuleManage).GetRuleByHisDrugList(stDate, endDate, hospDesc, drugList)
ClassMethod GetRuleByHisDrugList(stDate As %String, endDate As %String, hospDesc As %String, filter As %String, dataId) As %String
{
	n (stDate, endDate, hospDesc, filter,dataId)			

	s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospDesc),""))	
	
	k TmpDrugArr	
	d ..GetConstDataByHosp(hospId,.TmpDrugArr,dataId)
	
	d ..GetRuleByDrug(.TmpDrugArr,hospDesc,filter)
	
	q ""
}

/// Description:	通过药品 找到药品下的所有规则 
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			开始时间, 结束时间, 医院描述, 药品列表
/// return:		
/// other:			w ##class(web.DHCCKBExportRuleManage).GetRuleByDrug(stDate, endDate, hospDesc, drugList)
ClassMethod GetRuleByDrug(TmpDrugArr, hospDesc, filter, nodeList = "") As %String
{
	n (TmpDrugArr, hospDesc, filter,nodeList)
	s dicId = ""
	f  s dicId = $o(TmpDrugArr(dicId))  q:dicId=""   d
	.q:dicId=0
	.q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",dicId))
	.s dicRowID = ""
	.f  s dicRowID = $o(^CT.CKB.PDSS.RuleDicI("Dic",dicId,dicRowID)) q:dicRowID=""  d
	..s ruleId = $lg($g(^CT.CKB.PDSS.RuleDicD(+dicRowID)),2)
	..s exitFlag = ##class(web.DHCCKBExportRuleManage).isExistRule(ruleId,nodeList)	
	..Q:exitFlag=0 
	..s ruleInfo = ..GetRuleInfo(ruleId)	// 获取规则的信息
	..s drugInfo = ..GetDrugByRule(ruleId)	// 通过规则id获取药品id
	..s libaryInfo = ..GetLibaryByRule(ruleId)	// 通过规则id获取药品目录
	..s drugId = $lg(drugInfo,1)
	..s libaryId =  $lg(libaryInfo,1)
	..q:(drugId="")||(libaryId="")	
	..q:(filter="Y")&&(hospDesc'="")&&("N"=..IsContrastFlag($lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2),$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3),hospDesc))
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId) = drugInfo
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId,libaryId) = libaryInfo
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId,libaryId,ruleId) = ruleInfo
	..s ruleObj = ..GetRuleObj("add",ruleId,"Y") 
	..s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","drug",dicId,libaryId,ruleId,"value") = ruleObj
	..
	q ""
}

/// Description:	使用时间寻找规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			开始日期,结束日期,医院描述,选择的药品列表
/// return:		
/// other:			w ##class(web.DHCCKBExportRuleManage)》GetRuleByDate(1415872)
ClassMethod GetRuleByDate(stDate As %String, endDate As %String, hospDesc As %String, filter As %String, dataId) As %String
{
	n (stDate, endDate, hospDesc, filter,dataId)
	
	s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","date") = stDate_"^"_endDate
	
	k TmpDrugArr	
	/* 通过时间段找到变更过规则的药品 */
	f date=stDate:1:endDate  d
	.s ruleLogId = ""
	.f  s ruleLogId = $o(^CKB.PDSS.RuleLogI("Date",date,ruleLogId)) q:ruleLogId=""  d
	..s ruleId = $lg(^CKB.PDSS.RuleLogD(+ruleLogId),2)
	..s drugInfo = ..GetDrugByRule(ruleId)	// 通过规则id获取药品id
	..q:(dataId'="")&(dataId'=$lg(drugInfo,4))
	..s drugId = $lg(drugInfo,1)
	..//q:(drugList'="")&(drugList'[drugId)	// 选择药品更新时,过滤药品
	../* 过滤不属于当前医院的药品 */
	..q:(filter="Y")&&(hospDesc'="")&&("N"=..IsContrastFlag($lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2),$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3),hospDesc))	
	..s TmpDrugArr(drugId)=""
	
	/* 通过药品 找到药品下的所有规则 */
	d ..GetRuleByDrug(.TmpDrugArr, hospDesc, filter)

	q ""
}

/// Description:	通过医院获取该医院对照的系统药品id
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			医院id
/// return:		
/// other:			w ##class(web.DHCCKBExportRuleManage).GetConstDataByHosp(1415872)
ClassMethod GetConstDataByHosp(hospId As %String, TmpDrugArr, dataId) As %String
{
	n (hospId, TmpDrugArr,dataId)
	i dataId'="" s drugDataList = $lb($p($g(^DHCCCKBCD(+dataId)),"^",2))
	e  s drugDataList = $Lb("DrugData","ChineseDrugData","ChineseHerbalMedicineData")
	
	f i=1:1:$listlength(drugDataList)  d
	.s drugType = $lg(drugDataList,i)
	.s drugTypeId = ##class(web.DHCCKBCommon).GetDicIdByCode(drugType)
	.s extRowID = ""
	.f  s extRowID = $o(^CKB.PDSS.ExtDictionI("Type",hospId,drugType,extRowID)) q:extRowID=""  d
	..s extData = $g(^CKB.PDSS.ExtDictionD(extRowID))
	..s extCode = $lg(extData,2)
	..s extDesc = $lg(extData,3)
	..i extDesc["||" s extDesc = $p(extDesc,"||",1)
	..q:'$d(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(extCode)))
	..s constrastID = ""
	..f  s constrastID = $o(^CKB.PDSS.ComContrastI("HisCode",$$UPPER^SSUTIL4(extCode),constrastID)) q:constrastID=""  d
	...s listData =$g(^CKB.PDSS.ComContrastD(constrastID))
	...s constHisDesc = $lg(listData,5)
	...q:constHisDesc'=extDesc
	...s constLibCode = $lg(listData,2)
	...s libID = ##class(web.DHCCKBCommon).GetDicIdByCode(constLibCode,drugTypeId)
	...s TmpDrugArr(libID) = ""
	
	q ""
}

/// Description:	使用药品id获取药品信息串
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			药品id
/// return:			药品id,药品代码,药品描述,父节点id,父节点代码,父节点描述
/// other:			w ##class(web.DHCCKBExportRuleManage).GetDrugInfo(237346)
ClassMethod GetDrugInfo(drugId As %String) As %String
{
	n (drugId)
	
	s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	
	s drugInfo = $lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc)
	
	q drugInfo
}

/// Description:	通过规则id获取规则信息
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			规则id
/// return:			规则id,备注,姓名,状态,唯一码
/// other:			w ##class(web.DHCCKBExportRuleManage).GetRuleInfo(1415872)
ClassMethod GetRuleInfo(ruleId As %String) As %String
{
	n (ruleId)
	
	q:'$d(^CT.CKB.PDSS.RuleD(ruleId)) $lb(ruleId,"","","","","delete")
	
	s rmark = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),2)	// 备注
	s rname = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),3)	// 姓名
	s rstatus = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),4)	// 状态
	s runique = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),5)	// 唯一标识码
	s ruleOpStat= ""
	i ($d(^CKB.PDSS.RuleLogI("Rule",ruleId)))&('$d(^CT.CKB.PDSS.RuleD(ruleId))) s ruleOpStat="delete" // 有日志,没有具体规则,则认为是删除 
	s ruleInfo = $lb(ruleId,rmark,rname,rstatus,runique,ruleOpStat)
	
	q ruleInfo
}

/// Description:	通过规则id获取药品信息
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			规则id
/// return:			药品id,药品代码,药品描述,父节点id,父节点代码,父节点描述
/// other:			w ##class(web.DHCCKBExportRuleManage).GetDrugByRule(237346)
ClassMethod GetDrugByRule(ruleId As %String) As %String
{
	n (ruleId)
	
	s drugData = ##class(web.DHCCKBCommon).GetDrugData()		// 西药
	s chinaData = ##class(web.DHCCKBCommon).GetChineseDrugData()	// 中药
	s chHMData = ##class(web.DHCCKBCommon).GetChineseHMData()		// 草药
	s prescCopeData= ##class(web.DHCCKBCommon).PrescriptionCopeData()	// 处方应付	
	s generalFromData = ##class(web.DHCCKBCommon).GetGeneralFromData()	//带剂型的通用名字典
	s dataList = $lb(drugData,chinaData,chHMData,prescCopeData,generalFromData)
	
	s drugId = ""
	f i=1:1:$listlength(dataList)  q:drugId'=""  d
	.s dataId = $listget(dataList,i)
	.q:'$d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",+ruleId,+dataId))
	.s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,dataId,""))	
	.s drugId = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicId)),3)
	
	s drugInfo = ""
	i drugId'=""  d
	.s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	.s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	.s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	.s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	.s drugInfo = $lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc)
	
	q drugInfo
}

/// Description:	通过规则id获取目录id
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			规则id
/// return:			目录id,目录代码,目录描述,父节点id,父节点代码,父节点描述
/// other:			w ##class(web.DHCCKBExportRuleManage).GetLibaryByRule(278010)
ClassMethod GetLibaryByRule(ruleId As %String) As %String
{
	n (ruleId)
	
	s libaryId = ""
	s drugLibaryData = ##class(web.DHCCKBCommon).GetDrugLibaryData()
	q:'$d(^CT.CKB.PDSS.RuleDicI("RuleParentDic",+ruleId,+drugLibaryData)) ""
	s ruleDicId = $o(^CT.CKB.PDSS.RuleDicI("RuleParentDic",ruleId,drugLibaryData,""))	
	s libaryId = $lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicId)),3)	
	
	s libaryInfo = ""
	i libaryId'=""  d
	.s libaryCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libaryId)),2)
	.s libaryDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libaryId)),3)
	.s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+libaryId)),4)
	.s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	.s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	.s libaryInfo = $lb(libaryId,libaryCode,libaryDesc,parref,parrefCode,parrefDesc)
	
	q libaryInfo
}

/// Description:	判断当前的规则状态(新增,修改,删除,取消发布)
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			规则id
/// return:			
/// other:			w ##class(web.DHCCKBExportRuleManage).CheckRuleStatus(237346)
ClassMethod CheckRuleStatus(stDate, endDate, ruleId As %String) As %String
{
	n (stDate, endDate, ruleId)
	
	/* 开始时间之前,有日志,且没删除,且规则为发布状态, 认为是修改 */
	/* 开始时间之前,没有日志, 无论规则是否发布, 认为是新增 */
	/* 时间段内有日志,没有具体规则,则认为是删除 */
}

/// Description:	获取规则明细,拼成保存的json串
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			规则id,rmarkFlag(是否需要记录字典数据,用于区分规则保存和导出)
/// return:			规则json串
/// other:			w ##class(web.DHCCKBExportRuleManage).GetRuleObj(1)
ClassMethod GetRuleObj(opStatus, ruleId, rmarkFlag = "N") As %String
{
	n (opStatus,ruleId,rmarkFlag)
	
	q:($d(^CKB.PDSS.RuleLogI("Rule",ruleId)))&('$d(^CT.CKB.PDSS.RuleD(ruleId))) ""
	
	s ruleObj = ##class(DHCNewPro.COM.Object).%New()	
	s ruleObj.if = ..GetIfObj(opStatus,ruleId,rmarkFlag)
	s ruleObj.then = ..GetOutObj(opStatus, ruleId, "then",rmarkFlag)
	s ruleObj.else = ..GetOutObj(opStatus, ruleId, "else",rmarkFlag)
	s ruleObj."_name" = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),3)	// 规则名称
	s ruleObj.remark = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),2)	// 备注
	s ruleObj.status = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),4)	// 状态(存储时不需要使用)
	s ruleObj.uniqeIdentity = $lg($g(^CT.CKB.PDSS.RuleD(+ruleId)),5)	// 唯一标识(存储时不需要使用)
	s outPutObj = ##class(DHCNewPro.COM.Object).%New()	
	s outPutObj.rule = ruleObj
	q outPutObj.ToJSON()
}

/// Description:	获取if区域json串
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			规则id
/// return:			规则json串
/// other:			w ##class(web.DHCCKBExportRuleManage).GetIfObj("add",61467)
ClassMethod GetIfObj(opStatus, ruleID, rmarkFlag) As %String
{
	n (opStatus,ruleID, rmarkFlag)
	q:ruleID="" ""
	q:'$d(^CT.CKB.PDSS.RuleNodeI("Parent",ruleID)) "" 
	s parent = 0
	s ruleNodeID = ""
	f  s ruleNodeID = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleID,"if",parent,ruleNodeID))  q:ruleNodeID=""  d
	.s condition = 	$lg($g(^CT.CKB.PDSS.RuleNodeD(+ruleNodeID)),3)
	.s condObj = ..GetConditonObj(opStatus, ruleID, ruleNodeID,rmarkFlag)
	.s ifObj = ##class(DHCNewPro.COM.Object).%New()
	.d ifObj.Set(condition,condObj)
	
	q ifObj
}

/// Description:	获取节点json串
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			规则id, nodeID
/// return:			规则明细json串 
/// other:			w ##class(web.DHCCKBExportRuleManage).GetConditonObj(1)
ClassMethod GetConditonObj(opStatus, ruleID, parentNodeID, rmarkFlag) As %String
{
	n (opStatus, ruleID, parentNodeID,rmarkFlag)
	s condObj = ##class(DHCNewPro.COM.Object).%New()
	s atomArr = ..GetAtomObj(opStatus, parentNodeID,rmarkFlag)
	i (atomArr.Size() <=1 ) d
	.s condObj.atom = atomArr.Get(0)
	e  d 
	.s condObj.atom = atomArr

	q:'$d(^CT.CKB.PDSS.RuleNodeI("Parent",ruleID,"if",parentNodeID)) condObj
	s conditionAndArr = ##class(DHCNewPro.COM.Array).%New()
	s condictionOrArr = ##class(DHCNewPro.COM.Array).%New()
	s condictionUnionArr = ##class(DHCNewPro.COM.Array).%New()
	s ruleNodeID = ""	// 循环节点
	f  s ruleNodeID = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleID,"if",parentNodeID,ruleNodeID)) q:ruleNodeID=""  d
	.s condition = 	$lg($g(^CT.CKB.PDSS.RuleNodeD(+ruleNodeID)),3)	
	.s tmpConObj =	..GetConditonObj(opStatus, ruleID, ruleNodeID,rmarkFlag)
	.i condition="and" d conditionAndArr.Push(tmpConObj)
	.i condition="or" d condictionOrArr.Push(tmpConObj)
	.i condition="union" d condictionUnionArr.Push(tmpConObj)
	.//d condObj.Set(condition,tmpConObj)
	
	// and
	i conditionAndArr.Size()=1 d
	.d condObj.Set("and",conditionAndArr.Get(0))
	i conditionAndArr.Size()>1 d
	.d condObj.Set("and",conditionAndArr)
	
	//or 
	i condictionOrArr.Size()=1 d
	.d condObj.Set("or",condictionOrArr.Get(0))
	i condictionOrArr.Size()>1 d
	.d condObj.Set("or",condictionOrArr)
	
	// union
	i condictionUnionArr.Size()=1 d
	.d condObj.Set("union",condictionUnionArr.Get(0))
	i condictionUnionArr.Size()>1 d
	.d condObj.Set("union",condictionUnionArr)
	
	q condObj
}

/// Description:	获取node中json串
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			nodeID
/// return:			规则明细json串 {}
/// other:			w ##class(web.DHCCKBExportRuleManage).GetAtomObj(1415872)
ClassMethod GetAtomObj(opStatus, nodeID, rmarkFlag) As %String
{
	n (opStatus, nodeID,rmarkFlag)
	
	s atomArr = ##class(DHCNewPro.COM.Array).%New()
	s ruleDataID = ""
	f  s ruleDataID = $o(^CT.CKB.PDSS.RuleDataI("Node",nodeID,ruleDataID)) q:ruleDataID=""  d
	./* left */
	.s leftObj = ##class(DHCNewPro.COM.Object).%New()
	.s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),4)
	.s leftDicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+leftDic)),3)
	.s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),5)
	.s leftValueDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+leftValue)),3)
	.s leftType = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),6)
	.i (leftDic'="")&&(leftValue'="") d
	..s leftObj."_varCategoryId" = leftValue
	..s leftObj."_varLabel" = leftDicDesc
	..s leftObj."_varCategory" = leftValueDesc
	..s leftObj."_var" = leftDic
	.e  d
	..s leftObj."_varCategoryId" = ""
	..s leftObj."_varLabel" = ""
	..s leftObj."_varCategory" = leftDicDesc
	..s leftObj."_var" = leftDic
	.
	.s leftObj."_type" = leftType
	.s leftObj."_datatype" = "String"
	.s leftObj."_ruleData" = $case(opStatus="add",1:0,:ruleDataID)
	.b:ruleDataID=6241480 ;41
	.i rmarkFlag="Y" d  
	..d ..RememberDicInfo(leftDic)	// 记录属性和属性值,防止字典值是新增,项目上没有此值 
	..d ..RememberDicInfo(leftValue)	
	./* value */
	.s valueObj = ##class(DHCNewPro.COM.Object).%New()
	.s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),8)
	.s rightDicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+rightDic)),3)
	.s rightVale = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),9)
	.s rightType = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),10)
	.s rightExt = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),11)
	.s rightLimit = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),12)
	.s valueObj."_const-category" =  rightDic	
	.s valueObj."_const" =  rightDic
	.s valueObj."_const-label" = rightDicDesc
	.s valueObj."_type" = rightType
	.s valueObj."_content" = rightVale	// 文本值/下限
	.s valueObj."_limit" = rightLimit	// 上限
	.s valueObj."_uom" = rightExt		// 单位
	.s valueObj."_ruleData" =  $case(opStatus="add",1:0,:ruleDataID)
	.b:ruleDataID=6241480 ;43
	.i rmarkFlag="Y" d 
	..d ..RememberDicInfo(rightExt)	// 记录属性和属性值,防止字典值是新增,项目上没有此值 
	..i rightType="Constant"  d ..RememberDicInfo(rightDic)	
	.b:ruleDataID=6241480 ;44
	./*atom*/
	.s atomObj = ##class(DHCNewPro.COM.Object).%New()
	.s atomObj.left = leftObj
	.s atomObj.value = valueObj
	.s atomObj."_op" = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),7)
	.d atomArr.Push(atomObj)
	
	q atomArr
}

/// Description:	获取else区域中的json串
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			规则id,类型
/// return:			规则json串
/// other:			w ##class(web.DHCCKBExportRuleManage).GetOutObj(1)
ClassMethod GetOutObj(opStatus, ruleID, type, rmarkFlag) As %String
{
	n (opStatus, ruleID, type, rmarkFlag)
	
	s atomArr = ##class(DHCNewPro.COM.Array).%New()
	s parent = 0
	s ruleNodeID = ""
	f  s ruleNodeID = $o(^CT.CKB.PDSS.RuleNodeI("Parent",ruleID,type,parent,ruleNodeID))  q:ruleNodeID=""  d
	.d atomArr.Push(..GetOutValueObj(opStatus, ruleNodeID,rmarkFlag))
	
	s elseObj = ##class(DHCNewPro.COM.Object).%New()
	
	i atomArr.Size()<=1 d
	.i atomArr.Size()'=0 d 
	..s elseObj."var-assign" = atomArr.Get(0)
	e  d
	.s elseObj."var-assign" = atomArr
	
	q:elseObj.ToJSON()="{}" ""
	q elseObj
}

/// Description:	获取else规则明细obj串
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			nodeID
/// return:			{{value:{}}
/// other:			w ##class(web.DHCCKBExportRuleManage).GetElseValueObj(1415872)
ClassMethod GetOutValueObj(opStatus, nodeID, rmarkFlag) As %String
{
	n (opStatus, nodeID,rmarkFlag)	
	
	s ruleDataID = $o(^CT.CKB.PDSS.RuleDataI("Node",nodeID,""))
	//f  s ruleDataID = $o(^CT.CKB.PDSS.RuleDataI("Node",nodeID,ruleDataID)) q:ruleDataID=""  d
	s leftDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),4)
	s leftDicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+leftDic)),3)
	s leftValue = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),5)
	s leftValueDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+leftValue)),3)
	s leftType = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),6)
	/*atom*/
	s atomObj = ##class(DHCNewPro.COM.Object).%New()
	s atomObj."_varCategoryId" = leftValue
	s atomObj."_varCategory" = leftValueDesc
	s atomObj."_var" = leftDic
	s atomObj."_varLabel" = leftDicDesc
	s atomObj."_type" = leftType
	s atomObj."_datatype" = "String"
	s atomObj."_ruleData" = $case(opStatus="add",1:0,:ruleDataID)
	i rmarkFlag="Y" d
	.d ..RememberDicInfo(leftDic)	// 记录属性和属性值,防止字典值是新增,项目上没有此值 
	.d ..RememberDicInfo(leftValue)	
	/* value */
	s valueObj = ##class(DHCNewPro.COM.Object).%New()
	s rightDic = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),8)
	s rightDicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+rightDic)),3)
	s rightVale = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),9)
	s rightType = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),10)
	s rightExt = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),11)
	s rightLimit = $lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),12)
	s valueObj."_const-category" =  rightDic	
	s valueObj."_const" =  rightDic
	s valueObj."_const-label" = rightDicDesc
	s valueObj."_type" = rightType
	s valueObj."_content" = rightVale	// 文本值/下限
	s valueObj."_limit" = rightLimit	// 上限
	s valueObj."_uom" = rightExt		// 单位
	s valueObj."_ruleData" =  $case(opStatus="add",1:0,:ruleDataID)
	i rmarkFlag="Y" d
	.d ..RememberDicInfo(rightExt)	// 记录属性和属性值,防止字典值是新增,项目上没有此值 
	.i rightType="Constant"  d
	..d ..RememberDicInfo(rightDic)	
	
	s atomObj.value = valueObj	
				
	q atomObj
}

/// Description:	获取导出数据的版本
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			
/// return:			版本(医院全拼+日期)	
/// other:			w ##class(web.DHCCKBExportRuleManage).GetVersion("哈医大")
ClassMethod GetVersion(logo, hosp As %String) As %String
{
	n (logo,hosp)
	
	q "["_logo_"]"_##class(web.DHCCKBCommonUtil).GetCNCODE(hosp,3)_","_$h
}

/// Description:	获取导出数据的路径
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-07	
/// Input:			
/// return:			路径	
/// other:			w ##class(web.DHCCKBExportRuleManage).GetUpdatePath()
ClassMethod GetUpdatePath()
{
	s globalDir = "\temp\global\"	
	
	s phyDir = ##class(ext.util.String).GetPhysicalPath("",globalDir)
	i '##class(%File).DirectoryExists(phyDir) d
	.d ##class(%File).CreateDirectory(phyDir)
	
	q phyDir
}

/// Description:： 判断药品是否被医院的药品对照过
/// Creator：      qunianpeng
/// CreatDate：    2021-06-07
/// Input:		   系统代码,系统描述,医院描述
/// Return:			Y 对照过, N 未对照
/// w ##class(web.DHCCKBExportRuleManage).IsContrastFlag()
ClassMethod IsContrastFlag(code, desc, hospDesc)
{
	n (code, desc, hospDesc)
	
	s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hospDesc),""))
	//q:$d(^DHCCKBCC(0,"Hospital",$$UPPER^SSUTIL4(+hospId))) "Y"
	
	s ret = "N"
	s hisCode = ""
	f   s hisCode = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(code),hisCode)) q:(hisCode="")||(ret="Y")  d
	.s constId = ""
	.f  s constId = $o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(code),hisCode,constId)) q:(constId="")||(ret="Y")   d
	..s hisDesc = $lg(^CKB.PDSS.ComContrastD(+constId),5)
	..s flag = ##class(web.DHCCKBComContrast).CheckFlag(hisCode,hisDesc,+hospId)
	..s:flag=1 ret="Y"
	
	q ret
}

/// Description:	保存规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			药品id_"^"_目录id,用户信息,复制规则id
/// return:			
/// other:			w ##class(web.DHCCKBExportRuleManage).SaveRule("150^72",13923,"13923^1^1^339^2",237329)
ClassMethod SaveRule(dicStr, userId, loginInfo, copyRuleID) As %String
{
	n (dicStr, userId, loginInfo ,copyRuleID)
	s opStatus = "add"
	s status = ""
	s root = ..GetRuleObj(opStatus,copyRuleID)
	s ret=##class(web.DHCCKBRuleSave).save(0,status,root,userId,dicStr,loginInfo)
	
	i ret>0 d	
	.s status = "Release"
	.s opStatus = ""
	.s root = ..GetRuleObj(opStatus,ret)
	.s ret=##class(web.DHCCKBRuleSave).save(ret,status,root,userId,dicStr,loginInfo)
	
	q ret
	
	// ret<=0 失败 新生成的ruleId
}

/// Description:	记录新增的字典数据
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-25	
/// Input:			字典数据id
/// return:			
/// other:			w ##class(web.DHCCKBExportRuleManage).RememberDicInfo("150")
ClassMethod RememberDicInfo(dicId As %String) As %String
{
	n (dicId)
	q:+dicId=0 ""
	s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),2)
	s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),3)
	s parrefDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),4)
	s dicLinkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),5)
	
	if (parrefDr="")&&(dicLinkDr="") d
	.s knowTypePropId = ##class(web.DHCCKBCommon).GetKnowType()
	.s attrRowID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicId,knowTypePropId,""))
	.s knowDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+attrRowID)),4)
	.s knowCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+knowDr)),2)
	.s knowDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+knowDr)),3)	
	.s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dataType",dicId) =  dicId_"^"_dicCode_"^"_dicDesc_"^"_parrefDr_"^"_knowCode_"^"_knowDesc
	
	s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","dic",dicId) =  dicId_"^"_dicCode_"^"_dicDesc_"^"_parrefDr
	i parrefDr'=""  d
	.s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","parref",dicId,parrefDr) = "" 
	.d ..RememberDicInfo(parrefDr)
	i dicLinkDr'=""  d
	.s ^TMPExportDrugRule("web.DHCCKBExportRuleManage","newData","linkDr",dicId,dicLinkDr) = "" 
	.d ..RememberDicInfo(dicLinkDr) 
	
	q ""
}

/// Input:          GlobalName - global名字, FilePath - D:\\EEEE.gbl 
/// W ##Class(web.DHCCKB.Util.UtilService).ImportGlobal("", "")
/// w ##class(web.DHCCKBExportRuleManage).ImportGlobal()
ClassMethod ImportGlobal()
{
	k ^TmpDDDDHHH

	w ##Class(web.DHCCKB.Util.UtilService).ImportGlobal("TmpDDDDHHH", "D:\dthealth\app\dthis\web\temp\global\HAYIDA,65902,76620.gof")  //导出global文件
	
	q ""
}

/// Descript:判断是否存在选择的规则
/// Input：ruleId:规则id,nodeList:规则id串
/// Output:1:存在，0：不存在
/// w ##class(web.DHCCKBExportRuleManage).isExistRule()
ClassMethod isExistRule(ruleId, nodeList)
{
	n (ruleId,nodeList)
	s existFlag = 0
	Q:nodeList="" 1
	s len=$l(nodeList,"^")
	for i=1:1:len  Q:existFlag=1  d
	.s tmpRuleId = $p(nodeList,"^",i)
	.Q:ruleId'=tmpRuleId
	.s existFlag = 1
	Q existFlag
}

}
