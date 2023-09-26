Import SQLUSER

/// Descript:导出处方审核结果
/// Creator:sufan
/// CreateDate:2021-11-08
Class web.DHCCKBAuditResultExport Extends %RegisteredObject
{

/// Descript:导出处方审核结果
/// Creator:sufan
/// CreateDate:2021-11-08
/// Input:开始日期，结束日期，医院，目录
/// w ##Class(websys.Query).ToExcel("导出结果","web.DHCCKBAuditResultExport","ExportAuditRes","2022-05-25","2022-05-25","","")
/// w ##Class(websys.Query).ToExcel("禁忌症","web.DHCCKBAuditResultExport","ExportAuditRes","2021-11-01","2021-11-10","","禁忌症")
/// w ##Class(websys.Query).ToExcel("药物过敏","web.DHCCKBAuditResultExport","ExportAuditRes","2021-11-01","2021-11-10","","药物过敏")
/// w ##Class(websys.Query).ToExcel("重复用药","web.DHCCKBAuditResultExport","ExportAuditRes","2021-11-01","2021-11-07","","重复用药")
/// w ##Class(websys.Query).ToExcel("日志数据","web.DHCCKBAuditResultExport","ExportAuditRes","2021-11-01","2021-11-10","","相互作用")
/// w ##Class(websys.Query).ToExcel("日志数据","web.DHCCKBAuditResultExport","ExportAuditRes","2021-11-10","2021-11-10","","相互作用")
/// d ##class(%ResultSet).RunQuery("web.DHCCKBAuditResultExport","ExportAuditRes","2021-11-10","2021-11-10","","相互作用") 
Query ExportAuditRes(stDate, endDate, hosp, cat) As websys.Query(ROWSPEC = "f1:%String:姓名,f2:%String:性别,f3:%String:出生日期,f4:%String:体重,f5:%String:过敏原,f6:%String:诊断,f7:%String:药品名称,f8:%String:单次剂量,f9:%String:单位,f10:%String:剂型,f11:%String:给药途径,f12:%String:频次,f13:%String:疗程,f14:%String:目录,f15:%String:项目,f16:%String:级别,f17:%String:审查结果,f18:%String:触发次数,f19:%String:触发总次数")
{
}

ClassMethod ExportAuditResExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, hosp As %String, cat As %String) As %Status
{

	Set repid=$I(^CacheTemp)	
	Set ind=1
	Q:(stDate="")||(endDate="") $$$OK
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	k TmpArr	
	d ..QueryAuditDatanew(.TmpArr,stDate,endDate,hosp,cat)
	
	s ordNum = ""
	for  s ordNum = $o(TmpArr(ordNum),-1)  Q:ordNum=""  d
	.s itmIndex=""	
	.for  set itmIndex = $order(TmpArr(ordNum,itmIndex)) quit:itmIndex=""  do
	..quit:itmIndex=""
	..s index = ""
	..for  s index = $o(TmpArr(ordNum,itmIndex,index),-1)  Q:index=""  d
	...s numindex = ""
	...for  s numindex = $o(TmpArr(ordNum,itmIndex,index,numindex))  Q:numindex=""  d
	....set listData=$g(TmpArr(ordNum,itmIndex,index,numindex))_"^"_ordNum
	....//set listData=$reverse(listData)	// 逆序
	....set ^CacheTemp(repid,ind)=$listfromstring(listData,"^")
	....set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// w ##class(web.DHCCKBAuditResultExport).QueryAuditData(.TmpArr,66058,66058,"","")
ClassMethod QueryAuditData(TmpArr, stDate, endDate, hosp, cat)
{
	
	k ParamArr
	k queTmpArr
	k itmTmpArr
	for date = stDate:1:endDate  d
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("DatePass",date,"0",monId))  Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s exaParam = $lg(monData,9)				//入参
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	../*患者信息*/
	..s patName = exaParamObj.PatName
	..s:patName="" patName="门诊"
	..s episodeID = exaParamObj.EpisodeID
	..s patientID = $p($g(^PAADM(+episodeID)),"^",1)
	..s patNo = $p($g(^PAPER(+patientID,"PAT",1)),"^",1)  /// 登记号
	..s sex = exaParamObj.SexProp
	..s age = exaParamObj.AgeProp
	..s weight = exaParamObj.Weight
	..s patInfo = patName_"^"_sex_"^"_age_"^"_weight
	../*取过敏信息*/
	..s hisAllergyList = ""
	..s hisAllergyArr = exaParamObj.%Get("HisAllergy")
	..s lenaller = hisAllergyArr.%Size()
	..for i=0:1:lenaller-1  d
	...s allergyObj = hisAllergyArr.%Get(i)
	...s allergy = allergyObj.item
	...i hisAllergyList="" s hisAllergyList = allergy
	...e  s hisAllergyList = hisAllergyList_";"_allergy
	../*取诊断信息*/
	..s diagList = ""
	..s diagArr = exaParamObj.%Get("Disease")
	..s diagLen = diagArr.%Size()
	..for j=0:1:diagLen-1  d
	...s diagObj = diagArr.%Get(j)
	...s diag = diagObj.item
	...i diagList="" s diagList = diag
	...e  s diagList = diagList_";"_diag
	..s outParam = $lg(monData,10) 			//结果
	..s hosp = $lg(monData,12)
	..s subItmId = ""
	..for  s subItmId = $o(^CKB.PDSS.MonQueListI("Parref",monId,subItmId))  Q:subItmId=""  d
	...s monData = $g(^CKB.PDSS.MonQueListD(subItmId))
	...s itmId = $lg(monData,3) //药品Id
	...s catId = $lg(monData,4) //目录Id
	...s proId = $lg(monData,5)	//属性Id
	...s levId = $lg(monData,7)	//级别Id
	...Q:levId=""
	...s drugDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+itmId),3)				//药品名称
	...s funDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+proId),3)				//属性
	...s catDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+catId),3)				//目录
	...Q:(cat'="")&&(catDesc'=cat)
	...s levCode = $lg(^CT.CKB.PDSS.CommonDictionD(+levId),2)				//级别代码
	...s levDesc = $lg(^CT.CKB.PDSS.CommonDictionD(+levId),3)				//级别描述
	...Q:levCode'="warn"
	...s rulelist = ..Getrule(monId,itmId,catId)
	...s rulelen = $l(rulelist,"^")
	...Q:rulelen=0
	...s drugList = ..GetInParam(drugDesc,exaParamObj)
	...s hisDrugName = $p(drugList,"^",1)
	...s drugOutParam = ..GetExeOutParam(outParam, drugDesc, catDesc,funDesc)    //获取审查结果
	...b:hisDrugName="培哚普利吲达帕胺片/百普乐[4:1.25mg*7片]"   //33 
	...s drugOutParam = $tr(drugOutParam,",","，")
	...s drugOutParam = $tr(drugOutParam,$c(13),"")
	...s drugOutParam = $tr(drugOutParam,$c(10),"")
	...s drugOutParam = $replace(drugOutParam,"：",":")
	...for k = 1:1:rulelen  d
	....s ruleId = $p(rulelist,"^",k)
	....;b   //44
	....s paramindex = itmId _"^"_ruleId
	....b:hisDrugName="培哚普利吲达帕胺片/百普乐[4:1.25mg*7片]"   //33
	....s listData = patInfo_"^"_hisAllergyList_"^"_diagList_"^"_drugList_"^"_catDesc_"^"_funDesc_"^"_levDesc_"^"_drugOutParam_"^"_1
	....i $d(queTmpArr(itmId,paramindex))  d
	.....b:hisDrugName="培哚普利吲达帕胺片/百普乐[4:1.25mg*7片]"   //33  ///333
	.....s $p(queTmpArr(itmId,paramindex),"^",18) = $p(queTmpArr(itmId,paramindex),"^",18)+1
	....e  d
	.....s queTmpArr(itmId,paramindex) = listData
	....i $d(itmTmpArr(itmId))  d
	.....s itmTmpArr(itmId) = itmTmpArr(itmId)+1
	....e  d
	.....s itmTmpArr(itmId) = 1
	
	s itmdrugId = ""
	for  s itmdrugId = $o(queTmpArr(itmdrugId))  Q:itmdrugId=""  d
	.s itmindex = ""
	.for  s itmindex = $o(queTmpArr(itmdrugId,itmindex))  Q:itmindex=""  d
	..s num = $p(queTmpArr(itmdrugId,itmindex),"^",18)
	..s ordindex = itmindex
	..s totnum = $g(itmTmpArr(itmdrugId))
	..s TmpArr(totnum,itmdrugId,num,ordindex) = queTmpArr(itmdrugId,itmindex)
	Q ""
}

