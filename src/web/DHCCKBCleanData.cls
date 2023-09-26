/// Description:	清除数据方法
/// Creator:		QuNianpeng 
/// CreateDate:		2018-01-09	
Class web.DHCCKBCleanData Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	清除基础数据
/// Creator:		QuNianpeng 
/// CreateDate:		2018-01-09	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBCleanData).CleanBaseData()
ClassMethod CleanBaseData() As %String
{
	
	kill ^DHCCKBCD			// 实体字典表
	kill ^mdata("DHCCKBCD")
	
	kill ^DHCCKBCC			// 数据对照表
	kill ^mdata("DHCCKBCC")
	
	kill ^DHCCKBDLA			// 实体属性关联表
	kill ^mdata("DHCCKBDLA")
	
	q "成功"
}

/// Description:	清除业务数据
/// Creator:		QuNianpeng 
/// CreateDate:		2018-01-09	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBCleanData).CleanBusinessData()
ClassMethod CleanBusinessData() As %String
{
	kill ^TMP("DHCCKB","web.DHCCKBExport","ExportDataErrMsg")
	kill ^TMP("DHCCKB","web.DHCCKBComImport","TmpImportData")
	
	kill ^DHCCKBRULE		// 规则表 DHC_CKBRule
	kill ^mdata("DHCCKBRULE")
	
	kill ^DHCCKBRD			// 规则数据表 DHC_CKBRuleData
	kill ^mdata("DHCCKBRD")
	
	kill ^DHCCKBRDITM		// 规则数据子表 DHC_CKBRuleDataItm  //无
	kill ^mdata("DHCCKBRDITM")
	
	kill ^DHCCKBRULEDIC		// 规则实例表 DHC_CKBRuleDic
	kill ^mdata("DHCCKBRULEDIC")
	
	kill ^DHCCKBRULEDATALOG	// 规则数据日志表 DHC_CKBRuleDataLog
	kill ^mdata("DHCCKBRULEDATALOG") 
	
	kill ^DHCCKBRULELOG		// 规则日志表 DHC_CKBRuleLog
	kill ^mdata("DHCCKBRULELOG")	
	
	kill ^DHCCKBRULENODE	// 规则节点表 DHC_CKBRuleNode
	kill ^mdata("DHCCKBRULENODE") 
		
	kill ^DHCCKBRULEACTION	// 规则关系表 DHC_CKBRuleAction
	kill ^mdata("DHCCKBRULEACTION")
	
	kill ^DHCCKBRULECOMPLEXARITH // 运算符表达式表 DHC_CKBRuleComplexArith
	kill ^mdata("DHCCKBRULECOMPLEXARITH")
	
	kill ^DHCCKBCONLOG 		// 配置日志表 DHC_CKBConfigLog //无
	kill ^mdata("DHCCKBCONLOG")
	
	kill ^DHCCKBDLG	 // 字典日志表
	kill ^mdata("DHCCKBDLG")
	
	kill ^DHCCKBEXD // 外部代码表
	kill ^mdata("DHCCKBEXD")

 	kill ^DHCCKBRULEDETAIL // User.DHCCKBRuleDetail

	kill ^DHCCKBRULEMAINTAIN // 拆分规则中间表 
	kill ^mdata("DHCCKBRULEMAINTAIN")

	kill ^DHCCKBTEM 		// 模板表 DHCCKBTemplate.cls
	kill ^mdata("DHCCKBTEMPLATE")
	
	kill ^DHCCKBRULETEXT	// 分词记录表	User.DHCCKBRuleText
	kill ^mdata("DHCCKBRULETEXT")
	
 	kill ^DHCCKBTCT 		// 审查模板表	User.DHCCKBTestCaseTemp
	kill ^mdata("DHCCKBTESTCASETEMP")
	
	//kill ^DHCCKBMFL	 // DHCCKBMonFunList.cls  // 2020/12/13 规则表给项目更新时 记住不能清空
	//kill ^mdata("DHCCKBMONFUNLIST")			
	
	//kill ^DHCCKBMM	 //	DHCCKBMonMaster.cls
	//kill ^mdata("DHCCKBMONMASTER")	
	
	//kill ^DHCCKBMQL		//	DHCCKBMonQueList.cls	
	//kill ^mdata("DHCCKBMONQUELIST")
	
	//kill ^DHCCKBMRL //	DHCCKBMonRuleList.cls
	//kill ^mdata("DHCCKBMONRULELIST")	
	
	kill ^DHCCKBDLAEXT
	kill ^mdata("DHCCKBDLAEXT") // ^DHCCKBDLAEXT 外部属性表 User.DHCCKBDicExtLinkAttr 2020/12/123 增加以下
 
 	//kill ^DHCCKBFB	// ^DHCCKBFB 反馈表 User.DHCCKBFeedBack
 	//kill ^mdata("DHCCKBFB")
 
 	kill ^DHCCKBRCL // ^DHCCKBRCL 规则赋值表? User.DHCCKBRuleCopyLog
 	
 	kill ^User.DHCCKBDrugLibaryRefD  // 药品目录关系表 User.DHCCKBDrugLibaryRef
	kill ^User.DHCCKBDrugLibaryRefI 
	
	kill ^User.DHCCKBDiagnosisRelationD // 疾病关系关联表 User.DHCCKBDiagnosisRelation
	kill ^User.DHCCKBDiagnosisRelationI 
 
 
	q "成功"
}

