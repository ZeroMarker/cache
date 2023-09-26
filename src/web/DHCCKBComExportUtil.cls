Import SQLUser

/// Creator:      qunianpeng
/// CreatDate:    2020-09-14
/// Description:  导出工具类
Class web.DHCCKBComExportUtil Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:      qunianpeng
/// CreatDate:    2020-04-16
/// Description:  导出分类
/// Input:		  				catType:全部分类=all,五级分类=five,其他分类other,非五级非其他分类notin, hospID:医院id
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBComExportUtil","ExportDrugCat","other","94","","")
/// w ##Class(websys.Query).ToExcel("CKB_Excel全部分类","web.DHCCKBComExportUtil","ExportDrugCat","all","","")
/// w ##Class(websys.Query).ToExcel("CKB_Excel五级分类","web.DHCCKBComExportUtil","ExportDrugCat","five","","","","")
/// w ##Class(websys.Query).ToExcel("CKB_Excel其他分类","web.DHCCKBComExportUtil","ExportDrugCat","other","","")
/// w ##Class(websys.Query).ToExcel("CKB_Excel非五级非其他分类","web.DHCCKBComExportUtil","ExportDrugCat","notin","2")
Query ExportDrugCat(catType, hospID, ruleUse, input) As websys.Query(ROWSPEC = "f1:%String:1级,f2:%String:2级,f3:%String:3级,f4:%String:4级,f5:%String:5级,f6:%String:6级,f7:%String:7级,f8:%String:8级,f9:%String:9级,f10:%String:10级")
{
}

ClassMethod ExportDrugCatExecute(ByRef qHandle As %Binary, catType As %String, hospID As %String, ruleUse As %String, input As %String) As %Status
{
	
	n (qHandle,catType,hospID,ruleUse,input)

	Set repid=$I(^CacheTemp)	
	Set ind=1

	k TmpArr	
	d ..QueryCatData(.TmpArr,catType,hospID,ruleUse,input)

	Set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.quit:index=""
	.set listData=$g(TmpArr(index))
	.//set listData=$reverse(listData)	// 逆序
	.set listData=..ListReverse(listData)
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Description: 通过类型查询分类
ClassMethod QueryCatData(TmpArr, catType, hospID, ruleUse, input)
{

	n (TmpArr,catType,hospID,ruleUse,input)
	
	s parref=""
 i catType="five" d		// 新编药物学分类
	.s parref=##class(web.DHCCKBCommon).GetDicIdByCode("NewDrugCat")	
	e  i catType="other" d	// 其他分类
	.s parref=##class(web.DHCCKBCommon).GetDicIdByCode("OtherDrugCat")
	e  i catType="notin" d	// 非新编非其他
	.s parref=##class(web.DHCCKBCommon).GetDrugCategoryData()
	e  d	// 全部
	.s parref=##class(web.DHCCKBCommon).GetDrugCategoryData()

	q:+parref=0 ""

	s catID=""
	f  s catID= $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,catID)) q:catID=""  d
	.q:catID=""
	.q:(catType="notin")&((catID=##class(web.DHCCKBCommon).GetDicIdByCode("OtherDrugCat"))||(catID=##class(web.DHCCKBCommon).GetDicIdByCode("NewDrugCat")))
	.d ..GetChildCatData(.TmpArr,catID,hospID,ruleUse,input)
	
	q ""
}

/// Description:获取层次分类的数据
/// other: w ##class(web.DHCCKBComExportUtil).GetChildCatData()
ClassMethod GetChildCatData(TmpArr, itmCatID, hospID, ruleUse, input)
{
	n (TmpArr,itmCatID,hospID,ruleUse,input)
	s hasChildFlag=$d(^CT.CKB.PDSS.CommonDictionI("Parref",+itmCatID))	
	q:itmCatID="" ""	
	q:##class(web.DHCCKBCommon).IsEnabled(itmCatID)=0 "" // 停用
	
	s exitFlag=1
	i ((hospID'="")||(ruleUse="Y"))&(0=..IsUsedByRule(itmCatID)) s exitFlag=0	// 选择了医院或者规则引用标志为Y,则必须要判断规则被引用
	i (hospID'="")&(..IsUseByHospital(itmCatID,hospID)=0)	s exitFlag=0		// 是否指定的医院有引用该分类
	s listCat=""
	d ..GetParentCat(.listCat,itmCatID,exitFlag,input)	// 需要判断规则是否被引用,被哪个医院引用
	i (listCat'="")	d
	.q:(input'="")&($listtostring(listCat)'[input)
	.s TmpArr($i(^TMP("DHCCKB.GetChildCatData")))=listCat
	
	q:hasChildFlag<=0 ""
	s childCat=""
	f  s childCat=$o(^CT.CKB.PDSS.CommonDictionI("Parref",+itmCatID,childCat))	q:childCat=""  d
	.d ..GetChildCatData(.TmpArr,childCat,hospID,ruleUse,input)
	
	q ""
}

/// 获取分类的父分类
/// w ##Class(web.DHCCKBComExportUtil).GetParentCat(.listCat,"98732","94","")
ClassMethod GetParentCat(listCat, itmCatID, exitFlag, input) As %String
{
	n (listCat,itmCatID,exitFlag,input)
		
	q:exitFlag=0 ""
	s itmCatData=..GetDicData(itmCatID)
	s itmCatDesc=$P(itmCatData,"^",2)
	q:itmCatDesc=""
	i $e(itmCatDesc,*)=1 s itmCatDesc=$e(itmCatDesc,1,*-1)	// 2020/8/3 薛工在分类后面暂时加了一个1，需要忽略
	s $LIST(listCat,*+1)=itmCatDesc
	
	s parentCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(+itmCatID)),4)
	// 分类的父类不为空,且不是分类字典时,加入到分类列表
	i (parentCat'="")&(parentCat'=##class(web.DHCCKBCommon).GetDrugCategoryData())  d
	.d ..GetParentCat(.listCat,parentCat,exitFlag,input)	
	
	q ""
}

/// Description: 通过id获取字典的code和desc
/// other: w ##class(web.DHCCKBComExportUtil).GetDicData(78219)
ClassMethod GetDicData(dicID)
{
	n (dicID)
	
	q:dicID="" ""
	//s isShow=##class(web.DHCCKBCommon).IsShow(dicID,"DHC_CKBCommonDiction",loginInfo)
	//q:##class(web.DHCCKBCommon).IsEnabled(dicID)=0 ""	// 停用
	
	s code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),2)
	s desc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)

	s dicData=""
	i code="" d
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),5)
	.if linkDr'="" d
	..s dicData=..GetDicData(linkDr)
	e  d
	.s dicData=code_"^"_desc

	q dicData
}

