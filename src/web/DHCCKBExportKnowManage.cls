/// Description:	知识导出管理类
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
Class web.DHCCKBExportKnowManage Extends %RegisteredObject [ ClassType = "", Not Final, Not ProcedureBlock ]
{

/// Description:	导出知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09	
/// Input:			开始日期,结束日期,用户id, 医院描述, 选择的药品列表, 字典id
/// return:		
/// other:			w ##class(web.DHCCKBExportKnowManage).ExportKnow("","","11871","广西壮族自治区南溪山医院","","105")
ClassMethod ExportKnow(stDate As %String, endDate As %String, userId As %String, hospDesc As %String, drugList As %String = "", dataId As %String = "") As %String
{
	n (stDate, endDate, userId, hospDesc, drugList, dataId)
	
	k ^TMPExportDrugKnow
	s stDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(stDate)	
	s endDate = ##class(web.DHCCKBCommonUtil).DateHtmlToLogical(endDate)
	s:endDate="" endDate = +$h
	s curDate = endDate-stDate
	s filter = $case(hospDesc'="",1:"Y",:"N") // 是否需要根据医院已经对照的药品进行过滤
	
	/* 选择药品更新 */	 // 日期、药品列表、字典 单选模式
	if (drugList'="")  d	
	.s filter = "N"	// 是否需要根据医院已经对照的药品进行过滤
	.d ..GetKnowBySelectDrug(hospDesc,drugList,filter)
	
	/* 直接更新某个字典的知识,如中药饮片,成分的知识 */
	else  if (dataId'="")  d
	.d ..GetKnowByDataId(hospDesc,filter,dataId)	
	
	/* 获取版本 */
	s version = ##class(web.DHCCKBExportRuleManage).GetVersion("know",hospDesc)
	
	/* 获取路径 */
	s pathDir = ##class(web.DHCCKBExportRuleManage).GetUpdatePath()
	s path = pathDir_version_".gof"
	
	/* 导入global文件 */
	d ##Class(web.DHCCKB.Util.UtilService).ExportGlobal("TMPExportDrugKnow", path)  //导出global文件

	/* 存储日志 */	
	d ##Class(web.DHCCKBUpdateManage).SaveUpdateLog(stDate, endDate, userId, path, "know", "out", hospDesc, version)	

	q "dhctt.file.csp?act=download&filename="_version_"&dirname="_path
}

/// Description:	通过选择的药品id,获取该医院的更新知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09	
/// Input:			医院描述, 药品列表, 过滤器(是否根据医院过滤)
/// return:		
/// other:			w ##class(web.DHCCKBExportKnowManage).GetKnowBySelectDrug(hospDesc, drugList,filter)
ClassMethod GetKnowBySelectDrug(hospDesc As %String, drugList As %String, filter As %String) As %String
{
	n (hospDesc, drugList, filter)			

	k TmpDrugArr	
	s drugList = $listfromstring(drugList,"^")
	d ##class(web.DHCCKBCommonUtil).ListToArr(drugList,.TmpDrugArr)
	
	s drugId = ""
	f  s drugId = $o(TmpDrugArr(drugId))  q:drugId=""   d
	.d ..GetKnowByDrug(hospDesc, filter,drugId)
	
	q ""
}

/// Description:	通过药品 找到药品下的所有知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09	
/// Input:			 医院描述, 药品列表
/// return:		
/// other:			w ##class(web.DHCCKBExportKnowManage).GetKnowByDrug("","N","96141")
ClassMethod GetKnowByDrug(hospDesc, filter, drugId) As %String
{
	n (hospDesc, filter,drugId)
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",drugId))
	s drugInfo = ..GetDrugInfo(drugId)	
	s drugCode = $lg(drugInfo,2)
	s drugDesc = $lg(drugInfo,3)
	q:(filter="Y")&&(hospDesc'="")&&("N"=##class(web.DHCCKBExportRuleManage).IsContrastFlag(drugCode,drugDesc,hospDesc)) ""
	
	d ..RememberDicInfo(drugId)
	s attrCode = ""
	f  s attrCode = $o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",drugId,attrCode))  q:attrCode=""  d
	.s ^tempsst($h)=attrCode
	.d ..RememberDicInfo(attrCode)
	.s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId) = drugInfo
	.s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId,attrCode) = ""
	.s dlaRowID = "",count = 0
	.f  s dlaRowID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,attrCode,dlaRowID))  q:dlaRowID=""  d
	..s count = count + 1
	..s valueType = "", markValue = ""
	..s value = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+dlaRowID)),4)
	..i value'="" d
	...s valueType = "diction"
	...s markValue = value
	...d ..RememberDicInfo(value) // 记录字典值
	..s result = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+dlaRowID)),5)
	..i result'="" d
	...s valueType = "string"
	...s markValue = result
	..s group = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+dlaRowID)),6)
	..i markValue'="" s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","drug",drugId,attrCode,"value",count) = $lb(valueType,markValue,group)
	..i group'=""  s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","group",drugId,group,attrCode) =  $lb(valueType,markValue,group)

	q ""
}

/// Description:	通过药品id获取药品信息
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09
/// Input:			药品id
/// return:			药品id,药品代码,药品描述,父节点id,父节点代码,父节点描述
/// other:			w ##class(web.DHCCKBExportKnowManage).GetDrugInfo(237346)
ClassMethod GetDrugInfo(drugId As %String) As %String
{
	n (drugId)
	q:+drugId=0 ""
		
	s drugInfo = ""
	s drugCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),2)
	s drugDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),3)
	s parref = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	s parrefCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),2)
	s parrefDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),3)
	s drugInfo = $lb(drugId,drugCode,drugDesc,parref,parrefCode,parrefDesc)
	
	q drugInfo
}

/// Description:	记录新增的字典数据
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09	
/// Input:			字典数据id
/// return:			
/// other:			w ##class(web.DHCCKBExportKnowManage).RememberDicInfo("125844")
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
	.s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","dataType",dicId) =  dicId_"^"_dicCode_"^"_dicDesc_"^"_parrefDr_"^"_knowCode_"^"_knowDesc

	s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","dic",dicId) =  dicId_"^"_dicCode_"^"_dicDesc_"^"_parrefDr
	
	i parrefDr'=""  d
	.s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","parref",dicId,parrefDr) = "" 
	.d ..RememberDicInfo(parrefDr)
	i dicLinkDr'=""  d
	.s ^TMPExportDrugKnow("web.DHCCKBExportKnowManage","newData","linkDr",dicId,dicLinkDr) = "" 
	.d ..RememberDicInfo(dicLinkDr) 
	
	q ""
}

/// Description:	通过字典直接更新某个字典的知识，如中药饮片知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-09	
/// Input:			
/// return:		
/// other:			w ##class(web.DHCCKBExportKnowManage).GetKnowByDataId()
ClassMethod GetKnowByDataId(hospDesc, filter, dataId As %String) As %String
{
	n (hospDesc,filter,dataId)			
	q:dataId="" ""
	
	s dicId = ""
	f  s dicId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",dataId,dicId))	q:dicId=""  d
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",dicId))
	.q:##class(web.DHCCKBCommon).IsEnabled(dicId)=0
	.d ..GetKnowByDrug(hospDesc,filter,dicId)
		
	q ""
}

}
