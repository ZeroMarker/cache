Import SQLUSER

/// Creator: 		qunianpeng
/// CreateDate: 	2020-12-24
/// Descript: 		临时问题处理类
Class web.DHCCKBTempDealProblem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		qunianpeng
/// Description:	使用字典id,查询规则中使用到该字典的药品和目录
/// CreatDate:		2020-12-24
/// Input： 		从拆分表中找到新增的规则，更新到161上使用 
/// Output：		
/// Table:			DHC_CKBRuleMaintain
/// w ##class(web.DHCCKBTempDealProblem).ExportNewRule()
ClassMethod ExportNewRule() As %String
{
	k ^DHCCKBTempDealProblem
	s count = 0
	s ruleMainID = "912021"  // 从912021开始遍历(161从此处开始新增)
	f  s ruleMainID = $o(^DHCCKBRULEMAINTAIN(ruleMainID))  q:ruleMainID=""  d
	.s rmCode = $p($g(^DHCCKBRULEMAINTAIN(ruleMainID)),"^",1)
	.s rmDesc = $p($g(^DHCCKBRULEMAINTAIN(ruleMainID)),"^",2)
	.s rmGroupNo = $p($g(^DHCCKBRULEMAINTAIN(ruleMainID)),"^",3)
	.s rmTemp = $p($g(^DHCCKBRULEMAINTAIN(ruleMainID)),"^",4)
	.s rmFlag = $p($g(^DHCCKBRULEMAINTAIN(ruleMainID)),"^",5)
	.s rmRuleDr = $p($g(^DHCCKBRULEMAINTAIN(ruleMainID)),"^",6)
	.s rmText = $p($g(^DHCCKBRULEMAINTAIN(ruleMainID)),"^",7)
	.s count = count + 1
	.s ^DHCCKBTempDealProblem(rmGroupNo,count)=$lb(rmCode,rmDesc,rmGroupNo,rmTemp,rmFlag,rmRuleDr,rmText)
	
	q count
}

/// Creator:		qunianpeng
/// Description:	导入从DHC_CKBRuleMaintain表中新增的数据
/// CreatDate:		2020-12-24
/// Input： 		从拆分表中找到新增的规则，更新到161上使用 
/// Output：		
/// Table:			DHC_CKBRuleMaintain
/// w ##class(web.DHCCKBTempDealProblem).ImportNewRuleFromMainTain()
ClassMethod ImportNewRuleFromMainTain() As %String
{
	
	TS
	s ret = 0
	s index = ""
	f  s index = $o(^DHCCKBTempDealProblem(index))  q:(index="")||(ret'=0)  d
	.s groupID = ##class(web.DHCCKBCommonUtil).NewPid()
	.s drugInfo = ""
	.s count = ""
	.f  s count = $o(^DHCCKBTempDealProblem(index,count))  q:(count="")||(ret'=0)  d
	..s listData = $g(^DHCCKBTempDealProblem(index,count))
	..q:listData=""
	..s rmCode = $listget(listData,1)
	..s rmDesc = $listget(listData,2)
	..s rmTemp = $listget(listData,4)
	..s rmFlag = $listget(listData,5) //1 提交 0 保存 3删除
	..s rmRuleDr = $listget(listData,6)
	..s rmText = $listget(listData,7)
	..q:rmFlag=3 // 删除的不导入
	..s rmTempName = $case(+rmTemp'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+rmTemp)),3),:"")
	..i rmCode = 81842	d //  81842, 'ChineseDrugNameProp', '中成药名称'
	...s $list(drugInfo,2)=rmDesc	
	...s $list(drugInfo,4)="中成药"
	...//s drugName = rmDesc
	...//s drugType = "中成药"
	..i rmCode = 81224	d //  81224, 'MedDrugNameProp', '西药名称'
	...s $list(drugInfo,2)=rmDesc
	...s $list(drugInfo,4)="西药"
	..
	..s $list(drugInfo,1)=groupID
	..s $list(drugInfo,3)=rmTempName
	..s ret = ..SaveRuleMainTain(groupID,listData)
	.q:ret'=0
	.q:drugInfo=""
	.s $list(drugInfo,*+1)=index
	.d ..MarkImportDrug(drugInfo)
	.
	
	i ret'=0 tro
	e  tc 
	
	w ##Class(websys.Query).ToExcel("拆分表新增规则"_$h,"web.DHCCKBTempDealProblem","ExportImportDrug")
	
	q ret
}

/// Creator:		qunianpeng
/// Description:	保存数据
/// CreatDate:		2020-12-24
/// Input： 		
/// Output：		0 成功 非0 失败	
/// Table:			DHC_CKBRuleMaintain
/// w ##class(web.DHCCKBTempDealProblem).SaveRuleMainTain()
ClassMethod SaveRuleMainTain(groupID, listData) As %String
{
	n (groupID,listData)
	
	//s rmCode = $listget(listData,1)
	//s rmDesc = $listget(listData,2)
	//s rmTemp = $listget(listData,4)
	//s rmFlag = $listget(listData,5) //1 提交 0 保存 3删除
	//s rmRuleDr = $listget(listData,6)
	//s rmText = $listget(listData,7)
	
	s obj=##class(User.DHCCKBRuleMaintain).%New()	
	s obj.RMCode=$listget(listData,1)
	s obj.RMDesc=$listget(listData,2)
	s obj.RMGroupNo=groupID
	s obj.RMTemp=$listget(listData,4)
	s obj.RMFlag=0
	s obj.RMText=$$ALPHAUP^SSUTIL4($listget(listData,2))
	s sc=obj.%Save()
	s code=0
	i $SYSTEM.Status.IsError(sc) d
	.s code=$SYSTEM.Status.GetErrorCodes(sc)
	
	q code
}

/// Creator:		qunianpeng
/// Description:	记录导入规则的药品
/// CreatDate:		2020-12-24
/// Input： 		
/// Output：		
/// Table:			DHC_CKBRuleMaintain
/// w ##class(web.DHCCKBTempDealProblem).MarkImportDrug()
ClassMethod MarkImportDrug(drugInfo) As %String
{
	n (drugInfo)
	
	s pid = $list(drugInfo,1)
	s ^TMP("DHCCKB","web.DHCCKBTempDealProblem","MarkImportDrug",pid)=drugInfo
}

/// Creator:      qunianpeng
/// CreatDate:    2020-12-24
/// Description:  将拆分表生成的规则进行记录导出(没有提交到规则表中)
/// Input:		  
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCCKBTempDealProblem","ExportImportDrug")
/// w ##Class(websys.Query).ToExcel("CKB_Excel","web.DHCCKBTempDealProblem","ExportImportDrug")
Query ExportImportDrug() As websys.Query(ROWSPEC = "groupID:%String:规则组号,drugName:%String:药品名称,tempName:%String:模板名称,drugType:%String:药品类型,index:%String:序号")
{
}

ClassMethod ExportImportDrugExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)

	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	Set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBTempDealProblem","MarkImportDrug",index)) quit:index=""  do
	.set listData=$get(^TMP("DHCCKB","web.DHCCKBTempDealProblem","MarkImportDrug",index))
	.set ^CacheTemp(repid,ind)=listData
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