/// Description: list逆序
/// w ##class(web.DHCCKBComExportUtil).ListReverse()
ClassMethod ListReverse(list)
{
	n (list)

	s len=$listLength(list)
	
	s relist=""
	f i=len:-1:1 d
	.s $list(relist,*+1)=$listget(list,i)
	
	i relist="" s relist=list
	q relist
}

/// Description: 分类是否被规则引用
/// OutPut:						0 没有被引用  1被引用
/// w ##class(web.DHCCKBComExportUtil).IsUsedByRule()
ClassMethod IsUsedByRule(catID)
{
	n (catID)
	
	s ret = 0	
	if $d(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",+catID))	s ret = 1	

	q ret
}

/// Description: 分类是否被指定的医院引用
/// OutPut:						0 没有被引用  1被引用
/// w ##class(web.DHCCKBComExportUtil).IsUseByHospital(98732,94)
ClassMethod IsUseByHospital(catID, hospID)
{
	n (catID,hospID)
	
	q:'$d(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",+catID)) 0
 	q:hospID="" 0

	s ret = 0
	s ruleID = ""
	f  s ruleID=$o(^CT.CKB.PDSS.RuleDataI("RightDic","Constant",+catID,ruleID))	q:(ruleID="")||(ret=1)  d
	.q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID))
	.s drugID=""
	.s dicID=""
	.f  s dicID=$o(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleID,dicID))  q:(dicID="")||(drugID'="")  d
	..s parrefDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),4)
	..q:(parrefDic'=##class(web.DHCCKBCommon).GetDrugData())&(parrefDic'=##class(web.DHCCKBCommon).GetChineseDrugData())	// 中药，西药，全局规则，子规则
	..s drugID=dicID
	.
	.q:drugID=""
	.s drugCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugID)),2)
	.s drugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+drugID)),3)
	.// 是否对照
	.q:'$d(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(drugCode)))&('$d(^CKB.PDSS.ComContrastI("LibDesc",$$UPPER^SSUTIL4(drugDesc))))
	.s hisCode="" // 找到对照数据,过滤外部代码表中的医院
	.f  s hisCode=$o(^CKB.PDSS.ComContrastI("LibCode",$$UPPER^SSUTIL4(drugCode),hisCode))  q:(hisCode="")||(ret=1)   d
	..q:'$d(^CKB.PDSS.ExtDictionI("Code",hospID,hisCode))
	..s ret=1

	q ret
}