/// Description:	清除产品业务数据 （global改造后）
/// Creator:		QuNianpeng 
/// CreateDate:		2022-12-20	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBCleanData).CleanCKBBusinessData()
ClassMethod CleanCKBBusinessData() As %String
{
	k ^CKB.PDSS.ComContrastD
	k ^CKB.PDSS.ComContrastI
	
	k ^CKB.PDSS.ComDictionExtD
	k ^CKB.PDSS.ComDictionExt
	
	k ^CKB.PDSS.DicDataLogD
	k ^CKB.PDSS.DicDataLogI
	
	k ^CKB.PDSS.DicExtLinkAttrD
	k ^CKB.PDSS.DicExtLinkAttrI
	
	k ^CKB.PDSS.DicLogD
	k ^CKB.PDSS.DicLogI
	
	k ^CKB.PDSS.DrugSearchLogD
	k ^CKB.PDSS.DrugSearchLogI
	
	k ^CKB.PDSS.ExtDictionD
	k ^CKB.PDSS.ExtDictionI
	
	k ^CKB.PDSS.FeedBackD
	k ^CKB.PDSS.FeedBackI
		
	k ^CKB.PDSS.KnowUpdateLogD
	k ^CKB.PDSS.KnowUpdateLogI
	
	k ^CKB.PDSS.MedicationOrderD
	k ^CKB.PDSS.MedicationOrderI
	
	k ^CKB.PDSS.MonFunListD
	k ^CKB.PDSS.MonFunListI
	
	k ^CKB.PDSS.MonMasterD
	k ^CKB.PDSS.MonMasterI
	
	k ^CKB.PDSS.MonQueListD
	k ^CKB.PDSS.MonQueListI
	
	k ^CKB.PDSS.MonRuleListD
	k ^CKB.PDSS.MonRuleListI
	
	k ^CKB.PDSS.PosLifeCycleD
	k ^CKB.PDSS.PosLifeCycleI
	
	k ^CKB.PDSS.RuleLogD
	k ^CKB.PDSS.RuleLogI
	
	k ^CKB.PDSS.RuleDataLogD
	k ^CKB.PDSS.RuleDataLogI
	
	k ^CKB.PDSS.RuleCopyLogD
	k ^CKB.PDSS.RuleCopyLogI
	
	k ^CKB.PDSS.UserAuthorityD
	k ^CKB.PDSS.UserAuthorityI
	
	k ^CKB.PDSS.RuleActionD
	k ^CKB.PDSS.RuleActionI
		
	k ^CKB.PDSS.RuleComplexArithD
	k ^CKB.PDSS.RuleComplexArithI
	
	k ^CKB.PDSS.RuleDetailD
	k ^CKB.PDSS.RuleDetailI
	
	k ^CKB.PDSS.RuleTextD
	k ^CKB.PDSS.RuleTextI
	
	q "清除产品业务数据成功"
}