/// Descript:获取触发的规则
/// w ##class(web.DHCCKBAuditResultExport).Getrule(3122036,103710,76)
ClassMethod Getrule(monId, itmId, catId)
{
	s monruleId = ""
	s rulelist=""
	for  s monruleId = $o(^CKB.PDSS.MonRuleListI("Parref",monId,monruleId))  Q:monruleId=""  d
	.s ruleId = $lg(^CKB.PDSS.MonRuleListD(monruleId),3)
	.Q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,catId))
	.Q:'$d(^CT.CKB.PDSS.RuleDicI("RuleDic",ruleId,itmId))
	.i rulelist = "" s rulelist = ruleId
	.e  s rulelist = rulelist_"^"_ruleId
	Q rulelist
}

ClassMethod GetExeOutParam(outParam, drugName, cat, itmDesc = "", seqNo = "")
{
	s outParamObj = ##class(%DynamicArray).%FromJSON(outParam)
	s itemsArr = outParamObj.items
	s length = itemsArr.%Size()
	s msg = ""
	for i=0:1:length-1  d
	.s itmsObj = itemsArr.%Get(i)
	.s libItem = itmsObj.libitem
	.s hisItem = itmsObj.item
	.Q:(libItem'=drugName)
	.;Q:(hisDrug=hisItem)&(seqNo'=itmsObj.seqno) // 增加过滤条件 qnp 2020/12/18 
	.s warnArr = itmsObj.warns
	.s warnLen = warnArr.%Size()
	.for j=0:1:warnLen-1  d
	..s warnObj = warnArr.%Get(j)
	..s keyName = warnObj.keyname
	..Q:(cat'="")&&(keyName'[cat)
	..s warnItmsArr = warnObj.itms
	..s warnItmLen = warnItmsArr.%Size()
	..for k=0:1:warnItmLen-1  d
	...s warnItmObj = warnItmsArr.%Get(k)
	...s itmsArr = warnItmObj.itms
	...s itmsLen = itmsArr.%Size()
	...for l=0:1:itmsLen-1  d
	....s itmsObj = itmsArr.%Get(l)
	....s itmkeyName = itmsObj.keyname
	....s itmmsg = itmsObj.val
	....;i msg="" s msg = (l+1)_":"_itmmsg
	....;e  s msg = msg_"&"_(l+1)_":"_itmmsg
	....i msg="" s msg = itmmsg
	....e  s msg = msg_"&"_itmmsg
	Q msg
}

ClassMethod GetInParam(hisItem, exaParamObj)
{
	//取药品信息
	s drugArr = exaParamObj.%Get("Drug")
	s length = drugArr.%Size()
	s drugList = ""
	for k=0:1:length-1  d
	.s drugObj = drugArr.%Get(k)
	.s drugName = drugObj.item
	.q:drugName=""
	.Q:hisItem'=drugName
	.s onceDose = drugObj.OnceDose
	.s unit = drugObj.Unit
	.s formProp = drugObj.FormProp
	.s drugPreMet = drugObj.DrugPreMet
	.s drugFreq = drugObj.DrugFreq
	.i drugFreq="" s drugFreq=drugObj.DrugDrugFreq
	.s treatment = drugObj.Treatment
	.s seqNo = drugObj.SeqNo 
	.s drugList = drugName_"^"_onceDose_"^"_unit_"^"_formProp_"^"_drugPreMet_"^"_drugFreq_"^"_treatment
	Q drugList
}

/// w ##class(web.DHCCKBAuditResultExport).QueryAuditData(.TmpArr,66058,66058,"","")
ClassMethod QueryAuditDatanew(TmpArr, stDate, endDate, hosp, cat)
{
	b   //222
	k ParamArr
	k queTmpArr
	k itmTmpArr
	for date = stDate:1:endDate  d
	.s monId = ""
	.for  s monId = $o(^CKB.PDSS.MonMasterI("DatePass",date,"0",monId))  Q:monId=""  d
	..s monData = $g(^CKB.PDSS.MonMasterD(monId))
	..s exaParam = $lg(monData,9)	//入参
	..s exaParamObj = ##class(%DynamicArray).%FromJSON(exaParam)
	../*患者信息*/
	..s patName = exaParamObj.PatName
	..s:patName="" patName="门诊"
	..s episodeID = exaParamObj.EpisodeID
	..s patientID = $p($g(^PAADM(+episodeID)),"^",1)
	..s patNo = $p($g(^PAPER(+patientID,"PAT",1)),"^",1)  /// 登记号
	..s sex = exaParamObj.SexProp
	..s age = exaParamObj.AgeProp
	..s weight = exaParamObj.Weight
	..s patInfo = patName_"^"_sex_"^"_age_"^"_weight
	../*取过敏信息*/
	..s hisAllergyList = ""
	..s hisAllergyArr = exaParamObj.%Get("HisAllergy")
	..s lenaller = hisAllergyArr.%Size()
	..for i=0:1:lenaller-1  d
	...s allergyObj = hisAllergyArr.%Get(i)
	...s allergy = allergyObj.item
	...i hisAllergyList="" s hisAllergyList = allergy
	...e  s hisAllergyList = hisAllergyList_";"_allergy
	../*取诊断信息*/
	..s diagList = ""
	..s diagArr = exaParamObj.%Get("Disease")
	..s diagLen = diagArr.%Size()
	..for j=0:1:diagLen-1  d
	...s diagObj = diagArr.%Get(j)
	...s diag = diagObj.item
	...i diagList="" s diagList = diag
	...e  s diagList = diagList_";"_diag
	..s outParam = $lg(monData,10)	//结果
	..s hosp = $lg(monData,12)
	..s outParamObj = ##class(%DynamicArray).%FromJSON(outParam)
	..s itemsArr = outParamObj.items
	..s length = itemsArr.%Size()
	..for n=0:1:length-1  d
	...s itmsObj = itemsArr.%Get(n)
	...s libItem = itmsObj.libitem
	...s hisItem = itmsObj.item
	...s drugList = ..GetInParam(hisItem,exaParamObj)
	...s warnArr = itmsObj.warns
	...s warnLen = warnArr.%Size()
	...for k=0:1:warnLen-1  d
	....s warnObj = warnArr.%Get(k)
	....s keyName = warnObj.keyname
	....Q:(cat'="")&&(keyName'[cat)
	....s warnItmsArr = warnObj.itms
	....s warnItmLen = warnItmsArr.%Size()
	....for l=0:1:warnItmLen-1  d
	.....s warnItmObj = warnItmsArr.%Get(l)
	.....s itmsArr = warnItmObj.itms
	.....s ruleId = warnItmObj.ruleID
	.....s ruleId = $p(ruleId,$c(2),1)
	.....;b:hisItem="注射用醋酸西曲瑞克/思则凯[0.25mg ]"   //33
	.....s manLev = warnItmObj.manLev
	.....s manLevel = warnItmObj.manLevel
	.....Q:manLevel'="warn"
	.....s itmsLen = itmsArr.%Size()
	.....for m=0:1:itmsLen-1  d
	......s itmsObj = itmsArr.%Get(m)
	......s itmkeyName = itmsObj.keyname
	......s itmmsg = itmsObj.val
	......s itmmsg = $tr(itmmsg,",","，")
	......s itmmsg = $tr(itmmsg,$c(13),"")
	......s itmmsg = $tr(itmmsg,$c(10),"")
	......s itmmsg = $replace(itmmsg,"：",":")
	......s paramindex = hisItem_"^"_ruleId
	......;b:hisItem="注射用醋酸西曲瑞克/思则凯[0.25mg ]"   //33
	......s listData = patInfo_"^"_hisAllergyList_"^"_diagList_"^"_drugList_"^"_cat_"^"_itmkeyName_"^"_manLev_"^"_itmmsg _"^"_1
	......i $d(queTmpArr(hisItem,paramindex))  d
	.......;b:hisItem="培哚普利吲达帕胺片/百普乐[4:1.25mg*7片]"   //33  ///333
	.......s $p(queTmpArr(hisItem,paramindex),"^",18) = $p(queTmpArr(hisItem,paramindex),"^",18)+1
	......e  d
	.......s queTmpArr(hisItem,paramindex) = listData
	......i $d(itmTmpArr(hisItem))  d
	.......s itmTmpArr(hisItem) = itmTmpArr(hisItem)+1
	......e  d
	.......s itmTmpArr(hisItem) = 1
	
	b   //333
	s itmdrugId = ""
	for  s itmdrugId = $o(queTmpArr(itmdrugId))  Q:itmdrugId=""  d
	.s itmindex = ""
	.for  s itmindex = $o(queTmpArr(itmdrugId,itmindex))  Q:itmindex=""  d
	..s num = $p(queTmpArr(itmdrugId,itmindex),"^",18)
	..s ordindex = itmindex
	..s totnum = $g(itmTmpArr(itmdrugId))
	..s TmpArr(totnum,itmdrugId,num,ordindex) = queTmpArr(itmdrugId,itmindex)
	Q ""
}

}