/// Creator:      qunianpeng
/// CreatDate:    2020-11-18
/// Description:  导出字典数据
/// Input:		  字典
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportReplaceData")
/// w ##Class(websys.Query).ToExcel("用药频率字典","web.DHCCKBComExportUtil","ExportData","用药频率字典")
Query ExportData(dataCode) As websys.Query(ROWSPEC = "code:%String:代码,desc:%String:描述")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInfoData") 
ClassMethod ExportDataExecute(ByRef qHandle As %Binary, dataCode) As %Status
{
	n (qHandle,dataCode)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	k TmpArr	
	d ..QueryData(dataCode,.TmpArr)

	Set index=""	
	for  set index=$order(TmpArr(index)) quit:index=""  do
	.set listData=$get(TmpArr(index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBExport","ExportDrugInfoData") 
ClassMethod QueryData(dataCode, TmpArr) As %Status
{
	n (dataCode,TmpArr)
	
	s parref = ##class(web.DHCCKBCommon).GetDicIdByDesc(dataCode)
	q:##class(web.DHCCKBCommon).IsEnabled(parref)=0 ""
	s count = 0
	s dicId=""
	f  s dicId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,dicId))  q:dicId=""  d
	.q:##class(web.DHCCKBCommon).IsEnabled(dicId)=0 
	.s count = count +1
	.s dicCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),2)
	.s dicDesc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicId)),3)
	.s TmpArr(count)= $lb(dicCode,dicDesc)
	
	q ""
}

/// Description:	导出指定属性值
/// Creator:		sufan 
/// CreateDate:		2021-12-17	
/// Input:			药品Id串,属性代码
/// return:			
/// w ##class(web.DHCCKBComExportUtil).ExportAttrvalue("703,705,899,963,1116","RuleUsage")
ClassMethod ExportAttrvalue(drugIdStr, attrCode)
{
	n (drugIdStr,attrCode)
	s attrCodeId = ##class(web.DHCCKBCommon).GetDicIdByCode(attrCode)
	s pid = ##class(web.DHCCKBCommonUtil).NewPid()
	s count = 0
	s len = $l(drugIdStr,",")
	for i=1:1:len  d
	.s drugId = $p(drugIdStr,",",i)
	.s attrval = ##class(web.DHCCKBEditProp).QueryAttrValue(drugId,attrCodeId)
	.i attrval = ""  d
	..s id = ""
	..for  s id = $o(^CT.CKB.PDSS.CommonDictionI("Link",attrCodeId,id)) Q:(id="")||(attrval'="")  d
	...s attrCodeId = id
	...s attrval = ##class(web.DHCCKBEditProp).QueryAttrValue(drugId,id)
	.s count = count+1
	.i attrval = "" s ^tempErr(count) = drugId
	.Q:attrval=""
	.s index = drugId_"^"_attrCodeId
	.s ^tempExporData(pid,drugId) = attrval
	b   ///333
	q ""
}

/// Description:	更新指定药品属性
/// Creator:		sufan 
/// CreateDate:		2021-12-17	
/// Input:			药品Id串,属性代码
/// return:			
/// w ##class(web.DHCCKBComExportUtil).UpdateDrugAttr("13566332")
ClassMethod UpdateDrugAttr(pid)
{
	n (pid)
	s index = ""
	s ret = 0
	for  s index = $o(^tempExpornewData9(pid,index))  Q:(index="")||(ret'=0)  d
	.Q:ret'=0
	.s drugId = $p(index,"^",1)
	.s attrId = $p(index,"^",2)
	.s val = ^tempExpornewData9(pid,index)
	.i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,attrId))  d
	..&sql(insert into CT_CKB_PDSS.DicLinkAttr (DLA_Dic_Dr,DLA_AttrCode,DLA_Result) values (:drugId,:attrId,:val))
	..s ret = SQLCODE
	.e  d
	..s dicattrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",drugId,attrId,""))
	..s result = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(dicattrId)),5)
	..i result = "" d
	...&sql(update CT_CKB_PDSS.DicLinkAttr set DLA_Result=:val where DLA_RowID=:dicattrId)
	...s ret = SQLCODE
	Q ret
}

}