/// Description:	清除基础数据（global改造后）
/// Creator:		QuNianpeng 
/// CreateDate:		2023-02-17	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBCleanData).CleanCKBBaseData()
ClassMethod CleanCKBBaseData() As %String
{
	k ^CT.CKB.PDSS.CommonDictionD
	k ^CT.CKB.PDSS.CommonDictionI
		
	k ^CT.CKB.PDSS.DicLinkAttrD
	k ^CT.CKB.PDSS.DicLinkAttrI
	
	k ^CT.CKB.PDSS.DrugLibaryRefD
	k ^CT.CKB.PDSS.DrugLibaryRefI
	
	k ^CT.CKB.PDSS.RuleD
	k ^CT.CKB.PDSS.RuleI
	
	k ^CT.CKB.PDSS.RuleDataD
	k ^CT.CKB.PDSS.RuleDataI
	
	k ^CT.CKB.PDSS.RuleDicD
	k ^CT.CKB.PDSS.RuleDicI
	
	k ^CT.CKB.PDSS.RuleNodeD
	k ^CT.CKB.PDSS.RuleNodeI
	
	k ^CT.CKB.PDSS.SourcePoolD
	k ^CT.CKB.PDSS.SourcePoolI

	q "清除产品基础数据成功"
}

/// Description:	清除产品配置数据（global改造后）
/// Creator:		QuNianpeng 
/// CreateDate:		2023-02-17	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBCleanData).CleanCKBConfigData()
ClassMethod CleanCKBConfigData() As %String
{
	K ^CF.CKB.PDSS.DiagRelationD
	K ^CF.CKB.PDSS.DiagRelationI
	
	//K ^CF.CKB.PDSS.GenIndexD
	//K ^CF.CKB.PDSS.GenIndexI
		
	K ^CF.CKB.PDSS.IgnoreDataPoolD
	K ^CF.CKB.PDSS.IgnoreDataPoolI
	
	K ^CF.CKB.PDSS.IgnoreManageD
	K ^CF.CKB.PDSS.IgnoreManageI
	
	//K ^CF.CKB.PDSS.PluginTempD
	//K ^CF.CKB.PDSS.PluginTempI
	
	K ^CF.CKB.PDSS.PreDataPoolD
	K ^CF.CKB.PDSS.PreDataPoolI
	
	K ^CF.CKB.PDSS.SourcePriorityD
	K ^CF.CKB.PDSS.SourcePriorityI
	
	K ^CF.CKB.PDSS.GrantAuthD
	K ^CF.CKB.PDSS.GrantAuthI

	q "清除产品基础数据成功"
}

/// Description:	清除所有改造前的DHCCKB表数据
/// Creator:		QuNianpeng 
/// CreateDate:		2023-02-20	
/// Input:			
/// return:			0 成功 非0 失败
/// other:			w ##class(web.DHCCKBCleanData).CleanBeforeCKBData()
ClassMethod CleanBeforeCKBData() As %String
{
	kill ^User.DHCCKBDiagnosisRelationD
	kill ^User.DHCCKBDiagnosisRelationI
	
	kill ^DHCCKBDLA
	
	kill ^User.DHCCKBDrugLibaryRefD
	kill ^User.DHCCKBDrugLibaryRefI
	
	kill ^User.DHCCKBGenNIndexD
	kill ^User.DHCCKBGenNIndexI
	
	kill ^User.DHCCKBGrantAuthD
	kill ^User.DHCCKBGrantAuthI
	
	kill ^User.DHCCKBIgnoreDataPoolD
	kill ^User.DHCCKBIgnoreDataPoolI
	
	kill ^DHCCKBIGMAN
	
	kill ^DHCCKBPTEMP
	
	kill ^User.DHCCKBPreconditionDataPoolD
	
	kill ^User.DHCCKBReasTempD
	
	kill ^DHCCKBRULE
	
	kill ^DHCCKBRD
	
	kill ^DHCCKBRULEDIC
	
	kill ^DHCCKBRULENODE
	
	kill ^User.DHCCKBSourcePoolD
	
	kill ^User.DHCCKBSourcePriorityD	
	kill ^User.DHCCKBSourcePriorityI
	
	kill ^DHCCKBCD
}

}
