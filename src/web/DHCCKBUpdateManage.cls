Import SQLUser

/// Description:	安全用药更新管理类(知识、规则、基础数据)
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05
Class web.DHCCKBUpdateManage Extends %RegisteredObject [ ClassType = "", Not Final, Not ProcedureBlock ]
{

/// Description:	导出规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			开始日期,结束日期,医院描述(药品所属),药品串,字典id
/// return:			
/// other:			w ##class(web.DHCCKBUpdateManage).Export("","","11871","安徽蚌埠第四人民医院","rule","","105","")
/// w ##class(web.DHCCKBUpdateManage).Export("","","11871","安徽蚌埠第四人民医院","know","","105","")
/// w ##class(web.DHCCKBUpdateManage).Export("","","11871","安徽蚌埠第四人民医院","rule","","81790","")
/// w ##class(web.DHCCKBUpdateManage).Export("2022-11-01","2022-11-28","12017","河北保定容城中医","know","","","")
/// w ##class(web.DHCCKBUpdateManage).Export("2022-06-24","2022-12-09","11871","南京医科大学第四附属医院","rule","","81790","")
ClassMethod Export(stDate, endDate, userId, hosp, extype, drugStr = "", dataId = "", nodeList = "") As %String
{
	n (stDate, endDate, userId, hosp, extype, drugStr, dataId,nodeList)
	s ^temptest("s") = $lb(stDate, endDate, userId, hosp, extype, drugStr, dataId,nodeList)
	s ret = 0
	if (extype = "rule") d
	.s ret = ..ExportRule(stDate, endDate, userId, hosp, drugStr,dataId,nodeList)
	else  if (extype = "know") d
	.s ret = ..ExportKnow(stDate, endDate, userId, hosp, drugStr, dataId)
	else  if (extype = "all")  d
	.s path1 = ..ExportRule(stDate, endDate, userId, hosp, drugStr,dataId)
	.s path2 = ..ExportKnow(stDate, endDate, userId, hosp, drugStr, dataId)
	.s ret = path1_"</br>"_path2
	q ret
}

/// Description:	导出规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			开始日期,结束日期,医院描述,药品串,字典id
/// return:			
/// other:			w ##class(web.DHCCKBUpdateManage).ExportRule()
ClassMethod ExportRule(stDate, endDate, userId, hosp, drugStr = "", dataId = "", nodeList = "") As %String
{
	n (stDate, endDate, userId, hosp, drugStr, dataId,nodeList)
	s path = ##class(web.DHCCKBExportRuleManage).ExportRule(stDate, endDate, userId, hosp, drugStr,dataId,nodeList)
	q path
}

/// Description:	导入规则
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			global name, 含后缀的路径
/// return:			
/// other:			w ##class(web.DHCCKBUpdateManage).ImportRule("TMPExportDrugRule","D:\dthealth\app\dthis\web\temp\global\[rule],65938,55552.gof","11863^8^1^291^2","127.0.0.1")
ClassMethod ImportRule(global, path, loginInfo, clientIP) As %String
{
	n (global, path, loginInfo, clientIP)

	s ret = ##class(web.DHCCKBImportRuleManage).ImportRule(global, path, loginInfo, clientIP)

	q ret
}

/// Description:	保存导入的日志记录
/// Creator:		QuNianpeng 
/// CreateDate:		2021-06-05	
/// Input:			药品id_"^"_目录id,用户信息,复制规则id
/// return:			
/// other:			w ##class(web.DHCCKBUpdateManage).SaveUpdateLog("150^72",13923,"13923^1^1^339^2",237329)
ClassMethod SaveUpdateLog(stDate, endDate, userId, path, type, status, hosp, version) As %String
{
	n (stDate, endDate, userId, path, type, status, hosp, version)
	s logObj=##class(CKB.PDSS.KnowUpdateLog).%New()
	s logObj.KULFromDate = stDate
	s logObj.KULToDate = endDate
	s userName = $p($g(^SSU("SSUSR",+userId)),"^",2)
	s logObj.KULUserName = userName
	s logObj.KULUpDate = +$h
	s logObj.KULUpTime = $p($h,",",2)
	s logObj.KULPath = path
	s logObj.KULType = type	// rule,know,base
	s logObj.KULStatus = status  // in,out
	s logObj.KULHosp = hosp
	s logObj.KULVersion = version
	
	s sc=logObj.%Save()
	q:$SYSTEM.Status.IsError(sc) -10
	q logObj.%Id()
}

/// Description:	导出知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-10	
/// Input:			
/// return:			
/// other:			w ##class(web.DHCCKBUpdateManage).ExportKnow("","",11863,"东华标准版数字化医院[总院]","150","")
ClassMethod ExportKnow(stDate, endDate, userId, hosp, drugStr = "", dataId = "") As %String
{
	n (stDate, endDate, userId, hosp, drugStr, dataId)
	s path = ##class(web.DHCCKBExportKnowManage).ExportKnow(stDate, endDate, userId, hosp, drugStr,dataId)
	q path
}

/// Description:	导入知识
/// Creator:		QuNianpeng 
/// CreateDate:		2021-07-10		
/// Input:			global name, 含后缀的路径
/// return:			
/// other:			w ##class(web.DHCCKBUpdateManage).ImportKnow("TMPExportDrugKnow","D:\dthealth\app\dthis\web\temp\global\[know],65938,55643.gof","11863^8^1^291^2","127.0.0.1")
ClassMethod ImportKnow(global, path, loginInfo, clientIP) As %String
{
	n (global, path, loginInfo, clientIP)

	s ret = ##class(web.DHCCKBImportKnowManage).ImportKnow(global, path, loginInfo, clientIP)

	q ret
}

/// Description:	批量操作导出药品规则、说明书
/// Creator:		QuNianpeng 
/// CreateDate:		2022-07-27	
/// Input:			路径,药品类型(DrugData:西药,ChineseDrugData:中成药),开始日期,结束日期,医院描述(药品所属),药品串,字典id
/// return:			(如果有药品串,则日期为操作日期即可)
/// other:			w ##class(web.DHCCKBUpdateManage).ExportBatch("D:\temp\南溪山药品数据更新列表-西药.txt","DrugData","2022-08-02","2022-08-02",1,"广西壮族自治区南溪山医院","all")
/// w ##class(web.DHCCKBUpdateManage).ExportBatch("D:\temp\南溪山更新数据-中成药.txt","ChineseDrugData","2022-08-02","2022-08-02",1,"广西壮族自治区南溪山医院","all")
ClassMethod ExportBatch(filepath, drugType, stDate, endDate, userId, hosp, extype) As %String
{
	
	n (filepath,drugType,stDate, endDate, userId, hosp, extype)
	
	s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))
	q:+hospId=0 -1
	
	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	k TmpArr	
	s drugStr = ""
	s drugTypeId = ##class(web.DHCCKBCommon).GetDicIdByCode(drugType)
	
	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s data=$tr(onerow,$c(9),del)
	.s drugCode = $p(data,"^",1)
	.s drugName = $p(data,"^",2)
	.q:0=##class(web.DHCCKBComContrast).CheckFlag(drugCode,drugName,hospId)
	.s libstr =  ##class(web.DHCCKBComContrast).GetSysConst(drugCode,drugName,drugTypeId)
	.q:libstr=""
	.s libCode = $p(libstr,"^",1)
	.s drugId = ##class(web.DHCCKBCommon).GetDicIdByCode(libCode,drugTypeId)
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(drugId))
	.q:+drugId=0
	.i $lf(drugStr,drugId)=0 s $list(drugStr,*+1) = drugId
	.s hCount=hCount+1
	.s TmpArr(hCount) = data
	
	c filepath 
	s drugStr = $lts(drugStr,"^")
	s dataId="",nodeList=""
	s ret = 0
	if (extype = "rule") d
	.s ret = ..ExportRule(stDate, endDate, userId, hosp, drugStr,dataId,nodeList)
	else  if (extype = "know") d
	.s ret = ..ExportKnow(stDate, endDate, userId, hosp, drugStr, dataId)
	else  if (extype = "all")  d
	.s path1 = ..ExportRule(stDate, endDate, userId, hosp, drugStr,dataId)
	.s path2 = ..ExportKnow(stDate, endDate, userId, hosp, drugStr, dataId)
	.s ret = path1_"</br>"_path2
	q ret
}

/// Description:	批量操作导出药品规则、说明书(根据安全用药药品类型)
/// Creator:		QuNianpeng 
/// CreateDate:		2022-08-02	
/// Input:			路径,药品类型(DrugData:西药,ChineseDrugData:中成药),开始日期,结束日期,医院描述(药品所属),药品串,字典id
/// return:			(如果有药品串,则日期为操作日期即可)
/// other:			w ##class(web.DHCCKBUpdateManage).ExportBatchBySysName("D:\temp\南溪山错误规则药品.txt","2022-08-02","2022-08-02",1,"广西壮族自治区南溪山医院","all")
ClassMethod ExportBatchBySysName(filepath, stDate, endDate, userId, hosp, extype) As %String
{
	
	n (filepath,stDate, endDate, userId, hosp, extype)
	
	
	s hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))
	q:+hospId=0 -1

	S hCount=0
	q:filepath="" "-2"
	s del="^"
	o filepath:"RS":2
	u filepath
	
	k TmpArr	
	s drugStr = ""

	s end=0
	d $ZU(68,40,1)
	f  d  q:end'=0
	.R onerow
	.s end=$ZEOF
	.q:end'=0
	.q:onerow=""
	.s data=$tr(onerow,$c(9),del)
	.s drugName = $p(data,"^",1)
	.s drugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(drugName)
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(drugId))
	.q:+drugId=0
	.s drugTypeId = $lg($g(^CT.CKB.PDSS.CommonDictionD(+drugId)),4)
	.i $lf(drugStr,drugId)=0 s $list(drugStr,*+1) = drugId
	.s hCount=hCount+1
	.s TmpArr(hCount) = data
	
	c filepath
	k TmpArr
	s count = 0,index= ""
	f i=1:1:$ll(drugStr)  d
	.s count =count + 1
	.s drug=$lg(drugStr,i)
	.s TmpArr(drug)=""

	s count = 0,index= ""
	f  s index = $o(TmpArr(index)) q:index=""  d
	.s count =count + 1
	.w count_":"_index,!
	q 1	
	
	s drugStr = $lts(drugStr,"^")
	s dataId="",nodeList=""
	s ret = 0
	if (extype = "rule") d
	.s ret = ..ExportRule(stDate, endDate, userId, hosp, drugStr,dataId,nodeList)
	else  if (extype = "know") d
	.s ret = ..ExportKnow(stDate, endDate, userId, hosp, drugStr, dataId)
	else  if (extype = "all")  d
	.s path1 = ..ExportRule(stDate, endDate, userId, hosp, drugStr,dataId)
	.s path2 = ..ExportKnow(stDate, endDate, userId, hosp, drugStr, dataId)
	.s ret = path1_"</br>"_path2
	q ret
}

}
